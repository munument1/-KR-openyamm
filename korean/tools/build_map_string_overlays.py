#!/usr/bin/env python3
"""Generate Korean world event Lua overlays from KO_MapStrings.

OpenYAMM's map Lua files are generated from legacy EVT/STR and contain the STR
text as Lua string literals. This tool never edits those generated source files.
It uses the legacy STR StringId to recover the exact English text, validates
placeholders, then writes localized copies only for maps whose emitted Lua uses
that STR entry.

KO entries that exist in a legacy STR but are not emitted by the current Lua
exporter are recorded as exclusions rather than false translation misses.
"""

from __future__ import annotations

import argparse
import csv
import io
import json
import re
from collections import Counter, defaultdict
from pathlib import Path

WORLDS = ("mm6", "mm7", "mm8")
PRINTF_TOKEN_RE = re.compile(
    r"%(?:\d+\$)?\d*(?:\.\d+)?(?:hh|h|ll|l|j|z|t|L)?[diuoxXfFeEgGaAcsn]"
)


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
    return list(csv.reader(io.StringIO(text, newline=""), delimiter="\t", quotechar='"')), encoding


def legacy_str_entries(path: Path) -> tuple[list[str], str]:
    text, encoding = decode_text(path, ("utf-8-sig", "cp1252"))
    # Match tools/legacy_events/StrTable.cpp: split on LF, strip a trailing CR,
    # and preserve an empty final entry if the file ends in LF.
    entries: list[str] = []
    position = 0
    while position <= len(text):
        line_end = text.find("\n", position)
        if line_end == -1:
            line_end = len(text)
        line = text[position:line_end]
        if line.endswith("\r"):
            line = line[:-1]
        entries.append(line)
        if line_end == len(text):
            break
        position = line_end + 1
    return entries, encoding


def lua_quoted(text: str) -> str:
    escaped: list[str] = []
    for character in text:
        if character == "\\":
            escaped.append("\\\\")
        elif character == '"':
            escaped.append('\\"')
        elif character == "\n":
            escaped.append("\\n")
        elif character == "\r":
            escaped.append("\\r")
        elif character == "\t":
            escaped.append("\\t")
        else:
            escaped.append(character)
    return '"' + "".join(escaped) + '"'


def printf_tokens(text: str) -> Counter[str]:
    return Counter(PRINTF_TOKEN_RE.findall(text))


def index_case_insensitive_files(root: Path, suffix: str) -> dict[str, Path]:
    result: dict[str, Path] = {}
    if not root.is_dir():
        return result
    for path in root.iterdir():
        if path.is_file() and path.suffix.lower() == suffix.lower():
            key = path.name.lower()
            if key in result:
                raise ValueError(f"Case-insensitive duplicate in {root}: {path.name}")
            result[key] = path
    return result


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
    parser.add_argument("--mmmerge-root", required=True)
    parser.add_argument("--catalog", default="korean/translations/catalog.json")
    parser.add_argument("--overlay-worlds-root", default="korean/overlay/worlds")
    parser.add_argument("--fail-on-review", action="store_true")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    mmmerge_root = Path(args.mmmerge_root).resolve()
    catalog_path = repo_root / args.catalog
    output_worlds_root = repo_root / args.overlay_worlds_root
    ko_path = mmmerge_root / "Data" / "Text localization" / "KO_MapStrings.txt"

    ko_rows, ko_encoding = read_tsv(ko_path, ("utf-8-sig", "cp949"))

    world_indexes: dict[str, dict[str, dict[str, Path]]] = {}
    source_owner: dict[str, list[str]] = defaultdict(list)
    for world_id in WORLDS:
        world_root = repo_root / "assets_dev" / "worlds" / world_id
        str_index = index_case_insensitive_files(world_root / "_legacy" / "events", ".str")
        lua_index = index_case_insensitive_files(world_root / "events" / "maps", ".lua")
        world_indexes[world_id] = {"str": str_index, "lua": lua_index}
        for name in str_index:
            source_owner[name].append(world_id)

    # Load canonical Lua lazily and collect replacements per world/map. We use
    # quoted literals so comments and unrelated substrings are never touched.
    lua_texts: dict[tuple[str, str], str] = {}
    replacements: dict[tuple[str, str], dict[str, str]] = defaultdict(dict)
    replacement_keys: dict[tuple[str, str, str], list[str]] = defaultdict(list)
    emitted_entries: list[dict] = []
    excluded_details: list[dict] = []
    unresolved_entries: list[dict] = []

    for row_number, row in enumerate(ko_rows[1:], start=2):
        if len(row) < 3:
            continue
        map_file = row[0].strip()
        raw_string_id = row[1].strip()
        translation = row[2]
        if not map_file and not raw_string_id and not translation:
            continue
        if not raw_string_id.isdigit():
            unresolved_entries.append(
                {
                    "key": f"world:unknown:{map_file}:{raw_string_id}",
                    "scope": "world",
                    "source_file": map_file,
                    "record_id": raw_string_id,
                    "field": "Text",
                    "source": "",
                    "translation": translation,
                    "translation_origin": "mmmerge",
                    "status": "needs_review",
                    "placeholder_ok": True,
                    "note": f"KO_MapStrings row {row_number} has a non-numeric StringId.",
                }
            )
            continue
        string_id = int(raw_string_id)
        normalized_name = Path(map_file).name.lower()
        owners = source_owner.get(normalized_name, [])
        if len(owners) != 1:
            unresolved_entries.append(
                {
                    "key": f"world:unknown:{map_file}:{string_id}",
                    "scope": "world",
                    "source_file": map_file,
                    "record_id": string_id,
                    "field": "Text",
                    "source": "",
                    "translation": translation,
                    "translation_origin": "mmmerge",
                    "status": "needs_review",
                    "placeholder_ok": True,
                    "note": (
                        "KO_MapStrings source STR could not be resolved uniquely; "
                        f"candidate worlds={owners}."
                    ),
                }
            )
            continue

        world_id = owners[0]
        source_str_path = world_indexes[world_id]["str"][normalized_name]
        str_entries, source_encoding = legacy_str_entries(source_str_path)
        if string_id >= len(str_entries):
            unresolved_entries.append(
                {
                    "key": f"world:{world_id}:{map_file}:{string_id}",
                    "scope": f"world:{world_id}",
                    "source_file": source_str_path.relative_to(repo_root).as_posix(),
                    "record_id": string_id,
                    "field": "Text",
                    "source": "",
                    "translation": translation,
                    "translation_origin": "mmmerge",
                    "status": "needs_review",
                    "placeholder_ok": True,
                    "note": (
                        f"StringId {string_id} is outside the source STR range "
                        f"0..{max(len(str_entries) - 1, 0)}."
                    ),
                }
            )
            continue

        source_text = str_entries[string_id]
        placeholder_ok = printf_tokens(source_text) == printf_tokens(translation)
        map_stem = Path(map_file).stem.lower()
        lua_name = map_stem + ".lua"
        lua_path = world_indexes[world_id]["lua"].get(lua_name)
        key = f"world:{world_id}:{Path(map_file).name}:{string_id}"

        if not placeholder_ok:
            unresolved_entries.append(
                {
                    "key": key,
                    "scope": f"world:{world_id}",
                    "source_file": source_str_path.relative_to(repo_root).as_posix(),
                    "record_id": string_id,
                    "field": "Text",
                    "source": source_text,
                    "translation": translation,
                    "translation_origin": "mmmerge",
                    "status": "needs_review",
                    "placeholder_ok": False,
                    "note": "KO_MapStrings placeholder mismatch.",
                }
            )
            continue

        if lua_path is None:
            excluded_details.append(
                {
                    "key": key,
                    "world": world_id,
                    "map_file": Path(map_file).name,
                    "string_id": string_id,
                    "source": source_text,
                    "translation": translation,
                    "reason": "No generated map Lua exists for this legacy STR in the current world export.",
                }
            )
            continue

        map_key = (world_id, lua_name)
        if map_key not in lua_texts:
            lua_texts[map_key] = lua_path.read_text(encoding="utf-8")
        source_literal = lua_quoted(source_text)
        target_literal = lua_quoted(translation)
        occurrence_count = lua_texts[map_key].count(source_literal)

        if occurrence_count == 0:
            excluded_details.append(
                {
                    "key": key,
                    "world": world_id,
                    "map_file": Path(map_file).name,
                    "string_id": string_id,
                    "source": source_text,
                    "translation": translation,
                    "reason": "Legacy STR entry is not emitted as a Lua string literal by the current exporter.",
                }
            )
            continue

        previous = replacements[map_key].get(source_literal)
        if previous is not None and previous != target_literal:
            unresolved_entries.append(
                {
                    "key": key,
                    "scope": f"world:{world_id}",
                    "source_file": source_str_path.relative_to(repo_root).as_posix(),
                    "record_id": string_id,
                    "field": "Text",
                    "source": source_text,
                    "translation": translation,
                    "translation_origin": "mmmerge",
                    "status": "needs_review",
                    "placeholder_ok": True,
                    "note": "Same English Lua literal maps to conflicting Korean translations in one map.",
                }
            )
            continue

        replacements[map_key][source_literal] = target_literal
        replacement_keys[(world_id, lua_name, source_literal)].append(key)
        emitted_entries.append(
            {
                "key": key,
                "scope": f"world:{world_id}",
                "source_file": source_str_path.relative_to(repo_root).as_posix(),
                "record_id": string_id,
                "field": "Text",
                "source": source_text,
                "translation": translation,
                "translation_origin": "mmmerge",
                "status": "translated",
                "placeholder_ok": True,
                "note": (
                    f"Generated from {Path(map_file).name} StringId {string_id}; "
                    f"canonical Lua literal occurs {occurrence_count} time(s)."
                ),
            }
        )

    # Generate world overlay Lua without modifying canonical generated sources.
    generated_files_by_world: dict[str, list[str]] = defaultdict(list)
    for (world_id, lua_name), literal_map in replacements.items():
        text = lua_texts[(world_id, lua_name)]
        if literal_map:
            pattern = re.compile("|".join(re.escape(value) for value in sorted(literal_map, key=len, reverse=True)))
            text = pattern.sub(lambda match: literal_map[match.group(0)], text)
        output_path = output_worlds_root / world_id / "events" / "maps" / lua_name
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(text, encoding="utf-8", newline="\n")
        generated_files_by_world[world_id].append(output_path.relative_to(repo_root).as_posix())

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    existing_keys = {entry["key"] for entry in catalog["entries"]}
    new_entries = emitted_entries + unresolved_entries
    duplicate_keys = sorted(existing_keys.intersection(entry["key"] for entry in new_entries))
    if duplicate_keys:
        raise ValueError(f"Duplicate catalog keys: {duplicate_keys[:20]}")
    key_counts = Counter(entry["key"] for entry in new_entries)
    duplicate_new_keys = sorted(key for key, count in key_counts.items() if count > 1)
    if duplicate_new_keys:
        raise ValueError(f"Duplicate KO_MapStrings keys: {duplicate_new_keys[:20]}")

    catalog["entries"].extend(new_entries)
    table_stats: list[dict] = []
    for world_id in WORLDS:
        world_entries = [entry for entry in new_entries if entry["scope"] == f"world:{world_id}"]
        world_excluded = [detail for detail in excluded_details if detail["world"] == world_id]
        stats = {
            "overlay_source": "Data/Text localization/KO_MapStrings.txt",
            "overlay_format": "legacy STR StringId -> generated Lua literal world overlay",
            "source_file": f"assets_dev/worlds/{world_id}/_legacy/events/*.str",
            "source_encoding": "utf-8/cp1252",
            "mmmerge_encoding": ko_encoding,
            "entries": len(world_entries),
            "translated": sum(1 for entry in world_entries if entry["status"] == "translated"),
            "untranslated": sum(1 for entry in world_entries if entry["status"] == "untranslated"),
            "placeholder_mismatches": sum(1 for entry in world_entries if entry["status"] == "needs_review"),
            "overrides": 0,
            "excluded": len(world_excluded),
            "exclusion_reason": (
                "Legacy STR entries present in KO_MapStrings but not emitted by the current generated map Lua "
                "are outside current runtime coverage."
            ),
            "excluded_details": world_excluded,
            "generated_overlay_files": sorted(generated_files_by_world.get(world_id, [])),
            "output_encoding": "utf-8",
        }
        catalog["tables"].append(stats)
        table_stats.append(stats)

    catalog["format"] = max(int(catalog.get("format", 1)), 9)
    refresh_summary(catalog)
    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(json.dumps(catalog["summary"], ensure_ascii=False))
    print(f"KO_MapStrings rows={max(len(ko_rows) - 1, 0)}")
    for stats in table_stats:
        world_id = Path(stats["source_file"]).parts[2]
        print(
            f"{world_id}: {stats['translated']}/{stats['entries']} emitted entries translated, "
            f"{stats['placeholder_mismatches']} review, {stats['excluded']} runtime-unused/excluded, "
            f"{len(stats['generated_overlay_files'])} overlay Lua file(s)"
        )

    if args.fail_on_review and (
        catalog["summary"]["untranslated"] or catalog["summary"]["needs_review"]
    ):
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
