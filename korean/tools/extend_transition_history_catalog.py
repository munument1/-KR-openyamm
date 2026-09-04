#!/usr/bin/env python3
"""Import runtime-visible transition text and journal histories from MMMerge.

Handled here:
- KO_TransTxt.txt -> english/trans.txt Transition Description
  MMMerge IDs are logical non-empty row numbers, not OpenYAMM's sparse runtime IDs.
- MM7History_KO.txt -> english/mm7_history.txt Text + Page Title
- MM8History_KO.txt -> english/history.txt Text + Page Title

Transition Note and history Time columns are runtime metadata/control tokens and are
left untouched. The Korean history files are legacy TSVs with unquoted embedded
newlines, so they need record-block parsing rather than a normal csv.reader pass.
Legacy history placeholders such as %31/%33/%34 are validated in addition to
printf-style placeholders.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import io
import json
import re
from collections import Counter
from pathlib import Path

PRINTF_TOKEN_RE = re.compile(
    r"%(?:\d+\$)?\d*(?:\.\d+)?(?:hh|h|ll|l|j|z|t|L)?[diuoxXfFeEgGaAcsn]"
)
LEGACY_HISTORY_TOKEN_RE = re.compile(r"%\d+(?![A-Za-z$])")
HISTORY_RECORD_START_RE = re.compile(r"^(\d+)\t")


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


def parse_legacy_history(path: Path) -> tuple[dict[int, list[str]], str]:
    """Parse MMMerge history TSVs whose multiline text cells are not quoted."""
    text, encoding = decode_text(path, ("utf-8-sig", "cp949"))
    blocks: list[str] = []
    current: list[str] = []

    for line in text.splitlines():
        if HISTORY_RECORD_START_RE.match(line):
            if current:
                blocks.append("\n".join(current))
            current = [line]
        elif current:
            current.append(line)

    if current:
        blocks.append("\n".join(current))

    result: dict[int, list[str]] = {}
    for block in blocks:
        parts = block.split("\t")
        if len(parts) < 4 or not parts[0].strip().isdigit():
            continue
        record_id = int(parts[0].strip())
        # The final two tab-separated fields are Time and Page Title. Any tabs
        # before them are considered part of the legacy multiline text cell.
        result[record_id] = [parts[0], "\t".join(parts[1:-2]), parts[-2], parts[-1]]

    return result, encoding


def rows_by_id(rows: list[list[str]]) -> dict[int, tuple[int, list[str]]]:
    result: dict[int, tuple[int, list[str]]] = {}
    for row_index, row in enumerate(rows):
        if row and row[0].strip().isdigit():
            result[int(row[0].strip())] = (row_index, row)
    return result


def numeric_rows_in_order(rows: list[list[str]]) -> list[tuple[int, int, list[str]]]:
    result: list[tuple[int, int, list[str]]] = []
    for row_index, row in enumerate(rows):
        if row and row[0].strip().isdigit():
            result.append((int(row[0].strip()), row_index, row))
    return result


def tokens(text: str, include_legacy_history: bool = False) -> Counter[str]:
    result = Counter(PRINTF_TOKEN_RE.findall(text))
    if include_legacy_history:
        result.update(LEGACY_HISTORY_TOKEN_RE.findall(text))
    return result


def make_entry(
    source_relpath: str,
    record_id: int,
    field_name: str,
    source_text: str,
    translation: str,
    note: str,
    include_legacy_history: bool = False,
) -> dict:
    placeholder_ok = not translation or tokens(source_text, include_legacy_history) == tokens(
        translation, include_legacy_history
    )
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


def stats(
    repo_root: Path,
    source_relpath: str,
    source_path: Path,
    source_encoding: str,
    translation_path: Path,
    translation_encoding: str,
    entries: list[dict],
    output_path: Path,
    mapping: str,
    excluded: int = 0,
) -> dict:
    return {
        "overlay_source": translation_path.as_posix(),
        "overlay_format": mapping,
        "source_file": source_relpath,
        "source_sha256": sha256_file(source_path),
        "source_encoding": source_encoding,
        "mmmerge_sha256": sha256_file(translation_path),
        "mmmerge_encoding": translation_encoding,
        "entries": len(entries),
        "translated": sum(1 for entry in entries if entry["status"] == "translated"),
        "untranslated": sum(1 for entry in entries if entry["status"] == "untranslated"),
        "placeholder_mismatches": sum(1 for entry in entries if entry["status"] == "needs_review"),
        "overrides": 0,
        "excluded": excluded,
        "output_file": output_path.relative_to(repo_root).as_posix(),
        "output_encoding": "utf-8",
    }


def import_transitions(repo_root: Path, mmmerge_root: Path, overlay_root: Path) -> tuple[list[dict], dict]:
    source_relpath = "assets_dev/engine/data_tables/english/trans.txt"
    source_path = repo_root / source_relpath
    translation_path = mmmerge_root / "Data" / "Text localization" / "KO_TransTxt.txt"
    source_rows, source_encoding = read_tsv(source_path, ("utf-8-sig", "cp1252"))
    translations, translation_encoding = parse_field_overlay(translation_path)
    output_rows = [list(row) for row in source_rows]

    numeric_rows = numeric_rows_in_order(source_rows)
    entries: list[dict] = []
    for logical_id, (record_id, row_index, row) in enumerate(numeric_rows, start=1):
        if len(row) < 2 or not row[1]:
            continue
        translation = translations.get(logical_id, "")
        entry = make_entry(
            source_relpath,
            record_id,
            "Description",
            row[1],
            translation,
            f"MMMerge KO_TransTxt logical row {logical_id}; OpenYAMM runtime ID {record_id}. Note metadata preserved.",
        )
        if entry["status"] == "translated":
            output_rows[row_index][1] = translation
        entries.append(entry)

    output_path = overlay_root / Path(source_relpath).relative_to("assets_dev/engine")
    write_tsv(output_path, output_rows)
    table = stats(
        repo_root,
        source_relpath,
        source_path,
        source_encoding,
        translation_path,
        translation_encoding,
        entries,
        output_path,
        "KO_TransTxt logical non-empty row order -> sparse trans.txt runtime IDs, Description only",
    )
    table["logical_source_rows"] = len(numeric_rows)
    table["translation_rows"] = len(translations)
    table["unused_translation_ids"] = sorted(set(translations) - set(range(1, len(numeric_rows) + 1)))
    return entries, table


def import_history(
    repo_root: Path,
    mmmerge_root: Path,
    overlay_root: Path,
    source_name: str,
    translation_name: str,
) -> tuple[list[dict], dict]:
    source_relpath = f"assets_dev/engine/data_tables/english/{source_name}"
    source_path = repo_root / source_relpath
    translation_path = mmmerge_root / "Data" / "Text localization" / translation_name
    source_rows, source_encoding = read_tsv(source_path, ("utf-8-sig", "cp1252"))
    translations, translation_encoding = parse_legacy_history(translation_path)
    output_rows = [list(row) for row in source_rows]

    entries: list[dict] = []
    source_records = rows_by_id(source_rows)
    for record_id, (row_index, row) in source_records.items():
        translated_row = translations.get(record_id, [])
        for field_name, column in (("Text", 1), ("PageTitle", 3)):
            if column >= len(row) or not row[column]:
                continue
            translation = translated_row[column] if column < len(translated_row) else ""
            entry = make_entry(
                source_relpath,
                record_id,
                field_name,
                row[column],
                translation,
                f"{translation_name} direct history ID mapping; Time token preserved.",
                include_legacy_history=True,
            )
            if entry["status"] == "translated":
                while len(output_rows[row_index]) <= column:
                    output_rows[row_index].append("")
                output_rows[row_index][column] = translation
            entries.append(entry)

    output_path = overlay_root / Path(source_relpath).relative_to("assets_dev/engine")
    write_tsv(output_path, output_rows)
    table = stats(
        repo_root,
        source_relpath,
        source_path,
        source_encoding,
        translation_path,
        translation_encoding,
        entries,
        output_path,
        f"{translation_name} legacy multiline records -> {source_name} IDs, Text and Page Title only",
    )
    table["source_history_rows"] = len(source_records)
    table["translation_history_rows"] = len(translations)
    table["missing_translation_ids"] = sorted(set(source_records) - set(translations))
    table["unused_translation_ids"] = sorted(set(translations) - set(source_records))
    return entries, table


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
    importers = (
        lambda: import_transitions(repo_root, mmmerge_root, overlay_root),
        lambda: import_history(repo_root, mmmerge_root, overlay_root, "mm7_history.txt", "MM7History_KO.txt"),
        lambda: import_history(repo_root, mmmerge_root, overlay_root, "history.txt", "MM8History_KO.txt"),
    )
    for importer in importers:
        entries, table = importer()
        new_entries.extend(entries)
        new_tables.append(table)

    duplicate_keys = sorted(existing_keys.intersection(entry["key"] for entry in new_entries))
    if duplicate_keys:
        raise ValueError(f"Duplicate catalog keys: {duplicate_keys[:20]}")

    catalog["entries"].extend(new_entries)
    catalog["tables"].extend(new_tables)
    catalog["format"] = max(int(catalog.get("format", 1)), 9)
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
        for diagnostic in (
            "logical_source_rows",
            "translation_rows",
            "source_history_rows",
            "translation_history_rows",
            "missing_translation_ids",
            "unused_translation_ids",
        ):
            if diagnostic in table:
                print(f"  {diagnostic}={table[diagnostic]}")

    if args.fail_on_review and (
        catalog["summary"]["untranslated"] or catalog["summary"]["needs_review"]
    ):
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
