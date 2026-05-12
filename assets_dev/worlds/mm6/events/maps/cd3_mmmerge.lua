-- MMMerge map supplement: Castle Kriegspire guardian and curator.

ReplaceMapEvent(13, "Guardian of Kriegspire", function(continueStep)
    if continueStep == 3 then
        evt.StatusText("Get Lost!")
        return
    end

    if continueStep == 5 then
        if not IsAtLeast(Gold, 50000) then
            evt.StatusText("Get Lost!")
            return
        end

        SubtractValue(Gold, 50000)
        evt.MoveToMap(13487, 3117, 673, 0, 0, 0, 0, 0)
        return
    end

    if continueStep ~= nil then
        return
    end

    if IsQBitSet(QBit(1364)) then
        evt.MoveToMap(13487, 3117, 673, 0, 0, 0, 0, 0)
        return
    end

    evt.SimpleMessage("\"The Guardian of Kriegspire proclaims, 'For 50,000 gold, the secret will be revealed!'\"")
    evt.AskQuestion(13, 3, 10, 5, 11, 12, "Accept (Yes/No)?", {"Yes", "Y"})
    return nil
end, "Guardian of Kriegspire")

ReplaceMapEvent(27, "Curator of Kriegspire", function(continueStep)
    if continueStep == 2 then
        evt.StatusText("Get Lost!")
        return
    end

    if continueStep == 4 then
        if not IsAtLeast(Gold, 10000) then
            evt.StatusText("Get Lost!")
            return
        end

        SubtractValue(Gold, 10000)
        AddValue(ReputationInCurrentLocation, 50)
        evt.ForPlayer(Players.All)
        SetValue(MajorCondition, 0)
        AddValue(HasFullHP, 0)
        AddValue(HasFullSP, 0)
        return
    end

    if continueStep ~= nil then
        return
    end

    evt.SimpleMessage("\"The Curator of Kriegspire proclaims, 'For 10,000 gold you shall be healed.'\"")
    evt.AskQuestion(27, 2, 10, 4, 11, 12, "Accept (Yes/No)?", {"Yes", "Y"})
    return nil
end, "Curator of Kriegspire")
