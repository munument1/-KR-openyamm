-- MMMerge map supplement: Castle Alamos password plate.

ReplaceMapEvent(69, "Legacy event 69", function(continueStep)
    if continueStep == 4 then
        evt.MoveToMap(-3136, 2240, 224, 1024, 0, 0, 0, 0)
        evt.StatusText("Wrong!")
        return
    end

    if continueStep == 23 then
        SetValue(MapVar(6), 1)
        evt.StatusText("Ok!")
        return
    end

    if continueStep ~= nil then
        return
    end

    if IsAtLeast(MapVar(6), 1) then
        return
    end

    evt.SimpleMessage("Restricted area - Keep out.")
    evt.AskQuestion(69, 4, 14, 23, 15, 16, "What's the password?", {"JBARD", "jbard"})
    return nil
end)
