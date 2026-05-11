-- MMMerge map supplement: New Sorpigal local outdoor state.

RegisterMapOnLoadEvent(65029, "MMMerge oute3 town portal", function()
    SetQBit(QBit(313)) -- New Sorpigal town portal destination discovered.
    MM6.ApplyLocalMonsterRelations({
        {185, 0, 0},
    })
    MM6.ApplyDragonTowerState(1180, 84, 42)
end)

table.insert(evt.meta.map.textureNames, "t1swbu")

ReplaceMapEvent(15, "New Sorpigal Coach Company", function()
    evt.EnterHouse(470)
end, "New Sorpigal Coach Company")

ReplaceMapEvent(16, "New Sorpigal Coach Company", function()
    evt.EnterHouse(470)
end, "New Sorpigal Coach Company")

AppendMapEvent(140, function()
    if not evt.Cmp(MapVar(50), 1) then
        MM6.OpenDimensionDoor()
    end
end)

ReplaceMapEvent(220, "Volcano", function()
    MM6.RunNewSorpigalVolcanoSequence()
end, "Volcano")

MM6.RegisterDragonTowerTimer(230, -6152, -9208, 2700, 1180)

ReplaceMapEvent(231, "Dragon Tower", function()
    MM6.TryDisableDragonTower(1180, 84, 42)
end)
