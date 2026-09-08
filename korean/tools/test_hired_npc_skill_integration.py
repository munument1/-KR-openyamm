#!/usr/bin/env python3
from __future__ import annotations

import unittest
from pathlib import Path


class HiredNpcSkillIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.repo_root = Path(__file__).resolve().parents[2]
        source_paths = {
            "party": "game/party/Party.cpp",
            "follower": "game/gameplay/NpcFollowerRuntime.cpp",
            "mechanics": "game/gameplay/GameMechanics.cpp",
            "prices": "game/items/PriceCalculator.cpp",
            "events": "game/events/EventRuntime.cpp",
            "houses": "game/gameplay/HouseServiceRuntime.cpp",
            "spells": "game/party/PartySpellSystem.cpp",
            "combat": "game/gameplay/GameplayCombatController.cpp",
        }
        missing = [relative for relative in source_paths.values() if not (cls.repo_root / relative).is_file()]
        if missing:
            raise unittest.SkipTest(
                "hired NPC gameplay integration sources are not present in this sparse checkout: "
                + ", ".join(missing)
            )
        for attribute, relative in source_paths.items():
            setattr(cls, attribute, (cls.repo_root / relative).read_text(encoding="utf-8"))

    def test_learning_bonus_is_flat_and_uses_reviewed_values(self) -> None:
        self.assertIn('hiredNpcSkillBonus(followerRuntimeState, "Learning")', self.party)
        self.assertIn('learningPercentForExperienceGain(member) + followerLearningPercent', self.party)
        self.assertIn('if (professionId == 4) bonus += 5;', self.follower)
        self.assertIn('else if (professionId == 13) bonus += 10;', self.follower)
        self.assertIn('else if (professionId == 14) bonus += 15;', self.follower)

    def test_same_profession_does_not_stack_twice(self) -> None:
        self.assertIn('std::unordered_set<uint32_t> appliedProfessionIds;', self.follower)
        self.assertIn('if (!appliedProfessionIds.insert(professionId).second)', self.follower)

    def test_non_learning_skill_bonuses_are_materialized_for_all_members(self) -> None:
        start = self.party.index('FollowerSkillBonusNames')
        end = self.party.index('std::unordered_map<std::string, int> followerSkillBonuses;', start)
        block = self.party[start:end]
        expected = {
            'Merchant', 'DisarmTraps', 'Perception',
            'LeatherArmor', 'ChainArmor', 'PlateArmor',
            'Staff', 'Sword', 'Dagger', 'Axe', 'Spear', 'Bow', 'Mace',
            'FireMagic', 'AirMagic', 'WaterMagic', 'EarthMagic',
            'SpiritMagic', 'MindMagic', 'BodyMagic', 'LightMagic', 'DarkMagic',
        }
        for skill in expected:
            self.assertIn(f'"{skill}"', block)
        self.assertNotIn('"Learning"', block)
        self.assertIn('member.itemSkillBonuses[skillName] += bonus;', self.party)

    def test_hire_and_dismiss_refresh_derived_skill_state(self) -> None:
        add_start = self.party.index('void Party::addHiredNpcFollower')
        remove_start = self.party.index('void Party::removeHiredNpcFollower', add_start)
        ability_start = self.party.index('void Party::setHiredNpcFollowerAbilityUsedDay', remove_start)
        self.assertIn('rebuildMagicalBonusesFromBuffs();', self.party[add_start:remove_start])
        self.assertIn('rebuildMagicalBonusesFromBuffs();', self.party[remove_start:ability_start])

        event_start = self.party.index('void Party::applyEventRuntimeState')
        event_end = self.party.index('bool Party::applyDamageToActiveMember', event_start)
        event_block = self.party[event_start:event_end]
        self.assertIn('bool followerStateChanged = false;', event_block)
        self.assertIn('if (followerStateChanged)', event_block)
        self.assertIn('rebuildMagicalBonusesFromBuffs();', event_block)

    def test_merchant_bonus_reaches_selection_pricing_and_shop_phrases(self) -> None:
        self.assertIn('itemSkillBonuses.find("Merchant")', self.prices)
        self.assertIn('SkillMastery::Normal', self.prices)
        self.assertIn('temporaryMerchantSkillBonus', self.prices)
        self.assertIn('itemSkillBonuses.find("Merchant")', self.houses)
        self.assertIn('genericUtilitySkillScore(member, skillName)', self.party)

    def test_perception_and_disarm_resolvers_use_temporary_skill_points(self) -> None:
        perception_start = self.mechanics.index('int GameMechanics::resolveCharacterPerceptionValue')
        disarm_start = self.mechanics.index('int GameMechanics::resolveCharacterDisarmTrapValue', perception_start)
        party_start = self.mechanics.index('int GameMechanics::resolvePartyPerceptionValue', disarm_start)
        perception = self.mechanics[perception_start:disarm_start]
        disarm = self.mechanics[disarm_start:party_start]
        self.assertIn('itemSkillBonuses.find(PerceptionSkillName)', perception)
        self.assertIn('SkillMastery::Normal', perception)
        self.assertIn('bonusForName("DisarmTraps")', disarm)
        self.assertIn('SkillMastery::Normal', disarm)

    def test_numeric_event_checks_accept_bonus_but_mastery_checks_still_require_skill(self) -> None:
        start = self.events.index('int characterEffectiveSkillCheckValue')
        end = self.events.index('bool characterHasLearnedSkill', start)
        block = self.events[start:end]
        self.assertIn('member.itemSkillBonuses.find(skillName)', block)
        self.assertIn('if (rawMastery == 0)', block)
        self.assertIn('const CharacterSkill *pSkill = member.findSkill(skillName);', block)
        self.assertIn('pSkill->mastery >= mastery', block)

    def test_existing_spell_and_combat_paths_consume_materialized_bonus(self) -> None:
        self.assertIn('caster.itemSkillBonuses.find(*skillName)', self.spells)
        self.assertIn('character.itemSkillBonuses.find(skillName)', self.combat)


if __name__ == "__main__":
    unittest.main()
