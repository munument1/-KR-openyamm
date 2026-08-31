#!/usr/bin/env python3
"""Generate world-owned OpenYAMM monster rows from MM9 MONSTERS.txt."""

from __future__ import annotations

import argparse
import csv
import re
from pathlib import Path

from mm9_units import MM9_TO_OPENYAMM_COORDINATE_SCALE


MM9_MONSTER_ID_BASE = 9000
OPENYAMM_TICKS_PER_SECOND = 128
# Runtime monster recovery applies the classic OE real-time factor after reading table ticks.
OPENYAMM_MONSTER_RECOVERY_SCALE = 2.133333333333333

# MONSTERS.txt contains duplicate Projectile2 and Att% headings. Keep positional
# ownership explicit so csv.DictReader cannot silently select the wrong column.
SOURCE_COLUMN = {
    "number": 0, "name": 1, "level": 7, "hp": 8, "ac": 9, "experience": 10,
    "treasure_type": 12, "fly": 14, "move": 15, "walk_velocity": 16, "run_velocity": 17,
    "fly_velocity": 18, "recovery": 22,
    "bonus": 24, "attack1_type": 27, "attack1_damage": 28, "attack1_projectile": 32,
    "attack2_chance": 33, "attack2_type": 34, "attack2_damage": 35, "attack2_projectile": 39,
    "spell1_chance": 40, "spell1": 41, "spell2_chance": 42, "spell2": 43,
    "elemental_resistance": 47, "spirit_resistance": 48, "dark_resistance": 49,
    "light_resistance": 50, "physical_resistance": 51, "script": 52, "is_monster": 61,
    "hostility_group": 63, "treasure_level": 64, "attack3_projectile": 66,
    "attack3_chance": 67, "attack3_type": 68, "attack3_damage": 69, "resurrect": 73,
}
SOURCE_COLUMN_COUNT = 79

PROJECTILE_TOKENS = {
    "": "0", "0": "0", "Air": "Air", "Axe": "MM9Axe", "BlueLine": "Water",
    "BlueThingy": "Water", "BlueThingy2": "Cold", "DragonBreath2": "Fire",
    "DragonFireBolt": "Fire", "Earth": "Earth", "Egg": "MM9Egg", "Fire": "Fire",
    "FireAr": "FireAr", "FireBolt": "Fire", "Goo1": "Body", "Goo2": "Body",
    "Goo3": "Body", "GreenThingy": "Earth", "GreenYellowThingy": "Body",
    "IceBlast": "Cold", "Knife": "MM9Knife", "Lightning": "Elec",
    "LightningBolt": "Elec", "PurpleThingy": "Dark", "RedThingy": "Fire",
    "RedYellowThingy": "Light", "Redline": "Fire", "RingOfFire": "Fire",
    "Skull": "MM9Skull", "Spell": "0", "Stone": "Rock", "YellowThingy": "Elec",
}

MOVEMENT_TYPES = {
    "0": "Stationary", "2": "Short", "3": "Short", "4": "Med",
    "5": "Med", "6": "Long", "7": "Long", "8": "Free",
}

DIRECT_DAMAGE_TYPES = {
    "": "0", "0": "0", "Dark": "Dark", "Light": "Light",
    "Phys": "Phys", "Spirit": "Spirit",
}

ELEMENTAL_PROJECTILE_DAMAGE_TYPES = {
    "BlueLine": "Water", "BlueThingy": "Water", "BlueThingy2": "Water",
    "DragonBreath2": "Fire", "DragonFireBolt": "Fire", "Fire": "Fire",
    "FireAr": "Fire", "FireBolt": "Fire", "GreenThingy": "Earth",
    "GreenYellowThingy": "Earth", "IceBlast": "Water", "Lightning": "Air",
    "LightningBolt": "Air", "RedThingy": "Fire", "RedYellowThingy": "Fire",
    "Redline": "Fire", "RingOfFire": "Fire", "Stone": "Earth", "YellowThingy": "Air",
}

SPECIAL_ATTACKS = {
    "": "0", "0": "0", "Afraid": "Afraid", "Agex2": "Agex2", "Asleep": "Asleep",
    "BrkArmor": "BrkArmor", "BrkItem": "BrkItem", "Brkarmor": "BrkArmor",
    "Brkitem": "BrkItem", "Brkweapon": "BrkWeapon", "Curse": "Curse",
    "Cursex2": "Cursex2", "Dead": "Dead", "Disease1": "Disease1",
    "Disease1/Afraid": "Disease1", "Disease2": "Disease2", "Disease3": "Disease3",
    "DrainSP": "DrainSP", "Drunk": "Drunk", "Insane": "Insane",
    "Paralyze": "Paralyze", "Paralyze/Afraid": "Paralyze", "Poison1": "Poison1",
    "Poison2": "Poison2", "Poison3": "Poison3", "Poison3x2": "Poison3x2",
    # Item damage is the closest supported inventory consequence to MM9 stealing.
    "Stealx1": "BrkItemx1", "Stealx2": "BrkItemx2",
    # MM9 Stun is temporary control; use the lowest supported control tier.
    "Stun": "Paralyzex1", "Uncon": "Uncon",
}

SPELL_NAMES = {
    1: "Bless",
    2: "Lightning Bolt",       # Chain Lightning
    4: "Incinerate",           # Column-of-Fire
    5: "Dark Grasp",           # Curse: closest supported dark debuff projectile
    6: "Dark Grasp",
    7: "Dragon Breath",        # Death's Touch
    8: "Toxic Cloud",          # Disease
    12: None,                   # Elemental Bolt: selected from the actor's projectile family
    19: "Mind Blast",          # Fear: closest supported mind projectile
    23: "Heal",
    27: "Stone Skin",          # Natural Armor
    29: "Dark Grasp",          # Paralyze: supported slowing dark projectile
    31: "Poison Spray",
    39: "Dragon Breath",       # Souldrinker is not a supported monster area spell
    40: "Sparks",
    41: "Dispel Magic",        # SpellReaver
    47: "Harm",                # Wound
}

MASTERY_NAMES = {"N": "N", "E": "E", "M": "M", "G": "GM"}


def numeric_rows(path: Path) -> tuple[list[list[str]], dict[int, list[str]]]:
    with path.open(newline="", encoding="utf-8") as input_file:
        rows = list(csv.reader(input_file, delimiter="\t"))
    return rows, {
        int(row[0]): row for row in rows if row and re.fullmatch(r"\d+", row[0].strip())
    }


def source_monsters(path: Path) -> dict[int, list[str]]:
    with path.open(newline="", encoding="cp1252") as input_file:
        rows = list(csv.reader(input_file, delimiter="\t"))
    if not rows or len(rows[0]) != SOURCE_COLUMN_COUNT:
        raise ValueError(f"Unexpected MM9 MONSTERS.txt schema in {path}")

    monsters: dict[int, list[str]] = {}
    for row in rows[1:]:
        if len(row) != SOURCE_COLUMN_COUNT or not row[SOURCE_COLUMN["number"]].strip().isdigit():
            continue
        if row[SOURCE_COLUMN["is_monster"]].strip() != "1":
            continue
        number = int(row[SOURCE_COLUMN["number"]])
        monsters[number] = [cell.strip() for cell in row]
    return monsters


def replacement_ids(path: Path) -> dict[int, int]:
    with path.open(newline="", encoding="utf-8") as input_file:
        return {
            int(row["mm9_source_number"]): int(row["legacy_actor_id"])
            for row in csv.DictReader(input_file, delimiter="\t")
        }


def internal_name(source_number: int, display_name: str) -> str:
    return f"MM9 {source_number} {display_name}"


def source_value(row: list[str], name: str) -> str:
    return row[SOURCE_COLUMN[name]]


def required_mapping(mapping: dict[str, str], value: str, field: str, source_number: int) -> str:
    if value not in mapping:
        raise ValueError(f"MM9 monster {source_number} has unsupported {field} token {value!r}")
    return mapping[value]


def projectile_token(value: str, source_number: int) -> str:
    return required_mapping(PROJECTILE_TOKENS, value, "projectile", source_number)


def elemental_damage_type(row: list[str], projectile: str) -> str:
    if projectile in ELEMENTAL_PROJECTILE_DAMAGE_TYPES:
        return ELEMENTAL_PROJECTILE_DAMAGE_TYPES[projectile]

    attack1_projectile = source_value(row, "attack1_projectile")
    if attack1_projectile in ELEMENTAL_PROJECTILE_DAMAGE_TYPES:
        return ELEMENTAL_PROJECTILE_DAMAGE_TYPES[attack1_projectile]

    # MM9's combined elemental family has no classic equivalent. Air is the
    # least theme-specific fallback for source spell/melee rows.
    return "Air"


def damage_type(row: list[str], type_token: str, projectile: str, source_number: int) -> str:
    if type_token == "Elem":
        return elemental_damage_type(row, projectile)
    return required_mapping(DIRECT_DAMAGE_TYPES, type_token, "damage type", source_number)


def movement_type(row: list[str], source_number: int) -> str:
    if max(source_movement_velocities(row)) == 0:
        return "Stationary"
    return required_mapping(MOVEMENT_TYPES, source_value(row, "move"), "movement", source_number)


def ai_type(row: list[str]) -> str:
    if max(source_movement_velocities(row)) == 0:
        return "Normal"

    script = source_value(row, "script").lower()
    if script in {
        "basemelee.scr", "dagrell.scr", "dragon.scr", "greaterdemon.scr",
        "lesserdemon.scr", "titan.scr", "yanmirbase.scr",
    }:
        return "Suicidal"
    if script in {"guardbase.scr", "monkbase.scr"}:
        return "Normal"
    return "Aggress"


def movement_speed(row: list[str]) -> str:
    source_speed = max(source_movement_velocities(row))
    return str(min(1000, round(source_speed * MM9_TO_OPENYAMM_COORDINATE_SCALE)))


def source_movement_velocities(row: list[str]) -> tuple[int, int, int]:
    return (
        int(source_value(row, "walk_velocity") or "0"),
        int(source_value(row, "run_velocity") or "0"),
        int(source_value(row, "fly_velocity") or "0"),
    )


def recovery_ticks(row: list[str]) -> str:
    # Recovered MM9 actor recovery is 0.1 * MONSTERS.txt Recovery seconds.
    seconds = float(source_value(row, "recovery")) * 0.1
    ticks = seconds * OPENYAMM_TICKS_PER_SECOND / OPENYAMM_MONSTER_RECOVERY_SCALE
    return str(round(ticks))


def treasure_definition(row: list[str], source_number: int) -> str:
    treasure_type = source_value(row, "treasure_type").lower()
    level = int(source_value(row, "treasure_level") or "0")
    if treasure_type in {"", "0", "none"} or level <= 0:
        return "0"

    kind = {"armor": "Armor", "item": "", "random": "", "weapon": "Weapon"}.get(treasure_type)
    if kind is None:
        raise ValueError(f"MM9 monster {source_number} has unsupported treasure type {treasure_type!r}")

    # MM9 stores no per-actor drop chance. Preserve level/category with a
    # conservative world-specific chance rather than guaranteeing an item.
    return f"25%L{level}{kind}"


def resistance(value: str) -> str:
    numeric = int(value or "0")
    return "Imm" if numeric >= 1000 else str(numeric)


def elemental_bolt_spell(row: list[str]) -> str:
    damage_family = elemental_damage_type(row, source_value(row, "attack1_projectile"))
    return {
        "Fire": "Fire Bolt", "Air": "Lightning Bolt",
        "Water": "Ice Bolt", "Earth": "Rock Blast",
    }[damage_family]


def parse_source_spell(descriptor: str, row: list[str], source_number: int) -> tuple[str, int] | None:
    if descriptor in {"", "0"}:
        return None

    match = re.match(r"^\s*(\d+)\s*,\s*([NEMG])\s*,\s*(\d+)", descriptor, re.IGNORECASE)
    if match is None:
        raise ValueError(f"MM9 monster {source_number} has unsupported spell descriptor {descriptor!r}")

    spell_id = int(match.group(1))
    mastery_token = match.group(2).upper()
    skill = int(match.group(3))
    if spell_id not in SPELL_NAMES or mastery_token not in MASTERY_NAMES:
        raise ValueError(f"MM9 monster {source_number} has unsupported spell {descriptor!r}")

    spell_name = SPELL_NAMES[spell_id]
    if spell_id == 12:
        spell_name = elemental_bolt_spell(row)
    assert spell_name is not None
    return f"{spell_name},{MASTERY_NAMES[mastery_token]},{skill}", spell_id


def condition_for_concat_spell(spell_id: int, skill: int) -> str:
    if spell_id == 5:
        return "Curse"
    if spell_id == 8:
        return f"Disease{1 if skill <= 3 else 2 if skill <= 6 else 3}"
    if spell_id == 19:
        return "Afraid"
    if spell_id == 29:
        return "Paralyze"
    if spell_id == 31:
        return f"Poison{1 if skill <= 3 else 2 if skill <= 6 else 3}"
    raise ValueError(f"MM9 concat spell {spell_id} has no supported on-hit condition mapping")


def special_attack(row: list[str], source_number: int, spell1: tuple[str, int] | None) -> str:
    mapped_bonus = required_mapping(
        SPECIAL_ATTACKS, source_value(row, "bonus"), "bonus", source_number
    )
    if source_value(row, "spell1_chance").lower() != "concat" or spell1 is None:
        return mapped_bonus

    descriptor, spell_id = spell1
    skill = int(descriptor.rsplit(",", 1)[1])
    concat_bonus = condition_for_concat_spell(spell_id, skill)
    return mapped_bonus if mapped_bonus != "0" else concat_bonus


def numeric_chance(value: str, source_number: int, field: str) -> int:
    if value.lower() == "concat":
        return 0
    if not value.isdigit():
        raise ValueError(f"MM9 monster {source_number} has unsupported {field} chance {value!r}")
    return int(value)


def spell_columns(row: list[str], source_number: int) -> tuple[str, str, str, str, str]:
    source_spell1 = parse_source_spell(source_value(row, "spell1"), row, source_number)
    source_spell2 = parse_source_spell(source_value(row, "spell2"), row, source_number)
    spell1_chance_token = source_value(row, "spell1_chance")
    spell1_chance = numeric_chance(spell1_chance_token, source_number, "spell 1")
    spell2_chance = numeric_chance(source_value(row, "spell2_chance"), source_number, "spell 2")

    if source_spell2 is not None and spell2_chance == 0:
        spell2_chance = 100 if spell1_chance_token.lower() == "concat" else max(0, 100 - spell1_chance)

    return (
        str(spell1_chance),
        source_spell1[0] if source_spell1 is not None and spell1_chance_token.lower() != "concat" else "0",
        str(spell2_chance),
        source_spell2[0] if source_spell2 is not None else "0",
        special_attack(row, source_number, source_spell1),
    )


def build_data_row(source_number: int, row: list[str], base_data: list[str]) -> list[str]:
    display_name = source_value(row, "name")
    attack1_projectile = source_value(row, "attack1_projectile")
    attack2_projectile = source_value(row, "attack2_projectile")
    attack2_type = source_value(row, "attack2_type")
    attack2_damage = source_value(row, "attack2_damage")
    if source_value(row, "attack3_projectile") not in {"", "0"}:
        attack2_projectile = source_value(row, "attack3_projectile")
        attack2_type = source_value(row, "attack3_type")
        attack2_damage = source_value(row, "attack3_damage")
    spell1_chance, spell1, spell2_chance, spell2, bonus = spell_columns(row, source_number)
    elemental_resistance = resistance(source_value(row, "elemental_resistance"))
    spirit_resistance = resistance(source_value(row, "spirit_resistance"))

    return [
        str(MM9_MONSTER_ID_BASE + source_number), display_name, internal_name(source_number, display_name),
        source_value(row, "level"), source_value(row, "hp"), source_value(row, "ac"),
        source_value(row, "experience"), treasure_definition(row, source_number), base_data[8],
        "Y" if source_value(row, "fly") == "1" else "N", movement_type(row, source_number),
        ai_type(row), "4", movement_speed(row), recovery_ticks(row), "0", bonus,
        damage_type(row, source_value(row, "attack1_type"), attack1_projectile, source_number),
        source_value(row, "attack1_damage"), projectile_token(attack1_projectile, source_number),
        source_value(row, "attack2_chance"),
        damage_type(row, attack2_type, attack2_projectile, source_number),
        attack2_damage, projectile_token(attack2_projectile, source_number),
        spell1_chance, spell1, spell2_chance, spell2,
        elemental_resistance, elemental_resistance, elemental_resistance, elemental_resistance,
        spirit_resistance, spirit_resistance, spirit_resistance,
        resistance(source_value(row, "light_resistance")),
        resistance(source_value(row, "dark_resistance")),
        resistance(source_value(row, "physical_resistance")), "0",
    ]


def write_rows(path: Path, rows: list[list[str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as output_file:
        csv.writer(output_file, delimiter="\t", lineterminator="\n").writerows(rows)


def write_audit(path: Path, sources: dict[int, list[str]], replacements: dict[int, int]) -> None:
    rows = [[
        "mm9_source_number", "runtime_id", "name", "legacy_visual_id", "source_projectile1",
        "mapped_projectile1", "source_spell1", "mapped_spell1", "source_spell2", "mapped_spell2",
        "source_elemental_resistance", "source_spirit_resistance", "source_recovery",
        "mapped_recovery_ticks", "source_resurrect", "source_attack3",
    ]]
    for source_number, legacy_actor_id in sorted(replacements.items()):
        row = sources[source_number]
        _, spell1, _, spell2, _ = spell_columns(row, source_number)
        rows.append([
            str(source_number), str(MM9_MONSTER_ID_BASE + source_number), source_value(row, "name"),
            str(legacy_actor_id), source_value(row, "attack1_projectile"),
            projectile_token(source_value(row, "attack1_projectile"), source_number),
            source_value(row, "spell1"), spell1, source_value(row, "spell2"), spell2,
            source_value(row, "elemental_resistance"), source_value(row, "spirit_resistance"),
            source_value(row, "recovery"), recovery_ticks(row), source_value(row, "resurrect"),
            source_value(row, "attack3_projectile") or source_value(row, "attack3_damage"),
        ])
    write_rows(path, rows)


def generate_tables(
    source_monsters_path: Path,
    replacements_path: Path,
    base_monster_data_path: Path,
    base_descriptors_path: Path,
    output_dir: Path,
) -> tuple[int, int]:
    sources = source_monsters(source_monsters_path)
    replacements = replacement_ids(replacements_path)
    data_rows, data_by_id = numeric_rows(base_monster_data_path)
    descriptor_rows, descriptors_by_id = numeric_rows(base_descriptors_path)

    generated_data = [row for row in data_rows if not row or not re.fullmatch(r"\d+", row[0].strip())]
    generated_descriptors = [
        row for row in descriptor_rows if not row or not re.fullmatch(r"\d+", row[0].strip())
    ]

    missing_sources = sorted(set(replacements) - set(sources))
    unclassified_sources = sorted(set(sources) - set(replacements))
    if missing_sources or unclassified_sources:
        raise ValueError(
            f"MM9 monster replacement coverage mismatch: missing={missing_sources}, "
            f"unclassified={unclassified_sources}"
        )

    for source_number, legacy_actor_id in sorted(replacements.items()):
        source_row = sources[source_number]
        base_data = data_by_id.get(legacy_actor_id)
        base_descriptor = descriptors_by_id.get(legacy_actor_id)
        if base_data is None or base_descriptor is None:
            raise ValueError(
                f"Cannot generate MM9 monster {source_number}: missing legacy visual actor "
                f"{legacy_actor_id} tables"
            )

        generated_data.append(build_data_row(source_number, source_row, base_data))

        descriptor_row = list(base_descriptor)
        descriptor_row[0] = str(MM9_MONSTER_ID_BASE + source_number)
        descriptor_row[1] = internal_name(source_number, source_value(source_row, "name"))
        generated_descriptors.append(descriptor_row)

    write_rows(output_dir / "monster_data.txt", generated_data)
    write_rows(output_dir / "monster_descriptors.txt", generated_descriptors)
    write_audit(output_dir / "monster_conversion_audit.tsv", sources, replacements)
    return len(generated_data), len(replacements)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-monsters", type=Path, default=Path("mm9/extracted/DATA/DATA/MONSTERS.txt"))
    parser.add_argument(
        "--replacements", type=Path,
        default=Path("tools/mm9_import_discovery/mm9_monster_legacy_replacements.tsv"),
    )
    parser.add_argument(
        "--base-monster-data", type=Path,
        default=Path("assets_dev/engine/data_tables/monster_data.txt"),
    )
    parser.add_argument(
        "--base-descriptors", type=Path,
        default=Path("assets_dev/engine/data_tables/monster_descriptors.txt"),
    )
    parser.add_argument(
        "--output-dir", type=Path, default=Path("assets_dev/worlds/mm9/data_tables"),
    )
    args = parser.parse_args()

    _, monster_count = generate_tables(
        args.source_monsters, args.replacements, args.base_monster_data,
        args.base_descriptors, args.output_dir,
    )
    print(f"Generated {monster_count} MM9 monster rows in {args.output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
