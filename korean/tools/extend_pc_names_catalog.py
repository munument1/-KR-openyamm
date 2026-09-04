#!/usr/bin/env python3
"""Import reviewed Korean character-creation names into the translation catalog."""

from __future__ import annotations

import argparse
import csv
import hashlib
import io
import json
from pathlib import Path


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def read_tsv(path: Path) -> tuple[list[list[str]], str]:
    raw = path.read_bytes()
    for encoding in ("utf-8-sig", "cp1252"):
        try:
            text = raw.decode(encoding)
            return list(csv.reader(io.StringIO(text, newline=""), delimiter="\t", quotechar='"')), encoding
        except UnicodeDecodeError:
            pass
    raise ValueError(f"Could not decode {path}")


def write_tsv(path: Path, rows: list[list[str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as stream:
        csv.writer(stream, delimiter="\t", quotechar='"', quoting=csv.QUOTE_MINIMAL, lineterminator="\n").writerows(rows)


def refresh_summary(catalog: dict) -> None:
    entries = catalog["entries"]
    catalog["summary"] = {
        "entries": len(entries),
        "translated": sum(e["status"] == "translated" for e in entries),
        "untranslated": sum(e["status"] == "untranslated" for e in entries),
        "needs_review": sum(e["status"] == "needs_review" for e in entries),
        "overrides": sum(e.get("translation_origin") == "override" for e in entries),
        "excluded": sum(int(t.get("excluded", 0)) for t in catalog["tables"]),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", default=None)
    parser.add_argument("--catalog", default="korean/translations/catalog.json")
    parser.add_argument("--inventory", default="korean/translations/pc_names_inventory.json")
    parser.add_argument("--translations", default="korean/translations/pc_names_reviewed.json")
    parser.add_argument("--overlay-engine-root", default="korean/overlay/engine")
    parser.add_argument("--fail-on-review", action="store_true")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    catalog_path = repo_root / args.catalog
    inventory_path = repo_root / args.inventory
    translation_path = repo_root / args.translations
    source_relpath = "assets_dev/engine/data_tables/english/pc_names.txt"
    source_path = repo_root / source_relpath
    overlay_root = repo_root / args.overlay_engine_root

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    inventory = json.loads(inventory_path.read_text(encoding="utf-8"))
    payload = json.loads(translation_path.read_text(encoding="utf-8"))

    if inventory.get("source_file") != source_relpath:
        raise ValueError("PC name inventory source path mismatch")
    if payload.get("source_file") != source_relpath:
        raise ValueError("PC name translation source path mismatch")
    if payload.get("review_status") != "reviewed":
        raise ValueError("PC name translation set has not passed review")

    inventory_entries = inventory.get("entries", [])
    unique_sources = inventory.get("unique_sources", [])
    if len(inventory_entries) != int(inventory.get("entry_count", -1)):
        raise ValueError("PC name inventory entry count mismatch")
    if len(unique_sources) != int(inventory.get("unique_source_count", -1)):
        raise ValueError("PC name inventory unique-source count mismatch")
    if len(set(unique_sources)) != len(unique_sources):
        raise ValueError("PC name inventory contains duplicate unique_sources")

    translations = payload.get("entries", {})
    source_set = set(unique_sources)
    translation_set = set(translations)
    if translation_set != source_set:
        missing = sorted(source_set - translation_set)
        extra = sorted(translation_set - source_set)
        raise ValueError(f"PC name translation key mismatch: missing={missing}, extra={extra}")

    for source in unique_sources:
        spec = translations[source]
        if not spec.get("reviewed"):
            raise ValueError(f"PC name is not marked reviewed: {source!r}")
        if str(spec.get("source", source)) != source:
            raise ValueError(f"PC name source mismatch inside translation map: {source!r}")
        if not str(spec.get("translation", "")).strip():
            raise ValueError(f"PC name translation is empty: {source!r}")

    rows, source_encoding = read_tsv(source_path)
    output_rows = [list(row) for row in rows]
    existing_keys = {entry["key"] for entry in catalog["entries"]}
    added: list[dict] = []

    seen_inventory_cells: set[tuple[int, int]] = set()
    for entry in inventory_entries:
        row_index = int(entry["row"])
        column = int(entry["column"])
        category = str(entry["category"])
        source = str(entry["source"])
        cell = (row_index, column)

        if cell in seen_inventory_cells:
            raise ValueError(f"Duplicate PC name inventory cell: row={row_index}, column={column}")
        seen_inventory_cells.add(cell)

        if row_index <= 0 or row_index >= len(rows):
            raise ValueError(f"PC name row out of range: {row_index}")
        if column < 0 or column >= len(rows[row_index]):
            raise ValueError(f"PC name column out of range: row={row_index}, column={column}")

        active_source = rows[row_index][column].strip()
        if active_source != source:
            raise ValueError(
                f"PC name source drift at row={row_index}, column={column}: expected {source!r}, got {active_source!r}"
            )

        translation = str(translations[source]["translation"]).strip()
        output_rows[row_index][column] = translation
        key = f"engine:pc_names.txt:{row_index}:{column}:{category}"
        if key in existing_keys:
            raise ValueError(f"Duplicate catalog key: {key}")
        existing_keys.add(key)
        added.append({
            "key": key,
            "scope": "engine",
            "source_file": source_relpath,
            "record_id": row_index,
            "field": category,
            "source": source,
            "translation": translation,
            "translation_origin": "reviewed_direct",
            "status": "translated",
            "placeholder_ok": True,
            "note": "Character-creation default name; directly transliterated to Korean and reviewed by unique source name.",
        })

    if len(added) != int(inventory.get("entry_count", -1)):
        raise ValueError("PC name imported entry count mismatch")

    output_path = overlay_root / Path(source_relpath).relative_to("assets_dev/engine")
    write_tsv(output_path, output_rows)
    catalog["entries"].extend(added)
    catalog["tables"].append({
        "overlay_source": translation_path.relative_to(repo_root).as_posix(),
        "overlay_format": "reviewed direct transliteration map by unique source name",
        "source_file": source_relpath,
        "source_sha256": sha256_file(source_path),
        "source_encoding": source_encoding,
        "translation_sha256": sha256_file(translation_path),
        "inventory_sha256": sha256_file(inventory_path),
        "entries": len(added),
        "translated": len(added),
        "untranslated": 0,
        "placeholder_mismatches": 0,
        "overrides": 0,
        "excluded": 0,
        "output_file": output_path.relative_to(repo_root).as_posix(),
        "output_encoding": "utf-8",
    })
    catalog["format"] = max(int(catalog.get("format", 1)), 12)
    refresh_summary(catalog)
    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(json.dumps(catalog["summary"], ensure_ascii=False))
    print(
        f"pc_names.txt: {len(added)}/{len(added)} translated from "
        f"{len(unique_sources)} reviewed unique source names"
    )

    if args.fail_on_review and (catalog["summary"]["untranslated"] or catalog["summary"]["needs_review"]):
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
