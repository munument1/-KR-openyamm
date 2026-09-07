#!/usr/bin/env python3
"""Add reviewed Korean decoration display hints to the translation catalog.

The source decoration Hint field is intentionally left in English because OpenYAMM
also consumes it as a gameplay classification key. Korean text is applied only at
the runtime display boundary.
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
            pass
    raise ValueError(f"Could not decode {path}")


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
    parser.add_argument("--translations", default="korean/translations/decoration_hints.json")
    parser.add_argument("--fail-on-review", action="store_true")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    catalog_path = repo_root / args.catalog
    translation_path = repo_root / args.translations
    runtime_header_relpath = "game/ui/KoreanDecorationText.h"
    runtime_header_path = repo_root / runtime_header_relpath
    source_relpath = "assets_dev/engine/data_tables/decoration_data.txt"
    source_path = repo_root / source_relpath

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    payload = json.loads(translation_path.read_text(encoding="utf-8"))
    if payload.get("review_status") != "reviewed":
        raise ValueError("Decoration hint translation set has not passed review")

    translations = {str(key).strip().casefold(): str(value).strip() for key, value in payload.get("entries", {}).items()}
    excluded_sources = {str(value).strip().casefold() for value in payload.get("excluded_sources", [])}
    overlap = set(translations) & excluded_sources
    if overlap:
        raise ValueError(f"Decoration sources cannot be both translated and excluded: {sorted(overlap)}")

    runtime_header = runtime_header_path.read_text(encoding="utf-8")
    for source_text, translation in translations.items():
        expected = f'{{"{source_text}", "{translation}"}}'
        if expected not in runtime_header:
            raise ValueError(f"Runtime decoration translation is missing: {expected}")

    rows, source_encoding = read_tsv(source_path)
    added: list[dict] = []
    excluded_count = 0
    unknown_sources: set[str] = set()
    existing_keys = {entry["key"] for entry in catalog["entries"]}

    for row in rows:
        if len(row) < 3 or not row[0].strip().isdigit():
            continue

        record_id = int(row[0].strip())
        source_text = row[2].strip()
        normalized = source_text.casefold()
        if not source_text or normalized in excluded_sources:
            excluded_count += 1
            continue

        translation = translations.get(normalized)
        if translation is None:
            unknown_sources.add(source_text)
            continue

        key = f"engine:decoration_data.txt:{record_id}:Hint"
        if key in existing_keys:
            raise ValueError(f"Duplicate catalog key: {key}")
        existing_keys.add(key)
        added.append({
            "key": key,
            "scope": "engine",
            "source_file": source_relpath,
            "record_id": record_id,
            "field": "Hint",
            "source": source_text,
            "translation": translation,
            "translation_origin": "reviewed_runtime_display",
            "status": "translated",
            "placeholder_ok": True,
            "note": "Decoration display hint localized at the runtime UI boundary; the source Hint remains English because gameplay logic also consumes it.",
        })

    if unknown_sources:
        raise ValueError("Unmapped decoration Hint value(s): " + ", ".join(sorted(unknown_sources, key=str.casefold)))

    catalog["entries"].extend(added)
    catalog["tables"].append({
        "overlay_source": translation_path.relative_to(repo_root).as_posix(),
        "overlay_format": "reviewed runtime display translation map by decoration Hint value",
        "source_file": source_relpath,
        "source_sha256": sha256_file(source_path),
        "source_encoding": source_encoding,
        "translation_sha256": sha256_file(translation_path),
        "entries": len(added),
        "translated": len(added),
        "untranslated": 0,
        "placeholder_mismatches": 0,
        "overrides": 0,
        "excluded": excluded_count,
        "output_file": runtime_header_relpath,
        "output_encoding": "utf-8",
    })
    catalog["format"] = max(int(catalog.get("format", 1)), 12)
    refresh_summary(catalog)
    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(json.dumps(catalog["summary"], ensure_ascii=False))
    print(f"decoration_data.txt: {len(added)} runtime-display translations, 0 untranslated, {excluded_count} excluded")
    if args.fail_on_review and (catalog["summary"]["untranslated"] or catalog["summary"]["needs_review"]):
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
