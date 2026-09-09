#!/usr/bin/env python3
from pathlib import Path


audit_path = Path("korean/tools/audit_runtime_display_text.py")
text = audit_path.read_text(encoding="utf-8")
marker = "DEDICATED_DISPLAY = {\n"
helper = '''PLAYER_SINK_CALL_RE = re.compile(
    r"\\b(?:setStatusBarEvent|setStatus|drawText|renderText|displayText|drawScreenText|renderHud|renderLayoutLabel)\\s*\\("
)
PLAYER_NAMED_CALL_RE = re.compile(
    r"\\b(?:show|set|draw|render|display|update)(?:[A-Za-z0-9_]*(?:Message|Title|Label|Description|Tooltip|Prompt|Dialog))\\s*\\("
)
PLAYER_TEXT_ASSIGN_RE = re.compile(
    r"\\b(?:statusText|tooltip|prompt|endingText|characterLine|scoreLine|totalTimeLine)\\b\\s*(?:=|\\+=|\\.assign\\s*\\(|\\.append\\s*\\()"
)
NON_PLAYER_LOOKUP_CALL_RE = re.compile(
    r"\\b(?:findHudLayoutElement|resolveHudLayoutElement|defaultHudLayoutZIndexForScreen|readStringMapFromField)\\s*\\("
)


def is_player_sink_context(source_line: str) -> bool:
    # Quoted literals are data candidates, never sink evidence themselves.
    # Require a structural display call/assignment instead of broad substrings
    # such as "Dialog" appearing inside unrelated identifiers.
    code_context = LITERAL_RE.sub('""', source_line)
    if NON_PLAYER_LOOKUP_CALL_RE.search(code_context):
        return False
    return bool(
        PLAYER_SINK_CALL_RE.search(code_context)
        or PLAYER_NAMED_CALL_RE.search(code_context)
        or PLAYER_TEXT_ASSIGN_RE.search(code_context)
    )


'''
if "def is_player_sink_context(" not in text:
    if marker not in text:
        raise SystemExit("Could not locate helper insertion point")
    text = text.replace(marker, helper + marker, 1)
else:
    raise SystemExit("Unexpected pre-existing sink helper; inspect before patching")

old = "            player_sink = any(marker in stripped for marker in PLAYER_SINK_MARKERS)\n"
new = "            player_sink = is_player_sink_context(stripped)\n"
if old not in text:
    raise SystemExit("Could not locate player_sink assignment")
text = text.replace(old, new, 1)
text = text.replace("        'format': 6,\n", "        'format': 7,\n", 1)
audit_path.write_text(text, encoding="utf-8")


test_path = Path("korean/tools/test_runtime_display_audit.py")
test_path.write_text('''#!/usr/bin/env python3
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
''', encoding="utf-8")


workflow_path = Path(".github/workflows/korean-runtime-display-audit.yml")
workflow = workflow_path.read_text(encoding="utf-8")
checkout_line = "            /korean/tools/audit_runtime_display_text.py\n"
test_checkout = "            /korean/tools/test_runtime_display_audit.py\n"
if test_checkout not in workflow:
    if checkout_line not in workflow:
        raise SystemExit("Could not update display audit sparse checkout")
    workflow = workflow.replace(checkout_line, checkout_line + test_checkout, 1)
test_step = '''
      - name: Test runtime display audit heuristics
        shell: bash
        run: |
          set -euo pipefail
          python3 -m unittest korean/tools/test_runtime_display_audit.py
'''
scan_step = "\n      - name: Scan runtime display literals\n"
if test_step not in workflow:
    if scan_step not in workflow:
        raise SystemExit("Could not locate runtime audit scan step")
    workflow = workflow.replace(scan_step, test_step + scan_step, 1)
workflow_path.write_text(workflow, encoding="utf-8")
