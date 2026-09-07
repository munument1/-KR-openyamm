"""Regression checks for safe Korean decoration runtime display localization."""

from __future__ import annotations

from pathlib import Path
import unittest


REPOSITORY_ROOT = Path(__file__).resolve().parents[2]


class DecorationRuntimeRouteTests(unittest.TestCase):
    def test_gameplay_interaction_localizes_decoration_only_at_display_boundary(self) -> None:
        source = (REPOSITORY_ROOT / "game/gameplay/GameplayInteractionController.cpp").read_text(encoding="utf-8")

        self.assertIn('#include "game/ui/KoreanDecorationText.h"', source)
        self.assertIn("targetKind == GameplayWorldEventTargetKind::Decoration", source)
        self.assertGreaterEqual(source.count("KoreanRuntimeText::koreanDecorationHint("), 3)

    def test_semantic_decoration_source_is_not_packaged_as_localized_overlay(self) -> None:
        overlay_path = REPOSITORY_ROOT / "korean/overlay/engine/data_tables/decoration_data.txt"
        self.assertFalse(
            overlay_path.exists(),
            "decoration_data.txt Hint values are gameplay keys and must not be localized in the overlay",
        )

    def test_npc_name_profession_composition_has_no_english_article(self) -> None:
        source = (REPOSITORY_ROOT / "game/outdoor/OutdoorInteractionController.cpp").read_text(encoding="utf-8")
        self.assertIn('return resolution->generatedName + " " + pProfession->profession;', source)
        self.assertNotIn('return resolution->generatedName + " the " + pProfession->profession;', source)


if __name__ == "__main__":
    unittest.main()
