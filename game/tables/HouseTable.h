#pragma once

#include <cstdint>
#include <array>
#include <optional>
#include <string>
#include <unordered_map>
#include <vector>

namespace OpenYAMM::Game
{
class MapStats;
class MergedHouseExitTable;
class MergedHouseRuleTable;
class MergedTransportLocationTable;

struct HouseEntry
{
    struct StockRule
    {
        int quality = 0;
        int secondaryQuality = 0;
        std::vector<uint32_t> itemTypes;
        std::vector<uint32_t> secondaryItemTypes;
    };

    struct TransportRoute
    {
        uint32_t routeIndex = 0;
        std::string destinationName;
        std::string mapFileName;
        std::array<bool, 7> daysAvailable = {true, true, true, true, true, true, true};
        uint32_t travelDays = 0;
        int x = 0;
        int y = 0;
        int z = 0;
        int directionDegrees = 0;
        uint32_t requiredQBit = 0;
        bool useMapStartPosition = false;
    };

    struct ArcomageRule
    {
        int towerToWin = 0;
        int resourceToWin = 0;
        int towerAtStart = 0;
        int wallAtStart = 0;
        int quarry = 0;
        int magic = 0;
        int dungeon = 0;
        int bricks = 0;
        int gems = 0;
        int recruits = 0;
        int ai = 0;
        uint32_t rulesTextId = 0;
    };

    struct ExtraExit
    {
        uint32_t pictureId = 0;
        uint32_t destinationMapId = 0;
        uint32_t requiredQuestBit = 0;
        std::string destinationMapFileName;
        std::string destinationName;
        std::string label;
        bool useMapStartPosition = true;
        int x = 0;
        int y = 0;
        int z = 0;
    };

    uint32_t id = 0;
    uint32_t typeIndex = 0;
    uint32_t mapId = 0;
    uint32_t proprietorPictureId = 0;
    uint32_t roomSoundId = 0;
    uint32_t houseSoundBaseId = 0;
    std::string type;
    std::string name;
    std::string buildingName;
    std::string videoName;
    std::string proprietorName;
    std::string proprietorTitle;
    float priceMultiplier = 0.0f;
    float skillPriceMultiplier = 0.0f;
    StockRule standardStockRule;
    StockRule specialStockRule;
    StockRule spellbookStockRule;
    int standardStockTier = 0;
    int specialStockTier = 0;
    int stockRefreshDays = 0;
    int trainingMaxLevel = 0;
    int openHour = 0;
    int closeHour = 0;
    std::string enterText;
    std::vector<std::string> offeredSkills;
    std::vector<uint32_t> residentNpcIds;
    std::vector<TransportRoute> transportRoutes;
    std::optional<ArcomageRule> arcomageRule;
    uint32_t rawExtraExitPictureIndex = 0;
    uint32_t rawExtraExitMapId = 0;
    int rawExtraExitRestriction = 0;
    std::optional<ExtraExit> extraExit;
};

class HouseTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    bool loadAnimationRows(const std::vector<std::vector<std::string>> &rows);
    bool loadAnimationRows(
        const std::vector<std::vector<std::string>> &rows,
        const std::vector<std::vector<std::string>> &movieRows);
    bool applyHouseRules(
        const MergedHouseRuleTable &houseRules,
        const MergedTransportLocationTable &transportLocations,
        const MapStats &mapStats
    );
    bool applyHouseExits(const MergedHouseExitTable &houseExits, const MapStats &mapStats);
    std::optional<std::string> getName(uint32_t houseId) const;
    const HouseEntry *get(uint32_t houseId) const;
    const std::unordered_map<uint32_t, HouseEntry> &entries() const;

private:
    bool loadAnimationRows(
        const std::vector<std::vector<std::string>> &rows,
        const std::unordered_map<uint32_t, std::string> &movieStemsByAnimationId);

    std::unordered_map<uint32_t, HouseEntry> m_entries;
};
}
