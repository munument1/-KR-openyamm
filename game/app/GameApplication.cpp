#include "game/app/GameApplication.h"

#include "game/StringUtils.h"
#include "game/gameplay/GameMechanics.h"
#include "game/gameplay/GameplayHeldItemController.h"
#include "game/scene/IndoorSceneRuntime.h"
#include "game/scene/OutdoorSceneRuntime.h"
#include "game/items/ItemGenerator.h"
#include "game/party/SkillData.h"
#include "game/party/SpellIds.h"
#include "game/party/SpellSchool.h"
#include "game/render/TextureFiltering.h"
#include "game/events/EventDialogContent.h"
#include "game/events/EventRuntime.h"
#include "game/events/EvtEnums.h"
#include "game/maps/MapIdentity.h"
#include "game/tables/ClassMultiplierTable.h"
#include "game/tables/ItemTable.h"
#include "game/ui/screens/ArcomageScreen.h"
#include "game/ui/screens/CutsceneVideoScreen.h"
#include "game/ui/screens/LoadGameScreen.h"
#include "game/ui/screens/LoadingOverlayScreen.h"
#include "game/ui/screens/MainMenuScreen.h"
#include "game/ui/screens/NewGameScreen.h"
#include "game/ui/screens/WinGameScreen.h"
#include "engine/TextTable.h"

#include <imgui.h>
#include <backends/imgui_impl_sdl3.h>
#include <SDL3/SDL.h>
#include <bgfx/bgfx.h>

#include <algorithm>
#include <array>
#include <cctype>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <functional>
#include <iostream>
#include <random>
#include <sstream>
#include <string_view>

namespace OpenYAMM::Game
{
namespace
{
double millisecondsFromNanoseconds(uint64_t nanoseconds)
{
    return static_cast<double>(nanoseconds) / 1000000.0;
}

bool mapLoadTimingEnabled()
{
    const char *pValue = std::getenv("OPENYAMM_MAP_LOAD_TIMING");
    return pValue != nullptr && std::string_view(pValue) != "0" && std::string_view(pValue) != "false";
}

TextureFilterMode textureFilterModeFromSetting(const std::string &value, TextureFilterMode fallback)
{
    const std::string normalized = toLowerCopy(value);

    if (normalized == "nearest" || normalized == "point")
    {
        return TextureFilterMode::Nearest;
    }

    if (normalized == "linear" || normalized == "bilinear")
    {
        return TextureFilterMode::Linear;
    }

    if (normalized == "anisotropic" || normalized == "aniso")
    {
        return TextureFilterMode::Anisotropic;
    }

    return fallback;
}

TextureFilteringConfig textureFilteringConfigFromSettings(const GameSettings &settings)
{
    TextureFilteringConfig config = {};
    config.enabled = settings.textureFiltering;
    config.terrain = textureFilterModeFromSetting(settings.terrainFiltering, TextureFilterMode::Anisotropic);
    config.bmodel = textureFilterModeFromSetting(settings.bmodelFiltering, TextureFilterMode::Anisotropic);
    config.sky = config.terrain;
    config.billboard = textureFilterModeFromSetting(settings.billboardFiltering, TextureFilterMode::Linear);
    config.ui = textureFilterModeFromSetting(settings.uiFiltering, TextureFilterMode::Linear);
    config.text = textureFilterModeFromSetting(settings.textFiltering, TextureFilterMode::Nearest);
    return config;
}

class MapLoadTimingLogger
{
public:
    MapLoadTimingLogger(const std::string &mapFileName, const std::string &scope)
        : m_enabled(mapLoadTimingEnabled())
        , m_mapFileName(mapFileName)
        , m_scope(scope)
        , m_startTickNanoseconds(SDL_GetTicksNS())
        , m_lastTickNanoseconds(m_startTickNanoseconds)
    {
        if (m_enabled)
        {
            std::cerr
                << "[MapLoadTiming] map=" << m_mapFileName
                << " begin=" << m_scope
                << '\n';
        }
    }

    void stage(const std::string &stageName)
    {
        if (!m_enabled)
        {
            return;
        }

        const uint64_t nowNanoseconds = SDL_GetTicksNS();
        const uint64_t stageNanoseconds = nowNanoseconds - m_lastTickNanoseconds;
        const uint64_t totalNanoseconds = nowNanoseconds - m_startTickNanoseconds;
        m_lastTickNanoseconds = nowNanoseconds;

        std::cerr
            << "[MapLoadTiming] map=" << m_mapFileName
            << " scope=" << m_scope
            << " stage=\"" << stageName << "\""
            << " delta_ms=" << millisecondsFromNanoseconds(stageNanoseconds)
            << " total_ms=" << millisecondsFromNanoseconds(totalNanoseconds)
            << '\n';
    }

private:
    bool m_enabled = false;
    std::string m_mapFileName;
    std::string m_scope;
    uint64_t m_startTickNanoseconds = 0;
    uint64_t m_lastTickNanoseconds = 0;
};

constexpr float Pi = 3.14159265358979323846f;
constexpr uint32_t DefaultRosterPartyMemberCount = 3;
constexpr const char *DefaultStartupMapFile = "out01.odm";
constexpr int MainMenuMusicTrack = 14;
constexpr int LoadingOverlayBackgroundCount = 5;
constexpr uint32_t DungeonTransitionOverlayFrameMilliseconds = 16;
constexpr uint32_t BronzeRingItemId = 137;
constexpr uint32_t GoldRingItemId = 138;
constexpr uint32_t PotionBottleItemId = 220;
constexpr uint32_t FirstDebugWandItemId = 152;
constexpr uint32_t LastDebugWandItemId = 176;
constexpr const char *DwiRespawnMapFile = "out01.odm";
constexpr const char *RavenshoreRespawnMapFile = "out02.odm";
constexpr const char *PartyDefeatCutsceneDirectory = "Videos/Cutscenes";
constexpr const char *PartyDefeatCutsceneStem = "LoseGame";
constexpr const char *EventMovieCutsceneDirectory = "Videos/Cutscenes";
constexpr const char *WinGameCutsceneStem = "wingame";
constexpr size_t MaxPendingInputLength = 64;
constexpr std::array<uint32_t, 3> Level1ReagentItemIds = {{200, 205, 210}};
constexpr std::array<uint32_t, 18> DebugUnlockedTownPortalQBits = {{
    301, 302, 303, 304, 305, 306,
    310, 311, 312, 313, 314, 315,
    718, 719, 720, 721, 722, 723}};
constexpr float EnterDungeonSpeechDelaySeconds = 2.0f;

bool sameMapFileName(const std::string &left, const std::string &right)
{
    return toLowerCopy(left) == toLowerCopy(right);
}

bool isDungeonMapFileName(const std::string &mapFileName)
{
    return toLowerCopy(mapFileName).ends_with(".blv");
}

std::string trimCopy(std::string_view value)
{
    size_t first = 0;

    while (first < value.size() && std::isspace(static_cast<unsigned char>(value[first])) != 0)
    {
        ++first;
    }

    size_t last = value.size();

    while (last > first && std::isspace(static_cast<unsigned char>(value[last - 1])) != 0)
    {
        --last;
    }

    return std::string(value.substr(first, last - first));
}

std::optional<int32_t> parseInt32Argument(const std::string &value)
{
    if (value.empty())
    {
        return std::nullopt;
    }

    char *pEnd = nullptr;
    const long parsed = std::strtol(value.c_str(), &pEnd, 10);

    if (pEnd == nullptr || *pEnd != '\0')
    {
        return std::nullopt;
    }

    return static_cast<int32_t>(parsed);
}

std::optional<float> parseFloatArgument(const std::string &value)
{
    if (value.empty())
    {
        return std::nullopt;
    }

    char *pEnd = nullptr;
    const float parsed = std::strtof(value.c_str(), &pEnd);

    if (pEnd == nullptr || *pEnd != '\0')
    {
        return std::nullopt;
    }

    return parsed;
}

std::string boolString(bool value)
{
    return value ? "true" : "false";
}

std::string debugEngineEnglishDataTablePath(std::string_view fileName)
{
    return "engine/data_tables/english/" + std::string(fileName);
}

std::vector<std::vector<std::string>> rowsFromTextTable(const Engine::TextTable &table)
{
    std::vector<std::vector<std::string>> rows;
    rows.reserve(table.getRowCount());

    for (size_t rowIndex = 0; rowIndex < table.getRowCount(); ++rowIndex)
    {
        rows.push_back(table.getRow(rowIndex));
    }

    return rows;
}

std::string lowerSearchText(const std::string &value)
{
    std::string result;
    result.reserve(value.size());

    for (char character : value)
    {
        if (std::isalnum(static_cast<unsigned char>(character)) != 0)
        {
            result.push_back(static_cast<char>(std::tolower(static_cast<unsigned char>(character))));
        }
        else if (!result.empty() && result.back() != ' ')
        {
            result.push_back(' ');
        }
    }

    while (!result.empty() && result.back() == ' ')
    {
        result.pop_back();
    }

    return result;
}

std::string compactSearchText(const std::string &value)
{
    std::string result;

    for (char character : lowerSearchText(value))
    {
        if (character != ' ')
        {
            result.push_back(character);
        }
    }

    return result;
}

std::vector<std::string> searchTokens(const std::string &query)
{
    std::vector<std::string> tokens;
    std::istringstream stream(lowerSearchText(query));
    std::string token;

    while (stream >> token)
    {
        tokens.push_back(token);
    }

    return tokens;
}

std::string upperSearchText(std::string value)
{
    for (char &character : value)
    {
        character = static_cast<char>(std::toupper(static_cast<unsigned char>(character)));
    }

    return value;
}

int itemSearchScore(const ItemDefinition &item, const std::string &query)
{
    const std::string normalizedQuery = lowerSearchText(query);
    const std::string compactQuery = compactSearchText(query);

    if (normalizedQuery.empty())
    {
        return 0;
    }

    const std::string idText = std::to_string(item.itemId);

    if (idText == normalizedQuery)
    {
        return 20000;
    }

    const std::string haystack =
        item.name + " " + item.unidentifiedName + " " + item.iconName + " " + item.skillGroup + " " + item.notes;
    const std::string normalizedHaystack = lowerSearchText(haystack);
    const std::string compactHaystack = compactSearchText(haystack);
    int score = 0;

    if (lowerSearchText(item.name) == normalizedQuery)
    {
        score = std::max(score, 12000);
    }

    if (!compactQuery.empty() && compactSearchText(item.name).find(compactQuery) != std::string::npos)
    {
        score = std::max(score, 9000 - static_cast<int>(item.name.size()));
    }

    if (!compactQuery.empty() && compactHaystack.find(compactQuery) != std::string::npos)
    {
        score = std::max(score, 7000 - static_cast<int>(compactHaystack.find(compactQuery)));
    }

    const std::vector<std::string> tokens = searchTokens(query);
    int tokenScore = 0;

    for (const std::string &token : tokens)
    {
        if (normalizedHaystack.find(token) == std::string::npos)
        {
            tokenScore = 0;
            break;
        }

        tokenScore += 500;
    }

    return std::max(score, tokenScore);
}

std::vector<const ItemDefinition *> findItemMatches(const ItemTable &itemTable, const std::string &query, size_t limit)
{
    struct ScoredItem
    {
        const ItemDefinition *pItem = nullptr;
        int score = 0;
    };

    std::vector<ScoredItem> scoredItems;

    for (const ItemDefinition &item : itemTable.entries())
    {
        const int score = itemSearchScore(item, query);

        if (score > 0)
        {
            scoredItems.push_back({.pItem = &item, .score = score});
        }
    }

    std::sort(
        scoredItems.begin(),
        scoredItems.end(),
        [](const ScoredItem &left, const ScoredItem &right)
        {
            if (left.score != right.score)
            {
                return left.score > right.score;
            }

            return left.pItem->itemId < right.pItem->itemId;
        });

    std::vector<const ItemDefinition *> result;
    result.reserve(std::min(limit, scoredItems.size()));

    for (const ScoredItem &scoredItem : scoredItems)
    {
        if (result.size() >= limit)
        {
            break;
        }

        result.push_back(scoredItem.pItem);
    }

    return result;
}

struct DebugAwardEntry
{
    uint32_t id = 0;
    std::string text;
    std::string notes;
};

std::vector<DebugAwardEntry> loadDebugAwardEntries(const Engine::AssetFileSystem *pAssetFileSystem)
{
    std::vector<DebugAwardEntry> entries;

    if (pAssetFileSystem == nullptr)
    {
        return entries;
    }

    const std::optional<std::string> contents =
        pAssetFileSystem->readTextFile(debugEngineEnglishDataTablePath("awards.txt"));

    if (!contents)
    {
        return entries;
    }

    const std::optional<Engine::TextTable> table = Engine::TextTable::parseTabSeparated(*contents);

    if (!table)
    {
        return entries;
    }

    for (const std::vector<std::string> &row : rowsFromTextTable(*table))
    {
        if (row.size() < 2 || row[0] == "A Bit")
        {
            continue;
        }

        const std::optional<int32_t> id = parseInt32Argument(row[0]);

        if (!id || *id <= 0)
        {
            continue;
        }

        DebugAwardEntry entry = {};
        entry.id = static_cast<uint32_t>(*id);
        entry.text = row[1];
        entry.notes = row.size() > 3 ? row[3] : std::string();
        entries.push_back(std::move(entry));
    }

    return entries;
}

std::string normalizePromptAnswer(const std::string &value)
{
    return toLowerCopy(trimCopy(value));
}

std::string trimEventMovieName(const std::string &movieName)
{
    size_t first = 0;
    while (first < movieName.size() && std::isspace(static_cast<unsigned char>(movieName[first])) != 0)
    {
        ++first;
    }

    size_t last = movieName.size();
    while (last > first && std::isspace(static_cast<unsigned char>(movieName[last - 1])) != 0)
    {
        --last;
    }

    std::string trimmed = movieName.substr(first, last - first);
    while (trimmed.size() >= 2 && trimmed.front() == '"' && trimmed.back() == '"')
    {
        trimmed = trimmed.substr(1, trimmed.size() - 2);
    }

    return trimmed;
}

std::string eventMovieStemFromName(const std::string &movieName)
{
    std::string stem = trimEventMovieName(movieName);
    std::replace(stem.begin(), stem.end(), '\\', '/');

    const size_t slashPosition = stem.find_last_of('/');
    if (slashPosition != std::string::npos)
    {
        stem = stem.substr(slashPosition + 1);
    }

    if (toLowerCopy(stem).ends_with(".ogv"))
    {
        stem.resize(stem.size() - 4);
    }

    return trimEventMovieName(stem);
}

std::string pluralizedUnit(uint64_t value, const char *pSingular, const char *pPlural)
{
    return value == 1 ? pSingular : pPlural;
}

std::string formatWinGameDuration(float currentGameMinutes)
{
    constexpr float GameStartMinutes = 9.0f * 60.0f;
    constexpr uint64_t MinutesPerDay = 24u * 60u;
    constexpr uint64_t DaysPerMonth = 28u;
    constexpr uint64_t MonthsPerYear = 12u;

    const float elapsedGameMinutes = std::max(0.0f, currentGameMinutes - GameStartMinutes);
    uint64_t totalDays = static_cast<uint64_t>(std::floor(elapsedGameMinutes / static_cast<float>(MinutesPerDay)));
    const uint64_t years = totalDays / (DaysPerMonth * MonthsPerYear);
    totalDays %= DaysPerMonth * MonthsPerYear;
    const uint64_t months = totalDays / DaysPerMonth;
    const uint64_t days = totalDays % DaysPerMonth;

    return "Total Time: " + std::to_string(years) + " " + pluralizedUnit(years, "Year", "Years")
        + ", " + std::to_string(months) + " " + pluralizedUnit(months, "Month", "Months")
        + ", " + std::to_string(days) + " " + pluralizedUnit(days, "Day", "Days");
}

uint64_t calculateWinGameScore(const Party &party, float currentGameMinutes)
{
    constexpr float GameStartMinutes = 9.0f * 60.0f;
    constexpr uint64_t MinutesPerDay = 24u * 60u;

    const float elapsedGameMinutes = std::max(0.0f, currentGameMinutes - GameStartMinutes);
    const uint64_t totalDays = std::max<uint64_t>(
        1u,
        static_cast<uint64_t>(std::floor(elapsedGameMinutes / static_cast<float>(MinutesPerDay))));
    uint64_t totalExperience = 0;

    for (const Character &member : party.members())
    {
        totalExperience += member.experience;
    }

    return totalExperience / totalDays;
}

std::string winGameCharacterLine(const Party &party)
{
    const std::vector<Character> &members = party.members();

    if (members.empty())
    {
        return "Adventurer the Level 1 Adventurer";
    }

    const Character &leader = members.front();
    const std::string className = !leader.className.empty() ? leader.className : leader.role;
    const std::string displayClass = !className.empty() ? displayClassName(className) : "Adventurer";
    const uint32_t level = std::max<uint32_t>(1u, leader.level);

    return leader.name + " the Level " + std::to_string(level) + " " + displayClass;
}

std::string resolveEventMovieStem(
    const Engine::AssetFileSystem &assetFileSystem,
    const std::string &movieName)
{
    const std::string requestedStem = eventMovieStemFromName(movieName);

    if (requestedStem.empty())
    {
        return {};
    }

    const std::string requestedFileName = toLowerCopy(requestedStem + ".ogv");
    const std::vector<std::string> entries = assetFileSystem.enumerate(EventMovieCutsceneDirectory);

    for (const std::string &entry : entries)
    {
        if (toLowerCopy(entry) == requestedFileName)
        {
            return std::filesystem::path(entry).stem().string();
        }
    }

    return requestedStem;
}

std::optional<size_t> chooseRandomActablePartyMember(const Party &party)
{
    std::vector<size_t> actableMemberIndices;

    for (size_t memberIndex = 0; memberIndex < party.members().size(); ++memberIndex)
    {
        const Character *pMember = party.member(memberIndex);

        if (pMember != nullptr && GameMechanics::canAct(*pMember))
        {
            actableMemberIndices.push_back(memberIndex);
        }
    }

    if (actableMemberIndices.empty())
    {
        return std::nullopt;
    }

    static thread_local std::mt19937 rng(std::random_device{}());
    std::uniform_int_distribution<size_t> distribution(0, actableMemberIndices.size() - 1);
    return actableMemberIndices[distribution(rng)];
}

int remapLoadingProgress(int localProgress, int startProgress, int endProgress)
{
    const int clampedLocal = std::clamp(localProgress, 0, 100);
    return startProgress + (endProgress - startProgress) * clampedLocal / 100;
}

float mapMoveHeadingDegreesToYawRadians(int32_t directionDegrees)
{
    return static_cast<float>(directionDegrees) * Pi / 180.0f;
}

std::optional<uint32_t> starterItemIdForSkill(const std::string &skillName)
{
    const std::string canonicalName = canonicalSkillName(skillName);

    if (canonicalName == "Staff")
    {
        return 79;
    }

    if (canonicalName == "Sword")
    {
        return 1;
    }

    if (canonicalName == "Dagger")
    {
        return 21;
    }

    if (canonicalName == "Axe")
    {
        return 31;
    }

    if (canonicalName == "Spear")
    {
        return 41;
    }

    if (canonicalName == "Bow")
    {
        return 56;
    }

    if (canonicalName == "Mace")
    {
        return 66;
    }

    if (canonicalName == "Shield")
    {
        return 99;
    }

    if (canonicalName == "LeatherArmor")
    {
        return 84;
    }

    if (canonicalName == "ChainArmor")
    {
        return 89;
    }

    if (canonicalName == "PlateArmor")
    {
        return 94;
    }

    return std::nullopt;
}

bool isStarterMagicSkill(const std::string &skillName)
{
    const std::string canonicalName = canonicalSkillName(skillName);

    return canonicalName == "FireMagic"
        || canonicalName == "AirMagic"
        || canonicalName == "WaterMagic"
        || canonicalName == "EarthMagic"
        || canonicalName == "SpiritMagic"
        || canonicalName == "MindMagic"
        || canonicalName == "BodyMagic"
        || canonicalName == "LightMagic"
        || canonicalName == "DarkMagic";
}

std::optional<uint32_t> spellbookItemIdForSpell(
    const ItemTable &itemTable,
    uint32_t spellId)
{
    constexpr uint32_t FirstSpellbookItemId = 400;

    if (spellId == 0 || spellId > spellIdValue(SpellId::SoulDrinker))
    {
        return std::nullopt;
    }

    const uint32_t itemId = FirstSpellbookItemId + (spellId - spellIdValue(SpellId::TorchLight));
    const ItemDefinition *pDefinition = itemTable.get(itemId);

    if (pDefinition == nullptr || pDefinition->equipStat != "Book")
    {
        return std::nullopt;
    }

    return itemId;
}

void addStarterInventoryItem(Character &character, InventoryItem item)
{
    item.identified = true;
    character.addInventoryItem(item);
}

InventoryItem makeStarterInventoryItem(
    uint32_t itemId,
    const ItemTable &itemTable)
{
    InventoryItem item = ItemGenerator::makeInventoryItem(itemId, itemTable, ItemGenerationMode::Generic);
    item.identified = true;
    return item;
}

InventoryItem generateStarterRing(
    const ItemTable &itemTable,
    const StandardItemEnchantTable &standardItemEnchantTable,
    const SpecialItemEnchantTable &specialItemEnchantTable)
{
    std::random_device randomDevice;
    std::mt19937 rng(randomDevice());
    const ItemGenerationRequest request = {
        .treasureLevel = 2,
        .mode = ItemGenerationMode::Generic,
        .allowRareItems = false
    };

    const std::optional<InventoryItem> generatedRing = ItemGenerator::generateRandomInventoryItem(
        itemTable,
        standardItemEnchantTable,
        specialItemEnchantTable,
        request,
        nullptr,
        rng,
        [](const ItemDefinition &entry)
        {
            return entry.equipStat == "Ring"
                && (entry.itemId == BronzeRingItemId || entry.itemId == GoldRingItemId);
        });

    if (generatedRing)
    {
        InventoryItem ring = *generatedRing;
        ring.identified = true;
        return ring;
    }

    return makeStarterInventoryItem(BronzeRingItemId, itemTable);
}

void grantCreatedCharacterStarterItems(
    Character &character,
    const ItemTable &itemTable,
    const StandardItemEnchantTable &standardItemEnchantTable,
    const SpecialItemEnchantTable &specialItemEnchantTable)
{
    addStarterInventoryItem(
        character,
        generateStarterRing(itemTable, standardItemEnchantTable, specialItemEnchantTable));
    addStarterInventoryItem(character, makeStarterInventoryItem(PotionBottleItemId, itemTable));

    std::random_device randomDevice;
    std::mt19937 rng(randomDevice());
    const size_t reagentIndex = std::uniform_int_distribution<size_t>(0, Level1ReagentItemIds.size() - 1)(rng);
    addStarterInventoryItem(character, makeStarterInventoryItem(Level1ReagentItemIds[reagentIndex], itemTable));

    for (const auto &[skillName, skill] : character.skills)
    {
        if (skill.level == 0)
        {
            continue;
        }

        const std::optional<uint32_t> starterItemId = starterItemIdForSkill(skillName);

        if (starterItemId)
        {
            addStarterInventoryItem(character, makeStarterInventoryItem(*starterItemId, itemTable));
            continue;
        }

        if (!isStarterMagicSkill(skillName))
        {
            continue;
        }

        const std::optional<std::pair<uint32_t, uint32_t>> spellRange = spellIdRangeForMagicSkill(skillName);

        if (!spellRange)
        {
            continue;
        }

        for (uint32_t spellId = spellRange->first;
             spellId <= spellRange->second && spellId < spellRange->first + 2;
             ++spellId)
        {
            const std::optional<uint32_t> spellbookItemId = spellbookItemIdForSpell(itemTable, spellId);

            if (!spellbookItemId)
            {
                continue;
            }

            addStarterInventoryItem(character, makeStarterInventoryItem(*spellbookItemId, itemTable));
        }
    }
}

void seedSimulatedPartyFromRoster(
    Party &party,
    const RosterTable &rosterTable,
    std::optional<uint32_t> selectedRosterId)
{
    static constexpr std::array<uint32_t, DefaultRosterPartyMemberCount> DefaultPartyRosterIds = {{11, 5, 4}};

    std::vector<uint32_t> rosterIds;
    rosterIds.reserve(DefaultRosterPartyMemberCount);

    if (selectedRosterId.has_value())
    {
        rosterIds.push_back(*selectedRosterId);
    }

    for (uint32_t rosterId : DefaultPartyRosterIds)
    {
        if (selectedRosterId.has_value() && rosterId == *selectedRosterId)
        {
            continue;
        }

        rosterIds.push_back(rosterId);

        if (rosterIds.size() >= DefaultRosterPartyMemberCount)
        {
            break;
        }
    }

    if (rosterIds.size() < DefaultRosterPartyMemberCount)
    {
        for (const RosterEntry *pEntry : rosterTable.getEntriesSortedById())
        {
            if (pEntry == nullptr)
            {
                continue;
            }

            if (std::find(rosterIds.begin(), rosterIds.end(), pEntry->id) != rosterIds.end())
            {
                continue;
            }

            rosterIds.push_back(pEntry->id);

            if (rosterIds.size() >= DefaultRosterPartyMemberCount)
            {
                break;
            }
        }
    }

    if (party.members().size() <= 1)
    {
        return;
    }

    const size_t replaceCount = std::min(party.members().size() - 1, rosterIds.size());

    for (size_t memberIndex = 0; memberIndex < replaceCount; ++memberIndex)
    {
        const RosterEntry *pRosterEntry = rosterTable.get(rosterIds[memberIndex]);

        if (pRosterEntry != nullptr)
        {
            party.replaceMemberWithRosterEntry(memberIndex + 1, *pRosterEntry);
        }
    }
}

bool partyMemberHasInventoryItem(const Character &character, uint32_t itemId)
{
    return std::any_of(
        character.inventory.begin(),
        character.inventory.end(),
        [itemId](const InventoryItem &item)
        {
            return item.objectDescriptionId == itemId;
        });
}

void seedDebugWandsIntoParty(Party &party, const ItemTable &itemTable)
{
    Character *pPrimaryMember = party.member(1);
    Character *pOverflowMember = party.member(2);

    if (pPrimaryMember == nullptr)
    {
        return;
    }

    for (uint32_t itemId = FirstDebugWandItemId; itemId <= LastDebugWandItemId; ++itemId)
    {
        if (partyMemberHasInventoryItem(*pPrimaryMember, itemId)
            || (pOverflowMember != nullptr && partyMemberHasInventoryItem(*pOverflowMember, itemId)))
        {
            continue;
        }

        InventoryItem item = ItemGenerator::makeInventoryItem(itemId, itemTable, ItemGenerationMode::Generic);
        item.identified = true;

        if (pPrimaryMember->addInventoryItem(item))
        {
            continue;
        }

        if (pOverflowMember != nullptr)
        {
            pOverflowMember->addInventoryItem(item);
        }
    }
}

float normalizedVolumeLevel(int level)
{
    return std::clamp(static_cast<float>(level) / 9.0f, 0.0f, 1.0f);
}

Engine::WindowMode engineWindowModeForSettings(WindowMode mode)
{
    switch (mode)
    {
    case WindowMode::Windowed:
        return Engine::WindowMode::Windowed;

    case WindowMode::WindowedFullscreen:
        return Engine::WindowMode::WindowedFullscreen;

    case WindowMode::Fullscreen:
        return Engine::WindowMode::Fullscreen;
    }

    return Engine::WindowMode::Windowed;
}

float mouseRotateSpeedForTurnRate(TurnRateMode turnRate)
{
    switch (turnRate)
    {
    case TurnRateMode::X16:
        return 0.0024f;

    case TurnRateMode::X32:
        return 0.0034f;

    case TurnRateMode::Smooth:
        return 0.0045f;
    }

    return 0.0034f;
}

Character buildFreshCreatedCharacter(
    const Character &sourceCharacter,
    const ClassMultiplierTable &classMultiplierTable,
    const ItemTable &itemTable,
    const StandardItemEnchantTable &standardItemEnchantTable,
    const SpecialItemEnchantTable &specialItemEnchantTable,
    bool preserveDebugLoadout)
{
    Character character = sourceCharacter;
    character.rosterId = 0;
    character.birthYear = character.birthYear != 0 ? character.birthYear : 1150;

    if (!preserveDebugLoadout)
    {
        character.experience = 0;
        character.level = 1;
        character.skillPoints = 0;
        character.knownSpellIds.clear();
        character.equipment = {};
        character.equipmentRuntime = {};
    }

    character.quickSpellName.clear();
    character.attackSpellName.clear();
    character.baseResistances = {};
    character.permanentBonuses = {};
    character.magicalBonuses = {};
    character.permanentImmunities = {};
    character.magicalImmunities = {};
    character.permanentConditionImmunities = {};
    character.magicalConditionImmunities = {};
    character.conditions = {};
    character.awards.clear();
    character.eventVariables.clear();
    character.recoverySecondsRemaining = 0.0f;
    character.armorClassModifier = 0;
    character.levelModifier = 0;
    character.ageModifier = 0;
    character.playerBits.clear();
    character.npcs2 = 0;
    character.merchantBonus = 0;
    character.weaponEnchantmentDamageBonus = 0;
    character.vampiricHealFraction = 0.0f;
    character.physicalAttackDisabled = false;
    character.physicalDamageImmune = false;
    character.halfMissileDamage = false;
    character.waterWalking = false;
    character.featherFalling = false;
    character.healthRegenPerSecond = 0.0f;
    character.spellRegenPerSecond = 0.0f;
    character.healthRegenAccumulator = 0.0f;
    character.spellRegenAccumulator = 0.0f;
    character.attackRecoveryReductionTicks = 0;
    character.recoveryProgressMultiplier = 1.0f;
    character.itemSkillBonuses.clear();
    character.inventory.clear();

    character.maxHealth = GameMechanics::calculateBaseCharacterMaxHealth(character, &classMultiplierTable);
    character.health = character.maxHealth;
    character.maxSpellPoints = GameMechanics::calculateBaseCharacterMaxSpellPoints(character, &classMultiplierTable);
    character.spellPoints = character.maxSpellPoints;

    if (!preserveDebugLoadout)
    {
        grantCreatedCharacterStarterItems(character, itemTable, standardItemEnchantTable, specialItemEnchantTable);
    }

    return character;
}

void setDebugTownPortalUnlocks(Party &party, bool unlocked)
{
    for (uint32_t qbitId : DebugUnlockedTownPortalQBits)
    {
        party.setQuestBit(qbitId, unlocked);
    }
}
}

GameApplication::GameApplication(const Engine::ApplicationConfig &config)
    : m_config(config)
    , m_engineApplication(
        config,
        std::bind(&GameApplication::loadGameData, this, std::placeholders::_1),
        std::bind(&GameApplication::initializeRenderer, this),
        std::bind(&GameApplication::handleSdlEvent, this, std::placeholders::_1),
        std::bind(
            &GameApplication::renderFrame,
            this,
            std::placeholders::_1,
            std::placeholders::_2,
            std::placeholders::_3,
            std::placeholders::_4
        ),
        std::bind(&GameApplication::shutdownApplication, this)
    )
    , m_gameSession()
    , m_indoorGameView(m_gameSession)
    , m_outdoorGameView(m_gameSession)
    , m_pAssetFileSystem(nullptr)
    , m_lastFrameWidth(config.windowWidth)
    , m_lastFrameHeight(config.windowHeight)
{
    m_gameSession.setSaveGameToPathCallback(
        [this](
            const std::filesystem::path &path,
            const std::string &saveName,
            const std::vector<uint8_t> &previewBmp,
            std::string &error) -> bool
        {
            static_cast<void>(error);
            return quickSaveToPath(path, saveName, previewBmp);
        });
    m_gameSession.setSettingsChangedCallback(
        [this](const GameSettings &settings)
        {
            m_settings = settings;
            std::string error;

            if (!saveGameSettings(settingsFilePath(), m_settings, error))
            {
                std::cerr << "GameApplication: failed to write settings.ini: " << error << '\n';
            }

            applyCurrentSettingsToActiveRuntime();
        });
}

int GameApplication::run()
{
    return m_engineApplication.run();
}

void GameApplication::configureDebugConsoleStyle()
{
    ImGuiStyle &style = ImGui::GetStyle();
    style.WindowRounding = 4.0f;
    style.FrameRounding = 3.0f;
    style.PopupRounding = 4.0f;
    style.ScrollbarRounding = 4.0f;
    style.WindowBorderSize = 1.0f;
    style.FrameBorderSize = 1.0f;
    style.WindowPadding = ImVec2(8.0f, 8.0f);
    style.FramePadding = ImVec2(7.0f, 4.0f);
    style.ItemSpacing = ImVec2(8.0f, 6.0f);

    ImVec4 *pColors = style.Colors;
    pColors[ImGuiCol_Text] = ImVec4(0.91f, 0.92f, 0.93f, 1.0f);
    pColors[ImGuiCol_WindowBg] = ImVec4(0.08f, 0.09f, 0.10f, 0.94f);
    pColors[ImGuiCol_ChildBg] = ImVec4(0.11f, 0.12f, 0.14f, 0.96f);
    pColors[ImGuiCol_PopupBg] = ImVec4(0.10f, 0.11f, 0.13f, 0.98f);
    pColors[ImGuiCol_Border] = ImVec4(0.20f, 0.23f, 0.27f, 1.0f);
    pColors[ImGuiCol_FrameBg] = ImVec4(0.15f, 0.17f, 0.19f, 1.0f);
    pColors[ImGuiCol_FrameBgHovered] = ImVec4(0.18f, 0.20f, 0.23f, 1.0f);
    pColors[ImGuiCol_FrameBgActive] = ImVec4(0.22f, 0.25f, 0.29f, 1.0f);
    pColors[ImGuiCol_Button] = ImVec4(0.14f, 0.16f, 0.18f, 1.0f);
    pColors[ImGuiCol_ButtonHovered] = ImVec4(0.18f, 0.20f, 0.23f, 1.0f);
    pColors[ImGuiCol_ButtonActive] = ImVec4(0.22f, 0.25f, 0.29f, 1.0f);
    pColors[ImGuiCol_Header] = ImVec4(0.16f, 0.18f, 0.20f, 1.0f);
    pColors[ImGuiCol_HeaderHovered] = ImVec4(0.20f, 0.23f, 0.26f, 1.0f);
    pColors[ImGuiCol_HeaderActive] = ImVec4(0.34f, 0.25f, 0.14f, 1.0f);
    pColors[ImGuiCol_CheckMark] = ImVec4(0.82f, 0.67f, 0.34f, 1.0f);
}

void GameApplication::registerDebugConsoleCommands()
{
    if (m_debugConsoleCommandsRegistered)
    {
        return;
    }

    const auto commandResult = [](bool success, const std::string &message)
    {
        return DebugConsole::CommandResult{.success = success, .message = message};
    };

    const auto activeParty = [this]() -> Party *
    {
        if (m_pMapSceneRuntime != nullptr)
        {
            return &m_pMapSceneRuntime->party();
        }

        return m_gameSession.partyState() ? &*m_gameSession.partyState() : nullptr;
    };

    m_debugConsole.registerCommand({
        .name = "help",
        .description = "Show available commands.",
        .usage = "help",
        .callback = [this, commandResult](const DebugConsole::CommandContext &)
        {
            std::ostringstream out;
            out << "Commands: help, cls, map, event <id>, qbit get|set|clear <id>, qbit dump [active|all|filter], "
                << "award get|set|clear <id>, award dump [active|all|filter], gold get|add|set <amount>, "
                << "food get|add|set <amount>, hp full, item search <text>, item give <id|text> [qty], "
                << "tp <x> <y> <z>, config get|set|toggle immortal|unlimited_mana|invisible, reload map";
            return commandResult(true, out.str());
        }});

    m_debugConsole.registerCommand({
        .name = "cls",
        .description = "Clear console output.",
        .usage = "cls",
        .callback = [this, commandResult](const DebugConsole::CommandContext &)
        {
            m_debugConsole.clearMessages();
            m_debugConsole.addMessage(DebugConsole::MessageKind::Info, "Console cleared.");
            return commandResult(true, "");
        }});

    m_debugConsole.registerCommand({
        .name = "map",
        .description = "Show current map information.",
        .usage = "map",
        .callback = [this, commandResult](const DebugConsole::CommandContext &)
        {
            const std::optional<MapAssetInfo> &selectedMap = m_gameDataLoader.getSelectedMap();
            std::ostringstream out;
            out << "world=" << m_activeWorldManifest.id
                << " session_map=" << m_gameSession.currentMapFileName();

            if (selectedMap)
            {
                out << " selected=" << selectedMap->map.fileName
                    << " canonical=" << selectedMap->map.canonicalId
                    << " scene=" << (selectedMap->outdoorMapData ? "outdoor" : "indoor")
                    << " local_events=" << (selectedMap->localEventProgram
                        ? selectedMap->localEventProgram->eventIds().size() : 0)
                    << " global_events=" << (selectedMap->globalEventProgram
                        ? selectedMap->globalEventProgram->eventIds().size() : 0);
            }

            return commandResult(true, out.str());
        }});

    m_debugConsole.registerCommand({
        .name = "goto",
        .description = "Jump directly to a map by merged map id.",
        .usage = "goto <map-id> [x y z direction-yaw-units]",
        .callback = [this, commandResult](const DebugConsole::CommandContext &context)
        {
            if (context.args.empty())
            {
                return commandResult(false, "Usage: goto <map-id> [x y z direction-yaw-units]");
            }

            const std::optional<int32_t> mapId = parseInt32Argument(context.args[0]);

            if (!mapId || *mapId <= 0)
            {
                return commandResult(false, "Invalid map id.");
            }

            if (m_gameDataLoader.getMapStats().findById(static_cast<uint32_t>(*mapId)) == nullptr)
            {
                return commandResult(false, "Unknown map id.");
            }

            PendingDebugMapJump pendingJump = {};
            pendingJump.mapId = *mapId;

            if (context.args.size() != 1 && context.args.size() != 5)
            {
                return commandResult(false, "Usage: goto <map-id> [x y z direction-yaw-units]");
            }

            if (context.args.size() == 5)
            {
                std::optional<int32_t> x = parseInt32Argument(context.args[1]);
                std::optional<int32_t> y = parseInt32Argument(context.args[2]);
                std::optional<int32_t> z = parseInt32Argument(context.args[3]);
                std::optional<int32_t> direction = parseInt32Argument(context.args[4]);

                if (!x || !y || !z || !direction)
                {
                    return commandResult(false, "Invalid map start coordinates.");
                }

                pendingJump.start = DebugMapJumpStart{
                    .x = *x,
                    .y = *y,
                    .z = *z,
                    .directionYawUnits = *direction,
                };
            }

            m_pendingDebugMapJump = pendingJump;
            return commandResult(true, "Queued map jump " + std::to_string(*mapId));
        }});

    m_debugConsole.registerCommand({
        .name = "event",
        .description = "Execute a map event by id.",
        .usage = "event <id>",
        .callback = [this, commandResult](const DebugConsole::CommandContext &context)
        {
            if (context.args.empty())
            {
                return commandResult(false, "Usage: event <id>");
            }

            const std::optional<int32_t> eventId = parseInt32Argument(context.args[0]);

            if (!eventId || *eventId < 0 || *eventId > 65535)
            {
                return commandResult(false, "Invalid event id.");
            }

            if (m_pMapSceneRuntime == nullptr || m_pMapSceneRuntime->eventRuntimeState() == nullptr)
            {
                return commandResult(false, "No active map runtime.");
            }

            const std::optional<MapAssetInfo> &selectedMap = m_gameDataLoader.getSelectedMap();

            if (!selectedMap)
            {
                return commandResult(false, "No selected map.");
            }

            EventRuntime eventRuntime(&m_gameDataLoader.getHouseTable());
            const bool executed = eventRuntime.executeEventById(
                selectedMap->localEventProgram,
                selectedMap->globalEventProgram,
                static_cast<uint16_t>(*eventId),
                *m_pMapSceneRuntime->eventRuntimeState(),
                &m_pMapSceneRuntime->party(),
                m_pMapSceneRuntime->sceneEventContext());
            return commandResult(executed, executed ? "Executed event " + std::to_string(*eventId) : "Event failed.");
        }});

    m_debugConsole.registerCommand({
        .name = "qbit",
        .description = "Inspect or mutate party quest bits.",
        .usage = "qbit get|set|clear <id> | qbit dump [active|all|filter]",
        .callback = [this, activeParty, commandResult](const DebugConsole::CommandContext &context)
        {
            if (context.args.empty())
            {
                return commandResult(false, "Usage: qbit get|set|clear <id> | qbit dump [active|all|filter]");
            }

            Party *pParty = activeParty();

            if (pParty == nullptr)
            {
                return commandResult(false, "No active party.");
            }

            const std::string action = toLowerCopy(context.args[0]);

            if (action == "dump")
            {
                const std::string filter = context.args.size() >= 2 ? lowerSearchText(context.args[1]) : "active";
                const bool activeOnly = filter.empty() || filter == "active";
                const bool allRows = filter == "all";
                const Party::Snapshot snapshot = pParty->snapshot();
                std::ostringstream out;
                size_t emitted = 0;

                out << "QBits";

                if (activeOnly)
                {
                    out << " active";
                }
                else if (!allRows)
                {
                    out << " matching '" << context.args[1] << "'";
                }

                out << ":\n";

                for (const JournalQuestEntry &entry : m_gameSession.data().journalQuestTable().entries())
                {
                    const bool isActive = snapshot.questBits.contains(entry.qbitId);
                    const std::string haystack =
                        lowerSearchText(entry.text + " " + entry.notes + " " + entry.owner);

                    if ((activeOnly && !isActive)
                        || (!activeOnly && !allRows && haystack.find(filter) == std::string::npos))
                    {
                        continue;
                    }

                    out << entry.qbitId << " [" << (isActive ? "set" : "clear") << "] "
                        << (!entry.text.empty() ? entry.text : entry.notes) << '\n';
                    ++emitted;

                    if (emitted >= 120)
                    {
                        out << "... truncated\n";
                        break;
                    }
                }

                if (emitted == 0)
                {
                    out << "<none>";
                }

                return commandResult(true, out.str());
            }

            if (context.args.size() < 2)
            {
                return commandResult(false, "Usage: qbit get|set|clear <id> | qbit dump [active|all|filter]");
            }

            const std::optional<int32_t> qbitId = parseInt32Argument(context.args[1]);

            if (!qbitId || *qbitId < 0)
            {
                return commandResult(false, "Invalid qbit id.");
            }

            const uint32_t id = static_cast<uint32_t>(*qbitId);

            if (action == "get")
            {
                return commandResult(true, "qbit " + std::to_string(id) + "=" + boolString(pParty->hasQuestBit(id)));
            }

            if (action == "set")
            {
                pParty->setQuestBit(id, true);
                return commandResult(true, "qbit " + std::to_string(id) + "=true");
            }

            if (action == "clear")
            {
                pParty->setQuestBit(id, false);
                return commandResult(true, "qbit " + std::to_string(id) + "=false");
            }

            return commandResult(false, "Usage: qbit get|set|clear <id> | qbit dump [active|all|filter]");
        }});

    m_debugConsole.registerCommand({
        .name = "award",
        .description = "Inspect or mutate party awards.",
        .usage = "award get|set|clear <id> | award dump [active|all|filter]",
        .callback = [this, activeParty, commandResult](const DebugConsole::CommandContext &context)
        {
            if (context.args.empty())
            {
                return commandResult(false, "Usage: award get|set|clear <id> | award dump [active|all|filter]");
            }

            Party *pParty = activeParty();

            if (pParty == nullptr)
            {
                return commandResult(false, "No active party.");
            }

            const std::string action = toLowerCopy(context.args[0]);

            if (action == "dump")
            {
                const std::string filter = context.args.size() >= 2 ? lowerSearchText(context.args[1]) : "active";
                const bool activeOnly = filter.empty() || filter == "active";
                const bool allRows = filter == "all";
                const std::vector<DebugAwardEntry> awards = loadDebugAwardEntries(m_pAssetFileSystem);
                std::ostringstream out;
                size_t emitted = 0;

                out << "Awards";

                if (activeOnly)
                {
                    out << " active";
                }
                else if (!allRows)
                {
                    out << " matching '" << context.args[1] << "'";
                }

                out << ":\n";

                for (const DebugAwardEntry &entry : awards)
                {
                    const bool isActive = pParty->hasAward(entry.id);
                    const std::string haystack = lowerSearchText(entry.text + " " + entry.notes);

                    if ((activeOnly && !isActive)
                        || (!activeOnly && !allRows && haystack.find(filter) == std::string::npos))
                    {
                        continue;
                    }

                    out << entry.id << " [" << (isActive ? "set" : "clear") << "] " << entry.text << '\n';
                    ++emitted;

                    if (emitted >= 120)
                    {
                        out << "... truncated\n";
                        break;
                    }
                }

                if (emitted == 0)
                {
                    out << "<none>";
                }

                return commandResult(true, out.str());
            }

            if (context.args.size() < 2)
            {
                return commandResult(false, "Usage: award get|set|clear <id> | award dump [active|all|filter]");
            }

            const std::optional<int32_t> awardId = parseInt32Argument(context.args[1]);

            if (!awardId || *awardId < 0)
            {
                return commandResult(false, "Invalid award id.");
            }

            const uint32_t id = static_cast<uint32_t>(*awardId);

            if (action == "get")
            {
                return commandResult(true, "award " + std::to_string(id) + "=" + boolString(pParty->hasAward(id)));
            }

            if (action == "set")
            {
                pParty->addAward(id);
                return commandResult(true, "award " + std::to_string(id) + "=true");
            }

            if (action == "clear")
            {
                pParty->removeAward(id);
                return commandResult(true, "award " + std::to_string(id) + "=false");
            }

            return commandResult(false, "Usage: award get|set|clear <id> | award dump [active|all|filter]");
        }});

    m_debugConsole.registerCommand({
        .name = "gold",
        .description = "Inspect or mutate party gold.",
        .usage = "gold get|add|set <amount>",
        .callback = [activeParty, commandResult](const DebugConsole::CommandContext &context)
        {
            Party *pParty = activeParty();

            if (pParty == nullptr)
            {
                return commandResult(false, "No active party.");
            }

            if (context.args.empty() || toLowerCopy(context.args[0]) == "get")
            {
                return commandResult(true, "gold=" + std::to_string(pParty->gold()));
            }

            if (context.args.size() < 2)
            {
                return commandResult(false, "Usage: gold get|add|set <amount>");
            }

            const std::optional<int32_t> amount = parseInt32Argument(context.args[1]);

            if (!amount)
            {
                return commandResult(false, "Invalid amount.");
            }

            if (toLowerCopy(context.args[0]) == "add")
            {
                pParty->addGold(*amount);
            }
            else if (toLowerCopy(context.args[0]) == "set")
            {
                pParty->addGold(*amount - pParty->gold());
            }
            else
            {
                return commandResult(false, "Usage: gold get|add|set <amount>");
            }

            return commandResult(true, "gold=" + std::to_string(pParty->gold()));
        }});

    m_debugConsole.registerCommand({
        .name = "food",
        .description = "Inspect or mutate party food.",
        .usage = "food get|add|set <amount>",
        .callback = [activeParty, commandResult](const DebugConsole::CommandContext &context)
        {
            Party *pParty = activeParty();

            if (pParty == nullptr)
            {
                return commandResult(false, "No active party.");
            }

            if (context.args.empty() || toLowerCopy(context.args[0]) == "get")
            {
                return commandResult(true, "food=" + std::to_string(pParty->food()));
            }

            if (context.args.size() < 2)
            {
                return commandResult(false, "Usage: food get|add|set <amount>");
            }

            const std::optional<int32_t> amount = parseInt32Argument(context.args[1]);

            if (!amount)
            {
                return commandResult(false, "Invalid amount.");
            }

            if (toLowerCopy(context.args[0]) == "add")
            {
                pParty->addFood(*amount);
            }
            else if (toLowerCopy(context.args[0]) == "set")
            {
                pParty->addFood(*amount - pParty->food());
            }
            else
            {
                return commandResult(false, "Usage: food get|add|set <amount>");
            }

            return commandResult(true, "food=" + std::to_string(pParty->food()));
        }});

    m_debugConsole.registerCommand({
        .name = "hp",
        .description = "Heal the party.",
        .usage = "hp full",
        .callback = [activeParty, commandResult](const DebugConsole::CommandContext &context)
        {
            if (context.args.empty() || toLowerCopy(context.args[0]) != "full")
            {
                return commandResult(false, "Usage: hp full");
            }

            Party *pParty = activeParty();

            if (pParty == nullptr)
            {
                return commandResult(false, "No active party.");
            }

            pParty->restoreAll();
            return commandResult(true, "Party restored.");
        }});

    m_debugConsole.registerCommand({
        .name = "item",
        .description = "Search for or grant an item to the party.",
        .usage = "item search <text> | item give <id|text> [qty] | item add <id> [qty]",
        .callback = [this, activeParty, commandResult](const DebugConsole::CommandContext &context)
        {
            if (context.args.size() < 2)
            {
                return commandResult(false, "Usage: item search <text> | item give <id|text> [qty]");
            }

            const std::string action = toLowerCopy(context.args[0]);
            const ItemTable &itemTable = m_gameDataLoader.getItemTable();

            if (action == "search")
            {
                const std::vector<const ItemDefinition *> matches = findItemMatches(itemTable, context.args[1], 24);
                std::ostringstream out;
                out << "Item matches for '" << context.args[1] << "':\n";

                for (const ItemDefinition *pItem : matches)
                {
                    out << pItem->itemId << " " << pItem->name;

                    if (!pItem->unidentifiedName.empty() && pItem->unidentifiedName != pItem->name)
                    {
                        out << " (" << pItem->unidentifiedName << ")";
                    }

                    if (!pItem->skillGroup.empty())
                    {
                        out << " [" << pItem->skillGroup << "]";
                    }

                    out << '\n';
                }

                if (matches.empty())
                {
                    out << "<none>";
                }

                return commandResult(true, out.str());
            }

            if (action != "add" && action != "give")
            {
                return commandResult(false, "Usage: item search <text> | item give <id|text> [qty]");
            }

            Party *pParty = activeParty();

            if (pParty == nullptr)
            {
                return commandResult(false, "No active party.");
            }

            const std::optional<int32_t> quantity =
                context.args.size() >= 3 ? parseInt32Argument(context.args[2]) : std::optional<int32_t>(1);

            if (!quantity || *quantity <= 0)
            {
                return commandResult(false, "Invalid quantity.");
            }

            const std::optional<int32_t> parsedItemId = parseInt32Argument(context.args[1]);
            const ItemDefinition *pItem = nullptr;

            if (parsedItemId && *parsedItemId > 0)
            {
                pItem = itemTable.get(static_cast<uint32_t>(*parsedItemId));
            }
            else
            {
                const std::vector<const ItemDefinition *> matches = findItemMatches(itemTable, context.args[1], 1);
                pItem = !matches.empty() ? matches.front() : nullptr;
            }

            if (pItem == nullptr)
            {
                return commandResult(false, "No matching item.");
            }

            pParty->grantItem(pItem->itemId, static_cast<uint32_t>(*quantity));
            return commandResult(
                true,
                "Granted " + std::to_string(*quantity) + "x " + pItem->name
                    + " (" + std::to_string(pItem->itemId) + ")");
        }});

    m_debugConsole.registerCommand({
        .name = "tp",
        .description = "Teleport the party on the current map.",
        .usage = "tp <x> <y> <z>",
        .callback = [this, commandResult](const DebugConsole::CommandContext &context)
        {
            if (context.args.size() < 3)
            {
                return commandResult(false, "Usage: tp <x> <y> <z>");
            }

            const std::optional<float> x = parseFloatArgument(context.args[0]);
            const std::optional<float> y = parseFloatArgument(context.args[1]);
            const std::optional<float> z = parseFloatArgument(context.args[2]);

            if (!x || !y || !z)
            {
                return commandResult(false, "Invalid coordinates.");
            }

            if (m_pMapSceneRuntime == nullptr)
            {
                return commandResult(false, "No active map runtime.");
            }

            if (m_pMapSceneRuntime->kind() == SceneKind::Outdoor && m_pOutdoorPartyRuntime != nullptr)
            {
                m_pOutdoorPartyRuntime->teleportTo(*x, *y, *z);
            }
            else if (m_pMapSceneRuntime->kind() == SceneKind::Indoor)
            {
                IndoorSceneRuntime *pIndoorRuntime = static_cast<IndoorSceneRuntime *>(m_pMapSceneRuntime.get());
                pIndoorRuntime->partyRuntime().teleportPartyPosition(*x, *y, *z);
            }

            synchronizeSessionFromRuntime();
            return commandResult(true, "Teleported.");
        }});

    m_debugConsole.registerCommand({
        .name = "config",
        .description = "Inspect or mutate debug settings.",
        .usage = "config get|set|toggle <name> [value]",
        .callback = [this, activeParty, commandResult](const DebugConsole::CommandContext &context)
        {
            if (context.args.size() < 2)
            {
                return commandResult(
                    false,
                    "Usage: config get|set|toggle immortal|unlimited_mana|invisible|start_flying [value]");
            }

            const std::string action = toLowerCopy(context.args[0]);
            const std::string name = toLowerCopy(context.args[1]);

            const auto getSetting = [this, activeParty, &name]() -> std::optional<bool>
            {
                if (name == "immortal")
                {
                    return m_settings.immortal;
                }

                if (name == "unlimited_mana")
                {
                    return m_settings.unlimitedMana;
                }

                if (name == "start_flying" || name == "flying")
                {
                    return m_settings.startFlying;
                }

                if (name == "invisible" || name == "invisibility")
                {
                    Party *pParty = activeParty();
                    return pParty != nullptr
                        ? std::optional<bool>(pParty->hasPartyBuff(PartyBuffId::Invisibility))
                        : std::nullopt;
                }

                return std::nullopt;
            };

            const auto setSetting = [this, &name](bool value) -> bool
            {
                if (name == "immortal")
                {
                    m_settings.immortal = value;
                }
                else if (name == "unlimited_mana")
                {
                    m_settings.unlimitedMana = value;
                }
                else if (name == "start_flying" || name == "flying")
                {
                    m_settings.startFlying = value;
                }
                else
                {
                    return false;
                }

                applyCurrentSettingsToActiveRuntime();

                if (Party *pParty = m_pMapSceneRuntime != nullptr ? &m_pMapSceneRuntime->party() : nullptr)
                {
                    pParty->setDebugDamageImmune(m_settings.immortal);
                    pParty->setDebugUnlimitedMana(m_settings.unlimitedMana);
                }

                std::string error;

                if (!saveGameSettings(settingsFilePath(), m_settings, error))
                {
                    std::cerr << "GameApplication: failed to write settings.ini: " << error << '\n';
                }

                return true;
            };

            const auto setRuntimeSetting = [activeParty, &name](bool value) -> bool
            {
                if (name != "invisible" && name != "invisibility")
                {
                    return false;
                }

                Party *pParty = activeParty();

                if (pParty == nullptr)
                {
                    return false;
                }

                if (value)
                {
                    pParty->applyPartyBuff(
                        PartyBuffId::Invisibility,
                        365.0f * 24.0f * 60.0f * 60.0f,
                        0,
                        static_cast<uint32_t>(SpellId::Invisibility),
                        10,
                        SkillMastery::Grandmaster,
                        0);
                }
                else
                {
                    pParty->clearPartyBuff(PartyBuffId::Invisibility);
                }

                return true;
            };

            if (action == "get")
            {
                const std::optional<bool> value = getSetting();
                return value
                    ? commandResult(true, name + "=" + boolString(*value))
                    : commandResult(false, "Unknown setting.");
            }

            if (action == "toggle")
            {
                const std::optional<bool> value = getSetting();

                if (!value || (!setSetting(!*value) && !setRuntimeSetting(!*value)))
                {
                    return commandResult(false, "Unknown setting.");
                }

                return commandResult(true, name + "=" + boolString(!*value));
            }

            if (action == "set")
            {
                if (context.args.size() < 3)
                {
                    return commandResult(false, "Usage: config set <name> true|false");
                }

                const std::string raw = toLowerCopy(context.args[2]);
                const bool value = raw == "1" || raw == "true" || raw == "yes" || raw == "on";

                if (!setSetting(value) && !setRuntimeSetting(value))
                {
                    return commandResult(false, "Unknown setting.");
                }

                return commandResult(true, name + "=" + boolString(value));
            }

            return commandResult(false, "Usage: config get|set|toggle <name> [value]");
        }});

    m_debugConsole.registerCommand({
        .name = "reload",
        .description = "Reload current map.",
        .usage = "reload map",
        .callback = [this, commandResult](const DebugConsole::CommandContext &context)
        {
            if (context.args.empty() || toLowerCopy(context.args[0]) != "map")
            {
                return commandResult(false, "Usage: reload map");
            }

            if (m_pAssetFileSystem == nullptr || m_gameSession.currentMapFileName().empty())
            {
                return commandResult(false, "No map to reload.");
            }

            synchronizeSessionFromRuntime();

            if (!loadCurrentSessionMap(true))
            {
                return commandResult(false, "Reload failed.");
            }

            return commandResult(true, "Reloaded " + m_gameSession.currentMapFileName());
        }});

    std::vector<DebugConsole::ItemOption> itemOptions;

    for (const ItemDefinition &item : m_gameDataLoader.getItemTable().entries())
    {
        if (item.itemId == 0 || item.name.empty())
        {
            continue;
        }

        itemOptions.push_back({
            .itemId = item.itemId,
            .name = item.name,
            .unidentifiedName = item.unidentifiedName,
            .iconName = item.iconName,
            .skillGroup = item.skillGroup,
            .notes = item.notes,
        });
    }

    m_debugConsole.setItemOptions(std::move(itemOptions));

    if (m_pAssetFileSystem != nullptr)
    {
        m_debugConsole.setMapOptionsFromMapStats(m_gameDataLoader.getMapStats());
    }
    else
    {
        m_debugConsole.setMapOptions({});
    }
    m_debugConsole.addMessage(DebugConsole::MessageKind::Info, "OpenYAMM debug console ready. Type help.");
    m_debugConsoleCommandsRegistered = true;
}

bool GameApplication::initializeDebugConsoleRenderer()
{
    if (!m_settings.debugConsole)
    {
        return true;
    }

    if (m_debugConsoleRendererInitialized)
    {
        return true;
    }

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO &io = ImGui::GetIO();
    io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;
    io.IniFilename = nullptr;
    configureDebugConsoleStyle();

    SDL_Window *pWindow = SDL_GetKeyboardFocus();

    if (pWindow == nullptr)
    {
        pWindow = SDL_GetMouseFocus();
    }

    if (pWindow == nullptr)
    {
        int windowCount = 0;
        SDL_Window **ppWindows = SDL_GetWindows(&windowCount);

        if (ppWindows != nullptr && windowCount > 0)
        {
            pWindow = ppWindows[0];
        }

        SDL_free(ppWindows);
    }

    if (pWindow == nullptr || !ImGui_ImplSDL3_InitForOther(pWindow))
    {
        return false;
    }

    if (!m_debugConsoleRenderer.initialize())
    {
        ImGui_ImplSDL3_Shutdown();
        ImGui::DestroyContext();
        return false;
    }

    registerDebugConsoleCommands();
    m_debugConsoleRendererInitialized = true;
    return true;
}

void GameApplication::shutdownDebugConsoleRenderer()
{
    if (!m_debugConsoleRendererInitialized)
    {
        return;
    }

    m_debugConsoleRenderer.shutdown();
    ImGui_ImplSDL3_Shutdown();
    ImGui::DestroyContext();
    m_debugConsoleRendererInitialized = false;
    m_debugConsoleFrameBegun = false;
}

void GameApplication::beginDebugConsoleFrame()
{
    if (!m_debugConsoleRendererInitialized || m_debugConsoleFrameBegun)
    {
        return;
    }

    if (m_debugConsole.enabled())
    {
        SDL_Window *pWindow = SDL_GetMouseFocus();

        if (pWindow == nullptr)
        {
            pWindow = SDL_GetKeyboardFocus();
        }

        if (pWindow != nullptr)
        {
            SDL_SetWindowRelativeMouseMode(pWindow, false);
        }

        SDL_ShowCursor();
    }

    ImGui_ImplSDL3_NewFrame();
    m_debugConsoleRenderer.newFrame();
    ImGui::NewFrame();
    m_debugConsoleFrameBegun = true;
}

void GameApplication::renderDebugConsoleFrame(int width, int height)
{
    if (!m_debugConsoleRendererInitialized || !m_debugConsoleFrameBegun)
    {
        return;
    }

    const Party *pActiveParty = nullptr;

    if (m_pMapSceneRuntime != nullptr)
    {
        pActiveParty = &m_pMapSceneRuntime->party();
    }
    else if (m_gameSession.partyState())
    {
        pActiveParty = &*m_gameSession.partyState();
    }

    m_debugConsole.setDebugToggleStates(
        m_settings.immortal,
        m_settings.unlimitedMana,
        pActiveParty != nullptr && pActiveParty->hasPartyBuff(PartyBuffId::Invisibility));
    m_debugConsole.render(width, height);
    ImGui::Render();
    m_debugConsoleRenderer.renderDrawData(ImGui::GetDrawData());
    m_debugConsoleFrameBegun = false;
}

bool GameApplication::processPendingDebugMapJump()
{
    if (!m_pendingDebugMapJump.has_value())
    {
        return false;
    }

    const PendingDebugMapJump pendingJump = *m_pendingDebugMapJump;
    const int mapId = pendingJump.mapId;
    m_pendingDebugMapJump.reset();

    if (m_pAssetFileSystem == nullptr)
    {
        m_debugConsole.addMessage(DebugConsole::MessageKind::Error, "Map jump unavailable: no asset filesystem.");
        return false;
    }

    const MapStatsEntry *pTargetMap = m_gameDataLoader.getMapStats().findById(static_cast<uint32_t>(mapId));

    if (pTargetMap == nullptr)
    {
        m_debugConsole.addMessage(DebugConsole::MessageKind::Error, "Map jump failed: unknown map id.");
        return false;
    }

    if (m_pMapSceneRuntime != nullptr)
    {
        captureCurrentSceneState();
    }

    if (!activateWorldForMap(*pTargetMap))
    {
        m_debugConsole.addMessage(DebugConsole::MessageKind::Error, "Map jump failed: world switch failed.");
        return false;
    }
    const std::string targetWorldId = normalizeWorldId(pTargetMap->worldId);

    beginLoadingOverlay(LoadingOverlayScreen::Presentation::Fullscreen);
    renderLoadingOverlayProgress(15);

    if (!m_gameDataLoader.loadMapByIdForGameplay(*m_pAssetFileSystem, mapId))
    {
        cancelLoadingOverlay();
        m_debugConsole.addMessage(DebugConsole::MessageKind::Error, "Map jump failed: map load failed.");
        return false;
    }

    renderLoadingOverlayProgress(70);
    const std::optional<MapAssetInfo> &selectedMap = m_gameDataLoader.getSelectedMap();

    if (!selectedMap)
    {
        cancelLoadingOverlay();
        m_debugConsole.addMessage(DebugConsole::MessageKind::Error, "Map jump failed: selected map missing.");
        return false;
    }

    m_gameSession.setCurrentMapFileName(selectedMap->map.fileName);
    shutdownRenderer();

    if (!initializeSelectedMapRuntime(true))
    {
        cancelLoadingOverlay();
        m_debugConsole.addMessage(DebugConsole::MessageKind::Error, "Map jump failed: runtime init failed.");
        return false;
    }

    if (pendingJump.start.has_value())
    {
        const DebugMapJumpStart &start = *pendingJump.start;

        if (m_pMapSceneRuntime != nullptr
            && m_pMapSceneRuntime->kind() == SceneKind::Outdoor
            && m_pOutdoorPartyRuntime != nullptr)
        {
            m_pOutdoorPartyRuntime->teleportTo(
                static_cast<float>(start.x),
                static_cast<float>(start.y),
                static_cast<float>(start.z));
        }
        else if (m_pMapSceneRuntime != nullptr && m_pMapSceneRuntime->kind() == SceneKind::Indoor)
        {
            IndoorSceneRuntime *pIndoorRuntime = static_cast<IndoorSceneRuntime *>(m_pMapSceneRuntime.get());
            pIndoorRuntime->partyRuntime().teleportPartyPosition(
                static_cast<float>(start.x),
                static_cast<float>(start.y),
                static_cast<float>(start.z));
        }

        const int32_t normalizedYawUnits = ((start.directionYawUnits % 2048) + 2048) % 2048;
        const int32_t directionDegrees = normalizedYawUnits * 360 / 2048;
        const float yawRadians = mapMoveHeadingDegreesToYawRadians(directionDegrees);

        if (m_pMapSceneRuntime != nullptr && m_pMapSceneRuntime->kind() == SceneKind::Outdoor)
        {
            m_outdoorGameView.setCameraAngles(yawRadians, m_outdoorGameView.cameraPitchRadians());
        }
        else if (m_pMapSceneRuntime != nullptr && m_pMapSceneRuntime->kind() == SceneKind::Indoor)
        {
            m_indoorRenderer.setCameraAngles(yawRadians, m_indoorRenderer.cameraPitchRadians());
        }
    }

    renderLoadingOverlayProgress(95);
    completeLoadingOverlay();
    synchronizeSessionFromRuntime();
    m_debugConsole.addMessage(
        DebugConsole::MessageKind::Success,
        "Jumped to [" + upperSearchText(targetWorldId) + "] "
            + selectedMap->map.fileName + " - " + selectedMap->map.name);

    if (selectedMap->indoorMapData.has_value()
        && !selectedMap->indoorMapData->partyStartPoint.has_value()
        && !pendingJump.start.has_value())
    {
        m_debugConsole.addMessage(
            DebugConsole::MessageKind::Warning,
            "Indoor debug jump used the fallback start because this BLV has no Party Start marker.");
    }

    return true;
}

void GameApplication::handleSdlEvent(const SDL_Event &event)
{
    if (m_debugConsoleRendererInitialized)
    {
        ImGui_ImplSDL3_ProcessEvent(&event);

        if (m_settings.debugConsole
            && event.type == SDL_EVENT_KEY_DOWN
            && !event.key.repeat
            && (event.key.key == SDLK_GRAVE || event.key.scancode == SDL_SCANCODE_GRAVE))
        {
            m_debugConsole.toggleEnabled();
            m_gameSession.requestRelativeMouseMotionReset();
            return;
        }

        if (m_debugConsole.wantsGameplayInputBlocked())
        {
            const ImGuiIO &io = ImGui::GetIO();

            if (event.type == SDL_EVENT_TEXT_INPUT
                || event.type == SDL_EVENT_KEY_DOWN
                || event.type == SDL_EVENT_KEY_UP
                || event.type == SDL_EVENT_MOUSE_BUTTON_DOWN
                || event.type == SDL_EVENT_MOUSE_BUTTON_UP
                || event.type == SDL_EVENT_MOUSE_WHEEL
                || io.WantCaptureKeyboard
                || io.WantCaptureMouse)
            {
                return;
            }
        }
    }

    if (handlePendingInputPromptSdlEvent(event))
    {
        return;
    }

    IScreen *pActiveScreen = m_screenManager.activeScreen();

    if (pActiveScreen != nullptr)
    {
        pActiveScreen->handleSdlEvent(event);
    }
}

bool GameApplication::pendingInputPromptActive() const
{
    if (m_screenManager.activeScreen() != nullptr)
    {
        return false;
    }

    const IGameplayWorldRuntime *pWorldRuntime = m_gameSession.activeWorldRuntime();
    const EventRuntimeState *pRuntimeState = pWorldRuntime != nullptr ? pWorldRuntime->eventRuntimeState() : nullptr;
    const EventDialogContent &activeDialog = m_gameSession.gameplayScreenRuntime().activeEventDialog();

    return activeDialog.isActive
        && pRuntimeState != nullptr
        && pRuntimeState->pendingInputPrompt
        && pRuntimeState->pendingInputPrompt->kind == EventRuntimeState::PendingInputPrompt::Kind::InputString;
}

bool GameApplication::handlePendingInputPromptSdlEvent(const SDL_Event &event)
{
    if (!pendingInputPromptActive())
    {
        return false;
    }

    if (event.type == SDL_EVENT_TEXT_INPUT)
    {
        if (event.text.text != nullptr && m_pendingInputText.size() < MaxPendingInputLength)
        {
            const size_t remaining = MaxPendingInputLength - m_pendingInputText.size();
            m_pendingInputText.append(event.text.text, std::min(remaining, std::strlen(event.text.text)));
        }

        return true;
    }

    if (event.type != SDL_EVENT_KEY_DOWN)
    {
        return false;
    }

    if (event.key.repeat)
    {
        return true;
    }

    switch (event.key.key)
    {
        case SDLK_RETURN:
        case SDLK_KP_ENTER:
            finishPendingInputPrompt(true);
            return true;

        case SDLK_ESCAPE:
            finishPendingInputPrompt(false);
            return true;

        case SDLK_BACKSPACE:
            if (!m_pendingInputText.empty())
            {
                m_pendingInputText.pop_back();
            }
            return true;

        default:
            return true;
    }
}

void GameApplication::clearPendingInputPromptUi(bool clearStatusBar)
{
    if (m_pendingInputTextActive)
    {
        SDL_Window *pWindow = SDL_GetKeyboardFocus();

        if (pWindow != nullptr)
        {
            SDL_StopTextInput(pWindow);
        }
    }

    m_pendingInputTextActive = false;
    m_pendingInputText.clear();
    m_pendingInputStatusText.clear();

    if (clearStatusBar)
    {
        m_gameSession.gameplayScreenRuntime().setStatusBarEvent(" ", 0.01f);
    }
}

void GameApplication::updatePendingInputPrompt()
{
    if (!pendingInputPromptActive())
    {
        IGameplayWorldRuntime *pWorldRuntime = m_gameSession.activeWorldRuntime();
        EventRuntimeState *pRuntimeState = pWorldRuntime != nullptr ? pWorldRuntime->eventRuntimeState() : nullptr;

        if (pRuntimeState != nullptr && pRuntimeState->pendingInputPrompt
            && !m_gameSession.gameplayScreenRuntime().activeEventDialog().isActive)
        {
            pRuntimeState->pendingInputPrompt.reset();
        }

        clearPendingInputPromptUi(m_pendingInputTextActive || !m_pendingInputStatusText.empty());
        return;
    }

    if (!m_pendingInputTextActive)
    {
        SDL_Window *pWindow = SDL_GetKeyboardFocus();

        if (pWindow != nullptr)
        {
            SDL_StartTextInput(pWindow);
        }

        m_pendingInputTextActive = true;
    }

    const std::string statusText = m_pendingInputText + "_";

    if (statusText != m_pendingInputStatusText)
    {
        m_pendingInputStatusText = statusText;
        m_gameSession.gameplayScreenRuntime().setStatusBarEvent(statusText, 3600.0f);
    }
}

void GameApplication::finishPendingInputPrompt(bool accepted)
{
    IGameplayWorldRuntime *pWorldRuntime = m_gameSession.activeWorldRuntime();
    EventRuntimeState *pRuntimeState = pWorldRuntime != nullptr ? pWorldRuntime->eventRuntimeState() : nullptr;

    if (pWorldRuntime == nullptr || pRuntimeState == nullptr || !pRuntimeState->pendingInputPrompt)
    {
        clearPendingInputPromptUi(false);
        return;
    }

    const EventRuntimeState::PendingInputPrompt prompt = *pRuntimeState->pendingInputPrompt;
    pRuntimeState->pendingInputPrompt.reset();
    const std::string submittedInput = m_pendingInputText;

    clearPendingInputPromptUi(true);

    if (!accepted)
    {
        m_skipGameplayUpdateUntilPromptSubmitKeysReleased = true;
        return;
    }

    const std::string normalizedInput = normalizePromptAnswer(submittedInput);

    bool matchedAnswer = false;
    const std::vector<std::string> answers = resolvePendingInputAnswers(prompt);

    for (const std::string &answer : answers)
    {
        const std::string normalizedAnswer = normalizePromptAnswer(answer);

        if (!answer.empty() && normalizedAnswer == normalizedInput)
        {
            matchedAnswer = true;
        }
    }

    const uint8_t continueStep = matchedAnswer && prompt.correctStep != 0
        ? prompt.correctStep
        : prompt.continueStep;
    const EventDialogContent previousDialog = m_gameSession.gameplayScreenRuntime().activeEventDialog();
    const bool promptStartedFromMapEvent =
        pRuntimeState->pendingDialogueContext
        && pRuntimeState->pendingDialogueContext->kind == DialogueContextKind::MapEvent;
    size_t previousMessageCount = 0;
    const bool executed = promptStartedFromMapEvent
        ? pWorldRuntime->executeMapEvent(prompt.eventId, previousMessageCount, continueStep)
        : pWorldRuntime->executeNpcTopicEvent(prompt.eventId, previousMessageCount, continueStep);

    if (executed && promptStartedFromMapEvent)
    {
        previousMessageCount = 0;
    }

    if (executed && !pRuntimeState->pendingDialogueContext && previousDialog.isActive && previousDialog.sourceId != 0)
    {
        EventRuntimeState::PendingDialogueContext context = {};
        context.kind = previousDialog.isHouseDialog ? DialogueContextKind::HouseService : DialogueContextKind::NpcTalk;
        context.sourceId = previousDialog.sourceId;
        context.hostHouseId = pRuntimeState->dialogueState.hostHouseId;

        if (context.kind == DialogueContextKind::HouseService && context.hostHouseId == 0)
        {
            context.hostHouseId = context.sourceId;
        }

        pRuntimeState->pendingDialogueContext = std::move(context);
    }

    if (executed)
    {
        GameplayHeldItemController::applyGrantedEventItemsToHeldInventory(
            m_gameSession.gameplayScreenRuntime(),
            *pRuntimeState,
            m_gameSession.data().itemTable());
    }

    if (executed
        && pRuntimeState->pendingDialogueContext
        && pRuntimeState->pendingDialogueContext->kind == DialogueContextKind::MapEvent
        && pRuntimeState->messages.size() <= previousMessageCount
        && !pRuntimeState->pendingInputPrompt)
    {
        pRuntimeState->pendingDialogueContext.reset();
    }

    if (executed && !pRuntimeState->pendingDialogueContext)
    {
        m_gameSession.gameplayScreenRuntime().activeEventDialog() = {};
    }

    m_skipGameplayUpdateUntilPromptSubmitKeysReleased = true;

    if (executed)
    {
        presentPendingInputPromptDialogResult(previousMessageCount);
    }
}

void GameApplication::presentPendingInputPromptDialogResult(size_t previousMessageCount)
{
    IGameplayWorldRuntime *pWorldRuntime = m_gameSession.activeWorldRuntime();
    EventRuntimeState *pRuntimeState = pWorldRuntime != nullptr ? pWorldRuntime->eventRuntimeState() : nullptr;

    if (pWorldRuntime == nullptr || pRuntimeState == nullptr || !pRuntimeState->pendingDialogueContext)
    {
        return;
    }

    const MapStatsEntry *pCurrentMap =
        m_gameDataLoader.getMapStats().findByFileName(m_gameSession.currentMapFileName());

    m_gameSession.gameplayScreenRuntime().activeEventDialog() = buildEventDialogContent(
        *pRuntimeState,
        previousMessageCount,
        true,
        pWorldRuntime->globalEventProgram(),
        &m_gameDataLoader.getHouseTable(),
        &m_gameDataLoader.getClassSkillTable(),
        &m_gameDataLoader.getNpcDialogTable(),
        &m_gameDataLoader.getTransitionTable(),
        pCurrentMap,
        &m_gameDataLoader.getMapStats().getEntries(),
        pWorldRuntime->party(),
        pWorldRuntime,
        pWorldRuntime->gameMinutes(),
        &m_gameDataLoader.getMergedNpcProfessionTable(),
        &m_gameDataLoader.getMergedNewsProfessionTopicTable(),
        &m_gameDataLoader.getMergedNpcBtbTable(),
        nullptr,
        &m_gameDataLoader.getMergedContinentSettingTable());

}

std::vector<std::string> GameApplication::resolvePendingInputAnswers(
    const EventRuntimeState::PendingInputPrompt &prompt) const
{
    return prompt.answers;
}

std::filesystem::path GameApplication::settingsFilePath() const
{
    return std::filesystem::path("settings.ini");
}

void GameApplication::loadOrCreateSettings()
{
    m_settings = GameSettings::createDefault();
    const std::filesystem::path path = settingsFilePath();
    std::string error;

    if (std::filesystem::exists(path))
    {
        const std::optional<GameSettings> loadedSettings = loadGameSettings(path, error);

        if (loadedSettings.has_value())
        {
            m_settings = *loadedSettings;
        }
        else
        {
            std::cerr << "GameApplication: failed to load " << path.string() << ": " << error << '\n';
        }
    }

    m_settings.startWorldId = normalizeWorldId(m_config.activeWorldId);

    if (!saveGameSettings(path, m_settings, error))
    {
        std::cerr << "GameApplication: failed to write " << path.string() << ": " << error << '\n';
    }

    m_config.windowWidth = m_settings.resolutionWidth;
    m_config.windowHeight = m_settings.resolutionHeight;
    m_config.windowMode = engineWindowModeForSettings(m_settings.windowMode);
    m_engineApplication.setConfiguration(m_config);
}

void GameApplication::applyCurrentSettingsToActiveRuntime()
{
    setTextureFilteringConfig(textureFilteringConfigFromSettings(m_settings));
    m_gameAudioSystem.setSoundVolume(normalizedVolumeLevel(m_settings.soundVolume));
    m_gameAudioSystem.setMusicVolume(normalizedVolumeLevel(m_settings.musicVolume));
    m_gameAudioSystem.setVoiceVolume(normalizedVolumeLevel(m_settings.voiceVolume));
    m_outdoorGameView.setMouseRotateSpeed(mouseRotateSpeedForTurnRate(m_settings.turnRate));
    m_outdoorGameView.setWalkSoundEnabled(m_settings.walksound);
    m_outdoorGameView.setShowHitStatusMessages(m_settings.showHits);
    m_outdoorGameView.setFlipOnExitEnabled(m_settings.flipOnExit);
    m_outdoorGameView.setSettingsSnapshot(m_settings);
    m_indoorGameView.setSettingsSnapshot(m_settings);

    if (m_pOutdoorPartyRuntime != nullptr)
    {
        m_pOutdoorPartyRuntime->setRunning(m_settings.alwaysRun);
        m_pOutdoorPartyRuntime->setDebugFlyingOverride(m_settings.startFlying);
        m_pOutdoorPartyRuntime->setMovementSpeedMultiplier(m_settings.movementSpeedMultiplier);
    }

    if (m_pMapSceneRuntime != nullptr && m_pMapSceneRuntime->kind() == SceneKind::Indoor)
    {
        IndoorSceneRuntime *pIndoorRuntime = static_cast<IndoorSceneRuntime *>(m_pMapSceneRuntime.get());
        pIndoorRuntime->partyRuntime().setAlwaysRunEnabled(m_settings.alwaysRun);
        pIndoorRuntime->partyRuntime().setMovementSpeedMultiplier(m_settings.movementSpeedMultiplier);
    }

    if (m_pMapSceneRuntime != nullptr)
    {
        m_pMapSceneRuntime->party().setDebugDamageImmune(m_settings.immortal);
        m_pMapSceneRuntime->party().setDebugUnlimitedMana(m_settings.unlimitedMana);
    }
}

void GameApplication::applyStartupDebugSettingsToActiveRuntime()
{
    if (m_pMapSceneRuntime == nullptr)
    {
        return;
    }

    if (m_settings.overrideStartPosition)
    {
        if (m_pMapSceneRuntime->kind() == SceneKind::Outdoor && m_pOutdoorPartyRuntime != nullptr)
        {
            m_pOutdoorPartyRuntime->teleportTo(m_settings.startX, m_settings.startY, m_settings.startZ);
        }
        else if (m_pMapSceneRuntime->kind() == SceneKind::Indoor)
        {
            IndoorSceneRuntime *pIndoorRuntime = static_cast<IndoorSceneRuntime *>(m_pMapSceneRuntime.get());
            pIndoorRuntime->partyRuntime().teleportPartyPosition(m_settings.startX, m_settings.startY, m_settings.startZ);
        }
    }

}

void GameApplication::shutdownApplication()
{
    m_screenManager.setActiveScreen(nullptr);
    m_pLoadingOverlayScreen.reset();
    shutdownRenderer();
    shutdownDebugConsoleRenderer();
    m_gameAudioSystem.shutdown();
}

bool GameApplication::loadGameData(Engine::AssetFileSystem &assetFileSystem)
{
    m_pAssetFileSystem = &assetFileSystem;
    m_gameSession.clear();
    m_gameDataRepository.clear();
    m_gameSession.bindDataRepository(&m_gameDataRepository);
    m_gameplayController.bindSession(m_gameSession);
    m_gameplayController.clearRuntime();
    m_screenManager.setActiveScreen(nullptr);

    std::string manifestError;
    m_activeWorldManifest = loadActiveWorldManifestOrDefault(
        assetFileSystem,
        m_config.activeWorldId,
        manifestError);

    if (!manifestError.empty())
    {
        std::cerr << manifestError << '\n';
        return false;
    }

    if (m_activeWorldManifest.id != normalizeWorldId(m_config.activeWorldId))
    {
        std::cerr
            << "world.yml id '" << m_activeWorldManifest.id
            << "' does not match active world '" << normalizeWorldId(m_config.activeWorldId) << "'\n";
        return false;
    }

    m_gameDataLoader.setActiveWorldId(m_activeWorldManifest.id);
    m_gameDataLoader.setInitialMapFileName(m_activeWorldManifest.start.mapFileName);

    if (!m_gameDataLoader.loadForGameplay(assetFileSystem))
    {
        return false;
    }

    m_gameDataRepository.bind(m_gameDataLoader);
    m_gameSession.bindDataRepository(&m_gameDataRepository);

    loadOrCreateSettings();

    if (!m_gameAudioSystem.initialize(
            assetFileSystem,
            m_gameDataLoader.getCharacterDollTable(),
            m_gameDataLoader.getSpellTable()))
    {
        return false;
    }

    const std::optional<MapAssetInfo> &selectedMap = m_gameDataLoader.getSelectedMap();

    if (selectedMap)
    {
        m_gameSession.setCurrentMapFileName(selectedMap->map.fileName);
    }

    applyCurrentSettingsToActiveRuntime();
    m_screenManager.setCurrentMode(AppMode::MainMenu);
    m_bootSeededDwiOnNextRendererInit = !m_settings.startInMainMenu;

    return true;
}

bool GameApplication::activateWorldForMap(const MapStatsEntry &map)
{
    if (m_pAssetFileSystem == nullptr)
    {
        return false;
    }

    const std::string targetWorldId = normalizeWorldId(map.worldId);
    const std::string currentWorldId = normalizeWorldId(m_pAssetFileSystem->getActiveWorldId());

    if (currentWorldId != targetWorldId && !m_pAssetFileSystem->switchActiveWorld(targetWorldId))
    {
        std::cerr
            << "GameApplication: failed to switch active world from "
            << currentWorldId
            << " to "
            << targetWorldId
            << " for map "
            << map.fileName
            << '\n';
        return false;
    }

    std::string manifestError;
    WorldManifest targetManifest = loadActiveWorldManifestOrDefault(*m_pAssetFileSystem, targetWorldId, manifestError);

    if (!manifestError.empty())
    {
        std::cerr << manifestError << '\n';
        return false;
    }

    if (targetManifest.id != targetWorldId)
    {
        std::cerr
            << "world.yml id '" << targetManifest.id
            << "' does not match active world '" << targetWorldId << "'\n";
        return false;
    }

    m_config.activeWorldId = targetWorldId;
    m_activeWorldManifest = std::move(targetManifest);
    m_gameDataLoader.setActiveWorldId(targetWorldId);
    m_gameDataLoader.setInitialMapFileName(m_activeWorldManifest.start.mapFileName);
    return true;
}

bool GameApplication::activateWorldForMapFileName(const std::string &mapFileName)
{
    const MapStatsEntry *pMap = m_gameDataLoader.getMapStats().findByFileName(mapFileName);

    if (pMap == nullptr)
    {
        std::cerr
            << "GameApplication: cannot resolve map world for "
            << mapFileName
            << '\n';
        return false;
    }

    return activateWorldForMap(*pMap);
}

bool GameApplication::initializeRenderer()
{
    shutdownRenderer();

    if (!initializeDebugConsoleRenderer())
    {
        std::cerr << "GameApplication: debug console renderer initialization failed\n";
        return false;
    }

    if (m_bootSeededDwiOnNextRendererInit)
    {
        const bool initialized = initializeStartupSession(true);

        if (!initialized)
        {
            std::cerr << "GameApplication: initializeRenderer failed during startup session initialization\n";
        }

        return initialized;
    }

    if (m_screenManager.currentMode() == AppMode::MainMenu
        || m_screenManager.currentMode() == AppMode::LoadMenu
        || m_screenManager.currentMode() == AppMode::NewGame)
    {
        openMainMenuScreen();
        return true;
    }

    const bool initialized = initializeSelectedMapRuntime(true);

    if (!initialized)
    {
        std::cerr << "GameApplication: initializeRenderer failed to initialize selected map runtime\n";
    }

    return initialized;
}

bool GameApplication::initializeStartupSession(bool initializeView)
{
    if (!m_bootSeededDwiOnNextRendererInit)
    {
        std::cerr << "GameApplication: initializeStartupSession called without boot flag\n";
        return false;
    }

    m_bootSeededDwiOnNextRendererInit = false;
    const bool initialized = startNewSession(std::nullopt, initializeView);

    if (!initialized)
    {
        std::cerr << "GameApplication: initializeStartupSession failed to start a new session\n";
    }

    return initialized;
}

bool GameApplication::initializeSelectedMapRuntime(bool initializeView)
{
    const std::optional<MapAssetInfo> &selectedMap = m_gameDataLoader.getSelectedMap();

    if (!selectedMap)
    {
        std::cerr << "GameApplication: initializeSelectedMapRuntime has no selected map\n";
        return false;
    }

    MapLoadTimingLogger timingLogger(selectedMap->map.fileName, "selected_map_runtime");

    if (selectedMap->outdoorMapData)
    {
        m_gameSession.setCurrentSceneKind(SceneKind::Outdoor);
        m_gameSession.setCurrentMapFileName(selectedMap->map.fileName);
        m_pOutdoorPartyRuntime = std::make_unique<OutdoorPartyRuntime>(
            OutdoorMovementDriver(
                *selectedMap->outdoorMapData,
                selectedMap->map.outdoorBounds.enabled
                    ? std::optional<MapBounds>(selectedMap->map.outdoorBounds)
                    : std::nullopt,
                selectedMap->outdoorLandMask,
                selectedMap->outdoorDecorationCollisionSet,
                selectedMap->outdoorActorCollisionSet,
                selectedMap->outdoorSpriteObjectCollisionSet
            ),
            m_gameDataLoader.getItemTable()
        );
        bindPartyDependencies(m_pOutdoorPartyRuntime->party());

        if (m_gameSession.partyState())
        {
            bindPartyDependencies(*m_gameSession.partyState());
            m_pOutdoorPartyRuntime->setParty(*m_gameSession.partyState());
        }
        else
        {
            m_pOutdoorPartyRuntime->party().reset();
            m_gameSession.setPartyState(m_pOutdoorPartyRuntime->party());
        }

        m_pOutdoorWorldRuntime = std::make_unique<OutdoorWorldRuntime>();
        m_pOutdoorWorldRuntime->initialize(
            selectedMap->map,
            m_gameDataLoader.getMonsterTable(),
            m_gameDataLoader.getMonsterProjectileTable(),
            m_gameDataLoader.getObjectTable(),
            m_gameDataLoader.getSpellTable(),
            m_gameDataLoader.getItemTable(),
            &m_pOutdoorPartyRuntime->party(),
            m_pOutdoorPartyRuntime.get(),
            m_gameDataLoader.getStandardItemEnchantTable(),
            m_gameDataLoader.getSpecialItemEnchantTable(),
            &m_gameDataLoader.getChestTable(),
            selectedMap->outdoorMapData,
            selectedMap->outdoorMapDeltaData,
            selectedMap->outdoorWeatherProfile,
            selectedMap->eventRuntimeState,
            selectedMap->outdoorActorPreviewBillboardSet,
            selectedMap->outdoorLandMask,
            selectedMap->outdoorDecorationCollisionSet,
            selectedMap->outdoorActorCollisionSet,
            selectedMap->outdoorSpriteObjectCollisionSet,
            selectedMap->outdoorSpriteObjectBillboardSet,
            &m_gameSession.gameplayActorService(),
            &m_gameSession.gameplayProjectileService(),
            &m_gameSession.gameplayCombatController(),
            &m_gameSession.gameplayFxService()
        );
        timingLogger.stage("outdoor runtime initialized");

        restoreSavedOutdoorWorldStateForSelectedMap();
        OutdoorWorldRuntime::Snapshot outdoorTimeSnapshot = m_pOutdoorWorldRuntime->snapshot();
        outdoorTimeSnapshot.gameMinutes = m_gameSession.gameMinutes();
        m_pOutdoorWorldRuntime->restoreSnapshot(outdoorTimeSnapshot);

        if (EventRuntimeState *pEventRuntimeState = m_pOutdoorWorldRuntime->eventRuntimeState())
        {
            EventRuntime eventRuntime(&m_gameDataLoader.getHouseTable());

            eventRuntime.executeOnLoadEvents(
                selectedMap->localEventProgram,
                selectedMap->globalEventProgram,
                *pEventRuntimeState,
                &m_pOutdoorPartyRuntime->party(),
                m_pOutdoorWorldRuntime.get());
            m_pOutdoorWorldRuntime->applyEventRuntimeState(true);
            m_pOutdoorPartyRuntime->applyEventRuntimeState(*pEventRuntimeState, false);
        }
        timingLogger.stage("outdoor on-load events applied");

        m_pMapSceneRuntime = std::make_unique<OutdoorSceneRuntime>(
            selectedMap->map.fileName,
            selectedMap->map,
            *m_pOutdoorPartyRuntime,
            *m_pOutdoorWorldRuntime,
            selectedMap->localEventProgram,
            selectedMap->globalEventProgram,
            &m_gameDataLoader.getHouseTable());
        m_gameplayController.bindRuntime(m_pMapSceneRuntime.get());
        m_screenManager.setCurrentMode(AppMode::GameplayOutdoor);

        m_gameAudioSystem.setBackgroundMusicTrack(selectedMap->map.redbookTrack);
        applyCurrentSettingsToActiveRuntime();
        timingLogger.stage("outdoor scene runtime bound");

        if (!initializeView)
        {
            return true;
        }

        const bool initialized = m_outdoorGameView.initialize(
            *m_pAssetFileSystem,
            selectedMap->map,
            *selectedMap->outdoorMapData,
            selectedMap->outdoorLandMask,
            selectedMap->outdoorTileColors,
            selectedMap->outdoorTerrainTextureAtlas,
            selectedMap->outdoorBModelTextureSet,
            selectedMap->outdoorDecorationCollisionSet,
            selectedMap->outdoorActorCollisionSet,
            selectedMap->outdoorSpriteObjectCollisionSet,
            selectedMap->outdoorDecorationBillboardSet,
            selectedMap->outdoorActorPreviewBillboardSet,
            selectedMap->outdoorSpriteObjectBillboardSet,
            selectedMap->outdoorMapDeltaData,
            &m_gameAudioSystem,
            *static_cast<OutdoorSceneRuntime *>(m_pMapSceneRuntime.get()),
                m_settings);
        timingLogger.stage("outdoor view initialized");

        if (!initialized)
        {
            std::cerr
                << "GameApplication: outdoor view initialization failed for map "
                << selectedMap->map.fileName
                << '\n';
        }

        return initialized;
    }

    if (selectedMap->indoorMapData)
    {
        m_gameSession.setCurrentSceneKind(SceneKind::Indoor);
        m_gameSession.setCurrentMapFileName(selectedMap->map.fileName);
        m_screenManager.setCurrentMode(AppMode::GameplayIndoor);
        m_gameAudioSystem.setBackgroundMusicTrack(selectedMap->map.redbookTrack);
        applyCurrentSettingsToActiveRuntime();
        Party &party = ensureSessionPartyState();
        const SpriteFrameTable *pIndoorActorSpriteFrameTable =
            selectedMap->indoorActorPreviewBillboardSet
                ? &selectedMap->indoorActorPreviewBillboardSet->spriteFrameTable
                : nullptr;
        const SpriteFrameTable *pIndoorProjectileSpriteFrameTable =
            selectedMap->indoorSpriteObjectBillboardSet
                ? &selectedMap->indoorSpriteObjectBillboardSet->spriteFrameTable
                : pIndoorActorSpriteFrameTable;
        std::unique_ptr<IndoorSceneRuntime> pIndoorSceneRuntime = std::make_unique<IndoorSceneRuntime>(
            selectedMap->map.fileName,
            selectedMap->map,
            *selectedMap->indoorMapData,
            m_gameDataLoader.getMonsterTable(),
            m_gameDataLoader.getMonsterProjectileTable(),
            m_gameDataLoader.getObjectTable(),
            m_gameDataLoader.getSpellTable(),
            m_gameDataLoader.getItemTable(),
            m_gameDataLoader.getChestTable(),
            party,
            selectedMap->indoorMapDeltaData,
            selectedMap->eventRuntimeState,
            selectedMap->localEventProgram,
            selectedMap->globalEventProgram,
            &m_gameSession.gameplayActorService(),
            &m_gameSession.gameplayProjectileService(),
            &m_gameSession.gameplayCombatController(),
            pIndoorActorSpriteFrameTable,
            pIndoorProjectileSpriteFrameTable,
            selectedMap->indoorDecorationBillboardSet ? &*selectedMap->indoorDecorationBillboardSet : nullptr
        );
        timingLogger.stage("indoor runtime initialized");
        std::unordered_map<std::string, IndoorSceneRuntime::Snapshot>::const_iterator indoorStateIt =
            m_gameSession.indoorSceneStates().find(selectedMap->map.canonicalId);

        if (indoorStateIt == m_gameSession.indoorSceneStates().end())
        {
            indoorStateIt = m_gameSession.indoorSceneStates().find(selectedMap->map.fileName);
        }

        if (indoorStateIt != m_gameSession.indoorSceneStates().end())
        {
            pIndoorSceneRuntime->restoreSnapshot(indoorStateIt->second);
        }

        IndoorSceneRuntime::Snapshot indoorTimeSnapshot = pIndoorSceneRuntime->snapshot();
        indoorTimeSnapshot.worldRuntime.gameMinutes = m_gameSession.gameMinutes();
        pIndoorSceneRuntime->restoreSnapshot(indoorTimeSnapshot);

        timingLogger.stage("indoor saved state restored");

        pIndoorSceneRuntime->partyRuntime().setMovementSpeedMultiplier(m_settings.movementSpeedMultiplier);
        pIndoorSceneRuntime->partyRuntime().setAlwaysRunEnabled(m_settings.alwaysRun);

        if (initializeView
            && !m_indoorRenderer.initialize(
                m_pAssetFileSystem,
                m_pAssetFileSystem != nullptr ? m_pAssetFileSystem->getAssetScaleTier() : Engine::AssetScaleTier::X1,
                selectedMap->map,
                m_gameDataLoader.getMonsterTable(),
                *selectedMap->indoorMapData,
                selectedMap->indoorTextureSet,
                selectedMap->indoorDecorationBillboardSet,
                selectedMap->indoorActorPreviewBillboardSet,
                selectedMap->indoorSpriteObjectBillboardSet,
                *pIndoorSceneRuntime,
                m_gameDataLoader.getObjectTable(),
                m_gameDataLoader.getItemTable(),
                m_gameDataLoader.getChestTable(),
                m_gameDataLoader.getHouseTable()))
        {
            std::cerr
                << "GameApplication: indoor renderer initialization failed for map "
                << selectedMap->map.fileName
                << '\n';
            return false;
        }
        timingLogger.stage("indoor renderer initialized");

        if (initializeView)
        {
            pIndoorSceneRuntime->worldRuntime().bindRenderer(&m_indoorRenderer);
        }

        if (initializeView
            && !m_indoorGameView.initialize(
                *m_pAssetFileSystem,
                selectedMap->map,
                m_indoorRenderer,
                *pIndoorSceneRuntime,
                &m_gameAudioSystem))
        {
            std::cerr
                << "GameApplication: indoor gameplay view initialization failed for map "
                << selectedMap->map.fileName
                << '\n';
            return false;
        }
        timingLogger.stage("indoor view initialized");

        m_indoorGameView.setSettingsSnapshot(m_settings);

        m_pMapSceneRuntime = std::move(pIndoorSceneRuntime);
        m_gameplayController.bindRuntime(m_pMapSceneRuntime.get());
        timingLogger.stage("indoor scene runtime bound");
        return true;
    }

    std::cerr
        << "GameApplication: selected map "
        << selectedMap->map.fileName
        << " has neither outdoor nor indoor runtime data\n";
    return false;
}

Party &GameApplication::ensureSessionPartyState()
{
    if (!m_gameSession.partyState())
    {
        Party party = {};
        bindPartyDependencies(party);
        party.reset();
        m_gameSession.setPartyState(std::move(party));
    }
    else
    {
        bindPartyDependencies(*m_gameSession.partyState());
    }

    return *m_gameSession.partyState();
}

void GameApplication::bindPartyDependencies(Party &party) const
{
    const GameDataRepository &data = m_gameSession.data();
    party.setItemTable(&data.itemTable());
    party.setJournalQuestTable(&data.journalQuestTable());
    party.setCharacterDollTable(&data.characterDollTable());
    party.setItemEnchantTables(&data.standardItemEnchantTable(), &data.specialItemEnchantTable());
    party.setClassMultiplierTable(&data.classMultiplierTable());
    party.setClassSkillTable(&data.classSkillTable());
}

void GameApplication::synchronizeSessionFromRuntime()
{
    if (m_pMapSceneRuntime == nullptr)
    {
        return;
    }

    m_gameplayController.synchronizeSessionFromRuntime();
    m_gameSession.setCurrentSceneKind(m_pMapSceneRuntime->kind());
    m_gameSession.setCurrentMapFileName(m_pMapSceneRuntime->currentMapFileName());

    if (m_pMapSceneRuntime->kind() == SceneKind::Outdoor
        && m_pOutdoorPartyRuntime != nullptr
        && m_pOutdoorWorldRuntime != nullptr)
    {
        const OutdoorWorldRuntime::Snapshot worldSnapshot = m_pOutdoorWorldRuntime->snapshot();
        m_gameSession.captureOutdoorRuntimeState(
            m_pMapSceneRuntime->currentMapFileName(),
            m_pMapSceneRuntime->party(),
            m_pOutdoorPartyRuntime->snapshot(),
            worldSnapshot,
            m_outdoorGameView.cameraYawRadians(),
            m_outdoorGameView.cameraPitchRadians());

        const std::optional<MapAssetInfo> &selectedMap = m_gameDataLoader.getSelectedMap();

        if (selectedMap && !selectedMap->map.canonicalId.empty())
        {
            m_gameSession.storeOutdoorWorldState(selectedMap->map.canonicalId, worldSnapshot);
        }

        return;
    }

    if (m_pMapSceneRuntime->kind() == SceneKind::Indoor)
    {
        const IndoorSceneRuntime *pIndoorRuntime = static_cast<const IndoorSceneRuntime *>(m_pMapSceneRuntime.get());
        const IndoorSceneRuntime::Snapshot snapshot = pIndoorRuntime->snapshot();
        m_gameSession.captureIndoorRuntimeState(
            m_pMapSceneRuntime->currentMapFileName(),
            m_pMapSceneRuntime->party(),
            snapshot);

        const std::optional<MapAssetInfo> &selectedMap = m_gameDataLoader.getSelectedMap();

        if (selectedMap && !selectedMap->map.canonicalId.empty())
        {
            m_gameSession.storeIndoorSceneState(selectedMap->map.canonicalId, snapshot);
        }
    }
}

bool GameApplication::loadCurrentSessionMap(
    bool initializeView,
    const std::function<void(int)> &progressCallback)
{
    if (m_pAssetFileSystem == nullptr || !m_gameSession.hasCurrentMapFileName())
    {
        std::cerr
            << "GameApplication: loadCurrentSessionMap missing prerequisites"
            << " asset_fs=" << (m_pAssetFileSystem != nullptr ? "yes" : "no")
            << " has_map=" << (m_gameSession.hasCurrentMapFileName() ? "yes" : "no")
            << '\n';
        return false;
    }

    MapLoadTimingLogger timingLogger(m_gameSession.currentMapFileName(), "current_session_map");

    if (progressCallback)
    {
        progressCallback(10);
    }

    if (!activateWorldForMapFileName(m_gameSession.currentMapFileName()))
    {
        return false;
    }

    const std::optional<MapAssetInfo> &selectedMap = m_gameDataLoader.getSelectedMap();
    const bool selectedMapMatchesSession =
        selectedMap.has_value() && sameMapFileName(selectedMap->map.fileName, m_gameSession.currentMapFileName());

    if (!selectedMapMatchesSession
        && !m_gameDataLoader.loadMapByFileNameForGameplay(
                *m_pAssetFileSystem,
                m_gameSession.currentMapFileName(),
                [this]()
                {
                    pumpLoadingOverlayAnimation();
                }))
    {
        std::cerr
            << "GameApplication: loadCurrentSessionMap failed to load map assets for "
            << m_gameSession.currentMapFileName()
            << '\n';
        return false;
    }

    timingLogger.stage(
        selectedMapMatchesSession
            ? "game data loader map load reused selected map"
            : "game data loader map load");

    if (progressCallback)
    {
        progressCallback(55);
    }

    shutdownRenderer();
    timingLogger.stage("renderer shutdown");

    if (!initializeSelectedMapRuntime(initializeView))
    {
        std::cerr
            << "GameApplication: loadCurrentSessionMap failed to initialize runtime for "
            << m_gameSession.currentMapFileName()
            << '\n';
        return false;
    }

    timingLogger.stage(initializeView ? "runtime and view initialized" : "runtime initialized");

    if (progressCallback)
    {
        progressCallback(90);
    }

    if (progressCallback)
    {
        progressCallback(100);
    }

    timingLogger.stage("current session map load complete");
    return true;
}

void GameApplication::beginLoadingOverlay(LoadingOverlayScreen::Presentation presentation)
{
    if (m_pAssetFileSystem == nullptr)
    {
        return;
    }

    const char *pDisableOverlay = std::getenv("OPENYAMM_DISABLE_LOADING_OVERLAY");

    if (pDisableOverlay != nullptr && std::string(pDisableOverlay) == "1")
    {
        cancelLoadingOverlay();
        return;
    }

    const char *pVideoDriver = SDL_GetCurrentVideoDriver();

    if (pVideoDriver != nullptr && std::string(pVideoDriver) == "dummy")
    {
        cancelLoadingOverlay();
        return;
    }

    if (m_pLoadingOverlayScreen == nullptr)
    {
        m_pLoadingOverlayScreen = std::make_unique<LoadingOverlayScreen>(*m_pAssetFileSystem);
    }

    m_pLoadingOverlayScreen->setPresentation(presentation);
    m_loadingOverlayPresentation = presentation;
    m_loadingOverlayCurrentProgressPercent = 0;
    m_loadingOverlayNextAnimationFrameTick = 0;

    if (presentation == LoadingOverlayScreen::Presentation::Fullscreen)
    {
        std::random_device randomDevice;
        std::mt19937 rng(randomDevice());
        const int backgroundIndex = std::uniform_int_distribution<int>(1, LoadingOverlayBackgroundCount)(rng);
        m_loadingOverlayBackgroundTextureName = "loading" + std::to_string(backgroundIndex);
    }
    else
    {
        m_loadingOverlayBackgroundTextureName = "bardata";
    }

    m_loadingOverlayActive = true;
    renderLoadingOverlayProgress(0);
}

void GameApplication::renderLoadingOverlayProgress(int progressPercent)
{
    if (!m_loadingOverlayActive || m_pLoadingOverlayScreen == nullptr)
    {
        return;
    }

    m_loadingOverlayCurrentProgressPercent = std::clamp(progressPercent, 0, 100);
    m_pLoadingOverlayScreen->setBackgroundTextureName(m_loadingOverlayBackgroundTextureName);
    m_pLoadingOverlayScreen->setProgressPercent(progressPercent);
    SDL_PumpEvents();
    m_pLoadingOverlayScreen->renderFrame(
        std::max(1, m_lastFrameWidth),
        std::max(1, m_lastFrameHeight),
        m_gameInputSystem.frame(),
        1.0f / 60.0f);
    bgfx::frame();
}

void GameApplication::pumpLoadingOverlayAnimation()
{
    if (!m_loadingOverlayActive
        || m_loadingOverlayPresentation != LoadingOverlayScreen::Presentation::DungeonTransition)
    {
        return;
    }

    const uint64_t now = SDL_GetTicks();

    if (m_loadingOverlayNextAnimationFrameTick != 0 && now < m_loadingOverlayNextAnimationFrameTick)
    {
        return;
    }

    renderLoadingOverlayProgress(m_loadingOverlayCurrentProgressPercent);
    m_loadingOverlayNextAnimationFrameTick = SDL_GetTicks() + DungeonTransitionOverlayFrameMilliseconds;
}

void GameApplication::completeLoadingOverlay()
{
    if (!m_loadingOverlayActive)
    {
        return;
    }

    renderLoadingOverlayProgress(100);
    m_loadingOverlayActive = false;
    m_loadingOverlayBackgroundTextureName.clear();
    m_loadingOverlayPresentation = LoadingOverlayScreen::Presentation::Fullscreen;
    m_loadingOverlayCurrentProgressPercent = 0;
    m_loadingOverlayNextAnimationFrameTick = 0;
    m_pLoadingOverlayScreen.reset();
}

void GameApplication::cancelLoadingOverlay()
{
    m_loadingOverlayActive = false;
    m_loadingOverlayBackgroundTextureName.clear();
    m_loadingOverlayPresentation = LoadingOverlayScreen::Presentation::Fullscreen;
    m_loadingOverlayCurrentProgressPercent = 0;
    m_loadingOverlayNextAnimationFrameTick = 0;
    m_pLoadingOverlayScreen.reset();
}

bool GameApplication::applyCurrentSessionToRuntime(bool initializeView)
{
    if (m_pMapSceneRuntime == nullptr)
    {
        return true;
    }

    if (m_pMapSceneRuntime->kind() == SceneKind::Outdoor && m_pOutdoorPartyRuntime != nullptr)
    {
        if (m_gameSession.outdoorPartyState())
        {
            m_pOutdoorPartyRuntime->restoreSnapshot(*m_gameSession.outdoorPartyState());
        }

        if (initializeView)
        {
            m_outdoorGameView.setCameraAngles(
                m_gameSession.outdoorCameraYawRadians(),
                m_gameSession.outdoorCameraPitchRadians());
        }

        applyCurrentSettingsToActiveRuntime();
    }

    synchronizeSessionFromRuntime();
    return true;
}

void GameApplication::captureCurrentSceneState()
{
    synchronizeSessionFromRuntime();
}

void GameApplication::restoreSavedOutdoorWorldStateForSelectedMap()
{
    const std::optional<MapAssetInfo> &selectedMap = m_gameDataLoader.getSelectedMap();

    if (!selectedMap || m_pOutdoorWorldRuntime == nullptr || !selectedMap->outdoorMapData)
    {
        return;
    }

    std::unordered_map<std::string, OutdoorWorldRuntime::Snapshot>::const_iterator stateIt =
        m_gameSession.outdoorWorldStates().find(selectedMap->map.canonicalId);

    if (stateIt == m_gameSession.outdoorWorldStates().end())
    {
        stateIt = m_gameSession.outdoorWorldStates().find(selectedMap->map.fileName);
    }

    if (stateIt == m_gameSession.outdoorWorldStates().end())
    {
        return;
    }

    m_pOutdoorWorldRuntime->restoreSnapshot(stateIt->second);
}

void GameApplication::shutdownRenderer()
{
    m_outdoorGameView.shutdown();
    m_indoorGameView.shutdown();
    m_indoorRenderer.shutdown();
    m_gameplayController.clearRuntime();
    m_pMapSceneRuntime.reset();
    m_pOutdoorPartyRuntime.reset();
    m_pOutdoorWorldRuntime.reset();
}

void GameApplication::updateQuickSaveInput()
{
    const GameplayInputFrame &inputFrame = m_gameInputSystem.frame();

    if (inputFrame.isScancodeHeld(SDL_SCANCODE_F9))
    {
        if (!m_quickSaveLatch)
        {
            m_pendingQuickSave = true;
            m_quickSaveLatch = true;
        }
    }
    else
    {
        m_quickSaveLatch = false;
    }

    if (inputFrame.isScancodeHeld(SDL_SCANCODE_F10))
    {
        if (!m_quickLoadLatch)
        {
            m_pendingQuickLoad = true;
            m_quickLoadLatch = true;
        }
    }
    else
    {
        m_quickLoadLatch = false;
    }

}

bool GameApplication::processPendingQuickSaveInput()
{
    if (m_pendingAdvanceTime)
    {
        m_pendingAdvanceTime = false;

        if (m_gameplayController.advanceGameMinutes(60.0f))
        {
            reportQuickSaveStatus("Advanced time by 1 hour");
            return true;
        }

        reportQuickSaveStatus("Time advance unavailable");
        return false;
    }

    if (m_pendingQuickLoad)
    {
        m_pendingQuickLoad = false;
        m_pendingQuickSave = false;
        return quickLoad();
    }

    if (m_pendingQuickSave)
    {
        m_pendingQuickSave = false;
        return quickSave();
    }

    return false;
}

bool GameApplication::quickSave()
{
    if (m_pMapSceneRuntime != nullptr && m_pMapSceneRuntime->kind() == SceneKind::Outdoor)
    {
        return m_outdoorGameView.requestQuickSave();
    }

    if (m_pMapSceneRuntime != nullptr && m_pMapSceneRuntime->kind() == SceneKind::Indoor)
    {
        return m_indoorGameView.requestQuickSave();
    }

    return quickSaveToPath(std::filesystem::path("saves") / "quicksave.oysav");
}

bool GameApplication::quickSaveToPath(
    const std::filesystem::path &path,
    const std::string &saveName,
    const std::vector<uint8_t> &previewBmp)
{
    const std::optional<MapAssetInfo> &selectedMap = m_gameDataLoader.getSelectedMap();

    if (!selectedMap || m_pMapSceneRuntime == nullptr)
    {
        reportQuickSaveStatus("Quick save unavailable");
        return false;
    }

    if (!selectedMap->map.runtimeRestrictions.allowSaveGame)
    {
        reportQuickSaveStatus("Quick save unavailable here");
        return false;
    }

    synchronizeSessionFromRuntime();
    std::optional<GameSaveData> saveData = m_gameSession.buildSaveData();

    if (!saveData)
    {
        reportQuickSaveStatus("Quick save unavailable");
        return false;
    }

    saveData->saveName = saveName;
    saveData->previewBmp = previewBmp;

    std::string error;

    if (!saveGameDataToPath(path, *saveData, error))
    {
        reportQuickSaveStatus("Quick save failed: " + error);
        return false;
    }

    m_gameSession.setCurrentSavePath(path);
    reportQuickSaveStatus("Quick save written");
    return true;
}

bool GameApplication::quickLoad()
{
    return quickLoadFromPath(std::filesystem::path("saves") / "quicksave.oysav", true);
}

bool GameApplication::quickLoadFromPath(const std::filesystem::path &path, bool initializeView)
{
    if (m_pAssetFileSystem == nullptr)
    {
        reportQuickSaveStatus("Quick load unavailable");
        return false;
    }

    beginLoadingOverlay();

    std::string error;
    const std::optional<GameSaveData> saveData = loadGameDataFromPath(path, error);

    if (!saveData)
    {
        cancelLoadingOverlay();
        reportQuickSaveStatus("Quick load failed: " + error);
        return false;
    }

    renderLoadingOverlayProgress(20);

    m_gameSession.restoreFromSaveData(*saveData);
    m_gameSession.setCurrentSavePath(path);

    renderLoadingOverlayProgress(35);

    if (!loadCurrentSessionMap(
            initializeView,
            [this](int localProgress)
            {
                renderLoadingOverlayProgress(remapLoadingProgress(localProgress, 40, 85));
            }))
    {
        cancelLoadingOverlay();
        reportQuickSaveStatus("Quick load failed: runtime init failed");
        return false;
    }

    renderLoadingOverlayProgress(90);

    if (!applyCurrentSessionToRuntime(initializeView))
    {
        cancelLoadingOverlay();
        reportQuickSaveStatus("Quick load failed: runtime apply failed");
        return false;
    }

    renderLoadingOverlayProgress(95);
    completeLoadingOverlay();
    reportQuickSaveStatus("Quick load applied");
    return true;
}

void GameApplication::openMainMenuScreen()
{
    if (m_pAssetFileSystem == nullptr)
    {
        return;
    }

    m_gameAudioSystem.setBackgroundMusicTrack(MainMenuMusicTrack);

    m_screenManager.setActiveScreen(std::make_unique<MainMenuScreen>(
        *m_pAssetFileSystem,
        &m_gameAudioSystem,
        [this]()
        {
            openNewGameScreen();
        },
        [this]()
        {
            openLoadGameScreen();
        },
        [this]()
        {
            requestApplicationQuit();
        }));
}

void GameApplication::openLoadGameScreen(bool returnToGameplayMenu)
{
    if (m_pAssetFileSystem == nullptr)
    {
        return;
    }

    m_screenManager.setActiveScreen(std::make_unique<LoadGameScreen>(
        *m_pAssetFileSystem,
        m_gameSession.data(),
        [this](const std::filesystem::path &path) -> bool
        {
            return loadSessionFromPath(path);
        },
        [this, returnToGameplayMenu]()
        {
            if (returnToGameplayMenu)
            {
                m_screenManager.setActiveScreen(nullptr);

                if (m_pMapSceneRuntime != nullptr)
                {
                    m_screenManager.setCurrentMode(
                        m_pMapSceneRuntime->kind() == SceneKind::Indoor
                            ? AppMode::GameplayIndoor
                            : AppMode::GameplayOutdoor);
                }

                if (m_pMapSceneRuntime != nullptr && m_pMapSceneRuntime->kind() == SceneKind::Indoor)
                {
                    m_indoorGameView.reopenMenuScreen();
                }
                else
                {
                    m_outdoorGameView.reopenMenuScreen();
                }
            }
            else
            {
                openMainMenuScreen();
            }
        }));
}

void GameApplication::openNewGameScreen()
{
    if (m_pAssetFileSystem == nullptr)
    {
        return;
    }

    m_gameAudioSystem.stopBackgroundMusicImmediate();

    m_screenManager.setActiveScreen(std::make_unique<NewGameScreen>(
        *m_pAssetFileSystem,
        &m_gameAudioSystem,
        m_gameSession.data(),
        m_settings.newGameGodLich,
        [this](const Character &character)
        {
            startNewSessionFromCharacterCreation(character);
        },
        [this]()
        {
            openMainMenuScreen();
        }));
}

std::string GameApplication::resolveStartupMapFile() const
{
    if (!m_config.startupMapFileOverride.empty())
    {
        return m_config.startupMapFileOverride;
    }

    if (!m_settings.startMapFile.empty())
    {
        return m_settings.startMapFile;
    }

    return m_activeWorldManifest.start.mapFileName.empty()
        ? DefaultStartupMapFile
        : m_activeWorldManifest.start.mapFileName;
}

bool GameApplication::startNewSession(std::optional<uint32_t> rosterId, bool initializeView)
{
    if (m_pAssetFileSystem == nullptr)
    {
        std::cerr << "GameApplication: startNewSession has no asset filesystem\n";
        return false;
    }

    m_screenManager.setActiveScreen(nullptr);
    shutdownRenderer();
    m_gameSession.clear();
    m_gameSession.clearCurrentSavePath();
    m_gameSession.setCurrentSceneKind(SceneKind::Outdoor);
    m_gameSession.setCurrentMapFileName(resolveStartupMapFile());

    const bool shouldSeedParty = rosterId.has_value() || m_settings.preseedParty;
    std::optional<uint32_t> effectiveRosterId = rosterId;

    if (!effectiveRosterId.has_value() && m_settings.preseedParty && m_settings.partySeedRosterId != 0)
    {
        effectiveRosterId = m_settings.partySeedRosterId;
    }

    if (shouldSeedParty)
    {
        Party &party = ensureSessionPartyState();
        const RosterEntry *pRosterEntry =
            effectiveRosterId.has_value() ? m_gameDataLoader.getRosterTable().get(*effectiveRosterId) : nullptr;

        seedSimulatedPartyFromRoster(
            party,
            m_gameDataLoader.getRosterTable(),
            effectiveRosterId.has_value() && pRosterEntry != nullptr ? effectiveRosterId : std::nullopt);
        seedDebugWandsIntoParty(party, m_gameDataLoader.getItemTable());
        setDebugTownPortalUnlocks(party, true);
    }

    if (!loadCurrentSessionMap(initializeView))
    {
        std::cerr
            << "GameApplication: startNewSession failed to load configured startup map "
            << m_gameSession.currentMapFileName()
            << '\n';

        const std::string fallbackStartupMapFile = m_activeWorldManifest.start.mapFileName.empty()
            ? DefaultStartupMapFile
            : m_activeWorldManifest.start.mapFileName;

        if (m_gameSession.currentMapFileName() != fallbackStartupMapFile)
        {
            m_gameSession.setCurrentMapFileName(fallbackStartupMapFile);

            if (loadCurrentSessionMap(initializeView))
            {
                // Use the world manifest startup map when the configured one cannot be loaded.
                std::cerr
                    << "GameApplication: startNewSession fell back to world startup map "
                    << fallbackStartupMapFile
                    << '\n';
            }
            else
            {
                std::cerr
                    << "GameApplication: startNewSession fallback startup map also failed "
                    << fallbackStartupMapFile
                    << '\n';
                openMainMenuScreen();
                return false;
            }
        }
        else
        {
            std::cerr << "GameApplication: startNewSession default startup map failed without fallback\n";
            openMainMenuScreen();
            return false;
        }
    }

    if (m_pMapSceneRuntime == nullptr)
    {
        std::cerr
            << "GameApplication: startNewSession expected active scene runtime after startup map load, but none exists\n";
        openMainMenuScreen();
        return false;
    }

    applyCurrentSettingsToActiveRuntime();
    applyStartupDebugSettingsToActiveRuntime();
    synchronizeSessionFromRuntime();
    return true;
}

bool GameApplication::startNewSessionFromCharacterCreation(const Character &character, bool initializeView)
{
    if (m_pAssetFileSystem == nullptr)
    {
        return false;
    }

    m_screenManager.setActiveScreen(nullptr);
    beginLoadingOverlay();
    shutdownRenderer();
    m_gameSession.clear();
    m_gameSession.clearCurrentSavePath();
    m_gameSession.setCurrentSceneKind(SceneKind::Outdoor);
    m_gameSession.setCurrentMapFileName(resolveStartupMapFile());
    PartySeed seed = {};
    seed.gold = 200;
    seed.food = 5;
    seed.members.push_back(
        buildFreshCreatedCharacter(
            character,
            m_gameDataLoader.getClassMultiplierTable(),
            m_gameDataLoader.getItemTable(),
            m_gameDataLoader.getStandardItemEnchantTable(),
            m_gameDataLoader.getSpecialItemEnchantTable(),
            m_settings.newGameGodLich));

    Party &sessionParty = ensureSessionPartyState();
    sessionParty.seed(seed);
    setDebugTownPortalUnlocks(sessionParty, false);
    renderLoadingOverlayProgress(15);

    if (!loadCurrentSessionMap(
            initializeView,
            [this](int localProgress)
            {
                renderLoadingOverlayProgress(remapLoadingProgress(localProgress, 20, 80));
            }))
    {
        cancelLoadingOverlay();
        openMainMenuScreen();
        return false;
    }

    if (m_pOutdoorPartyRuntime == nullptr)
    {
        cancelLoadingOverlay();
        openMainMenuScreen();
        return false;
    }

    renderLoadingOverlayProgress(90);
    applyCurrentSettingsToActiveRuntime();
    synchronizeSessionFromRuntime();
    renderLoadingOverlayProgress(95);
    completeLoadingOverlay();
    return true;
}

bool GameApplication::loadSessionFromPath(const std::filesystem::path &path)
{
    if (quickLoadFromPath(path, true))
    {
        m_screenManager.setActiveScreen(nullptr);
        return true;
    }

    return false;
}

void GameApplication::requestApplicationQuit() const
{
    SDL_Event event = {};
    event.type = SDL_EVENT_QUIT;
    SDL_PushEvent(&event);
}

void GameApplication::reportQuickSaveStatus(const std::string &status)
{
    if (EventRuntimeState *pEventRuntimeState = m_gameplayController.eventRuntimeState())
    {
        pEventRuntimeState->lastActivationResult = status;
    }
}

void GameApplication::renderFrame(int width, int height, float mouseWheelDelta, float deltaSeconds)
{
    m_lastFrameWidth = width;
    m_lastFrameHeight = height;

    if (processPendingDebugMapJump())
    {
        return;
    }

    beginDebugConsoleFrame();
    const bool debugConsoleOpen = m_debugConsole.wantsGameplayInputBlocked();
    const bool debugConsoleFreezesGameplay = m_debugConsole.freezesGameplay();

    if (m_gameSession.consumeRelativeMouseMotionResetRequest())
    {
        m_gameInputSystem.resetRelativeMouseMotion();
    }

    m_gameInputSystem.updateFromEngineInput(
        width,
        height,
        mouseWheelDelta,
        m_settings,
        debugConsoleOpen);
    m_gameSession.bindCurrentGameplayInputFrame(&m_gameInputSystem.frame());

    if (debugConsoleFreezesGameplay)
    {
        m_gameSession.clearSharedInputFrameResult();
    }
    else
    {
        processPendingArcomageGame();
    }

    if (IScreen *pActiveScreen = m_screenManager.activeScreen())
    {
        pActiveScreen->renderFrame(width, height, m_gameInputSystem.frame(), deltaSeconds);
        handleCompletedPartyDefeatScreen();
        handleCompletedEventMovieScreen();
        handleCompletedWinGameScreen();
        handleCompletedArcomageScreen();
        m_gameAudioSystem.update(0.0f, 0.0f, 0.0f, deltaSeconds);
        renderDebugConsoleFrame(width, height);
        return;
    }

    updateQuickSaveInput();

    if (processPendingPartyDefeat())
    {
        if (IScreen *pActiveScreen = m_screenManager.activeScreen())
        {
            pActiveScreen->renderFrame(width, height, m_gameInputSystem.frame(), deltaSeconds);
            handleCompletedPartyDefeatScreen();
            handleCompletedEventMovieScreen();
            handleCompletedWinGameScreen();
        }

        m_gameAudioSystem.update(0.0f, 0.0f, 0.0f, deltaSeconds);
        renderDebugConsoleFrame(width, height);
        return;
    }

    if (processPendingWinGame())
    {
        if (IScreen *pActiveScreen = m_screenManager.activeScreen())
        {
            pActiveScreen->renderFrame(width, height, m_gameInputSystem.frame(), deltaSeconds);
            handleCompletedEventMovieScreen();
            handleCompletedWinGameScreen();
        }

        m_gameAudioSystem.update(0.0f, 0.0f, 0.0f, deltaSeconds);
        renderDebugConsoleFrame(width, height);
        return;
    }

    if (processPendingEventMovie())
    {
        if (IScreen *pActiveScreen = m_screenManager.activeScreen())
        {
            pActiveScreen->renderFrame(width, height, m_gameInputSystem.frame(), deltaSeconds);
            handleCompletedEventMovieScreen();
            handleCompletedWinGameScreen();
        }

        m_gameAudioSystem.update(0.0f, 0.0f, 0.0f, deltaSeconds);
        renderDebugConsoleFrame(width, height);
        return;
    }

    const std::optional<MapAssetInfo> &selectedMap = m_gameDataLoader.getSelectedMap();
    const bool *pKeyboardState = m_gameInputSystem.frame().keyboardState();
    bool skipGameplayUpdateAfterInputPrompt = false;

    if (m_skipGameplayUpdateUntilPromptSubmitKeysReleased)
    {
        skipGameplayUpdateAfterInputPrompt =
            pKeyboardState[SDL_SCANCODE_RETURN]
            || pKeyboardState[SDL_SCANCODE_KP_ENTER]
            || pKeyboardState[SDL_SCANCODE_SPACE];

        if (!skipGameplayUpdateAfterInputPrompt)
        {
            m_skipGameplayUpdateUntilPromptSubmitKeysReleased = false;
        }
    }

    if (!debugConsoleFreezesGameplay && !skipGameplayUpdateAfterInputPrompt)
    {
        m_gameSession.updateGameplay(m_gameInputSystem.frame(), deltaSeconds);
    }

    if (!debugConsoleFreezesGameplay)
    {
        updatePendingInputPrompt();
        processPendingDimensionDoorOverlay();
    }

    IGameplayWorldRuntime *pWorldRuntime = m_gameSession.activeWorldRuntime();

    if (pWorldRuntime != nullptr && m_pMapSceneRuntime != nullptr && selectedMap)
    {
        const GameplaySharedInputFrameResult &sharedInput = m_gameSession.sharedInputFrameResult();
        const bool pendingSpellTargetActive = m_gameSession.gameplayScreenState().pendingSpellTarget().active;
        const bool gameplayWorldPaused =
            sharedInput.mouseLookPolicy.cursorModeActive
            || sharedInput.worldInputBlocked
            || pendingSpellTargetActive
            || m_gameSession.sharedWorldInteractionBlockedThisFrame()
            || debugConsoleFreezesGameplay;

        if (!gameplayWorldPaused)
        {
            pWorldRuntime->updateWorld(deltaSeconds);
        }

        m_gameSession.consumePendingGameplayAudioRequests();
        pWorldRuntime->renderWorld(width, height, m_gameInputSystem.frame(), deltaSeconds);
        m_gameSession.renderGameplayUi(width, height);

        if (m_gameSession.consumeRelativeMouseMotionResetRequest())
        {
            m_gameInputSystem.resetRelativeMouseMotion();
        }

        if (m_gameSession.consumePendingOpenNewGameScreenRequest())
        {
            openNewGameScreen();
            renderDebugConsoleFrame(width, height);
            return;
        }

        if (m_gameSession.consumePendingOpenLoadGameScreenRequest())
        {
            openLoadGameScreen(true);
            renderDebugConsoleFrame(width, height);
            return;
        }

        if (m_pMapSceneRuntime->kind() == SceneKind::Outdoor && m_pOutdoorPartyRuntime != nullptr)
        {
            const OutdoorMoveState &moveState = m_pOutdoorPartyRuntime->movementState();
            m_gameAudioSystem.update(moveState.x, moveState.y, moveState.footZ + 96.0f, deltaSeconds);
        }
        else if (m_pMapSceneRuntime->kind() == SceneKind::Indoor)
        {
            const IndoorSceneRuntime *pIndoorRuntime =
                static_cast<const IndoorSceneRuntime *>(m_pMapSceneRuntime.get());
            const IndoorMoveState &moveState = pIndoorRuntime->partyRuntime().movementState();
            m_gameAudioSystem.update(moveState.x, moveState.y, moveState.eyeZ(), deltaSeconds);
        }
        else
        {
            m_gameAudioSystem.update(0.0f, 0.0f, 0.0f, deltaSeconds);
        }

        if (processPendingWinGame())
        {
            renderDebugConsoleFrame(width, height);
            return;
        }

        if (processPendingEventMovie())
        {
            renderDebugConsoleFrame(width, height);
            return;
        }

        processPendingMapMove();

        if (processPendingQuickSaveInput())
        {
            renderDebugConsoleFrame(width, height);
            return;
        }

        renderDebugConsoleFrame(width, height);
        return;
    }

    renderDebugConsoleFrame(width, height);
}

bool GameApplication::processPendingMapMove()
{
    if (m_pAssetFileSystem == nullptr)
    {
        return false;
    }

    std::optional<EventRuntimeState::PendingMapMove> pendingMapMove = m_gameplayController.consumePendingMapMove();

    if (!pendingMapMove)
    {
        return false;
    }

    synchronizeSessionFromRuntime();

    const bool isSameMapTeleport =
        !pendingMapMove->mapName
        || pendingMapMove->mapName->empty()
        || *pendingMapMove->mapName == "0"
        || *pendingMapMove->mapName == "0."
        || (!pendingMapMove->useMapStartPosition
            && sameMapFileName(*pendingMapMove->mapName, m_gameSession.currentMapFileName()));

    const auto applyMapMoveDirection = [this, &pendingMapMove]()
    {
        if (!pendingMapMove->directionDegrees.has_value() || m_pMapSceneRuntime == nullptr)
        {
            return;
        }

        const float yawRadians = mapMoveHeadingDegreesToYawRadians(*pendingMapMove->directionDegrees);

        if (m_pMapSceneRuntime->kind() == SceneKind::Outdoor)
        {
            m_outdoorGameView.setCameraAngles(yawRadians, m_outdoorGameView.cameraPitchRadians());
        }
        else if (m_pMapSceneRuntime->kind() == SceneKind::Indoor)
        {
            m_indoorRenderer.setCameraAngles(yawRadians, m_indoorRenderer.cameraPitchRadians());
        }
    };
    if (isSameMapTeleport)
    {
        if (m_pMapSceneRuntime != nullptr
            && m_pMapSceneRuntime->kind() == SceneKind::Outdoor
            && m_pOutdoorPartyRuntime != nullptr)
        {
            m_pOutdoorPartyRuntime->teleportTo(
                static_cast<float>(pendingMapMove->x),
                static_cast<float>(pendingMapMove->y),
                static_cast<float>(pendingMapMove->z)
            );
        }
        else if (m_pMapSceneRuntime != nullptr && m_pMapSceneRuntime->kind() == SceneKind::Indoor)
        {
            IndoorSceneRuntime *pIndoorRuntime = static_cast<IndoorSceneRuntime *>(m_pMapSceneRuntime.get());
            pIndoorRuntime->partyRuntime().teleportPartyPosition(
                static_cast<float>(pendingMapMove->x),
                static_cast<float>(pendingMapMove->y),
                static_cast<float>(pendingMapMove->z));
        }

        applyMapMoveDirection();

        m_gameAudioSystem.playCommonSound(SoundId::Teleport, GameAudioSystem::PlaybackGroup::Ui);
        synchronizeSessionFromRuntime();
        return true;
    }

    executeCurrentMapOnLeaveEvents();

    const std::string targetMapName = *pendingMapMove->mapName;
    const std::string previousMapFileName = m_gameSession.currentMapFileName();

    captureCurrentSceneState();

    m_gameSession.setCurrentMapFileName(targetMapName);
    const LoadingOverlayScreen::Presentation loadingPresentation = pendingMapMove->useFullscreenLoading
        ? LoadingOverlayScreen::Presentation::Fullscreen
        : LoadingOverlayScreen::Presentation::DungeonTransition;
    beginLoadingOverlay(loadingPresentation);
    renderLoadingOverlayProgress(15);

    if (!loadCurrentSessionMap(
            true,
            [this](int localProgress)
            {
                renderLoadingOverlayProgress(remapLoadingProgress(localProgress, 20, 85));
            }))
    {
        cancelLoadingOverlay();
        m_gameSession.setCurrentMapFileName(previousMapFileName);
        return false;
    }

    if (m_pMapSceneRuntime != nullptr
        && m_pMapSceneRuntime->kind() == SceneKind::Outdoor
        && m_pOutdoorPartyRuntime != nullptr
        && !pendingMapMove->useMapStartPosition)
    {
        m_pOutdoorPartyRuntime->teleportTo(
            static_cast<float>(pendingMapMove->x),
            static_cast<float>(pendingMapMove->y),
            static_cast<float>(pendingMapMove->z)
        );
    }
    else if (m_pMapSceneRuntime != nullptr
             && m_pMapSceneRuntime->kind() == SceneKind::Indoor
             && !pendingMapMove->useMapStartPosition)
    {
        IndoorSceneRuntime *pIndoorRuntime = static_cast<IndoorSceneRuntime *>(m_pMapSceneRuntime.get());
        pIndoorRuntime->partyRuntime().teleportPartyPosition(
            static_cast<float>(pendingMapMove->x),
            static_cast<float>(pendingMapMove->y),
            static_cast<float>(pendingMapMove->z));
    }

    applyMapMoveDirection();

    if (isDungeonMapFileName(targetMapName) && !sameMapFileName(previousMapFileName, targetMapName))
    {
        Party *pParty = m_pMapSceneRuntime != nullptr ? &m_pMapSceneRuntime->party() : nullptr;
        const std::optional<size_t> memberIndex =
            pParty != nullptr ? chooseRandomActablePartyMember(*pParty) : std::nullopt;

        if (memberIndex.has_value())
        {
            m_gameSession.gameplayScreenRuntime().queueDelayedSpeechReaction(
                *memberIndex,
                SpeechId::EnterDungeon,
                EnterDungeonSpeechDelaySeconds);
        }
    }

    synchronizeSessionFromRuntime();
    renderLoadingOverlayProgress(95);
    completeLoadingOverlay();
    return true;
}

bool GameApplication::processPendingArcomageGame()
{
    if (m_screenManager.activeScreen() != nullptr || m_pAssetFileSystem == nullptr)
    {
        return false;
    }

    const std::optional<EventRuntimeState::PendingArcomageGame> pendingArcomageGame =
        m_gameplayController.consumePendingArcomageGame();

    if (!pendingArcomageGame.has_value())
    {
        return false;
    }

    Party *pParty = nullptr;

    if (m_pOutdoorPartyRuntime != nullptr)
    {
        pParty = &m_pOutdoorPartyRuntime->party();
    }
    else if (m_gameSession.partyState().has_value())
    {
        pParty = &*m_gameSession.partyState();
    }

    if (pParty == nullptr)
    {
        return false;
    }

    const HouseEntry *pHouseEntry = m_gameDataLoader.getHouseTable().get(pendingArcomageGame->houseId);
    const ArcomageTavernRule *pRule = m_gameDataLoader.getArcomageLibrary().ruleForHouse(pendingArcomageGame->houseId);

    if (pHouseEntry == nullptr || pRule == nullptr)
    {
        return false;
    }

    const Character *pActiveMember = pParty->activeMember();
    const std::string playerName =
        (pActiveMember != nullptr && !pActiveMember->name.empty()) ? pActiveMember->name : "Party";
    const std::string opponentName =
        !pHouseEntry->proprietorName.empty() ? pHouseEntry->proprietorName : pHouseEntry->name;
    int winGoldReward = 0;

    if (!pParty->hasArcomageWinAt(pendingArcomageGame->houseId))
    {
        winGoldReward = static_cast<int>(pHouseEntry->priceMultiplier * 100.0f);
    }

    m_screenManager.setActiveScreen(std::make_unique<ArcomageScreen>(
        *m_pAssetFileSystem,
        &m_gameAudioSystem,
        m_gameDataLoader.getArcomageLibrary(),
        pendingArcomageGame->houseId,
        playerName,
        opponentName,
        winGoldReward,
        SDL_GetTicks()
    ));

    return true;
}

bool GameApplication::processPendingPartyDefeat()
{
    if (m_pAssetFileSystem == nullptr
        || m_screenManager.activeScreen() != nullptr
        || m_pendingPartyDefeatRespawnMapFileName.has_value()
        || !shouldTriggerPartyDefeat())
    {
        return false;
    }

    m_pendingPartyDefeatRespawnMapFileName = resolvePartyDefeatRespawnMapFileName();
    const std::string cutsceneStem = resolvePartyDefeatCutsceneStem();
    m_screenManager.setActiveScreen(std::make_unique<CutsceneVideoScreen>(
        *m_pAssetFileSystem,
        &m_gameAudioSystem,
        PartyDefeatCutsceneDirectory,
        cutsceneStem,
        m_screenManager.currentMode()));
    return true;
}

bool GameApplication::executeCurrentMapOnLeaveEvents()
{
    if (m_pMapSceneRuntime == nullptr)
    {
        return false;
    }

    EventRuntimeState *pRuntimeState = m_pMapSceneRuntime->eventRuntimeState();

    if (pRuntimeState == nullptr)
    {
        return false;
    }

    EventRuntime eventRuntime = {};
    eventRuntime.bindHouseTable(&m_gameDataLoader.getHouseTable());
    return eventRuntime.executeOnLeaveEvents(
        m_pMapSceneRuntime->localEventProgram(),
        m_pMapSceneRuntime->globalEventProgram(),
        *pRuntimeState,
        &m_pMapSceneRuntime->party(),
        m_pMapSceneRuntime->sceneEventContext());
}

WinGameCertificate GameApplication::buildWinGameCertificate() const
{
    WinGameCertificate certificate = {};
    const Party *pParty = nullptr;

    if (m_pMapSceneRuntime != nullptr)
    {
        pParty = &m_pMapSceneRuntime->party();
    }
    else if (m_gameSession.partyState().has_value())
    {
        pParty = &*m_gameSession.partyState();
    }

    const IGameplayWorldRuntime *pWorldRuntime = m_gameSession.activeWorldRuntime();
    const float currentGameMinutes = pWorldRuntime != nullptr ? pWorldRuntime->gameMinutes() : 9.0f * 60.0f;

    if (pParty != nullptr)
    {
        certificate.characterLine = winGameCharacterLine(*pParty);
        certificate.scoreLine = "Your score: " + std::to_string(calculateWinGameScore(*pParty, currentGameMinutes));
    }
    else
    {
        certificate.characterLine = "Adventurer the Level 1 Adventurer";
        certificate.scoreLine = "Your score: 0";
    }

    certificate.endingText =
        "Excellent work! By thwarting the Destroyer of Worlds, you have pulled your world from the brink of "
        "unending oblivion. Not only may life continue, but a new peace reigns over Jadame. The mighty alliance "
        "you forged will see to the land's restoration and eventual prosperity.";
    certificate.totalTimeLine = formatWinGameDuration(currentGameMinutes);
    return certificate;
}

bool GameApplication::processPendingWinGame()
{
    if (m_pAssetFileSystem == nullptr || m_screenManager.activeScreen() != nullptr)
    {
        return false;
    }

    EventRuntimeState *pRuntimeState = m_gameplayController.eventRuntimeState();

    if (pRuntimeState == nullptr || !pRuntimeState->pendingWinGame.has_value())
    {
        return false;
    }

    pRuntimeState->pendingWinGame.reset();
    m_gameSession.gameplayScreenRuntime().closeActiveEventDialog();
    m_pendingWinGameCertificateAfterMovie = true;

    if (resolveEventMovieStem(*m_pAssetFileSystem, WinGameCutsceneStem).empty())
    {
        m_screenManager.setActiveScreen(std::make_unique<WinGameScreen>(
            *m_pAssetFileSystem,
            buildWinGameCertificate(),
            m_screenManager.currentMode()));
        m_pendingWinGameCertificateAfterMovie = false;
        return true;
    }

    m_screenManager.setActiveScreen(std::make_unique<CutsceneVideoScreen>(
        *m_pAssetFileSystem,
        &m_gameAudioSystem,
        EventMovieCutsceneDirectory,
        WinGameCutsceneStem,
        m_screenManager.currentMode()));
    return true;
}

bool GameApplication::processPendingEventMovie()
{
    if (m_pAssetFileSystem == nullptr || m_screenManager.activeScreen() != nullptr)
    {
        return false;
    }

    EventRuntimeState *pRuntimeState = m_gameplayController.eventRuntimeState();

    if (pRuntimeState == nullptr || !pRuntimeState->pendingMovie.has_value())
    {
        return false;
    }

    std::optional<EventRuntimeState::PendingMovie> pendingMovie = std::move(pRuntimeState->pendingMovie);
    pRuntimeState->pendingMovie.reset();

    const std::string movieStem = resolveEventMovieStem(*m_pAssetFileSystem, pendingMovie->movieName);

    if (movieStem.empty())
    {
        return false;
    }

    m_screenManager.setActiveScreen(std::make_unique<CutsceneVideoScreen>(
        *m_pAssetFileSystem,
        &m_gameAudioSystem,
        EventMovieCutsceneDirectory,
        movieStem,
        m_screenManager.currentMode()));
    return true;
}

bool GameApplication::processPendingDimensionDoorOverlay()
{
    EventRuntimeState *pRuntimeState = m_gameplayController.eventRuntimeState();

    if (pRuntimeState == nullptr || !pRuntimeState->pendingDimensionDoorOverlay)
    {
        return false;
    }

    pRuntimeState->pendingDimensionDoorOverlay = false;

    GameplayScreenRuntime &screenRuntime = m_gameSession.gameplayScreenRuntime();

    if (!screenRuntime.ensureDimensionDoorDestinationsLoaded())
    {
        screenRuntime.setStatusBarEvent("Dimension Door destinations unavailable");
        return false;
    }

    const Party *pParty = screenRuntime.partyReadOnly();
    const size_t casterMemberIndex = pParty != nullptr ? pParty->activeMemberIndex() : 0;
    screenRuntime.openUtilitySpellOverlay(
        GameplayUiController::UtilitySpellOverlayMode::DimensionDoor,
        spellIdValue(SpellId::TownPortal),
        casterMemberIndex);
    screenRuntime.resetUtilitySpellOverlayInteractionState();
    screenRuntime.setStatusBarEvent("Choose Dimension Door destination", 4.0f);
    return true;
}

void GameApplication::handleCompletedPartyDefeatScreen()
{
    if (!m_pendingPartyDefeatRespawnMapFileName.has_value())
    {
        return;
    }

    CutsceneVideoScreen *pCutsceneScreen = dynamic_cast<CutsceneVideoScreen *>(m_screenManager.activeScreen());

    if (pCutsceneScreen == nullptr || !pCutsceneScreen->shouldClose())
    {
        return;
    }

    m_screenManager.setActiveScreen(nullptr);
    m_gameSession.gameplayScreenRuntime().interactionState().menuToggleLatch = true;
    applyPartyDefeatConsequences();
    respawnPartyAfterDefeat(true);
    m_pendingPartyDefeatRespawnMapFileName.reset();
}

void GameApplication::handleCompletedEventMovieScreen()
{
    if (m_pendingPartyDefeatRespawnMapFileName.has_value())
    {
        return;
    }

    CutsceneVideoScreen *pCutsceneScreen = dynamic_cast<CutsceneVideoScreen *>(m_screenManager.activeScreen());

    if (pCutsceneScreen == nullptr || !pCutsceneScreen->shouldClose())
    {
        return;
    }

    if (m_pendingWinGameCertificateAfterMovie && m_pAssetFileSystem != nullptr)
    {
        m_screenManager.setActiveScreen(std::make_unique<WinGameScreen>(
            *m_pAssetFileSystem,
            buildWinGameCertificate(),
            pCutsceneScreen->mode()));
        m_pendingWinGameCertificateAfterMovie = false;
        return;
    }

    m_screenManager.setActiveScreen(nullptr);
    m_gameSession.gameplayScreenRuntime().interactionState().menuToggleLatch = true;
}

void GameApplication::handleCompletedWinGameScreen()
{
    WinGameScreen *pWinGameScreen = dynamic_cast<WinGameScreen *>(m_screenManager.activeScreen());

    if (pWinGameScreen == nullptr || !pWinGameScreen->shouldClose())
    {
        return;
    }

    m_screenManager.setActiveScreen(nullptr);
}

bool GameApplication::shouldTriggerPartyDefeat() const
{
    if (m_pMapSceneRuntime == nullptr)
    {
        return false;
    }

    return !m_pMapSceneRuntime->party().hasActableMember();
}

std::string GameApplication::resolvePartyDefeatRespawnMapFileName() const
{
    const std::string currentMapFileName = toLowerCopy(m_gameSession.currentMapFileName());
    const MapStatsEntry *pCurrentMap = m_gameDataLoader.getMapStats().findByFileName(currentMapFileName);

    if (pCurrentMap != nullptr)
    {
        const bool indoorMap = currentMapFileName.ends_with(".blv");
        const int effectiveAreaId = indoorMap && pCurrentMap->areaId != 0
            ? pCurrentMap->areaId
            : (pCurrentMap->isTopLevelArea ? pCurrentMap->id : pCurrentMap->areaId);

        if (effectiveAreaId == 1)
        {
            return DwiRespawnMapFile;
        }
    }

    if (currentMapFileName == DwiRespawnMapFile)
    {
        return DwiRespawnMapFile;
    }

    return RavenshoreRespawnMapFile;
}

std::string GameApplication::resolvePartyDefeatCutsceneStem() const
{
    if (m_pAssetFileSystem == nullptr)
    {
        return PartyDefeatCutsceneStem;
    }

    const std::string currentMapFileName = toLowerCopy(m_gameSession.currentMapFileName());
    const MapStatsEntry *pCurrentMap = m_gameDataLoader.getMapStats().findByFileName(currentMapFileName);

    if (pCurrentMap != nullptr)
    {
        const MergedContinentSettingEntry *pContinentSetting =
            m_gameDataLoader.findMergedContinentSettingsForMap(*pCurrentMap);

        if (pContinentSetting != nullptr && !trimCopy(pContinentSetting->deathMovie).empty())
        {
            const std::string resolvedMovieStem =
                resolveEventMovieStem(*m_pAssetFileSystem, pContinentSetting->deathMovie);

            if (!resolvedMovieStem.empty())
            {
                return resolvedMovieStem;
            }
        }
    }

    return PartyDefeatCutsceneStem;
}

void GameApplication::applyPartyDefeatConsequences()
{
    if (m_pMapSceneRuntime == nullptr)
    {
        return;
    }

    Party &party = m_pMapSceneRuntime->party();
    const int carriedGold = party.gold();

    if (carriedGold > 0)
    {
        party.addGold(-carriedGold);
        m_gameAudioSystem.playCommonSound(SoundId::Gold, GameAudioSystem::PlaybackGroup::Ui);
    }

    const uint16_t numDeathsVariableId = static_cast<uint16_t>(EvtVariable::NumDeaths);
    party.setEventVariableValue(numDeathsVariableId, party.eventVariableValue(numDeathsVariableId) + 1);
    party.reviveAndRestoreAll();
    synchronizeSessionFromRuntime();
}

bool GameApplication::respawnPartyAfterDefeat(bool initializeView)
{
    if (!m_pendingPartyDefeatRespawnMapFileName.has_value())
    {
        return false;
    }

    const std::string previousMapFileName = m_gameSession.currentMapFileName();

    if (!sameMapFileName(previousMapFileName, *m_pendingPartyDefeatRespawnMapFileName))
    {
        executeCurrentMapOnLeaveEvents();
    }

    captureCurrentSceneState();
    m_gameSession.setCurrentMapFileName(*m_pendingPartyDefeatRespawnMapFileName);
    beginLoadingOverlay();
    renderLoadingOverlayProgress(15);

    if (!loadCurrentSessionMap(
            initializeView,
            [this](int localProgress)
            {
                renderLoadingOverlayProgress(remapLoadingProgress(localProgress, 20, 85));
            }))
    {
        cancelLoadingOverlay();
        m_gameSession.setCurrentMapFileName(previousMapFileName);
        return false;
    }

    synchronizeSessionFromRuntime();
    renderLoadingOverlayProgress(95);
    completeLoadingOverlay();
    return true;
}

void GameApplication::handleCompletedArcomageScreen()
{
    ArcomageScreen *pArcomageScreen = dynamic_cast<ArcomageScreen *>(m_screenManager.activeScreen());

    if (pArcomageScreen == nullptr || !pArcomageScreen->shouldClose())
    {
        return;
    }

    const ArcomageState &state = pArcomageScreen->state();
    Party *pParty = nullptr;

    if (m_pOutdoorPartyRuntime != nullptr)
    {
        pParty = &m_pOutdoorPartyRuntime->party();
    }
    else if (m_gameSession.partyState().has_value())
    {
        pParty = &*m_gameSession.partyState();
    }

    std::optional<std::string> arcomageStatusText;

    if (pParty != nullptr && state.result.finished && state.result.winnerIndex.has_value())
    {
        if (*state.result.winnerIndex == 0)
        {
            int goldReward = 0;
            const HouseEntry *pHouseEntry = m_gameDataLoader.getHouseTable().get(state.houseId);

            if (pHouseEntry != nullptr && !pParty->hasArcomageWinAt(state.houseId))
            {
                goldReward = static_cast<int>(pHouseEntry->priceMultiplier * 100.0f);
            }

            uint32_t firstWinAwardId = 0;
            const ArcomageTavernRule *pRule = m_gameDataLoader.getArcomageLibrary().ruleForHouse(state.houseId);

            if (pRule != nullptr)
            {
                firstWinAwardId = pRule->firstWinAwardId;
            }

            pParty->recordArcomageWin(state.houseId, goldReward, firstWinAwardId);
            arcomageStatusText = "You have won " + std::to_string(goldReward) + " gold!";
        }
        else if (*state.result.winnerIndex == 1)
        {
            pParty->recordArcomageLoss();
        }

        if (m_pOutdoorPartyRuntime != nullptr)
        {
            synchronizeSessionFromRuntime();
        }
        else
        {
            m_gameSession.setPartyState(*pParty);
        }
    }

    m_screenManager.setActiveScreen(nullptr);

    if (arcomageStatusText.has_value())
    {
        if (EventRuntimeState *pEventRuntimeState = m_gameplayController.eventRuntimeState())
        {
            pEventRuntimeState->lastActivationResult = *arcomageStatusText;
        }

        if (m_pMapSceneRuntime != nullptr && m_pMapSceneRuntime->kind() == SceneKind::Outdoor)
        {
            m_outdoorGameView.showStatusBarEvent(*arcomageStatusText, 4.0f);
        }
    }

    if (m_pMapSceneRuntime != nullptr)
    {
        m_screenManager.setCurrentMode(
            m_pMapSceneRuntime->kind() == SceneKind::Outdoor ? AppMode::GameplayOutdoor : AppMode::GameplayIndoor
        );
    }
}
}
