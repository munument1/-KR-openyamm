#!/usr/bin/env python3
from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from korean.tools.sync_map_target_names import catalog_name_maps, synchronize


class MapTargetNameSyncTests(unittest.TestCase):
    def catalog(self) -> dict:
        return {
            "entries": [
                {
                    "source_file": "assets_dev/engine/data_tables/house_data.txt",
                    "record_id": 8,
                    "field": "Name",
                    "source": "The Knight's Blade",
                    "translation": "기사의 칼날",
                },
                {
                    "source_file": "assets_dev/engine/data_tables/map_stats.txt",
                    "record_id": 42,
                    "field": "Name",
                    "source": "The Temple of the Moon",
                    "translation": "달의 신전",
                },
            ]
        }

    def test_catalog_name_maps(self) -> None:
        houses, maps = catalog_name_maps(self.catalog())
        self.assertEqual(houses[8], "기사의 칼날")
        self.assertEqual(maps["The Temple of the Moon"], "달의 신전")

    def test_syncs_house_and_map_metadata(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            maps_dir = root / "korean/overlay/worlds/mm7/events/maps"
            maps_dir.mkdir(parents=True)
            path = maps_dir / "7out01.lua"
            path.write_text(
                '    [2] = { kind = "enter_house", houseId = 8, targetName = "The Knight\'s Blade" },\n'
                '    [3] = { kind = "enter_dungeon", targetMap = "7d06.blv", targetName = "The Temple of the Moon" },\n'
                '    [4] = { kind = "enter_dungeon", targetMap = "7d30.blv", targetName = "램번트 성" },\n',
                encoding="utf-8",
            )
            changed, scanned = synchronize(root, self.catalog())
            self.assertEqual(scanned, 1)
            self.assertEqual(changed, 2)
            result = path.read_text(encoding="utf-8")
            self.assertIn('targetName = "기사의 칼날"', result)
            self.assertIn('targetName = "달의 신전"', result)
            self.assertIn('targetName = "램번트 성"', result)

    def test_unknown_english_target_is_a_failure(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            maps_dir = root / "korean/overlay/worlds/mm7/events/maps"
            maps_dir.mkdir(parents=True)
            (maps_dir / "unknown.lua").write_text(
                '    [1] = { kind = "travel", targetName = "Unknown Place" },\n',
                encoding="utf-8",
            )
            with self.assertRaisesRegex(ValueError, "Unknown Place"):
                synchronize(root, self.catalog())


if __name__ == "__main__":
    unittest.main()
