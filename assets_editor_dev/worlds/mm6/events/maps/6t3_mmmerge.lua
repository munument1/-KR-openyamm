-- MMMerge map supplement: Temple of the Sun rescue follower state.

ReplaceMapEvent(30, "Legacy event 30", function()
    if IsQBitSet(QBit(1030)) then
        return
    end

    SetQBit(QBit(1030))
    SetQBit(QBit(1705))
    AddFollowerNpc(940)
    evt.SpeakNPC(940)
end)
