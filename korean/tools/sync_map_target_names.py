#!/usr/bin/env python3
"""Synchronize generated map-Lua interaction names with the Korean catalog.

Generated event Lua repeats building/dungeon names in both metadata `targetName`
fields and RegisterEvent display titles.  The latter can reach the HUD directly,
so translating only metadata leaves English field labels behind.  Derive a
per-map literal mapping from authoritative house/map catalog entries and apply
it to the whole quoted Lua literal, creating an overlay even when KO_MapStrings
did not otherwise need one.
"""

from __future__ import annotations

import argparse
import json
import re
from collections import defaultdict
from pathlib import Path

HOUSE_ID_RE = re.compile(r"\bhouseId\s*=\s*(\d+)")
TARGET_NAME_RE = re.compile(r'(\btargetName\s*=\s*)"((?:\\.|[^"\\])*)"')
LATIN_RE = re.compile(r"[A-Za-z]")
WORLDS = ("mm6", "mm7", "mm8", "mmmerge")


def decode_lua(path: Path) -> str:
    raw = path.read_bytes()
    try:
        return raw.decode("utf-8-sig")
    except UnicodeDecodeError:
        return raw.decode("cp1252")


def lua_unescape(text: str) -> str:
    return (
        text.replace(r"\\", "\0")
        .replace(r"\"", '"')
        .replace(r"\n", "\n")
        .replace(r"\r", "\r")
        .replace(r"\t", "\t")
        .replace("\0", "\\")
    )


def lua_quoted(text: str) -> str:
    escaped = (
        text.replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\n", "\\n")
        .replace("\r", "\\r")
        .replace("\t", "\\t")
    )
    return '"' + escaped + '"'


def catalog_name_maps(catalog: dict) -> tuple[dict[int, str], dict[str, str]]:
    houses: dict[int, str] = {}
    map_candidates: dict[str, set[str]] = defaultdict(set)

    for entry in catalog.get("entries", []):
        source_name = Path(str(entry.get("source_file", ""))).name.casefold()
        field = str(entry.get("field", "")).casefold()
        translation = entry.get("translation", "")
        if not isinstance(translation, str) or not translation:
            continue

        if source_name == "house_data.txt" and field == "name":
            try:
                houses[int(entry.get("record_id"))] = translation
            except (TypeError, ValueError):
                continue
        elif source_name == "map_stats.txt" and field == "name":
            source = str(entry.get("source", ""))
            if source:
                map_candidates[source].add(translation)

    maps = {
        source: next(iter(translations))
        for source, translations in map_candidates.items()
        if len(translations) == 1
    }
    return houses, maps


def literal_mapping_for_source(
    path: Path,
    houses: dict[int, str],
    maps: dict[str, str],
) -> tuple[dict[str, str], list[str]]:
    source_text = decode_lua(path)
    mapping: dict[str, str] = {}
    unresolved_required: list[str] = []

    for line_number, line in enumerate(source_text.splitlines(), start=1):
        target_match = TARGET_NAME_RE.search(line)
        if target_match is None:
            continue

        current_name = lua_unescape(target_match.group(2))
        translated_name: str | None = None
        required = False

        house_match = HOUSE_ID_RE.search(line)
        if house_match is not None:
            required = True
            translated_name = houses.get(int(house_match.group(1)))

        if translated_name is None:
            translated_name = maps.get(current_name)

        if translated_name is None:
            if required and LATIN_RE.search(current_name):
                unresolved_required.append(f"{path}:{line_number}: {current_name}")
            continue

        if translated_name == current_name:
            continue

        previous = mapping.get(current_name)
        if previous is not None and previous != translated_name:
            raise ValueError(
                f"Conflicting target-name translation in {path}: "
                f"{current_name!r} -> {previous!r}/{translated_name!r}"
            )
        mapping[current_name] = translated_name

    return mapping, unresolved_required


def synchronize_file(
    repo_root: Path,
    world_id: str,
    source_path: Path,
    houses: dict[int, str],
    maps: dict[str, str],
) -> tuple[int, bool, list[str]]:
    mapping, unresolved = literal_mapping_for_source(source_path, houses, maps)
    if not mapping:
        return 0, False, unresolved

    overlay_path = (
        repo_root / "korean" / "overlay" / "worlds" / world_id
        / "events" / "maps" / source_path.name.lower()
    )
    text = overlay_path.read_text(encoding="utf-8") if overlay_path.is_file() else decode_lua(source_path)
    changed = 0

    for source_name, translated_name in sorted(mapping.items(), key=lambda item: len(item[0]), reverse=True):
        source_literal = lua_quoted(source_name)
        translated_literal = lua_quoted(translated_name)
        count = text.count(source_literal)
        if count:
            text = text.replace(source_literal, translated_literal)
            changed += count

    created = not overlay_path.is_file()
    if changed:
        overlay_path.parent.mkdir(parents=True, exist_ok=True)
        overlay_path.write_text(text, encoding="utf-8", newline="\n")
    return changed, created and changed > 0, unresolved


def synchronize(repo_root: Path, catalog: dict) -> tuple[int, int, int]:
    houses, maps = catalog_name_maps(catalog)
    changed = 0
    created = 0
    scanned = 0
    unresolved_required: list[str] = []

    for world_id in WORLDS:
        source_root = repo_root / "assets_dev" / "worlds" / world_id / "events" / "maps"
        if not source_root.is_dir():
            continue
        for source_path in sorted(source_root.glob("*.lua")):
            file_changed, file_created, file_unresolved = synchronize_file(
                repo_root, world_id, source_path, houses, maps
            )
            changed += file_changed
            created += int(file_created)
            unresolved_required.extend(file_unresolved)
            scanned += 1

    if unresolved_required:
        preview = "\n".join(unresolved_required[:100])
        raise ValueError(
            f"Untranslated generated targetName values remain ({len(unresolved_required)}):\n{preview}"
        )
    return changed, created, scanned


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", default=None)
    args = parser.parse_args()
    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    catalog_path = repo_root / "korean" / "translations" / "catalog.json"
    if not catalog_path.is_file():
        print("Map target-name sync: catalog not present; skipping")
        return 0

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    changed, created, scanned = synchronize(repo_root, catalog)
    print(
        f"Map target-name sync: {changed} quoted literal replacement(s), "
        f"{created} new overlay file(s), {scanned} source Lua file(s) scanned"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
