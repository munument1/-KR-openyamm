-- MMMerge map supplement: Supreme Temple of Baa memory crystal pickup.

ReplaceMapEvent(32, "Oracle Memory Crystal", function()
    if IsQBitSet(QBit(1077)) then return end -- 53 T6, Given when characters take the Oracle Crystal from the altar.
    SetQBit(QBit(1077)) -- 53 T6, Given when characters take the Oracle Crystal from the altar.
    evt.SetSprite(132, 1, "crysdisc")
    AddValue(InventoryItem(2170), 2170) -- Memory Crystal Alpha
    SetQBit(QBit(1215)) -- Quest item bits for seer
end, "Oracle Memory Crystal")
