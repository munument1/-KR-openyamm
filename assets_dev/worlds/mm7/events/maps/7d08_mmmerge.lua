-- MMMerge map supplement: Tularean Caves Loren Steel follower.

ReplaceMapEvent(376, "Door", function()
    if IsQBitSet(QBit(1696)) then -- Fake Loren is active
        evt.FaceAnimation(FaceAnimation.DoorLocked)
        return
    end

    if IsQBitSet(QBit(1695)) then -- Loren Steel is already rescued
        AddFollowerNpc(MM7.LorenNpcId)
        return
    end

    if IsQBitSet(QBit(593)) then -- Loren was returned to Catherine
        evt.FaceAnimation(FaceAnimation.DoorLocked)
        return
    end

    if IsQBitSet(QBit(595)) then -- Fake Loren was returned to Catherine
        return
    end

    if IsQBitSet(QBit(605)) then -- Loren was already picked up from the caves
        evt.FaceAnimation(FaceAnimation.DoorLocked)
        return
    end

    SetQBit(QBit(1695)) -- Replacement for NPCs 71 ver. 7
    evt.ForPlayer(Players.All)
    SetQBit(QBit(605)) -- Tularean Caves. Got Loren
    AddFollowerNpc(MM7.LorenNpcId)
    evt.SpeakNPC(MM7.LorenNpcId)
end, "Door")
