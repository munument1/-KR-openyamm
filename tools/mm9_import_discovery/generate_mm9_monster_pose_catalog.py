#!/usr/bin/env python3
"""Generate the authoritative MM9 monster model/skin inventory and reference-pose gallery."""

from __future__ import annotations

import argparse
import re
from pathlib import Path

import yaml

from generate_mm9_npc_pose_catalog import (
    build_variants,
    contact_sheet,
    placeholder,
    read_table_rows,
    render_jobs,
    resolve_assets,
    slug,
    write_gallery,
    write_inventory,
)
from batch_convert_actor_models import SKIN_COLUMNS, clean_field, stem_id


SPR_DTX_PATTERN = re.compile(rb"(?:SpriteTextures[\\/])?([^\\/\x00\"]+\.dtx)", re.IGNORECASE)
PLACEHOLDER_MODELS = {"n/a", "sheep.abc"}


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--monster-table", type=Path, default=Path("mm9/extracted/DATA/DATA/MONSTERS.txt"))
    parser.add_argument("--model-root", type=Path, required=True)
    parser.add_argument("--skin-preview-root", type=Path, required=True)
    parser.add_argument("--spr-root", type=Path, default=Path("mm9/extracted/SKINS/SKINS"))
    parser.add_argument("--output-dir", type=Path, default=Path("test_img/mm9_monster_pose_catalog"))
    parser.add_argument("--blender", default="blender")
    parser.add_argument("--inventory-only", action="store_true")
    parser.add_argument("--limit", type=int)
    return parser.parse_args()


def read_monster_rows(path: Path) -> list[dict[str, str]]:
    rows = []
    for source_row, source in enumerate(read_table_rows(path), start=2):
        if clean_field(source.get("IsMonster")) != "1":
            continue
        model_name = clean_field(source.get("ModelName"))
        if not model_name:
            raise ValueError(f"MM9 monster row {source_row} has no authoritative ModelName")
        if model_name.lower() in PLACEHOLDER_MODELS:
            raise ValueError(f"MM9 monster row {source_row} resolves to placeholder model {model_name}")
        row = dict(source)
        row["ModelName"] = model_name
        for column in SKIN_COLUMNS:
            row[column] = clean_field(source.get(column))
        row["_source_row"] = str(source_row)
        rows.append(row)
    return rows


def first_spr_frame_name(path: Path) -> str | None:
    match = SPR_DTX_PATTERN.search(path.read_bytes())
    return match.group(1).decode("cp1252") if match is not None else None


def resolve_spr_previews(variants: list[dict], spr_root: Path, skin_preview_root: Path) -> None:
    spr_index = {path.name.lower(): path for path in spr_root.rglob("*.spr")}
    preview_index = {path.name.lower(): path for path in skin_preview_root.rglob("*.png")}
    for variant in variants:
        resolved_skins = []
        for skin in variant["skins"]:
            if Path(skin).suffix.lower() != ".spr":
                resolved_skins.append(skin)
                continue
            spr_path = spr_index.get(Path(skin).name.lower())
            if spr_path is None:
                raise ValueError(f"Missing MM9 monster SPR skin: {skin}")
            frame_name = first_spr_frame_name(spr_path)
            if frame_name is None or f"{stem_id(frame_name)}.png" not in preview_index:
                raise ValueError(f"Cannot resolve first DTX frame for MM9 monster SPR skin: {skin}")
            resolved_skins.append(frame_name)
        variant["sourceSkins"] = list(variant["skins"])
        variant["skins"] = resolved_skins


def resolve_missing_skin_previews(variants: list[dict], model_root: Path, skin_preview_root: Path) -> None:
    preview_names = {path.name.lower() for path in skin_preview_root.rglob("*.png")}
    for variant in variants:
        sidecar_path = model_root / f"{variant['modelId']}.model.yml"
        sidecar = yaml.safe_load(sidecar_path.read_text(encoding="utf-8")) if sidecar_path.exists() else {}
        materials = {
            int(material.get("index", 0)): material
            for material in (sidecar or {}).get("materials", [])
            if isinstance(material, dict)
        }
        resolutions = []
        for material_index, skin in enumerate(variant["skins"]):
            if f"{stem_id(skin)}.png" in preview_names:
                continue
            material = materials.get(material_index, {})
            default_preview = Path(str(material.get("preview_texture", ""))).name
            if not default_preview or default_preview.lower() not in preview_names:
                raise ValueError(
                    f"Missing MM9 monster skin {skin} and no real model-default texture for {variant['variantId']}"
                )
            default_skin = Path(default_preview).with_suffix(".dtx").name
            resolutions.append(
                {
                    "materialIndex": material_index,
                    "missingSourceSkin": skin,
                    "modelDefaultSkin": default_skin,
                }
            )
            variant.setdefault("warnings", []).append(
                f"source skin {skin} is missing; reference render uses model-default {default_skin}"
            )
            variant["skins"][material_index] = default_skin
        if resolutions:
            variant["skinResolutions"] = resolutions


def restore_source_skins(variants: list[dict]) -> None:
    for variant in variants:
        source_skins = variant.pop("sourceSkins", None)
        if source_skins is not None:
            variant["renderSkins"] = list(variant["skins"])
            variant["skins"] = source_skins


def main() -> int:
    arguments = parse_arguments()
    arguments.output_dir.mkdir(parents=True, exist_ok=True)
    rows = read_monster_rows(arguments.monster_table)
    variants = build_variants(rows, arguments.limit)
    resolve_spr_previews(variants, arguments.spr_root, arguments.skin_preview_root)
    resolve_missing_skin_previews(variants, arguments.model_root, arguments.skin_preview_root)

    expected_previews = {
        f"{index:03d}_{slug(variant['variantId'])}.png" for index, variant in enumerate(variants, start=1)
    }
    preview_dir = arguments.output_dir / "previews"
    for preview_path in preview_dir.glob("*.png"):
        if preview_path.name not in expected_previews:
            preview_path.unlink()

    jobs = resolve_assets(variants, arguments.model_root, arguments.skin_preview_root, arguments.output_dir)
    if arguments.inventory_only:
        for variant in variants:
            placeholder(arguments.output_dir / variant["preview"], variant["variantId"], "inventory-only run")
    else:
        render_jobs(arguments, jobs, variants)

    failed = [
        variant
        for variant in variants
        if not Path(variant["modelPath"]).is_file()
        or variant["missingMaterialIndices"]
        or (not arguments.inventory_only and not variant["rendered"])
    ]
    restore_source_skins(variants)
    write_inventory(
        arguments.output_dir,
        arguments.monster_table,
        arguments.monster_table,
        variants,
        catalog_label="monster",
        selection="MONSTERS.txt rows whose IsMonster field is exactly 1; model and skins come directly from that row",
        schema="openyamm.mm9MonsterPoseCatalog.v1",
    )
    write_gallery(arguments.output_dir, variants, catalog_label="monster")
    for start in range(0, len(variants), 16):
        contact_sheet(arguments.output_dir, variants, start // 16 + 1, start)

    print(
        f"MM9 monster catalogue: {len(rows)} rows, {len(variants)} variants, "
        f"{sum(variant['rendered'] for variant in variants)} rendered"
    )
    print(f"catalogue: {arguments.output_dir}")
    if failed:
        print(f"ERROR: {len(failed)} authoritative MM9 monster variants did not render cleanly")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
