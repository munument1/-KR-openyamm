#!/usr/bin/env python3

from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path

import numpy as np
from PIL import Image

sys.path.insert(0, str(Path(__file__).resolve().parent))

import audit_mm9_armor_pose_pairs as pose_pairs
import generate_mm9_equipment_variants as equipment
import render_paperdoll_equipment_preview as paperdoll


def rgba_image(pixels: np.ndarray) -> Image.Image:
    return Image.fromarray(np.asarray(pixels, dtype=np.uint8), "RGBA")


class AuditMm9ArmorPosePairsTest(unittest.TestCase):
    def test_goal_covers_exactly_35_families_and_175_pairs(self) -> None:
        items = equipment.read_equipment_items(paperdoll.MM9_TABLE_ROOT / "items.txt")
        armor = [item for item in items.values() if item.category == "Armor"]
        self.assertEqual(len(armor), 35)
        self.assertEqual(len(armor) * len(pose_pairs.PAIR_SUFFIXES), 175)

    def test_material_difference_ignores_small_palette_noise(self) -> None:
        first = np.zeros((3, 4, 4), dtype=np.uint8)
        first[:, :, 3] = 255
        second = first.copy()
        second[1, 1, :3] = 20
        second[1, 2, :3] = 40
        difference = pose_pairs.material_difference_mask(rgba_image(first), rgba_image(second), threshold=32)
        self.assertFalse(difference[1, 1])
        self.assertTrue(difference[1, 2])

    def test_identical_target_alpha_produces_empty_pose_change_mask(self) -> None:
        target = Image.new("RGBA", (8, 6), (80, 80, 80, 255))
        first_reference = Image.new("RGBA", target.size, (40, 40, 40, 255))
        second_reference = Image.new("RGBA", target.size, (40, 40, 40, 255))
        allowed = pose_pairs.derive_pose_change_mask(
            first_reference,
            second_reference,
            target,
            target,
        )
        self.assertFalse(np.any(allowed))

    def test_internal_arm_change_is_allowed_when_target_alpha_is_identical(self) -> None:
        target = np.zeros((20, 30, 4), dtype=np.uint8)
        target[2:18, 2:28, 3] = 255
        first_reference = target.copy()
        second_reference = target.copy()
        first_reference[4:10, 3:9, :3] = 40
        second_reference[4:10, 3:9, :3] = 180
        allowed = pose_pairs.derive_pose_change_mask(
            rgba_image(first_reference),
            rgba_image(second_reference),
            rgba_image(target),
            rgba_image(target),
        )
        self.assertTrue(np.any(allowed[2:12, :12]))
        self.assertFalse(np.any(allowed[:, 20:]))

    def test_pose_change_mask_stays_near_target_alpha_difference(self) -> None:
        first_target = np.zeros((20, 30, 4), dtype=np.uint8)
        second_target = first_target.copy()
        first_target[4:12, 2:8, 3] = 255
        second_target[5:15, 4:10, 3] = 255
        first_reference = first_target.copy()
        second_reference = second_target.copy()
        first_reference[:, :, :3] = 80
        second_reference[:, :, :3] = 190
        allowed = pose_pairs.derive_pose_change_mask(
            rgba_image(first_reference),
            rgba_image(second_reference),
            rgba_image(first_target),
            rgba_image(second_target),
        )
        self.assertTrue(np.any(allowed[:, :15]))
        self.assertFalse(np.any(allowed[:, 20:]))

    def test_authored_weapon_arm_mask_validation_rejects_broad_body_regions(self) -> None:
        armor = np.zeros((30, 40), dtype=bool)
        armor[2:28, 3:37] = True
        narrow_arm = np.zeros_like(armor)
        narrow_arm[4:14, 4:10] = True
        pose_pairs.validate_weapon_arm_mask(narrow_arm, armor, "authored test")

        invalid_masks = {
            "chest": (slice(5, 14), slice(15, 25)),
            "waist": (slice(20, 26), slice(4, 12)),
            "opposite arm": (slice(4, 14), slice(30, 37)),
        }

        for name, region in invalid_masks.items():
            with self.subTest(name=name):
                invalid = narrow_arm.copy()
                invalid[region] = True
                with self.assertRaises(ValueError):
                    pose_pairs.validate_weapon_arm_mask(invalid, armor, f"authored {name}")

    def test_disconnected_target_noise_is_not_treated_as_an_arm_change(self) -> None:
        first_target = np.zeros((30, 40, 4), dtype=np.uint8)
        second_target = first_target.copy()
        first_target[4:14, 2:9, 3] = 255
        second_target[5:17, 4:11, 3] = 255
        second_target[22, 35, 3] = 255
        first_reference = first_target.copy()
        second_reference = second_target.copy()
        allowed = pose_pairs.derive_pose_change_mask(
            rgba_image(first_reference),
            rgba_image(second_reference),
            rgba_image(first_target),
            rgba_image(second_target),
        )
        self.assertTrue(np.any(allowed[:20, :20]))
        self.assertFalse(allowed[22, 35])

    def test_target_normalization_removes_differences_outside_arm_region(self) -> None:
        weapon = np.zeros((5, 8, 4), dtype=np.uint8)
        empty = weapon.copy()
        weapon[:, 1:7, :] = (90, 80, 70, 255)
        empty[:, 2:7, :] = (120, 110, 100, 255)
        empty[4, 7, :] = (200, 10, 10, 255)
        allowed = np.zeros((5, 8), dtype=bool)
        allowed[:, :3] = True
        normalized_weapon, normalized_empty = pose_pairs.normalize_target_pair(
            rgba_image(weapon),
            rgba_image(empty),
            allowed,
            "v1",
            "v1",
            "v1a",
        )
        difference = pose_pairs.rgba_difference_mask(normalized_weapon, normalized_empty)
        self.assertFalse(np.any(difference & ~allowed))

    def test_common_region_lock_preserves_target_alpha_and_exact_rgba(self) -> None:
        weapon = np.zeros((5, 8, 4), dtype=np.uint8)
        empty = np.zeros_like(weapon)
        weapon[:, :, :] = (180, 30, 20, 255)
        empty[:, :, :] = (20, 80, 170, 255)
        weapon_target = np.zeros_like(weapon)
        empty_target = np.zeros_like(empty)
        weapon_target[:, 1:7, 3] = 255
        empty_target[:, 2:7, 3] = 255
        allowed = np.zeros((5, 8), dtype=bool)
        allowed[:, :3] = True
        repaired_weapon, repaired_empty = pose_pairs.lock_common_region(
            rgba_image(weapon),
            rgba_image(empty),
            rgba_image(weapon_target),
            rgba_image(empty_target),
            allowed,
            "v1",
            "v1",
            "v1a",
        )
        repaired_weapon_pixels = pose_pairs.image_array(repaired_weapon)
        repaired_empty_pixels = pose_pairs.image_array(repaired_empty)
        common = np.zeros((5, 8), dtype=bool)
        common[:, 3:7] = True
        self.assertTrue(np.array_equal(repaired_weapon_pixels[common], repaired_empty_pixels[common]))
        self.assertEqual(repaired_weapon.getchannel("A").tobytes(), rgba_image(weapon_target).getchannel("A").tobytes())
        self.assertEqual(repaired_empty.getchannel("A").tobytes(), rgba_image(empty_target).getchannel("A").tobytes())
        self.assertTrue(np.all(repaired_weapon_pixels[:, 7, :3] == 0))

    def test_analysis_rejects_every_shared_body_region_difference(self) -> None:
        item = equipment.EquipmentItem(1, 10001, "test", "Test Armor", "Armor", "test.pcx")
        target_pixels = np.zeros((30, 40, 4), dtype=np.uint8)
        target_pixels[2:28, 3:37, 3] = 255
        weapon_pixels = target_pixels.copy()
        empty_pixels = target_pixels.copy()
        allowed = np.zeros((30, 40), dtype=bool)
        allowed[4:14, 4:10] = True

        for name, coordinate in {
            "chest": (8, 20),
            "waist": (19, 20),
            "leg": (25, 14),
            "opposite arm": (8, 34),
        }.items():
            with self.subTest(name=name):
                changed = empty_pixels.copy()
                changed[coordinate[0], coordinate[1], :3] = 255
                analysis = pose_pairs.analyze_pair(
                    1,
                    item,
                    "v1",
                    "v1a",
                    rgba_image(weapon_pixels),
                    rgba_image(changed),
                    rgba_image(target_pixels),
                    rgba_image(target_pixels),
                    allowed,
                    "v1",
                    "test",
                )
                self.assertEqual(analysis.status, "failed")
                self.assertEqual(analysis.changed_outside_allowed, 1)

    def test_atomic_family_copy_preflights_all_sources(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            source = root / "source.bin"
            missing = root / "missing.bin"
            first_destination = root / "first.bin"
            second_destination = root / "second.bin"
            source.write_bytes(b"new")
            first_destination.write_bytes(b"old")
            second_destination.write_bytes(b"old")

            with self.assertRaises(ValueError):
                pose_pairs.copy_family_files_atomically([
                    (source, first_destination),
                    (missing, second_destination),
                ])

            self.assertEqual(first_destination.read_bytes(), b"old")
            self.assertEqual(second_destination.read_bytes(), b"old")

    def test_variant_manifest_hashes_are_updated_after_atomic_copy(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            staged_asset = root / "staged.png"
            promoted_asset = root / "promoted.png"
            staged_preview = root / "staged_preview.png"
            promoted_preview = root / "promoted_preview.png"
            Image.new("RGBA", (4, 5), (20, 30, 40, 255)).save(staged_asset)
            Image.new("RGBA", (8, 9), (50, 60, 70, 255)).save(staged_preview)
            pose_pairs.copy_family_files_atomically([
                (staged_asset, promoted_asset),
                (staged_preview, promoted_preview),
            ])
            variant = {"postprocess": "existing"}
            pose_pairs.update_variant_manifest(variant, promoted_asset, promoted_preview, "v1")
            self.assertEqual(variant["content_sha256"], pose_pairs.sha256_file(promoted_asset))
            self.assertEqual(variant["asset_sha256"], variant["content_sha256"])
            self.assertEqual(
                variant["equipped_preview_sha256"],
                pose_pairs.sha256_file(promoted_preview),
            )

    def test_family_contact_sheet_generation_is_stable(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            item = equipment.EquipmentItem(1, 10001, "test", "Test Armor", "Armor", "test.pcx")
            inventory = Image.new("RGBA", (64, 64), (20, 30, 40, 255))
            pair_paths = []

            for index in range(5):
                pair_path = root / f"pair_{index}.png"
                Image.new("RGBA", (350, 198), (40 + index, 50, 60, 255)).save(pair_path)
                pair_paths.append(pair_path)

            first = root / "first.png"
            second = root / "second.png"
            pose_pairs.save_family_contact_sheet(item, inventory.copy(), pair_paths, first)
            pose_pairs.save_family_contact_sheet(item, inventory.copy(), pair_paths, second)
            self.assertEqual(pose_pairs.sha256_file(first), pose_pairs.sha256_file(second))

    def test_dark_plate_native_mask_is_localized_to_weapon_side_arm(self) -> None:
        items, mappings, authored = pose_pairs.armor_items()
        item = items[115]
        inputs = pose_pairs.load_pair_inputs(115, item, "v1", "v1a", mappings, authored)
        allowed = pose_pairs.derive_pose_change_mask(inputs[4], inputs[5], inputs[2], inputs[3])
        coordinates = np.argwhere(allowed)
        self.assertGreater(len(coordinates), 0)
        self.assertLess(int(np.max(coordinates[:, 1])), inputs[0].width // 2)
        self.assertLess(int(np.max(coordinates[:, 0])), inputs[0].height * 2 // 3)

    def test_dark_plate_repair_has_no_forbidden_difference(self) -> None:
        items, mappings, authored = pose_pairs.armor_items()
        item = items[115]
        inputs = pose_pairs.load_pair_inputs(115, item, "v1", "v1a", mappings, authored)
        allowed = pose_pairs.derive_pose_change_mask(inputs[4], inputs[5], inputs[2], inputs[3])
        canonical, reason = pose_pairs.choose_canonical_suffix("v1", "v1a", inputs[0], inputs[1], inputs[6])
        weapon, empty = pose_pairs.lock_common_region(
            inputs[0],
            inputs[1],
            inputs[2],
            inputs[3],
            allowed,
            canonical,
            "v1",
            "v1a",
        )
        analysis = pose_pairs.analyze_pair(
            115,
            item,
            "v1",
            "v1a",
            weapon,
            empty,
            inputs[2],
            inputs[3],
            allowed,
            canonical,
            reason,
        )
        self.assertEqual(analysis.status, "reviewed")
        self.assertEqual(analysis.changed_outside_allowed, 0)
        self.assertTrue(analysis.common_rgba_exact)


if __name__ == "__main__":
    unittest.main()
