-- MMMerge supplement: Harmondale outdoor castle, judge, invasion, and scavenger repairs.

ReplaceMapEvent(37, "Arbiter follower cleanup", function()
    MM7.RemoveJudgeFollowers()
end, "Arbiter")

ReplaceMapEvent(301, "Enter Castle Harmondale", function()
    MM7.EnterCastleHarmondaleOutdoor()
end, "Enter Castle Harmondale")

RegisterMapOnLoadEvent(65002, "MMMerge Harmondale judge and invasion state", function()
    MM7.UpdateCrossContinentsState()
    MM7.UpdateHarmondaleInvasion()
    MM7.UpdateJudgeGreyDeath()
end)

RegisterMapTimerEvent(65003, 180, function()
    MM7.GiveScavengerAdvertisementIfNear(-13115, 12497, true)
end, "MMMerge Harmondale scavenger advertisement")
