MM7 = MM7 or {}

MM7.RescuedDwarfNpcIds = {399, 400, 401, 402, 403, 404, 405}
MM7.LorenNpcId = 410
MM7.FakeLorenNpcId = 411
MM7.JudgeFairweatherNpcId = 416
MM7.JudgeSleenNpcId = 417
MM7.GolemNpcId = 395
MM7.ArcomageDeckItemId = 1453
MM7.ScavengerAdvertisementItemId = 774
MM7.WetsuitItemId = 1406
MM7.WetsuitPortraitId = 30

MM7.HouseServiceType = {
    Tavern = 4,
}

function MM7.FilterTavernTopicsWithoutArcomage(context)
    if context.houseServiceType ~= MM7.HouseServiceType.Tavern then
        return
    end

    evt.SetHookHouseTopics({
        HouseAction.TavernRentRoom,
        HouseAction.TavernBuyFood,
        HouseAction.OpenLearnSkillsMenu,
    })
end

function MM7.BlockArcomageWithoutDeck(context)
    local actionId = context.houseActionId

    if actionId ~= HouseAction.OpenTavernArcomageMenu
        and actionId ~= HouseAction.TavernArcomagePlay then
        return
    end

    if HasItemAnywhere(MM7.ArcomageDeckItemId) then
        return
    end

    evt.SetHookBlocked(true, "You must have your own card deck to play here.")
end

function MM7.RemoveGolemFollowerIfConstructed()
    if IsQBitSet(QBit(585)) or IsQBitSet(QBit(586)) then
        RemoveFollowerNpc(MM7.GolemNpcId)
    end
end

function MM7.MakeCastleHarmondaleRestFreeIfRebuilt(context)
    if context == nil then
        return
    end

    if IsQBitSet(QBit(610)) then -- Built Castle to Level 2
        evt.SetHookRestFoodCost(0)
    end
end

function MM7.ActivateCastleHarmondaleMercenaries()
    evt.SetMonGroupBit(60, MonsterBits.Hostile, 1)
    evt.SetMonGroupBit(60, MonsterBits.Invisible, 0)
    SetValue(BankGold, 0)
    ClearQBit(QBit(693)) -- Go to the Mercenary Guild in Tatalia and talk to Niles Stantley within two weeks.
    ClearQBit(QBit(694)) -- Steal the Tapestry from your associate's Castle and return it to Niles Stantley.
end

function MM7.HideCastleHarmondaleMercenaries()
    evt.SetMonGroupBit(60, MonsterBits.Hostile, 0)
    evt.SetMonGroupBit(60, MonsterBits.Invisible, 1)
end

function MM7.HideCastleHarmondaleGoblinsIfRebuilt()
    if not IsQBitSet(QBit(610)) then -- Built Castle to Level 2
        return
    end

    evt.SetMonGroupBit(56, MonsterBits.Hostile, 0)
    evt.SetMonGroupBit(56, MonsterBits.Invisible, 1)
end

function MM7.UpdateCastleHarmondaleMercenariesOnLoad()
    if IsQBitSet(QBit(526))
        and IsQBitSet(QBit(695))
        and not IsQBitSet(QBit(696))
        and not IsQBitSet(QBit(702)) then
        MM7.ActivateCastleHarmondaleMercenaries()
        return
    end

    MM7.HideCastleHarmondaleMercenaries()
end

function MM7.MarkCastleHarmondaleMercenariesKilledIfClear()
    if not IsQBitSet(QBit(695)) then
        return
    end

    if not evt.CheckMonstersKilled(ActorKillCheck.Group, 60, 0, false) then
        return
    end

    SetQBit(QBit(696)) -- Killed all castle monsters

    if IsQBitSet(QBit(697)) then -- Killed all outdoor monsters
        SetQBit(QBit(702)) -- Finished with Malwick & Assc.
        ClearQBit(QBit(695)) -- Failed either goto or do guild quest
    end
end

function MM7.IsEnemyDetectorActive()
    local yellow, red = evt.GetEnemyDetectorState()
    return yellow or red
end

function MM7.EnterCastleLambentThroneRoom()
    if IsQBitSet(QBit(612)) -- Chose the path of Dark
        or not IsQBitSet(QBit(611)) -- Chose the path of Light
        or MM7.IsEnemyDetectorActive() then
        evt.StatusText("The Door is Locked")
        return
    end

    evt.EnterHouse(220) -- Throne Room
end

function MM7.EnterCastleGloamingThroneRoom()
    if IsQBitSet(QBit(611)) -- Chose the path of Light
        or not IsQBitSet(QBit(612)) -- Chose the path of Dark
        or MM7.IsEnemyDetectorActive() then
        evt.StatusText("The Door is Locked")
        return
    end

    if IsQBitSet(QBit(710)) then -- Archibald in Clanker's Lab now
        evt.EnterHouse(221) -- Throne Room
        return
    end

    evt.EnterHouse(219) -- Throne Room
end

function MM7.OpenDimensionDoor()
    if CrossContinents ~= nil
        and CrossContinents.TryDimensionDoorContact ~= nil
        and CrossContinents.TryDimensionDoorContact() then
        return
    end

    evt.OpenDimensionDoor()
end

function MM7.DistanceToPartySquared(x, y)
    local partyX, partyY = evt.GetPartyPosition()
    local dx = x - partyX
    local dy = y - partyY
    return dx * dx + dy * dy
end

function MM7.ApplyDeyjaLocalRelations()
    evt.SetMonsterRelation(91, 0, 0)
end

function MM7.UpdateDeyjaOutdoorState()
    MM7.ApplyDeyjaLocalRelations()
    evt.SetMonGroupBit(56, MonsterBits.Hostile, 1)
    evt.SetMonGroupBit(55, MonsterBits.Hostile, IsQBitSet(QBit(611)) and 1 or 0)
end

function MM7.SummonDeyjaAmbushIfNeeded(context)
    if context == nil or context.npcId ~= 461 or IsQBitSet(QBit(761)) then
        return
    end

    local partyX, partyY, partyZ = evt.GetPartyPosition()
    evt.SummonMonsters(3, 3, 5, partyX, partyY, partyZ + 400, 59, 0)
    evt.SetMonGroupBit(59, MonsterBits.Hostile, 1)
end

function MM7.GiveMalwickWand()
    evt.SetHeldItem(947, {
        identified = true,
        charges = 30,
        maxCharges = 30,
    })
end

function MM7.SummonMalwickAmbush(force)
    if not force and IsQBitSet(QBit(761)) then
        return
    end

    local partyX, partyY, partyZ = evt.GetPartyPosition()
    evt.SummonMonsters(3, 3, 5, partyX, partyY, partyZ + 400, 59, 0)
    evt.SetMonGroupBit(59, MonsterBits.Hostile, 1)
end

function MM7.CastOffToHarmondale()
    ClearQBit(QBit(528))
    evt.MoveNPC(340, 215)
    evt.SetNPCGreeting(340, 320)
    evt.SetNPCTopic(340, 3, 0)
    AdvanceGameMinutes(14 * 24 * 60)
    evt.MoveToMap(-17331, 12547, 465, 1024, 0, 0, 0, 0, "7out02.odm")
end

function MM7.MarkAntagarichEndgameComplete()
    SetQBit(QBit(783))
end

MM7.CrossContinents = {
    VerdantNpcId = 803,
    RunawayChaosNpcId = 1092,
    ChargedConnectorStoneItemId = 624,
    DischargedConnectorStoneItemId = 625,
    SharedLifeRingItemId = 543,
    FinalQuestQBit = 1713,
    CompleteQBits = {
        [1] = 228, -- Jadame
        [2] = 783, -- Antagarich
        [3] = 784, -- Enroth
    },
    ContinentTopicIds = {
        [1] = 1782, -- Jadame
        [2] = 1783, -- Antagarich
        [3] = 1784, -- Enroth
    },
    MeetSpotHouseIds = {
        [1] = 185,
        [2] = 641,
        [3] = 1195,
    },
    ContinentMessageText = {
        [1] = "Jadame starts on Dagger Wound. Help the caravan, reach Ravenshore, and hold the alliance together.",
        [2] = "Antagarich begins with the Emerald Island scavenger hunt and leads to Harmondale. Become lords, then keep your land alive.",
        [3] = "Enroth is the simple path: train hard, help where you can, and try not to mistake every future devil for an apprentice wizard.",
    },
}

function MM7.CrossVar(name)
    if CrossContinents ~= nil and CrossContinents.Var ~= nil then
        return CrossContinents.Var(name)
    end

    return "MMerge.CrossContinents." .. name
end

function MM7.GetCrossVar(name, defaultValue)
    if CrossContinents ~= nil and CrossContinents.GetVar ~= nil then
        return CrossContinents.GetVar(name, defaultValue)
    end

    return evt.GetGlobalVar(MM7.CrossVar(name), defaultValue or 0)
end

function MM7.SetCrossVar(name, value)
    if CrossContinents ~= nil and CrossContinents.SetVar ~= nil then
        CrossContinents.SetVar(name, value)
        return
    end

    evt.SetGlobalVar(MM7.CrossVar(name), value or 0)
end

function MM7.CurrentMergedContinent()
    if CrossContinents ~= nil and CrossContinents.CurrentContinent ~= nil then
        return CrossContinents.CurrentContinent()
    end

    local continent = CurrentContinent()
    if continent >= 1 and continent <= 3 then
        return continent
    end

    local mapName = string.lower(evt.GetCurrentMapName() or "")
    if string.sub(mapName, 1, 1) == "7" then
        return 2
    end

    return continent
end

function MM7.IsCrossContinentFinished(continent)
    if CrossContinents ~= nil and CrossContinents.IsContinentFinished ~= nil then
        return CrossContinents.IsContinentFinished(continent)
    end

    local qbitId = MM7.CrossContinents.CompleteQBits[continent]
    if qbitId == nil then
        return false
    end

    return IsQBitSet(QBit(qbitId)) or MM7.GetCrossVar("Finished." .. tostring(continent), 0) ~= 0
end

function MM7.MarkCrossContinentFinished(continent)
    if CrossContinents ~= nil and CrossContinents.MarkContinentFinished ~= nil then
        CrossContinents.MarkContinentFinished(continent)
        return
    end

    MM7.SetCrossVar("Finished." .. tostring(continent), 1)
end

function MM7.MarkCrossContinentAntagarichIfComplete()
    if IsQBitSet(QBit(633)) or IsQBitSet(QBit(783)) then
        MM7.MarkCrossContinentFinished(2)
    end
end

function MM7.CrossRewardCount()
    if CrossContinents ~= nil and CrossContinents.RewardCount ~= nil then
        return CrossContinents.RewardCount()
    end

    local count = 0
    for continent = 1, 3 do
        if MM7.GetCrossVar("Reward." .. tostring(continent), 0) ~= 0 then
            count = count + 1
        end
    end
    return count
end

function MM7.PlaceVerdantForCurrentContinent()
    if CrossContinents ~= nil and CrossContinents.PlaceVerdantForCurrentContinent ~= nil then
        CrossContinents.PlaceVerdantForCurrentContinent()
        return
    end

    if MM7.GetCrossVar("MetVerdant", 0) == 0 and MM7.GetCrossVar("GotMainQuest", 0) == 0 then
        return
    end

    local houseId = MM7.CrossContinents.MeetSpotHouseIds[MM7.CurrentMergedContinent()]
    if houseId ~= nil then
        evt.MoveNPC(MM7.CrossContinents.VerdantNpcId, houseId)
    end
end

function MM7.UpdateVerdantTopics()
    if CrossContinents ~= nil and CrossContinents.UpdateVerdantTopics ~= nil then
        CrossContinents.UpdateVerdantTopics()
        return
    end

    local npcId = MM7.CrossContinents.VerdantNpcId
    evt.SetNPCTopic(npcId, 0, 0)
    evt.SetNPCTopic(npcId, 1, 0)
    evt.SetNPCTopic(npcId, 2, 0)
    evt.SetNPCTopic(npcId, 3, 0)

    if MM7.GetCrossVar("GotMainQuest", 0) == 0 then
        evt.SetNPCTopic(npcId, 0, 1778) -- Important Matter
        return
    end

    local continent = MM7.CurrentMergedContinent()
    local topicId = MM7.CrossContinents.ContinentTopicIds[continent]
    if topicId ~= nil then
        evt.SetNPCTopic(npcId, 0, topicId)
    else
        evt.SetNPCTopic(npcId, 0, 1781) -- Time Travel Guide
    end

    evt.SetNPCTopic(npcId, 1, 1781) -- Time Travel Guide

    if MM7.GetCrossVar("AllStoriesFinished", 0) ~= 0 then
        evt.SetNPCTopic(npcId, 0, 1787) -- What's next?
        evt.SetNPCTopic(npcId, 1, 1785) -- Something terrible
        evt.SetNPCTopic(npcId, 2, 1786) -- Controlled Breach
    elseif MM7.GetCrossVar("GotConnectorStone", 0) ~= 0 then
        evt.SetNPCTopic(npcId, 2, 1788) -- Connector gem
    end
end

function MM7.UpdateCrossContinentsState()
    if CrossContinents ~= nil and CrossContinents.UpdateState ~= nil then
        CrossContinents.UpdateState()
        return
    end

    MM7.PlaceVerdantForCurrentContinent()

    for continent = 1, 3 do
        if MM7.IsCrossContinentFinished(continent) then
            MM7.MarkCrossContinentFinished(continent)
        end
    end

    local currentContinent = MM7.CurrentMergedContinent()
    if MM7.GetCrossVar("GotMainQuest", 0) ~= 0
        and currentContinent >= 1 and currentContinent <= 3
        and MM7.GetCrossVar("StartedContinent", 0) ~= 0
        and currentContinent ~= MM7.GetCrossVar("StartedContinent", currentContinent)
        and MM7.GetCrossVar("GotConnectorStone", 0) == 0 then
        MM7.SetCrossVar("GotConnectorStone", 1)
        AddValue(InventoryItem(MM7.CrossContinents.ChargedConnectorStoneItemId), MM7.CrossContinents.ChargedConnectorStoneItemId)
        evt.SetNPCGreeting(MM7.CrossContinents.VerdantNpcId, 331)
    end

    if currentContinent >= 1
        and currentContinent <= 3
        and MM7.IsCrossContinentFinished(currentContinent)
        and MM7.GetCrossVar("Reward." .. tostring(currentContinent), 0) == 0 then
        local rewardCount = MM7.CrossRewardCount()
        MM7.SetCrossVar("Reward." .. tostring(currentContinent), 1)

        if rewardCount < 2 then
            AddValue(InventoryItem(MM7.CrossContinents.SharedLifeRingItemId), MM7.CrossContinents.SharedLifeRingItemId)
        else
            MM7.SetCrossVar("ImprovedConnector", 1)
            MM7.SetCrossVar("AllStoriesFinished", 1)
        end
    end

    MM7.UpdateVerdantTopics()
end

function MM7.HandleVerdantIntro()
    if CrossContinents ~= nil and CrossContinents.HandleVerdantIntro ~= nil then
        CrossContinents.HandleVerdantIntro()
        return
    end

    local step = MM7.GetCrossVar("IntroStep", 0)
    MM7.SetCrossVar("MetVerdant", 1)

    if step == 0 then
        evt.SimpleMessage("Verdant introduces herself as a time traveler and says the world needs your help.")
        MM7.SetCrossVar("IntroStep", 1)
    elseif step == 1 then
        evt.SimpleMessage("Verdant explains that missing heroes have left several histories without champions.")
        MM7.SetCrossVar("IntroStep", 2)
    elseif step == 2 then
        evt.SimpleMessage("Verdant believes your party can take their place without causing another disaster.")
        MM7.SetCrossVar("IntroStep", 3)
    else
        evt.SimpleMessage("Verdant asks you to save each continent's story and use dimension doors to move between them.")
        MM7.SetCrossVar("GotMainQuest", 1)
        MM7.SetCrossVar("StartedContinent", MM7.CurrentMergedContinent())
        evt.SetNPCGreeting(MM7.CrossContinents.VerdantNpcId, 328)
    end

    MM7.UpdateVerdantTopics()
end

function MM7.ExplainCurrentCrossContinent(continent)
    if CrossContinents ~= nil and CrossContinents.ExplainCurrentContinent ~= nil then
        CrossContinents.ExplainCurrentContinent(continent)
        return
    end

    evt.SimpleMessage(MM7.CrossContinents.ContinentMessageText[continent] or "Use dimension doors to continue the displaced heroes' stories.")
    MM7.UpdateVerdantTopics()
end

function MM7.ExplainDimensionDoors()
    if CrossContinents ~= nil and CrossContinents.ExplainDimensionDoors ~= nil then
        CrossContinents.ExplainDimensionDoors()
        return
    end

    evt.SimpleMessage("Dimension doors in magically active places let you step onto the other heroes' paths.")
    MM7.UpdateVerdantTopics()
end

function MM7.ExplainRunawayChaos()
    if CrossContinents ~= nil and CrossContinents.ExplainRunawayChaos ~= nil then
        CrossContinents.ExplainRunawayChaos()
        return
    end

    SetQBit(QBit(MM7.CrossContinents.FinalQuestQBit))
    MM7.SetCrossVar("FinalQuestStarted", 1)
    evt.SimpleMessage("Verdant says the timeline damage has a source: a Runaway Chaos that must be contained.")
    MM7.UpdateVerdantTopics()
end

function MM7.ExplainControlledBreach()
    if CrossContinents ~= nil and CrossContinents.ExplainControlledBreach ~= nil then
        CrossContinents.ExplainControlledBreach()
        return
    end

    SetQBit(QBit(MM7.CrossContinents.FinalQuestQBit))
    MM7.SetCrossVar("FinalQuestStarted", 1)
    evt.SimpleMessage("The Controlled Breach is Verdant's safe arena for reaching and containing the Runaway Chaos.")
    MM7.UpdateVerdantTopics()
end

function MM7.ExplainCrossContinentsNextStep()
    if CrossContinents ~= nil and CrossContinents.ExplainNextStep ~= nil then
        CrossContinents.ExplainNextStep()
        return
    end

    MM7.SetCrossVar("FinalQuestStarted", 1)
    SetQBit(QBit(MM7.CrossContinents.FinalQuestQBit))
    evt.SimpleMessage("Verdant has another anomaly to investigate and asks you to keep helping her.")
    MM7.UpdateVerdantTopics()
end

function MM7.ExplainConnectorStone()
    if CrossContinents ~= nil and CrossContinents.HandleConnectorStone ~= nil then
        CrossContinents.HandleConnectorStone()
        return
    end

    if MM7.GetCrossVar("GotConnectorStone", 0) == 0 then
        MM7.SetCrossVar("GotConnectorStone", 1)
        AddValue(InventoryItem(MM7.CrossContinents.ChargedConnectorStoneItemId), MM7.CrossContinents.ChargedConnectorStoneItemId)
    end

    local message = "The connector stone lets you call Verdant, but it must recharge after each use."
    if MM7.GetCrossVar("ImprovedConnector", 0) ~= 0 then
        message = message .. " Verdant has improved it so the charged stone can also help restore the party."
    end
    evt.SimpleMessage(message)
    MM7.UpdateVerdantTopics()
end

function MM7.HandleVerdantEnter(context)
    if CrossContinents ~= nil and CrossContinents.HandleVerdantEnter ~= nil then
        CrossContinents.HandleVerdantEnter(context)
        return
    end

    if context == nil or context.npcId ~= MM7.CrossContinents.VerdantNpcId then
        return
    end

    MM7.UpdateCrossContinentsState()
end

function MM7.UpdateDragonHatchlingTopics()
    local npcId = 396
    evt.SetNPCTopic(npcId, 0, 789) -- Dragon
    evt.SetNPCTopic(npcId, 1, 0)
    evt.SetNPCTopic(npcId, 2, 0)
    evt.SetNPCTopic(npcId, 3, 0)
end

function MM7.HandleDragonHatchlingTopic()
    if MM7.GetCrossVar("DragonJoined", 0) ~= 0 then
        evt.SimpleMessage("The dragon is already traveling with you.")
        return
    end

    if MM7.GetCrossVar("DragonGrown", 0) ~= 0 then
        AddFollowerNpc(396)
        MM7.SetCrossVar("DragonJoined", 1)
        evt.SetNPCName(396, "Dragon")
        evt.SimpleMessage("The grown dragon joins your company.")
        return
    end

    if not IsAtLeast(Food, 5) then
        evt.SimpleMessage("The hatchling is hungry, but you need five food to feed it.")
        return
    end

    SubtractValue(Food, 5)

    local firstFeed = MM7.GetCrossVar("DragonFirstFeedMinutes", 0)
    if firstFeed == 0 then
        MM7.SetCrossVar("DragonFirstFeedMinutes", CurrentGameMinutes())
    end

    local foodEaten = MM7.GetCrossVar("DragonFood", 0) + 5
    MM7.SetCrossVar("DragonFood", foodEaten)

    if foodEaten >= 100 and CurrentGameMinutes() >= MM7.GetCrossVar("DragonFirstFeedMinutes", CurrentGameMinutes()) + 28 * 24 * 60 then
        MM7.SetCrossVar("DragonGrown", 1)
        evt.SimpleMessage("The hatchling has grown enough to travel with you.")
    else
        evt.SimpleMessage("The hatchling eats the food.")
    end
end

function MM7.UpdateDragonHatchlingNpc(context)
    if context == nil or context.npcId ~= 396 then
        return
    end

    MM7.UpdateDragonHatchlingTopics()
end

function MM7.TeachBlasterSkill()
    evt.ForPlayer(Players.All)
    if not IsAtLeast(BlasterSkill, 1) then
        SetValue(BlasterSkill, SkillJoinedMask.Normal + 1)
    end
end

function MM7.AnyQBit(qbits)
    for _, qbitId in ipairs(qbits or {}) do
        if IsQBitSet(QBit(qbitId)) then
            return true
        end
    end

    return false
end

function MM7.SetQBits(qbits)
    for _, qbitId in ipairs(qbits or {}) do
        SetQBit(QBit(qbitId))
    end
end

function MM7.ClearQBits(qbits)
    for _, qbitId in ipairs(qbits or {}) do
        ClearQBit(QBit(qbitId))
    end
end

function MM7.HasPartyItem(itemId)
    return HasItemAnywhere(itemId)
end

function MM7.TakePartyItem(itemId)
    evt.ForPlayer(Players.All)
    RemoveItem(itemId)
    evt.ForPlayer(Players.Current)
end

function MM7.GivePartyItem(itemId)
    AddValue(InventoryItem(itemId), itemId)
end

function MM7.AddPartyGold(gold)
    if gold ~= nil and gold ~= 0 then
        AddValue(Gold, gold)
    end
end

function MM7.AddPartyReputation(value)
    if value ~= nil and value ~= 0 then
        AddValue(ReputationInCurrentLocation, value)
    end
end

function MM7.PromotionMessage(text)
    if text ~= nil and text ~= "" then
        evt.SimpleMessage(text)
    end
end

function MM7.CompletePromotion(data)
    local firstTime = not MM7.AnyQBit(data.qbits)

    if firstTime and data.condition ~= nil and not data.condition() then
        MM7.PromotionMessage(data.refuseMessage)
        return 0
    end

    MM7.PromotionMessage(firstTime and data.firstMessage or (data.repeatMessage or data.firstMessage))

    local result = PromotePlayers({
        from = data.from,
        to = data.to,
        promotedRewards = {Experience = data.promotedExperience or 0},
        nonPromotedRewards = firstTime and {Experience = data.nonPromotedExperience or 0} or nil,
    })

    if firstTime then
        MM7.SetQBits(data.qbits)
        MM7.AddPartyGold(data.gold)
        MM7.AddPartyReputation(data.reputation)
    end

    return firstTime and 1 or 2, result
end

function MM7.CheckPromotionSide(thisSideBit, oppositeSideBit, thisMessage, oppositeMessage, neitherMessage)
    if IsQBitSet(QBit(thisSideBit)) then
        MM7.PromotionMessage(thisMessage)
        return true
    end

    if IsQBitSet(QBit(oppositeSideBit)) then
        MM7.PromotionMessage(oppositeMessage)
        return false
    end

    MM7.PromotionMessage(neitherMessage)
    return false
end

function MM7.AntagarichArcherFirstPromotion()
    local result = MM7.CompletePromotion({
        from = 0,
        to = 1,
        promotedExperience = 30000,
        nonPromotedExperience = 15000,
        gold = 7500,
        qbits = {1584, 1585},
        reputation = -10,
        firstMessage = "You have proven yourselves worthy of the Warrior Mage title.",
        repeatMessage = "Any Archers among you are now Warrior Mages.",
        refuseMessage = "Return when the Warrior Mage trial is complete.",
        condition = function() return IsQBitSet(QBit(570)) end,
    })

    if result == 1 then
        ClearQBit(QBit(543))
        evt.SetNPCTopic(380, 1, 819)
    end
end

function MM7.AntagarichArcherGoodPath()
    if IsQBitSet(QBit(612)) then
        evt.SetNPCTopic(380, 1, 820)
        SetQBit(QBit(544))
        MM7.PromotionMessage("The Sniper path is now open.")
    elseif IsQBitSet(QBit(611)) then
        MM7.PromotionMessage("You chose Light; Sniper training is not your path.")
    else
        MM7.PromotionMessage("Choose Light or Dark before continuing this promotion.")
    end
end

function MM7.AntagarichMasterArcherPromotion()
    local result = MM7.CompletePromotion({
        from = 1,
        to = 2,
        promotedExperience = 80000,
        nonPromotedExperience = 40000,
        qbits = {1586, 1587},
        reputation = -10,
        firstMessage = "You are now Master Archers.",
        repeatMessage = "Any Warrior Mages among you are now Master Archers.",
        refuseMessage = "Return with the bow required for Master Archer training.",
        condition = function() return MM7.HasPartyItem(1344) end,
    })

    if result == 1 then
        MM7.GivePartyItem(1345)
        MM7.TakePartyItem(1344)
        evt.SetNPCGreeting(379, 172)
        ClearQBit(QBit(542))
    end
end

function MM7.AntagarichSniperPromotion()
    local result = MM7.CompletePromotion({
        from = 1,
        to = 3,
        promotedExperience = 80000,
        nonPromotedExperience = 40000,
        qbits = {1588, 1589},
        reputation = 10,
        firstMessage = "You are now Snipers.",
        repeatMessage = "Any Warrior Mages among you are now Snipers.",
        refuseMessage = "Return with the bow required for Sniper training.",
        condition = function() return MM7.HasPartyItem(1344) end,
    })

    if result == 1 then
        MM7.GivePartyItem(1345)
        MM7.TakePartyItem(1344)
        evt.SetNPCGreeting(380, 174)
        ClearQBit(QBit(544))
    elseif result == 0 then
        SetQBit(QBit(544))
    end
end

function MM7.AntagarichClericFirstPromotion()
    local result = MM7.CompletePromotion({
        from = 4,
        to = 5,
        promotedExperience = 30000,
        nonPromotedExperience = 15000,
        gold = 5000,
        qbits = {1607, 1608},
        reputation = -5,
        firstMessage = "You are now Priests.",
        repeatMessage = "Any Clerics among you are now Priests.",
        refuseMessage = "Return with the lost pirate map.",
        condition = function() return MM7.HasPartyItem(1485) end,
    })

    if result == 1 then
        MM7.TakePartyItem(1485)
        ClearQBit(QBit(730))
        SetQBit(QBit(576))
        ClearQBit(QBit(555))
        evt.SetNPCTopic(386, 1, 840)
        evt.SetNPCTopic(386, 0, 839)
    elseif result == 2 then
        ClearQBit(QBit(555))
    end
end

function MM7.AntagarichPriestLightGate()
    if MM7.AnyQBit({1607, 1608}) then
        if IsQBitSet(QBit(612)) then
            MM7.PromotionMessage("The Light priesthood will not train followers of Darkness.")
        elseif IsQBitSet(QBit(611)) then
            MM7.PromotionMessage("The Priest of Light task is now available.")
            SetQBit(QBit(554))
            evt.SetNPCTopic(385, 0, 837)
        else
            MM7.PromotionMessage("Choose Light before continuing this promotion.")
        end
    else
        MM7.PromotionMessage("Become Priests before seeking the second promotion.")
    end
end

function MM7.AntagarichPriestDarkGate()
    if IsQBitSet(QBit(611)) then
        MM7.PromotionMessage("The Dark priesthood will not train followers of Light.")
    elseif IsQBitSet(QBit(612)) then
        MM7.PromotionMessage("The Priest of Dark task is now available.")
        SetQBit(QBit(556))
        evt.SetNPCTopic(386, 1, 841)
    else
        MM7.PromotionMessage("Choose Dark before continuing this promotion.")
    end
end

function MM7.AntagarichPriestLightPromotion()
    local result = MM7.CompletePromotion({
        from = 5,
        to = 6,
        promotedExperience = 80000,
        nonPromotedExperience = 40000,
        gold = 10000,
        qbits = {1609, 1610},
        reputation = -10,
        firstMessage = "You are now Priests of the Light.",
        repeatMessage = "Any Priests among you are now Priests of the Light.",
        refuseMessage = "Purify the altar before returning.",
        condition = function() return IsQBitSet(QBit(574)) end,
    })

    if result ~= 0 then
        ClearQBit(QBit(554))
    end

    if result == 1 then
        evt.SetNPCGreeting(385, 188)
    end
end

function MM7.AntagarichPriestDarkPromotion()
    local result = MM7.CompletePromotion({
        from = 5,
        to = 7,
        promotedExperience = 80000,
        nonPromotedExperience = 40000,
        gold = 10000,
        qbits = {1611, 1612},
        reputation = -10,
        firstMessage = "You are now Priests of the Dark.",
        repeatMessage = "Any Priests among you are now Priests of the Dark.",
        refuseMessage = "Defile the altar before returning.",
        condition = function() return IsQBitSet(QBit(575)) end,
    })

    if result ~= 0 then
        ClearQBit(QBit(556))
    end

    if result == 1 then
        evt.SetNPCGreeting(386, 190)
    end
end

function MM7.AntagarichDruidFirstPromotion()
    local result = MM7.CompletePromotion({
        from = 12,
        to = 13,
        promotedExperience = 30000,
        nonPromotedExperience = 15000,
        qbits = {1613, 1614},
        reputation = -5,
        firstMessage = "You are now Great Druids.",
        repeatMessage = "Any Druids among you are now Great Druids.",
        refuseMessage = "Return after completing the Ceremony of the Sun.",
        condition = function() return IsQBitSet(QBit(562)) end,
    })

    if result == 1 then
        ClearQBit(QBit(561))
        evt.SetNPCTopic(389, 1, 850)
    elseif result == 0 and (IsQBitSet(QBit(563)) or IsQBitSet(QBit(564)) or IsQBitSet(QBit(565))) then
        MM7.PromotionMessage("The ceremony is incomplete.")
    end
end

function MM7.StartArchDruidPromotionFromEitherPath()
    if not MM7.AnyQBit({1613, 1614}) then
        MM7.PromotionMessage("Become Great Druids before seeking the Arch Druid promotion.")
        return
    end

    if MM7.CheckPromotionSide(611, 612, "The Arch Druid task is now available.", "Followers of Darkness would normally be refused, but Verdant's merged path keeps this route available.", "Choose a path before continuing this promotion.") then
        SetQBit(QBit(566))
        evt.SetNPCTopic(389, 1, 851)
        return
    end

    if IsQBitSet(QBit(612)) then
        SetQBit(QBit(566))
        evt.SetNPCTopic(389, 1, 851)
    end
end

function MM7.AntagarichArchDruidPromotion()
    local result = MM7.CompletePromotion({
        from = 13,
        to = 15,
        promotedExperience = 80000,
        nonPromotedExperience = 40000,
        qbits = {1615, 1616},
        reputation = -10,
        firstMessage = "You are now Arch Druids.",
        repeatMessage = "Any Great Druids among you are now Arch Druids.",
        refuseMessage = "Return after laying the Dwarf King's bones to rest.",
        condition = function() return IsQBitSet(QBit(577)) end,
    })

    if result == 1 then
        ClearQBit(QBit(566))
        evt.SetNPCGreeting(389, 196)
    end
end

function MM7.StartWarlockPromotionFromEitherPath()
    if not MM7.AnyQBit({1613, 1614}) then
        MM7.PromotionMessage("Become Great Druids before seeking the Warlock promotion.")
        return
    end

    if MM7.CheckPromotionSide(612, 611, "The Warlock task is now available.", "Followers of Light would normally be refused, but Verdant's merged path keeps this route available.", "Choose a path before continuing this promotion.") then
        SetQBit(QBit(567))
        evt.SetNPCTopic(390, 0, 853)
        return
    end

    if IsQBitSet(QBit(611)) then
        SetQBit(QBit(567))
        evt.SetNPCTopic(390, 0, 853)
    end
end

function MM7.AntagarichWarlockPromotion()
    local result = MM7.CompletePromotion({
        from = 13,
        to = 14,
        promotedExperience = 80000,
        nonPromotedExperience = 40000,
        qbits = {1617, 1618},
        reputation = -10,
        firstMessage = "You are now Warlocks.",
        repeatMessage = "Any Great Druids among you are now Warlocks.",
        refuseMessage = "Return with the dragon egg.",
        condition = function() return MM7.HasPartyItem(1449) end,
    })

    if result == 1 then
        ClearQBit(QBit(567))
        ClearQBit(QBit(739))
        evt.SetNPCGreeting(390, 198)
        SetQBit(QBit(1687))
        MM7.TakePartyItem(1449)
        AddFollowerNpc(396)
    end
end

function MM7.AntagarichPaladinStart()
    MM7.PromotionMessage("Sir Charles Quixote joins you for the Crusader trial.")
    AddFollowerNpc(356)
    SetQBit(QBit(534))
    SetQBit(QBit(1684))
    evt.MoveNPC(356, 0)
    evt.SetNPCTopic(356, 0, 802)
end

function MM7.AntagarichCrusaderPromotion()
    local result = MM7.CompletePromotion({
        from = 26,
        to = 27,
        promotedExperience = 30000,
        nonPromotedExperience = 15000,
        qbits = {1590, 1591},
        reputation = -5,
        firstMessage = "You are now Crusaders.",
        repeatMessage = "Any Paladins among you are now Crusaders.",
        refuseMessage = "Kill Wromthrax before returning.",
        condition = function() return IsQBitSet(QBit(535)) end,
    })

    if result == 1 then
        ClearQBit(QBit(534))
        ClearQBit(QBit(1684))
        evt.MoveNPC(356, 941)
        evt.SetNPCTopic(356, 0, 803)
        evt.SetNPCTopic(356, 1, 802)
        evt.SetNPCGreeting(356, 158)
        RemoveFollowerNpc(356)
    end
end

function MM7.AddAliceFollowerForPaladinSecondPromotion()
    if (IsQBitSet(QBit(611)) or IsQBitSet(QBit(612))) and not (IsQBitSet(QBit(1592)) or IsQBitSet(QBit(1594))) then
        AddFollowerNpc(393)
    end
end

function MM7.AntagarichHeroGate()
    if IsQBitSet(QBit(611)) then
        MM7.PromotionMessage("The Hero task is now available.")
        SetQBit(QBit(536))
        evt.SetNPCTopic(356, 0, 804)
        evt.SetNPCGreeting(356, 158)
        evt.MoveNPC(393, 1158)
    elseif IsQBitSet(QBit(612)) then
        MM7.PromotionMessage("Followers of Darkness cannot become Heroes.")
    else
        MM7.PromotionMessage("Choose Light before continuing this promotion.")
    end
end

function MM7.AntagarichHeroPromotion()
    local result = MM7.CompletePromotion({
        from = 27,
        to = 28,
        promotedExperience = 80000,
        nonPromotedExperience = 40000,
        qbits = {1592, 1593},
        reputation = -10,
        firstMessage = "You are now Heroes.",
        repeatMessage = "Any Crusaders among you are now Heroes.",
        refuseMessage = "Rescue Alice before returning.",
        condition = function() return IsQBitSet(QBit(1685)) end,
    })

    if result == 1 then
        RemoveFollowerNpc(393)
        ClearQBit(QBit(536))
        ClearQBit(QBit(1685))
        evt.MoveNPC(393, 941)
        evt.SetNPCGreeting(356, 161)
    elseif result == 0 then
        SetQBit(QBit(536))
    end
end

function MM7.AntagarichVillainPromotion()
    local result = MM7.CompletePromotion({
        from = 27,
        to = 29,
        promotedExperience = 80000,
        nonPromotedExperience = 40000,
        qbits = {1594, 1595},
        reputation = 10,
        firstMessage = "You are now Villains.",
        repeatMessage = "Any Crusaders among you are now Villains.",
        refuseMessage = "Capture Alice before returning.",
        condition = function() return IsQBitSet(QBit(1685)) end,
    })

    if result == 1 then
        RemoveFollowerNpc(393)
        ClearQBit(QBit(538))
        ClearQBit(QBit(1685))
        evt.SetNPCGreeting(357, 165)
    end
end

function MM7.AntagarichMonkFirstPromotion()
    local result = MM7.CompletePromotion({
        from = 22,
        to = 23,
        promotedExperience = 30000,
        nonPromotedExperience = 15000,
        qbits = {1572, 1573},
        firstMessage = "You are now Initiates.",
        repeatMessage = "Any Monks among you are now Initiates.",
    })

    ClearQBit(QBit(539))
    ClearQBit(QBit(1685))
    evt.SetNPCTopic(377, 0, 810)
    evt.SetNPCTopic(377, 1, 811)
    evt.SetNPCTopic(394, 0, 810)
    evt.SetNPCTopic(394, 1, 811)
end

function MM7.AntagarichMasterGate()
    if IsQBitSet(QBit(611)) then
        SetQBit(QBit(540))
        evt.SetNPCTopic(377, 1, 812)
        evt.SetNPCTopic(394, 1, 812)
        MM7.PromotionMessage("The Master task is now available.")
    elseif IsQBitSet(QBit(612)) then
        MM7.PromotionMessage("Followers of Darkness cannot become Masters.")
    else
        MM7.PromotionMessage("Choose Light before continuing this promotion.")
    end
end

function MM7.AntagarichMasterPromotion()
    local result = MM7.CompletePromotion({
        from = 23,
        to = 24,
        promotedExperience = 80000,
        nonPromotedExperience = 40000,
        qbits = {1574, 1575},
        reputation = -10,
        firstMessage = "You are now Masters.",
        repeatMessage = "Any Initiates among you are now Masters.",
        refuseMessage = "Return with proof of completing the Master task.",
        condition = function() return IsQBitSet(QBit(755)) or MM7.HasPartyItem(1332) end,
    })

    if result ~= 0 then
        ClearQBit(QBit(540))
    end

    if result == 1 then
        evt.SetNPCGreeting(377, 167)
    end
end

function MM7.AntagarichNinjaPromotion()
    local result = MM7.CompletePromotion({
        from = 23,
        to = 25,
        promotedExperience = 80000,
        nonPromotedExperience = 40000,
        qbits = {1576, 1577},
        reputation = -10,
        firstMessage = "You are now Ninjas.",
        repeatMessage = "Any Initiates among you are now Ninjas.",
        refuseMessage = "Return after completing the Ninja task.",
        condition = function() return IsQBitSet(QBit(754)) end,
    })

    if result ~= 0 then
        ClearQBit(QBit(541))
    elseif IsQBitSet(QBit(569)) then
        MM7.PromotionMessage("The trial is underway.")
    end

    if result == 1 then
        evt.SetNPCGreeting(378, 170)
    end
end

function MM7.AntagarichKnightFirstPromotion()
    local result = MM7.CompletePromotion({
        from = 16,
        to = 17,
        promotedExperience = 30000,
        nonPromotedExperience = 15000,
        qbits = {1566, 1567},
        reputation = -5,
        firstMessage = "You are now Cavaliers.",
        repeatMessage = "Any Knights among you are now Cavaliers.",
        refuseMessage = "Win the required arena rank before returning.",
        condition = function() return IsQBitSet(QBit(652)) end,
    })

    if result == 1 then
        ClearQBit(QBit(546))
        evt.SetNPCTopic(382, 1, 825)
    end
end

function MM7.AntagarichBlackKnightGate()
    if MM7.CheckPromotionSide(612, 611, "The Black Knight task is now available.", "Followers of Light cannot become Black Knights.", "Choose Dark before continuing this promotion.") then
        SetQBit(QBit(547))
        evt.SetNPCTopic(382, 1, 826)
    end
end

function MM7.AntagarichBlackKnightPromotion()
    local result = MM7.CompletePromotion({
        from = 17,
        to = 18,
        promotedExperience = 80000,
        nonPromotedExperience = 40000,
        qbits = {1570, 1571},
        reputation = -10,
        firstMessage = "You are now Black Knights.",
        repeatMessage = "Any Cavaliers among you are now Black Knights.",
        refuseMessage = "Return after completing the Black Knight task.",
        condition = function() return IsQBitSet(QBit(572)) end,
    })

    if result == 1 then
        ClearQBit(QBit(547))
        evt.SetNPCGreeting(382, 178)
    end
end

function MM7.AntagarichChampionGate()
    if MM7.AnyQBit({1566, 1567}) then
        if MM7.CheckPromotionSide(611, 612, "The Champion task is now available.", "Followers of Darkness cannot become Champions.", "Choose Light before continuing this promotion.") then
            SetQBit(QBit(545))
            evt.SetNPCTopic(381, 0, 822)
        end
    else
        MM7.PromotionMessage("Become Cavaliers before seeking Champion training.")
    end
end

function MM7.AntagarichChampionPromotion()
    local result = MM7.CompletePromotion({
        from = 17,
        to = 19,
        promotedExperience = 80000,
        nonPromotedExperience = 40000,
        qbits = {1568, 1569},
        reputation = -10,
        firstMessage = "You are now Champions.",
        repeatMessage = "Any Cavaliers among you are now Champions.",
        refuseMessage = "Win enough Knight arena battles before returning.",
        condition = function() return IsAtLeast(ArenaWinsKnight, 5) end,
    })

    if result == 1 then
        ClearQBit(QBit(545))
        evt.SetNPCGreeting(381, 176)
    end
end

function MM7.AntagarichRangerFirstPromotion()
    if MM7.AnyQBit({1578, 1579}) then
        ClearQBit(QBit(549))
        MM7.CompletePromotion({
            from = 30,
            to = 31,
            promotedExperience = 30000,
            qbits = {1578, 1579},
            firstMessage = "Any Rangers among you are now Hunters.",
        })
        return
    end

    SetQBit(QBit(549))
    MM7.PromotionMessage("The Hunter promotion task is now available.")
end

function MM7.AntagarichRangerCompleteFirstPromotion()
    MM7.CompletePromotion({
        from = 30,
        to = 31,
        promotedExperience = 30000,
        nonPromotedExperience = 15000,
        qbits = {1578, 1579},
        firstMessage = "You are now Hunters.",
    })
    ClearQBit(QBit(549))
    evt.SetNPCTopic(384, 0, 830)
    evt.SetNPCTopic(384, 1, 831)
end

function MM7.AntagarichBountyHunterGate()
    if MM7.CheckPromotionSide(612, 611, "The Bounty Hunter task is now available.", "Followers of Light cannot become Bounty Hunters.", "Choose Dark before continuing this promotion.") then
        SetQBit(QBit(550))
        evt.SetNPCTopic(384, 1, 832)
    end
end

function MM7.AntagarichBountyHunterPromotion()
    local result = MM7.CompletePromotion({
        from = 31,
        to = 32,
        promotedExperience = 80000,
        nonPromotedExperience = 40000,
        qbits = {1582, 1583},
        reputation = -10,
        firstMessage = "You are now Bounty Hunters.",
        repeatMessage = "Any Hunters among you are now Bounty Hunters.",
        refuseMessage = "Collect the required bounty before returning.",
        condition = function() return IsAtLeast(ArenaWinsPage, 10000) end,
    })

    if result == 1 then
        ClearQBit(QBit(550))
        evt.SetNPCGreeting(384, 182)
    end
end

function MM7.AntagarichRangerLordGate()
    if MM7.AnyQBit({1578, 1579}) then
        if MM7.CheckPromotionSide(611, 612, "The Ranger Lord task is now available.", "Followers of Darkness cannot become Ranger Lords.", "Choose Light before continuing this promotion.") then
            SetQBit(QBit(548))
            evt.SetNPCTopic(383, 0, 828)
        end
    else
        MM7.PromotionMessage("Become Hunters before seeking Ranger Lord training.")
    end
end

function MM7.AntagarichRangerLordPromotion()
    local result = MM7.CompletePromotion({
        from = 31,
        to = 33,
        promotedExperience = 80000,
        nonPromotedExperience = 40000,
        qbits = {1580, 1581},
        reputation = -5,
        firstMessage = "You are now Ranger Lords.",
        repeatMessage = "Any Hunters among you are now Ranger Lords.",
        refuseMessage = "Return after completing the Ranger Lord task.",
        condition = function() return IsQBitSet(QBit(553)) end,
    })

    if result == 1 then
        ClearQBit(QBit(548))
        evt.SetNPCGreeting(383, 180)
    elseif result == 2 then
        ClearQBit(QBit(548))
    elseif result == 0 and IsQBitSet(QBit(552)) then
        MM7.PromotionMessage("The Ranger Lord task is underway.")
    end
end

function MM7.AntagarichThiefFirstPromotion()
    if MM7.AnyQBit({1560, 1561}) then
        MM7.CompletePromotion({
            from = 34,
            to = 35,
            promotedExperience = 15000,
            qbits = {1560, 1561},
            firstMessage = "Any Thieves among you are now Rogues.",
        })
        return
    end

    local result = MM7.CompletePromotion({
        from = 34,
        to = 35,
        promotedExperience = 30000,
        nonPromotedExperience = 15000,
        gold = 5000,
        qbits = {1560, 1561},
        firstMessage = "You are now Rogues.",
        refuseMessage = "Return with Lord Markham's vase.",
        condition = function() return MM7.HasPartyItem(1426) end,
    })

    if result == 1 then
        MM7.TakePartyItem(1426)
        ClearQBit(QBit(724))
        ClearQBit(QBit(530))
        evt.SetNPCTopic(354, 1, 796)
        evt.SetNPCTopic(354, 0, 795)
    end
end

function MM7.AntagarichSpyGate()
    if IsQBitSet(QBit(611)) then
        SetQBit(QBit(531))
        evt.SetNPCTopic(354, 1, 797)
        MM7.PromotionMessage("The Spy task is now available.")
    elseif IsQBitSet(QBit(612)) then
        MM7.PromotionMessage("Followers of Darkness cannot become Spies.")
    else
        MM7.PromotionMessage("Choose Light before continuing this promotion.")
    end
end

function MM7.AntagarichSpyPromotion()
    local result = MM7.CompletePromotion({
        from = 35,
        to = 37,
        promotedExperience = 80000,
        nonPromotedExperience = 40000,
        gold = 15000,
        qbits = {1562, 1563},
        firstMessage = "You are now Spies.",
        repeatMessage = "Any Rogues among you are now Spies.",
        refuseMessage = "Move the Watchtower weight before returning.",
        condition = function() return IsQBitSet(QBit(532)) end,
    })

    if result == 1 then
        ClearQBit(QBit(531))
        evt.SetNPCGreeting(354, 154)
    elseif result == 0 and IsQBitSet(QBit(568)) then
        MM7.PromotionMessage("The Watchtower task is underway.")
    end
end

function MM7.AntagarichAssassinPromotion()
    local result = MM7.CompletePromotion({
        from = 35,
        to = 36,
        promotedExperience = 80000,
        nonPromotedExperience = 40000,
        gold = 15000,
        qbits = {1564, 1565},
        reputation = 10,
        firstMessage = "You are now Assassins.",
        repeatMessage = "Any Rogues among you are now Assassins.",
        refuseMessage = "Return with Lady Carmine's dagger.",
        condition = function() return MM7.HasPartyItem(1342) end,
    })

    if result == 1 then
        MM7.TakePartyItem(1342)
        ClearQBit(QBit(725))
        ClearQBit(QBit(533))
        evt.SetNPCGreeting(355, 157)
    end
end

function MM7.AntagarichWizardFollower()
    AddFollowerNpc(395)
end

function MM7.AntagarichWizardPromotion()
    local result = MM7.CompletePromotion({
        from = 42,
        to = 43,
        promotedExperience = 30000,
        nonPromotedExperience = 15000,
        qbits = {1619, 1620},
        reputation = -5,
        firstMessage = "You are now Wizards.",
        repeatMessage = "Any Sorcerers among you are now Wizards.",
        refuseMessage = "Assemble the golem before returning.",
        condition = function() return IsQBitSet(QBit(585)) or IsQBitSet(QBit(586)) end,
    })

    if result == 1 then
        ClearQBit(QBit(557))
        ClearQBit(QBit(731))
        ClearQBit(QBit(732))
        SetQBit(QBit(558))
        evt.SetNPCTopic(387, 1, 844)
        evt.SetNPCGreeting(395, 199)
    end
end

function MM7.AntagarichArchMageGate()
    if MM7.CheckPromotionSide(611, 612, "The Archmage task is now available.", "Followers of Darkness cannot become Archmages.", "Choose Light before continuing this promotion.") then
        SetQBit(QBit(559))
        evt.SetNPCTopic(387, 1, 845)
    end
end

function MM7.AntagarichArchMagePromotion()
    local result = MM7.CompletePromotion({
        from = 43,
        to = 46,
        promotedExperience = 80000,
        nonPromotedExperience = 40000,
        gold = 10000,
        qbits = {1621, 1622},
        firstMessage = "You are now Archmages.",
        repeatMessage = "Any Wizards among you are now Archmages.",
        refuseMessage = "Return with Divine Intervention.",
        condition = function() return MM7.HasPartyItem(1289) end,
    })

    if result == 1 then
        MM7.TakePartyItem(1289)
        ClearQBit(QBit(559))
        ClearQBit(QBit(738))
        evt.SetNPCGreeting(387, 192)
    end
end

function MM7.AntagarichLichGate()
    local allowed = MM7.AnyQBit({1619, 1620}) or PlayerClassMatches(0, {44, 45})

    if not allowed then
        MM7.PromotionMessage("Become Wizards before seeking the Ritual of the Void.")
        return
    end

    if IsQBitSet(QBit(612)) then
        SetQBit(QBit(560))
        evt.SetNPCTopic(388, 0, 847)
        MM7.PromotionMessage("The Lich ritual is now available.")
    elseif IsQBitSet(QBit(611)) then
        MM7.PromotionMessage("Followers of Light cannot become Liches.")
    else
        MM7.PromotionMessage("Choose Dark before continuing this promotion.")
    end
end

function MM7.AntagarichLichPromotion()
    local memberCount = evt.GetPartyMemberCount()
    local promotedCount = 0
    local honoraryCount = 0
    local consumedJarCount = 0

    for playerIndex = 0, memberCount - 1 do
        local classId = GetPlayerClass(playerIndex)
        local jarItem = 0

        if PlayerHasItem(playerIndex, 1417) then
            jarItem = 1417
        elseif classId == 47 and PlayerHasItem(playerIndex, 628) then
            jarItem = 628
        end

        if jarItem ~= 0 then
            RemovePlayerItem(playerIndex, jarItem)
            consumedJarCount = consumedJarCount + 1

            if PlayerClassMatches(playerIndex, {43, 44, 47}) then
                if ApplyLichTransformation(playerIndex) then
                    promotedCount = promotedCount + 1
                    ApplyPlayerRewards(playerIndex, {Experience = 40000})
                end
            else
                honoraryCount = honoraryCount + 1

                if not IsQBitSet(QBit(1624)) then
                    ApplyPlayerRewards(playerIndex, {Experience = 40000})
                end

                MM7.AddPartyGold(1500)
            end
        end
    end

    if consumedJarCount == 0 then
        MM7.PromotionMessage("Return with soul jars.")
        return
    end

    SetQBit(QBit(1624))

    if promotedCount > 0 then
        SetQBit(QBit(1623))
    end

    ClearQBit(QBit(560))
    ClearQBit(QBit(741))
    evt.SetNPCTopic(388, 0, 0)
    evt.SetNPCGreeting(388, 194)

    if promotedCount > 0 then
        MM7.PromotionMessage("The Ritual is complete. Wizards and Necromancers carrying soul jars are now Liches.")
    elseif honoraryCount > 0 then
        MM7.PromotionMessage("The jars are accepted. You are recognized as Honorary Liches.")
    else
        MM7.PromotionMessage("The jars are accepted, but none among you can complete the Ritual.")
    end
end

function MM7.UpdateEvenmornObeliskTreasure()
    local allObelisksFound = true

    for qbitId = 676, 689 do
        allObelisksFound = allObelisksFound and IsQBitSet(QBit(qbitId))
    end

    if not allObelisksFound then
        return
    end

    if IsAtLeast(Hour, 1) then
        evt.SetSprite(170, 0, "0")
    end
end

function MM7.OpenEvenmornDimensionDoorIfNear()
    if MM7.DistanceToPartySquared(-5121, 98) < 1500 * 1500 then
        MM7.OpenDimensionDoor()
    end
end

function MM7.SummonTulareanArtifactBattle()
    evt.SetFacetBit(1, FacetBits.Untouchable, 0)
    evt.SetFacetBit(1, FacetBits.Invisible, 0)
    evt.SummonMonsters(2, 2, 3, -15752, 21272, 3273, 51, 0)
    evt.SummonMonsters(2, 2, 5, -14000, 18576, 4250, 51, 0)
    evt.SummonMonsters(2, 2, 10, -16016, 19280, 3284, 51, 0)
    evt.SummonMonsters(3, 2, 3, -15752, 21272, 3273, 50, 0)
    evt.SummonMonsters(3, 2, 9, -14000, 18576, 4250, 50, 0)
    evt.SummonMonsters(3, 2, 10, -16016, 19280, 3284, 50, 0)
end

function MM7.UpdateTulareanArtifactBattle()
    if IsQBitSet(QBit(646)) then -- Judge Grey died
        return
    end

    if not IsQBitSet(QBit(649)) then -- Artifact Messenger only happens once
        if not IsQBitSet(QBit(600)) then -- Talked to Catherine
            return
        end

        if IsQBitSet(QBit(589)) or IsQBitSet(QBit(590)) then
            return
        end

        evt.SpeakNPC(412) -- Messenger
        AddValue(InventoryItem(1502), 1502) -- Message from Erathia
        SetQBit(QBit(649)) -- Artifact Messenger only happens once
        SetQBit(QBit(591)) -- Retrieve Gryphonheart's Trumpet
        SetValue(MapVar(11), 0)
    end

    if not IsQBitSet(QBit(591)) or IsAtLeast(MapVar(11), 1) then
        return
    end

    SetValue(MapVar(11), 1)
    MM7.SummonTulareanArtifactBattle()
end

function MM7.EnterClankersLaboratory()
    if IsQBitSet(QBit(710)) then -- Archibald in Clanker's Lab now
        evt.MoveNPC(427, 395)
        evt.EnterHouse(395) -- Clanker's Laboratory
        return
    end

    evt.MoveToMap(0, -709, 1, 512, 0, 0, 395, 9, "7d12.blv")
end

function MM7.RemoveJudgeFollowers()
    RemoveFollowerNpc(MM7.JudgeFairweatherNpcId)
    RemoveFollowerNpc(MM7.JudgeSleenNpcId)
end

function MM7.EnterCastleHarmondaleOutdoor()
    if IsQBitSet(QBit(519)) then -- Visited Emerald Island
        if IsQBitSet(QBit(610)) or IsQBitSet(QBit(644)) then
            if IsQBitSet(QBit(610)) then
                evt.MoveToMap(-5073, -2842, 1, 512, 0, 0, 382, 9, "7d29.blv")
            else
                evt.MoveToMap(-5073, -2842, 1, 512, 0, 0, 390, 9, "7d29.blv")
            end
            return
        end

        SetQBit(QBit(644)) -- Butler only shows up once.
        SetQBit(QBit(587)) -- Clean out Castle Harmondale.
        AddValue(History(5), 0)
        evt.MoveNPC(397, 240)
        evt.SpeakNPC(397)
        return
    end

    evt.FaceAnimation(FaceAnimation.DoorLocked)
end

function MM7.UpdateHarmondaleInvasion()
    if IsQBitSet(QBit(611)) or IsQBitSet(QBit(612)) then
        SetQBit(QBit(608))
    end

    if not (IsQBitSet(QBit(693)) or IsQBitSet(QBit(694))) then
        return
    end

    if IsQBitSet(QBit(702)) or IsQBitSet(QBit(695)) then
        return
    end

    local invasionTime = evt.GetMapVar("InvasionTime", 0)
    if invasionTime == 0 then
        invasionTime = CurrentGameMinutes() + 14 * 24 * 60
        evt.SetMapVar("InvasionTime", invasionTime)
    end

    if invasionTime >= CurrentGameMinutes() then
        return
    end

    SetQBit(QBit(695))
    evt.SetMonGroupBit(60, MonsterBits.Hostile, 1)
    evt.SetMonGroupBit(60, MonsterBits.Invisible, 0)
    SetValue(BankGold, 0)
    evt.SpeakNPC(437)
end

function MM7.GiveScavengerAdvertisementIfNear(x, y, requireNoAdvertisementItem)
    if evt.GetMapVar("GotAdvertisement", 0) ~= 0 or IsQBitSet(QBit(519)) then
        return
    end

    if requireNoAdvertisementItem and HasItemAnywhere(MM7.ScavengerAdvertisementItemId) then
        return
    end

    local enemyYellow, enemyRed = evt.GetEnemyDetectorState()
    if IsFlying() or enemyYellow or enemyRed then
        return
    end

    if MM7.DistanceToPartySquared(x, y) >= 4000 * 4000 then
        return
    end

    evt.SetMapVar("GotAdvertisement", 1)
    AddValue(InventoryItem(MM7.ScavengerAdvertisementItemId), MM7.ScavengerAdvertisementItemId)
    evt.SetNPCGreeting(649, 332)
    evt.SpeakNPC(649)
end

function MM7.UpdateJudgeGreyDeath()
    if not IsQBitSet(QBit(610)) then -- Built Castle to Level 2.
        return
    end

    local rebuiltDate = evt.GetGlobalVar("HarmondaleRebuiltDate", 0)
    if rebuiltDate == 0 then
        rebuiltDate = CurrentGameMinutes()
        evt.SetGlobalVar("HarmondaleRebuiltDate", rebuiltDate)
    end

    if IsQBitSet(QBit(646)) then -- Arbiter Messenger only happens once.
        return
    end

    local sixMonths = 6 * 28 * 24 * 60
    if not (IsQBitSet(QBit(659))
        or IsQBitSet(QBit(596))
        or IsQBitSet(QBit(597))
        or CurrentGameMinutes() > rebuiltDate + sixMonths) then
        return
    end

    evt.SpeakNPC(430)
    SetQBit(QBit(665))
    AddValue(History(8), 0)
    evt.MoveNPC(406, 0)
    evt.MoveNPC(407, 0)
    evt.MoveNPC(414, 1169)
    evt.MoveNPC(415, 1169)
    evt.MoveNPC(416, 244)
    evt.MoveNPC(417, 243)
    SetQBit(QBit(646))
end

function MM7.AllPartyMembersHaveWetsuit()
    local count = evt.GetPartyMemberCount()

    for memberIndex = 0, count - 1 do
        if not evt.PartyMemberHasEquippedItem(memberIndex, MM7.WetsuitItemId) then
            return false
        end
    end

    return true
end

function MM7.BlockShoalsTravelWithoutWetsuits(context)
    if context == nil or context.boundaryEdge ~= 3 then -- West edge.
        return
    end

    if string.lower(context.destinationMapName or "") ~= "7out15.odm" then
        return
    end

    local hasLincolnQuest = IsQBitSet(QBit(642)) or IsQBitSet(QBit(643)) or IsQBitSet(QBit(783))
    if not hasLincolnQuest then
        evt.SetHookBlocked(true, nil)
        return
    end

    if MM7.AllPartyMembersHaveWetsuit() then
        return
    end

    evt.SetHookBlocked(true, "You must all be wearing your wetsuits!")
end

function MM7.BlockShoalsUnderwaterAction(context)
    if context == nil then
        return
    end

    if context.actionId == 133 or context.actionId == 105
        or (context.heldItemId == MM7.WetsuitItemId and context.actionId ~= 120 and context.actionId ~= 12) then
        evt.PlaySound(27)
        evt.SetHookBlocked(true, "You can't do that here.")
    end
end

function MM7.ApplyShoalsPartyPortraits()
    -- Older OpenYAMM saves may already be on Shoals with the temporary wetsuit portrait forced.
    MM7.RestoreShoalsPartyPortraits()
end

function MM7.RestoreShoalsPartyPortraits()
    local count = evt.GetPartyMemberCount()

    for memberIndex = 0, count - 1 do
        local varName = "ShoalsOriginalPortrait" .. tostring(memberIndex)
        local storedPortrait = evt.GetMapVar(varName, 0)
        if storedPortrait > 0 then
            evt.SetPartyMemberPortraitId(memberIndex, storedPortrait - 1)
        end
        evt.SetMapVar(varName, 0)
    end
end

function MM7.KillUnsuitedShoalsPartyMembers()
    local _, _, partyZ = evt.GetPartyPosition()
    if partyZ > 3900 and evt.GetCurrentScreen() == 0 then
        return
    end

    local count = evt.GetPartyMemberCount()

    for memberIndex = 0, count - 1 do
        if not evt.PartyMemberHasEquippedItem(memberIndex, MM7.WetsuitItemId) then
            evt.ForPlayer(memberIndex)
            if not IsAtLeast(Dead, 0) then
                SetValue(CurrentHealth, 0)
                SetValue(Dead, 0)
            end
        end
    end

    evt.ForPlayer(Players.Current)
end

function MM7.LeaveShoalsIfAboveWater()
    local _, _, partyZ = evt.GetPartyPosition()
    if partyZ <= 3900 or evt.GetCurrentScreen() ~= 0 then
        evt.SetMapVar("ShoalsWasAboveWater", 1)
        return
    end

    if evt.GetMapVar("ShoalsWasAboveWater", 1) == 0 then
        return
    end

    evt.SetMapVar("ShoalsWasAboveWater", 0)
    evt.MoveToMap(-18584, -16562, 1, 290, 0, 0, 0, 8, "out14.odm")
end

function MM7.RemoveRescuedDwarfFollowers()
    if not IsQBitSet(QBit(610)) then -- Built Castle to Level 2
        return
    end

    for _, npcId in ipairs(MM7.RescuedDwarfNpcIds) do
        RemoveFollowerNpc(npcId)
    end
end

function MM7.RemoveLorenFollowersIfResolved()
    if not IsQBitSet(QBit(1695)) then
        RemoveFollowerNpc(MM7.LorenNpcId)
    end

    if not IsQBitSet(QBit(1696)) then
        RemoveFollowerNpc(MM7.FakeLorenNpcId)
    end
end

function MM7.AddLorenFollowerIfActive()
    if IsQBitSet(QBit(1695)) then
        AddFollowerNpc(MM7.LorenNpcId)
    end
end

function MM7.AddFakeLorenFollowerIfActive()
    if IsQBitSet(QBit(1696)) then
        AddFollowerNpc(MM7.FakeLorenNpcId)
    end
end

function MM7.ChooseJudgeSleenFollower()
    RemoveFollowerNpc(MM7.JudgeFairweatherNpcId)
    AddFollowerNpc(MM7.JudgeSleenNpcId)
end

function MM7.ChooseJudgeFairweatherFollower()
    RemoveFollowerNpc(MM7.JudgeSleenNpcId)
    AddFollowerNpc(MM7.JudgeFairweatherNpcId)
end

MM7.SeerRecoverableItems = {
    {Item = 1426, QBit = 724}, -- Vase
    {Item = 1342, QBit = 725}, -- Lady Carmine's Dagger
    {Item = 1504, QBit = 726}, -- Scroll of Waves
    {Item = 1503, QBit = 727}, -- Cipher
    {Item = 1451, QBit = 728}, -- Worn Belt
    {Item = 1402, QBit = 729}, -- Heart of the Wood
    {Item = 1485, QBit = 730}, -- Map to Evenmorn
    {Item = 1443, QBit = 731}, -- Golem Head
    {Item = 1442, QBit = 732}, -- Abbey Normal Golem Head
    {Item = 1446, QBit = 733}, -- Golem Right Arm
    {Item = 1447, QBit = 734}, -- Golem Left Arm
    {Item = 1445, QBit = 735}, -- Golem Right Leg
    {Item = 1444, QBit = 736}, -- Golem Left Leg
    {Item = 1441, QBit = 737}, -- Golem Torso
    {Item = 1289, QBit = 738}, -- Book of Divine Intervention
    {Item = 1449, QBit = 739}, -- Dragon Egg
    {Item = 1428, QBit = 740}, -- Dwarf Bones
    {Item = 1417, QBit = 741}, -- Lich Jar (Empty)
    {Item = 1431, QBit = 742}, -- Elixir
    {Item = 1404, QBit = 743}, -- Lich Jar Case
    {Item = 1478, QBit = 744}, -- Altar Piece (Good)
    {Item = 1479, QBit = 745}, -- Altar Piece (Evil)
    {Item = 1477, QBit = 746}, -- Control Cube
    {Item = 1406, QBit = 747}, -- Wetsuit
    {Item = 1407, QBit = 748}, -- Oscillation Overthruster
    {Item = 1403, QBit = 749}, -- Lich Jar
}

function MM7.RecoverLostItem()
    support.tryRecoverLostItem(MM7.SeerRecoverableItems)
end

RegisterGlobalEvent(889, "I lost it", function()
    MM7.RecoverLostItem()
end)
