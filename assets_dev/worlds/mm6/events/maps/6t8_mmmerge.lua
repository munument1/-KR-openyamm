-- MMMerge map supplement: Temple of the Snake rescue follower state.

ReplaceMapEvent(25, "Cage", function()
    if IsQBitSet(QBit(1227)) then
        return
    end

    SetQBit(QBit(1227))
    SetQBit(QBit(1702))
    AddFollowerNpc(893)
    evt.SpeakNPC(893)
end, "Cage")
