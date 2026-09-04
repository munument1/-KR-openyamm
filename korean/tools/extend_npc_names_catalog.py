#!/usr/bin/env python3
"""Append reviewed random NPC names and character-creation names to the Korean catalog."""

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
    parser.add_argument(
        "--direct-overrides",
        default="korean/translations/npc_names_direct_reviewed.json",
    )
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
    direct_path = repo_root / args.direct_overrides

    source_relpath = "assets_dev/engine/data_tables/npc_names.txt"
    source_path = repo_root / source_relpath
    ko_path = mmmerge_root / "Data" / "Text localization" / "KO_NPCNames.txt"

    source_rows, source_encoding = read_tsv(source_path, ("utf-8-sig", "cp1252"))
    ko_rows, ko_encoding = read_tsv(ko_path, ("utf-8-sig", "cp949"))
    direct = json.loads(direct_path.read_text(encoding="utf-8"))

    if direct.get("source_file") != source_relpath or direct.get("review_status") != "reviewed":
        raise ValueError("Random NPC direct-review metadata is invalid")
    direct_entries = direct.get("entries", {})
    if set(direct_entries) != {"Zyggie"}:
        raise ValueError(f"Unexpected direct random-NPC name set: {sorted(direct_entries)}")
    zyggie_spec = direct_entries["Zyggie"]
    if (
        not zyggie_spec.get("reviewed")
        or zyggie_spec.get("source") != "Zyggie"
        or not str(zyggie_spec.get("translation", "")).strip()
    ):
        raise ValueError("Zyggie direct review is incomplete")

    if not source_rows or source_rows[0][:2] != ["Male", "Female"]:
        raise ValueError("Unexpected npc_names.txt header")
    if not ko_rows or ko_rows[0][:2] != ["Male", "Female"]:
        raise ValueError("Unexpected KO_NPCNames.txt header")
    if len(source_rows) != 541 or len(ko_rows) != 540:
        raise ValueError(
            f"Random NPC name row count drift: source={len(source_rows)}, Korean={len(ko_rows)}"
        )
    if not source_rows[-1] or source_rows[-1][0].strip() != "Zyggie":
        raise ValueError(f"Unexpected final random NPC source row: {source_rows[-1]!r}")

    output_rows = [list(row) for row in source_rows]
    entries: list[dict] = []
    translated_from_mmmerge = 0
    translated_direct = 0

    for row_index, source_row in enumerate(source_rows[1:], start=1):
        ko_row = ko_rows[row_index] if row_index < len(ko_rows) else []
        for column, field in ((0, "Male"), (1, "Female")):
            source_text = source_row[column].strip() if column < len(source_row) else ""
            if not source_text:
                continue

            translation = ko_row[column].strip() if column < len(ko_row) else ""
            origin = "mmmerge"
            note = "Random NPC name; row-aligned reviewed MMMerge Korean name."
            if not translation:
                spec = direct_entries.get(source_text)
                if spec:
                    translation = str(spec["translation"]).strip()
                    origin = "reviewed_direct"
                    note = "Random NPC name missing from MMMerge source; directly transliterated and reviewed."
                else:
                    raise ValueError(
                        f"Missing reviewed random NPC name at row={row_index}, column={column}: {source_text!r}"
                    )

            output_rows[row_index][column] = translation
            if origin == "mmmerge":
                translated_from_mmmerge += 1
            else:
                translated_direct += 1

            entries.append(
                {
                    "key": f"engine:npc_names.txt:{row_index}:{column}:{field}",
                    "scope": "engine",
                    "source_file": source_relpath,
                    "record_id": row_index,
                    "field": field,
                    "source": source_text,
                    "translation": translation,
                    "translation_origin": origin,
                    "status": "translated",
                    "placeholder_ok": True,
                    "note": note,
                }
            )

    if len(entries) != 850:
        raise ValueError(f"Random NPC name entry count drift: expected 850, got {len(entries)}")
    if translated_from_mmmerge != 849 or translated_direct != 1:
        raise ValueError(
            f"Random NPC name source count drift: MMMerge={translated_from_mmmerge}, direct={translated_direct}"
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
        "overlay_format": "row-aligned Male/Female columns plus one reviewed direct tail entry",
        "source_file": source_relpath,
        "source_sha256": sha256_file(source_path),
        "source_encoding": source_encoding,
        "mmmerge_sha256": sha256_file(ko_path),
        "mmmerge_encoding": ko_encoding,
        "direct_review_sha256": sha256_file(direct_path),
        "entries": len(entries),
        "translated": len(entries),
        "untranslated": 0,
        "placeholder_mismatches": 0,
        "overrides": 0,
        "reviewed_mmmerge_entries": translated_from_mmmerge,
        "reviewed_direct_entries": translated_direct,
        "output_file": output_path.relative_to(repo_root).as_posix(),
        "output_encoding": "utf-8",
    }
    catalog["entries"].extend(entries)
    catalog["tables"].append(table)
    catalog["format"] = max(int(catalog.get("format", 1)), 12)
    refresh_summary(catalog)
    catalog_path.write_text(
        json.dumps(catalog, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    print(json.dumps(catalog["summary"], ensure_ascii=False))
    print(
        f"npc_names.txt: {len(entries)}/{len(entries)} translated "
        f"({translated_from_mmmerge} MMMerge, {translated_direct} direct)"
    )

    pc_names_command = [
        sys.executable,
        str(repo_root / "korean" / "tools" / "extend_pc_names_catalog.py"),
        "--repo-root",
        str(repo_root),
        "--mmmerge-root",
        str(mmmerge_root),
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
