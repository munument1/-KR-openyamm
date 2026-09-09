#!/usr/bin/env python3
"""Export/import OpenYAMM's generated Korean catalog as gettext PO.

PO is an editing surface, not a runtime file format. Stable catalog keys are
stored in msgctxt, English source text in msgid, and Korean text in msgstr.
When importing, changed PO entries are materialized back into the native TSV,
Lua, or runtime-display overlay that OpenYAMM actually loads.
"""

from __future__ import annotations

import argparse
import ast
import csv
import io
import json
from collections import Counter
from pathlib import Path
import re
from typing import Iterable

PRINTF_TOKEN_RE = re.compile(
    r"%(?:\d+\$)?\d*(?:\.\d+)?(?:hh|h|ll|l|j|z|t|L)?[diuoxXfFeEgGaAcsn]"
)
LEGACY_NUMERIC_TOKEN_RE = re.compile(r"%\d+(?![A-Za-z$])")

FIELD_COLUMN_OVERRIDES: dict[tuple[str, str], int] = {
    ("global.txt", "text"): 1,
    ("quests.txt", "text"): 1,
    ("autonote.txt", "text"): 1,
    ("spells.txt", "shortname"): 4,
    ("spells.txt", "description"): 5,
    ("spells.txt", "normal"): 6,
    ("spells.txt", "expert"): 7,
    ("spells.txt", "master"): 8,
    ("spells.txt", "grandmaster"): 9,
    ("items.txt", "name"): 2,
    ("items.txt", "notidentifiedname"): 10,
    ("items.txt", "notes"): 16,
    ("npc.txt", "name"): 1,
    ("npc_greet.txt", "greeting1"): 1,
    ("npc_greet.txt", "greeting2"): 2,
    ("npc_topic.txt", "topic"): 1,
    ("npc_topic_text.txt", "text"): 1,
    ("npc_news.txt", "text"): 1,
    ("npc_professions.txt", "name"): 1,
    ("map_stats.txt", "name"): 1,
    ("monster_data.txt", "name"): 1,
    ("awards.txt", "awards"): 1,
    ("trans.txt", "description"): 1,
    ("mm7_history.txt", "text"): 1,
    ("mm7_history.txt", "pagetitle"): 3,
    ("history.txt", "text"): 1,
    ("history.txt", "pagetitle"): 3,
}


def placeholder_tokens(text: str) -> Counter[str]:
    result = Counter(PRINTF_TOKEN_RE.findall(text))
    result.update(LEGACY_NUMERIC_TOKEN_RE.findall(text))
    return result


def po_quote(text: str) -> str:
    return json.dumps(text, ensure_ascii=False)


def export_catalog(catalog: dict) -> str:
    lines = [
        '# OpenYAMM Korean translation catalog',
        'msgid ""',
        'msgstr "Project-Id-Version: OpenYAMM Korean\\nLanguage: ko\\nMIME-Version: 1.0\\nContent-Type: text/plain; charset=UTF-8\\nContent-Transfer-Encoding: 8bit\\n"',
        "",
    ]
    for entry in sorted(catalog.get("entries", []), key=lambda value: value["key"]):
        key = str(entry["key"])
        source = str(entry.get("source", ""))
        translation = str(entry.get("translation", ""))
        source_file = str(entry.get("source_file", ""))
        record_id = entry.get("record_id", "")
        field = str(entry.get("field", ""))
        status = str(entry.get("status", ""))
        lines.append(f"#. {source_file} record={record_id} field={field} status={status}")
        lines.append(f"msgctxt {po_quote(key)}")
        lines.append(f"msgid {po_quote(source)}")
        lines.append(f"msgstr {po_quote(translation)}")
        lines.append("")
    return "\n".join(lines)


def parse_po_quoted(raw: str) -> str:
    value = ast.literal_eval(raw.strip())
    if not isinstance(value, str):
        raise ValueError(f"PO string is not text: {raw!r}")
    return value


def parse_po(text: str) -> list[dict[str, str]]:
    entries: list[dict[str, str]] = []
    current: dict[str, str] = {}
    active_field: str | None = None

    def flush() -> None:
        nonlocal current, active_field
        if current.get("msgctxt"):
            entries.append(current)
        current = {}
        active_field = None

    for line_number, raw_line in enumerate(text.splitlines(), start=1):
        line = raw_line.strip()
        if not line:
            flush()
            continue
        if line.startswith("#"):
            continue
        if line.startswith("msgid_plural") or line.startswith("msgstr["):
            raise ValueError(f"Plural PO entries are not supported (line {line_number})")
        matched = False
        for field in ("msgctxt", "msgid", "msgstr"):
            prefix = field + " "
            if line.startswith(prefix):
                current[field] = parse_po_quoted(line[len(prefix):])
                active_field = field
                matched = True
                break
        if matched:
            continue
        if line.startswith('"'):
            if active_field is None:
                raise ValueError(f"PO continuation without a field on line {line_number}")
            current[active_field] = current.get(active_field, "") + parse_po_quoted(line)
            continue
        raise ValueError(f"Unsupported PO syntax on line {line_number}: {raw_line}")
    flush()
    return entries


def read_tsv(path: Path) -> list[list[str]]:
    text = path.read_text(encoding="utf-8-sig")
    return list(csv.reader(io.StringIO(text, newline=""), delimiter="\t", quotechar='"'))


def write_tsv(path: Path, rows: Iterable[list[str]]) -> None:
    with path.open("w", encoding="utf-8", newline="") as stream:
        writer = csv.writer(
            stream,
            delimiter="\t",
            quotechar='"',
            quoting=csv.QUOTE_MINIMAL,
            lineterminator="\n",
        )
        writer.writerows(rows)


def row_lookup(rows: list[list[str]]) -> dict[int, int]:
    result: dict[int, int] = {}
    for index, row in enumerate(rows):
        if row and row[0].strip().isdigit():
            result[int(row[0].strip())] = index
    return result


def find_field_column(rows: list[list[str]], source_name: str, field_name: str) -> int | None:
    source_key = source_name.casefold()
    field_key = field_name.casefold()
    override = FIELD_COLUMN_OVERRIDES.get((source_key, field_key))
    if override is not None:
        return override
    if rows:
        normalized_header = [cell.strip().casefold() for cell in rows[0]]
        if field_key in normalized_header:
            return normalized_header.index(field_key)
    if field_key == "text" and rows and max((len(row) for row in rows), default=0) == 2:
        return 1
    return None


def lua_quoted(text: str) -> str:
    escaped = (
        text.replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\n", "\\n")
        .replace("\r", "\\r")
        .replace("\t", "\\t")
    )
    return '"' + escaped + '"'


def materialize_decoration_header(repo_root: Path, entry: dict, translation: str) -> None:
    header_path = repo_root / "game/ui/KoreanDecorationText.h"
    text = header_path.read_text(encoding="utf-8")
    source = str(entry["source"]).strip().casefold()
    old_translation = str(entry.get("translation", ""))
    old_literal = f'{{"{source}", "{old_translation}"}}'
    new_literal = f'{{"{source}", "{translation}"}}'
    if old_literal not in text:
        raise ValueError(f"Decoration runtime mapping was not found for {entry['key']}")
    header_path.write_text(text.replace(old_literal, new_literal), encoding="utf-8", newline="\n")


def infer_engine_output(repo_root: Path, entry: dict) -> Path:
    source_path = Path(str(entry["source_file"]))
    prefix = Path("assets_dev/engine")
    try:
        relative = source_path.relative_to(prefix)
    except ValueError as error:
        raise ValueError(f"Unsupported engine PO target for {entry['key']}: {source_path}") from error
    return repo_root / "korean/overlay/engine" / relative


def materialize_engine_tsv(repo_root: Path, entry: dict, translation: str) -> None:
    output_path = infer_engine_output(repo_root, entry)
    if not output_path.is_file():
        raise ValueError(f"Runtime overlay does not exist for PO entry {entry['key']}: {output_path}")
    rows = read_tsv(output_path)
    lookup = row_lookup(rows)
    try:
        record_id = int(entry["record_id"])
    except (TypeError, ValueError) as error:
        raise ValueError(f"PO entry has a non-numeric runtime row: {entry['key']}") from error
    if record_id not in lookup:
        raise ValueError(f"Runtime row {record_id} missing for PO entry {entry['key']}")
    column = find_field_column(rows, Path(str(entry["source_file"])).name, str(entry["field"]))
    if column is None:
        raise ValueError(f"No TSV field mapping for PO entry {entry['key']}")
    row = rows[lookup[record_id]]
    if column >= len(row):
        raise ValueError(f"Runtime column missing for PO entry {entry['key']}")
    row[column] = translation
    write_tsv(output_path, rows)


def materialize_world_lua(repo_root: Path, entry: dict, translation: str) -> None:
    key_parts = str(entry["key"]).split(":", 3)
    if len(key_parts) != 4 or key_parts[0] != "world":
        raise ValueError(f"Malformed world PO key: {entry['key']}")
    world_id = key_parts[1]
    map_file = key_parts[2]
    lua_name = Path(map_file).stem.lower() + ".lua"
    output_path = repo_root / "korean/overlay/worlds" / world_id / "events/maps" / lua_name
    if not output_path.is_file():
        raise ValueError(f"World runtime Lua missing for PO entry {entry['key']}: {output_path}")
    text = output_path.read_text(encoding="utf-8")
    old_literal = lua_quoted(str(entry.get("translation", "")))
    new_literal = lua_quoted(translation)
    occurrence_count = text.count(old_literal)
    if occurrence_count == 0:
        raise ValueError(f"Current translated Lua literal missing for PO entry {entry['key']}")
    output_path.write_text(text.replace(old_literal, new_literal), encoding="utf-8", newline="\n")


def materialize_entry(repo_root: Path, entry: dict, translation: str) -> None:
    scope = str(entry.get("scope", ""))
    source_name = Path(str(entry.get("source_file", ""))).name.casefold()
    if scope == "engine" and source_name == "decoration_data.txt":
        materialize_decoration_header(repo_root, entry, translation)
        return
    if scope == "engine":
        materialize_engine_tsv(repo_root, entry, translation)
        return
    if scope.startswith("world:"):
        materialize_world_lua(repo_root, entry, translation)
        return
    raise ValueError(f"Unsupported PO runtime scope for {entry['key']}: {scope}")


def refresh_counts(catalog: dict) -> None:
    entries = catalog["entries"]
    by_source: dict[str, list[dict]] = {}
    for entry in entries:
        by_source.setdefault(str(entry.get("source_file", "")), []).append(entry)
    for table in catalog.get("tables", []):
        source_file = str(table.get("source_file", ""))
        table_entries = by_source.get(source_file)
        if table_entries is None:
            continue
        table["entries"] = len(table_entries)
        table["translated"] = sum(entry.get("status") == "translated" for entry in table_entries)
        table["untranslated"] = sum(entry.get("status") == "untranslated" for entry in table_entries)
        table["placeholder_mismatches"] = sum(entry.get("status") == "needs_review" for entry in table_entries)
        table["overrides"] = sum(entry.get("translation_origin") in {"override", "po"} for entry in table_entries)
    catalog["summary"] = {
        "entries": len(entries),
        "translated": sum(entry.get("status") == "translated" for entry in entries),
        "untranslated": sum(entry.get("status") == "untranslated" for entry in entries),
        "needs_review": sum(entry.get("status") == "needs_review" for entry in entries),
        "overrides": sum(entry.get("translation_origin") in {"override", "po"} for entry in entries),
        "excluded": sum(int(table.get("excluded", 0)) for table in catalog.get("tables", [])),
    }


def import_po(catalog: dict, po_entries: list[dict[str, str]], repo_root: Path | None, apply_runtime: bool) -> int:
    catalog_by_key = {str(entry["key"]): entry for entry in catalog.get("entries", [])}
    seen: set[str] = set()
    changed = 0
    for po_entry in po_entries:
        key = po_entry.get("msgctxt", "")
        if key in seen:
            raise ValueError(f"Duplicate PO context: {key}")
        seen.add(key)
        if key not in catalog_by_key:
            raise ValueError(f"PO context does not match the current catalog: {key}")
        entry = catalog_by_key[key]
        msgid = po_entry.get("msgid", "")
        if msgid != str(entry.get("source", "")):
            raise ValueError(f"Stale PO source text for {key}")
        translation = po_entry.get("msgstr", "")
        if not translation or translation == str(entry.get("translation", "")):
            continue
        if placeholder_tokens(msgid) != placeholder_tokens(translation):
            raise ValueError(f"PO placeholder mismatch for {key}")
        if apply_runtime:
            if repo_root is None:
                raise ValueError("repo_root is required when applying PO translations")
            materialize_entry(repo_root, entry, translation)
        entry["translation"] = translation
        entry["translation_origin"] = "po"
        entry["status"] = "translated"
        entry["placeholder_ok"] = True
        entry["note"] = "Imported from korean/translations/ko.po"
        changed += 1
    refresh_counts(catalog)
    return changed


def main() -> int:
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command", required=True)

    export_parser = subparsers.add_parser("export")
    export_parser.add_argument("--catalog", default="korean/translations/catalog.json")
    export_parser.add_argument("--po", default="korean/translations/ko.po")

    import_parser = subparsers.add_parser("import")
    import_parser.add_argument("--repo-root", default=None)
    import_parser.add_argument("--catalog", default="korean/translations/catalog.json")
    import_parser.add_argument("--po", default="korean/translations/ko.po")
    import_parser.add_argument("--check-only", action="store_true")

    verify_parser = subparsers.add_parser("verify")
    verify_parser.add_argument("--catalog", default="korean/translations/catalog.json")
    verify_parser.add_argument("--po", default="korean/translations/ko.po")

    args = parser.parse_args()
    if args.command == "export":
        catalog_path = Path(args.catalog)
        po_path = Path(args.po)
        catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
        po_path.parent.mkdir(parents=True, exist_ok=True)
        po_path.write_text(export_catalog(catalog), encoding="utf-8", newline="\n")
        print(f"Exported {len(catalog.get('entries', []))} PO entries to {po_path}")
        return 0

    catalog_path = Path(args.catalog)
    po_path = Path(args.po)
    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    po_entries = parse_po(po_path.read_text(encoding="utf-8-sig"))

    if args.command == "verify":
        import_po(catalog, po_entries, None, False)
        missing = len(catalog.get("entries", [])) - len(po_entries)
        if missing:
            raise ValueError(f"PO catalog is missing {missing} context(s)")
        print(f"Verified {len(po_entries)} PO entries against the current catalog")
        return 0

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    changed = import_po(catalog, po_entries, repo_root, not args.check_only)
    if not args.check_only:
        catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"PO import validated {len(po_entries)} entries; changed={changed}; apply_runtime={not args.check_only}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
