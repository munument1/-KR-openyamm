#pragma once

#include "game/tables/MonsterTable.h"

#include <cstdint>
#include <string>

namespace OpenYAMM::Game
{
struct EventRuntimeState;
class IGameplayWorldRuntime;
struct MergedContinentSettingEntry;
class Party;

struct PeasantKillReputationResult
{
    bool applied = false;
    int fineDelta = 0;
    int reputationDelta = 0;
};

enum class ReputationLevel : uint8_t
{
    Saintly,
    Friendly,
    Neutral,
    Unfriendly,
    Notorious,
};

constexpr int MinReputation = -10000;
constexpr int MaxReputation = 10000;

int clampReputation(int value);
bool continentUsesMergedReputation(const MergedContinentSettingEntry *pContinentSetting);
int hiredNpcReputationPenalty(const EventRuntimeState &runtimeState);
int effectivePartyReputation(int storedReputation, const EventRuntimeState *pRuntimeState);
void applyReputationGuardHostility(IGameplayWorldRuntime &worldRuntime, int hostileThreshold = 25);
void addStoredCurrentLocationReputation(IGameplayWorldRuntime &worldRuntime, int delta);
PeasantKillReputationResult applyPeasantKillReputationPenalty(
    IGameplayWorldRuntime &worldRuntime,
    Party *pParty,
    const MonsterTable::MonsterStatsEntry *pStats,
    int baseStealingFine,
    bool actorHasNpcId = true);
ReputationLevel reputationLevel(int effectiveReputation);
std::string reputationLabel(int effectiveReputation);
}
