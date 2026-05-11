-- MMMerge supplement: Evenmorn obelisk treasure and Dimension Door trigger.

AppendMapEvent(6, function()
    MM7.OpenDimensionDoor()
end)

RegisterMapOnLoadEvent(65009, "MMMerge Evenmorn obelisk treasure", function()
    MM7.UpdateEvenmornObeliskTreasure()
end)

RegisterMapTimerEvent(65010, 180, function()
    MM7.OpenEvenmornDimensionDoorIfNear()
end, "MMMerge Evenmorn Dimension Door proximity")
