-- MMMerge supplement: clear-land quest completion checks are independent of the Riki spawn workaround.

AppendMapEvent(131, function()
    if not IsQBitSet(QBit(22)) -- Allied with Dragons. Return Dragon Egg to Dragons done.
        and not IsQBitSet(QBit(155)) -- Killed all Dragons in Garrote Gorge Area
        and evt.CheckMonstersKilled(ActorKillCheck.MonsterId, 189, 0, false)
        and evt.CheckMonstersKilled(ActorKillCheck.MonsterId, 190, 0, false)
        and evt.CheckMonstersKilled(ActorKillCheck.MonsterId, 191, 0, false) then
        SetQBit(QBit(155)) -- Killed all Dragons in Garrote Gorge Area
        evt.StatusText("You have killed all of the Dragons")
    end

    if not IsQBitSet(QBit(21)) -- Allied with Charles Quioxte's Dragon Hunters. Return Dragon Egg to Quixote done.
        and not IsQBitSet(QBit(158)) -- Killed all Dragon Hunters in Garrote Gorge wilderness area
        and evt.CheckMonstersKilled(ActorKillCheck.MonsterId, 42, 0, false)
        and evt.CheckMonstersKilled(ActorKillCheck.MonsterId, 43, 0, false)
        and evt.CheckMonstersKilled(ActorKillCheck.MonsterId, 44, 0, false) then
        SetQBit(QBit(158)) -- Killed all Dragon Hunters in Garrote Gorge wilderness area
        evt.StatusText("You have killed all of the Dragon Hunters")
    end
end)
