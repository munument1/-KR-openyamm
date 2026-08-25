#pragma once

#include "game/maps/MapItemSourceData.h"

namespace OpenYAMM::Game
{
class Party;
class ItemTable;
struct InventoryItem;

bool worldItemPolicyAvailable(const MapWorldItemSource &source, const Party &party);
bool applyWorldItemPolicyActions(
    const MapWorldItemSource &source,
    const InventoryItem &randomPoolItem,
    Party &party,
    const ItemTable &itemTable);
}
