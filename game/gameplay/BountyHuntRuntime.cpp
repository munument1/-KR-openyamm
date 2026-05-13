#include "game/gameplay/BountyHuntRuntime.h"

#include "game/events/EvtEnums.h"
#include "game/gameplay/GameplayRuntimeInterfaces.h"
#include "game/gameplay/ReputationRuntime.h"
#include "game/party/Party.h"

#include <algorithm>
#include <cmath>
#include <random>

namespace OpenYAMM::Game
{
namespace
{
constexpr int MinutesPerDay = 24 * 60;
constexpr int MMergeBountyHuntLocalReputationLimit = -20;
constexpr int MMergeBountyHuntContinentReputationLimit = -5;

uint32_t monthFromGameMinutes(float currentGameMinutes)
{
    const int totalMinutes = std::max(0, static_cast<int>(std::floor(currentGameMinutes)));
    const int totalDays = totalMinutes / MinutesPerDay;
    return static_cast<uint32_t>(totalDays / 28);
}

std::string bountyHuntVarPrefix(const IGameplayWorldRuntime &worldRuntime)
{
    return "MMerge.BountyHunt." + worldRuntime.mapName();
}

int32_t namedGlobalVarValue(const EventRuntimeState &state, const std::string &name)
{
    const auto iterator = state.namedGlobalVars.find(name);
    return iterator != state.namedGlobalVars.end() ? iterator->second : 0;
}

void writeRuntimeBountyHuntEntry(EventRuntimeState &state, const std::string &prefix, const BountyHuntEntry &entry)
{
    state.namedGlobalVars[prefix + ".Month"] = static_cast<int32_t>(entry.month);
    state.namedGlobalVars[prefix + ".MonsterId"] = static_cast<int32_t>(entry.monsterId);
    state.namedGlobalVars[prefix + ".Done"] = entry.done ? 1 : 0;
    state.namedGlobalVars[prefix + ".Claimed"] = entry.claimed ? 1 : 0;
}

int32_t bountyHuntReputationDeltaForKilledMonster(
    const MonsterTable::MonsterStatsEntry &stats,
    int32_t storedReputation)
{
    int32_t reputationDelta = 0;

    if (storedReputation >= MMergeBountyHuntLocalReputationLimit)
    {
        reputationDelta -= static_cast<int32_t>(std::max(0, stats.level) / 20);
    }

    if (storedReputation > MMergeBountyHuntContinentReputationLimit)
    {
        reputationDelta -= 1;
    }

    return reputationDelta;
}
}

uint32_t bountyHuntRewardForMonster(const MonsterTable::MonsterStatsEntry &stats)
{
    return static_cast<uint32_t>(std::max(0, stats.level) * 100);
}

bool bountyHuntMonsterAllowed(
    const MonsterTable::MonsterStatsEntry &stats,
    const MergedBolsterMonsterTable *pBolsterMonsterTable,
    uint32_t maximumLevel)
{
    if (stats.id <= 0 || stats.level <= 0 || static_cast<uint32_t>(stats.level) > maximumLevel)
    {
        return false;
    }

    if (stats.hasKind(MonsterKind::NoArena))
    {
        return false;
    }

    const MergedBolsterMonsterEntry *pBolsterMonster =
        pBolsterMonsterTable != nullptr ? pBolsterMonsterTable->findById(static_cast<uint32_t>(stats.id)) : nullptr;
    return pBolsterMonster == nullptr || !pBolsterMonster->noBountyHunt;
}

std::vector<int16_t> collectBountyHuntMonsterIds(
    const MonsterTable &monsterTable,
    const MergedBolsterMonsterTable *pBolsterMonsterTable,
    uint32_t maximumLevel)
{
    std::vector<int16_t> monsterIds;

    for (const auto &entry : monsterTable.statsEntries())
    {
        if (bountyHuntMonsterAllowed(entry.second, pBolsterMonsterTable, maximumLevel))
        {
            monsterIds.push_back(static_cast<int16_t>(entry.first));
        }
    }

    std::sort(monsterIds.begin(), monsterIds.end());
    return monsterIds;
}

std::optional<int16_t> chooseBountyHuntMonsterId(
    const MonsterTable &monsterTable,
    const MergedBolsterMonsterTable *pBolsterMonsterTable,
    uint32_t maximumLevel,
    uint32_t seed)
{
    const std::vector<int16_t> monsterIds =
        collectBountyHuntMonsterIds(monsterTable, pBolsterMonsterTable, maximumLevel);

    if (monsterIds.empty())
    {
        return std::nullopt;
    }

    std::mt19937 rng(seed);
    return monsterIds[std::uniform_int_distribution<size_t>(0, monsterIds.size() - 1u)(rng)];
}

bool bountyHuntEntryExpired(const BountyHuntEntry &entry, uint32_t currentMonth)
{
    return entry.monsterId == 0 || entry.month != currentMonth;
}

bool markBountyHuntMonsterKilled(BountyHuntEntry &entry, int16_t monsterId, uint32_t currentMonth)
{
    if (bountyHuntEntryExpired(entry, currentMonth) || entry.done || entry.monsterId != monsterId)
    {
        return false;
    }

    entry.done = true;
    return true;
}

bool markRuntimeBountyHuntMonsterKilled(IGameplayWorldRuntime &worldRuntime, int16_t monsterId)
{
    return markRuntimeBountyHuntMonsterKilled(worldRuntime, monsterId, nullptr);
}

bool markRuntimeBountyHuntMonsterKilled(
    IGameplayWorldRuntime &worldRuntime,
    int16_t monsterId,
    const MonsterTable *pMonsterTable)
{
    EventRuntimeState *pEventRuntimeState = worldRuntime.eventRuntimeState();

    if (pEventRuntimeState == nullptr || monsterId <= 0)
    {
        return false;
    }

    const std::string prefix = bountyHuntVarPrefix(worldRuntime);
    BountyHuntEntry entry = {};
    entry.month =
        static_cast<uint32_t>(std::max<int32_t>(0, namedGlobalVarValue(*pEventRuntimeState, prefix + ".Month")));
    entry.monsterId = static_cast<int16_t>(namedGlobalVarValue(*pEventRuntimeState, prefix + ".MonsterId"));
    entry.done = namedGlobalVarValue(*pEventRuntimeState, prefix + ".Done") != 0;
    entry.claimed = namedGlobalVarValue(*pEventRuntimeState, prefix + ".Claimed") != 0;

    if (!markBountyHuntMonsterKilled(entry, monsterId, monthFromGameMinutes(worldRuntime.gameMinutes())))
    {
        return false;
    }

    writeRuntimeBountyHuntEntry(*pEventRuntimeState, prefix, entry);

    const MonsterTable::MonsterStatsEntry *pStats =
        pMonsterTable != nullptr ? pMonsterTable->findStatsById(monsterId) : nullptr;

    if (pStats != nullptr)
    {
        addStoredCurrentLocationReputation(
            worldRuntime,
            bountyHuntReputationDeltaForKilledMonster(*pStats, worldRuntime.currentLocationReputation()));
    }

    return true;
}

BountyHuntClaimResult claimBountyHuntReward(
    BountyHuntEntry &entry,
    const MonsterTable &monsterTable,
    uint32_t currentMonth,
    bool awardGold)
{
    BountyHuntClaimResult result = {};

    if (bountyHuntEntryExpired(entry, currentMonth) || !entry.done || entry.claimed)
    {
        return result;
    }

    const MonsterTable::MonsterStatsEntry *pStats = monsterTable.findStatsById(entry.monsterId);

    if (pStats == nullptr)
    {
        return result;
    }

    result.claimed = true;
    result.goldReward = bountyHuntRewardForMonster(*pStats);
    result.bountyTotalDelta = result.goldReward;
    result.reputationDelta = 0;

    if (!awardGold)
    {
        result.goldReward = 0;
    }

    entry.claimed = true;
    return result;
}

std::string bountyHuntTargetText(const MonsterTable::MonsterStatsEntry &stats)
{
    return "This month's bounty is " + stats.name + " for "
        + std::to_string(bountyHuntRewardForMonster(stats)) + " gold.";
}

std::string bountyHuntRewardText(const MonsterTable::MonsterStatsEntry &stats)
{
    const uint32_t reward = bountyHuntRewardForMonster(stats);
    return "You eliminated " + stats.name + ". Your reward is " + std::to_string(reward) + " gold.";
}

void applyBountyHuntClaimResult(
    IGameplayWorldRuntime &worldRuntime,
    Party *pParty,
    const BountyHuntClaimResult &result)
{
    if (!result.claimed)
    {
        return;
    }

    addStoredCurrentLocationReputation(worldRuntime, result.reputationDelta);

    if (pParty != nullptr)
    {
        if (result.goldReward > 0)
        {
            pParty->addGold(static_cast<int>(result.goldReward));
        }

        if (result.bountyTotalDelta > 0)
        {
            pParty->addEventVariableValue(
                static_cast<uint16_t>(EvtVariable::ArenaWinsPage),
                static_cast<int32_t>(result.bountyTotalDelta));
        }
    }
}
}
