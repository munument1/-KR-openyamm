-- MMMerge map supplement: Dragonsand Dimension Door entry point and Shrine of the Gods refill state.

local function shrineOfGodsMapVarName(playerIndex)
    return "ShrineOfGodsBlessed" .. tostring(playerIndex)
end

ReplaceMapEvent(103, "Shrine of the Gods", function()
    local playerIndex = evt.GetCurrentPlayerIndex()

    if playerIndex < 0 then
        return
    end

    evt.ForPlayer(Players.Current)

    if evt.GetMapVar(shrineOfGodsMapVarName(playerIndex), 0) ~= 0 then
        SetValue(MajorCondition, 0)
        return
    end

    evt.SetMapVar(shrineOfGodsMapVarName(playerIndex), 1)
    AddValue(FireResistance, 20)
    AddValue(AirResistance, 20)
    AddValue(WaterResistance, 20)
    AddValue(EarthResistance, 20)
    AddValue(SpiritResistance, 20)
    AddValue(MindResistance, 20)
    AddValue(BodyResistance, 20)
    AddValue(BaseMight, 20)
    AddValue(BaseIntellect, 20)
    AddValue(BasePersonality, 20)
    AddValue(BaseEndurance, 20)
    AddValue(BaseSpeed, 20)
    AddValue(BaseAccuracy, 20)
    AddValue(BaseLuck, 20)
    evt.PlaySound(42797, 0, 0)
    evt.StatusText("+20 to all stats permanent.")
end, "Shrine of the Gods")

RegisterMapRefillHook(65020, "Reset Shrine of the Gods blessings", function()
    for playerIndex = 0, 4 do
        evt.SetMapVar(shrineOfGodsMapVarName(playerIndex), 0)
    end
end)

ReplaceMapEvent(105, "Dimension Door", function()
    MM6.OpenDimensionDoor()
end, "Dimension Door")
