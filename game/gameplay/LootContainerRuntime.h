#pragma once

#include "game/maps/MapDeltaData.h"
#include "game/maps/MapItemSourceData.h"

#include <cstdint>

namespace OpenYAMM::Game
{
class ChestTable;
class ItemTable;

MapLootContainerSource materializeSpawnedLootContainerSource(
    const MapSpawnedLootContainerSource &source,
    uint32_t containerId);

MapDeltaChest buildLootContainerChest(
    const MapLootContainerSource &source,
    int mapTreasureLevel,
    int mapId,
    uint32_t sessionSeed,
    const ItemTable *pItemTable,
    const ChestTable *pChestTable);
}
