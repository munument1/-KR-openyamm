-- pending
-- generated from legacy EVT/STR

SetMapMetadata({
    onLoad = {},
    onLeave = {},
    openedChestIds = {
    },
    textureNames = {},
    spriteNames = {"0"},
    castSpellIds = {46},
    timers = {
    },
})

RegisterEvent(1, "Shard filled caskets.", function()
    evt.StatusText("Barrel is filled with crystal shards (worthless).")
end, "Shard filled caskets.")

RegisterEvent(2, "Sacks.", function()
    evt.StatusText("The sacks are filled with flawed crystal shards (worthless).")
end, "Sacks.")

RegisterEvent(3, "Crystal.", function()
    if IsAtLeast(MapVar(2), 1) then return end
    evt.StatusText("You mine the crystal in its raw form (+300 gold).")
    AddValue(Gold, 300)
    SetValue(MapVar(2), 1)
    evt.SetSprite(18, 0, "0")
end, "Crystal.")

RegisterEvent(4, "Crystal.", function()
    if IsAtLeast(MapVar(3), 1) then return end
    evt.StatusText("You mine the crystal in its raw form (+300 gold).")
    AddValue(Gold, 300)
    SetValue(MapVar(3), 1)
    evt.SetSprite(19, 0, "0")
end, "Crystal.")

RegisterEvent(5, "Crystal.", function()
    if IsAtLeast(MapVar(4), 1) then return end
    evt.StatusText("You mine the crystal in its raw form (+300 gold).")
    AddValue(Gold, 300)
    SetValue(MapVar(4), 1)
    evt.SetSprite(45, 0, "0")
end, "Crystal.")

RegisterEvent(6, "Crystal.", function()
    if IsAtLeast(MapVar(5), 1) then return end
    evt.StatusText("You mine the crystal in its raw form (+300 gold).")
    AddValue(Gold, 300)
    SetValue(MapVar(5), 1)
    evt.SetSprite(30, 0, "0")
end, "Crystal.")

RegisterEvent(7, "Crystal.", function()
    if IsAtLeast(MapVar(6), 1) then return end
    evt.StatusText("You mine the crystal in its raw form (+300 gold).")
    AddValue(Gold, 300)
    SetValue(MapVar(6), 1)
    evt.SetSprite(32, 0, "0")
end, "Crystal.")

RegisterEvent(8, "Crystal.", function()
    if IsAtLeast(MapVar(7), 1) then return end
    evt.StatusText("You mine the crystal in its raw form (+300 gold).")
    AddValue(Gold, 300)
    SetValue(MapVar(7), 1)
    evt.SetSprite(31, 0, "0")
end, "Crystal.")

RegisterEvent(9, "Crystal.", function()
    if IsAtLeast(MapVar(8), 1) then return end
    evt.StatusText("You mine the crystal in its raw form (+300 gold).")
    AddValue(Gold, 300)
    SetValue(MapVar(8), 1)
    evt.SetSprite(26, 0, "0")
end, "Crystal.")

RegisterEvent(10, "Crystal.", function()
    if IsAtLeast(MapVar(9), 1) then return end
    evt.StatusText("You mine the crystal in its raw form (+300 gold).")
    AddValue(Gold, 300)
    SetValue(MapVar(9), 1)
    evt.SetSprite(27, 0, "0")
end, "Crystal.")

RegisterEvent(11, "Crystal.", function()
    if IsAtLeast(MapVar(10), 1) then return end
    evt.StatusText("You mine the crystal in its raw form (+300 gold).")
    AddValue(Gold, 300)
    SetValue(MapVar(10), 1)
    evt.SetSprite(25, 0, "0")
end, "Crystal.")

RegisterEvent(12, "Crystal.", function()
    if IsAtLeast(MapVar(11), 1) then return end
    evt.StatusText("You mine the crystal in its raw form (+300 gold).")
    AddValue(Gold, 300)
    SetValue(MapVar(11), 1)
    evt.SetSprite(43, 0, "0")
end, "Crystal.")

RegisterEvent(13, "Crystal.", function()
    if IsAtLeast(MapVar(12), 1) then return end
    evt.StatusText("You mine the crystal in its raw form (+300 gold).")
    AddValue(Gold, 300)
    SetValue(MapVar(12), 1)
    evt.SetSprite(22, 0, "0")
end, "Crystal.")

RegisterEvent(14, "Table with implements atop.", function(continueStep)
    local function Step_0()
        SetValue(MapVar(26), 0)
        return 1
    end
    local function Step_1()
        if IsAtLeast(MapVar(2), 1) then return 3 end
        return 2
    end
    local function Step_2()
        return 9
    end
    local function Step_3()
        if IsAtLeast(MapVar(14), 1) then return 9 end
        return 4
    end
    local function Step_4()
        evt.SetMessage("You refine the crystal you harvested (+200 to its value).")
        return 5
    end
    local function Step_5()
        AddValue(Gold, 200)
        return 6
    end
    local function Step_6()
        AddValue(MapVar(14), 1)
        return 7
    end
    local function Step_7()
        evt._PressAnyKey(14, 8)
        return nil
    end
    local function Step_8()
        SetValue(MapVar(26), 1)
        return 9
    end
    local function Step_9()
        if IsAtLeast(MapVar(3), 1) then return 11 end
        return 10
    end
    local function Step_10()
        return 17
    end
    local function Step_11()
        if IsAtLeast(MapVar(15), 1) then return 17 end
        return 12
    end
    local function Step_12()
        evt.SetMessage("You refine the crystal you harvested (+200 to its value).")
        return 13
    end
    local function Step_13()
        AddValue(Gold, 200)
        return 14
    end
    local function Step_14()
        AddValue(MapVar(15), 1)
        return 15
    end
    local function Step_15()
        evt._PressAnyKey(14, 16)
        return nil
    end
    local function Step_16()
        SetValue(MapVar(26), 1)
        return 17
    end
    local function Step_17()
        if IsAtLeast(MapVar(4), 1) then return 19 end
        return 18
    end
    local function Step_18()
        return 25
    end
    local function Step_19()
        if IsAtLeast(MapVar(16), 1) then return 25 end
        return 20
    end
    local function Step_20()
        evt.SetMessage("You refine the crystal you harvested (+200 to its value).")
        return 21
    end
    local function Step_21()
        AddValue(Gold, 200)
        return 22
    end
    local function Step_22()
        AddValue(MapVar(16), 1)
        return 23
    end
    local function Step_23()
        evt._PressAnyKey(14, 24)
        return nil
    end
    local function Step_24()
        SetValue(MapVar(26), 1)
        return 25
    end
    local function Step_25()
        if IsAtLeast(MapVar(5), 1) then return 27 end
        return 26
    end
    local function Step_26()
        return 33
    end
    local function Step_27()
        if IsAtLeast(MapVar(17), 1) then return 33 end
        return 28
    end
    local function Step_28()
        evt.SetMessage("You refine the crystal you harvested (+200 to its value).")
        return 29
    end
    local function Step_29()
        AddValue(Gold, 200)
        return 30
    end
    local function Step_30()
        AddValue(MapVar(17), 1)
        return 31
    end
    local function Step_31()
        evt._PressAnyKey(14, 32)
        return nil
    end
    local function Step_32()
        SetValue(MapVar(26), 1)
        return 33
    end
    local function Step_33()
        if IsAtLeast(MapVar(6), 1) then return 35 end
        return 34
    end
    local function Step_34()
        return 41
    end
    local function Step_35()
        if IsAtLeast(MapVar(18), 1) then return 41 end
        return 36
    end
    local function Step_36()
        evt.SetMessage("You refine the crystal you harvested (+200 to its value).")
        return 37
    end
    local function Step_37()
        AddValue(Gold, 200)
        return 38
    end
    local function Step_38()
        AddValue(MapVar(18), 1)
        return 39
    end
    local function Step_39()
        evt._PressAnyKey(14, 40)
        return nil
    end
    local function Step_40()
        SetValue(MapVar(26), 1)
        return 41
    end
    local function Step_41()
        if IsAtLeast(MapVar(7), 1) then return 43 end
        return 42
    end
    local function Step_42()
        return 49
    end
    local function Step_43()
        if IsAtLeast(MapVar(19), 1) then return 49 end
        return 44
    end
    local function Step_44()
        evt.SetMessage("You refine the crystal you harvested (+200 to its value).")
        return 45
    end
    local function Step_45()
        AddValue(Gold, 200)
        return 46
    end
    local function Step_46()
        AddValue(MapVar(19), 1)
        return 47
    end
    local function Step_47()
        evt._PressAnyKey(14, 48)
        return nil
    end
    local function Step_48()
        SetValue(MapVar(26), 1)
        return 49
    end
    local function Step_49()
        if IsAtLeast(MapVar(8), 1) then return 51 end
        return 50
    end
    local function Step_50()
        return 57
    end
    local function Step_51()
        if IsAtLeast(MapVar(20), 1) then return 57 end
        return 52
    end
    local function Step_52()
        evt.SetMessage("You refine the crystal you harvested (+200 to its value).")
        return 53
    end
    local function Step_53()
        AddValue(Gold, 200)
        return 54
    end
    local function Step_54()
        AddValue(MapVar(20), 1)
        return 55
    end
    local function Step_55()
        evt._PressAnyKey(14, 56)
        return nil
    end
    local function Step_56()
        SetValue(MapVar(26), 1)
        return 57
    end
    local function Step_57()
        if IsAtLeast(MapVar(9), 1) then return 59 end
        return 58
    end
    local function Step_58()
        return 65
    end
    local function Step_59()
        if IsAtLeast(MapVar(21), 1) then return 65 end
        return 60
    end
    local function Step_60()
        evt.SetMessage("You refine the crystal you harvested (+200 to its value).")
        return 61
    end
    local function Step_61()
        AddValue(Gold, 200)
        return 62
    end
    local function Step_62()
        AddValue(MapVar(21), 1)
        return 63
    end
    local function Step_63()
        evt._PressAnyKey(14, 64)
        return nil
    end
    local function Step_64()
        SetValue(MapVar(26), 1)
        return 65
    end
    local function Step_65()
        if IsAtLeast(MapVar(10), 1) then return 67 end
        return 66
    end
    local function Step_66()
        return 73
    end
    local function Step_67()
        if IsAtLeast(MapVar(22), 1) then return 73 end
        return 68
    end
    local function Step_68()
        evt.SetMessage("You refine the crystal you harvested (+200 to its value).")
        return 69
    end
    local function Step_69()
        AddValue(Gold, 200)
        return 70
    end
    local function Step_70()
        AddValue(MapVar(22), 1)
        return 71
    end
    local function Step_71()
        evt._PressAnyKey(14, 72)
        return nil
    end
    local function Step_72()
        SetValue(MapVar(26), 1)
        return 73
    end
    local function Step_73()
        if IsAtLeast(MapVar(11), 1) then return 75 end
        return 74
    end
    local function Step_74()
        return 81
    end
    local function Step_75()
        if IsAtLeast(MapVar(23), 1) then return 81 end
        return 76
    end
    local function Step_76()
        evt.SetMessage("You refine the crystal you harvested (+200 to its value).")
        return 77
    end
    local function Step_77()
        AddValue(Gold, 200)
        return 78
    end
    local function Step_78()
        AddValue(MapVar(23), 1)
        return 79
    end
    local function Step_79()
        evt._PressAnyKey(14, 80)
        return nil
    end
    local function Step_80()
        SetValue(MapVar(26), 1)
        return 81
    end
    local function Step_81()
        if IsAtLeast(MapVar(12), 1) then return 83 end
        return 82
    end
    local function Step_82()
        return 89
    end
    local function Step_83()
        if IsAtLeast(MapVar(24), 1) then return 89 end
        return 84
    end
    local function Step_84()
        evt.SetMessage("You refine the crystal you harvested (+200 to its value).")
        return 85
    end
    local function Step_85()
        AddValue(Gold, 100)
        return 86
    end
    local function Step_86()
        AddValue(MapVar(24), 1)
        return 87
    end
    local function Step_87()
        evt._PressAnyKey(14, 88)
        return nil
    end
    local function Step_88()
        SetValue(MapVar(26), 1)
        return 89
    end
    local function Step_89()
        if IsAtLeast(MapVar(13), 1) then return 91 end
        return 90
    end
    local function Step_90()
        return 97
    end
    local function Step_91()
        if IsAtLeast(MapVar(25), 1) then return 97 end
        return 92
    end
    local function Step_92()
        evt.SetMessage("You refine the crystal you harvested (+200 to its value).")
        return 93
    end
    local function Step_93()
        AddValue(Gold, 200)
        return 94
    end
    local function Step_94()
        AddValue(MapVar(25), 1)
        return 95
    end
    local function Step_95()
        evt._PressAnyKey(14, 96)
        return nil
    end
    local function Step_96()
        SetValue(MapVar(26), 1)
        return 97
    end
    local function Step_97()
        if IsAtLeast(MapVar(26), 1) then return 99 end
        return 98
    end
    local function Step_98()
        evt.StatusText("You see a scattered of refining tools and small crystal shavings.")
        return 99
    end
    local function Step_99()
        return nil
    end
    local step = continueStep or 0
    while step ~= nil do
        if step == 0 then
            step = Step_0()
        elseif step == 1 then
            step = Step_1()
        elseif step == 2 then
            step = Step_2()
        elseif step == 3 then
            step = Step_3()
        elseif step == 4 then
            step = Step_4()
        elseif step == 5 then
            step = Step_5()
        elseif step == 6 then
            step = Step_6()
        elseif step == 7 then
            step = Step_7()
        elseif step == 8 then
            step = Step_8()
        elseif step == 9 then
            step = Step_9()
        elseif step == 10 then
            step = Step_10()
        elseif step == 11 then
            step = Step_11()
        elseif step == 12 then
            step = Step_12()
        elseif step == 13 then
            step = Step_13()
        elseif step == 14 then
            step = Step_14()
        elseif step == 15 then
            step = Step_15()
        elseif step == 16 then
            step = Step_16()
        elseif step == 17 then
            step = Step_17()
        elseif step == 18 then
            step = Step_18()
        elseif step == 19 then
            step = Step_19()
        elseif step == 20 then
            step = Step_20()
        elseif step == 21 then
            step = Step_21()
        elseif step == 22 then
            step = Step_22()
        elseif step == 23 then
            step = Step_23()
        elseif step == 24 then
            step = Step_24()
        elseif step == 25 then
            step = Step_25()
        elseif step == 26 then
            step = Step_26()
        elseif step == 27 then
            step = Step_27()
        elseif step == 28 then
            step = Step_28()
        elseif step == 29 then
            step = Step_29()
        elseif step == 30 then
            step = Step_30()
        elseif step == 31 then
            step = Step_31()
        elseif step == 32 then
            step = Step_32()
        elseif step == 33 then
            step = Step_33()
        elseif step == 34 then
            step = Step_34()
        elseif step == 35 then
            step = Step_35()
        elseif step == 36 then
            step = Step_36()
        elseif step == 37 then
            step = Step_37()
        elseif step == 38 then
            step = Step_38()
        elseif step == 39 then
            step = Step_39()
        elseif step == 40 then
            step = Step_40()
        elseif step == 41 then
            step = Step_41()
        elseif step == 42 then
            step = Step_42()
        elseif step == 43 then
            step = Step_43()
        elseif step == 44 then
            step = Step_44()
        elseif step == 45 then
            step = Step_45()
        elseif step == 46 then
            step = Step_46()
        elseif step == 47 then
            step = Step_47()
        elseif step == 48 then
            step = Step_48()
        elseif step == 49 then
            step = Step_49()
        elseif step == 50 then
            step = Step_50()
        elseif step == 51 then
            step = Step_51()
        elseif step == 52 then
            step = Step_52()
        elseif step == 53 then
            step = Step_53()
        elseif step == 54 then
            step = Step_54()
        elseif step == 55 then
            step = Step_55()
        elseif step == 56 then
            step = Step_56()
        elseif step == 57 then
            step = Step_57()
        elseif step == 58 then
            step = Step_58()
        elseif step == 59 then
            step = Step_59()
        elseif step == 60 then
            step = Step_60()
        elseif step == 61 then
            step = Step_61()
        elseif step == 62 then
            step = Step_62()
        elseif step == 63 then
            step = Step_63()
        elseif step == 64 then
            step = Step_64()
        elseif step == 65 then
            step = Step_65()
        elseif step == 66 then
            step = Step_66()
        elseif step == 67 then
            step = Step_67()
        elseif step == 68 then
            step = Step_68()
        elseif step == 69 then
            step = Step_69()
        elseif step == 70 then
            step = Step_70()
        elseif step == 71 then
            step = Step_71()
        elseif step == 72 then
            step = Step_72()
        elseif step == 73 then
            step = Step_73()
        elseif step == 74 then
            step = Step_74()
        elseif step == 75 then
            step = Step_75()
        elseif step == 76 then
            step = Step_76()
        elseif step == 77 then
            step = Step_77()
        elseif step == 78 then
            step = Step_78()
        elseif step == 79 then
            step = Step_79()
        elseif step == 80 then
            step = Step_80()
        elseif step == 81 then
            step = Step_81()
        elseif step == 82 then
            step = Step_82()
        elseif step == 83 then
            step = Step_83()
        elseif step == 84 then
            step = Step_84()
        elseif step == 85 then
            step = Step_85()
        elseif step == 86 then
            step = Step_86()
        elseif step == 87 then
            step = Step_87()
        elseif step == 88 then
            step = Step_88()
        elseif step == 89 then
            step = Step_89()
        elseif step == 90 then
            step = Step_90()
        elseif step == 91 then
            step = Step_91()
        elseif step == 92 then
            step = Step_92()
        elseif step == 93 then
            step = Step_93()
        elseif step == 94 then
            step = Step_94()
        elseif step == 95 then
            step = Step_95()
        elseif step == 96 then
            step = Step_96()
        elseif step == 97 then
            step = Step_97()
        elseif step == 98 then
            step = Step_98()
        elseif step == 99 then
            step = Step_99()
        else
            step = nil
        end
    end
end, "Table with implements atop.")

RegisterEvent(15, "Crystal.", function()
    evt.StatusText(" This razor sharp crystal is too immature to harvest.")
    evt.DamagePlayer(Players.Current, const.Damage.Physical, 2)
end, "Crystal.")

RegisterEvent(16, nil, function()
    if IsAtLeast(MapVar(27), 1) then return end
    evt.StatusText("Someone has gone to a lot of trouble carving all these murals")
    AddValue(MapVar(27), 1)
end)

RegisterEvent(17, "Carved mural.", function()
    evt.StatusText("You study the mural and get a good feeling inside.")
    evt.CastSpell(46, 1, 2, 0, 0, 0, 0, 0, 0) -- Bless
end, "Carved mural.")

RegisterEvent(18, "Cabinet", function()
    evt.StatusText("The cabinet is filled with old and broken harvesting tools.")
end, "Cabinet")

RegisterEvent(19, "Crystal.", function()
    if IsAtLeast(MapVar(13), 1) then return end
    evt.StatusText("You mine the crystal in its raw form (+300 gold).")
    AddValue(Gold, 300)
    SetValue(MapVar(13), 1)
    evt.SetSprite(44, 0, "0")
end, "Crystal.")

