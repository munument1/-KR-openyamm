#!/usr/bin/env python3
"""Generate fitted MM9 equipment variants from authored geometry references.

The selected MM7/MM8 family owns fitted geometry and placement. Deterministic
staging outputs are review candidates only; accepted AI or explicitly migrated
variants are owned by the generic generated-art manifest and promoted by this
tool as complete item families.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import shutil
from collections import deque
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import numpy as np
import yaml
from PIL import Image, ImageDraw, ImageFilter

import render_paperdoll_equipment_preview as paperdoll


REPOSITORY_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_MAPPING = Path(__file__).resolve().with_name("mm9_equipment_legacy_base_mappings.yml")
DEFAULT_FOOT_EXCLUSIONS = Path(__file__).resolve().with_name("mm9_armor_foot_exclusions.yml")
DEFAULT_AUTHORED_ART_MANIFEST = Path(__file__).resolve().with_name("mm9_equipment_generated_art.yml")
DEFAULT_GENERATED_ART_ROOT = Path(__file__).resolve().with_name("generated_equipment_art")
DEFAULT_STAGING_ROOT = Path(__file__).resolve().with_name("equipment_generation_staging")
DEFAULT_WORLD_ROOT = REPOSITORY_ROOT / "assets_dev/worlds/mm9"
DEFAULT_SOURCE_ROOT = REPOSITORY_ROOT / "mm9/extracted"
ARMOR_SUFFIXES = [
    "v1", "v1a", "v2", "v2a", "v3", "v3a", "v4", "v4a", "v5", "v5a",
]
HELMET_BOOT_SUFFIXES = ["v1", "v2", "v4", "v5"]
BELT_SUFFIXES = ["v1", "v2", "v3", "v4", "v5"]
VARIANT_SUFFIXES = sorted(set(ARMOR_SUFFIXES + HELMET_BOOT_SUFFIXES + BELT_SUFFIXES))
EQUIPMENT_CATEGORIES = {"Armor", "Helm", "Boots", "Belt"}
COVERAGE_PROFILES = {"short_torso", "hip_length", "thigh_length", "full_harness"}
SILHOUETTE_ADJUSTMENTS = {"", "smooth_upper_protrusions"}

# Reviewed low-foot regions for the MM7 Leather Boots variants used by the
# ankle_only_footwear profile. Coordinates are normalized to the exact fitted
# variant canvas so both feet survive independently in raised and crossed poses.
# The target still intersects these regions with the selected legacy alpha; the
# polygons cannot add coverage which was absent from the fitted reference.
ANKLE_ONLY_FOOT_POLYGONS: dict[int, tuple[tuple[tuple[float, float], ...], ...]] = {
    0: (
        ((0.06, 0.28), (0.30, 0.30), (0.44, 0.35), (0.58, 0.44), (0.60, 0.58),
         (0.46, 0.66), (0.20, 0.64), (0.07, 0.46)),
        ((0.47, 0.67), (0.70, 0.68), (0.90, 0.78), (0.94, 0.95), (0.82, 1.00),
         (0.52, 1.00), (0.45, 0.86)),
    ),
    1: (
        ((0.15, 0.18), (0.50, 0.18), (0.67, 0.28), (0.72, 0.48), (0.57, 0.61),
         (0.37, 0.58), (0.17, 0.42)),
        ((0.43, 0.61), (0.76, 0.59), (0.95, 0.70), (0.95, 0.88), (0.76, 1.00),
         (0.43, 0.96), (0.39, 0.80)),
    ),
    3: (
        ((0.00, 0.60), (0.28, 0.57), (0.52, 0.65), (0.56, 0.86), (0.40, 1.00),
         (0.00, 1.00)),
        ((0.49, 0.60), (0.78, 0.58), (1.00, 0.64), (1.00, 0.90), (0.87, 1.00),
         (0.49, 1.00)),
    ),
    4: (
        ((0.05, 0.53), (0.29, 0.52), (0.54, 0.61), (0.55, 0.78), (0.40, 0.88),
         (0.05, 0.88)),
        ((0.47, 0.53), (0.74, 0.51), (0.96, 0.59), (0.97, 0.78), (0.83, 0.88),
         (0.45, 0.88)),
    ),
}

# Drogg's Helm supplies the fitted head placement for Death Cap, but its outer
# spike and horn loops are not part of the MM9 skull mask. This normalized clip
# retains the central fitted helmet volume across the four supported dolls.
UNIQUE_FACE_MASK_POLYGON: tuple[tuple[float, float], ...] = (
    (0.50, 0.22),
    (0.33, 0.29),
    (0.19, 0.40),
    (0.10, 0.56),
    (0.11, 0.78),
    (0.20, 0.95),
    (0.32, 1.00),
    (0.68, 1.00),
    (0.80, 0.95),
    (0.89, 0.78),
    (0.90, 0.56),
    (0.81, 0.40),
    (0.67, 0.29),
)


@dataclass(frozen=True)
class EquipmentItem:
    raw_id: int
    item_id: int
    icon_name: str
    name: str
    category: str
    source_icon_path: str


@dataclass(frozen=True)
class EquipmentMapping:
    raw_id: int
    item_id: int
    name: str
    category: str
    reference_item_id: int
    reference_world: str
    geometry_profile: str
    normalized_tier: int
    transfer_focus: str
    silhouette_adjustment: str


@dataclass(frozen=True)
class FootExclusionDefinition:
    doll_type: int
    method: str
    source_item_id: int | None
    character_ids: tuple[int, ...]
    global_y_min: int | None
    dilation: int
    review_status: str


@dataclass(frozen=True)
class CoverageProfileDefinition:
    name: str
    max_global_y_exclusive: tuple[int, ...] | None
    review_status: str


@dataclass(frozen=True)
class AuthoredEquipmentVariant:
    raw_id: int
    suffix: str
    asset_path: Path
    asset_sha256: str
    source_asset_path: Path
    source_asset_sha256: str
    target_mask_path: Path
    target_mask_sha256: str
    reference_asset_path: Path
    reference_asset_sha256: str
    inventory_asset_path: Path
    inventory_asset_sha256: str
    original_pcx_path: Path
    original_pcx_sha256: str
    equipped_preview_path: Path
    equipped_preview_sha256: str
    generation_tool: str
    prompt_spec: str
    prompt_sha256: str
    postprocess: str
    width: int
    height: int
    alpha_sha256: str
    content_sha256: str
    review_status: str


POSE_PAIR_SUFFIXES = tuple((f"v{index}", f"v{index}a") for index in range(1, 6))
POSE_PAIR_EVIDENCE_FIELDS = (
    "allowed_change_mask",
    "common_region_mask",
    "isolated_review",
    "equipped_review",
    "blink_review",
    "difference_review",
    "seam_review",
)
POSE_PAIR_IN_GAME_REVIEWS = {
    "dark_plate_weapon": (10115, "weapon"),
    "dark_plate_empty": (10115, "empty"),
    "broderick_hauberk_weapon": (10225, "weapon"),
    "broderick_hauberk_empty": (10225, "empty"),
}


def validate_pose_pair_records(
    manifest_path: Path,
    raw_id: int,
    item: EquipmentItem,
    item_value: dict[str, Any],
    variants: dict[str, Any],
    *,
    allow_stale_goal_hash: bool = False,
) -> None:
    pose_pairs = item_value.get("pose_pairs")

    if pose_pairs is None:
        return
    if item.category != "Armor":
        raise ValueError(f"non-armor equipment {raw_id} cannot define pose pairs")
    if item_value.get("pose_pair_review_status") != "reviewed":
        raise ValueError(f"armor {raw_id} pose-pair family is not reviewed")
    if not isinstance(pose_pairs, dict):
        raise ValueError(f"armor {raw_id} pose pairs must be a mapping")

    expected_keys = {f"{weapon}_{empty}" for weapon, empty in POSE_PAIR_SUFFIXES}

    if set(pose_pairs) != expected_keys:
        raise ValueError(f"armor {raw_id} pose-pair keys are invalid: {sorted(pose_pairs)}")

    required_fields = {
        "raw_id", "item_id", "item_name", "doll_type", "weapon_suffix", "empty_suffix",
        "canonical_suffix", "canonical_reason", "allowed_pixels", "common_pixels", "changed_pixels",
        "changed_inside_allowed", "changed_outside_allowed", "target_alpha_changed_outside_allowed",
        "common_rgba_exact", "status", "allowed_change_mask_sha256_raw", "common_region_sha256_raw",
        "baseline_changed_outside_allowed", "baseline_common_rgba_exact", "baseline_transparent_rgb_pixels",
        "repair_required", "review_status", "reviewer_note", "weapon_asset_sha256", "empty_asset_sha256", "assembly",
        "weapon_target_sha256", "empty_target_sha256", "goal", "goal_sha256",
    }

    for evidence_field in POSE_PAIR_EVIDENCE_FIELDS:
        required_fields.add(evidence_field)
        required_fields.add(f"{evidence_field}_sha256")

    for doll_type, (weapon_suffix, empty_suffix) in enumerate(POSE_PAIR_SUFFIXES):
        pair_key = f"{weapon_suffix}_{empty_suffix}"
        pair = pose_pairs[pair_key]

        if not isinstance(pair, dict) or set(pair) != required_fields:
            actual_fields = set(pair) if isinstance(pair, dict) else set()
            raise ValueError(
                f"armor {raw_id} {pair_key} pose-pair fields differ; "
                f"missing={sorted(required_fields - actual_fields)}, "
                f"extra={sorted(actual_fields - required_fields)}"
            )
        if parse_int(str(pair["raw_id"])) != raw_id or parse_int(str(pair["item_id"])) != item.item_id:
            raise ValueError(f"armor {raw_id} {pair_key} item identity mismatch")
        if pair["item_name"] != item.name or parse_int(str(pair["doll_type"])) != doll_type:
            raise ValueError(f"armor {raw_id} {pair_key} name or doll type mismatch")
        if pair["weapon_suffix"] != weapon_suffix or pair["empty_suffix"] != empty_suffix:
            raise ValueError(f"armor {raw_id} {pair_key} suffix identity mismatch")
        if pair["canonical_suffix"] not in {weapon_suffix, empty_suffix} or not pair["canonical_reason"]:
            raise ValueError(f"armor {raw_id} {pair_key} canonical selection is invalid")
        if pair["status"] != "reviewed" or pair["review_status"] != "reviewed":
            raise ValueError(f"armor {raw_id} {pair_key} is not reviewed")
        if not pair["common_rgba_exact"]:
            raise ValueError(f"armor {raw_id} {pair_key} common RGBA is not exact")
        if parse_int(str(pair["changed_outside_allowed"])) != 0:
            raise ValueError(f"armor {raw_id} {pair_key} changes pixels outside the allowed arm region")
        if parse_int(str(pair["target_alpha_changed_outside_allowed"])) != 0:
            raise ValueError(f"armor {raw_id} {pair_key} target alpha escapes the allowed arm region")
        if pair["weapon_asset_sha256"] != variants[weapon_suffix]["content_sha256"]:
            raise ValueError(f"armor {raw_id} {pair_key} weapon hash does not match its variant")
        if pair["empty_asset_sha256"] != variants[empty_suffix]["content_sha256"]:
            raise ValueError(f"armor {raw_id} {pair_key} empty hash does not match its variant")
        if pair["weapon_target_sha256"] != variants[weapon_suffix]["target_mask_sha256"]:
            raise ValueError(f"armor {raw_id} {pair_key} weapon target hash does not match its variant")
        if pair["empty_target_sha256"] != variants[empty_suffix]["target_mask_sha256"]:
            raise ValueError(f"armor {raw_id} {pair_key} empty target hash does not match its variant")

        for evidence_field in POSE_PAIR_EVIDENCE_FIELDS:
            evidence_path = manifest_path.parent / str(pair[evidence_field])

            if not evidence_path.is_file():
                raise ValueError(f"armor {raw_id} {pair_key} is missing {evidence_field} {evidence_path}")
            if sha256_file(evidence_path) != str(pair[f"{evidence_field}_sha256"]):
                raise ValueError(f"armor {raw_id} {pair_key} {evidence_field} hash mismatch")

        goal_path = REPOSITORY_ROOT / str(pair["goal"])

        if not goal_path.is_file():
            raise ValueError(f"armor {raw_id} {pair_key} goal provenance is missing")
        if not allow_stale_goal_hash and sha256_file(goal_path) != str(pair["goal_sha256"]):
            raise ValueError(f"armor {raw_id} {pair_key} goal provenance mismatch")

    contact_sheet = manifest_path.parent / str(item_value.get("pose_pair_contact_sheet", ""))

    if not contact_sheet.is_file():
        raise ValueError(f"armor {raw_id} is missing its pose-pair contact sheet")
    if sha256_file(contact_sheet) != str(item_value.get("pose_pair_contact_sheet_sha256", "")):
        raise ValueError(f"armor {raw_id} pose-pair contact-sheet hash mismatch")


def parse_int(value: str) -> int:
    try:
        return int(value)
    except (TypeError, ValueError):
        return 0


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()

    with path.open("rb") as source_file:
        while chunk := source_file.read(1024 * 1024):
            digest.update(chunk)

    return digest.hexdigest()


def sha256_bytes(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest()


def sha256_tree(path: Path) -> str:
    digest = hashlib.sha256()

    for child in sorted(candidate for candidate in path.iterdir() if candidate.is_file()):
        digest.update(child.name.encode("utf-8"))
        digest.update(b"\0")
        digest.update(bytes.fromhex(sha256_file(child)))

    return digest.hexdigest()


def expected_suffixes(category: str) -> list[str]:
    if category == "Armor":
        return list(ARMOR_SUFFIXES)
    if category in {"Helm", "Boots"}:
        return list(HELMET_BOOT_SUFFIXES)
    if category == "Belt":
        return list(BELT_SUFFIXES)

    raise ValueError(f"unsupported equipment category {category!r}")


def read_equipment_items(path: Path) -> dict[int, EquipmentItem]:
    with path.open("r", encoding="utf-8", newline="") as source_file:
        rows = list(csv.reader(source_file, delimiter="\t"))

    header_index = next(index for index, row in enumerate(rows) if row and row[0] == "Item #")
    header = rows[header_index]
    result: dict[int, EquipmentItem] = {}

    for values in rows[header_index + 1:]:
        row = dict(zip(header, values))
        category = row.get("Equip Stat", "").strip()

        if category not in EQUIPMENT_CATEGORIES or row.get("package_id") != "mm9":
            continue

        raw_id = parse_int(row.get("x_mm9_raw_item_id", ""))
        item_id = parse_int(row.get("Item #", ""))

        if raw_id <= 0 or item_id <= 0:
            raise ValueError(f"invalid MM9 equipment row: {row}")

        result[raw_id] = EquipmentItem(
            raw_id=raw_id,
            item_id=item_id,
            icon_name=row.get("Pic File", "").strip(),
            name=row.get("Name", "").strip(),
            category=category,
            source_icon_path=row.get("x_mm9_source_icon_pcx", "").strip(),
        )

    return result


def load_mappings(path: Path, items: dict[int, EquipmentItem]) -> dict[int, EquipmentMapping]:
    document = yaml.safe_load(path.read_text(encoding="utf-8"))

    if not isinstance(document, dict) or document.get("format_version") != 1:
        raise ValueError("equipment mapping must use format_version 1")
    if document.get("kind") != "mm9_equipment_legacy_base_mappings":
        raise ValueError("equipment mapping has an invalid kind")

    values = document.get("items")

    if not isinstance(values, dict):
        raise ValueError("equipment mapping items must be a mapping")

    result: dict[int, EquipmentMapping] = {}

    for raw_key, value in values.items():
        raw_id = parse_int(str(raw_key))
        item = items.get(raw_id)

        if item is None or not isinstance(value, dict):
            raise ValueError(f"invalid equipment mapping {raw_key!r}")

        reference = value.get("reference")

        if not isinstance(reference, dict):
            raise ValueError(f"raw equipment {raw_id} has no reference mapping")

        mapping = EquipmentMapping(
            raw_id=raw_id,
            item_id=parse_int(str(value.get("item_id", ""))),
            name=str(value.get("name", "")),
            category=str(value.get("category", "")),
            reference_item_id=parse_int(str(reference.get("item_id", ""))),
            reference_world=str(reference.get("world", "")),
            geometry_profile=str(value.get("geometry_profile", "")),
            normalized_tier=parse_int(str(value.get("normalized_tier", ""))),
            transfer_focus=str(value.get("transfer_focus", "")).strip(),
            silhouette_adjustment=str(value.get("silhouette_adjustment", "")).strip(),
        )

        if (mapping.item_id, mapping.name, mapping.category) != (item.item_id, item.name, item.category):
            raise ValueError(f"raw equipment {raw_id} mapping does not match imported item metadata")
        if mapping.reference_world not in {"mm7", "mm8"} or mapping.reference_item_id <= 0:
            raise ValueError(f"raw equipment {raw_id} has an invalid reference")
        if not mapping.geometry_profile or not mapping.transfer_focus:
            raise ValueError(f"raw equipment {raw_id} has incomplete generation guidance")
        if mapping.silhouette_adjustment not in SILHOUETTE_ADJUSTMENTS:
            raise ValueError(
                f"raw equipment {raw_id} has invalid silhouette adjustment {mapping.silhouette_adjustment!r}"
            )

        result[raw_id] = mapping

    if set(result) != set(items):
        raise ValueError(
            f"equipment mapping coverage mismatch; missing={sorted(set(items) - set(result))}, "
            f"extra={sorted(set(result) - set(items))}"
        )

    return result


def read_armor_items(path: Path) -> dict[int, EquipmentItem]:
    return {
        raw_id: item
        for raw_id, item in read_equipment_items(path).items()
        if item.category == "Armor"
    }


def load_foot_exclusions(path: Path) -> dict[int, FootExclusionDefinition]:
    document = yaml.safe_load(path.read_text(encoding="utf-8"))

    if not isinstance(document, dict) or document.get("format_version") != 1:
        raise ValueError("armor foot exclusions must use format_version 1")
    if document.get("kind") != "mm9_armor_foot_exclusions":
        raise ValueError("armor foot exclusions have an invalid kind")
    if document.get("coordinate_space") != "paperdoll_background_pixels_from_top_left":
        raise ValueError("armor foot exclusions have an invalid coordinate space")

    values = document.get("doll_types")

    if not isinstance(values, dict):
        raise ValueError("armor foot exclusions doll_types must be a mapping")

    result: dict[int, FootExclusionDefinition] = {}

    for doll_key, value in values.items():
        doll_type = parse_int(str(doll_key))

        if doll_type not in range(5) or not isinstance(value, dict):
            raise ValueError(f"invalid armor foot exclusion doll type {doll_key!r}")

        unknown_keys = set(value) - {
            "method", "source_item_id", "character_ids", "global_y_min", "dilation", "review_status",
        }

        if unknown_keys:
            raise ValueError(f"doll type {doll_type} has unknown foot-exclusion fields: {sorted(unknown_keys)}")

        method = str(value.get("method", ""))
        source_item_id = parse_int(str(value.get("source_item_id", ""))) or None
        raw_character_ids = value.get("character_ids", [])

        if not isinstance(raw_character_ids, list):
            raise ValueError(f"doll type {doll_type} character_ids must be a list")

        character_ids = tuple(parse_int(str(character_id)) for character_id in raw_character_ids)
        global_y_min = parse_int(str(value.get("global_y_min", ""))) or None
        dilation = parse_int(str(value.get("dilation", "0")))
        review_status = str(value.get("review_status", ""))

        if method == "fitted_item":
            if source_item_id is None or character_ids or global_y_min is not None:
                raise ValueError(f"doll type {doll_type} has invalid fitted-item foot exclusion")
        elif method == "body_lower_region":
            if source_item_id is not None or not character_ids or global_y_min is None:
                raise ValueError(f"doll type {doll_type} has invalid lower-body foot exclusion")
        else:
            raise ValueError(f"doll type {doll_type} has unsupported foot-exclusion method {method!r}")

        if dilation not in range(0, 5):
            raise ValueError(f"doll type {doll_type} has invalid foot-exclusion dilation {dilation}")
        if review_status != "reviewed":
            raise ValueError(f"doll type {doll_type} foot exclusion is not reviewed")

        result[doll_type] = FootExclusionDefinition(
            doll_type=doll_type,
            method=method,
            source_item_id=source_item_id,
            character_ids=character_ids,
            global_y_min=global_y_min,
            dilation=dilation,
            review_status=review_status,
        )

    if set(result) != set(range(5)):
        raise ValueError(f"armor foot exclusions must define doll types 0-4, found {sorted(result)}")

    return result


def load_coverage_profiles(path: Path) -> dict[str, CoverageProfileDefinition]:
    document = yaml.safe_load(path.read_text(encoding="utf-8"))
    values = document.get("coverage_profiles") if isinstance(document, dict) else None

    if not isinstance(values, dict):
        raise ValueError("armor coverage profiles must be a mapping")

    result: dict[str, CoverageProfileDefinition] = {}

    for name, value in values.items():
        if name not in COVERAGE_PROFILES or not isinstance(value, dict):
            raise ValueError(f"invalid armor coverage profile {name!r}")

        unknown_keys = set(value) - {"max_global_y_exclusive", "review_status"}

        if unknown_keys:
            raise ValueError(f"coverage profile {name} has unknown fields: {sorted(unknown_keys)}")

        raw_limits = value.get("max_global_y_exclusive")

        if raw_limits is None:
            limits = None
        elif isinstance(raw_limits, dict) and set(parse_int(str(key)) for key in raw_limits) == set(range(5)):
            limits = tuple(parse_int(str(raw_limits[doll_type])) for doll_type in range(5))

            if any(limit <= 0 or limit > paperdoll.PAPERDOLL_HEIGHT for limit in limits):
                raise ValueError(f"coverage profile {name} has an invalid global Y limit")
        else:
            raise ValueError(f"coverage profile {name} must define doll types 0-4 or null")

        review_status = str(value.get("review_status", ""))

        if review_status != "reviewed":
            raise ValueError(f"coverage profile {name} is not reviewed")

        result[name] = CoverageProfileDefinition(
            name=name,
            max_global_y_exclusive=limits,
            review_status=review_status,
        )

    if set(result) != COVERAGE_PROFILES:
        raise ValueError(f"armor coverage profiles mismatch; found {sorted(result)}")

    return result


def paste_alpha_mask(canvas: np.ndarray, layer: Image.Image, point: tuple[int, int]) -> None:
    alpha = np.asarray(layer.convert("RGBA"), dtype=np.uint8)[:, :, 3]
    left = max(0, point[0])
    top = max(0, point[1])
    right = min(canvas.shape[1], point[0] + layer.width)
    bottom = min(canvas.shape[0], point[1] + layer.height)

    if left >= right or top >= bottom:
        return

    source_left = left - point[0]
    source_top = top - point[1]
    source_right = source_left + right - left
    source_bottom = source_top + bottom - top
    canvas[top:bottom, left:right] |= alpha[source_top:source_bottom, source_left:source_right] > 0


def build_foot_exclusion_masks(
    definitions: dict[int, FootExclusionDefinition],
    engine_items: dict[int, paperdoll.Item],
    engine_assets: paperdoll.AssetIndex,
    complex_offsets: dict[int, tuple[tuple[int, int], ...]],
    character_dolls: dict[int, paperdoll.CharacterDoll],
) -> dict[int, np.ndarray]:
    result: dict[int, np.ndarray] = {}

    for doll_type, definition in definitions.items():
        mask = np.zeros((paperdoll.PAPERDOLL_HEIGHT, paperdoll.PAPERDOLL_WIDTH), dtype=bool)

        if definition.method == "fitted_item":
            source_item = engine_items.get(definition.source_item_id or 0)
            source_points = complex_offsets.get(definition.source_item_id or 0)

            if source_item is None or source_item.equip_stat != "Boots" or source_points is None:
                raise ValueError(
                    f"doll type {doll_type} foot exclusion references invalid boot item "
                    f"{definition.source_item_id}"
                )

            source_name = f"{source_item.icon_name}v{doll_type + 1}"
            source_path = engine_assets.find(source_name)

            if source_path is None:
                raise ValueError(f"doll type {doll_type} foot exclusion is missing {source_name}")

            paste_alpha_mask(mask, paperdoll.load_layer(source_path, color_key=True), source_points[doll_type])
        else:
            assert definition.global_y_min is not None

            for character_id in definition.character_ids:
                doll = character_dolls.get(character_id)

                if doll is None or doll.doll_type != doll_type:
                    raise ValueError(
                        f"doll type {doll_type} foot exclusion references invalid character {character_id}"
                    )

                body_path = engine_assets.find(doll.body_asset)

                if body_path is None:
                    raise ValueError(f"doll type {doll_type} foot exclusion is missing {doll.body_asset}")

                body_mask = np.zeros_like(mask)
                paste_alpha_mask(
                    body_mask,
                    paperdoll.load_layer(body_path, color_key=True),
                    (doll.body_x, doll.body_y),
                )
                body_mask[:definition.global_y_min] = False
                mask |= body_mask

        if definition.dilation > 0:
            size = definition.dilation * 2 + 1
            mask = np.asarray(
                Image.fromarray(mask.astype(np.uint8) * 255, "L").filter(ImageFilter.MaxFilter(size))
            ) > 0

        if not np.any(mask):
            raise ValueError(f"doll type {doll_type} foot exclusion is empty")

        result[doll_type] = mask

    return result


def apply_foot_exclusion(
    reference: Image.Image,
    point: tuple[int, int],
    exclusion_mask: np.ndarray,
) -> tuple[Image.Image, int]:
    output = np.asarray(reference.convert("RGBA"), dtype=np.uint8).copy()
    alpha = output[:, :, 3]
    local_exclusion = np.zeros((reference.height, reference.width), dtype=bool)
    global_left = max(0, point[0])
    global_top = max(0, point[1])
    global_right = min(exclusion_mask.shape[1], point[0] + reference.width)
    global_bottom = min(exclusion_mask.shape[0], point[1] + reference.height)

    if global_left < global_right and global_top < global_bottom:
        local_left = global_left - point[0]
        local_top = global_top - point[1]
        local_right = local_left + global_right - global_left
        local_bottom = local_top + global_bottom - global_top
        local_exclusion[local_top:local_bottom, local_left:local_right] = exclusion_mask[
            global_top:global_bottom,
            global_left:global_right,
        ]

    removed = local_exclusion & (alpha > 0)
    output[:, :, 3][local_exclusion] = 0
    return Image.fromarray(output, "RGBA"), int(np.count_nonzero(removed))


def apply_coverage_profile(
    reference: Image.Image,
    point: tuple[int, int],
    doll_type: int,
    profile: CoverageProfileDefinition,
) -> tuple[Image.Image, int]:
    output = np.asarray(reference.convert("RGBA"), dtype=np.uint8).copy()

    if profile.max_global_y_exclusive is None:
        return Image.fromarray(output, "RGBA"), 0

    global_limit = profile.max_global_y_exclusive[doll_type]
    local_limit = max(0, min(reference.height, global_limit - point[1]))
    removed = output[local_limit:, :, 3] > 0
    output[local_limit:, :, 3] = 0
    return Image.fromarray(output, "RGBA"), int(np.count_nonzero(removed))


def alpha_overlap_count(image: Image.Image, point: tuple[int, int], exclusion_mask: np.ndarray) -> int:
    placed = np.zeros_like(exclusion_mask)
    paste_alpha_mask(placed, image, point)
    return int(np.count_nonzero(placed & exclusion_mask))


def largest_interior_transparent_component(alpha: np.ndarray) -> np.ndarray:
    height, width = alpha.shape
    visited = np.zeros_like(alpha)
    largest = np.zeros_like(alpha)
    largest_size = 0

    for start_y, start_x in np.argwhere(~alpha):
        if visited[start_y, start_x]:
            continue

        component = []
        touches_border = False
        queue: deque[tuple[int, int]] = deque([(int(start_y), int(start_x))])
        visited[start_y, start_x] = True

        while queue:
            y, x = queue.popleft()
            component.append((y, x))
            touches_border |= y in {0, height - 1} or x in {0, width - 1}

            for adjacent_y, adjacent_x in ((y - 1, x), (y + 1, x), (y, x - 1), (y, x + 1)):
                if not (0 <= adjacent_y < height and 0 <= adjacent_x < width):
                    continue
                if alpha[adjacent_y, adjacent_x] or visited[adjacent_y, adjacent_x]:
                    continue

                visited[adjacent_y, adjacent_x] = True
                queue.append((adjacent_y, adjacent_x))

        if not touches_border and len(component) > largest_size:
            largest[:] = False
            for y, x in component:
                largest[y, x] = True
            largest_size = len(component)

    if largest_size == 0:
        raise ValueError("equipment target has no interior opening")

    return largest


def remove_lower_detached_components(alpha: np.ndarray, cutoff_y: int) -> tuple[np.ndarray, int]:
    height, width = alpha.shape
    visited = np.zeros_like(alpha)
    revised = alpha.copy()
    removed = 0

    for start_y, start_x in np.argwhere(alpha):
        if visited[start_y, start_x]:
            continue

        component = []
        queue: deque[tuple[int, int]] = deque([(int(start_y), int(start_x))])
        visited[start_y, start_x] = True

        while queue:
            y, x = queue.popleft()
            component.append((y, x))

            for adjacent_y, adjacent_x in ((y - 1, x), (y + 1, x), (y, x - 1), (y, x + 1)):
                if not (0 <= adjacent_y < height and 0 <= adjacent_x < width):
                    continue
                if not alpha[adjacent_y, adjacent_x] or visited[adjacent_y, adjacent_x]:
                    continue

                visited[adjacent_y, adjacent_x] = True
                queue.append((adjacent_y, adjacent_x))

        if min(y for y, _x in component) < cutoff_y:
            continue

        for y, x in component:
            revised[y, x] = False
        removed += len(component)

    return revised, removed


def ankle_only_foot_masks(size: tuple[int, int], doll_type: int) -> tuple[np.ndarray, ...]:
    polygons = ANKLE_ONLY_FOOT_POLYGONS.get(doll_type)

    if polygons is None:
        raise ValueError(f"ankle-only footwear has no reviewed foot regions for doll type {doll_type}")

    width, height = size
    masks = []

    for polygon in polygons:
        mask = Image.new("1", size, 0)
        points = [
            (round(normalized_x * (width - 1)), round(normalized_y * (height - 1)))
            for normalized_x, normalized_y in polygon
        ]
        ImageDraw.Draw(mask).polygon(points, fill=1)
        masks.append(np.asarray(mask, dtype=bool))

    return tuple(masks)


def normalized_polygon_mask(
    size: tuple[int, int],
    polygon: tuple[tuple[float, float], ...],
) -> np.ndarray:
    width, height = size
    mask = Image.new("1", size, 0)
    points = [
        (round(normalized_x * (width - 1)), round(normalized_y * (height - 1)))
        for normalized_x, normalized_y in polygon
    ]
    ImageDraw.Draw(mask).polygon(points, fill=1)
    return np.asarray(mask, dtype=bool)


def fill_interior_transparency(alpha: np.ndarray) -> np.ndarray:
    height, width = alpha.shape
    outside = np.zeros_like(alpha)
    queue: deque[tuple[int, int]] = deque()

    for x in range(width):
        queue.append((0, x))
        queue.append((height - 1, x))

    for y in range(1, height - 1):
        queue.append((y, 0))
        queue.append((y, width - 1))

    while queue:
        y, x = queue.popleft()

        if alpha[y, x] or outside[y, x]:
            continue

        outside[y, x] = True

        for adjacent_y, adjacent_x in ((y - 1, x), (y + 1, x), (y, x - 1), (y, x + 1)):
            if 0 <= adjacent_y < height and 0 <= adjacent_x < width:
                queue.append((adjacent_y, adjacent_x))

    return alpha | (~alpha & ~outside)


def load_authored_art_manifest(
    path: Path,
    equipment_items: dict[int, EquipmentItem],
    *,
    allow_stale_pose_pair_goal_hash: bool = False,
) -> dict[tuple[int, str], AuthoredEquipmentVariant]:
    document = yaml.safe_load(path.read_text(encoding="utf-8"))

    if not isinstance(document, dict) or document.get("format_version") != 2:
        raise ValueError("authored equipment art manifest must use format_version 2")
    if document.get("kind") != "mm9_generated_equipment_art":
        raise ValueError("authored equipment art manifest has an invalid kind")
    if document.get("mapping") != DEFAULT_MAPPING.name:
        raise ValueError("authored equipment art manifest points at the wrong mapping")
    if document.get("mapping_sha256") != sha256_file(DEFAULT_MAPPING):
        raise ValueError("authored equipment art manifest mapping hash is stale")
    if document.get("engine_icons_tree_sha256") != sha256_tree(paperdoll.ENGINE_ICON_ROOT):
        raise ValueError("engine icon tree changed after the MM9 equipment snapshot")

    pose_pair_status = document.get("pose_pair_review_status")

    if pose_pair_status is not None:
        if pose_pair_status != "reviewed":
            raise ValueError("generated equipment pose-pair review is not complete")
        goal_path = REPOSITORY_ROOT / str(document.get("pose_pair_goal", ""))

        if not goal_path.is_file():
            raise ValueError("generated equipment pose-pair goal provenance is missing")
        if (
            not allow_stale_pose_pair_goal_hash
            and sha256_file(goal_path) != str(document.get("pose_pair_goal_sha256", ""))
        ):
            raise ValueError("generated equipment pose-pair goal provenance mismatch")

        catalogues = document.get("pose_pair_catalogues")

        if not isinstance(catalogues, list) or not catalogues:
            raise ValueError("generated equipment pose-pair catalogues are missing")

        for catalogue in catalogues:
            if not isinstance(catalogue, dict) or set(catalogue) != {"asset", "asset_sha256"}:
                raise ValueError("generated equipment pose-pair catalogue record is invalid")

            catalogue_path = path.parent / str(catalogue["asset"])

            if not catalogue_path.is_file() or sha256_file(catalogue_path) != str(catalogue["asset_sha256"]):
                raise ValueError(f"generated equipment pose-pair catalogue hash mismatch: {catalogue_path}")

        in_game_reviews = document.get("pose_pair_in_game_reviews")

        if not isinstance(in_game_reviews, dict) or set(in_game_reviews) != set(POSE_PAIR_IN_GAME_REVIEWS):
            raise ValueError("generated equipment manifest is missing the exact required in-game pose reviews")

        for review_name, (item_id, right_hand_state) in POSE_PAIR_IN_GAME_REVIEWS.items():
            review = in_game_reviews[review_name]
            expected_fields = {"item_id", "right_hand_state", "asset", "asset_sha256", "reviewer_note"}

            if not isinstance(review, dict) or set(review) != expected_fields:
                raise ValueError(f"generated equipment in-game review {review_name} is invalid")
            if parse_int(str(review["item_id"])) != item_id or review["right_hand_state"] != right_hand_state:
                raise ValueError(f"generated equipment in-game review {review_name} identity mismatch")
            if not str(review["reviewer_note"]).strip():
                raise ValueError(f"generated equipment in-game review {review_name} has no reviewer note")

            review_path = path.parent / str(review["asset"])

            if not review_path.is_file() or sha256_file(review_path) != str(review["asset_sha256"]):
                raise ValueError(f"generated equipment in-game review {review_name} hash mismatch")

    items = document.get("items")

    if not isinstance(items, dict):
        raise ValueError("authored equipment art manifest items must be a mapping")

    result: dict[tuple[int, str], AuthoredEquipmentVariant] = {}

    for raw_key, value in items.items():
        raw_id = parse_int(str(raw_key))
        equipment_item = equipment_items.get(raw_id)

        if equipment_item is None or not isinstance(value, dict):
            raise ValueError(f"invalid authored equipment art item {raw_key!r}")

        unknown_item_keys = set(value) - {
            "item_id", "name", "category", "review_status", "variants", "pose_pairs",
            "pose_pair_review_status", "pose_pair_contact_sheet", "pose_pair_contact_sheet_sha256",
        }

        if unknown_item_keys:
            raise ValueError(f"raw equipment {raw_id} has unknown authored-art fields: {sorted(unknown_item_keys)}")
        if parse_int(str(value.get("item_id", ""))) != equipment_item.item_id:
            raise ValueError(f"raw equipment {raw_id} authored-art item id does not match imported item")
        if str(value.get("name", "")) != equipment_item.name:
            raise ValueError(f"raw equipment {raw_id} authored-art name does not match imported item")
        if str(value.get("category", "")) != equipment_item.category:
            raise ValueError(f"raw equipment {raw_id} authored-art category does not match imported item")
        if str(value.get("review_status", "")) != "reviewed":
            raise ValueError(f"raw equipment {raw_id} family is not reviewed")

        variants = value.get("variants")

        if not isinstance(variants, dict) or not variants:
            raise ValueError(f"raw equipment {raw_id} authored-art variants must be a non-empty mapping")
        if set(variants) != set(expected_suffixes(equipment_item.category)):
            raise ValueError(
                f"raw equipment {raw_id} accepted suffix set is invalid: {sorted(variants)}"
            )

        validate_pose_pair_records(
            path,
            raw_id,
            equipment_item,
            value,
            variants,
            allow_stale_goal_hash=allow_stale_pose_pair_goal_hash,
        )

        for suffix, variant_value in variants.items():
            if not isinstance(variant_value, dict):
                raise ValueError(f"raw equipment {raw_id} has invalid authored variant {suffix!r}")

            required_variant_keys = {
                "asset", "asset_sha256", "source_asset", "source_asset_sha256", "target_mask",
                "target_mask_sha256", "reference_asset", "reference_asset_sha256", "inventory_asset",
                "inventory_asset_sha256", "original_pcx", "original_pcx_sha256", "equipped_preview",
                "equipped_preview_sha256", "generation_tool", "prompt_spec", "prompt_sha256", "postprocess",
                "width", "height", "alpha_sha256", "content_sha256", "review_status",
            }

            if set(variant_value) != required_variant_keys:
                raise ValueError(
                    f"raw equipment {raw_id} {suffix} manifest fields differ; "
                    f"missing={sorted(required_variant_keys - set(variant_value))}, "
                    f"extra={sorted(set(variant_value) - required_variant_keys)}"
                )

            def manifest_path(field: str) -> Path:
                return path.parent / str(variant_value[field])

            asset_path = manifest_path("asset")
            source_asset_path = manifest_path("source_asset")
            target_mask_path = manifest_path("target_mask")
            reference_asset_path = REPOSITORY_ROOT / str(variant_value["reference_asset"])
            inventory_asset_path = REPOSITORY_ROOT / str(variant_value["inventory_asset"])
            original_pcx_path = REPOSITORY_ROOT / str(variant_value["original_pcx"])
            equipped_preview_path = manifest_path("equipped_preview")
            generation_tool = str(variant_value.get("generation_tool", ""))
            prompt_spec = str(variant_value.get("prompt_spec", ""))
            postprocess = str(variant_value.get("postprocess", ""))
            review_status = str(variant_value.get("review_status", ""))

            hashed_paths = {
                "asset": (asset_path, "asset_sha256"),
                "source asset": (source_asset_path, "source_asset_sha256"),
                "target mask": (target_mask_path, "target_mask_sha256"),
                "reference asset": (reference_asset_path, "reference_asset_sha256"),
                "inventory asset": (inventory_asset_path, "inventory_asset_sha256"),
                "original PCX": (original_pcx_path, "original_pcx_sha256"),
                "equipped preview": (equipped_preview_path, "equipped_preview_sha256"),
            }

            for label, (hashed_path, hash_field) in hashed_paths.items():
                if not hashed_path.is_file():
                    raise ValueError(f"raw equipment {raw_id} {suffix} is missing {label} {hashed_path}")
                if sha256_file(hashed_path) != str(variant_value[hash_field]):
                    raise ValueError(f"raw equipment {raw_id} {suffix} {label} hash mismatch")

            if generation_tool not in {"built-in image_gen", "deterministic legacy palette placeholder"}:
                raise ValueError(
                    f"raw equipment {raw_id} {suffix} has unsupported generation tool {generation_tool!r}"
                )
            if not prompt_spec or not (REPOSITORY_ROOT / prompt_spec).is_file():
                raise ValueError(f"raw equipment {raw_id} {suffix} has invalid prompt spec {prompt_spec!r}")
            if sha256_file(REPOSITORY_ROOT / prompt_spec) != str(variant_value["prompt_sha256"]):
                raise ValueError(f"raw equipment {raw_id} {suffix} prompt hash mismatch")
            if not postprocess:
                raise ValueError(f"raw equipment {raw_id} {suffix} has no postprocess provenance")
            if review_status != "reviewed":
                raise ValueError(f"raw equipment {raw_id} {suffix} is not reviewed")

            image = Image.open(asset_path).convert("RGBA")
            width = parse_int(str(variant_value["width"]))
            height = parse_int(str(variant_value["height"]))

            if image.size != (width, height):
                raise ValueError(f"raw equipment {raw_id} {suffix} dimensions do not match manifest")
            if sha256_bytes(image.getchannel("A").tobytes()) != str(variant_value["alpha_sha256"]):
                raise ValueError(f"raw equipment {raw_id} {suffix} alpha hash mismatch")
            if sha256_file(asset_path) != str(variant_value["content_sha256"]):
                raise ValueError(f"raw equipment {raw_id} {suffix} content hash mismatch")

            result[(raw_id, suffix)] = AuthoredEquipmentVariant(
                raw_id=raw_id,
                suffix=suffix,
                asset_path=asset_path,
                asset_sha256=str(variant_value["asset_sha256"]),
                source_asset_path=source_asset_path,
                source_asset_sha256=str(variant_value["source_asset_sha256"]),
                target_mask_path=target_mask_path,
                target_mask_sha256=str(variant_value["target_mask_sha256"]),
                reference_asset_path=reference_asset_path,
                reference_asset_sha256=str(variant_value["reference_asset_sha256"]),
                inventory_asset_path=inventory_asset_path,
                inventory_asset_sha256=str(variant_value["inventory_asset_sha256"]),
                original_pcx_path=original_pcx_path,
                original_pcx_sha256=str(variant_value["original_pcx_sha256"]),
                equipped_preview_path=equipped_preview_path,
                equipped_preview_sha256=str(variant_value["equipped_preview_sha256"]),
                generation_tool=generation_tool,
                prompt_spec=prompt_spec,
                prompt_sha256=str(variant_value["prompt_sha256"]),
                postprocess=postprocess,
                width=width,
                height=height,
                alpha_sha256=str(variant_value["alpha_sha256"]),
                content_sha256=str(variant_value["content_sha256"]),
                review_status=review_status,
            )

    return result


def build_case_insensitive_file_index(root: Path) -> dict[str, Path]:
    result: dict[str, Path] = {}

    for path in root.rglob("*"):
        if path.is_file():
            result.setdefault(path.name.casefold(), path)

    return result


def source_content_image(path: Path) -> Image.Image:
    source = Image.open(path).convert("RGB")
    inset = max(2, min(source.width, source.height) // 16)
    cropped = source.crop((inset, inset, source.width - inset, source.height - inset)).convert("RGBA")
    pixels = np.asarray(cropped, dtype=np.uint8).copy()
    luminance = (
        pixels[:, :, 0].astype(np.uint16) * 54
        + pixels[:, :, 1].astype(np.uint16) * 183
        + pixels[:, :, 2].astype(np.uint16) * 19
    ) // 256
    pixels[:, :, 3] = np.where(luminance > 14, 255, 0).astype(np.uint8)
    return Image.fromarray(pixels, "RGBA")


def opaque_color_samples(image: Image.Image) -> np.ndarray:
    pixels = np.asarray(image.convert("RGBA"), dtype=np.uint8)
    return pixels[:, :, :3][pixels[:, :, 3] > 24]


def color_luminance(colors: np.ndarray) -> np.ndarray:
    values = colors.astype(np.float32)
    return values[:, 0] * 0.2126 + values[:, 1] * 0.7152 + values[:, 2] * 0.0722


def representative_palette(promoted: Image.Image, source: Image.Image) -> np.ndarray:
    promoted_colors = opaque_color_samples(promoted)
    source_colors = opaque_color_samples(source)

    if len(promoted_colors) == 0 or len(source_colors) == 0:
        raise ValueError("armor design input contains no opaque pixels")

    colors = np.concatenate([promoted_colors, source_colors, source_colors], axis=0)
    luminance = color_luminance(colors)
    result = []

    for quantile in [0.16, 0.50, 0.86]:
        target = float(np.quantile(luminance, quantile))
        distance = np.abs(luminance - target)
        selection_count = max(8, len(colors) // 18)
        indices = np.argpartition(distance, min(selection_count, len(distance) - 1))[:selection_count]
        result.append(np.median(colors[indices], axis=0))

    return np.asarray(result, dtype=np.float32)


def recolor_reference(reference: np.ndarray, palette: np.ndarray) -> np.ndarray:
    reference_rgb = reference[:, :, :3].astype(np.float32)
    luminance = color_luminance(reference_rgb.reshape(-1, 3)).reshape(reference.shape[:2])
    opaque = reference[:, :, 3] > 0

    if not np.any(opaque):
        raise ValueError("reference armor variant contains no opaque pixels")

    low, high = np.quantile(luminance[opaque], [0.03, 0.97])
    normalized = np.clip((luminance - low) / max(1.0, high - low), 0.0, 1.0)
    lower_weight = np.minimum(normalized * 2.0, 1.0)[:, :, None]
    upper_weight = np.maximum(normalized * 2.0 - 1.0, 0.0)[:, :, None]
    lower = palette[0] * (1.0 - lower_weight) + palette[1] * lower_weight
    return lower * (1.0 - upper_weight) + palette[2] * upper_weight


def fit_design_layer(image: Image.Image, size: tuple[int, int]) -> np.ndarray:
    bounds = image.getbbox()

    if bounds is None:
        raise ValueError("armor design input has no visible bounds")

    cropped = image.crop(bounds)
    return np.asarray(cropped.resize(size, Image.Resampling.LANCZOS), dtype=np.uint8)


def shade_design(design_rgb: np.ndarray, target_luminance: np.ndarray) -> np.ndarray:
    design = design_rgb.astype(np.float32)
    design_luminance = color_luminance(design.reshape(-1, 3)).reshape(design.shape[:2])
    desired = 0.58 * design_luminance + 0.42 * target_luminance
    scale = desired / np.maximum(8.0, design_luminance)
    return np.clip(design * scale[:, :, None], 0.0, 255.0)


def transfer_design(reference: Image.Image, promoted: Image.Image, source: Image.Image) -> Image.Image:
    reference_pixels = np.asarray(reference.convert("RGBA"), dtype=np.uint8)
    reference_alpha = reference_pixels[:, :, 3]
    bounds = reference.getchannel("A").getbbox()

    if bounds is None:
        raise ValueError("reference armor variant has no alpha bounds")

    left, top, right, bottom = bounds
    fit_size = (right - left, bottom - top)
    palette = representative_palette(promoted, source)
    output_rgb = recolor_reference(reference_pixels, palette)
    reference_luminance = color_luminance(output_rgb.reshape(-1, 3)).reshape(reference.height, reference.width)

    promoted_fit = fit_design_layer(promoted, fit_size)
    source_fit = fit_design_layer(source, fit_size)

    for fitted, strength in [(promoted_fit, 0.82), (source_fit, 0.16)]:
        region = output_rgb[top:bottom, left:right]
        region_luminance = reference_luminance[top:bottom, left:right]
        shaded = shade_design(fitted[:, :, :3], region_luminance)
        weight = fitted[:, :, 3:4].astype(np.float32) / 255.0 * strength
        output_rgb[top:bottom, left:right] = region * (1.0 - weight) + shaded * weight

    output = np.zeros_like(reference_pixels)
    output[:, :, :3] = np.clip(output_rgb, 0.0, 255.0).astype(np.uint8)
    output[:, :, 3] = reference_alpha
    return Image.fromarray(output, "RGBA")


def build_audited_target(
    category: str,
    geometry_profile: str,
    raw_reference: Image.Image,
    point: tuple[int, int],
    doll_type: int,
    coverage_profiles: dict[str, CoverageProfileDefinition],
    foot_exclusion_masks: dict[int, np.ndarray],
    silhouette_adjustment: str = "",
) -> tuple[Image.Image, dict[str, int | str | None]]:
    target = raw_reference.convert("RGBA")
    coverage_excluded = 0
    foot_excluded = 0
    profile_excluded = 0
    profile_added = 0
    silhouette_excluded = 0
    lower_detached_excluded = 0

    if category == "Armor":
        profile = coverage_profiles[geometry_profile]
        target, coverage_excluded = apply_coverage_profile(target, point, doll_type, profile)
        target, foot_excluded = apply_foot_exclusion(target, point, foot_exclusion_masks[doll_type])
        overlap = alpha_overlap_count(target, point, foot_exclusion_masks[doll_type])

        if overlap != 0:
            raise ValueError(f"armor target {doll_type} overlaps its footwear/foot exclusion")
    elif category == "Helm" and geometry_profile == "unique_face_mask":
        pixels = np.asarray(target, dtype=np.uint8).copy()
        original_alpha = pixels[:, :, 3] > 0

        if not np.any(original_alpha):
            raise ValueError("unique face-mask reference has no alpha")

        permitted = normalized_polygon_mask(target.size, UNIQUE_FACE_MASK_POLYGON)
        clipped_alpha = original_alpha & permitted
        row_widths = np.count_nonzero(clipped_alpha, axis=1)
        body_width = int(row_widths.max())
        dome_threshold = max(3, round(body_width * 0.35))
        dome_rows = np.where(row_widths >= dome_threshold)[0]

        if len(dome_rows) == 0:
            raise ValueError("unique face-mask reference has no central helmet body")

        dome_start = int(dome_rows[0])
        dome_xs = np.where(clipped_alpha[dome_start])[0]
        dome_center_x = (int(dome_xs[0]) + int(dome_xs[-1])) / 2.0
        dome_half_width = (int(dome_xs[-1]) - int(dome_xs[0]) + 1) / 2.0
        cap_height = min(dome_start, max(2, round(target.height * 0.07)))
        clipped_alpha[:dome_start] = False

        for cap_row in range(cap_height):
            normalized_y = (cap_row + 1) / cap_height
            half_width = dome_half_width * np.sqrt(1.0 - (1.0 - normalized_y) ** 2)
            y = dome_start - cap_height + cap_row
            left = max(0, int(np.floor(dome_center_x - half_width)))
            right = min(target.width, int(np.ceil(dome_center_x + half_width)) + 1)
            clipped_alpha[y, left:right] = True

        revised_alpha = fill_interior_transparency(clipped_alpha)
        profile_excluded = int(np.count_nonzero(original_alpha & ~revised_alpha))
        profile_added = int(np.count_nonzero(revised_alpha & ~original_alpha))
        pixels[:, :, 3][~revised_alpha] = 0
        pixels[:, :, :3][revised_alpha & ~original_alpha] = (115, 115, 115)
        pixels[:, :, 3][revised_alpha] = 255
        target = Image.fromarray(pixels, "RGBA")
    elif category == "Helm" and geometry_profile == "hornless_round_helm":
        pixels = np.asarray(target, dtype=np.uint8).copy()
        original_alpha = pixels[:, :, 3] > 0
        bounds = target.getchannel("A").getbbox()

        if bounds is None:
            raise ValueError("hornless round-helm reference has no alpha")

        left, top, right, bottom = bounds
        center_x = (left + right - 1) / 2.0
        reference_width = right - left
        upper_bottom = top + max(1, round((bottom - top) * 0.36))
        alpha_image = Image.fromarray((original_alpha * 255).astype(np.uint8), "L")
        opened = np.asarray(
            alpha_image.filter(ImageFilter.MinFilter(9)).filter(ImageFilter.MaxFilter(9)),
            dtype=np.uint8,
        ) > 0
        revised_alpha = original_alpha.copy()
        revised_alpha[top:upper_bottom] &= opened[top:upper_bottom]
        brow_row = None

        for y in range(top, bottom):
            row_xs = np.where(revised_alpha[y])[0]

            if len(row_xs) < round(reference_width * 0.75):
                continue

            if np.all(revised_alpha[y, int(row_xs.min()):int(row_xs.max()) + 1]):
                brow_row = y
                break

        if brow_row is None:
            raise ValueError("hornless round-helm reference has no continuous brow row")

        for y in range(top, brow_row):
            row_xs = np.where(revised_alpha[y])[0]

            if len(row_xs) == 0:
                continue

            row_runs: list[tuple[int, int]] = []
            run_left = int(row_xs[0])
            run_right = run_left

            for x in row_xs[1:]:
                x = int(x)

                if x != run_right + 1:
                    row_runs.append((run_left, run_right))
                    run_left = x

                run_right = x

            row_runs.append((run_left, run_right))
            central_left, central_right = min(
                row_runs,
                key=lambda run: 0.0 if run[0] <= center_x <= run[1] else min(
                    abs(center_x - run[0]), abs(center_x - run[1])
                ),
            )
            half_width = min(center_x - central_left, central_right - center_x)
            keep_left = max(left, int(np.ceil(center_x - half_width)))
            keep_right = min(right, int(np.floor(center_x + half_width)) + 1)
            revised_alpha[y, :keep_left] = False
            revised_alpha[y, keep_right:] = False

        envelope_bottom = top + max(1, round((bottom - top) * 0.68))

        for y in range(top, min(bottom, envelope_bottom)):
            normalized_y = (y - top) / max(1, bottom - top - 1)
            max_half_width = reference_width * (0.24 + normalized_y * 0.30)
            keep_left = max(left, int(np.ceil(center_x - max_half_width)))
            keep_right = min(right, int(np.floor(center_x + max_half_width)) + 1)
            revised_alpha[y, :keep_left] = False
            revised_alpha[y, keep_right:] = False

        profile_excluded = int(np.count_nonzero(original_alpha & ~revised_alpha))

        if profile_excluded == 0:
            raise ValueError("hornless round-helm profile did not remove reference geometry")

        pixels[:, :, 3][~revised_alpha] = 0
        target = Image.fromarray(pixels, "RGBA")
    elif category == "Helm" and geometry_profile == "soft_cap":
        original = np.asarray(target, dtype=np.uint8)
        original_alpha = original[:, :, 3] > 0
        bounds = target.getchannel("A").getbbox()

        if bounds is None:
            raise ValueError("soft-cap reference has no alpha")

        left, top, right, bottom = bounds
        cap_width = right - left
        cap_height = bottom - top
        tail_length = max(10, round(cap_height * 1.20))
        expanded_height = max(target.height, bottom + tail_length + 2)
        pixels = np.zeros((expanded_height, target.width, 4), dtype=np.uint8)
        pixels[:target.height] = original
        tail = Image.new("L", (target.width, expanded_height), 0)
        draw = ImageDraw.Draw(tail)
        start = (left + round(cap_width * 0.15), top + round(cap_height * 0.58))
        upper = (left + round(cap_width * 0.04), bottom + round(tail_length * 0.20))
        middle = (left + round(cap_width * 0.13), bottom + round(tail_length * 0.55))
        end = (left + round(cap_width * 0.05), bottom + tail_length)
        base_width = max(4, round(cap_width * 0.18))
        draw.line((start, upper), fill=255, width=base_width, joint="curve")
        draw.line((upper, middle), fill=255, width=max(3, base_width - 1), joint="curve")
        draw.line((middle, end), fill=255, width=max(2, base_width - 3), joint="curve")
        expanded_original_alpha = np.zeros((expanded_height, target.width), dtype=bool)
        expanded_original_alpha[:target.height] = original_alpha
        tail_alpha = np.asarray(tail, dtype=np.uint8) > 0
        revised_alpha = expanded_original_alpha | tail_alpha
        added_alpha = revised_alpha & ~expanded_original_alpha
        profile_added = int(np.count_nonzero(added_alpha))

        if profile_added == 0:
            raise ValueError("soft-cap profile did not add its hanging tail")

        pixels[:, :, :3][added_alpha] = (115, 115, 115)
        pixels[:, :, 3][revised_alpha] = 255
        target = Image.fromarray(pixels, "RGBA")
    elif category == "Helm" and geometry_profile == "chain_hood":
        pixels = np.asarray(target, dtype=np.uint8).copy()
        original_alpha = pixels[:, :, 3] > 0
        bounds = target.getchannel("A").getbbox()

        if bounds is None:
            raise ValueError("chain-hood reference has no alpha")

        left, top, right, bottom = bounds
        cap_top = top + max(2, (bottom - top) // 8)
        dome_bottom = top + max(4, (bottom - top) * 2 // 5)
        center_x = (left + right - 1) / 2.0
        radius_x = max(2.0, (right - left) * 0.34)
        center_y = dome_bottom + 3
        radius_y = max(2.0, float(center_y - cap_top + 2))
        pixels[top:dome_bottom, :, 3] = 0

        for y in range(cap_top, dome_bottom):
            normalized_y = (y - center_y) / radius_y
            half_width = radius_x * np.sqrt(max(0.0, 1.0 - normalized_y * normalized_y))
            row_left = max(0, int(np.floor(center_x - half_width)))
            row_right = min(target.width, int(np.ceil(center_x + half_width)) + 1)
            pixels[y, row_left:row_right, :3] = (115, 115, 115)
            pixels[y, row_left:row_right, 3] = 255

        revised_alpha = pixels[:, :, 3] > 0
        face_component = largest_interior_transparent_component(revised_alpha)
        face_ys, _face_xs = np.where(face_component)
        face_top = max(top, int(face_ys.min()) - 4)
        face_bottom = int(face_ys.max()) + 1
        rows_with_face = [y for y in range(face_top, face_bottom) if np.any(face_component[y])]

        for y in range(face_top, face_bottom):
            source_y = min(rows_with_face, key=lambda candidate: abs(candidate - y))
            row_xs = np.where(face_component[source_y])[0]
            row_left = max(0, int(row_xs.min()) - 1)
            row_right = min(target.width, int(row_xs.max()) + 2)
            pixels[y, row_left:row_right, :3] = 0
            pixels[y, row_left:row_right, 3] = 0

        revised_alpha = pixels[:, :, 3] > 0
        profile_excluded = int(np.count_nonzero(original_alpha & ~revised_alpha))
        profile_added = int(np.count_nonzero(revised_alpha & ~original_alpha))
        target = Image.fromarray(pixels, "RGBA")
    elif category == "Helm" and geometry_profile == "conical_helm":
        pixels = np.asarray(target, dtype=np.uint8).copy()
        original_alpha = pixels[:, :, 3] > 0

        if not np.any(original_alpha):
            raise ValueError("conical-helm reference has no alpha")

        face_opening = largest_interior_transparent_component(original_alpha)
        face_ys, _face_xs = np.where(face_opening)

        if len(face_ys) == 0:
            raise ValueError("conical-helm reference has no enclosed face opening")

        face_top = int(face_ys.min())
        revised_alpha = np.zeros_like(original_alpha)

        for y in range(face_top):
            row_xs = np.where(original_alpha[y])[0]

            if len(row_xs) == 0:
                continue

            revised_alpha[y, int(row_xs.min()):int(row_xs.max()) + 1] = True

        profile_excluded = int(np.count_nonzero(original_alpha & ~revised_alpha))
        profile_added = int(np.count_nonzero(revised_alpha & ~original_alpha))

        if profile_excluded == 0:
            raise ValueError("conical-helm profile did not remove lower hood geometry")

        pixels[:, :, 3][~revised_alpha] = 0
        pixels[:, :, :3][revised_alpha & ~original_alpha] = (115, 115, 115)
        pixels[:, :, 3][revised_alpha] = 255
        target = Image.fromarray(pixels, "RGBA")
    elif category == "Helm" and geometry_profile == "closed_conical_helm":
        pixels = np.asarray(target, dtype=np.uint8).copy()
        original_alpha = pixels[:, :, 3] > 0

        if not np.any(original_alpha):
            raise ValueError("closed conical-helm reference has no alpha")

        face_opening = largest_interior_transparent_component(original_alpha)
        revised_alpha = original_alpha | face_opening
        profile_added = int(np.count_nonzero(face_opening))

        if profile_added == 0:
            raise ValueError("closed conical-helm profile did not close the reference face opening")

        pixels[:, :, :3][face_opening] = (115, 115, 115)
        pixels[:, :, 3][revised_alpha] = 255
        target = Image.fromarray(pixels, "RGBA")
    elif category == "Boots" and geometry_profile in {"ankle_only_footwear", "low_ankle_boots"}:
        pixels = np.asarray(target, dtype=np.uint8).copy()
        original_alpha = pixels[:, :, 3] > 0

        if not np.any(original_alpha):
            raise ValueError(f"{geometry_profile} reference has no alpha")

        foot_masks = ankle_only_foot_masks(target.size, doll_type)
        permitted = np.logical_or.reduce(foot_masks)

        for foot_index, foot_mask in enumerate(foot_masks, start=1):
            if not np.any(original_alpha & foot_mask):
                raise ValueError(
                    f"{geometry_profile} reference has no alpha in foot region {foot_index} for doll type {doll_type}"
                )

        revised_alpha = original_alpha & permitted
        profile_excluded = int(np.count_nonzero(original_alpha & ~revised_alpha))
        pixels[:, :, 3][~revised_alpha] = 0
        target = Image.fromarray(pixels, "RGBA")

    if silhouette_adjustment == "smooth_upper_protrusions":
        pixels = np.asarray(target.convert("RGBA"), dtype=np.uint8).copy()
        original_alpha = pixels[:, :, 3] > 0
        bounds = target.getchannel("A").getbbox()

        if bounds is None:
            raise ValueError("upper-protrusion smoothing reference has no alpha")

        _left, top, _right, bottom = bounds
        upper_bottom = top + max(1, round((bottom - top) * 0.36))
        alpha_image = Image.fromarray((original_alpha * 255).astype(np.uint8), "L")
        opened = np.asarray(
            alpha_image.filter(ImageFilter.MinFilter(9)).filter(ImageFilter.MaxFilter(9)),
            dtype=np.uint8,
        ) > 0
        revised_alpha = original_alpha.copy()
        revised_alpha[top:upper_bottom] &= opened[top:upper_bottom]
        lower_component_cutoff = top + round((bottom - top) * 0.72)
        revised_alpha, lower_detached_excluded = remove_lower_detached_components(
            revised_alpha,
            lower_component_cutoff,
        )
        silhouette_excluded = int(np.count_nonzero(original_alpha & ~revised_alpha))

        if silhouette_excluded == 0:
            raise ValueError("upper-protrusion smoothing did not change the selected silhouette")

        pixels[:, :, 3][~revised_alpha] = 0
        target = Image.fromarray(pixels, "RGBA")
    elif silhouette_adjustment:
        raise ValueError(f"unsupported silhouette adjustment {silhouette_adjustment!r}")

    if target.getchannel("A").getbbox() is None:
        raise ValueError(f"{category} {geometry_profile} produced an empty target")

    return target, {
        "geometry_profile": geometry_profile,
        "coverage_excluded_alpha_pixels": coverage_excluded,
        "foot_excluded_alpha_pixels": foot_excluded,
        "profile_excluded_alpha_pixels": profile_excluded,
        "profile_added_alpha_pixels": profile_added,
        "silhouette_adjustment": silhouette_adjustment or None,
        "silhouette_excluded_alpha_pixels": silhouette_excluded,
        "lower_detached_excluded_alpha_pixels": lower_detached_excluded,
    }


def write_tsv(path: Path, rows: list[list[str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)

    with path.open("w", encoding="utf-8", newline="") as output_file:
        writer = csv.writer(output_file, delimiter="\t", lineterminator="\n")
        writer.writerows(rows)


def write_yaml(path: Path, document: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(yaml.safe_dump(document, sort_keys=False, width=120), encoding="utf-8")


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mapping", type=Path, default=DEFAULT_MAPPING)
    parser.add_argument("--foot-exclusions", type=Path, default=DEFAULT_FOOT_EXCLUSIONS)
    parser.add_argument("--authored-art-manifest", type=Path, default=DEFAULT_AUTHORED_ART_MANIFEST)
    parser.add_argument("--source-root", type=Path, default=DEFAULT_SOURCE_ROOT)
    parser.add_argument("--world-root", type=Path, default=DEFAULT_WORLD_ROOT)
    parser.add_argument("--inventory-icon-root", type=Path, default=DEFAULT_WORLD_ROOT / "icons")
    parser.add_argument("--staging-root", type=Path, default=DEFAULT_STAGING_ROOT)
    parser.add_argument("--item-id", action="append", type=int, help="global item id; may be repeated")
    parser.add_argument("--category", choices=sorted(EQUIPMENT_CATEGORIES))
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--verify-only", action="store_true", help="validate accepted and active art without writes")
    mode.add_argument("--promote", action="store_true", help="promote complete accepted families atomically")
    return parser.parse_args()


def equipment_table_rows(
    items: dict[int, EquipmentItem],
    mappings: dict[int, EquipmentMapping],
    complex_offsets: dict[int, tuple[tuple[int, int], ...]],
) -> list[list[str]]:
    rows: list[list[str]] = []
    row_id = 1

    for category in ["Armor", "Helm", "Boots", "Belt"]:
        rows.extend([
            ["", "", f"MM9 {category}", "Settings", "t0", "", "t1", "", "t2", "", "t3", "",
             "t4", "", "t5", ""],
            ["Id", "Item id", "Notes", "", "X", "Y", "X", "Y", "X", "Y", "X", "Y", "X", "Y",
             "X", "Y"],
        ])

        for raw_id in sorted(raw_id for raw_id, item in items.items() if item.category == category):
            item = items[raw_id]
            mapping = mappings[raw_id]
            points = complex_offsets.get(mapping.reference_item_id)

            if points is None:
                raise ValueError(f"reference item {mapping.reference_item_id} has no complex-picture row")

            point_cells = [str(coordinate) for point in points for coordinate in point]
            rows.append([str(row_id), str(item.item_id), item.name, category, *point_cells])
            row_id += 1

    return rows


def selected_raw_ids(
    arguments: argparse.Namespace,
    items: dict[int, EquipmentItem],
) -> list[int]:
    requested_ids = set(arguments.item_id or [])
    known_item_ids = {item.item_id for item in items.values()}
    unknown = requested_ids - known_item_ids

    if unknown:
        raise ValueError(f"unknown MM9 equipment item ids: {sorted(unknown)}")

    result = []

    for raw_id, item in sorted(items.items()):
        if requested_ids and item.item_id not in requested_ids:
            continue
        if arguments.category is not None and item.category != arguments.category:
            continue
        result.append(raw_id)

    if not result:
        raise ValueError("selection contains no MM9 equipment")

    return result


def validate_active_outputs(
    world_root: Path,
    items: dict[int, EquipmentItem],
    accepted: dict[tuple[int, str], AuthoredEquipmentVariant],
) -> None:
    expected_count = sum(len(expected_suffixes(item.category)) for item in items.values())

    if len(accepted) != expected_count:
        raise ValueError(f"accepted variant count is {len(accepted)}, expected {expected_count}")

    offsets = paperdoll.read_complex_picture_offsets(world_root / "data_tables/complex_item_pictures.txt")

    if set(offsets) != {item.item_id for item in items.values()}:
        raise ValueError("active MM9 complex-picture table does not exactly cover the 68 mapped items")

    for raw_id, item in items.items():
        for suffix in expected_suffixes(item.category):
            authored = accepted[(raw_id, suffix)]
            active_path = world_root / "icons" / f"{item.icon_name}{suffix}.png"

            if not active_path.is_file() or sha256_file(active_path) != authored.content_sha256:
                raise ValueError(f"active output mismatch for {item.item_id} {suffix}")


def main() -> int:
    arguments = parse_arguments()
    mm9_items = read_equipment_items(paperdoll.MM9_TABLE_ROOT / "items.txt")
    mappings = load_mappings(arguments.mapping, mm9_items)
    foot_exclusion_definitions = load_foot_exclusions(arguments.foot_exclusions)
    coverage_profiles = load_coverage_profiles(arguments.foot_exclusions)
    authored_variants = load_authored_art_manifest(arguments.authored_art_manifest, mm9_items)
    engine_items = paperdoll.read_items(paperdoll.ENGINE_TABLE_ROOT / "items.txt", "engine")
    engine_assets = paperdoll.AssetIndex([paperdoll.ENGINE_ICON_ROOT])
    complex_offsets = paperdoll.read_complex_picture_offsets(
        paperdoll.ENGINE_TABLE_ROOT / "complex_item_pictures.txt"
    )
    character_dolls = paperdoll.read_character_dolls(paperdoll.ENGINE_TABLE_ROOT / "character_data.txt")
    foot_exclusion_masks = build_foot_exclusion_masks(
        foot_exclusion_definitions,
        engine_items,
        engine_assets,
        complex_offsets,
        character_dolls,
    )
    source_index = build_case_insensitive_file_index(arguments.source_root)

    if arguments.verify_only:
        validate_active_outputs(arguments.world_root, mm9_items, authored_variants)
        print("verified 68 MM9 equipment families and 488 accepted active variants")
        return 0

    chosen_raw_ids = selected_raw_ids(arguments, mm9_items)
    output_root = arguments.world_root if arguments.promote else arguments.staging_root
    icon_root = output_root / "icons"
    target_root = output_root / "targets"
    records = []

    if arguments.promote:
        selection_is_explicit = bool(arguments.item_id) or arguments.category is not None
        incomplete = [] if not selection_is_explicit else [
            mm9_items[raw_id].item_id
            for raw_id in chosen_raw_ids
            if any(
                (raw_id, suffix) not in authored_variants
                for suffix in expected_suffixes(mm9_items[raw_id].category)
            )
        ]

        if incomplete:
            raise ValueError(f"cannot promote incomplete item families: {incomplete}")

        chosen_raw_ids = sorted({raw_id for raw_id, _suffix in authored_variants})

    for raw_id in chosen_raw_ids:
        item = mm9_items[raw_id]
        mapping = mappings[raw_id]
        reference_item = engine_items.get(mapping.reference_item_id)
        reference_points = complex_offsets.get(mapping.reference_item_id)

        if reference_item is None or reference_item.equip_stat != item.category:
            raise ValueError(f"raw equipment {raw_id} references incompatible item {mapping.reference_item_id}")
        if reference_points is None:
            raise ValueError(f"reference equipment {mapping.reference_item_id} has no complex-picture row")

        promoted_path = arguments.inventory_icon_root / f"{item.icon_name}.png"
        source_path = source_index.get(Path(item.source_icon_path).name.casefold())

        if not promoted_path.is_file():
            raise ValueError(f"raw equipment {raw_id} is missing promoted inventory image {promoted_path}")
        if source_path is None:
            raise ValueError(f"raw equipment {raw_id} is missing source PCX {item.source_icon_path!r}")

        promoted = Image.open(promoted_path).convert("RGBA")
        source = source_content_image(source_path)
        palette = representative_palette(promoted, source)
        variant_records = []

        for suffix in expected_suffixes(item.category):
            doll_type = int(suffix[1]) - 1
            reference_name = f"{reference_item.icon_name}{suffix}"
            reference_path = engine_assets.find(reference_name)

            if reference_path is None:
                raise ValueError(f"reference equipment {mapping.reference_item_id} is missing {reference_name}")

            raw_reference = paperdoll.load_layer(reference_path, color_key=True)
            target, geometry_record = build_audited_target(
                item.category,
                mapping.geometry_profile,
                raw_reference,
                reference_points[doll_type],
                doll_type,
                coverage_profiles,
                foot_exclusion_masks,
                mapping.silhouette_adjustment,
            )
            authored_variant = authored_variants.get((raw_id, suffix))

            if arguments.promote:
                if authored_variant is None:
                    raise ValueError(f"raw equipment {raw_id} {suffix} is not accepted")

                fitted = Image.open(authored_variant.asset_path).convert("RGBA")
                target = Image.open(authored_variant.target_mask_path).convert("RGBA")

                if fitted.size != target.size or fitted.getchannel("A").tobytes() != target.getchannel("A").tobytes():
                    raise ValueError(f"raw equipment {raw_id} {suffix} does not match its accepted target")

                output_path = icon_root / f"{item.icon_name}{suffix}.png"
                output_path.parent.mkdir(parents=True, exist_ok=True)
                temporary_path = output_path.with_suffix(".png.new")
                shutil.copyfile(authored_variant.asset_path, temporary_path)
                temporary_path.replace(output_path)
                visual_source = "accepted_authored_equipment"
            else:
                fitted_pixels = np.asarray(target.convert("RGBA"), dtype=np.uint8).copy()
                fitted_pixels[:, :, :3] = recolor_reference(fitted_pixels, palette)
                fitted = Image.fromarray(fitted_pixels, "RGBA")
                output_path = icon_root / f"{item.icon_name}{suffix}.png"
                output_path.parent.mkdir(parents=True, exist_ok=True)
                fitted.save(output_path, optimize=False)
                target_path = target_root / f"{item.icon_name}{suffix}.png"
                target_path.parent.mkdir(parents=True, exist_ok=True)
                target.save(target_path, optimize=False)
                visual_source = "staged_legacy_geometry_palette_candidate"

            variant_record = {
                "suffix": suffix,
                "output": output_path.as_posix(),
                "output_sha256": sha256_file(output_path),
                "width": fitted.width,
                "height": fitted.height,
                "reference_asset": reference_path.relative_to(REPOSITORY_ROOT).as_posix(),
                "reference_asset_sha256": sha256_file(reference_path),
                "raw_reference_alpha_sha256": sha256_bytes(raw_reference.getchannel("A").tobytes()),
                "audited_target_alpha_sha256": sha256_bytes(target.getchannel("A").tobytes()),
                "visual_source": visual_source,
                **geometry_record,
            }
            variant_records.append(variant_record)

        records.append({
            "raw_mm9_id": raw_id,
            "item_id": item.item_id,
            "name": item.name,
            "category": item.category,
            "source_pcx": source_path.relative_to(REPOSITORY_ROOT).as_posix(),
            "source_pcx_sha256": sha256_file(source_path),
            "promoted_inventory_image": promoted_path.relative_to(REPOSITORY_ROOT).as_posix(),
            "promoted_inventory_sha256": sha256_file(promoted_path),
            "reference_item_id": mapping.reference_item_id,
            "reference_world": mapping.reference_world,
            "geometry_profile": mapping.geometry_profile,
            "transfer_focus": mapping.transfer_focus,
            "paperdoll_offsets": [list(point) for point in reference_points],
            "variants": variant_records,
        })

    write_tsv(
        output_root / "data_tables/complex_item_pictures.txt",
        equipment_table_rows(mm9_items, mappings, complex_offsets),
    )
    write_yaml(output_root / "state/item_body_equipment_visuals.yml", {
        "format_version": 2,
        "generator": "tools/mm9_import_discovery/generate_mm9_equipment_variants.py",
        "mode": "promotion" if arguments.promote else "staging",
        "mapping": arguments.mapping.relative_to(REPOSITORY_ROOT).as_posix(),
        "mapping_sha256": sha256_file(arguments.mapping),
        "foot_exclusion_overlay": arguments.foot_exclusions.relative_to(REPOSITORY_ROOT).as_posix(),
        "items": records,
    })
    variant_count = sum(len(record["variants"]) for record in records)
    verb = "promoted" if arguments.promote else "staged"
    print(f"{verb} {len(records)} equipment families and {variant_count} fitted variants")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
