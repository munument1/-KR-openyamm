-- Shared MMMerge custom content: Controlled Breach Alvar facade.

RegisterEvent(53, "Enter Breach Basement", function()
    evt.SetGlobalVar("MMerge.CrossContinents.EnteredBasement", 0)
    evt.MoveToMap(0, 0, 0, 0, 0, 0, 710, 3, "BrBase.blv")
end, "Enter Breach Basement")

RegisterEvent(54, "Enter Breach Basement", function()
    evt.MoveToMap(0, 0, 0, 0, 0, 0, 711, 2, "BrBase.blv")
end, "Enter Breach Basement")

RegisterEvent(81, "Return To The Breach", function()
    if evt.GetGlobalVar("MMerge.CrossContinents.CaughtChaos") ~= 0 then
        evt.MoveToMap(-841, -475, 4501, 176, 0, 0, 0, 0, "Breach.odm")
    end
end, "Return To The Breach")

RegisterMapOnLoadEvent(66002, "MMMerge BrAlvar state", function()
    if evt.GetGlobalVar("MMerge.CrossContinents.GotFinalQuest") == 0 then
        evt.SetGlobalVar("MMerge.CrossContinents.GotFinalQuest", 1)
    end
end)
