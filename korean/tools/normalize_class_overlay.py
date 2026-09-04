#!/usr/bin/env python3
"""Keep class.txt logic keys in English while moving localized names to display-only column 3."""

from __future__ import annotations

import argparse
import csv
import io
from pathlib import Path


def read_tsv(path: Path, encodings: tuple[str, ...]) -> list[list[str]]:
    raw = path.read_bytes()
    for encoding in encodings:
        try:
            text = raw.decode(encoding)
            return list(csv.reader(io.StringIO(text, newline=""), delimiter="\t", quotechar='"'))
        except UnicodeDecodeError:
            continue
    raise ValueError(f"Could not decode {path}")


def write_tsv(path: Path, rows: list[list[str]]) -> None:
    with path.open("w", encoding="utf-8", newline="") as stream:
        csv.writer(
            stream,
            delimiter="\t",
            quotechar='"',
            quoting=csv.QUOTE_MINIMAL,
            lineterminator="\n",
        ).writerows(rows)


def ensure_column(row: list[str], index: int) -> None:
    while len(row) <= index:
        row.append("")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", default=None)
    parser.add_argument(
        "--source",
        default="assets_dev/engine/data_tables/english/class.txt",
    )
    parser.add_argument(
        "--overlay",
        default="korean/overlay/engine/data_tables/english/class.txt",
    )
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    source_path = repo_root / args.source
    overlay_path = repo_root / args.overlay

    source_rows = read_tsv(source_path, ("utf-8-sig", "cp1252"))
    overlay_rows = read_tsv(overlay_path, ("utf-8-sig",))

    if len(source_rows) != len(overlay_rows):
        raise ValueError(
            f"class.txt row count changed: source={len(source_rows)}, overlay={len(overlay_rows)}"
        )

    if not source_rows or not overlay_rows:
        raise ValueError("class.txt is empty")

    ensure_column(overlay_rows[0], 3)
    overlay_rows[0][0] = source_rows[0][0]
    overlay_rows[0][2] = source_rows[0][2]
    overlay_rows[0][3] = "Localized class name"

    localized_names = 0
    for row_index in range(1, len(source_rows)):
        source_row = source_rows[row_index]
        overlay_row = overlay_rows[row_index]

        if not source_row or not any(source_row):
            continue
        if len(source_row) < 3 or len(overlay_row) < 3:
            raise ValueError(f"Malformed class row {row_index + 1}")

        source_name = source_row[0]
        localized_name = overlay_row[0]

        if overlay_row[2] != source_row[2]:
            raise ValueError(
                f"Class kind changed at row {row_index + 1}: "
                f"source={source_row[2]!r}, overlay={overlay_row[2]!r}"
            )

        ensure_column(overlay_row, 3)
        overlay_row[0] = source_name
        overlay_row[2] = source_row[2]
        overlay_row[3] = localized_name if localized_name and localized_name != source_name else ""

        if overlay_row[3]:
            localized_names += 1

    if localized_names == 0:
        raise ValueError("No localized class display names were found")

    write_tsv(overlay_path, overlay_rows)
    print(f"class.txt: preserved English logic keys; moved {localized_names} localized names to column 3")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
