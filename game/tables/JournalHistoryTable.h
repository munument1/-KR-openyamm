#pragma once

#include <cstdint>
#include <string>
#include <unordered_map>
#include <vector>

namespace OpenYAMM::Game
{
struct JournalHistoryEntry
{
    uint32_t id = 0;
    std::string text;
    std::string timeToken;
    std::string pageTitle;
};

class JournalHistoryTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    bool loadFromRowsForContinent(uint32_t continentId, const std::vector<std::vector<std::string>> &rows);
    const std::vector<JournalHistoryEntry> &entries() const;
    const std::vector<JournalHistoryEntry> &entriesForContinent(uint32_t continentId) const;
    const JournalHistoryEntry *get(uint32_t id) const;
    const JournalHistoryEntry *getForContinent(uint32_t continentId, uint32_t id) const;

private:
    static const std::vector<JournalHistoryEntry> &emptyEntries();

    std::vector<JournalHistoryEntry> m_entries;
    std::unordered_map<uint32_t, std::vector<JournalHistoryEntry>> m_entriesByContinent;
};
}
