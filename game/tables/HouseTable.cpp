#include "game/tables/HouseTable.h"

#include "game/tables/MapStats.h"
#include "game/tables/MergedBaseTables.h"

#include <algorithm>
#include <cctype>
#include <cstdlib>
#include <iostream>
#include <optional>
#include <sstream>
#include <unordered_map>

namespace OpenYAMM::Game
{
namespace
{
constexpr int MergedYawUnitsPerTurn = 2048;
constexpr int DegreesPerTurn = 360;

bool isNumericOnly(const std::string &value)
{
    return !value.empty()
        && std::all_of(
            value.begin(),
            value.end(),
            [](unsigned char character)
            {
                return std::isdigit(character) != 0;
            });
}

std::string normalizeVideoStem(const std::string &value)
{
    return isNumericOnly(value) ? "" : value;
}

std::unordered_map<uint32_t, std::string> movieStemsByAnimationIdFromRows(
    const std::vector<std::vector<std::string>> &rows)
{
    std::unordered_map<uint32_t, std::string> result;

    for (const std::vector<std::string> &row : rows)
    {
        if (row.size() <= 1 || row[0].empty() || row[0][0] == '#')
        {
            continue;
        }

        char *pEnd = nullptr;
        const unsigned long parsedId = std::strtoul(row[0].c_str(), &pEnd, 10);

        if (pEnd == row[0].c_str() || *pEnd != '\0')
        {
            continue;
        }

        const std::string normalizedVideoStem = normalizeVideoStem(row[1]);

        if (!normalizedVideoStem.empty())
        {
            result[static_cast<uint32_t>(parsedId)] = normalizedVideoStem;
        }
    }

    return result;
}

uint32_t parseUnsigned(const std::string &value)
{
    if (value.empty())
    {
        return 0;
    }

    return static_cast<uint32_t>(std::strtoul(value.c_str(), nullptr, 10));
}

int parseSigned(const std::string &value)
{
    if (value.empty())
    {
        return 0;
    }

    return std::atoi(value.c_str());
}

bool isTransportHouseTypeName(const std::string &houseType)
{
    return houseType == "Stables" || houseType == "Boats";
}

uint32_t houseRuleId(const HouseEntry &entry)
{
    return entry.typeIndex != 0 ? entry.typeIndex : entry.mapId;
}

std::optional<std::pair<std::string, std::string>> stockSectionNamesForHouseType(const std::string &houseType)
{
    if (houseType == "Weapon Shop")
    {
        return std::pair<std::string, std::string>{"Weapon shops Standart", "Weapon shops Special"};
    }

    if (houseType == "Armor Shop")
    {
        return std::pair<std::string, std::string>{"Armor shops Standart", "Armor shops Special"};
    }

    if (houseType == "Magic Shop")
    {
        return std::pair<std::string, std::string>{"Magic shops Standart", "Magic shops Special"};
    }

    if (houseType == "Alchemist")
    {
        return std::pair<std::string, std::string>{"Alchem shops Standart", "Alchem shops Special"};
    }

    return std::nullopt;
}

bool isSpellbookHouseType(const std::string &houseType)
{
    return houseType == "Elemental Guild"
        || houseType == "Light Guild"
        || houseType == "Dark Guild"
        || houseType == "Self Guild"
        || houseType == "Fire Guild"
        || houseType == "Air Guild"
        || houseType == "Water Guild"
        || houseType == "Earth Guild"
        || houseType == "Spirit Guild"
        || houseType == "Mind Guild"
        || houseType == "Body Guild"
        || houseType == "Spell Shop";
}

std::string stemFromMapFileName(const std::string &fileName)
{
    const size_t slashPosition = fileName.find_last_of("/\\");
    const size_t nameStart = slashPosition == std::string::npos ? 0 : slashPosition + 1;
    const size_t dotPosition = fileName.find_last_of('.');

    if (dotPosition == std::string::npos || dotPosition < nameStart)
    {
        return fileName.substr(nameStart);
    }

    return fileName.substr(nameStart, dotPosition - nameStart);
}

std::string normalizedMapFileName(const std::string &fileName)
{
    std::string result = fileName;
    std::transform(
        result.begin(),
        result.end(),
        result.begin(),
        [](unsigned char character)
        {
            return static_cast<char>(std::tolower(character));
        });
    return result;
}

int directionDegreesFromMergedYawUnits(int32_t yawUnits)
{
    int32_t normalized = yawUnits % MergedYawUnitsPerTurn;

    if (normalized < 0)
    {
        normalized += MergedYawUnitsPerTurn;
    }

    return static_cast<int>((normalized * DegreesPerTurn) / MergedYawUnitsPerTurn);
}

const MergedHouseRuleSection *findHouseRuleSection(
    const MergedHouseRuleTable &houseRules,
    const std::string &sectionName)
{
    for (const MergedHouseRuleSection &section : houseRules.sections())
    {
        if (section.name == sectionName)
        {
            return &section;
        }
    }

    return nullptr;
}

const std::vector<int32_t> *findHouseRuleRow(const MergedHouseRuleSection &section, uint32_t ruleId)
{
    for (const std::vector<int32_t> &row : section.numericRows)
    {
        if (!row.empty() && row[0] == static_cast<int32_t>(ruleId))
        {
            return &row;
        }
    }

    return nullptr;
}

std::vector<uint32_t> itemTypesFromRuleRow(
    const std::vector<int32_t> &row,
    size_t beginColumn,
    size_t endColumn)
{
    std::vector<uint32_t> itemTypes;

    for (size_t columnIndex = beginColumn; columnIndex < endColumn && columnIndex < row.size(); ++columnIndex)
    {
        if (row[columnIndex] > 0)
        {
            itemTypes.push_back(static_cast<uint32_t>(row[columnIndex]));
        }
    }

    return itemTypes;
}

HouseEntry::StockRule stockRuleFromRow(const std::string &houseType, const std::vector<int32_t> &row)
{
    HouseEntry::StockRule rule = {};

    if (row.size() < 2)
    {
        return rule;
    }

    rule.quality = row[1];

    if (houseType == "Armor Shop")
    {
        rule.itemTypes = itemTypesFromRuleRow(row, 2, 6);

        if (row.size() > 6)
        {
            rule.secondaryQuality = row[6];
            rule.secondaryItemTypes = itemTypesFromRuleRow(row, 7, 11);
        }

        return rule;
    }

    rule.itemTypes = itemTypesFromRuleRow(row, 2, row.size());
    return rule;
}

bool applyStockRuleSection(
    HouseEntry &entry,
    const MergedHouseRuleTable &houseRules,
    const std::string &sectionName,
    HouseEntry::StockRule &targetRule)
{
    const MergedHouseRuleSection *pSection = findHouseRuleSection(houseRules, sectionName);

    if (pSection == nullptr)
    {
        std::cerr << "merged house rules are missing stock section: " << sectionName << '\n';
        return false;
    }

    const std::vector<int32_t> *pRow = findHouseRuleRow(*pSection, houseRuleId(entry));

    if (pRow == nullptr)
    {
        return true;
    }

    targetRule = stockRuleFromRow(entry.type, *pRow);
    return true;
}

bool applyShopStockRules(HouseEntry &entry, const MergedHouseRuleTable &houseRules)
{
    const std::optional<std::pair<std::string, std::string>> sectionNames =
        stockSectionNamesForHouseType(entry.type);

    if (!sectionNames.has_value())
    {
        return true;
    }

    if (!applyStockRuleSection(entry, houseRules, sectionNames->first, entry.standardStockRule)
        || !applyStockRuleSection(entry, houseRules, sectionNames->second, entry.specialStockRule))
    {
        return false;
    }

    entry.standardStockTier = entry.standardStockRule.quality;
    entry.specialStockTier = entry.specialStockRule.quality;
    return true;
}

bool applySpellbookRule(HouseEntry &entry, const MergedHouseRuleTable &houseRules)
{
    const MergedHouseRuleSection *pSection = findHouseRuleSection(houseRules, "Spellbook shops");

    if (pSection == nullptr)
    {
        std::cerr << "merged house rules are missing spellbook shop section\n";
        return false;
    }

    const std::vector<int32_t> *pRow = findHouseRuleRow(*pSection, houseRuleId(entry));

    if (pRow == nullptr || pRow->size() < 2)
    {
        return true;
    }

    entry.spellbookStockRule.quality = (*pRow)[1];
    return true;
}

bool applyTrainingRule(HouseEntry &entry, const MergedHouseRuleTable &houseRules)
{
    const MergedHouseRuleSection *pSection = findHouseRuleSection(houseRules, "Training halls");

    if (pSection == nullptr)
    {
        std::cerr << "merged house rules are missing training hall section\n";
        return false;
    }

    const std::vector<int32_t> *pRow = findHouseRuleRow(*pSection, houseRuleId(entry));

    if (pRow == nullptr || pRow->size() < 2)
    {
        return true;
    }

    entry.trainingMaxLevel = (*pRow)[1];
    return true;
}

bool applyArcomageRule(HouseEntry &entry, const MergedHouseRuleTable &houseRules)
{
    const MergedHouseRuleSection *pSection = findHouseRuleSection(houseRules, "Arcomage in taverns");

    if (pSection == nullptr)
    {
        std::cerr << "merged house rules are missing Arcomage tavern section\n";
        return false;
    }

    const std::vector<int32_t> *pRow = findHouseRuleRow(*pSection, houseRuleId(entry));

    if (pRow == nullptr || pRow->size() < 12)
    {
        entry.arcomageRule.reset();
        return true;
    }

    HouseEntry::ArcomageRule rule = {};
    rule.towerToWin = (*pRow)[1];
    rule.resourceToWin = (*pRow)[2];
    rule.towerAtStart = (*pRow)[3];
    rule.wallAtStart = (*pRow)[4];
    rule.quarry = (*pRow)[5];
    rule.magic = (*pRow)[6];
    rule.dungeon = (*pRow)[7];
    rule.bricks = (*pRow)[8];
    rule.gems = (*pRow)[9];
    rule.recruits = (*pRow)[10];
    rule.ai = (*pRow)[11];

    if (pRow->size() > 12 && (*pRow)[12] > 0)
    {
        rule.rulesTextId = static_cast<uint32_t>((*pRow)[12]);
    }

    entry.arcomageRule = rule;
    return true;
}

const MergedTransportLocationEntry *findTransportLocation(
    const MergedTransportLocationTable &transportLocations,
    int32_t locationId)
{
    if (locationId < 0)
    {
        return nullptr;
    }

    for (const MergedTransportLocationEntry &entry : transportLocations.entries())
    {
        if (entry.id == static_cast<uint32_t>(locationId))
        {
            return &entry;
        }
    }

    return nullptr;
}

std::string destinationNameForTransportLocation(
    const MergedTransportLocationEntry &location,
    const MapStats &mapStats)
{
    const MapStatsEntry *pMapStatsEntry = mapStats.findByFileName(location.mapName);

    if (pMapStatsEntry != nullptr && !pMapStatsEntry->name.empty())
    {
        return pMapStatsEntry->name;
    }

    return stemFromMapFileName(location.mapName);
}

std::vector<std::string> deriveOfferedSkillsForHouseType(const std::string &houseType)
{
    if (houseType == "Weapon Shop")
    {
        return {"Sword", "Dagger", "Axe", "Spear", "Bow", "Mace"};
    }

    if (houseType == "Armor Shop")
    {
        return {"LeatherArmor", "ChainArmor", "PlateArmor", "Shield"};
    }

    if (houseType == "Elemental Guild")
    {
        return {"FireMagic", "AirMagic", "WaterMagic", "EarthMagic", "Learning"};
    }

    if (houseType == "Fire Guild")
    {
        return {"FireMagic", "Learning"};
    }

    if (houseType == "Air Guild")
    {
        return {"AirMagic", "Learning"};
    }

    if (houseType == "Water Guild")
    {
        return {"WaterMagic", "Learning"};
    }

    if (houseType == "Earth Guild")
    {
        return {"EarthMagic", "Learning"};
    }

    if (houseType == "Self Guild")
    {
        return {"SpiritMagic", "MindMagic", "BodyMagic", "Meditation"};
    }

    if (houseType == "Spirit Guild")
    {
        return {"SpiritMagic", "Meditation"};
    }

    if (houseType == "Mind Guild")
    {
        return {"MindMagic", "Meditation"};
    }

    if (houseType == "Body Guild")
    {
        return {"BodyMagic", "Meditation"};
    }

    if (houseType == "Light Guild")
    {
        return {"LightMagic"};
    }

    if (houseType == "Dark Guild")
    {
        return {"DarkMagic"};
    }

    if (houseType == "Temple")
    {
        return {"Merchant"};
    }

    return {};
}
}

bool HouseTable::loadFromRows(const std::vector<std::vector<std::string>> &rows)
{
    m_entries.clear();

    for (const std::vector<std::string> &row : rows)
    {
        if (row.empty() || row[0].empty() || row[0][0] == '#')
        {
            continue;
        }

        char *pEnd = nullptr;
        const unsigned long parsedId = std::strtoul(row[0].c_str(), &pEnd, 10);

        if (pEnd == row[0].c_str() || *pEnd != '\0')
        {
            continue;
        }

        const std::string &name = row[5];

        if (name.empty())
        {
            continue;
        }

        HouseEntry entry = {};
        entry.id = static_cast<uint32_t>(parsedId);
        entry.typeIndex = (row.size() > 1 && !row[1].empty()) ? std::strtoul(row[1].c_str(), nullptr, 10) : 0;
        entry.mapId = (row.size() > 3 && !row[3].empty()) ? std::strtoul(row[3].c_str(), nullptr, 10) : 0;
        entry.proprietorPictureId =
            (row.size() > 8 && !row[8].empty()) ? std::strtoul(row[8].c_str(), nullptr, 10) : 0;
        entry.type = row.size() > 2 ? row[2] : "";
        entry.name = name;
        entry.videoName = row.size() > 4 ? normalizeVideoStem(row[4]) : "";
        entry.proprietorName = row.size() > 6 ? row[6] : "";
        entry.proprietorTitle = row.size() > 7 ? row[7] : "";
        entry.priceMultiplier =
            (row.size() > 12 && !row[12].empty()) ? std::strtof(row[12].c_str(), nullptr) : 0.0f;
        entry.skillPriceMultiplier =
            (row.size() > 13 && !row[13].empty()) ? std::strtof(row[13].c_str(), nullptr) : 0.0f;
        entry.stockRefreshDays = (row.size() > 15 && !row[15].empty()) ? std::atoi(row[15].c_str()) : 0;
        entry.openHour = (row.size() > 18 && !row[18].empty()) ? std::atoi(row[18].c_str()) : 0;
        entry.closeHour = (row.size() > 19 && !row[19].empty()) ? std::atoi(row[19].c_str()) : 0;
        entry.rawExtraExitPictureIndex = row.size() > 20 ? parseUnsigned(row[20]) : 0;
        entry.rawExtraExitMapId = row.size() > 21 ? parseUnsigned(row[21]) : 0;
        entry.rawExtraExitRestriction = row.size() > 22 ? parseSigned(row[22]) : 0;
        entry.enterText = row.size() > 23 ? row[23] : "";

        if (row.size() > 24 && !row[24].empty())
        {
            std::istringstream stream(row[24]);
            std::string token;

            while (std::getline(stream, token, ','))
            {
                token.erase(
                    std::remove_if(
                        token.begin(),
                        token.end(),
                        [](unsigned char character)
                        {
                            return std::isspace(character) != 0;
                        }
                    ),
                    token.end()
                );

                if (!token.empty())
                {
                    entry.offeredSkills.push_back(token);
                }
            }
        }

        if (entry.offeredSkills.empty())
        {
            entry.offeredSkills = deriveOfferedSkillsForHouseType(entry.type);
        }

        m_entries[entry.id] = entry;
    }

    return !m_entries.empty();
}

bool HouseTable::loadAnimationRows(const std::vector<std::vector<std::string>> &rows)
{
    const std::unordered_map<uint32_t, std::string> emptyMovieStems;
    return loadAnimationRows(rows, emptyMovieStems);
}

bool HouseTable::loadAnimationRows(
    const std::vector<std::vector<std::string>> &rows,
    const std::vector<std::vector<std::string>> &movieRows)
{
    return loadAnimationRows(rows, movieStemsByAnimationIdFromRows(movieRows));
}

bool HouseTable::loadAnimationRows(
    const std::vector<std::vector<std::string>> &rows,
    const std::unordered_map<uint32_t, std::string> &movieStemsByAnimationId)
{
    for (const std::vector<std::string> &row : rows)
    {
        if (row.size() <= 3 || row[0].empty() || row[0][0] == '#')
        {
            continue;
        }

        char *pEnd = nullptr;
        const unsigned long parsedId = std::strtoul(row[0].c_str(), &pEnd, 10);

        if (pEnd == row[0].c_str() || *pEnd != '\0')
        {
            continue;
        }

        const uint32_t houseId = static_cast<uint32_t>(parsedId);
        HouseEntry &entry = m_entries[houseId];
        const uint32_t animationId = row.size() > 1 ? parseUnsigned(row[1]) : 0;
        entry.id = houseId;
        entry.buildingName = row[2];
        std::string normalizedVideoStem;

        if (row.size() > 4)
        {
            normalizedVideoStem = normalizeVideoStem(row[4]);
        }

        if (normalizedVideoStem.empty() && animationId != 0)
        {
            const std::unordered_map<uint32_t, std::string>::const_iterator movieIt =
                movieStemsByAnimationId.find(animationId);

            if (movieIt != movieStemsByAnimationId.end())
            {
                normalizedVideoStem = movieIt->second;
            }
        }

        if (!normalizedVideoStem.empty())
        {
            entry.videoName = normalizedVideoStem;
        }
        entry.roomSoundId = (row.size() > 6 && !row[6].empty()) ? std::strtoul(row[6].c_str(), nullptr, 10) : 0;
        entry.houseSoundBaseId = (row.size() > 7 && !row[7].empty()) ? std::strtoul(row[7].c_str(), nullptr, 10) : 0;
        if (row.size() > 8)
        {
            const uint32_t proprietorPictureId = parseUnsigned(row[8]);

            if (proprietorPictureId != 0)
            {
                entry.proprietorPictureId = proprietorPictureId;
            }
        }

        if (entry.type.empty() && row.size() > 9)
        {
            entry.type = row[9];
        }

        entry.residentNpcIds.clear();

        size_t startPosition = 0;

        while (startPosition <= row[3].size())
        {
            const size_t commaPosition = row[3].find(',', startPosition);
            const size_t tokenLength = (commaPosition == std::string::npos)
                ? (row[3].size() - startPosition)
                : (commaPosition - startPosition);
            const std::string token = row[3].substr(startPosition, tokenLength);

            if (!token.empty())
            {
                char *pTokenEnd = nullptr;
                const unsigned long parsedNpcId = std::strtoul(token.c_str(), &pTokenEnd, 10);

                if (pTokenEnd != token.c_str() && *pTokenEnd == '\0')
                {
                    entry.residentNpcIds.push_back(static_cast<uint32_t>(parsedNpcId));
                }
            }

            if (commaPosition == std::string::npos)
            {
                break;
            }

            startPosition = commaPosition + 1;
        }
    }

    return true;
}

bool HouseTable::applyHouseRules(
    const MergedHouseRuleTable &houseRules,
    const MergedTransportLocationTable &transportLocations,
    const MapStats &mapStats)
{
    for (auto &[houseId, entry] : m_entries)
    {
        (void)houseId;

        if (!applyShopStockRules(entry, houseRules))
        {
            return false;
        }

        if (entry.type == "Training" && !applyTrainingRule(entry, houseRules))
        {
            return false;
        }

        if (entry.type == "Tavern" && !applyArcomageRule(entry, houseRules))
        {
            return false;
        }

        if (isSpellbookHouseType(entry.type) && !applySpellbookRule(entry, houseRules))
        {
            return false;
        }

        if (!isTransportHouseTypeName(entry.type) || !entry.transportRoutes.empty())
        {
            continue;
        }

        const MergedHouseRuleSection *pSection = findHouseRuleSection(houseRules, entry.type);

        if (pSection == nullptr)
        {
            std::cerr << "merged house rules are missing transport section: " << entry.type << '\n';
            return false;
        }

        const uint32_t routeRuleId = houseRuleId(entry);
        const std::vector<int32_t> *pRouteLocationRow = findHouseRuleRow(*pSection, routeRuleId);

        if (pRouteLocationRow == nullptr)
        {
            continue;
        }

        std::vector<int32_t> addedLocationIds;

        for (size_t columnIndex = 1; columnIndex < pRouteLocationRow->size(); ++columnIndex)
        {
            const int32_t locationId = (*pRouteLocationRow)[columnIndex];

            if (locationId < 0)
            {
                continue;
            }

            if (std::find(addedLocationIds.begin(), addedLocationIds.end(), locationId) != addedLocationIds.end())
            {
                continue;
            }

            const MergedTransportLocationEntry *pLocation = findTransportLocation(transportLocations, locationId);

            if (pLocation == nullptr)
            {
                std::cerr << "merged house route references unknown transport location " << locationId
                          << " for house " << entry.id << '\n';
                return false;
            }

            HouseEntry::TransportRoute route = {};
            route.routeIndex = static_cast<uint32_t>(entry.transportRoutes.size() + 1);
            route.destinationName = destinationNameForTransportLocation(*pLocation, mapStats);
            route.mapFileName = pLocation->mapName;
            route.daysAvailable = pLocation->weekdays;
            route.travelDays = pLocation->daysCount;
            route.x = pLocation->x;
            route.y = pLocation->y;
            route.z = pLocation->z;
            route.directionDegrees = directionDegreesFromMergedYawUnits(pLocation->direction);
            route.requiredQBit = pLocation->qbit;
            route.useMapStartPosition = false;
            entry.transportRoutes.push_back(std::move(route));
            addedLocationIds.push_back(locationId);
        }
    }

    return true;
}

bool HouseTable::applyHouseExits(const MergedHouseExitTable &houseExits, const MapStats &mapStats)
{
    const MergedHouseExitTableData &exitData = houseExits.data();

    for (auto &[houseId, entry] : m_entries)
    {
        (void)houseId;
        entry.extraExit.reset();

        if (entry.rawExtraExitPictureIndex == 0 || entry.rawExtraExitMapId == 0)
        {
            continue;
        }

        const MapStatsEntry *pDestinationMap = mapStats.findById(entry.rawExtraExitMapId);

        if (pDestinationMap == nullptr)
        {
            std::cerr << "merged house exit references unknown map id " << entry.rawExtraExitMapId
                      << " for house " << entry.id << '\n';
            return false;
        }

        HouseEntry::ExtraExit extraExit = {};
        extraExit.destinationMapId = entry.rawExtraExitMapId;
        extraExit.destinationMapFileName = pDestinationMap->fileName;
        extraExit.destinationName = pDestinationMap->name;
        extraExit.label = !entry.enterText.empty() && entry.enterText != "0" ? entry.enterText : pDestinationMap->name;

        const size_t pictureIndex = static_cast<size_t>(entry.rawExtraExitPictureIndex - 1);

        if (pictureIndex >= exitData.npcPictureIds.size())
        {
            std::cerr << "merged house exit references unknown picture slot " << entry.rawExtraExitPictureIndex
                      << " for house " << entry.id << '\n';
            return false;
        }

        extraExit.pictureId = exitData.npcPictureIds[pictureIndex];

        if (entry.rawExtraExitRestriction > 0)
        {
            extraExit.requiredQuestBit = static_cast<uint32_t>(entry.rawExtraExitRestriction);
        }
        else if (entry.rawExtraExitRestriction < 0)
        {
            const size_t entranceIndex = static_cast<size_t>(-entry.rawExtraExitRestriction - 1);
            const std::string destinationFileName = normalizedMapFileName(pDestinationMap->fileName);
            const MergedHouseExitEntry *pEntranceEntry = nullptr;

            for (const MergedHouseExitEntry &candidate : exitData.exits)
            {
                if (normalizedMapFileName(candidate.mapName) == destinationFileName)
                {
                    pEntranceEntry = &candidate;
                    break;
                }
            }

            if (pEntranceEntry == nullptr || entranceIndex >= pEntranceEntry->positions.size())
            {
                std::cerr << "merged house exit references unknown entrance " << -entry.rawExtraExitRestriction
                          << " for map " << pDestinationMap->fileName << " and house " << entry.id << '\n';
                return false;
            }

            extraExit.x = pEntranceEntry->positions[entranceIndex].x;
            extraExit.y = pEntranceEntry->positions[entranceIndex].y;
            extraExit.z = pEntranceEntry->positions[entranceIndex].z;
        }

        entry.extraExit = std::move(extraExit);
    }

    return true;
}

std::optional<std::string> HouseTable::getName(uint32_t houseId) const
{
    const auto entryIt = m_entries.find(houseId);

    if (entryIt == m_entries.end())
    {
        return std::nullopt;
    }

    return entryIt->second.name;
}

const HouseEntry *HouseTable::get(uint32_t houseId) const
{
    const std::unordered_map<uint32_t, HouseEntry>::const_iterator entryIt = m_entries.find(houseId);

    if (entryIt == m_entries.end())
    {
        return nullptr;
    }

    return &entryIt->second;
}

const std::unordered_map<uint32_t, HouseEntry> &HouseTable::entries() const
{
    return m_entries;
}
}
