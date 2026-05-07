-- MMMerge map supplement: Castle Ironfist local outdoor state.

ReplaceMapEvent(8, "Royal Lines", function()
    evt.EnterHouse(471)
end, "Royal Lines")

ReplaceMapEvent(9, "Royal Lines", function()
    evt.EnterHouse(471)
end, "Royal Lines")

ReplaceMapEvent(42, "King's Library", function()
    if IsQBitSet(QBit(1201)) then
        evt.EnterHouse(1244)
        return
    end

    if HasItem(2081) then
        evt.ShowMovie("archie", false)
        evt.EnterHouse(1244)
        return
    end

    evt.EnterHouse(1215)
end, "King's Library")

ReplaceMapEvent(43, "Throne Room", function()
    MM6.ReturnNicolai()
end, "Throne Room")

ReplaceMapEvent(210, "Legacy event 210", function(continueStep)
    if continueStep == 9 then
        if not IsAtLeast(Gold, 100) then
            evt.SimpleMessage("Well")
            evt.MoveToMap(4856, 10288, 0, 500, 0, 0, 0, 0, "0.")
            return
        end

        SubtractValue(Gold, 100)
        SetValue(MapVar(6), 0)
        return
    end

    if continueStep == 14 then
        evt.SummonMonsters(1, 2, 5, 4920, 12976, 0, 0, 0)
        SetValue(MapVar(6), 0)
        return
    end

    if continueStep == 13 then
        evt.SimpleMessage("Well")
        evt.MoveToMap(4856, 10288, 0, 500, 0, 0, 0, 0, "0.")
        return
    end

    if not IsAtLeast(MapVar(6), 1) then
        return
    end

    evt.CastSpell(98, 1, 1, 5784, 11584, 512, 5784, 11584, 0)
    evt.CastSpell(98, 1, 1, 4312, 11600, 512, 4312, 11600, 0)
    evt.SimpleMessage("All Hit points restored.")
    evt.SimpleMessage("Chest")
    AskQuestionWithAnswerSteps(
        210,
        13,
        "Refreshing!",
        {
            {Answer = "The prince has been kidnapped!  No visitors will be admitted until this crisis has been resolved!", Step = 9},
            {Answer = "Crate", Step = 14},
        })
    return nil
end)
