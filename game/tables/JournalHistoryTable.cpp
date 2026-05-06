#include "game/tables/JournalHistoryTable.h"

#include <algorithm>
#include <cstdlib>

namespace OpenYAMM::Game
{
namespace
{
constexpr uint32_t DefaultHistoryContinentId = 1;

std::string getCell(const std::vector<std::string> &row, size_t index)
{
    return index < row.size() ? row[index] : "";
}
}

bool JournalHistoryTable::loadFromRows(const std::vector<std::vector<std::string>> &rows)
{
    return loadFromRowsForContinent(DefaultHistoryContinentId, rows);
}

bool JournalHistoryTable::loadFromRowsForContinent(uint32_t continentId, const std::vector<std::vector<std::string>> &rows)
{
    std::vector<JournalHistoryEntry> entries;

    for (const std::vector<std::string> &row : rows)
    {
        if (row.empty() || row[0].empty() || row[0][0] == '#')
        {
            continue;
        }

        char *pEnd = nullptr;
        const unsigned long parsedId = std::strtoul(row[0].c_str(), &pEnd, 10);

        if (pEnd == row[0].c_str() || *pEnd != '\0')
        {
            continue;
        }

        JournalHistoryEntry entry = {};
        entry.id = static_cast<uint32_t>(parsedId);
        entry.text = getCell(row, 1);
        entry.timeToken = getCell(row, 2);
        entry.pageTitle = getCell(row, 3);

        if (entry.text.empty())
        {
            continue;
        }

        entries.push_back(std::move(entry));
    }

    std::sort(
        entries.begin(),
        entries.end(),
        [](const JournalHistoryEntry &left, const JournalHistoryEntry &right)
        {
            return left.id < right.id;
        });

    if (entries.empty())
    {
        return false;
    }

    if (continentId == DefaultHistoryContinentId)
    {
        m_entries = entries;
    }

    m_entriesByContinent[continentId] = std::move(entries);
    return true;
}

const std::vector<JournalHistoryEntry> &JournalHistoryTable::entries() const
{
    return m_entries;
}

const std::vector<JournalHistoryEntry> &JournalHistoryTable::entriesForContinent(uint32_t continentId) const
{
    const std::unordered_map<uint32_t, std::vector<JournalHistoryEntry>>::const_iterator found =
        m_entriesByContinent.find(continentId);

    return found != m_entriesByContinent.end() ? found->second : emptyEntries();
}

const JournalHistoryEntry *JournalHistoryTable::get(uint32_t id) const
{
    return getForContinent(DefaultHistoryContinentId, id);
}

const JournalHistoryEntry *JournalHistoryTable::getForContinent(uint32_t continentId, uint32_t id) const
{
    for (const JournalHistoryEntry &entry : entriesForContinent(continentId))
    {
        if (entry.id == id)
        {
            return &entry;
        }
    }

    return nullptr;
}

const std::vector<JournalHistoryEntry> &JournalHistoryTable::emptyEntries()
{
    static const std::vector<JournalHistoryEntry> entries;
    return entries;
}
}
