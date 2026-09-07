"""Regression checks for Korean decoration hover/display text coverage."""

from __future__ import annotations

import csv
import io
import json
from pathlib import Path
import unittest


REPOSITORY_ROOT = Path(__file__).resolve().parents[2]


class DecorationCatalogTests(unittest.TestCase):
    def test_all_visible_decoration_hints_are_mapped_or_explicitly_excluded(self) -> None:
        source_path = REPOSITORY_ROOT / "assets_dev/engine/data_tables/decoration_data.txt"
        raw = source_path.read_bytes()
        text = None
        for encoding in ("utf-8-sig", "cp1252"):
            try:
                text = raw.decode(encoding)
                break
            except UnicodeDecodeError:
                continue
        self.assertIsNotNone(text)

        payload = json.loads(
            (REPOSITORY_ROOT / "korean/translations/decoration_hints.json").read_text(encoding="utf-8")
        )
        translations = {str(key).strip().casefold(): str(value).strip() for key, value in payload["entries"].items()}
        excluded = {str(value).strip().casefold() for value in payload["excluded_sources"]}

        unknown = set()
        for row in csv.reader(io.StringIO(text, newline=""), delimiter="\t", quotechar='"'):
            if len(row) < 3 or not row[0].strip().isdigit():
                continue
            hint = row[2].strip()
            normalized = hint.casefold()
            if hint and normalized not in translations and normalized not in excluded:
                unknown.add(hint)

        self.assertEqual(set(), unknown)

    def test_common_world_objects_have_korean_display_names(self) -> None:
        payload = json.loads(
            (REPOSITORY_ROOT / "korean/translations/decoration_hints.json").read_text(encoding="utf-8")
        )
        translations = {str(key).casefold(): str(value) for key, value in payload["entries"].items()}
        self.assertEqual("나무", translations["tree"])
        self.assertEqual("나무통", translations["barrel"])
        self.assertEqual("룬 표지판", translations["rune post"])
        self.assertEqual("길 표지판", translations["path marker"])


if __name__ == "__main__":
    unittest.main()
