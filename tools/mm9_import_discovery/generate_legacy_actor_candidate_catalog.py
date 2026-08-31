#!/usr/bin/env python3
"""Generate a front-view catalogue of merged MM6-MM8 actor sprites."""

from __future__ import annotations

import argparse
import csv
import html
from pathlib import Path

import yaml
from PIL import Image, ImageDraw, ImageFont


PREVIEW_SIZE = (280, 360)
LABEL_HEIGHT = 82


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--monster-data",
        type=Path,
        default=Path("assets_dev/engine/data_tables/monster_data.txt"),
    )
    parser.add_argument(
        "--monster-descriptors",
        type=Path,
        default=Path("assets_dev/engine/data_tables/monster_descriptors.txt"),
    )
    parser.add_argument(
        "--sprite-frames",
        type=Path,
        default=Path("assets_dev/engine/rendering/sprite_frame_data_common.yml"),
    )
    parser.add_argument(
        "--sprite-root",
        type=Path,
        action="append",
        default=None,
        help="Sprite bitmap root. May be repeated; earlier roots take precedence.",
    )
    parser.add_argument("--output-dir", type=Path, default=Path("test_img/mm6_mm8_actor_candidates"))
    parser.add_argument("--ids", help="Comma-separated ids and inclusive ranges, for example 1,10-18,313-384.")
    return parser.parse_args()


def parse_ids(value: str | None) -> set[int] | None:
    if not value:
        return None
    result = set()
    for part in value.split(","):
        bounds = part.strip().split("-", maxsplit=1)
        if len(bounds) == 1:
            result.add(int(bounds[0]))
        else:
            result.update(range(int(bounds[0]), int(bounds[1]) + 1))
    return result


def read_table(path: Path) -> dict[int, list[str]]:
    result = {}
    with path.open(encoding="latin-1", newline="") as input_file:
        for row in csv.reader(input_file, delimiter="\t"):
            if row and row[0].isdigit():
                result[int(row[0])] = row
    return result


def font(size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    path = Path("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf")
    return ImageFont.truetype(path, size=size) if path.exists() else ImageFont.load_default()


def group_record(group: dict) -> tuple[str, int]:
    first_frame = group["frames"][0]
    return first_frame["texture_name"], int(first_frame.get("palette_id", 0))


def frame_index(path: Path) -> dict[str, tuple[str, int]]:
    data = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    result = {
        group["sprite_name"].lower(): group_record(group)
        for group in data.get("sprites", [])
        if group.get("sprite_name") and group.get("frames")
    }
    monster_root = path.parent / "sprite_frames" / "monsters"
    for monster_path in sorted(monster_root.glob("*.yml")):
        monster_data = yaml.safe_load(monster_path.read_text(encoding="utf-8")) or {}
        result.update(
            {
                group["sprite_name"].lower(): group_record(group)
                for group in monster_data.get("sprites", [])
                if group.get("sprite_name") and group.get("frames")
            }
        )
    return result


def bitmap_index(roots: list[Path]) -> dict[str, Path]:
    result = {}
    for root in roots:
        for path in root.glob("*.bmp"):
            result.setdefault(path.stem.lower(), path)
    return result


def resolve_palette(world_id: str, palette_id: int) -> Path | None:
    root = Path(f"assets_editor_dev/worlds/{world_id}/textures")
    for name in (f"pal{palette_id:03d}.act", f"Pal{palette_id:03d}.act"):
        path = root / name
        if path.is_file():
            return path
    return None


def resolve_bitmap(sprite_name: str, frames: dict[str, tuple[str, int]], bitmaps: dict[str, Path]) -> Path | None:
    texture_name = frames.get(sprite_name.lower(), (sprite_name, 0))[0]
    candidates = [texture_name]
    if not texture_name[-1:].isdigit():
        candidates.insert(0, texture_name + "0")
    for candidate in candidates:
        path = bitmaps.get(candidate.lower())
        if path is not None:
            return path
    return None


def load_sprite(path: Path, palette_path: Path | None) -> Image.Image:
    source = Image.open(path)
    source.load()
    if source.mode in {"P", "L"}:
        if palette_path is not None:
            indexed = Image.frombytes("P", source.size, source.tobytes())
            indexed.putpalette(palette_path.read_bytes()[: 256 * 3])
            source = indexed
        indices = Image.frombytes("L", source.size, source.tobytes())
        alpha = indices.point(lambda value: 0 if value == 0 else 255)
    else:
        alpha = Image.new("L", source.size, 255)
    sprite = source.convert("RGBA")
    sprite.putalpha(alpha)
    bounds = alpha.getbbox()
    return sprite.crop(bounds) if bounds else sprite


def fit_text(draw: ImageDraw.ImageDraw, value: str, text_font: ImageFont.ImageFont, width: int) -> str:
    if draw.textlength(value, font=text_font) <= width:
        return value
    suffix = "…"
    while value and draw.textlength(value + suffix, font=text_font) > width:
        value = value[:-1]
    return value + suffix


def make_preview(entry: dict) -> Image.Image:
    image = Image.new("RGB", PREVIEW_SIZE, (235, 233, 225))
    draw = ImageDraw.Draw(image)
    sprite_path = entry["sprite_path"]
    if sprite_path is not None:
        sprite = load_sprite(sprite_path, entry["palette_path"])
        sprite.thumbnail((PREVIEW_SIZE[0] - 24, PREVIEW_SIZE[1] - LABEL_HEIGHT - 16), Image.Resampling.LANCZOS)
        x = (PREVIEW_SIZE[0] - sprite.width) // 2
        y = (PREVIEW_SIZE[1] - LABEL_HEIGHT - sprite.height) // 2
        image.paste(sprite, (x, y), sprite)
    else:
        draw.line((45, 40, 235, 250), fill=(155, 70, 150), width=7)
        draw.line((235, 40, 45, 250), fill=(155, 70, 150), width=7)

    title_font = font(15)
    detail_font = font(11)
    top = PREVIEW_SIZE[1] - LABEL_HEIGHT
    draw.rectangle((0, top, PREVIEW_SIZE[0], PREVIEW_SIZE[1]), fill=(220, 218, 211))
    width = PREVIEW_SIZE[0] - 16
    title = fit_text(draw, f"#{entry['id']} {entry['name']}", title_font, width)
    draw.text((8, top + 7), title, font=title_font, fill=(25, 25, 25))
    draw.text((8, top + 31), fit_text(draw, entry["picture"], detail_font, width), font=detail_font, fill=(45, 45, 45))
    detail = f"{entry['standing']} → {entry['texture']} / pal{entry['palette_id']:03d}"
    draw.text((8, top + 51), fit_text(draw, detail, detail_font, width), font=detail_font, fill=(70, 70, 70))
    return image


def write_gallery(output_dir: Path, entries: list[dict]) -> None:
    cards = []
    for entry in entries:
        preview = entry["preview"]
        cards.append(
            f'<article><img src="{preview}"><b>#{entry["id"]} {html.escape(entry["name"])}</b>'
            f'<span>{html.escape(entry["picture"])}</span><code>{html.escape(entry["standing"])}</code></article>'
        )
    page = f"""<!doctype html>
<meta charset="utf-8"><title>MM6-MM8 actor sprite candidates</title>
<style>
body {{ margin:20px; background:#d8d5ca; font:14px sans-serif; }}
input {{ box-sizing:border-box; width:100%; padding:12px; margin-bottom:18px; font-size:17px; }}
main {{ display:grid; grid-template-columns:repeat(auto-fill,minmax(240px,1fr)); gap:12px; }}
article {{ background:#f3f0e7; border:1px solid #999; padding:8px; }}
img {{ display:block; width:100%; }} span,code {{ display:block; margin-top:5px; overflow-wrap:anywhere; }}
</style>
<h1>MM6-MM8 actor sprite candidates</h1><input id="search" placeholder="Filter by id, name, or picture…">
<main>{''.join(cards)}</main>
<script>const s=document.querySelector('#search');s.oninput=()=>document.querySelectorAll('article').forEach(
c=>c.hidden=!c.innerText.toLowerCase().includes(s.value.toLowerCase()));</script>
"""
    (output_dir / "index.html").write_text(page, encoding="utf-8")


def main() -> int:
    arguments = parse_arguments()
    selected_ids = parse_ids(arguments.ids)
    monster_data = read_table(arguments.monster_data)
    descriptors = read_table(arguments.monster_descriptors)
    frames = frame_index(arguments.sprite_frames)
    roots = arguments.sprite_root or [Path("assets_dev/engine/sprites"), Path("assets_dev/worlds/mm7/sprites")]
    bitmaps = bitmap_index(roots)
    arguments.output_dir.mkdir(parents=True, exist_ok=True)
    preview_dir = arguments.output_dir / "previews"
    preview_dir.mkdir(parents=True, exist_ok=True)

    entries = []
    for actor_id in sorted(monster_data.keys() & descriptors.keys()):
        if selected_ids is not None and actor_id not in selected_ids:
            continue
        data_row = monster_data[actor_id]
        descriptor_row = descriptors[actor_id]
        standing = descriptor_row[11]
        texture, palette_id = frames.get(standing.lower(), (standing, 0))
        sprite_path = resolve_bitmap(standing, frames, bitmaps)
        world_id = "mm8" if actor_id <= 180 else "mm7" if actor_id <= 492 else "mm6"
        palette_path = resolve_palette(world_id, palette_id)
        preview_name = f"{actor_id:03d}.png"
        entry = {
            "id": actor_id,
            "name": data_row[1],
            "picture": data_row[2],
            "standing": standing,
            "texture": texture,
            "palette_id": palette_id,
            "palette_path": palette_path,
            "sprite_path": sprite_path,
            "preview": f"previews/{preview_name}",
        }
        make_preview(entry).save(preview_dir / preview_name)
        entries.append(entry)

    write_gallery(arguments.output_dir, entries)
    for start in range(0, len(entries), 20):
        sheet = Image.new("RGB", (PREVIEW_SIZE[0] * 5, PREVIEW_SIZE[1] * 4), (224, 222, 216))
        for slot, entry in enumerate(entries[start : start + 20]):
            preview = Image.open(arguments.output_dir / entry["preview"]).convert("RGB")
            sheet.paste(preview, ((slot % 5) * PREVIEW_SIZE[0], (slot // 5) * PREVIEW_SIZE[1]))
        sheet.save(arguments.output_dir / f"contact_sheet_{start // 20 + 1:02d}.jpg", quality=92)

    missing = sum(entry["sprite_path"] is None for entry in entries)
    print(f"legacy actor candidates: {len(entries)} entries, {missing} missing previews")
    print(f"catalogue: {arguments.output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
