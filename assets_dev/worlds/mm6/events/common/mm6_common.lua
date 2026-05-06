MM6 = MM6 or {}

MM6.LorettaPriceMessage =
    "Well, If Loretta's got a new scheme, count me in!\nBut you better get all the other companies to sign up!"

function MM6.ApplyLocalMonsterRelations(relations)
    ApplyLocalMonsterRelations(relations)
end

function MM6.ApplyDragonTowerState(qbitId, modelIndex, faceIndex)
    if IsQBitSet(QBit(qbitId)) then
        evt.SetOutdoorModelFacetTexture(modelIndex, faceIndex, "t1swbu")
    end
end

function MM6.TryDisableDragonTower(qbitId, modelIndex, faceIndex)
    MM6.ApplyDragonTowerState(qbitId, modelIndex, faceIndex)
    if IsQBitSet(QBit(qbitId)) then
        return
    end

    if HasItem(2106) or HasItem(486) then
        SetQBit(QBit(qbitId))
        evt.SetOutdoorModelFacetTexture(modelIndex, faceIndex, "t1swbu")
    end
end

function MM6.RegisterDragonTowerTimer(eventId, x, y, z, qbitId)
    RegisterMapTimerEvent(eventId, 5 * 60, function()
        if IsQBitSet(QBit(qbitId)) then
            return
        end

        if support.isFlying() and not support.isInvisible() then
            evt.CastSpell(6, 5, 3, x, y, z, 0, 0, 0)
        end
    end, "Dragon Tower")
end

function MM6.CheckLorettaPrices(houseId, qbitId)
    if IsQBitSet(QBit(1140)) and not IsQBitSet(QBit(qbitId)) and evt.IsHouseOpen(houseId) then
        evt.SimpleMessage(MM6.LorettaPriceMessage)
        SetQBit(QBit(qbitId))

        for bit = 1515, 1523 do
            if not IsQBitSet(QBit(bit)) then
                return
            end
        end

        AddValue(Experience, 1)
        SetQBit(QBit(1141))
        return
    end

    evt.EnterHouse(houseId)
end

function MM6.EnsureChestItem(chestId, itemId, gridX, gridY)
    evt.EnsureChestItem(chestId, itemId, gridX or 0, gridY or 0)
end

function MM6.ApplyFrozenHighlandsWinterState()
    if IsQBitSet(QBit(1252)) then
        return
    end

    evt.SetOutdoorSky("sky04")
    evt.SetOutdoorFog(100, 1000)
    evt.SetRain(0, false)
    evt.SetSnow(0, true)
end

function MM6.RevealSilvertongue()
    if HasItem(2122) then
        evt.ShowMovie("citytrtr", false)
        evt.MoveNPC(1089, 0)
        RemoveItem(2122)
        AddValue(655595, 10)
        SetQBit(QBit(1192))
        ClearQBit(QBit(1214))
        ClearQBit(QBit(1225))
        ClearQBit(QBit(1224))
        SetAward(Award(63))
        evt.SetNPCTopic(789, 0, 1416)

        if HasAward(Award(57))
            and HasAward(Award(58))
            and HasAward(Award(59))
            and HasAward(Award(60))
            and HasAward(Award(61))
            and HasAward(Award(62)) then
            SetQBit(QBit(1191))
        end
    end

    if IsQBitSet(QBit(1192)) then
        ClearQBit(QBit(1225))
    end

    evt.EnterHouse(209)
end

function MM6.RepairStoneTemple()
    if IsQBitSet(QBit(1131)) then
        if HasItem(2054) then
            RemoveItem(2054)
            ClearQBit(QBit(1212))
            SetQBit(QBit(1132))
            evt.SimpleMessage(
                "You hand the Sacred Chalice to the monks of the temple who ensconce it in the main altar.")
        else
            evt.EnterHouse(326)
        end
        return
    end

    if IsQBitSet(QBit(1130)) then
        if IsQBitSet(QBit(1129)) then
            evt.EnterHouse(1442)
        else
            evt.EnterHouse(326)
        end
        return
    end

    if HasFollowerProfession(63) and HasFollowerProfession(64) then
        evt.SimpleMessage("The stone cutter and carpenter begin rebuilding the temple.")
        SetQBit(QBit(1130))
        RemoveFollowerProfession(63)
        RemoveFollowerProfession(64)
        return
    end

    evt.EnterHouse(1442)
end

function MM6.OpenDimensionDoor()
    evt.OpenDimensionDoor()
end

function MM6.RunNewSorpigalVolcanoSequence()
    evt.PlaySound(18090)

    for i = 1, 6 do
        evt.CastSpell(
            6,
            4,
            10,
            -14074,
            16106,
            1250,
            math.random(-14124, -14024),
            math.random(16056, 16156),
            1500)
    end

    evt.CastSpell(
        43, 4, 10, -14320, 16272, 1400, math.random(-14420, -14220), math.random(16172, 16372), 2400)
    evt.CastSpell(
        43, 4, 10, -14096, 15648, 1400, math.random(-14200, -14000), math.random(15548, 15748), 2400)
    evt.CastSpell(
        43, 4, 10, -13856, 16448, 1400, math.random(-13956, -13756), math.random(16348, 16548), 2400)

    for i = 1, 6 do
        local x = math.random(-20549, -7225)
        local y = math.random(11879, 18122)
        evt.CastSpell(9, 4, 10, x, y, 5084, x, y, 3000)
    end
end
