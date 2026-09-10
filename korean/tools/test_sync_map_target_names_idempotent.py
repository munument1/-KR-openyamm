\
#!/usr/bin/env python3
from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from korean.tools.sync_map_target_names import synchronize_file


class MapTargetNameIdempotencyTests(unittest.TestCase):
    def test_prelocalized_overlay_does_not_require_exact_catalog_spelling(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = root / "assets_dev/worlds/mm6/events/maps/oute3.lua"
            source.parent.mkdir(parents=True)
            source.write_text(
                '    [1] = { kind = "enter_house", houseId = 1, targetName = "New Sorpigal Temple" },\n'
                '    RegisterEvent(1, "enter_house", "New Sorpigal Temple", function() end)\n',
                encoding="utf-8",
            )
            overlay = root / "korean/overlay/worlds/mm6/events/maps/oute3.lua"
            overlay.parent.mkdir(parents=True)
            overlay.write_text(
                '    [1] = { kind = "enter_house", houseId = 1, targetName = "뉴 소피갈 신전" },\n'
                '    RegisterEvent(1, "enter_house", "뉴 소피갈 신전", function() end)\n',
                encoding="utf-8",
            )

            changed, created, unresolved = synchronize_file(
                root,
                "mm6",
                source,
                {1: "뉴 소피갈 사원"},
                {},
            )
            self.assertEqual(changed, 0)
            self.assertFalse(created)
            self.assertEqual(unresolved, [])
            self.assertNotIn("New Sorpigal Temple", overlay.read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()
