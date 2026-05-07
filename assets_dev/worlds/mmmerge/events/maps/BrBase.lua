-- Shared MMMerge custom content: Breach basement.

RegisterEvent(1, "Exit Breach Basement", function()
    evt.SetGlobalVar("MMerge.CrossContinents.EnteredBreach", 1)

    if evt.GetGlobalVar("MMerge.CrossContinents.QuestFinished") ~= 0 then
        evt.MoveToMap(1578, 899, 847, 1160, 0, 0, 0, 0, "Breach.odm")
        return
    end

    evt.MoveToMap(1578, 899, 847, 1160, 0, 0, 0, 0, "BrAlvar.odm")
end, "Exit Breach Basement")

RegisterEvent(2, "Breach Descent", function()
    if evt.GetGlobalVar("MMerge.CrossContinents.QuestFinished") == 0 then
        evt.FaceAnimation(FaceAnimation.DoorLocked)
    end
end, "Breach Descent")

RegisterMapOnLoadEvent(66003, "MMMerge BrBase state", function()
    evt.SetGlobalVar("MMerge.CrossContinents.EnteredBasement", 1)
end)
