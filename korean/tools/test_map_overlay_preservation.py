#!/usr/bin/env python3
from __future__ import annotations

import importlib.util
from pathlib import Path
import tempfile
import unittest

MODULE_PATH = Path(__file__).with_name("build_map_string_overlays.py")
SPEC = importlib.util.spec_from_file_location("build_map_string_overlays", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
module = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(module)


class MapOverlayPreservationTests(unittest.TestCase):
    def test_world_cleanup_removes_only_generated_map_lua(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            world_root = Path(temporary_directory) / "korean/overlay/worlds/mm6"
            map_dir = world_root / "events/maps"
            subtitle_dir = world_root / "subtitles"
            other_event_dir = world_root / "events/custom"
            map_dir.mkdir(parents=True)
            subtitle_dir.mkdir(parents=True)
            other_event_dir.mkdir(parents=True)
            (map_dir / "stale.lua").write_text("stale", encoding="utf-8")
            subtitle = subtitle_dir / "6intro.srt"
            subtitle.write_text("subtitle", encoding="utf-8")
            custom = other_event_dir / "keep.txt"
            custom.write_text("keep", encoding="utf-8")

            module._ScopedShutil().rmtree(world_root)

            self.assertFalse(map_dir.exists())
            self.assertTrue(subtitle.is_file())
            self.assertEqual(subtitle.read_text(encoding="utf-8"), "subtitle")
            self.assertTrue(custom.is_file())

    def test_non_world_cleanup_still_uses_normal_rmtree(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            disposable = Path(temporary_directory) / "cache"
            disposable.mkdir()
            (disposable / "value.txt").write_text("x", encoding="utf-8")
            module._ScopedShutil().rmtree(disposable)
            self.assertFalse(disposable.exists())


if __name__ == "__main__":
    unittest.main()
