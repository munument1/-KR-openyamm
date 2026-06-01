-- MMMerge supplement: were-rat hostility is map-local and cools down after a day.

local WereratsMad = "WereratsMad"
local WereratsMadUntil = "WereratsMadUntil"

ReplaceMapEvent(1, "MMMerge were-rat state", function()
    if MM8.GetMapFlag(WereratsMad) and CurrentGameMinutes() >= MM8.GetMapVar(WereratsMadUntil, 0) then
        MM8.SetMapFlag(WereratsMad, false)
    end

    if not IsQBitSet(QBit(10)) or MM8.GetMapFlag(WereratsMad) then -- Letter from Q Bit 9 delivered.
        SetValue(MapVar(11), 2)
        evt.SetMonGroupBit(8, MonsterBits.Hostile, 1)
        evt.SetMonGroupBit(10, MonsterBits.Hostile, 1)
        evt.SetMonGroupBit(11, MonsterBits.Hostile, 1)
        evt.SetMonGroupBit(8, MonsterBits.Invisible, 0)
        evt.SetMonGroupBit(11, MonsterBits.Invisible, 1)
    else
        evt.SetMonGroupBit(8, MonsterBits.Hostile, 0)
        evt.SetMonGroupBit(10, MonsterBits.Hostile, 0)
        evt.SetMonGroupBit(11, MonsterBits.Hostile, 0)
        evt.SetMonGroupBit(8, MonsterBits.Invisible, 1)
        evt.SetMonGroupBit(11, MonsterBits.Invisible, 0)
    end
end)
AppendMapOnLoadEvent(1)

RegisterMapTimerEvent(901, 60, function()
    if MM8.GetMapFlag(WereratsMad) then
        return
    end

    if evt.CheckMonstersKilled(ActorKillCheck.Group, 8, 1, false)
        or evt.CheckMonstersKilled(ActorKillCheck.Group, 10, 1, false)
        or evt.CheckMonstersKilled(ActorKillCheck.Group, 11, 1, false) then
        MM8.SetMapFlag(WereratsMad, true)
        MM8.SetMapVar(WereratsMadUntil, CurrentGameMinutes() + MM8.MinutesPerDay)
    end
end, "MMMerge were-rat kill tracker")
