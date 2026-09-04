#!/usr/bin/env python3
"""Apply explicit Korean overrides to an already generated catalog and overlay.

Used for OpenYAMM-only strings and corrections to inherited MMMerge text. The
runtime file remains native TSV; JSON only records why the override exists.
"""

from __future__ import annotations

import argparse
import csv
import json
from collections import Counter
from pathlib import Path
import re

PRINTF_TOKEN_RE = re.compile(
    r"%(?:\d+\$)?\d*(?:\.\d+)?(?:hh|h|ll|l|j|z|t|L)?[diuoxXfFeEgGaAcsn]"
)

FIELD_COLUMNS = {
    ("npc_greet.txt", "Greeting1"): 1,
    ("npc_greet.txt", "Greeting2"): 2,
    ("npc_topic.txt", "Topic"): 1,
    ("npc_topic_text.txt", "Text"): 1,
}


def printf_tokens(text: str) -> Counter[str]:
    return Counter(PRINTF_TOKEN_RE.findall(text))


def read_tsv(path: Path) -> list[list[str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as stream:
        return list(csv.reader(stream, delimiter="\t", quotechar='"'))


def write_tsv(path: Path, rows: list[list[str]]) -> None:
    with path.open("w", encoding="utf-8", newline="") as stream:
        writer = csv.writer(
            stream,
            delimiter="\t",
            quotechar='"',
            quoting=csv.QUOTE_MINIMAL,
            lineterminator="\n",
        )
        writer.writerows(rows)


def row_lookup(rows: list[list[str]]) -> dict[int, int]:
    result: dict[int, int] = {}
    for index, row in enumerate(rows):
        if row and row[0].strip().isdigit():
            result[int(row[0].strip())] = index
    return result


def refresh_counts(catalog: dict) -> None:
    entries = catalog["entries"]
    by_source: dict[str, list[dict]] = {}
    for entry in entries:
        by_source.setdefault(entry["source_file"], []).append(entry)

    for table in catalog["tables"]:
        table_entries = by_source.get(table["source_file"], [])
        table["entries"] = len(table_entries)
        table["translated"] = sum(1 for entry in table_entries if entry["status"] == "translated")
        table["untranslated"] = sum(1 for entry in table_entries if entry["status"] == "untranslated")
        table["placeholder_mismatches"] = sum(
            1 for entry in table_entries if entry["status"] == "needs_review"
        )
        table["overrides"] = sum(
            1 for entry in table_entries if entry.get("translation_origin") == "override"
        )

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
    parser.add_argument("--catalog", default="korean/translations/catalog.json")
    parser.add_argument("--overrides", required=True)
    parser.add_argument("--overlay-engine-root", default="korean/overlay/engine")
    parser.add_argument("--fail-on-review", action="store_true")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    catalog_path = repo_root / args.catalog
    override_path = repo_root / args.overrides
    overlay_root = repo_root / args.overlay_engine_root

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    payload = json.loads(override_path.read_text(encoding="utf-8"))
    overrides = payload.get("entries", {})
    entries_by_key = {entry["key"]: entry for entry in catalog["entries"]}

    touched_files: dict[Path, tuple[list[list[str]], dict[int, int]]] = {}

    for key, override in overrides.items():
        if key not in entries_by_key:
            raise ValueError(f"Override does not match a catalog entry: {key}")
        translation = override.get("translation", "")
        if not isinstance(translation, str) or not translation:
            raise ValueError(f"Override has no translation: {key}")

        entry = entries_by_key[key]
        placeholder_ok = printf_tokens(entry["source"]) == printf_tokens(translation)
        if not placeholder_ok:
            raise ValueError(f"Override placeholder mismatch: {key}")

        source_name = Path(entry["source_file"]).name
        field_name = entry["field"]
        column = FIELD_COLUMNS.get((source_name, field_name))
        if column is None:
            raise ValueError(f"No runtime column mapping for override: {key}")

        output_relpath = Path(entry["source_file"]).relative_to("assets_dev/engine")
        output_path = overlay_root / output_relpath
        if output_path not in touched_files:
            rows = read_tsv(output_path)
            touched_files[output_path] = (rows, row_lookup(rows))
        rows, lookup = touched_files[output_path]
        record_id = int(entry["record_id"])
        if record_id not in lookup:
            raise ValueError(f"Runtime row missing for override: {key}")
        row = rows[lookup[record_id]]
        if column >= len(row):
            raise ValueError(f"Runtime column missing for override: {key}")
        row[column] = translation

        entry["translation"] = translation
        entry["translation_origin"] = "override"
        entry["status"] = "translated"
        entry["placeholder_ok"] = True
        entry["note"] = str(override.get("note", ""))

    for output_path, (rows, _) in touched_files.items():
        write_tsv(output_path, rows)

    refresh_counts(catalog)
    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(catalog["summary"], ensure_ascii=False))

    if args.fail_on_review and (
        catalog["summary"]["untranslated"] or catalog["summary"]["needs_review"]
    ):
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
