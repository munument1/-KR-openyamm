#!/usr/bin/env python3
from __future__ import annotations

import importlib.util
from pathlib import Path
import sys
import tempfile
import unittest

MODULE_PATH = Path(__file__).with_name("sync_map_target_names.py")
TOOLS_PATH = str(MODULE_PATH.parent.resolve())
if TOOLS_PATH not in sys.path:
    sys.path.insert(0, TOOLS_PATH)
SPEC = importlib.util.spec_from_file_location("sync_map_target_names", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
sync_names = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(sync_names)


class SyncMapTargetNamesTests(unittest.TestCase):
    def test_house_name_creates_overlay_and_replaces_event_titles(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            source = root / "assets_dev/worlds/mm8/events/maps/out01.lua"
            source.parent.mkdir(parents=True)
            source.write_text(
                'SetMapMetadata({ contextActions = {\n'
                '[11] = { kind = "enter_house", houseId = 761, targetName = "Hiss\' Hut" },\n'
                '} })\n'
                'RegisterEvent(11, "Hiss\' Hut", function()\n'
                '    evt.EnterHouse(761)\n'
                'end, "Hiss\' Hut")\n',
                encoding="utf-8",
            )
            catalog = {
                "entries": [{
                    "scope": "engine",
                    "source_file": "assets_dev/engine/data_tables/house_data.txt",
                    "record_id": 761,
                    "field": "Name",
                    "source": "Hiss' Hut",
                    "translation": "히스의 오두막",
                }]
            }

            changed, created, scanned = sync_names.synchronize(root, catalog)
            self.assertEqual(scanned, 1)
            self.assertEqual(created, 1)
            self.assertGreaterEqual(changed, 3)

            overlay = root / "korean/overlay/worlds/mm8/events/maps/out01.lua"
            text = overlay.read_text(encoding="utf-8")
            self.assertNotIn('"Hiss\' Hut"', text)
            self.assertEqual(text.count('"히스의 오두막"'), 3)


if __name__ == "__main__":
    unittest.main()
