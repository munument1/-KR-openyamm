#include "game/render/CombatActorHealthBarPolicy.h"

#include <doctest/doctest.h>

#include <algorithm>
#include <array>

namespace OpenYAMM::Game
{
TEST_CASE("combat actor health bars retain the eight nearest candidates within engagement range")
{
    CombatActorHealthBarSelection rangeSelection = {};
    considerCombatActorHealthBarCandidate(rangeSelection, 0, MaximumCombatActorHealthBarDistanceSquared);
    constexpr float BeyondMaximumDistance = MaximumCombatActorHealthBarDistance + 1.0f;
    considerCombatActorHealthBarCandidate(rangeSelection, 1, BeyondMaximumDistance * BeyondMaximumDistance);
    REQUIRE(rangeSelection.count == 1);
    CHECK(rangeSelection.candidates[0].drawItemIndex == 0);

    CombatActorHealthBarSelection selection = {};

    for (size_t index = 0; index < 10; ++index)
    {
        const float distance = static_cast<float>(10 - index) * 100.0f;
        considerCombatActorHealthBarCandidate(selection, index, distance * distance);
    }

    REQUIRE(selection.count == MaximumCombatActorHealthBars);
    std::array<size_t, MaximumCombatActorHealthBars> selectedIndices = {};

    for (size_t index = 0; index < selection.count; ++index)
    {
        selectedIndices[index] = selection.candidates[index].drawItemIndex;
    }

    std::sort(selectedIndices.begin(), selectedIndices.end());
    const std::array<size_t, MaximumCombatActorHealthBars> expectedIndices = {2, 3, 4, 5, 6, 7, 8, 9};
    CHECK(selectedIndices == expectedIndices);
}

TEST_CASE("combat actor health bars shrink gradually across maximum engagement range")
{
    CHECK(combatActorHealthBarScale(0.0f) == doctest::Approx(1.0f));
    CHECK(
        combatActorHealthBarScale(
            MaximumCombatActorHealthBarDistanceSquared * 0.25f)
        == doctest::Approx(0.825f));
    CHECK(
        combatActorHealthBarScale(MaximumCombatActorHealthBarDistanceSquared)
        == doctest::Approx(MinimumCombatActorHealthBarScale));
}
} // namespace OpenYAMM::Game
