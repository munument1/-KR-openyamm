#!/usr/bin/env python3
from __future__ import annotations

import unittest
from pathlib import Path


class ContinentGameLabelTests(unittest.TestCase):
    def test_new_game_continents_show_source_game_numbers(self) -> None:
        repo_root = Path(__file__).resolve().parents[2]
        source = (repo_root / "game/ui/screens/NewGameScreen.cpp").read_text(encoding="utf-8")
        self.assertIn('drawContinentGameLabel(jadameRect, "M&M 8");', source)
        self.assertIn('drawContinentGameLabel(antagarichRect, "M&M 7");', source)
        self.assertIn('drawContinentGameLabel(enrothRect, "M&M 6");', source)
        self.assertLess(
            source.index('drawContinentGameLabel(jadameRect, "M&M 8");'),
            source.index('if (jadameState.clicked)'),
        )


if __name__ == "__main__":
    unittest.main()
