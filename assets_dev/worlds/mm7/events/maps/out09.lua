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
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {
    },
})

RegisterEvent(1, "Legacy event 1", function()
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

RegisterEvent(51, "Legacy event 51", nil)

RegisterEvent(52, "Crane Residence", function()
    evt.EnterHouse(987) -- Crane Residence
end, "Crane Residence")

RegisterEvent(53, "Smithson Residence", function()
    evt.EnterHouse(988) -- Smithson Residence
end, "Smithson Residence")

RegisterEvent(54, "Caverhill Residence", function()
    evt.EnterHouse(986) -- Caverhill Residence
end, "Caverhill Residence")

RegisterEvent(151, "Legacy event 151", function()
    evt.OpenChest(1)
end)

RegisterEvent(152, "Legacy event 152", function()
    evt.OpenChest(2)
end)

RegisterEvent(153, "Legacy event 153", function()
    evt.OpenChest(3)
end)

RegisterEvent(154, "Legacy event 154", function()
    evt.OpenChest(4)
end)

RegisterEvent(155, "Legacy event 155", function()
    evt.OpenChest(5)
end)

RegisterEvent(156, "Legacy event 156", function()
    evt.OpenChest(6)
end)

RegisterEvent(157, "Legacy event 157", function()
    evt.OpenChest(7)
end)

RegisterEvent(158, "Legacy event 158", function()
    evt.OpenChest(8)
end)

RegisterEvent(159, "Legacy event 159", function()
    evt.OpenChest(9)
end)

RegisterEvent(160, "Legacy event 160", function()
    evt.OpenChest(10)
end)

RegisterEvent(161, "Legacy event 161", function()
    evt.OpenChest(11)
end)

RegisterEvent(162, "Legacy event 162", function()
    evt.OpenChest(12)
end)

RegisterEvent(163, "Legacy event 163", function()
    evt.OpenChest(13)
end)

RegisterEvent(164, "Legacy event 164", function()
    evt.OpenChest(14)
end)

RegisterEvent(165, "Legacy event 165", function()
    evt.OpenChest(15)
end)

RegisterEvent(166, "Legacy event 166", function()
    evt.OpenChest(16)
end)

RegisterEvent(167, "Legacy event 167", function()
    evt.OpenChest(17)
end)

RegisterEvent(168, "Legacy event 168", function()
    evt.OpenChest(18)
end)

RegisterEvent(169, "Legacy event 169", function()
    evt.OpenChest(19)
end)

RegisterEvent(170, "Legacy event 170", function()
    if IsQBitSet(QBit(690)) then return end -- Open final Obelisk Chest
    evt.OpenChest(0)
    AddValue(Gold, 100000)
    evt.ForPlayer(Players.All)
    SetQBit(QBit(690)) -- Open final Obelisk Chest
end)

RegisterEvent(201, "Chest", nil, "Chest")

RegisterEvent(202, "Legacy event 202", nil)

RegisterEvent(203, "Legacy event 203", nil)

RegisterEvent(204, "Legacy event 204", nil)

RegisterEvent(205, "Legacy event 205", function()
    evt.MoveToMap(4234, -8993, 384, 1216, 0, 0, 0, 0)
end)

RegisterEvent(206, "Legacy event 206", function()
    evt.MoveToMap(-13860, -5350, 256, 192, 0, 0, 0, 0)
end)

RegisterEvent(401, "Legacy event 401", function()
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

RegisterEvent(451, "Legacy event 451", nil)

RegisterEvent(452, "Legacy event 452", function()
    if not IsPlayerBitSet(PlayerBit(27)) then
        AddValue(BaseAccuracy, 10)
        AddValue(BaseSpeed, 10)
        SetPlayerBit(PlayerBit(27))
        return
    end
end)

RegisterEvent(453, "Legacy event 453", function()
    if IsQBitSet(QBit(683)) then return end -- Visited Obelisk in Area 9
    SetAutonote(316) -- Obelisk message #8: _vehlgpe
    evt.ForPlayer(Players.All)
    SetQBit(QBit(683)) -- Visited Obelisk in Area 9
end)

RegisterEvent(500, "Legacy event 500", function()
    if evt.CheckSeason(3) then return end
    if evt.CheckSeason(2) then return end
    if evt.CheckSeason(1) then return end
    if evt.CheckSeason(0) then
    end
end)

RegisterEvent(501, "Legacy event 501", function()
    evt.MoveToMap(3136, 2053, 1, 512, 0, 0, 148, 1, "7d19.blv") -- Grand Temple of the Moon
end)

RegisterEvent(502, "Legacy event 502", function()
    evt.MoveToMap(0, -3179, 161, 512, 0, 0, 149, 1, "t03.blv") -- Grand Temple of the Sun
end)

