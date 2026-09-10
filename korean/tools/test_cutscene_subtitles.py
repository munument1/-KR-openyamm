#!/usr/bin/env python3
from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import re
import tempfile
import unittest
import zipfile


class CutsceneSubtitleIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.repo_root = Path(__file__).resolve().parents[2]

    def test_cutscene_screen_loads_srt_and_draws_by_playback_clock(self) -> None:
        source_path = self.repo_root / "game/ui/screens/CutsceneVideoScreen.cpp"
        if not source_path.is_file():
            self.skipTest("CutsceneVideoScreen.cpp is not present in this sparse checkout")
        source = source_path.read_text(encoding="utf-8")
        self.assertIn('"subtitles/" + m_videoStem + ".srt"', source)
        self.assertIn("readTextFile(candidate)", source)
        self.assertIn("m_videoPlayer.playbackSeconds()", source)
        self.assertIn("drawSubtitles(videoRect);", source)
        self.assertIn("wrapUtf8Text(activeText", source)

    def test_video_player_exposes_playback_clock(self) -> None:
        header_path = self.repo_root / "game/audio/HouseVideoPlayer.h"
        if not header_path.is_file():
            self.skipTest("HouseVideoPlayer.h is not present in this sparse checkout")
        source = header_path.read_text(encoding="utf-8")
        self.assertIn("float playbackSeconds() const", source)
        self.assertIn("return m_playbackSeconds;", source)

    def test_coverage_matches_every_runtime_ogv(self) -> None:
        inventory = json.loads((self.repo_root / "korean/subtitles/source_inventory.json").read_text(encoding="utf-8"))
        coverage = json.loads((self.repo_root / "korean/subtitles/coverage.json").read_text(encoding="utf-8"))
        runtime_keys = {(entry["world"], entry["stem"]) for entry in inventory["runtime_videos"]}
        coverage_keys = {(entry["world"], entry["stem"]) for entry in coverage["entries"]}
        self.assertEqual(runtime_keys, coverage_keys)
        self.assertEqual(coverage["summary"]["runtime_videos"], len(runtime_keys))
        self.assertEqual(coverage["summary"]["subtitle_ready"], sum(entry["status"] == "subtitle_ready" for entry in coverage["entries"]))
        self.assertEqual(coverage["summary"]["no_audio"], sum(entry["status"] == "no_audio" for entry in coverage["entries"]))
        self.assertEqual(coverage["summary"]["no_dialogue"], sum(entry["status"] == "no_dialogue" for entry in coverage["entries"]))
        self.assertEqual(coverage["summary"]["review_required"], sum(entry["status"] == "review_required" for entry in coverage["entries"]))

    def test_ready_subtitles_are_valid_utf8_srt_and_within_video_duration(self) -> None:
        coverage = json.loads((self.repo_root / "korean/subtitles/coverage.json").read_text(encoding="utf-8"))
        timing_re = re.compile(r"^(?P<sh>\d{2}):(?P<sm>\d{2}):(?P<ss>\d{2}),(?P<sms>\d{3}) --> (?P<eh>\d{2}):(?P<em>\d{2}):(?P<es>\d{2}),(?P<ems>\d{3})$")

        def seconds(match: re.Match[str], prefix: str) -> float:
            return int(match.group(prefix + "h")) * 3600 + int(match.group(prefix + "m")) * 60 + int(match.group(prefix + "s")) + int(match.group(prefix + "ms")) / 1000.0

        for entry in coverage["entries"]:
            status = entry["status"]
            self.assertIn(status, {"subtitle_ready", "no_audio", "no_dialogue", "review_required"})
            if status == "no_audio":
                self.assertFalse(entry["has_audio"])
                self.assertEqual(entry["subtitle_files"], [])
                continue
            if status == "no_dialogue":
                self.assertTrue(entry["has_audio"])
                self.assertEqual(entry["subtitle_files"], [])
                self.assertTrue(entry["reason"].strip())
                continue
            if status != "subtitle_ready":
                self.assertEqual(entry["subtitle_files"], [])
                continue
            self.assertTrue(entry["has_audio"])
            self.assertTrue(entry["subtitle_files"])
            for relative_path in entry["subtitle_files"]:
                subtitle_path = self.repo_root / relative_path
                raw = subtitle_path.read_bytes()
                text = raw.decode("utf-8")
                self.assertNotIn("\ufffd", text)
                blocks = [block for block in re.split(r"\r?\n\r?\n", text.strip()) if block]
                self.assertGreater(len(blocks), 0, relative_path)
                previous_start = -1.0
                for expected_index, block in enumerate(blocks, 1):
                    lines = block.splitlines()
                    self.assertGreaterEqual(len(lines), 3, relative_path)
                    self.assertEqual(lines[0].strip(), str(expected_index), relative_path)
                    match = timing_re.match(lines[1].strip())
                    self.assertIsNotNone(match, relative_path)
                    assert match is not None
                    start = seconds(match, "s")
                    end = seconds(match, "e")
                    self.assertGreaterEqual(start, previous_start, relative_path)
                    self.assertGreater(end, start, relative_path)
                    self.assertLessEqual(end, float(entry["duration_seconds"]) + 0.5, relative_path)
                    self.assertTrue("\n".join(lines[2:]).strip(), relative_path)
                    previous_start = start

    def test_ready_subtitles_are_in_world_overlay_zip(self) -> None:
        build_patch_path = self.repo_root / "korean/build_patch.py"
        spec = importlib.util.spec_from_file_location("korean_build_patch", build_patch_path)
        assert spec is not None and spec.loader is not None
        build_patch = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(build_patch)
        coverage = json.loads((self.repo_root / "korean/subtitles/coverage.json").read_text(encoding="utf-8"))
        expected_by_world: dict[str, set[str]] = {}
        for entry in coverage["entries"]:
            for relative_path in entry["subtitle_files"]:
                path = Path(relative_path)
                parts = path.parts
                self.assertEqual(parts[:3], ("korean", "overlay", "worlds"))
                world = parts[3]
                archive_name = Path(*parts[4:]).as_posix()
                expected_by_world.setdefault(world, set()).add(archive_name)
        with tempfile.TemporaryDirectory() as temporary_directory:
            temporary_root = Path(temporary_directory)
            for world, expected_names in expected_by_world.items():
                output = temporary_root / f"{world}.zip"
                source = self.repo_root / "korean/overlay/worlds" / world
                count = build_patch.write_overlay_zip(source, output)
                self.assertGreater(count, 0, world)
                with zipfile.ZipFile(output, "r") as archive:
                    names = set(archive.namelist())
                self.assertTrue(expected_names <= names, (world, sorted(expected_names - names)))


if __name__ == "__main__":
    unittest.main()
