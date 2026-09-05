"""Read MMMerge's four-column text localization format without dropping lines."""

import csv
import io
from pathlib import Path


def read_field_overlay(path: Path) -> tuple[dict[tuple[int, str], str], str]:
    raw = path.read_bytes()
    try:
        text = raw.decode('utf-8-sig')
        encoding = 'utf-8-sig'
    except UnicodeDecodeError:
        text = raw.decode('cp949')
        encoding = 'cp949'
    rows = list(csv.reader(io.StringIO(text, newline=''), delimiter='\t', quotechar='"'))
    result: dict[tuple[int, str], str] = {}
    current_key: tuple[int, str] | None = None
    for row in rows[1:]:
        if len(row) >= 4 and row[1].strip().isdigit():
            current_key = (int(row[1].strip()), row[2].strip())
            if current_key in result:
                raise ValueError(f'Duplicate translation field in {path}: {current_key}')
            result[current_key] = row[3]
        elif current_key is not None:
            continuation = '\t'.join(row)
            result[current_key] += ('\n' if result[current_key] else '') + continuation
        elif any(cell.strip() for cell in row):
            raise ValueError(f'Translation continuation has no record in {path}: {row!r}')
    return result, encoding
