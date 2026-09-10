-- MMMerge supplement: clear-land quest completion checks are independent of the Riki spawn workaround.

local function updateClearLandQuests()
    local completionText

    if not IsQBitSet(QBit(22)) -- Allied with Dragons. Return Dragon Egg to Dragons done.
        and not IsQBitSet(QBit(155)) -- Killed all Dragons in Garrote Gorge Area
        and evt.CheckMonstersKilled(ActorKillCheck.MonsterId, 189, 0, false)
        and evt.CheckMonstersKilled(ActorKillCheck.MonsterId, 190, 0, false)
        and evt.CheckMonstersKilled(ActorKillCheck.MonsterId, 191, 0, false) then
        SetQBit(QBit(155)) -- Killed all Dragons in Garrote Gorge Area
        completionText = "You have killed all of the Dragons"
    end

    if not IsQBitSet(QBit(21)) -- Allied with Charles Quioxte's Dragon Hunters. Return Dragon Egg to Quixote done.
        and not IsQBitSet(QBit(158)) -- Killed all Dragon Hunters in Garrote Gorge wilderness area
        and evt.CheckMonstersKilled(ActorKillCheck.MonsterId, 42, 0, false)
        and evt.CheckMonstersKilled(ActorKillCheck.MonsterId, 43, 0, false)
        and evt.CheckMonstersKilled(ActorKillCheck.MonsterId, 44, 0, false) then
        SetQBit(QBit(158)) -- Killed all Dragon Hunters in Garrote Gorge wilderness area
        completionText = "You have killed all of the Dragon Hunters"
    end

    if not IsQBitSet(QBit(75))
        and evt.CheckMonstersKilled(ActorKillCheck.Group, 24, 0, false) then
        SetQBit(QBit(75)) -- Cleared the southwest Dragon Slayer training camp.
        completionText = completionText or "You have cleared the Dragon Slayer training camp"
    end

    if not IsQBitSet(QBit(200))
        and evt.CheckMonstersKilled(ActorKillCheck.UniqueNameId, 2, 1, false) then
        SetQBit(QBit(200)) -- Whistlebone's sword can now be recovered through lost-item dialogue.
    end

    if completionText then
        evt.StatusText(completionText)
        -- Hidden completion bits do not announce journal changes. Celebrate explicitly for the whole party.
        evt.QuestCompleteFeedback()
    end
end

AppendMapEvent(131, updateClearLandQuests)

RegisterMonsterKilledHook(65031, "Garrote Gorge clearance after a kill", function(context)
    -- Hook IDs are monster-table IDs; legacy CheckMonstersKilled uses zero-based event IDs.
    if (context.monsterId >= 43 and context.monsterId <= 45)
        or (context.monsterId >= 190 and context.monsterId <= 192) then
        updateClearLandQuests()
    end
end)
