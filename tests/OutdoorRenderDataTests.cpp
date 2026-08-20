#include "doctest/doctest.h"

#include "game/outdoor/OutdoorMapData.h"
#include "game/outdoor/OutdoorRenderData.h"

#include <array>
#include <cstdint>
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

std::vector<uint8_t> makeRenderBytes(
    const std::vector<uint8_t> &geometryBytes,
    uint32_t bModelIndex = 0,
    uint32_t faceIndex = 0,
    bool dynamic = true,
    bool translucent = false)
{
    const std::array<uint8_t, 8> magic = {'O', 'Y', 'M', 'R', 'E', 'N', '1', 0};
    std::vector<uint8_t> result(magic.begin(), magic.end());
    appendU32(result, 1);
    appendU32(result, 48);
    appendU32(result, 24);
    appendU32(result, 4096);
    appendU64(result, fnv1a64(geometryBytes));
    appendU32(result, 1);
    appendU32(result, 1);
    appendU32(result, 1);
    appendU32(result, 0);
    appendU64(result, (static_cast<uint64_t>(bModelIndex) << 32) | faceIndex);
    appendU32(result, bModelIndex);
    appendU32(result, faceIndex);
    appendU16(result, static_cast<uint16_t>(-3));
    appendU16(result, 7);
    appendU32(result, (dynamic ? 1u : 0u) | (translucent ? 2u : 0u));
    return result;
}

OpenYAMM::Game::OutdoorMapData makeMapData()
{
    OpenYAMM::Game::OutdoorMapData mapData = {};
    mapData.bmodels.resize(1);
    mapData.bmodels[0].faces.resize(1);
    OpenYAMM::Game::OutdoorBModelMechanism mechanism = {};
    mechanism.mechanismId = 1;
    mechanism.motionKind = OpenYAMM::Game::OutdoorBModelMechanismMotionKind::Linear;
    mechanism.hasBModelBinding = true;
    mechanism.bmodelIndex = 0;
    mapData.mechanisms.push_back(mechanism);
    return mapData;
}

TEST_CASE("outdoor render data keeps audit-only mechanisms static")
{
    const std::vector<uint8_t> geometryBytes = {2, 4, 6, 8};
    OpenYAMM::Game::OutdoorMapData mapData = makeMapData();
    mapData.mechanisms[0].motionKind = OpenYAMM::Game::OutdoorBModelMechanismMotionKind::None;
    OpenYAMM::Game::OutdoorRenderDataLoader loader = {};
    std::string errorMessage;

    const std::optional<OpenYAMM::Game::OutdoorRenderData> renderData =
        loader.loadFromBytes(makeRenderBytes(geometryBytes, 0, 0, false), geometryBytes, mapData, errorMessage);

    REQUIRE_MESSAGE(renderData.has_value(), errorMessage);
    CHECK_FALSE(renderData->faces[0].dynamic);
}
}

TEST_CASE("outdoor render data loader validates cooked cells and exact source references")
{
    const std::vector<uint8_t> geometryBytes = {2, 4, 6, 8};
    const OpenYAMM::Game::OutdoorMapData mapData = makeMapData();
    OpenYAMM::Game::OutdoorRenderDataLoader loader = {};
    std::string errorMessage;

    const std::optional<OpenYAMM::Game::OutdoorRenderData> renderData =
        loader.loadFromBytes(makeRenderBytes(geometryBytes), geometryBytes, mapData, errorMessage);

    REQUIRE_MESSAGE(renderData.has_value(), errorMessage);
    REQUIRE_EQ(renderData->faces.size(), 1);
    CHECK_EQ(renderData->cellSize, 4096);
    CHECK_EQ(renderData->faces[0].cellX, -3);
    CHECK_EQ(renderData->faces[0].cellY, 7);
    CHECK(renderData->faces[0].dynamic);
    CHECK_FALSE(renderData->faces[0].translucent);
}

TEST_CASE("outdoor render data preserves explicit translucent face classification")
{
    const std::vector<uint8_t> geometryBytes = {2, 4, 6, 8};
    const OpenYAMM::Game::OutdoorMapData mapData = makeMapData();
    OpenYAMM::Game::OutdoorRenderDataLoader loader = {};
    std::string errorMessage;

    const std::optional<OpenYAMM::Game::OutdoorRenderData> renderData = loader.loadFromBytes(
        makeRenderBytes(geometryBytes, 0, 0, true, true),
        geometryBytes,
        mapData,
        errorMessage);

    REQUIRE_MESSAGE(renderData.has_value(), errorMessage);
    CHECK(renderData->faces[0].dynamic);
    CHECK(renderData->faces[0].translucent);
}

TEST_CASE("outdoor render data loader rejects stale or out-of-range sidecars")
{
    const std::vector<uint8_t> geometryBytes = {2, 4, 6, 8};
    const OpenYAMM::Game::OutdoorMapData mapData = makeMapData();
    OpenYAMM::Game::OutdoorRenderDataLoader loader = {};
    std::string errorMessage;

    CHECK_FALSE(loader.loadFromBytes(makeRenderBytes(geometryBytes), {1}, mapData, errorMessage));
    CHECK(errorMessage.find("different geometry") != std::string::npos);

    errorMessage.clear();
    CHECK_FALSE(loader.loadFromBytes(
        makeRenderBytes(geometryBytes, 0, 1),
        geometryBytes,
        mapData,
        errorMessage));
    CHECK(errorMessage.find("out of range") != std::string::npos);
}
