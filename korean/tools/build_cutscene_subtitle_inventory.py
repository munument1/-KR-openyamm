#!/usr/bin/env python3
"""Inventory runtime cutscene stems and legacy SMK/BIK media for Korean SRT work.

The subtitle runtime consumes ``subtitles/<video-stem>.srt``.  The important
question is therefore which stems the game actually asks CutsceneVideoScreen to
play, not merely which movies happen to exist in ``data/Anims``.  This tool
cross-references Lua ``evt.ShowMovie`` calls, fixed C++ cutscene stems, configured
``*losegame`` stems, and the legacy media containers.

Classification remains deliberately conservative: source media and repository
references can prove that a movie exists and is used, but cannot prove that it
contains spoken dialogue.  Story/runtime candidates still require transcript and
timing review before an SRT is authored.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
from typing import Iterable

MEDIA_EXTENSIONS = {".bik", ".smk"}
REFERENCE_SUFFIXES = {
    ".cpp", ".h", ".hpp", ".c", ".cc", ".lua", ".txt", ".json", ".md", ".toml", ".ini", ".yml", ".yaml",
}
# Runtime/source evidence lives in the engine and asset trees.  Generated Korean
# catalogs are intentionally excluded: scanning them is expensive and can turn a
# translated mention of a movie name into a circular false reference.
REFERENCE_ROOTS = ("game", "assets_dev")
MAX_REFERENCES_PER_MEDIA = 20

SHOW_MOVIE_RE = re.compile(r"\bevt\.ShowMovie\s*\(\s*\"((?:\\.|[^\"\\])*)\"")
FIXED_CUTSCENE_STEM_RE = re.compile(
    r"constexpr\s+const\s+char\s*\*\s*([A-Za-z0-9_]*CutsceneStem)\s*=\s*\"([^\"]+)\""
)
LOSEGAME_RE = re.compile(r"(?i)(?<![A-Za-z0-9_])([67]?losegame)(?![A-Za-z0-9_])")


def normalize_movie_stem(raw: str) -> str:
    """Normalize Lua/C++ movie spellings without guessing aliases."""
    value = raw.replace(r'\"', '"').replace(r"\\", "\\").strip()
    while len(value) >= 2 and value[0] == value[-1] and value[0] in {'"', "'"}:
        value = value[1:-1].strip()
    return value


def media_entries(repo_root: Path) -> list[dict]:
    anim_root = repo_root / "data" / "Anims"
    if not anim_root.is_dir():
        raise ValueError(f"Legacy animation root is missing: {anim_root}")

    entries: list[dict] = []
    for path in sorted(anim_root.rglob("*"), key=lambda value: value.as_posix().casefold()):
        if not path.is_file() or path.suffix.casefold() not in MEDIA_EXTENSIONS:
            continue
        relative = path.relative_to(repo_root).as_posix()
        entries.append(
            {
                "source_path": relative,
                "source_group": path.parent.name,
                "stem": path.stem,
                "extension": path.suffix.casefold(),
                "bytes": path.stat().st_size,
                "subtitle_path": f"subtitles/{path.stem}.srt",
                "references": [],
                "runtime_references": [],
            }
        )
    if not entries:
        raise ValueError(f"No SMK/BIK media found under {anim_root}")
    return entries


def iter_reference_files(repo_root: Path) -> Iterable[Path]:
    for relative_root in REFERENCE_ROOTS:
        root = repo_root / relative_root
        if not root.is_dir():
            continue
        for path in root.rglob("*"):
            if path.is_file() and path.suffix.casefold() in REFERENCE_SUFFIXES:
                yield path


def normalized_search_tokens(entry: dict) -> set[str]:
    stem = str(entry["stem"])
    filename = Path(str(entry["source_path"])).name
    return {token for token in {stem.casefold(), filename.casefold()} if len(token) >= 3}


def attach_textual_references(repo_root: Path, entries: list[dict]) -> None:
    token_to_entries: dict[str, list[dict]] = {}
    token_patterns: dict[str, re.Pattern[str]] = {}
    for entry in entries:
        for token in normalized_search_tokens(entry):
            token_to_entries.setdefault(token, []).append(entry)
            token_patterns.setdefault(token, re.compile(rf"(?<![A-Za-z0-9_]){re.escape(token)}(?![A-Za-z0-9_])"))

    tokens = sorted(token_to_entries, key=len, reverse=True)
    for path in iter_reference_files(repo_root):
        try:
            text = path.read_text(encoding="utf-8-sig")
        except (UnicodeDecodeError, OSError):
            continue
        relative = path.relative_to(repo_root).as_posix()
        for line_number, line in enumerate(text.splitlines(), start=1):
            lowered = line.casefold()
            matched_entries: set[int] = set()
            for token in tokens:
                if not token_patterns[token].search(lowered):
                    continue
                for entry in token_to_entries[token]:
                    identity = id(entry)
                    if identity in matched_entries or len(entry["references"]) >= MAX_REFERENCES_PER_MEDIA:
                        continue
                    matched_entries.add(identity)
                    excerpt = re.sub(r"\s+", " ", line.strip())
                    if len(excerpt) > 240:
                        excerpt = excerpt[:237] + "..."
                    entry["references"].append({"path": relative, "line": line_number, "excerpt": excerpt})


def world_from_event_path(path: Path, repo_root: Path) -> tuple[str | None, str]:
    relative = path.relative_to(repo_root).as_posix()
    parts = relative.split("/")
    source_world = None
    if len(parts) >= 3 and parts[0] == "assets_dev" and parts[1] == "worlds":
        source_world = parts[2].casefold()
    variant = "mmmerge" if path.stem.casefold().endswith("_mmmerge") else "base"
    return source_world, variant


def scan_show_movie_calls(repo_root: Path) -> list[dict]:
    worlds_root = repo_root / "assets_dev" / "worlds"
    references: list[dict] = []
    if not worlds_root.is_dir():
        return references

    for path in sorted(worlds_root.rglob("*.lua"), key=lambda value: value.as_posix().casefold()):
        try:
            text = path.read_text(encoding="utf-8-sig")
        except (UnicodeDecodeError, OSError):
            continue
        source_world, variant = world_from_event_path(path, repo_root)
        relative = path.relative_to(repo_root).as_posix()
        for line_number, line in enumerate(text.splitlines(), start=1):
            for match in SHOW_MOVIE_RE.finditer(line):
                stem = normalize_movie_stem(match.group(1))
                if not stem:
                    continue
                references.append(
                    {
                        "stem": stem,
                        "kind": "evt.ShowMovie",
                        "world": source_world,
                        "variant": variant,
                        "path": relative,
                        "line": line_number,
                        "excerpt": re.sub(r"\s+", " ", line.strip())[:240],
                    }
                )
    return references


def scan_fixed_runtime_stems(repo_root: Path) -> list[dict]:
    references: list[dict] = []
    game_application = repo_root / "game" / "app" / "GameApplication.cpp"
    if game_application.is_file():
        text = game_application.read_text(encoding="utf-8-sig")
        for match in FIXED_CUTSCENE_STEM_RE.finditer(text):
            line_number = text.count("\n", 0, match.start()) + 1
            references.append(
                {
                    "stem": normalize_movie_stem(match.group(2)),
                    "kind": "fixed_cutscene_stem",
                    "symbol": match.group(1),
                    "world": None,
                    "variant": "runtime",
                    "path": game_application.relative_to(repo_root).as_posix(),
                    "line": line_number,
                }
            )

    # Defeat movies are continent-configurable.  Record exact losegame-shaped
    # tokens from source/config text so 6losegame/7losegame are not hidden by
    # the generic LoseGame fallback.
    seen_locations: set[tuple[str, str, int]] = set()
    for path in iter_reference_files(repo_root):
        try:
            text = path.read_text(encoding="utf-8-sig")
        except (UnicodeDecodeError, OSError):
            continue
        relative = path.relative_to(repo_root).as_posix()
        for line_number, line in enumerate(text.splitlines(), start=1):
            for match in LOSEGAME_RE.finditer(line):
                stem = match.group(1)
                location = (stem.casefold(), relative, line_number)
                if location in seen_locations:
                    continue
                seen_locations.add(location)
                references.append(
                    {
                        "stem": stem,
                        "kind": "defeat_stem_reference",
                        "world": None,
                        "variant": "runtime",
                        "path": relative,
                        "line": line_number,
                        "excerpt": re.sub(r"\s+", " ", line.strip())[:240],
                    }
                )
    return references


def runtime_stem_entries(repo_root: Path) -> list[dict]:
    references = scan_show_movie_calls(repo_root) + scan_fixed_runtime_stems(repo_root)
    by_stem: dict[str, dict] = {}
    for reference in references:
        key = reference["stem"].casefold()
        entry = by_stem.setdefault(
            key,
            {
                "stem": reference["stem"],
                "subtitle_path": f"subtitles/{reference['stem']}.srt",
                "worlds": [],
                "variants": [],
                "references": [],
            },
        )
        if reference.get("world") and reference["world"] not in entry["worlds"]:
            entry["worlds"].append(reference["world"])
        if reference.get("variant") and reference["variant"] not in entry["variants"]:
            entry["variants"].append(reference["variant"])
        entry["references"].append(reference)

    return sorted(by_stem.values(), key=lambda entry: entry["stem"].casefold())


def classify_media(entries: list[dict], runtime_entries: list[dict]) -> None:
    media_by_stem: dict[str, list[dict]] = {}
    for entry in entries:
        media_by_stem.setdefault(entry["stem"].casefold(), []).append(entry)

    for runtime_entry in runtime_entries:
        matches = media_by_stem.get(runtime_entry["stem"].casefold(), [])
        runtime_entry["source_media"] = [entry["source_path"] for entry in matches]
        runtime_entry["source_missing"] = not bool(matches)
        runtime_entry["review_status"] = "needs_dialogue_review"
        runtime_entry["review_rationale"] = (
            "Actual runtime cutscene stem. Spoken dialogue and timing must be verified before authoring SRT."
        )
        for entry in matches:
            entry["runtime_references"].extend(runtime_entry["references"])

    for entry in entries:
        if entry["runtime_references"]:
            entry["subtitle_candidate"] = "runtime_candidate"
            entry["candidate_rationale"] = (
                "Referenced by an actual runtime movie path; dialogue/timing still require verification."
            )
        elif entry["extension"] == ".smk" and any(
            reference["path"].endswith(("house_animations.txt", "house_movies.txt"))
            for reference in entry["references"]
        ):
            entry["subtitle_candidate"] = "building_animation"
            entry["candidate_rationale"] = (
                "Legacy SMK referenced by house animation/movie tables and not by a runtime cutscene call."
            )
        elif entry["extension"] == ".smk":
            entry["subtitle_candidate"] = "ambient_or_building_review"
            entry["candidate_rationale"] = (
                "Legacy SMK with no runtime cutscene reference; review only if later runtime evidence appears."
            )
        else:
            entry["subtitle_candidate"] = "source_unreferenced"
            entry["candidate_rationale"] = (
                "Legacy BIK currently has no matched runtime movie reference; do not invent subtitles."
            )


def build_inventory(repo_root: Path) -> dict:
    entries = media_entries(repo_root)
    attach_textual_references(repo_root, entries)
    runtime_entries = runtime_stem_entries(repo_root)
    classify_media(entries, runtime_entries)

    extension_counts: dict[str, int] = {}
    candidate_counts: dict[str, int] = {}
    for entry in entries:
        extension_counts[entry["extension"]] = extension_counts.get(entry["extension"], 0) + 1
        candidate = entry["subtitle_candidate"]
        candidate_counts[candidate] = candidate_counts.get(candidate, 0) + 1

    source_missing = sum(1 for entry in runtime_entries if entry["source_missing"])
    return {
        "format": 2,
        "purpose": "Korean external SRT runtime/source inventory",
        "runtime_convention": "subtitles/<video-stem>.srt",
        "source_roots": ["data/Anims/Magicdod.vid", "data/Anims/mightdod.vid"],
        "notes": [
            "runtime_stems are derived from evt.ShowMovie, fixed CutsceneStem constants, and losegame-shaped runtime/config references.",
            "needs_dialogue_review does not prove speech; no subtitle text may be invented from the stem alone.",
            "building_animation marks source SMKs tied to house animation/movie tables with no runtime cutscene call.",
            "source_missing means the runtime stem has no same-stem SMK/BIK under data/Anims; converted/runtime video assets may come from another source.",
        ],
        "summary": {
            "media": len(entries),
            "runtime_stems": len(runtime_entries),
            "runtime_source_missing": source_missing,
            "by_extension": dict(sorted(extension_counts.items())),
            "by_candidate": dict(sorted(candidate_counts.items())),
        },
        "runtime_stems": runtime_entries,
        "entries": entries,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", default=None)
    parser.add_argument("--output", default="korean/subtitles/source_inventory.json")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    output_path = repo_root / args.output
    inventory = build_inventory(repo_root)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(inventory, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    summary = inventory["summary"]
    print(f"CUTSCENE_MEDIA={summary['media']}")
    print(f"CUTSCENE_RUNTIME_STEMS={summary['runtime_stems']}")
    print(f"CUTSCENE_RUNTIME_SOURCE_MISSING={summary['runtime_source_missing']}")
    for extension, count in summary["by_extension"].items():
        print(f"CUTSCENE_{extension[1:].upper()}={count}")
    print(f"WROTE={output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
