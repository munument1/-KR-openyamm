#!/usr/bin/env python3
"""Import OpenYAMM-only Korean Arcomage card names.

The active runtime table contains 102 cards. MMMerge's Korean localization has no
corresponding Arcomage card-name text asset, so the audited Korean names live in
korean/translations/arcomage_card_names.json. Only the visible `name` column is
translated; card IDs, slots, costs, conditions, and effects remain untouched.
"""

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
            continue
    raise UnicodeDecodeError("utf-8", raw, 0, 1, "Could not decode Arcomage table")


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
    parser.add_argument("--catalog", default="korean/translations/catalog.json")
    parser.add_argument("--translations", default="korean/translations/arcomage_card_names.json")
    parser.add_argument("--overlay-engine-root", default="korean/overlay/engine")
    parser.add_argument("--fail-on-review", action="store_true")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    catalog_path = repo_root / args.catalog
    translation_path = repo_root / args.translations
    overlay_root = repo_root / args.overlay_engine_root
    source_relpath = "assets_dev/engine/data_tables/arcomage_cards.txt"
    source_path = repo_root / source_relpath

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    payload = json.loads(translation_path.read_text(encoding="utf-8"))
    translations = payload.get("entries", {})
    rows, source_encoding = read_tsv(source_path)
    output_rows = [list(row) for row in rows]

    expected_ids = set(range(102))
    translation_ids = {int(raw_id) for raw_id in translations}
    if translation_ids != expected_ids:
        missing = sorted(expected_ids - translation_ids)
        extra = sorted(translation_ids - expected_ids)
        raise ValueError(f"Arcomage translation IDs mismatch: missing={missing}, extra={extra}")

    source_rows: dict[int, tuple[int, list[str]]] = {}
    for row_index, row in enumerate(rows[1:], start=1):
        if len(row) >= 2 and row[0].strip().isdigit():
            source_rows[int(row[0].strip())] = (row_index, row)
    if set(source_rows) != expected_ids:
        missing = sorted(expected_ids - set(source_rows))
        extra = sorted(set(source_rows) - expected_ids)
        raise ValueError(f"Arcomage source IDs mismatch: missing={missing}, extra={extra}")

    existing_keys = {entry["key"] for entry in catalog["entries"]}
    entries: list[dict] = []
    for card_id in range(102):
        row_index, row = source_rows[card_id]
        source_text = row[1]
        spec = translations[str(card_id)]
        expected_source = str(spec.get("source", ""))
        translation = str(spec.get("translation", ""))
        if expected_source != source_text:
            raise ValueError(
                f"Arcomage source drift at ID {card_id}: expected {expected_source!r}, got {source_text!r}"
            )
        status = "translated" if translation else "untranslated"
        key = f"engine:arcomage_cards.txt:{card_id}:Name"
        if key in existing_keys:
            raise ValueError(f"Duplicate catalog key: {key}")
        entry = {
            "key": key,
            "scope": "engine",
            "source_file": source_relpath,
            "record_id": card_id,
            "field": "Name",
            "source": source_text,
            "translation": translation,
            "translation_origin": "override" if translation else "none",
            "status": status,
            "placeholder_ok": True,
            "note": "OpenYAMM runtime-only Arcomage card name; no MMMerge Korean source asset exists.",
        }
        if status == "translated":
            output_rows[row_index][1] = translation
        entries.append(entry)

    output_path = overlay_root / Path(source_relpath).relative_to("assets_dev/engine")
    write_tsv(output_path, output_rows)
    catalog["entries"].extend(entries)
    catalog["tables"].append({
        "overlay_source": translation_path.relative_to(repo_root).as_posix(),
        "overlay_format": "OpenYAMM-only audited card-name map by runtime ID",
        "source_file": source_relpath,
        "source_sha256": sha256_file(source_path),
        "source_encoding": source_encoding,
        "translation_sha256": sha256_file(translation_path),
        "entries": len(entries),
        "translated": sum(1 for entry in entries if entry["status"] == "translated"),
        "untranslated": sum(1 for entry in entries if entry["status"] == "untranslated"),
        "placeholder_mismatches": 0,
        "overrides": sum(1 for entry in entries if entry["translation_origin"] == "override"),
        "excluded": 0,
        "output_file": output_path.relative_to(repo_root).as_posix(),
        "output_encoding": "utf-8",
    })
    catalog["format"] = max(int(catalog.get("format", 1)), 11)
    refresh_summary(catalog)
    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(json.dumps(catalog["summary"], ensure_ascii=False))
    print(
        f"arcomage_cards.txt: {sum(1 for e in entries if e['status'] == 'translated')}/{len(entries)} translated, "
        f"{sum(1 for e in entries if e['status'] == 'untranslated')} untranslated"
    )

    if args.fail_on_review and (
        catalog["summary"]["untranslated"] or catalog["summary"]["needs_review"]
    ):
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
