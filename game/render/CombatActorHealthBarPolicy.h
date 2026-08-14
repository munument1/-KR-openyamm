#pragma once

#include "game/gameplay/GameplayActorService.h"

#include <algorithm>
#include <array>
#include <cmath>
#include <cstddef>

namespace OpenYAMM::Game
{
constexpr size_t MaximumCombatActorHealthBars = 8;
constexpr float MinimumCombatActorHealthBarScale = 0.65f;
constexpr float MaximumCombatActorHealthBarDistance = GameplayActorService::MaximumPartyEngagementRange;
constexpr float MaximumCombatActorHealthBarDistanceSquared =
    MaximumCombatActorHealthBarDistance * MaximumCombatActorHealthBarDistance;

struct CombatActorHealthBarCandidate
{
    size_t drawItemIndex = 0;
    float distanceSquared = 0.0f;
};

struct CombatActorHealthBarSelection
{
    std::array<CombatActorHealthBarCandidate, MaximumCombatActorHealthBars> candidates = {};
    size_t count = 0;
};

inline void considerCombatActorHealthBarCandidate(
    CombatActorHealthBarSelection &selection,
    size_t drawItemIndex,
    float distanceSquared)
{
    if (distanceSquared > MaximumCombatActorHealthBarDistanceSquared)
    {
        return;
    }

    if (selection.count < selection.candidates.size())
    {
        selection.candidates[selection.count++] = {drawItemIndex, distanceSquared};
        return;
    }

    size_t farthestCandidateIndex = 0;

    for (size_t index = 1; index < selection.candidates.size(); ++index)
    {
        if (selection.candidates[index].distanceSquared
            > selection.candidates[farthestCandidateIndex].distanceSquared)
        {
            farthestCandidateIndex = index;
        }
    }

    if (distanceSquared < selection.candidates[farthestCandidateIndex].distanceSquared)
    {
        selection.candidates[farthestCandidateIndex] = {drawItemIndex, distanceSquared};
    }
}

inline float combatActorHealthBarScale(float distanceSquared)
{
    const float distance = std::sqrt(std::clamp(distanceSquared, 0.0f, MaximumCombatActorHealthBarDistanceSquared));
    const float distanceRatio = distance / MaximumCombatActorHealthBarDistance;
    return 1.0f - distanceRatio * (1.0f - MinimumCombatActorHealthBarScale);
}
} // namespace OpenYAMM::Game
