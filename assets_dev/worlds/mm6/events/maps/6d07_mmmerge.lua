-- MMMerge map supplement: Silver Helm Outpost Gharik key chest branch.

ReplaceMapEvent(16, "Chest", function()
    if IsAtLeast(MapVar(4), 1) then
        evt.OpenChest(1)
        return
    end

    local alreadyHasKey = HasItemAnywhere(2107) -- Key to Gharik's Laboratory
    SetValue(MapVar(4), 1)
    SetQBit(QBit(1035)) -- 11 D7, opens tomb in D18.
    SetQBit(QBit(1223)) -- Quest item bits for seer
    evt.OpenChest(alreadyHasKey and 6 or 1)
end, "Chest")
