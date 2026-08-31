#!/usr/bin/env python3

import sys
import unittest
from pathlib import Path

import numpy as np
from PIL import Image

sys.path.insert(0, str(Path(__file__).resolve().parent))

import generate_mm9_armor_legacy_placeholders as placeholders


class Mm9ArmorLegacyPlaceholderTest(unittest.TestCase):
    def test_definitions_record_tier_skill_and_reviewed_reference(self) -> None:
        definitions = placeholders.load_definitions(placeholders.DEFAULT_DEFINITIONS)
        self.assertEqual(definitions[86].reference_item_id, 84)
        self.assertEqual(definitions[86].normalized_tier, 1)
        self.assertEqual(definitions[86].armor_skill, "Leather")
        self.assertEqual(definitions[225].reference_item_id, 1335)
        self.assertEqual(definitions[225].normalized_tier, 7)
        self.assertEqual(definitions[225].armor_skill, "Chain")

    def test_conservative_grade_preserves_alpha(self) -> None:
        reference = Image.new("RGBA", (4, 4), (190, 150, 30, 0))
        reference.paste((190, 150, 30, 255), (1, 0, 3, 4))
        inventory = Image.new("RGBA", (4, 4), (30, 80, 210, 255))
        output, _report = placeholders.conservative_grade(reference, inventory)
        self.assertEqual(output.getchannel("A").tobytes(), reference.getchannel("A").tobytes())

    def test_conservative_grade_does_not_recolor_waist_accent(self) -> None:
        reference = Image.new("RGBA", (10, 10), (20, 20, 20, 255))
        pixels = np.asarray(reference, dtype=np.uint8).copy()
        pixels[1:3, :, :3] = (210, 160, 25)
        pixels[5:7, :, :3] = (210, 160, 25)
        reference = Image.fromarray(pixels, "RGBA")
        inventory = Image.new("RGBA", (10, 10), (25, 80, 220, 255))
        output, _report = placeholders.conservative_grade(reference, inventory)
        result = np.asarray(output, dtype=np.uint8)
        self.assertFalse(np.array_equal(result[1, 1, :3], pixels[1, 1, :3]))
        self.assertTrue(np.array_equal(result[5, 1, :3], pixels[5, 1, :3]))

    def test_generated_prototype_has_no_foot_overlap(self) -> None:
        report_path = placeholders.DEFAULT_OUTPUT_ROOT / "report.json"

        if not report_path.is_file():
            self.skipTest("prototype output has not been generated")

        import json

        report = json.loads(report_path.read_text(encoding="utf-8"))
        self.assertEqual(len(report["items"]), 2)
        self.assertEqual(sum(len(item["variants"]) for item in report["items"]), 20)
        self.assertTrue(all(
            variant["foot_overlap_pixels"] == 0
            for item in report["items"]
            for variant in item["variants"]
        ))


if __name__ == "__main__":
    unittest.main()
