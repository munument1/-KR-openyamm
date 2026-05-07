-- MMMerge map supplement: Shadow Guild Hideout rescue follower state.

ReplaceMapEvent(22, "Legacy event 22", function()
    if IsQBitSet(QBit(1036)) then
        return
    end

    SetQBit(QBit(1036))
    SetQBit(QBit(1703))
    AddFollowerNpc(978)
    evt.SpeakNPC(978)
end)
