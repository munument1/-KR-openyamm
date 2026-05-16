-- Evenmorn Island
-- generated from legacy EVT/STR

SetMapMetadata({
    onLoad = {1},
    onLeave = {},
    openedChestIds = {
    [151] = {1},
    [152] = {2},
    [153] = {3},
    [154] = {4},
    [155] = {5},
    [156] = {6},
    [157] = {7},
    [158] = {8},
    [159] = {9},
    [160] = {10},
    [161] = {11},
    [162] = {12},
    [163] = {13},
    [164] = {14},
    [165] = {15},
    [166] = {16},
    [167] = {17},
    [168] = {18},
    [169] = {19},
    [170] = {0},
    },
    contextActions = {
    [3] = { kind = "enter_house", source = "opcode", houseId = 247, targetName = "The Laughing Monk" },
    [5] = { kind = "enter_house", source = "opcode", houseId = 143, targetName = "Paramount Guild of Water" },
    [7] = { kind = "enter_house", source = "opcode", houseId = 489, targetName = "Sacred Sails" },
    [52] = { kind = "enter_house", source = "opcode", houseId = 987, targetName = "Crane Residence" },
    [53] = { kind = "enter_house", source = "opcode", houseId = 988, targetName = "Smithson Residence" },
    [54] = { kind = "enter_house", source = "opcode", houseId = 986, targetName = "Caverhill Residence" },
    [151] = { kind = "open_chest", source = "opcode", chestIds = {1} },
    [152] = { kind = "open_chest", source = "opcode", chestIds = {2} },
    [153] = { kind = "open_chest", source = "opcode", chestIds = {3} },
    [154] = { kind = "open_chest", source = "opcode", chestIds = {4} },
    [155] = { kind = "open_chest", source = "opcode", chestIds = {5} },
    [156] = { kind = "open_chest", source = "opcode", chestIds = {6} },
    [157] = { kind = "open_chest", source = "opcode", chestIds = {7} },
    [158] = { kind = "open_chest", source = "opcode", chestIds = {8} },
    [159] = { kind = "open_chest", source = "opcode", chestIds = {9} },
    [160] = { kind = "open_chest", source = "opcode", chestIds = {10} },
    [161] = { kind = "open_chest", source = "opcode", chestIds = {11} },
    [162] = { kind = "open_chest", source = "opcode", chestIds = {12} },
    [163] = { kind = "open_chest", source = "opcode", chestIds = {13} },
    [164] = { kind = "open_chest", source = "opcode", chestIds = {14} },
    [165] = { kind = "open_chest", source = "opcode", chestIds = {15} },
    [166] = { kind = "open_chest", source = "opcode", chestIds = {16} },
    [167] = { kind = "open_chest", source = "opcode", chestIds = {17} },
    [168] = { kind = "open_chest", source = "opcode", chestIds = {18} },
    [169] = { kind = "open_chest", source = "opcode", chestIds = {19} },
    [170] = { kind = "open_chest", source = "opcode", chestIds = {0} },
    [205] = { kind = "teleport", source = "heuristic" },
    [206] = { kind = "teleport", source = "heuristic" },
    [401] = { kind = "generic_event", source = "opcode" },
    [452] = { kind = "generic_event", source = "opcode" },
    [453] = { kind = "generic_event", source = "opcode" },
    [501] = { kind = "enter_dungeon", source = "opcode", targetMap = "7d19.blv", targetName = "Grand Temple of the Moon" },
    [502] = { kind = "enter_dungeon", source = "opcode", targetMap = "t03.blv", targetName = "Grand Temple of the Sun" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {
    },
})

RegisterEvent(1, nil, function()
    evt.SetMonGroupBit(56, MonsterBits.Hostile, 1) -- actor group 56: spawn Gargoyle A
end)

RegisterEvent(3, "The Laughing Monk", function()
    evt.EnterHouse(247) -- The Laughing Monk
end, "The Laughing Monk")

RegisterEvent(4, "The Laughing Monk", nil, "The Laughing Monk")

RegisterEvent(5, "Paramount Guild of Water", function()
    evt.EnterHouse(143) -- Paramount Guild of Water
end, "Paramount Guild of Water")

RegisterEvent(6, "Paramount Guild of Water", nil, "Paramount Guild of Water")

RegisterEvent(7, "Sacred Sails", function()
    evt.EnterHouse(489) -- Sacred Sails
end, "Sacred Sails")

RegisterEvent(8, "Sacred Sails", nil, "Sacred Sails")

RegisterEvent(51, nil, nil)

RegisterEvent(52, "Crane Residence", function()
    evt.EnterHouse(987) -- Crane Residence
end, "Crane Residence")

RegisterEvent(53, "Smithson Residence", function()
    evt.EnterHouse(988) -- Smithson Residence
end, "Smithson Residence")

RegisterEvent(54, "Caverhill Residence", function()
    evt.EnterHouse(986) -- Caverhill Residence
end, "Caverhill Residence")

RegisterEvent(151, nil, function()
    evt.OpenChest(1)
end)

RegisterEvent(152, nil, function()
    evt.OpenChest(2)
end)

RegisterEvent(153, nil, function()
    evt.OpenChest(3)
end)

RegisterEvent(154, nil, function()
    evt.OpenChest(4)
end)

RegisterEvent(155, nil, function()
    evt.OpenChest(5)
end)

RegisterEvent(156, nil, function()
    evt.OpenChest(6)
end)

RegisterEvent(157, nil, function()
    evt.OpenChest(7)
end)

RegisterEvent(158, nil, function()
    evt.OpenChest(8)
end)

RegisterEvent(159, nil, function()
    evt.OpenChest(9)
end)

RegisterEvent(160, nil, function()
    evt.OpenChest(10)
end)

RegisterEvent(161, nil, function()
    evt.OpenChest(11)
end)

RegisterEvent(162, nil, function()
    evt.OpenChest(12)
end)

RegisterEvent(163, nil, function()
    evt.OpenChest(13)
end)

RegisterEvent(164, nil, function()
    evt.OpenChest(14)
end)

RegisterEvent(165, nil, function()
    evt.OpenChest(15)
end)

RegisterEvent(166, nil, function()
    evt.OpenChest(16)
end)

RegisterEvent(167, nil, function()
    evt.OpenChest(17)
end)

RegisterEvent(168, nil, function()
    evt.OpenChest(18)
end)

RegisterEvent(169, nil, function()
    evt.OpenChest(19)
end)

RegisterEvent(170, nil, function()
    if IsQBitSet(QBit(690)) then return end -- Open final Obelisk Chest
    evt.OpenChest(0)
    AddValue(Gold, 100000)
    evt.ForPlayer(Players.All)
    SetQBit(QBit(690)) -- Open final Obelisk Chest
end)

RegisterEvent(201, "Chest", nil, "Chest")

RegisterEvent(202, nil, nil)

RegisterEvent(203, nil, nil)

RegisterEvent(204, nil, nil)

RegisterEvent(205, nil, function()
    evt.MoveToMap(4234, -8993, 384, 1216, 0, 0, 0, 0)
end)

RegisterEvent(206, nil, function()
    evt.MoveToMap(-13860, -5350, 256, 192, 0, 0, 0, 0)
end)

RegisterEvent(401, nil, function()
    if not IsQBitSet(QBit(561)) then return end -- Visit the three stonehenge monoliths in Tatalia, the Evenmorn Islands, and Avlee, then return to Anthony Green in the Tularean Forest.
    if IsQBitSet(QBit(562)) then -- Visited all stonehenges
        return
    elseif IsQBitSet(QBit(563)) then -- Visited stonehenge 1 (area 9)
        return
    else
        evt.ForPlayer(Players.All)
        SetQBit(QBit(563)) -- Visited stonehenge 1 (area 9)
        evt.ForPlayer(Players.All)
        SetQBit(QBit(757)) -- Congratulations - For Blinging
        ClearQBit(QBit(757)) -- Congratulations - For Blinging
        if IsQBitSet(QBit(564)) and IsQBitSet(QBit(565)) then -- Visited stonehenge 2 (area 13)
            evt.ForPlayer(Players.All)
            SetQBit(QBit(562)) -- Visited all stonehenges
        else
        end
        return
    end
end)

RegisterEvent(451, nil, nil)

RegisterEvent(452, nil, function()
    if not IsPlayerBitSet(PlayerBit(27)) then
        AddValue(BaseAccuracy, 10)
        AddValue(BaseSpeed, 10)
        SetPlayerBit(PlayerBit(27))
        return
    end
end)

RegisterEvent(453, nil, function()
    if IsQBitSet(QBit(683)) then return end -- Visited Obelisk in Area 9
    SetAutonote(316) -- Obelisk message #8: _vehlgpe
    evt.ForPlayer(Players.All)
    SetQBit(QBit(683)) -- Visited Obelisk in Area 9
end)

RegisterEvent(500, nil, function()
    if evt.CheckSeason(3) then return end
    if evt.CheckSeason(2) then return end
    if evt.CheckSeason(1) then return end
    if evt.CheckSeason(0) then
    end
end)

RegisterEvent(501, nil, function()
    evt.MoveToMap(3136, 2053, 1, 512, 0, 0, 148, 1, "7d19.blv") -- Grand Temple of the Moon
end)

RegisterEvent(502, nil, function()
    evt.MoveToMap(0, -3179, 161, 512, 0, 0, 149, 1, "t03.blv") -- Grand Temple of the Sun
end)

