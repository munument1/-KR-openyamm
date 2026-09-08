#!/usr/bin/env python3
from __future__ import annotations

import csv
import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]


class JournalAndHoverLocalizationTests(unittest.TestCase):
    def test_journal_body_text_has_no_shadow(self):
        path = ROOT / 'game/ui/GameplayPartyOverlayRenderer.cpp'
        if not path.is_file():
            self.skipTest('journal renderer is not present in this checkout')
        text = path.read_text(encoding='utf-8')
        start = text.index('void GameplayPartyOverlayRenderer::renderJournalOverlay')
        end = text.index('void GameplayPartyOverlayRenderer::renderUtilitySpellOverlay', start)
        block = text[start:end]
        shadowless_entry = 'renderHudLines(context, *bodyFont, pTextLayout->textColorAbgr, entry.lines, textResolved->x, textY, bodyFontScale, false);'
        self.assertEqual(block.count(shadowless_entry), 2)
        self.assertIn(
            'renderHudLines(context, *bodyFont, pTextLayout->textColorAbgr, bodyLines, textResolved->x, textResolved->y, bodyFontScale, false);',
            block,
        )

    def test_core_interaction_object_names_are_localized(self):
        path = ROOT / 'game/ui/KoreanDecorationText.h'
        if not path.is_file():
            self.skipTest('runtime decoration translations are not present in this checkout')
        text = path.read_text(encoding='utf-8')
        expected = {
            'keg': '작은 통',
            'anvil': '모루',
            'well': '우물',
            'fountain': '분수',
            'shrine': '성소',
            'obelisk': '오벨리스크',
            'sign': '표지판',
            'tree': '나무',
            'rock': '바위',
            'flower': '꽃',
            'flowers': '꽃',
        }
        for source, korean in expected.items():
            self.assertIn('{"' + source + '", "' + korean + '"}', text)

    def test_all_decoration_hints_are_mapped_or_explicitly_excluded(self):
        data = ROOT / 'assets_dev/engine/data_tables/decoration_data.txt'
        mapping_path = ROOT / 'korean/translations/decoration_hints.json'
        if not data.is_file() or not mapping_path.is_file():
            self.skipTest('full decoration sources are not present in this checkout')
        rows = list(csv.reader(data.read_text(encoding='utf-8-sig').splitlines(), delimiter='\t'))
        mapping = json.loads(mapping_path.read_text(encoding='utf-8'))
        entries = {str(k).strip().casefold() for k in mapping.get('entries', {})}
        excluded = {str(x).strip().casefold() for x in mapping.get('excluded_sources', [])}
        hints = {
            row[2].strip()
            for row in rows
            if len(row) > 2 and row[0].strip().isdigit() and row[2].strip()
        }
        unknown = sorted(
            hint for hint in hints
            if hint.casefold() not in entries and hint.casefold() not in excluded
        )
        self.assertEqual(unknown, [])

    def test_all_event_target_labels_cross_localization_boundary(self):
        path = ROOT / 'game/gameplay/GameplayInteractionController.cpp'
        if not path.is_file():
            self.skipTest('interaction controller is not present in this checkout')
        text = path.read_text(encoding='utf-8')
        self.assertIn(
            'if (hit.kind == GameplayWorldHitKind::EventTarget && !action.label.empty())',
            text,
        )
        self.assertIn('action.label = localizeInteractionDisplayText(action.label);', text)
        self.assertIn('KoreanRuntimeText::koreanRuntimeTextOverride(text)', text)
        self.assertIn('return KoreanRuntimeText::koreanDecorationHint(text);', text)

    def test_map_target_name_sync_is_strict(self):
        path = ROOT / 'korean/tools/sync_map_target_names.py'
        if not path.is_file():
            self.skipTest('map target-name sync tool is not present in this checkout')
        text = path.read_text(encoding='utf-8')
        self.assertIn('house_data.txt', text)
        self.assertIn('map_stats.txt', text)
        self.assertIn('targetName', text)
        self.assertIn('Untranslated generated targetName values remain', text)


if __name__ == '__main__':
    unittest.main()
