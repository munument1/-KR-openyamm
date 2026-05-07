#include "doctest/doctest.h"

#include "game/gameplay/GameplayBolsterRuntime.h"
#include "game/party/Party.h"
#include "game/tables/MapStats.h"
#include "game/tables/MergedBaseTables.h"

using namespace OpenYAMM::Game;

namespace
{
std::vector<std::string> monsterStatsRow(
    int id,
    const std::string &name,
    int level,
    int hp,
    int armorClass,
    const std::string &movement,
    int speed)
{
    std::vector<std::string> row(38);
    row[0] = std::to_string(id);
    row[1] = name;
    row[2] = name;
    row[3] = std::to_string(level);
    row[4] = std::to_string(hp);
    row[5] = std::to_string(armorClass);
    row[10] = movement;
    row[11] = "Normal";
    row[12] = "0";
    row[13] = std::to_string(speed);
    row[14] = "100";
    row[17] = "Phys";
    row[18] = "1d6";
    return row;
}

MonsterTable makeMonsterTable()
{
    MonsterTable table;
    REQUIRE(table.loadStatsFromRows({
        monsterStatsRow(451, "Tree A", 10, 100, 5, "Stationary", 120),
        monsterStatsRow(452, "Tree B", 10, 120, 7, "Stationary", 120),
        monsterStatsRow(453, "Tree C", 10, 140, 9, "Stationary", 120),
    }));
    return table;
}

MergedBolsterMapTable makeBolsterMapTable(bool summons)
{
    MergedBolsterMapTable table;
    REQUIRE(table.loadFromRows({
        {"#", "Note", "Continent", "Bolster kind", "Spells", "Summons", "Weather", "Extra", "Rarity"},
        {"65", "The Tularean Forest", "2", "LowerToEqual", "x", summons ? "x" : "-", "x", "0", "30"},
    }));
    return table;
}

MergedBolsterMonsterTable makeBolsterMonsterTable()
{
    MergedBolsterMonsterTable table;
    REQUIRE(table.loadFromRows({
        {
            "#",
            "Note",
            "Type",
            "ExtraType",
            "Creed",
            "Gender",
            "Style",
            "PrefMagic",
            "NoBounty",
            "Ranged",
            "Spells",
            "HPBySize",
            "Replicate",
            "Summons",
            "SummonId",
            "Extra",
            "MaxHP",
        },
        {"451", "Tree", "Immobile", "", "Neutral", "", "Endurance", "", "-", "-", "x", "-", "-", "x", "226", "", "300"},
        {"452", "Tree", "Immobile", "", "Neutral", "", "Endurance", "", "-", "-", "x", "-", "-", "x", "226", "", "300"},
        {"453", "Tree", "Immobile", "", "Neutral", "", "Endurance", "", "-", "-", "x", "-", "-", "x", "226", "", "300"},
    }));
    return table;
}

Party makeParty(uint32_t level)
{
    Character first;
    first.level = level;
    Character second;
    second.level = level;

    PartySeed seed = {};
    seed.members = {first, second};

    Party party;
    party.seed(seed);
    return party;
}
}

TEST_CASE("runtime bolster applies merged map and monster settings to MM7 tree-style actors")
{
    MonsterTable monsterTable = makeMonsterTable();
    MergedBolsterMapTable mapTable = makeBolsterMapTable(true);
    MergedBolsterMonsterTable monsterSettingsTable = makeBolsterMonsterTable();
    Party party = makeParty(35);
    MapStatsEntry map = {};
    map.id = 65;
    MonsterEntry monsterEntry = {};
    monsterEntry.height = 256;

    const MonsterTable::MonsterStatsEntry *pStats = monsterTable.findStatsById(451);
    REQUIRE(pStats != nullptr);

    const GameplayMonsterBolsterResult bolster =
        resolveGameplayMonsterBolster(
            GameplayBolsterRuntimeContext{
                .pMap = &map,
                .pMonsterTable = &monsterTable,
                .pBolsterMapTable = &mapTable,
                .pBolsterMonsterTable = &monsterSettingsTable,
                .pParty = &party,
            },
            *pStats,
            &monsterEntry);

    CHECK(bolster.mapEnabled);
    CHECK(bolster.statsEnabled);
    CHECK(bolster.maxHp > pStats->hitPoints);
    CHECK(bolster.armorClass == pStats->armorClass);
    CHECK_GT(bolster.attack1DamageBonus, pStats->attack1Damage.bonus);
    CHECK_EQ(bolster.attack2DamageBonus, pStats->attack2Damage.bonus);
    CHECK(bolster.monsterAllowsNewSpells);
    CHECK(bolster.monsterAllowsSummons);
    CHECK(bolster.immobile);
    CHECK(bolster.stationarySummonAsSpawnPoint);
    CHECK(bolster.summonMonsterId == 226);
}

TEST_CASE("runtime bolster keeps summon behavior gated by the map row")
{
    MonsterTable monsterTable = makeMonsterTable();
    MergedBolsterMapTable mapTable = makeBolsterMapTable(false);
    MergedBolsterMonsterTable monsterSettingsTable = makeBolsterMonsterTable();
    Party party = makeParty(35);
    MapStatsEntry map = {};
    map.id = 65;

    const MonsterTable::MonsterStatsEntry *pStats = monsterTable.findStatsById(451);
    REQUIRE(pStats != nullptr);

    const GameplayMonsterBolsterResult bolster =
        resolveGameplayMonsterBolster(
            GameplayBolsterRuntimeContext{
                .pMap = &map,
                .pMonsterTable = &monsterTable,
                .pBolsterMapTable = &mapTable,
                .pBolsterMonsterTable = &monsterSettingsTable,
                .pParty = &party,
            },
            *pStats,
            nullptr);

    CHECK(bolster.monsterAllowsNewSpells);
    CHECK_FALSE(bolster.monsterAllowsSummons);
    CHECK_FALSE(bolster.stationarySummonAsSpawnPoint);
}
