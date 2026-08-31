#!/usr/bin/env python3
"""Prepare generation and equipped-preview review inputs for one MM9 equipment suffix."""

from __future__ import annotations

import argparse
import json
import shutil
import sys
from dataclasses import asdict
from pathlib import Path

import numpy as np
from PIL import Image

sys.path.insert(0, str(Path(__file__).resolve().parent))

import generate_mm9_equipment_variants as equipment
import render_paperdoll_equipment_preview as paperdoll


DOLL_DESCRIPTIONS = {
    0: "male human",
    1: "female human",
    2: "minotaur with exposed furry lower legs and hooves",
    3: "troll with exposed trousers, sandals, and feet",
    4: "dwarf with exposed trousers, boots, and feet",
}

CATEGORY_CONSTRAINTS = {
    "Armor": (
        "Armor pixels only. Construct the neck, shoulders, sleeves, torso, waist, hem, skirt or lower panels around "
        "the actual body and arm pose. Body armor must end before separate footwear, feet, claws, or hooves. Preserve "
        "the distinction between weapon and empty-right-hand arm poses. Do not bake in skin, hands, a weapon, a "
        "shield, boots, or a belt item."
    ),
    "Helm": (
        "Helmet or cap pixels only. Fit the exact head angle and preserve intentional face, eye, mouth, ear, hair, "
        "horn, and neck openings implied by the MM9 design. Do not bake in a face, eyes, hair, beard, skin, neck, "
        "body, armor, or plume unless that plume is an actual part of the MM9 helmet. A closed helm may occlude the "
        "face only inside its audited mask."
    ),
    "Boots": (
        "Boot or slipper pixels only. Fit the left and right foot independently, preserve sole contact and leg "
        "direction, and end each shaft at the height implied by the MM9 design. Do not bridge the legs, swap feet, "
        "include floor or shadow, or bake in trousers, greaves belonging to armor, skin, claws, or unrelated leg "
        "pixels. For ankle_only_footwear, remove the legacy shafts and cover only the audited low-foot region."
    ),
    "Belt": (
        "Belt pixels only. Wrap the exact waist perspective and keep buckle, medallions, gems, strap thickness, and "
        "rear edges coherent around the torso. Do not bake in armor, cloth, skin, hands, pouches, a weapon, or "
        "unrelated waist pixels. The belt must not float away from the body or become a flat horizontal inventory "
        "strip."
    ),
}

CATEGORY_REVIEW_CHECKS = {
    "Armor": (
        "neck alignment; both shoulder joins; each sleeve opening against its actual arm direction; torso "
        "perspective; waist and belt line; hem and panel construction; leg separation when applicable; and "
        "termination before footwear, feet, claws, or hooves"
    ),
    "Helm": (
        "the exact head angle; face, eye, mouth, ear, hair, horn, and neck openings; intentional hair and ear "
        "occlusion; secure contact with the head; and absence of generated skin, facial features, or detached pieces"
    ),
    "Boots": (
        "the left and right foot independently; toe, vamp, heel, and sole alignment; sole contact; each leg's actual "
        "direction; the two shaft or ankle terminations; and absence of bridges, swapped feet, floating soles, floor, "
        "skin, trousers, claws, or unrelated leg pixels"
    ),
    "Belt": (
        "waist perspective and centerline; buckle or medallion placement; strap thickness; rear-edge wrapping; armor "
        "occlusion and layer order; and absence of floating segments, armor pixels, cloth, skin, hands, or pouches"
    ),
}


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--item-id", type=int, required=True)
    parser.add_argument("--suffix", choices=equipment.VARIANT_SUFFIXES, required=True)
    parser.add_argument("--candidate", type=Path, help="fitted candidate to render instead of the active asset")
    parser.add_argument("--target", type=Path, help="audited fitted target; defaults to generic staging output")
    parser.add_argument("--output-dir", type=Path, required=True)
    return parser.parse_args()


def mask_guide(target: Image.Image) -> Image.Image:
    alpha = np.asarray(target.convert("RGBA"), dtype=np.uint8)[:, :, 3]
    result = np.empty((target.height, target.width, 4), dtype=np.uint8)
    result[:, :, :3] = (255, 0, 255)
    result[:, :, 3] = 255
    result[alpha > 0, :3] = (138, 138, 138)
    return Image.fromarray(result, "RGBA")


def enlarged_source(source: Path) -> Image.Image:
    image = Image.open(source).convert("RGB")
    return image.resize((image.width * 8, image.height * 8), Image.Resampling.NEAREST)


def render_equipped_preview(
    item_id: int,
    doll_type_id: int,
    has_right_hand_weapon: bool,
    candidate_root: Path | None,
    point: tuple[int, int] | None = None,
) -> tuple[Image.Image, paperdoll.PreviewDiagnostic]:
    items = paperdoll.read_items(paperdoll.ENGINE_TABLE_ROOT / "items.txt", "engine")
    items.update(paperdoll.read_items(paperdoll.MM9_TABLE_ROOT / "items.txt", "mm9"))
    dolls = paperdoll.read_character_dolls(paperdoll.ENGINE_TABLE_ROOT / "character_data.txt")
    representatives = paperdoll.representative_dolls(dolls)
    doll_types = paperdoll.read_doll_types(paperdoll.ENGINE_TABLE_ROOT / "doll_types.txt")
    offsets = paperdoll.read_complex_picture_offsets(
        paperdoll.ENGINE_TABLE_ROOT / "complex_item_pictures.txt"
    )
    offsets.update(
        paperdoll.read_complex_picture_offsets(paperdoll.MM9_TABLE_ROOT / "complex_item_pictures.txt")
    )
    roots = [paperdoll.MM9_ICON_ROOT, paperdoll.ENGINE_ICON_ROOT]

    if candidate_root is not None:
        roots.insert(0, candidate_root)

    item = items[item_id]
    doll = representatives[doll_type_id]
    doll_type = doll_types[doll_type_id]
    preview, diagnostic = paperdoll.render_preview(
        item,
        doll,
        doll_type,
        point if point is not None else offsets[item_id][doll_type_id],
        (0, 0),
        has_right_hand_weapon,
        "complete",
        paperdoll.AssetIndex(roots),
    )
    return preview, diagnostic


def render_legacy_preview(
    reference_item: paperdoll.Item,
    doll_type_id: int,
    point: tuple[int, int],
    has_right_hand_weapon: bool,
) -> Image.Image:
    dolls = paperdoll.read_character_dolls(paperdoll.ENGINE_TABLE_ROOT / "character_data.txt")
    representatives = paperdoll.representative_dolls(dolls)
    doll_types = paperdoll.read_doll_types(paperdoll.ENGINE_TABLE_ROOT / "doll_types.txt")
    preview, diagnostic = paperdoll.render_preview(
        reference_item,
        representatives[doll_type_id],
        doll_types[doll_type_id],
        point,
        (0, 0),
        has_right_hand_weapon,
        "complete",
        paperdoll.AssetIndex([paperdoll.ENGINE_ICON_ROOT]),
    )

    if diagnostic.issues:
        raise ValueError(f"legacy preview failed: {diagnostic.issues}")

    return preview


def generation_prompt(
    item_name: str,
    item_id: int,
    suffix: str,
    category: str,
    geometry_profile: str,
    legacy_world: str,
    legacy_item_name: str,
    transfer_focus: str,
    doll_description: str,
    width: int,
    height: int,
) -> str:
    pose = "right-hand weapon pose" if category == "Armor" and not suffix.endswith("a") else "standard fitted pose"
    return f"""Use case: precise-object-edit
Asset type: fitted equipment-layer sprite for a late-1990s MM6-MM8-style RPG paperdoll
Primary request: Edit the selected fitted {legacy_world.upper()} {legacy_item_name} variant into a good placeholder
for MM9 {item_name} (item {item_id}), suffix {suffix}, category {category}, geometry profile {geometry_profile},
on the exact {doll_description} {pose}.

Input images:
- Image 1 is the selected fitted legacy variant and the primary edit base. Preserve its pose, placement geometry,
  perspective, lighting, anatomical alignment, and broad silhouette.
- Image 2 is the audited two-color target mask. It owns permitted coverage and exact outer alpha geometry.
- Image 3 is the legacy variant equipped on the exact target doll. It owns final fit and layer-order evidence.
- Image 4 is the promoted MM9 inventory icon. It owns readable palette, material, ornament, and identity.
- Image 5 is the exact original 64x64 MM9 PCX enlarged with nearest-neighbor sampling and is binding history.

Transfer focus: {transfer_focus}

Make a restrained source-derived adaptation, not an unrelated redesign. Preserve fitted construction and painted
shading while transferring recognizable MM9 colors, materials, trim, closures, panels, symbols, gems, and ornament.
Reconstruct details in the fitted pose. Never stretch, tile, project, or paste the flat inventory icon.

Keep every equipment pixel within Image 2's exact {width}x{height} geometry. Do not move, rotate, mirror, widen,
shorten, swap, or detach fitted parts. Keep the item upright. Output one equipment layer only on one perfectly uniform
solid #FF00FF magenta background. Magenta must not occur in the equipment.

Style: Hand-painted late-1990s MM6-MM8 paperdoll sprite artwork, readable after downsampling, coherent material scale,
neutral frontal lighting slightly from upper left.

Category constraints: {CATEGORY_CONSTRAINTS[category]}
Constraints: No doll, unrelated equipment, UI, scenery, checkerboard, transparency, gradient, shadow, glow, text,
watermark, white matte, or modern glossy 3D rendering.
"""


def validation_prompt(
    item_name: str,
    item_id: int,
    suffix: str,
    category: str,
    doll_description: str,
    width: int,
    height: int,
) -> str:
    return f"""Use case: precise-object-edit
Asset type: corrected MM6-MM8-style fitted paperdoll equipment layer
Primary request: Inspect the final equipped composite for {item_name} (item {item_id}, suffix {suffix}), then redraw
only the defective {category} region so it genuinely fits the {doll_description} pose.

Input images:
- Image 1 is the current high-resolution generated source and the edit target.
- Image 2 is the exact audited target mask and owns permitted alpha geometry.
- Image 3 is the final equipped-doll composite and is authoritative anatomical and layer-order evidence.
- Image 4 is the promoted inventory icon and owns item identity.
- Image 5 is the enlarged original MM9 PCX and is the binding historical design reference.

Inspect before drawing: {CATEGORY_REVIEW_CHECKS[category]}. Correct every visible projection, stretching, clipping,
floating edge, misplaced seam, mirrored or swapped part, or mannequin-like surface from Image 2. A texture merely
filling Image 1 is a failure.

Change only the affected region and defect. Preserve every accepted region, fitted pose, MM9 identity, colors,
materials, lighting, and exact {width}x{height} mask geometry. Output {category} pixels only on one uniform #FF00FF
background in late-1990s MM6-MM8 painted-sprite style.

Constraints: Do not output the doll, body parts, other equipment, UI, scenery, checkerboard, transparency, white matte,
text, glow, shadow, or watermark.
"""


def main() -> int:
    arguments = parse_arguments()
    arguments.output_dir.mkdir(parents=True, exist_ok=True)
    equipment_items = equipment.read_equipment_items(paperdoll.MM9_TABLE_ROOT / "items.txt")
    mappings = equipment.load_mappings(equipment.DEFAULT_MAPPING, equipment_items)
    by_item_id = {item.item_id: item for item in equipment_items.values()}
    item = by_item_id.get(arguments.item_id)

    if item is None:
        raise ValueError(f"item {arguments.item_id} is not imported MM9 paperdoll equipment")
    if arguments.suffix not in equipment.expected_suffixes(item.category):
        raise ValueError(f"suffix {arguments.suffix} is not supported by {item.category} item {item.item_id}")

    mapping = mappings[item.raw_id]
    doll_type = int(arguments.suffix[1]) - 1
    expected_name = f"{item.icon_name}{arguments.suffix}.png"
    engine_items = paperdoll.read_items(paperdoll.ENGINE_TABLE_ROOT / "items.txt", "engine")
    reference_item = engine_items[mapping.reference_item_id]
    offsets = paperdoll.read_complex_picture_offsets(
        paperdoll.ENGINE_TABLE_ROOT / "complex_item_pictures.txt"
    )
    reference_points = offsets[mapping.reference_item_id]
    engine_assets = paperdoll.AssetIndex([paperdoll.ENGINE_ICON_ROOT])
    reference_path = engine_assets.find(f"{reference_item.icon_name}{arguments.suffix}")

    if reference_path is None:
        raise ValueError(f"missing selected legacy variant for {item.item_id} {arguments.suffix}")

    raw_reference = paperdoll.load_layer(reference_path, color_key=True)
    foot_definitions = equipment.load_foot_exclusions(equipment.DEFAULT_FOOT_EXCLUSIONS)
    coverage_profiles = equipment.load_coverage_profiles(equipment.DEFAULT_FOOT_EXCLUSIONS)
    character_dolls = paperdoll.read_character_dolls(paperdoll.ENGINE_TABLE_ROOT / "character_data.txt")
    foot_masks = equipment.build_foot_exclusion_masks(
        foot_definitions,
        engine_items,
        engine_assets,
        offsets,
        character_dolls,
    )
    calculated_target, geometry_record = equipment.build_audited_target(
        item.category,
        mapping.geometry_profile,
        raw_reference,
        reference_points[doll_type],
        doll_type,
        coverage_profiles,
        foot_masks,
        mapping.silhouette_adjustment,
    )
    target = Image.open(arguments.target).convert("RGBA") if arguments.target is not None else calculated_target

    candidate_root = None

    if arguments.candidate is not None:
        candidate_root = arguments.output_dir / "candidate_root"
        candidate_root.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(arguments.candidate, candidate_root / expected_name)
        candidate_image = Image.open(arguments.candidate).convert("RGBA")
        candidate_image.save(arguments.output_dir / "candidate.png", optimize=False)
        candidate_image.resize(
            (candidate_image.width * 8, candidate_image.height * 8),
            Image.Resampling.NEAREST,
        ).save(arguments.output_dir / "candidate_8x.png", optimize=False)

    source_index = equipment.build_case_insensitive_file_index(equipment.DEFAULT_SOURCE_ROOT)
    source_path = source_index.get(Path(item.source_icon_path).name.casefold())

    if source_path is None:
        raise ValueError(f"missing source PCX {item.source_icon_path}")

    inventory_path = paperdoll.MM9_ICON_ROOT / f"{item.icon_name}.png"
    unarmored_root = arguments.output_dir / "unarmored_root"
    unarmored_root.mkdir(parents=True, exist_ok=True)
    Image.new("RGBA", target.size, (0, 0, 0, 0)).save(unarmored_root / expected_name, optimize=False)
    unarmored_preview, _ = render_equipped_preview(
        item.item_id,
        doll_type,
        item.category != "Armor" or not arguments.suffix.endswith("a"),
        unarmored_root,
        reference_points[doll_type],
    )
    preview, diagnostic = render_equipped_preview(
        item.item_id,
        doll_type,
        item.category != "Armor" or not arguments.suffix.endswith("a"),
        candidate_root,
        reference_points[doll_type],
    )
    legacy_preview = render_legacy_preview(
        reference_item,
        doll_type,
        reference_points[doll_type],
        item.category != "Armor" or not arguments.suffix.endswith("a"),
    )
    target_path = arguments.output_dir / "target.png"
    mask_path = arguments.output_dir / "mask.png"
    legacy_path = arguments.output_dir / "legacy_variant.png"
    legacy_preview_output = arguments.output_dir / "legacy_equipped.png"
    unarmored_output = arguments.output_dir / "unarmored_doll.png"
    inventory_output = arguments.output_dir / "inventory.png"
    source_output = arguments.output_dir / "source_pcx.png"
    preview_output = arguments.output_dir / "equipped_preview.png"
    target.save(target_path, optimize=False)
    mask_guide(target).save(mask_path, optimize=False)
    raw_reference.save(legacy_path, optimize=False)
    legacy_preview.convert("RGB").save(legacy_preview_output, optimize=False)
    unarmored_preview.convert("RGB").save(unarmored_output, optimize=False)
    shutil.copyfile(inventory_path, inventory_output)
    enlarged_source(source_path).save(source_output, optimize=False)
    preview.convert("RGB").save(preview_output, optimize=False)
    generation_text = generation_prompt(
        item.name,
        item.item_id,
        arguments.suffix,
        item.category,
        mapping.geometry_profile,
        mapping.reference_world,
        reference_item.name,
        mapping.transfer_focus,
        DOLL_DESCRIPTIONS[doll_type],
        target.width,
        target.height,
    )
    validation_text = validation_prompt(
        item.name,
        item.item_id,
        arguments.suffix,
        item.category,
        DOLL_DESCRIPTIONS[doll_type],
        target.width,
        target.height,
    )
    (arguments.output_dir / "generation_prompt.txt").write_text(generation_text, encoding="utf-8")
    (arguments.output_dir / "validation_prompt.txt").write_text(validation_text, encoding="utf-8")
    report = {
        "raw_mm9_id": item.raw_id,
        "item_id": item.item_id,
        "name": item.name,
        "category": item.category,
        "geometry_profile": mapping.geometry_profile,
        "transfer_focus": mapping.transfer_focus,
        "reference_item_id": reference_item.id,
        "reference_item_name": reference_item.name,
        "reference_asset": reference_path.relative_to(equipment.REPOSITORY_ROOT).as_posix(),
        "suffix": arguments.suffix,
        "doll_type": doll_type,
        "doll_description": DOLL_DESCRIPTIONS[doll_type],
        "right_hand_weapon": item.category != "Armor" or not arguments.suffix.endswith("a"),
        "target_size": [target.width, target.height],
        "target_alpha_sha256": equipment.sha256_bytes(target.getchannel("A").tobytes()),
        "candidate": str(arguments.candidate) if arguments.candidate is not None else None,
        "geometry": geometry_record,
        "preview_diagnostic": asdict(diagnostic),
    }
    (arguments.output_dir / "review.json").write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"prepared {item.item_id} {item.name} {arguments.suffix} in {arguments.output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
