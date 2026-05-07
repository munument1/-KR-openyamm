-- MMMerge supplement: Balthazar Lair tritons stay hidden after the rescue is complete.

RegisterMapOnLoadEvent(901, "MMMerge hide rescued-lair tritons", function()
    if IsQBitSet(QBit(23)) then
        evt.SetMonGroupBit(0, MonsterBits.Invisible, 1)
    end
end)
