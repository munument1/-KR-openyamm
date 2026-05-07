-- MMMerge map supplement: Shadow Guild Hideout rescue follower state.

ReplaceMapEvent(22, "Legacy event 22", function()
    if IsQBitSet(QBit(1036)) then -- 12 D3, given when you save Mom.
        return
    end

    SetQBit(QBit(1036)) -- 12 D3, given when you save Mom.
    SetQBit(QBit(1703)) -- Replacement for NPCs 193 ver. 6
    AddFollowerNpc(978)
    evt.SpeakNPC(978)
end)
