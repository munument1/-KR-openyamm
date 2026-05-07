#pragma once

#include <array>
#include <string>
#include <unordered_map>
#include <vector>

namespace OpenYAMM::Game
{
class RaceStartingStatsTable
{
public:
    struct Entry
    {
        std::string raceName;
        std::array<int, 7> stats = {};
        std::array<int, 7> maximumStats = {};
        std::array<int, 7> addSteps = {};
        std::array<int, 7> droppedSteps = {};
    };

    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const Entry *get(const std::string &raceName) const;

private:
    static std::string canonicalRaceName(const std::string &raceName);

    std::unordered_map<std::string, Entry> m_entries;
};
}
