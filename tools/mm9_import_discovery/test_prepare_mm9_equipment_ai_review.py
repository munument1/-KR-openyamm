#!/usr/bin/env python3

import sys
import unittest
from pathlib import Path

import numpy as np
from PIL import Image

sys.path.insert(0, str(Path(__file__).resolve().parent))

import prepare_mm9_equipment_ai_review as review


class Mm9EquipmentAiReviewPreparationTest(unittest.TestCase):
    def test_mask_guide_uses_only_gray_and_exact_magenta(self) -> None:
        target = Image.new("RGBA", (3, 2), (10, 20, 30, 0))
        target.putpixel((1, 0), (10, 20, 30, 255))
        result = np.asarray(review.mask_guide(target), dtype=np.uint8)
        colors = {tuple(pixel) for pixel in result.reshape(-1, 4)}
        self.assertEqual(colors, {(255, 0, 255, 255), (138, 138, 138, 255)})

    def test_generation_prompt_requires_pose_specific_sleeves(self) -> None:
        prompt = review.generation_prompt(
            "Test Armor", 10001, "v2", "Armor", "hip_length", "mm8", "Leather Jerkin",
            "Blue trim and a tied waist.", "female human", 66, 247,
        )
        self.assertIn("primary edit base", prompt)
        self.assertIn("audited two-color target mask", prompt)
        self.assertIn("Never stretch", prompt)
        self.assertIn("66x247", prompt)

    def test_validation_prompt_uses_equipped_composite_as_evidence(self) -> None:
        prompt = review.validation_prompt("Test Armor", 10001, "v2a", "Armor", "female human", 66, 247)
        self.assertIn("final equipped-doll composite", prompt)
        self.assertIn("Change only the affected region", prompt)
        self.assertIn("Do not output the doll", prompt)

    def test_boot_validation_prompt_checks_feet_instead_of_armor_anatomy(self) -> None:
        prompt = review.validation_prompt("Test Boots", 10002, "v4", "Boots", "troll", 103, 104)
        self.assertIn("left and right foot independently", prompt)
        self.assertIn("toe, vamp, heel, and sole alignment", prompt)
        self.assertIn("shaft or ankle terminations", prompt)
        self.assertNotIn("neck alignment", prompt)
        self.assertNotIn("shoulder joins", prompt)

    def test_category_constraints_cover_all_goal_categories(self) -> None:
        self.assertEqual(set(review.CATEGORY_CONSTRAINTS), {"Armor", "Helm", "Boots", "Belt"})
        self.assertEqual(set(review.CATEGORY_REVIEW_CHECKS), {"Armor", "Helm", "Boots", "Belt"})


if __name__ == "__main__":
    unittest.main()
