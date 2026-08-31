#!/usr/bin/env python3

import sys
import unittest
from pathlib import Path

import numpy as np
from PIL import Image

sys.path.insert(0, str(Path(__file__).resolve().parent))

import fit_mm9_ai_equipment_variant as fitter


class FitMm9AiEquipmentVariantTest(unittest.TestCase):
    def test_fit_preserves_exact_target_alpha_and_removes_white_background(self) -> None:
        source = np.full((40, 30, 4), 255, dtype=np.uint8)
        source[4:36, 9:21, :3] = (45, 70, 110)
        source[4:36, 9:21, 3] = 255
        target = np.zeros((24, 16, 4), dtype=np.uint8)
        target[2:22, 4:12, 3] = 255
        target[12:22, 7:9, 3] = 0

        fitted, report = fitter.fit_generated_art(
            Image.fromarray(source, "RGBA"),
            Image.fromarray(target, "RGBA"),
            None,
            background_threshold=242,
            dehalo_width=2,
            dehalo_brightness=150,
            background_mode="light",
        )
        fitted_pixels = np.asarray(fitted)

        self.assertEqual(fitted.getchannel("A").tobytes(), Image.fromarray(target, "RGBA").getchannel("A").tobytes())
        self.assertTrue(np.all(fitted_pixels[target[:, :, 3] > 0, :3] != 255))
        self.assertTrue(np.all(fitted_pixels[target[:, :, 3] == 0, :3] == 0))
        self.assertTrue(report["alpha_exact"] if "alpha_exact" in report else True)

    def test_parse_crop_rejects_out_of_bounds_values(self) -> None:
        with self.assertRaises(ValueError):
            fitter.parse_crop("0,0,31,40", (30, 40))

    def test_scanline_fit_covers_the_complete_target_without_background_wedges(self) -> None:
        source_rgb = np.zeros((8, 8, 3), dtype=np.uint8)
        source_rgb[:, 2:6] = (70, 90, 120)
        source_mask = np.zeros((8, 8), dtype=bool)
        source_mask[:, 2:6] = True
        target = np.zeros((8, 12), dtype=bool)
        target[:, 1:11] = True

        result, painted = fitter.scanline_fit(source_rgb, source_mask, target)

        self.assertTrue(np.all(painted[target]))
        self.assertTrue(np.all(result[target] == (70, 90, 120)))

    def test_scanline_fit_reuses_sparse_source_pixels_for_multiple_target_components(self) -> None:
        source_rgb = np.zeros((3, 5, 3), dtype=np.uint8)
        source_rgb[1, 2] = (80, 100, 140)
        source_mask = np.zeros((3, 5), dtype=bool)
        source_mask[1, 2] = True
        target = np.zeros((3, 8), dtype=bool)
        target[1, 0:2] = True
        target[1, 3:5] = True
        target[1, 6:8] = True

        result, painted = fitter.scanline_fit(source_rgb, source_mask, target)

        self.assertTrue(np.all(painted[target]))
        self.assertTrue(np.all(result[target] == (80, 100, 140)))

    def test_hybrid_fit_uses_foreground_art_instead_of_nearest_edge_stripes(self) -> None:
        source = np.full((20, 20, 4), 255, dtype=np.uint8)
        source[2:18, 6:14, :3] = (60, 80, 100)
        target = np.zeros((20, 20, 4), dtype=np.uint8)
        target[1:19, 2:18, 3] = 255

        fitted, report = fitter.fit_generated_art(
            Image.fromarray(source, "RGBA"),
            Image.fromarray(target, "RGBA"),
            None,
            background_threshold=220,
            dehalo_width=0,
            dehalo_brightness=150,
            fit_mode="hybrid",
            background_mode="light",
        )

        pixels = np.asarray(fitted)
        self.assertTrue(np.all(pixels[target[:, :, 3] > 0, :3] == (60, 80, 100)))
        self.assertEqual(report["fit_mode"], "hybrid")

    def test_magenta_background_is_detected_without_affecting_brown_armor(self) -> None:
        source = np.full((20, 20, 4), (255, 0, 255, 255), dtype=np.uint8)
        source[3:17, 6:14] = (75, 50, 40, 255)
        source[3, 6:14] = (190, 35, 180, 255)

        foreground, mode = fitter.generated_foreground(
            Image.fromarray(source, "RGBA"),
            background_threshold=220,
            background_mode="auto",
        )

        self.assertEqual(mode, "magenta")
        self.assertTrue(foreground[10, 10])
        self.assertFalse(foreground[0, 0])
        self.assertFalse(foreground[3, 10])

    def test_magenta_key_preserves_disconnected_and_interior_purple_armor(self) -> None:
        source = np.full((24, 24, 4), (255, 0, 255, 255), dtype=np.uint8)
        source[4:20, 5:19] = (105, 40, 145, 255)
        source[8:16, 9:15] = (140, 55, 175, 255)

        foreground, mode = fitter.generated_foreground(
            Image.fromarray(source, "RGBA"),
            background_threshold=220,
            background_mode="magenta",
        )

        self.assertEqual(mode, "magenta")
        self.assertFalse(foreground[0, 0])
        self.assertTrue(foreground[6, 6])
        self.assertTrue(foreground[12, 12])

    def test_magenta_key_removes_disconnected_background_island(self) -> None:
        source = np.full((24, 24, 4), (255, 0, 255, 255), dtype=np.uint8)
        source[3:21, 4:20] = (80, 55, 40, 255)
        source[9:15, 9:15] = (245, 10, 240, 255)

        foreground, mode = fitter.generated_foreground(
            Image.fromarray(source, "RGBA"),
            background_threshold=220,
            background_mode="magenta",
        )

        self.assertEqual(mode, "magenta")
        self.assertTrue(foreground[6, 6])
        self.assertFalse(foreground[12, 12])

    def test_magenta_key_removes_border_connected_dark_vignette(self) -> None:
        source = np.full((24, 24, 4), (170, 8, 165, 255), dtype=np.uint8)
        source[4:20, 6:18] = (80, 55, 40, 255)
        source[10:14, 10:14] = (105, 40, 145, 255)

        foreground, mode = fitter.generated_foreground(
            Image.fromarray(source, "RGBA"),
            background_threshold=220,
            background_mode="magenta",
        )

        self.assertEqual(mode, "magenta")
        self.assertFalse(foreground[0, 0])
        self.assertTrue(foreground[6, 8])
        self.assertTrue(foreground[12, 12])

    def test_magenta_fit_clears_hidden_background_rgb_before_resampling(self) -> None:
        source = np.full((32, 24, 4), (235, 15, 235, 255), dtype=np.uint8)
        source[3:29, 6:18] = (80, 55, 35, 255)
        source[12:20, 9:15] = (255, 0, 255, 255)
        target = np.zeros((20, 14, 4), dtype=np.uint8)
        target[1:19, 3:11, 3] = 255

        fitted, _ = fitter.fit_generated_art(
            Image.fromarray(source, "RGBA"),
            Image.fromarray(target, "RGBA"),
            None,
            background_threshold=220,
            dehalo_width=0,
            dehalo_brightness=150,
            fit_mode="hybrid",
            background_mode="magenta",
            strict_magenta_despill=True,
        )

        pixels = np.asarray(fitted)
        opaque = pixels[:, :, 3] > 0
        red = pixels[:, :, 0].astype(np.int16)
        green = pixels[:, :, 1].astype(np.int16)
        blue = pixels[:, :, 2].astype(np.int16)
        magenta_dominant = (red - green >= 22) & (blue - green >= 22)

        self.assertFalse(np.any(magenta_dominant & opaque))

    def test_magenta_fit_leaves_no_opaque_exact_key_pixels(self) -> None:
        source = np.full((32, 24, 4), (255, 0, 255, 255), dtype=np.uint8)
        source[3:29, 6:18] = (70, 85, 105, 255)
        source[3, 6:18] = (205, 40, 195, 255)
        target = np.zeros((20, 14, 4), dtype=np.uint8)
        target[1:19, 3:11, 3] = 255

        fitted, report = fitter.fit_generated_art(
            Image.fromarray(source, "RGBA"),
            Image.fromarray(target, "RGBA"),
            None,
            background_threshold=220,
            dehalo_width=0,
            dehalo_brightness=150,
            fit_mode="hybrid",
            background_mode="magenta",
        )

        pixels = np.asarray(fitted)
        opaque = pixels[:, :, 3] > 0
        self.assertFalse(np.any(np.all(pixels[:, :, :3] == (255, 0, 255), axis=2) & opaque))
        self.assertEqual(report["opaque_exact_magenta_pixels"], 0)

    def test_source_despill_repairs_edge_chroma_but_preserves_interior_purple(self) -> None:
        rgb = np.full((16, 16, 3), (70, 85, 105), dtype=np.uint8)
        foreground = np.zeros((16, 16), dtype=bool)
        foreground[2:14, 2:14] = True
        rgb[2, 4:12] = (210, 40, 205)
        rgb[7:9, 7:9] = (145, 55, 175)

        cleaned, count = fitter.despill_magenta_source(rgb, foreground)

        self.assertGreater(count, 0)
        self.assertFalse(np.any(np.all(cleaned[2, 4:12] == (210, 40, 205), axis=1)))
        self.assertTrue(np.all(cleaned[7:9, 7:9] == (145, 55, 175)))


if __name__ == "__main__":
    unittest.main()
