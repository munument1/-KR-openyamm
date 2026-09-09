#!/usr/bin/env python3
"""Inventory legacy SMK/BIK movies for Korean external subtitle work.

The runtime subtitle renderer consumes ``subtitles/<video-stem>.srt``.  This
script inventories the original media under ``data/Anims`` and records textual
source references without pretending that every animation contains dialogue.
Bink files are marked as higher-priority *candidates* only; actual speech and
subtitle timing still require review of the corresponding movie.
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
REFERENCE_ROOTS = (
    "game",
    "assets_dev",
    "korean",
)
MAX_REFERENCES_PER_MEDIA = 20


def media_entries(repo_root: Path) -> list[dict]:
    anim_root = repo_root / "data" / "Anims"
    if not anim_root.is_dir():
        raise ValueError(f"Legacy animation root is missing: {anim_root}")

    entries: list[dict] = []
    for path in sorted(anim_root.rglob("*"), key=lambda value: value.as_posix().casefold()):
        if not path.is_file() or path.suffix.casefold() not in MEDIA_EXTENSIONS:
            continue
        relative = path.relative_to(repo_root).as_posix()
        extension = path.suffix.casefold()
        stem = path.stem
        source_group = path.parent.name
        if extension == ".bik":
            candidate = "priority_candidate"
            rationale = "Bink movie; likely full-screen/story media, but dialogue must be verified manually."
        else:
            candidate = "needs_review"
            rationale = "Smacker animation; many are building/ambient loops, so speech must be verified manually."
        entries.append(
            {
                "source_path": relative,
                "source_group": source_group,
                "stem": stem,
                "extension": extension,
                "bytes": path.stat().st_size,
                "subtitle_path": f"subtitles/{stem}.srt",
                "subtitle_candidate": candidate,
                "candidate_rationale": rationale,
                "references": [],
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
    tokens = {stem.casefold(), filename.casefold()}
    return {token for token in tokens if len(token) >= 3}


def attach_references(repo_root: Path, entries: list[dict]) -> None:
    token_to_entries: dict[str, list[dict]] = {}
    for entry in entries:
        for token in normalized_search_tokens(entry):
            token_to_entries.setdefault(token, []).append(entry)

    # Longest first avoids recording both filename and stem matches from the
    # same line as separate references.
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
                if token not in lowered:
                    continue
                for entry in token_to_entries[token]:
                    identity = id(entry)
                    if identity in matched_entries or len(entry["references"]) >= MAX_REFERENCES_PER_MEDIA:
                        continue
                    matched_entries.add(identity)
                    excerpt = re.sub(r"\s+", " ", line.strip())
                    if len(excerpt) > 240:
                        excerpt = excerpt[:237] + "..."
                    entry["references"].append(
                        {
                            "path": relative,
                            "line": line_number,
                            "excerpt": excerpt,
                        }
                    )


def build_inventory(repo_root: Path) -> dict:
    entries = media_entries(repo_root)
    attach_references(repo_root, entries)
    extension_counts: dict[str, int] = {}
    candidate_counts: dict[str, int] = {}
    referenced = 0
    for entry in entries:
        extension_counts[entry["extension"]] = extension_counts.get(entry["extension"], 0) + 1
        candidate_counts[entry["subtitle_candidate"]] = candidate_counts.get(entry["subtitle_candidate"], 0) + 1
        if entry["references"]:
            referenced += 1

    return {
        "format": 1,
        "purpose": "Korean external SRT subtitle source inventory",
        "runtime_convention": "subtitles/<video-stem>.srt",
        "source_roots": ["data/Anims/Magicdod.vid", "data/Anims/mightdod.vid"],
        "notes": [
            "priority_candidate does not prove that a movie contains spoken dialogue.",
            "needs_review SMK entries include many ambient/building animations and must not receive invented subtitles.",
            "references are textual repository matches only; they are not transcripts or timing sources.",
        ],
        "summary": {
            "media": len(entries),
            "by_extension": dict(sorted(extension_counts.items())),
            "by_candidate": dict(sorted(candidate_counts.items())),
            "with_textual_references": referenced,
        },
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
    for extension, count in summary["by_extension"].items():
        print(f"CUTSCENE_{extension[1:].upper()}={count}")
    print(f"CUTSCENE_REFERENCED={summary['with_textual_references']}")
    print(f"WROTE={output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
