-- MMMerge map supplement: Red Dwarf Mines rescued dwarf followers.

local rescuedDwarves = {
    {event = 376, sprite = 1, qbit = 1689, npc = 400},
    {event = 377, sprite = 2, qbit = 1690, npc = 401},
    {event = 378, sprite = 3, qbit = 1691, npc = 402},
    {event = 379, sprite = 4, qbit = 1692, npc = 403},
    {event = 380, sprite = 5, qbit = 1693, npc = 404},
    {event = 381, sprite = 6, qbit = 1694, npc = 405},
    {event = 382, sprite = 7, qbit = 1688, npc = 399},
}

for _, rescue in ipairs(rescuedDwarves) do
    ReplaceMapEvent(rescue.event, "Rescue Dwarf", function()
        if IsQBitSet(QBit(rescue.qbit)) or not HasItem(1431) then -- Elixir
            return
        end

        evt.SetSprite(rescue.sprite, 0, "0")
        SetQBit(QBit(rescue.qbit))
        AddFollowerNpc(rescue.npc)
        evt.SpeakNPC(rescue.npc)
    end, "Statue")
end

RegisterMapOnLoadEvent(65034, "Restore rescued dwarf statues", function()
    for _, rescue in ipairs(rescuedDwarves) do
        if IsQBitSet(QBit(rescue.qbit)) then
            evt.SetSprite(rescue.sprite, 0, "0")
        end
    end
end)
