#!/usr/bin/env python3
"""Generate an inventory and initial-pose image catalogue for MM9 non-monster actors."""

from __future__ import annotations

import argparse
import csv
import html
import json
import subprocess
from collections import OrderedDict
from pathlib import Path

import yaml
from PIL import Image, ImageDraw, ImageFont

from batch_convert_actor_models import SKIN_COLUMNS, clean_field, slug, stem_id


CATALOG_SCHEMA = "openyamm.mm9NpcPoseCatalog.v1"
PREVIEW_SIZE = (360, 480)


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--actor-table", type=Path, default=Path("mm9/extracted/DATA/DATA/ACTOR.txt"))
    parser.add_argument("--visual-table", type=Path, default=Path("mm9/extracted/DATA/DATA/MONSTERS.txt"))
    parser.add_argument("--model-root", type=Path, required=True)
    parser.add_argument("--skin-preview-root", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, default=Path("test_img/mm9_npc_pose_catalog"))
    parser.add_argument("--blender", default="blender")
    parser.add_argument("--inventory-only", action="store_true")
    parser.add_argument("--limit", type=int)
    return parser.parse_args()


def read_table_rows(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="cp1252") as input_file:
        return list(csv.DictReader(input_file, delimiter="\t"))


def read_npc_rows(actor_path: Path, visual_path: Path) -> list[dict[str, str]]:
    visual_rows = {
        clean_field(row.get("Number")): row
        for row in read_table_rows(visual_path)
        if clean_field(row.get("Number"))
    }
    rows = []
    for source_row, source in enumerate(read_table_rows(actor_path), start=2):
        if not clean_field(source.get("ModelName")) or clean_field(source.get("IsMonster")) == "1":
            continue

        row = dict(source)
        visual = visual_rows.get(clean_field(row.get("Number")))
        if visual is not None:
            visual_model = clean_field(visual.get("ModelName"))
            row["ModelName"] = visual_model or "n/a"
            for column in SKIN_COLUMNS:
                row[column] = clean_field(visual.get(column))

        model_name = clean_field(row.get("ModelName"))
        type_picture = clean_field(row.get("Type/Picture"))
        if model_name.lower() == "sheep.abc" and type_picture not in {"Ewe", "Ram"}:
            row["ModelName"] = "n/a"
            for column in SKIN_COLUMNS:
                row[column] = ""

        row["_source_row"] = str(source_row)
        rows.append(row)
    return rows


def row_record(row: dict[str, str], source_row: int) -> dict:
    def integer(name: str) -> int:
        value = clean_field(row.get(name))
        try:
            return int(value)
        except ValueError:
            return 0

    return {
        "sourceRow": source_row,
        "sourceNumber": integer("Number"),
        "role": clean_field(row.get("Monster Name")),
        "typePicture": clean_field(row.get("Type/Picture")),
        "baseName": clean_field(row.get("BaseName")),
        "level": integer("LVL"),
        "hitPoints": integer("HP"),
        "armorClass": integer("AC"),
        "experience": integer("EXP"),
    }


def build_variants(rows: list[dict[str, str]], limit: int | None) -> list[dict]:
    variants: OrderedDict[tuple[str, tuple[str, ...]], dict] = OrderedDict()
    for row in rows:
        source_row = int(row["_source_row"])
        model_name = clean_field(row.get("ModelName"))
        skins = tuple(clean_field(row.get(column)) for column in SKIN_COLUMNS)
        skins = tuple(value for value in skins if value)
        key = (model_name.lower(), tuple(value.lower() for value in skins))
        if key not in variants:
            model_id = "unassigned_model" if model_name.lower() == "n/a" else stem_id(model_name)
            skin_id = "_".join(stem_id(value) for value in skins)
            variants[key] = {
                "variantId": model_id if not skin_id else f"{model_id}_{skin_id}",
                "modelId": model_id,
                "modelName": model_name,
                "skins": list(skins),
                "rows": [],
            }
        variants[key]["rows"].append(row_record(row, source_row))
    result = list(variants.values())
    return result[:limit] if limit is not None else result


def index_by_name(root: Path, suffix: str) -> dict[str, Path]:
    result = {}
    for path in sorted(root.rglob(f"*{suffix}"), key=lambda value: str(value).lower()):
        result.setdefault(path.name.lower(), path)
    return result


def model_material_indices(sidecar_path: Path, skin_count: int) -> list[int]:
    if sidecar_path.exists():
        sidecar = yaml.safe_load(sidecar_path.read_text(encoding="utf-8")) or {}
        indices = sorted(
            {
                int(piece.get("materialIndex", 0))
                for piece in sidecar.get("pieces", [])
                if isinstance(piece, dict)
            }
        )
        if indices:
            return indices
    return list(range(max(1, skin_count)))


def resolve_assets(variants: list[dict], model_root: Path, skin_preview_root: Path, output_dir: Path) -> list[dict]:
    preview_index = index_by_name(skin_preview_root, ".png")
    jobs = []
    for index, variant in enumerate(variants, start=1):
        model_path = model_root / f"{variant['modelId']}.glb"
        sidecar_path = model_root / f"{variant['modelId']}.model.yml"
        material_indices = model_material_indices(sidecar_path, len(variant["skins"]))
        maximum_index = max(material_indices, default=0)
        texture_paths: list[str | None] = [None] * (maximum_index + 1)
        missing_material_indices = []
        skins = variant["skins"]
        if not skins:
            fallback = preview_index.get(f"{variant['modelId']}.png")
            skins = [fallback.name] if fallback is not None else []

        for material_index in material_indices:
            skin_name = skins[material_index] if material_index < len(skins) else ""
            preview = preview_index.get(f"{stem_id(skin_name)}.png") if skin_name else None
            if preview is None:
                missing_material_indices.append(material_index)
            else:
                texture_paths[material_index] = str(preview.resolve())

        preview_name = f"{index:03d}_{slug(variant['variantId'])}.png"
        preview_path = output_dir / "previews" / preview_name
        warnings = list(variant.get("warnings", []))
        if not model_path.exists():
            warnings.append(f"missing converted model: {model_path}")
        if missing_material_indices:
            warnings.append(f"missing preview textures for material indices {missing_material_indices}")

        variant.update(
            {
                "modelPath": str(model_path),
                "sidecarPath": str(sidecar_path),
                "materialIndices": material_indices,
                "texturePaths": texture_paths,
                "missingMaterialIndices": missing_material_indices,
                "preview": f"previews/{preview_name}",
                "rendered": False,
                "warnings": warnings,
            }
        )
        if model_path.exists():
            jobs.append(
                {
                    "variant_id": variant["variantId"],
                    "model_path": str(model_path.resolve()),
                    "texture_paths": texture_paths,
                    "missing_material_indices": missing_material_indices,
                    "output_path": str(preview_path.resolve()),
                }
            )
    return jobs


def font(size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    path = Path("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf")
    return ImageFont.truetype(path, size=size) if path.exists() else ImageFont.load_default()


def fit_text(draw: ImageDraw.ImageDraw, value: str, text_font: ImageFont.ImageFont, maximum_width: int) -> str:
    if draw.textlength(value, font=text_font) <= maximum_width:
        return value
    suffix = "…"
    low = 0
    high = len(value)
    while low < high:
        middle = (low + high + 1) // 2
        if draw.textlength(value[:middle] + suffix, font=text_font) <= maximum_width:
            low = middle
        else:
            high = middle - 1
    return value[:low] + suffix


def placeholder(path: Path, title: str, details: str) -> None:
    image = Image.new("RGBA", PREVIEW_SIZE, (42, 38, 45, 255))
    draw = ImageDraw.Draw(image)
    draw.line((45, 70, 315, 410), fill=(155, 70, 150, 255), width=8)
    draw.line((315, 70, 45, 410), fill=(155, 70, 150, 255), width=8)
    draw.multiline_text((20, 18), title, fill=(255, 235, 255, 255), font=font(18), spacing=5)
    draw.multiline_text((20, 425), details, fill=(220, 190, 220, 255), font=font(12), spacing=3)
    path.parent.mkdir(parents=True, exist_ok=True)
    image.save(path)


def render_jobs(arguments: argparse.Namespace, jobs: list[dict], variants: list[dict]) -> None:
    output_dir = arguments.output_dir.resolve()
    jobs_path = output_dir / "render_jobs.json"
    results_path = output_dir / "render_results.json"
    jobs_path.write_text(json.dumps(jobs, indent=2) + "\n", encoding="utf-8")
    renderer = Path(__file__).with_name("render_mm9_npc_pose_catalog_blender.py")
    command = [
        arguments.blender,
        "--background",
        "--python",
        str(renderer),
        "--",
        "--jobs",
        str(jobs_path),
        "--results",
        str(results_path),
    ]
    result = subprocess.run(command, check=False)
    render_results = {}
    if results_path.exists():
        render_results = {
            entry["variant_id"]: entry for entry in json.loads(results_path.read_text(encoding="utf-8"))
        }

    for variant in variants:
        preview_path = output_dir / variant["preview"]
        render_result = render_results.get(variant["variantId"])
        variant["rendered"] = bool(render_result and render_result["ok"] and preview_path.exists())
        if not variant["rendered"]:
            error = render_result["error"] if render_result else "model was not submitted to Blender"
            variant["warnings"].append(error)
            placeholder(preview_path, variant["variantId"], "\n".join(variant["warnings"][-2:]))

    if result.returncode != 0:
        print(f"Blender returned {result.returncode}; failed variants received placeholders.")


def write_inventory(
    output_dir: Path,
    actor_table: Path,
    visual_table: Path,
    variants: list[dict],
    catalog_label: str = "NPC",
    selection: str | None = None,
    schema: str = CATALOG_SCHEMA,
) -> None:
    summary = {
        "sourceRows": sum(len(variant["rows"]) for variant in variants),
        "uniqueVariants": len(variants),
        "uniqueModels": len({variant["modelId"] for variant in variants}),
        "renderedVariants": sum(variant["rendered"] for variant in variants),
        "variantsWithWarnings": sum(bool(variant["warnings"]) for variant in variants),
    }
    inventory = {
        "schema": schema,
        "source": {"actors": str(actor_table), "visuals": str(visual_table)},
        "selection": selection
        or f"{actor_table.name} non-monsters with visual fields resolved from {visual_table.name}",
        "summary": summary,
        "variants": variants,
    }
    (output_dir / "inventory.yml").write_text(yaml.safe_dump(inventory, sort_keys=False), encoding="utf-8")

    columns = [
        "source_row",
        "source_number",
        "role",
        "type_picture",
        "level",
        "hp",
        "ac",
        "experience",
        "model",
        "skins",
        "variant_id",
        "preview",
        "warnings",
    ]
    with (output_dir / "inventory.tsv").open("w", encoding="utf-8", newline="") as output_file:
        writer = csv.writer(output_file, delimiter="\t", lineterminator="\n")
        writer.writerow(columns)
        for variant in variants:
            for row in variant["rows"]:
                writer.writerow(
                    [
                        row["sourceRow"],
                        row["sourceNumber"],
                        row["role"],
                        row["typePicture"],
                        row["level"],
                        row["hitPoints"],
                        row["armorClass"],
                        row["experience"],
                        variant["modelName"],
                        ";".join(variant["skins"]),
                        variant["variantId"],
                        variant["preview"],
                        "; ".join(variant["warnings"]),
                    ]
                )

    unrendered = [variant for variant in variants if not variant["rendered"]]
    readme = [
        f"# MM9 {catalog_label} initial-pose catalogue",
        "",
        f"Selection: {inventory['selection']}.",
        f"Visual fields are resolved from `{visual_table.name}`. Each image uses animation time zero and a fixed",
        "three-quarter orthographic camera. Magenta materials identify unresolved source textures.",
        "",
        f"- Source rows: {summary['sourceRows']}",
        f"- Unique model/skin variants: {summary['uniqueVariants']}",
        f"- Unique models: {summary['uniqueModels']}",
        f"- Rendered variants: {summary['renderedVariants']}",
        f"- Variants with warnings: {summary['variantsWithWarnings']}",
        "",
        f"Open `index.html` for the searchable gallery. `inventory.tsv` has one record per MM9 "
        f"{catalog_label} row, while",
        "`inventory.yml` preserves grouped variant provenance.",
        "",
    ]
    if unrendered:
        readme.extend(
            [
                "## Unrendered source entries",
                "",
                *[
                    f"- `{variant['variantId']}` ({len(variant['rows'])} source rows): "
                    + "; ".join(variant["warnings"])
                    for variant in unrendered
                ],
                "",
            ]
        )
    (output_dir / "README.md").write_text("\n".join(readme), encoding="utf-8")


def contact_sheet(output_dir: Path, variants: list[dict], sheet_index: int, start: int, count: int = 16) -> None:
    tile_width, tile_height = 360, 570
    columns, rows = 4, 4
    sheet = Image.new("RGB", (tile_width * columns, tile_height * rows), (224, 222, 216))
    draw = ImageDraw.Draw(sheet)
    title_font = font(16)
    detail_font = font(12)
    for slot, variant in enumerate(variants[start : start + count]):
        x = (slot % columns) * tile_width
        y = (slot // columns) * tile_height
        preview = Image.open(output_dir / variant["preview"]).convert("RGBA")
        background = Image.new("RGBA", PREVIEW_SIZE, (235, 233, 225, 255))
        background.alpha_composite(preview)
        sheet.paste(background.convert("RGB"), (x, y))
        first = variant["rows"][0]
        extra = len(variant["rows"]) - 1
        role = f"#{first['sourceNumber']} {first['role']}" + (f" (+{extra} rows)" if extra else "")
        maximum_width = tile_width - 20
        draw.text(
            (x + 10, y + 488),
            fit_text(draw, role, title_font, maximum_width),
            fill=(25, 25, 25),
            font=title_font,
        )
        draw.text(
            (x + 10, y + 513),
            fit_text(draw, first["typePicture"], detail_font, maximum_width),
            fill=(45, 45, 45),
            font=detail_font,
        )
        source_assets = f"{variant['modelName']} | {', '.join(variant['skins']) or '[no skin]'}"
        draw.text(
            (x + 10, y + 535),
            fit_text(draw, source_assets, detail_font, maximum_width),
            fill=(90, 40, 40) if variant["warnings"] else (65, 65, 65),
            font=detail_font,
        )
    sheet.save(output_dir / f"contact_sheet_{sheet_index:02d}.jpg", quality=91, optimize=True)


def write_gallery(output_dir: Path, variants: list[dict], catalog_label: str = "NPC") -> None:
    cards = []
    for variant in variants:
        search_text = variant["variantId"] + " " + " ".join(row["role"] for row in variant["rows"])
        rows = "".join(
            "<li>#{sourceNumber} {role} — {typePicture}; L{level}, HP {hitPoints}, AC {armorClass}</li>".format(
                **{key: html.escape(str(value)) for key, value in row.items()}
            )
            for row in variant["rows"]
        )
        warnings = "".join(f"<li>{html.escape(value)}</li>" for value in variant["warnings"])
        cards.append(
            f"""
<article data-search="{html.escape(search_text.lower())}">
  <img src="{html.escape(variant['preview'])}" loading="lazy">
  <h2>{html.escape(variant['variantId'])}</h2>
  <p><code>{html.escape(variant['modelName'])}</code><br>{html.escape(', '.join(variant['skins']) or '[no skin]')}</p>
  <ul>{rows}</ul>
  {f'<ul class="warning">{warnings}</ul>' if warnings else ''}
</article>"""
        )
    page = f"""<!doctype html>
<meta charset="utf-8">
<title>MM9 {html.escape(catalog_label)} initial-pose catalogue</title>
<style>
body {{ margin: 20px; font: 14px sans-serif; background: #d8d5ca; color: #222; }}
input {{ box-sizing: border-box; width: 100%; padding: 12px; margin-bottom: 18px; font-size: 17px; }}
main {{ display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 16px; }}
article {{ background: #f3f0e7; border: 1px solid #999; padding: 10px; overflow: hidden; }}
img {{ display: block; width: 100%; max-height: 480px; object-fit: contain; background: #e7e4dc; }}
h2 {{ font-size: 16px; overflow-wrap: anywhere; }} ul {{ padding-left: 20px; }}
.warning {{ color: #8b174c; }} code {{ overflow-wrap: anywhere; }}
</style>
<h1>MM9 {html.escape(catalog_label)} initial-pose catalogue</h1>
<input id="search" placeholder="Filter by role, model, skin, or variant…">
<main>{''.join(cards)}</main>
<script>
const search = document.querySelector('#search');
search.addEventListener('input', () => {{
  const value = search.value.toLowerCase();
  document.querySelectorAll('article').forEach(card => card.hidden = !card.innerText.toLowerCase().includes(value));
}});
</script>
"""
    (output_dir / "index.html").write_text(page, encoding="utf-8")
    for start in range(0, len(variants), 16):
        contact_sheet(output_dir, variants, start // 16 + 1, start)


def main() -> int:
    arguments = parse_arguments()
    arguments.output_dir.mkdir(parents=True, exist_ok=True)
    variants = build_variants(read_npc_rows(arguments.actor_table, arguments.visual_table), arguments.limit)
    expected_previews = {
        f"{index:03d}_{slug(variant['variantId'])}.png" for index, variant in enumerate(variants, start=1)
    }
    preview_dir = arguments.output_dir / "previews"
    for preview_path in preview_dir.glob("*.png"):
        if preview_path.name not in expected_previews:
            preview_path.unlink()
    jobs = resolve_assets(variants, arguments.model_root, arguments.skin_preview_root, arguments.output_dir)
    if arguments.inventory_only:
        for variant in variants:
            preview_path = arguments.output_dir / variant["preview"]
            placeholder(preview_path, variant["variantId"], "inventory-only run")
    else:
        render_jobs(arguments, jobs, variants)
    write_inventory(arguments.output_dir, arguments.actor_table, arguments.visual_table, variants)
    write_gallery(arguments.output_dir, variants)
    print(
        f"MM9 NPC catalogue: {sum(len(variant['rows']) for variant in variants)} rows, "
        f"{len(variants)} variants, {sum(variant['rendered'] for variant in variants)} rendered"
    )
    print(f"catalogue: {arguments.output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
