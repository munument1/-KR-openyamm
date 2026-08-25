#pragma once

#include <cstdint>
#include <vector>
#include <string>

namespace OpenYAMM::Game
{
class Party;

struct JournalQuestEntry
{
    uint32_t qbitId = 0;
    std::string text;
    std::string notes;
    std::string owner;
    std::vector<uint32_t> requiredQBitIds;
    std::vector<uint32_t> forbiddenQBitIds;
    bool usesExplicitConditions = false;
};

class JournalQuestTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<JournalQuestEntry> &entries() const;
    bool hasQuestText(uint32_t qbitId) const;
    bool isVisible(const JournalQuestEntry &entry, const Party &party) const;
    bool qbitChangeRevealsQuest(uint32_t qbitId, bool wasSet, bool isSet, const Party &party) const;

private:
    std::vector<JournalQuestEntry> m_entries;
};
}
