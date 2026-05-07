-- MMMerge supplement: place the Water Lord NPC until the prison quest is complete.

RegisterMapOnLoadEvent(901, "MMMerge Water Lord NPC placement", function()
    if not IsQBitSet(QBit(53)) then -- Quest 52 done.
        evt.MoveNPC(24, 662)
    end
end)
