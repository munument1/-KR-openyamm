-- MMMerge map supplement: Kriegspire local outdoor state.

SetMapContextAction(90, {
    kind = "enter_house",
    source = "override",
    targetMap = "6t7.blv",
    targetName = "Superior Temple of Baa",
})

ReplaceMapEvent(8, "King's Highway", function()
    evt.EnterHouse(477)
end, "King's Highway")

ReplaceMapEvent(9, "King's Highway", function()
    evt.EnterHouse(477)
end, "King's Highway")
