-- MMMerge supplement: Castle Harmondale local quest state.

AppendMapEvent(376, function()
    MM7.RemoveGolemFollowerIfConstructed()
end)

RemoveMapEvent(377)
RegisterMapOnLoadEvent(377, "MMMerge Harmondale mercenary invasion state", function()
    MM7.HideCastleHarmondaleGoblinsIfRebuilt()
    MM7.UpdateCastleHarmondaleMercenariesOnLoad()
    MM7.MarkCrossContinentAntagarichIfComplete()
end)

RegisterMapOnLeaveEvent(65029, "MMMerge Harmondale mercenary completion", function()
    MM7.MarkCastleHarmondaleMercenariesKilledIfClear()
end)

RegisterRestFoodCostHook(65030, "MMMerge Castle Harmondale free rest", function(context)
    MM7.MakeCastleHarmondaleRestFreeIfRebuilt(context)
end)
