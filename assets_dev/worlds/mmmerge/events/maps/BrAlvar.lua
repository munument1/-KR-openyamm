-- Shared MMMerge custom content: Controlled Breach Alvar facade.

local ChaosNpcId = 1092
local FriendTopicId = 1793
local ChaosRiddleTopicId = 1790
local ChaosCaptureTopicId = 1792
local ChaosTalkTopicId = 1794
local FriendNpcs = {
    {NpcId = 772, ActorId = 77, Name = "Anya Charo"},
    {NpcId = 773, ActorId = 78, Name = "Wan Ruchos"},
    {NpcId = 774, ActorId = 79, Name = "Noah Charo"},
    {NpcId = 775, ActorId = 80, Name = "Chan Os Wy"},
}
local FriendHints = {
    "This place is a madhouse. The thing we are looking for, the Runaway Chaos, is not a living being. Think of a ghost or spirit of some sort.",
    "This place reminds me of Alvar, but there are no elves here. The lights in the houses turn on and off even though nobody is here. We should look for Runaway Chaos in one of the buildings.",
    "I found part of a diary. It says everything here reflects things that happened somewhere, somewhen. None of it is real except the Personalities. The last pages mention riddles.",
    "I found the Runaway Chaos, or maybe it found me. It spoke calmly and said it would ask five riddles. Answer them and maybe we can be freed.",
}
local ChaosAppearances = {
    {Name = "Anya Charo", Picture = 354, Profession = 24},
    {Name = "Wan Ruchos", Picture = 358, Profession = 33},
    {Name = "Noah Charo", Picture = 66, Profession = 77},
    {Name = "Chan Os Wy", Picture = 167, Profession = 42},
    {Name = "R.C. Wosch", Picture = 257, Profession = 65},
    {Name = "Runaway Chaos", Picture = 273, Profession = 0},
}
local ChaosRiddles = {
    {
        Text = "You see it about in field and town,\nIt cannot get up,\nBut will often fall down.",
        Answer = "rain",
    },
    {
        Text = "The strongest chains will not bind it,\nditch and rampart will not slow it down.\nA thousand soldiers cannot beat it,\nit can knock down trees with a single push.",
        Answer = "wind",
    },
    {
        Text = "An untiring servant it is,\ncarrying loads across muddy earth.\nBut one thing that cannot be forced,\nis a return to the place of its birth.",
        Answer = "river",
    },
    {
        Text = "With sharp edged wit,\nAnd pointed poise,\nIt can settle disputes,\nWithout a noise.",
        Answer = "sword",
    },
    {
        Text = "It is too much for one.\nTwo it is meant for.\nBut it no longer exists,\nWhen the two become more.",
        Answer = "secret",
    },
    {
        Text = "This old one runs forever,\nBut never moves at all.\nHe has not lungs, nor throat,\nStill, a mighty roaring call.",
        Answer = "waterfall",
    },
    {
        Text = "It can move over water,\nBut cannot fly.\nIt can move under water,\nBut stay quite dry.",
        Answer = "shadow",
    },
    {
        Text = "It doesn't live with in a house,\nNor does it live without.\nMost will use it when they come in,\nAnd again when they go out.",
        Answer = "door",
    },
    {
        Text = "A shimmering field that reaches far.\nYet it has no tracks,\nAnd is crossed without paths.",
        Answer = "ocean",
    },
    {
        Text = "This engulfing thing,\nis strange indeed.\nThe greater it grows,\nthe less you see.",
        Answer = "darkness",
    },
    {
        Text = "When it comes in,\nFrom sea to shore,\nTwenty paces you'll see,\nNo less, no more.",
        Answer = "fog",
    },
}
local ChaosRiddleStarts = {
    "Ah, I do love me some riddles. Tell me what this is:",
    "I remember one from my childhood:",
    "Sometimes you can find riddles in random books. Delightfully unexpected. Like this one:",
    "This one was mumbled in a tavern by a drooling drunk. His last words, actually:",
}
local ChaosRefuses = {
    "Don't waste my time!",
    "Never heard of it.",
    "What is this? A new shop?",
}

local function SetMonsterFamilyRelation(leftIds, rightIds, relation)
    for _, leftId in ipairs(leftIds) do
        for _, rightId in ipairs(rightIds) do
            evt.SetMonsterRelation(leftId, rightId, relation)
        end
    end
end

local function ConfigureChaosNpc()
    local answered = evt.GetGlobalVar("MMerge.CrossContinents.RiddlesAnswered", 0)
    local appearance = ChaosAppearances[answered + 1] or ChaosAppearances[#ChaosAppearances]

    evt.SetNPCName(ChaosNpcId, appearance.Name)
    evt.SetNPCPicture(ChaosNpcId, appearance.Picture)
    evt.SetNPCProfession(ChaosNpcId, appearance.Profession)

    if evt.GetGlobalVar("MMerge.CrossContinents.CaughtChaos") ~= 0
        or evt.GetGlobalVar("MMerge.CrossContinents.CoughtChaos") ~= 0 then
        evt.SetNPCTopic(ChaosNpcId, 0, 0)
        evt.SetNPCTopic(ChaosNpcId, 1, 0)
        return
    end

    if evt.GetGlobalVar("MMerge.CrossContinents.GotFQHint2") ~= 0 then
        if evt.GetGlobalVar("MMerge.CrossContinents.ChaosReadyToFollow") ~= 0 then
            evt.SetNPCTopic(ChaosNpcId, 0, ChaosCaptureTopicId)
        else
            evt.SetNPCTopic(ChaosNpcId, 0, ChaosTalkTopicId)
        end
    else
        evt.SetNPCTopic(ChaosNpcId, 0, 0)
    end

    if evt.GetGlobalVar("MMerge.CrossContinents.GotFQHint3") ~= 0 and answered < 5 then
        evt.SetNPCTopic(ChaosNpcId, 1, ChaosRiddleTopicId)
    else
        evt.SetNPCTopic(ChaosNpcId, 1, 0)
    end
end

local function IsFriendNpc(npcId)
    for _, friend in ipairs(FriendNpcs) do
        if friend.NpcId == npcId then
            return true
        end
    end

    return false
end

local function FriendActorId(npcId)
    for _, friend in ipairs(FriendNpcs) do
        if friend.NpcId == npcId then
            return friend.ActorId
        end
    end

    return 0
end

local function ConfigureFriendNpcs()
    if evt.GetGlobalVar("MMerge.CrossContinents.QuestFinished") ~= 0 then
        for _, friend in ipairs(FriendNpcs) do
            evt.SetMonsterBit(friend.ActorId, ActorAttribute.Invisible, 1)
        end
        return
    end

    for _, friend in ipairs(FriendNpcs) do
        evt.SetMonsterBit(friend.ActorId, ActorAttribute.Invisible, 0)
        evt.SetNPCName(friend.NpcId, friend.Name)
        evt.SetNPCTopic(friend.NpcId, 0, FriendTopicId)
        evt.SetNPCTopic(friend.NpcId, 1, 0)
        evt.SetNPCTopic(friend.NpcId, 2, 0)
        evt.SetNPCTopic(friend.NpcId, 3, 0)
    end
end

RegisterEvent(101, "Operate Time_1", function()
    RegisterOutdoorModelMechanism(101, "Time_1", 0, 0, -10, 1000, true, false)
    SetOutdoorModelMechanismState(101, DoorAction.Trigger)
end, "Operate")

RegisterEvent(102, "Operate Time_2", function()
    RegisterOutdoorModelMechanism(102, "Time_2", 0, 0, -10, 1000, true, false)
    SetOutdoorModelMechanismState(102, DoorAction.Trigger)
end, "Operate")

RegisterEvent(103, "Operate Time_3", function()
    RegisterOutdoorModelMechanism(103, "Time_3", 0, 0, -10, 1000, true, false)
    SetOutdoorModelMechanismState(103, DoorAction.Trigger)
end, "Operate")

RegisterEvent(104, "Operate Elev_1_Door", function()
    local _, _, partyZ = evt.GetPartyPosition()

    if evt.GetGlobalVar("MMerge.CrossContinents.BrFirstFloor") ~= 0 then
        RegisterOutdoorModelMechanism(104, "Elev_1_Door", 0, 0, 250, 1000, true, false)
        SetOutdoorModelMechanismState(104, DoorAction.Trigger)
    elseif partyZ >= 1980 then
        evt.SummonMonsters(3, 2, 3, 1343, 763, 1992, 13, 0)
        evt.SummonMonsters(3, 2, 2, -1397, -731, 2071, 13, 0)
        evt.SummonMonsters(3, 2, 2, -1390, 677, 2069, 13, 0)
        evt.SummonMonsters(3, 2, 2, 1354, -646, 2487, 13, 0)
        evt.SetGlobalVar("MMerge.CrossContinents.BrFirstFloor", 1)
        RegisterOutdoorModelMechanism(104, "Elev_1_Door", 0, 0, 250, 1000, true, false)
        SetOutdoorModelMechanismState(104, DoorAction.Trigger)
    else
        evt.StatusText("Door won't budge!")
        evt.FaceAnimation(FaceAnimation.DoorLocked)
    end
end, "Operate")

RegisterEvent(105, "Operate Elev_2_Door", function()
    local _, _, partyZ = evt.GetPartyPosition()

    if evt.GetGlobalVar("MMerge.CrossContinents.BrFirstFloor") ~= 0 then
        RegisterOutdoorModelMechanism(105, "Elev_2_Door", 0, 0, 250, 1000, true, false)
        SetOutdoorModelMechanismState(105, DoorAction.Trigger)
    elseif partyZ >= 1980 then
        evt.SummonMonsters(3, 2, 3, 1343, 763, 1992, 13, 0)
        evt.SummonMonsters(3, 2, 2, -1397, -731, 2071, 13, 0)
        evt.SummonMonsters(3, 2, 2, -1390, 677, 2069, 13, 0)
        evt.SummonMonsters(3, 2, 2, 1354, -646, 2487, 13, 0)
        evt.SetGlobalVar("MMerge.CrossContinents.BrFirstFloor", 1)
        RegisterOutdoorModelMechanism(105, "Elev_2_Door", 0, 0, 250, 1000, true, false)
        SetOutdoorModelMechanismState(105, DoorAction.Trigger)
    else
        evt.StatusText("Door won't budge!")
        evt.FaceAnimation(FaceAnimation.DoorLocked)
    end
end, "Operate")

RegisterEvent(106, "Operate Elev_3_Door", function()
    local _, _, partyZ = evt.GetPartyPosition()

    if evt.GetGlobalVar("MMerge.CrossContinents.BrFirstFloor") ~= 0 then
        RegisterOutdoorModelMechanism(106, "Elev_3_Door", 0, 0, 250, 1000, true, false)
        SetOutdoorModelMechanismState(106, DoorAction.Trigger)
    elseif partyZ >= 1980 then
        evt.SummonMonsters(3, 2, 3, 1343, 763, 1992, 13, 0)
        evt.SummonMonsters(3, 2, 2, -1397, -731, 2071, 13, 0)
        evt.SummonMonsters(3, 2, 2, -1390, 677, 2069, 13, 0)
        evt.SummonMonsters(3, 2, 2, 1354, -646, 2487, 13, 0)
        evt.SetGlobalVar("MMerge.CrossContinents.BrFirstFloor", 1)
        RegisterOutdoorModelMechanism(106, "Elev_3_Door", 0, 0, 250, 1000, true, false)
        SetOutdoorModelMechanismState(106, DoorAction.Trigger)
    else
        evt.StatusText("Door won't budge!")
        evt.FaceAnimation(FaceAnimation.DoorLocked)
    end
end, "Operate")

RegisterEvent(107, "Operate SubTower_Door_1", function()
    local _, _, partyZ = evt.GetPartyPosition()

    if evt.GetGlobalVar("MMerge.CrossContinents.BrSecFloor") ~= 0 then
        RegisterOutdoorModelMechanism(107, "SubTower_Door_1", 0, 0, 250, 1000, true, false)
        SetOutdoorModelMechanismState(107, DoorAction.Trigger)
    elseif partyZ >= 1990 then
        evt.SummonMonsters(3, 2, 3, 75, -1077, 3126, 13, 0)
        evt.SummonMonsters(3, 2, 3, 1067, -100, 3127, 13, 0)
        evt.SummonMonsters(3, 2, 3, -1025, 647, 3127, 13, 0)
        evt.SummonMonsters(3, 2, 3, 401, 1156, 3127, 13, 0)
        evt.SetGlobalVar("MMerge.CrossContinents.BrSecFloor", 1)
        RegisterOutdoorModelMechanism(107, "SubTower_Door_1", 0, 0, 250, 1000, true, false)
        SetOutdoorModelMechanismState(107, DoorAction.Trigger)
    else
        evt.StatusText("Door won't budge!")
        evt.FaceAnimation(FaceAnimation.DoorLocked)
    end
end, "Operate")

RegisterEvent(108, "Operate SubTower_Door_2", function()
    local _, _, partyZ = evt.GetPartyPosition()

    if evt.GetGlobalVar("MMerge.CrossContinents.BrSecFloor") ~= 0 then
        RegisterOutdoorModelMechanism(108, "SubTower_Door_2", 0, 0, 250, 1000, true, false)
        SetOutdoorModelMechanismState(108, DoorAction.Trigger)
    elseif partyZ >= 1990 then
        evt.SummonMonsters(3, 2, 3, 75, -1077, 3126, 13, 0)
        evt.SummonMonsters(3, 2, 3, 1067, -100, 3127, 13, 0)
        evt.SummonMonsters(3, 2, 3, -1025, 647, 3127, 13, 0)
        evt.SummonMonsters(3, 2, 3, 401, 1156, 3127, 13, 0)
        evt.SetGlobalVar("MMerge.CrossContinents.BrSecFloor", 1)
        RegisterOutdoorModelMechanism(108, "SubTower_Door_2", 0, 0, 250, 1000, true, false)
        SetOutdoorModelMechanismState(108, DoorAction.Trigger)
    else
        evt.StatusText("Door won't budge!")
        evt.FaceAnimation(FaceAnimation.DoorLocked)
    end
end, "Operate")

RegisterEvent(109, "Operate SubTower_Door_3", function()
    local _, _, partyZ = evt.GetPartyPosition()

    if evt.GetGlobalVar("MMerge.CrossContinents.BrSecFloor") ~= 0 then
        RegisterOutdoorModelMechanism(109, "SubTower_Door_3", 0, 0, 250, 1000, true, false)
        SetOutdoorModelMechanismState(109, DoorAction.Trigger)
    elseif partyZ >= 1990 then
        evt.SummonMonsters(3, 2, 3, 75, -1077, 3126, 13, 0)
        evt.SummonMonsters(3, 2, 3, 1067, -100, 3127, 13, 0)
        evt.SummonMonsters(3, 2, 3, -1025, 647, 3127, 13, 0)
        evt.SummonMonsters(3, 2, 3, 401, 1156, 3127, 13, 0)
        evt.SetGlobalVar("MMerge.CrossContinents.BrSecFloor", 1)
        RegisterOutdoorModelMechanism(109, "SubTower_Door_3", 0, 0, 250, 1000, true, false)
        SetOutdoorModelMechanismState(109, DoorAction.Trigger)
    else
        evt.StatusText("Door won't budge!")
        evt.FaceAnimation(FaceAnimation.DoorLocked)
    end
end, "Operate")

RegisterEvent(110, "Operate LibDoor_1", function()
    RegisterOutdoorModelMechanism(110, "LibDoor_1", 0, 0, 300, 1000, true, false)
    SetOutdoorModelMechanismState(110, DoorAction.Trigger)
end, "Operate")

RegisterEvent(111, "Operate LibDoor_2", function()
    RegisterOutdoorModelMechanism(111, "LibDoor_2", 0, 0, 300, 1000, true, false)
    SetOutdoorModelMechanismState(111, DoorAction.Trigger)
end, "Operate")

RegisterEvent(112, "Operate LibDoor_3", function()
    if evt.GetGlobalVar("MMerge.CrossContinents.BrThirdFloor") ~= 0 then
        RegisterOutdoorModelMechanism(112, "LibDoor_3", 0, 0, 300, 1000, true, false)
        SetOutdoorModelMechanismState(112, DoorAction.Trigger)
    else
        evt.StatusText("Door won't budge!")
        evt.FaceAnimation(FaceAnimation.DoorLocked)
    end
end, "Operate")

RegisterEvent(113, "Operate LibDoor_4", function()
    if evt.GetGlobalVar("MMerge.CrossContinents.BrThirdFloor") ~= 0 then
        RegisterOutdoorModelMechanism(113, "LibDoor_4", 0, 0, 300, 1000, true, false)
        SetOutdoorModelMechanismState(113, DoorAction.Trigger)
    else
        evt.StatusText("Door won't budge!")
        evt.FaceAnimation(FaceAnimation.DoorLocked)
    end
end, "Operate")

RegisterEvent(114, "Operate Mus_Door_1", function()
    if evt.GetGlobalVar("MMerge.CrossContinents.BrThirdFloor") ~= 0 then
        RegisterOutdoorModelMechanism(114, "Mus_Door_1", 0, 0, 300, 1000, true, false)
        SetOutdoorModelMechanismState(114, DoorAction.Trigger)
    else
        evt.StatusText("Door won't budge!")
        evt.FaceAnimation(FaceAnimation.DoorLocked)
    end
end, "Operate")

RegisterEvent(115, "Operate Mus_Door_2", function()
    RegisterOutdoorModelMechanism(115, "Mus_Door_2", 0, 0, 300, 1000, true, false)
    SetOutdoorModelMechanismState(115, DoorAction.Trigger)
end, "Operate")

RegisterEvent(116, "Operate Mus_Door_3", function()
    RegisterOutdoorModelMechanism(116, "Mus_Door_3", 0, 0, 300, 1000, true, false)
    SetOutdoorModelMechanismState(116, DoorAction.Trigger)
end, "Operate")

RegisterEvent(117, "Operate Mus_Door_4", function()
    RegisterOutdoorModelMechanism(117, "Mus_Door_4", 0, 0, 300, 1000, true, false)
    SetOutdoorModelMechanismState(117, DoorAction.Trigger)
end, "Operate")

RegisterEvent(118, "Operate RoomDoor_1", function()
    RegisterOutdoorModelMechanism(118, "RoomDoor_1", 0, 0, 200, 500, true, false)
    SetOutdoorModelMechanismState(118, DoorAction.Trigger)
end, "Operate")

RegisterEvent(119, "Operate RoomDoor_2", function()
    RegisterOutdoorModelMechanism(119, "RoomDoor_2", 0, 0, 200, 500, true, false)
    SetOutdoorModelMechanismState(119, DoorAction.Trigger)
end, "Operate")

RegisterEvent(120, "Operate RoomDoor_3", function()
    RegisterOutdoorModelMechanism(120, "RoomDoor_3", 0, 0, 200, 500, true, false)
    SetOutdoorModelMechanismState(120, DoorAction.Trigger)
end, "Operate")

RegisterEvent(121, "Operate RoomDoor_4", function()
    RegisterOutdoorModelMechanism(121, "RoomDoor_4", 0, 0, 200, 500, true, false)
    SetOutdoorModelMechanismState(121, DoorAction.Trigger)
end, "Operate")

RegisterEvent(122, "Operate RoomDoor_5", function()
    RegisterOutdoorModelMechanism(122, "RoomDoor_5", 0, 0, 200, 500, true, false)
    SetOutdoorModelMechanismState(122, DoorAction.Trigger)
end, "Operate")

RegisterEvent(123, "Operate RoomDoor_6", function()
    RegisterOutdoorModelMechanism(123, "RoomDoor_6", 0, 0, 200, 500, true, false)
    SetOutdoorModelMechanismState(123, DoorAction.Trigger)
end, "Operate")

RegisterEvent(124, "Operate RoomDoor_7", function()
    RegisterOutdoorModelMechanism(124, "RoomDoor_7", 0, 0, 200, 500, true, false)
    SetOutdoorModelMechanismState(124, DoorAction.Trigger)
end, "Operate")

RegisterEvent(125, "Operate RoomElev", function()
    RegisterOutdoorModelMechanism(125, "RoomElev", 0, 0, 455, 2000, true, false)
    SetOutdoorModelMechanismState(125, DoorAction.Trigger)
end, "Operate")

RegisterEvent(126, "Operate Elev_1_Button", function()
    local partyX, partyY, partyZ = evt.GetPartyPosition()

    if evt.GetGlobalVar("MMerge.CrossContinents.BrThirdFloor") ~= 0 then
        RegisterOutdoorModelMechanism(126, "Elev_1_Button", 0, 0, 5, 250, true, false)
        SetOutdoorModelMechanismState(126, DoorAction.Trigger)
    elseif partyZ >= 3120 then
        evt.SummonMonsters(3, 3, 1, 14, 86, 5184, 13, 0)
        evt.SummonMonsters(3, 2, 4, 14, 86, 5184, 13, 0)
        evt.SetGlobalVar("MMerge.CrossContinents.BrThirdFloor", 1)
        RegisterOutdoorModelMechanism(126, "Elev_1_Button", 0, 0, 5, 250, true, false)
        SetOutdoorModelMechanismState(126, DoorAction.Trigger)
    else
        evt.StatusText("Button won't budge.")
        evt.FaceAnimation(FaceAnimation.DoorLocked)
        return
    end

    if math.sqrt((10 - partyX) * (10 - partyX) + (-2334 - partyY) * (-2334 - partyY)) < 100 and partyZ < 4410 then
        evt._SpecialJump(0, math.floor(math.sqrt(2 * 800 * (4410 - partyZ))))
    end
end, "Operate")

RegisterEvent(127, "Operate Elev_2_Button", function()
    local partyX, partyY, partyZ = evt.GetPartyPosition()

    if evt.GetGlobalVar("MMerge.CrossContinents.BrThirdFloor") ~= 0 then
        RegisterOutdoorModelMechanism(127, "Elev_2_Button", 0, 0, 5, 250, true, false)
        SetOutdoorModelMechanismState(127, DoorAction.Trigger)
    elseif partyZ >= 3120 then
        evt.SummonMonsters(3, 3, 1, 14, 86, 5184, 13, 0)
        evt.SummonMonsters(3, 2, 4, 14, 86, 5184, 13, 0)
        evt.SetGlobalVar("MMerge.CrossContinents.BrThirdFloor", 1)
        RegisterOutdoorModelMechanism(127, "Elev_2_Button", 0, 0, 5, 250, true, false)
        SetOutdoorModelMechanismState(127, DoorAction.Trigger)
    else
        evt.StatusText("Button won't budge.")
        evt.FaceAnimation(FaceAnimation.DoorLocked)
        return
    end

    if math.sqrt((1971 - partyX) * (1971 - partyX) + (1139 - partyY) * (1139 - partyY)) < 100 and partyZ < 4410 then
        evt._SpecialJump(0, math.floor(math.sqrt(2 * 800 * (4410 - partyZ))))
    end
end, "Operate")

RegisterEvent(128, "Operate Elev_3_Button", function()
    local partyX, partyY, partyZ = evt.GetPartyPosition()

    if evt.GetGlobalVar("MMerge.CrossContinents.BrThirdFloor") ~= 0 then
        RegisterOutdoorModelMechanism(128, "Elev_3_Button", 0, 0, 5, 250, true, false)
        SetOutdoorModelMechanismState(128, DoorAction.Trigger)
    elseif partyZ >= 3120 then
        evt.SummonMonsters(3, 3, 1, 14, 86, 5184, 13, 0)
        evt.SummonMonsters(3, 2, 4, 14, 86, 5184, 13, 0)
        evt.SetGlobalVar("MMerge.CrossContinents.BrThirdFloor", 1)
        RegisterOutdoorModelMechanism(128, "Elev_3_Button", 0, 0, 5, 250, true, false)
        SetOutdoorModelMechanismState(128, DoorAction.Trigger)
    else
        evt.StatusText("Button won't budge.")
        evt.FaceAnimation(FaceAnimation.DoorLocked)
        return
    end

    if math.sqrt((-1962 - partyX) * (-1962 - partyX) + (1137 - partyY) * (1137 - partyY)) < 100
        and partyZ < 4410 then
        evt._SpecialJump(0, math.floor(math.sqrt(2 * 800 * (4410 - partyZ))))
    end
end, "Operate")

RegisterEvent(5, "Closed Breach House", function()
    local partyX, partyY = evt.GetPartyPosition()
    local keyHour = math.floor(CurrentGameMinutes() / 60)
    local key = tostring(math.ceil(partyX / 500))
        .. ":"
        .. tostring(math.ceil(partyY / 500))
        .. ":"
        .. tostring(keyHour)

    if evt.GetGlobalVar("MMerge.CrossContinents.CaughtChaos") ~= 0
        or evt.GetGlobalVar("MMerge.CrossContinents.CoughtChaos") ~= 0
        or evt.GetMapVar("ClosedHouse." .. key, 0) ~= 0 then
        evt.FaceAnimation(FaceAnimation.DoorLocked)
        return
    end

    evt.SetMapVar("ClosedHouse." .. key, 1)
    evt.SetGlobalVar("MMerge.CrossContinents.GotFQHints", math.max(evt.GetGlobalVar("MMerge.CrossContinents.GotFQHints", 0), 3))
    evt.SetGlobalVar("MMerge.CrossContinents.GotFQHint1", 1)
    evt.SetGlobalVar("MMerge.CrossContinents.GotFQHint2", 1)
    evt.SetGlobalVar("MMerge.CrossContinents.GotFQHint3", 1)
    evt.SetGlobalVar("MMerge.CrossContinents.RiddlesAnswered", 5)
    evt.SetGlobalVar("MMerge.CrossContinents.ChaosReadyToFollow", 1)
    evt.MoveNPC(ChaosNpcId, 712)
    ConfigureChaosNpc()
    evt.EnterHouse(712)
end, "Closed House")

RegisterEvent(7, "Troll's Inn", function()
    evt.EnterHouse(231)
end, "Troll's Inn")

RegisterEvent(15, "Breach Jumper", function()
    local encodedHorizontal = math.random(128, 256) * 65536 + math.random(0, 2047)
    evt._SpecialJump(encodedHorizontal, 1800)
end)

RegisterEvent(16, "Breach Jumper", function()
    local encodedHorizontal = math.random(128, 256) * 65536 + math.random(0, 2047)
    evt._SpecialJump(encodedHorizontal, 1800)
end)

RegisterEvent(30, "Special Trash Heap", function()
    evt.GiveItem(315)
end, "Search")

RegisterEvent(53, "Enter Breach Basement", function()
    evt.SetGlobalVar("MMerge.CrossContinents.EnteredBasement", 0)
    evt.MoveToMap(0, 0, 0, 0, 0, 0, 710, 3, "BrBase.blv")
end, "Enter Breach Basement")

RegisterEvent(54, "Enter Breach Basement", function()
    evt.MoveToMap(0, 0, 0, 0, 0, 0, 711, 2, "BrBase.blv")
end, "Enter Breach Basement")

RegisterEvent(60, "Breach Swordsman Alarm", function()
    if evt.GetMapVar("SwordsAggro", 0) ~= 0 then
        return
    end

    evt.SimpleMessage("Someone shouts: \"Prince Nicolai has been kidnapped!\"")
    evt.SetMonGroupBit(15, MonsterBits.Hostile, 1)
    evt.SetMapVar("SwordsAggro", 1)
end)

RegisterEvent(81, "Return To The Breach", function()
    if evt.GetGlobalVar("MMerge.CrossContinents.CaughtChaos") == 0
        and evt.GetGlobalVar("MMerge.CrossContinents.CoughtChaos") == 0 then
        return
    end

    if HasFollowerNpc(ChaosNpcId) then
        RemoveFollowerNpc(ChaosNpcId)
    end

    AddValue(Experience, 100000)
    evt.MoveToMap(-841, -475, 4501, 176, 0, 0, 0, 0, "Breach.odm")
end, "Return To The Breach")

RegisterEvent(82, "Breach Library Cache", function()
    local partyX, partyY, partyZ = evt.GetPartyPosition()
    local key = tostring(math.ceil(partyX / 200))
        .. ":"
        .. tostring(math.ceil(partyY / 200))
        .. ":"
        .. tostring(math.ceil(partyZ / 100))

    if evt.GetMapVar("LibraryCache." .. key, 0) ~= 0 then
        return
    end

    evt.SetMapVar("LibraryCache." .. key, 1)
    evt.GiveItem(math.random(3, 6), math.random(16, 17), 0)
end, "Search")

RegisterEvent(ChaosRiddleTopicId, "Runaway Chaos Riddle", function(continueStep)
    if evt.GetGlobalVar("MMerge.CrossContinents.GotFQHint3") == 0 then
        evt.SimpleMessage("The answer is still hidden in this place.")
        return
    end

    local answered = evt.GetGlobalVar("MMerge.CrossContinents.RiddlesAnswered", 0)

    if answered >= 5 then
        evt.SetGlobalVar("MMerge.CrossContinents.ChaosReadyToFollow", 1)
        ConfigureChaosNpc()
        evt.SimpleMessage("I don't know anymore.")
        return
    end

    local currentRiddle = evt.GetGlobalVar("MMerge.CrossContinents.CurrentRiddle", 0)

    if continueStep == 1 then
        if currentRiddle ~= 0 then
            evt.SetGlobalVar("MMerge.CrossContinents.RiddleUsed." .. tostring(currentRiddle), 1)
        end

        evt.SetGlobalVar("MMerge.CrossContinents.CurrentRiddle", 0)
        answered = answered + 1
        evt.SetGlobalVar("MMerge.CrossContinents.RiddlesAnswered", answered)
        evt.SimpleMessage("Correct!")

        if answered >= 5 then
            evt.SetGlobalVar("MMerge.CrossContinents.ChaosReadyToFollow", 0)
            evt.SetNPCTopic(ChaosNpcId, 0, ChaosTalkTopicId)
            evt.SetNPCTopic(ChaosNpcId, 1, 0)
        else
            ConfigureChaosNpc()
        end

        return
    elseif continueStep == 2 then
        evt.SetGlobalVar("MMerge.CrossContinents.CurrentRiddle", 0)
        evt.SimpleMessage("Not quite, friend, not quite.")
        return
    end

    local riddleIndex = 0

    for index = 1, #ChaosRiddles do
        if evt.GetGlobalVar("MMerge.CrossContinents.RiddleUsed." .. tostring(index), 0) == 0 then
            riddleIndex = index
            break
        end
    end

    if riddleIndex == 0 then
        evt.SimpleMessage("I don't know anymore.")
        return
    end

    local riddle = ChaosRiddles[riddleIndex]
    local start = ChaosRiddleStarts[(answered % #ChaosRiddleStarts) + 1]
    evt.SetGlobalVar("MMerge.CrossContinents.CurrentRiddle", riddleIndex)
    evt.AskQuestion(ChaosRiddleTopicId, 2, 0, 1, start .. "\n\n" .. riddle.Text, {riddle.Answer})
end)

RegisterEvent(ChaosCaptureTopicId, "Runaway Chaos Capture", function()
    if evt.GetGlobalVar("MMerge.CrossContinents.GotFQHint3") == 0
        or evt.GetGlobalVar("MMerge.CrossContinents.RiddlesAnswered", 0) < 5 then
        evt.SimpleMessage("Not yet.")
        return
    end

    evt.SetGlobalVar("MMerge.CrossContinents.CaughtChaos", 1)
    evt.SetGlobalVar("MMerge.CrossContinents.CoughtChaos", 1)
    evt.SetGlobalVar("MMerge.CrossContinents.ChaosReadyToFollow", 1)
    evt.AddFollowerNpc(ChaosNpcId, 0, 0)
    evt.MoveNPC(ChaosNpcId, 0)
    ConfigureChaosNpc()
    evt.SimpleMessage("Runaway Chaos follows you.")
end)

RegisterEvent(ChaosTalkTopicId, "Runaway Chaos", function()
    if evt.GetGlobalVar("MMerge.CrossContinents.GotFQHint3") ~= 0
        and evt.GetGlobalVar("MMerge.CrossContinents.RiddlesAnswered", 0) >= 5 then
        evt.SetGlobalVar("MMerge.CrossContinents.ChaosReadyToFollow", 1)
        evt.SetNPCName(ChaosNpcId, "Runaway Chaos")
        evt.SetNPCTopic(ChaosNpcId, 0, ChaosCaptureTopicId)
        evt.SetNPCTopic(ChaosNpcId, 1, 0)
        evt.SimpleMessage("Hmm, yes, that will do. It was fun picking your brain, very enjoyable indeed. A good time begs a good reward. Make a wish and I shall make it come true.")
        return
    end

    local answered = evt.GetGlobalVar("MMerge.CrossContinents.RiddlesAnswered", 0)
    evt.SimpleMessage(ChaosRefuses[(answered % #ChaosRefuses) + 1])
end)

RegisterEvent(FriendTopicId, "Breach Friend Hint", function()
    local npcId = evt.GetMapVar("CurrentFriendNpc", 0)

    if not IsFriendNpc(npcId) then
        evt.SimpleMessage("We need to find the others before we can make sense of this place.")
        return
    end

    local hintByNpcKey = "MMerge.CrossContinents.HintByNPC." .. tostring(npcId)
    local hintId = evt.GetGlobalVar(hintByNpcKey)

    if hintId == 0 then
        hintId = evt.GetGlobalVar("MMerge.CrossContinents.GotFQHints", 0) + 1

        if hintId > #FriendHints then
            hintId = #FriendHints
        end

        evt.SetGlobalVar("MMerge.CrossContinents.GotFQHints", hintId)
        evt.SetGlobalVar("MMerge.CrossContinents.GotFQHint" .. tostring(hintId), 1)
        evt.SetGlobalVar(hintByNpcKey, hintId)
    end

    evt.SimpleMessage(FriendHints[hintId] or FriendHints[#FriendHints])

    local actorId = FriendActorId(npcId)

    if actorId ~= 0 then
        evt.SetMonsterBit(actorId, ActorAttribute.Invisible, 1)
    end

    ConfigureChaosNpc()
end)

RegisterEvent(301, "Breach Chest Trap", function()
    evt.FaceAnimation(FaceAnimation.DoorLocked)
end)

RegisterEvent(302, "Breach Chest Trap", function()
    evt.FaceAnimation(FaceAnimation.DoorLocked)
end)

RegisterEvent(303, "Breach Chest Trap", function()
    evt.FaceAnimation(FaceAnimation.DoorLocked)
end)

RegisterEvent(304, "Breach Chest Trap", function()
    evt.FaceAnimation(FaceAnimation.DoorLocked)
end)

RegisterEvent(305, "Breach Chest Trap", function()
    evt.FaceAnimation(FaceAnimation.DoorLocked)
end)

RegisterEvent(306, "Breach Chest Trap", function()
    evt.FaceAnimation(FaceAnimation.DoorLocked)
end)

RegisterEvent(307, "Breach Chest Trap", function()
    evt.FaceAnimation(FaceAnimation.DoorLocked)
end)

RegisterEvent(308, "Breach Chest Trap", function()
    evt.FaceAnimation(FaceAnimation.DoorLocked)
end)

RegisterEvent(309, "Breach Chest Trap", function()
    evt.FaceAnimation(FaceAnimation.DoorLocked)
end)

RegisterEvent(310, "Breach Chest Trap", function()
    evt.FaceAnimation(FaceAnimation.DoorLocked)
end)

RegisterEvent(311, "Breach Chest Trap", function()
    evt.FaceAnimation(FaceAnimation.DoorLocked)
end)

RegisterEvent(312, "Breach Chest Trap", function()
    evt.FaceAnimation(FaceAnimation.DoorLocked)
end)

RegisterEvent(313, "Breach Chest Trap", function()
    evt.FaceAnimation(FaceAnimation.DoorLocked)
end)

RegisterEvent(314, "Breach Chest Trap", function()
    evt.FaceAnimation(FaceAnimation.DoorLocked)
end)

RegisterEvent(315, "Breach Chest Trap", function()
    evt.FaceAnimation(FaceAnimation.DoorLocked)
end)

RegisterMapTimerEvent(66004, 60, function()
    local partyX, partyY, partyZ = evt.GetPartyPosition()

    if IsFlying() then
        local sourceX = partyX + math.random(-500, 500)
        local sourceY = partyY + math.random(-500, 500)
        local sourceZ = partyZ + math.random(-200, 200)
        evt.CastSpell(18, 3, 7, sourceX, sourceY, sourceZ, partyX, partyY, partyZ)
        evt.SummonMonsters(3, 2, 1, sourceX, sourceY, sourceZ, 13, 0)
    end

    if evt.GetGlobalVar("MMerge.CrossContinents.EnteredBreach") == 0
        and math.sqrt((332 - partyX) * (332 - partyX) + (-268 - partyY) * (-268 - partyY)) < 2500 then
        local xSign = math.random(0, 1) == 0 and -1 or 1
        local ySign = math.random(0, 1) == 0 and -1 or 1
        local newX = math.random(3000, 4000) * xSign
        local newY = math.random(3000, 4000) * ySign
        evt.MoveToMap(newX, newY, partyZ, 0, 0, 0, 0, 0, "BrAlvar.odm")
    end
end, "MMMerge BrAlvar control timer")

RegisterMapOnLoadEvent(66002, "MMMerge BrAlvar state", function()
    RegisterOutdoorModelMechanism(101, "Time_1", 0, 0, -10, 1000, true, false)
    RegisterOutdoorModelMechanism(102, "Time_2", 0, 0, -10, 1000, true, false)
    RegisterOutdoorModelMechanism(103, "Time_3", 0, 0, -10, 1000, true, false)
    RegisterOutdoorModelMechanism(104, "Elev_1_Door", 0, 0, 250, 1000, true, false)
    RegisterOutdoorModelMechanism(105, "Elev_2_Door", 0, 0, 250, 1000, true, false)
    RegisterOutdoorModelMechanism(106, "Elev_3_Door", 0, 0, 250, 1000, true, false)
    RegisterOutdoorModelMechanism(107, "SubTower_Door_1", 0, 0, 250, 1000, true, false)
    RegisterOutdoorModelMechanism(108, "SubTower_Door_2", 0, 0, 250, 1000, true, false)
    RegisterOutdoorModelMechanism(109, "SubTower_Door_3", 0, 0, 250, 1000, true, false)
    RegisterOutdoorModelMechanism(110, "LibDoor_1", 0, 0, 300, 1000, true, false)
    RegisterOutdoorModelMechanism(111, "LibDoor_2", 0, 0, 300, 1000, true, false)
    RegisterOutdoorModelMechanism(112, "LibDoor_3", 0, 0, 300, 1000, true, false)
    RegisterOutdoorModelMechanism(113, "LibDoor_4", 0, 0, 300, 1000, true, false)
    RegisterOutdoorModelMechanism(114, "Mus_Door_1", 0, 0, 300, 1000, true, false)
    RegisterOutdoorModelMechanism(115, "Mus_Door_2", 0, 0, 300, 1000, true, false)
    RegisterOutdoorModelMechanism(116, "Mus_Door_3", 0, 0, 300, 1000, true, false)
    RegisterOutdoorModelMechanism(117, "Mus_Door_4", 0, 0, 300, 1000, true, false)
    RegisterOutdoorModelMechanism(118, "RoomDoor_1", 0, 0, 200, 500, true, false)
    RegisterOutdoorModelMechanism(119, "RoomDoor_2", 0, 0, 200, 500, true, false)
    RegisterOutdoorModelMechanism(120, "RoomDoor_3", 0, 0, 200, 500, true, false)
    RegisterOutdoorModelMechanism(121, "RoomDoor_4", 0, 0, 200, 500, true, false)
    RegisterOutdoorModelMechanism(122, "RoomDoor_5", 0, 0, 200, 500, true, false)
    RegisterOutdoorModelMechanism(123, "RoomDoor_6", 0, 0, 200, 500, true, false)
    RegisterOutdoorModelMechanism(124, "RoomDoor_7", 0, 0, 200, 500, true, false)
    RegisterOutdoorModelMechanism(125, "RoomElev", 0, 0, 455, 2000, true, false)
    RegisterOutdoorModelMechanism(126, "Elev_1_Button", 0, 0, 5, 250, true, false)
    RegisterOutdoorModelMechanism(127, "Elev_2_Button", 0, 0, 5, 250, true, false)
    RegisterOutdoorModelMechanism(128, "Elev_3_Button", 0, 0, 5, 250, true, false)

    -- Local monster relations mirror the controlled-chaos faction setup for this custom map.
    -- MMMerge edits Hostile.txt kind ids here; OpenYAMM's Lua API uses actual monster ids.
    local fireElementals = {73, 74, 75}
    local trolls = {448, 449, 450}
    local archers = {475, 476, 477}
    local cacti = {649, 650, 651}
    local swordChampions = {259, 260, 261}
    local archmages = {292, 293, 294}
    local goldGolems = {277, 278, 279}
    local party = {0}

    SetMonsterFamilyRelation(fireElementals, trolls, 4)
    SetMonsterFamilyRelation(trolls, fireElementals, 4)
    SetMonsterFamilyRelation(trolls, archers, 4)
    SetMonsterFamilyRelation(archers, trolls, 4)
    SetMonsterFamilyRelation(cacti, archers, 4)
    SetMonsterFamilyRelation(archers, cacti, 4)
    SetMonsterFamilyRelation(cacti, swordChampions, 4)
    SetMonsterFamilyRelation(swordChampions, cacti, 4)
    SetMonsterFamilyRelation(fireElementals, swordChampions, 4)
    SetMonsterFamilyRelation(swordChampions, fireElementals, 4)
    SetMonsterFamilyRelation(fireElementals, archers, 4)
    SetMonsterFamilyRelation(archers, fireElementals, 4)
    SetMonsterFamilyRelation(cacti, archmages, 4)
    SetMonsterFamilyRelation(archmages, cacti, 1)
    SetMonsterFamilyRelation(cacti, goldGolems, 4)
    SetMonsterFamilyRelation(goldGolems, cacti, 4)
    SetMonsterFamilyRelation(fireElementals, archmages, 4)
    SetMonsterFamilyRelation(archmages, fireElementals, 1)
    SetMonsterFamilyRelation(fireElementals, goldGolems, 4)
    SetMonsterFamilyRelation(goldGolems, fireElementals, 4)
    SetMonsterFamilyRelation(archers, party, 0)
    SetMonsterFamilyRelation(fireElementals, party, 4)
    SetMonsterFamilyRelation(party, fireElementals, 4)
    SetMonsterFamilyRelation(fireElementals, fireElementals, 0)
    SetMonsterFamilyRelation(swordChampions, trolls, 4)
    SetMonsterFamilyRelation(trolls, swordChampions, 4)

    if evt.GetGlobalVar("MMerge.CrossContinents.QuestFinished") == 0 then
        SetQBit(QBit(1715)) -- Find entrance to the main Breach structure.
    end

    if evt.GetGlobalVar("MMerge.CrossContinents.BreachSplit") == 0 then
        -- We keep the full party, but still mark the quest beat MMMerge uses for the Breach sequence.
        evt.StatusText("Your friends have disappeared!")
        SetQBit(QBit(1714)) -- Find your friends.
        evt.SetGlobalVar("MMerge.CrossContinents.BreachSplit", 1)
    end

    if evt.GetGlobalVar("MMerge.CrossContinents.GotFinalQuest") == 0 then
        evt.SetGlobalVar("MMerge.CrossContinents.GotFinalQuest", 1)
    end

    ConfigureFriendNpcs()
    ConfigureChaosNpc()
end)

RegisterNpcEnterHook(65005, "MMMerge BrAlvar friend context", function(context)
    if context ~= nil and IsFriendNpc(context.npcId) then
        evt.SetMapVar("CurrentFriendNpc", context.npcId)
    end
end)
