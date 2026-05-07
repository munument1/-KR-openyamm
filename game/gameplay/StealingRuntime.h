#pragma once

#include "game/party/Party.h"

#include <cstdint>

namespace OpenYAMM::Game
{
enum class StealingTargetKind : uint8_t
{
    Shop,
    Monster,
};

enum class StealingOutcomeKind : uint8_t
{
    Ignored,
    Success,
    NoInventoryRoom,
    NothingToSteal,
    FailedUncaught,
    FailedCaught,
    TooFar,
    InsufficientSkill,
};

struct StealingAttemptInput
{
    StealingTargetKind targetKind = StealingTargetKind::Shop;
    int itemValue = 0;
    int itemReputationRequirement = 0;
    int monsterLevel = 0;
    int distanceSquared = 0;
    bool hasLoot = true;
    bool inventoryHasRoom = true;
    bool reputationSensitiveTarget = true;
    int invisibilitySkill = 0;
    uint32_t successRoll = 0;
    uint32_t caughtRoll = 0;
};

struct StealingAttemptResult
{
    StealingOutcomeKind outcome = StealingOutcomeKind::Ignored;
    bool handled = false;
    bool stoleItem = false;
    bool caught = false;
    bool breakInvisibility = false;
    int reputationDelta = 0;
    int fineDelta = 0;
    float recoverySeconds = 0.0f;
};

class IGameplayWorldRuntime;

int stealingTotalSkill(const Character &member);
int stealingRecoveryTicks(const Character &member);
StealingAttemptResult resolveStealingAttempt(const Character &member, const StealingAttemptInput &input);
void applyStealingAttemptResult(
    IGameplayWorldRuntime &worldRuntime,
    Party *pParty,
    const StealingAttemptResult &result);
}
