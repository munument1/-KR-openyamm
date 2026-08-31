#!/usr/bin/env python3
from __future__ import annotations

import unittest
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import generate_mm9_monster_tables as generator


def source_row(**values: str) -> list[str]:
    row = ["0"] * generator.SOURCE_COLUMN_COUNT
    defaults = {
        "number": "1", "name": "Test Monster", "level": "20", "hp": "120", "ac": "30",
        "experience": "900", "treasure_type": "Item", "fly": "0", "move": "5",
        "walk_velocity": "75", "run_velocity": "250", "fly_velocity": "0",
        "recovery": "30", "bonus": "0", "attack1_type": "Elem",
        "attack1_damage": "3D7+4", "attack1_projectile": "GreenThingy",
        "attack2_chance": "50", "attack2_type": "Phys", "attack2_damage": "2D6",
        "attack2_projectile": "0", "spell1_chance": "0", "spell1": "0",
        "spell2_chance": "0", "spell2": "0", "elemental_resistance": "30",
        "spirit_resistance": "40", "dark_resistance": "50", "light_resistance": "60",
        "physical_resistance": "70", "script": "baserange.scr", "is_monster": "1",
        "hostility_group": "4", "treasure_level": "3", "attack3_projectile": "0",
        "attack3_chance": "0", "attack3_type": "0", "attack3_damage": "0", "resurrect": "0",
    }
    defaults.update(values)
    for name, value in defaults.items():
        row[generator.SOURCE_COLUMN[name]] = value
    return row


class Mm9MonsterTableGenerationTests(unittest.TestCase):
    def test_source_stats_and_resistance_families_are_preserved(self) -> None:
        row = generator.build_data_row(1, source_row(), ["0"] * 39)

        self.assertEqual(row[3:7], ["20", "120", "30", "900"])
        self.assertEqual(row[13], "640")
        self.assertEqual(row[14], "180")
        self.assertEqual(row[17:20], ["Earth", "3D7+4", "Earth"])
        self.assertEqual(row[28:32], ["30", "30", "30", "30"])
        self.assertEqual(row[32:35], ["40", "40", "40"])
        self.assertEqual(row[35:38], ["60", "50", "70"])

    def test_immunity_and_physical_projectile_adaptation(self) -> None:
        source = source_row(
            attack1_type="Phys", attack1_projectile="Axe",
            elemental_resistance="1000", spirit_resistance="1000",
        )
        row = generator.build_data_row(1, source, ["0"] * 39)

        self.assertEqual(row[19], "MM9Axe")
        self.assertEqual(row[28:35], ["Imm"] * 7)

    def test_zero_chance_second_spell_is_spell_one_complement(self) -> None:
        source = source_row(
            attack1_projectile="Spell", spell1_chance="50", spell1="40,E,6,4 (Sparks)",
            spell2_chance="0", spell2="12,E,6,1 (Elemental Bolt)",
        )
        row = generator.build_data_row(1, source, ["0"] * 39)

        self.assertEqual(row[24:28], ["50", "Sparks,E,6", "50", "Lightning Bolt,E,6"])

    def test_concat_spell_becomes_on_hit_condition(self) -> None:
        source = source_row(
            attack1_type="Phys", attack1_projectile="0", spell1_chance="concat",
            spell1="31,N,5,3 (Poison)", spell2_chance="100", spell2="8,E,5,1 (Disease)",
        )
        row = generator.build_data_row(1, source, ["0"] * 39)

        self.assertEqual(row[16], "Poison2")
        self.assertEqual(row[24:28], ["0", "0", "100", "Toxic Cloud,E,5"])

    def test_unknown_tokens_fail_loudly(self) -> None:
        with self.assertRaisesRegex(ValueError, "unsupported projectile"):
            generator.build_data_row(
                1, source_row(attack1_projectile="UnmappedProjectile"), ["0"] * 39,
            )

    def test_flying_velocity_and_third_projectile_are_adapted(self) -> None:
        source = source_row(
            fly="1", walk_velocity="0", run_velocity="0", fly_velocity="250",
            attack3_projectile="DragonBreath2", attack3_type="Elem",
            attack3_damage="24D10+100",
        )
        row = generator.build_data_row(1, source, ["0"] * 39)

        self.assertEqual(row[13], "640")
        self.assertEqual(row[21:24], ["Fire", "24D10+100", "Fire"])


if __name__ == "__main__":
    unittest.main()
