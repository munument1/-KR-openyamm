#!/usr/bin/env python3
"""Import MMMerge 2DEvents localization into OpenYAMM house_data.txt.

Only user-visible textual fields are tracked. Empty cells and numeric sentinel
values such as the legacy Enter-text value 0 are deliberately ignored so they
do not become false translation misses.
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

# field name -> (OpenYAMM house_data column, KO_2DEvents column)
FIELD_COLUMNS = {
    "Name": (5, 1),
    "ProprietorName": (6, 2),
    "Title": (7, 3),
    "EnterText": (23, 4),
}


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


def rows_by_id(rows: list[list[str]], id_column: int = 0) -> dict[int, int]:
    result: dict[int, int] = {}
    for index, row in enumerate(rows):
        if len(row) > id_column and row[id_column].strip().isdigit():
            result[int(row[id_column].strip())] = index
    return result


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

    source_relpath = "assets_dev/engine/data_tables/house_data.txt"
    source_path = repo_root / source_relpath
    translation_path = mmmerge_root / "Data" / "Text localization" / "KO_2DEvents.txt"

    source_rows, source_encoding = read_tsv(source_path, ("utf-8-sig", "cp1252"))
    translation_rows, translation_encoding = read_tsv(translation_path, ("utf-8-sig", "cp949"))
    output_rows = [list(row) for row in source_rows]
    source_lookup = rows_by_id(source_rows)
    translation_lookup = rows_by_id(translation_rows)

    entries: list[dict] = []
    source_ids_without_translation_row: list[int] = []

    for record_id, source_row_index in sorted(source_lookup.items()):
        source_row = source_rows[source_row_index]
        translation_row_index = translation_lookup.get(record_id)
        translation_row = translation_rows[translation_row_index] if translation_row_index is not None else []

        for field_name, (source_column, translation_column) in FIELD_COLUMNS.items():
            if source_column >= len(source_row):
                continue
            source_text = source_row[source_column]

            # Empty runtime cells and legacy numeric sentinels are data, not text.
            if not source_text or source_text.strip() == "0":
                continue

            if translation_row_index is None:
                translation = ""
                if record_id not in source_ids_without_translation_row:
                    source_ids_without_translation_row.append(record_id)
            elif translation_column < len(translation_row):
                candidate = translation_row[translation_column]
                translation = "" if candidate.strip() == "0" else candidate
            else:
                translation = ""

            placeholder_ok = not translation or printf_tokens(source_text) == printf_tokens(translation)
            status = "translated" if translation and placeholder_ok else (
                "needs_review" if translation else "untranslated"
            )
            if status == "translated":
                output_rows[source_row_index][source_column] = translation

            entries.append(
                {
                    "key": f"engine:house_data.txt:{record_id}:{field_name}",
                    "scope": "engine",
                    "source_file": source_relpath,
                    "record_id": record_id,
                    "field": field_name,
                    "source": source_text,
                    "translation": translation,
                    "translation_origin": "mmmerge" if translation else "none",
                    "status": status,
                    "placeholder_ok": placeholder_ok,
                    "note": "KO_2DEvents direct ID mapping.",
                }
            )

    output_path = overlay_root / Path(source_relpath).relative_to("assets_dev/engine")
    write_tsv(output_path, output_rows)

    stats = {
        "overlay_source": "Data/Text localization/KO_2DEvents.txt",
        "overlay_format": "direct ID row; Name/Proprietor/Title/EnterText fields",
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
        "excluded": 0,
        "source_ids_without_translation_row": source_ids_without_translation_row,
        "output_file": output_path.relative_to(repo_root).as_posix(),
        "output_encoding": "utf-8",
    }

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    existing_keys = {entry["key"] for entry in catalog["entries"]}
    duplicate_keys = sorted(existing_keys.intersection(entry["key"] for entry in entries))
    if duplicate_keys:
        raise ValueError(f"Duplicate catalog keys: {duplicate_keys[:20]}")

    catalog["entries"].extend(entries)
    catalog["tables"].append(stats)
    catalog["format"] = max(int(catalog.get("format", 1)), 8)
    refresh_summary(catalog)
    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(json.dumps(catalog["summary"], ensure_ascii=False))
    print(
        f"house_data.txt: {stats['translated']}/{stats['entries']} translated, "
        f"{stats['untranslated']} untranslated, "
        f"{stats['placeholder_mismatches']} placeholder mismatch(es), "
        f"{len(source_ids_without_translation_row)} source ID(s) without KO_2DEvents row"
    )

    if args.fail_on_review and (
        catalog["summary"]["untranslated"] or catalog["summary"]["needs_review"]
    ):
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
