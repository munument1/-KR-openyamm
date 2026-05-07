-- MMMerge supplement: Dyson checks are relaxed for invisibility and transformer completion.

ReplaceMapEvent(15, "Door", function()
    if IsQBitSet(QBit(20)) or IsQBitSet(QBit(19)) or HasPlayer(34) then
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
    if IsQBitSet(QBit(27)) or not IsQBitSet(QBit(26)) or not IsAtLeast(MapVar(21), 15) then
        return
    end

    SetQBit(QBit(27))
    evt.ShowMovie("skeltrans", true)
    evt.SetFacetBit(30, FacetBits.Untouchable, 1)
    evt.SetFacetBit(30, FacetBits.Invisible, 1)
end)
