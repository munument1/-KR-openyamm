#include "doctest/doctest.h"

#include "game/outdoor/OutdoorLightingData.h"
#include "game/outdoor/OutdoorMapData.h"

#include <array>
#include <cstdint>
#include <cstring>
#include <string>
#include <vector>

namespace
{
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

void appendU16(std::vector<uint8_t> &bytes, uint16_t value)
{
    bytes.push_back(static_cast<uint8_t>(value));
    bytes.push_back(static_cast<uint8_t>(value >> 8));
}

void appendU32(std::vector<uint8_t> &bytes, uint32_t value)
{
    appendU16(bytes, static_cast<uint16_t>(value));
    appendU16(bytes, static_cast<uint16_t>(value >> 16));
}

void appendU64(std::vector<uint8_t> &bytes, uint64_t value)
{
    appendU32(bytes, static_cast<uint32_t>(value));
    appendU32(bytes, static_cast<uint32_t>(value >> 32));
}

void appendFloat(std::vector<uint8_t> &bytes, float value)
{
    uint32_t bits = 0;
    std::memcpy(&bits, &value, sizeof(bits));
    appendU32(bytes, bits);
}

OpenYAMM::Game::OutdoorMapData makeMapData()
{
    OpenYAMM::Game::OutdoorMapData mapData = {};
    mapData.bmodels.resize(1);
    mapData.bmodels[0].faces.resize(1);
    mapData.bmodels[0].faces[0].vertexIndices = {0, 1, 2};
    return mapData;
}

std::vector<uint8_t> makeLightingBytes(const std::vector<uint8_t> &geometryBytes)
{
    constexpr uint32_t PageOffset = 96;
    constexpr uint32_t FaceOffset = 112;
    constexpr uint32_t VertexOffset = 136;
    constexpr uint32_t LightOffset = 172;
    constexpr uint32_t PixelOffset = 252;
    constexpr uint32_t FileSize = 256;
    const std::array<uint8_t, 8> magic = {'O', 'Y', 'M', 'L', 'I', 'T', '1', 0};
    std::vector<uint8_t> result(magic.begin(), magic.end());
    appendU32(result, 1);
    appendU32(result, 96);
    appendU64(result, fnv1a64(geometryBytes));
    appendU32(result, 1);
    appendU32(result, 1);
    appendU32(result, 1);
    appendU32(result, 1);
    appendU32(result, 3);
    appendU32(result, 1);
    appendU32(result, PageOffset);
    appendU32(result, FaceOffset);
    appendU32(result, VertexOffset);
    appendU32(result, LightOffset);
    appendU32(result, PixelOffset);
    appendU32(result, FileSize);
    appendU32(result, 0xff302010);
    result.resize(PageOffset, 0);

    appendU32(result, 1);
    appendU32(result, 1);
    appendU32(result, PixelOffset);
    appendU32(result, 4);

    appendU64(result, 0);
    appendU32(result, 0);
    appendU32(result, 0);
    appendU16(result, 0);
    appendU16(result, 1);
    appendU32(result, 0);

    for (size_t index = 0; index < 3; ++index)
    {
        appendFloat(result, 0.25f * static_cast<float>(index));
        appendFloat(result, 0.5f);
        appendU32(result, 0xffffffff);
    }

    appendU32(result, 42);
    appendU32(result, 1);
    appendFloat(result, 10.0f);
    appendFloat(result, 20.0f);
    appendFloat(result, 30.0f);
    appendFloat(result, 400.0f);
    appendU32(result, 0xff604020);
    appendU32(result, 0x23);
    for (size_t index = 0; index < 4; ++index)
    {
        appendFloat(result, index == 3 ? 1.0f : 0.0f);
    }
    appendFloat(result, 90.0f);
    appendFloat(result, 0.75f);
    appendFloat(result, 0.5f);
    appendU32(result, 0xffc08040);
    appendU32(result, 1234);
    appendU32(result, 0);
    appendU32(result, 0);
    appendU32(result, 0);
    appendU32(result, 0xffc0a080);
    return result;
}
}

TEST_CASE("outdoor lighting data loader validates atlas faces and authored lights")
{
    const std::vector<uint8_t> geometryBytes = {3, 1, 4, 1, 5};
    const OpenYAMM::Game::OutdoorMapData mapData = makeMapData();
    OpenYAMM::Game::OutdoorLightingDataLoader loader = {};
    std::string errorMessage;

    const std::optional<OpenYAMM::Game::OutdoorLightingData> lighting =
        loader.loadFromBytes(makeLightingBytes(geometryBytes), geometryBytes, mapData, errorMessage);

    REQUIRE_MESSAGE(lighting.has_value(), errorMessage);
    REQUIRE_EQ(lighting->atlasPages.size(), 1);
    CHECK_EQ(lighting->atlasPages[0].pixelsBgra[0], 0xffc0a080);
    REQUIRE_EQ(lighting->facesByBModel[0][0].vertices.size(), 3);
    CHECK(lighting->facesByBModel[0][0].hasLightmap);
    CHECK_EQ(lighting->facesByBModel[0][0].atlasPageIndex, 0);
    REQUIRE_EQ(lighting->authoredLights.size(), 1);
    CHECK_EQ(lighting->authoredLights[0].sourceObjectIndex, 42);
    CHECK(lighting->authoredLights[0].lightsObjects());
    CHECK(lighting->authoredLights[0].lightsFastObjects());
    CHECK_FALSE(lighting->authoredLights[0].staticObjectLightEligible());
    CHECK(lighting->authoredLights[0].globalObjectLight());
}

TEST_CASE("outdoor lighting data loader rejects stale geometry")
{
    const std::vector<uint8_t> geometryBytes = {3, 1, 4, 1, 5};
    const OpenYAMM::Game::OutdoorMapData mapData = makeMapData();
    OpenYAMM::Game::OutdoorLightingDataLoader loader = {};
    std::string errorMessage;

    CHECK_FALSE(loader.loadFromBytes(makeLightingBytes(geometryBytes), {1}, mapData, errorMessage));
    CHECK(errorMessage.find("different geometry") != std::string::npos);
}

TEST_CASE("outdoor lighting brightness scaling raises lightmap and fallback RGB and preserves alpha")
{
    OpenYAMM::Game::OutdoorLightingData lighting = {};
    lighting.atlasPages.push_back({2, 1, {0xffc0a080, 0x80f0e0d0}});
    lighting.facesByBModel.resize(1);
    lighting.facesByBModel[0].resize(2);
    lighting.facesByBModel[0][0].hasLightmap = false;
    lighting.facesByBModel[0][0].vertices.push_back({0.5f, 0.5f, 0xff806040});
    lighting.facesByBModel[0][1].hasLightmap = true;
    lighting.facesByBModel[0][1].vertices.push_back({0.5f, 0.5f, 0xff604020});

    OpenYAMM::Game::scaleOutdoorLightingBrightness(lighting, 1.25f);

    REQUIRE_EQ(lighting.atlasPages.size(), 1);
    REQUIRE_EQ(lighting.atlasPages[0].pixelsBgra.size(), 2);
    CHECK_EQ(lighting.atlasPages[0].pixelsBgra[0], 0xfff0c8a0);
    CHECK_EQ(lighting.atlasPages[0].pixelsBgra[1], 0x80ffffff);
    REQUIRE_EQ(lighting.facesByBModel[0][0].vertices.size(), 1);
    CHECK_EQ(lighting.facesByBModel[0][0].vertices[0].staticColorAbgr, 0xffa07850);
    REQUIRE_EQ(lighting.facesByBModel[0][1].vertices.size(), 1);
    CHECK_EQ(lighting.facesByBModel[0][1].vertices[0].staticColorAbgr, 0xff604020);
}
