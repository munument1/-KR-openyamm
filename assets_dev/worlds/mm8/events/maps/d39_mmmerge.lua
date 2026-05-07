-- MMMerge supplement: place the Earth Lord NPC until the prison quest is complete.

RegisterMapOnLoadEvent(901, "MMMerge Earth Lord NPC placement", function()
    if not IsQBitSet(QBit(51)) then
        evt.MoveNPC(25, 663)
    end
end)
