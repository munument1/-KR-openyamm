#!/usr/bin/env python3
from __future__ import annotations

import csv
import tempfile
import unittest
from pathlib import Path

from generate_mm9_skill_trainers import GenerationError, generate, topic_definition


def rude_row(rude_id: int, choice: int, prompt: str, next_value: int, payload: int) -> list[str]:
    row = ["0"] * 30
    row[0] = str(rude_id)
    row[1] = str(rude_id)
    row[2] = str(choice)
    row[3] = prompt
    row[4] = "Ready?"
    row[5] = str(next_value)
    row[15] = str(payload)
    return row


def write_csv(path: Path, rows: list[list[str]]) -> None:
    with path.open("w", encoding="utf-8", newline="") as stream:
        csv.writer(stream, lineterminator="\n").writerows(rows)


def teacher_hint(topic_id: int, hint: str) -> list[str]:
    row = rude_row(998, 1, hint, 0, 0)
    row[6] = str(topic_id)
    return row


class GenerateMm9SkillTrainersTests(unittest.TestCase):
    def test_topic_mapping_uses_goal_composite_groups(self) -> None:
        self.assertEqual(topic_definition(2006, 1), ("Blade", "Sword|Dagger", "Expert", 4))
        self.assertEqual(topic_definition(2014, 1), ("Spear", "Spear", "Grandmaster", 10))
        self.assertEqual(
            topic_definition(2038, 1),
            ("Elemental", "FireMagic|AirMagic|WaterMagic|EarthMagic", "Grandmaster", 10),
        )

    def test_generation_crosschecks_hint_and_actor_ownership(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            rude_dir = root / "rude"
            maps_dir = root / "maps"
            scripts_dir = root / "scripts"
            rude_dir.mkdir()
            maps_dir.mkdir()
            scripts_dir.mkdir()
            write_csv(rude_dir / "NPC80.rude", [
                rude_row(80, 1, "Become Expert in Blade", -4, 2006),
                rude_row(80, 2, "Become Master in Blade", -4, 2006),
            ])
            write_csv(rude_dir / "NPCNAME.rude", [["80", "Katrina Vianni"]])
            write_csv(
                rude_dir / "NPC998.rude",
                [teacher_hint(2006, "Katrina Vianni of Sturmford teaches Blade.")],
            )
            (maps_dir / "sturmfordcity.scene.yml").write_text(
                "actors:\n  - script_metadata:\n      mm9_rude_id: 80\n",
                encoding="utf-8",
            )
            (scripts_dir / "MM_STURMFORDCITY.scr").write_text(
                "ArrayPut aGroup1,0,80\n",
                encoding="utf-8",
            )

            records, audit = generate(rude_dir, maps_dir, scripts_dir)

            self.assertEqual(len(records), 2)
            self.assertEqual(records[0]["CanonicalId"], "mm9:trainer/80/1")
            self.assertEqual(records[0]["SharedSkills"], "Sword|Dagger")
            self.assertEqual(records[1]["TargetMastery"], "Master")
            self.assertEqual(records[0]["ActorOwnership"], "static")
            self.assertEqual(audit["summary"]["scheduled_trainer_count"], 1)
            self.assertEqual(audit["summary"]["scheduled_only_trainer_count"], 0)
            self.assertEqual(len(audit["records"][0]["schedule_sources"]), 1)
            self.assertEqual(audit["summary"]["error_count"], 0)

    def test_missing_actor_ownership_is_an_audit_error(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            rude_dir = root / "rude"
            maps_dir = root / "maps"
            scripts_dir = root / "scripts"
            rude_dir.mkdir()
            maps_dir.mkdir()
            scripts_dir.mkdir()
            write_csv(rude_dir / "NPC80.rude", [rude_row(80, 1, "Expert Blade", -4, 2006)])
            write_csv(rude_dir / "NPCNAME.rude", [["80", "Katrina Vianni"]])
            write_csv(
                rude_dir / "NPC998.rude",
                [teacher_hint(2006, "Katrina Vianni of Sturmford teaches Blade.")],
            )

            with self.assertRaisesRegex(GenerationError, "trainer audit contains 1 errors"):
                generate(rude_dir, maps_dir, scripts_dir)

    def test_scheduled_teacher_audit_reports_missing_source_destination_markers(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            rude_dir = root / "rude"
            maps_dir = root / "maps"
            scripts_dir = root / "scripts"
            rude_dir.mkdir()
            maps_dir.mkdir()
            scripts_dir.mkdir()
            write_csv(rude_dir / "NPC412.rude", [rude_row(412, 1, "Grandmaster Bodybuilding", -4, 2071)])
            write_csv(rude_dir / "NPCNAME.rude", [["412", "Stev Palac"]])
            write_csv(
                rude_dir / "NPC998.rude",
                [teacher_hint(2071, "Stev Palac of Yorwick is the Body Building Grandmaster.")],
            )
            (maps_dir / "yorwick.scene.yml").write_text(
                "actors:\n  - script_metadata:\n      mm9_rude_id: 412\n",
                encoding="utf-8",
            )
            (maps_dir / "yorwick.raw_objects.yml").write_text(
                "format_version: 1\nobjects: []\n",
                encoding="utf-8",
            )
            (scripts_dir / "MM_YORWICK.scr").write_text(
                "ArrayPut aGroup4,3,412\n",
                encoding="utf-8",
            )

            records, audit = generate(rude_dir, maps_dir, scripts_dir)

            self.assertEqual(records[0]["ActorOwnership"], "scheduled")
            self.assertEqual(audit["summary"]["unresolved_schedule_destination_count"], 1)
            self.assertEqual(
                audit["records"][0]["schedule_destination_status"],
                "unresolved_missing_destination_markers",
            )
            self.assertEqual(
                audit["records"][0]["missing_schedule_destination_markers"],
                ["Marker_Work_412", "Marker_Home_412", "Marker_Misc_412"],
            )


if __name__ == "__main__":
    unittest.main()
