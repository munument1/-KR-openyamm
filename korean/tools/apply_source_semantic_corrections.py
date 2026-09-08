#!/usr/bin/env python3
"""Normalize Korean display terminology from the English catalog source.

This is a final post-generation pass.  It is intentionally source-aware so
upstream MMMerge wording changes (for example Endurance translated as either
체력 or 인내력) cannot silently reintroduce terminology drift into OpenYAMM.
The corrected catalog item Name/Notes fields are then synchronized into the
actual generated items.txt overlay.
"""

from __future__ import annotations

import argparse
import csv
import io
import json
import re
from collections import Counter
from pathlib import Path


SOURCE_TERMS: tuple[tuple[str, tuple[tuple[str, str], ...]], ...] = (
    ("Intellect", (("지력", "지능"),)),
    ("Accuracy", (("정확도", "적중률"),)),
    ("Endurance", (("인내력", "체력"),)),
    ("Speed", (("민첩성", "속도"),)),
    ("Air", (("대기 마법", "공기 마법"), ("대기 저항", "공기 저항"), ("대기 피해", "공기 피해"))),
    ("Body", (("신체 마법", "육체 마법"), ("신체 저항", "육체 저항"), ("신체 피해", "육체 피해"), ("신체 보호", "육체 보호"))),
    ("Earth", (("흙 마법", "대지 마법"),)),
    ("Resistance", (("저항력", "저항"),)),
    ("Resistances", (("저항력", "저항"),)),
)

MECHANICAL_OVERLAY_REPLACEMENTS: dict[str, tuple[tuple[str, str], ...]] = {
    "standard_item_enchants.txt": (
        ("지력", "지능"),
        ("정확도", "적중률"),
        ("인내력", "체력"),
        ("민첩성", "속도"),
        ("대기", "공기"),
        ("신체", "육체"),
        ("저항력", "저항"),
    ),
    "special_item_enchants.txt": (
        ("지력", "지능"),
        ("정확도", "적중률"),
        ("인내력", "체력"),
        ("민첩성", "속도"),
        ("대기", "공기"),
        ("신체", "육체"),
        ("저항력", "저항"),
    ),
    "stats.txt": (
        ("대기 저항", "공기 저항"),
        ("대기 기반", "공기 기반"),
        ("대기 피해", "공기 피해"),
        ("신체 저항", "육체 저항"),
        ("신체 기반", "육체 기반"),
        ("신체 피해", "육체 피해"),
    ),
    "skill_des.txt": (
        ("대기 마법", "공기 마법"),
        ("신체 마법", "육체 마법"),
    ),
    "spells.txt": (
        ("대기 마법", "공기 마법"),
        ("신체 마법", "육체 마법"),
        ("신체 저항", "육체 저항"),
        ("신체 피해", "육체 피해"),
        ("신체 보호", "육체 보호"),
        ("저항력", "저항"),
    ),
}


def source_has_word(source: str, word: str) -> bool:
    return re.search(r"\b" + re.escape(word) + r"\b", source) is not None


def replace_all(text: str, replacements: tuple[tuple[str, str], ...], counts: Counter[str]) -> str:
    result = text
    for old, new in replacements:
        count = result.count(old)
        if count:
            result = result.replace(old, new)
            counts[f"{old} -> {new}"] += count
    return result


def normalize_translation(source_name: str, source: str, translation: str, counts: Counter[str]) -> str:
    result = translation
    for english, replacements in SOURCE_TERMS:
        if source_has_word(source, english):
            result = replace_all(result, replacements, counts)

    if source_has_word(source, "Luck"):
        if source_name == "items.txt":
            # Preserve natural prose such as '행운을 빈다'; only normalize
            # explicit mechanical stat forms in item descriptions.
            result = re.sub(r"행운(?=\s*[+-]\s*\d)", "운", result)
        else:
            result = replace_all(result, (("행운", "운"),), counts)

    return result


def normalize_catalog(catalog: dict) -> tuple[int, Counter[str]]:
    changed = 0
    counts: Counter[str] = Counter()
    for entry in catalog.get("entries", []):
        translation = entry.get("translation", "")
        if not isinstance(translation, str) or not translation:
            continue
        source_name = Path(str(entry.get("source_file", ""))).name
        source = str(entry.get("source", ""))
        corrected = normalize_translation(source_name, source, translation, counts)
        if corrected == translation:
            continue
        entry["translation"] = corrected
        note = str(entry.get("note", "")).strip()
        marker = "OpenYAMM source-semantic terminology normalization applied."
        if marker not in note:
            entry["note"] = f"{note} {marker}".strip()
        changed += 1
    return changed, counts


def validate_catalog(catalog: dict) -> None:
    errors: list[str] = []
    stale_checks = (
        ("Intellect", "지력"),
        ("Accuracy", "정확도"),
        ("Endurance", "인내력"),
        ("Speed", "민첩성"),
        ("Air", "대기 마법"),
        ("Air", "대기 저항"),
        ("Body", "신체 마법"),
        ("Body", "신체 저항"),
        ("Earth", "흙 마법"),
    )
    for entry in catalog.get("entries", []):
        translation = entry.get("translation", "")
        if not isinstance(translation, str):
            continue
        source = str(entry.get("source", ""))
        for english, stale in stale_checks:
            if source_has_word(source, english) and stale in translation:
                errors.append(f"{entry.get('key', '<unknown>')}: stale {stale!r} for {english}")
        if (source_has_word(source, "Resistance") or source_has_word(source, "Resistances")) and "저항력" in translation:
            errors.append(f"{entry.get('key', '<unknown>')}: stale '저항력' for Resistance")

    if errors:
        raise ValueError("Source-semantic Korean normalization failed:\n" + "\n".join(errors[:100]))


def catalog_item_fields(catalog: dict) -> dict[tuple[int, str], str]:
    fields: dict[tuple[int, str], str] = {}
    for entry in catalog.get("entries", []):
        if Path(str(entry.get("source_file", ""))).name != "items.txt":
            continue
        try:
            item_id = int(entry.get("record_id"))
        except (TypeError, ValueError):
            continue
        field = str(entry.get("field", ""))
        translation = entry.get("translation", "")
        if field in {"Name", "Notes"} and isinstance(translation, str):
            fields[(item_id, field)] = translation
    return fields


def sync_items_overlay(path: Path, fields: dict[tuple[int, str], str]) -> int:
    if not path.is_file():
        return 0
    text = path.read_text(encoding="utf-8-sig")
    rows = list(csv.reader(io.StringIO(text, newline=""), delimiter="\t", quotechar='"'))
    header_index = next((i for i, row in enumerate(rows) if row and row[0] == "Item #"), None)
    if header_index is None:
        raise ValueError("items.txt header row was not found")
    header = rows[header_index]
    name_column = header.index("Name")
    notes_column = header.index("Notes")
    changed = 0

    for row in rows[header_index + 1:]:
        if not row or not row[0].strip().isdigit():
            continue
        item_id = int(row[0].strip())
        while len(row) <= notes_column:
            row.append("")
        for field, column in (("Name", name_column), ("Notes", notes_column)):
            value = fields.get((item_id, field))
            if value is not None and row[column] != value:
                row[column] = value
                changed += 1

    output = io.StringIO(newline="")
    csv.writer(
        output,
        delimiter="\t",
        quotechar='"',
        quoting=csv.QUOTE_MINIMAL,
        lineterminator="\n",
    ).writerows(rows)
    path.write_text(output.getvalue(), encoding="utf-8", newline="")
    return changed


def normalize_mechanical_overlay(path: Path) -> int:
    replacements = MECHANICAL_OVERLAY_REPLACEMENTS.get(path.name)
    if not replacements or not path.is_file():
        return 0
    original = path.read_text(encoding="utf-8-sig")
    corrected = original
    changed = 0
    for old, new in replacements:
        count = corrected.count(old)
        if count:
            corrected = corrected.replace(old, new)
            changed += count
    if corrected != original:
        path.write_text(corrected, encoding="utf-8", newline="")
    return changed


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", default=None)
    parser.add_argument("--catalog", default="korean/translations/catalog.json")
    parser.add_argument("--engine-overlay-root", default="korean/overlay/engine")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    catalog_path = repo_root / args.catalog
    overlay_root = repo_root / args.engine_overlay_root / "data_tables"

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    changed_entries, counts = normalize_catalog(catalog)
    validate_catalog(catalog)
    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    synced_item_fields = sync_items_overlay(overlay_root / "items.txt", catalog_item_fields(catalog))
    mechanical_changes = 0
    for name in MECHANICAL_OVERLAY_REPLACEMENTS:
        candidate = overlay_root / name
        if not candidate.is_file():
            candidate = overlay_root / "english" / name
        mechanical_changes += normalize_mechanical_overlay(candidate)

    print(f"SOURCE_SEMANTIC_CHANGED_ENTRIES={changed_entries}")
    print(f"SOURCE_SEMANTIC_SYNCED_ITEM_FIELDS={synced_item_fields}")
    print(f"SOURCE_SEMANTIC_MECHANICAL_REPLACEMENTS={mechanical_changes}")
    print(f"SOURCE_SEMANTIC_TOTAL_CATALOG_REPLACEMENTS={sum(counts.values())}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
