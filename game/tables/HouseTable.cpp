#include "game/tables/HouseTable.h"

#include "game/tables/MapStats.h"
#include "game/tables/MmergeBaseTables.h"

#include <algorithm>
#include <cctype>
#include <cmath>
#include <cstdlib>
#include <iostream>
#include <limits>
#include <sstream>
#include <unordered_map>

namespace OpenYAMM::Game
{
namespace
{
constexpr int MmergeYawUnitsPerTurn = 2048;
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

int parseTrainingMaxLevel(const std::string &value)
{
    if (value.empty())
    {
        return 0;
    }

    if (value == "No Max" || value == "no max")
    {
        return std::numeric_limits<int>::max();
    }

    return std::atoi(value.c_str());
}

int parseStandardStockTier(float priceMultiplier)
{
    if (priceMultiplier <= 0.0f)
    {
        return 0;
    }

    return std::clamp(static_cast<int>(std::floor(priceMultiplier)), 1, 6);
}

int parseSpecialStockTier(float priceMultiplier, float skillPriceMultiplier)
{
    const int standardTier = parseStandardStockTier(priceMultiplier);

    if (standardTier == 0)
    {
        return 0;
    }

    if (skillPriceMultiplier <= 0.0f)
    {
        return standardTier;
    }

    const int bonusTier = std::max(1, static_cast<int>(std::ceil(skillPriceMultiplier * 0.5f)));
    return std::clamp(standardTier + bonusTier, standardTier, 6);
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

bool parseBoolDefaultTrue(const std::string &value)
{
    if (value.empty())
    {
        return true;
    }

    std::string lowered = value;
    std::transform(
        lowered.begin(),
        lowered.end(),
        lowered.begin(),
        [](unsigned char character)
        {
            return static_cast<char>(std::tolower(character));
        });

    return lowered == "1" || lowered == "true" || lowered == "yes" || lowered == "y";
}

bool isTransportHouseTypeName(const std::string &houseType)
{
    return houseType == "Stables" || houseType == "Boats";
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

int directionDegreesFromMmergeYawUnits(int32_t yawUnits)
{
    int32_t normalized = yawUnits % MmergeYawUnitsPerTurn;

    if (normalized < 0)
    {
        normalized += MmergeYawUnitsPerTurn;
    }

    return static_cast<int>((normalized * DegreesPerTurn) / MmergeYawUnitsPerTurn);
}

const MmergeHouseRuleSection *findHouseRuleSection(
    const MmergeHouseRuleTable &houseRules,
    const std::string &sectionName)
{
    for (const MmergeHouseRuleSection &section : houseRules.sections())
    {
        if (section.name == sectionName)
        {
            return &section;
        }
    }

    return nullptr;
}

const std::vector<int32_t> *findHouseRuleRow(const MmergeHouseRuleSection &section, uint32_t mapId)
{
    for (const std::vector<int32_t> &row : section.numericRows)
    {
        if (!row.empty() && row[0] == static_cast<int32_t>(mapId))
        {
            return &row;
        }
    }

    return nullptr;
}

const MmergeTransportLocationEntry *findTransportLocation(
    const MmergeTransportLocationTable &transportLocations,
    int32_t locationId)
{
    if (locationId < 0)
    {
        return nullptr;
    }

    for (const MmergeTransportLocationEntry &entry : transportLocations.entries())
    {
        if (entry.id == static_cast<uint32_t>(locationId))
        {
            return &entry;
        }
    }

    return nullptr;
}

std::string destinationNameForTransportLocation(
    const MmergeTransportLocationEntry &location,
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
        entry.standardStockTier = parseStandardStockTier(entry.priceMultiplier);
        entry.specialStockTier = parseSpecialStockTier(entry.priceMultiplier, entry.skillPriceMultiplier);
        entry.stockRefreshDays = (row.size() > 15 && !row[15].empty()) ? std::atoi(row[15].c_str()) : 0;
        entry.trainingMaxLevel = row.size() > 17 ? parseTrainingMaxLevel(row[17]) : 0;
        entry.openHour = (row.size() > 18 && !row[18].empty()) ? std::atoi(row[18].c_str()) : 0;
        entry.closeHour = (row.size() > 19 && !row[19].empty()) ? std::atoi(row[19].c_str()) : 0;
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

bool HouseTable::loadTransportScheduleRows(const std::vector<std::vector<std::string>> &rows)
{
    for (const std::vector<std::string> &row : rows)
    {
        if (row.empty() || row[0].empty() || row[0][0] == '#')
        {
            continue;
        }

        const uint32_t houseId = parseUnsigned(row[0]);

        if (houseId == 0)
        {
            continue;
        }

        HouseEntry &entry = m_entries[houseId];
        entry.id = houseId;

        HouseEntry::TransportRoute route = {};
        route.routeIndex = row.size() > 1 ? parseUnsigned(row[1]) : 0;
        route.destinationName = row.size() > 2 ? row[2] : "";
        route.mapFileName = row.size() > 3 ? row[3] : "";
        route.travelDays = row.size() > 4 ? parseUnsigned(row[4]) : 0;

        for (size_t dayIndex = 0; dayIndex < route.daysAvailable.size(); ++dayIndex)
        {
            route.daysAvailable[dayIndex] = row.size() > (5 + dayIndex)
                ? parseBoolDefaultTrue(row[5 + dayIndex])
                : true;
        }

        route.x = row.size() > 12 ? parseSigned(row[12]) : 0;
        route.y = row.size() > 13 ? parseSigned(row[13]) : 0;
        route.z = row.size() > 14 ? parseSigned(row[14]) : 0;
        route.directionDegrees = row.size() > 15 ? parseSigned(row[15]) : 0;
        route.requiredQBit = row.size() > 16 ? parseUnsigned(row[16]) : 0;
        route.useMapStartPosition =
            row.size() > 17
            ? parseBoolDefaultTrue(row[17])
            : (row.size() <= 14 || (row[12].empty() && row[13].empty() && row[14].empty()));
        entry.transportRoutes.push_back(std::move(route));
    }

    for (auto &[houseId, entry] : m_entries)
    {
        (void)houseId;
        std::sort(
            entry.transportRoutes.begin(),
            entry.transportRoutes.end(),
            [](const HouseEntry::TransportRoute &left, const HouseEntry::TransportRoute &right)
            {
                if (left.routeIndex != right.routeIndex)
                {
                    return left.routeIndex < right.routeIndex;
                }

                return left.destinationName < right.destinationName;
            });
    }

    return true;
}

bool HouseTable::applyMmergeTransportRoutes(
    const MmergeHouseRuleTable &houseRules,
    const MmergeTransportLocationTable &transportLocations,
    const MapStats &mapStats)
{
    for (auto &[houseId, entry] : m_entries)
    {
        (void)houseId;

        if (!isTransportHouseTypeName(entry.type) || !entry.transportRoutes.empty())
        {
            continue;
        }

        const MmergeHouseRuleSection *pSection = findHouseRuleSection(houseRules, entry.type);

        if (pSection == nullptr)
        {
            std::cerr << "MMerge house rules are missing transport section: " << entry.type << '\n';
            return false;
        }

        const uint32_t routeRuleId = entry.typeIndex != 0 ? entry.typeIndex : entry.mapId;
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

            const MmergeTransportLocationEntry *pLocation = findTransportLocation(transportLocations, locationId);

            if (pLocation == nullptr)
            {
                std::cerr << "MMerge house route references unknown transport location " << locationId
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
            route.directionDegrees = directionDegreesFromMmergeYawUnits(pLocation->direction);
            route.requiredQBit = pLocation->qbit;
            route.useMapStartPosition = false;
            entry.transportRoutes.push_back(std::move(route));
            addedLocationIds.push_back(locationId);
        }
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
