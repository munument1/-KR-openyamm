#pragma once

#include "game/tables/MonsterTable.h"
#include "game/tables/MergedBaseTables.h"

#include <cstdint>
#include <optional>
#include <string>
#include <vector>

namespace OpenYAMM::Game
{
struct BountyHuntEntry
{
    uint32_t month = 0;
    int16_t monsterId = 0;
    bool done = false;
    bool claimed = false;
};

struct BountyHuntClaimResult
{
    bool claimed = false;
    uint32_t goldReward = 0;
    int32_t reputationDelta = 0;
    uint32_t bountyTotalDelta = 0;
};

class IGameplayWorldRuntime;
class Party;

uint32_t bountyHuntRewardForMonster(const MonsterTable::MonsterStatsEntry &stats);
bool bountyHuntMonsterAllowed(
    const MonsterTable::MonsterStatsEntry &stats,
    const MergedBolsterMonsterTable *pBolsterMonsterTable,
    uint32_t maximumLevel);
std::vector<int16_t> collectBountyHuntMonsterIds(
    const MonsterTable &monsterTable,
    const MergedBolsterMonsterTable *pBolsterMonsterTable,
    uint32_t maximumLevel);
std::optional<int16_t> chooseBountyHuntMonsterId(
    const MonsterTable &monsterTable,
    const MergedBolsterMonsterTable *pBolsterMonsterTable,
    uint32_t maximumLevel,
    uint32_t seed);
bool bountyHuntEntryExpired(const BountyHuntEntry &entry, uint32_t currentMonth);
bool markBountyHuntMonsterKilled(BountyHuntEntry &entry, int16_t monsterId, uint32_t currentMonth);
BountyHuntClaimResult claimBountyHuntReward(
    BountyHuntEntry &entry,
    const MonsterTable &monsterTable,
    uint32_t currentMonth,
    bool awardGold);
bool markRuntimeBountyHuntMonsterKilled(IGameplayWorldRuntime &worldRuntime, int16_t monsterId);
std::string bountyHuntTargetText(const MonsterTable::MonsterStatsEntry &stats);
std::string bountyHuntRewardText(const MonsterTable::MonsterStatsEntry &stats);
void applyBountyHuntClaimResult(
    IGameplayWorldRuntime &worldRuntime,
    Party *pParty,
    const BountyHuntClaimResult &result);
}
