#!/usr/bin/env python3
"""Import legacy tables whose IDs do not map 1:1 to OpenYAMM rows.

Handled here:
- scroll.txt merges the MM8, MM7 and MM6 MessageScrolls arrays into three
  disjoint OpenYAMM item-ID ranges. The Korean source keeps those arrays
  concatenated as logical IDs 0..210.
- class.txt has no numeric ID column; ClassNames and ClassDescriptions use the
  zero-based logical row order.
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

# OpenYAMM keeps scrolls in the global item namespace. MMMerge's MessageScrolls
# localization instead concatenates the three game-local scroll arrays:
#   MM8: OpenYAMM 700..781  -> MessageScrolls 0..81
#   MM7: OpenYAMM 1502..1583 -> MessageScrolls 82..163
#   MM6: OpenYAMM 2120..2166 -> MessageScrolls 164..210
SCROLL_ID_RANGES = (
    (700, 781, 700),
    (1502, 1583, 1420),
    (2120, 2166, 1956),
)


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


def parse_overlay(path: Path) -> tuple[dict[tuple[int, str], str], str]:
    rows, encoding = read_tsv(path, ("utf-8-sig", "cp949"))
    result: dict[tuple[int, str], str] = {}
    for row in rows[1:]:
        if len(row) >= 4 and row[1].strip().isdigit():
            result[(int(row[1].strip()), row[2].strip())] = row[3]
    return result, encoding


def printf_tokens(text: str) -> Counter[str]:
    return Counter(PRINTF_TOKEN_RE.findall(text))


def make_entry(
    source_relpath: str,
    record_id: int,
    field_name: str,
    source_text: str,
    translation: str,
    note: str = "",
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


def stats_for(
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
        "overlay_source": [
            path.relative_to(path.parents[2]).as_posix()
            if len(path.parents) > 2 else path.as_posix()
            for path in translation_paths
        ],
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


def scroll_translation_id(source_id: int) -> int | None:
    for first_id, last_id, offset in SCROLL_ID_RANGES:
        if first_id <= source_id <= last_id:
            return source_id - offset
    return None


def import_scrolls(
    repo_root: Path,
    mmmerge_root: Path,
    overlay_root: Path,
) -> tuple[list[dict], dict]:
    source_relpath = "assets_dev/engine/data_tables/english/scroll.txt"
    source_path = repo_root / source_relpath
    translation_path = mmmerge_root / "Data" / "Text localization" / "KO_MessageScrolls.txt"
    rows, source_encoding = read_tsv(source_path, ("utf-8-sig", "cp1252"))
    output_rows = [list(row) for row in rows]
    translations, translation_encoding = parse_overlay(translation_path)

    entries: list[dict] = []
    unmapped_source_ids: list[int] = []
    for row_index, row in enumerate(rows[1:], start=1):
        if len(row) < 2 or not row[0].strip().isdigit() or not row[1]:
            continue
        source_id = int(row[0].strip())
        translation_id = scroll_translation_id(source_id)
        if translation_id is None:
            unmapped_source_ids.append(source_id)
            translation = ""
            note = "Source ID is outside the three known MM6-MM8 scroll ranges."
        else:
            translation = translations.get((translation_id, ""), "")
            note = f"MMMerge MessageScrolls logical ID {translation_id}."

        entry = make_entry(source_relpath, source_id, "Text", row[1], translation, note)
        if entry["status"] == "translated":
            output_rows[row_index][1] = translation
        entries.append(entry)

    output_path = overlay_root / Path(source_relpath).relative_to("assets_dev/engine")
    write_tsv(output_path, output_rows)
    stats = stats_for(
        repo_root,
        source_relpath,
        source_path,
        source_encoding,
        [translation_path],
        [translation_encoding],
        entries,
        output_path,
        "three merged game ranges -> concatenated MessageScrolls logical IDs",
    )
    stats["translation_id_ranges"] = [
        {
            "source_first": first_id,
            "source_last": last_id,
            "subtract": offset,
            "translation_first": first_id - offset,
            "translation_last": last_id - offset,
        }
        for first_id, last_id, offset in SCROLL_ID_RANGES
    ]
    stats["unmapped_source_ids"] = unmapped_source_ids
    return entries, stats


def import_classes(
    repo_root: Path,
    mmmerge_root: Path,
    overlay_root: Path,
) -> tuple[list[dict], dict]:
    source_relpath = "assets_dev/engine/data_tables/english/class.txt"
    source_path = repo_root / source_relpath
    names_path = mmmerge_root / "Data" / "Text localization" / "KO_ClassNames.txt"
    descriptions_path = mmmerge_root / "Data" / "Text localization" / "KO_ClassDescriptions.txt"
    rows, source_encoding = read_tsv(source_path, ("utf-8-sig", "cp1252"))
    output_rows = [list(row) for row in rows]
    names, names_encoding = parse_overlay(names_path)
    descriptions, descriptions_encoding = parse_overlay(descriptions_path)

    entries: list[dict] = []
    logical_id = 0
    for row_index, row in enumerate(rows[1:], start=1):
        if not row or not any(cell for cell in row):
            continue
        if len(row) < 2:
            raise ValueError(f"Malformed class row {row_index + 1}: {row}")

        for field_name, target_column, translations in (
            ("Name", 0, names),
            ("Description", 1, descriptions),
        ):
            source_text = row[target_column]
            if not source_text:
                continue
            translation = translations.get((logical_id, ""), "")
            entry = make_entry(
                source_relpath,
                logical_id,
                field_name,
                source_text,
                translation,
                f"MMMerge class logical row {logical_id}.",
            )
            if entry["status"] == "translated":
                output_rows[row_index][target_column] = translation
            entries.append(entry)
        logical_id += 1

    output_path = overlay_root / Path(source_relpath).relative_to("assets_dev/engine")
    write_tsv(output_path, output_rows)
    stats = stats_for(
        repo_root,
        source_relpath,
        source_path,
        source_encoding,
        [names_path, descriptions_path],
        [names_encoding, descriptions_encoding],
        entries,
        output_path,
        "zero-based non-empty class row order",
    )
    stats["logical_rows"] = logical_id
    return entries, stats


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
    for importer in (import_scrolls, import_classes):
        entries, stats = importer(repo_root, mmmerge_root, overlay_root)
        new_entries.extend(entries)
        new_tables.append(stats)

    duplicate_keys = sorted(existing_keys.intersection(entry["key"] for entry in new_entries))
    if duplicate_keys:
        raise ValueError(f"Duplicate catalog keys: {duplicate_keys[:20]}")

    catalog["entries"].extend(new_entries)
    catalog["tables"].extend(new_tables)
    catalog["format"] = max(int(catalog.get("format", 1)), 7)
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
