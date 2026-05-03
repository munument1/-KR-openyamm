-- New Sorpigal MMerge behavior fixups.

RegisterEvent(65520, "New Sorpigal guard hostility fixup", function()
    evt.SetMonGroupBit(55, MonsterBits.Hostile, 0)
end)

AppendMapOnLoadEvent(65520)
