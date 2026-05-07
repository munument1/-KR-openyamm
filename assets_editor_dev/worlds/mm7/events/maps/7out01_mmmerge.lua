-- MMMerge supplement: Emerald Island taverns do not offer Arcomage.

RegisterHouseTopicFilter(65001, "MMMerge Emerald Island tavern topics", function(context)
    MM7.FilterTavernTopicsWithoutArcomage(context)
end)
