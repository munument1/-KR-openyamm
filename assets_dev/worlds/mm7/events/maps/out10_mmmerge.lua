-- MMMerge supplement: Mount Nighon resident warlocks should not attack town peasants.

RegisterMapOnLoadEvent(65010, "MMerge Mount Nighon resident relations", function()
    local humanPeasants = {360, 361, 362, 363, 364, 365, 366}

    for _, peasantId in ipairs(humanPeasants) do
        evt.SetMonsterRelation(419, peasantId, 0) -- Water Warlock -> Human1 peasant
        evt.SetMonsterRelation(peasantId, 419, 0) -- Human1 peasant -> Water Warlock
    end
end)
