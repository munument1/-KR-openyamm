#!/usr/bin/env python3
"""Generate the side-by-side MM9 monster to MM6-MM8 actor replacement catalogue."""

from __future__ import annotations

from collections import Counter
from pathlib import Path

from generate_mm9_npc_legacy_comparison_catalog import (
    build_html,
    card_html,
    copy_preview,
    read_inventory,
    read_legacy_actors,
    read_mapping,
)


INVENTORY = Path("test_img/mm9_monster_pose_catalog/inventory.tsv")
MAPPING = Path("tools/mm9_import_discovery/mm9_monster_legacy_replacements.tsv")
MONSTER_TABLE = Path("assets_dev/engine/data_tables/monster_data.txt")
MM9_PREVIEW_ROOT = Path("test_img/mm9_monster_pose_catalog")
LEGACY_PREVIEW_ROOT = Path("test_img/mm6_mm8_actor_candidates")
OUTPUT_DIR = Path("test_img/mm9_monster_legacy_comparison")


def main() -> None:
    monsters, excluded = read_inventory(INVENTORY)
    replacements = read_mapping(MAPPING)
    legacy_actors = read_legacy_actors(MONSTER_TABLE)

    missing = sorted(set(monsters) - set(replacements))
    extra = sorted(set(replacements) - set(monsters))
    if missing or extra:
        raise ValueError(f"Mapping coverage mismatch: missing={missing}, extra={extra}")
    if excluded:
        raise ValueError(f"Monster inventory unexpectedly contains ModelName=n/a rows: {sorted(excluded)}")

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    cards: list[str] = []
    counts: Counter[str] = Counter()
    for source_number in sorted(monsters):
        monster = monsters[source_number]
        replacement = replacements[source_number]
        legacy_id = int(replacement["legacy_actor_id"])
        if legacy_id not in legacy_actors:
            raise ValueError(f"Unknown legacy actor id {legacy_id} for MM9 source {source_number}")

        mm9_source = MM9_PREVIEW_ROOT / monster["preview"]
        legacy_source = LEGACY_PREVIEW_ROOT / "previews" / f"{legacy_id:03}.png"
        copy_preview(mm9_source, OUTPUT_DIR / "mm9" / f"{source_number:03}.png")
        copy_preview(legacy_source, OUTPUT_DIR / "legacy" / f"{legacy_id:03}.png")
        cards.append(card_html(source_number, monster, replacement, legacy_actors[legacy_id], "monster"))
        counts[replacement["confidence"]] += 1

    index_path = OUTPUT_DIR / "index.html"
    index_path.write_text(build_html(cards, counts, 0, "monster"), encoding="utf-8")
    print(f"monster comparison mappings: {len(cards)} ({dict(counts)})")
    print(f"catalogue: {index_path}")


if __name__ == "__main__":
    main()
