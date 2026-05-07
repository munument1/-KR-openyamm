-- MMMerge map supplement: Red Dwarf Mines rescued dwarf followers.

for offset = 0, 5 do
    ReplaceMapEvent(376 + offset, "Rescue Dwarf", function()
        if HasItem(1431) then -- Elixir
            AddFollowerNpc(400 + offset)
        end
    end, "Statue")
end

ReplaceMapEvent(382, "Rescue Dwarf", function()
    if HasItem(1431) then -- Elixir
        AddFollowerNpc(399)
    end
end, "Statue")
