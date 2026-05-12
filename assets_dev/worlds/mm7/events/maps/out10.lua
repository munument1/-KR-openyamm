-- Mount Nighon
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
    evt.Debug("load")
    if not IsQBitSet(QBit(721)) then -- TP Buff Nighon
        SetQBit(QBit(721)) -- TP Buff Nighon
        evt.SetMonGroupBit(56, MonsterBits.Hostile, 1) -- actor group 56: spawn Hydra A, spawn Roc A, spawn Warlock A
        return
    end
    evt.SetMonGroupBit(56, MonsterBits.Hostile, 1) -- actor group 56: spawn Hydra A, spawn Roc A, spawn Warlock A
end)

RegisterEvent(3, "The Tannery", function()
    evt.EnterHouse(54) -- The Tannery
end, "The Tannery")

RegisterEvent(4, "The Tannery", nil, "The Tannery")

RegisterEvent(5, "Arcane Items", function()
    evt.EnterHouse(92) -- Arcane Items
end, "Arcane Items")

RegisterEvent(6, "Arcane Items", nil, "Arcane Items")

RegisterEvent(7, "Offerings and Blessings", function()
    evt.EnterHouse(318) -- Offerings and Blessings
end, "Offerings and Blessings")

RegisterEvent(8, "Offerings and Blessings", nil, "Offerings and Blessings")

RegisterEvent(9, "Applied Instruction", function()
    evt.EnterHouse(1576) -- Applied Instruction
end, "Applied Instruction")

RegisterEvent(10, "Applied Instruction", nil, "Applied Instruction")

RegisterEvent(11, "Fortune's Folly", function()
    evt.EnterHouse(248) -- Fortune's Folly
end, "Fortune's Folly")

RegisterEvent(12, "Fortune's Folly", nil, "Fortune's Folly")

RegisterEvent(13, "Paramount Guild of Fire", function()
    evt.EnterHouse(131) -- Paramount Guild of Fire
end, "Paramount Guild of Fire")

RegisterEvent(14, "Paramount Guild of Fire", nil, "Paramount Guild of Fire")

RegisterEvent(15, "The Blooded Dagger", function()
    evt.EnterHouse(14) -- The Blooded Dagger
end, "The Blooded Dagger")

RegisterEvent(16, "The Blooded Dagger", nil, "The Blooded Dagger")

RegisterEvent(51, "Legacy event 51", nil)

RegisterEvent(52, "Whitesky Residence", function()
    evt.EnterHouse(990) -- Whitesky Residence
end, "Whitesky Residence")

RegisterEvent(53, "Evander's Home", function()
    evt.EnterHouse(995) -- Evander's Home
end, "Evander's Home")

RegisterEvent(54, "Anwyn Residence", function()
    evt.EnterHouse(996) -- Anwyn Residence
end, "Anwyn Residence")

RegisterEvent(55, "Silk's Home", function()
    evt.EnterHouse(997) -- Silk's Home
end, "Silk's Home")

RegisterEvent(56, "Dusk's Home", function()
    evt.EnterHouse(1002) -- Dusk's Home
end, "Dusk's Home")

RegisterEvent(57, "Elmo's House", function()
    evt.EnterHouse(991) -- Elmo's House
end, "Elmo's House")

RegisterEvent(58, "Roggen Residence", function()
    evt.EnterHouse(1143) -- Roggen Residence
end, "Roggen Residence")

RegisterEvent(59, "Elzbet's House", function()
    evt.EnterHouse(1144) -- Elzbet's House
end, "Elzbet's House")

RegisterEvent(60, "Aznog's Place", function()
    evt.EnterHouse(1145) -- Aznog's Place
end, "Aznog's Place")

RegisterEvent(61, "Hollis' Home", function()
    evt.EnterHouse(1146) -- Hollis' Home
end, "Hollis' Home")

RegisterEvent(62, "Lanshee's House", function()
    evt.EnterHouse(1147) -- Lanshee's House
end, "Lanshee's House")

RegisterEvent(63, "Neldon Residence", function()
    evt.EnterHouse(1148) -- Neldon Residence
end, "Neldon Residence")

RegisterEvent(64, "Hawthorne Residence", function()
    evt.EnterHouse(1149) -- Hawthorne Residence
end, "Hawthorne Residence")

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
    evt.OpenChest(0)
end)

RegisterEvent(201, "Chest", nil, "Chest")

RegisterEvent(202, "Legacy event 202", function()
    if not IsPlayerBitSet(PlayerBit(15)) then
        if not IsAutonoteSet(277) then -- 2 Skill Points from the well near Offerings and Blessings in Damocles in Mount Nighon.
            SetAutonote(277) -- 2 Skill Points from the well near Offerings and Blessings in Damocles in Mount Nighon.
        end
        AddValue(SkillPoints, 2)
        SetPlayerBit(PlayerBit(15))
        return
    end
end)

RegisterEvent(203, "Legacy event 203", function()
    if not IsPlayerBitSet(PlayerBit(16)) then
        if not IsAutonoteSet(278) then -- 2 points of permanent Personality from the well near Fortune's Folly in Damocles in Mount Nighon.
            SetAutonote(278) -- 2 points of permanent Personality from the well near Fortune's Folly in Damocles in Mount Nighon.
        end
        AddValue(BasePersonality, 2)
        SetPlayerBit(PlayerBit(16))
        return
    end
end)

RegisterEvent(204, "Legacy event 204", function()
    if IsPlayerBitSet(PlayerBit(17)) then
        return
    elseif IsAutonoteSet(279) then -- 20 points of temporary Air, Earth, Fire, Water, Body, and Mind resistances from the well near the Fire Guild in Damocles in Mount Nighon.
        AddValue(FireResistanceBonus, 20)
        AddValue(WaterResistanceBonus, 20)
        AddValue(BodyResistanceBonus, 20)
        AddValue(AirResistanceBonus, 20)
        AddValue(EarthResistanceBonus, 20)
        AddValue(MindResistanceBonus, 20)
        SetPlayerBit(PlayerBit(17))
        return
    else
        SetAutonote(279) -- 20 points of temporary Air, Earth, Fire, Water, Body, and Mind resistances from the well near the Fire Guild in Damocles in Mount Nighon.
        AddValue(FireResistanceBonus, 20)
        AddValue(WaterResistanceBonus, 20)
        AddValue(BodyResistanceBonus, 20)
        AddValue(AirResistanceBonus, 20)
        AddValue(EarthResistanceBonus, 20)
        AddValue(MindResistanceBonus, 20)
        SetPlayerBit(PlayerBit(17))
        return
    end
end)

RegisterEvent(205, "Legacy event 205", nil)

RegisterEvent(206, "Legacy event 206", function()
    if not IsPlayerBitSet(PlayerBit(14)) then
        if not IsAutonoteSet(276) then -- 50 points of temporary Intellect and Personality from the central fountain in Damocles in Mount Nighon.
            SetAutonote(276) -- 50 points of temporary Intellect and Personality from the central fountain in Damocles in Mount Nighon.
        end
        AddValue(PersonalityBonus, 50)
        AddValue(IntellectBonus, 50)
        SetPlayerBit(PlayerBit(14))
        return
    end
end)

RegisterEvent(207, "Legacy event 207", function()
    if not IsAtLeast(MaxSpellPoints, 0) then
        AddValue(CurrentSpellPoints, 25)
        SetAutonote(280) -- 50 Spell Points recovered from the well in the eastern village in Mount Nighon.
        return
    end
end)

RegisterEvent(208, "Legacy event 208", function()
    if not IsAtLeast(MaxHealth, 0) then
        AddValue(CurrentHealth, 25)
        SetAutonote(281) -- 50 Hit Points recovered from the well in the western village in Mount Nighon.
        return
    end
end)

RegisterEvent(209, "Legacy event 209", nil)

RegisterEvent(210, "Legacy event 210", nil)

RegisterEvent(451, "Legacy event 451", nil)

RegisterEvent(452, "Legacy event 452", function()
    if not IsPlayerBitSet(PlayerBit(28)) then
        AddValue(BasePersonality, 10)
        AddValue(BaseIntellect, 10)
        SetPlayerBit(PlayerBit(28))
        return
    end
end)

RegisterEvent(453, "Legacy event 453", function()
    if IsQBitSet(QBit(684)) then return end -- Visited Obelisk in Area 10
    SetAutonote(317) -- Obelisk message #9: fi_eo_od
    evt.ForPlayer(Players.All)
    SetQBit(QBit(684)) -- Visited Obelisk in Area 10
end)

RegisterEvent(454, "Legacy event 454", function()
    evt.ForPlayer(Players.All)
    SetValue(Eradicated, 0)
end)

RegisterEvent(500, "Legacy event 500", function()
    if evt.CheckSeason(3) then return end
    if evt.CheckSeason(2) then return end
    if evt.CheckSeason(1) then return end
    if evt.CheckSeason(0) then
    end
end)

RegisterEvent(501, "Legacy event 501", function()
    evt.MoveToMap(-1024, 768, 4097, 1792, 0, 0, 150, 1, "7d07.blv") -- Thunderfist Mountain
end)

RegisterEvent(502, "Legacy event 502", function()
    evt.MoveToMap(1536, -8614, 1, 512, 0, 0, 151, 1, "d02.blv") -- The Maze
end)

RegisterEvent(503, "Legacy event 503", function()
    evt.MoveToMap(9960, 1443, 390, 1936, 0, 0, 150, 1, "7d07.blv") -- Thunderfist Mountain
end)

RegisterEvent(504, "Legacy event 504", function()
    evt.MoveToMap(-11058, 4858, 3969, 148, 0, 0, 150, 1, "7d07.blv") -- Thunderfist Mountain
end)

RegisterEvent(505, "Legacy event 505", function()
    evt.MoveToMap(11471, -3498, 2814, 414, 0, 0, 150, 1, "7d07.blv") -- Thunderfist Mountain
end)

