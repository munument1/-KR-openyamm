#!/usr/bin/env python3
"""Import Korean placed-monster names into the translation catalog."""

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


def read_text(path: Path) -> tuple[str, str]:
    raw = path.read_bytes()
    for encoding in ("utf-8-sig", "cp949", "cp1252"):
        try:
            return raw.decode(encoding), encoding
        except UnicodeDecodeError:
            pass
    raise ValueError(f"Could not decode {path}")


def read_tsv(path: Path) -> tuple[list[list[str]], str]:
    text, encoding = read_text(path)
    rows = list(csv.reader(io.StringIO(text, newline=""), delimiter="\t", quotechar='"'))
    return rows, encoding


def write_tsv(path: Path, rows: list[list[str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as stream:
        csv.writer(
            stream,
            delimiter="\t",
            quotechar='"',
            quoting=csv.QUOTE_MINIMAL,
            lineterminator="\n",
        ).writerows(rows)


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
    parser.add_argument("--mmmerge-root", required=True)
    parser.add_argument("--catalog", default="korean/translations/catalog.json")
    parser.add_argument("--overlay-engine-root", default="korean/overlay/engine")
    parser.add_argument("--fail-on-review", action="store_true")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    mmmerge_root = (repo_root / args.mmmerge_root).resolve()
    catalog_path = repo_root / args.catalog
    source_relpath = "assets_dev/engine/data_tables/english/place_mon.txt"
    source_path = repo_root / source_relpath
    translation_path = mmmerge_root / "Data/Text localization/KO_PlaceMonTxt.txt"
    overlay_root = repo_root / args.overlay_engine_root

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    source_rows, source_encoding = read_tsv(source_path)
    translation_rows, translation_encoding = read_tsv(translation_path)
    output_rows = [list(row) for row in source_rows]

    source_by_id: dict[int, tuple[int, list[str]]] = {}
    for row_index, row in enumerate(source_rows):
        if len(row) >= 2 and row[0].strip().isdigit():
            source_by_id[int(row[0].strip())] = (row_index, row)

    expected_source_ids = set(range(1, 163))
    if set(source_by_id) != expected_source_ids:
        raise ValueError(
            f"place_mon source ID mismatch: missing={sorted(expected_source_ids - set(source_by_id))}, "
            f"extra={sorted(set(source_by_id) - expected_source_ids)}"
        )

    translations: dict[int, str] = {}
    for row in translation_rows:
        if len(row) < 4 or not row[1].strip().isdigit():
            continue
        record_id = int(row[1].strip())
        translations[record_id] = row[3].strip()

    target_ids = set(range(1, 161))
    missing_translation_ids = sorted(record_id for record_id in target_ids if not translations.get(record_id, ""))
    if missing_translation_ids:
        raise ValueError(f"KO_PlaceMonTxt is missing visible IDs: {missing_translation_ids}")

    # 161 and 162 are literal Placeholder rows in the OpenYAMM source and are not player text.
    excluded_ids = {161, 162}
    if source_by_id[161][1][1].strip().lower() != "placeholder" or source_by_id[162][1][1].strip().lower() != "placeholder":
        raise ValueError("place_mon placeholder rows changed; review exclusion policy")

    existing_keys = {entry["key"] for entry in catalog["entries"]}
    added: list[dict] = []
    for record_id in range(1, 161):
        row_index, row = source_by_id[record_id]
        source_text = row[1].strip()
        translation = translations[record_id]
        key = f"engine:english/place_mon.txt:{record_id}:Name"
        if key in existing_keys:
            raise ValueError(f"Duplicate catalog key: {key}")

        output_rows[row_index][1] = translation
        added.append({
            "key": key,
            "scope": "engine",
            "source_file": source_relpath,
            "record_id": record_id,
            "field": "Name",
            "source": source_text,
            "translation": translation,
            "translation_origin": "mmmerge_ko_place_mon",
            "status": "translated",
            "placeholder_ok": True,
            "note": "Imported from MMMerge KO_PlaceMonTxt by stable runtime ID.",
        })

    output_path = overlay_root / Path(source_relpath).relative_to("assets_dev/engine")
    write_tsv(output_path, output_rows)
    catalog["entries"].extend(added)
    catalog["tables"].append({
        "translation_source": translation_path.relative_to(mmmerge_root).as_posix(),
        "translation_format": "MMMerge KO_PlaceMonTxt runtime ID map",
        "source_file": source_relpath,
        "source_sha256": sha256_file(source_path),
        "source_encoding": source_encoding,
        "translation_sha256": sha256_file(translation_path),
        "translation_encoding": translation_encoding,
        "entries": len(added),
        "translated": len(added),
        "untranslated": 0,
        "placeholder_mismatches": 0,
        "overrides": 0,
        "excluded": len(excluded_ids),
        "excluded_ids": sorted(excluded_ids),
        "output_file": output_path.relative_to(repo_root).as_posix(),
        "output_encoding": "utf-8",
    })
    catalog["format"] = max(int(catalog.get("format", 1)), 12)
    refresh_summary(catalog)
    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(json.dumps(catalog["summary"], ensure_ascii=False))
    print(f"place_mon.txt: {len(added)}/{len(added)} translated, 0 untranslated, {len(excluded_ids)} excluded")

    if args.fail_on_review and (catalog["summary"]["untranslated"] or catalog["summary"]["needs_review"]):
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
