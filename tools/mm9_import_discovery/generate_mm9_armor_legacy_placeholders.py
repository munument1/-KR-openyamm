#!/usr/bin/env python3
"""Generate fitted MM9 armor placeholders by conservatively grading legacy variants."""

from __future__ import annotations

import argparse
import csv
import json
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import numpy as np
import yaml
from PIL import Image

sys.path.insert(0, str(Path(__file__).resolve().parent))

import generate_mm9_equipment_variants as armor
import render_paperdoll_equipment_preview as paperdoll


DEFAULT_DEFINITIONS = Path(__file__).resolve().with_name("mm9_armor_legacy_placeholders.yml")
DEFAULT_OUTPUT_ROOT = armor.REPOSITORY_ROOT / "test_img/mm9_armor_legacy_placeholders"


@dataclass(frozen=True)
class PlaceholderDefinition:
    raw_id: int
    item_id: int
    name: str
    normalized_tier: int
    armor_skill: str
    reference_item_id: int
    reference_world: str
    coverage_profile: str
    selection_reason: str


@dataclass(frozen=True)
class LegacyArmorCandidate:
    item_id: int
    icon_name: str
    name: str
    normalized_tier: int
    armor_skill: str
    source_world: str


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--definitions", type=Path, default=DEFAULT_DEFINITIONS)
    parser.add_argument("--output-root", type=Path, default=DEFAULT_OUTPUT_ROOT)
    return parser.parse_args()


def parse_int(value: Any) -> int:
    try:
        return int(value)
    except (TypeError, ValueError):
        return 0


def read_item_skills(path: Path) -> dict[int, str]:
    with path.open("r", encoding="cp1252", newline="") as source_file:
        rows = list(csv.reader(source_file, delimiter="\t"))

    header_index = next(index for index, row in enumerate(rows) if row and row[0] == "Item #")
    header = rows[header_index]
    return {
        parse_int(row.get("Item #")): row.get("Skill Group", "").strip()
        for values in rows[header_index + 1:]
        if (row := dict(zip(header, values))) and parse_int(row.get("Item #")) > 0
    }


def source_world(icon_name: str) -> str | None:
    folded = icon_name.casefold()

    if folded.startswith("6"):
        return "mm6"
    if folded.startswith("7"):
        return "mm7"
    if folded.startswith("item"):
        return "mm8"

    return None


def read_legacy_armor_candidates(path: Path) -> list[LegacyArmorCandidate]:
    with path.open("r", encoding="cp1252", newline="") as source_file:
        rows = list(csv.reader(source_file, delimiter="\t"))

    header_index = next(index for index, row in enumerate(rows) if row and row[0] == "Item #")
    header = rows[header_index]
    regular: dict[tuple[str, str], list[dict[str, str]]] = {}
    special: list[dict[str, str]] = []

    for values in rows[header_index + 1:]:
        row = dict(zip(header, values))
        world = source_world(row.get("Pic File", ""))
        skill = row.get("Skill Group", "").strip()

        if row.get("Equip Stat") != "Armor" or skill not in {"Leather", "Chain", "Plate"} or world is None:
            continue
        if row.get("material", "").strip() in {"Artifact", "Relic"}:
            row["_source_world"] = world
            special.append(row)
        elif row.get("material", "").strip().isdigit() and parse_int(row.get("Value")) > 0:
            row["_source_world"] = world
            regular.setdefault((world, skill), []).append(row)

    result = []

    for (world, skill), values in regular.items():
        ordered = sorted(
            values,
            key=lambda row: (parse_int(row.get("Mod2")), parse_int(row.get("Value")), parse_int(row.get("Item #"))),
        )

        for index, row in enumerate(ordered[:5]):
            result.append(LegacyArmorCandidate(
                item_id=parse_int(row.get("Item #")),
                icon_name=row.get("Pic File", "").strip(),
                name=row.get("Name", "").strip(),
                normalized_tier=index + 1,
                armor_skill=skill,
                source_world=world,
            ))

    for row in special:
        result.append(LegacyArmorCandidate(
            item_id=parse_int(row.get("Item #")),
            icon_name=row.get("Pic File", "").strip(),
            name=row.get("Name", "").strip(),
            normalized_tier=7,
            armor_skill=row.get("Skill Group", "").strip(),
            source_world=row["_source_world"],
        ))

    return result


def color_histogram(image: Image.Image) -> np.ndarray:
    rgba = np.asarray(image.convert("RGBA"), dtype=np.uint8)
    colors = rgba[:, :, :3][rgba[:, :, 3] > 32]

    if len(colors) == 0:
        return np.zeros(64, dtype=np.float64)

    bins = colors[:, 0] // 64 * 16 + colors[:, 1] // 64 * 4 + colors[:, 2] // 64
    histogram = np.bincount(bins, minlength=64).astype(np.float64)
    return histogram / np.sum(histogram)


def visible_aspect(image: Image.Image) -> float:
    bounds = image.convert("RGBA").getchannel("A").getbbox()

    if bounds is None:
        return 1.0

    return max(1, bounds[2] - bounds[0]) / max(1, bounds[3] - bounds[1])


def rank_candidates(
    target_tier: int,
    armor_skill: str,
    target_inventory: Image.Image,
    candidates: list[LegacyArmorCandidate],
    assets: paperdoll.AssetIndex,
) -> list[dict[str, Any]]:
    world_penalty = {"mm8": 0.0, "mm7": 3.0, "mm6": 6.0}
    target_histogram = color_histogram(target_inventory)
    target_aspect = visible_aspect(target_inventory)
    result = []

    for candidate in candidates:
        if candidate.armor_skill != armor_skill:
            continue

        inventory_path = assets.find(candidate.icon_name)

        if inventory_path is None:
            continue

        inventory = paperdoll.load_layer(inventory_path, color_key=True)
        tier_distance = abs(candidate.normalized_tier - target_tier)
        color_distance = float(np.sum(np.abs(target_histogram - color_histogram(inventory))) / 2.0)
        aspect_distance = abs(float(np.log(max(0.01, visible_aspect(inventory) / target_aspect))))
        score = tier_distance * 100.0 + color_distance * 35.0 + aspect_distance * 15.0
        score += world_penalty[candidate.source_world]
        result.append({
            "item_id": candidate.item_id,
            "name": candidate.name,
            "normalized_tier": candidate.normalized_tier,
            "source_world": candidate.source_world,
            "score": round(score, 4),
            "tier_distance": tier_distance,
            "color_distance": round(color_distance, 4),
            "aspect_distance": round(aspect_distance, 4),
        })

    return sorted(result, key=lambda value: (value["score"], value["item_id"]))


def load_definitions(path: Path) -> dict[int, PlaceholderDefinition]:
    document = yaml.safe_load(path.read_text(encoding="utf-8"))

    if not isinstance(document, dict) or document.get("format_version") != 1:
        raise ValueError("legacy placeholder definitions must use format_version 1")
    if document.get("kind") != "mm9_armor_legacy_placeholders":
        raise ValueError("legacy placeholder definitions have an invalid kind")

    raw_items = document.get("items")

    if not isinstance(raw_items, dict) or not raw_items:
        raise ValueError("legacy placeholder definitions must contain items")

    result: dict[int, PlaceholderDefinition] = {}

    for raw_key, value in raw_items.items():
        raw_id = parse_int(raw_key)

        if raw_id <= 0 or not isinstance(value, dict):
            raise ValueError(f"invalid legacy placeholder item {raw_key!r}")

        unknown = set(value) - {
            "item_id", "name", "normalized_tier", "armor_skill", "reference_item_id", "reference_world",
            "coverage_profile", "selection_reason",
        }

        if unknown:
            raise ValueError(f"raw armor {raw_id} has unknown placeholder fields: {sorted(unknown)}")

        definition = PlaceholderDefinition(
            raw_id=raw_id,
            item_id=parse_int(value.get("item_id")),
            name=str(value.get("name", "")),
            normalized_tier=parse_int(value.get("normalized_tier")),
            armor_skill=str(value.get("armor_skill", "")),
            reference_item_id=parse_int(value.get("reference_item_id")),
            reference_world=str(value.get("reference_world", "")),
            coverage_profile=str(value.get("coverage_profile", "")),
            selection_reason=str(value.get("selection_reason", "")),
        )

        if definition.normalized_tier not in range(1, 8):
            raise ValueError(f"raw armor {raw_id} has invalid normalized tier")
        if definition.armor_skill not in {"Leather", "Chain", "Plate"}:
            raise ValueError(f"raw armor {raw_id} has invalid armor skill")
        if definition.reference_world not in {"mm6", "mm7", "mm8"}:
            raise ValueError(f"raw armor {raw_id} has invalid reference world")
        if definition.coverage_profile not in armor.COVERAGE_PROFILES:
            raise ValueError(f"raw armor {raw_id} has invalid coverage profile")

        result[raw_id] = definition

    return result


def hue_distance(first: np.ndarray, second: float) -> np.ndarray:
    difference = np.abs(first.astype(np.float32) - second)
    return np.minimum(difference, 255.0 - difference)


def dominant_accent_hsv(image: Image.Image) -> tuple[float, float] | None:
    rgba = image.convert("RGBA")
    hsv = np.asarray(rgba.convert("RGB").convert("HSV"), dtype=np.uint8)
    alpha = np.asarray(rgba.getchannel("A"), dtype=np.uint8)
    saturated = (alpha > 32) & (hsv[:, :, 1] >= 72) & (hsv[:, :, 2] >= 42)

    if np.count_nonzero(saturated) < 8:
        return None

    hues = hsv[:, :, 0][saturated]
    saturations = hsv[:, :, 1][saturated]
    bins = np.bincount(hues // 16, weights=saturations.astype(np.float64), minlength=16)
    winning_bin = int(np.argmax(bins))
    selected = (hues // 16) == winning_bin
    return float(np.median(hues[selected])), float(np.median(saturations[selected]))


def conservative_grade(reference: Image.Image, mm9_inventory: Image.Image) -> tuple[Image.Image, dict[str, Any]]:
    reference = reference.convert("RGBA")
    pixels = np.asarray(reference, dtype=np.uint8).copy()
    alpha = pixels[:, :, 3]
    source_hsv = np.asarray(reference.convert("RGB").convert("HSV"), dtype=np.uint8)
    source_accent = dominant_accent_hsv(reference)
    target_accent = dominant_accent_hsv(mm9_inventory)
    accent_mask = np.zeros(alpha.shape, dtype=bool)

    if source_accent is not None and target_accent is not None:
        source_hue, _source_saturation = source_accent
        target_hue, target_saturation = target_accent
        accent_mask = (
            (alpha > 0)
            & (source_hsv[:, :, 1] >= 64)
            & (source_hsv[:, :, 2] >= 36)
            & (hue_distance(source_hsv[:, :, 0], source_hue) <= 28)
        )
        height = max(1, reference.height - 1)
        normalized_y = np.indices(alpha.shape)[0].astype(np.float32) / height
        waist = accent_mask & (normalized_y >= 0.40) & (normalized_y <= 0.67)
        trim = accent_mask & ~waist
        graded_hsv = source_hsv.copy()
        graded_hsv[:, :, 0][trim] = np.uint8(round(target_hue))
        source_saturation = float(np.median(source_hsv[:, :, 1][trim])) if np.any(trim) else 0.0
        graded_hsv[:, :, 1][trim] = np.uint8(
            round(0.85 * target_saturation + 0.15 * source_saturation)
        )
        graded_rgb = np.asarray(Image.fromarray(graded_hsv, "HSV").convert("RGB"), dtype=np.uint8)
        pixels[:, :, :3][trim] = graded_rgb[trim]
        accent_mask = trim

    output = Image.fromarray(pixels, "RGBA")
    return output, {
        "source_accent_hsv": list(source_accent) if source_accent is not None else None,
        "target_accent_hsv": list(target_accent) if target_accent is not None else None,
        "accent_pixels": int(np.count_nonzero(accent_mask)),
    }


def write_complex_picture_table(
    path: Path,
    definitions: list[tuple[PlaceholderDefinition, tuple[tuple[int, int], ...]]],
) -> None:
    rows = [
        ["", "", "Armors", "Settings", "t0", "", "t1", "", "t2", "", "t3", "", "t4", "", "t5", ""],
        ["Id", "Item id", "Notes", "", "X", "Y", "X", "Y", "X", "Y", "X", "Y", "X", "Y", "X", "Y"],
    ]

    for row_id, (definition, points) in enumerate(definitions, start=1):
        rows.append([str(row_id), str(definition.item_id), definition.name, "", *[str(v) for p in points for v in p]])

    path.parent.mkdir(parents=True, exist_ok=True)

    with path.open("w", encoding="utf-8", newline="") as output_file:
        csv.writer(output_file, delimiter="\t", lineterminator="\n").writerows(rows)


def main() -> int:
    arguments = parse_arguments()
    definitions = load_definitions(arguments.definitions)
    mm9_items = armor.read_armor_items(paperdoll.MM9_TABLE_ROOT / "items.txt")
    engine_items = paperdoll.read_items(paperdoll.ENGINE_TABLE_ROOT / "items.txt", "engine")
    engine_item_skills = read_item_skills(paperdoll.ENGINE_TABLE_ROOT / "items.txt")
    legacy_candidates = read_legacy_armor_candidates(paperdoll.ENGINE_TABLE_ROOT / "items.txt")
    engine_assets = paperdoll.AssetIndex([paperdoll.ENGINE_ICON_ROOT])
    complex_offsets = paperdoll.read_complex_picture_offsets(
        paperdoll.ENGINE_TABLE_ROOT / "complex_item_pictures.txt"
    )
    foot_definitions = armor.load_foot_exclusions(armor.DEFAULT_FOOT_EXCLUSIONS)
    profiles = armor.load_coverage_profiles(armor.DEFAULT_FOOT_EXCLUSIONS)
    character_dolls = paperdoll.read_character_dolls(paperdoll.ENGINE_TABLE_ROOT / "character_data.txt")
    foot_masks = armor.build_foot_exclusion_masks(
        foot_definitions,
        engine_items,
        engine_assets,
        complex_offsets,
        character_dolls,
    )
    icons_root = arguments.output_root / "icons"
    icons_root.mkdir(parents=True, exist_ok=True)
    records = []
    table_definitions = []

    for raw_id, definition in definitions.items():
        mm9_item = mm9_items.get(raw_id)
        reference_item = engine_items.get(definition.reference_item_id)
        points = complex_offsets.get(definition.reference_item_id)

        if mm9_item is None or mm9_item.item_id != definition.item_id or mm9_item.name != definition.name:
            raise ValueError(f"raw armor {raw_id} does not match the imported MM9 item")
        if reference_item is None or reference_item.equip_stat != "Armor":
            raise ValueError(f"raw armor {raw_id} has invalid reference item {definition.reference_item_id}")
        if engine_item_skills.get(definition.reference_item_id) != definition.armor_skill:
            raise ValueError(f"raw armor {raw_id} reference armor skill does not match")
        if points is None:
            raise ValueError(f"raw armor {raw_id} reference item has no fitted offsets")

        inventory = Image.open(paperdoll.MM9_ICON_ROOT / f"{mm9_item.icon_name}.png").convert("RGBA")
        candidate_ranking = rank_candidates(
            definition.normalized_tier,
            definition.armor_skill,
            inventory,
            legacy_candidates,
            engine_assets,
        )
        profile = profiles[definition.coverage_profile]
        variants = []

        for suffix in armor.ARMOR_SUFFIXES:
            doll_type = int(suffix[1]) - 1
            reference_name = f"{reference_item.icon_name}{suffix}"
            reference_path = engine_assets.find(reference_name)

            if reference_path is None:
                raise ValueError(f"raw armor {raw_id} is missing legacy variant {reference_name}")

            legacy = paperdoll.load_layer(reference_path, color_key=True)
            covered, coverage_removed = armor.apply_coverage_profile(
                legacy,
                points[doll_type],
                doll_type,
                profile,
            )
            clipped, foot_removed = armor.apply_foot_exclusion(
                covered,
                points[doll_type],
                foot_masks[doll_type],
            )
            output, grade_report = conservative_grade(clipped, inventory)
            output_path = icons_root / f"{mm9_item.icon_name}{suffix}.png"
            output.save(output_path, optimize=False)
            variants.append({
                "suffix": suffix,
                "reference_asset": reference_path.relative_to(armor.REPOSITORY_ROOT).as_posix(),
                "output": output_path.relative_to(arguments.output_root).as_posix(),
                "output_sha256": armor.sha256_file(output_path),
                "coverage_removed_pixels": coverage_removed,
                "foot_removed_pixels": foot_removed,
                "foot_overlap_pixels": armor.alpha_overlap_count(
                    output,
                    points[doll_type],
                    foot_masks[doll_type],
                ),
                **grade_report,
            })

        records.append({
            "raw_mm9_id": raw_id,
            "item_id": definition.item_id,
            "name": definition.name,
            "normalized_tier": definition.normalized_tier,
            "armor_skill": definition.armor_skill,
            "reference_item_id": definition.reference_item_id,
            "reference_name": reference_item.name,
            "reference_world": definition.reference_world,
            "selection_reason": definition.selection_reason,
            "selection_candidates": candidate_ranking[:8],
            "paperdoll_offsets": [list(point) for point in points],
            "variants": variants,
        })
        table_definitions.append((definition, points))

    write_complex_picture_table(arguments.output_root / "complex_item_pictures.txt", table_definitions)
    report_path = arguments.output_root / "report.json"
    report_path.write_text(json.dumps({"items": records}, indent=2) + "\n", encoding="utf-8")
    print(f"generated {len(records)} legacy-placeholder armor families under {arguments.output_root}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
