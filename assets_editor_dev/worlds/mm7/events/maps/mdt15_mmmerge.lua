-- MMMerge map supplement: Small House monster item reset after map refill.

RegisterMapRefillHook(65015, "MMMerge Small House refill item reset", function()
    for actorId = 0, 1 do
        evt.SetMonsterItem(actorId, 1477, 1) -- Control Cube
        evt.SetMonsterItem(actorId, 866, 1) -- Blaster
    end
end)
