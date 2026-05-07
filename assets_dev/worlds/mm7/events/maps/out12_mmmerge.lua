-- MMMerge map supplement: Xenofex control cube handoff after entering Land of the Giants.

RemoveMapEvent(1)

RegisterMapOnLoadEvent(65012, "MMMerge out12 Xenofex handoff", function()
    if IsQBitSet(QBit(775)) then
        return
    end

    if not IsQBitSet(QBit(616)) and not IsQBitSet(QBit(635)) then
        return
    end

    SetQBit(QBit(775))

    if IsQBitSet(QBit(616)) then
        evt.SetNPCGreeting(462, 316)
    elseif IsQBitSet(QBit(635)) then
        evt.SetNPCGreeting(462, 317)
    end

    if evt.GetHeldItemId() ~= 0 then
        evt.ClearHeldItem()
    end

    evt.SetHeldItem(866, {identified = true})
    evt.SpeakNPC(462)
end)
