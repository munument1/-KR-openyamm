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
    def make_media_root(self, root: Path) -> tuple[Path, Path]:
        magic = root / "data/Anims/Magicdod.vid"
        might = root / "data/Anims/mightdod.vid"
        magic.mkdir(parents=True)
        might.mkdir(parents=True)
        return magic, might

    def test_inventory_cross_references_runtime_movie_stems_and_ogv_assets(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            magic, might = self.make_media_root(root)
            (magic / "intro.bik").write_bytes(b"BIK")
            (magic / "overrept.bik").write_bytes(b"BIK")
            (might / "Nmagshp.smk").write_bytes(b"SMK")

            event_dir = root / "assets_dev/worlds/mm8/events/maps"
            event_dir.mkdir(parents=True)
            (event_dir / "out01_intro.lua").write_text(
                'evt.ShowMovie("intro", true)\n', encoding="utf-8"
            )
            (event_dir / "out03_mmmerge.lua").write_text(
                'evt.ShowMovie("\\\"overrept\\\"", true)\n', encoding="utf-8"
            )

            cutscene_dir = root / "assets_dev/worlds/mm8/videos/Cutscenes"
            cutscene_dir.mkdir(parents=True)
            (cutscene_dir / "intro.ogv").write_bytes(b"OGV")
            (cutscene_dir / "overrept.ogv").write_bytes(b"OGV")
            (cutscene_dir / "unused_logo.ogv").write_bytes(b"OGV")

            tables = root / "assets_dev/engine/data_tables"
            tables.mkdir(parents=True)
            (tables / "house_animations.txt").write_text(
                '42\tNmagshp\n', encoding="utf-8"
            )

            game_dir = root / "game/app"
            game_dir.mkdir(parents=True)
            (game_dir / "GameApplication.cpp").write_text(
                'constexpr const char *PartyDefeatCutsceneStem = "LoseGame";\n'
                'constexpr const char *WinGameCutsceneStem = "wingame";\n'
                'const char *a = "6losegame";\n'
                'const char *b = "7losegame";\n',
                encoding="utf-8",
            )

            inventory = inventory_tool.build_inventory(root)
            self.assertEqual(inventory["format"], 3)
            self.assertEqual(inventory["summary"]["media"], 3)
            self.assertEqual(inventory["summary"]["runtime_videos"], 3)
            self.assertEqual(inventory["summary"]["runtime_videos_referenced"], 2)
            self.assertEqual(inventory["summary"]["runtime_videos_unreferenced"], 1)
            self.assertEqual(inventory["summary"]["by_extension"], {".bik": 2, ".smk": 1})

            runtime = {entry["stem"].casefold(): entry for entry in inventory["runtime_stems"]}
            self.assertIn("intro", runtime)
            self.assertIn("overrept", runtime)
            self.assertIn("losegame", runtime)
            self.assertIn("6losegame", runtime)
            self.assertIn("7losegame", runtime)
            self.assertIn("wingame", runtime)
            self.assertEqual(runtime["intro"]["worlds"], ["mm8"])
            self.assertIn("mmmerge", runtime["overrept"]["variants"])
            self.assertEqual(runtime["intro"]["source_media"], ["data/Anims/Magicdod.vid/intro.bik"])
            self.assertEqual(runtime["intro"]["runtime_video_assets"], ["assets_dev/worlds/mm8/videos/Cutscenes/intro.ogv"])
            self.assertFalse(runtime["intro"]["runtime_video_missing"])
            self.assertTrue(runtime["6losegame"]["source_missing"])
            self.assertTrue(runtime["6losegame"]["runtime_video_missing"])

            videos = {entry["stem"].casefold(): entry for entry in inventory["runtime_videos"]}
            self.assertTrue(videos["intro"]["referenced"])
            self.assertTrue(videos["overrept"]["referenced"])
            self.assertFalse(videos["unused_logo"]["referenced"])
            self.assertEqual(videos["intro"]["subtitle_path"], "subtitles/intro.srt")

            media = {entry["stem"].casefold(): entry for entry in inventory["entries"]}
            self.assertEqual(media["intro"]["subtitle_candidate"], "runtime_candidate")
            self.assertEqual(media["overrept"]["subtitle_candidate"], "runtime_candidate")
            self.assertEqual(media["nmagshp"]["subtitle_candidate"], "building_animation")

    def test_runtime_video_inventory_preserves_world_and_stem(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            self.make_media_root(root)
            mm6 = root / "assets_dev/worlds/mm6/videos/Cutscenes"
            mm7 = root / "assets_dev/worlds/mm7/videos/Cutscenes"
            mm6.mkdir(parents=True)
            mm7.mkdir(parents=True)
            (mm6 / "6intro.ogv").write_bytes(b"OGV")
            (mm7 / "intro post.ogv").write_bytes(b"OGV")

            videos = inventory_tool.runtime_video_entries(root)
            self.assertEqual(
                [(entry["world"], entry["stem"]) for entry in videos],
                [("mm6", "6intro"), ("mm7", "intro post")],
            )

    def test_movie_stem_normalization_only_removes_wrapper_quotes(self) -> None:
        self.assertEqual(inventory_tool.normalize_movie_stem(r'\"overrept\"'), "overrept")
        self.assertEqual(inventory_tool.normalize_movie_stem("DragonHunters"), "DragonHunters")

    def test_missing_animation_root_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            with self.assertRaisesRegex(ValueError, "Legacy animation root is missing"):
                inventory_tool.build_inventory(Path(temporary_directory))


if __name__ == "__main__":
    unittest.main()
