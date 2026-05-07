#include "game/tables/RaceStartingStatsTable.h"

#include <algorithm>
#include <cctype>
#include <cstdlib>

namespace OpenYAMM::Game
{
namespace
{
constexpr int NeutralStatValue = 11;
constexpr int DefaultMaximumStatValue = 25;

bool parseInteger(const std::string &text, int &value)
{
    if (text.empty())
    {
        return false;
    }

    char *pEnd = nullptr;
    const long parsed = std::strtol(text.c_str(), &pEnd, 10);

    if (pEnd == text.c_str() || *pEnd != '\0')
    {
        return false;
    }

    value = static_cast<int>(parsed);
    return true;
}

bool parseBaseMaxCell(const std::string &cell, int &baseValue, int &maximumValue)
{
    const size_t slash = cell.find('/');

    if (slash == std::string::npos)
    {
        if (!parseInteger(cell, baseValue))
        {
            return false;
        }

        maximumValue = DefaultMaximumStatValue;
        return true;
    }

    return parseInteger(cell.substr(0, slash), baseValue)
        && parseInteger(cell.substr(slash + 1), maximumValue);
}

bool parseAddStepCell(const std::string &cell, int baseValue, int &addStep, int &droppedStep)
{
    const size_t slash = cell.find('/');

    if (slash == std::string::npos)
    {
        if (!parseInteger(cell, addStep))
        {
            return false;
        }

        droppedStep = baseValue > NeutralStatValue ? 1 : addStep;
        return true;
    }

    return parseInteger(cell.substr(0, slash), addStep)
        && parseInteger(cell.substr(slash + 1), droppedStep);
}
}

std::string RaceStartingStatsTable::canonicalRaceName(const std::string &raceName)
{
    std::string canonical;
    const size_t parenthesis = raceName.find('(');
    const std::string source = parenthesis == std::string::npos
        ? raceName
        : raceName.substr(0, parenthesis);
    canonical.reserve(source.size());

    for (char character : source)
    {
        if (std::isalnum(static_cast<unsigned char>(character)) == 0)
        {
            continue;
        }

        canonical.push_back(static_cast<char>(std::tolower(static_cast<unsigned char>(character))));
    }

    return canonical;
}

bool RaceStartingStatsTable::loadFromRows(const std::vector<std::vector<std::string>> &rows)
{
    m_entries.clear();

    if (rows.size() < 2)
    {
        return false;
    }

    if (!rows.empty() && !rows[0].empty() && rows[0][0] == "Stat")
    {
        const std::vector<std::string> &header = rows[0];

        for (size_t columnIndex = 1; columnIndex < header.size(); ++columnIndex)
        {
            Entry entry = {};
            entry.raceName = header[columnIndex];
            const std::string canonicalName = canonicalRaceName(entry.raceName);

            if (canonicalName.empty())
            {
                continue;
            }

            entry.maximumStats.fill(DefaultMaximumStatValue);
            entry.addSteps.fill(1);
            entry.droppedSteps.fill(1);
            m_entries[canonicalName] = std::move(entry);
        }

        size_t statIndex = 0;

        for (size_t rowIndex = 1; rowIndex + 1 < rows.size() && statIndex < 7; rowIndex += 2, ++statIndex)
        {
            const std::vector<std::string> &statRow = rows[rowIndex];
            const std::vector<std::string> &addRow = rows[rowIndex + 1];

            for (size_t columnIndex = 1; columnIndex < header.size(); ++columnIndex)
            {
                Entry *pEntry = nullptr;
                const std::string canonicalName = canonicalRaceName(header[columnIndex]);
                const std::unordered_map<std::string, Entry>::iterator entryIt = m_entries.find(canonicalName);

                if (entryIt == m_entries.end())
                {
                    continue;
                }

                pEntry = &entryIt->second;

                if (columnIndex >= statRow.size())
                {
                    continue;
                }

                if (!parseBaseMaxCell(
                        statRow[columnIndex],
                        pEntry->stats[statIndex],
                        pEntry->maximumStats[statIndex]))
                {
                    continue;
                }

                if (columnIndex < addRow.size())
                {
                    parseAddStepCell(
                        addRow[columnIndex],
                        pEntry->stats[statIndex],
                        pEntry->addSteps[statIndex],
                        pEntry->droppedSteps[statIndex]);
                }
            }
        }

        return !m_entries.empty();
    }

    for (size_t rowIndex = 1; rowIndex < rows.size(); ++rowIndex)
    {
        const std::vector<std::string> &row = rows[rowIndex];

        if (row.size() < 8)
        {
            continue;
        }

        Entry entry = {};
        entry.raceName = row[0];
        entry.maximumStats.fill(DefaultMaximumStatValue);
        entry.addSteps.fill(1);
        entry.droppedSteps.fill(1);
        const std::string canonicalName = canonicalRaceName(entry.raceName);

        if (canonicalName.empty())
        {
            continue;
        }

        bool valid = true;

        for (size_t statIndex = 0; statIndex < entry.stats.size(); ++statIndex)
        {
            try
            {
                entry.stats[statIndex] = std::stoi(row[statIndex + 1]);
            }
            catch (...)
            {
                valid = false;
                break;
            }
        }

        if (!valid)
        {
            continue;
        }

        m_entries[canonicalName] = std::move(entry);
    }

    return !m_entries.empty();
}

const RaceStartingStatsTable::Entry *RaceStartingStatsTable::get(const std::string &raceName) const
{
    const std::unordered_map<std::string, Entry>::const_iterator it = m_entries.find(canonicalRaceName(raceName));

    if (it == m_entries.end())
    {
        return nullptr;
    }

    return &it->second;
}
}
