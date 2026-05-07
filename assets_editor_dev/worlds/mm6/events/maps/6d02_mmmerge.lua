-- MMMerge map supplement: Abandoned Temple rescue follower state.

ReplaceMapEvent(14, "Legacy event 14", function()
    if IsQBitSet(QBit(1056)) then
        return
    end

    SetQBit(QBit(1056))
    SetQBit(QBit(1704))
    AddFollowerNpc(980)
    evt.SpeakNPC(980)
end)
