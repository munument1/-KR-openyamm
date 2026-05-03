-- Castle Ironfist MMerge behavior fixups.

RegisterEvent(65520, "Castle Ironfist guard hostility fixup", function()
    evt.SetMonGroupBit(55, MonsterBits.Hostile, 0)
end)

AppendMapOnLoadEvent(65520)
