-- MMMerge supplement: Castle Lambent throne-room faction gate.

ReplaceMapEvent(416, "Enter the Throne Room", function()
    MM7.EnterCastleLambentThroneRoom()
end, "Enter the Throne Room")

RegisterMapOnLoadEvent(65072, "MMMerge CrossContinents Antagarich completion", function()
    MM7.MarkCrossContinentAntagarichIfComplete()
end)
