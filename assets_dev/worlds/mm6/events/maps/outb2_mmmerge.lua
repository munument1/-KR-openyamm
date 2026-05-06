-- MMMerge map supplement: Blackshire local outdoor state.

RegisterMapOnLoadEvent(65024, "MMMerge outb2 town portal and guards", function()
    SetQBit(QBit(310)) -- Blackshire town portal destination discovered.
    MM6.ApplyLocalMonsterRelations({
        {196, 0, 0},
    })
    evt.SetMonGroupBit(39, MonsterBits.Hostile, false)
    MM6.ApplyDragonTowerState(1184, 61, 42)
end)

table.insert(evt.meta.map.textureNames, "t1swbu")

ReplaceMapEvent(10, "Blackshire Coach and Buggy", function()
    evt.EnterHouse(478)
end, "Blackshire Coach and Buggy")

ReplaceMapEvent(11, "Blackshire Coach and Buggy", function()
    evt.EnterHouse(478)
end, "Blackshire Coach and Buggy")

MM6.RegisterDragonTowerTimer(210, -17921, 9724, 2742, 1184)

ReplaceMapEvent(211, "Dragon Tower", function()
    MM6.TryDisableDragonTower(1184, 61, 42)
end)
