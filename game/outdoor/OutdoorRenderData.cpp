#include "game/outdoor/OutdoorRenderData.h"

#include "game/outdoor/OutdoorMapData.h"

#include <algorithm>
#include <array>
#include <limits>

namespace OpenYAMM::Game
{
namespace
{
constexpr std::array<uint8_t, 8> RenderMagic = {'O', 'Y', 'M', 'R', 'E', 'N', '1', 0};
constexpr uint32_t RenderFormatVersion = 1;
constexpr uint32_t RenderHeaderSize = 48;
constexpr uint32_t RenderRecordSize = 24;
constexpr uint32_t RenderFlagDynamic = 0x01;
constexpr uint32_t RenderFlagTranslucent = 0x02;
constexpr uint32_t RenderKnownFlags = RenderFlagDynamic | RenderFlagTranslucent;

uint32_t readU32(const std::vector<uint8_t> &bytes, size_t offset)
{
    return static_cast<uint32_t>(bytes[offset])
        | (static_cast<uint32_t>(bytes[offset + 1]) << 8)
        | (static_cast<uint32_t>(bytes[offset + 2]) << 16)
        | (static_cast<uint32_t>(bytes[offset + 3]) << 24);
}

int16_t readI16(const std::vector<uint8_t> &bytes, size_t offset)
{
    return static_cast<int16_t>(
        static_cast<uint16_t>(bytes[offset]) | (static_cast<uint16_t>(bytes[offset + 1]) << 8));
}

uint64_t readU64(const std::vector<uint8_t> &bytes, size_t offset)
{
    return static_cast<uint64_t>(readU32(bytes, offset))
        | (static_cast<uint64_t>(readU32(bytes, offset + 4)) << 32);
}

uint64_t fnv1a64(const std::vector<uint8_t> &bytes)
{
    uint64_t value = 14695981039346656037ULL;

    for (uint8_t byte : bytes)
    {
        value ^= byte;
        value *= 1099511628211ULL;
    }

    return value;
}

size_t outdoorFaceCount(const OutdoorMapData &outdoorMapData)
{
    size_t result = 0;

    for (const OutdoorBModel &bModel : outdoorMapData.bmodels)
    {
        result += bModel.faces.size();
    }

    return result;
}
}

std::optional<OutdoorRenderData> OutdoorRenderDataLoader::loadFromBytes(
    const std::vector<uint8_t> &renderBytes,
    const std::vector<uint8_t> &geometryBytes,
    const OutdoorMapData &outdoorMapData,
    std::string &errorMessage) const
{
    if (renderBytes.size() < RenderHeaderSize
        || !std::equal(RenderMagic.begin(), RenderMagic.end(), renderBytes.begin()))
    {
        errorMessage = "invalid outdoor render data magic or truncated header";
        return std::nullopt;
    }

    const uint32_t version = readU32(renderBytes, 8);
    const uint32_t headerSize = readU32(renderBytes, 12);
    const uint32_t recordSize = readU32(renderBytes, 16);
    const uint32_t cellSize = readU32(renderBytes, 20);
    const uint64_t geometryHash = readU64(renderBytes, 24);
    const uint32_t sourceBModelCount = readU32(renderBytes, 32);
    const uint32_t sourceFaceCount = readU32(renderBytes, 36);
    const uint32_t faceCount = readU32(renderBytes, 40);
    const uint32_t reserved = readU32(renderBytes, 44);

    if (version != RenderFormatVersion
        || headerSize != RenderHeaderSize
        || recordSize != RenderRecordSize
        || cellSize < 256
        || reserved != 0)
    {
        errorMessage = "unsupported outdoor render data header";
        return std::nullopt;
    }

    if (faceCount > (std::numeric_limits<size_t>::max() - headerSize) / recordSize
        || renderBytes.size() != headerSize + static_cast<size_t>(faceCount) * recordSize)
    {
        errorMessage = "outdoor render data record count does not match file size";
        return std::nullopt;
    }

    if (geometryHash != fnv1a64(geometryBytes))
    {
        errorMessage = "outdoor render data was cooked for different geometry";
        return std::nullopt;
    }

    if (sourceBModelCount != outdoorMapData.bmodels.size()
        || sourceFaceCount != outdoorFaceCount(outdoorMapData))
    {
        errorMessage = "outdoor render data source counts do not match geometry";
        return std::nullopt;
    }

    OutdoorRenderData result = {};
    result.formatVersion = version;
    result.cellSize = cellSize;
    result.geometryHash = geometryHash;
    result.faces.reserve(faceCount);
    uint64_t previousSourceKey = 0;
    std::vector<bool> dynamicBModels(outdoorMapData.bmodels.size(), false);

    for (const OutdoorBModelMechanism &mechanism : outdoorMapData.mechanisms)
    {
        if (mechanism.hasRuntimeEndpointMotion()
            && mechanism.hasBModelBinding
            && mechanism.bmodelIndex < dynamicBModels.size())
        {
            dynamicBModels[mechanism.bmodelIndex] = true;
        }
    }

    for (size_t recordIndex = 0; recordIndex < faceCount; ++recordIndex)
    {
        const size_t offset = headerSize + recordIndex * recordSize;
        OutdoorRenderFaceReference face = {};
        face.sourceKey = readU64(renderBytes, offset);
        face.bModelIndex = readU32(renderBytes, offset + 8);
        face.faceIndex = readU32(renderBytes, offset + 12);
        face.cellX = readI16(renderBytes, offset + 16);
        face.cellY = readI16(renderBytes, offset + 18);
        const uint32_t flags = readU32(renderBytes, offset + 20);

        if (face.bModelIndex >= outdoorMapData.bmodels.size()
            || face.faceIndex >= outdoorMapData.bmodels[face.bModelIndex].faces.size())
        {
            errorMessage = "outdoor render data face references geometry out of range";
            return std::nullopt;
        }

        const uint64_t expectedSourceKey =
            (static_cast<uint64_t>(face.bModelIndex) << 32) | face.faceIndex;

        if (face.sourceKey != expectedSourceKey
            || (recordIndex > 0 && face.sourceKey <= previousSourceKey)
            || (flags & ~RenderKnownFlags) != 0)
        {
            errorMessage = "outdoor render data face identities or flags are invalid";
            return std::nullopt;
        }

        previousSourceKey = face.sourceKey;
        face.dynamic = (flags & RenderFlagDynamic) != 0;
        face.translucent = (flags & RenderFlagTranslucent) != 0;

        if (face.dynamic != dynamicBModels[face.bModelIndex])
        {
            errorMessage = "outdoor render data mechanism ownership does not match scene data";
            return std::nullopt;
        }

        result.faces.push_back(face);
    }

    return result;
}
}
