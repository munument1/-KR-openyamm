#!/usr/bin/env python3
from __future__ import annotations

import sys
import unittest
from collections import Counter
from pathlib import Path

TOOLS = Path(__file__).resolve().parent
if str(TOOLS) not in sys.path:
    sys.path.insert(0, str(TOOLS))

import apply_mmmerge_116a_feedback as feedback


class Mmerge116aFeedbackTests(unittest.TestCase):
    def item(self, item_id: int, source: str, translation: str, field: str = "Notes") -> dict:
        return {
            "source_file": "assets_dev/engine/data_tables/items.txt",
            "record_id": item_id,
            "field": field,
            "source": source,
            "translation": translation,
            "note": "",
        }

    def test_lore_terms_are_source_aware(self) -> None:
        wonders = self.item(1607, "A weapon forged during the Time of Wonders.", "경이로운 시대에 만들어졌다.")
        feedback.correct_catalog_entry(wonders, Counter())
        self.assertEqual(wonders["translation"], "경이의 시대에 만들어졌다.")

        silence = self.item(807, "These blades were forged before the Silence.", "대재앙 이전에 만들어졌다.")
        feedback.correct_catalog_entry(silence, Counter())
        self.assertEqual(silence["translation"], "침묵의 시대 이전에 만들어졌다.")

        mekorig = self.item(880, "Made by Mekorig the Blind.", "메코리그 더 블라인드가 만들었다.")
        feedback.correct_catalog_entry(mekorig, Counter())
        self.assertEqual(mekorig["translation"], "장님 메코리그가 만들었다.")

    def test_gem_provenance_adds_san_only_for_source_adjectives(self) -> None:
        jadame = self.item(186, "A Jadamean diamond.", "제이덤 다이아몬드입니다.")
        feedback.correct_catalog_entry(jadame, Counter())
        self.assertEqual(jadame["translation"], "제이덤산 다이아몬드입니다.")

        antagarich = self.item(997, "An Antagarichan diamond.", "안타개릭 다이아몬드입니다.")
        feedback.correct_catalog_entry(antagarich, Counter())
        self.assertEqual(antagarich["translation"], "안타개릭산 다이아몬드입니다.")

    def test_specific_item_wording_is_consistent(self) -> None:
        dagger = self.item(821, "A weapon from the Time of Wonders.", "불가사의한 시대의 무기인 이 칼입니다.")
        feedback.correct_catalog_entry(dagger, Counter())
        self.assertIn("경이의 시대", dagger["translation"])
        self.assertIn("단검", dagger["translation"])

        poleaxe = self.item(832, "The Headsman's Poleaxe has a longer blade.", "헤드스맨 폴액스는 날이 깁니다.")
        feedback.correct_catalog_entry(poleaxe, Counter())
        self.assertIn("참수자의 장대도끼", poleaxe["translation"])

        merlin = self.item(2024, "Merlin acts as a reservoir of spell power.", "마법력의 저장소입니다.")
        feedback.correct_catalog_entry(merlin, Counter())
        self.assertIn("주문력의 저장소", merlin["translation"])
        self.assertIn("빠른 공격 회복 속도", merlin["translation"])

    def test_ranged_labels_are_not_bow_only_terms(self) -> None:
        bonus = {
            "source_file": "assets_dev/engine/data_tables/english/stats.txt",
            "record_id": "Shoot Bonus",
            "field": "DisplayName",
            "source": "Shoot Bonus",
            "translation": "사격 보너스",
            "note": "",
        }
        feedback.correct_catalog_entry(bonus, Counter())
        self.assertEqual(bonus["translation"], "원거리 공격 보너스")

        damage = dict(bonus)
        damage.update(record_id="Shoot Damage", source="Shoot Damage", translation="사격 피해")
        feedback.correct_catalog_entry(damage, Counter())
        self.assertEqual(damage["translation"], "원거리 피해")

    def test_shield_gm_and_gods_suffix(self) -> None:
        shield = {
            "source_file": "assets_dev/engine/data_tables/english/skill_des.txt",
            "record_id": "Shield",
            "field": "GrandMaster",
            "source": "Protection as per Shield spell.",
            "translation": "방패(Shield) 주문과 같은 보호 효과",
            "note": "",
        }
        feedback.correct_catalog_entry(shield, Counter())
        self.assertEqual(shield["translation"], "방패 주문 효과 상시 부여")

        gods = {
            "source_file": "assets_dev/engine/data_tables/special_item_enchants.txt",
            "record_id": 2,
            "field": "DisplaySuffix",
            "source": "of The Gods",
            "translation": "[신들]",
            "note": "",
        }
        feedback.correct_catalog_entry(gods, Counter())
        self.assertEqual(gods["translation"], "[신]")

    def test_optional_stat_renaming_is_not_applied(self) -> None:
        # The report explicitly marks 지성/인성 as an optional suggestion.
        # Keep the project's established character-screen terminology.
        intellect = {
            "source_file": "assets_dev/engine/data_tables/english/stats.txt",
            "record_id": "Intellect",
            "field": "DisplayName",
            "source": "Intellect",
            "translation": "지능",
            "note": "",
        }
        changed = feedback.correct_catalog_entry(intellect, Counter())
        self.assertFalse(changed)
        self.assertEqual(intellect["translation"], "지능")


if __name__ == "__main__":
    unittest.main()
