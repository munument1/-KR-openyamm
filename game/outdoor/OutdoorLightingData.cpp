#include "game/outdoor/OutdoorLightingData.h"

#include "game/outdoor/OutdoorMapData.h"

#include <algorithm>
#include <array>
#include <cstring>
#include <limits>

namespace OpenYAMM::Game
{
namespace
{
constexpr std::array<uint8_t, 8> LightingMagic = {'O', 'Y', 'M', 'L', 'I', 'T', '1', 0};
constexpr uint32_t LightingFormatVersion = 1;
constexpr uint32_t LightingHeaderSize = 96;
constexpr uint32_t PageRecordSize = 16;
constexpr uint32_t FaceRecordSize = 24;
constexpr uint32_t VertexRecordSize = 12;
constexpr uint32_t LightRecordSize = 80;
constexpr uint16_t FaceHasLightmap = 0x01;
constexpr uint16_t FaceKnownFlags = FaceHasLightmap;
constexpr uint32_t LightKnownFlags = 0x1f;

uint16_t readU16(const std::vector<uint8_t> &bytes, size_t offset)
{
    return static_cast<uint16_t>(bytes[offset]) | (static_cast<uint16_t>(bytes[offset + 1]) << 8);
}

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

float readFloat(const std::vector<uint8_t> &bytes, size_t offset)
{
    const uint32_t bits = readU32(bytes, offset);
    float value = 0.0f;
    std::memcpy(&value, &bits, sizeof(value));
    return value;
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

size_t outdoorFaceVertexCount(const OutdoorMapData &outdoorMapData)
{
    size_t result = 0;

    for (const OutdoorBModel &bModel : outdoorMapData.bmodels)
    {
        for (const OutdoorBModelFace &face : bModel.faces)
        {
            result += face.vertexIndices.size();
        }
    }

    return result;
}
}

bool OutdoorAuthoredLight::lightsObjects() const
{
    return (flags & 0x01) != 0;
}

bool OutdoorAuthoredLight::lightsFastObjects() const
{
    return (flags & 0x02) != 0;
}

bool OutdoorAuthoredLight::staticObjectLightEligible() const
{
    return (flags & 0x04) != 0;
}

std::optional<OutdoorLightingData> OutdoorLightingDataLoader::loadFromBytes(
    const std::vector<uint8_t> &lightingBytes,
    const std::vector<uint8_t> &geometryBytes,
    const OutdoorMapData &outdoorMapData,
    std::string &errorMessage) const
{
    if (lightingBytes.size() < LightingHeaderSize
        || !std::equal(LightingMagic.begin(), LightingMagic.end(), lightingBytes.begin()))
    {
        errorMessage = "invalid outdoor lighting data magic or truncated header";
        return std::nullopt;
    }

    const uint32_t version = readU32(lightingBytes, 8);
    const uint32_t headerSize = readU32(lightingBytes, 12);
    const uint64_t geometryHash = readU64(lightingBytes, 16);
    const uint32_t sourceBModelCount = readU32(lightingBytes, 24);
    const uint32_t sourceFaceCount = readU32(lightingBytes, 28);
    const uint32_t pageCount = readU32(lightingBytes, 32);
    const uint32_t faceCount = readU32(lightingBytes, 36);
    const uint32_t vertexCount = readU32(lightingBytes, 40);
    const uint32_t lightCount = readU32(lightingBytes, 44);
    const uint32_t pageRecordsOffset = readU32(lightingBytes, 48);
    const uint32_t faceRecordsOffset = readU32(lightingBytes, 52);
    const uint32_t vertexRecordsOffset = readU32(lightingBytes, 56);
    const uint32_t lightRecordsOffset = readU32(lightingBytes, 60);
    const uint32_t pixelDataOffset = readU32(lightingBytes, 64);
    const uint32_t fileSize = readU32(lightingBytes, 68);
    const uint32_t ambientColorAbgr = readU32(lightingBytes, 72);

    if (version != LightingFormatVersion || headerSize != LightingHeaderSize || fileSize != lightingBytes.size())
    {
        errorMessage = "unsupported outdoor lighting data header";
        return std::nullopt;
    }

    const uint64_t expectedFaceOffset = static_cast<uint64_t>(headerSize)
        + static_cast<uint64_t>(pageCount) * PageRecordSize;
    const uint64_t expectedVertexOffset = expectedFaceOffset + static_cast<uint64_t>(faceCount) * FaceRecordSize;
    const uint64_t expectedLightOffset = expectedVertexOffset + static_cast<uint64_t>(vertexCount) * VertexRecordSize;
    const uint64_t expectedPixelOffset = expectedLightOffset + static_cast<uint64_t>(lightCount) * LightRecordSize;

    if (pageRecordsOffset != headerSize
        || faceRecordsOffset != expectedFaceOffset
        || vertexRecordsOffset != expectedVertexOffset
        || lightRecordsOffset != expectedLightOffset
        || pixelDataOffset != expectedPixelOffset
        || expectedPixelOffset > lightingBytes.size())
    {
        errorMessage = "outdoor lighting data section offsets are invalid";
        return std::nullopt;
    }

    if (geometryHash != fnv1a64(geometryBytes))
    {
        errorMessage = "outdoor lighting data was cooked for different geometry";
        return std::nullopt;
    }

    if (sourceBModelCount != outdoorMapData.bmodels.size()
        || sourceFaceCount != outdoorFaceCount(outdoorMapData)
        || faceCount != sourceFaceCount
        || vertexCount != outdoorFaceVertexCount(outdoorMapData))
    {
        errorMessage = "outdoor lighting data source counts do not match geometry";
        return std::nullopt;
    }

    OutdoorLightingData result = {};
    result.formatVersion = version;
    result.geometryHash = geometryHash;
    result.ambientColorAbgr = ambientColorAbgr;
    result.atlasPages.reserve(pageCount);
    uint64_t expectedPagePixelOffset = pixelDataOffset;

    for (size_t pageIndex = 0; pageIndex < pageCount; ++pageIndex)
    {
        const size_t recordOffset = pageRecordsOffset + pageIndex * PageRecordSize;
        OutdoorLightmapAtlasPage page = {};
        page.width = readU32(lightingBytes, recordOffset);
        page.height = readU32(lightingBytes, recordOffset + 4);
        const uint32_t pagePixelOffset = readU32(lightingBytes, recordOffset + 8);
        const uint32_t pagePixelBytes = readU32(lightingBytes, recordOffset + 12);
        const uint64_t expectedPixelBytes = static_cast<uint64_t>(page.width) * page.height * sizeof(uint32_t);

        if (page.width == 0
            || page.height == 0
            || pagePixelOffset != expectedPagePixelOffset
            || pagePixelBytes != expectedPixelBytes
            || expectedPagePixelOffset + expectedPixelBytes > lightingBytes.size())
        {
            errorMessage = "outdoor lighting atlas page is invalid";
            return std::nullopt;
        }

        const size_t pixelCount = static_cast<size_t>(page.width) * page.height;
        page.pixelsBgra.reserve(pixelCount);
        for (size_t pixelIndex = 0; pixelIndex < pixelCount; ++pixelIndex)
        {
            page.pixelsBgra.push_back(readU32(lightingBytes, pagePixelOffset + pixelIndex * sizeof(uint32_t)));
        }
        expectedPagePixelOffset += expectedPixelBytes;
        result.atlasPages.push_back(std::move(page));
    }

    if (expectedPagePixelOffset != lightingBytes.size())
    {
        errorMessage = "outdoor lighting atlas payload does not consume the file";
        return std::nullopt;
    }

    result.facesByBModel.resize(outdoorMapData.bmodels.size());
    size_t faceRecordIndex = 0;
    size_t expectedVertexIndex = 0;

    for (size_t bModelIndex = 0; bModelIndex < outdoorMapData.bmodels.size(); ++bModelIndex)
    {
        const OutdoorBModel &bModel = outdoorMapData.bmodels[bModelIndex];
        std::vector<OutdoorBModelFaceLighting> &faceLighting = result.facesByBModel[bModelIndex];
        faceLighting.reserve(bModel.faces.size());

        for (size_t faceIndex = 0; faceIndex < bModel.faces.size(); ++faceIndex, ++faceRecordIndex)
        {
            const size_t recordOffset = faceRecordsOffset + faceRecordIndex * FaceRecordSize;
            const uint64_t sourceKey = readU64(lightingBytes, recordOffset);
            const uint32_t storedBModelIndex = readU32(lightingBytes, recordOffset + 8);
            const uint32_t storedFaceIndex = readU32(lightingBytes, recordOffset + 12);
            const uint16_t atlasPageIndex = readU16(lightingBytes, recordOffset + 16);
            const uint16_t flags = readU16(lightingBytes, recordOffset + 18);
            const uint32_t firstVertexIndex = readU32(lightingBytes, recordOffset + 20);
            const uint64_t expectedSourceKey = (static_cast<uint64_t>(bModelIndex) << 32) | faceIndex;
            const bool hasLightmap = (flags & FaceHasLightmap) != 0;

            if (sourceKey != expectedSourceKey
                || storedBModelIndex != bModelIndex
                || storedFaceIndex != faceIndex
                || firstVertexIndex != expectedVertexIndex
                || (flags & ~FaceKnownFlags) != 0
                || (atlasPageIndex != 0xffff && atlasPageIndex >= result.atlasPages.size())
                || (hasLightmap && atlasPageIndex == 0xffff))
            {
                errorMessage = "outdoor lighting face identity or atlas reference is invalid";
                return std::nullopt;
            }

            OutdoorBModelFaceLighting face = {};
            face.atlasPageIndex = atlasPageIndex;
            face.hasLightmap = hasLightmap;
            face.vertices.reserve(bModel.faces[faceIndex].vertexIndices.size());
            for (size_t localVertexIndex = 0;
                 localVertexIndex < bModel.faces[faceIndex].vertexIndices.size();
                 ++localVertexIndex, ++expectedVertexIndex)
            {
                const size_t vertexOffset = vertexRecordsOffset + expectedVertexIndex * VertexRecordSize;
                face.vertices.push_back({
                    readFloat(lightingBytes, vertexOffset),
                    readFloat(lightingBytes, vertexOffset + 4),
                    readU32(lightingBytes, vertexOffset + 8),
                });
            }
            faceLighting.push_back(std::move(face));
        }
    }

    result.authoredLights.reserve(lightCount);
    for (size_t lightIndex = 0; lightIndex < lightCount; ++lightIndex)
    {
        const size_t recordOffset = lightRecordsOffset + lightIndex * LightRecordSize;
        const uint32_t type = readU32(lightingBytes, recordOffset + 4);
        const uint32_t flags = readU32(lightingBytes, recordOffset + 28);
        const uint32_t reserved0 = readU32(lightingBytes, recordOffset + 68);
        const uint32_t reserved1 = readU32(lightingBytes, recordOffset + 72);
        const uint32_t reserved2 = readU32(lightingBytes, recordOffset + 76);

        if (type > static_cast<uint32_t>(OutdoorAuthoredLightType::Directional)
            || (flags & ~LightKnownFlags) != 0
            || reserved0 != 0
            || reserved1 != 0
            || reserved2 != 0)
        {
            errorMessage = "outdoor authored light record is invalid";
            return std::nullopt;
        }

        OutdoorAuthoredLight light = {};
        light.sourceObjectIndex = readU32(lightingBytes, recordOffset);
        light.type = static_cast<OutdoorAuthoredLightType>(type);
        light.position = {
            readFloat(lightingBytes, recordOffset + 8),
            readFloat(lightingBytes, recordOffset + 12),
            readFloat(lightingBytes, recordOffset + 16),
        };
        light.radius = readFloat(lightingBytes, recordOffset + 20);
        light.effectiveColorAbgr = readU32(lightingBytes, recordOffset + 24);
        light.flags = flags;
        light.sourceRotationLt = {
            readFloat(lightingBytes, recordOffset + 32),
            readFloat(lightingBytes, recordOffset + 36),
            readFloat(lightingBytes, recordOffset + 40),
            readFloat(lightingBytes, recordOffset + 44),
        };
        light.fovDegrees = readFloat(lightingBytes, recordOffset + 48);
        light.brightnessScale = readFloat(lightingBytes, recordOffset + 52);
        light.objectBrightnessScale = readFloat(lightingBytes, recordOffset + 56);
        light.sourceColorAbgr = readU32(lightingBytes, recordOffset + 60);
        light.lightGroupCrc32 = readU32(lightingBytes, recordOffset + 64);
        result.authoredLights.push_back(light);
    }

    return result;
}
}
