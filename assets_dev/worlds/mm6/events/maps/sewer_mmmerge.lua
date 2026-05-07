-- MMMerge map supplement: Free Haven sewer rescue follower state.

ReplaceMapEvent(8, "Legacy event 8", function()
    if IsQBitSet(QBit(1194)) or not IsQBitSet(QBit(1122)) then
        return
    end

    SetQBit(QBit(1701))
    SetQBit(QBit(1194))
    AddFollowerNpc(802)
    evt.SpeakNPC(802)
end)
