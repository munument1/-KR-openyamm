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

MonsterTable makeGeneratedAbilityMonsterTable()
{
    std::vector<std::string> first = monsterStatsRow(16, "Regnan Sorcerer", 10, 100, 5, "Short", 120);
    first[18] = "2d5";
    MonsterTable table;
    REQUIRE(table.loadStatsFromRows({
        first,
        monsterStatsRow(17, "Regnan Battlemage", 10, 120, 7, "Short", 120),
        monsterStatsRow(18, "Regnan Archmage", 10, 140, 9, "Short", 120),
    }));
    return table;
}

MonsterTable makeElementalMonsterTable()
{
    MonsterTable table;
    REQUIRE(table.loadStatsFromRows({
        monsterStatsRow(76, "Lesser Water Elemental", 10, 100, 5, "Short", 120),
        monsterStatsRow(77, "Water Elemental", 10, 100, 5, "Short", 120),
        monsterStatsRow(78, "Greater Water Elemental", 10, 100, 5, "Short", 120),
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

MergedBolsterMonsterTable makeGeneratedAbilityMonsterSettingsTable()
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
        {"16", "Regnan Sorcerer", "Human", "", "Dark", "M", "Magic", "Fire", "-", "x", "x",
         "-", "-", "-", "", "", "300"},
        {"17", "Regnan Battlemage", "Human", "", "Dark", "M", "Magic", "Fire", "-", "x", "x",
         "-", "-", "-", "", "", "300"},
        {"18", "Regnan Archmage", "Human", "", "Dark", "M", "Magic", "Fire", "-", "x", "x",
         "-", "-", "-", "", "", "300"},
    }));
    return table;
}

MergedBolsterMonsterTable makeElementalMonsterSettingsTable()
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
        {"76", "Lesser Water Elemental", "Elemental", "", "Neutral", "", "Magic", "Water", "-", "x",
         "-", "x", "-", "-", "", "", ""},
        {"77", "Water Elemental", "Elemental", "", "Neutral", "", "Magic", "Water", "-", "x",
         "-", "x", "-", "-", "", "", ""},
        {"78", "Greater Water Elemental", "Elemental", "", "Neutral", "", "Magic", "Water", "-", "x",
         "-", "x", "-", "-", "", "", ""},
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
                .bolsterMonstersEnabled = true,
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

TEST_CASE("runtime bolster is disabled by default")
{
    MonsterTable monsterTable = makeMonsterTable();
    MergedBolsterMapTable mapTable = makeBolsterMapTable(true);
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

    CHECK_FALSE(bolster.mapEnabled);
    CHECK_FALSE(bolster.statsEnabled);
    CHECK_EQ(bolster.maxHp, pStats->hitPoints);
    CHECK_EQ(bolster.armorClass, pStats->armorClass);
    CHECK_FALSE(bolster.monsterAllowsNewSpells);
    CHECK_FALSE(bolster.monsterAllowsSummons);
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
                .bolsterMonstersEnabled = true,
            },
            *pStats,
            nullptr);

    CHECK(bolster.monsterAllowsNewSpells);
    CHECK_FALSE(bolster.monsterAllowsSummons);
    CHECK_FALSE(bolster.stationarySummonAsSpawnPoint);
}

TEST_CASE("runtime bolster materializes generated ranged attacks and spells")
{
    MonsterTable monsterTable = makeGeneratedAbilityMonsterTable();
    MergedBolsterMapTable mapTable = makeBolsterMapTable(true);
    MergedBolsterMonsterTable monsterSettingsTable = makeGeneratedAbilityMonsterSettingsTable();
    Party party = makeParty(60);
    MapStatsEntry map = {};
    map.id = 65;

    const MonsterTable::MonsterStatsEntry *pStats = monsterTable.findStatsById(16);
    REQUIRE(pStats != nullptr);

    const GameplayMonsterBolsterResult bolster =
        resolveGameplayMonsterBolster(
            GameplayBolsterRuntimeContext{
                .pMap = &map,
                .pMonsterTable = &monsterTable,
                .pBolsterMapTable = &mapTable,
                .pBolsterMonsterTable = &monsterSettingsTable,
                .pParty = &party,
                .bolsterMonstersEnabled = true,
            },
            *pStats,
            nullptr);

    CHECK(bolster.generatedAttack2);
    CHECK(bolster.generatedAttack2IsRanged);
    CHECK(bolster.copyAttack1DamageToAttack2);
    CHECK_EQ(bolster.generatedAttack2MissileType, "Fire");
    CHECK_EQ(bolster.generatedAttack2Chance, 35);
    CHECK_EQ(bolster.generatedSpell1Id, 11u);
    CHECK_EQ(bolster.generatedSpell2Id, 5u);
    CHECK_EQ(bolster.generatedSpell1UseChance, 60);
    CHECK_EQ(bolster.generatedSpell2UseChance, 35);
    CHECK_EQ(bolster.spell1SkillLevel, 4u);
    CHECK_EQ(bolster.spell1SkillMastery, SkillMastery::Expert);
}

TEST_CASE("runtime bolster applies the special water elemental HP formula")
{
    MonsterTable monsterTable = makeElementalMonsterTable();
    MergedBolsterMapTable mapTable = makeBolsterMapTable(true);
    MergedBolsterMonsterTable monsterSettingsTable = makeElementalMonsterSettingsTable();
    Party party = makeParty(30);
    MapStatsEntry map = {};
    map.id = 65;
    MonsterEntry monsterEntry = {};
    monsterEntry.height = 160;

    const MonsterTable::MonsterStatsEntry *pStats = monsterTable.findStatsById(76);
    REQUIRE(pStats != nullptr);

    const GameplayMonsterBolsterResult bolster =
        resolveGameplayMonsterBolster(
            GameplayBolsterRuntimeContext{
                .pMap = &map,
                .pMonsterTable = &monsterTable,
                .pBolsterMapTable = &mapTable,
                .pBolsterMonsterTable = &monsterSettingsTable,
                .pParty = &party,
                .bolsterMonstersEnabled = true,
            },
            *pStats,
            &monsterEntry);

    CHECK_EQ(bolster.maxHp, 300);
}

TEST_CASE("runtime bolster player armor class formula only applies to bolstered monsters")
{
    CHECK_EQ(gameplayBolsterPlayerArmorClass(50, 10, 20, false), 50);
    CHECK_EQ(gameplayBolsterPlayerArmorClass(50, 10, 20, true), 25);
    CHECK_EQ(gameplayBolsterPlayerArmorClass(50, 30, 20, true), 50);
}
