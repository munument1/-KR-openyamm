-- MMMerge supplement: Tularean Forest Dimension Door and artifact battle repairs.

RegisterEvent(504, "Dimension Door", function()
    MM7.OpenDimensionDoor()
end, "Dimension Door")

RemoveMapEvent(401)
RegisterMapOnLoadEvent(401, "MMMerge Tularean artifact messenger", function()
    MM7.UpdateTulareanArtifactBattle()
end)

ReplaceMapEvent(503, "Enter Clanker's Laboratory", function()
    MM7.EnterClankersLaboratory()
end, "Enter Clanker's Laboratory")
