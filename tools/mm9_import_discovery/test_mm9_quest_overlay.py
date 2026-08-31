#!/usr/bin/env python3
from __future__ import annotations

import csv
import io
import tempfile
import unittest
from pathlib import Path

from generate_mm9_quest_overlay import generate_quest_overlay


def rude_row(entry_id: int, title: str, description: str, required: int, forbidden: int) -> list[str]:
    row = ["0"] * 30
    row[0] = "997"
    row[1] = "997"
    row[2] = str(entry_id)
    row[3] = title
    row[4] = description
    row[5] = "997"
    row[6] = str(required)
    row[20] = str(forbidden)
    return row


class Mm9QuestOverlayTests(unittest.TestCase):
    def test_generates_namespaced_conditional_journal_rows(self) -> None:
        source_stream = io.StringIO(newline="")
        csv.writer(source_stream, lineterminator="\n").writerows([
            rude_row(1, "Complete training.", "Read the scroll.", 0, 473),
            rude_row(2, "Leave the island.", "Find a boat.", 473, 480),
        ])

        with tempfile.TemporaryDirectory() as directory:
            source_path = Path(directory) / "NPC997.rude"
            source_path.write_text(source_stream.getvalue(), encoding="latin-1")
            output = generate_quest_overlay(source_path)

        rows = list(csv.reader(io.StringIO(output), delimiter="\t"))
        self.assertEqual(rows[0][4:], ["Required QBits", "Forbidden QBits"])
        self.assertEqual(rows[1][0], "90001")
        self.assertEqual(rows[1][1], "Complete training.\n\nRead the scroll.")
        self.assertEqual(rows[1][4], "")
        self.assertEqual(rows[1][5], "90473")
        self.assertEqual(rows[2][0], "90002")
        self.assertEqual(rows[2][4], "90473")
        self.assertEqual(rows[2][5], "90480")


if __name__ == "__main__":
    unittest.main()
