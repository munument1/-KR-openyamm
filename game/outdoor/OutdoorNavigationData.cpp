#include "game/outdoor/OutdoorNavigationData.h"

#include "game/outdoor/OutdoorMapData.h"

#include <algorithm>
#include <array>
#include <limits>

namespace OpenYAMM::Game
{
namespace
{
constexpr std::array<uint8_t, 8> NavigationMagic = {'O', 'Y', 'M', 'N', 'A', 'V', '1', 0};
constexpr uint32_t NavigationFormatVersion = 1;
constexpr uint32_t NavigationHeaderSize = 48;
constexpr uint32_t NavigationRecordSize = 24;
constexpr uint8_t NavigationFlagWalkable = 0x01;
constexpr uint8_t NavigationFlagBlocking = 0x02;
constexpr uint8_t NavigationFlagDynamic = 0x04;
constexpr uint8_t NavigationKnownFlags =
    NavigationFlagWalkable | NavigationFlagBlocking | NavigationFlagDynamic;

uint32_t readU32(const std::vector<uint8_t> &bytes, size_t offset)
{
    return static_cast<uint32_t>(bytes[offset])
        | (static_cast<uint32_t>(bytes[offset + 1]) << 8)
        | (static_cast<uint32_t>(bytes[offset + 2]) << 16)
        | (static_cast<uint32_t>(bytes[offset + 3]) << 24);
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

std::optional<OutdoorNavigationData> OutdoorNavigationDataLoader::loadFromBytes(
    const std::vector<uint8_t> &navigationBytes,
    const std::vector<uint8_t> &geometryBytes,
    const OutdoorMapData &outdoorMapData,
    std::string &errorMessage) const
{
    if (navigationBytes.size() < NavigationHeaderSize
        || !std::equal(NavigationMagic.begin(), NavigationMagic.end(), navigationBytes.begin()))
    {
        errorMessage = "invalid outdoor navigation magic or truncated header";
        return std::nullopt;
    }

    const uint32_t version = readU32(navigationBytes, 8);
    const uint32_t headerSize = readU32(navigationBytes, 12);
    const uint32_t recordSize = readU32(navigationBytes, 16);
    const uint32_t headerFlags = readU32(navigationBytes, 20);
    const uint64_t geometryHash = readU64(navigationBytes, 24);
    const uint32_t sourceBModelCount = readU32(navigationBytes, 32);
    const uint32_t sourceFaceCount = readU32(navigationBytes, 36);
    const uint32_t facetCount = readU32(navigationBytes, 40);
    const uint32_t reserved = readU32(navigationBytes, 44);

    if (version != NavigationFormatVersion
        || headerSize != NavigationHeaderSize
        || recordSize != NavigationRecordSize
        || headerFlags != 0
        || reserved != 0)
    {
        errorMessage = "unsupported outdoor navigation header";
        return std::nullopt;
    }

    if (facetCount > (std::numeric_limits<size_t>::max() - headerSize) / recordSize
        || facetCount > static_cast<uint32_t>(std::numeric_limits<int32_t>::max())
        || navigationBytes.size() != headerSize + static_cast<size_t>(facetCount) * recordSize)
    {
        errorMessage = "outdoor navigation record count does not match file size";
        return std::nullopt;
    }

    if (geometryHash != fnv1a64(geometryBytes))
    {
        errorMessage = "outdoor navigation was cooked for different geometry";
        return std::nullopt;
    }

    if (sourceBModelCount != outdoorMapData.bmodels.size()
        || sourceFaceCount != outdoorFaceCount(outdoorMapData))
    {
        errorMessage = "outdoor navigation source counts do not match geometry";
        return std::nullopt;
    }

    OutdoorNavigationData result = {};
    result.formatVersion = version;
    result.geometryHash = geometryHash;
    result.facets.reserve(facetCount);
    uint64_t previousSourceKey = 0;
    std::vector<uint32_t> mechanismIdByBModel(outdoorMapData.bmodels.size(), 0);

    for (const OutdoorBModelMechanism &mechanism : outdoorMapData.mechanisms)
    {
        if (mechanism.hasRuntimeEndpointMotion()
            && mechanism.hasBModelBinding
            && mechanism.bmodelIndex < mechanismIdByBModel.size()
            && mechanismIdByBModel[mechanism.bmodelIndex] == 0)
        {
            mechanismIdByBModel[mechanism.bmodelIndex] = mechanism.mechanismId;
        }
    }

    for (const OutdoorDestructible &destructible : outdoorMapData.destructibles)
    {
        if (destructible.runtimeObjectId != 0 && destructible.bmodelIndex < mechanismIdByBModel.size())
        {
            mechanismIdByBModel[destructible.bmodelIndex] = destructible.runtimeObjectId;
        }
        for (size_t auxiliaryBmodelIndex : destructible.auxiliaryBmodelIndices)
        {
            if (destructible.runtimeObjectId != 0 && auxiliaryBmodelIndex < mechanismIdByBModel.size())
            {
                mechanismIdByBModel[auxiliaryBmodelIndex] = destructible.runtimeObjectId;
            }
        }
    }

    for (size_t facetIndex = 0; facetIndex < facetCount; ++facetIndex)
    {
        const size_t offset = headerSize + facetIndex * recordSize;
        OutdoorNavigationFacetReference facet = {};
        facet.sourceKey = readU64(navigationBytes, offset);
        facet.bModelIndex = readU32(navigationBytes, offset + 8);
        facet.faceIndex = readU32(navigationBytes, offset + 12);
        facet.mechanismId = readU32(navigationBytes, offset + 16);
        const uint8_t kind = navigationBytes[offset + 20];
        const uint8_t flags = navigationBytes[offset + 21];
        facet.mergeLeaderOffset = static_cast<uint16_t>(navigationBytes[offset + 22])
            | (static_cast<uint16_t>(navigationBytes[offset + 23]) << 8);

        if (facet.bModelIndex >= outdoorMapData.bmodels.size()
            || facet.faceIndex >= outdoorMapData.bmodels[facet.bModelIndex].faces.size())
        {
            errorMessage = "outdoor navigation facet references geometry out of range";
            return std::nullopt;
        }

        const uint64_t expectedSourceKey =
            (static_cast<uint64_t>(facet.bModelIndex) << 32) | facet.faceIndex;

        if (facet.sourceKey != expectedSourceKey
            || (facetIndex > 0 && facet.sourceKey <= previousSourceKey))
        {
            errorMessage = "outdoor navigation facet source identities are invalid or not ordered";
            return std::nullopt;
        }

        previousSourceKey = facet.sourceKey;

        if ((kind != static_cast<uint8_t>(OutdoorNavigationFacetKind::Floor)
                && kind != static_cast<uint8_t>(OutdoorNavigationFacetKind::Barrier))
            || (flags & ~NavigationKnownFlags) != 0)
        {
            errorMessage = "outdoor navigation facet has unsupported flags";
            return std::nullopt;
        }

        facet.kind = static_cast<OutdoorNavigationFacetKind>(kind);
        facet.walkable = (flags & NavigationFlagWalkable) != 0;
        facet.blocking = (flags & NavigationFlagBlocking) != 0;
        facet.dynamic = (flags & NavigationFlagDynamic) != 0;

        if ((facet.kind == OutdoorNavigationFacetKind::Floor) != facet.walkable
            || (facet.kind == OutdoorNavigationFacetKind::Barrier) != facet.blocking
            || (facet.dynamic && facet.mechanismId == 0)
            || (!facet.dynamic && facet.mechanismId != 0))
        {
            errorMessage = "outdoor navigation facet semantics are inconsistent";
            return std::nullopt;
        }

        if (facet.mechanismId != mechanismIdByBModel[facet.bModelIndex])
        {
            errorMessage = "outdoor navigation mechanism ownership does not match scene data";
            return std::nullopt;
        }

        result.facets.push_back(facet);
    }

    for (size_t facetIndex = 0; facetIndex < result.facets.size(); ++facetIndex)
    {
        OutdoorNavigationFacetReference &facet = result.facets[facetIndex];
        facet.pathSourceId = static_cast<int32_t>(facetIndex);

        if (facet.mergeLeaderOffset == 0)
        {
            continue;
        }

        if (facet.mergeLeaderOffset > facetIndex)
        {
            errorMessage = "outdoor navigation merge leader is out of range";
            return std::nullopt;
        }

        const size_t leaderIndex = facetIndex - facet.mergeLeaderOffset;
        const OutdoorNavigationFacetReference &leader = result.facets[leaderIndex];

        if (leader.mergeLeaderOffset != 0
            || leader.kind != OutdoorNavigationFacetKind::Floor
            || facet.kind != OutdoorNavigationFacetKind::Floor
            || leader.dynamic
            || facet.dynamic)
        {
            errorMessage = "outdoor navigation merge group semantics are inconsistent";
            return std::nullopt;
        }

        facet.pathSourceId = static_cast<int32_t>(leaderIndex);
    }

    return result;
}
}
