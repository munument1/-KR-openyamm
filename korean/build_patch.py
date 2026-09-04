#!/usr/bin/env python3
"""Build small Korean overlay archives without repackaging upstream game assets."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import shutil
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


def build(repo_root: Path, output_root: Path) -> dict:
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
