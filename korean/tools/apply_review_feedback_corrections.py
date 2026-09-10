#!/usr/bin/env python3
"""Apply reviewed Korean terminology and typo corrections to generated overlays.

The base OpenYAMM Korean catalog intentionally imports a large amount of text
from the MMMerge localization.  Player feedback can therefore identify a
small set of corrections that must be applied consistently to engine tables,
world Lua overlays, and catalog metadata after all import/extension stages
have finished.

This tool is deliberately post-generation: it never edits upstream English
assets or the external MMMerge checkout.
"""

from __future__ import annotations

import argparse
import csv
import io
import json
from collections import Counter
from pathlib import Path


# Reviewed terminology/typo corrections that are safe across all Korean
# display text.  Keep longer variants before their prefixes.
GLOBAL_REPLACEMENTS: tuple[tuple[str, str], ...] = (
    ("안타가리찬", "안타개릭"),
    ("안타가리치", "안타개릭"),
    ("자다메", "제이덤"),
    ("자데임", "제이덤"),
    ("마컴", "마크햄"),
    ("포피스냅스", "양귀비꽃"),
    ("포피스냅", "양귀비꽃"),
    ("파피스냅", "양귀비꽃"),
    ("위도우윕 열매", "위도우스위프 열매"),
    ("위도윕 열매", "위도우스위프 열매"),
    ("과부쥐 열매", "위도우스위프 열매"),
    ("과부딸기", "위도우스위프 열매"),
    ("과부쓸이 열매", "위도우스위프 열매"),
    ("사드래곤", "사용"),
    ("늑대 눈", "늑대의 눈"),
)

# "Garnet" is also a surname (Kelly Garnet) and appears in a house name, so
# the gem terminology correction is intentionally limited to the item table.
ITEM_ONLY_REPLACEMENTS: tuple[tuple[str, str], ...] = (
    ("가넷", "석류석"),
)

# These item descriptions refer to the Speed character attribute.  Other
# occurrences of "이동 속도" (Slow spell, travel prose, etc.) are genuine
# movement-speed descriptions and must not be normalized globally.
SPEED_ATTRIBUTE_ITEM_IDS = frozenset({
    244,
    265,
    277,
    515,
    518,
    525,
    1327,
    1329,
    1788,
    2043,
})

FORBIDDEN_GLOBAL_TERMS = tuple(source for source, _ in GLOBAL_REPLACEMENTS)


def apply_replacements(text: str, replacements: tuple[tuple[str, str], ...]) -> tuple[str, Counter[str]]:
    result = text
    counts: Counter[str] = Counter()
    for source, target in replacements:
        count = result.count(source)
        if count:
            result = result.replace(source, target)
            counts[source] += count
    return result, counts


def correct_catalog_entry(entry: dict) -> tuple[bool, Counter[str]]:
    translation = entry.get("translation", "")
    if not isinstance(translation, str) or not translation:
        return False, Counter()

    corrected, counts = apply_replacements(translation, GLOBAL_REPLACEMENTS)
    source_name = Path(str(entry.get("source_file", ""))).name
    record_id = entry.get("record_id")

    if source_name == "items.txt":
        corrected, item_counts = apply_replacements(corrected, ITEM_ONLY_REPLACEMENTS)
        counts.update(item_counts)
        try:
            numeric_record_id = int(record_id)
        except (TypeError, ValueError):
            numeric_record_id = -1
        if numeric_record_id in SPEED_ATTRIBUTE_ITEM_IDS:
            count = corrected.count("이동 속도")
            if count:
                corrected = corrected.replace("이동 속도", "속도")
                counts["이동 속도 (Speed attribute)"] += count

    if corrected == translation:
        return False, counts

    entry["translation"] = corrected
    note = str(entry.get("note", "")).strip()
    feedback_note = "MMMerge 1.0.14 player-feedback terminology review applied."
    if feedback_note not in note:
        entry["note"] = f"{note} {feedback_note}".strip()
    return True, counts


def correct_items_tsv(text: str) -> tuple[str, Counter[str]]:
    rows = list(csv.reader(io.StringIO(text, newline=""), delimiter="\t", quotechar='"'))
    counts: Counter[str] = Counter()

    for row in rows:
        if not row:
            continue

        for column, cell in enumerate(row):
            corrected, cell_counts = apply_replacements(cell, GLOBAL_REPLACEMENTS)
            corrected, item_counts = apply_replacements(corrected, ITEM_ONLY_REPLACEMENTS)
            cell_counts.update(item_counts)
            row[column] = corrected
            counts.update(cell_counts)

        if not row[0].strip().isdigit() or int(row[0].strip()) not in SPEED_ATTRIBUTE_ITEM_IDS:
            continue
        for column, cell in enumerate(row):
            count = cell.count("이동 속도")
            if count:
                row[column] = cell.replace("이동 속도", "속도")
                counts["이동 속도 (Speed attribute)"] += count

    output = io.StringIO(newline="")
    writer = csv.writer(
        output,
        delimiter="\t",
        quotechar='"',
        quoting=csv.QUOTE_MINIMAL,
        lineterminator="\n",
    )
    writer.writerows(rows)
    return output.getvalue(), counts


def correct_overlay_file(path: Path) -> tuple[bool, Counter[str]]:
    text = path.read_text(encoding="utf-8-sig")
    if path.name == "items.txt":
        corrected, counts = correct_items_tsv(text)
    else:
        corrected, counts = apply_replacements(text, GLOBAL_REPLACEMENTS)

    if corrected == text:
        return False, counts
    path.write_text(corrected, encoding="utf-8", newline="")
    return True, counts


def validate_catalog(catalog: dict) -> None:
    errors: list[str] = []
    for entry in catalog.get("entries", []):
        translation = entry.get("translation", "")
        if not isinstance(translation, str):
            continue
        for term in FORBIDDEN_GLOBAL_TERMS:
            if term in translation:
                errors.append(f"{entry.get('key', '<unknown>')}: stale term {term!r}")
        if Path(str(entry.get("source_file", ""))).name == "items.txt" and "가넷" in translation:
            errors.append(f"{entry.get('key', '<unknown>')}: stale item gem term '가넷'")
        try:
            record_id = int(entry.get("record_id"))
        except (TypeError, ValueError):
            record_id = -1
        if (
            Path(str(entry.get("source_file", ""))).name == "items.txt"
            and record_id in SPEED_ATTRIBUTE_ITEM_IDS
            and "이동 속도" in translation
        ):
            errors.append(f"{entry.get('key', '<unknown>')}: Speed attribute still translated as 이동 속도")

    if errors:
        raise ValueError("Reviewed feedback correction validation failed:\n" + "\n".join(errors[:50]))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", default=None)
    parser.add_argument("--catalog", default="korean/translations/catalog.json")
    parser.add_argument("--engine-overlay-root", default="korean/overlay/engine")
    parser.add_argument("--world-overlay-root", default="korean/overlay/worlds")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    catalog_path = repo_root / args.catalog
    engine_overlay_root = repo_root / args.engine_overlay_root
    world_overlay_root = repo_root / args.world_overlay_root

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    changed_entries = 0
    changed_files = 0
    counts: Counter[str] = Counter()

    for entry in catalog.get("entries", []):
        changed, entry_counts = correct_catalog_entry(entry)
        changed_entries += int(changed)
        counts.update(entry_counts)

    validate_catalog(catalog)
    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    overlay_paths: list[Path] = []
    if engine_overlay_root.exists():
        overlay_paths.extend(sorted(engine_overlay_root.rglob("*.txt")))
    if world_overlay_root.exists():
        overlay_paths.extend(sorted(world_overlay_root.rglob("*.lua")))

    for path in overlay_paths:
        changed, file_counts = correct_overlay_file(path)
        changed_files += int(changed)
        counts.update(file_counts)

    print(f"REVIEW_FEEDBACK_CHANGED_ENTRIES={changed_entries}")
    print(f"REVIEW_FEEDBACK_CHANGED_FILES={changed_files}")
    for source, target in GLOBAL_REPLACEMENTS:
        if counts[source]:
            print(f"{source} -> {target}: {counts[source]}")
    if counts["가넷"]:
        print(f"가넷 -> 석류석 (items only): {counts['가넷']}")
    if counts["이동 속도 (Speed attribute)"]:
        print(
            "이동 속도 -> 속도 (Speed attribute items only): "
            f"{counts['이동 속도 (Speed attribute)']}"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
