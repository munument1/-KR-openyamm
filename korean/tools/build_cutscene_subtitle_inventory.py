#!/usr/bin/env python3
"""Inventory runtime cutscene stems, OGV assets, and legacy media for Korean SRT work.

The subtitle runtime consumes ``subtitles/<video-stem>.srt``.  The important
questions are therefore which stems the game asks CutsceneVideoScreen to play
and which OGV files are actually shipped under each world's Videos/Cutscenes
directory, not merely which movies happen to exist in ``data/Anims``.

Classification remains deliberately conservative: repository references and
media presence can prove that a movie exists and is used, but cannot prove that
it contains spoken dialogue.  Story/runtime candidates still require transcript
and timing review before an SRT is authored.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
from typing import Iterable

MEDIA_EXTENSIONS = {".bik", ".smk"}
RUNTIME_VIDEO_EXTENSION = ".ogv"
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


def runtime_video_entries(repo_root: Path) -> list[dict]:
    """Enumerate actual converted cutscene videos shipped by each world."""
    worlds_root = repo_root / "assets_dev" / "worlds"
    entries: list[dict] = []
    if not worlds_root.is_dir():
        return entries

    for world_dir in sorted(worlds_root.iterdir(), key=lambda value: value.name.casefold()):
        if not world_dir.is_dir():
            continue
        cutscene_root = world_dir / "videos" / "Cutscenes"
        if not cutscene_root.is_dir():
            continue
        for path in sorted(cutscene_root.iterdir(), key=lambda value: value.name.casefold()):
            if not path.is_file() or path.suffix.casefold() != RUNTIME_VIDEO_EXTENSION:
                continue
            entries.append(
                {
                    "world": world_dir.name.casefold(),
                    "stem": path.stem,
                    "path": path.relative_to(repo_root).as_posix(),
                    "bytes": path.stat().st_size,
                    "subtitle_path": f"subtitles/{path.stem}.srt",
                    "referenced": False,
                    "references": [],
                    "review_status": "needs_usage_review",
                    "review_rationale": (
                        "Runtime OGV exists, but no direct repository movie reference has been matched yet. "
                        "Do not infer dialogue or invent subtitles."
                    ),
                }
            )
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

    # Defeat movies are continent-configurable. Record exact losegame-shaped
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


def attach_runtime_video_evidence(runtime_entries: list[dict], runtime_videos: list[dict]) -> None:
    videos_by_stem: dict[str, list[dict]] = {}
    runtime_by_stem: dict[str, dict] = {}
    for video in runtime_videos:
        videos_by_stem.setdefault(video["stem"].casefold(), []).append(video)
    for runtime_entry in runtime_entries:
        runtime_by_stem[runtime_entry["stem"].casefold()] = runtime_entry

    for runtime_entry in runtime_entries:
        matches = videos_by_stem.get(runtime_entry["stem"].casefold(), [])
        runtime_entry["runtime_video_assets"] = [video["path"] for video in matches]
        runtime_entry["runtime_video_worlds"] = sorted({video["world"] for video in matches})
        runtime_entry["runtime_video_missing"] = not bool(matches)

    for video in runtime_videos:
        runtime_entry = runtime_by_stem.get(video["stem"].casefold())
        if runtime_entry is None:
            continue
        video["referenced"] = True
        video["references"] = runtime_entry["references"]
        video["review_status"] = "needs_dialogue_review"
        video["review_rationale"] = (
            "Runtime OGV is matched by an actual movie reference. Spoken dialogue and timing must still be verified."
        )


def classify_media(entries: list[dict], runtime_entries: list[dict]) -> None:
    media_by_stem: dict[str, list[dict]] = {}
    for entry in entries:
        media_by_stem.setdefault(entry["stem"].casefold(), []).append(entry)

    for runtime_entry in runtime_entries:
        matches = media_by_stem.get(runtime_entry["stem"].casefold(), [])
        # Keep the old source_media/source_missing names for compatibility. They
        # refer specifically to legacy SMK/BIK source containers, not runtime OGVs.
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
    runtime_videos = runtime_video_entries(repo_root)
    attach_textual_references(repo_root, entries)
    runtime_entries = runtime_stem_entries(repo_root)
    attach_runtime_video_evidence(runtime_entries, runtime_videos)
    classify_media(entries, runtime_entries)

    extension_counts: dict[str, int] = {}
    candidate_counts: dict[str, int] = {}
    for entry in entries:
        extension_counts[entry["extension"]] = extension_counts.get(entry["extension"], 0) + 1
        candidate = entry["subtitle_candidate"]
        candidate_counts[candidate] = candidate_counts.get(candidate, 0) + 1

    source_missing = sum(1 for entry in runtime_entries if entry["source_missing"])
    runtime_video_missing = sum(1 for entry in runtime_entries if entry["runtime_video_missing"])
    referenced_runtime_videos = sum(1 for entry in runtime_videos if entry["referenced"])
    return {
        "format": 3,
        "purpose": "Korean external SRT runtime/source inventory",
        "runtime_convention": "subtitles/<video-stem>.srt",
        "source_roots": [
            "assets_dev/worlds/*/videos/Cutscenes",
            "data/Anims/Magicdod.vid",
            "data/Anims/mightdod.vid",
        ],
        "notes": [
            "runtime_stems are derived from evt.ShowMovie, fixed CutsceneStem constants, and losegame-shaped runtime/config references.",
            "runtime_videos are actual OGV assets under assets_dev/worlds/*/videos/Cutscenes.",
            "An unreferenced runtime OGV is not automatically unused; data-driven or dynamic references may still require manual review.",
            "needs_dialogue_review does not prove speech; no subtitle text may be invented from the stem alone.",
            "building_animation marks source SMKs tied to house animation/movie tables with no runtime cutscene call.",
            "source_missing refers only to same-stem legacy SMK/BIK under data/Anims, not to runtime OGV availability.",
        ],
        "summary": {
            "media": len(entries),
            "runtime_stems": len(runtime_entries),
            "runtime_source_missing": source_missing,
            "runtime_stem_video_missing": runtime_video_missing,
            "runtime_videos": len(runtime_videos),
            "runtime_videos_referenced": referenced_runtime_videos,
            "runtime_videos_unreferenced": len(runtime_videos) - referenced_runtime_videos,
            "by_extension": dict(sorted(extension_counts.items())),
            "by_candidate": dict(sorted(candidate_counts.items())),
        },
        "runtime_stems": runtime_entries,
        "runtime_videos": runtime_videos,
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
    print(f"CUTSCENE_RUNTIME_VIDEO_MISSING={summary['runtime_stem_video_missing']}")
    print(f"CUTSCENE_RUNTIME_OGV={summary['runtime_videos']}")
    print(f"CUTSCENE_RUNTIME_OGV_REFERENCED={summary['runtime_videos_referenced']}")
    print(f"CUTSCENE_RUNTIME_OGV_UNREFERENCED={summary['runtime_videos_unreferenced']}")
    for extension, count in summary["by_extension"].items():
        print(f"CUTSCENE_{extension[1:].upper()}={count}")
    print(f"WROTE={output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
