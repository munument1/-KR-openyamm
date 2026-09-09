#!/usr/bin/env python3
from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import tempfile
import unittest

MODULE_PATH = Path(__file__).with_name("catalog_po.py")
SPEC = importlib.util.spec_from_file_location("catalog_po", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
catalog_po = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(catalog_po)


class CatalogPoTests(unittest.TestCase):
    def sample_catalog(self) -> dict:
        return {
            "format": 1,
            "entries": [
                {
                    "key": "engine:quests.txt:1:text",
                    "scope": "engine",
                    "source_file": "assets_dev/engine/data_tables/english/quests.txt",
                    "record_id": 1,
                    "field": "text",
                    "source": 'Find the "Orb".\nReturn safely.',
                    "translation": "\"오브\"를 찾아라.\n무사히 돌아와라.",
                    "translation_origin": "mmmerge",
                    "status": "translated",
                    "placeholder_ok": True,
                    "note": "",
                }
            ],
            "tables": [],
            "summary": {},
        }

    def test_export_parse_round_trip_preserves_context_and_newlines(self) -> None:
        catalog = self.sample_catalog()
        po_text = catalog_po.export_catalog(catalog)
        entries = catalog_po.parse_po(po_text)
        self.assertEqual(len(entries), 1)
        self.assertEqual(entries[0]["msgctxt"], "engine:quests.txt:1:text")
        self.assertEqual(entries[0]["msgid"], 'Find the "Orb".\nReturn safely.')
        self.assertEqual(entries[0]["msgstr"], "\"오브\"를 찾아라.\n무사히 돌아와라.")
        changed = catalog_po.import_po(catalog, entries, None, False)
        self.assertEqual(changed, 0)

    def test_stale_msgid_is_rejected(self) -> None:
        catalog = self.sample_catalog()
        entries = catalog_po.parse_po(catalog_po.export_catalog(catalog))
        entries[0]["msgid"] = "Source changed"
        with self.assertRaisesRegex(ValueError, "Stale PO source text"):
            catalog_po.import_po(catalog, entries, None, False)

    def test_placeholder_damage_is_rejected(self) -> None:
        catalog = self.sample_catalog()
        catalog["entries"][0]["source"] = "Gold: %d"
        catalog["entries"][0]["translation"] = "골드: %d"
        entries = catalog_po.parse_po(catalog_po.export_catalog(catalog))
        entries[0]["msgstr"] = "골드"
        with self.assertRaisesRegex(ValueError, "placeholder mismatch"):
            catalog_po.import_po(catalog, entries, None, False)

    def test_engine_tsv_change_is_materialized(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            output = root / "korean/overlay/engine/data_tables/english/quests.txt"
            output.parent.mkdir(parents=True)
            output.write_text("ID\tText\n1\t기존 번역\n", encoding="utf-8")
            catalog = self.sample_catalog()
            catalog["entries"][0]["translation"] = "기존 번역"
            entries = catalog_po.parse_po(catalog_po.export_catalog(catalog))
            entries[0]["msgstr"] = "새 번역"
            changed = catalog_po.import_po(catalog, entries, root, True)
            self.assertEqual(changed, 1)
            self.assertIn("새 번역", output.read_text(encoding="utf-8"))
            self.assertEqual(catalog["entries"][0]["translation_origin"], "po")

    def test_world_lua_change_is_materialized(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            output = root / "korean/overlay/worlds/mm7/events/maps/out01.lua"
            output.parent.mkdir(parents=True)
            output.write_text('evt.StatusText("기존 번역")\n', encoding="utf-8")
            catalog = {
                "entries": [{
                    "key": "world:mm7:out01.str:7",
                    "scope": "world:mm7",
                    "source_file": "assets_dev/worlds/mm7/_legacy/events/out01.str",
                    "record_id": 7,
                    "field": "Text",
                    "source": "Old text",
                    "translation": "기존 번역",
                    "translation_origin": "mmmerge",
                    "status": "translated",
                    "placeholder_ok": True,
                    "note": "",
                }],
                "tables": [],
                "summary": {},
            }
            entries = catalog_po.parse_po(catalog_po.export_catalog(catalog))
            entries[0]["msgstr"] = "새 번역"
            changed = catalog_po.import_po(catalog, entries, root, True)
            self.assertEqual(changed, 1)
            self.assertIn('"새 번역"', output.read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()
