-- MMMerge supplement: Erathia transport and scavenger advertisement triggers.

RegisterMapOnLoadEvent(65005, "MMMerge Erathia contest transport", function()
    if IsQBitSet(QBit(519)) then -- Finished Scavenger Hunt
        evt.SetTransportRouteOverride(462, 4, {
            destinationName = "Bracada Desert",
            mapFileName = "7Out06.odm",
            daysAvailable = {false, false, true, false, false, false, false},
            travelDays = 6,
            x = 19171,
            y = -19722,
            z = 193,
            directionDegrees = 180,
        })
    else
        evt.SetTransportRouteOverride(462, 4, {
            destinationName = "Emerald Island",
            mapFileName = "7Out01.odm",
            daysAvailable = {false, false, true, false, false, false, false},
            travelDays = 6,
            x = 12552,
            y = 800,
            z = 193,
            directionDegrees = 90,
        })
    end
end)

RegisterMapTimerEvent(65004, 180, function()
    MM7.GiveScavengerAdvertisementIfNear(-10511, 6119, false)
end, "MMMerge Erathia scavenger advertisement")
