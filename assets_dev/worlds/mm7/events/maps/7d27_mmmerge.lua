-- MMMerge map supplement: Colony Zod key pickup repair.

ReplaceMapEvent(376, "Colony Zod Key", function()
    if not HasItemAnywhere(1463) and evt.GetHeldItemId() ~= 1463 then
        GiveItem(1463) -- Colony Zod Key
        evt.SetSprite(20, 1, "0")
        SetQBit(QBit(752)) -- Talked to Roland
        evt.SetFacetBit(1, FacetBits.Untouchable, true)
        evt.SetFacetBit(1, FacetBits.Invisible, true)
    end

    evt.SpeakNPC(626)
end)
