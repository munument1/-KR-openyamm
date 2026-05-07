#pragma once

#include <cstddef>
#include <cstdint>
#include <optional>
#include <string>
#include <unordered_map>
#include <vector>

namespace OpenYAMM::Game
{
class PotionNoteTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);

    std::optional<uint32_t> autonoteIdForMix(uint32_t targetItemId, uint32_t heldItemId) const;
    size_t entryCount() const;

private:
    static uint64_t key(uint32_t rowItemId, uint32_t columnItemId);

    std::unordered_map<uint64_t, uint32_t> m_autonoteIds;
};
}
