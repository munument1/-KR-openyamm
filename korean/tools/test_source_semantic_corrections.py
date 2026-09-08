#!/usr/bin/env python3
from __future__ import annotations

import tempfile
import unittest
from collections import Counter
from pathlib import Path

import apply_source_semantic_corrections as semantic


class SourceSemanticCorrectionTests(unittest.TestCase):
    def test_source_terms_normalize_upstream_variants(self) -> None:
        samples = (
            ("Global.txt", "Endurance +20", "인내력 +20", "체력 +20"),
            ("Global.txt", "speed +70", "민첩성 +70", "속도 +70"),
            ("Global.txt", "temporary intellect", "일시적 지력", "일시적 지능"),
            ("Global.txt", "permanent accuracy", "영구 정확도", "영구 적중률"),
            ("Global.txt", "Pure Luck", "순수한 행운", "순수한 운"),
            ("spells.txt", "Air Resistance", "대기 저항력", "공기 저항"),
            ("spells.txt", "Body Resistance", "신체 저항력", "육체 저항"),
            ("skill_des.txt", "Earth Magic", "흙 마법", "대지 마법"),
            ("special_item_enchants.txt", "End (+15), AC (+5)", "인내력 +15, 방어도 +5", "체력 +15, 방어도 +5"),
        )
        for source_name, source, translation, expected in samples:
            with self.subTest(source=source):
                actual = semantic.normalize_translation(source_name, source, translation, Counter())
                self.assertEqual(actual, expected)

    def test_item_luck_preserves_natural_prose(self) -> None:
        actual = semantic.normalize_translation(
            "items.txt",
            "+20 Luck; may bring luck to the bearer",
            "행운 +20, 착용자에게 행운을 가져다줍니다",
            Counter(),
        )
        self.assertEqual(actual, "운 +20, 착용자에게 행운을 가져다줍니다")

    def test_catalog_items_are_synchronized_to_overlay(self) -> None:
        catalog = {
            "entries": [
                {
                    "source_file": "assets_dev/engine/data_tables/items.txt",
                    "record_id": 506,
                    "field": "Name",
                    "source": "Wyrm Spitter",
                    "translation": "웜 스피터",
                },
                {
                    "source_file": "assets_dev/engine/data_tables/items.txt",
                    "record_id": 506,
                    "field": "NotIdentifiedName",
                    "source": "Spear",
                    "translation": "창",
                },
                {
                    "source_file": "assets_dev/engine/data_tables/items.txt",
                    "record_id": 506,
                    "field": "Notes",
                    "source": "Endurance +20, Swift",
                    "translation": "체력 +20, 빠른 공격 회복 속도",
                },
            ]
        }
        source = (
            "Item #\tPic File\tName\tValue\tEquip Stat\tSkill Group\tMod1\tMod2\tmaterial\tID/Rep/St\t"
            "Not identified name\tSprite Index\tVarA\tVarB\tEquip X\tEquip Y\tNotes\n"
            "506\t\t웜 스피터\t0\t\t\t\t\t0\t0\t낡은 창\t0\t0\t0\t0\t0\t인내력 +20, 신속\n"
        )
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "items.txt"
            path.write_text(source, encoding="utf-8")
            fields = semantic.catalog_fields_for_table(catalog, "items.txt", {"Name", "NotIdentifiedName", "Notes"})
            changed = semantic.sync_tabular_overlay(
                path,
                fields,
                {"Name": "Name", "NotIdentifiedName": "Not identified name", "Notes": "Notes"},
            )
            corrected = path.read_text(encoding="utf-8")
        self.assertEqual(changed, 2)
        self.assertIn("\t웜 스피터\t", corrected)
        self.assertIn("\t창\t", corrected)
        self.assertIn("체력 +20, 빠른 공격 회복 속도", corrected)
        self.assertNotIn("웜 스플리터", corrected)

    def test_non_item_table_is_synchronized_from_catalog(self) -> None:
        catalog = {
            "entries": [
                {
                    "source_file": "assets_dev/engine/data_tables/english/autonote.txt",
                    "record_id": 407,
                    "field": "text",
                    "source": "10 Points of temporary accuracy",
                    "translation": "일시적으로 적중률 10 증가",
                }
            ]
        }
        source = "Note bit\tAutonote Text\tCategory\n407\t일시적으로 정확도 10 증가\tMisc\n"
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "autonote.txt"
            path.write_text(source, encoding="utf-8")
            fields = semantic.catalog_fields_for_table(catalog, "autonote.txt", {"text"})
            changed = semantic.sync_tabular_overlay(path, fields, {"text": "Autonote Text"})
            corrected = path.read_text(encoding="utf-8")
        self.assertEqual(changed, 1)
        self.assertIn("일시적으로 적중률 10 증가", corrected)
        self.assertNotIn("정확도 10 증가", corrected)

    def test_validation_rejects_stale_semantic_term(self) -> None:
        catalog = {
            "entries": [
                {
                    "key": "engine:items.txt:1:Notes",
                    "source_file": "assets_dev/engine/data_tables/items.txt",
                    "record_id": 1,
                    "field": "Notes",
                    "source": "endurance +10",
                    "translation": "인내력 +10",
                }
            ]
        }
        with self.assertRaises(ValueError):
            semantic.validate_catalog(catalog)


if __name__ == "__main__":
    unittest.main()
