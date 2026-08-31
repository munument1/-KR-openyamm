#pragma once

#include "game/maps/MapDeltaData.h"
#include "game/party/Party.h"

#include <optional>
#include <random>
#include <string>

namespace OpenYAMM::Game
{
class ItemTable;

struct Mm9BarrelResult
{
    bool handled = false;
    bool alreadyUsed = false;
    bool invalidCharacter = false;
    bool statRaised = false;
    bool diseaseApplied = false;
    bool itemGenerated = false;
    bool itemAwarded = false;
    bool inventoryFull = false;
    std::optional<InventoryItem> generatedItem;
    std::string statusMessage;
    std::string soundName;
};

uint32_t mm9BarrelSeed(uint32_t sessionSeed, const std::string &sourceId);
MapDeltaMm9BarrelState &ensureMm9BarrelState(
    std::vector<MapDeltaMm9BarrelState> &states,
    uint32_t sourceObjectIndex,
    std::mt19937 &rng);
size_t mm9BarrelLiquidTextureIndex(const MapDeltaMm9BarrelState &state);
std::optional<InventoryItem> generateMm9TreasureLevelOneItem(
    const ItemTable &itemTable,
    int bestPartyLuckModifier,
    std::mt19937 &rng);
Mm9BarrelResult useMm9Barrel(
    MapDeltaMm9BarrelState &state,
    Party &party,
    const ItemTable &itemTable,
    std::mt19937 &rng);
}
