#!/usr/bin/env python3
"""Generate Korean world event Lua overlays from KO_MapStrings.

OpenYAMM's map Lua files are generated from legacy EVT/STR and contain STR text
as Lua string literals. This tool never edits canonical generated sources.
Instead it resolves each KO_MapStrings row by runtime Lua ownership first, then
uses MM6/MM7/MM8 legacy STR candidates to recover the exact English StringId.
That also supports MMerge-only Lua maps, which have no local legacy STR copy.

KO entries that exist in a legacy STR but are not emitted by the current Lua
exporter are recorded as exclusions rather than false translation misses.
"""

from __future__ import annotations

import argparse
import csv
import io
import json
import re
import shutil
from collections import Counter, defaultdict
from pathlib import Path

WORLDS = ("mm6", "mm7", "mm8", "mmmerge")
LEGACY_SOURCE_WORLDS = ("mm6", "mm7", "mm8")
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
    for path in root.rglob("*"):
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


def review_entry(
    *,
    key: str,
    scope: str,
    source_file: str,
    record_id: int | str,
    source: str,
    translation: str,
    note: str,
    placeholder_ok: bool = True,
) -> dict:
    return {
        "key": key,
        "scope": scope,
        "source_file": source_file,
        "record_id": record_id,
        "field": "Text",
        "source": source,
        "translation": translation,
        "translation_origin": "mmmerge",
        "status": "needs_review",
        "placeholder_ok": placeholder_ok,
        "note": note,
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

    # Canonical runtime Lua ownership is authoritative. MMerge has runtime Lua
    # but no local legacy STR tree, so legacy source candidates are indexed
    # independently from MM6/MM7/MM8.
    lua_indexes: dict[str, dict[str, Path]] = {}
    str_indexes: dict[str, dict[str, Path]] = {}
    for world_id in WORLDS:
        world_root = repo_root / "assets_dev" / "worlds" / world_id
        lua_indexes[world_id] = index_case_insensitive_files(world_root / "events" / "maps", ".lua")
        if world_id in LEGACY_SOURCE_WORLDS:
            str_indexes[world_id] = index_case_insensitive_files(world_root / "_legacy" / "events", ".str")

    for world_id in WORLDS:
        stale_root = output_worlds_root / world_id
        if stale_root.exists():
            shutil.rmtree(stale_root)

    lua_texts: dict[tuple[str, str], str] = {}
    replacements: dict[tuple[str, str], dict[str, str]] = defaultdict(dict)
    emitted_entries: list[dict] = []
    excluded_details: list[dict] = []
    unresolved_entries: list[dict] = []
    processed_rows = 0

    for row_number, row in enumerate(ko_rows[1:], start=2):
        if len(row) < 3:
            continue
        map_file = row[0].strip()
        raw_string_id = row[1].strip()
        translation = row[2]
        if not map_file and not raw_string_id and not translation:
            continue
        processed_rows += 1

        if not raw_string_id.isdigit():
            unresolved_entries.append(
                review_entry(
                    key=f"world:unknown:{map_file}:{raw_string_id}",
                    scope="world",
                    source_file=map_file,
                    record_id=raw_string_id,
                    source="",
                    translation=translation,
                    note=f"KO_MapStrings row {row_number} has a non-numeric StringId.",
                )
            )
            continue

        string_id = int(raw_string_id)
        normalized_str_name = Path(map_file).name.lower()
        lua_name = Path(map_file).stem.lower() + ".lua"
        target_worlds = [world_id for world_id in WORLDS if lua_name in lua_indexes[world_id]]
        source_candidates: list[tuple[str, Path, str, str]] = []
        for source_world in LEGACY_SOURCE_WORLDS:
            source_path = str_indexes[source_world].get(normalized_str_name)
            if source_path is None:
                continue
            str_entries, source_encoding = legacy_str_entries(source_path)
            if string_id < len(str_entries):
                source_candidates.append((source_world, source_path, str_entries[string_id], source_encoding))

        if len(target_worlds) > 1:
            unresolved_entries.append(
                review_entry(
                    key=f"world:unknown:{Path(map_file).name}:{string_id}",
                    scope="world",
                    source_file=map_file,
                    record_id=string_id,
                    source="",
                    translation=translation,
                    note=f"Generated Lua map ownership is ambiguous; candidate worlds={target_worlds}.",
                )
            )
            continue

        if not target_worlds:
            distinct_sources = {candidate[2] for candidate in source_candidates}
            if len(distinct_sources) == 1 and source_candidates:
                source_world, source_path, source_text, _ = source_candidates[0]
                excluded_details.append(
                    {
                        "key": f"world:{source_world}:{Path(map_file).name}:{string_id}",
                        "world": source_world,
                        "map_file": Path(map_file).name,
                        "string_id": string_id,
                        "source": source_text,
                        "translation": translation,
                        "reason": "No generated map Lua exists for this legacy STR in any current runtime world.",
                    }
                )
            else:
                unresolved_entries.append(
                    review_entry(
                        key=f"world:unknown:{Path(map_file).name}:{string_id}",
                        scope="world",
                        source_file=map_file,
                        record_id=string_id,
                        source="",
                        translation=translation,
                        note=(
                            "No generated Lua map exists and the legacy STR source cannot be resolved uniquely; "
                            f"candidate worlds={[candidate[0] for candidate in source_candidates]}."
                        ),
                    )
                )
            continue

        world_id = target_worlds[0]
        lua_path = lua_indexes[world_id][lua_name]
        map_key = (world_id, lua_name)
        if map_key not in lua_texts:
            lua_texts[map_key] = lua_path.read_text(encoding="utf-8")
        lua_text = lua_texts[map_key]

        if not source_candidates:
            unresolved_entries.append(
                review_entry(
                    key=f"world:{world_id}:{Path(map_file).name}:{string_id}",
                    scope=f"world:{world_id}",
                    source_file=map_file,
                    record_id=string_id,
                    source="",
                    translation=translation,
                    note="No MM6/MM7/MM8 legacy STR candidate contains this MapFile/StringId.",
                )
            )
            continue

        # Prefer source candidates whose exact quoted StringId text is actually
        # present in the target runtime Lua. Multiple legacy copies are safe if
        # they resolve to the same source text.
        matching_candidates = [
            candidate for candidate in source_candidates if lua_quoted(candidate[2]) in lua_text
        ]
        matching_texts = {candidate[2] for candidate in matching_candidates}
        all_texts = {candidate[2] for candidate in source_candidates}

        if len(matching_texts) == 1:
            source_text = next(iter(matching_texts))
            compatible = [candidate for candidate in matching_candidates if candidate[2] == source_text]
        elif not matching_candidates and len(all_texts) == 1:
            # The StringId is valid and unambiguous, but the exporter does not
            # emit it in current Lua. Count it as runtime-unused, not missing.
            source_world, source_path, source_text, _ = source_candidates[0]
            excluded_details.append(
                {
                    "key": f"world:{world_id}:{Path(map_file).name}:{string_id}",
                    "world": world_id,
                    "map_file": Path(map_file).name,
                    "string_id": string_id,
                    "source": source_text,
                    "translation": translation,
                    "reason": "Legacy STR entry is not emitted as a Lua string literal by the current exporter.",
                }
            )
            continue
        else:
            unresolved_entries.append(
                review_entry(
                    key=f"world:{world_id}:{Path(map_file).name}:{string_id}",
                    scope=f"world:{world_id}",
                    source_file=map_file,
                    record_id=string_id,
                    source="",
                    translation=translation,
                    note=(
                        "Legacy STR source is ambiguous after matching against target Lua; "
                        f"candidate worlds={[candidate[0] for candidate in source_candidates]}, "
                        f"matching worlds={[candidate[0] for candidate in matching_candidates]}."
                    ),
                )
            )
            continue

        preferred = next((candidate for candidate in compatible if candidate[0] == world_id), compatible[0])
        source_world, source_str_path, source_text, source_encoding = preferred
        key = f"world:{world_id}:{Path(map_file).name}:{string_id}"
        placeholder_ok = printf_tokens(source_text) == printf_tokens(translation)
        if not placeholder_ok:
            unresolved_entries.append(
                review_entry(
                    key=key,
                    scope=f"world:{world_id}",
                    source_file=source_str_path.relative_to(repo_root).as_posix(),
                    record_id=string_id,
                    source=source_text,
                    translation=translation,
                    note="KO_MapStrings placeholder mismatch.",
                    placeholder_ok=False,
                )
            )
            continue

        source_literal = lua_quoted(source_text)
        target_literal = lua_quoted(translation)
        occurrence_count = lua_text.count(source_literal)
        previous = replacements[map_key].get(source_literal)
        if previous is not None and previous != target_literal:
            unresolved_entries.append(
                review_entry(
                    key=key,
                    scope=f"world:{world_id}",
                    source_file=source_str_path.relative_to(repo_root).as_posix(),
                    record_id=string_id,
                    source=source_text,
                    translation=translation,
                    note="Same English Lua literal maps to conflicting Korean translations in one map.",
                )
            )
            continue

        replacements[map_key][source_literal] = target_literal
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
                    f"Target {world_id}/{lua_name}; source {source_world}/{source_str_path.name} "
                    f"StringId {string_id}; canonical Lua literal occurs {occurrence_count} time(s); "
                    f"source encoding {source_encoding}."
                ),
            }
        )

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

    classified_rows = len(emitted_entries) + len(unresolved_entries) + len(excluded_details)
    if classified_rows != processed_rows:
        raise ValueError(f"KO_MapStrings classification mismatch: processed={processed_rows}, classified={classified_rows}")

    catalog["entries"].extend(new_entries)
    table_stats: list[dict] = []
    for world_id in WORLDS:
        world_entries = [entry for entry in new_entries if entry["scope"] == f"world:{world_id}"]
        world_excluded = [detail for detail in excluded_details if detail["world"] == world_id]
        stats = {
            "overlay_source": "Data/Text localization/KO_MapStrings.txt",
            "overlay_format": "runtime Lua ownership + legacy STR StringId -> generated Lua literal world overlay",
            "source_file": f"assets_dev/worlds/{world_id}/events/maps/*.lua",
            "source_encoding": "utf-8 Lua; legacy STR utf-8/cp1252",
            "mmmerge_encoding": ko_encoding,
            "entries": len(world_entries),
            "translated": sum(1 for entry in world_entries if entry["status"] == "translated"),
            "untranslated": sum(1 for entry in world_entries if entry["status"] == "untranslated"),
            "placeholder_mismatches": sum(1 for entry in world_entries if entry["status"] == "needs_review"),
            "overrides": 0,
            "excluded": len(world_excluded),
            "exclusion_reason": (
                "KO_MapStrings rows with a valid legacy STR entry but no emitted current runtime Lua literal "
                "are outside current runtime coverage."
            ),
            "excluded_details": world_excluded,
            "generated_overlay_files": sorted(generated_files_by_world.get(world_id, [])),
            "output_encoding": "utf-8",
        }
        catalog["tables"].append(stats)
        table_stats.append(stats)

    unknown_entries = [entry for entry in unresolved_entries if entry["scope"] == "world"]
    if unknown_entries:
        catalog["tables"].append(
            {
                "overlay_source": "Data/Text localization/KO_MapStrings.txt",
                "overlay_format": "unresolved map ownership/source diagnostics",
                "source_file": "KO_MapStrings unresolved",
                "source_encoding": "mixed",
                "mmmerge_encoding": ko_encoding,
                "entries": len(unknown_entries),
                "translated": 0,
                "untranslated": 0,
                "placeholder_mismatches": len(unknown_entries),
                "overrides": 0,
                "excluded": 0,
                "generated_overlay_files": [],
                "output_encoding": "utf-8",
            }
        )

    catalog["format"] = max(int(catalog.get("format", 1)), 10)
    refresh_summary(catalog)
    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(json.dumps(catalog["summary"], ensure_ascii=False))
    print(f"KO_MapStrings rows={processed_rows}, classified={classified_rows}")
    for world_id, stats in zip(WORLDS, table_stats, strict=True):
        print(
            f"{world_id}: {stats['translated']}/{stats['entries']} emitted entries translated, "
            f"{stats['placeholder_mismatches']} review, {stats['excluded']} runtime-unused/excluded, "
            f"{len(stats['generated_overlay_files'])} overlay Lua file(s)"
        )
    print(f"unresolved ownership/source={len(unknown_entries)}")

    if args.fail_on_review and (
        catalog["summary"]["untranslated"] or catalog["summary"]["needs_review"]
    ):
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
