-- pending
-- generated from legacy EVT/STR

SetMapMetadata({
    onLoad = {},
    onLeave = {},
    openedChestIds = {
    [5] = {2},
    [6] = {3},
    },
    contextActions = {
    [1] = { kind = "open_door", source = "opcode" },
    [2] = { kind = "open_door", source = "opcode" },
    [3] = { kind = "open_door", source = "opcode" },
    [5] = { kind = "open_chest", source = "opcode", chestIds = {2} },
    [6] = { kind = "open_chest", source = "opcode", chestIds = {3} },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {
    },
})

RegisterEvent(1, nil, function()
    evt.SetDoorState(1, DoorAction.Open)
    evt.SetDoorState(3, DoorAction.Close)
end)

RegisterEvent(2, nil, function()
    evt.SetDoorState(2, DoorAction.Open)
    evt.SetDoorState(4, DoorAction.Close)
end)

RegisterEvent(3, nil, function()
    evt.SetDoorState(1, DoorAction.Close)
    evt.SetDoorState(3, DoorAction.Open)
end)

RegisterEvent(5, "Chest", function()
    evt.OpenChest(2)
end, "Chest")

RegisterEvent(6, "Chest", function()
    evt.OpenChest(3)
end, "Chest")

