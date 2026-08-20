#pragma once

#include <cstdint>
#include <optional>
#include <string>
#include <vector>

namespace OpenYAMM::Game
{
struct OutdoorMapData;
constexpr uint64_t InvalidOutdoorNavigationSourceKey = UINT64_MAX;

enum class OutdoorNavigationFacetKind : uint8_t
{
    Floor = 1,
    Barrier = 2
};

struct OutdoorNavigationFacetReference
{
    uint64_t sourceKey = 0;
    uint32_t bModelIndex = 0;
    uint32_t faceIndex = 0;
    uint32_t mechanismId = 0;
    uint16_t mergeLeaderOffset = 0;
    int32_t pathSourceId = -1;
    OutdoorNavigationFacetKind kind = OutdoorNavigationFacetKind::Floor;
    bool walkable = false;
    bool blocking = false;
    bool dynamic = false;
};

struct OutdoorNavigationData
{
    uint32_t formatVersion = 0;
    uint64_t geometryHash = 0;
    std::vector<OutdoorNavigationFacetReference> facets;
};

class OutdoorNavigationDataLoader
{
public:
    std::optional<OutdoorNavigationData> loadFromBytes(
        const std::vector<uint8_t> &navigationBytes,
        const std::vector<uint8_t> &geometryBytes,
        const OutdoorMapData &outdoorMapData,
        std::string &errorMessage) const;
};
}
