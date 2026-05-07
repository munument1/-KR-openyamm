-- MMMerge supplement: Deyja local monster relations and post-NPC ambush.

RegisterMapOnLoadEvent(65005, "MMMerge Deyja local hostility", function()
    MM7.UpdateDeyjaOutdoorState()
end)

RegisterNpcExitHook(65006, "MMMerge Deyja ambush", function(context)
    MM7.SummonDeyjaAmbushIfNeeded(context)
end)
