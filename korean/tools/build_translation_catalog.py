#!/usr/bin/env python3
"""Build an auditable Korean translation catalog and OpenYAMM overlay files.

The source of truth for reusable Korean text is the user's MMMerge Korean
localization repository. OpenYAMM runtime files remain in their native TSV/TXT
formats; JSON is only the review/coverage layer used to detect omissions and
source drift.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
from collections import Counter
from dataclasses import dataclass
from pathlib import Path
import re
from typing import Iterable

PRINTF_TOKEN_RE = re.compile(r"%(?:\d+\$)?[-+#0 ]*\d*(?:\.\d+)?[A-Za-z]")


@dataclass(frozen=True)
class TableSpec:
    overlay_name: str
    source_relpath: str
    fields: dict[str, int]


TABLE_SPECS = (
    TableSpec(
        overlay_name="KO_GlobalTxt.txt",
        source_relpath="assets_dev/engine/data_tables/english/Global.txt",
        fields={"": 1},
    ),
    TableSpec(
        overlay_name="KO_QuestsTxt.txt",
        source_relpath="assets_dev/engine/data_tables/english/quests.txt",
        fields={"": 1},
    ),
    TableSpec(
        overlay_name="KO_AutonoteTxt.txt",
        source_relpath="assets_dev/engine/data_tables/english/autonote.txt",
        fields={"": 1},
    ),
    TableSpec(
        overlay_name="KO_SpellsTxt.txt",
        source_relpath="assets_dev/engine/data_tables/english/spells.txt",
        fields={
            "Name": 2,
            "ShortName": 4,
            "Description": 5,
            "Normal": 6,
            "Expert": 7,
            "Master": 8,
            "GrandMaster": 9,
        },
    ),
)


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def read_tsv(path: Path) -> list[list[str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as stream:
        return list(csv.reader(stream, delimiter="\t", quotechar='"'))


def write_tsv(path: Path, rows: Iterable[list[str]]) -> None:
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


def parse_mmmerge_overlay(path: Path) -> dict[tuple[int, str], str]:
    rows = read_tsv(path)
    result: dict[tuple[int, str], str] = {}
    for row in rows[1:]:
        if len(row) < 4:
            continue
        raw_id = row[1].strip()
        if not raw_id.isdigit():
            continue
        result[(int(raw_id), row[2].strip())] = row[3]
    return result


def source_rows_by_id(rows: list[list[str]]) -> dict[int, int]:
    result: dict[int, int] = {}
    for row_index, row in enumerate(rows):
        if not row:
            continue
        raw_id = row[0].strip()
        if raw_id.isdigit():
            result[int(raw_id)] = row_index
    return result


def printf_tokens(text: str) -> Counter[str]:
    return Counter(PRINTF_TOKEN_RE.findall(text))


def build_table(
    repo_root: Path,
    mmmerge_root: Path,
    overlay_engine_root: Path,
    spec: TableSpec,
) -> tuple[list[dict], dict]:
    source_path = repo_root / spec.source_relpath
    mmmerge_path = mmmerge_root / "Data" / "Text localization" / spec.overlay_name
    if not source_path.is_file():
        raise FileNotFoundError(source_path)
    if not mmmerge_path.is_file():
        raise FileNotFoundError(mmmerge_path)

    source_rows = read_tsv(source_path)
    output_rows = [list(row) for row in source_rows]
    row_lookup = source_rows_by_id(source_rows)
    translations = parse_mmmerge_overlay(mmmerge_path)

    entries: list[dict] = []
    translated_count = 0
    missing_count = 0
    placeholder_mismatches = 0

    for record_id, row_index in sorted(row_lookup.items()):
        row = source_rows[row_index]
        for field_name, column_index in spec.fields.items():
            if column_index >= len(row):
                continue
            source_text = row[column_index]
            if source_text == "":
                continue

            translation = translations.get((record_id, field_name), "")
            status = "translated" if translation else "untranslated"
            placeholder_ok = True
            if translation:
                placeholder_ok = printf_tokens(source_text) == printf_tokens(translation)
                if placeholder_ok:
                    output_rows[row_index][column_index] = translation
                    translated_count += 1
                else:
                    status = "needs_review"
                    placeholder_mismatches += 1
            else:
                missing_count += 1

            entries.append(
                {
                    "key": f"engine:{Path(spec.source_relpath).name}:{record_id}:{field_name or 'text'}",
                    "scope": "engine",
                    "source_file": spec.source_relpath,
                    "record_id": record_id,
                    "field": field_name or "text",
                    "source": source_text,
                    "translation": translation,
                    "status": status,
                    "placeholder_ok": placeholder_ok,
                }
            )

    output_relpath = Path(spec.source_relpath).relative_to("assets_dev/engine")
    output_path = overlay_engine_root / output_relpath
    write_tsv(output_path, output_rows)

    stats = {
        "overlay_source": f"Data/Text localization/{spec.overlay_name}",
        "source_file": spec.source_relpath,
        "source_sha256": sha256_file(source_path),
        "mmmerge_sha256": sha256_file(mmmerge_path),
        "entries": len(entries),
        "translated": translated_count,
        "untranslated": missing_count,
        "placeholder_mismatches": placeholder_mismatches,
        "output_file": output_path.relative_to(repo_root).as_posix(),
    }
    return entries, stats


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", default=None)
    parser.add_argument("--mmmerge-root", required=True)
    parser.add_argument(
        "--catalog-output",
        default="korean/translations/catalog.json",
    )
    parser.add_argument(
        "--overlay-engine-root",
        default="korean/overlay/engine",
    )
    parser.add_argument(
        "--fail-on-placeholder-mismatch",
        action="store_true",
    )
    args = parser.parse_args()

    repo_root = (
        Path(args.repo_root).resolve()
        if args.repo_root
        else Path(__file__).resolve().parents[2]
    )
    mmmerge_root = Path(args.mmmerge_root).resolve()
    catalog_output = repo_root / args.catalog_output
    overlay_engine_root = repo_root / args.overlay_engine_root

    all_entries: list[dict] = []
    tables: list[dict] = []
    for spec in TABLE_SPECS:
        entries, stats = build_table(
            repo_root,
            mmmerge_root,
            overlay_engine_root,
            spec,
        )
        all_entries.extend(entries)
        tables.append(stats)

    summary = {
        "entries": len(all_entries),
        "translated": sum(1 for entry in all_entries if entry["status"] == "translated"),
        "untranslated": sum(1 for entry in all_entries if entry["status"] == "untranslated"),
        "needs_review": sum(1 for entry in all_entries if entry["status"] == "needs_review"),
    }
    catalog = {
        "format": 1,
        "purpose": "OpenYAMM Korean translation coverage and source-drift tracking",
        "runtime_format": "native OpenYAMM TSV/TXT overlay",
        "translation_source": "munument1/-KR-MMMerge",
        "tables": tables,
        "summary": summary,
        "entries": all_entries,
    }
    catalog_output.parent.mkdir(parents=True, exist_ok=True)
    catalog_output.write_text(
        json.dumps(catalog, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    print(json.dumps(summary, ensure_ascii=False))
    for table in tables:
        print(
            f"{Path(table['source_file']).name}: "
            f"{table['translated']}/{table['entries']} translated, "
            f"{table['untranslated']} untranslated, "
            f"{table['placeholder_mismatches']} placeholder mismatch(es)"
        )

    if args.fail_on_placeholder_mismatch and summary["needs_review"]:
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
