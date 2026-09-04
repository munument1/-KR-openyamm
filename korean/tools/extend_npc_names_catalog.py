#!/usr/bin/env python3
"""Append random NPC names to the Korean translation catalog and overlay."""

from __future__ import annotations

import argparse
import csv
import hashlib
import io
import json
import subprocess
import sys
from pathlib import Path


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
    rows = list(csv.reader(io.StringIO(text, newline=""), delimiter="\t", quotechar='"'))
    return rows, encoding


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


def rows_by_id(rows: list[list[str]], id_column: int = 0) -> dict[int, tuple[int, list[str]]]:
    result: dict[int, tuple[int, list[str]]] = {}
    for row_index, row in enumerate(rows):
        if id_column >= len(row):
            continue
        raw_id = row[id_column].strip()
        if raw_id.isdigit():
            result[int(raw_id)] = (row_index, row)
    return result


def refresh_summary(catalog: dict) -> None:
    entries = catalog["entries"]
    catalog["summary"] = {
        "entries": len(entries),
        "translated": sum(entry["status"] == "translated" for entry in entries),
        "untranslated": sum(entry["status"] == "untranslated" for entry in entries),
        "needs_review": sum(entry["status"] == "needs_review" for entry in entries),
        "overrides": sum(entry.get("translation_origin") == "override" for entry in entries),
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

    repo_root = (
        Path(args.repo_root).resolve()
        if args.repo_root
        else Path(__file__).resolve().parents[2]
    )
    mmmerge_root = Path(args.mmmerge_root).resolve()
    catalog_path = repo_root / args.catalog
    overlay_root = repo_root / args.overlay_engine_root

    source_relpath = "assets_dev/engine/data_tables/npc_names.txt"
    source_path = repo_root / source_relpath
    ko_path = mmmerge_root / "Data" / "Text localization" / "KO_NPCNames.txt"

    source_rows, source_encoding = read_tsv(source_path, ("utf-8-sig", "cp1252"))
    ko_rows, ko_encoding = read_tsv(ko_path, ("utf-8-sig", "cp949"))
    output_rows = [list(row) for row in source_rows]

    source_lookup = rows_by_id(source_rows)
    ko_lookup = rows_by_id(ko_rows)

    entries: list[dict] = []
    for record_id, (row_index, source_row) in sorted(source_lookup.items()):
        if len(source_row) < 2 or not source_row[1]:
            continue
        source_text = source_row[1]
        ko_row = ko_lookup.get(record_id, (-1, []))[1]
        translation = ko_row[1] if len(ko_row) >= 2 else ""
        status = "translated" if translation else "untranslated"
        if translation:
            output_rows[row_index][1] = translation
        entries.append(
            {
                "key": f"engine:npc_names.txt:{record_id}:Name",
                "scope": "engine",
                "source_file": source_relpath,
                "record_id": record_id,
                "field": "Name",
                "source": source_text,
                "translation": translation,
                "translation_origin": "mmmerge" if translation else "none",
                "status": status,
                "placeholder_ok": True,
                "note": "",
            }
        )

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    existing_keys = {entry["key"] for entry in catalog["entries"]}
    duplicate_keys = sorted(existing_keys.intersection(entry["key"] for entry in entries))
    if duplicate_keys:
        raise ValueError(f"Duplicate catalog keys: {duplicate_keys[:20]}")

    output_relpath = Path(source_relpath).relative_to("assets_dev/engine")
    output_path = overlay_root / output_relpath
    write_tsv(output_path, output_rows)

    table = {
        "overlay_source": "Data/Text localization/KO_NPCNames.txt",
        "overlay_format": "direct-id-row",
        "source_file": source_relpath,
        "source_sha256": sha256_file(source_path),
        "source_encoding": source_encoding,
        "mmmerge_sha256": sha256_file(ko_path),
        "mmmerge_encoding": ko_encoding,
        "entries": len(entries),
        "translated": sum(entry["status"] == "translated" for entry in entries),
        "untranslated": sum(entry["status"] == "untranslated" for entry in entries),
        "placeholder_mismatches": 0,
        "overrides": 0,
        "output_file": output_path.relative_to(repo_root).as_posix(),
        "output_encoding": "utf-8",
    }
    catalog["entries"].extend(entries)
    catalog["tables"].append(table)
    catalog["format"] = max(int(catalog.get("format", 1)), 7)
    refresh_summary(catalog)
    catalog_path.write_text(
        json.dumps(catalog, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    print(json.dumps(catalog["summary"], ensure_ascii=False))
    print(
        f"npc_names.txt: {table['translated']}/{table['entries']} translated, "
        f"{table['untranslated']} untranslated"
    )

    pc_names_command = [
        sys.executable,
        str(repo_root / "korean" / "tools" / "extend_pc_names_catalog.py"),
        "--repo-root",
        str(repo_root),
        "--catalog",
        args.catalog,
        "--overlay-engine-root",
        args.overlay_engine_root,
    ]
    if args.fail_on_review:
        pc_names_command.append("--fail-on-review")
    subprocess.run(pc_names_command, check=True)

    final_catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    if args.fail_on_review and (
        final_catalog["summary"]["untranslated"] or final_catalog["summary"]["needs_review"]
    ):
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
