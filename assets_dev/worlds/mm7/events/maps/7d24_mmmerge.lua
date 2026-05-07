-- MMMerge map supplement: Stone City throne room and Dwarf King cleanup.

ReplaceMapEvent(416, "Enter the Throne Room", function()
    if IsQBitSet(QBit(647)) then -- Completed the Red Dwarf Mines rescue path for the Dwarf King.
        evt.EnterHouse(216)
        return
    end

    evt.FaceAnimation(FaceAnimation.DoorLocked)
    evt.StatusText("The Door is Locked")
end, "Enter the Throne Room")

RegisterNpcExitHook(65024, "MMMerge Dwarf King cleanup", function(context)
    if context.npcId == 398 then -- Dwarf King
        ClearQBit(QBit(658))
    end
end)
