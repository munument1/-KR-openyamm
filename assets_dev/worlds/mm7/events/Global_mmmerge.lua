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

ReplaceGlobalEvent(850, "MMMerge Arch Druid promotion cross-path", function()
    MM7.StartArchDruidPromotionFromEitherPath()
end)

ReplaceGlobalEvent(852, "MMMerge Warlock promotion cross-path", function()
    MM7.StartWarlockPromotionFromEitherPath()
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
