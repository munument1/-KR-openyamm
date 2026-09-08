#!/usr/bin/env python3
from __future__ import annotations

import unittest

import apply_deep_review_corrections as review


class DeepReviewCorrectionTests(unittest.TestCase):
    def test_stat_terminology_uses_character_screen_terms(self) -> None:
        intellect = {
            "source_file": "assets_dev/engine/data_tables/items.txt",
            "record_id": 999,
            "field": "Notes",
            "source": "Intellect +20, Accuracy +10, Luck +5",
            "translation": "지력 +20, 정확도 +10, 행운 +5",
            "note": "",
        }
        review.correct_catalog_entry(intellect)
        self.assertEqual(intellect["translation"], "지능 +20, 적중률 +10, 운 +5")

        standard = {
            "source_file": "assets_dev/engine/data_tables/standard_item_enchants.txt",
            "record_id": 1,
            "field": "LocalizedDisplayStat",
            "source": "Intellect",
            "translation": "지력",
            "note": "",
        }
        review.correct_catalog_entry(standard)
        self.assertEqual(standard["translation"], "지능")

    def test_air_body_and_ranged_wording_are_standardized(self) -> None:
        stats = {
            "source_file": "assets_dev/engine/data_tables/english/stats.txt",
            "record_id": 1,
            "field": "Description",
            "source": "Shoot Bonus",
            "translation": "대기 저항과 신체 저항, 장착한 활로 명중시킬 확률",
            "note": "",
        }
        review.correct_catalog_entry(stats)
        self.assertEqual(stats["translation"], "공기 저항과 육체 저항, 장착한 원거리 무기로 명중시킬 확률")

        skill = {
            "source_file": "assets_dev/engine/data_tables/english/skill_des.txt",
            "record_id": 1,
            "field": "LocalizedName",
            "source": "Air Magic",
            "translation": "대기 마법",
            "note": "",
        }
        review.correct_catalog_entry(skill)
        self.assertEqual(skill["translation"], "공기 마법")

    def test_bulk_replacement_corruption_is_repaired(self) -> None:
        text = "날카로행운 아름다행운 가까행운 갑작스러행운 영광스러행운 기행운 불행운하게"
        counts = review.Counter()
        corrected = review.replace_all(text, review.BROKEN_WORD_REPLACEMENTS, counts)
        self.assertEqual(
            corrected,
            "날카로운 아름다운 가까운 갑작스러운 영광스러운 기운 불운하게",
        )

    def test_specific_item_effects_are_reviewed(self) -> None:
        def corrected(item_id: int, source: str, translation: str) -> str:
            entry = {
                "source_file": "assets_dev/engine/data_tables/items.txt",
                "record_id": item_id,
                "field": "Notes",
                "source": source,
                "translation": translation,
                "note": "",
            }
            review.correct_catalog_entry(entry)
            return entry["translation"]

        cure = corrected(222, "Heals 10 plus potion strength hit points", "물약 효능만큼 체력을 회복합니다.")
        self.assertTrue(cure.startswith("생명력을 10 + 물약 효능만큼 회복합니다."))

        hades = corrected(2035, "Negative Regeneration, +20 Luck", "재생력 +10, 행운 +20")
        self.assertIn("시간이 지남에 따라 생명력 감소", hades)
        self.assertIn("운 +20", hades)
        self.assertNotIn("재생력 +10", hades)

        aegis = corrected(2043, "Immune to Flesh to Stone effects, Shielding +20 Luck, and -20 Speed", "방패 사용 시 행운 +20")
        self.assertIn("석화 면역", aegis)
        self.assertIn("원거리 투사체 피해 절반", aegis)
        self.assertIn("운 +20", aegis)
        self.assertNotIn("방패 기술 +20", aegis)

    def test_item_name_and_description_use_same_korean_name(self) -> None:
        for item_id, canonical in (
            (1303, "철깃털"),
            (1308, "파쇄자"),
            (1309, "구울베인"),
            (1310, "교수대"),
            (1311, "샤렐"),
            (1312, "율리시스"),
            (1316, "매시"),
            (1320, "어먹"),
            (1326, "타이탄의 허리띠"),
            (2040, "아르테미스"),
        ):
            notes = review.ITEM_FIELD_OVERRIDES[(item_id, "Notes")]
            self.assertIn(canonical, notes)

    def test_wyrm_spitter_is_not_changed_to_splitter(self) -> None:
        source = (
            "Item #\tPic File\tName\tValue\tEquip Stat\tSkill Group\tMod1\tMod2\tmaterial\tID/Rep/St\t"
            "Not identified name\tSprite Index\tVarA\tVarB\tEquip X\tEquip Y\tNotes\n"
            "506\t\t웜 스피터\t0\t\t\t\t\t0\t0\t\t0\t0\t0\t0\t0\t설명\n"
        )
        corrected, _ = review.correct_items_tsv(source)
        self.assertIn("\t웜 스피터\t", corrected)
        self.assertNotIn("웜 스플리터", corrected)

    def test_reagent_wording_uses_neutral_reagent_term(self) -> None:
        entry = {
            "source_file": "assets_dev/engine/data_tables/items.txt",
            "record_id": 777,
            "field": "Notes",
            "source": "A magical reagent. (To use, pick the herb up.)",
            "translation": "특이한 마법의 재료. 사용하려면 약초를 줍고 병을 누르세요.",
            "note": "",
        }
        review.correct_catalog_entry(entry)
        self.assertIn("마법의 시약", entry["translation"])
        self.assertIn("시약을 집어 들고", entry["translation"])
        self.assertNotIn("약초를", entry["translation"])


if __name__ == "__main__":
    unittest.main()
