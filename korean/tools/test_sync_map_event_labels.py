#!/usr/bin/env python3
from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from korean.tools.sync_map_event_labels import catalog_translations, resolve_label, synchronize_text


class MapEventLabelSyncTests(unittest.TestCase):
    def test_catalog_and_generic_labels(self) -> None:
        catalog = {"entries": [{"source": "The Sharpening Stone", "translation": "숫돌"}]}
        exact = catalog_translations(catalog)
        self.assertEqual(resolve_label("The Sharpening Stone", exact), "숫돌")
        self.assertEqual(resolve_label("Keg", exact), None)
        self.assertEqual(resolve_label("Anvil", exact), "모루")
        self.assertEqual(resolve_label("Sign", exact), "표지판")
        self.assertEqual(resolve_label("Door", exact), "문")
        self.assertEqual(resolve_label("Operate Elev_1_Door", exact), "문")

    def test_register_event_and_tail_are_synchronized(self) -> None:
        catalog = {"entries": [{"source": "The Temple of the Moon", "translation": "달의 신전"}]}
        exact = catalog_translations(catalog)
        source = (
            'RegisterEvent(1, "Anvil", function()\nend, "Anvil")\n'
            'RegisterEvent(2, "The Temple of the Moon", nil, "The Temple of the Moon")\n'
        )
        output, changed, unresolved = synchronize_text(source, exact, "test.lua")
        self.assertEqual(unresolved, [])
        self.assertEqual(changed, 2)
        self.assertIn('RegisterEvent(1, "모루"', output)
        self.assertIn('end, "모루")', output)
        self.assertIn('RegisterEvent(2, "달의 신전"', output)

    def test_unknown_label_fails_closed(self) -> None:
        output, changed, unresolved = synchronize_text(
            'RegisterEvent(1, "Definitely Unknown Hover Label", nil)\n', {}, "test.lua"
        )
        self.assertEqual(changed, 0)
        self.assertEqual(output, 'RegisterEvent(1, "Definitely Unknown Hover Label", nil)\n')
        self.assertEqual(unresolved, ["test.lua: Definitely Unknown Hover Label"])


if __name__ == "__main__":
    unittest.main()
