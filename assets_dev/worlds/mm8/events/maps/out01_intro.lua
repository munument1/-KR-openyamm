-- Dagger Wound Island initial cutscene.

RegisterMapOnLoadEvent(65030, "MM8 initial cutscene", function()
    if evt.GetGlobalVar("OpenYAMM.WorldIntro.MM8", 0) ~= 0 then
        return
    end

    evt.SetGlobalVar("OpenYAMM.WorldIntro.MM8", 1)
    evt.ShowMovie("intro", true)
end)
