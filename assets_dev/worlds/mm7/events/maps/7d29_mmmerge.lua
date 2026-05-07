-- MMMerge supplement: Castle Harmondale local quest state.

local previousMapEvent376 = evt.map[376]
ReplaceMapEvent(376, "MMMerge Golem follower cleanup", function(...)
    if previousMapEvent376 ~= nil then
        previousMapEvent376(...)
    end

    MM7.RemoveGolemFollowerIfConstructed()
end)

RemoveMapEvent(377)
RegisterMapOnLoadEvent(377, "MMMerge Harmondale mercenary invasion state", function()
    MM7.UpdateCastleHarmondaleMercenariesOnLoad()
    MM7.MarkCrossContinentAntagarichIfComplete()
end)

RegisterMapOnLeaveEvent(65029, "MMMerge Harmondale mercenary completion", function()
    MM7.MarkCastleHarmondaleMercenariesKilledIfClear()
end)

RegisterRestFoodCostHook(65030, "MMMerge Castle Harmondale free rest", function(context)
    MM7.MakeCastleHarmondaleRestFreeIfRebuilt(context)
end)
