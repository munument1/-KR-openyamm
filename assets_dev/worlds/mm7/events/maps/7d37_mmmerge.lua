-- MMMerge map supplement: Haunted Mansion portrait pickup persistence.

ReplaceMapEvent(376, "Portrait", function()
    if evt.GetMapVar("PortraitTaken", 0) ~= 0 then
        return
    end

    evt.SetTexture(15, "t2bs")
    AddValue(InventoryItem(1423), 1423) -- Angel Statue Painting
    SetQBit(QBit(778)) -- Took Angel Painting
    evt.SetMapVar("PortraitTaken", 1)
end, "Portrait")
