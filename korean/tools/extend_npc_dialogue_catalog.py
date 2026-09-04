#!/usr/bin/env python3
"""Append NPC greetings, topics and dialogue text to the Korean catalog.

This runs after build_translation_catalog.py. It keeps the audit catalog as the
QA source of truth while writing the actual runtime data in OpenYAMM's native
TSV format.
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


def source_rows_by_id(rows: list[list[str]]) -> dict[int, int]:
    result: dict[int, int] = {}
    for row_index, row in enumerate(rows):
        if row and row[0].strip().isdigit():
            result[int(row[0].strip())] = row_index
    return result


def parse_field_overlay(path: Path) -> tuple[dict[tuple[int, str], str], str]:
    rows, encoding = read_tsv(path, ("utf-8-sig", "cp949"))
    result: dict[tuple[int, str], str] = {}
    for row in rows[1:]:
        if len(row) < 4 or not row[1].strip().isdigit():
            continue
        result[(int(row[1].strip()), row[2].strip())] = row[3]
    return result, encoding


def printf_tokens(text: str) -> Counter[str]:
    return Counter(PRINTF_TOKEN_RE.findall(text))


def make_entry(
    source_file: str,
    record_id: int,
    field_name: str,
    source_text: str,
    translation: str,
) -> dict:
    placeholder_ok = not translation or printf_tokens(source_text) == printf_tokens(translation)
    status = "translated" if translation and placeholder_ok else (
        "needs_review" if translation else "untranslated"
    )
    return {
        "key": f"engine:{Path(source_file).name}:{record_id}:{field_name}",
        "scope": "engine",
        "source_file": source_file,
        "record_id": record_id,
        "field": field_name,
        "source": source_text,
        "translation": translation,
        "translation_origin": "mmmerge" if translation else "none",
        "status": status,
        "placeholder_ok": placeholder_ok,
        "note": "",
    }


def append_simple_table(
    repo_root: Path,
    mmmerge_root: Path,
    overlay_root: Path,
    source_relpath: str,
    overlay_name: str,
    field_name: str,
    target_column: int,
    translation_field: str = "",
) -> tuple[list[dict], dict]:
    source_path = repo_root / source_relpath
    translation_path = mmmerge_root / "Data" / "Text localization" / overlay_name
    source_rows, source_encoding = read_tsv(source_path, ("utf-8-sig", "cp1252"))
    output_rows = [list(row) for row in source_rows]
    translations, translation_encoding = parse_field_overlay(translation_path)
    row_lookup = source_rows_by_id(source_rows)

    entries: list[dict] = []
    for record_id, row_index in sorted(row_lookup.items()):
        row = source_rows[row_index]
        if target_column >= len(row) or not row[target_column]:
            continue
        source_text = row[target_column]
        translation = translations.get((record_id, translation_field), "")
        entry = make_entry(source_relpath, record_id, field_name, source_text, translation)
        if entry["status"] == "translated":
            output_rows[row_index][target_column] = translation
        entries.append(entry)

    output_relpath = Path(source_relpath).relative_to("assets_dev/engine")
    output_path = overlay_root / output_relpath
    write_tsv(output_path, output_rows)
    stats = table_stats(
        entries,
        source_path,
        source_encoding,
        [translation_path],
        [translation_encoding],
        output_path,
        repo_root,
    )
    stats["overlay_source"] = f"Data/Text localization/{overlay_name}"
    stats["overlay_format"] = "id-field-text"
    return entries, stats


def append_greetings(
    repo_root: Path,
    mmmerge_root: Path,
    overlay_root: Path,
) -> tuple[list[dict], dict]:
    source_relpath = "assets_dev/engine/data_tables/npc_greet.txt"
    source_path = repo_root / source_relpath
    greet1_path = mmmerge_root / "Data" / "Text localization" / "KO_NPCGreet1.txt"
    greet2_path = mmmerge_root / "Data" / "Text localization" / "KO_NPCGreet2.txt"
    source_rows, source_encoding = read_tsv(source_path, ("utf-8-sig", "cp1252"))
    output_rows = [list(row) for row in source_rows]
    greet1, greet1_encoding = parse_field_overlay(greet1_path)
    greet2, greet2_encoding = parse_field_overlay(greet2_path)
    row_lookup = source_rows_by_id(source_rows)

    entries: list[dict] = []
    field_specs = (
        ("Greeting1", 1, greet1, "0"),
        ("Greeting2", 2, greet2, "1"),
    )
    for record_id, row_index in sorted(row_lookup.items()):
        row = source_rows[row_index]
        for field_name, target_column, translations, translation_field in field_specs:
            if target_column >= len(row) or not row[target_column]:
                continue
            source_text = row[target_column]
            translation = translations.get((record_id, translation_field), "")
            entry = make_entry(source_relpath, record_id, field_name, source_text, translation)
            if entry["status"] == "translated":
                output_rows[row_index][target_column] = translation
            entries.append(entry)

    output_relpath = Path(source_relpath).relative_to("assets_dev/engine")
    output_path = overlay_root / output_relpath
    write_tsv(output_path, output_rows)
    stats = table_stats(
        entries,
        source_path,
        source_encoding,
        [greet1_path, greet2_path],
        [greet1_encoding, greet2_encoding],
        output_path,
        repo_root,
    )
    stats["overlay_source"] = [
        "Data/Text localization/KO_NPCGreet1.txt",
        "Data/Text localization/KO_NPCGreet2.txt",
    ]
    stats["overlay_format"] = "two-id-field-text-files"
    return entries, stats


def table_stats(
    entries: list[dict],
    source_path: Path,
    source_encoding: str,
    translation_paths: list[Path],
    translation_encodings: list[str],
    output_path: Path,
    repo_root: Path,
) -> dict:
    return {
        "source_file": source_path.relative_to(repo_root).as_posix(),
        "source_sha256": sha256_file(source_path),
        "source_encoding": source_encoding,
        "mmmerge_sha256": [sha256_file(path) for path in translation_paths],
        "mmmerge_encoding": translation_encodings,
        "entries": len(entries),
        "translated": sum(1 for entry in entries if entry["status"] == "translated"),
        "untranslated": sum(1 for entry in entries if entry["status"] == "untranslated"),
        "placeholder_mismatches": sum(1 for entry in entries if entry["status"] == "needs_review"),
        "overrides": 0,
        "output_file": output_path.relative_to(repo_root).as_posix(),
        "output_encoding": "utf-8",
    }


def refresh_summary(catalog: dict) -> None:
    entries = catalog["entries"]
    catalog["summary"] = {
        "entries": len(entries),
        "translated": sum(1 for entry in entries if entry["status"] == "translated"),
        "untranslated": sum(1 for entry in entries if entry["status"] == "untranslated"),
        "needs_review": sum(1 for entry in entries if entry["status"] == "needs_review"),
        "overrides": sum(1 for entry in entries if entry.get("translation_origin") == "override"),
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

    entries, stats = append_greetings(repo_root, mmmerge_root, overlay_root)
    new_entries.extend(entries)
    new_tables.append(stats)

    for source_relpath, overlay_name, field_name in (
        ("assets_dev/engine/data_tables/npc_topic.txt", "KO_NPCTopic.txt", "Topic"),
        ("assets_dev/engine/data_tables/npc_topic_text.txt", "KO_NPCText.txt", "Text"),
    ):
        entries, stats = append_simple_table(
            repo_root,
            mmmerge_root,
            overlay_root,
            source_relpath,
            overlay_name,
            field_name,
            1,
        )
        new_entries.extend(entries)
        new_tables.append(stats)

    duplicate_keys = sorted(existing_keys.intersection(entry["key"] for entry in new_entries))
    if duplicate_keys:
        raise ValueError(f"Duplicate catalog keys: {duplicate_keys[:20]}")

    catalog["entries"].extend(new_entries)
    catalog["tables"].extend(new_tables)
    catalog["format"] = max(int(catalog.get("format", 1)), 3)
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
