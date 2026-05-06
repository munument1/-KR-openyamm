-- MMMerge map supplement: The Lincoln initial containment field actors.

RegisterMapOnLoadEvent(65023, "MMMerge 7d23 monster group state", function()
    evt.SetMonGroupBit(56, MonsterBits.Hostile, false)
    evt.SetMonGroupBit(56, MonsterBits.Invisible, true)
end)

