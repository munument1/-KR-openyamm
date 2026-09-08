#!/usr/bin/env python3
"""Synchronize generated map-Lua interaction target names with the Korean catalog.

The event exporter emits metadata such as `houseId`/`targetMap` plus an English
`targetName`.  House names and map names are already fully translated in the
catalog, so leaving this metadata untouched makes building, dungeon, passage,
and travel labels appear in English even though their source tables are Korean.
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


def lua_unescape(text: str) -> str:
    return (
        text.replace(r"\\", "\0")
        .replace(r'\"', '"')
        .replace(r"\n", "\n")
        .replace(r"\r", "\r")
        .replace(r"\t", "\t")
        .replace("\0", "\\")
    )


def lua_escape(text: str) -> str:
    return (
        text.replace("\\", r"\\")
        .replace('"', r'\"')
        .replace("\n", r"\n")
        .replace("\r", r"\r")
        .replace("\t", r"\t")
    )


def catalog_name_maps(catalog: dict) -> tuple[dict[int, str], dict[str, str]]:
    houses: dict[int, str] = {}
    map_candidates: dict[str, set[str]] = defaultdict(set)

    for entry in catalog.get("entries", []):
        source_name = Path(str(entry.get("source_file", ""))).name
        field = str(entry.get("field", ""))
        translation = entry.get("translation", "")
        if not isinstance(translation, str) or not translation:
            continue

        if source_name == "house_data.txt" and field == "Name":
            try:
                houses[int(entry.get("record_id"))] = translation
            except (TypeError, ValueError):
                continue
        elif source_name == "map_stats.txt" and field == "Name":
            source = str(entry.get("source", ""))
            if source:
                map_candidates[source].add(translation)

    maps = {
        source: next(iter(translations))
        for source, translations in map_candidates.items()
        if len(translations) == 1
    }
    return houses, maps


def synchronize_file(path: Path, houses: dict[int, str], maps: dict[str, str]) -> tuple[int, list[str]]:
    text = path.read_text(encoding="utf-8-sig")
    changed = 0
    unresolved: list[str] = []
    output_lines: list[str] = []

    for line_number, line in enumerate(text.splitlines(keepends=True), start=1):
        match = TARGET_NAME_RE.search(line)
        if match is None:
            output_lines.append(line)
            continue

        current_name = lua_unescape(match.group(2))
        translated_name: str | None = None

        house_match = HOUSE_ID_RE.search(line)
        if house_match is not None:
            translated_name = houses.get(int(house_match.group(1)))

        if translated_name is None:
            translated_name = maps.get(current_name)

        if translated_name is not None:
            if translated_name != current_name:
                escaped = lua_escape(translated_name)
                line = line[: match.start(2)] + escaped + line[match.end(2):]
                changed += 1
        elif LATIN_RE.search(current_name):
            unresolved.append(f"{path}:{line_number}: {current_name}")

        output_lines.append(line)

    if changed:
        path.write_text("".join(output_lines), encoding="utf-8", newline="")
    return changed, unresolved


def synchronize(repo_root: Path, catalog: dict) -> tuple[int, int]:
    houses, maps = catalog_name_maps(catalog)
    worlds_root = repo_root / "korean" / "overlay" / "worlds"
    if not worlds_root.is_dir():
        return 0, 0

    changed = 0
    unresolved: list[str] = []
    scanned = 0
    for path in sorted(worlds_root.glob("*/events/maps/*.lua")):
        file_changed, file_unresolved = synchronize_file(path, houses, maps)
        changed += file_changed
        unresolved.extend(file_unresolved)
        scanned += 1

    if unresolved:
        preview = "\n".join(unresolved[:100])
        raise ValueError(
            f"Untranslated generated targetName values remain ({len(unresolved)}):\n{preview}"
        )
    return changed, scanned


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
    changed, scanned = synchronize(repo_root, catalog)
    print(f"Map target-name sync: {changed} replacement(s) across {scanned} Lua file(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
