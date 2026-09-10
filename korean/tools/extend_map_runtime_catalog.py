#!/usr/bin/env python3
"""Materialize direct map-event runtime strings stored in the main Korean PO.

Legacy STR/KO_MapStrings covers most map text, but generated Lua also contains
player-facing literals that never came from STR files.  Entries whose PO
context is `world:<world>:<map>.lua:runtime:<id>` are treated as reviewed
runtime strings, appended to the generated catalog, and materialized into the
normal world Lua overlay before the final PO verification step.
"""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

import catalog_po

RUNTIME_CONTEXT_RE = re.compile(
    r"^world:(mm6|mm7|mm8|mmmerge):([^:]+\.lua):runtime:([A-Za-z0-9_.-]+)$"
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


def apply_runtime_po(repo_root: Path, catalog_path: Path, po_path: Path) -> tuple[int, int]:
    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    po_entries = catalog_po.parse_po(po_path.read_text(encoding="utf-8-sig"))
    existing_keys = {str(entry["key"]) for entry in catalog.get("entries", [])}

    selected: list[tuple[re.Match[str], dict[str, str]]] = []
    seen: set[str] = set()
    for po_entry in po_entries:
        context = po_entry.get("msgctxt", "")
        match = RUNTIME_CONTEXT_RE.fullmatch(context)
        if match is None:
            continue
        if context in seen:
            raise ValueError(f"Duplicate map-runtime PO context: {context}")
        seen.add(context)
        selected.append((match, po_entry))

    materialized_files: set[Path] = set()
    new_entries: list[dict] = []
    for match, po_entry in selected:
        context = po_entry["msgctxt"]
        if context in existing_keys:
            raise ValueError(f"Map-runtime PO context collides with generated catalog: {context}")

        world_id, lua_name, runtime_id = match.groups()
        source = po_entry.get("msgid", "")
        translation = po_entry.get("msgstr", "")
        if not source or not translation:
            raise ValueError(f"Map-runtime PO entry must have source and translation: {context}")
        if catalog_po.placeholder_tokens(source) != catalog_po.placeholder_tokens(translation):
            raise ValueError(f"Map-runtime PO placeholder mismatch: {context}")

        source_path = repo_root / "assets_dev" / "worlds" / world_id / "events" / "maps" / lua_name
        if not source_path.is_file():
            raise ValueError(f"Map-runtime source Lua is missing for {context}: {source_path}")

        overlay_path = repo_root / "korean" / "overlay" / "worlds" / world_id / "events" / "maps" / lua_name
        if overlay_path.is_file():
            text = overlay_path.read_text(encoding="utf-8")
        else:
            text = source_path.read_text(encoding="utf-8-sig")

        source_literal = lua_quoted(source)
        translation_literal = lua_quoted(translation)
        if source_literal in text:
            text = text.replace(source_literal, translation_literal)
        elif translation_literal not in text:
            raise ValueError(
                f"Map-runtime source literal is stale or missing for {context}: {source!r}"
            )

        overlay_path.parent.mkdir(parents=True, exist_ok=True)
        overlay_path.write_text(text, encoding="utf-8", newline="\n")
        materialized_files.add(overlay_path)

        new_entries.append({
            "key": context,
            "scope": f"world:{world_id}",
            "source_file": source_path.relative_to(repo_root).as_posix(),
            "record_id": f"runtime:{runtime_id}",
            "field": "RuntimeText",
            "source": source,
            "translation": translation,
            "translation_origin": "po",
            "status": "translated",
            "placeholder_ok": True,
            "note": "Direct generated-Lua display text maintained in korean/translations/ko.po.",
        })

    if new_entries:
        catalog["entries"].extend(new_entries)
        catalog["tables"].append({
            "overlay_source": "korean/translations/ko.po",
            "overlay_format": "direct generated-Lua runtime PO",
            "source_file": "assets_dev/worlds/*/events/maps/*.lua:runtime-po",
            "source_encoding": "utf-8",
            "mmmerge_encoding": None,
            "entries": len(new_entries),
            "translated": len(new_entries),
            "untranslated": 0,
            "placeholder_mismatches": 0,
            "overrides": len(new_entries),
            "excluded": 0,
            "generated_overlay_files": sorted(
                path.relative_to(repo_root).as_posix() for path in materialized_files
            ),
            "output_encoding": "utf-8",
        })
        catalog["format"] = max(int(catalog.get("format", 1)), 11)
        catalog_po.refresh_counts(catalog)
        catalog_path.write_text(
            json.dumps(catalog, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )

    print(
        f"Map-runtime PO: {len(new_entries)} entry(s), "
        f"{len(materialized_files)} Lua overlay file(s)"
    )
    return len(new_entries), len(materialized_files)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", default=None)
    parser.add_argument("--catalog", default="korean/translations/catalog.json")
    parser.add_argument("--po", default="korean/translations/ko.po")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    catalog_path = repo_root / args.catalog
    po_path = repo_root / args.po
    if not catalog_path.is_file() or not po_path.is_file():
        print("Map-runtime PO: catalog or PO not present; skipping")
        return 0

    apply_runtime_po(repo_root, catalog_path, po_path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
