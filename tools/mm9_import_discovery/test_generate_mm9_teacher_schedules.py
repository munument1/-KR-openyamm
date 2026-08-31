from pathlib import Path
import tempfile
import unittest

import yaml

from generate_mm9_teacher_schedules import generate, load_schedule_script


class TeacherScheduleGenerationTests(unittest.TestCase):
    def test_parses_groups_and_all_four_daily_boundaries(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "schedule.scr"
            lines = []
            for group in range(1, 5):
                lines.extend([
                    f"ArrayPut aGroup{group},0,{400 + group}",
                    f"@M 6 : {group} Group{group}_GoWork Group{group}_WarpWork",
                    f"@M 13 : {group} Group{group}_GoMisc Group{group}_WarpMisc",
                    f"@M 15 : {group} Group{group}_GoWork Group{group}_WarpWork",
                    f"@M 18 : {group} Group{group}_GoHome Group{group}_WarpHome",
                ])
            path.write_text("\n".join(lines), encoding="utf-8")
            groups, schedules = load_schedule_script(path)
            self.assertEqual(groups[404], 4)
            self.assertEqual(schedules[4], (364, 784, 904, 1084))

    def test_unresolved_markers_emit_audit_but_no_runtime_row(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            scripts = root / "scripts"
            maps = root / "maps"
            scripts.mkdir()
            maps.mkdir()
            lines = []
            for group in range(1, 5):
                rude_id = 408 if group == 2 else 500 + group
                lines.extend([
                    f"ArrayPut aGroup{group},0,{rude_id}",
                    f"@M 6 : {group} Group{group}_GoWork Group{group}_WarpWork",
                    f"@M 13 : {group} Group{group}_GoMisc Group{group}_WarpMisc",
                    f"@M 15 : {group} Group{group}_GoWork Group{group}_WarpWork",
                    f"@M 18 : {group} Group{group}_GoHome Group{group}_WarpHome",
                ])
            (scripts / "MM_LINDISFARNE.scr").write_text("\n".join(lines), encoding="utf-8")
            (maps / "lindisfarne.scene.yml").write_text(yaml.safe_dump({
                "actors": [{"mm9_rude_id": 408, "mm9_source_object_index": 77}],
            }), encoding="utf-8")
            trainer_audit = root / "trainers.yml"
            trainer_audit.write_text(yaml.safe_dump({"records": [{
                "rude_id": 408,
                "expected_region": "Lindisfarne",
                "actor_ownership": "scheduled",
                "schedule_destination_markers": ["Marker_Work_408", "Marker_Home_408", "Marker_Misc_408"],
                "missing_schedule_destination_markers": [
                    "Marker_Work_408", "Marker_Home_408", "Marker_Misc_408"],
                "schedule_destination_status": "unresolved_missing_destination_markers",
                "schedule_destination_reason": "absent from DAT",
            }]}), encoding="utf-8")
            overrides = root / "overrides.yml"
            overrides.write_text("overrides: []\n", encoding="utf-8")

            records, audit = generate(trainer_audit, scripts, maps, overrides)
            self.assertEqual(records, [])
            self.assertEqual(audit["summary"]["unresolved_schedule_count"], 1)
            self.assertEqual(audit["records"][0]["source_object_index"], 77)
            self.assertEqual(audit["records"][0]["group_index"], 2)

            overrides.write_text(yaml.safe_dump({"overrides": [{
                "id": "mm9:teacher_schedule_override/lindisfarne/408",
                "rude_id": 408,
                "review_state": "reviewed",
                "work": {"x": 1, "y": 2, "z": 3},
                "misc": {"x": 4, "y": 5, "z": 6},
                "home": {"x": 7, "y": 8, "z": 9},
                "provenance": "executable-backed fixture",
            }]}), encoding="utf-8")
            records, audit = generate(trainer_audit, scripts, maps, overrides)
            self.assertEqual(len(records), 1)
            self.assertEqual(records[0]["SourceObjectIndex"], 77)
            self.assertEqual(records[0]["GroupIndex"], 2)
            self.assertEqual(records[0]["WorkMinute"], 362)
            self.assertEqual(records[0]["HomeZ"], 9)
            self.assertEqual(records[0]["ReviewState"], "reviewed_override")
            self.assertEqual(audit["summary"]["unresolved_schedule_count"], 0)


if __name__ == "__main__":
    unittest.main()
