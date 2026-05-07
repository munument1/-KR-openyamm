-- MMMerge map supplement: Silver Helm Outpost Gharik key chest branch.

ReplaceMapEvent(16, "Chest", function()
    if not HasItem(2107) or IsAtLeast(MapVar(4), 1) then -- Key to Gharik's Laboratory
        SetValue(MapVar(4), 1)
        SetQBit(QBit(1035)) -- 11 D7, opens tomb in D18.
        SetQBit(QBit(1223)) -- Quest item bits for seer
        evt.OpenChest(1)
        return
    end

    evt.OpenChest(6)
end, "Chest")
