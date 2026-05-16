-- pending
-- generated from legacy EVT/STR

SetMapMetadata({
    onLoad = {},
    onLeave = {},
    openedChestIds = {
    [5] = {1},
    [6] = {0},
    },
    contextActions = {
    [1] = { kind = "open_door", source = "title" },
    [2] = { kind = "open_door", source = "title" },
    [3] = { kind = "open_door", source = "opcode" },
    [4] = { kind = "open_door", source = "title" },
    [5] = { kind = "open_chest", source = "opcode", chestIds = {1} },
    [6] = { kind = "open_chest", source = "opcode", chestIds = {0} },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {
    },
})

RegisterEvent(1, "Door", function()
    evt.SetDoorState(1, DoorAction.Close)
end, "Door")

RegisterEvent(2, "Door", function()
    evt.SetDoorState(2, DoorAction.Close)
end, "Door")

RegisterEvent(3, "Dresser", function()
    evt.SetDoorState(3, DoorAction.Close)
end, "Dresser")

RegisterEvent(4, "Door", function()
    evt.SetDoorState(4, DoorAction.Close)
end, "Door")

RegisterEvent(5, "Chest", function()
    evt.OpenChest(1)
end, "Chest")

RegisterEvent(6, "Bag", function()
    evt.OpenChest(0)
end, "Bag")

