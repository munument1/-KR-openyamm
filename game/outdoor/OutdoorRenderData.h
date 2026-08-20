#pragma once

#include <cstdint>
#include <optional>
#include <string>
#include <vector>

namespace OpenYAMM::Game
{
struct OutdoorMapData;

struct OutdoorRenderFaceReference
{
    uint64_t sourceKey = 0;
    uint32_t bModelIndex = 0;
    uint32_t faceIndex = 0;
    int32_t cellX = 0;
    int32_t cellY = 0;
    bool dynamic = false;
    bool translucent = false;
};

struct OutdoorRenderData
{
    uint32_t formatVersion = 0;
    uint32_t cellSize = 0;
    uint64_t geometryHash = 0;
    std::vector<OutdoorRenderFaceReference> faces;
};

class OutdoorRenderDataLoader
{
public:
    std::optional<OutdoorRenderData> loadFromBytes(
        const std::vector<uint8_t> &renderBytes,
        const std::vector<uint8_t> &geometryBytes,
        const OutdoorMapData &outdoorMapData,
        std::string &errorMessage) const;
};
}
