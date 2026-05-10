#include "doctest/doctest.h"

#include "game/FaceEnums.h"
#include "game/indoor/IndoorPathfindingBuilder.h"

#include <cmath>
#include <utility>
#include <vector>

using OpenYAMM::Game::FaceAttribute;
using OpenYAMM::Game::IndoorFace;
using OpenYAMM::Game::IndoorFaceGeometryCache;
using OpenYAMM::Game::IndoorMapData;
using OpenYAMM::Game::IndoorPathMapBuildResult;
using OpenYAMM::Game::IndoorPathfindingBuilder;
using OpenYAMM::Game::IndoorVertex;
using OpenYAMM::Game::MapDeltaData;
using OpenYAMM::Game::PathObject;
using OpenYAMM::Game::faceAttributeBit;

namespace
{
IndoorFace makeIndoorFace(std::vector<uint16_t> vertexIndices, uint8_t facetType, uint32_t attributes = 0)
{
    IndoorFace face = {};
    face.vertexIndices = std::move(vertexIndices);
    face.facetType = facetType;
    face.attributes = attributes;
    face.roomNumber = 0;
    face.roomBehindNumber = 0;
    face.isPortal = (attributes & faceAttributeBit(FaceAttribute::IsPortal)) != 0;
    return face;
}

PathObject makeIndoorPathObject()
{
    PathObject object = {};
    object.radius = 8.0f;
    object.stepLength = 24.0f;
    object.stepHeight = 40.0f;
    return object;
}
}

TEST_CASE("indoor pathfinding builder converts BLV faces into walkable and blocking path facets")
{
    IndoorMapData mapData = {};
    mapData.vertices = {
        {-100, -100, 0},
        {100, -100, 0},
        {100, 100, 0},
        {-100, 100, 0},
        {0, -40, 0},
        {0, 40, 0},
        {0, 40, 120},
        {0, -40, 120}
    };
    mapData.faces = {
        makeIndoorFace({0, 1, 2, 3}, 3),
        makeIndoorFace({4, 5, 6, 7}, 1)
    };

    IndoorFaceGeometryCache geometryCache(mapData.faces.size());
    const IndoorPathMapBuildResult result =
        IndoorPathfindingBuilder::buildPathMap(mapData, mapData.vertices, nullptr, &geometryCache);

    REQUIRE_EQ(result.sourceFaceCount, 2u);
    REQUIRE_EQ(result.pathFacetCount, 2u);
    REQUIRE_EQ(result.skippedFaceCount, 0u);
    CHECK(result.pathMap.floorAt({-50.0f, 0.0f, 20.0f}).hasFloor);
    CHECK_FALSE(
        result.pathMap.canReachDirectly(
            {-50.0f, 0.0f, 0.0f},
            {50.0f, 0.0f, 0.0f},
            makeIndoorPathObject()));
}

TEST_CASE("indoor pathfinding builder keeps portals non-blocking")
{
    IndoorMapData mapData = {};
    mapData.vertices = {
        {-100, -100, 0},
        {100, -100, 0},
        {100, 100, 0},
        {-100, 100, 0},
        {0, -40, 0},
        {0, 40, 0},
        {0, 40, 120},
        {0, -40, 120}
    };
    mapData.faces = {
        makeIndoorFace({0, 1, 2, 3}, 3),
        makeIndoorFace({4, 5, 6, 7}, 1, faceAttributeBit(FaceAttribute::IsPortal))
    };

    const IndoorPathMapBuildResult result =
        IndoorPathfindingBuilder::buildPathMap(mapData, mapData.vertices);

    REQUIRE_EQ(result.pathFacetCount, 2u);
    CHECK(
        result.pathMap.canReachDirectly(
            {-50.0f, 0.0f, 0.0f},
            {50.0f, 0.0f, 0.0f},
            makeIndoorPathObject()));
}

TEST_CASE("indoor pathfinding builder applies map delta face attributes")
{
    IndoorMapData mapData = {};
    mapData.vertices = {
        {-100, -100, 0},
        {100, -100, 0},
        {100, 100, 0},
        {-100, 100, 0},
        {0, -40, 0},
        {0, 40, 0},
        {0, 40, 120},
        {0, -40, 120}
    };
    mapData.faces = {
        makeIndoorFace({0, 1, 2, 3}, 3),
        makeIndoorFace({4, 5, 6, 7}, 1)
    };

    MapDeltaData deltaData = {};
    deltaData.faceAttributes = {
        mapData.faces[0].attributes,
        faceAttributeBit(FaceAttribute::Untouchable)
    };

    IndoorFaceGeometryCache geometryCache(mapData.faces.size());
    const IndoorPathMapBuildResult result =
        IndoorPathfindingBuilder::buildPathMap(mapData, mapData.vertices, &deltaData, &geometryCache);

    REQUIRE_EQ(result.pathFacetCount, 2u);
    CHECK(
        result.pathMap.canReachDirectly(
            {-50.0f, 0.0f, 0.0f},
            {50.0f, 0.0f, 0.0f},
            makeIndoorPathObject()));
}
