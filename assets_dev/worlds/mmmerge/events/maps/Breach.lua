-- Shared MMMerge custom content: Controlled Breach outdoor map.

local CrossContinentsQuestFinished = "MMerge.CrossContinents.QuestFinished"
local CrossContinentsGotEndCard = "MMerge.CrossContinents.GotEndCard"

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
    RegisterOutdoorModelMechanism(104, "Elev_1_Door", 0, 0, 250, 1000, true, false)
    SetOutdoorModelMechanismState(104, DoorAction.Trigger)
end, "Operate")

RegisterEvent(105, "Operate Elev_2_Door", function()
    RegisterOutdoorModelMechanism(105, "Elev_2_Door", 0, 0, 250, 1000, true, false)
    SetOutdoorModelMechanismState(105, DoorAction.Trigger)
end, "Operate")

RegisterEvent(106, "Operate Elev_3_Door", function()
    RegisterOutdoorModelMechanism(106, "Elev_3_Door", 0, 0, 250, 1000, true, false)
    SetOutdoorModelMechanismState(106, DoorAction.Trigger)
end, "Operate")

RegisterEvent(107, "Operate SubTower_Door_1", function()
    RegisterOutdoorModelMechanism(107, "SubTower_Door_1", 0, 0, 250, 1000, true, false)
    SetOutdoorModelMechanismState(107, DoorAction.Trigger)
end, "Operate")

RegisterEvent(108, "Operate SubTower_Door_2", function()
    RegisterOutdoorModelMechanism(108, "SubTower_Door_2", 0, 0, 250, 1000, true, false)
    SetOutdoorModelMechanismState(108, DoorAction.Trigger)
end, "Operate")

RegisterEvent(109, "Operate SubTower_Door_3", function()
    RegisterOutdoorModelMechanism(109, "SubTower_Door_3", 0, 0, 250, 1000, true, false)
    SetOutdoorModelMechanismState(109, DoorAction.Trigger)
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
    RegisterOutdoorModelMechanism(112, "LibDoor_3", 0, 0, 300, 1000, true, false)
    SetOutdoorModelMechanismState(112, DoorAction.Trigger)
end, "Operate")

RegisterEvent(113, "Operate LibDoor_4", function()
    RegisterOutdoorModelMechanism(113, "LibDoor_4", 0, 0, 300, 1000, true, false)
    SetOutdoorModelMechanismState(113, DoorAction.Trigger)
end, "Operate")

RegisterEvent(114, "Operate Mus_Door_1", function()
    RegisterOutdoorModelMechanism(114, "Mus_Door_1", 0, 0, 300, 1000, true, false)
    SetOutdoorModelMechanismState(114, DoorAction.Trigger)
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

    RegisterOutdoorModelMechanism(126, "Elev_1_Button", 0, 0, 5, 250, true, false)
    SetOutdoorModelMechanismState(126, DoorAction.Trigger)

    if math.sqrt((10 - partyX) * (10 - partyX) + (-2334 - partyY) * (-2334 - partyY)) < 100 and partyZ < 4410 then
        evt._SpecialJump(0, math.floor(math.sqrt(2 * 800 * (4410 - partyZ))))
    end
end, "Operate")

RegisterEvent(127, "Operate Elev_2_Button", function()
    local partyX, partyY, partyZ = evt.GetPartyPosition()

    RegisterOutdoorModelMechanism(127, "Elev_2_Button", 0, 0, 5, 250, true, false)
    SetOutdoorModelMechanismState(127, DoorAction.Trigger)

    if math.sqrt((1971 - partyX) * (1971 - partyX) + (1139 - partyY) * (1139 - partyY)) < 100 and partyZ < 4410 then
        evt._SpecialJump(0, math.floor(math.sqrt(2 * 800 * (4410 - partyZ))))
    end
end, "Operate")

RegisterEvent(128, "Operate Elev_3_Button", function()
    local partyX, partyY, partyZ = evt.GetPartyPosition()

    RegisterOutdoorModelMechanism(128, "Elev_3_Button", 0, 0, 5, 250, true, false)
    SetOutdoorModelMechanismState(128, DoorAction.Trigger)

    if math.sqrt((-1962 - partyX) * (-1962 - partyX) + (1137 - partyY) * (1137 - partyY)) < 100
        and partyZ < 4410 then
        evt._SpecialJump(0, math.floor(math.sqrt(2 * 800 * (4410 - partyZ))))
    end
end, "Operate")

RegisterEvent(54, "Enter Breach Basement", function()
    evt.MoveToMap(0, 0, 0, 0, 0, 0, 711, 2, "BrBase.blv")
end, "Enter Breach Basement")

RegisterEvent(81, "Breach Focus", function()
    if evt.GetGlobalVar(CrossContinentsQuestFinished) == 0 then
        evt.SetGlobalVar(CrossContinentsQuestFinished, 1)
    end
end, "Breach Focus")

RegisterEvent(900, "Adventurer's Inn", function()
    evt.EnterHouse(1607)
end, "Adventurer's Inn")

RegisterMapOnLoadEvent(66001, "MMMerge Breach final quest state", function()
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

    evt.SetGlobalVar(CrossContinentsQuestFinished, 1)
    evt.SetGlobalVar(CrossContinentsGotEndCard, 1)
    ClearQBit(QBit(1713)) -- Enter The Controlled Breach, find Runaway Chaos and bring it to the Uneasy Origin Matter.
    ClearQBit(QBit(1714)) -- Find your friends.
    ClearQBit(QBit(1715)) -- Find entrance to the main Breach structure.
end)
