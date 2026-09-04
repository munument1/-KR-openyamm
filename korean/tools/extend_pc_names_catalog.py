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


def read_tsv(path: Path, encodings: tuple[str, ...]) -> tuple[list[list[str]], str]:
    raw = path.read_bytes()
    for encoding in encodings:
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


def build_reviewed_npc_name_reuse(
    english_rows: list[list[str]],
    korean_rows: list[list[str]],
    pc_sources: set[str],
) -> dict[str, str]:
    if not english_rows or english_rows[0][:2] != ["Male", "Female"]:
        raise ValueError("Unexpected English NPC-name header")
    if not korean_rows or korean_rows[0][:2] != ["Male", "Female"]:
        raise ValueError("Unexpected Korean NPC-name header")

    if len(english_rows) not in (len(korean_rows), len(korean_rows) + 1):
        raise ValueError(
            f"NPC name row count mismatch: English={len(english_rows)} Korean={len(korean_rows)}"
        )
    if len(english_rows) == len(korean_rows) + 1:
        trailing = english_rows[-1][0].strip() if english_rows[-1] else ""
        if trailing != "Zyggie":
            raise ValueError(f"Unexpected unmatched English NPC-name row: {english_rows[-1]!r}")

    candidates: dict[str, set[str]] = {}
    for english_row, korean_row in zip(english_rows[1:], korean_rows[1:]):
        for column in (0, 1):
            source = english_row[column].strip() if column < len(english_row) else ""
            translation = korean_row[column].strip() if column < len(korean_row) else ""
            if not source or source not in pc_sources or not translation:
                continue
            candidates.setdefault(source, set()).add(translation)

    conflicts = {
        source: sorted(values)
        for source, values in candidates.items()
        if len(values) != 1
    }
    if conflicts:
        raise ValueError(f"Conflicting reviewed NPC-name reuse candidates: {conflicts}")

    reused = {source: next(iter(values)) for source, values in candidates.items()}
    if len(reused) != 543:
        raise ValueError(f"Reviewed NPC-name reuse count drift: expected 543, got {len(reused)}")
    return reused


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", default=None)
    parser.add_argument("--mmmerge-root", required=True)
    parser.add_argument("--catalog", default="korean/translations/catalog.json")
    parser.add_argument("--inventory", default="korean/translations/pc_names_inventory.json")
    parser.add_argument(
        "--direct-translations",
        default="korean/translations/pc_names_direct_reviewed.json",
    )
    parser.add_argument("--overlay-engine-root", default="korean/overlay/engine")
    parser.add_argument("--fail-on-review", action="store_true")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    mmmerge_root = Path(args.mmmerge_root).resolve()
    catalog_path = repo_root / args.catalog
    inventory_path = repo_root / args.inventory
    direct_path = repo_root / args.direct_translations
    source_relpath = "assets_dev/engine/data_tables/english/pc_names.txt"
    source_path = repo_root / source_relpath
    npc_source_path = repo_root / "assets_dev/engine/data_tables/npc_names.txt"
    ko_npc_names_path = mmmerge_root / "Data" / "Text localization" / "KO_NPCNames.txt"
    overlay_root = repo_root / args.overlay_engine_root

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    inventory = json.loads(inventory_path.read_text(encoding="utf-8"))
    direct_payload = json.loads(direct_path.read_text(encoding="utf-8"))

    if inventory.get("source_file") != source_relpath:
        raise ValueError("PC name inventory source path mismatch")
    if direct_payload.get("source_file") != source_relpath:
        raise ValueError("PC name direct-translation source path mismatch")
    if direct_payload.get("review_status") != "reviewed":
        raise ValueError("PC name direct-translation set has not passed review")

    inventory_entries = inventory.get("entries", [])
    unique_sources = inventory.get("unique_sources", [])
    if len(inventory_entries) != int(inventory.get("entry_count", -1)):
        raise ValueError("PC name inventory entry count mismatch")
    if len(unique_sources) != int(inventory.get("unique_source_count", -1)):
        raise ValueError("PC name inventory unique-source count mismatch")
    if len(set(unique_sources)) != len(unique_sources):
        raise ValueError("PC name inventory contains duplicate unique_sources")
    if len(inventory_entries) != 1073 or len(unique_sources) != 814:
        raise ValueError(
            f"PC name inventory count drift: cells={len(inventory_entries)}, unique={len(unique_sources)}"
        )

    source_set = set(unique_sources)
    direct_entries = direct_payload.get("entries", {})
    for source, spec in direct_entries.items():
        if source not in source_set:
            raise ValueError(f"Direct PC name is not present in active source inventory: {source!r}")
        if not spec.get("reviewed"):
            raise ValueError(f"Direct PC name is not marked reviewed: {source!r}")
        if str(spec.get("source", source)) != source:
            raise ValueError(f"Direct PC name source mismatch: {source!r}")
        if not str(spec.get("translation", "")).strip():
            raise ValueError(f"Direct PC name translation is empty: {source!r}")

    npc_source_rows, npc_source_encoding = read_tsv(npc_source_path, ("utf-8-sig", "cp1252"))
    ko_npc_rows, ko_npc_encoding = read_tsv(ko_npc_names_path, ("utf-8-sig", "cp949"))
    reused = build_reviewed_npc_name_reuse(npc_source_rows, ko_npc_rows, source_set)

    direct_set = set(direct_entries)
    expected_direct_set = source_set - set(reused)
    if direct_set != expected_direct_set:
        missing = sorted(expected_direct_set - direct_set)
        extra = sorted(direct_set - expected_direct_set)
        raise ValueError(
            f"Direct PC-name review coverage mismatch: missing={missing}, extra={extra}"
        )
    if len(direct_entries) != 271:
        raise ValueError(f"Direct PC-name review count drift: expected 271, got {len(direct_entries)}")

    translations = dict(reused)
    origins = {source: "verified_npc_name_reuse" for source in reused}
    for source, spec in direct_entries.items():
        translations[source] = str(spec["translation"]).strip()
        origins[source] = "reviewed_direct"

    if set(translations) != source_set or len(translations) != 814:
        missing = sorted(source_set - set(translations))
        raise ValueError(f"PC name translation coverage incomplete: {missing}")

    rows, source_encoding = read_tsv(source_path, ("utf-8-sig", "cp1252"))
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
                f"PC name source drift at row={row_index}, column={column}: "
                f"expected {source!r}, got {active_source!r}"
            )

        translation = translations[source]
        output_rows[row_index][column] = translation
        key = f"engine:pc_names.txt:{row_index}:{column}:{category}"
        if key in existing_keys:
            raise ValueError(f"Duplicate catalog key: {key}")
        existing_keys.add(key)

        origin = origins[source]
        note = (
            "OpenYAMM-only character-creation name; directly transliterated to Korean and reviewed."
            if origin == "reviewed_direct"
            else "Character-creation name; exact English match reuses the reviewed Korean NPC-name transliteration."
        )
        added.append(
            {
                "key": key,
                "scope": "engine",
                "source_file": source_relpath,
                "record_id": row_index,
                "field": category,
                "source": source,
                "translation": translation,
                "translation_origin": origin,
                "status": "translated",
                "placeholder_ok": True,
                "note": note,
            }
        )

    if len(added) != 1073:
        raise ValueError(f"PC name imported entry count mismatch: {len(added)}")

    output_path = overlay_root / Path(source_relpath).relative_to("assets_dev/engine")
    write_tsv(output_path, output_rows)

    catalog["entries"].extend(added)
    catalog["tables"].append(
        {
            "overlay_source": direct_path.relative_to(repo_root).as_posix(),
            "overlay_format": "reviewed direct names plus exact reviewed MMMerge NPC-name reuse",
            "source_file": source_relpath,
            "source_sha256": sha256_file(source_path),
            "source_encoding": source_encoding,
            "npc_source_sha256": sha256_file(npc_source_path),
            "npc_source_encoding": npc_source_encoding,
            "mmmerge_npc_names_sha256": sha256_file(ko_npc_names_path),
            "mmmerge_npc_names_encoding": ko_npc_encoding,
            "direct_translation_sha256": sha256_file(direct_path),
            "inventory_sha256": sha256_file(inventory_path),
            "reviewed_reuse_unique_names": len(reused),
            "reviewed_direct_unique_names": len(direct_entries),
            "reviewed_unique_names": len(translations),
            "entries": len(added),
            "translated": len(added),
            "untranslated": 0,
            "placeholder_mismatches": 0,
            "overrides": 0,
            "excluded": 0,
            "output_file": output_path.relative_to(repo_root).as_posix(),
            "output_encoding": "utf-8",
        }
    )
    catalog["format"] = max(int(catalog.get("format", 1)), 12)
    refresh_summary(catalog)
    catalog_path.write_text(
        json.dumps(catalog, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    print(json.dumps(catalog["summary"], ensure_ascii=False))
    print(
        f"pc_names.txt: {len(added)}/{len(added)} translated from "
        f"{len(translations)} reviewed unique source names "
        f"({len(reused)} reused, {len(direct_entries)} direct)"
    )

    if args.fail_on_review and (
        catalog["summary"]["untranslated"] or catalog["summary"]["needs_review"]
    ):
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
