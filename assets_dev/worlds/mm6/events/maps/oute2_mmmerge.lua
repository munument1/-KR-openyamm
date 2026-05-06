-- MMMerge map supplement: Misty Islands local outdoor state.

RegisterMapOnLoadEvent(65028, "MMMerge oute2 town portal", function()
    SetQBit(QBit(312)) -- Mist town portal destination discovered.
    MM6.ApplyLocalMonsterRelations({
        {211, 0, 0},
        {204, 0, 0},
        {211, 205, 2},
        {205, 211, 1},
        {211, 201, 2},
        {201, 211, 1},
        {211, 202, 2},
        {202, 211, 1},
    })
    MM6.ApplyDragonTowerState(1181, 53, 42)
end)

table.insert(evt.meta.map.textureNames, "t1swbu")

MM6.RegisterDragonTowerTimer(210, 3039, -9201, 2818, 1181)

ReplaceMapEvent(211, "Dragon Tower", function()
    MM6.TryDisableDragonTower(1181, 53, 42)
end)
