#!/usr/bin/env python3
"""Build small Korean overlay archives without repackaging upstream game assets."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys
import zipfile

PACKAGE_IDS = ("engine", "mm6", "mm7", "mm8", "mmmerge")
WORLD_PACKAGE_IDS = ("mm6", "mm7", "mm8", "mmmerge")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def iter_files(root: Path):
    if not root.is_dir():
        return
    for path in sorted(root.rglob("*")):
        if path.is_file():
            yield path


def write_overlay_zip(source_root: Path, output_path: Path) -> int:
    files = list(iter_files(source_root) or ())
    if not files:
        return 0

    output_path.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(output_path, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for path in files:
            archive.write(path, path.relative_to(source_root).as_posix())
    return len(files)



def extend_map_runtime_catalog_if_available(repo_root: Path) -> None:
    catalog_path = repo_root / "korean" / "translations" / "catalog.json"
    po_path = repo_root / "korean" / "translations" / "ko.po"
    tool = repo_root / "korean" / "tools" / "extend_map_runtime_catalog.py"
    if not catalog_path.is_file() or not po_path.is_file() or not tool.is_file():
        return

    subprocess.run(
        [
            sys.executable,
            str(tool),
            "--repo-root",
            str(repo_root),
            "--catalog",
            str(catalog_path),
            "--po",
            str(po_path),
        ],
        check=True,
    )


def sync_map_target_names_if_available(repo_root: Path) -> None:
    tool = repo_root / "korean" / "tools" / "sync_map_target_names.py"
    if not tool.is_file():
        return
    subprocess.run(
        [sys.executable, str(tool), "--repo-root", str(repo_root)],
        check=True,
    )

def apply_reviewed_feedback_if_available(repo_root: Path) -> None:
    catalog_path = repo_root / "korean" / "translations" / "catalog.json"
    if not catalog_path.is_file():
        return

    correction_tools = (
        repo_root / "korean" / "tools" / "apply_review_feedback_corrections.py",
        repo_root / "korean" / "tools" / "apply_deep_review_corrections.py",
        repo_root / "korean" / "tools" / "apply_source_semantic_corrections.py",
        repo_root / "korean" / "tools" / "apply_mmmerge_116a_feedback.py",
    )
    for correction_tool in correction_tools:
        if not correction_tool.is_file():
            continue
        subprocess.run(
            [
                sys.executable,
                str(correction_tool),
                "--repo-root",
                str(repo_root),
            ],
            check=True,
        )


def apply_po_if_available(repo_root: Path) -> None:
    catalog_path = repo_root / "korean" / "translations" / "catalog.json"
    po_path = repo_root / "korean" / "translations" / "ko.po"
    po_tool = repo_root / "korean" / "tools" / "catalog_po.py"
    if not catalog_path.is_file() or not po_path.is_file() or not po_tool.is_file():
        return

    subprocess.run(
        [
            sys.executable,
            str(po_tool),
            "import",
            "--repo-root",
            str(repo_root),
            "--catalog",
            str(catalog_path),
            "--po",
            str(po_path),
        ],
        check=True,
    )


def verify_po_runtime_if_available(repo_root: Path) -> None:
    catalog_path = repo_root / "korean" / "translations" / "catalog.json"
    po_path = repo_root / "korean" / "translations" / "ko.po"
    po_tool = repo_root / "korean" / "tools" / "catalog_po.py"
    if not catalog_path.is_file() or not po_path.is_file() or not po_tool.is_file():
        return

    subprocess.run(
        [
            sys.executable,
            str(po_tool),
            "verify-runtime",
            "--repo-root",
            str(repo_root),
            "--catalog",
            str(catalog_path),
            "--po",
            str(po_path),
        ],
        check=True,
    )



def verify_packaged_runtime_regressions(repo_root: Path, package_root: Path) -> None:
    catalog_path = repo_root / "korean" / "translations" / "catalog.json"
    engine_zip = package_root / "engine.zip"
    mm8_zip = package_root / "worlds" / "mm8.zip"
    if not catalog_path.is_file() or not engine_zip.is_file() or not mm8_zip.is_file():
        return

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    entries = {str(entry["key"]): entry for entry in catalog.get("entries", [])}

    npc_key = "engine:npc_topic_text.txt:2:Text"
    npc_entry = entries.get(npc_key)
    if npc_entry is not None:
        with zipfile.ZipFile(engine_zip) as archive:
            member = "data_tables/npc_topic_text.txt"
            if member not in archive.namelist():
                raise ValueError(f"Final engine overlay is missing {member}")
            payload = archive.read(member).decode("utf-8-sig")
        expected = str(npc_entry.get("translation", ""))
        source = str(npc_entry.get("source", ""))
        if not expected or expected not in payload:
            raise ValueError(f"Final engine overlay is missing Korean NPC text for {npc_key}")
        if source and source != expected and source in payload:
            raise ValueError(f"Final engine overlay still contains reported English NPC text for {npc_key}")

    with zipfile.ZipFile(mm8_zip) as archive:
        member = "events/maps/out01.lua"
        if member not in archive.namelist():
            raise ValueError(f"Final MM8 overlay is missing {member}")
        out01 = archive.read(member).decode("utf-8-sig")

    runtime_prefix = "world:mm8:out01.lua:runtime:"
    runtime_entries = [
        entry for key, entry in entries.items()
        if key.startswith(runtime_prefix)
    ]
    if not runtime_entries:
        raise ValueError("No direct MM8 out01 runtime PO entries were generated")
    for entry in runtime_entries:
        source = str(entry.get("source", ""))
        translation = str(entry.get("translation", ""))
        if not translation or f'"{translation}"' not in out01:
            raise ValueError(f"Final MM8 overlay is missing runtime translation for {entry['key']}")
        if source != translation and f'"{source}"' in out01:
            raise ValueError(f"Final MM8 overlay still contains runtime English for {entry['key']}")

    house_translation = next(
        (
            str(entry.get("translation", ""))
            for entry in catalog.get("entries", [])
            if Path(str(entry.get("source_file", ""))).name.casefold() == "house_data.txt"
            and str(entry.get("field", "")).casefold() == "name"
            and str(entry.get("record_id", "")) == "761"
        ),
        "",
    )
    if not house_translation or f'"{house_translation}"' not in out01:
        raise ValueError("Final MM8 overlay is missing translated Hiss' Hut event title")
    if "\"Hiss' Hut\"" in out01:
        raise ValueError("Final MM8 overlay still contains quoted Hiss' Hut runtime title")


def build(repo_root: Path, output_root: Path) -> dict:
    # Catalog/table importers intentionally remain faithful to their upstream
    # sources. Apply reviewed player-feedback corrections after all generated
    # engine/world overlays exist, then apply optional PO edits immediately
    # before packaging the native runtime files.
    extend_map_runtime_catalog_if_available(repo_root)
    apply_reviewed_feedback_if_available(repo_root)
    apply_po_if_available(repo_root)
    sync_map_target_names_if_available(repo_root)
    verify_po_runtime_if_available(repo_root)

    overlay_root = repo_root / "korean" / "overlay"
    package_root = output_root / "korean"

    if output_root.exists():
        shutil.rmtree(output_root)
    package_root.mkdir(parents=True, exist_ok=True)

    built = []

    engine_zip = package_root / "engine.zip"
    engine_count = write_overlay_zip(overlay_root / "engine", engine_zip)
    if engine_count:
        built.append(("engine", engine_zip, engine_count))

    for world_id in WORLD_PACKAGE_IDS:
        world_zip = package_root / "worlds" / f"{world_id}.zip"
        file_count = write_overlay_zip(overlay_root / "worlds" / world_id, world_zip)
        if file_count:
            built.append((world_id, world_zip, file_count))

    verify_packaged_runtime_regressions(repo_root, package_root)

    manifest = {
        "format": 1,
        "distribution": "overlay-only",
        "targets": ["windows-x64", "android-arm64"],
        "packages": [
            {
                "id": package_id,
                "path": path.relative_to(output_root).as_posix(),
                "files": file_count,
                "bytes": path.stat().st_size,
                "sha256": sha256_file(path),
            }
            for package_id, path, file_count in built
        ],
    }

    manifest_path = output_root / "manifest.json"
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    checksums_path = output_root / "SHA256SUMS.txt"
    checksum_lines = [
        f"{entry['sha256']}  {entry['path']}" for entry in manifest["packages"]
    ]
    checksum_lines.append(f"{sha256_file(manifest_path)}  manifest.json")
    checksums_path.write_text("\n".join(checksum_lines) + "\n", encoding="utf-8")

    return manifest


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output",
        default="dist/korean-patch",
        help="Output directory relative to the repository root",
    )
    args = parser.parse_args()

    repo_root = Path(__file__).resolve().parents[1]
    output_root = (repo_root / args.output).resolve()
    manifest = build(repo_root, output_root)

    if not manifest["packages"]:
        print("No Korean overlay files were found; created an empty manifest only.")
        return 0

    print(f"Built {len(manifest['packages'])} Korean overlay package(s) in {output_root}")
    for package in manifest["packages"]:
        print(f"  {package['id']}: {package['files']} files, {package['bytes']} bytes")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
