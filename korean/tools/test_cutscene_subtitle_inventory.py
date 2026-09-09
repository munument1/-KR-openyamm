#!/usr/bin/env python3
from __future__ import annotations

import importlib.util
from pathlib import Path
import tempfile
import unittest

MODULE_PATH = Path(__file__).with_name("build_cutscene_subtitle_inventory.py")
SPEC = importlib.util.spec_from_file_location("build_cutscene_subtitle_inventory", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
inventory_tool = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(inventory_tool)


class CutsceneSubtitleInventoryTests(unittest.TestCase):
    def test_inventory_classifies_media_and_finds_textual_references(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            magic = root / "data/Anims/Magicdod.vid"
            might = root / "data/Anims/mightdod.vid"
            magic.mkdir(parents=True)
            might.mkdir(parents=True)
            (magic / "intro.bik").write_bytes(b"BIK")
            (might / "Nmagshp.smk").write_bytes(b"SMK")

            game = root / "game"
            game.mkdir()
            (game / "Movies.cpp").write_text(
                'playMovie("INTRO.bik");\nopenAnimation("nmagshp");\n',
                encoding="utf-8",
            )

            inventory = inventory_tool.build_inventory(root)
            self.assertEqual(inventory["summary"]["media"], 2)
            self.assertEqual(inventory["summary"]["by_extension"], {".bik": 1, ".smk": 1})
            by_stem = {entry["stem"]: entry for entry in inventory["entries"]}
            self.assertEqual(by_stem["intro"]["subtitle_candidate"], "priority_candidate")
            self.assertEqual(by_stem["Nmagshp"]["subtitle_candidate"], "needs_review")
            self.assertEqual(by_stem["intro"]["subtitle_path"], "subtitles/intro.srt")
            self.assertTrue(by_stem["intro"]["references"])
            self.assertTrue(by_stem["Nmagshp"]["references"])

    def test_missing_animation_root_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            with self.assertRaisesRegex(ValueError, "Legacy animation root is missing"):
                inventory_tool.build_inventory(Path(temporary_directory))


if __name__ == "__main__":
    unittest.main()
