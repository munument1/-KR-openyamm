-- Plane of Fire
-- generated from legacy EVT/STR

SetMapMetadata({
    onLoad = {1, 2, 3, 4, 5},
    onLeave = {6, 7, 8, 9, 10},
    openedChestIds = {
    [81] = {0},
    [82] = {1},
    [83] = {2},
    [84] = {3},
    [85] = {4},
    [86] = {5},
    [87] = {6},
    [88] = {7},
    [89] = {8},
    [90] = {9},
    [91] = {10},
    [92] = {11},
    [93] = {12},
    [94] = {13},
    [95] = {14},
    [96] = {15},
    [97] = {16},
    [98] = {17},
    [99] = {18},
    [100] = {19},
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {
    },
})

RegisterNoOpEvent(1, nil)

RegisterNoOpEvent(2, nil)

RegisterNoOpEvent(3, nil)

RegisterNoOpEvent(4, nil)

RegisterNoOpEvent(5, nil)

RegisterEvent(6, nil, function()
    if IsQBitSet(QBit(242)) then return end -- Got the heart of fire
    evt.ForPlayer(Players.All)
    if HasItem(606) then -- Heart of Fire
        SetQBit(QBit(242)) -- Got the heart of fire
        AddValue(Experience, 100000)
        SetQBit(QBit(205)) -- Heart of Fire - I lost it
    end
end)

RegisterNoOpEvent(7, nil)

RegisterNoOpEvent(8, nil)

RegisterNoOpEvent(9, nil)

RegisterNoOpEvent(10, nil)

RegisterEvent(11, "Ember's House", function()
    evt.EnterHouse(686) -- Ember's House
end, "Ember's House")

RegisterEvent(12, "Ember's House", nil, "Ember's House")

RegisterEvent(13, "Evenblaze's House", function()
    evt.EnterHouse(687) -- Evenblaze's House
end, "Evenblaze's House")

RegisterEvent(14, "Evenblaze's House", nil, "Evenblaze's House")

RegisterEvent(15, "Empty House", function()
    evt.EnterHouse(688) -- Empty House
end, "Empty House")

RegisterEvent(16, "Empty House", nil, "Empty House")

RegisterEvent(17, "Empty House", function()
    evt.EnterHouse(689) -- Empty House
end, "Empty House")

RegisterEvent(18, "Empty House", nil, "Empty House")

RegisterEvent(19, "Empty House", function()
    evt.EnterHouse(690) -- Empty House
end, "Empty House")

RegisterEvent(20, "Empty House", nil, "Empty House")

RegisterEvent(21, "Burn's House", function()
    evt.EnterHouse(543) -- Burn's House
end, "Burn's House")

RegisterEvent(22, "Burn's House", nil, "Burn's House")

RegisterEvent(81, nil, function()
    evt.OpenChest(0)
end)

RegisterEvent(82, nil, function()
    evt.OpenChest(1)
end)

RegisterEvent(83, nil, function()
    evt.OpenChest(2)
end)

RegisterEvent(84, nil, function()
    evt.OpenChest(3)
end)

RegisterEvent(85, nil, function()
    evt.OpenChest(4)
end)

RegisterEvent(86, nil, function()
    evt.OpenChest(5)
end)

RegisterEvent(87, nil, function()
    evt.OpenChest(6)
end)

RegisterEvent(88, nil, function()
    evt.OpenChest(7)
end)

RegisterEvent(89, nil, function()
    evt.OpenChest(8)
end)

RegisterEvent(90, nil, function()
    evt.OpenChest(9)
end)

RegisterEvent(91, nil, function()
    evt.OpenChest(10)
end)

RegisterEvent(92, nil, function()
    evt.OpenChest(11)
end)

RegisterEvent(93, nil, function()
    evt.OpenChest(12)
end)

RegisterEvent(94, nil, function()
    evt.OpenChest(13)
end)

RegisterEvent(95, nil, function()
    evt.OpenChest(14)
end)

RegisterEvent(96, nil, function()
    evt.OpenChest(15)
end)

RegisterEvent(97, nil, function()
    evt.OpenChest(16)
end)

RegisterEvent(98, nil, function()
    evt.OpenChest(17)
end)

RegisterEvent(99, nil, function()
    evt.OpenChest(18)
end)

RegisterEvent(100, nil, function()
    evt.OpenChest(19)
end)

RegisterEvent(401, "Castle of Fire", nil, "Castle of Fire")

RegisterEvent(402, "War Camp", nil, "War Camp")

RegisterEvent(403, "Gate out of the Plane of Fire", nil, "Gate out of the Plane of Fire")

RegisterEvent(451, "Take a Drink", function()
    if not IsAtLeast(FireResistanceBonus, 25) then
        AddValue(FireResistanceBonus, 25)
        evt.StatusText("Fire Resistance +25 (Temporary)")
        SetAutonote(231) -- Well in the Plane of Fire gives a temporary Fire Resistance bonus of 25.
        return
    end
    evt.StatusText("Refreshing")
end, "Take a Drink")

RegisterEvent(452, nil, function()
    evt._SpecialJump(33555456, 220)
end)

RegisterEvent(453, nil, function()
    evt._SpecialJump(33555968, 220)
end)

RegisterEvent(454, nil, function()
    evt._SpecialJump(33554432, 220)
end)

RegisterEvent(501, "Enter the Castle of Fire", function()
    evt.MoveToMap(1, 1, 1, 256, 0, 0, 376, 1, "d29.blv") -- Castle of Fire
end, "Enter the Castle of Fire")

RegisterEvent(502, "Enter the War Camp", function()
    evt.MoveToMap(4, -1050, 1, 512, 0, 0, 377, 1, "d30.blv") -- War Camp
end, "Enter the War Camp")

RegisterEvent(505, "Leave the Plane of Fire", function()
    evt.MoveToMap(20912, 20208, 918, 1024, 0, 0, 0, 1, "out04.odm") -- Ironsand Desert
end, "Leave the Plane of Fire")

