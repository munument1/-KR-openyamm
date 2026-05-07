-- MMMerge supplement: submarine remains usable after the pirate key was used once.

ReplaceMapEvent(451, "Enter the Submarine", function()
    evt.ForPlayer(Players.All)

    if HasItem(619) or IsQBitSet(QBit(214)) then
        SetQBit(QBit(214))
        evt.ForPlayer(Players.Current)
        evt.ShowMovie("Subcut", true)
        evt.MoveToMap(-2416, 1850, -687, 1536, 0, 0, 0, 0, "d34.blv")
        return
    end

    evt.ForPlayer(Players.Current)
    evt.FaceAnimation(FaceAnimation.DoorLocked)
end, "Enter the Submarine")
