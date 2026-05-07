#include "game/gameplay/GameplayBolsterRuntime.h"

#include "game/party/Party.h"
#include "game/tables/MapStats.h"
#include "game/tables/MergedBaseTables.h"

#include <algorithm>
#include <array>
#include <cmath>
#include <cctype>
#include <string>
#include <vector>

namespace OpenYAMM::Game
{
namespace
{
constexpr int MaximumBolsteredHitPoints = 30000;
constexpr uint32_t SpecialElementalHpFormulaTarget = 76;

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

int generatedSpellSkillLevel(bool magicStyle)
{
    return magicStyle ? 4 : 1;
}

SkillMastery generatedSpellSkillMastery(bool magicStyle)
{
    return magicStyle ? SkillMastery::Expert : SkillMastery::Normal;
}

std::string generatedProjectileToken(
    const MonsterTable::MonsterStatsEntry &stats,
    const MergedBolsterMonsterEntry *pMonsterSettings)
{
    if (!stats.attack1MissileType.empty())
    {
        return stats.attack1MissileType;
    }

    const std::string preferredMagic =
        pMonsterSettings != nullptr ? lowercaseCopy(pMonsterSettings->preferredMagic) : "";

    if (preferredMagic == "fire")
    {
        return "Fire";
    }

    if (preferredMagic == "air")
    {
        return "Air";
    }

    if (preferredMagic == "water")
    {
        return "Water";
    }

    if (preferredMagic == "earth")
    {
        return "Earth";
    }

    if (preferredMagic == "spirit")
    {
        return "Spirit";
    }

    if (preferredMagic == "mind")
    {
        return "Mind";
    }

    if (preferredMagic == "body" || preferredMagic == "self")
    {
        return "Body";
    }

    if (preferredMagic == "light")
    {
        return "Light";
    }

    if (preferredMagic == "dark")
    {
        return "Dark";
    }

    return "Arrow";
}

uint32_t magicSchoolIndex(const MergedBolsterMonsterEntry *pMonsterSettings)
{
    const std::string preferredMagic =
        pMonsterSettings != nullptr ? lowercaseCopy(pMonsterSettings->preferredMagic) : "";

    if (preferredMagic == "fire") return 1;
    if (preferredMagic == "air") return 2;
    if (preferredMagic == "water") return 3;
    if (preferredMagic == "earth") return 4;
    if (preferredMagic == "spirit") return 5;
    if (preferredMagic == "mind") return 6;
    if (preferredMagic == "body") return 7;
    if (preferredMagic == "light") return 8;
    if (preferredMagic == "dark") return 9;
    if (preferredMagic == "self") return 10;

    const uint32_t seed = pMonsterSettings != nullptr ? pMonsterSettings->id : 0;
    return (seed % 9u) + 1u;
}

uint32_t generatedSpellFromSet(
    const std::vector<uint32_t> &spellIds,
    int bolsterStep,
    int spellSlot,
    uint32_t otherSpellId)
{
    if (spellIds.empty())
    {
        return 0;
    }

    const size_t candidateCount = std::min<size_t>(
        spellIds.size(),
        static_cast<size_t>(std::max(1, bolsterStep + spellSlot + 1)));
    uint32_t spellId = spellIds[candidateCount - 1u];

    if (spellId == otherSpellId)
    {
        spellId = spellIds.front() != otherSpellId ? spellIds.front() : 0;
    }

    return spellId;
}

uint32_t generatedSpellId(
    const MergedBolsterMonsterEntry *pMonsterSettings,
    bool magicStyle,
    int bolsterStep,
    int spellSlot,
    uint32_t otherSpellId)
{
    static const std::array<std::vector<uint32_t>, 11> offensiveSpells = {{
        {},
        {2, 6, 11},
        {15, 18},
        {24, 26, 29, 32},
        {39, 41},
        {46, 47, 51, 59},
        {59, 65},
        {68, 70, 76},
        {78, 87},
        {90, 93, 95},
        {68, 71, 77},
    }};
    static const std::array<std::vector<uint32_t>, 11> defensiveSpells = {{
        {},
        {5},
        {17},
        {26},
        {38},
        {46, 47, 51, 52},
        {59, 65},
        {68, 71, 77},
        {86},
        {95},
        {68, 71, 77},
    }};

    const uint32_t schoolIndex = std::clamp<uint32_t>(magicSchoolIndex(pMonsterSettings), 1u, 10u);
    const bool defensive =
        lowercaseCopy(pMonsterSettings != nullptr ? pMonsterSettings->preferredMagic : "") == "self"
        || (magicStyle && spellSlot > 0);
    return generatedSpellFromSet(
        defensive ? defensiveSpells[schoolIndex] : offensiveSpells[schoolIndex],
        bolsterStep,
        spellSlot,
        otherSpellId);
}

void applyGeneratedAbilities(
    GameplayMonsterBolsterResult &result,
    const MonsterTable::MonsterStatsEntry &stats,
    const MergedBolsterMonsterEntry *pMonsterSettings,
    bool magicStyle)
{
    if (result.monsterAllowsNewRangedAttacks && stats.attack2Chance <= 0)
    {
        result.generatedAttack2 = true;
        result.generatedAttack2IsRanged = true;
        result.copyAttack1DamageToAttack2 = true;
        result.generatedAttack2MissileType = generatedProjectileToken(stats, pMonsterSettings);
        result.generatedAttack2Chance = std::min(result.bolsterStep * 10, 35);
    }

    if (!result.monsterAllowsNewSpells)
    {
        return;
    }

    if (!stats.hasSpell1 && (result.bolsterStep >= 1 || magicStyle))
    {
        result.generatedSpell1Id = generatedSpellId(pMonsterSettings, magicStyle, result.bolsterStep, 0, 0);
        result.generatedSpell1UseChance = magicStyle ? 60 : 35;
        result.spell1SkillLevel = generatedSpellSkillLevel(magicStyle);
        result.spell1SkillMastery = generatedSpellSkillMastery(magicStyle);
    }

    if (!stats.hasSpell2 && (result.bolsterStep >= 2 || (magicStyle && result.bolsterStep >= 1)))
    {
        result.generatedSpell2Id =
            generatedSpellId(pMonsterSettings, magicStyle, result.bolsterStep, 1, result.generatedSpell1Id);
        result.generatedSpell2UseChance = magicStyle ? 35 : 20;
        result.spell2SkillLevel = generatedSpellSkillLevel(magicStyle);
        result.spell2SkillMastery = generatedSpellSkillMastery(magicStyle);
    }
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

int gameplayBolsterPlayerArmorClass(
    int armorClass,
    int monsterLevel,
    int playerBaseLevel,
    bool bolsterAffectsArmorClass)
{
    if (!bolsterAffectsArmorClass)
    {
        return std::max(0, armorClass);
    }

    const double levelRatio =
        std::min(
            static_cast<double>(std::max(0, monsterLevel)) / static_cast<double>(std::max(1, playerBaseLevel)),
            1.0);
    return std::max(0, static_cast<int>(std::lround(static_cast<double>(std::max(0, armorClass)) * levelRatio)));
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
        || !context.bolsterMonstersEnabled
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
        applyGeneratedAbilities(result, stats, pMonsterSettings, magicStyle);
    }

    if (!statsEnabled)
    {
        return result;
    }

    if (monsterKindBaseId(monsterId) == SpecialElementalHpFormulaTarget)
    {
        const double heightMultiplier =
            pMonsterSettings != nullptr && pMonsterSettings->sizeAffectsHp
                ? std::max(1.0, static_cast<double>(monsterHeight) / 160.0)
                : 1.0;
        result.maxHp = std::min(
            MaximumBolsteredHitPoints,
            std::max(
                1,
                static_cast<int>(std::lround(
                    static_cast<double>(std::max(1, stats.hitPoints))
                    + heightMultiplier
                        * (static_cast<double>(std::max(1, stats.hitPoints)) / static_cast<double>(familyLevel))
                            * static_cast<double>(basePartyLevel - familyLevel)))));
    }
    else
    {
        result.maxHp = cappedBolsteredHitPoints(
            std::max(1, stats.hitPoints),
            familyLevel,
            basePartyLevel,
            pMonsterSettings != nullptr && pMonsterSettings->sizeAffectsHp,
            monsterHeight,
            pMonsterSettings);
    }
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
    applyGeneratedAbilities(result, stats, pMonsterSettings, magicStyle);

    return result;
}
}
