#pragma once

#include "game/party/SkillData.h"
#include "game/tables/MonsterTable.h"

#include <cstdint>

namespace OpenYAMM::Game
{
class MergedBolsterMapTable;
class MergedBolsterMonsterTable;
class Party;
struct MapStatsEntry;
struct MonsterEntry;

struct GameplayBolsterRuntimeContext
{
    const MapStatsEntry *pMap = nullptr;
    const MonsterTable *pMonsterTable = nullptr;
    const MergedBolsterMapTable *pBolsterMapTable = nullptr;
    const MergedBolsterMonsterTable *pBolsterMonsterTable = nullptr;
    const Party *pParty = nullptr;
};

struct GameplayMonsterBolsterResult
{
    bool mapEnabled = false;
    bool statsEnabled = false;
    bool mapAllowsSpells = false;
    bool mapAllowsSummons = false;
    bool monsterAllowsNewRangedAttacks = false;
    bool monsterAllowsNewSpells = false;
    bool monsterAllowsSummons = false;
    bool monsterAllowsReplicate = false;
    bool immobile = false;
    bool stationarySummonAsSpawnPoint = false;
    uint32_t summonMonsterId = 0;
    int partyLevel = 0;
    int monsterFamilyLevel = 0;
    int bolsterStep = 0;
    int maxHp = 0;
    int armorClass = 0;
    uint16_t moveSpeed = 0;
    int attack1DamageBonus = 0;
    int attack2DamageBonus = 0;
    uint32_t spell1SkillLevel = 0;
    SkillMastery spell1SkillMastery = SkillMastery::None;
    uint32_t spell2SkillLevel = 0;
    SkillMastery spell2SkillMastery = SkillMastery::None;
};

int gameplayBolsterAveragePartyLevel(const Party *pParty);

GameplayMonsterBolsterResult resolveGameplayMonsterBolster(
    const GameplayBolsterRuntimeContext &context,
    const MonsterTable::MonsterStatsEntry &stats,
    const MonsterEntry *pMonsterEntry);
}
