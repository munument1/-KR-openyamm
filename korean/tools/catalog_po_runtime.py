#!/usr/bin/env python3
"""Strict runtime routes for gettext PO edits.

The generated Korean catalog uses several different record-id conventions.
This module resolves each catalog entry to the exact native runtime cell or Lua
literal without ever localizing gameplay-key columns.
"""

from __future__ import annotations

import csv
import io
from pathlib import Path
from typing import Iterable

FIELD_COLUMNS: dict[tuple[str, str], int] = {
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
    ("npc_names.txt", "male"): 0,
    ("npc_names.txt", "female"): 1,
    ("npc_greet.txt", "greeting1"): 1,
    ("npc_greet.txt", "greeting2"): 2,
    ("npc_topic.txt", "topic"): 1,
    ("npc_topic_text.txt", "text"): 1,
    ("npc_news.txt", "text"): 1,
    ("npc_professions.txt", "profession"): 1,
    ("map_stats.txt", "name"): 1,
    ("monster_data.txt", "name"): 1,
    ("awards.txt", "awards"): 1,
    ("place_mon.txt", "name"): 1,
    ("scroll.txt", "text"): 1,
    ("stats.txt", "description"): 1,
    ("stats.txt", "displayname"): 2,
    ("skill_des.txt", "description"): 1,
    ("skill_des.txt", "normal"): 2,
    ("skill_des.txt", "expert"): 3,
    ("skill_des.txt", "master"): 4,
    ("skill_des.txt", "grandmaster"): 5,
    ("skill_des.txt", "displayname"): 6,
    ("class.txt", "description"): 1,
    ("class.txt", "name"): 3,
    ("house_data.txt", "name"): 5,
    ("house_data.txt", "proprietorname"): 6,
    ("house_data.txt", "title"): 7,
    ("house_data.txt", "entertext"): 23,
    ("trans.txt", "description"): 1,
    ("mm7_history.txt", "text"): 1,
    ("mm7_history.txt", "pagetitle"): 3,
    ("history.txt", "text"): 1,
    ("history.txt", "pagetitle"): 3,
    ("standard_item_enchants.txt", "displaystat"): 20,
    ("standard_item_enchants.txt", "displaysuffix"): 21,
    ("special_item_enchants.txt", "displaydescription"): 20,
    ("special_item_enchants.txt", "displaysuffix"): 21,
    ("arcomage_cards.txt", "name"): 1,
    ("pc_names.txt", "human_male"): 0,
    ("pc_names.txt", "human_female"): 1,
    ("pc_names.txt", "dark_elf_male"): 2,
    ("pc_names.txt", "dark_elf_female"): 3,
    ("pc_names.txt", "troll_minotaur"): 4,
    ("pc_names.txt", "vampire_female"): 5,
    ("pc_names.txt", "vampire_male"): 6,
    ("pc_names.txt", "dragon"): 7,
}

SYNTHETIC_ROW_OFFSETS: dict[str, int] = {
    "npc_names.txt": 0,
    "pc_names.txt": 0,
    "class.txt": 1,
    "standard_item_enchants.txt": 3,
    "special_item_enchants.txt": 3,
}

SYMBOLIC_KEY_TABLES = {"stats.txt", "skill_des.txt"}

_VERIFY_TSV_CACHE: dict[Path, list[list[str]]] = {}
_VERIFY_TEXT_CACHE: dict[Path, str] = {}


def read_tsv(path: Path) -> list[list[str]]:
    text = path.read_text(encoding="utf-8-sig")
    return list(csv.reader(io.StringIO(text, newline=""), delimiter="\t", quotechar='"'))


def write_tsv(path: Path, rows: Iterable[list[str]]) -> None:
    with path.open("w", encoding="utf-8", newline="") as stream:
        csv.writer(
            stream,
            delimiter="\t",
            quotechar='"',
            quoting=csv.QUOTE_MINIMAL,
            lineterminator="\n",
        ).writerows(rows)


def numeric_row_lookup(rows: list[list[str]]) -> dict[int, int]:
    result: dict[int, int] = {}
    for index, row in enumerate(rows):
        if row and row[0].strip().isdigit():
            record_id = int(row[0].strip())
            if record_id in result:
                raise ValueError(f"Duplicate numeric runtime row id {record_id}")
            result[record_id] = index
    return result


def symbolic_row_lookup(rows: list[list[str]]) -> dict[str, int]:
    result: dict[str, int] = {}
    for index, row in enumerate(rows):
        if not row or not row[0].strip():
            continue
        key = row[0].strip()
        if key in result:
            raise ValueError(f"Duplicate symbolic runtime row key {key!r}")
        result[key] = index
    return result


def resolve_row(rows: list[list[str]], source_name: str, entry: dict) -> int:
    source_key = source_name.casefold()
    record_id = entry.get("record_id")

    if source_key in SYNTHETIC_ROW_OFFSETS:
        try:
            numeric_id = int(record_id)
        except (TypeError, ValueError) as error:
            raise ValueError(f"PO entry has a non-numeric synthetic row: {entry['key']}") from error
        row_index = numeric_id + SYNTHETIC_ROW_OFFSETS[source_key]
        if row_index < 0 or row_index >= len(rows):
            raise ValueError(f"Synthetic runtime row {row_index} out of range for PO entry {entry['key']}")
        return row_index

    if source_key in SYMBOLIC_KEY_TABLES:
        lookup = symbolic_row_lookup(rows)
        symbolic_id = str(record_id)
        if symbolic_id not in lookup:
            raise ValueError(f"Runtime key {symbolic_id!r} missing for PO entry {entry['key']}")
        return lookup[symbolic_id]

    try:
        numeric_id = int(record_id)
    except (TypeError, ValueError) as error:
        raise ValueError(f"PO entry has a non-numeric runtime row: {entry['key']}") from error

    lookup = numeric_row_lookup(rows)
    if numeric_id not in lookup:
        raise ValueError(f"Runtime row {numeric_id} missing for PO entry {entry['key']}")
    return lookup[numeric_id]


def find_column(rows: list[list[str]], source_name: str, field_name: str) -> int:
    key = (source_name.casefold(), field_name.casefold())
    explicit = FIELD_COLUMNS.get(key)
    if explicit is not None:
        return explicit

    field_key = field_name.casefold()
    for header in rows[:4]:
        normalized = [cell.strip().casefold() for cell in header]
        if field_key in normalized:
            return normalized.index(field_key)
    if field_key == "text" and max((len(row) for row in rows), default=0) == 2:
        return 1
    raise ValueError(f"No TSV field mapping for {source_name}:{field_name}")


def infer_engine_output(repo_root: Path, entry: dict) -> Path:
    source_path = Path(str(entry["source_file"]))
    try:
        relative = source_path.relative_to(Path("assets_dev/engine"))
    except ValueError as error:
        raise ValueError(f"Unsupported engine PO target for {entry['key']}: {source_path}") from error
    return repo_root / "korean/overlay/engine" / relative


def resolve_engine_cell(
    repo_root: Path,
    entry: dict,
    *,
    verify_cache: bool = False,
) -> tuple[Path, list[list[str]], int, int]:
    output_path = infer_engine_output(repo_root, entry)
    if verify_cache:
        rows = _VERIFY_TSV_CACHE.get(output_path)
        if rows is None:
            if not output_path.is_file():
                raise ValueError(f"Runtime overlay does not exist for PO entry {entry['key']}: {output_path}")
            rows = read_tsv(output_path)
            _VERIFY_TSV_CACHE[output_path] = rows
    else:
        if not output_path.is_file():
            raise ValueError(f"Runtime overlay does not exist for PO entry {entry['key']}: {output_path}")
        rows = read_tsv(output_path)

    source_name = Path(str(entry["source_file"])).name
    row_index = resolve_row(rows, source_name, entry)
    column = find_column(rows, source_name, str(entry["field"]))
    if column >= len(rows[row_index]):
        raise ValueError(f"Runtime column {column} missing for PO entry {entry['key']}")
    return output_path, rows, row_index, column


def runtime_engine_value(entry: dict, translation: str) -> str:
    source_name = Path(str(entry["source_file"])).name.casefold()
    field_name = str(entry["field"]).casefold()
    if (
        source_name == "class.txt"
        and field_name == "name"
        and translation == str(entry.get("source", ""))
    ):
        return ""
    return translation


def verify_engine_tsv(repo_root: Path, entry: dict, translation: str) -> None:
    _, rows, row_index, column = resolve_engine_cell(repo_root, entry, verify_cache=True)
    expected = runtime_engine_value(entry, translation)
    current = rows[row_index][column]
    if current != expected:
        raise ValueError(
            f"Runtime TSV value mismatch for {entry['key']}: expected {expected!r}, got {current!r}"
        )

    source_name = Path(str(entry["source_file"])).name.casefold()
    if source_name == "class.txt" and str(entry["field"]).casefold() == "name":
        logic_key = rows[row_index][0]
        if logic_key != str(entry["source"]):
            raise ValueError(
                f"Class gameplay key was localized for {entry['key']}: {logic_key!r}"
            )


def materialize_engine_tsv(repo_root: Path, entry: dict, translation: str) -> None:
    output_path, rows, row_index, column = resolve_engine_cell(repo_root, entry)
    rows[row_index][column] = runtime_engine_value(entry, translation)
    write_tsv(output_path, rows)


def decoration_location(repo_root: Path, entry: dict) -> tuple[Path, str]:
    return repo_root / "game/ui/KoreanDecorationText.h", str(entry["source"]).strip().casefold()


def verify_decoration(repo_root: Path, entry: dict, translation: str) -> None:
    header_path, source = decoration_location(repo_root, entry)
    text = _VERIFY_TEXT_CACHE.get(header_path)
    if text is None:
        text = header_path.read_text(encoding="utf-8")
        _VERIFY_TEXT_CACHE[header_path] = text
    literal = f'{{"{source}", "{translation}"}}'
    if literal not in text:
        raise ValueError(f"Decoration runtime mapping does not match PO entry {entry['key']}")


def materialize_decoration(repo_root: Path, entry: dict, translation: str) -> None:
    header_path, source = decoration_location(repo_root, entry)
    text = header_path.read_text(encoding="utf-8")
    old_literal = f'{{"{source}", "{entry.get("translation", "")}"}}'
    new_literal = f'{{"{source}", "{translation}"}}'
    count = text.count(old_literal)
    if count != 1:
        raise ValueError(
            f"Decoration runtime mapping count for {entry['key']} is {count}, expected 1"
        )
    header_path.write_text(text.replace(old_literal, new_literal), encoding="utf-8", newline="\n")


def lua_quoted(text: str) -> str:
    escaped = (
        text.replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\n", "\\n")
        .replace("\r", "\\r")
        .replace("\t", "\\t")
    )
    return '"' + escaped + '"'


def world_lua_output(repo_root: Path, entry: dict) -> Path:
    key_parts = str(entry["key"]).split(":", 3)
    if len(key_parts) != 4 or key_parts[0] != "world":
        raise ValueError(f"Malformed world PO key: {entry['key']}")
    world_id = key_parts[1]
    lua_name = Path(key_parts[2]).stem.lower() + ".lua"
    return repo_root / "korean/overlay/worlds" / world_id / "events/maps" / lua_name


def verify_world_lua(repo_root: Path, entry: dict, translation: str) -> None:
    output_path = world_lua_output(repo_root, entry)
    if not output_path.is_file():
        raise ValueError(f"World runtime Lua missing for PO entry {entry['key']}: {output_path}")
    text = _VERIFY_TEXT_CACHE.get(output_path)
    if text is None:
        text = output_path.read_text(encoding="utf-8")
        _VERIFY_TEXT_CACHE[output_path] = text
    if lua_quoted(translation) not in text:
        raise ValueError(f"Translated Lua literal missing for PO entry {entry['key']}")


def materialize_world_lua(repo_root: Path, entry: dict, translation: str) -> None:
    output_path = world_lua_output(repo_root, entry)
    if not output_path.is_file():
        raise ValueError(f"World runtime Lua missing for PO entry {entry['key']}: {output_path}")
    text = output_path.read_text(encoding="utf-8")
    old_literal = lua_quoted(str(entry.get("translation", "")))
    new_literal = lua_quoted(translation)
    count = text.count(old_literal)
    if count == 0:
        raise ValueError(f"Current translated Lua literal missing for PO entry {entry['key']}")
    output_path.write_text(text.replace(old_literal, new_literal), encoding="utf-8", newline="\n")


def verify_entry(repo_root: Path, entry: dict, translation: str) -> None:
    scope = str(entry.get("scope", ""))
    source_name = Path(str(entry.get("source_file", ""))).name.casefold()
    if scope == "engine" and source_name == "decoration_data.txt":
        verify_decoration(repo_root, entry, translation)
        return
    if scope == "engine":
        verify_engine_tsv(repo_root, entry, translation)
        return
    if scope.startswith("world:"):
        verify_world_lua(repo_root, entry, translation)
        return
    raise ValueError(f"Unsupported PO runtime scope for {entry['key']}: {scope}")


def materialize_entry(repo_root: Path, entry: dict, translation: str) -> None:
    scope = str(entry.get("scope", ""))
    source_name = Path(str(entry.get("source_file", ""))).name.casefold()
    if scope == "engine" and source_name == "decoration_data.txt":
        materialize_decoration(repo_root, entry, translation)
        return
    if scope == "engine":
        materialize_engine_tsv(repo_root, entry, translation)
        return
    if scope.startswith("world:"):
        materialize_world_lua(repo_root, entry, translation)
        return
    raise ValueError(f"Unsupported PO runtime scope for {entry['key']}: {scope}")


def verify_runtime_catalog(catalog: dict, po_entries: list[dict[str, str]], repo_root: Path) -> int:
    _VERIFY_TSV_CACHE.clear()
    _VERIFY_TEXT_CACHE.clear()
    catalog_by_key = {str(entry["key"]): entry for entry in catalog.get("entries", [])}
    verified = 0
    seen: set[str] = set()

    for po_entry in po_entries:
        key = po_entry.get("msgctxt", "")
        if key in seen:
            raise ValueError(f"Duplicate PO context: {key}")
        seen.add(key)
        if key not in catalog_by_key:
            raise ValueError(f"PO context does not match current catalog: {key}")
        entry = catalog_by_key[key]
        if po_entry.get("msgid", "") != str(entry.get("source", "")):
            raise ValueError(f"Stale PO source text for {key}")
        translation = po_entry.get("msgstr", "") or str(entry.get("translation", ""))
        verify_entry(repo_root, entry, translation)
        verified += 1

    missing = set(catalog_by_key) - seen
    if missing:
        raise ValueError(f"PO catalog is missing {len(missing)} runtime context(s)")
    return verified
