-- MMMerge map supplement: Celeste post-Light hostile guards.

RegisterMapOnLoadEvent(65025, "MMMerge 7d25 post-Light hostility", function()
    if IsQBitSet(QBit(612)) then -- Chose the path of Dark.
        evt.SetMonGroupBit(57, MonsterBits.Hostile, true)
        evt.SetMonGroupBit(56, MonsterBits.Hostile, true)
        evt.SetMonGroupBit(55, MonsterBits.Hostile, true)
    end
end)
