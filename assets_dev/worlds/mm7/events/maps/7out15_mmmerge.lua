-- MMMerge supplement: Shoals underwater action and surfacing behavior.

RegisterGameplayActionHook(65016, "MMMerge Shoals underwater action gate", function(context)
    MM7.BlockShoalsUnderwaterAction(context)
end)

RegisterMapOnLoadEvent(65018, "MMMerge Shoals portrait cleanup", function()
    MM7.ApplyShoalsPartyPortraits()
end)

RegisterMapOnLeaveEvent(65019, "MMMerge Shoals party portrait restore", function()
    MM7.RestoreShoalsPartyPortraits()
end)

RegisterMapTimerEvent(65017, 0.25, function()
    MM7.LeaveShoalsIfAboveWater()
    MM7.KillUnsuitedShoalsPartyMembers()
end, "MMMerge Shoals surfacing travel")
