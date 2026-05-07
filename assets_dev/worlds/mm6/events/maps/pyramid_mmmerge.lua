-- MMMerge map supplement: restore MM6 VARN code event variable layout.

local function allCrewCodesEntered()
    return IsAtLeast(MapVar(10), 1)
        and IsAtLeast(MapVar(11), 1)
        and IsAtLeast(MapVar(12), 1)
        and IsAtLeast(MapVar(13), 1)
        and IsAtLeast(MapVar(14), 1)
end

local function registerCrewCodeEvent(eventId, itemId, mapVarIndex, qbit, answer, wrongFace, promptText, answerTextId)
    ReplaceMapEvent(eventId, "Cleansing Pool", function(continueStep)
        if continueStep == 5 then
            evt.StatusText("Incorrect.")
            evt.FaceExpression(wrongFace)
            SubtractValue(CurrentHealth, 5)
            return
        end

        if continueStep == 9 then
            SetValue(MapVar(mapVarIndex), 1)

            if allCrewCodesEntered() then
                SetValue(MapVar(27), 1)
            end

            evt.ForPlayer(Players.All)
            RemoveItem(itemId)
            ClearQBit(QBit(qbit))
            return
        end

        if continueStep ~= nil then
            return
        end

        SetValue(MapVar(0), 0)

        if not HasItem(itemId) then
            return
        end

        evt.SimpleMessage(promptText)
        evt.AskQuestion(eventId, 5, 44, 9, answerTextId, answerTextId, "Answer?  ", {answer, answer})
        return nil
    end, "Cleansing Pool")
end

ReplaceMapEvent(1, "Well of VARN", function(continueStep)
    if continueStep == 10 then
        evt.StatusText("Incorrect.")
        evt.FaceExpression(44)
        SubtractValue(CurrentHealth, 5)
        return
    end

    if continueStep == 14 then
        SetValue(MapVar(15), 1)
        evt.ForPlayer(Players.All)
        RemoveItem(2157) -- Captain's Code
        ClearQBit(QBit(1255))
        evt.SetDoorState(1, DoorAction.Close)
        evt.StatusText("The waters part.")
        return
    end

    if continueStep ~= nil then
        return
    end

    SetValue(MapVar(0), 0)

    if not HasItem(2157) then
        return
    end

    if not IsAtLeast(MapVar(27), 1) then
        evt.StatusText("Access Denied.  All codes must be entered first.")
        SubtractValue(CurrentHealth, 25)
        evt.FaceExpression(35)
        return
    end

    evt.SimpleMessage("What is the Captain's code?")
    evt.AskQuestion(1, 10, 44, 14, 43, 43, "Answer?  ", {"kriK", "kriK"})
    return nil
end, "Well of VARN")

registerCrewCodeEvent(21, 2158, 10, 1253, "kcopS", 48, "What is the first mate's code?", 33)
registerCrewCodeEvent(22, 2159, 11, 1256, "uluS", 33, "What is the navigator's code?", 35)
registerCrewCodeEvent(23, 2160, 12, 1258, "aruhU", 50, "What is the communication officer's code?", 37)
registerCrewCodeEvent(24, 2161, 13, 1257, "yttocS", 46, "What is the engineer's code?", 39)
registerCrewCodeEvent(25, 2162, 14, 1254, "yoccM", 13, "What is the doctor's code?", 41)

ReplaceMapEvent(26, "Books", function()
    if IsAtLeast(MapVar(25), 1) then
        return
    end

    SetQBit(QBit(1258))
    AddValue(InventoryItem(2160), 2160) -- Communication Officer's Code
    SetValue(MapVar(25), 1)
end, "Books")

ReplaceMapEvent(27, "Books", function()
    if IsAtLeast(MapVar(26), 1) then
        return
    end

    SetQBit(QBit(1257))
    AddValue(InventoryItem(2161), 2161) -- Engineer's Code
    SetValue(MapVar(26), 1)
end, "Books")

ReplaceMapEvent(35, "Control Room Entry", function()
    if IsAtLeast(MapVar(15), 1) then
        evt.SetDoorState(39, DoorAction.Close)
        evt.SetDoorState(40, DoorAction.Close)
    end
end, "Control Room Entry")
