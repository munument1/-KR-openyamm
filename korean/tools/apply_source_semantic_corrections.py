#!/usr/bin/env python3
"""Normalize Korean display terminology from the English catalog source.

This is a final post-generation pass. It is intentionally source-aware so
upstream MMMerge wording changes cannot silently reintroduce terminology drift
into OpenYAMM. Corrected catalog fields are synchronized back into the native
generated TSV/TXT overlays before packaging.
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

# Catalog field -> generated table header. Only display fields are synchronized;
# source/runtime logic keys are never changed.
SYNC_TABLES: dict[str, tuple[str, dict[str, str]]] = {
    "Global.txt": ("english/Global.txt", {"text": "Global Text"}),
    "autonote.txt": ("english/autonote.txt", {"text": "Autonote Text"}),
    "npc_topic_text.txt": ("npc_topic_text.txt", {"Text": "Text"}),
    "npc_topic.txt": ("npc_topic.txt", {"Topic": "Topic"}),
    "scroll.txt": ("english/scroll.txt", {"Text": "message text"}),
    "npc_news.txt": ("npc_news.txt", {"Text": "Text"}),
    "stats.txt": ("english/stats.txt", {"Description": "Description", "DisplayName": "LocalizedName"}),
    "skill_des.txt": (
        "english/skill_des.txt",
        {
            "Description": "Description",
            "Normal": "Normal",
            "Expert": "Expert",
            "Master": "Master",
            "GrandMaster": "GrandMaster",
            "DisplayName": "LocalizedName",
        },
    ),
    "items.txt": (
        "items.txt",
        {"Name": "Name", "NotIdentifiedName": "Not identified name", "Notes": "Notes"},
    ),
}

MECHANICAL_OVERLAY_REPLACEMENTS: dict[str, tuple[tuple[str, str], ...]] = {
    "standard_item_enchants.txt": (
        ("지력", "지능"), ("정확도", "적중률"), ("인내력", "체력"), ("민첩성", "속도"),
        ("대기", "공기"), ("신체", "육체"), ("저항력", "저항"),
    ),
    "special_item_enchants.txt": (
        ("지력", "지능"), ("정확도", "적중률"), ("인내력", "체력"), ("민첩성", "속도"),
        ("대기", "공기"), ("신체", "육체"), ("저항력", "저항"),
    ),
    "stats.txt": (
        ("대기 저항", "공기 저항"), ("대기 기반", "공기 기반"), ("대기 피해", "공기 피해"),
        ("신체 저항", "육체 저항"), ("신체 기반", "육체 기반"), ("신체 피해", "육체 피해"),
    ),
    "skill_des.txt": (("대기 마법", "공기 마법"), ("신체 마법", "육체 마법")),
    "spells.txt": (
        ("대기 마법", "공기 마법"), ("신체 마법", "육체 마법"), ("신체 저항", "육체 저항"),
        ("신체 피해", "육체 피해"), ("신체 보호", "육체 보호"), ("저항력", "저항"),
    ),
}


def source_has_word(source: str, word: str) -> bool:
    return re.search(r"\b" + re.escape(word) + r"\b", source, flags=re.IGNORECASE) is not None


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

    # Some special-enchant source descriptions abbreviate Endurance as End.
    if source_name == "special_item_enchants.txt" and source_has_word(source, "End"):
        result = replace_all(result, (("인내력", "체력"),), counts)

    if source_has_word(source, "Luck"):
        if source_name == "items.txt":
            # Preserve natural prose such as '행운을 빈다'; normalize only
            # explicit mechanical stat forms inside item descriptions.
            before = result
            result = re.sub(r"행운(?=\s*[+-]\s*\d)", "운", result)
            if result != before:
                counts["행운(stat) -> 운"] += 1
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
        ("Intellect", "지력"), ("Accuracy", "정확도"), ("Endurance", "인내력"), ("Speed", "민첩성"),
        ("Air", "대기 마법"), ("Air", "대기 저항"), ("Body", "신체 마법"), ("Body", "신체 저항"),
        ("Earth", "흙 마법"),
    )
    for entry in catalog.get("entries", []):
        translation = entry.get("translation", "")
        if not isinstance(translation, str):
            continue
        source_name = Path(str(entry.get("source_file", ""))).name
        source = str(entry.get("source", ""))
        for english, stale in stale_checks:
            if source_has_word(source, english) and stale in translation:
                errors.append(f"{entry.get('key', '<unknown>')}: stale {stale!r} for {english}")
        if source_name == "special_item_enchants.txt" and source_has_word(source, "End") and "인내력" in translation:
            errors.append(f"{entry.get('key', '<unknown>')}: stale '인내력' for abbreviated Endurance")
        if (source_has_word(source, "Resistance") or source_has_word(source, "Resistances")) and "저항력" in translation:
            errors.append(f"{entry.get('key', '<unknown>')}: stale '저항력' for Resistance")

    if errors:
        raise ValueError("Source-semantic Korean normalization failed:\n" + "\n".join(errors[:100]))


def catalog_fields_for_table(catalog: dict, source_name: str, allowed_fields: set[str]) -> dict[tuple[str, str], str]:
    fields: dict[tuple[str, str], str] = {}
    for entry in catalog.get("entries", []):
        if Path(str(entry.get("source_file", ""))).name != source_name:
            continue
        field = str(entry.get("field", ""))
        translation = entry.get("translation", "")
        if field not in allowed_fields or not isinstance(translation, str):
            continue
        fields[(str(entry.get("record_id")), field)] = translation
    return fields


def sync_tabular_overlay(
    path: Path,
    fields: dict[tuple[str, str], str],
    field_headers: dict[str, str],
) -> int:
    if not path.is_file() or not fields:
        return 0
    text = path.read_text(encoding="utf-8-sig")
    rows = list(csv.reader(io.StringIO(text, newline=""), delimiter="\t", quotechar='"'))

    header_index = None
    header_columns: dict[str, int] = {}
    for index, row in enumerate(rows):
        if not row:
            continue
        candidate = {field: (row.index(header) if header in row else -1) for field, header in field_headers.items()}
        if any(column >= 0 for column in candidate.values()):
            header_index = index
            header_columns = candidate
            break
    if header_index is None:
        raise ValueError(f"Could not locate header in {path}")

    changed = 0
    for row in rows[header_index + 1:]:
        if not row:
            continue
        record_id = row[0].strip()
        for field, column in header_columns.items():
            if column < 0:
                continue
            value = fields.get((record_id, field))
            if value is None:
                continue
            while len(row) <= column:
                row.append("")
            if row[column] != value:
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

    synced_fields = 0
    for source_name, (relative_path, field_headers) in SYNC_TABLES.items():
        fields = catalog_fields_for_table(catalog, source_name, set(field_headers))
        synced_fields += sync_tabular_overlay(overlay_root / relative_path, fields, field_headers)

    mechanical_changes = 0
    for name in MECHANICAL_OVERLAY_REPLACEMENTS:
        candidate = overlay_root / name
        if not candidate.is_file():
            candidate = overlay_root / "english" / name
        mechanical_changes += normalize_mechanical_overlay(candidate)

    # One reviewed map-runtime phrasing is a stat check despite the English
    # source using 'smart' rather than the canonical word Intellect.
    world_root = repo_root / "korean" / "overlay" / "worlds"
    map_phrase_changes = 0
    for path in world_root.rglob("*.lua") if world_root.exists() else ():
        original = path.read_text(encoding="utf-8-sig")
        corrected = original.replace("지력이 부족합니다!", "지능이 부족합니다!")
        if corrected != original:
            map_phrase_changes += original.count("지력이 부족합니다!")
            path.write_text(corrected, encoding="utf-8", newline="")

    print(f"SOURCE_SEMANTIC_CHANGED_ENTRIES={changed_entries}")
    print(f"SOURCE_SEMANTIC_SYNCED_TABLE_FIELDS={synced_fields}")
    print(f"SOURCE_SEMANTIC_MECHANICAL_REPLACEMENTS={mechanical_changes}")
    print(f"SOURCE_SEMANTIC_MAP_PHRASE_REPLACEMENTS={map_phrase_changes}")
    print(f"SOURCE_SEMANTIC_TOTAL_CATALOG_REPLACEMENTS={sum(counts.values())}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
