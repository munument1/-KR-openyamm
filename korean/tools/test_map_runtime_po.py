#!/usr/bin/env python3
from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import sys
import tempfile
import unittest

MODULE_PATH = Path(__file__).with_name("extend_map_runtime_catalog.py")
TOOLS_PATH = str(MODULE_PATH.parent.resolve())
if TOOLS_PATH not in sys.path:
    sys.path.insert(0, TOOLS_PATH)
SPEC = importlib.util.spec_from_file_location("extend_map_runtime_catalog", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
runtime_po = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(runtime_po)


class MapRuntimePoTests(unittest.TestCase):
    def test_direct_runtime_po_creates_overlay_and_catalog_entry(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            source = root / "assets_dev/worlds/mm8/events/maps/out01.lua"
            source.parent.mkdir(parents=True)
            source.write_text(
                'RegisterEvent(1, "Drink from the well", function()\n'
                '    evt.StatusText("Refreshing")\n'
                'end, "Drink from the well")\n',
                encoding="utf-8",
            )

            catalog_path = root / "korean/translations/catalog.json"
            catalog_path.parent.mkdir(parents=True)
            catalog_path.write_text(
                json.dumps({"format": 1, "entries": [], "tables": [], "summary": {}}),
                encoding="utf-8",
            )
            po_path = root / "korean/translations/ko.po"
            po_path.write_text(
                '# test\n'
                'msgid ""\n'
                'msgstr ""\n\n'
                'msgctxt "world:mm8:out01.lua:runtime:drink_from_well"\n'
                'msgid "Drink from the well"\n'
                'msgstr "우물물을 마십니다."\n\n'
                'msgctxt "world:mm8:out01.lua:runtime:refreshing"\n'
                'msgid "Refreshing"\n'
                'msgstr "상쾌합니다."\n',
                encoding="utf-8",
            )

            entries, files = runtime_po.apply_runtime_po(root, catalog_path, po_path)
            self.assertEqual(entries, 2)
            self.assertEqual(files, 1)

            overlay = root / "korean/overlay/worlds/mm8/events/maps/out01.lua"
            text = overlay.read_text(encoding="utf-8")
            self.assertNotIn('"Drink from the well"', text)
            self.assertNotIn('"Refreshing"', text)
            self.assertIn('"우물물을 마십니다."', text)
            self.assertIn('"상쾌합니다."', text)

            catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
            keys = {entry["key"] for entry in catalog["entries"]}
            self.assertIn("world:mm8:out01.lua:runtime:drink_from_well", keys)
            self.assertIn("world:mm8:out01.lua:runtime:refreshing", keys)

    def test_stale_direct_runtime_literal_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            source = root / "assets_dev/worlds/mm8/events/maps/out01.lua"
            source.parent.mkdir(parents=True)
            source.write_text('evt.StatusText("Different")\n', encoding="utf-8")

            catalog_path = root / "korean/translations/catalog.json"
            catalog_path.parent.mkdir(parents=True)
            catalog_path.write_text(
                json.dumps({"format": 1, "entries": [], "tables": [], "summary": {}}),
                encoding="utf-8",
            )
            po_path = root / "korean/translations/ko.po"
            po_path.write_text(
                'msgctxt "world:mm8:out01.lua:runtime:refreshing"\n'
                'msgid "Refreshing"\n'
                'msgstr "상쾌합니다."\n',
                encoding="utf-8",
            )

            with self.assertRaisesRegex(ValueError, "stale or missing"):
                runtime_po.apply_runtime_po(root, catalog_path, po_path)


if __name__ == "__main__":
    unittest.main()
