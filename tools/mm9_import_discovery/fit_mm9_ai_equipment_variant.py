#!/usr/bin/env python3
"""Fit an AI-redrawn equipment proposal to an authoritative paperdoll alpha silhouette."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import deque
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()

    with path.open("rb") as source_file:
        while chunk := source_file.read(1024 * 1024):
            digest.update(chunk)

    return digest.hexdigest()


def nearest_indices(valid: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    height, width = valid.shape
    nearest_y = np.full((height, width), -1, dtype=np.int32)
    nearest_x = np.full((height, width), -1, dtype=np.int32)
    queue: deque[tuple[int, int]] = deque()

    for y, x in np.argwhere(valid):
        nearest_y[y, x] = y
        nearest_x[y, x] = x
        queue.append((int(y), int(x)))

    if not queue:
        raise ValueError("AI proposal contains no usable equipment pixels")

    while queue:
        y, x = queue.popleft()

        for adjacent_y, adjacent_x in ((y - 1, x), (y + 1, x), (y, x - 1), (y, x + 1)):
            if not (0 <= adjacent_y < height and 0 <= adjacent_x < width):
                continue
            if nearest_y[adjacent_y, adjacent_x] >= 0:
                continue

            nearest_y[adjacent_y, adjacent_x] = nearest_y[y, x]
            nearest_x[adjacent_y, adjacent_x] = nearest_x[y, x]
            queue.append((adjacent_y, adjacent_x))

    return nearest_y, nearest_x


def erode(mask: np.ndarray, iterations: int) -> np.ndarray:
    result = Image.fromarray(mask.astype(np.uint8) * 255, "L")

    for _ in range(iterations):
        result = result.filter(ImageFilter.MinFilter(3))

    return np.asarray(result) > 0


def border_connected(mask: np.ndarray) -> np.ndarray:
    height, width = mask.shape
    connected = np.zeros_like(mask)
    queue: deque[tuple[int, int]] = deque()

    for x in range(width):
        for y in (0, height - 1):
            if mask[y, x] and not connected[y, x]:
                connected[y, x] = True
                queue.append((y, x))

    for y in range(height):
        for x in (0, width - 1):
            if mask[y, x] and not connected[y, x]:
                connected[y, x] = True
                queue.append((y, x))

    while queue:
        y, x = queue.popleft()

        for adjacent_y, adjacent_x in (
            (y - 1, x - 1), (y - 1, x), (y - 1, x + 1),
            (y, x - 1), (y, x + 1),
            (y + 1, x - 1), (y + 1, x), (y + 1, x + 1),
        ):
            if not (0 <= adjacent_y < height and 0 <= adjacent_x < width):
                continue
            if not mask[adjacent_y, adjacent_x] or connected[adjacent_y, adjacent_x]:
                continue

            connected[adjacent_y, adjacent_x] = True
            queue.append((adjacent_y, adjacent_x))

    return connected


def parse_crop(value: str | None, source_size: tuple[int, int]) -> tuple[int, int, int, int] | None:
    if value is None:
        return None

    cells = [int(cell) for cell in value.split(",")]

    if len(cells) != 4:
        raise ValueError("--crop must be left,top,right,bottom")

    left, top, right, bottom = cells

    if not (0 <= left < right <= source_size[0] and 0 <= top < bottom <= source_size[1]):
        raise ValueError(f"invalid crop {value!r} for source size {source_size}")

    return left, top, right, bottom


def row_runs(bits: np.ndarray, merge_gap: int = 1) -> list[tuple[int, int]]:
    found: list[tuple[int, int]] = []
    start: int | None = None

    for index, enabled in enumerate([*bits.tolist(), False]):
        if enabled and start is None:
            start = index
        elif not enabled and start is not None:
            found.append((start, index - 1))
            start = None

    merged: list[tuple[int, int]] = []

    for current in found:
        if merged and current[0] - merged[-1][1] - 1 <= merge_gap:
            merged[-1] = merged[-1][0], current[1]
        else:
            merged.append(current)

    return merged


def map_component_runs(
    source_runs: list[tuple[int, int]],
    target_count: int,
) -> list[tuple[int, int]]:
    if len(source_runs) == target_count:
        return source_runs
    if target_count == 1:
        return [(source_runs[0][0], source_runs[-1][1])]
    if len(source_runs) == 1:
        start, end = source_runs[0]
        width = end - start + 1
        mapped: list[tuple[int, int]] = []

        for index in range(target_count):
            left = start + width * index // target_count
            right = start + width * (index + 1) // target_count - 1

            if right < left:
                sample = round(start + index * (end - start) / (target_count - 1))
                mapped.append((sample, sample))
            else:
                mapped.append((left, right))

        return mapped

    return [
        source_runs[round(index * (len(source_runs) - 1) / (target_count - 1))]
        for index in range(target_count)
    ]


def component_samples(
    source_runs: list[tuple[int, int]],
    target_count: int,
) -> list[list[int]]:
    if target_count == 1:
        return [
            [x for left, right in source_runs for x in range(left, right + 1)]
        ]

    mapped = map_component_runs(source_runs, target_count)
    return [list(range(left, right + 1)) for left, right in mapped]


def scanline_fit(
    source_rgb: np.ndarray,
    source_mask: np.ndarray,
    target_inside: np.ndarray,
) -> tuple[np.ndarray, np.ndarray]:
    height, width = target_inside.shape
    result = np.zeros((height, width, 3), dtype=np.uint8)
    painted = np.zeros((height, width), dtype=bool)
    rows_with_source = [y for y in range(height) if row_runs(source_mask[y])]

    if not rows_with_source:
        raise ValueError("AI proposal contains no usable scanlines")

    for y in range(height):
        target_components = row_runs(target_inside[y], merge_gap=0)

        if not target_components:
            continue

        source_y = min(rows_with_source, key=lambda candidate: abs(candidate - y))
        source_components = row_runs(source_mask[source_y])
        mapped_samples = component_samples(source_components, len(target_components))

        for (target_left, target_right), source_samples in zip(
            target_components,
            mapped_samples,
        ):
            target_width = max(1, target_right - target_left)
            source_width = len(source_samples) - 1

            for target_x in range(target_left, target_right + 1):
                source_index = round(
                    (target_x - target_left) * source_width / target_width
                )
                source_x = source_samples[source_index]
                result[y, target_x] = source_rgb[source_y, source_x]
                painted[y, target_x] = True

    return result, painted


def generated_foreground(
    image: Image.Image,
    background_threshold: int,
    background_mode: str,
) -> tuple[np.ndarray, str]:
    rgba = np.asarray(image.convert("RGBA"), dtype=np.uint8)
    alpha = rgba[:, :, 3]
    rgb = rgba[:, :, :3]
    red = rgb[:, :, 0].astype(np.uint16)
    green = rgb[:, :, 1].astype(np.uint16)
    blue = rgb[:, :, 2].astype(np.uint16)
    magenta_distance_squared = (
        (255 - red).astype(np.uint32) ** 2
        + green.astype(np.uint32) ** 2
        + (255 - blue).astype(np.uint32) ** 2
    )
    magenta_candidate = magenta_distance_squared <= 150 ** 2
    magenta_hue_candidate = (
        (red >= 40)
        & (blue >= 40)
        & (red.astype(np.int32) - green.astype(np.int32) >= 28)
        & (blue.astype(np.int32) - green.astype(np.int32) >= 28)
        & (np.abs(red.astype(np.int32) - blue.astype(np.int32)) <= 24)
    )
    border_magenta = border_connected(magenta_hue_candidate)

    if background_mode == "alpha" or (background_mode == "auto" and np.any(alpha < 250)):
        foreground = alpha > 16
        detected_mode = "alpha"
    elif background_mode == "magenta" or (
        background_mode == "auto" and np.count_nonzero(border_magenta) >= border_magenta.size // 20
    ):
        # The prompt contract reserves this bright magenta range exclusively for the backdrop. Key it globally,
        # including disconnected holes enclosed by crossed legs or separate equipment parts. Darker purple item
        # materials remain outside this deliberately narrow color-distance range.
        foreground = ~(border_magenta | magenta_candidate)
        detected_mode = "magenta"
    else:
        brightness = np.mean(rgb, axis=2)
        saturation = np.max(rgb, axis=2) - np.min(rgb, axis=2)
        foreground = ~((brightness >= background_threshold) & (saturation <= 18))
        detected_mode = "light"

    cleaned = Image.fromarray(foreground.astype(np.uint8) * 255, "L")

    if detected_mode != "magenta":
        cleaned = cleaned.filter(ImageFilter.MaxFilter(3)).filter(ImageFilter.MinFilter(3))

    return np.asarray(cleaned) > 0, detected_mode


def despill_magenta_source(rgb: np.ndarray, foreground: np.ndarray) -> tuple[np.ndarray, int]:
    red = rgb[:, :, 0].astype(np.int16)
    green = rgb[:, :, 1].astype(np.int16)
    blue = rgb[:, :, 2].astype(np.int16)
    chroma_like = (
        (red >= 120)
        & (blue >= 120)
        & (green <= 150)
        & (red - green >= 45)
        & (blue - green >= 45)
    )
    interior = erode(foreground, 3)
    near_foreground = ~erode(~foreground, 3)
    spill = chroma_like & near_foreground & ~interior
    safe = foreground & ~chroma_like

    if not np.any(spill) or not np.any(safe):
        return rgb, 0

    nearest_y, nearest_x = nearest_indices(safe)
    output = rgb.copy()
    output[spill] = output[nearest_y[spill], nearest_x[spill]]
    return output, int(np.count_nonzero(spill))


def fit_generated_art(
    source: Image.Image,
    target: Image.Image,
    crop: tuple[int, int, int, int] | None,
    background_threshold: int,
    dehalo_width: int,
    dehalo_brightness: int,
    fit_mode: str = "hybrid",
    background_mode: str = "auto",
    strict_magenta_despill: bool = False,
) -> tuple[Image.Image, dict[str, object]]:
    source = source.convert("RGBA")
    target = target.convert("RGBA")
    foreground, detected_background_mode = generated_foreground(
        source,
        background_threshold,
        background_mode,
    )

    if crop is None:
        ys, xs = np.where(foreground)

        if not len(xs):
            raise ValueError("AI proposal has no detectable foreground")

        crop = int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1

    source_pixels = np.asarray(source, dtype=np.uint8).copy()
    source_pixels[~foreground, :3] = 0
    source_rgb = Image.fromarray(source_pixels[:, :, :3], "RGB").crop(crop)
    source_foreground = Image.fromarray(foreground.astype(np.uint8) * 255, "L").crop(crop)
    source_despill_pixels = 0

    if detected_background_mode == "magenta":
        cleaned_rgb, source_despill_pixels = despill_magenta_source(
            np.asarray(source_rgb, dtype=np.uint8),
            np.asarray(source_foreground) > 0,
        )
        source_rgb = Image.fromarray(cleaned_rgb, "RGB")
    target_pixels = np.asarray(target, dtype=np.uint8)
    target_alpha = target_pixels[:, :, 3]
    target_bounds = target.getchannel("A").getbbox()

    if target_bounds is None:
        raise ValueError("target fitted variant has no alpha silhouette")

    left, top, right, bottom = target_bounds
    fit_size = right - left, bottom - top
    fitted_rgb = source_rgb.resize(fit_size, Image.Resampling.LANCZOS)
    fitted_foreground = source_foreground.resize(fit_size, Image.Resampling.BILINEAR)
    fitted_rgb_pixels = np.asarray(fitted_rgb, dtype=np.uint8)
    fitted_foreground_pixels = np.asarray(fitted_foreground) > 96
    canvas_rgb = np.zeros((target.height, target.width, 3), dtype=np.uint8)
    painted = np.zeros((target.height, target.width), dtype=bool)
    inside = target_alpha > 0

    if fit_mode == "scanline":
        region_rgb, region_painted = scanline_fit(
            fitted_rgb_pixels,
            fitted_foreground_pixels,
            inside[top:bottom, left:right],
        )
        canvas_rgb[top:bottom, left:right] = region_rgb
        painted[top:bottom, left:right] = region_painted
    else:
        canvas_rgb[top:bottom, left:right] = fitted_rgb_pixels
        painted[top:bottom, left:right] = fitted_foreground_pixels

    valid = painted & inside
    missing = inside & ~valid
    initial_valid_pixels = int(np.count_nonzero(valid))
    initial_missing_pixels = int(np.count_nonzero(missing))

    if np.any(missing):
        if fit_mode == "hybrid":
            recovery_rgb, recovery_painted = scanline_fit(
                fitted_rgb_pixels,
                fitted_foreground_pixels,
                inside[top:bottom, left:right],
            )
            recovery_canvas = np.zeros_like(canvas_rgb)
            recovery_mask = np.zeros_like(inside)
            recovery_canvas[top:bottom, left:right] = recovery_rgb
            recovery_mask[top:bottom, left:right] = recovery_painted
            recovered = missing & recovery_mask
            canvas_rgb[recovered] = recovery_canvas[recovered]
            valid |= recovered
            missing = inside & ~valid

        if np.any(missing):
            nearest_y, nearest_x = nearest_indices(valid)
            canvas_rgb[missing] = canvas_rgb[nearest_y[missing], nearest_x[missing]]

    if detected_background_mode == "magenta":
        red = canvas_rgb[:, :, 0].astype(np.uint16)
        green = canvas_rgb[:, :, 1].astype(np.uint16)
        blue = canvas_rgb[:, :, 2].astype(np.uint16)
        chroma_edge = inside & ~erode(inside, 8)
        if strict_magenta_despill:
            chroma_dominance = (
                (red.astype(np.int32) - green.astype(np.int32) >= 22)
                & (blue.astype(np.int32) - green.astype(np.int32) >= 22)
            )
        else:
            chroma_dominance = (
                (red.astype(np.int32) - green.astype(np.int32) >= 38)
                & (blue.astype(np.int32) - green.astype(np.int32) >= 38)
                & (np.abs(red.astype(np.int32) - blue.astype(np.int32)) <= 42)
            )
        chroma_spill = inside & chroma_edge & chroma_dominance
        chroma_safe = inside & ~chroma_spill
        safe_y, safe_x = nearest_indices(chroma_safe)
        canvas_rgb[chroma_spill] = canvas_rgb[safe_y[chroma_spill], safe_x[chroma_spill]]
    else:
        chroma_spill = np.zeros_like(inside)

    if dehalo_width > 0:
        edge_band = inside & ~erode(inside, dehalo_width)
        brightness = np.mean(canvas_rgb, axis=2)
        saturation = np.max(canvas_rgb, axis=2) - np.min(canvas_rgb, axis=2)
        fringe = edge_band & (brightness >= dehalo_brightness) & (saturation <= 48)
        safe = inside & ~fringe & ((brightness < dehalo_brightness) | (saturation > 48))
        safe_y, safe_x = nearest_indices(safe)
        canvas_rgb[fringe] = canvas_rgb[safe_y[fringe], safe_x[fringe]]
    else:
        fringe = np.zeros_like(inside)

    canvas_rgb[~inside] = 0
    output = np.dstack((canvas_rgb, target_alpha)).astype(np.uint8)
    opaque_exact_magenta = inside & np.all(canvas_rgb == (255, 0, 255), axis=2)

    if np.any(opaque_exact_magenta):
        raise ValueError("fitted equipment contains opaque exact-magenta chroma-key pixels")

    report = {
        "source_crop": list(crop),
        "target_size": [target.width, target.height],
        "target_alpha_pixels": int(np.count_nonzero(inside)),
        "initial_painted_pixels": initial_valid_pixels,
        "filled_pixels": initial_missing_pixels,
        "dehalo_pixels": int(np.count_nonzero(fringe)),
        "chroma_spill_pixels": int(np.count_nonzero(chroma_spill)),
        "source_chroma_despill_pixels": source_despill_pixels,
        "opaque_exact_magenta_pixels": 0,
        "background_threshold": background_threshold,
        "background_mode": detected_background_mode,
        "dehalo_width": dehalo_width,
        "dehalo_brightness": dehalo_brightness,
        "fit_mode": fit_mode,
        "strict_magenta_despill": strict_magenta_despill,
    }
    return Image.fromarray(output, "RGBA"), report


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, required=True, help="high-resolution AI proposal")
    parser.add_argument("--target", type=Path, required=True, help="authoritative fitted alpha variant")
    parser.add_argument("--output", type=Path, required=True, help="fitted RGBA candidate")
    parser.add_argument("--report", type=Path, help="optional JSON fit report")
    parser.add_argument("--crop", help="optional source crop as left,top,right,bottom")
    parser.add_argument("--background-threshold", type=int, default=242)
    parser.add_argument("--background-mode", choices=["auto", "alpha", "light", "magenta"], default="auto")
    parser.add_argument("--dehalo-width", type=int, default=2)
    parser.add_argument("--dehalo-brightness", type=int, default=150)
    parser.add_argument("--fit-mode", choices=["nearest", "scanline", "hybrid"], default="hybrid")
    parser.add_argument("--strict-magenta-despill", action="store_true")
    return parser.parse_args()


def main() -> int:
    arguments = parse_arguments()
    source = Image.open(arguments.source)
    target = Image.open(arguments.target)
    crop = parse_crop(arguments.crop, source.size)
    output, report = fit_generated_art(
        source,
        target,
        crop,
        arguments.background_threshold,
        arguments.dehalo_width,
        arguments.dehalo_brightness,
        arguments.fit_mode,
        arguments.background_mode,
        arguments.strict_magenta_despill,
    )
    arguments.output.parent.mkdir(parents=True, exist_ok=True)
    output.save(arguments.output)
    report.update({
        "source": arguments.source.as_posix(),
        "source_sha256": sha256_file(arguments.source),
        "target": arguments.target.as_posix(),
        "target_sha256": sha256_file(arguments.target),
        "output": arguments.output.as_posix(),
        "output_sha256": sha256_file(arguments.output),
        "alpha_exact": output.getchannel("A").tobytes() == target.convert("RGBA").getchannel("A").tobytes(),
    })

    if arguments.report is not None:
        arguments.report.parent.mkdir(parents=True, exist_ok=True)
        arguments.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")

    print(json.dumps(report, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
