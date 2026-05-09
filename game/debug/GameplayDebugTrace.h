#pragma once

#include "game/gameplay/GameplayWorldInteraction.h"

#include <cstdint>
#include <string>

namespace OpenYAMM::Game
{
class ItemTable;

bool gameplayDebugTraceEnabled();
bool gameplayDebugTraceSuppressed();
void gameplayDebugTraceLog(const std::string &message);
std::string gameplayDebugTraceWorldHitSummary(const GameplayWorldHit &hit);
bool gameplayDebugTraceItemLooksQuestRelevant(uint32_t itemId, const ItemTable *pItemTable);
std::string gameplayDebugTraceItemSummary(uint32_t itemId, const ItemTable *pItemTable);
const char *gameplayDebugTraceMechanismStateName(uint16_t state);
const char *gameplayDebugTraceMechanismActionName(uint32_t action);

class ScopedGameplayDebugTraceSuppression
{
public:
    ScopedGameplayDebugTraceSuppression();
    ~ScopedGameplayDebugTraceSuppression();

    ScopedGameplayDebugTraceSuppression(const ScopedGameplayDebugTraceSuppression &) = delete;
    ScopedGameplayDebugTraceSuppression &operator=(const ScopedGameplayDebugTraceSuppression &) = delete;
};
}
