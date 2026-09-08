#!/usr/bin/env python3
from __future__ import annotations

import csv
import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


class RecordAndHoverLocalizationGuards(unittest.TestCase):
    def test_journal_body_text_has_no_shadow(self) -> None:
        source = (ROOT / "game/ui/GameplayPartyOverlayRenderer.cpp").read_text(encoding="utf-8")
        start = source.index("void GameplayPartyOverlayRenderer::renderJournalOverlay")
        end = source.index("void GameplayPartyOverlayRenderer::renderUtilitySpellOverlay", start)
        journal = source[start:end]

        # Quest and autonote stacked entries are black parchment body text.
        stacked_call = re.compile(
            r"renderHudLines\(context, \*bodyFont, pTextLayout->textColorAbgr, "
            r"entry\.lines, textResolved->x, textY, bodyFontScale, false\);"
        )
        self.assertEqual(len(stacked_call.findall(journal)), 2)
        # Story/history body text uses the same no-shadow policy.
        self.assertIn(
            "renderHudLines(context, *bodyFont, pTextLayout->textColorAbgr, bodyLines, "
            "textResolved->x, textResolved->y, bodyFontScale, false);",
            journal,
        )
        # The title still goes through the normal layout-label renderer, so this
        # change is body-only and does not globally disable HUD shadows.
        self.assertIn("context.renderLayoutLabel(*pTitleLayout, *titleResolved, titleText);", journal)

    def test_keg_anvil_sign_have_runtime_korean_names(self) -> None:
        source = (ROOT / "game/ui/KoreanDecorationText.h").read_text(encoding="utf-8")
        for english, korean in (("keg", "작은 통"), ("anvil", "모루"), ("sign", "표지판")):
            self.assertIn(f'{{"{english}", "{korean}"}}', source)

    def test_hover_status_uses_shared_runtime_localizer(self) -> None:
        source = (ROOT / "game/gameplay/GameplayInteractionController.cpp").read_text(encoding="utf-8")
        start = source.index("GameplayInteractionController::resolveHoverStatusText")
        end = source.index("GameplayInteractionController::WorldInteractionPointerPolicy", start)
        hover = source[start:end]
        self.assertIn(
            "return localizeInteractionDisplayText(*payload.eventTargetStatusText);",
            hover,
        )
        self.assertIn("return KoreanRuntimeText::koreanDecorationHint(text);", source)

    def test_decoration_hint_vocabulary_is_exhaustive(self) -> None:
        source_path = ROOT / "assets_dev/engine/data_tables/decoration_data.txt"
        reviewed_path = ROOT / "korean/translations/decoration_hints.json"
        rows = list(csv.reader(source_path.read_text(encoding="utf-8-sig").splitlines(), delimiter="\t"))
        reviewed = json.loads(reviewed_path.read_text(encoding="utf-8"))
        translated = {str(key).strip().casefold() for key in reviewed.get("entries", {})}
        excluded = {str(value).strip().casefold() for value in reviewed.get("excluded_sources", [])}
        hints = {
            row[2].strip()
            for row in rows
            if len(row) > 2 and row[0].strip().isdigit() and row[2].strip()
        }
        unknown = sorted(
            hint for hint in hints
            if hint.casefold() not in translated and hint.casefold() not in excluded
        )
        self.assertEqual(unknown, [])

    def test_generated_map_target_names_are_synchronized_before_packaging(self) -> None:
        build_patch = (ROOT / "korean/build_patch.py").read_text(encoding="utf-8")
        self.assertIn('repo_root / "korean" / "tools" / "sync_map_target_names.py"', build_patch)


if __name__ == "__main__":
    unittest.main()
