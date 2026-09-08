from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]


class R9RuntimeLocalizationHotfixTests(unittest.TestCase):
    def read_source(self, relative: str) -> str:
        path = ROOT / relative
        if not path.exists():
            self.skipTest(f"source-only check: {relative} not present in sparse checkout")
        return path.read_text(encoding="utf-8")

    def test_status_bar_uses_korean_runtime_override(self) -> None:
        source = self.read_source("game/gameplay/GameplayScreenRuntime.cpp")
        self.assertIn(
            "KoreanRuntimeText::koreanRuntimeTextOverride(text).value_or(text)",
            source,
        )
        self.assertIn("uiController().setStatusBarEvent(localizedText", source)

    def test_event_targets_use_general_localization_route(self) -> None:
        source = self.read_source("game/gameplay/GameplayInteractionController.cpp")
        self.assertIn(
            "localizeInteractionDisplayText(*payload.eventTargetStatusText)",
            source,
        )
        self.assertIn(
            "action.label = localizeInteractionDisplayText(action.label);",
            source,
        )

    def test_well_anvil_and_existing_keg_are_localizable(self) -> None:
        source = self.read_source("game/ui/KoreanDecorationText.h")
        self.assertIn('{"well", "우물"}', source)
        self.assertIn('{"anvil", "모루"}', source)
        self.assertIn('{"keg", "작은 통"}', source)

    def test_journal_body_disables_shadow_only_at_journal_call(self) -> None:
        source = self.read_source("game/ui/GameplayPartyOverlayRenderer.cpp")
        self.assertIn("bool drawShadow = true", source)
        self.assertIn("bodyFontScale, false);", source)
        self.assertIn("if (drawShadow)", source)


if __name__ == "__main__":
    unittest.main()
