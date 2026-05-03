-- Blackshire MMerge behavior fixups.

RegisterEvent(65520, "Blackshire guard hostility fixup", function()
    evt.SetMonGroupBit(55, MonsterBits.Hostile, 0)
    evt.SetMonGroupBit(39, MonsterBits.Hostile, 0)
end)

AppendMapOnLoadEvent(65520)
