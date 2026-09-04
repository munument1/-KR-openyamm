#!/usr/bin/env python3
"""Import reviewed Korean stat and skill inspect text while preserving English logic keys."""

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


def append_entry(catalog: dict, existing_keys: set[str], *, key: str, source_file: str,
                 record_id: str, field: str, source: str, translation: str) -> None:
    if key in existing_keys:
        raise ValueError(f"Duplicate catalog key: {key}")
    if not translation.strip():
        raise ValueError(f"Empty reviewed translation: {key}")
    existing_keys.add(key)
    catalog["entries"].append({
        "key": key,
        "scope": "engine",
        "source_file": source_file,
        "record_id": record_id,
        "field": field,
        "source": source,
        "translation": translation,
        "translation_origin": "reviewed_direct",
        "status": "translated",
        "placeholder_ok": True,
        "note": "Direct Korean translation reviewed against the active OpenYAMM source and MMMerge terminology.",
    })


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", default=None)
    parser.add_argument("--catalog", default="korean/translations/catalog.json")
    parser.add_argument("--translations", default="korean/translations/stats_skills_reviewed.json")
    parser.add_argument("--overlay-engine-root", default="korean/overlay/engine")
    parser.add_argument("--fail-on-review", action="store_true")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    catalog_path = repo_root / args.catalog
    translation_path = repo_root / args.translations
    overlay_root = repo_root / args.overlay_engine_root

    stats_relpath = "assets_dev/engine/data_tables/english/stats.txt"
    skills_relpath = "assets_dev/engine/data_tables/english/skill_des.txt"
    stats_path = repo_root / stats_relpath
    skills_path = repo_root / skills_relpath

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    payload = json.loads(translation_path.read_text(encoding="utf-8"))
    if payload.get("review_status") != "reviewed":
        raise ValueError("Stats/skills translation set has not passed review")

    stats_spec = payload.get("stats", {})
    skills_spec = payload.get("skills", {})
    stats_rows, stats_encoding = read_tsv(stats_path)
    skills_rows, skills_encoding = read_tsv(skills_path)

    stats_source = {row[0].strip(): row for row in stats_rows[1:] if len(row) >= 2 and row[0].strip()}
    skills_source = {row[0].strip(): row for row in skills_rows[1:] if len(row) >= 6 and row[0].strip()}
    if set(stats_spec) != set(stats_source):
        raise ValueError(
            f"stats key mismatch: missing={sorted(set(stats_source) - set(stats_spec))}, "
            f"extra={sorted(set(stats_spec) - set(stats_source))}"
        )
    if set(skills_spec) != set(skills_source):
        raise ValueError(
            f"skill key mismatch: missing={sorted(set(skills_source) - set(skills_spec))}, "
            f"extra={sorted(set(skills_spec) - set(skills_source))}"
        )

    existing_keys = {entry["key"] for entry in catalog["entries"]}

    stats_output = [list(row) for row in stats_rows]
    while len(stats_output[0]) < 3:
        stats_output[0].append("")
    stats_output[0][2] = "LocalizedName"
    stats_added_before = len(catalog["entries"])
    for row_index, row in enumerate(stats_rows[1:], start=1):
        if len(row) < 2 or not row[0].strip():
            continue
        source_name = row[0].strip()
        source_description = row[1].strip()
        spec = stats_spec[source_name]
        display_name = str(spec["display_name"]).strip()
        description = str(spec["description"]).strip()
        while len(stats_output[row_index]) < 3:
            stats_output[row_index].append("")
        # Column 0 remains the stable English lookup key.
        stats_output[row_index][1] = description
        stats_output[row_index][2] = display_name
        record_key = source_name.replace(" ", "_")
        append_entry(
            catalog, existing_keys,
            key=f"engine:english/stats.txt:{record_key}:Description",
            source_file=stats_relpath, record_id=source_name, field="Description",
            source=source_description, translation=description,
        )
        append_entry(
            catalog, existing_keys,
            key=f"engine:english/stats.txt:{record_key}:DisplayName",
            source_file=stats_relpath, record_id=source_name, field="DisplayName",
            source=source_name, translation=display_name,
        )
    stats_added = len(catalog["entries"]) - stats_added_before

    skills_output = [list(row) for row in skills_rows]
    while len(skills_output[0]) < 7:
        skills_output[0].append("")
    skills_output[0][6] = "LocalizedName"
    field_specs = [
        (1, "Description", "description"),
        (2, "Normal", "normal"),
        (3, "Expert", "expert"),
        (4, "Master", "master"),
        (5, "GrandMaster", "grandmaster"),
    ]
    skills_added_before = len(catalog["entries"])
    for row_index, row in enumerate(skills_rows[1:], start=1):
        if len(row) < 6 or not row[0].strip():
            continue
        source_name = row[0].strip()
        spec = skills_spec[source_name]
        while len(skills_output[row_index]) < 7:
            skills_output[row_index].append("")
        # Column 0 remains the stable English canonical skill key.
        for column_index, field_name, spec_key in field_specs:
            translation = str(spec[spec_key]).strip()
            source_text = row[column_index].strip()
            skills_output[row_index][column_index] = translation
            append_entry(
                catalog, existing_keys,
                key=f"engine:english/skill_des.txt:{source_name.replace(' ', '_')}:{field_name}",
                source_file=skills_relpath, record_id=source_name, field=field_name,
                source=source_text, translation=translation,
            )
        display_name = str(spec["display_name"]).strip()
        skills_output[row_index][6] = display_name
        append_entry(
            catalog, existing_keys,
            key=f"engine:english/skill_des.txt:{source_name.replace(' ', '_')}:DisplayName",
            source_file=skills_relpath, record_id=source_name, field="DisplayName",
            source=source_name, translation=display_name,
        )
    skills_added = len(catalog["entries"]) - skills_added_before

    stats_output_path = overlay_root / Path(stats_relpath).relative_to("assets_dev/engine")
    skills_output_path = overlay_root / Path(skills_relpath).relative_to("assets_dev/engine")
    write_tsv(stats_output_path, stats_output)
    write_tsv(skills_output_path, skills_output)

    catalog["tables"].append({
        "overlay_source": translation_path.relative_to(repo_root).as_posix(),
        "overlay_format": "reviewed direct translation; English stat key preserved, LocalizedName appended",
        "source_file": stats_relpath,
        "source_sha256": sha256_file(stats_path),
        "source_encoding": stats_encoding,
        "translation_sha256": sha256_file(translation_path),
        "entries": stats_added,
        "translated": stats_added,
        "untranslated": 0,
        "placeholder_mismatches": 0,
        "overrides": 0,
        "excluded": 0,
        "output_file": stats_output_path.relative_to(repo_root).as_posix(),
        "output_encoding": "utf-8",
    })
    catalog["tables"].append({
        "overlay_source": translation_path.relative_to(repo_root).as_posix(),
        "overlay_format": "reviewed direct translation; English skill key preserved, LocalizedName appended",
        "source_file": skills_relpath,
        "source_sha256": sha256_file(skills_path),
        "source_encoding": skills_encoding,
        "translation_sha256": sha256_file(translation_path),
        "entries": skills_added,
        "translated": skills_added,
        "untranslated": 0,
        "placeholder_mismatches": 0,
        "overrides": 0,
        "excluded": 0,
        "output_file": skills_output_path.relative_to(repo_root).as_posix(),
        "output_encoding": "utf-8",
    })

    catalog["format"] = max(int(catalog.get("format", 1)), 13)
    refresh_summary(catalog)
    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(json.dumps(catalog["summary"], ensure_ascii=False))
    print(f"stats.txt: {stats_added}/{stats_added} translated")
    print(f"skill_des.txt: {skills_added}/{skills_added} translated")

    if args.fail_on_review and (catalog["summary"]["untranslated"] or catalog["summary"]["needs_review"]):
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
