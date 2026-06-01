#include "game/gameplay/BountyHuntRuntime.h"

#include "game/events/EvtEnums.h"
#include "game/gameplay/GameplayRuntimeInterfaces.h"
#include "game/gameplay/ReputationRuntime.h"
#include "game/party/Party.h"
#include "game/tables/NpcDialogTable.h"

#include <algorithm>
#include <cmath>
#include <functional>
#include <random>

namespace OpenYAMM::Game
{
namespace
{
constexpr int MinutesPerDay = 24 * 60;
constexpr uint32_t BountyHuntGroup = 39;
constexpr uint32_t MMergeBountyHuntTextId = 133;
constexpr uint32_t MMergeBountyRewardTextId = 134;
constexpr uint32_t MMergeBountyClaimedTextId = 135;
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

BountyHuntEntry readRuntimeBountyHuntEntry(const EventRuntimeState &state, const std::string &prefix)
{
    BountyHuntEntry entry = {};
    entry.month = static_cast<uint32_t>(std::max<int32_t>(0, namedGlobalVarValue(state, prefix + ".Month")));
    entry.monsterId = static_cast<int16_t>(namedGlobalVarValue(state, prefix + ".MonsterId"));
    entry.done = namedGlobalVarValue(state, prefix + ".Done") != 0;
    entry.claimed = namedGlobalVarValue(state, prefix + ".Claimed") != 0;
    return entry;
}

uint32_t activeBountyMaximumLevel(const Party *pParty)
{
    const Character *pMember = pParty != nullptr ? pParty->member(0) : nullptr;
    return pMember != nullptr ? pMember->level + 20u : 20u;
}

void replaceFirst(std::string &text, const std::string &needle, const std::string &replacement)
{
    const size_t position = text.find(needle);

    if (position != std::string::npos)
    {
        text.replace(position, needle.size(), replacement);
    }
}

std::optional<std::string> npcText(const NpcDialogTable *pNpcDialogTable, uint32_t textId)
{
    if (pNpcDialogTable == nullptr)
    {
        return std::nullopt;
    }

    return pNpcDialogTable->getText(textId);
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
    if (bountyHuntEntryExpired(entry, currentMonth) || entry.done || entry.claimed || entry.monsterId != monsterId)
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

    const uint32_t currentMonth = monthFromGameMinutes(worldRuntime.gameMinutes());
    const std::string currentMapPrefix = bountyHuntVarPrefix(worldRuntime);
    bool markedAnyEntry = false;
    bool markedCurrentMapEntry = false;

    std::vector<std::string> prefixes;
    prefixes.reserve(pEventRuntimeState->namedGlobalVars.size());

    for (const auto &entry : pEventRuntimeState->namedGlobalVars)
    {
        constexpr const char *pMonsterIdSuffix = ".MonsterId";
        const std::string &name = entry.first;

        if (name.size() <= std::char_traits<char>::length(pMonsterIdSuffix)
            || name.compare(
                name.size() - std::char_traits<char>::length(pMonsterIdSuffix),
                std::char_traits<char>::length(pMonsterIdSuffix),
                pMonsterIdSuffix) != 0
            || name.rfind("MMerge.BountyHunt.", 0) != 0)
        {
            continue;
        }

        prefixes.push_back(name.substr(0, name.size() - std::char_traits<char>::length(pMonsterIdSuffix)));
    }

    for (const std::string &prefix : prefixes)
    {
        BountyHuntEntry entry = readRuntimeBountyHuntEntry(*pEventRuntimeState, prefix);

        if (markBountyHuntMonsterKilled(entry, monsterId, currentMonth))
        {
            writeRuntimeBountyHuntEntry(*pEventRuntimeState, prefix, entry);
            markedAnyEntry = true;
            markedCurrentMapEntry = markedCurrentMapEntry || prefix == currentMapPrefix;
        }
    }

    if (!markedAnyEntry)
    {
        return false;
    }

    const MonsterTable::MonsterStatsEntry *pStats =
        pMonsterTable != nullptr ? pMonsterTable->findStatsById(monsterId) : nullptr;

    if (markedCurrentMapEntry && pStats != nullptr)
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
    result.reputationDelta = -static_cast<int32_t>(
        std::ceil(static_cast<double>(result.bountyTotalDelta) / 2000.0));

    if (!awardGold)
    {
        result.goldReward = 0;
    }

    entry.claimed = true;
    return result;
}

BountyHuntInteractionResult performBountyHuntInteraction(
    IGameplayWorldRuntime &worldRuntime,
    Party *pParty,
    bool awardGold,
    const NpcDialogTable *pNpcDialogTable)
{
    BountyHuntInteractionResult result = {};
    const MonsterTable *pMonsterTable = worldRuntime.monsterTable();

    if (pMonsterTable == nullptr)
    {
        result.messages.push_back("The bounty office is unavailable right now.");
        return result;
    }

    EventRuntimeState *pEventRuntimeState = worldRuntime.eventRuntimeState();

    if (pEventRuntimeState == nullptr)
    {
        result.messages.push_back("The bounty office is unavailable right now.");
        return result;
    }

    const uint32_t currentMonth = monthFromGameMinutes(worldRuntime.gameMinutes());
    const std::string prefix = bountyHuntVarPrefix(worldRuntime);
    BountyHuntEntry entry = readRuntimeBountyHuntEntry(*pEventRuntimeState, prefix);

    if (entry.monsterId <= 0 || bountyHuntEntryExpired(entry, currentMonth))
    {
        const uint32_t seed =
            static_cast<uint32_t>(std::hash<std::string>{}(prefix))
            ^ static_cast<uint32_t>(currentMonth * 1103515245u);
        const std::optional<int16_t> monsterId =
            chooseBountyHuntMonsterId(
                *pMonsterTable,
                worldRuntime.mergedBolsterMonsterTable(),
                activeBountyMaximumLevel(pParty),
                seed);

        if (!monsterId.has_value())
        {
            result.messages.push_back("There is no bounty this month.");
            return result;
        }

        entry = {};
        entry.month = currentMonth;
        entry.monsterId = *monsterId;
        writeRuntimeBountyHuntEntry(*pEventRuntimeState, prefix, entry);

        const GameplayWorldPoint spawnPoint = worldRuntime.chooseBountyHuntSpawnPoint(seed);
        worldRuntime.summonHostileMonsterById(
            entry.monsterId,
            1,
            spawnPoint.x,
            spawnPoint.y,
            spawnPoint.z,
            BountyHuntGroup);
    }

    const MonsterTable::MonsterStatsEntry *pStats = pMonsterTable->findStatsById(entry.monsterId);

    if (pStats == nullptr)
    {
        result.messages.push_back("The bounty office is unavailable right now.");
        return result;
    }

    if (!entry.done)
    {
        result.messages.push_back(bountyHuntTargetText(*pStats, pNpcDialogTable));
        result.succeeded = true;
        return result;
    }

    const BountyHuntClaimResult claim = claimBountyHuntReward(entry, *pMonsterTable, currentMonth, awardGold);

    if (!claim.claimed)
    {
        result.messages.push_back(bountyHuntClaimedText(pNpcDialogTable));
        writeRuntimeBountyHuntEntry(*pEventRuntimeState, prefix, entry);
        return result;
    }

    applyBountyHuntClaimResult(worldRuntime, pParty, claim);
    writeRuntimeBountyHuntEntry(*pEventRuntimeState, prefix, entry);
    result.messages.push_back(bountyHuntRewardText(*pStats, pNpcDialogTable));
    result.succeeded = true;
    return result;
}

std::string bountyHuntTargetText(
    const MonsterTable::MonsterStatsEntry &stats,
    const NpcDialogTable *pNpcDialogTable)
{
    const uint32_t reward = bountyHuntRewardForMonster(stats);
    std::optional<std::string> text = npcText(pNpcDialogTable, MMergeBountyHuntTextId);

    if (text && !text->empty())
    {
        replaceFirst(*text, "%s", stats.name);
        replaceFirst(*text, "%lu", std::to_string(reward));
        return *text;
    }

    return "This month's bounty is " + stats.name + " for "
        + std::to_string(reward) + " gold.";
}

std::string bountyHuntRewardText(
    const MonsterTable::MonsterStatsEntry &stats,
    const NpcDialogTable *pNpcDialogTable)
{
    const uint32_t reward = bountyHuntRewardForMonster(stats);
    std::optional<std::string> text = npcText(pNpcDialogTable, MMergeBountyRewardTextId);

    if (text && !text->empty())
    {
        replaceFirst(*text, "%s", stats.name);
        replaceFirst(*text, "%lu", std::to_string(reward));
        return *text;
    }

    return "You eliminated " + stats.name + ". Your reward is " + std::to_string(reward) + " gold.";
}

std::string bountyHuntClaimedText(const NpcDialogTable *pNpcDialogTable)
{
    std::optional<std::string> text = npcText(pNpcDialogTable, MMergeBountyClaimedTextId);

    if (text && !text->empty())
    {
        return *text;
    }

    return "You have already claimed this bounty.";
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
                static_cast<uint16_t>(EvtVariable::NumBounties),
                static_cast<int32_t>(result.bountyTotalDelta));
            pParty->addAward(44);
        }
    }
}
}
