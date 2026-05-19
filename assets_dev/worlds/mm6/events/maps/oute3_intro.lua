-- New Sorpigal initial cutscene.

RegisterMapOnLoadEvent(65030, "MM6 initial cutscene", function()
    if evt.GetGlobalVar("OpenYAMM.WorldIntro.MM6", 0) ~= 0 then
        return
    end

    evt.SetGlobalVar("OpenYAMM.WorldIntro.MM6", 1)
    evt.ShowMovie("6intro", true)
end)
