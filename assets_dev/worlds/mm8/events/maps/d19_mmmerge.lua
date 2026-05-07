-- MMMerge supplement: Dyson checks are relaxed for invisibility and transformer completion.

ReplaceMapEvent(15, "Door", function()
    if IsQBitSet(QBit(20)) -- Allied with Temple of the Sun. Destroy the Skeleton Transformer done.
        or IsQBitSet(QBit(19)) -- Allied with Necromancers Guild. Steal Nightshade Brazier done.
        or HasPlayer(34) then
        evt.SetDoorState(5, DoorAction.Open)
        return
    end

    if IsInvisible() then
        evt.FaceAnimation(FaceAnimation.DoorLocked)
        return
    end

    evt.SetNPCGreeting(45, 107)
    evt.SpeakNPC(45)
end, "Door")

ReplaceMapEvent(131, "MMMerge Skeleton Transformer", function()
    if IsQBitSet(QBit(27)) -- Skeleton Transformer Destroyed.
        or not IsQBitSet(QBit(26)) -- Destroy the skeleton transformer and return to Oskar Tyre.
        or not IsAtLeast(MapVar(21), 15) then
        return
    end

    SetQBit(QBit(27)) -- Skeleton Transformer Destroyed.
    evt.ShowMovie("skeltrans", true)
    evt.SetFacetBit(30, FacetBits.Untouchable, 1)
    evt.SetFacetBit(30, FacetBits.Invisible, 1)
end)
