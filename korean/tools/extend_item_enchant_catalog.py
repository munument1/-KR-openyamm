#!/usr/bin/env python3
"""Import Korean standard/special item enchant display strings safely.

OpenYAMM historically uses the same English cells both as gameplay parse keys and
as UI display text. The Korean branch keeps those stable English logic cells and
writes localized display overrides into optional trailing columns consumed by
ItemEnchantTables.cpp:

  column 20: localized stat/description text
  column 21: localized item-name suffix/prefix

This preserves enchant kind parsing while localizing names and inspect text.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import io
import json
from collections import Counter
from pathlib import Path
import re

PRINTF_TOKEN_RE = re.compile(
    r"%(?:\d+\$)?\d*(?:\.\d+)?(?:hh|h|ll|l|j|z|t|L)?[diuoxXfFeEgGaAcsn]"
)
DISPLAY_TEXT_COLUMN = 20
DISPLAY_SUFFIX_COLUMN = 21


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def decode_text(path: Path, encodings: tuple[str, ...]) -> tuple[str, str]:
    raw = path.read_bytes()
    last_error: UnicodeDecodeError | None = None
    for encoding in encodings:
        try:
            return raw.decode(encoding), encoding
        except UnicodeDecodeError as error:
            last_error = error
    if last_error is not None:
        raise last_error
    raise ValueError(f"No encodings configured for {path}")


def read_tsv(path: Path, encodings: tuple[str, ...]) -> tuple[list[list[str]], str]:
    text, encoding = decode_text(path, encodings)
    return list(csv.reader(io.StringIO(text, newline=""), delimiter="\t", quotechar='"')), encoding


def write_tsv(path: Path, rows: list[list[str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as stream:
        writer = csv.writer(
            stream,
            delimiter="\t",
            quotechar='"',
            quoting=csv.QUOTE_MINIMAL,
            lineterminator="\n",
        )
        writer.writerows(rows)


def parse_field_overlay(path: Path) -> tuple[dict[int, str], str]:
    rows, encoding = read_tsv(path, ("utf-8-sig", "cp949"))
    result: dict[int, str] = {}
    for row in rows[1:]:
        if len(row) >= 4 and row[1].strip().isdigit():
            result[int(row[1].strip())] = row[3]
    return result, encoding


def printf_tokens(text: str) -> Counter[str]:
    return Counter(PRINTF_TOKEN_RE.findall(text))


def ensure_column(row: list[str], column: int) -> None:
    while len(row) <= column:
        row.append("")


def make_entry(
    source_relpath: str,
    record_id: int,
    field_name: str,
    source_text: str,
    translation: str,
    note: str,
) -> dict:
    placeholder_ok = not translation or printf_tokens(source_text) == printf_tokens(translation)
    status = "translated" if translation and placeholder_ok else (
        "needs_review" if translation else "untranslated"
    )
    return {
        "key": f"engine:{Path(source_relpath).name}:{record_id}:{field_name}",
        "scope": "engine",
        "source_file": source_relpath,
        "record_id": record_id,
        "field": field_name,
        "source": source_text,
        "translation": translation,
        "translation_origin": "mmmerge" if translation else "none",
        "status": status,
        "placeholder_ok": placeholder_ok,
        "note": note,
    }


def source_enchant_rows(rows: list[list[str]], count: int) -> list[tuple[int, list[str]]]:
    """Return the first runtime enchant rows, excluding headings/trailing tuning notes."""
    result: list[tuple[int, list[str]]] = []
    for row_index, row in enumerate(rows):
        first = row[0].strip() if row else ""
        second = row[1].strip() if len(row) > 1 else ""
        if not first or not second or first == "Bonus Stat":
            continue
        result.append((row_index, row))
        if len(result) == count:
            break
    if len(result) != count:
        raise ValueError(f"Expected {count} enchant rows, found {len(result)}")
    return result


def table_stats(
    repo_root: Path,
    source_relpath: str,
    source_path: Path,
    source_encoding: str,
    translation_paths: list[Path],
    translation_encodings: list[str],
    entries: list[dict],
    output_path: Path,
    mapping: str,
) -> dict:
    return {
        "overlay_source": [path.as_posix() for path in translation_paths],
        "overlay_format": mapping,
        "source_file": source_relpath,
        "source_sha256": sha256_file(source_path),
        "source_encoding": source_encoding,
        "mmmerge_sha256": [sha256_file(path) for path in translation_paths],
        "mmmerge_encoding": translation_encodings,
        "entries": len(entries),
        "translated": sum(1 for entry in entries if entry["status"] == "translated"),
        "untranslated": sum(1 for entry in entries if entry["status"] == "untranslated"),
        "placeholder_mismatches": sum(1 for entry in entries if entry["status"] == "needs_review"),
        "overrides": 0,
        "excluded": 0,
        "output_file": output_path.relative_to(repo_root).as_posix(),
        "output_encoding": "utf-8",
    }


def import_standard(repo_root: Path, mmmerge_root: Path, overlay_root: Path) -> tuple[list[dict], dict]:
    source_relpath = "assets_dev/engine/data_tables/standard_item_enchants.txt"
    source_path = repo_root / source_relpath
    names_path = mmmerge_root / "Data" / "Text localization" / "KO_StdItemsTxtNames.txt"
    stats_path = mmmerge_root / "Data" / "Text localization" / "KO_StdItemsTxtStats.txt"
    rows, source_encoding = read_tsv(source_path, ("utf-8-sig", "cp1252"))
    names, names_encoding = parse_field_overlay(names_path)
    stats_text, stats_encoding = parse_field_overlay(stats_path)
    if sorted(names) != list(range(25)) or sorted(stats_text) != list(range(25)):
        raise ValueError("Standard enchant Korean source must contain IDs 0..24")

    output_rows = [list(row) for row in rows]
    data_rows = source_enchant_rows(rows, 25)
    entries: list[dict] = []
    for legacy_id, (row_index, row) in enumerate(data_rows):
        runtime_id = legacy_id + 1
        source_stat = row[0]
        source_suffix = row[1]
        stat_translation = stats_text.get(legacy_id, "")
        suffix_translation = names.get(legacy_id, "")
        stat_entry = make_entry(
            source_relpath,
            runtime_id,
            "DisplayStat",
            source_stat,
            stat_translation,
            f"MMMerge StdItemsTxt ID {legacy_id}; stable English stat key remains in column 0.",
        )
        suffix_entry = make_entry(
            source_relpath,
            runtime_id,
            "DisplaySuffix",
            source_suffix,
            suffix_translation,
            f"MMMerge StdItemsTxt ID {legacy_id}; localized name modifier is stored separately from logic data.",
        )
        if stat_entry["status"] == "translated":
            ensure_column(output_rows[row_index], DISPLAY_TEXT_COLUMN)
            output_rows[row_index][DISPLAY_TEXT_COLUMN] = stat_translation
        if suffix_entry["status"] == "translated":
            ensure_column(output_rows[row_index], DISPLAY_SUFFIX_COLUMN)
            output_rows[row_index][DISPLAY_SUFFIX_COLUMN] = suffix_translation
        entries.extend((stat_entry, suffix_entry))

    for row in output_rows:
        if row and row[0].strip() == "Bonus Stat":
            ensure_column(row, DISPLAY_SUFFIX_COLUMN)
            row[DISPLAY_TEXT_COLUMN] = "Localized Display Stat"
            row[DISPLAY_SUFFIX_COLUMN] = "Localized Display Suffix"
            break

    output_path = overlay_root / Path(source_relpath).relative_to("assets_dev/engine")
    write_tsv(output_path, output_rows)
    return entries, table_stats(
        repo_root,
        source_relpath,
        source_path,
        source_encoding,
        [stats_path, names_path],
        [stats_encoding, names_encoding],
        entries,
        output_path,
        "StdItemsTxt IDs 0..24 -> runtime enchant IDs 1..25; localized display columns 20/21",
    )


def import_special(repo_root: Path, mmmerge_root: Path, overlay_root: Path) -> tuple[list[dict], dict]:
    source_relpath = "assets_dev/engine/data_tables/special_item_enchants.txt"
    source_path = repo_root / source_relpath
    names_path = mmmerge_root / "Data" / "Text localization" / "KO_SpcItemsTxtNames.txt"
    stats_path = mmmerge_root / "Data" / "Text localization" / "KO_SpcItemsTxtStats.txt"
    rows, source_encoding = read_tsv(source_path, ("utf-8-sig", "cp1252"))
    names, names_encoding = parse_field_overlay(names_path)
    stats_text, stats_encoding = parse_field_overlay(stats_path)
    if sorted(names) != list(range(73)) or sorted(stats_text) != list(range(73)):
        raise ValueError("Special enchant Korean source must contain IDs 0..72")

    output_rows = [list(row) for row in rows]
    data_rows = source_enchant_rows(rows, 73)
    entries: list[dict] = []
    for legacy_id, (row_index, row) in enumerate(data_rows):
        runtime_id = legacy_id + 1
        source_suffix = row[1]
        source_description = row[16] if len(row) > 16 and row[16] else row[0]
        description_translation = stats_text.get(legacy_id, "")
        suffix_translation = names.get(legacy_id, "")
        description_entry = make_entry(
            source_relpath,
            runtime_id,
            "DisplayDescription",
            source_description,
            description_translation,
            f"MMMerge SpcItemsTxt ID {legacy_id}; English suffix logic key and tuning columns remain unchanged.",
        )
        suffix_entry = make_entry(
            source_relpath,
            runtime_id,
            "DisplaySuffix",
            source_suffix,
            suffix_translation,
            f"MMMerge SpcItemsTxt ID {legacy_id}; prefix/suffix grammar is derived from the stable English key.",
        )
        if description_entry["status"] == "translated":
            ensure_column(output_rows[row_index], DISPLAY_TEXT_COLUMN)
            output_rows[row_index][DISPLAY_TEXT_COLUMN] = description_translation
        if suffix_entry["status"] == "translated":
            ensure_column(output_rows[row_index], DISPLAY_SUFFIX_COLUMN)
            output_rows[row_index][DISPLAY_SUFFIX_COLUMN] = suffix_translation
        entries.extend((description_entry, suffix_entry))

    for row in output_rows:
        if row and row[0].strip() == "Bonus Stat":
            ensure_column(row, DISPLAY_SUFFIX_COLUMN)
            row[DISPLAY_TEXT_COLUMN] = "Localized Display Description"
            row[DISPLAY_SUFFIX_COLUMN] = "Localized Display Suffix"
            break

    output_path = overlay_root / Path(source_relpath).relative_to("assets_dev/engine")
    write_tsv(output_path, output_rows)
    return entries, table_stats(
        repo_root,
        source_relpath,
        source_path,
        source_encoding,
        [stats_path, names_path],
        [stats_encoding, names_encoding],
        entries,
        output_path,
        "SpcItemsTxt IDs 0..72 -> runtime enchant IDs 1..73; localized display columns 20/21",
    )


def refresh_summary(catalog: dict) -> None:
    entries = catalog["entries"]
    catalog["summary"] = {
        "entries": len(entries),
        "translated": sum(1 for entry in entries if entry["status"] == "translated"),
        "untranslated": sum(1 for entry in entries if entry["status"] == "untranslated"),
        "needs_review": sum(1 for entry in entries if entry["status"] == "needs_review"),
        "overrides": sum(1 for entry in entries if entry.get("translation_origin") == "override"),
        "excluded": sum(int(table.get("excluded", 0)) for table in catalog["tables"]),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", default=None)
    parser.add_argument("--mmmerge-root", required=True)
    parser.add_argument("--catalog", default="korean/translations/catalog.json")
    parser.add_argument("--overlay-engine-root", default="korean/overlay/engine")
    parser.add_argument("--fail-on-review", action="store_true")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    mmmerge_root = Path(args.mmmerge_root).resolve()
    catalog_path = repo_root / args.catalog
    overlay_root = repo_root / args.overlay_engine_root
    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    existing_keys = {entry["key"] for entry in catalog["entries"]}

    new_entries: list[dict] = []
    new_tables: list[dict] = []
    for importer in (import_standard, import_special):
        entries, table = importer(repo_root, mmmerge_root, overlay_root)
        new_entries.extend(entries)
        new_tables.append(table)

    duplicate_keys = sorted(existing_keys.intersection(entry["key"] for entry in new_entries))
    if duplicate_keys:
        raise ValueError(f"Duplicate catalog keys: {duplicate_keys[:20]}")

    catalog["entries"].extend(new_entries)
    catalog["tables"].extend(new_tables)
    catalog["format"] = max(int(catalog.get("format", 1)), 10)
    refresh_summary(catalog)
    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(json.dumps(catalog["summary"], ensure_ascii=False))
    for table in new_tables:
        print(
            f"{Path(table['source_file']).name}: "
            f"{table['translated']}/{table['entries']} translated, "
            f"{table['untranslated']} untranslated, "
            f"{table['placeholder_mismatches']} placeholder mismatch(es)"
        )

    if args.fail_on_review and (
        catalog["summary"]["untranslated"] or catalog["summary"]["needs_review"]
    ):
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
