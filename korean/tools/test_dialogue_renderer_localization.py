"""Regression check for runtime Korean localization in event-dialogue body text."""

from pathlib import Path
import unittest


REPOSITORY_ROOT = Path(__file__).resolve().parents[2]
RENDERER_PATH = REPOSITORY_ROOT / "game/ui/GameplayDialogueRenderer.cpp"


class DialogueRendererLocalizationTests(unittest.TestCase):
    def test_dialogue_body_localizes_before_measurement_and_rendering(self) -> None:
        source = RENDERER_PATH.read_text(encoding="utf-8")
        self.assertIn('#include "game/ui/KoreanRuntimeTextOverrides.h"', source)
        self.assertIn("std::vector<std::string> localizedDialogueBodyLines;", source)
        self.assertIn(
            "KoreanRuntimeText::koreanRuntimeTextOverride(sourceLine).value_or(sourceLine)",
            source,
        )
        self.assertIn(
            "calculateDialogueBodyTextMetrics(view, effectiveDialogueTextLayout, localizedDialogueBodyLines)",
            source,
        )
        self.assertIn("for (const std::string &sourceLine : localizedDialogueBodyLines)", source)


if __name__ == "__main__":
    unittest.main()
