#!/usr/bin/env python3
"""Normalize Korean display terminology from the English catalog source.

This is a final post-generation pass. It is intentionally source-aware so
upstream MMMerge wording changes cannot silently reintroduce terminology drift
into OpenYAMM. Corrected catalog fields are synchronized back into the native
generated TSV/TXT and map Lua overlays before packaging.
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

# Replacing a Korean noun can change whether the following particle needs a
# final-consonant form. Keep these repairs explicit so terminology cleanup does
# not generate text such as "적중률를" or "속도과".
PARTICLE_REPAIRS: tuple[tuple[str, str], ...] = (
    ("적중률를", "적중률을"),
    ("적중률가", "적중률이"),
    ("적중률는", "적중률은"),
    ("적중률와", "적중률과"),
    ("속도을", "속도를"),
    ("속도이", "속도가"),
    ("속도은", "속도는"),
    ("속도과", "속도와"),
    ("대지을", "대지를"),
    ("대지이", "대지가"),
    ("대지은", "대지는"),
    ("대지과", "대지와"),
)

# Catalog field -> generated table selector. A selector can be a header name or
# an explicit zero-based column index for legacy tables whose header is shifted
# relative to their data rows (notably Global.txt).
SYNC_TABLES: dict[str, tuple[str, dict[str, str | int]]] = {
    "Global.txt": ("english/Global.txt", {"text": 1}),
    "quests.txt": ("english/quests.txt", {"text": "Quest Note Text"}),
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

TARGET_MAP_RE = re.compile(r"\bTarget\s+([^/;]+)/([^;]+\.lua)\b", flags=re.IGNORECASE)
LITERAL_COUNT_RE = re.compile(r"literal occurs\s+(\d+)\s+time\(s\)", flags=re.IGNORECASE)


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


def repair_korean_particles(text: str, counts: Counter[str] | None = None) -> str:
    result = text
    for old, new in PARTICLE_REPAIRS:
        count = result.count(old)
        if not count:
            continue
        result = result.replace(old, new)
        if counts is not None:
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
        elif source_name in {
            "standard_item_enchants.txt",
            "special_item_enchants.txt",
            "stats.txt",
            "skill_des.txt",
            "spells.txt",
        }:
            result = replace_all(result, (("행운", "운"),), counts)

    if source.strip().casefold() == "you are not smart enough!" and result == "지력이 부족합니다!":
        result = "지능이 부족합니다!"
        counts["지력이 부족합니다! -> 지능이 부족합니다!"] += 1

    return repair_korean_particles(result, counts)


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
        for malformed, _ in PARTICLE_REPAIRS:
            if malformed in translation:
                errors.append(f"{entry.get('key', '<unknown>')}: malformed particle sequence {malformed!r}")

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
    field_selectors: dict[str, str | int],
) -> int:
    if not path.is_file() or not fields:
        return 0
    text = path.read_text(encoding="utf-8-sig")
    rows = list(csv.reader(io.StringIO(text, newline=""), delimiter="\t", quotechar='"'))

    explicit_columns = {
        field: selector for field, selector in field_selectors.items() if isinstance(selector, int)
    }
    named_selectors = {
        field: selector for field, selector in field_selectors.items() if isinstance(selector, str)
    }

    header_index = 0
    header_columns: dict[str, int] = dict(explicit_columns)
    if named_selectors:
        found_header = False
        for index, row in enumerate(rows):
            if not row:
                continue
            candidate = {
                field: (row.index(header) if header in row else -1)
                for field, header in named_selectors.items()
            }
            if any(column >= 0 for column in candidate.values()):
                header_index = index
                header_columns.update(candidate)
                found_header = True
                break
        if not found_header:
            raise ValueError(f"Could not locate header in {path}")

    # For explicit-column legacy tables we still skip their first header row.
    if not named_selectors:
        header_index = 0

    changed = 0
    for row in rows[header_index + 1:]:
        if not row:
            continue
        record_id = row[0].strip()
        # Never rewrite the record-id column. A malformed selector must fail
        # rather than silently turning IDs into localized strings.
        for field, column in header_columns.items():
            if column <= 0:
                raise ValueError(f"Unsafe display column {column} for {field} in {path}")
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
    corrected = repair_korean_particles(corrected)
    if corrected != original:
        path.write_text(corrected, encoding="utf-8", newline="")
    return changed


def _read_utf8_preserving_bom(path: Path) -> tuple[str, bool]:
    raw = path.read_bytes()
    return raw.decode("utf-8-sig"), raw.startswith(b"\xef\xbb\xbf")


def _write_utf8_preserving_bom(path: Path, text: str, had_bom: bool) -> None:
    path.write_text(text, encoding="utf-8-sig" if had_bom else "utf-8", newline="")


def sync_world_map_overlays(
    world_root: Path,
    catalog: dict,
    previous_translations: dict[str, str],
) -> int:
    """Push corrected catalog literals back into generated map Lua files.

    Map catalog rows carry notes like ``Target mm6/oute2.lua`` and the expected
    number of literal occurrences. The map builder runs before this final pass,
    so without this synchronization the catalog can be correct while packaged
    Lua still contains the old terminology.
    """
    changed = 0
    cached: dict[Path, tuple[str, bool]] = {}

    for entry in catalog.get("entries", []):
        key = str(entry.get("key", ""))
        old = previous_translations.get(key)
        new = entry.get("translation")
        source_file = str(entry.get("source_file", ""))
        if not isinstance(old, str) or not isinstance(new, str) or old == new:
            continue
        if "/worlds/" not in source_file.replace("\\", "/"):
            continue

        note = str(entry.get("note", ""))
        target_match = TARGET_MAP_RE.search(note)
        if target_match is None:
            raise ValueError(f"Changed world catalog entry has no Target Lua note: {key}")
        world = target_match.group(1)
        lua_name = target_match.group(2)
        path = world_root / world / "events" / "maps" / lua_name
        if not path.is_file():
            raise ValueError(f"Target map Lua does not exist for {key}: {path}")

        if path not in cached:
            cached[path] = _read_utf8_preserving_bom(path)
        text, had_bom = cached[path]

        expected_match = LITERAL_COUNT_RE.search(note)
        expected = int(expected_match.group(1)) if expected_match else None
        quoted_old = f'"{old}"'
        quoted_new = f'"{new}"'
        quoted_count = text.count(quoted_old)
        plain_count = text.count(old)

        if quoted_count and (expected is None or quoted_count == expected):
            text = text.replace(quoted_old, quoted_new)
            changed += quoted_count
        elif plain_count and (expected is None or plain_count == expected):
            text = text.replace(old, new)
            changed += plain_count
        else:
            already_count = text.count(quoted_new) or text.count(new)
            if expected is not None and already_count == expected:
                cached[path] = (text, had_bom)
                continue
            raise ValueError(
                f"Could not safely synchronize {key} into {path}: "
                f"expected={expected}, quoted_old={quoted_count}, plain_old={plain_count}, already_new={already_count}"
            )

        cached[path] = (text, had_bom)

    for path, (text, had_bom) in cached.items():
        _write_utf8_preserving_bom(path, text, had_bom)
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
    previous_translations = {
        str(entry.get("key", "")): entry.get("translation", "")
        for entry in catalog.get("entries", [])
        if isinstance(entry.get("translation"), str)
    }
    changed_entries, counts = normalize_catalog(catalog)
    validate_catalog(catalog)
    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    synced_fields = 0
    for source_name, (relative_path, field_selectors) in SYNC_TABLES.items():
        fields = catalog_fields_for_table(catalog, source_name, set(field_selectors))
        synced_fields += sync_tabular_overlay(overlay_root / relative_path, fields, field_selectors)

    mechanical_changes = 0
    for name in MECHANICAL_OVERLAY_REPLACEMENTS:
        candidate = overlay_root / name
        if not candidate.is_file():
            candidate = overlay_root / "english" / name
        mechanical_changes += normalize_mechanical_overlay(candidate)

    world_root = repo_root / "korean" / "overlay" / "worlds"
    map_catalog_sync_changes = sync_world_map_overlays(world_root, catalog, previous_translations)

    # One reviewed map-runtime phrasing is a stat check despite the English
    # source using 'smart' rather than the canonical word Intellect.
    map_phrase_changes = 0
    for path in world_root.rglob("*.lua") if world_root.exists() else ():
        original, had_bom = _read_utf8_preserving_bom(path)
        corrected = original.replace("지력이 부족합니다!", "지능이 부족합니다!")
        if corrected != original:
            map_phrase_changes += original.count("지력이 부족합니다!")
            _write_utf8_preserving_bom(path, corrected, had_bom)

    print(f"SOURCE_SEMANTIC_CHANGED_ENTRIES={changed_entries}")
    print(f"SOURCE_SEMANTIC_SYNCED_TABLE_FIELDS={synced_fields}")
    print(f"SOURCE_SEMANTIC_MECHANICAL_REPLACEMENTS={mechanical_changes}")
    print(f"SOURCE_SEMANTIC_MAP_CATALOG_SYNC_REPLACEMENTS={map_catalog_sync_changes}")
    print(f"SOURCE_SEMANTIC_MAP_PHRASE_REPLACEMENTS={map_phrase_changes}")
    print(f"SOURCE_SEMANTIC_TOTAL_CATALOG_REPLACEMENTS={sum(counts.values())}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
