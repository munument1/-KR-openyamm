-- MMMerge supplement: Dimension Door tile and Ravenshore town-portal unlock.

RegisterMapOnLoadEvent(901, "MMMerge Ravenshore travel unlock", function()
    SetQBit(QBit(185)) -- Blood Drop Town Portal
    MM8.SetMapFlag("DimensionDoorTileActive", false)
end)

RegisterMapTimerEvent(902, 1, function()
    MM8.OpenDimensionDoorOnTile(63, 59, "DimensionDoorTileActive")
end, "MMMerge Dimension Door tile")
