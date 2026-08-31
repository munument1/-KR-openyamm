#!/usr/bin/env python3
"""Headless Blender worker for the MM9 NPC initial-pose catalogue."""

from __future__ import annotations

import argparse
import json
import math
import re
import sys
from collections import defaultdict
from pathlib import Path

import bpy
from mathutils import Vector


MM9_LIGHT_POWER_SCALE = 0.08


def parse_arguments() -> argparse.Namespace:
    arguments = sys.argv[sys.argv.index("--") + 1 :] if "--" in sys.argv else []
    parser = argparse.ArgumentParser()
    parser.add_argument("--jobs", type=Path, required=True)
    parser.add_argument("--results", type=Path, required=True)
    return parser.parse_args(arguments)


def material_index(name: str, fallback: int) -> int:
    match = re.search(r"\.(\d+)$", name)
    return int(match.group(1)) if match else fallback


def make_material(name: str, texture_path: str | None, missing: bool) -> bpy.types.Material:
    material = bpy.data.materials.new(name=name)
    material.use_nodes = True
    material.diffuse_color = (0.8, 0.05, 0.8, 1.0) if missing else (1.0, 1.0, 1.0, 1.0)
    nodes = material.node_tree.nodes
    links = material.node_tree.links
    shader = nodes.get("Principled BSDF")
    if shader is None:
        return material

    shader.inputs["Metallic"].default_value = 0.0
    shader.inputs["Roughness"].default_value = 0.82
    if texture_path:
        image = bpy.data.images.load(texture_path, check_existing=True)
        texture = nodes.new("ShaderNodeTexImage")
        texture.image = image
        texture.interpolation = "Closest"
        links.new(texture.outputs["Color"], shader.inputs["Base Color"])
        # MM9 actor DTX files commonly carry unused or zero alpha bytes despite being opaque model skins. Applying
        # that channel hides valid geometry (notably wolves, giants, dragons, sea monsters, and beholders).
        shader.inputs["Alpha"].default_value = 1.0
    return material


def apply_variant_materials(meshes: list[bpy.types.Object], job: dict) -> None:
    textures = job["texture_paths"]
    missing_indices = set(job["missing_material_indices"])
    materials: dict[int, bpy.types.Material] = {}

    for mesh in meshes:
        for fallback, slot in enumerate(mesh.material_slots):
            index = material_index(slot.material.name if slot.material else "", fallback)
            if index not in materials:
                texture_path = textures[index] if index < len(textures) else None
                materials[index] = make_material(
                    f"catalog_{job['variant_id']}_{index}",
                    texture_path,
                    index in missing_indices or texture_path is None,
                )
            slot.material = materials[index]


def evaluated_bounds(meshes: list[bpy.types.Object]) -> tuple[Vector, Vector]:
    dependency_graph = bpy.context.evaluated_depsgraph_get()
    minimum = Vector((math.inf, math.inf, math.inf))
    maximum = Vector((-math.inf, -math.inf, -math.inf))
    for mesh in meshes:
        evaluated = mesh.evaluated_get(dependency_graph)
        for corner in evaluated.bound_box:
            point = evaluated.matrix_world @ Vector(corner)
            minimum.x = min(minimum.x, point.x)
            minimum.y = min(minimum.y, point.y)
            minimum.z = min(minimum.z, point.z)
            maximum.x = max(maximum.x, point.x)
            maximum.y = max(maximum.y, point.y)
            maximum.z = max(maximum.z, point.z)
    if not math.isfinite(minimum.x):
        raise RuntimeError("imported model has no finite mesh bounds")
    return minimum, maximum


def add_area_light(name: str, location: Vector, energy: float, size: float, target: Vector) -> None:
    data = bpy.data.lights.new(name=name, type="AREA")
    data.energy = energy
    data.shape = "DISK"
    data.size = size
    light = bpy.data.objects.new(name, data)
    bpy.context.scene.collection.objects.link(light)
    light.location = location
    light.rotation_euler = (target - location).to_track_quat("-Z", "Y").to_euler()


def configure_scene(minimum: Vector, maximum: Vector, output_path: Path) -> None:
    scene = bpy.context.scene
    scene.render.engine = "BLENDER_EEVEE"
    scene.render.resolution_x = 360
    scene.render.resolution_y = 480
    scene.render.resolution_percentage = 100
    scene.render.image_settings.file_format = "PNG"
    scene.render.image_settings.color_mode = "RGBA"
    scene.render.film_transparent = True
    scene.render.filepath = str(output_path)
    scene.render.image_settings.color_depth = "8"
    if scene.world is None:
        scene.world = bpy.data.worlds.new("CatalogWorld")
    scene.world.color = (0.035, 0.035, 0.035)

    center = (minimum + maximum) * 0.5
    dimensions = maximum - minimum
    largest = max(dimensions.x, dimensions.y, dimensions.z, 0.01)
    # Converted MM9 actors retain large source-space dimensions. Light power must follow the square of the
    # uniformly scaled scene to preserve approximately the same illumination at the correspondingly larger distance.
    light_energy_scale = largest * largest * MM9_LIGHT_POWER_SCALE
    direction = Vector((0.34, -1.0, 0.02)).normalized()

    camera_data = bpy.data.cameras.new("CatalogCamera")
    camera = bpy.data.objects.new("CatalogCamera", camera_data)
    scene.collection.objects.link(camera)
    camera.location = center + direction * largest * 4.0
    camera.rotation_euler = (center - camera.location).to_track_quat("-Z", "Y").to_euler()
    projected_width = math.sqrt(dimensions.x * dimensions.x + dimensions.y * dimensions.y)
    camera_data.type = "ORTHO"
    camera_data.ortho_scale = max(dimensions.z * 1.16, projected_width * 480.0 / 360.0 * 1.10, 0.1)
    scene.camera = camera

    add_area_light(
        "Key",
        center + Vector((-2.5, -4.0, 4.5)).normalized() * largest * 2.5,
        900.0 * light_energy_scale,
        largest * 1.5,
        center,
    )
    add_area_light(
        "Fill",
        center + Vector((4.0, -2.0, 1.0)).normalized() * largest * 2.0,
        450.0 * light_energy_scale,
        largest * 1.8,
        center,
    )
    add_area_light(
        "Rim",
        center + Vector((0.0, 3.0, 4.0)).normalized() * largest * 2.0,
        650.0 * light_energy_scale,
        largest * 1.4,
        center,
    )


def import_model(model_path: str) -> list[bpy.types.Object]:
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.gltf(filepath=model_path)
    scene = bpy.context.scene
    scene.frame_start = 1
    scene.frame_set(1)
    bpy.context.view_layer.update()
    meshes = [entry for entry in scene.objects if entry.type == "MESH"]
    if not meshes:
        raise RuntimeError("GLB contains no mesh objects")
    return meshes


def main() -> int:
    arguments = parse_arguments()
    jobs = json.loads(arguments.jobs.read_text(encoding="utf-8"))
    jobs_by_model: dict[str, list[dict]] = defaultdict(list)
    for job in jobs:
        jobs_by_model[job["model_path"]].append(job)

    results = []
    completed = 0
    for model_path, model_jobs in jobs_by_model.items():
        try:
            meshes = import_model(model_path)
            minimum, maximum = evaluated_bounds(meshes)
            configure_scene(minimum, maximum, Path(model_jobs[0]["output_path"]))
            for job in model_jobs:
                output_path = Path(job["output_path"])
                output_path.parent.mkdir(parents=True, exist_ok=True)
                try:
                    apply_variant_materials(meshes, job)
                    bpy.context.scene.render.filepath = str(output_path)
                    bpy.ops.render.render(write_still=True)
                    results.append({"variant_id": job["variant_id"], "ok": True, "error": ""})
                except Exception as error:
                    results.append({"variant_id": job["variant_id"], "ok": False, "error": str(error)})
                completed += 1
                print(f"MM9 NPC pose render {completed}/{len(jobs)}: {job['variant_id']}", flush=True)
        except Exception as error:
            for job in model_jobs:
                results.append({"variant_id": job["variant_id"], "ok": False, "error": str(error)})
                completed += 1

    arguments.results.write_text(json.dumps(results, indent=2) + "\n", encoding="utf-8")
    return 0 if all(result["ok"] for result in results) else 1


if __name__ == "__main__":
    raise SystemExit(main())
