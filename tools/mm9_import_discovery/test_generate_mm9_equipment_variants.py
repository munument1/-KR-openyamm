#!/usr/bin/env python3

from __future__ import annotations

import sys
import tempfile
import unittest
from collections import Counter
from pathlib import Path

import numpy as np
import yaml
from PIL import Image

sys.path.insert(0, str(Path(__file__).resolve().parent))

import generate_mm9_equipment_variants as generator
import render_paperdoll_equipment_preview as paperdoll


class GenerateMm9EquipmentVariantsTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.items = generator.read_equipment_items(paperdoll.MM9_TABLE_ROOT / "items.txt")
        cls.mappings = generator.load_mappings(generator.DEFAULT_MAPPING, cls.items)
        cls.authored = generator.load_authored_art_manifest(
            generator.DEFAULT_AUTHORED_ART_MANIFEST,
            cls.items,
        )
        cls.engine_items = paperdoll.read_items(paperdoll.ENGINE_TABLE_ROOT / "items.txt", "engine")
        cls.engine_assets = paperdoll.AssetIndex([paperdoll.ENGINE_ICON_ROOT])
        cls.reference_offsets = paperdoll.read_complex_picture_offsets(
            paperdoll.ENGINE_TABLE_ROOT / "complex_item_pictures.txt"
        )
        cls.character_dolls = paperdoll.read_character_dolls(
            paperdoll.ENGINE_TABLE_ROOT / "character_data.txt"
        )
        cls.foot_definitions = generator.load_foot_exclusions(generator.DEFAULT_FOOT_EXCLUSIONS)
        cls.coverage_profiles = generator.load_coverage_profiles(generator.DEFAULT_FOOT_EXCLUSIONS)
        cls.foot_masks = generator.build_foot_exclusion_masks(
            cls.foot_definitions,
            cls.engine_items,
            cls.engine_assets,
            cls.reference_offsets,
            cls.character_dolls,
        )

    def test_mapping_exactly_covers_goal_counts(self) -> None:
        self.assertEqual(len(self.items), 68)
        self.assertEqual(set(self.mappings), set(self.items))
        self.assertEqual(
            Counter(item.category for item in self.items.values()),
            Counter({"Armor": 35, "Helm": 16, "Boots": 11, "Belt": 6}),
        )
        self.assertEqual(
            sum(len(generator.expected_suffixes(item.category)) for item in self.items.values()),
            488,
        )

    def test_suffix_sets_exclude_ineligible_minotaur_variants(self) -> None:
        self.assertEqual(generator.expected_suffixes("Helm"), ["v1", "v2", "v4", "v5"])
        self.assertEqual(generator.expected_suffixes("Boots"), ["v1", "v2", "v4", "v5"])
        self.assertEqual(generator.expected_suffixes("Belt"), ["v1", "v2", "v3", "v4", "v5"])
        self.assertEqual(len(generator.expected_suffixes("Armor")), 10)

    def test_every_reference_is_compatible_and_has_required_assets(self) -> None:
        for raw_id, mapping in self.mappings.items():
            item = self.items[raw_id]
            reference = self.engine_items[mapping.reference_item_id]
            self.assertEqual(reference.equip_stat, item.category)
            self.assertIn(mapping.reference_item_id, self.reference_offsets)

            for suffix in generator.expected_suffixes(item.category):
                self.assertIsNotNone(
                    self.engine_assets.find(f"{reference.icon_name}{suffix}"),
                    f"reference {reference.id} missing {suffix} for raw item {raw_id}",
                )

    def test_accepted_families_are_complete_and_hash_validated(self) -> None:
        accepted_raw_ids = {
            86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105,
            108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129,
            130, 131, 132, 150, 151, 152, 153, 154, 200, 201, 202, 203, 204, 205, 208, 220, 221, 225, 226, 230,
            231, 233, 236, 238, 364, 366, 367,
        }
        self.assertEqual({raw_id for raw_id, _ in self.authored}, accepted_raw_ids)
        self.assertEqual(len(self.authored), 488)

        for raw_id in accepted_raw_ids:
            item = self.items[raw_id]
            self.assertEqual(
                {suffix for accepted_raw_id, suffix in self.authored if accepted_raw_id == raw_id},
                set(generator.expected_suffixes(item.category)),
            )

    def test_staging_can_refresh_only_stale_pose_pair_goal_hashes(self) -> None:
        manifest_path = generator.DEFAULT_AUTHORED_ART_MANIFEST
        document = yaml.safe_load(manifest_path.read_text(encoding="utf-8"))
        stale_hash = "0" * 64
        document["pose_pair_goal_sha256"] = stale_hash

        for item in document["items"].values():
            for pair in item.get("pose_pairs", {}).values():
                pair["goal_sha256"] = stale_hash

        with tempfile.NamedTemporaryFile(
            mode="w",
            encoding="utf-8",
            suffix=".yml",
            dir=manifest_path.parent,
            delete=False,
        ) as temporary_file:
            yaml.safe_dump(document, temporary_file, sort_keys=False, width=120)
            temporary_path = Path(temporary_file.name)

        try:
            with self.assertRaisesRegex(ValueError, "goal provenance mismatch"):
                generator.load_authored_art_manifest(temporary_path, self.items)

            refreshed = generator.load_authored_art_manifest(
                temporary_path,
                self.items,
                allow_stale_pose_pair_goal_hash=True,
            )
            self.assertEqual(len(refreshed), 488)
        finally:
            temporary_path.unlink(missing_ok=True)

    def test_migrated_assets_match_their_audited_target_alpha(self) -> None:
        for accepted in self.authored.values():
            asset = Image.open(accepted.asset_path).convert("RGBA")
            target = Image.open(accepted.target_mask_path).convert("RGBA")
            self.assertEqual(asset.size, target.size)
            self.assertEqual(asset.getchannel("A").tobytes(), target.getchannel("A").tobytes())

    def test_category_geometry_profiles_produce_nonempty_targets(self) -> None:
        pilot_raw_ids = [225, 220, 116, 231, 131, 366, 153, 208]

        for raw_id in pilot_raw_ids:
            item = self.items[raw_id]
            mapping = self.mappings[raw_id]
            reference = self.engine_items[mapping.reference_item_id]
            points = self.reference_offsets[mapping.reference_item_id]

            for suffix in generator.expected_suffixes(item.category):
                doll_type = int(suffix[1]) - 1
                path = self.engine_assets.find(f"{reference.icon_name}{suffix}")
                self.assertIsNotNone(path)
                raw_reference = paperdoll.load_layer(path, color_key=True)
                target, record = generator.build_audited_target(
                    item.category,
                    mapping.geometry_profile,
                    raw_reference,
                    points[doll_type],
                    doll_type,
                    self.coverage_profiles,
                    self.foot_masks,
                )
                self.assertIsNotNone(target.getchannel("A").getbbox())
                self.assertEqual(record["geometry_profile"], mapping.geometry_profile)

    def test_short_torso_profile_clips_prize_plate_at_each_doll_waist(self) -> None:
        item = self.items[220]
        mapping = self.mappings[220]
        reference = self.engine_items[mapping.reference_item_id]
        points = self.reference_offsets[mapping.reference_item_id]
        profile = self.coverage_profiles[mapping.geometry_profile]
        self.assertIsNotNone(profile.max_global_y_exclusive)

        for suffix in generator.expected_suffixes(item.category):
            doll_type = int(suffix[1]) - 1
            path = self.engine_assets.find(f"{reference.icon_name}{suffix}")
            self.assertIsNotNone(path)
            raw_reference = paperdoll.load_layer(path, color_key=True)
            target, record = generator.build_audited_target(
                item.category,
                mapping.geometry_profile,
                raw_reference,
                points[doll_type],
                doll_type,
                self.coverage_profiles,
                self.foot_masks,
            )
            target_bounds = target.getchannel("A").getbbox()
            self.assertIsNotNone(target_bounds)
            global_bottom = points[doll_type][1] + target_bounds[3]
            self.assertLessEqual(global_bottom, profile.max_global_y_exclusive[doll_type])
            self.assertGreater(record["coverage_excluded_alpha_pixels"], 0)

    def test_swordsbane_removes_supreme_plate_upper_spikes(self) -> None:
        item = self.items[202]
        mapping = self.mappings[202]
        reference = self.engine_items[mapping.reference_item_id]
        points = self.reference_offsets[mapping.reference_item_id]

        self.assertEqual(mapping.silhouette_adjustment, "smooth_upper_protrusions")
        lower_detached_excluded = 0

        for suffix in generator.expected_suffixes(item.category):
            doll_type = int(suffix[1]) - 1
            path = self.engine_assets.find(f"{reference.icon_name}{suffix}")
            self.assertIsNotNone(path)
            raw_reference = paperdoll.load_layer(path, color_key=True)
            target, record = generator.build_audited_target(
                item.category,
                mapping.geometry_profile,
                raw_reference,
                points[doll_type],
                doll_type,
                self.coverage_profiles,
                self.foot_masks,
                mapping.silhouette_adjustment,
            )
            raw_alpha = np.asarray(raw_reference.getchannel("A"), dtype=np.uint8) > 0
            target_alpha = np.asarray(target.getchannel("A"), dtype=np.uint8) > 0

            self.assertEqual(record["silhouette_adjustment"], "smooth_upper_protrusions")
            self.assertGreater(record["silhouette_excluded_alpha_pixels"], 0)
            self.assertFalse(np.any(target_alpha & ~raw_alpha))
            lower_detached_excluded += record["lower_detached_excluded_alpha_pixels"]

        self.assertGreater(lower_detached_excluded, 0)

    def test_padded_leather_uses_hip_length_instead_of_legwear_geometry(self) -> None:
        item = self.items[87]
        mapping = self.mappings[87]
        reference = self.engine_items[mapping.reference_item_id]
        points = self.reference_offsets[mapping.reference_item_id]
        hip_profile = self.coverage_profiles["hip_length"]
        thigh_profile = self.coverage_profiles["thigh_length"]

        self.assertEqual(mapping.geometry_profile, "hip_length")

        for suffix in ("v2", "v2a"):
            doll_type = 1
            path = self.engine_assets.find(f"{reference.icon_name}{suffix}")
            self.assertIsNotNone(path)
            raw_reference = paperdoll.load_layer(path, color_key=True)
            target, record = generator.build_audited_target(
                item.category,
                mapping.geometry_profile,
                raw_reference,
                points[doll_type],
                doll_type,
                self.coverage_profiles,
                self.foot_masks,
            )
            target_bounds = target.getchannel("A").getbbox()
            self.assertIsNotNone(target_bounds)
            global_bottom = points[doll_type][1] + target_bounds[3]
            self.assertLessEqual(global_bottom, hip_profile.max_global_y_exclusive[doll_type])
            self.assertLess(global_bottom, thigh_profile.max_global_y_exclusive[doll_type])
            self.assertGreater(record["coverage_excluded_alpha_pixels"], 0)

    def test_butted_chain_uses_hip_length_instead_of_legging_geometry(self) -> None:
        item = self.items[96]
        mapping = self.mappings[96]
        reference = self.engine_items[mapping.reference_item_id]
        points = self.reference_offsets[mapping.reference_item_id]
        hip_profile = self.coverage_profiles["hip_length"]
        thigh_profile = self.coverage_profiles["thigh_length"]

        self.assertEqual(mapping.geometry_profile, "hip_length")

        for suffix in ("v2", "v2a"):
            doll_type = 1
            path = self.engine_assets.find(f"{reference.icon_name}{suffix}")
            self.assertIsNotNone(path)
            raw_reference = paperdoll.load_layer(path, color_key=True)
            target, record = generator.build_audited_target(
                item.category,
                mapping.geometry_profile,
                raw_reference,
                points[doll_type],
                doll_type,
                self.coverage_profiles,
                self.foot_masks,
            )
            target_bounds = target.getchannel("A").getbbox()
            self.assertIsNotNone(target_bounds)
            global_bottom = points[doll_type][1] + target_bounds[3]
            self.assertLessEqual(global_bottom, hip_profile.max_global_y_exclusive[doll_type])
            self.assertLess(global_bottom, thigh_profile.max_global_y_exclusive[doll_type])
            self.assertGreater(record["coverage_excluded_alpha_pixels"], 0)

    def test_ankle_only_profile_removes_boot_shafts(self) -> None:
        item = self.items[366]
        mapping = self.mappings[366]
        reference = self.engine_items[mapping.reference_item_id]
        points = self.reference_offsets[mapping.reference_item_id]

        for suffix in generator.expected_suffixes(item.category):
            doll_type = int(suffix[1]) - 1
            path = self.engine_assets.find(f"{reference.icon_name}{suffix}")
            self.assertIsNotNone(path)
            raw_reference = paperdoll.load_layer(path, color_key=True)
            raw_bounds = raw_reference.getchannel("A").getbbox()
            self.assertIsNotNone(raw_bounds)
            target, _record = generator.build_audited_target(
                item.category,
                mapping.geometry_profile,
                raw_reference,
                points[doll_type],
                doll_type,
                self.coverage_profiles,
                self.foot_masks,
            )
            target_bounds = target.getchannel("A").getbbox()
            self.assertIsNotNone(target_bounds)
            raw_alpha = np.asarray(raw_reference, dtype=np.uint8)[:, :, 3] > 0
            target_alpha = np.asarray(target, dtype=np.uint8)[:, :, 3] > 0
            foot_masks = generator.ankle_only_foot_masks(raw_reference.size, doll_type)
            permitted = np.logical_or.reduce(foot_masks)

            self.assertFalse(np.any(target_alpha & ~raw_alpha))
            self.assertFalse(np.any(target_alpha & ~permitted))

            for foot_mask in foot_masks:
                self.assertGreater(np.count_nonzero(target_alpha & foot_mask), 40)

            self.assertEqual(target_bounds[3], raw_bounds[3])

    def test_leather_boots_use_low_ankle_profile_without_losing_either_foot(self) -> None:
        item = self.items[126]
        mapping = self.mappings[126]
        reference = self.engine_items[mapping.reference_item_id]
        points = self.reference_offsets[mapping.reference_item_id]

        self.assertEqual(mapping.reference_item_id, 917)
        self.assertEqual(mapping.geometry_profile, "low_ankle_boots")

        for suffix in generator.expected_suffixes(item.category):
            doll_type = int(suffix[1]) - 1
            path = self.engine_assets.find(f"{reference.icon_name}{suffix}")
            self.assertIsNotNone(path)
            raw_reference = paperdoll.load_layer(path, color_key=True)
            raw_bounds = raw_reference.getchannel("A").getbbox()
            self.assertIsNotNone(raw_bounds)
            target, record = generator.build_audited_target(
                item.category,
                mapping.geometry_profile,
                raw_reference,
                points[doll_type],
                doll_type,
                self.coverage_profiles,
                self.foot_masks,
            )
            target_bounds = target.getchannel("A").getbbox()
            self.assertIsNotNone(target_bounds)
            raw_alpha = np.asarray(raw_reference.getchannel("A"), dtype=np.uint8) > 0
            target_alpha = np.asarray(target.getchannel("A"), dtype=np.uint8) > 0
            foot_masks = generator.ankle_only_foot_masks(raw_reference.size, doll_type)

            self.assertGreater(record["profile_excluded_alpha_pixels"], 0)
            self.assertFalse(np.any(target_alpha & ~raw_alpha))

            for foot_mask in foot_masks:
                self.assertGreater(np.count_nonzero(target_alpha & foot_mask), 40)

            self.assertEqual(target_bounds[3], raw_bounds[3])

    def test_chain_boots_reuse_the_audited_low_ankle_geometry(self) -> None:
        leather_mapping = self.mappings[126]
        chain_mapping = self.mappings[128]

        self.assertEqual(chain_mapping.reference_item_id, 917)
        self.assertEqual(chain_mapping.geometry_profile, "low_ankle_boots")
        self.assertEqual(chain_mapping.reference_item_id, leather_mapping.reference_item_id)
        self.assertEqual(chain_mapping.geometry_profile, leather_mapping.geometry_profile)

    def test_unique_face_mask_removes_spike_and_horns_and_keeps_solid_mask(self) -> None:
        item = self.items[231]
        mapping = self.mappings[231]
        reference = self.engine_items[mapping.reference_item_id]
        points = self.reference_offsets[mapping.reference_item_id]

        for suffix in generator.expected_suffixes(item.category):
            doll_type = int(suffix[1]) - 1
            path = self.engine_assets.find(f"{reference.icon_name}{suffix}")
            self.assertIsNotNone(path)
            raw_reference = paperdoll.load_layer(path, color_key=True)
            target, record = generator.build_audited_target(
                item.category,
                mapping.geometry_profile,
                raw_reference,
                points[doll_type],
                doll_type,
                self.coverage_profiles,
                self.foot_masks,
            )
            target_alpha = np.asarray(target, dtype=np.uint8)[:, :, 3] > 0
            top_limit = round((target.height - 1) * 0.20)
            lower_start = round((target.height - 1) * 0.75)
            side_width = max(1, round((target.width - 1) * 0.08))

            self.assertGreater(record["profile_excluded_alpha_pixels"], 0)
            self.assertGreaterEqual(record["profile_added_alpha_pixels"], 0)
            self.assertFalse(np.any(target_alpha[:top_limit]))
            self.assertFalse(np.any(target_alpha[lower_start:, :side_width]))
            self.assertFalse(np.any(target_alpha[lower_start:, -side_width:]))
            self.assertTrue(np.array_equal(target_alpha, generator.fill_interior_transparency(target_alpha)))
            nonempty_row_widths = np.count_nonzero(target_alpha, axis=1)
            nonempty_row_widths = nonempty_row_widths[nonempty_row_widths > 0]
            body_width = nonempty_row_widths.max()
            narrow_cap_rows = np.count_nonzero(nonempty_row_widths < body_width * 0.35)
            self.assertGreaterEqual(nonempty_row_widths[0], round(body_width * 0.15))
            self.assertLessEqual(narrow_cap_rows, max(2, round(target.height * 0.08)))

    def test_loaf_helm_closes_elven_helm_face_opening_without_expanding_outer_silhouette(self) -> None:
        item = self.items[120]
        mapping = self.mappings[120]
        reference = self.engine_items[mapping.reference_item_id]
        points = self.reference_offsets[mapping.reference_item_id]

        self.assertEqual(mapping.geometry_profile, "closed_conical_helm")

        for suffix in generator.expected_suffixes(item.category):
            doll_type = int(suffix[1]) - 1
            path = self.engine_assets.find(f"{reference.icon_name}{suffix}")
            self.assertIsNotNone(path)
            raw_reference = paperdoll.load_layer(path, color_key=True)
            raw_alpha = np.asarray(raw_reference.getchannel("A"), dtype=np.uint8) > 0
            face_opening = generator.largest_interior_transparent_component(raw_alpha)
            target, record = generator.build_audited_target(
                item.category,
                mapping.geometry_profile,
                raw_reference,
                points[doll_type],
                doll_type,
                self.coverage_profiles,
                self.foot_masks,
            )
            target_alpha = np.asarray(target.getchannel("A"), dtype=np.uint8) > 0

            self.assertTrue(np.all(target_alpha[raw_alpha]))
            self.assertTrue(np.all(target_alpha[face_opening]))
            self.assertFalse(np.any(target_alpha & ~(raw_alpha | face_opening)))
            self.assertFalse(target_alpha[0, 0])
            self.assertEqual(record["profile_excluded_alpha_pixels"], 0)
            self.assertEqual(record["profile_added_alpha_pixels"], int(np.count_nonzero(face_opening)))
            self.assertGreater(record["profile_added_alpha_pixels"], 0)
            self.assertTrue(np.array_equal(target_alpha, generator.fill_interior_transparency(target_alpha)))

    def test_prize_skullcap_removes_elven_helm_chain_hood_and_face_ring(self) -> None:
        item = self.items[221]
        mapping = self.mappings[221]
        reference = self.engine_items[mapping.reference_item_id]
        points = self.reference_offsets[mapping.reference_item_id]

        self.assertEqual(mapping.reference_item_id, 893)
        self.assertEqual(mapping.geometry_profile, "conical_helm")

        for suffix in generator.expected_suffixes(item.category):
            doll_type = int(suffix[1]) - 1
            path = self.engine_assets.find(f"{reference.icon_name}{suffix}")
            self.assertIsNotNone(path)
            raw_reference = paperdoll.load_layer(path, color_key=True)
            raw_alpha = np.asarray(raw_reference.getchannel("A"), dtype=np.uint8) > 0
            face_opening = generator.largest_interior_transparent_component(raw_alpha)
            face_ys, _face_xs = np.where(face_opening)
            self.assertGreater(len(face_ys), 0)
            face_top = int(face_ys.min())
            target, record = generator.build_audited_target(
                item.category,
                mapping.geometry_profile,
                raw_reference,
                points[doll_type],
                doll_type,
                self.coverage_profiles,
                self.foot_masks,
            )
            target_alpha = np.asarray(target.getchannel("A"), dtype=np.uint8) > 0

            self.assertGreater(record["profile_excluded_alpha_pixels"], 0)
            self.assertFalse(np.any(target_alpha[face_top:]))

            for row in target_alpha[:face_top]:
                row_xs = np.where(row)[0]

                if len(row_xs) > 0:
                    self.assertTrue(np.all(row[int(row_xs.min()):int(row_xs.max()) + 1]))

    def test_jarl_helm_uses_open_cheek_geometry_without_reference_horns(self) -> None:
        item = self.items[125]
        mapping = self.mappings[125]
        reference = self.engine_items[mapping.reference_item_id]
        points = self.reference_offsets[mapping.reference_item_id]

        self.assertEqual(mapping.reference_item_id, 894)
        self.assertEqual(mapping.geometry_profile, "open_cheek_helm")
        self.assertEqual(mapping.silhouette_adjustment, "smooth_upper_protrusions")

        for suffix in generator.expected_suffixes(item.category):
            doll_type = int(suffix[1]) - 1
            path = self.engine_assets.find(f"{reference.icon_name}{suffix}")
            self.assertIsNotNone(path)
            raw_reference = paperdoll.load_layer(path, color_key=True)
            target, record = generator.build_audited_target(
                item.category,
                mapping.geometry_profile,
                raw_reference,
                points[doll_type],
                doll_type,
                self.coverage_profiles,
                self.foot_masks,
                mapping.silhouette_adjustment,
            )
            raw_alpha = np.asarray(raw_reference.getchannel("A"), dtype=np.uint8) > 0
            target_alpha = np.asarray(target.getchannel("A"), dtype=np.uint8) > 0
            bounds = target.getchannel("A").getbbox()
            self.assertIsNotNone(bounds)
            left, top, right, bottom = bounds
            opening_row = top + round((bottom - top - 1) * 0.70)
            center = (left + right) // 2

            self.assertGreater(record["silhouette_excluded_alpha_pixels"], 0)
            self.assertFalse(np.any(target_alpha & ~raw_alpha))
            self.assertTrue(np.any(target_alpha[opening_row, left:center]))
            self.assertFalse(target_alpha[opening_row, center])
            self.assertTrue(np.any(target_alpha[opening_row, center + 1:right]))

    def test_fres_helm_removes_mogred_horns_and_preserves_open_face(self) -> None:
        item = self.items[236]
        mapping = self.mappings[236]
        reference = self.engine_items[mapping.reference_item_id]
        points = self.reference_offsets[mapping.reference_item_id]

        self.assertEqual(mapping.reference_item_id, 895)
        self.assertEqual(mapping.geometry_profile, "hornless_round_helm")
        self.assertEqual(mapping.silhouette_adjustment, "")

        for suffix in generator.expected_suffixes(item.category):
            doll_type = int(suffix[1]) - 1
            path = self.engine_assets.find(f"{reference.icon_name}{suffix}")
            self.assertIsNotNone(path)
            raw_reference = paperdoll.load_layer(path, color_key=True)
            target, record = generator.build_audited_target(
                item.category,
                mapping.geometry_profile,
                raw_reference,
                points[doll_type],
                doll_type,
                self.coverage_profiles,
                self.foot_masks,
                mapping.silhouette_adjustment,
            )
            raw_alpha = np.asarray(raw_reference.getchannel("A"), dtype=np.uint8) > 0
            target_alpha = np.asarray(target.getchannel("A"), dtype=np.uint8) > 0
            bounds = target.getchannel("A").getbbox()
            raw_bounds = raw_reference.getchannel("A").getbbox()
            self.assertIsNotNone(bounds)
            self.assertIsNotNone(raw_bounds)
            left, top, right, bottom = bounds
            raw_left, raw_top, raw_right, raw_bottom = raw_bounds
            opening_row = top + round((bottom - top - 1) * 0.82)
            center = (left + right) // 2

            self.assertGreater(record["profile_excluded_alpha_pixels"], 0)
            self.assertIsNone(record["silhouette_adjustment"])
            self.assertFalse(np.any(target_alpha & ~raw_alpha))
            envelope_row = raw_top + round((raw_bottom - raw_top - 1) * 0.55)
            envelope_xs = np.where(target_alpha[envelope_row])[0]
            self.assertGreater(len(envelope_xs), 0)
            self.assertLessEqual(
                int(envelope_xs.max()) - int(envelope_xs.min()) + 1,
                round((raw_right - raw_left) * 0.86),
            )
            self.assertTrue(np.any(target_alpha[opening_row, left:center]))
            self.assertFalse(target_alpha[opening_row, center])
            self.assertTrue(np.any(target_alpha[opening_row, center + 1:right]))

    def test_fur_cap_uses_round_cap_and_adds_attached_hanging_tail(self) -> None:
        item = self.items[364]
        mapping = self.mappings[364]
        reference = self.engine_items[mapping.reference_item_id]
        points = self.reference_offsets[mapping.reference_item_id]

        self.assertEqual(mapping.reference_item_id, 898)
        self.assertEqual(mapping.geometry_profile, "soft_cap")

        for suffix in generator.expected_suffixes(item.category):
            doll_type = int(suffix[1]) - 1
            path = self.engine_assets.find(f"{reference.icon_name}{suffix}")
            self.assertIsNotNone(path)
            raw_reference = paperdoll.load_layer(path, color_key=True)
            target, record = generator.build_audited_target(
                item.category,
                mapping.geometry_profile,
                raw_reference,
                points[doll_type],
                doll_type,
                self.coverage_profiles,
                self.foot_masks,
                mapping.silhouette_adjustment,
            )
            raw_alpha = np.asarray(raw_reference.getchannel("A"), dtype=np.uint8) > 0
            target_alpha = np.asarray(target.getchannel("A"), dtype=np.uint8) > 0
            raw_bounds = raw_reference.getchannel("A").getbbox()
            self.assertIsNotNone(raw_bounds)
            left, _top, right, bottom = raw_bounds

            self.assertEqual(target.width, raw_reference.width)
            self.assertGreaterEqual(target.height, raw_reference.height)
            self.assertTrue(np.array_equal(target_alpha[:raw_reference.height] & raw_alpha, raw_alpha))
            self.assertGreater(record["profile_added_alpha_pixels"], 0)
            self.assertTrue(np.any(target_alpha[bottom:, left:(left + right) // 2]))

    def test_complex_picture_output_contains_four_category_sections_and_68_rows(self) -> None:
        rows = generator.equipment_table_rows(self.items, self.mappings, self.reference_offsets)
        numeric_rows = [row for row in rows if row and row[0].isdigit()]
        section_rows = [row for row in rows if len(row) > 2 and row[2].startswith("MM9 ")]
        self.assertEqual(len(numeric_rows), 68)
        self.assertEqual([row[2] for row in section_rows], ["MM9 Armor", "MM9 Helm", "MM9 Boots", "MM9 Belt"])
        self.assertEqual({int(row[1]) for row in numeric_rows}, {item.item_id for item in self.items.values()})


if __name__ == "__main__":
    unittest.main()
