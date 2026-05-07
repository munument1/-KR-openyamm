-- MMMerge supplement: Castle Harmondale local quest state.

local function appendMapEvent(eventId, title, handler)
    local previousHandler = evt.map[eventId]

    ReplaceMapEvent(eventId, title, function(...)
        if previousHandler ~= nil then
            previousHandler(...)
        end

        handler(...)
    end)
end

appendMapEvent(376, "MMMerge Golem follower cleanup", function()
    MM7.RemoveGolemFollowerIfConstructed()
end)

RemoveMapEvent(377)
RegisterMapOnLoadEvent(377, "MMMerge Harmondale mercenary invasion state", function()
    MM7.UpdateCastleHarmondaleMercenariesOnLoad()
end)

RegisterMapOnLeaveEvent(65029, "MMMerge Harmondale mercenary completion", function()
    MM7.MarkCastleHarmondaleMercenariesKilledIfClear()
end)

RegisterRestFoodCostHook(65030, "MMMerge Castle Harmondale free rest", function(context)
    MM7.MakeCastleHarmondaleRestFreeIfRebuilt(context)
end)
