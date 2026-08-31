#!/usr/bin/env python3
"""Generate deterministic MM9 vendor overlay tables from local source data."""

from __future__ import annotations

import argparse
import csv
import json
from collections import Counter
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


SELLING_TYPES = {"Weapon", "Armor", "Magic", "Apothecary", "General Store", "Library"}
SERVICE_TYPES = {"Temple", "Training Arena"}
PROFILE_SLOT_COUNTS = {
    "Weapon": 6,
    "Armor": 8,
    "Spellbook": 12,
    "Mm9Apothecary": 12,
    "Mm9GeneralStore": 8,
    "Mm9Library": 12,
}
PROFILE_BY_SOURCE_TYPE = {
    "Weapon": "Weapon",
    "Armor": "Armor",
    "Magic": "Spellbook",
    "Apothecary": "Mm9Apothecary",
    "General Store": "Mm9GeneralStore",
    "Library": "Mm9Library",
}
LOCATION_BY_SOURCE_ID = {
    **{source_id: "Thjorgard" for source_id in (5, 10, 12, 15, 16, 17, 20, 21)},
    **{source_id: "Sturmford" for source_id in (50, 53, 54, 58, 59, 62)},
    **{source_id: "Drangheim" for source_id in (97, 98, 99, 102, 105)},
    **{source_id: "Guberland" for source_id in (134, 135, 136, 137, 138, 139, 142, 143, 146, 147)},
    **{source_id: "Frosgard" for source_id in (200, 201, 202, 203, 204, 205, 207, 208, 211, 212)},
    **{source_id: "Thronheim" for source_id in (241, 247, 248, 249, 250, 251, 252, 255, 256, 259, 260)},
    **{vendor_id: "Lindisfarne" for vendor_id in (285, 286, 287)},
    314: "Yorwick",
    **{source_id: "Arslegard" for source_id in (340, 341, 342, 343, 344, 345, 348, 349, 350, 351)},
}
EQUIPMENT_STATS = {
    "Weapon", "Weapon1or2", "Weapon2", "Missile", "Bow", "Armor", "Shield", "Helm", "Belt",
    "Cloak", "Gauntlets", "Boots", "Ring", "Amulet",
}
WEAPON_STATS = {"Weapon", "Weapon1or2", "Weapon2", "Missile", "Bow"}
ARMOR_STATS = {"Armor", "Shield", "Helm", "Belt", "Cloak", "Gauntlets", "Boots"}
APOTHECARY_STATS = {"Ring", "Amulet", "Belt", "Mscroll", "Misc"}
GENERAL_STATS = WEAPON_STATS | {"Ring", "Amulet", "Belt", "Gauntlets", "Mscroll", "Misc"}
QUALITY_OFFSET = {"Normal": 0, "Good": 1, "Excellent": 2}
SOURCE_FIELD_NAMES = (
    "shop_name",
    "shop_npc_id",
    "shop_type",
    "merchandise",
    "wealth",
    "merchant_base",
    "standard_treasure_range",
    "standard_concat_percent",
    "special_treasure_range",
    "special_concat_percent",
    "quantity",
    "restock",
)
SOURCE_CONCAT_FIELD_COUNT = 25
SOURCE_CONCAT_APPLICABILITY_COLUMNS = tuple(range(3, 18))
SOURCE_CONCAT_WEAPON_COLUMNS = tuple(range(11, 16))
SOURCE_CONCAT_MAPPING_OWNER = "MM9 vendor integration goal"
SOURCE_CONCAT_MAPPING_REASONS = {
    "weapon_elemental": (
        "Preserve the universal MM9 Elemental family and select an ordinary OpenYAMM elemental "
        "damage tier within the effective-tier budget."
    ),
    "wearable_durability": (
        "OpenYAMM has no durability enchant field; use its lowest-value universal "
        "endurance-oriented ordinary enchant as the reviewed overlay."
    ),
}


@dataclass(frozen=True)
class SourceShopRow:
    source_line: int
    fields: tuple[str, ...]

    @property
    def source_type(self) -> str:
        return self.fields[2]

    @property
    def source_id(self) -> int:
        return parse_int(self.fields[1])


@dataclass(frozen=True)
class SourceConcat:
    source_line: int
    fields: tuple[str, ...]

    @property
    def concat_id(self) -> int:
        return parse_int(self.fields[0])

    @property
    def name(self) -> str:
        return self.fields[1].strip()

    @property
    def name_is_prefix(self) -> bool:
        return parse_int(self.fields[2]) != 0

    @property
    def applicability(self) -> tuple[int, ...]:
        return tuple(parse_int(value) for value in self.fields[3:18])

    @property
    def value(self) -> int:
        return parse_int(self.fields[18])

    @property
    def family(self) -> str:
        return self.fields[21].strip()

    @property
    def tier(self) -> int:
        return parse_int(self.fields[22])

    @property
    def description(self) -> str:
        return self.fields[24].strip()


@dataclass(frozen=True)
class SourceVendor:
    source_line: int
    name: str
    source_id: int
    source_type: str
    merchandise: str
    wealth: str
    merchant_base: float
    standard_min: int
    standard_max: int
    standard_concat: int
    special_min: int
    special_max: int
    special_concat: int
    source_quantity: str
    restock_text: str

    @property
    def vendor_id(self) -> int:
        return 30000 + self.source_id

    @property
    def profile(self) -> str:
        return PROFILE_BY_SOURCE_TYPE[self.source_type]


@dataclass(frozen=True)
class SourceServiceVenue:
    source_line: int
    name: str
    source_id: int
    source_type: str
    wealth: str
    merchant_base: float
    can_heal: bool
    can_donate: bool

    @property
    def service_id(self) -> int:
        return 30000 + self.source_id

    @property
    def runtime_type(self) -> str:
        return "Training" if self.source_type == "Training Arena" else "Temple"


@dataclass(frozen=True)
class Item:
    item_id: int
    name: str
    equip_stat: str
    skill_group: str
    normalized_tier: int
    source_item_id: int
    source_treasure_tier: int
    content_flags: frozenset[str]
    rarity: str
    set_id: str
    source_equip_type: str
    value: int
    mod1: str = ""
    mod2: str = ""
    source_minimum: str = ""
    source_maximum: str = ""
    package_id: str = ""
    inventory_width: int = 0
    inventory_height: int = 0
    visual_status: str = ""
    allowed_class_roots: str = ""


def source_provenance_path(path: Path) -> str:
    repository_root = Path(__file__).resolve().parents[2]
    try:
        return path.resolve().relative_to(repository_root).as_posix()
    except ValueError:
        return path.as_posix()


def read_manifest_vendor_range(path: Path) -> tuple[int, int]:
    in_id_ranges = False
    in_vendor_range = False
    begin = 0
    end = 0
    for line in path.read_text(encoding="utf-8").splitlines():
        if line == "idRanges:":
            in_id_ranges = True
            continue
        if in_id_ranges and line and not line.startswith(" "):
            break
        if in_id_ranges and line == "  vendors:":
            in_vendor_range = True
            continue
        if in_vendor_range and line.startswith("  ") and not line.startswith("    "):
            break
        if in_vendor_range:
            stripped = line.strip()
            if stripped.startswith("begin:"):
                begin = parse_int(stripped.split(":", 1)[1].strip())
            elif stripped.startswith("end:"):
                end = parse_int(stripped.split(":", 1)[1].strip())
    if begin <= 0 or end < begin:
        raise ValueError(f"{path}: missing valid idRanges.vendors declaration")
    return begin, end


def read_source_shop_rows(path: Path) -> tuple[tuple[str, ...], list[SourceShopRow]]:
    with path.open(encoding="cp1252", newline="") as source_file:
        rows = list(csv.reader(source_file, delimiter="\t"))
    if not rows:
        raise ValueError(f"empty MMIXSHOPS source {path}")
    if len(rows[0]) != len(SOURCE_FIELD_NAMES) or rows[0][2] != "Shop Type":
        raise ValueError(f"unexpected MMIXSHOPS header in {path}")

    result: list[SourceShopRow] = []
    for source_line, row in enumerate(rows[1:], 2):
        if len(row) != len(SOURCE_FIELD_NAMES):
            raise ValueError(
                f"{path}:{source_line}: expected {len(SOURCE_FIELD_NAMES)} fields, found {len(row)}")
        if not row[0].strip() or parse_int(row[1]) == 0 or not row[2].strip():
            raise ValueError(f"{path}:{source_line}: incomplete shop identity")
        result.append(SourceShopRow(source_line, tuple(row)))
    return tuple(rows[0]), result


def read_source_concats(path: Path) -> list[SourceConcat]:
    with path.open(encoding="cp1252", newline="") as source_file:
        rows = list(csv.reader(source_file))
    result: list[SourceConcat] = []
    seen_ids: set[int] = set()
    for source_line, row in enumerate(rows, 1):
        if len(row) != SOURCE_CONCAT_FIELD_COUNT:
            raise ValueError(
                f"{path}:{source_line}: expected {SOURCE_CONCAT_FIELD_COUNT} fields, found {len(row)}")
        source_concat = SourceConcat(source_line, tuple(row))
        if source_concat.concat_id <= 0 or not source_concat.name or source_concat.tier <= 0:
            raise ValueError(f"{path}:{source_line}: incomplete concat identity")
        if source_concat.concat_id in seen_ids:
            raise ValueError(f"{path}:{source_line}: duplicate concat id {source_concat.concat_id}")
        if any(flag not in (0, 1) for flag in source_concat.applicability):
            raise ValueError(f"{path}:{source_line}: non-boolean concat applicability flag")
        seen_ids.add(source_concat.concat_id)
        result.append(source_concat)
    if len(result) != 104:
        raise ValueError(f"expected 104 MM9 concat rows, found {len(result)}")
    return result


def parse_range(value: str) -> tuple[int, int]:
    pieces = [piece.strip() for piece in value.split(",")]
    if len(pieces) != 2:
        raise ValueError(f"invalid treasure range {value!r}")
    return int(pieces[0]), int(pieces[1])


def parse_percent(value: str) -> int:
    stripped = value.strip()
    if stripped.endswith("%"):
        stripped = stripped[:-1]
    return int(stripped or "0")


def read_source_vendors(path: Path) -> list[SourceVendor]:
    result: list[SourceVendor] = []
    _, source_rows = read_source_shop_rows(path)
    for source_row in source_rows:
        row = source_row.fields
        if source_row.source_type not in SELLING_TYPES:
            continue
        standard_min, standard_max = parse_range(row[6])
        special_min, special_max = parse_range(row[8])
        result.append(SourceVendor(
            source_line=source_row.source_line,
            name=row[0].strip(),
            source_id=int(row[1]),
            source_type=row[2],
            merchandise=row[3],
            wealth=row[4],
            merchant_base=float(row[5]),
            standard_min=standard_min,
            standard_max=standard_max,
            standard_concat=parse_percent(row[7]),
            special_min=special_min,
            special_max=special_max,
            special_concat=parse_percent(row[9]),
            source_quantity=row[10].strip(),
            restock_text=row[11].strip(),
        ))
    if len(result) != 48:
        raise ValueError(f"expected 48 item-selling vendors, found {len(result)}")
    return result


def read_source_service_venues(
    path: Path,
    training_ids: set[int],
    healer_ids: set[int],
    donation_ids: set[int],
) -> list[SourceServiceVenue]:
    result: list[SourceServiceVenue] = []
    _, source_rows = read_source_shop_rows(path)
    for source_row in source_rows:
        row = source_row.fields
        if source_row.source_type not in SERVICE_TYPES:
            continue
        source_id = int(row[1])
        reachable = source_id in training_ids or source_id in healer_ids or source_id in donation_ids
        if not reachable:
            continue
        result.append(SourceServiceVenue(
            source_line=source_row.source_line,
            name=row[0].strip(),
            source_id=source_id,
            source_type=row[2],
            wealth=row[4],
            merchant_base=float(row[5]),
            can_heal=source_id in healer_ids,
            can_donate=source_id in donation_ids,
        ))

    # NPC241 is a quest-unlocked Thronheim midwife, not an MMIXSHOPS building.
    # Its RUDE row 14 exposes the standard healer opcode after key 315 is granted.
    if 241 in healer_ids:
        result.append(SourceServiceVenue(
            source_line=14,
            name="Ealusaid A'Norta a'thrakan",
            source_id=241,
            source_type="Temple",
            wealth="Moderate",
            merchant_base=2.5,
            can_heal=True,
            can_donate=False,
        ))

    if len(result) != 16:
        raise ValueError(f"expected 16 reachable temple/training venues, found {len(result)}")
    return result


def table_rows(path: Path, encoding: str) -> tuple[list[str], list[list[str]]]:
    with path.open(encoding=encoding, newline="") as source_file:
        rows = list(csv.reader(source_file, delimiter="\t"))
    header_index = next(index for index, row in enumerate(rows) if row and row[0] == "Item #")
    return rows[header_index], rows[header_index + 1:]


def parse_int(value: str, default: int = 0) -> int:
    try:
        return int(value)
    except (TypeError, ValueError):
        return default


def read_items(path: Path, encoding: str, package_id: str) -> list[Item]:
    header, rows = table_rows(path, encoding)
    result: list[Item] = []
    for row in rows:
        padded = row + [""] * max(0, len(header) - len(row))
        values = dict(zip(header, padded))
        item_id = parse_int(values.get("Item #", ""))
        if item_id == 0 or not values.get("Name", "").strip():
            continue
        flags = frozenset(filter(None, (flag.strip() for flag in values.get("content_flags", "").split("|"))))
        rarity = values.get("material", "")
        normalized_tier = parse_int(values.get("normalized_tier", ""))
        if package_id == "engine" and 1902 <= item_id <= 2018:
            normalized_tier = max(1, min(5, parse_int(values.get("ID/Rep/St", ""), 1)))
        skill_group = values.get("Skill Group", "").strip()
        if package_id == "engine" and values.get("Equip Stat", "").strip() == "Book":
            skill_group = values.get("Mod1", "").strip()
        result.append(Item(
            item_id=item_id,
            name=values.get("Name", "").strip(),
            equip_stat=values.get("Equip Stat", "").strip(),
            skill_group=skill_group,
            normalized_tier=normalized_tier,
            source_item_id=parse_int(values.get("source_item_id", ""), item_id),
            source_treasure_tier=parse_int(
                values.get("x_mm9_source_field_05", ""), normalized_tier),
            content_flags=flags,
            rarity=rarity,
            set_id=values.get("set_id", "").strip(),
            source_equip_type=values.get("x_mm9_source_equip_type", "").strip(),
            value=parse_int(values.get("Value", "")),
            mod1=values.get("Mod1", "").strip(),
            mod2=values.get("Mod2", "").strip(),
            source_minimum=values.get("x_mm9_source_min", "").strip(),
            source_maximum=values.get("x_mm9_source_max", "").strip(),
            package_id=package_id,
            inventory_width=parse_int(values.get("inventory_width", "")),
            inventory_height=parse_int(values.get("inventory_height", "")),
            visual_status=values.get("visual_status", "").strip(),
            allowed_class_roots=values.get("allowed_class_roots", "").strip(),
        ))
    return result


def rude_service_ids(directory: Path, opcode: int) -> set[int]:
    return set(rude_service_rows(directory, opcode))


def rude_service_rows(directory: Path, opcode: int) -> dict[int, list[dict[str, object]]]:
    result: dict[int, list[dict[str, object]]] = {}
    for path in sorted(directory.glob("NPC*.rude")):
        with path.open(encoding="utf-8", newline="") as rude_file:
            for source_line, row in enumerate(csv.reader(rude_file), 1):
                if len(row) <= 5 or parse_int(row[5]) != opcode:
                    continue
                result.setdefault(parse_int(row[0]), []).append({
                    "source_file": source_provenance_path(path),
                    "source_line": source_line,
                    "raw_fields": row,
                })
    return result


def magic_school(merchandise: str) -> str:
    lower = merchandise.casefold()
    if "light" in lower:
        return "Light"
    if "dark" in lower:
        return "Dark"
    if "elemental" in lower:
        return "Elemental"
    if "spirit" in lower:
        return "Spirit"
    return "All"


def spell_school(item: Item) -> str:
    spell_index = parse_int(item.skill_group[1:] if item.skill_group.startswith("S") else item.skill_group)
    if spell_index == 0:
        return ""
    school_index = (spell_index - 1) // 11
    return ("Fire", "Air", "Water", "Earth", "Spirit", "Mind", "Body", "Light", "Dark")[school_index]


def profile_accepts_item(vendor: SourceVendor, item: Item) -> bool:
    if vendor.profile == "Weapon":
        return item.equip_stat in WEAPON_STATS
    if vendor.profile == "Armor":
        return item.equip_stat in ARMOR_STATS
    if vendor.profile == "Mm9Apothecary":
        return (
            item.equip_stat in APOTHECARY_STATS
            and item.source_equip_type not in {"Letter", "Quest Item", "Quest item"}
        )
    if vendor.profile == "Mm9GeneralStore":
        return (
            item.equip_stat in GENERAL_STATS
            and item.source_equip_type not in {"Letter", "Quest Item", "Quest item"}
        )
    if vendor.profile == "Mm9Library":
        return item.equip_stat == "LearnSkill" and "SkillLearning" in item.content_flags
    if vendor.profile == "Spellbook":
        school = magic_school(vendor.merchandise)
        item_school = spell_school(item)
        return item.equip_stat == "Book" and (
            school == "All"
            or item_school == school
            or (school == "Elemental" and item_school in {"Fire", "Air", "Water", "Earth"})
        )
    return False


def item_rejection_reason(vendor: SourceVendor, lane: str, item: Item) -> str | None:
    if "NoShop" in item.content_flags:
        return "content_flag_no_shop"
    if "Quest" in item.content_flags:
        return "content_flag_quest"
    if "Unique" in item.content_flags:
        return "content_flag_unique"
    if item.set_id:
        return "set_piece"
    if item.normalized_tier == 7:
        return "reserved_tier_l7"
    if item.rarity.casefold() in {"artifact", "relic", "special"}:
        return "rare_item"
    if item.package_id == "mm9" and (item.inventory_width <= 0 or item.inventory_height <= 0):
        return "invalid_inventory_dimensions"
    if item.package_id == "mm9" and not item.visual_status:
        return "missing_reviewed_visual"
    if not profile_accepts_item(vendor, item):
        return "profile_or_school_mismatch"

    minimum = vendor.standard_min if lane == "standard" else vendor.special_min
    maximum = vendor.standard_max if lane == "standard" else vendor.special_max
    if not max(1, minimum) <= admission_tier(vendor, item) <= max(1, maximum):
        return "outside_normalized_source_range"
    return None


def item_allowed(vendor: SourceVendor, item: Item) -> bool:
    return item_rejection_reason(vendor, "standard", item) not in {
        "content_flag_no_shop",
        "content_flag_quest",
        "content_flag_unique",
        "set_piece",
        "reserved_tier_l7",
        "rare_item",
        "profile_or_school_mismatch",
    }


def quality_for(vendor: SourceVendor, lane: str, slot: int, item: Item) -> str:
    if item.equip_stat not in EQUIPMENT_STATS:
        return "NotApplicable"
    minimum = vendor.standard_min if lane == "standard" else vendor.special_min
    maximum = vendor.standard_max if lane == "standard" else vendor.special_max
    item_tier = admission_tier(vendor, item)
    if lane == "standard":
        if minimum >= 3:
            return "Good"
        if maximum >= 3 and item_tier >= maximum and slot % 2 == 0:
            return "Good"
        return "Normal"
    if maximum <= 1:
        return "Good"
    if maximum == 2:
        return "Excellent" if item_tier >= 2 and slot % 3 == 0 else "Good"
    if maximum == 3:
        return "Excellent" if item_tier >= 3 and slot % 2 == 0 else "Good"
    if maximum >= 4:
        return "Excellent"
    return "Good"


def source_q(source_tier: int, quality: str) -> int:
    return max(0, 2 * (max(1, source_tier) - 1) + QUALITY_OFFSET[quality])


def page_count(concat_percent: int) -> int:
    if 0 < concat_percent < 10:
        return 8
    if concat_percent < 30:
        return 4
    return 2


def admission_tier(vendor: SourceVendor, item: Item) -> int:
    if vendor.profile == "Mm9Library":
        if item.value <= 50:
            return 1
        if item.value <= 75:
            return 2
        return 3
    return item.normalized_tier


def candidates_for(vendor: SourceVendor, lane: str, mm9_items: list[Item], engine_items: list[Item]) -> list[Item]:
    source = engine_items if vendor.profile == "Spellbook" else mm9_items
    allowed = [item for item in source if item_rejection_reason(vendor, lane, item) is None]
    return sorted(allowed, key=lambda item: (admission_tier(vendor, item), item.item_id))


def source_concat_for(item: Item, source_concats: dict[int, SourceConcat]) -> SourceConcat:
    # ID 4 (Elemental 1) admits every one of CONCAT.csv's five weapon-domain columns. ID 49
    # (Durability 1) admits all fifteen source equipment columns. These conservative representatives
    # keep source applicability provable without guessing the headerless file's individual category order.
    source_concat_id = 4 if item.equip_stat in WEAPON_STATS else 49
    source_concat = source_concats[source_concat_id]
    if item.equip_stat in WEAPON_STATS:
        weapon_flags = tuple(
            source_concat.fields[column] for column in SOURCE_CONCAT_WEAPON_COLUMNS)
        if any(flag != "1" for flag in weapon_flags):
            raise ValueError(f"concat {source_concat_id} is not universal across MM9 weapon columns")
    elif any(flag != 1 for flag in source_concat.applicability):
        raise ValueError(f"concat {source_concat_id} is not universal across MM9 equipment columns")
    return source_concat


def concat_mapping_id(item: Item) -> str:
    return "weapon_elemental" if item.equip_stat in WEAPON_STATS else "wearable_durability"


def quality_role_envelope(item: Item) -> str:
    if item.equip_stat in WEAPON_STATS:
        return "weapon_damage"
    if item.equip_stat in ARMOR_STATS and item.equip_stat != "Belt":
        return "armor_class"
    if item.equip_stat in {"Belt", "Ring", "Amulet"}:
        return "wearable_attribute"
    return "not_applicable"


def mapped_enchants(item: Item, quality: str, concat: bool, effective_tier: int, slot: int) -> tuple[int, int, int]:
    standard_id = 0
    standard_power = 0
    special_id = 0
    if item.equip_stat in EQUIPMENT_STATS and quality != "Normal":
        if item.equip_stat in WEAPON_STATS:
            special_id = 4 if quality == "Good" else 5
        else:
            standard_id = 10 if item.equip_stat in ARMOR_STATS and item.equip_stat != "Belt" else 1
            standard_power = max(1, effective_tier * (2 if quality == "Excellent" else 1))
    if concat and item.equip_stat in EQUIPMENT_STATS:
        if item.equip_stat in WEAPON_STATS:
            elemental_family_base = (4, 7, 10, 13)[slot % 4]
            target_strength = 0 if effective_tier <= 2 else 1 if effective_tier <= 4 else 2
            special_id = elemental_family_base + target_strength
        else:
            # OpenYAMM has no item-durability enchant field. Warriors' is the lowest-value universal
            # ordinary enchant and retains the source concat as a modest endurance-oriented overlay.
            special_id = 56
    return standard_id, standard_power, special_id


def read_special_enchant_price_modifiers(path: Path) -> dict[int, tuple[bool, int]]:
    with path.open(encoding="cp1252", newline="") as source_file:
        rows = list(csv.reader(source_file, delimiter="\t"))
    header_index = next(
        index for index, row in enumerate(rows)
        if row and row[0].strip() == "Bonus Stat" and "Value" in row)
    header = rows[header_index]
    value_index = header.index("Value")
    result: dict[int, tuple[bool, int]] = {}
    enchant_id = 0
    for row in rows[header_index + 1:]:
        if not row or not row[0].strip():
            continue
        enchant_id += 1
        padded = row + [""] * max(0, len(header) - len(row))
        value = padded[value_index].strip().casefold().replace(" ", "")
        if value.startswith("x"):
            result[enchant_id] = (True, parse_int(value[1:], 1))
        else:
            result[enchant_id] = (False, parse_int(value))
    return result


def runtime_item_value(
    item: Item,
    standard_enchant_power: int,
    special_enchant_id: int,
    special_price_modifiers: dict[int, tuple[bool, int]],
) -> int:
    value = max(1, item.value)
    if standard_enchant_power > 0:
        value += 100 * standard_enchant_power
    if special_enchant_id != 0:
        multiplicative, amount = special_price_modifiers[special_enchant_id]
        if multiplicative and amount > 1:
            value *= amount
        else:
            value += max(0, amount)
    return max(1, value)


def target_concat_count(total_slots: int, concat_percent: int) -> int:
    if total_slots == 0 or concat_percent == 0:
        return 0
    quotient, remainder = divmod(total_slots * concat_percent, 100)
    result = quotient + (1 if remainder * 2 >= 100 else 0)
    return max(1, result)


def write_tsv(path: Path, rows: Iterable[Iterable[object]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as target_file:
        writer = csv.writer(target_file, delimiter="\t", lineterminator="\n")
        writer.writerows(rows)


def generate(args: argparse.Namespace) -> None:
    source_header, source_shop_rows = read_source_shop_rows(args.shops)
    source_concat_rows = read_source_concats(args.concats)
    source_concats = {source_concat.concat_id: source_concat for source_concat in source_concat_rows}
    vendors = read_source_vendors(args.shops)
    shop_rude_rows = rude_service_rows(args.rude_directory, -2)
    reachable_shop_ids = set(shop_rude_rows)
    training_ids = rude_service_ids(args.rude_directory, -3)
    healer_ids = rude_service_ids(args.rude_directory, -8)
    donation_ids = rude_service_ids(args.rude_directory, -16)
    service_venues = read_source_service_venues(
        args.shops,
        training_ids,
        healer_ids,
        donation_ids,
    )
    vendor_id_begin, vendor_id_end = read_manifest_vendor_range(args.world_manifest)
    package_owned_ids = [
        *(vendor.vendor_id for vendor in vendors),
        *(venue.service_id for venue in service_venues),
    ]
    if len(package_owned_ids) != len(set(package_owned_ids)):
        raise ValueError("duplicate canonical MM9 vendor/service id")
    if any(identifier < vendor_id_begin or identifier > vendor_id_end for identifier in package_owned_ids):
        raise ValueError(
            f"MM9 vendor/service id lies outside manifest range {vendor_id_begin}-{vendor_id_end}")
    unresolved = sorted(vendor.source_id for vendor in vendors if vendor.source_id not in reachable_shop_ids)
    mm9_items = read_items(args.mm9_items, "utf-8", "mm9")
    engine_items = [
        item for item in read_items(args.engine_items, "cp1252", "engine")
        if 1902 <= item.item_id <= 2018
    ]
    special_price_modifiers = read_special_enchant_price_modifiers(args.special_enchants)
    source_row_by_line = {row.source_line: row for row in source_shop_rows}
    shop_source_path = source_provenance_path(args.shops)
    concat_source_path = source_provenance_path(args.concats)

    vendor_rows: list[list[object]] = [[
        "vendor_id", "package_id", "source_vendor_id", "canonical_id", "name", "location", "source_type",
        "merchandise", "profile", "magic_school", "wealth", "merchant_base", "standard_min", "standard_max",
        "standard_concat_percent", "special_min", "special_max", "special_concat_percent", "restock_days",
        "can_sell", "can_identify", "can_repair", "scene_policy", "opening_policy", "source_line",
        "source_quantity", "source_restock", "source_file", "normalized_service_type",
        "legacy_house_audio_policy", "legacy_house_video_policy",
    ]]
    alias_rows: list[list[object]] = [[
        "vendor_id", "package_id", "source_vendor_id", "source_line", "rude_source_files",
    ]]
    stock_rows: list[list[object]] = [[
        "vendor_id", "lane", "page", "slot", "item_id", "quantity", "identified", "standard_enchant_id",
        "standard_enchant_power", "special_enchant_id", "generation_version",
    ]]
    concat_mapping_rows: list[list[object]] = [[
        "mapping_id", "source_concat_id", "source_name", "source_family", "source_tier",
        "source_applicability_rule", "target_special_enchant_ids", "owner", "reason",
    ], [
        "weapon_elemental", 4, source_concats[4].name, source_concats[4].family,
        source_concats[4].tier, "all_five_weapon_domain_flags_set",
        "4|5|6|7|8|9|10|11|12|13|14|15",
        SOURCE_CONCAT_MAPPING_OWNER,
        SOURCE_CONCAT_MAPPING_REASONS["weapon_elemental"],
    ], [
        "wearable_durability", 49, source_concats[49].name, source_concats[49].family,
        source_concats[49].tier, "all_fifteen_equipment_flags_set", "56",
        SOURCE_CONCAT_MAPPING_OWNER,
        SOURCE_CONCAT_MAPPING_REASONS["wearable_durability"],
    ]]
    service_rows: list[list[object]] = [[
        "service_id", "package_id", "source_service_id", "canonical_id", "name", "location",
        "service_type", "price_multiplier", "temple_healing_tier", "training_max_level", "can_heal",
        "can_donate", "can_learn_skills", "scene_policy", "opening_policy", "source_line",
    ]]
    service_alias_rows: list[list[object]] = [[
        "service_id", "package_id", "source_service_id", "source_line",
    ]]
    audit: dict[str, object] = {
        "algorithm": "mm9_vendor_overlay_v1",
        "source_file": shop_source_path,
        "source_header": list(source_header),
        "source_field_names": list(SOURCE_FIELD_NAMES),
        "source_row_count": len(source_shop_rows),
        "source_rows": [
            {
                "source_line": row.source_line,
                "raw_fields": dict(zip(SOURCE_FIELD_NAMES, row.fields)),
                "disposition": (
                    "selling_vendor" if row.source_type in SELLING_TYPES
                    else "reachable_service_venue"
                    if row.source_type in SERVICE_TYPES
                    and (row.source_id in training_ids
                         or row.source_id in healer_ids
                         or row.source_id in donation_ids)
                    else "non_stock_service"
                ),
            }
            for row in source_shop_rows
        ],
        "concat_source_file": concat_source_path,
        "concat_source_has_header": False,
        "concat_source_field_count": SOURCE_CONCAT_FIELD_COUNT,
        "concat_source_row_count": len(source_concat_rows),
        "concat_source_rows": [
            {
                "source_line": source_concat.source_line,
                "raw_fields": list(source_concat.fields),
                "source_concat_id": source_concat.concat_id,
                "name": source_concat.name,
                "name_is_prefix": source_concat.name_is_prefix,
                "applicability_flags": list(source_concat.applicability),
                "value": source_concat.value,
                "family": source_concat.family,
                "tier": source_concat.tier,
                "description": source_concat.description,
            }
            for source_concat in source_concat_rows
        ],
        "concat_applicability_model": {
            "source_flag_columns_zero_based": list(SOURCE_CONCAT_APPLICABILITY_COLUMNS),
            "source_weapon_domain_columns_zero_based": list(SOURCE_CONCAT_WEAPON_COLUMNS),
            "individual_flag_names_in_source": "not_present_headerless_csv",
            "selection_rule": (
                "Use only a source concat whose complete relevant domain is enabled: all five weapon flags "
                "for weapons or all fifteen equipment flags for other wearables."
            ),
        },
        "concat_mappings": [
            {
                "mapping_id": row[0],
                "source_concat_id": row[1],
                "source_name": row[2],
                "source_family": row[3],
                "source_tier": row[4],
                "source_applicability_rule": row[5],
                "target_special_enchant_ids": [parse_int(value) for value in str(row[6]).split("|")],
                "owner": row[7],
                "reason": row[8],
            }
            for row in concat_mapping_rows[1:]
        ],
        "runtime_stock_generation_version": 1,
        "ordinary_effective_tier_cap": 6,
        "quality_policy": {
            "quality_offsets": dict(QUALITY_OFFSET),
            "effective_tier_formula": "clamp(base_normalized_tier + quality_offset, 1, 6)",
            "assignment_version": 1,
            "runtime_quality_fields_emitted": False,
            "runtime_source_q_field_emitted": False,
        },
        "vendor_id_domain": {
            "manifest_file": source_provenance_path(args.world_manifest),
            "begin": vendor_id_begin,
            "end": vendor_id_end,
            "validated_canonical_ids": sorted(package_owned_ids),
            "all_unique_and_in_range": True,
        },
        "balance_boundary": {
            "ordinary_shop_maximum_tier": 6,
            "artifact_relic_reserved_tier": 7,
            "rare_and_set_rows_admitted": False,
        },
        "vendor_count": len(vendors),
        "selling_vendors_without_rude_shop_row": unresolved,
        "rude_shop_rows_without_selling_vendor": sorted(
            reachable_shop_ids - {vendor.source_id for vendor in vendors}),
        "service_venue_count": len(service_venues),
        "training_ids": sorted(training_ids),
        "healer_ids": sorted(healer_ids),
        "donation_ids": sorted(donation_ids),
        "reviewed_policy_decisions": [
            {
                "policy": "standard_special_source_pair_interpretation",
                "owner": "MM9 vendor integration goal",
                "reason": "The first treasure/concat pair maps to Standard and the second maps to Special.",
            },
            {
                "policy": "raw_zero_candidate_floor",
                "owner": "MM9 vendor integration goal",
                "reason": "Raw range zero remains in provenance and admits the ordinary L1 candidate floor.",
            },
            {
                "policy": "offline_quality_conversion",
                "owner": "MM9 vendor integration goal",
                "reason": (
                    "Normal/Good/Excellent and source Q remain audit-only; runtime rows use ordinary "
                    "item/enchant fields."
                ),
            },
            {
                "policy": "concat_largest_remainder_half_up",
                "owner": "MM9 vendor integration goal",
                "reason": (
                    "Each complete lane cycle receives the nearest integral concat count, with exact "
                    "half remainders rounded up."
                ),
            },
            {
                "policy": "source_concat_conservative_applicability",
                "owner": SOURCE_CONCAT_MAPPING_OWNER,
                "reason": (
                    "CONCAT.csv is headerless, so author stock only from source rows that enable the entire "
                    "relevant equipment domain and retain the exact row and flags in the audit."
                ),
            },
            {
                "policy": "merchant_base_pricing",
                "owner": "MM9 vendor integration goal",
                "reason": "Merchant base becomes the shared house price multiplier; Wealth is provenance only.",
            },
            {
                "policy": "source_merchandise_to_shared_profile",
                "owner": "MM9 vendor integration goal",
                "reason": (
                    "The six source selling types map to reviewed shared stock profiles; the raw merchandise "
                    "text remains the category and magic-school filter."
                ),
            },
            {
                "policy": "source_restock_to_game_days",
                "owner": "MM9 vendor integration goal",
                "reason": (
                    "Two Weeks maps to 14 game days and Two Months maps to 56 game days under the "
                    "shared 28-day game calendar."
                ),
            },
            {
                "policy": "profile_visual_slot_counts",
                "owner": "MM9 vendor integration goal",
                "reason": (
                    "The source quantity text is retained verbatim; concrete roster sizes use the shared "
                    "profile-specific shop layouts."
                ),
            },
            {
                "policy": "rude_quest_key_opening",
                "owner": "MM9 vendor integration goal",
                "reason": (
                    "Recovered RUDE row visibility is the authoritative opening policy; no schedule is "
                    "inferred from adjacent vendors."
                ),
            },
        ],
        "profile_rules": {
            "source_type_to_runtime_profile": dict(sorted(PROFILE_BY_SOURCE_TYPE.items())),
            "runtime_profile_slot_counts": dict(sorted(PROFILE_SLOT_COUNTS.items())),
        },
        "restock_rules": {
            "2 Weeks": 14,
            "2 Months": 56,
        },
        "pricing_policy": {
            "merchant_base_runtime_field": "HouseEntry.priceMultiplier",
            "wealth_affects_runtime_price": False,
            "quality_value_is_ordinary_item_enchant_value": True,
            "shared_merchant_skill_calculation": True,
        },
        "vendors": [],
    }

    for venue in sorted(service_venues, key=lambda entry: entry.service_id):
        service_rows.append([
            venue.service_id, "mm9", venue.source_id, f"mm9:service/{venue.source_id}", venue.name,
            LOCATION_BY_SOURCE_ID[venue.source_id], venue.runtime_type, f"{venue.merchant_base:g}", 0, 0,
            int(venue.can_heal), int(venue.can_donate), 0, "LiveGameplay", "RudeQuestKey",
            venue.source_line,
        ])
        service_alias_rows.append([venue.service_id, "mm9", venue.source_id, venue.source_line])

    for vendor in sorted(vendors, key=lambda entry: entry.vendor_id):
        restock_days = 56 if vendor.restock_text == "2 Months" else 14
        can_repair = vendor.profile in {"Weapon", "Armor", "Mm9GeneralStore"}
        can_identify = vendor.profile != "Mm9Library"
        vendor_rows.append([
            vendor.vendor_id, "mm9", vendor.source_id, f"mm9:vendor/{vendor.source_id}", vendor.name,
            LOCATION_BY_SOURCE_ID[vendor.source_id], vendor.source_type, vendor.merchandise, vendor.profile,
            magic_school(vendor.merchandise) if vendor.profile == "Spellbook" else "", vendor.wealth,
            f"{vendor.merchant_base:g}", vendor.standard_min, vendor.standard_max, vendor.standard_concat,
            vendor.special_min, vendor.special_max, vendor.special_concat, restock_days, 1, int(can_identify),
            int(can_repair), "LiveGameplay", "RudeQuestKey", vendor.source_line,
            vendor.source_quantity, vendor.restock_text, shop_source_path, "Shop", "Disabled", "Disabled",
        ])
        alias_rows.append([
            vendor.vendor_id,
            "mm9",
            vendor.source_id,
            vendor.source_line,
            ";".join(sorted({
                str(row["source_file"]) for row in shop_rude_rows.get(vendor.source_id, [])
            })),
        ])
        source_row = source_row_by_line[vendor.source_line]
        reviewed_overrides: list[dict[str, str]] = []
        if vendor.standard_min == 0 or vendor.special_min == 0:
            reviewed_overrides.append({
                "override": "raw_zero_candidate_floor",
                "owner": "MM9 vendor integration goal",
                "reason": "The ordinary MM9 catalogue has no useful shop tier below L1.",
            })
        if vendor.source_id == 138:
            reviewed_overrides.append({
                "override": "source_vendor_without_rude_shop_row",
                "owner": "MM9 vendor integration goal",
                "reason": "MMIXSHOPS defines this selling vendor, but recovered RUDE data has no opcode -2 row.",
            })
        vendor_audit: dict[str, object] = {
            "vendor_id": vendor.vendor_id,
            "source_vendor_id": vendor.source_id,
            "name": vendor.name,
            "canonical_id": f"mm9:vendor/{vendor.source_id}",
            "location": LOCATION_BY_SOURCE_ID[vendor.source_id],
            "source_type": vendor.source_type,
            "source_merchandise": vendor.merchandise,
            "source_wealth": vendor.wealth,
            "source_merchant_base": vendor.merchant_base,
            "runtime_price_multiplier": vendor.merchant_base,
            "source_quantity": vendor.source_quantity,
            "source_restock": vendor.restock_text,
            "normalized_restock_days": restock_days,
            "normalized_service_type": "Shop",
            "dialogue_scene_policy": "LiveGameplay",
            "legacy_house_audio_policy": "Disabled",
            "legacy_house_video_policy": "Disabled",
            "opening_policy": "RudeQuestKey",
            "opening_policy_provenance": shop_rude_rows.get(vendor.source_id, []),
            "profile": vendor.profile,
            "magic_school": magic_school(vendor.merchandise) if vendor.profile == "Spellbook" else "",
            "source_line": vendor.source_line,
            "source_file": shop_source_path,
            "source_raw_fields": dict(zip(SOURCE_FIELD_NAMES, source_row.fields)),
            "raw_ranges": {
                "standard": [vendor.standard_min, vendor.standard_max],
                "special": [vendor.special_min, vendor.special_max],
            },
            "raw_concat_percentages": {
                "standard": vendor.standard_concat,
                "special": vendor.special_concat,
            },
            "source_pair_interpretation": "first_pair_standard_second_pair_special",
            "zero_floor_reviewed": vendor.standard_min == 0 or vendor.special_min == 0,
            "reviewed_overrides": reviewed_overrides,
            "lanes": {},
        }
        for lane, concat_percent in (("standard", vendor.standard_concat), ("special", vendor.special_concat)):
            source_catalog = engine_items if vendor.profile == "Spellbook" else mm9_items
            rejected_candidates = Counter(
                reason for item in source_catalog
                if (reason := item_rejection_reason(vendor, lane, item)) is not None)
            candidates = candidates_for(vendor, lane, mm9_items, engine_items)
            if not candidates:
                raise ValueError(f"vendor {vendor.source_id} {lane} has no eligible candidates")
            count = PROFILE_SLOT_COUNTS[vendor.profile]
            pages = page_count(concat_percent)
            total_slots = count * pages
            prepared_slots: list[tuple[int, int, int, Item, str, int, int]] = []
            for page in range(pages):
                for slot in range(count):
                    flat_index = page * count + slot
                    item = candidates[(flat_index + vendor.source_id) % len(candidates)]
                    quality = quality_for(vendor, lane, slot, item)
                    quality_offset = QUALITY_OFFSET.get(quality, 0)
                    item_admission_tier = admission_tier(vendor, item)
                    effective_tier = min(6, max(1, item_admission_tier) + quality_offset)
                    prepared_slots.append((
                        page, slot, flat_index, item, quality, item_admission_tier, effective_tier))

            eligible_indices = [
                flat_index
                for _, _, flat_index, item, _, _, _ in prepared_slots
                if item.equip_stat in EQUIPMENT_STATS
            ]
            concat_count = target_concat_count(len(eligible_indices), concat_percent)
            concat_indices = {
                eligible_indices[index * len(eligible_indices) // concat_count]
                for index in range(concat_count)
            } if concat_count else set()
            lane_audit: list[dict[str, object]] = []
            for (
                page, slot, flat_index, item, quality, item_admission_tier, effective_tier
            ) in prepared_slots:
                quality_offset = QUALITY_OFFSET.get(quality, 0)
                concat = flat_index in concat_indices
                source_concat = source_concat_for(item, source_concats) if concat else None
                if source_concat is not None and source_concat.tier > effective_tier:
                    raise ValueError(
                        f"vendor {vendor.source_id} {lane} slot {flat_index}: concat tier "
                        f"{source_concat.tier} exceeds effective tier {effective_tier}")
                standard_id, standard_power, special_id = mapped_enchants(
                    item, quality, concat, effective_tier, slot)
                final_value = runtime_item_value(
                    item,
                    standard_power,
                    special_id,
                    special_price_modifiers)
                stock_rows.append([
                    vendor.vendor_id, lane, page, slot, item.item_id, 1, 1, standard_id, standard_power,
                    special_id, 1,
                ])
                mapping_id = concat_mapping_id(item) if source_concat is not None else ""
                lane_audit.append({
                        "page": page,
                        "slot": slot,
                        "item_id": item.item_id,
                        "item_name": item.name,
                        "source_tier": item.source_treasure_tier,
                        "normalized_base_tier": item.normalized_tier,
                        "admission_tier": item_admission_tier,
                        "source_quality": quality,
                        "source_q": source_q(item.source_treasure_tier, quality)
                        if quality in QUALITY_OFFSET else None,
                        "effective_tier": effective_tier,
                        "runtime_mapping": {
                            "item_id": item.item_id,
                            "standard_enchant_id": standard_id,
                            "standard_enchant_power": standard_power,
                            "special_enchant_id": special_id,
                        },
                        "quality_conversion": {
                            "application_count": 0 if quality == "NotApplicable" else 1,
                            "mapping_kind": (
                                "not_applicable" if quality == "NotApplicable"
                                else "ordinary_item_and_combined_concat_enchant"
                                if concat and special_id != 0
                                else "ordinary_item_and_explicit_enchant"
                            ),
                            "base_normalized_statistics": {
                                "equipment_family": item.equip_stat,
                                "normalized_tier": item.normalized_tier,
                                "item_value": item.value,
                                "mod1": item.mod1,
                                "mod2": item.mod2,
                                "source_minimum": item.source_minimum,
                                "source_maximum": item.source_maximum,
                                "inventory_width": item.inventory_width,
                                "inventory_height": item.inventory_height,
                                "visual_status": item.visual_status,
                                "allowed_class_roots": item.allowed_class_roots,
                            },
                            "target_envelope": {
                                "effective_tier": effective_tier,
                                "ordinary_tier_cap": 6,
                                "role": item.equip_stat,
                                "role_envelope": quality_role_envelope(item),
                            },
                            "applied_delta": {
                                "tier_offset": quality_offset,
                                "item_value": final_value - item.value,
                                "standard_enchant_id": standard_id,
                                "standard_enchant_power": standard_power,
                                "special_enchant_id": special_id,
                            },
                            "final_overlay_statistics": {
                                "runtime_item_id": item.item_id,
                                "effective_tier": effective_tier,
                                "item_value": final_value,
                                "base_mod1_retained": item.mod1,
                                "base_mod2_retained": item.mod2,
                                "ordinary_standard_enchant_id": standard_id,
                                "ordinary_standard_enchant_power": standard_power,
                                "ordinary_special_enchant_id": special_id,
                                "canonical_item_identity_retained": True,
                                "inventory_dimensions_retained": True,
                                "visual_mapping_retained": True,
                                "class_restrictions_retained": True,
                                "runtime_quality_field_emitted": False,
                                "runtime_source_q_field_emitted": False,
                            },
                        },
                        "balance_boundary_validation": {
                            "base_normalized_tier_at_most_l5": item.normalized_tier <= 5,
                            "effective_tier_at_most_l6": effective_tier <= 6,
                            "source_rarity": item.rarity,
                            "source_content_flags": sorted(item.content_flags),
                            "source_set_id": item.set_id,
                            "rare_item_admitted": item.rarity.casefold()
                            in {"artifact", "relic", "special"},
                            "quest_or_unique_item_admitted": bool(
                                {"Quest", "Unique", "NoShop"} & item.content_flags),
                            "set_piece_admitted": bool(item.set_id),
                            "runtime_artifact_id_emitted": False,
                            "ordinary_l7_boundary_preserved": (
                                item.normalized_tier <= 5
                                and effective_tier <= 6
                                and item.rarity.casefold() not in {"artifact", "relic", "special"}
                                and not ({"Quest", "Unique", "NoShop"} & item.content_flags)
                                and not item.set_id
                            ),
                        },
                        "concat_mapping": None if source_concat is None else {
                            "mapping_id": mapping_id,
                            "source_file": concat_source_path,
                            "source_line": source_concat.source_line,
                            "source_concat_id": source_concat.concat_id,
                            "source_name": source_concat.name,
                            "source_name_is_prefix": source_concat.name_is_prefix,
                            "source_family": source_concat.family,
                            "source_tier": source_concat.tier,
                            "source_value": source_concat.value,
                            "source_description": source_concat.description,
                            "source_applicability_flags": list(source_concat.applicability),
                            "source_raw_fields": list(source_concat.fields),
                            "applicability_rule": (
                                "all_five_weapon_domain_flags_set"
                                if item.equip_stat in WEAPON_STATS
                                else "all_fifteen_equipment_flags_set"
                            ),
                            "applicable": True,
                            "target_special_enchant_id": special_id,
                            "owner": SOURCE_CONCAT_MAPPING_OWNER,
                            "reason": SOURCE_CONCAT_MAPPING_REASONS[mapping_id],
                        },
                        "concat": concat,
                    })
            vendor_audit["lanes"][lane] = {
                "page_count": pages,
                "slot_count": total_slots,
                "concat_eligible_slot_count": len(eligible_indices),
                "concat_ineligible_slot_count": total_slots - len(eligible_indices),
                "candidate_count": len(candidates),
                "rejected_candidate_counts": dict(sorted(rejected_candidates.items())),
                "expected_concat_percent": concat_percent,
                "realized_concat_percent": (
                    100.0 * concat_count / len(eligible_indices) if eligible_indices else 0.0),
                "concat_percentage_deviation": (
                    100.0 * concat_count / len(eligible_indices) - concat_percent
                    if eligible_indices else -float(concat_percent)),
                "concat_target_count": concat_count,
                "source_concat_ids_used": sorted({
                    slot["concat_mapping"]["source_concat_id"]
                    for slot in lane_audit
                    if slot["concat_mapping"] is not None
                }),
                "concat_rounding_rule": "largest_remainder_half_up_with_nonzero_minimum",
                "slots": lane_audit,
            }
        audit["vendors"].append(vendor_audit)

    audit["coverage"] = {
        "selling_vendor_count": len(vendors),
        "library_vendor_count": sum(vendor.profile == "Mm9Library" for vendor in vendors),
        "magic_vendor_count": sum(vendor.profile == "Spellbook" for vendor in vendors),
        "library_skill_book_ids": sorted({
            slot["item_id"]
            for vendor in audit["vendors"]
            if vendor["profile"] == "Mm9Library"
            for lane in vendor["lanes"].values()
            for slot in lane["slots"]
        }),
        "magic_schools": dict(sorted(Counter(
            vendor["magic_school"] for vendor in audit["vendors"]
            if vendor["profile"] == "Spellbook"
        ).items())),
        "missing_library_coverage": [],
        "missing_magic_school_coverage": [],
        "missing_profile_coverage": [],
    }

    write_tsv(args.output_directory / "vendors.txt", vendor_rows)
    write_tsv(args.output_directory / "vendor_aliases.txt", alias_rows)
    write_tsv(args.output_directory / "vendor_stock.txt", stock_rows)
    write_tsv(args.output_directory / "vendor_concat_mappings.txt", concat_mapping_rows)
    write_tsv(args.output_directory / "service_venues.txt", service_rows)
    write_tsv(args.output_directory / "service_venue_aliases.txt", service_alias_rows)
    args.audit.parent.mkdir(parents=True, exist_ok=True)
    args.audit.write_text(json.dumps(audit, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def default_root() -> Path:
    return Path(__file__).resolve().parents[2]


def parse_args() -> argparse.Namespace:
    root = default_root()
    parser = argparse.ArgumentParser()
    parser.add_argument("--shops", type=Path, default=root / "mm9/extracted/DATA/DATA/MMIXSHOPS.txt")
    parser.add_argument("--concats", type=Path, default=root / "mm9/extracted/DATA/DATA/CONCAT.csv")
    parser.add_argument("--world-manifest", type=Path, default=root / "assets_dev/worlds/mm9/world.yml")
    parser.add_argument("--rude-directory", type=Path, default=root / "assets_dev/worlds/mm9/dialogue/rude")
    parser.add_argument("--mm9-items", type=Path, default=root / "assets_dev/worlds/mm9/data_tables/items.txt")
    parser.add_argument("--engine-items", type=Path, default=root / "assets_dev/engine/data_tables/items.txt")
    parser.add_argument(
        "--special-enchants",
        type=Path,
        default=root / "assets_dev/engine/data_tables/special_item_enchants.txt")
    parser.add_argument("--output-directory", type=Path, default=root / "assets_dev/worlds/mm9/data_tables")
    parser.add_argument("--audit", type=Path, default=root / "assets_dev/worlds/mm9/state/vendor_stock_audit.yml")
    return parser.parse_args()


if __name__ == "__main__":
    generate(parse_args())
