import csv
import json
import sys
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace

sys.path.insert(0, str(Path(__file__).resolve().parent))

import generate_mm9_vendors


class GenerateMm9VendorsTests(unittest.TestCase):
    def setUp(self) -> None:
        self.root = Path(__file__).resolve().parents[2]

    def arguments(self, output_root: Path) -> SimpleNamespace:
        return SimpleNamespace(
            shops=self.root / "mm9/extracted/DATA/DATA/MMIXSHOPS.txt",
            concats=self.root / "mm9/extracted/DATA/DATA/CONCAT.csv",
            world_manifest=self.root / "assets_dev/worlds/mm9/world.yml",
            rude_directory=self.root / "assets_dev/worlds/mm9/dialogue/rude",
            mm9_items=self.root / "assets_dev/worlds/mm9/data_tables/items.txt",
            engine_items=self.root / "assets_dev/engine/data_tables/items.txt",
            special_enchants=self.root / "assets_dev/engine/data_tables/special_item_enchants.txt",
            output_directory=output_root / "data_tables",
            audit=output_root / "state/vendor_stock_audit.yml",
        )

    def test_generation_is_complete_deterministic_and_runtime_quality_free(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            output_root = Path(temporary_directory)
            arguments = self.arguments(output_root)
            generate_mm9_vendors.generate(arguments)
            first_outputs = {
                path.relative_to(output_root): path.read_bytes()
                for path in sorted(output_root.rglob("*"))
                if path.is_file()
            }
            generate_mm9_vendors.generate(arguments)
            second_outputs = {
                path.relative_to(output_root): path.read_bytes()
                for path in sorted(output_root.rglob("*"))
                if path.is_file()
            }
            self.assertEqual(first_outputs, second_outputs)
            checked_in_root = self.root / "assets_dev/worlds/mm9"
            checked_in_outputs = {
                relative_path: (checked_in_root / relative_path).read_bytes()
                for relative_path in first_outputs
            }
            self.assertEqual(first_outputs, checked_in_outputs)

            with (arguments.output_directory / "vendors.txt").open(encoding="utf-8", newline="") as source_file:
                vendors = list(csv.DictReader(source_file, delimiter="\t"))
            self.assertEqual(len(vendors), 48)
            self.assertEqual({row["source_type"] for row in vendors}, generate_mm9_vendors.SELLING_TYPES)
            self.assertEqual(sum(row["source_type"] == "Library" for row in vendors), 6)
            self.assertEqual(sum(row["source_type"] == "Magic" for row in vendors), 15)
            self.assertTrue(all(row["normalized_service_type"] == "Shop" for row in vendors))
            self.assertTrue(all(row["legacy_house_audio_policy"] == "Disabled" for row in vendors))
            self.assertTrue(all(row["legacy_house_video_policy"] == "Disabled" for row in vendors))

            with (arguments.output_directory / "service_venues.txt").open(
                encoding="utf-8", newline=""
            ) as source_file:
                service_venues = list(csv.DictReader(source_file, delimiter="\t"))
            self.assertEqual(len(service_venues), 16)
            self.assertEqual(sum(row["service_type"] == "Training" for row in service_venues), 8)
            self.assertEqual(sum(row["service_type"] == "Temple" for row in service_venues), 8)
            self.assertTrue(all(row["training_max_level"] == "0" for row in service_venues))
            self.assertTrue(all(row["can_learn_skills"] == "0" for row in service_venues))
            midwife = next(row for row in service_venues if row["source_service_id"] == "241")
            self.assertEqual(midwife["can_heal"], "1")
            self.assertEqual(midwife["can_donate"], "0")

            with (arguments.output_directory / "vendor_stock.txt").open(encoding="utf-8", newline="") as source_file:
                reader = csv.DictReader(source_file, delimiter="\t")
                self.assertNotIn("quality", reader.fieldnames)
                self.assertNotIn("source_q", reader.fieldnames)
                stock_rows = list(reader)
            self.assertGreater(len(stock_rows), 3000)
            self.assertTrue(all(int(row["item_id"]) > 0 for row in stock_rows))

            audit = json.loads(arguments.audit.read_text(encoding="utf-8"))
            self.assertEqual(audit["vendor_count"], 48)
            with arguments.shops.open(encoding="cp1252", newline="") as source_file:
                source_rows = list(csv.reader(source_file, delimiter="\t"))
            self.assertEqual(audit["source_header"], source_rows[0])
            self.assertEqual(audit["source_row_count"], len(source_rows) - 1)
            reconstructed_source_rows = [
                [row["raw_fields"][field] for field in audit["source_field_names"]]
                for row in audit["source_rows"]
            ]
            self.assertEqual(reconstructed_source_rows, source_rows[1:])
            with arguments.concats.open(encoding="cp1252", newline="") as source_file:
                source_concat_rows = list(csv.reader(source_file))
            self.assertEqual(audit["concat_source_file"],
                             "mm9/extracted/DATA/DATA/CONCAT.csv")
            self.assertFalse(audit["concat_source_has_header"])
            self.assertEqual(audit["concat_source_field_count"], 25)
            self.assertEqual(audit["concat_source_row_count"], 104)
            self.assertEqual(
                [row["raw_fields"] for row in audit["concat_source_rows"]],
                source_concat_rows,
            )
            self.assertEqual(
                {row["source_concat_id"] for row in audit["concat_source_rows"]},
                {int(row[0]) for row in source_concat_rows},
            )
            with (arguments.output_directory / "vendor_concat_mappings.txt").open(
                encoding="utf-8", newline=""
            ) as source_file:
                concat_mappings = list(csv.DictReader(source_file, delimiter="\t"))
            self.assertEqual({row["source_concat_id"] for row in concat_mappings}, {"4", "49"})
            self.assertTrue(all(row["owner"] and row["reason"] for row in concat_mappings))
            self.assertEqual(
                {row["disposition"] for row in audit["source_rows"]},
                {"selling_vendor", "reachable_service_venue", "non_stock_service"},
            )
            self.assertEqual(audit["service_venue_count"], 16)
            self.assertEqual(audit["selling_vendors_without_rude_shop_row"], [138])
            self.assertEqual(audit["rude_shop_rows_without_selling_vendor"], [])
            self.assertEqual(audit["ordinary_effective_tier_cap"], 6)
            self.assertEqual(
                audit["quality_policy"]["quality_offsets"],
                {"Normal": 0, "Good": 1, "Excellent": 2},
            )
            self.assertFalse(audit["quality_policy"]["runtime_quality_fields_emitted"])
            self.assertFalse(audit["quality_policy"]["runtime_source_q_field_emitted"])
            self.assertEqual(audit["vendor_id_domain"]["begin"], 30000)
            self.assertEqual(audit["vendor_id_domain"]["end"], 30999)
            self.assertTrue(audit["vendor_id_domain"]["all_unique_and_in_range"])
            self.assertEqual(len(audit["vendor_id_domain"]["validated_canonical_ids"]), 64)
            self.assertEqual(audit["balance_boundary"]["artifact_relic_reserved_tier"], 7)
            self.assertFalse(audit["balance_boundary"]["rare_and_set_rows_admitted"])
            self.assertEqual(audit["coverage"]["library_vendor_count"], 6)
            self.assertEqual(audit["coverage"]["magic_vendor_count"], 15)
            self.assertFalse(audit["coverage"]["missing_library_coverage"])
            self.assertFalse(audit["coverage"]["missing_magic_school_coverage"])
            self.assertTrue(all(
                decision["owner"] and decision["reason"]
                for decision in audit["reviewed_policy_decisions"]
            ))
            slots = [
                slot
                for vendor in audit["vendors"]
                for lane in vendor["lanes"].values()
                for slot in lane["slots"]
            ]
            self.assertTrue(all(slot["effective_tier"] <= 6 for slot in slots))
            self.assertTrue(all(
                "source_tier" in slot and "normalized_base_tier" in slot
                for slot in slots
            ))
            self.assertTrue(any(slot["effective_tier"] == 6 for slot in slots))
            self.assertTrue(all(slot["runtime_mapping"]["item_id"] > 0 for slot in slots))
            self.assertTrue(all(
                slot["quality_conversion"]["final_overlay_statistics"]["runtime_quality_field_emitted"]
                is False
                and slot["quality_conversion"]["final_overlay_statistics"]["runtime_source_q_field_emitted"]
                is False
                for slot in slots
            ))
            self.assertTrue(all(
                slot["quality_conversion"]["application_count"]
                == (0 if slot["source_quality"] == "NotApplicable" else 1)
                for slot in slots
            ))
            self.assertTrue(all(
                slot["balance_boundary_validation"]["ordinary_l7_boundary_preserved"]
                and not slot["balance_boundary_validation"]["rare_item_admitted"]
                and not slot["balance_boundary_validation"]["quest_or_unique_item_admitted"]
                and not slot["balance_boundary_validation"]["set_piece_admitted"]
                and not slot["balance_boundary_validation"]["runtime_artifact_id_emitted"]
                for slot in slots
            ))
            mm9_content_slots = [slot for slot in slots if slot["item_id"] >= 10000]
            self.assertTrue(mm9_content_slots)
            self.assertTrue(all(
                slot["quality_conversion"]["base_normalized_statistics"]["inventory_width"] > 0
                and slot["quality_conversion"]["base_normalized_statistics"]["inventory_height"] > 0
                and slot["quality_conversion"]["base_normalized_statistics"]["visual_status"]
                for slot in mm9_content_slots
            ))
            self.assertTrue(all(
                slot["quality_conversion"]["final_overlay_statistics"][field]
                for slot in slots
                for field in (
                    "canonical_item_identity_retained",
                    "inventory_dimensions_retained",
                    "visual_mapping_retained",
                    "class_restrictions_retained",
                )
            ))
            concat_slots = [slot for slot in slots if slot["concat"]]
            non_concat_slots = [slot for slot in slots if not slot["concat"]]
            self.assertTrue(concat_slots)
            self.assertTrue(all(slot["concat_mapping"] is not None for slot in concat_slots))
            self.assertTrue(all(slot["concat_mapping"] is None for slot in non_concat_slots))
            self.assertTrue(all(
                slot["concat_mapping"]["applicable"]
                and slot["concat_mapping"]["source_tier"] <= slot["effective_tier"]
                and slot["concat_mapping"]["target_special_enchant_id"]
                == slot["runtime_mapping"]["special_enchant_id"]
                for slot in concat_slots
            ))
            self.assertTrue(all(
                all(flag == 1 for flag in slot["concat_mapping"]["source_applicability_flags"])
                if slot["concat_mapping"]["source_concat_id"] == 49
                else all(
                    slot["concat_mapping"]["source_raw_fields"][column] == "1"
                    for column in generate_mm9_vendors.SOURCE_CONCAT_WEAPON_COLUMNS
                )
                for slot in concat_slots
            ))

            library_tier_sets = set()
            for vendor in audit["vendors"]:
                minimum = max(1, vendor["raw_ranges"]["standard"][0])
                maximum = max(1, vendor["raw_ranges"]["standard"][1])
                admission_tiers = {
                    slot["admission_tier"]
                    for lane in vendor["lanes"].values()
                    for slot in lane["slots"]
                }
                self.assertTrue(all(minimum <= tier <= maximum for tier in admission_tiers))
                if vendor["profile"] == "Mm9Library":
                    library_tier_sets.add(tuple(sorted(admission_tiers)))
            self.assertGreaterEqual(len(library_tier_sets), 3)

            audit_by_source_id = {vendor["source_vendor_id"]: vendor for vendor in audit["vendors"]}
            frosgard_weapon = audit_by_source_id[200]
            frosgard_standard_qualities = {
                slot["source_quality"] for slot in frosgard_weapon["lanes"]["standard"]["slots"]
            }
            frosgard_special_qualities = {
                slot["source_quality"] for slot in frosgard_weapon["lanes"]["special"]["slots"]
            }
            self.assertEqual(frosgard_standard_qualities, {"Normal", "Good"})
            self.assertEqual(frosgard_special_qualities, {"Good", "Excellent"})
            arslegard_weapon = audit_by_source_id[340]
            self.assertEqual(
                {slot["source_quality"] for slot in arslegard_weapon["lanes"]["standard"]["slots"]},
                {"Good"},
            )
            self.assertEqual(
                {slot["source_quality"] for slot in arslegard_weapon["lanes"]["special"]["slots"]},
                {"Excellent"},
            )
            sturmford_weapon_slots = [
                slot
                for lane in audit_by_source_id[53]["lanes"].values()
                for slot in lane["slots"]
            ]
            self.assertTrue(all(slot["effective_tier"] <= 2 for slot in sturmford_weapon_slots))
            l6_slots = [
                (vendor, slot)
                for vendor in audit["vendors"]
                for lane in vendor["lanes"].values()
                for slot in lane["slots"]
                if slot["effective_tier"] == 6
            ]
            self.assertTrue(l6_slots)
            self.assertTrue(all(
                vendor["raw_ranges"]["standard"] == [3, 4]
                for vendor, slot in l6_slots
                if slot["source_quality"] != "NotApplicable"
            ))
            low_concat_lanes = [
                lane
                for vendor in audit["vendors"]
                for lane in vendor["lanes"].values()
                if 0 < lane["expected_concat_percent"] < 10
            ]
            self.assertTrue(low_concat_lanes)
            self.assertTrue(all(
                lane["realized_concat_percent"] > 0
                for lane in low_concat_lanes
                if lane["concat_eligible_slot_count"] > 0
            ))

            equipment_slots = [slot for slot in slots if slot["source_quality"] != "NotApplicable"]
            other_slots = [slot for slot in slots if slot["source_quality"] == "NotApplicable"]
            self.assertTrue(equipment_slots)
            self.assertTrue(other_slots)
            self.assertTrue(all(slot["source_q"] is not None for slot in equipment_slots))
            self.assertTrue(all(slot["source_q"] is None for slot in other_slots))
            self.assertTrue(all(
                slot["runtime_mapping"]["standard_enchant_id"] == 0
                and slot["runtime_mapping"]["special_enchant_id"] == 0
                for slot in other_slots
            ))
            armor_quality_slots = [
                slot for slot in equipment_slots
                if slot["quality_conversion"]["base_normalized_statistics"]["equipment_family"]
                in (generate_mm9_vendors.ARMOR_STATS - {"Belt"})
                and slot["source_quality"] != "Normal"
            ]
            self.assertTrue(armor_quality_slots)
            self.assertTrue(all(
                slot["runtime_mapping"]["standard_enchant_id"] == 10
                and slot["quality_conversion"]["target_envelope"]["role_envelope"]
                == "armor_class"
                for slot in armor_quality_slots
            ))
            for vendor in audit["vendors"]:
                self.assertEqual(vendor["runtime_price_multiplier"], vendor["source_merchant_base"])
                self.assertEqual(vendor["normalized_service_type"], "Shop")
                self.assertEqual(vendor["dialogue_scene_policy"], "LiveGameplay")
                self.assertEqual(vendor["legacy_house_audio_policy"], "Disabled")
                self.assertEqual(vendor["legacy_house_video_policy"], "Disabled")
                self.assertEqual(vendor["source_pair_interpretation"],
                                 "first_pair_standard_second_pair_special")
                if vendor["source_vendor_id"] == 138:
                    self.assertFalse(vendor["opening_policy_provenance"])
                else:
                    self.assertTrue(vendor["opening_policy_provenance"])
                    self.assertTrue(all(
                        row["source_file"].endswith(".rude")
                        and row["source_line"] > 0
                        and row["raw_fields"]
                        for row in vendor["opening_policy_provenance"]
                    ))
                self.assertTrue(all(
                    override["owner"] and override["reason"]
                    for override in vendor["reviewed_overrides"]
                ))
                for lane in vendor["lanes"].values():
                    self.assertGreater(lane["candidate_count"], 0)
                    self.assertTrue(lane["rejected_candidate_counts"])
                    self.assertEqual(lane["concat_rounding_rule"],
                                     "largest_remainder_half_up_with_nonzero_minimum")
                    self.assertEqual(
                        lane["concat_target_count"],
                        sum(slot["concat"] for slot in lane["slots"]),
                    )
                    self.assertTrue(all(
                        not slot["concat"] or slot["source_quality"] != "NotApplicable"
                        for slot in lane["slots"]
                    ))
                    if (lane["expected_concat_percent"] == 0
                            and vendor["profile"] in {"Spellbook", "Mm9Library"}):
                        self.assertTrue(all(
                            slot["runtime_mapping"]["standard_enchant_id"] == 0
                            and
                            slot["runtime_mapping"]["special_enchant_id"] == 0
                            for slot in lane["slots"]
                        ))

            vendor_by_id = {int(row["vendor_id"]): row for row in vendors}
            vendor_by_source_id = {int(row["source_vendor_id"]): row for row in vendors}
            self.assertEqual(vendor_by_source_id[200]["restock_days"], "56")
            self.assertEqual(vendor_by_source_id[250]["standard_max"], "1")
            self.assertEqual(vendor_by_source_id[247]["standard_max"], "2")
            stock_by_vendor: dict[int, list[dict[str, str]]] = {}
            for row in stock_rows:
                stock_by_vendor.setdefault(int(row["vendor_id"]), []).append(row)
            mm9_items = {
                item.item_id: item
                for item in generate_mm9_vendors.read_items(arguments.mm9_items, "utf-8", "mm9")
            }
            engine_items = {
                item.item_id: item
                for item in generate_mm9_vendors.read_items(arguments.engine_items, "cp1252", "engine")
            }
            for vendor_id, vendor in vendor_by_id.items():
                rows = stock_by_vendor[vendor_id]
                if vendor["source_type"] == "Library":
                    self.assertTrue(all(
                        mm9_items[int(row["item_id"])].equip_stat == "LearnSkill"
                        and "SkillLearning" in mm9_items[int(row["item_id"])].content_flags
                        for row in rows
                    ))
                if vendor["source_type"] == "Magic":
                    school = generate_mm9_vendors.magic_school(vendor["merchandise"])
                    self.assertTrue(all(
                        generate_mm9_vendors.spell_school(engine_items[int(row["item_id"])]) == school
                        or school == "All"
                        or (school == "Elemental" and generate_mm9_vendors.spell_school(
                            engine_items[int(row["item_id"])]) in {"Fire", "Air", "Water", "Earth"})
                        for row in rows
                    ))

            library_item_ids = {
                int(row["item_id"])
                for vendor_id, rows in stock_by_vendor.items()
                if vendor_by_id[vendor_id]["source_type"] == "Library"
                for row in rows
            }
            self.assertEqual(library_item_ids, set(range(10285, 10308)))

    def test_quality_conversion_is_offline_and_clamped(self) -> None:
        item = generate_mm9_vendors.Item(
            item_id=1,
            name="Test armor",
            equip_stat="Armor",
            skill_group="",
            normalized_tier=4,
            source_item_id=1,
            source_treasure_tier=4,
            content_flags=frozenset(),
            rarity="Common",
            set_id="",
            source_equip_type="Armor",
            value=100,
        )
        vendor = generate_mm9_vendors.SourceVendor(
            source_line=1,
            name="Test",
            source_id=1,
            source_type="Armor",
            merchandise="Armor",
            wealth="Average",
            merchant_base=1.0,
            standard_min=3,
            standard_max=4,
            standard_concat=0,
            special_min=3,
            special_max=4,
            special_concat=0,
            source_quantity="",
            restock_text="2 Weeks",
        )
        self.assertEqual(generate_mm9_vendors.QUALITY_OFFSET, {"Normal": 0, "Good": 1, "Excellent": 2})
        self.assertEqual(generate_mm9_vendors.quality_for(vendor, "special", 0, item), "Excellent")
        effective_tier = min(6, item.normalized_tier + generate_mm9_vendors.QUALITY_OFFSET["Excellent"])
        self.assertEqual(effective_tier, 6)

        shield = generate_mm9_vendors.Item(
            item_id=2,
            name="Test shield",
            equip_stat="Shield",
            skill_group="Shield",
            normalized_tier=3,
            source_item_id=2,
            source_treasure_tier=3,
            content_flags=frozenset(),
            rarity="Common",
            set_id="",
            source_equip_type="Shield",
            value=100,
        )
        self.assertEqual(
            generate_mm9_vendors.mapped_enchants(shield, "Good", False, 4, 0),
            (10, 4, 0),
        )


if __name__ == "__main__":
    unittest.main()
