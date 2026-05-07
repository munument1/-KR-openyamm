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

function MM7.UpdateAntagarichEndgameStarted()
    if IsQBitSet(QBit(783)) then
        ClearQBit(QBit(642))
    else
        SetQBit(QBit(642))
    end
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
        [1] = 228, -- Enroth
        [2] = 783, -- Antagarich
        [3] = 784, -- Jadame
    },
    ContinentTopicIds = {
        [1] = 1784, -- Enroth
        [2] = 1783, -- Antagarich
        [3] = 1782, -- Jadame
    },
    MeetSpotHouseIds = {
        [1] = 185,
        [2] = 641,
        [3] = 1195,
    },
    ContinentMessageText = {
        [1] = "Enroth is the simple path: train hard, help where you can, and try not to mistake every future devil for an apprentice wizard.",
        [2] = "Antagarich begins with the Emerald Island scavenger hunt and leads to Harmondale. Become lords, then keep your land alive.",
        [3] = "Jadame starts on Dagger Wound. Help the caravan, reach Ravenshore, and hold the alliance together.",
    },
}

function MM7.CrossVar(name)
    return "MMerge.CrossContinents." .. name
end

function MM7.GetCrossVar(name, defaultValue)
    return evt.GetGlobalVar(MM7.CrossVar(name), defaultValue or 0)
end

function MM7.SetCrossVar(name, value)
    evt.SetGlobalVar(MM7.CrossVar(name), value or 0)
end

function MM7.CurrentMergedContinent()
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
    local qbitId = MM7.CrossContinents.CompleteQBits[continent]
    if qbitId == nil then
        return false
    end

    return IsQBitSet(QBit(qbitId)) or MM7.GetCrossVar("Finished." .. tostring(continent), 0) ~= 0
end

function MM7.MarkCrossContinentFinished(continent)
    MM7.SetCrossVar("Finished." .. tostring(continent), 1)
end

function MM7.MarkCrossContinentAntagarichIfComplete()
    if IsQBitSet(QBit(633)) or IsQBitSet(QBit(783)) then
        MM7.MarkCrossContinentFinished(2)
    end
end

function MM7.CrossRewardCount()
    local count = 0
    for continent = 1, 3 do
        if MM7.GetCrossVar("Reward." .. tostring(continent), 0) ~= 0 then
            count = count + 1
        end
    end
    return count
end

function MM7.PlaceVerdantForCurrentContinent()
    if MM7.GetCrossVar("MetVerdant", 0) == 0 and MM7.GetCrossVar("GotMainQuest", 0) == 0 then
        return
    end

    local houseId = MM7.CrossContinents.MeetSpotHouseIds[MM7.CurrentMergedContinent()]
    if houseId ~= nil then
        evt.MoveNPC(MM7.CrossContinents.VerdantNpcId, houseId)
    end
end

function MM7.UpdateVerdantTopics()
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
    evt.SimpleMessage(MM7.CrossContinents.ContinentMessageText[continent] or "Use dimension doors to continue the displaced heroes' stories.")
    MM7.UpdateVerdantTopics()
end

function MM7.ExplainDimensionDoors()
    evt.SimpleMessage("Dimension doors in magically active places let you step onto the other heroes' paths.")
    MM7.UpdateVerdantTopics()
end

function MM7.ExplainRunawayChaos()
    SetQBit(QBit(MM7.CrossContinents.FinalQuestQBit))
    MM7.SetCrossVar("FinalQuestStarted", 1)
    evt.SimpleMessage("Verdant says the timeline damage has a source: a Runaway Chaos that must be contained.")
    MM7.UpdateVerdantTopics()
end

function MM7.ExplainControlledBreach()
    SetQBit(QBit(MM7.CrossContinents.FinalQuestQBit))
    MM7.SetCrossVar("FinalQuestStarted", 1)
    evt.SimpleMessage("The Controlled Breach is Verdant's safe arena for reaching and containing the Runaway Chaos.")
    MM7.UpdateVerdantTopics()
end

function MM7.ExplainCrossContinentsNextStep()
    MM7.SetCrossVar("FinalQuestStarted", 1)
    SetQBit(QBit(MM7.CrossContinents.FinalQuestQBit))
    evt.SimpleMessage("Verdant has another anomaly to investigate and asks you to keep helping her.")
    MM7.UpdateVerdantTopics()
end

function MM7.ExplainConnectorStone()
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

function MM7.StartWarlockPromotionFromEitherPath()
    if (IsQBitSet(QBit(611)) or IsQBitSet(QBit(612)))
        and (IsQBitSet(QBit(1613)) or IsQBitSet(QBit(1614))) then
        SetQBit(QBit(567))
        evt.SetNPCTopic(390, 0, 853)
        evt.SimpleMessage("The Warlock promotion task is now available.")
    else
        evt.SimpleMessage("Return after choosing a path and proving your druidic standing.")
    end
end

function MM7.StartArchDruidPromotionFromEitherPath()
    if (IsQBitSet(QBit(611)) or IsQBitSet(QBit(612)))
        and (IsQBitSet(QBit(1613)) or IsQBitSet(QBit(1614))) then
        SetQBit(QBit(566))
        evt.SetNPCTopic(389, 1, 851)
        evt.SimpleMessage("The Arch Druid promotion task is now available.")
    else
        evt.SimpleMessage("Return after choosing a path and proving your druidic standing.")
    end
end

function MM7.TeachBlasterSkill()
    evt.ForPlayer(Players.All)
    if not IsAtLeast(BlasterSkill, 1) then
        SetValue(BlasterSkill, SkillJoinedMask.Normal + 1)
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
        if not evt.PartyMemberHasEquippedItem(memberIndex, MM7.WetsuitItemId)
            and not evt.PartyMemberHasItem(memberIndex, MM7.WetsuitItemId) then
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

    if MM7.AllPartyMembersHaveWetsuit() then
        return
    end

    local status = nil
    if IsQBitSet(QBit(642)) or IsQBitSet(QBit(643)) or IsQBitSet(QBit(783)) then
        status = "You must all be wearing your wetsuits!"
    end
    evt.SetHookBlocked(true, status)
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
    local count = evt.GetPartyMemberCount()

    for memberIndex = 0, count - 1 do
        local varName = "ShoalsOriginalPortrait" .. tostring(memberIndex)
        if evt.GetMapVar(varName, 0) == 0 then
            evt.SetMapVar(varName, evt.GetPartyMemberPortraitId(memberIndex) + 1)
        end
        evt.SetPartyMemberPortraitId(memberIndex, 30)
    end
end

function MM7.RestoreShoalsPartyPortraits()
    local count = evt.GetPartyMemberCount()

    for memberIndex = 0, count - 1 do
        local storedPortrait = evt.GetMapVar("ShoalsOriginalPortrait" .. tostring(memberIndex), 0)
        if storedPortrait > 0 then
            evt.SetPartyMemberPortraitId(memberIndex, storedPortrait - 1)
        end
    end
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
