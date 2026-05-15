-- MMMerge map supplement: Temple of the Sun rescue follower state.

ReplaceMapEvent(30, nil, function()
    if IsQBitSet(QBit(1030)) then -- 6 T3, given when you rescue prisoner.
        return
    end

    SetQBit(QBit(1030)) -- 6 T3, given when you rescue prisoner.
    SetQBit(QBit(1705)) -- Replacement for NPCs 155 ver. 6
    AddFollowerNpc(940)
    evt.SpeakNPC(940)
end)
