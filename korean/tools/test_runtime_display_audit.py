#!/usr/bin/env python3
from __future__ import annotations

import importlib.util
from pathlib import Path
import unittest

MODULE_PATH = Path(__file__).with_name("audit_runtime_display_text.py")
spec = importlib.util.spec_from_file_location("audit_runtime_display_text", MODULE_PATH)
assert spec is not None and spec.loader is not None
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


class RuntimeDisplayAuditSinkTests(unittest.TestCase):
    def test_explicit_player_text_calls_are_detected(self) -> None:
        self.assertTrue(audit.is_player_sink_context('drawText(font, "Name");'))
        self.assertTrue(audit.is_player_sink_context('setStatusBarEvent("Ready");'))
        self.assertTrue(audit.is_player_sink_context('view.renderLayoutLabel(layout, resolved, "Shop");'))
        self.assertTrue(audit.is_player_sink_context('showMessage("Inventory full");'))

    def test_layout_lookup_identifiers_are_not_sinks(self) -> None:
        self.assertFalse(audit.is_player_sink_context('view.findHudLayoutElement("DialogueGoodbyeButton");'))
        self.assertFalse(audit.is_player_sink_context('const HudLayoutElement *pEventDialogLayout = view.findHudLayoutElement("DialogueEventDialog");'))
        self.assertFalse(audit.is_player_sink_context('const HudLayoutElement *pHouseTitleLayout = view.findHudLayoutElement("DialogueHouseTitle");'))
        self.assertFalse(audit.is_player_sink_context('view.resolveHudLayoutElement("DialogueEventDialog", width, height);'))

    def test_lookup_literals_and_unrelated_identifiers_do_not_count(self) -> None:
        self.assertFalse(audit.is_player_sink_context('equipStat == "Message"'))
        self.assertFalse(audit.is_player_sink_context('readStringMapFromField(state, -1, "title");'))
        self.assertFalse(audit.is_player_sink_context('return "<no description>";'))
        self.assertFalse(audit.is_player_sink_context('bool showEventDialogPanel = false;'))

    def test_player_text_assignments_are_detected(self) -> None:
        self.assertTrue(audit.is_player_sink_context('statusText = "Ready";'))
        self.assertTrue(audit.is_player_sink_context('prompt.assign("Choose one");'))


if __name__ == "__main__":
    unittest.main()
