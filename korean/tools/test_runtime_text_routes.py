"""Regression checks for screens that draw localized runtime text directly."""

from __future__ import annotations

from pathlib import Path
import unittest


REPOSITORY_ROOT = Path(__file__).resolve().parents[2]


class RuntimeTextRouteTests(unittest.TestCase):
    def test_direct_text_screens_localize_before_measuring_and_drawing(self) -> None:
        screens = (
            REPOSITORY_ROOT / "game/ui/screens/ArcomageScreen.cpp",
            REPOSITORY_ROOT / "game/ui/screens/LoadGameScreen.cpp",
        )

        for screen in screens:
            source = screen.read_text(encoding="utf-8")
            self.assertIn('#include "game/ui/KoreanRuntimeTextOverrides.h"', source)
            self.assertIn(
                "KoreanRuntimeText::koreanRuntimeTextOverride(text).value_or(text)",
                source,
            )
            self.assertIn("localizedText", source)


if __name__ == "__main__":
    unittest.main()
