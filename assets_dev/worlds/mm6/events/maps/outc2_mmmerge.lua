-- MMMerge map supplement: Free Haven local outdoor state.

RegisterMapOnLoadEvent(65026, "MMMerge outc2 town portal", function()
    SetQBit(QBit(311)) -- Free Haven town portal destination discovered.
    MM6.ApplyDragonTowerState(1183, 25, 55)
end)

table.insert(evt.meta.map.textureNames, "t1swbu")

ReplaceMapEvent(14, "Free Haven Travel East", function()
    evt.EnterHouse(472)
end, "Free Haven Travel East")

ReplaceMapEvent(15, "Free Haven Travel East", function()
    evt.EnterHouse(472)
end, "Free Haven Travel East")

ReplaceMapEvent(16, "Free Haven Travel West", function()
    evt.EnterHouse(473)
end, "Free Haven Travel West")

ReplaceMapEvent(17, "Free Haven Travel West", function()
    evt.EnterHouse(473)
end, "Free Haven Travel West")

ReplaceMapEvent(19, "Free Haven Temple", function()
    MM6.RepairStoneTemple()
end, "Free Haven Temple")

ReplaceMapEvent(49, "High Council", function()
    MM6.RevealSilvertongue()
end, "High Council")

ReplaceMapEvent(50, "High Council", function()
    MM6.RevealSilvertongue()
end, "High Council")

ReplaceMapEvent(140, "The Adventurer's Inn", function()
    evt.EnterHouse(1607)
end, "The Adventurer's Inn")

MM6.RegisterDragonTowerTimer(209, 3823, 10974, 2700, 1183)

ReplaceMapEvent(210, "Dragon Tower", function()
    MM6.TryDisableDragonTower(1183, 25, 55)
end)
