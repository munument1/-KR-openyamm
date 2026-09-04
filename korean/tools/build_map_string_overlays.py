#!/usr/bin/env python3
"""Generate Korean world event Lua overlays from KO_MapStrings.

Runtime Lua ownership determines the destination world. The English StringId
source is recovered from MM6/MM7/MM8 legacy STR files and matched against the
actual generated Lua literal. This also supports MMerge-only Lua maps, which do
not have their own legacy STR tree.
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
LEGACY_WORLDS = ("mm6", "mm7", "mm8")
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
    rows = list(csv.reader(io.StringIO(text, newline=""), delimiter="\t", quotechar='"'))
    return rows, encoding


def legacy_str_entries(path: Path) -> tuple[list[str], str]:
    text, encoding = decode_text(path, ("utf-8-sig", "cp1252"))
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


def index_files(root: Path, suffix: str) -> dict[str, Path]:
    result: dict[str, Path] = {}
    if not root.is_dir():
        return result
    for path in root.rglob("*"):
        if not path.is_file() or path.suffix.lower() != suffix.lower():
            continue
        key = path.name.lower()
        if key in result:
            raise ValueError(f"Case-insensitive duplicate in {root}: {path.name}")
        result[key] = path
    return result


def make_review(
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
    parser.add_argument("--overlay-worlds-root", default="korean/overlay/worlds")
    parser.add_argument("--fail-on-review", action="store_true")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    mmmerge_root = Path(args.mmmerge_root).resolve()
    catalog_path = repo_root / args.catalog
    output_root = repo_root / args.overlay_worlds_root
    ko_path = mmmerge_root / "Data" / "Text localization" / "KO_MapStrings.txt"
    ko_rows, ko_encoding = read_tsv(ko_path, ("utf-8-sig", "cp949"))

    lua_indexes: dict[str, dict[str, Path]] = {}
    str_indexes: dict[str, dict[str, Path]] = {}
    for world_id in WORLDS:
        world_root = repo_root / "assets_dev" / "worlds" / world_id
        lua_indexes[world_id] = index_files(world_root / "events" / "maps", ".lua")
        if world_id in LEGACY_WORLDS:
            str_indexes[world_id] = index_files(world_root / "_legacy" / "events", ".str")
        stale_output = output_root / world_id
        if stale_output.exists():
            shutil.rmtree(stale_output)

    str_cache: dict[Path, tuple[list[str], str]] = {}
    lua_cache: dict[tuple[str, str], tuple[str, str]] = {}
    replacements: dict[tuple[str, str], dict[str, str]] = defaultdict(dict)
    emitted_entries: list[dict] = []
    unresolved_entries: list[dict] = []
    excluded_details: list[dict] = []
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
                make_review(
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
        map_name = Path(map_file).name
        str_name = map_name.lower()
        lua_name = Path(map_file).stem.lower() + ".lua"
        target_worlds = [world for world in WORLDS if lua_name in lua_indexes[world]]

        source_candidates: list[tuple[str, Path, str, str]] = []
        for source_world in LEGACY_WORLDS:
            source_path = str_indexes[source_world].get(str_name)
            if source_path is None:
                continue
            if source_path not in str_cache:
                str_cache[source_path] = legacy_str_entries(source_path)
            entries, source_encoding = str_cache[source_path]
            if string_id < len(entries):
                source_candidates.append((source_world, source_path, entries[string_id], source_encoding))

        if len(target_worlds) > 1:
            unresolved_entries.append(
                make_review(
                    key=f"world:unknown:{map_name}:{string_id}",
                    scope="world",
                    source_file=map_file,
                    record_id=string_id,
                    source="",
                    translation=translation,
                    note=f"Generated Lua ownership is ambiguous; candidate worlds={target_worlds}.",
                )
            )
            continue

        if not target_worlds:
            distinct_sources = {candidate[2] for candidate in source_candidates}
            if source_candidates and len(distinct_sources) == 1:
                source_world, _, source_text, _ = source_candidates[0]
                excluded_details.append(
                    {
                        "key": f"world:{source_world}:{map_name}:{string_id}",
                        "world": source_world,
                        "map_file": map_name,
                        "string_id": string_id,
                        "source": source_text,
                        "translation": translation,
                        "reason": "No generated map Lua exists in any current runtime world.",
                    }
                )
            else:
                unresolved_entries.append(
                    make_review(
                        key=f"world:unknown:{map_name}:{string_id}",
                        scope="world",
                        source_file=map_file,
                        record_id=string_id,
                        source="",
                        translation=translation,
                        note=(
                            "No generated Lua exists and legacy STR source is not unique; "
                            f"candidate worlds={[candidate[0] for candidate in source_candidates]}."
                        ),
                    )
                )
            continue

        world_id = target_worlds[0]
        key = f"world:{world_id}:{map_name}:{string_id}"
        lua_path = lua_indexes[world_id][lua_name]
        map_key = (world_id, lua_name)
        if map_key not in lua_cache:
            # Canonical generated Lua is not uniformly UTF-8; some files retain
            # CP1252 bytes from the original game data. Korean overlays are
            # always written back as UTF-8.
            lua_cache[map_key] = decode_text(lua_path, ("utf-8-sig", "cp1252"))
        lua_text, lua_encoding = lua_cache[map_key]

        if not source_candidates:
            unresolved_entries.append(
                make_review(
                    key=key,
                    scope=f"world:{world_id}",
                    source_file=map_file,
                    record_id=string_id,
                    source="",
                    translation=translation,
                    note="No MM6/MM7/MM8 legacy STR candidate contains this MapFile/StringId.",
                )
            )
            continue

        matching = [candidate for candidate in source_candidates if lua_quoted(candidate[2]) in lua_text]
        matching_texts = {candidate[2] for candidate in matching}
        all_texts = {candidate[2] for candidate in source_candidates}

        if len(matching_texts) == 1:
            source_text = next(iter(matching_texts))
            compatible = [candidate for candidate in matching if candidate[2] == source_text]
        elif not matching:
            own = [candidate for candidate in source_candidates if candidate[0] == world_id]
            if len(own) == 1:
                compatible = own
                source_text = own[0][2]
            elif len(all_texts) == 1:
                compatible = source_candidates
                source_text = source_candidates[0][2]
            else:
                unresolved_entries.append(
                    make_review(
                        key=key,
                        scope=f"world:{world_id}",
                        source_file=map_file,
                        record_id=string_id,
                        source="",
                        translation=translation,
                        note=(
                            "Legacy STR source is ambiguous and no candidate literal is emitted; "
                            f"candidate worlds={[candidate[0] for candidate in source_candidates]}."
                        ),
                    )
                )
                continue

            excluded_details.append(
                {
                    "key": key,
                    "world": world_id,
                    "map_file": map_name,
                    "string_id": string_id,
                    "source": source_text,
                    "translation": translation,
                    "reason": "Legacy STR entry is not emitted as a Lua string literal by the current exporter.",
                }
            )
            continue
        else:
            unresolved_entries.append(
                make_review(
                    key=key,
                    scope=f"world:{world_id}",
                    source_file=map_file,
                    record_id=string_id,
                    source="",
                    translation=translation,
                    note=(
                        "Multiple different legacy STR texts match the target Lua; "
                        f"matching worlds={[candidate[0] for candidate in matching]}."
                    ),
                )
            )
            continue

        preferred = next((candidate for candidate in compatible if candidate[0] == world_id), compatible[0])
        source_world, source_path, source_text, source_encoding = preferred
        placeholder_ok = printf_tokens(source_text) == printf_tokens(translation)
        if not placeholder_ok:
            unresolved_entries.append(
                make_review(
                    key=key,
                    scope=f"world:{world_id}",
                    source_file=source_path.relative_to(repo_root).as_posix(),
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
                make_review(
                    key=key,
                    scope=f"world:{world_id}",
                    source_file=source_path.relative_to(repo_root).as_posix(),
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
                "source_file": source_path.relative_to(repo_root).as_posix(),
                "record_id": string_id,
                "field": "Text",
                "source": source_text,
                "translation": translation,
                "translation_origin": "mmmerge",
                "status": "translated",
                "placeholder_ok": True,
                "note": (
                    f"Target {world_id}/{lua_name} ({lua_encoding}); source {source_world}/{source_path.name} "
                    f"StringId {string_id} ({source_encoding}); literal occurs {occurrence_count} time(s)."
                ),
            }
        )

    generated_by_world: dict[str, list[str]] = defaultdict(list)
    for (world_id, lua_name), literal_map in replacements.items():
        text = lua_cache[(world_id, lua_name)][0]
        if literal_map:
            pattern = re.compile("|".join(re.escape(value) for value in sorted(literal_map, key=len, reverse=True)))
            text = pattern.sub(lambda match: literal_map[match.group(0)], text)
        output_path = output_root / world_id / "events" / "maps" / lua_name
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(text, encoding="utf-8", newline="\n")
        generated_by_world[world_id].append(output_path.relative_to(repo_root).as_posix())

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    new_entries = emitted_entries + unresolved_entries
    existing_keys = {entry["key"] for entry in catalog["entries"]}
    duplicate_existing = sorted(existing_keys.intersection(entry["key"] for entry in new_entries))
    if duplicate_existing:
        raise ValueError(f"Duplicate catalog keys: {duplicate_existing[:20]}")
    key_counts = Counter(entry["key"] for entry in new_entries)
    duplicate_new = sorted(key for key, count in key_counts.items() if count > 1)
    if duplicate_new:
        raise ValueError(f"Duplicate KO_MapStrings keys: {duplicate_new[:20]}")

    classified_rows = len(emitted_entries) + len(unresolved_entries) + len(excluded_details)
    if classified_rows != processed_rows:
        raise ValueError(f"KO_MapStrings classification mismatch: processed={processed_rows}, classified={classified_rows}")

    catalog["entries"].extend(new_entries)
    table_stats: list[tuple[str, dict]] = []
    for world_id in WORLDS:
        world_entries = [entry for entry in new_entries if entry["scope"] == f"world:{world_id}"]
        world_excluded = [detail for detail in excluded_details if detail["world"] == world_id]
        stats = {
            "overlay_source": "Data/Text localization/KO_MapStrings.txt",
            "overlay_format": "runtime Lua ownership + legacy STR StringId -> UTF-8 Lua overlay",
            "source_file": f"assets_dev/worlds/{world_id}/events/maps/*.lua",
            "source_encoding": "utf-8/cp1252 Lua; legacy STR utf-8/cp1252",
            "mmmerge_encoding": ko_encoding,
            "entries": len(world_entries),
            "translated": sum(entry["status"] == "translated" for entry in world_entries),
            "untranslated": sum(entry["status"] == "untranslated" for entry in world_entries),
            "placeholder_mismatches": sum(entry["status"] == "needs_review" for entry in world_entries),
            "overrides": 0,
            "excluded": len(world_excluded),
            "exclusion_reason": "Valid KO STR rows not emitted by current runtime Lua are excluded from coverage.",
            "excluded_details": world_excluded,
            "generated_overlay_files": sorted(generated_by_world.get(world_id, [])),
            "output_encoding": "utf-8",
        }
        catalog["tables"].append(stats)
        table_stats.append((world_id, stats))

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
    for world_id, stats in table_stats:
        print(
            f"{world_id}: {stats['translated']}/{stats['entries']} emitted translated, "
            f"{stats['placeholder_mismatches']} review, {stats['excluded']} excluded, "
            f"{len(stats['generated_overlay_files'])} overlay Lua file(s)"
        )
    print(f"unresolved ownership/source={len(unknown_entries)}")

    if args.fail_on_review and (catalog["summary"]["untranslated"] or catalog["summary"]["needs_review"]):
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
