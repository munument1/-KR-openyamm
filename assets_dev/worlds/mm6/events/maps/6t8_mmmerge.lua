-- MMMerge map supplement: Temple of the Snake rescue follower state.

ReplaceMapEvent(25, "Cage", function()
    if IsQBitSet(QBit(1227)) then -- Once Emmanuel is found.
        return
    end

    SetQBit(QBit(1227)) -- Once Emmanuel is found.
    SetQBit(QBit(1702)) -- Replacement for NPCs 108 ver. 6
    AddFollowerNpc(893)
    evt.SpeakNPC(893)
end, "Cage")
