#include "game/gameplay/ReputationRuntime.h"

#include "game/events/EventRuntime.h"
#include "game/gameplay/GameplayRuntimeInterfaces.h"
#include "game/party/Party.h"
#include "game/tables/MergedBaseTables.h"

#include <algorithm>

namespace OpenYAMM::Game
{
namespace
{
constexpr uint32_t PirateProfessionId = 45;
constexpr uint32_t GypsyProfessionId = 48;
constexpr uint32_t DuperProfessionId = 50;
constexpr uint32_t BurglarProfessionId = 51;
constexpr uint32_t FallenWizardProfessionId = 52;

bool professionHurtsReputation(uint32_t professionId)
{
    switch (professionId)
    {
        case PirateProfessionId:
        case GypsyProfessionId:
        case DuperProfessionId:
        case BurglarProfessionId:
        case FallenWizardProfessionId:
            return true;

        default:
            return false;
    }
}
}

int clampReputation(int value)
{
    return std::clamp(value, MinReputation, MaxReputation);
}

bool continentUsesMergedReputation(const MergedContinentSettingEntry *pContinentSetting)
{
    return pContinentSetting != nullptr
        && (pContinentSetting->reputationAffectsGuards
            || pContinentSetting->reputationAffectsShops
            || pContinentSetting->reputationAffectsNpc);
}

int hiredNpcReputationPenalty(const EventRuntimeState &runtimeState)
{
    int penalty = 0;

    for (const HiredNpcFollower &follower : runtimeState.hiredNpcFollowers)
    {
        if (professionHurtsReputation(follower.professionId))
        {
            penalty += 5;
        }
    }

    return penalty;
}

int effectivePartyReputation(int storedReputation, const EventRuntimeState *pRuntimeState)
{
    if (pRuntimeState == nullptr)
    {
        return storedReputation;
    }

    return storedReputation + hiredNpcReputationPenalty(*pRuntimeState);
}

void applyReputationGuardHostility(IGameplayWorldRuntime &worldRuntime, int hostileThreshold)
{
    EventRuntimeState *pRuntimeState = worldRuntime.eventRuntimeState();

    if (pRuntimeState == nullptr)
    {
        return;
    }

    const int effectiveReputation =
        effectivePartyReputation(worldRuntime.currentLocationReputation(), pRuntimeState);

    if (effectiveReputation >= hostileThreshold)
    {
        pRuntimeState->actorGroupHostilityRequests[38] = true;
        pRuntimeState->actorGroupHostilityRequests[55] = true;
        worldRuntime.applyEventRuntimeState(true);
    }
    else if (effectiveReputation <= 20)
    {
        pRuntimeState->actorGroupHostilityRequests[38] = false;
        pRuntimeState->actorGroupHostilityRequests[55] = false;
        worldRuntime.applyEventRuntimeState(true);
    }
}

void addStoredCurrentLocationReputation(IGameplayWorldRuntime &worldRuntime, int delta)
{
    if (delta == 0)
    {
        return;
    }

    worldRuntime.setCurrentLocationReputation(clampReputation(worldRuntime.currentLocationReputation() + delta));
    applyReputationGuardHostility(worldRuntime, delta > 0 ? 20 : 25);
}

PeasantKillReputationResult applyPeasantKillReputationPenalty(
    IGameplayWorldRuntime &worldRuntime,
    Party *pParty,
    const MonsterTable::MonsterStatsEntry *pStats,
    int baseStealingFine)
{
    PeasantKillReputationResult result = {};

    if (pStats == nullptr || !pStats->hasKind(MonsterKind::Peasant))
    {
        return result;
    }

    result.applied = true;
    result.reputationDelta = 1;

    if (pParty != nullptr)
    {
        const int effectiveReputation =
            effectivePartyReputation(worldRuntime.currentLocationReputation(), worldRuntime.eventRuntimeState());
        result.fineDelta = std::clamp(
            100 * (std::max(0, baseStealingFine) + std::max(0, pStats->level) + effectiveReputation),
            0,
            4000000);

        if (result.fineDelta > 0)
        {
            pParty->addFineGold(result.fineDelta);
        }
    }

    addStoredCurrentLocationReputation(worldRuntime, result.reputationDelta);
    return result;
}

ReputationLevel reputationLevel(int effectiveReputation)
{
    if (effectiveReputation >= 25)
    {
        return ReputationLevel::Notorious;
    }

    if (effectiveReputation >= 6)
    {
        return ReputationLevel::Unfriendly;
    }

    if (effectiveReputation >= -5)
    {
        return ReputationLevel::Neutral;
    }

    if (effectiveReputation >= -24)
    {
        return ReputationLevel::Friendly;
    }

    return ReputationLevel::Saintly;
}

std::string reputationLabel(int effectiveReputation)
{
    switch (reputationLevel(effectiveReputation))
    {
        case ReputationLevel::Saintly:
            return "Saintly";

        case ReputationLevel::Friendly:
            return "Friendly";

        case ReputationLevel::Neutral:
            return "Neutral";

        case ReputationLevel::Unfriendly:
            return "Unfriendly";

        case ReputationLevel::Notorious:
            return "Notorious";
    }

    return "Neutral";
}
}
