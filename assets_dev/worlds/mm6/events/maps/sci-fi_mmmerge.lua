-- MMMerge map supplement: Control Center blaster training terminal.

ReplaceMapEvent(61, "Computer Terminal", function()
    for playerIndex = 0, evt.GetPartyMemberCount() - 1 do
        evt.ForPlayer(playerIndex)

        if not IsAtLeast(BlasterSkill, 1) then
            SetValue(BlasterSkill, 1)
        end
    end
end, "Computer Terminal")
