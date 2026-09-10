#!/usr/bin/env python3
"""Append simple ID-based engine text tables to the Korean catalog.

The catalog tracks the declared OpenYAMM MM6-MM8 playable scope. Source rows
that belong to out-of-scope content stay untouched in the generated native TSV
and are reported as explicit exclusions instead of false translation misses.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import io
import json
from collections import Counter
from dataclasses import dataclass
from pathlib import Path
import re

PRINTF_TOKEN_RE = re.compile(
    r"%(?:\d+\$)?\d*(?:\.\d+)?(?:hh|h|ll|l|j|z|t|L)?[diuoxXfFeEgGaAcsn]"
)


@dataclass(frozen=True)
class TableSpec:
    source_relpath: str
    overlay_name: str
    field_name: str
    target_column: int
    translation_field: str
    maximum_record_id: int | None = None
    exclusion_reason: str = ""


TABLES = (
    TableSpec(
        source_relpath="assets_dev/engine/data_tables/english/awards.txt",
        overlay_name="KO_AwardsTxt.txt",
        field_name="Awards",
        target_column=1,
        translation_field="",
    ),
    TableSpec(
        source_relpath="assets_dev/engine/data_tables/map_stats.txt",
        overlay_name="KO_MapStats.txt",
        field_name="Name",
        target_column=1,
        translation_field="Name",
        maximum_record_id=8999,
        exclusion_reason=(
            "Record IDs 9000 and above are MM9 map data and are outside "
            "OpenYAMM's declared MM6-MM8 playable localization scope."
        ),
    ),
    TableSpec(
        source_relpath="assets_dev/engine/data_tables/monster_data.txt",
        overlay_name="KO_Monsters.txt",
        field_name="Name",
        target_column=1,
        translation_field="Name",
    ),
)


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def read_text(path: Path, encodings: tuple[str, ...]) -> tuple[str, str]:
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
    text, encoding = read_text(path, encodings)
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


def append_table(
    repo_root: Path,
    mmmerge_root: Path,
    overlay_root: Path,
    spec: TableSpec,
) -> tuple[list[dict], dict]:
    source_path = repo_root / spec.source_relpath
    translation_path = mmmerge_root / "Data" / "Text localization" / spec.overlay_name
    source_rows, source_encoding = read_tsv(source_path, ("utf-8-sig", "cp1252"))
    output_rows = [list(row) for row in source_rows]
    translations, translation_encoding = parse_overlay(translation_path)

    entries: list[dict] = []
    excluded_ids: list[int] = []
    for row_index, row in enumerate(source_rows):
        if not row or not row[0].strip().isdigit() or spec.target_column >= len(row):
            continue
        record_id = int(row[0].strip())
        source_text = row[spec.target_column]
        if not source_text:
            continue

        if spec.maximum_record_id is not None and record_id > spec.maximum_record_id:
            excluded_ids.append(record_id)
            continue

        translation = translations.get((record_id, spec.translation_field), "")
        placeholder_ok = not translation or printf_tokens(source_text) == printf_tokens(translation)
        status = "translated" if translation and placeholder_ok else (
            "needs_review" if translation else "untranslated"
        )
        if status == "translated":
            output_rows[row_index][spec.target_column] = translation
        entries.append(
            {
                "key": f"engine:{Path(spec.source_relpath).name}:{record_id}:{spec.field_name}",
                "scope": "engine",
                "source_file": spec.source_relpath,
                "record_id": record_id,
                "field": spec.field_name,
                "source": source_text,
                "translation": translation,
                "translation_origin": "mmmerge" if translation else "none",
                "status": status,
                "placeholder_ok": placeholder_ok,
                "note": "",
            }
        )

    output_relpath = Path(spec.source_relpath).relative_to("assets_dev/engine")
    output_path = overlay_root / output_relpath
    write_tsv(output_path, output_rows)

    stats = {
        "overlay_source": f"Data/Text localization/{spec.overlay_name}",
        "overlay_format": "id-field-text",
        "source_file": spec.source_relpath,
        "source_sha256": sha256_file(source_path),
        "source_encoding": source_encoding,
        "mmmerge_sha256": sha256_file(translation_path),
        "mmmerge_encoding": translation_encoding,
        "entries": len(entries),
        "translated": sum(1 for entry in entries if entry["status"] == "translated"),
        "untranslated": sum(1 for entry in entries if entry["status"] == "untranslated"),
        "placeholder_mismatches": sum(1 for entry in entries if entry["status"] == "needs_review"),
        "overrides": 0,
        "excluded": len(excluded_ids),
        "excluded_record_id_min": min(excluded_ids) if excluded_ids else None,
        "excluded_record_id_max": max(excluded_ids) if excluded_ids else None,
        "exclusion_reason": spec.exclusion_reason if excluded_ids else "",
        "output_file": output_path.relative_to(repo_root).as_posix(),
        "output_encoding": "utf-8",
    }
    return entries, stats


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
    for spec in TABLES:
        entries, stats = append_table(repo_root, mmmerge_root, overlay_root, spec)
        new_entries.extend(entries)
        new_tables.append(stats)

    duplicate_keys = sorted(existing_keys.intersection(entry["key"] for entry in new_entries))
    if duplicate_keys:
        raise ValueError(f"Duplicate catalog keys: {duplicate_keys[:20]}")

    catalog["entries"].extend(new_entries)
    catalog["tables"].extend(new_tables)
    catalog["format"] = max(int(catalog.get("format", 1)), 5)
    refresh_summary(catalog)
    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(json.dumps(catalog["summary"], ensure_ascii=False))
    for table in new_tables:
        line = (
            f"{Path(table['source_file']).name}: "
            f"{table['translated']}/{table['entries']} translated, "
            f"{table['untranslated']} untranslated, "
            f"{table['placeholder_mismatches']} placeholder mismatch(es)"
        )
        if table["excluded"]:
            line += f", {table['excluded']} out-of-scope row(s) excluded"
        print(line)

    if args.fail_on_review and (
        catalog["summary"]["untranslated"] or catalog["summary"]["needs_review"]
    ):
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
