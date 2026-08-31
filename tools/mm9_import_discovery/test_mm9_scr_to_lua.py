#!/usr/bin/env python3
from __future__ import annotations

import unittest

from tools.mm9_import_discovery.mm9_scr_to_lua import ScrCompileError, compile_rude_exit


class Mm9ScrToLuaTests(unittest.TestCase):
    def test_compiles_nested_quest_and_item_callback(self) -> None:
        source = """
#number g_nTemp
:OnRude
HasKey 475 g_nTemp
if (g_nTemp==TRUE)
    GiveExp 2000
    GiveKey 496
else
    GiveItem 579
endif
exit
:Main
OnRudeExit OnRude
exit
"""
        compiled = compile_rude_exit(source, "NPC436.scr", 207)

        self.assertIsNotNone(compiled)
        assert compiled is not None
        self.assertEqual(compiled.event_id, 50207)
        lua = "\n".join(compiled.lua_lines)
        self.assertIn("state[\"g_ntemp\"] = MM9.hasKey(475)", lua)
        self.assertIn("MM9.giveExperience(2000)", lua)
        self.assertIn("MM9.giveKey(496)", lua)
        self.assertIn('MM9.giveItem(579, "NPC436.scr:9")', lua)
        self.assertNotIn("if not MM9.giveItem", lua)

    def test_missing_item_operations_do_not_abort_later_state_changes(self) -> None:
        source = """
:OnRude
GiveItem 579
TakeItem 580
GiveKey 496
exit
:Main
OnRudeExit OnRude
"""
        compiled = compile_rude_exit(source, "NPC436.scr", 207)

        self.assertIsNotNone(compiled)
        assert compiled is not None
        lua = "\n".join(compiled.lua_lines)
        give_position = lua.index('MM9.giveItem(579, "NPC436.scr:3")')
        take_position = lua.index('MM9.takeItem(580, "NPC436.scr:4")')
        key_position = lua.index("MM9.giveKey(496)")
        self.assertLess(give_position, take_position)
        self.assertLess(take_position, key_position)
        self.assertNotIn("if not MM9.giveItem", lua)
        self.assertNotIn("if not MM9.takeItem", lua)

    def test_rejects_unsupported_reachable_party_operation(self) -> None:
        source = """
:OnRude
GiveSpell Fireball
exit
:Main
OnRudeExit OnRude
exit
"""
        with self.assertRaisesRegex(ScrCompileError, "unsupported reachable command 'givespell'"):
            compile_rude_exit(source, "NPC1.scr", 1)

    def test_compiles_reachable_actor_relocation_operations(self) -> None:
        source = """
:OnUse
GetObjectHandle PrisonerHuman2MaleA1 g_hObject
RemoveObject g_hObject
GetMyHandle g_hMyObject
SetPos g_hMyObject -2525 948 397
DoRude 1
:Main
AddTrigger Use, OnUse
"""
        compiled = compile_rude_exit(
            source,
            "NPC1.scr",
            1,
            actor_handles={"PrisonerHuman2MaleA1": 7},
            source_actor_handle=3,
        )

        self.assertIsNotNone(compiled)
        assert compiled is not None
        lua = "\n".join(compiled.lua_lines)
        self.assertIn('state["g_hobject"] = 7', lua)
        self.assertIn('MM9.removeActor(state["g_hobject"])', lua)
        self.assertIn('state["g_hmyobject"] = 3', lua)
        self.assertIn('MM9.setActorPosition(state["g_hmyobject"], -2525, 948, 397)', lua)

    def test_compiles_npc378_delayed_vanish_to_persistent_actor_removal(self) -> None:
        source = """
#number g_nTemp
:OnRude
HasKey 107 g_nTemp
if (g_nTemp==TRUE)
    Wait 1 2 Vanish
    exit
endif
:Main
OnRudeExit OnRude
"""
        compiled = compile_rude_exit(source, "NPC378.scr", 335, source_actor_handle=12)

        self.assertIsNotNone(compiled)
        assert compiled is not None
        lua = "\n".join(compiled.lua_lines)
        self.assertIn("MM9.removeActor(12)", lua)

    def test_rejects_unspecialized_reachable_wait(self) -> None:
        source = """
:OnRude
Wait 1 2 Continue
:Main
OnRudeExit OnRude
"""
        with self.assertRaisesRegex(ScrCompileError, "unsupported reachable actor operation 'wait'"):
            compile_rude_exit(source, "NPC1.scr", 1, source_actor_handle=12)

    def test_rejects_recursive_reachable_routine(self) -> None:
        source = """
:OnRude
Gosub OnRude
:Main
OnRudeExit OnRude
"""
        with self.assertRaisesRegex(ScrCompileError, "recursive routine :onrude"):
            compile_rude_exit(source, "NPC1.scr", 1)

    def test_ignores_scripts_without_rude_exit_callback(self) -> None:
        source = """
:OnUse
DoRude 1
exit
"""
        self.assertIsNone(compile_rude_exit(source, "DORUDE.scr", 10))

    def test_initializes_callback_state_from_script_parameters(self) -> None:
        source = """
#string Location
:OnRude
if (Location==Refinery)
    GiveKey 1
endif
exit
:Main
GetParam 0 Location
OnRudeExit OnRude
exit
"""
        compiled = compile_rude_exit(source, "NPC7.scr", 12, script_params=["Refinery"])

        self.assertIsNotNone(compiled)
        assert compiled is not None
        lua = "\n".join(compiled.lua_lines)
        self.assertIn('state["location"] = "refinery"', lua)
        self.assertIn('if state["location"]=="refinery" then', lua)

    def test_compiles_use_entry_that_opens_rude(self) -> None:
        source = """
#number unconscious
:OnUse
if (unconscious==TRUE)
    exit
endif
DoRude 132
:Main
AddTrigger Use, OnUse
"""
        compiled = compile_rude_exit(source, "NPC132.scr", 42)

        self.assertIsNotNone(compiled)
        assert compiled is not None
        self.assertIsNone(compiled.event_id)
        self.assertEqual(compiled.use_event_id, 53042)
        lua = "\n".join(compiled.lua_lines)
        self.assertIn('MM9.scrValue(42, "unconscious", 0)', lua)
        self.assertIn('if state["unconscious"]==1 then', lua)
        self.assertIn("MM9.openRude(132)", lua)

    def test_compiles_found_player_entry_point(self) -> None:
        source = """
#number bSpokeTo
:DoRude
if (bSpokeTo==FALSE)
    set bSpokeTo, TRUE
    DoRude 436
    PlaySound voices\\npc\\NPC_249.wav, DoNothing, 100
endif
:Init
OnFoundPlayer DoRude
:OnRude
GiveKey 496
:Main
OnRudeExit OnRude
OnPostStartWorld Init
"""
        compiled = compile_rude_exit(source, "NPC436.scr", 207)

        self.assertIsNotNone(compiled)
        assert compiled is not None
        self.assertEqual(compiled.event_id, 50207)
        self.assertIsNone(compiled.use_event_id)
        self.assertEqual(compiled.found_player_event_id, 56207)
        lua = "\n".join(compiled.lua_lines)
        self.assertIn("MM9.foundPlayerEnabled(207)", lua)
        self.assertIn('if state["bspoketo"]==0 then', lua)
        self.assertIn('MM9.setScrValue(207, "bspoketo", state["bspoketo"])', lua)
        self.assertIn("MM9.openRude(436)", lua)
        self.assertIn('MM9.playSound("voices\\\\npc\\\\NPC_249.wav")', lua)


if __name__ == "__main__":
    unittest.main()
