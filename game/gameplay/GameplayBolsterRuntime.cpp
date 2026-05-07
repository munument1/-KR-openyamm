#include "game/gameplay/GameplayBolsterRuntime.h"

#include "game/party/Party.h"
#include "game/tables/MapStats.h"
#include "game/tables/MergedBaseTables.h"

#include <algorithm>
#include <cmath>
#include <cctype>
#include <string>

namespace OpenYAMM::Game
{
namespace
{
constexpr int MaximumBolsteredHitPoints = 30000;

std::string lowercaseCopy(const std::string &value)
{
    std::string result = value;

    for (char &character : result)
    {
        character = static_cast<char>(std::tolower(static_cast<unsigned char>(character)));
    }

    return result;
}

bool isDisabledBolsterKind(const std::string &kind)
{
    const std::string normalized = lowercaseCopy(kind);
    return normalized.empty()
        || normalized == "0"
        || normalized == "-"
        || normalized == "nobolster";
}

bool isOriginalStatsBolsterKind(const std::string &kind)
{
    return lowercaseCopy(kind) == "originalstats";
}

bool isAllToEqualBolsterKind(const std::string &kind)
{
    return lowercaseCopy(kind) == "alltoequal";
}

bool isStyle(const MergedBolsterMonsterEntry *pMonsterSettings, const char *style)
{
    return pMonsterSettings != nullptr && lowercaseCopy(pMonsterSettings->style) == lowercaseCopy(style);
}

uint32_t monsterKindBaseId(uint32_t monsterId)
{
    return monsterId > 0 ? ((monsterId - 1u) / 3u) * 3u + 1u : 0u;
}

int monsterPower(uint32_t monsterId)
{
    return monsterId > 0 ? static_cast<int>((monsterId - 1u) % 3u) + 1 : 1;
}

int monsterLevelShift(const MergedBolsterMonsterEntry *pMonsterSettings)
{
    return pMonsterSettings != nullptr && pMonsterSettings->extraPoints
        ? static_cast<int>(*pMonsterSettings->extraPoints)
        : 0;
}

int monsterFamilyLevel(
    const MonsterTable &monsterTable,
    const MergedBolsterMonsterTable *pMonsterSettingsTable,
    uint32_t monsterId)
{
    const uint32_t baseId = monsterKindBaseId(monsterId);

    if (baseId == 0)
    {
        return 3;
    }

    int levelSum = 0;
    int levelCount = 0;

    for (uint32_t offset = 0; offset < 3; ++offset)
    {
        const uint32_t familyMonsterId = baseId + offset;
        const MonsterTable::MonsterStatsEntry *pStats =
            monsterTable.findStatsById(static_cast<int16_t>(familyMonsterId));

        if (pStats == nullptr)
        {
            continue;
        }

        const MergedBolsterMonsterEntry *pMonsterSettings =
            pMonsterSettingsTable != nullptr ? pMonsterSettingsTable->findById(familyMonsterId) : nullptr;
        levelSum += pStats->level + monsterLevelShift(pMonsterSettings);
        ++levelCount;
    }

    if (levelCount == 0)
    {
        return 3;
    }

    return std::max(3, static_cast<int>(std::ceil(static_cast<double>(levelSum) / levelCount)));
}

uint32_t masteryValue(SkillMastery mastery)
{
    return static_cast<uint32_t>(mastery);
}

SkillMastery masteryFromValue(uint32_t value)
{
    switch (std::clamp<uint32_t>(value, 0, 4))
    {
        case 1:
            return SkillMastery::Normal;
        case 2:
            return SkillMastery::Expert;
        case 3:
            return SkillMastery::Master;
        case 4:
            return SkillMastery::Grandmaster;
        default:
            return SkillMastery::None;
    }
}

uint32_t resolveSpellSkillLevel(
    uint32_t baseSkill,
    bool magicStyle,
    int monsterPowerValue,
    double partyToMonsterRatio)
{
    if (baseSkill == 0)
    {
        return 0;
    }

    if (magicStyle)
    {
        return static_cast<uint32_t>(
            std::clamp<int>(
                static_cast<int>(std::lround(static_cast<double>(baseSkill) * partyToMonsterRatio)),
                1,
                10));
    }

    return static_cast<uint32_t>(std::clamp<int>(
        static_cast<int>(baseSkill) * monsterPowerValue,
        1,
        7));
}

SkillMastery resolveSpellMastery(
    SkillMastery baseMastery,
    bool magicStyle,
    int monsterPowerValue,
    double partyToMonsterRatio)
{
    const uint32_t baseValue = masteryValue(baseMastery);

    if (baseValue == 0)
    {
        return SkillMastery::None;
    }

    if (magicStyle)
    {
        return masteryFromValue(baseValue + static_cast<uint32_t>(std::floor(partyToMonsterRatio)));
    }

    return masteryFromValue(std::min<uint32_t>(baseValue + static_cast<uint32_t>(monsterPowerValue), 3));
}

int cappedBolsteredHitPoints(
    int baseHp,
    int monsterFamilyLevelValue,
    int partyLevel,
    bool sizeAffectsHp,
    uint16_t monsterHeight,
    const MergedBolsterMonsterEntry *pMonsterSettings)
{
    const double heightMultiplier =
        sizeAffectsHp ? std::max(1.0, static_cast<double>(monsterHeight) / 160.0) : 1.0;
    const double scaledHp =
        static_cast<double>(baseHp)
        + (static_cast<double>(baseHp) / monsterFamilyLevelValue)
            * static_cast<double>(partyLevel - monsterFamilyLevelValue)
        + heightMultiplier * static_cast<double>(baseHp);

    int result = std::max(1, static_cast<int>(std::lround(scaledHp)));

    if (pMonsterSettings != nullptr && pMonsterSettings->maxHpBoostPercent)
    {
        const int cap =
            std::max(1, static_cast<int>(
                std::lround(static_cast<double>(baseHp) * *pMonsterSettings->maxHpBoostPercent / 100.0)));
        result = std::min(result, cap);
    }

    return std::min(result, MaximumBolsteredHitPoints);
}

int bolsteredAttackDamageBonus(int diceRolls, int diceSides, int baseBonus, int monsterPowerValue)
{
    const int maxDamage = std::max(0, diceRolls) * std::max(0, diceSides);

    if (maxDamage == 0)
    {
        return baseBonus;
    }

    const double multiplier = 1.0 + static_cast<double>(monsterPowerValue) / 3.0 - 0.33;
    const int boost = std::max(0, static_cast<int>(std::lround(static_cast<double>(maxDamage) * multiplier)));
    return baseBonus + boost;
}
}

int gameplayBolsterAveragePartyLevel(const Party *pParty)
{
    if (pParty == nullptr || pParty->members().empty())
    {
        return 1;
    }

    uint32_t levelSum = 0;

    for (const Character &member : pParty->members())
    {
        levelSum += std::max<uint32_t>(1, member.level);
    }

    return std::max(1, static_cast<int>(std::ceil(
        static_cast<double>(levelSum) / static_cast<double>(pParty->members().size()))));
}

GameplayMonsterBolsterResult resolveGameplayMonsterBolster(
    const GameplayBolsterRuntimeContext &context,
    const MonsterTable::MonsterStatsEntry &stats,
    const MonsterEntry *pMonsterEntry)
{
    GameplayMonsterBolsterResult result = {};
    result.maxHp = std::max(1, stats.hitPoints);
    result.armorClass = stats.armorClass;
    result.moveSpeed = static_cast<uint16_t>(std::max(0, stats.speed));
    result.attack1DamageBonus = stats.attack1Damage.bonus;
    result.attack2DamageBonus = stats.attack2Damage.bonus;
    result.spell1SkillLevel = stats.spell1SkillLevel;
    result.spell1SkillMastery = stats.spell1SkillMastery;
    result.spell2SkillLevel = stats.spell2SkillLevel;
    result.spell2SkillMastery = stats.spell2SkillMastery;

    if (context.pMap == nullptr
        || context.pMonsterTable == nullptr
        || context.pBolsterMapTable == nullptr
        || context.pBolsterMonsterTable == nullptr
        || stats.id == 0)
    {
        return result;
    }

    const MergedBolsterMapEntry *pMapSettings = context.pBolsterMapTable->findById(context.pMap->id);

    if (pMapSettings == nullptr || isDisabledBolsterKind(pMapSettings->bolsterKind))
    {
        return result;
    }

    const uint32_t monsterId = static_cast<uint32_t>(std::max(0, stats.id));
    const MergedBolsterMonsterEntry *pMonsterSettings = context.pBolsterMonsterTable->findById(monsterId);
    const uint16_t monsterHeight = pMonsterEntry != nullptr ? pMonsterEntry->height : uint16_t(160);
    const bool immobile =
        (pMonsterSettings != nullptr && lowercaseCopy(pMonsterSettings->type) == "immobile")
        || stats.movementType == MonsterTable::MonsterMovementType::Stationary;
    const int basePartyLevel =
        gameplayBolsterAveragePartyLevel(context.pParty) + static_cast<int>(pMapSettings->bolsterExtra);
    const int familyLevel = monsterFamilyLevel(*context.pMonsterTable, context.pBolsterMonsterTable, monsterId);
    const double partyToMonsterRatio =
        static_cast<double>(std::max(1, basePartyLevel)) / static_cast<double>(std::max(1, familyLevel));
    const bool allToEqual = isAllToEqualBolsterKind(pMapSettings->bolsterKind);
    const bool shouldBolsterMonster = allToEqual || basePartyLevel > familyLevel;
    const bool statsEnabled = shouldBolsterMonster && !isOriginalStatsBolsterKind(pMapSettings->bolsterKind);
    const int power = monsterPower(monsterId);
    const bool magicStyle = isStyle(pMonsterSettings, "magic");

    result.mapEnabled = shouldBolsterMonster;
    result.statsEnabled = statsEnabled;
    result.mapAllowsSpells = pMapSettings->spells;
    result.mapAllowsSummons = pMapSettings->summons;
    result.immobile = immobile;
    result.partyLevel = basePartyLevel;
    result.monsterFamilyLevel = familyLevel;
    result.bolsterStep =
        std::clamp<int>(static_cast<int>(std::floor(partyToMonsterRatio)), 0, 4);

    if (pMonsterSettings != nullptr)
    {
        result.monsterAllowsNewRangedAttacks =
            shouldBolsterMonster && pMonsterSettings->newRangedAttacks && result.bolsterStep > 0;
        result.monsterAllowsNewSpells =
            shouldBolsterMonster
            && pMapSettings->spells
            && pMonsterSettings->newSpells
            && partyToMonsterRatio > 2.0;
        result.monsterAllowsSummons =
            shouldBolsterMonster
            && pMapSettings->summons
            && pMonsterSettings->newSummons
            && partyToMonsterRatio > 2.0;
        result.monsterAllowsReplicate =
            shouldBolsterMonster
            && pMapSettings->summons
            && pMonsterSettings->replicate
            && partyToMonsterRatio > 2.0;
        result.stationarySummonAsSpawnPoint = result.monsterAllowsSummons && immobile;
        result.summonMonsterId =
            pMonsterSettings->summonId ? *pMonsterSettings->summonId : monsterId;
    }

    if (!statsEnabled)
    {
        return result;
    }

    result.maxHp = cappedBolsteredHitPoints(
        std::max(1, stats.hitPoints),
        familyLevel,
        basePartyLevel,
        pMonsterSettings != nullptr && pMonsterSettings->sizeAffectsHp,
        monsterHeight,
        pMonsterSettings);
    result.armorClass = std::max(0, stats.armorClass * power);
    result.attack1DamageBonus = bolsteredAttackDamageBonus(
        stats.attack1Damage.diceRolls,
        stats.attack1Damage.diceSides,
        stats.attack1Damage.bonus,
        power);
    result.attack2DamageBonus = bolsteredAttackDamageBonus(
        stats.attack2Damage.diceRolls,
        stats.attack2Damage.diceSides,
        stats.attack2Damage.bonus,
        power);

    if (isStyle(pMonsterSettings, "speed") || isStyle(pMonsterSettings, "strength"))
    {
        const double speedLimit = static_cast<double>(std::max(0, stats.speed))
            * (isStyle(pMonsterSettings, "speed") ? 3.0 : 1.75);
        const double scaledSpeed = static_cast<double>(std::max(0, stats.speed)) * partyToMonsterRatio;
        result.moveSpeed =
            static_cast<uint16_t>(std::clamp<int>(static_cast<int>(std::lround(
                std::min(scaledSpeed, speedLimit))), 0, 65535));
    }

    result.spell1SkillLevel = resolveSpellSkillLevel(
        stats.spell1SkillLevel,
        magicStyle,
        power,
        partyToMonsterRatio);
    result.spell1SkillMastery = resolveSpellMastery(
        stats.spell1SkillMastery,
        magicStyle,
        power,
        partyToMonsterRatio);
    result.spell2SkillLevel = resolveSpellSkillLevel(
        stats.spell2SkillLevel,
        magicStyle,
        power,
        partyToMonsterRatio);
    result.spell2SkillMastery = resolveSpellMastery(
        stats.spell2SkillMastery,
        magicStyle,
        power,
        partyToMonsterRatio);

    return result;
}
}
