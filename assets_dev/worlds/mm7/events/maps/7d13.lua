-- Zokarr's Tomb
-- generated from legacy EVT/STR

SetMapMetadata({
    onLoad = {1},
    onLeave = {},
    openedChestIds = {
    [176] = {1},
    [177] = {2},
    [178] = {3},
    [179] = {4},
    [180] = {5},
    [181] = {6},
    [182] = {7},
    [183] = {8},
    [184] = {9},
    [185] = {10},
    [186] = {11},
    [187] = {12},
    [188] = {13},
    [189] = {14},
    [190] = {15},
    [191] = {16},
    [192] = {17},
    [193] = {18},
    [194] = {19},
    [195] = {0},
    },
    contextActions = {
    [3] = { kind = "open_door", source = "title" },
    [4] = { kind = "open_door", source = "title" },
    [5] = { kind = "open_door", source = "title" },
    [6] = { kind = "open_door", source = "title" },
    [176] = { kind = "open_chest", source = "opcode", chestIds = {1} },
    [177] = { kind = "open_chest", source = "opcode", chestIds = {2} },
    [178] = { kind = "open_chest", source = "opcode", chestIds = {3} },
    [179] = { kind = "open_chest", source = "opcode", chestIds = {4} },
    [180] = { kind = "open_chest", source = "opcode", chestIds = {5} },
    [181] = { kind = "open_chest", source = "opcode", chestIds = {6} },
    [182] = { kind = "open_chest", source = "opcode", chestIds = {7} },
    [183] = { kind = "open_chest", source = "opcode", chestIds = {8} },
    [184] = { kind = "open_chest", source = "opcode", chestIds = {9} },
    [185] = { kind = "open_chest", source = "opcode", chestIds = {10} },
    [186] = { kind = "open_chest", source = "opcode", chestIds = {11} },
    [187] = { kind = "open_chest", source = "opcode", chestIds = {12} },
    [188] = { kind = "open_chest", source = "opcode", chestIds = {13} },
    [189] = { kind = "open_chest", source = "opcode", chestIds = {14} },
    [190] = { kind = "open_chest", source = "opcode", chestIds = {15} },
    [191] = { kind = "open_chest", source = "opcode", chestIds = {16} },
    [192] = { kind = "open_chest", source = "opcode", chestIds = {17} },
    [193] = { kind = "open_chest", source = "opcode", chestIds = {18} },
    [194] = { kind = "open_chest", source = "opcode", chestIds = {19} },
    [195] = { kind = "open_chest", source = "opcode", chestIds = {0} },
    [455] = { kind = "open_door", source = "title" },
    [456] = { kind = "open_door", source = "opcode" },
    [501] = { kind = "passage", source = "opcode", targetMap = "mdk02.blv", targetName = "Barrow IV" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {
    },
})

RegisterEvent(1, nil, function()
    evt.SetMonGroupBit(56, MonsterBits.Hostile, 1) -- actor group 56: spawn Ghoul A, spawn Wight A
end)

RegisterEvent(3, "Door", function()
    evt.SetDoorState(3, DoorAction.Trigger)
end, "Door")

RegisterEvent(4, "Door", function()
    evt.SetDoorState(4, DoorAction.Trigger)
end, "Door")

RegisterEvent(5, "Door", function()
    evt.SetDoorState(1, DoorAction.Trigger)
end, "Door")

RegisterEvent(6, "Door", function()
    evt.SetDoorState(2, DoorAction.Trigger)
end, "Door")

RegisterEvent(176, nil, function()
    evt.OpenChest(1)
end)

RegisterEvent(177, nil, function()
    evt.OpenChest(2)
end)

RegisterEvent(178, nil, function()
    evt.OpenChest(3)
end)

RegisterEvent(179, nil, function()
    evt.OpenChest(4)
end)

RegisterEvent(180, nil, function()
    evt.OpenChest(5)
end)

RegisterEvent(181, nil, function()
    evt.OpenChest(6)
end)

RegisterEvent(182, nil, function()
    evt.OpenChest(7)
end)

RegisterEvent(183, nil, function()
    evt.OpenChest(8)
end)

RegisterEvent(184, nil, function()
    evt.OpenChest(9)
end)

RegisterEvent(185, nil, function()
    evt.OpenChest(10)
end)

RegisterEvent(186, nil, function()
    evt.OpenChest(11)
end)

RegisterEvent(187, nil, function()
    evt.OpenChest(12)
end)

RegisterEvent(188, nil, function()
    evt.OpenChest(13)
end)

RegisterEvent(189, nil, function()
    evt.OpenChest(14)
end)

RegisterEvent(190, nil, function()
    evt.OpenChest(15)
end)

RegisterEvent(191, nil, function()
    evt.OpenChest(16)
end)

RegisterEvent(192, nil, function()
    evt.OpenChest(17)
end)

RegisterEvent(193, nil, function()
    evt.OpenChest(18)
end)

RegisterEvent(194, nil, function()
    evt.OpenChest(19)
end)

RegisterEvent(195, nil, function()
    evt.OpenChest(0)
end)

RegisterEvent(376, nil, function()
    if IsQBitSet(QBit(539)) then -- Find the lost meditation spot in the Dwarven Barrows.
        evt.SpeakNPC(394) -- Bartholomew Hume
    end
end)

RegisterEvent(377, nil, function()
    evt.ForPlayer(Players.All)
    if IsQBitSet(QBit(577)) then -- Barrow downs. Returned the bones of the Dwarf King. Arch Druid promo quest.
        return
    elseif IsQBitSet(QBit(566)) then -- Retrieve the bones of the Dwarf King from the tunnels between Stone City and Nighon and place them in their proper resting place in the Barrow Downs, then return to Anthony Green in the Tularean Forest.
        if HasItem(1428) then -- Zokarr IV's Skull
            RemoveItem(1428) -- Zokarr IV's Skull
            SetQBit(QBit(577)) -- Barrow downs. Returned the bones of the Dwarf King. Arch Druid promo quest.
            evt.ForPlayer(Players.All)
            SetQBit(QBit(757)) -- Congratulations - For Blinging
            ClearQBit(QBit(757)) -- Congratulations - For Blinging
            ClearQBit(QBit(740)) -- Dwarf Bones - I lost it
        end
        return
    else
        return
    end
end)

RegisterEvent(451, "Pillar", function()
    SetValue(MapVar(2), 1)
end, "Pillar")

RegisterEvent(452, "Pillar", function()
    SetValue(MapVar(3), 1)
end, "Pillar")

RegisterEvent(453, "Pillar", function()
    SetValue(MapVar(4), 1)
end, "Pillar")

RegisterEvent(454, "Pillar", function()
    SetValue(MapVar(5), 1)
end, "Pillar")

RegisterEvent(455, "Door", function()
    evt.SetDoorState(5, DoorAction.Trigger)
end, "Door")

RegisterEvent(456, nil, function()
    evt.SetDoorState(7, DoorAction.Open)
    evt.SetDoorState(6, DoorAction.Open)
end)

RegisterEvent(501, nil, function()
    local randomStep = PickRandomOption(501, 1, {1, 1, 1, 3, 3, 3})
    if randomStep == 1 then
        evt.MoveToMap(335, -1064, 1, 768, 0, 0, 0, 0, "mdk02.blv") -- Barrow IV
        return
    elseif randomStep == 3 then
        evt.MoveToMap(-426, 281, -15, 1664, 0, 0, 0, 0, "mdt02.blv") -- Barrow VI
        return
    end
end)

