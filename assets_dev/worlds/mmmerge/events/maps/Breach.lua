-- Shared MMMerge custom content: Controlled Breach outdoor map.

local CrossContinentsStateName = "MMerge.CrossContinents.QuestFinished"
local CrossContinentsEndCardName = "MMerge.CrossContinents.GotEndCard"
local BreachOutdoorDoors = {}
local NextOutdoorDoorEventId = 100

local function addOutdoorDoor(modelName, dx, dy, dz, moveTimeMs)
    NextOutdoorDoorEventId = NextOutdoorDoorEventId + 1
    local eventId = NextOutdoorDoorEventId

    table.insert(BreachOutdoorDoors, {
        Event = eventId,
        Model = modelName,
        Dx = dx or 0,
        Dy = dy or 0,
        Dz = dz or 0,
        TimeMs = moveTimeMs or 1000,
    })

    RegisterEvent(eventId, "Operate " .. modelName, function()
        SetOutdoorModelMechanismState(eventId, DoorAction.Trigger)
    end, "Operate")
end

for index = 1, 3 do
    addOutdoorDoor("Time_" .. index, 0, 0, -10, 1000)
end

for index = 1, 3 do
    addOutdoorDoor("Elev_" .. index .. "_Door", 0, 0, 250, 1000)
end

for index = 1, 3 do
    addOutdoorDoor("SubTower_Door_" .. index, 0, 0, 250, 1000)
end

for index = 1, 4 do
    addOutdoorDoor("LibDoor_" .. index, 0, 0, 300, 1000)
end

for index = 1, 4 do
    addOutdoorDoor("Mus_Door_" .. index, 0, 0, 300, 1000)
end

for index = 1, 7 do
    addOutdoorDoor("RoomDoor_" .. index, 0, 0, 200, 500)
end

addOutdoorDoor("RoomElev", 0, 0, 455, 2000)

for index = 1, 3 do
    addOutdoorDoor("Elev_" .. index .. "_Button", 0, 0, 5, 250)
end

local function registerOutdoorDoors()
    for _, door in ipairs(BreachOutdoorDoors) do
        RegisterOutdoorModelMechanism(
            door.Event,
            door.Model,
            door.Dx,
            door.Dy,
            door.Dz,
            door.TimeMs,
            true,
            false)
    end
end

RegisterEvent(54, "Enter Breach Basement", function()
    evt.MoveToMap(0, 0, 0, 0, 0, 0, 711, 2, "BrBase.blv")
end, "Enter Breach Basement")

RegisterEvent(81, "Breach Focus", function()
    if evt.GetGlobalVar(CrossContinentsStateName) == 0 then
        evt.SetGlobalVar(CrossContinentsStateName, 1)
    end
end, "Breach Focus")

RegisterEvent(900, "Adventurer's Inn", function()
    evt.EnterHouse(1607)
end, "Adventurer's Inn")

RegisterMapOnLoadEvent(66001, "MMMerge Breach final quest state", function()
    registerOutdoorDoors()
    evt.SetGlobalVar(CrossContinentsStateName, 1)
    evt.SetGlobalVar(CrossContinentsEndCardName, 1)
    ClearQBit(QBit(1713))
    ClearQBit(QBit(1714))
    ClearQBit(QBit(1715))
end)
