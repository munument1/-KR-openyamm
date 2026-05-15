-- MMMerge map supplement: Abandoned Temple rescue follower state.

ReplaceMapEvent(14, nil, function()
    if IsQBitSet(QBit(1056)) then -- 32 D02, given when kid is rescued.
        return
    end

    SetQBit(QBit(1056)) -- 32 D02, given when kid is rescued.
    SetQBit(QBit(1704)) -- Replacement for NPCs 195 ver. 6
    AddFollowerNpc(980)
    evt.SpeakNPC(980)
end)
