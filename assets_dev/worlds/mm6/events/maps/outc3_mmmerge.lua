-- MMMerge map supplement: Mire of the Damned local outdoor state.

ReplaceMapEvent(8, "Darkmoor Travel", function()
    evt.EnterHouse(474)
end, "Darkmoor Travel")

ReplaceMapEvent(9, "Darkmoor Travel", function()
    evt.EnterHouse(474)
end, "Darkmoor Travel")

-- MapVar 11 is the durable state for the Mire cog. Reapply it on load so saves
-- created before outdoor facet attributes were persisted reconstruct the same map.
RegisterMapOnLoadEvent(65031, "Restore Mire cog state", function()
    evt.SetFacetBit(4, FacetBits.Invisible, IsAtLeast(MapVar(11), 1) and 0 or 1)
end)
