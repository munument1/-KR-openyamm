-- MMMerge global supplement: MM7 quest follower behavior.

local function appendGlobalEvent(eventId, title, handler)
    local previousHandler = evt.global[eventId]

    ReplaceGlobalEvent(eventId, title, function(...)
        if previousHandler ~= nil then
            previousHandler(...)
        end

        handler(...)
    end)
end

appendGlobalEvent(858, "MMMerge rescued dwarf cleanup", function()
    MM7.RemoveRescuedDwarfFollowers()
end)

for offset = 0, 6 do
    local npcId = 399 + offset
    appendGlobalEvent(859 + offset, "MMMerge rescued dwarf follower", function()
        AddFollowerNpc(npcId)
    end)
end

RegisterGlobalNpcEnterHook(65070, "MMMerge Dwarf King follower cleanup", function(context)
    if context.npcId == 398 then
        MM7.RemoveRescuedDwarfFollowers()
    end
end)

RegisterGlobalHouseTopicClickHook(65071, "MMMerge Antagarich Arcomage deck requirement", function(context)
    MM7.BlockArcomageWithoutDeck(context)
end)

RegisterGlobalNpcEnterHook(65072, "MMMerge CrossContinents Verdant state", function(context)
    MM7.HandleVerdantEnter(context)
end)

RegisterGlobalNpcEnterHook(65073, "MMMerge Dragon Hatchling topics", function(context)
    MM7.UpdateDragonHatchlingNpc(context)
end)

ReplaceGlobalEvent(789, "MMMerge Dragon Hatchling", function()
    MM7.HandleDragonHatchlingTopic()
end)

ReplaceGlobalEvent(795, "MMMerge Rogue promotion", function()
    MM7.AntagarichThiefFirstPromotion()
end)

ReplaceGlobalEvent(796, "MMMerge Spy promotion gate", function()
    MM7.AntagarichSpyGate()
end)

ReplaceGlobalEvent(797, "MMMerge Spy promotion", function()
    MM7.AntagarichSpyPromotion()
end)

ReplaceGlobalEvent(800, "MMMerge Assassin promotion", function()
    MM7.AntagarichAssassinPromotion()
end)

ReplaceGlobalEvent(801, "MMMerge Crusader promotion start", function()
    MM7.AntagarichPaladinStart()
end)

ReplaceGlobalEvent(802, "MMMerge Crusader promotion", function()
    MM7.AntagarichCrusaderPromotion()
end)

ReplaceGlobalEvent(803, "MMMerge Hero promotion gate", function()
    MM7.AntagarichHeroGate()
end)

ReplaceGlobalEvent(804, "MMMerge Hero promotion", function()
    MM7.AntagarichHeroPromotion()
end)

ReplaceGlobalEvent(805, "MMMerge second Paladin follower", function()
    MM7.AddAliceFollowerForPaladinSecondPromotion()
end)

ReplaceGlobalEvent(807, "MMMerge Villain promotion", function()
    MM7.AntagarichVillainPromotion()
end)

ReplaceGlobalEvent(810, "MMMerge Initiate promotion", function()
    MM7.AntagarichMonkFirstPromotion()
end)

ReplaceGlobalEvent(811, "MMMerge Master promotion gate", function()
    MM7.AntagarichMasterGate()
end)

ReplaceGlobalEvent(812, "MMMerge Master promotion", function()
    MM7.AntagarichMasterPromotion()
end)

ReplaceGlobalEvent(814, "MMMerge Ninja promotion", function()
    MM7.AntagarichNinjaPromotion()
end)

ReplaceGlobalEvent(816, "MMMerge Master Archer promotion", function()
    MM7.AntagarichMasterArcherPromotion()
end)

ReplaceGlobalEvent(818, "MMMerge Warrior Mage promotion", function()
    MM7.AntagarichArcherFirstPromotion()
end)

ReplaceGlobalEvent(819, "MMMerge Sniper promotion gate", function()
    MM7.AntagarichArcherGoodPath()
end)

ReplaceGlobalEvent(820, "MMMerge Sniper promotion", function()
    MM7.AntagarichSniperPromotion()
end)

ReplaceGlobalEvent(821, "MMMerge Champion promotion gate", function()
    MM7.AntagarichChampionGate()
end)

ReplaceGlobalEvent(822, "MMMerge Champion promotion", function()
    MM7.AntagarichChampionPromotion()
end)

ReplaceGlobalEvent(824, "MMMerge Cavalier promotion", function()
    MM7.AntagarichKnightFirstPromotion()
end)

ReplaceGlobalEvent(825, "MMMerge Black Knight promotion gate", function()
    MM7.AntagarichBlackKnightGate()
end)

ReplaceGlobalEvent(826, "MMMerge Black Knight promotion", function()
    MM7.AntagarichBlackKnightPromotion()
end)

ReplaceGlobalEvent(827, "MMMerge Ranger Lord promotion gate", function()
    MM7.AntagarichRangerLordGate()
end)

ReplaceGlobalEvent(828, "MMMerge Ranger Lord promotion", function()
    MM7.AntagarichRangerLordPromotion()
end)

ReplaceGlobalEvent(830, "MMMerge Hunter promotion gate", function()
    MM7.AntagarichRangerFirstPromotion()
end)

ReplaceGlobalEvent(831, "MMMerge Bounty Hunter promotion gate", function()
    MM7.AntagarichBountyHunterGate()
end)

ReplaceGlobalEvent(832, "MMMerge Bounty Hunter promotion", function()
    MM7.AntagarichBountyHunterPromotion()
end)

ReplaceGlobalEvent(833, "MMMerge Hunter promotion", function()
    MM7.AntagarichRangerCompleteFirstPromotion()
end)

ReplaceGlobalEvent(836, "MMMerge Priest of Light gate", function()
    MM7.AntagarichPriestLightGate()
end)

ReplaceGlobalEvent(837, "MMMerge Priest of Light promotion", function()
    MM7.AntagarichPriestLightPromotion()
end)

ReplaceGlobalEvent(839, "MMMerge Priest promotion", function()
    MM7.AntagarichClericFirstPromotion()
end)

ReplaceGlobalEvent(840, "MMMerge Priest of Dark gate", function()
    MM7.AntagarichPriestDarkGate()
end)

ReplaceGlobalEvent(841, "MMMerge Priest of Dark promotion", function()
    MM7.AntagarichPriestDarkPromotion()
end)

ReplaceGlobalEvent(842, "MMMerge Wizard golem follower", function()
    MM7.AntagarichWizardFollower()
end)

ReplaceGlobalEvent(843, "MMMerge Wizard promotion", function()
    MM7.AntagarichWizardPromotion()
end)

ReplaceGlobalEvent(844, "MMMerge Archmage promotion gate", function()
    MM7.AntagarichArchMageGate()
end)

ReplaceGlobalEvent(845, "MMMerge Archmage promotion", function()
    MM7.AntagarichArchMagePromotion()
end)

ReplaceGlobalEvent(846, "MMMerge Lich promotion gate", function()
    MM7.AntagarichLichGate()
end)

ReplaceGlobalEvent(847, "MMMerge Lich promotion", function()
    MM7.AntagarichLichPromotion()
end)

ReplaceGlobalEvent(849, "MMMerge Great Druid promotion", function()
    MM7.AntagarichDruidFirstPromotion()
end)

ReplaceGlobalEvent(850, "MMMerge Arch Druid promotion cross-path", function()
    MM7.StartArchDruidPromotionFromEitherPath()
end)

ReplaceGlobalEvent(851, "MMMerge Arch Druid promotion", function()
    MM7.AntagarichArchDruidPromotion()
end)

ReplaceGlobalEvent(852, "MMMerge Warlock promotion cross-path", function()
    MM7.StartWarlockPromotionFromEitherPath()
end)

ReplaceGlobalEvent(853, "MMMerge Warlock promotion", function()
    MM7.AntagarichWarlockPromotion()
end)

ReplaceGlobalEvent(950, "MMMerge Blaster skill", function()
    MM7.TeachBlasterSkill()
end)

ReplaceGlobalEvent(1778, "MMMerge Verdant important matter", function()
    MM7.HandleVerdantIntro()
end)

ReplaceGlobalEvent(1781, "MMMerge Verdant dimension doors", function()
    MM7.ExplainDimensionDoors()
end)

ReplaceGlobalEvent(1782, "MMMerge Verdant Jadame", function()
    MM7.ExplainCurrentCrossContinent(3)
end)

ReplaceGlobalEvent(1783, "MMMerge Verdant Antagarich", function()
    MM7.ExplainCurrentCrossContinent(2)
end)

ReplaceGlobalEvent(1784, "MMMerge Verdant Enroth", function()
    MM7.ExplainCurrentCrossContinent(1)
end)

ReplaceGlobalEvent(1785, "MMMerge Verdant Runaway Chaos", function()
    MM7.ExplainRunawayChaos()
end)

ReplaceGlobalEvent(1786, "MMMerge Verdant Controlled Breach", function()
    MM7.ExplainControlledBreach()
end)

ReplaceGlobalEvent(1787, "MMMerge Verdant next step", function()
    MM7.ExplainCrossContinentsNextStep()
end)

ReplaceGlobalEvent(1788, "MMMerge Verdant connector stone", function()
    MM7.ExplainConnectorStone()
end)

ReplaceGlobalEvent(513, "MMMerge Malwick conditional ambush", function()
    MM7.SummonMalwickAmbush(false)
end)

ReplaceGlobalEvent(514, "MMMerge Malwick forced ambush", function()
    MM7.SummonMalwickAmbush(true)
end)

ReplaceGlobalEvent(769, "MMMerge Malwick wand", function()
    MM7.GiveMalwickWand()
end)

ReplaceGlobalEvent(783, "MMMerge Cast Off to Harmondale", function()
    MM7.CastOffToHarmondale()
end)

appendGlobalEvent(875, "MMMerge Loren cleanup", function()
    MM7.RemoveLorenFollowersIfResolved()
end)

appendGlobalEvent(876, "MMMerge Loren cleanup", function()
    MM7.RemoveLorenFollowersIfResolved()
end)

appendGlobalEvent(884, "MMMerge fake Loren follower", function()
    MM7.AddFakeLorenFollowerIfActive()
end)

appendGlobalEvent(885, "MMMerge Loren cleanup", function()
    MM7.RemoveLorenFollowersIfResolved()
end)

appendGlobalEvent(886, "MMMerge Loren cleanup", function()
    MM7.RemoveLorenFollowersIfResolved()
end)

appendGlobalEvent(891, "MMMerge Judge Sleen follower", function()
    MM7.ChooseJudgeSleenFollower()
end)

appendGlobalEvent(893, "MMMerge Judge Fairweather follower", function()
    MM7.ChooseJudgeFairweatherFollower()
end)

ReplaceGlobalEvent(920, "MMMerge Antagarich endgame started", function()
    MM7.UpdateAntagarichEndgameStarted()
end)

ReplaceGlobalEvent(922, "MMMerge Antagarich endgame complete", function()
    MM7.MarkAntagarichEndgameComplete()
end)
