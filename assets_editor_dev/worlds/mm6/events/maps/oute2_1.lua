-- Misty Islands MMerge behavior fixups.

RegisterEvent(65520, "Misty Islands guard hostility fixup", function()
    evt.SetMonGroupBit(38, MonsterBits.Hostile, 0)
end)

AppendMapOnLoadEvent(65520)
