"""Regression check for Korean generated NPC display-name composition."""

from __future__ import annotations

from pathlib import Path
import unittest


REPOSITORY_ROOT = Path(__file__).resolve().parents[2]


class NpcDisplayNameTests(unittest.TestCase):
    def test_generated_npc_name_does_not_use_english_article(self) -> None:
        source_path = REPOSITORY_ROOT / "game/outdoor/OutdoorInteractionController.cpp"
        if not source_path.is_file():
            self.skipTest("OutdoorInteractionController.cpp is outside the sparse release-overlay checkout")
        source = source_path.read_text(encoding="utf-8")

        self.assertNotIn(
            'resolution->generatedName + " the " + pProfession->profession',
            source,
        )
        self.assertIn(
            'resolution->generatedName + " " + pProfession->profession',
            source,
        )


if __name__ == "__main__":
    unittest.main()
