#include "doctest/doctest.h"

#include "game/outdoor/OutdoorMapData.h"
#include "game/outdoor/OutdoorNavigationData.h"

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

void appendU32(std::vector<uint8_t> &bytes, uint32_t value)
{
    bytes.push_back(static_cast<uint8_t>(value));
    bytes.push_back(static_cast<uint8_t>(value >> 8));
    bytes.push_back(static_cast<uint8_t>(value >> 16));
    bytes.push_back(static_cast<uint8_t>(value >> 24));
}

void appendU64(std::vector<uint8_t> &bytes, uint64_t value)
{
    appendU32(bytes, static_cast<uint32_t>(value));
    appendU32(bytes, static_cast<uint32_t>(value >> 32));
}

std::vector<uint8_t> makeNavigationBytes(
    const std::vector<uint8_t> &geometryBytes,
    uint32_t bModelIndex = 0,
    uint32_t faceIndex = 0)
{
    const std::array<uint8_t, 8> magic = {'O', 'Y', 'M', 'N', 'A', 'V', '1', 0};
    std::vector<uint8_t> result(magic.begin(), magic.end());
    appendU32(result, 1);
    appendU32(result, 48);
    appendU32(result, 24);
    appendU32(result, 0);
    appendU64(result, fnv1a64(geometryBytes));
    appendU32(result, 1);
    appendU32(result, 1);
    appendU32(result, 1);
    appendU32(result, 0);
    appendU64(result, (static_cast<uint64_t>(bModelIndex) << 32) | faceIndex);
    appendU32(result, bModelIndex);
    appendU32(result, faceIndex);
    appendU32(result, 0);
    result.push_back(1);
    result.push_back(1);
    result.push_back(0);
    result.push_back(0);
    return result;
}

OpenYAMM::Game::OutdoorMapData makeMapData()
{
    OpenYAMM::Game::OutdoorMapData mapData = {};
    mapData.bmodels.resize(1);
    mapData.bmodels[0].faces.resize(1);
    return mapData;
}
}

TEST_CASE("outdoor navigation loader validates geometry identity and exact source references")
{
    const std::vector<uint8_t> geometryBytes = {1, 3, 3, 7};
    const OpenYAMM::Game::OutdoorMapData mapData = makeMapData();
    const std::vector<uint8_t> navigationBytes = makeNavigationBytes(geometryBytes);
    OpenYAMM::Game::OutdoorNavigationDataLoader loader = {};
    std::string errorMessage;

    const std::optional<OpenYAMM::Game::OutdoorNavigationData> navigation =
        loader.loadFromBytes(navigationBytes, geometryBytes, mapData, errorMessage);

    REQUIRE_MESSAGE(navigation.has_value(), errorMessage);
    REQUIRE_EQ(navigation->facets.size(), 1);
    CHECK_EQ(navigation->facets[0].sourceKey, 0);
    CHECK(navigation->facets[0].walkable);
    CHECK_FALSE(navigation->facets[0].blocking);
}

TEST_CASE("outdoor navigation loader rejects stale or out-of-range sidecars")
{
    const std::vector<uint8_t> geometryBytes = {1, 3, 3, 7};
    const OpenYAMM::Game::OutdoorMapData mapData = makeMapData();
    OpenYAMM::Game::OutdoorNavigationDataLoader loader = {};
    std::string errorMessage;

    CHECK_FALSE(loader.loadFromBytes(
        makeNavigationBytes(geometryBytes),
        {9, 9, 9},
        mapData,
        errorMessage));
    CHECK(errorMessage.find("different geometry") != std::string::npos);

    errorMessage.clear();
    CHECK_FALSE(loader.loadFromBytes(
        makeNavigationBytes(geometryBytes, 0, 1),
        geometryBytes,
        mapData,
        errorMessage));
    CHECK(errorMessage.find("out of range") != std::string::npos);
}
