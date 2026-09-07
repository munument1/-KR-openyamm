#!/usr/bin/env python3
from __future__ import annotations

import unittest

import apply_review_feedback_corrections as feedback


class ReviewFeedbackCorrectionTests(unittest.TestCase):
    def test_global_terms_use_reviewed_forms(self) -> None:
        source = (
            "자다메 자데임 안타가리치 안타가리찬산 마컴 "
            "포피스냅스 포피스냅 파피스냅 과부쥐 열매 과부딸기 "
            "위도우윕 열매 위도윕 열매 과부쓸이 열매 "
            "사드래곤하려면 늑대 눈을"
        )
        corrected, _ = feedback.apply_replacements(source, feedback.GLOBAL_REPLACEMENTS)
        self.assertEqual(
            corrected,
            (
                "제이덤 제이덤 안타개릭 안타개릭산 마크햄 "
                "양귀비꽃 양귀비꽃 양귀비꽃 위도우스위프 열매 위도우스위프 열매 "
                "위도우스위프 열매 위도우스위프 열매 위도우스위프 열매 "
                "사용하려면 늑대의 눈을"
            ),
        )
        self.assertNotIn("양귀비꽃스", corrected)

    def test_garnet_correction_is_limited_to_items(self) -> None:
        item_entry = {
            "key": "engine:items.txt:213:Notes",
            "source_file": "assets_dev/engine/data_tables/items.txt",
            "record_id": 213,
            "translation": "가넷은 노란색 물약을 만드는 데 사용합니다.",
            "note": "",
        }
        npc_entry = {
            "key": "engine:npc.txt:741:Name",
            "source_file": "assets_dev/engine/data_tables/npc.txt",
            "record_id": 741,
            "translation": "켈리 가넷",
            "note": "",
        }

        changed, _ = feedback.correct_catalog_entry(item_entry)
        self.assertTrue(changed)
        self.assertEqual(item_entry["translation"], "석류석은 노란색 물약을 만드는 데 사용합니다.")

        changed, _ = feedback.correct_catalog_entry(npc_entry)
        self.assertFalse(changed)
        self.assertEqual(npc_entry["translation"], "켈리 가넷")

    def test_speed_attribute_correction_does_not_touch_movement_speed(self) -> None:
        speed_item = {
            "key": "engine:items.txt:518:Notes",
            "source_file": "assets_dev/engine/data_tables/items.txt",
            "record_id": 518,
            "translation": "(이동 속도 +30, 신속, 수면 면역)",
            "note": "",
        }
        slow_item = {
            "key": "engine:items.txt:523:Notes",
            "source_file": "assets_dev/engine/data_tables/items.txt",
            "record_id": 523,
            "translation": "(대상 이동 속도 감소, 물 저항 -50)",
            "note": "",
        }
        spell = {
            "key": "engine:spells.txt:35:Description",
            "source_file": "assets_dev/engine/data_tables/spells.txt",
            "record_id": 35,
            "translation": "대상의 이동 속도를 절반으로 줄입니다.",
            "note": "",
        }

        feedback.correct_catalog_entry(speed_item)
        feedback.correct_catalog_entry(slow_item)
        feedback.correct_catalog_entry(spell)

        self.assertEqual(speed_item["translation"], "(속도 +30, 신속, 수면 면역)")
        self.assertEqual(slow_item["translation"], "(대상 이동 속도 감소, 물 저항 -50)")
        self.assertEqual(spell["translation"], "대상의 이동 속도를 절반으로 줄입니다.")

    def test_items_tsv_preserves_non_attribute_movement_speed(self) -> None:
        source = (
            "ID\tName\tNotes\n"
            "518\tBoots\t(이동 속도 +30)\n"
            "523\tSnake\t(대상 이동 속도 감소)\n"
            "992\tGreen Garnet\t안타가리찬산 녹색 가넷\n"
        )
        corrected, _ = feedback.correct_items_tsv(source)
        self.assertIn("518\tBoots\t(속도 +30)", corrected)
        self.assertIn("523\tSnake\t(대상 이동 속도 감소)", corrected)
        self.assertIn("992\tGreen Garnet\t안타개릭산 녹색 석류석", corrected)


if __name__ == "__main__":
    unittest.main()
