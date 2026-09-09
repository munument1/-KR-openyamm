#!/usr/bin/env python3
from pathlib import Path
import unittest


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


if __name__ == "__main__":
    unittest.main()
