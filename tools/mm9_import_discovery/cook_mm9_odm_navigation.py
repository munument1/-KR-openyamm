#!/usr/bin/env python3
"""Cook compact MM9 BModel-world navigation and render sidecars from generated ODM assets."""

from __future__ import annotations

import argparse
import json
import struct
from pathlib import Path
from typing import Any

import yaml

from transcode_mm9_dat_to_odm import (
    BMODEL_FACE_FLAGS_SIZE,
    BMODEL_FACE_SIZE,
    BMODEL_HEADER_SIZE,
    BMODEL_TEXTURE_NAME_SIZE,
    CMAP1_SIZE,
    CMAP2_SIZE,
    TERRAIN_MAP_SIZE,
    DatWorld,
    OdmBModel,
    OdmFace,
    OdmVertex,
    WorldInfo,
    build_navigation_bytes,
    build_render_data_bytes,
    write_navigation_metadata,
    write_render_data_metadata,
)


ODM_PREFIX_SIZE = 0xB4 + TERRAIN_MAP_SIZE * 3 + 4 + CMAP1_SIZE + CMAP2_SIZE


def read_i32(data: bytes, offset: int) -> int:
    return struct.unpack_from("<i", data, offset)[0]


def read_u16(data: bytes, offset: int) -> int:
    return struct.unpack_from("<H", data, offset)[0]


def read_i16(data: bytes, offset: int) -> int:
    return struct.unpack_from("<h", data, offset)[0]


def read_fixed_string(data: bytes, offset: int, size: int) -> str:
    return data[offset:offset + size].split(b"\0", 1)[0].decode("ascii", errors="replace")


def source_metadata_maps(
    path: Path,
) -> tuple[dict[int, dict[str, Any]], dict[tuple[int, int], dict[str, Any]]]:
    bmodels: dict[int, dict[str, Any]] = {}
    faces: dict[tuple[int, int], dict[str, Any]] = {}
    section = ""
    entry: dict[str, Any] = {}

    def scalar(value: str) -> Any:
        value = value.strip()
        if value.startswith('"'):
            return json.loads(value)
        try:
            return int(value)
        except ValueError:
            return value

    def commit() -> None:
        if section == "bmodels" and "bmodel_index" in entry:
            bmodels[int(entry["bmodel_index"])] = dict(entry)
        elif section == "faces" and {"bmodel_index", "face_index", "collision_role"} <= entry.keys():
            faces[(int(entry["bmodel_index"]), int(entry["face_index"]))] = dict(entry)

    for raw_line in path.open(encoding="utf-8"):
        line = raw_line.rstrip("\n")
        if line == "bmodels:":
            commit()
            entry = {}
            section = "bmodels"
            continue
        if line == "bmodel_faces:":
            commit()
            entry = {}
            section = ""
            continue
        if line == "  source_faces:":
            section = "faces"
            continue
        expected_prefix = "  - " if section == "bmodels" else "    - "
        continuation_prefix = "    " if section == "bmodels" else "      "
        if section and line.startswith(expected_prefix):
            commit()
            entry = {}
            content = line[len(expected_prefix):]
        elif section and line.startswith(continuation_prefix):
            content = line[len(continuation_prefix):]
        else:
            continue
        if ":" not in content:
            continue
        key, value = content.split(":", 1)
        if key in {
            "bmodel_index",
            "face_index",
            "source_model_index",
            "source_model_name",
            "world_info_flags",
            "collision_role",
            "source_surface_flags",
        }:
            entry[key] = scalar(value)

    commit()
    return bmodels, faces


def parse_generated_odm(odm_bytes: bytes, metadata_path: Path) -> list[OdmBModel]:
    if len(odm_bytes) < ODM_PREFIX_SIZE + 4:
        raise ValueError("ODM is truncated before BModel count")

    bmodel_metadata, face_metadata = source_metadata_maps(metadata_path)
    bmodel_count = read_i32(odm_bytes, ODM_PREFIX_SIZE)
    if bmodel_count < 0:
        raise ValueError("ODM has a negative BModel count")
    header_offset = ODM_PREFIX_SIZE + 4
    body_offset = header_offset + bmodel_count * BMODEL_HEADER_SIZE
    headers: list[tuple[str, int, int, int]] = []

    for bmodel_index in range(bmodel_count):
        offset = header_offset + bmodel_index * BMODEL_HEADER_SIZE
        if offset + BMODEL_HEADER_SIZE > len(odm_bytes):
            raise ValueError("ODM is truncated in BModel headers")
        name = read_fixed_string(odm_bytes, offset, 0x20)
        vertex_count = read_i32(odm_bytes, offset + 0x44)
        face_count = read_i32(odm_bytes, offset + 0x4C)
        bsp_node_count = read_i32(odm_bytes, offset + 0x5C)
        if vertex_count < 0 or face_count < 0 or bsp_node_count < 0:
            raise ValueError("ODM has negative BModel geometry counts")
        headers.append((name, vertex_count, face_count, bsp_node_count))

    result: list[OdmBModel] = []
    for bmodel_index, (name, vertex_count, face_count, bsp_node_count) in enumerate(headers):
        source = bmodel_metadata.get(bmodel_index, {})
        bmodel = OdmBModel(
            name=name,
            source_model_index=int(source.get("source_model_index", bmodel_index)),
            source_model_name=str(source.get("source_model_name", name)),
            source_world_info_flags=int(source.get("world_info_flags", 0)),
        )

        vertex_bytes = vertex_count * 12
        face_bytes = face_count * BMODEL_FACE_SIZE
        trailer_bytes = (
            face_count * (BMODEL_FACE_FLAGS_SIZE + BMODEL_TEXTURE_NAME_SIZE)
            + bsp_node_count * 8
        )
        if body_offset + vertex_bytes + face_bytes + trailer_bytes > len(odm_bytes):
            raise ValueError("ODM is truncated in BModel geometry")

        for vertex_index in range(vertex_count):
            offset = body_offset + vertex_index * 12
            bmodel.vertices.append(OdmVertex(
                read_i32(odm_bytes, offset),
                read_i32(odm_bytes, offset + 4),
                read_i32(odm_bytes, offset + 8),
            ))
        body_offset += vertex_bytes

        for face_index in range(face_count):
            offset = body_offset + face_index * BMODEL_FACE_SIZE
            vertex_index_count = odm_bytes[offset + 0x12E]
            vertex_indices = [read_u16(odm_bytes, offset + 0x20 + index * 2) for index in range(vertex_index_count)]
            texture_us = [read_i16(odm_bytes, offset + 0x48 + index * 2) for index in range(vertex_index_count)]
            texture_vs = [read_i16(odm_bytes, offset + 0x70 + index * 2) for index in range(vertex_index_count)]
            bmodel.faces.append(OdmFace(
                vertex_indices=vertex_indices,
                texture_us=texture_us,
                texture_vs=texture_vs,
                texture_alias="",
                bitmap_index=read_i16(odm_bytes, offset + 0x110),
                polygon_type=odm_bytes[offset + 0x12F],
                attributes=read_i32(odm_bytes, offset + 0x1C),
                plane_normal=(
                    read_i32(odm_bytes, offset),
                    read_i32(odm_bytes, offset + 4),
                    read_i32(odm_bytes, offset + 8),
                ),
                plane_distance=read_i32(odm_bytes, offset + 0x0C),
                reserved=read_u16(odm_bytes, offset + 0x128),
            ))
            metadata_key = (bmodel_index, face_index)
            if metadata_key not in face_metadata:
                raise ValueError(f"source metadata is missing BModel face {metadata_key}")
            metadata = face_metadata[metadata_key]
            bmodel.source_collision_role_for_face.append(str(metadata["collision_role"]))
            bmodel.source_surface_flags_for_face.append(int(metadata.get("source_surface_flags", 0)))

        texture_name_offset = body_offset + face_bytes + face_count * BMODEL_FACE_FLAGS_SIZE
        for face_index in range(face_count):
            bmodel.faces[face_index].texture_alias = read_fixed_string(
                odm_bytes,
                texture_name_offset + face_index * BMODEL_TEXTURE_NAME_SIZE,
                BMODEL_TEXTURE_NAME_SIZE,
            )

        body_offset += face_bytes + trailer_bytes
        result.append(bmodel)

    return result


def mechanism_map(scene: dict[str, Any]) -> dict[int, int]:
    result: dict[int, int] = {}
    for mechanism in scene.get("mechanisms", []):
        binding = mechanism.get("binding", {})
        motion = mechanism.get("motion", {})
        if (
            motion.get("unsupported") is True
            or not ("linear" in motion or "rotation" in motion)
            or binding.get("target_kind") != "odm_bmodel"
            or "bmodel_index" not in binding
        ):
            continue
        result.setdefault(int(binding["bmodel_index"]), int(mechanism["mechanism_id"]))
    return result


def dummy_dat_world() -> DatWorld:
    return DatWorld(
        path=Path("navigation_sidecar.dat"),
        version=66,
        object_data_pos=0,
        render_data_pos=0,
        world_model_pos=0,
        world_info=WorldInfo("", 0.0, (0.0, 0.0, 0.0), (0.0, 0.0, 0.0)),
        world_models=[],
        objects=[],
    )


def cook_map(odm_path: Path) -> dict[str, Any]:
    metadata_path = odm_path.with_suffix(".mm9.yml")
    scene_path = odm_path.with_suffix(".scene.yml")
    if not metadata_path.is_file() or not scene_path.is_file():
        raise ValueError(f"missing generated metadata or scene for {odm_path.name}")

    odm_bytes = odm_path.read_bytes()
    scene = yaml.safe_load(scene_path.read_text(encoding="utf-8"))
    if scene.get("scene_profile") != "bmodel_world":
        raise ValueError(f"{scene_path.name} is not a bmodel_world scene")
    bmodels = parse_generated_odm(odm_bytes, metadata_path)
    navigation_bytes, stats = build_navigation_bytes(
        odm_bytes,
        dummy_dat_world(),
        bmodels,
        mechanism_map(scene),
    )
    render_data_bytes, render_stats = build_render_data_bytes(
        odm_bytes,
        bmodels,
        mechanism_map(scene),
    )
    odm_path.with_suffix(".nav").write_bytes(navigation_bytes)
    odm_path.with_suffix(".render").write_bytes(render_data_bytes)
    write_navigation_metadata(
        odm_path.with_suffix(".nav.yml"),
        odm_path.name,
        odm_path.with_suffix(".nav").name,
        stats["navigation_geometry_fnv1a64"],
        stats,
    )
    write_render_data_metadata(
        odm_path.with_suffix(".render.yml"),
        odm_path.name,
        odm_path.with_suffix(".render").name,
        render_stats,
    )
    stats.update(render_stats)
    return stats


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--maps-root", type=Path, default=Path("assets_dev/worlds/mm9/maps"))
    parser.add_argument("--only-map", action="append", default=[])
    args = parser.parse_args()
    requested = {name.lower() for name in args.only_map}
    odm_paths = sorted(args.maps_root.glob("*.odm"))
    if requested:
        odm_paths = [path for path in odm_paths if path.stem.lower() in requested]

    for odm_path in odm_paths:
        stats = cook_map(odm_path)
        print(
            f"{odm_path.stem}: facets={stats['navigation_cooked_facets']} "
            f"floors={stats['navigation_floor_facets']} barriers={stats['navigation_barrier_facets']} "
            f"duplicates={stats['navigation_duplicate_facets_removed']} "
            f"render_faces={stats['render_cooked_faces']} render_cells={stats['render_static_cells']}"
        )
    print(f"cooked={len(odm_paths)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
