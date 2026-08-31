#!/usr/bin/env python3
"""Generate a side-by-side MM9 NPC to MM6-MM8 actor replacement catalogue."""

from __future__ import annotations

import argparse
import csv
import html
import shutil
from collections import Counter
from pathlib import Path


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--inventory",
        type=Path,
        default=Path("test_img/mm9_npc_pose_catalog/inventory.tsv"),
    )
    parser.add_argument(
        "--mapping",
        type=Path,
        default=Path("tools/mm9_import_discovery/mm9_npc_legacy_replacements.tsv"),
    )
    parser.add_argument(
        "--monster-table",
        type=Path,
        default=Path("assets_dev/engine/data_tables/monster_data.txt"),
    )
    parser.add_argument(
        "--mm9-preview-root",
        type=Path,
        default=Path("test_img/mm9_npc_pose_catalog"),
    )
    parser.add_argument(
        "--legacy-preview-root",
        type=Path,
        default=Path("test_img/mm6_mm8_actor_candidates"),
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=Path("test_img/mm9_npc_legacy_comparison"),
    )
    parser.add_argument(
        "--catalog-label",
        default="NPC",
        help="Source catalogue label used in the generated page title and headings.",
    )
    return parser.parse_args()


def read_inventory(path: Path) -> tuple[dict[int, dict[str, str]], set[int]]:
    actors: dict[int, dict[str, str]] = {}
    excluded: set[int] = set()
    with path.open(newline="", encoding="utf-8") as input_file:
        for row in csv.DictReader(input_file, delimiter="\t"):
            source_number = int(row["source_number"])
            if row["model"].strip().lower() == "n/a":
                excluded.add(source_number)
                continue
            actors.setdefault(source_number, row)
    return actors, excluded


def read_mapping(path: Path) -> dict[int, dict[str, str]]:
    result: dict[int, dict[str, str]] = {}
    with path.open(newline="", encoding="utf-8") as input_file:
        for row in csv.DictReader(input_file, delimiter="\t"):
            source_number = int(row["mm9_source_number"])
            if source_number in result:
                raise ValueError(f"Duplicate MM9 source number in mapping: {source_number}")
            result[source_number] = row
    return result


def read_legacy_actors(path: Path) -> dict[int, dict[str, str]]:
    result: dict[int, dict[str, str]] = {}
    with path.open(newline="", encoding="utf-8") as input_file:
        for row in csv.reader(input_file, delimiter="\t"):
            try:
                actor_id = int(row[0])
            except (ValueError, IndexError):
                continue
            if len(row) < 3:
                continue
            result[actor_id] = {"name": row[1].strip(), "picture": row[2].strip()}
    return result


def rank_from_picture(picture: str) -> str:
    tokens = picture.split()
    if tokens and tokens[-1] in {"A", "B", "C"}:
        return tokens[-1]
    return "-"


def copy_preview(source: Path, target: Path) -> None:
    if not source.is_file():
        raise FileNotFoundError(source)
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, target)


def card_html(
    source_number: int,
    actor: dict[str, str],
    replacement: dict[str, str],
    legacy: dict[str, str],
    catalog_label: str = "NPC",
) -> str:
    legacy_id = int(replacement["legacy_actor_id"])
    confidence = replacement["confidence"]
    source_image = f"mm9/{source_number:03}.png"
    legacy_image = f"legacy/{legacy_id:03}.png"
    rank = rank_from_picture(legacy["picture"])
    searchable = " ".join(
        [
            str(source_number),
            actor["role"],
            actor["type_picture"],
            actor["model"],
            str(legacy_id),
            legacy["name"],
            legacy["picture"],
            replacement["note"],
            confidence,
        ]
    ).lower()
    return f"""
<article class="card" data-confidence="{html.escape(confidence)}" data-search="{html.escape(searchable)}">
  <header>
    <h2>MM9 #{source_number}: {html.escape(actor['role'])}</h2>
    <span class="confidence {html.escape(confidence)}">{html.escape(confidence)} match</span>
  </header>
  <div class="comparison">
    <section>
      <h3>MM9 {html.escape(catalog_label)} source</h3>
      <div class="image"><img src="{source_image}" loading="lazy"></div>
      <strong>{html.escape(actor['type_picture'])}</strong>
      <small>{html.escape(actor['model'])}</small>
    </section>
    <div class="arrow">&#8594;</div>
    <section>
      <h3>MM6-MM8 replacement</h3>
      <div class="image"><img src="{legacy_image}" loading="lazy"></div>
      <strong>#{legacy_id} {html.escape(legacy['name'])}</strong>
      <small>{html.escape(legacy['picture'])}</small>
      <span class="rank">rank {html.escape(rank)}</span>
    </section>
  </div>
  <p>{html.escape(replacement['note'])}</p>
</article>"""


def build_html(
    cards: list[str],
    counts: Counter[str],
    excluded_count: int,
    catalog_label: str = "NPC",
) -> str:
    escaped_label = html.escape(catalog_label)
    exclusion_summary = (
        f" {excluded_count} <code>ModelName=n/a</code> source numbers are intentionally excluded."
        if excluded_count
        else ""
    )
    return f"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>MM9 {escaped_label} legacy replacement comparison</title>
<style>
:root {{ color-scheme: light; font-family: system-ui,sans-serif; background:#cbc6b8; color:#25231e; }}
body {{ margin:0; }}
.top {{ position:sticky; z-index:2; top:0; padding:16px 24px; background:#34372f; color:#f4f0e5;
        box-shadow:0 3px 12px #0007; }}
.top h1 {{ margin:0 0 5px; font:600 24px Georgia,serif; }}
.summary {{ margin:0 0 12px; color:#d6d8cb; }}
.controls {{ display:flex; gap:10px; align-items:center; flex-wrap:wrap; }}
input,select {{ box-sizing:border-box; padding:9px 12px; border:1px solid #858778; border-radius:4px;
               background:#f8f6ee; color:#222; font-size:15px; }}
input {{ flex:1 1 360px; }}
main {{ max-width:1500px; margin:auto; padding:20px; display:grid;
        grid-template-columns:repeat(auto-fit,minmax(590px,1fr)); gap:18px; }}
.card {{ border:1px solid #8f8a7b; border-radius:6px; background:#eeeae0;
         box-shadow:0 2px 7px #4a463b35; overflow:hidden; }}
.card>header {{ display:flex; justify-content:space-between; gap:12px; align-items:center; padding:11px 15px;
                background:#ded8c9; border-bottom:1px solid #aaa493; }}
h2 {{ margin:0; font:600 18px Georgia,serif; }}
.confidence,.rank {{ display:inline-block; border-radius:11px; padding:3px 8px; font-size:12px; white-space:nowrap; }}
.confidence.high {{ background:#47714b; color:white; }}
.confidence.medium {{ background:#a17424; color:white; }}
.confidence.low {{ background:#8a4740; color:white; }}
.comparison {{ display:grid; grid-template-columns:minmax(0,1fr) 34px minmax(0,1fr);
               align-items:center; padding:12px; }}
.comparison section {{ min-width:0; text-align:center; }}
h3 {{ margin:0 0 7px; color:#5f5a4d; font-size:13px; letter-spacing:.06em; text-transform:uppercase; }}
.image {{ height:310px; display:flex; align-items:center; justify-content:center;
          border:1px solid #b8b2a4; background:#e6e1d6; }}
img {{ max-width:100%; max-height:100%; object-fit:contain; }}
strong,small {{ display:block; margin-top:7px; overflow-wrap:anywhere; }}
small {{ min-height:34px; color:#696457; }}
.rank {{ margin-top:5px; background:#6a695f; color:white; }}
.arrow {{ color:#777164; font-size:28px; text-align:center; }}
.card>p {{ margin:0; padding:10px 15px; border-top:1px solid #c3bdae; background:#e3decf; color:#575246; }}
.hidden {{ display:none; }}
@media (max-width:650px) {{
  main {{ grid-template-columns:1fr; padding:10px; }}
  .comparison {{ grid-template-columns:1fr; gap:8px; }}
  .arrow {{ transform:rotate(90deg); }}
}}
</style>
</head>
<body>
<div class="top">
  <h1>MM9 {escaped_label} &#8594; MM6-MM8 sprite replacements</h1>
  <p class="summary"><span id="visible">{len(cards)}</span> of {len(cards)} mappings shown; {counts['high']} high,
    {counts['medium']} medium, {counts['low']} low confidence.{exclusion_summary}</p>
  <div class="controls">
    <input id="search" type="search" placeholder="Filter by MM9 actor, role, source number, legacy id, or family">
    <select id="confidence">
      <option value="">All confidence levels</option>
      <option value="high">High only</option>
      <option value="medium">Medium only</option>
      <option value="low">Low only</option>
    </select>
  </div>
</div>
<main>{''.join(cards)}</main>
<script>
const search = document.querySelector('#search');
const confidence = document.querySelector('#confidence');
const cards = [...document.querySelectorAll('.card')];
function filter() {{
  const query = search.value.toLowerCase();
  let visible = 0;
  for (const card of cards) {{
    const show = card.dataset.search.includes(query) &&
      (!confidence.value || card.dataset.confidence === confidence.value);
    card.classList.toggle('hidden', !show);
    visible += show ? 1 : 0;
  }}
  document.querySelector('#visible').textContent = visible;
}}
search.addEventListener('input', filter);
confidence.addEventListener('change', filter);
</script>
</body>
</html>
"""


def main() -> None:
    args = parse_arguments()
    actors, excluded = read_inventory(args.inventory)
    replacements = read_mapping(args.mapping)
    legacy_actors = read_legacy_actors(args.monster_table)

    missing = sorted(set(actors) - set(replacements))
    extra = sorted(set(replacements) - set(actors))
    if missing or extra:
        raise ValueError(f"Mapping coverage mismatch: missing={missing}, extra={extra}")

    args.output_dir.mkdir(parents=True, exist_ok=True)
    cards: list[str] = []
    counts: Counter[str] = Counter()
    for source_number in sorted(actors):
        actor = actors[source_number]
        replacement = replacements[source_number]
        legacy_id = int(replacement["legacy_actor_id"])
        if legacy_id not in legacy_actors:
            raise ValueError(f"Unknown legacy actor id {legacy_id} for MM9 source {source_number}")

        mm9_source = args.mm9_preview_root / actor["preview"]
        legacy_source = args.legacy_preview_root / "previews" / f"{legacy_id:03}.png"
        copy_preview(mm9_source, args.output_dir / "mm9" / f"{source_number:03}.png")
        copy_preview(legacy_source, args.output_dir / "legacy" / f"{legacy_id:03}.png")
        cards.append(card_html(source_number, actor, replacement, legacy_actors[legacy_id], args.catalog_label))
        counts[replacement["confidence"]] += 1

    index_path = args.output_dir / "index.html"
    index_path.write_text(build_html(cards, counts, len(excluded), args.catalog_label), encoding="utf-8")
    print(f"comparison mappings: {len(cards)} ({dict(counts)})")
    print(f"excluded ModelName=n/a source numbers: {len(excluded)}")
    print(f"catalogue: {index_path}")


if __name__ == "__main__":
    main()
