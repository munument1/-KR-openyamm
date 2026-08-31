#!/usr/bin/env python3

from __future__ import annotations

import csv
import sys
import unittest
from collections import Counter
from pathlib import Path

import yaml

sys.path.insert(0, str(Path(__file__).resolve().parent))
import render_paperdoll_equipment_preview as paperdoll


ROOT = Path(__file__).resolve().parents[2]
MAPPING = Path(__file__).with_name("mm9_equipment_legacy_base_mappings.yml")
MM9_ITEMS = ROOT / "assets_dev/worlds/mm9/data_tables/items.txt"
ENGINE_ITEMS = ROOT / "assets_dev/engine/data_tables/items.txt"
ENGINE_OFFSETS = ROOT / "assets_dev/engine/data_tables/complex_item_pictures.txt"
ENGINE_ICONS = ROOT / "assets_dev/engine/icons"
EQUIPMENT_CATEGORIES = {"Armor", "Helm", "Boots", "Belt"}


def read_table(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="cp1252", newline="") as stream:
        return list(csv.DictReader((line for line in stream if line.strip()), delimiter="\t"))


class Mm9EquipmentLegacyBaseMappingsTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        document = yaml.safe_load(MAPPING.read_text(encoding="utf-8"))
        cls.mappings = document["items"]
        cls.mm9_items = {
            int(row["x_mm9_raw_item_id"]): row
            for row in read_table(MM9_ITEMS)
            if row["Equip Stat"] in EQUIPMENT_CATEGORIES
        }
        cls.engine_items = {
            item.id: item
            for item in paperdoll.read_items(ENGINE_ITEMS, "engine").values()
        }
        cls.engine_offsets = paperdoll.read_complex_picture_offsets(ENGINE_OFFSETS)
        cls.engine_assets = paperdoll.AssetIndex([ENGINE_ICONS])

    def test_mapping_exactly_covers_all_supported_mm9_equipment(self) -> None:
        self.assertEqual(set(self.mappings), set(self.mm9_items))
        self.assertEqual(
            Counter(mapping["category"] for mapping in self.mappings.values()),
            Counter({"Armor": 35, "Helm": 16, "Boots": 11, "Belt": 6}),
        )

    def test_every_reference_is_a_usable_mm7_or_mm8_equipment_family(self) -> None:
        for raw_id, mapping in self.mappings.items():
            source_row = self.mm9_items[raw_id]
            reference = mapping["reference"]
            reference_item = self.engine_items[reference["item_id"]]

            self.assertEqual(mapping["item_id"], int(source_row["Item #"]))
            self.assertEqual(mapping["name"], source_row["Name"])
            self.assertEqual(mapping["category"], source_row["Equip Stat"])
            self.assertEqual(mapping["normalized_tier"], int(source_row["normalized_tier"]))
            self.assertEqual(reference_item.equip_stat, mapping["category"])
            self.assertEqual(reference_item.name, reference["name"])
            self.assertIn(reference_item.id, self.engine_offsets)

            if reference["world"] == "mm8":
                self.assertGreaterEqual(reference_item.id, 84)
                self.assertLessEqual(reference_item.id, 537)
            else:
                self.assertEqual(reference["world"], "mm7")
                self.assertGreaterEqual(reference_item.id, 868)
                self.assertLessEqual(reference_item.id, 1439)

    def test_every_reference_has_all_equippable_doll_variants(self) -> None:
        for raw_id, mapping in self.mappings.items():
            reference_item = self.engine_items[mapping["reference"]["item_id"]]
            suffixes = ["v1", "v2", "v4", "v5"]

            if mapping["category"] not in {"Helm", "Boots"}:
                suffixes.append("v3")
            if mapping["category"] == "Armor":
                suffixes.extend(["v1a", "v2a", "v3a", "v4a", "v5a"])

            for suffix in suffixes:
                self.assertIsNotNone(
                    self.engine_assets.find(f"{reference_item.icon_name}{suffix}"),
                    f"MM9 raw item {raw_id} reference {reference_item.id} is missing {suffix}",
                )


if __name__ == "__main__":
    unittest.main()
