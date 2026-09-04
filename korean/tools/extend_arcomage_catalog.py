#!/usr/bin/env python3
"""Import reviewed Korean Arcomage card names into the translation catalog."""

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
    parser.add_argument("--translations", default="korean/translations/arcomage_card_names.json")
    parser.add_argument("--overlay-engine-root", default="korean/overlay/engine")
    parser.add_argument("--fail-on-review", action="store_true")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    catalog_path = repo_root / args.catalog
    translation_path = repo_root / args.translations
    source_relpath = "assets_dev/engine/data_tables/arcomage_cards.txt"
    source_path = repo_root / source_relpath
    overlay_root = repo_root / args.overlay_engine_root

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    payload = json.loads(translation_path.read_text(encoding="utf-8"))
    if payload.get("review_status") != "reviewed":
        raise ValueError("Arcomage translation set has not passed review")

    translations = payload.get("entries", {})
    expected_ids = set(range(102))
    translation_ids = {int(key) for key in translations}
    if translation_ids != expected_ids:
        raise ValueError(f"Arcomage translation ID mismatch: missing={sorted(expected_ids - translation_ids)}, extra={sorted(translation_ids - expected_ids)}")

    rows, source_encoding = read_tsv(source_path)
    output_rows = [list(row) for row in rows]
    source_rows: dict[int, tuple[int, list[str]]] = {}
    for row_index, row in enumerate(rows[1:], start=1):
        if len(row) >= 2 and row[0].strip().isdigit():
            source_rows[int(row[0].strip())] = (row_index, row)
    if set(source_rows) != expected_ids:
        raise ValueError(f"Arcomage source ID mismatch: missing={sorted(expected_ids - set(source_rows))}, extra={sorted(set(source_rows) - expected_ids)}")

    existing_keys = {entry["key"] for entry in catalog["entries"]}
    added: list[dict] = []
    for card_id in range(102):
        row_index, row = source_rows[card_id]
        source_text = row[1]
        spec = translations[str(card_id)]
        if not spec.get("reviewed"):
            raise ValueError(f"Arcomage card {card_id} is not marked reviewed")
        if spec.get("source") != source_text:
            raise ValueError(f"Arcomage source drift at ID {card_id}: expected {spec.get('source')!r}, got {source_text!r}")
        translation = str(spec.get("translation", "")).strip()
        status = "translated" if translation else "untranslated"
        key = f"engine:arcomage_cards.txt:{card_id}:Name"
        if key in existing_keys:
            raise ValueError(f"Duplicate catalog key: {key}")
        if translation:
            output_rows[row_index][1] = translation
        added.append({
            "key": key,
            "scope": "engine",
            "source_file": source_relpath,
            "record_id": card_id,
            "field": "Name",
            "source": source_text,
            "translation": translation,
            "translation_origin": "reviewed_direct",
            "status": status,
            "placeholder_ok": True,
            "note": "OpenYAMM-only Arcomage card name; directly translated and context-reviewed against card effects.",
        })

    output_path = overlay_root / Path(source_relpath).relative_to("assets_dev/engine")
    write_tsv(output_path, output_rows)
    catalog["entries"].extend(added)
    catalog["tables"].append({
        "overlay_source": translation_path.relative_to(repo_root).as_posix(),
        "overlay_format": "reviewed direct translation map by Arcomage runtime card ID",
        "source_file": source_relpath,
        "source_sha256": sha256_file(source_path),
        "source_encoding": source_encoding,
        "translation_sha256": sha256_file(translation_path),
        "entries": len(added),
        "translated": sum(e["status"] == "translated" for e in added),
        "untranslated": sum(e["status"] == "untranslated" for e in added),
        "placeholder_mismatches": 0,
        "overrides": 0,
        "excluded": 0,
        "output_file": output_path.relative_to(repo_root).as_posix(),
        "output_encoding": "utf-8",
    })
    catalog["format"] = max(int(catalog.get("format", 1)), 11)
    refresh_summary(catalog)
    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    translated = sum(e["status"] == "translated" for e in added)
    untranslated = sum(e["status"] == "untranslated" for e in added)
    print(json.dumps(catalog["summary"], ensure_ascii=False))
    print(f"arcomage_cards.txt: {translated}/{len(added)} translated, {untranslated} untranslated")

    if args.fail_on_review and (catalog["summary"]["untranslated"] or catalog["summary"]["needs_review"]):
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
