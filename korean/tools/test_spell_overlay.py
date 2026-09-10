"""Regression checks for the runtime spell-table Korean overlay."""

from __future__ import annotations

import importlib.util
from pathlib import Path
import sys
import tempfile
import unittest


REPOSITORY_ROOT = Path(__file__).resolve().parents[2]
MODULE_PATH = Path(__file__).with_name("build_translation_catalog.py")
MODULE_SPEC = importlib.util.spec_from_file_location("build_translation_catalog", MODULE_PATH)
assert MODULE_SPEC is not None and MODULE_SPEC.loader is not None
CATALOG_BUILDER = importlib.util.module_from_spec(MODULE_SPEC)
sys.modules[MODULE_SPEC.name] = CATALOG_BUILDER
MODULE_SPEC.loader.exec_module(CATALOG_BUILDER)


def mmmerge_root() -> Path:
    for candidate in (REPOSITORY_ROOT / "_mmmerge", REPOSITORY_ROOT / "_codex/mmmerge-full"):
        if (candidate / "Data/Text localization/KO_SpellsTxt.txt").is_file():
            return candidate
    raise FileNotFoundError("MMMerge Korean spell localization source was not checked out")


class SpellOverlayTests(unittest.TestCase):
    def test_active_spell_table_keeps_lookup_name_and_translates_display_fields(self) -> None:
        spec = next(spec for spec in CATALOG_BUILDER.FIELD_OVERLAY_SPECS if spec.overlay_name == "KO_SpellsTxt.txt")
        self.assertEqual(spec.source_relpath, "assets_dev/engine/data_tables/spells.txt")
        self.assertNotIn("Name", spec.fields)

        source_path = REPOSITORY_ROOT / spec.source_relpath
        source_rows, _ = CATALOG_BUILDER.read_tsv(source_path, ("utf-8-sig", "cp1252"))
        source_by_id = {
            int(row[0]): row
            for row in source_rows
            if row and row[0].strip().isdigit()
        }

        temporary_parent = REPOSITORY_ROOT / "_codex"
        temporary_parent.mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(dir=temporary_parent) as temporary_directory:
            overlay_root = Path(temporary_directory)
            entries, stats = CATALOG_BUILDER.build_field_overlay_table(
                REPOSITORY_ROOT,
                mmmerge_root(),
                overlay_root,
                spec,
                CATALOG_BUILDER.load_overrides(REPOSITORY_ROOT / "korean/translations/overrides.json"),
            )
            output_path = overlay_root / "data_tables/spells.txt"
            self.assertTrue(output_path.is_file())
            self.assertFalse((overlay_root / "data_tables/english/spells.txt").exists())
            output_rows, output_encoding = CATALOG_BUILDER.read_tsv(output_path, ("utf-8-sig",))

        self.assertEqual(output_encoding, "utf-8-sig")
        output_by_id = {
            int(row[0]): row
            for row in output_rows
            if row and row[0].strip().isdigit()
        }
        self.assertEqual(set(output_by_id), set(source_by_id))
        self.assertTrue(stats["output_file"].replace("\\", "/").endswith("data_tables/spells.txt"))
        self.assertEqual(stats["untranslated"], 0)
        self.assertEqual(stats["placeholder_mismatches"], 0)
        self.assertTrue(all(entry["status"] == "translated" for entry in entries))

        for record_id, source_row in source_by_id.items():
            output_row = output_by_id[record_id]
            self.assertEqual(output_row[2], source_row[2])
            for column in (0, 1, 3, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23):
                self.assertEqual(output_row[column], source_row[column])

        haste = output_by_id[5]
        self.assertEqual(haste[2], "Haste")
        self.assertEqual(haste[4], "가속")
        self.assertIn("모든 캐릭터", haste[5])
        self.assertIn("지속 시간", haste[7])


if __name__ == "__main__":
    unittest.main()
