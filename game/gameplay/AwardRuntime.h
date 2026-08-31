#pragma once

#include <cstddef>
#include <cstdint>
#include <functional>
#include <string>
#include <vector>

namespace OpenYAMM::Game
{
class AwardTable;
class Character;
class Party;

using AwardAutonoteLookup = std::function<bool(uint32_t)>;

struct VisibleAward
{
    std::string key;
    std::string text;
    int priority = 0;
};

std::vector<VisibleAward> buildVisibleAwards(const AwardTable &awardTable,
                                             const Character &character,
                                             const Party &party,
                                             const AwardAutonoteLookup &isAutonoteUnlocked);

size_t visibleAwardCount(const AwardTable &awardTable,
                         const Character &character,
                         const Party &party,
                         const AwardAutonoteLookup &isAutonoteUnlocked);
} // namespace OpenYAMM::Game
