#include "doctest/doctest.h"

#include "game/FaceEnums.h"
#include "game/maps/MapDeltaData.h"
#include "game/outdoor/OutdoorMovementController.h"
#include "game/outdoor/OutdoorPathfindingBuilder.h"
#include "game/pathfinding/PathPlanner.h"
#include "tests/RegressionMapLoader.h"

#include <cmath>
#include <cstddef>
#include <optional>
#include <vector>

using OpenYAMM::Game::FaceAttribute;
using OpenYAMM::Game::MapDeltaData;
using OpenYAMM::Game::OutdoorBModel;
using OpenYAMM::Game::OutdoorBModelFace;
using OpenYAMM::Game::OutdoorMapData;
using OpenYAMM::Game::OutdoorMovementController;
using OpenYAMM::Game::OutdoorPathMapBuildOptions;
using OpenYAMM::Game::OutdoorPathMapBuildResult;
using OpenYAMM::Game::OutdoorPathTerrainMode;
using OpenYAMM::Game::OutdoorPathfindingBuilder;
using OpenYAMM::Game::OutdoorSupportKind;
using OpenYAMM::Game::PathFacetKind;
using OpenYAMM::Game::PathFloorSample;
using OpenYAMM::Game::PathObject;
using OpenYAMM::Game::PathPlanRequest;
using OpenYAMM::Game::PathPlanResult;
using OpenYAMM::Game::PathPlanStatus;
using OpenYAMM::Game::PathPlanner;
using OpenYAMM::Game::PathPoint;
using OpenYAMM::Tests::regressionMapLoader;
using OpenYAMM::Tests::regressionMapLoaderFailure;
using OpenYAMM::Tests::regressionMapLoaderLoaded;
using OpenYAMM::Game::faceAttributeBit;
using OpenYAMM::Game::outdoorGridCornerWorldX;
using OpenYAMM::Game::outdoorGridCornerWorldY;
using OpenYAMM::Game::sampleOutdoorRenderedTerrainHeight;

namespace
{
constexpr uint8_t OutdoorPolygonWall = 0x1;
constexpr uint8_t OutdoorPolygonFloor = 0x3;
constexpr uint8_t OutdoorPolygonInBetweenFloorAndWall = 0x4;
constexpr uint8_t OutdoorTerrainWater = 0x02;

size_t terrainSampleIndex(size_t gridX, size_t gridY)
{
    return gridY * static_cast<size_t>(OutdoorMapData::TerrainWidth) + gridX;
}

OutdoorMapData makeOutdoorMapWithTerrain()
{
    OutdoorMapData mapData = {};
    mapData.heightMap.assign(
        static_cast<size_t>(OutdoorMapData::TerrainWidth) * static_cast<size_t>(OutdoorMapData::TerrainHeight),
        0);
    mapData.attributeMap.assign(mapData.heightMap.size(), 0);
    return mapData;
}

std::vector<uint8_t> makeOutdoorLandMask(uint8_t value = 1)
{
    return std::vector<uint8_t>(
        static_cast<size_t>(OutdoorMapData::TerrainWidth - 1)
            * static_cast<size_t>(OutdoorMapData::TerrainHeight - 1),
        value);
}

OutdoorBModelFace makeOutdoorFace(std::vector<uint16_t> vertexIndices, uint8_t polygonType, uint32_t attributes = 0)
{
    OutdoorBModelFace face = {};
    face.vertexIndices = std::move(vertexIndices);
    face.polygonType = polygonType;
    face.attributes = attributes;
    return face;
}

OutdoorBModel makePathTestBModel(uint32_t wallAttributes = 0)
{
    OutdoorBModel bModel = {};
    bModel.name = "path_test";
    bModel.vertices = {
        {-100, -100, 0},
        {100, -100, 0},
        {100, 100, 0},
        {-100, 100, 0},
        {0, -40, 0},
        {0, 40, 0},
        {0, 40, 120},
        {0, -40, 120}
    };
    bModel.faces = {
        makeOutdoorFace({0, 1, 2, 3}, OutdoorPolygonFloor),
        makeOutdoorFace({4, 5, 6, 7}, OutdoorPolygonWall, wallAttributes)
    };
    return bModel;
}

OutdoorBModel makeOutdoorPlannerBModel()
{
    OutdoorBModel bModel = {};
    bModel.name = "planner_test";
    bModel.vertices = {
        {-48, -120, 0},
        {192, -120, 0},
        {192, 120, 0},
        {-48, 120, 0},
        {72, -60, 0},
        {72, 60, 0},
        {72, 60, 120},
        {72, -60, 120}
    };
    bModel.faces = {
        makeOutdoorFace({0, 1, 2, 3}, OutdoorPolygonFloor),
        makeOutdoorFace({4, 5, 6, 7}, OutdoorPolygonWall)
    };
    return bModel;
}

OutdoorBModel makeOutdoorBridgeBModel(float centerX, float centerY, float z)
{
    OutdoorBModel bModel = {};
    bModel.name = "bridge_test";
    bModel.vertices = {
        {static_cast<int>(centerX - 192.0f), static_cast<int>(centerY - 192.0f), static_cast<int>(z)},
        {static_cast<int>(centerX + 192.0f), static_cast<int>(centerY - 192.0f), static_cast<int>(z)},
        {static_cast<int>(centerX + 192.0f), static_cast<int>(centerY + 192.0f), static_cast<int>(z)},
        {static_cast<int>(centerX - 192.0f), static_cast<int>(centerY + 192.0f), static_cast<int>(z)}
    };
    bModel.faces = {
        makeOutdoorFace({0, 1, 2, 3}, OutdoorPolygonFloor)
    };
    return bModel;
}

OutdoorBModel makeOutdoorBridgeRampToFlatBModel(float centerX, float centerY)
{
    OutdoorBModel bModel = {};
    bModel.name = "bridge_ramp_to_flat_test";
    bModel.vertices = {
        {static_cast<int>(centerX - 192.0f), static_cast<int>(centerY - 128.0f), 80},
        {static_cast<int>(centerX), static_cast<int>(centerY - 128.0f), 160},
        {static_cast<int>(centerX), static_cast<int>(centerY + 128.0f), 160},
        {static_cast<int>(centerX - 192.0f), static_cast<int>(centerY + 128.0f), 80},
        {static_cast<int>(centerX), static_cast<int>(centerY - 128.0f), 160},
        {static_cast<int>(centerX + 384.0f), static_cast<int>(centerY - 128.0f), 160},
        {static_cast<int>(centerX + 384.0f), static_cast<int>(centerY + 128.0f), 160},
        {static_cast<int>(centerX), static_cast<int>(centerY + 128.0f), 160}
    };
    bModel.faces = {
        makeOutdoorFace({0, 1, 2, 3}, OutdoorPolygonInBetweenFloorAndWall),
        makeOutdoorFace({4, 5, 6, 7}, OutdoorPolygonFloor)
    };
    return bModel;
}

float bridgeRampHeightAt(float seamX, float x)
{
    return 80.0f + ((x - (seamX - 192.0f)) / 192.0f) * 80.0f;
}

PathObject makeOutdoorPathObject()
{
    PathObject object = {};
    object.radius = 8.0f;
    object.stepLength = 24.0f;
    object.stepHeight = 48.0f;
    return object;
}

PathPlanRequest makeOutdoorPathRequest()
{
    PathPlanRequest request = {};
    request.object = makeOutdoorPathObject();
    request.nodeLimit = 8000;
    return request;
}
}

TEST_CASE("outdoor pathfinding builder materializes terrain triangles matching rendered terrain height")
{
    OutdoorMapData mapData = makeOutdoorMapWithTerrain();
    mapData.heightMap[terrainSampleIndex(64, 64)] = 1;
    mapData.heightMap[terrainSampleIndex(65, 64)] = 5;
    mapData.heightMap[terrainSampleIndex(64, 65)] = 9;
    mapData.heightMap[terrainSampleIndex(65, 65)] = 13;

    OutdoorPathMapBuildOptions options = {};
    options.includeBModels = false;
    const OutdoorPathMapBuildResult result =
        OutdoorPathfindingBuilder::buildPathMap(mapData, nullptr, nullptr, options);

    REQUIRE_EQ(
        result.terrainTriangleCount,
        static_cast<size_t>(OutdoorMapData::TerrainWidth - 1)
            * static_cast<size_t>(OutdoorMapData::TerrainHeight - 1) * 2);
    REQUIRE_EQ(result.pathFacetCount, result.terrainTriangleCount);

    const float firstTriangleX = outdoorGridCornerWorldX(64) + 128.0f;
    const float firstTriangleY = outdoorGridCornerWorldY(64) - 128.0f;
    const float firstExpectedHeight = sampleOutdoorRenderedTerrainHeight(mapData, firstTriangleX, firstTriangleY);
    const OpenYAMM::Game::PathFloorSample firstFloor =
        result.pathMap.floorAt({firstTriangleX, firstTriangleY, firstExpectedHeight + 256.0f});

    REQUIRE(firstFloor.hasFloor);
    CHECK_FALSE(firstFloor.inVoid);
    CHECK_GT(firstFloor.normalZ, 0.0f);
    CHECK(firstFloor.z == doctest::Approx(firstExpectedHeight));

    const float secondTriangleX = outdoorGridCornerWorldX(64) + 384.0f;
    const float secondTriangleY = outdoorGridCornerWorldY(64) - 384.0f;
    const float secondExpectedHeight = sampleOutdoorRenderedTerrainHeight(mapData, secondTriangleX, secondTriangleY);
    const OpenYAMM::Game::PathFloorSample secondFloor =
        result.pathMap.floorAt({secondTriangleX, secondTriangleY, secondExpectedHeight + 256.0f});

    REQUIRE(secondFloor.hasFloor);
    CHECK_FALSE(secondFloor.inVoid);
    CHECK_GT(secondFloor.normalZ, 0.0f);
    CHECK(secondFloor.z == doctest::Approx(secondExpectedHeight));
}

TEST_CASE("outdoor pathfinding builder can exclude water terrain from land-only maps")
{
    OutdoorMapData mapData = makeOutdoorMapWithTerrain();
    mapData.attributeMap[terrainSampleIndex(64, 64)] = OutdoorTerrainWater;

    OutdoorPathMapBuildOptions fullOptions = {};
    fullOptions.includeBModels = false;
    const OutdoorPathMapBuildResult fullResult =
        OutdoorPathfindingBuilder::buildPathMap(mapData, nullptr, nullptr, fullOptions);

    const float waterCellX = outdoorGridCornerWorldX(64) + 256.0f;
    const float waterCellY = outdoorGridCornerWorldY(64) - 256.0f;
    CHECK(fullResult.pathMap.floorAt({waterCellX, waterCellY, 256.0f}).hasFloor);

    OutdoorPathMapBuildOptions landOnlyOptions = {};
    landOnlyOptions.includeBModels = false;
    landOnlyOptions.terrainMode = OutdoorPathTerrainMode::LandOnly;
    const OutdoorPathMapBuildResult landOnlyResult =
        OutdoorPathfindingBuilder::buildPathMap(mapData, nullptr, nullptr, landOnlyOptions);

    CHECK_EQ(landOnlyResult.skippedWaterTerrainTriangleCount, 2u);
    CHECK_FALSE(landOnlyResult.pathMap.floorAt({waterCellX, waterCellY, 256.0f}).hasFloor);
}

TEST_CASE("outdoor pathfinding builder can route land actors around land-mask water")
{
    OutdoorMapData mapData = makeOutdoorMapWithTerrain();
    std::vector<uint8_t> landMask = makeOutdoorLandMask();
    constexpr size_t BarrierX = 64;

    for (size_t gridY = 62; gridY <= 66; ++gridY)
    {
        landMask[gridY * static_cast<size_t>(OutdoorMapData::TerrainWidth - 1) + BarrierX] = 0;
    }

    OutdoorPathMapBuildOptions fullOptions = {};
    fullOptions.includeBModels = false;
    const OutdoorPathMapBuildResult fullResult =
        OutdoorPathfindingBuilder::buildPathMap(mapData, nullptr, nullptr, fullOptions, &landMask);

    const float waterCellX = outdoorGridCornerWorldX(static_cast<int>(BarrierX)) + 256.0f;
    const float waterCellY = outdoorGridCornerWorldY(64) - 256.0f;
    CHECK(fullResult.pathMap.floorAt({waterCellX, waterCellY, 256.0f}).hasFloor);

    OutdoorPathMapBuildOptions landOnlyOptions = {};
    landOnlyOptions.includeBModels = false;
    landOnlyOptions.terrainMode = OutdoorPathTerrainMode::LandOnly;
    const OutdoorPathMapBuildResult landOnlyResult =
        OutdoorPathfindingBuilder::buildPathMap(mapData, nullptr, nullptr, landOnlyOptions, &landMask);

    CHECK_EQ(landOnlyResult.skippedWaterTerrainTriangleCount, 10u);
    CHECK_FALSE(landOnlyResult.pathMap.floorAt({waterCellX, waterCellY, 256.0f}).hasFloor);

    PathPlanRequest request = makeOutdoorPathRequest();
    request.source = {
        outdoorGridCornerWorldX(static_cast<int>(BarrierX) - 1) + 256.0f,
        waterCellY,
        0.0f
    };
    request.target = {
        outdoorGridCornerWorldX(static_cast<int>(BarrierX) + 1) + 256.0f,
        waterCellY,
        0.0f
    };
    request.mapRevision = landOnlyResult.pathMap.revision();

    CHECK_FALSE(landOnlyResult.pathMap.canReachDirectly(request.source, request.target, request.object));

    PathPlanner planner;
    const PathPlanResult planResult = planner.plan(landOnlyResult.pathMap, request);

    REQUIRE(planResult.status == PathPlanStatus::Success);
    REQUIRE(planResult.waypoints.size() > 1);
    CHECK(planResult.waypoints.back().x == doctest::Approx(request.target.x));
    CHECK(planResult.waypoints.back().y == doctest::Approx(request.target.y));
}

TEST_CASE("outdoor land path can recover actor source from land-mask water")
{
    OutdoorMapData mapData = makeOutdoorMapWithTerrain();
    std::vector<uint8_t> landMask = makeOutdoorLandMask();
    constexpr size_t WaterX = 64;
    constexpr size_t WaterY = 64;
    landMask[WaterY * static_cast<size_t>(OutdoorMapData::TerrainWidth - 1) + WaterX] = 0;

    OutdoorPathMapBuildOptions landOnlyOptions = {};
    landOnlyOptions.includeBModels = false;
    landOnlyOptions.terrainMode = OutdoorPathTerrainMode::LandOnly;
    const OutdoorPathMapBuildResult landOnlyResult =
        OutdoorPathfindingBuilder::buildPathMap(mapData, nullptr, nullptr, landOnlyOptions, &landMask);

    PathPlanRequest request = makeOutdoorPathRequest();
    request.source = {
        outdoorGridCornerWorldX(static_cast<int>(WaterX)) + 256.0f,
        outdoorGridCornerWorldY(static_cast<int>(WaterY)) - 256.0f,
        0.0f
    };
    request.target = {
        outdoorGridCornerWorldX(static_cast<int>(WaterX) - 1) + 256.0f,
        request.source.y,
        0.0f
    };
    request.mapRevision = landOnlyResult.pathMap.revision();
    request.sourceSnapDistance = static_cast<float>(OutdoorMapData::TerrainTileSize);

    PathPlanner planner;
    const PathPlanResult planResult = planner.plan(landOnlyResult.pathMap, request);

    CHECK(planResult.status == PathPlanStatus::Success);
    CHECK(planResult.debug.sourceValid);
    CHECK(planResult.debug.preferredSourceSnapUsed);
    const bool sourceSnappedAway =
        std::fabs(planResult.debug.snappedSource.x - request.source.x) > 0.001f
        || std::fabs(planResult.debug.snappedSource.y - request.source.y) > 0.001f;
    CHECK(sourceSnappedAway);
    REQUIRE_FALSE(planResult.waypoints.empty());
}

TEST_CASE("outdoor actor support query treats non-fluid BModel above water as bridge support")
{
    OutdoorMapData mapData = makeOutdoorMapWithTerrain();
    mapData.attributeMap[terrainSampleIndex(64, 64)] = OutdoorTerrainWater;
    const float bridgeX = outdoorGridCornerWorldX(64) + 256.0f;
    const float bridgeY = outdoorGridCornerWorldY(64) - 256.0f;
    constexpr float BridgeZ = 160.0f;
    mapData.bmodels.push_back(makeOutdoorBridgeBModel(bridgeX, bridgeY, BridgeZ));

    const OutdoorMovementController controller(mapData, std::nullopt, std::nullopt, std::nullopt, std::nullopt);
    const OpenYAMM::Game::OutdoorMoveState state =
        controller.initializeActorStateForBodyPreservingZ(bridgeX, bridgeY, BridgeZ + 1.0f, 37.0f);

    REQUIRE_EQ(state.supportKind, OutdoorSupportKind::BModelFace);
    CHECK_FALSE(state.supportIsFluid);
    CHECK(
        controller.hasNonFluidBModelActorSupport(
            state,
            37.0f,
            bridgeX,
            bridgeY,
            state.footZ,
            128.0f));
    CHECK_FALSE(
        controller.hasNonFluidBModelActorSupport(
            state,
            37.0f,
            bridgeX + 512.0f,
            bridgeY,
            state.footZ,
            128.0f));
}

TEST_CASE("outdoor actor movement keeps BModel support across ramp to flat bridge seam")
{
    OutdoorMapData mapData = makeOutdoorMapWithTerrain();
    mapData.attributeMap[terrainSampleIndex(64, 64)] = OutdoorTerrainWater;
    const float seamX = outdoorGridCornerWorldX(64) + 256.0f;
    const float bridgeY = outdoorGridCornerWorldY(64) - 256.0f;
    mapData.bmodels.push_back(makeOutdoorBridgeRampToFlatBModel(seamX, bridgeY));

    const OutdoorMovementController controller(mapData, std::nullopt, std::nullopt, std::nullopt, std::nullopt);
    constexpr float ActorRadius = 37.0f;
    const float startX = seamX - 8.0f;
    const float startFootZ = bridgeRampHeightAt(seamX, startX) + 1.0f;
    const OpenYAMM::Game::OutdoorMoveState start =
        controller.initializeActorStateForBodyPreservingZ(startX, bridgeY, startFootZ, ActorRadius);

    REQUIRE_EQ(start.supportKind, OutdoorSupportKind::BModelFace);
    CHECK_EQ(start.supportFaceIndex, 0u);

    const OpenYAMM::Game::OutdoorMoveState resolved =
        controller.resolveOutdoorActorMove(
            start,
            OpenYAMM::Game::OutdoorBodyDimensions{ActorRadius, 128.0f},
            160.0f,
            0.0f,
            0.0f,
            false,
            0.1f);

    CHECK(resolved.x > seamX);
    CHECK_EQ(resolved.supportKind, OutdoorSupportKind::BModelFace);
    CHECK_EQ(resolved.supportFaceIndex, 1u);
    CHECK_FALSE(resolved.supportIsFluid);
    CHECK_FALSE(resolved.supportOnWater);
    CHECK(resolved.footZ == doctest::Approx(161.0f));
}

TEST_CASE("outdoor pathfinding builder converts BModel floors and walls into path facets")
{
    OutdoorMapData mapData = {};
    mapData.bmodels.push_back(makePathTestBModel());

    OutdoorPathMapBuildOptions options = {};
    options.includeTerrain = false;
    const OutdoorPathMapBuildResult result =
        OutdoorPathfindingBuilder::buildPathMap(mapData, nullptr, nullptr, options);

    REQUIRE_EQ(result.sourceBModelFaceCount, 2u);
    REQUIRE_EQ(result.bModelPathFacetCount, 2u);
    REQUIRE_EQ(result.pathFacetCount, 2u);
    REQUIRE_EQ(result.pathMap.facets().size(), 2u);

    CHECK_EQ(result.pathMap.facets()[0].kind, PathFacetKind::Floor);
    CHECK(result.pathMap.facets()[0].walkableFloor);
    CHECK_EQ(result.pathMap.facets()[0].sourceId, OutdoorPathfindingBuilder::bModelSourceId(0, 0));
    CHECK_EQ(result.pathMap.facets()[1].kind, PathFacetKind::Wall);
    CHECK_FALSE(result.pathMap.facets()[1].walkableFloor);
    CHECK_EQ(result.pathMap.facets()[1].sourceId, OutdoorPathfindingBuilder::bModelSourceId(0, 1));
    CHECK(result.pathMap.floorAt({-50.0f, 0.0f, 64.0f}).hasFloor);
    CHECK_FALSE(
        result.pathMap.canReachDirectly(
            {-50.0f, 0.0f, 0.0f},
            {50.0f, 0.0f, 0.0f},
            makeOutdoorPathObject()));
}

TEST_CASE("outdoor pathfinding builder applies map delta face attributes to BModel blockers")
{
    OutdoorMapData mapData = {};
    mapData.bmodels.push_back(makePathTestBModel());

    MapDeltaData deltaData = {};
    deltaData.faceAttributes = {
        mapData.bmodels[0].faces[0].attributes,
        faceAttributeBit(FaceAttribute::Untouchable)
    };

    OutdoorPathMapBuildOptions options = {};
    options.includeTerrain = false;
    const OutdoorPathMapBuildResult result =
        OutdoorPathfindingBuilder::buildPathMap(mapData, &deltaData, nullptr, options);

    REQUIRE_EQ(result.pathMap.facets().size(), 2u);
    CHECK(result.pathMap.facets()[1].attributes.untouchable);
    CHECK_FALSE(result.pathMap.facets()[1].blocking);
    CHECK(
        result.pathMap.canReachDirectly(
            {-50.0f, 0.0f, 0.0f},
            {50.0f, 0.0f, 0.0f},
            makeOutdoorPathObject()));
}

TEST_CASE("outdoor pathfinding builder feeds the generic planner around a BModel blocker")
{
    OutdoorMapData mapData = {};
    mapData.bmodels.push_back(makeOutdoorPlannerBModel());

    OutdoorPathMapBuildOptions options = {};
    options.includeTerrain = false;
    const OutdoorPathMapBuildResult buildResult =
        OutdoorPathfindingBuilder::buildPathMap(mapData, nullptr, nullptr, options);

    PathPlanRequest request = makeOutdoorPathRequest();
    request.source = {0.0f, 0.0f, 0.0f};
    request.target = {144.0f, 0.0f, 0.0f};
    request.mapRevision = buildResult.pathMap.revision();

    CHECK_FALSE(buildResult.pathMap.canReachDirectly(request.source, request.target, request.object));

    PathPlanner planner;
    const PathPlanResult planResult = planner.plan(buildResult.pathMap, request);

    REQUIRE(planResult.status == PathPlanStatus::Success);
    REQUIRE(planResult.waypoints.size() > 1);
    CHECK(planResult.analyzedNodeCount > 0u);
    CHECK(planResult.waypoints.back().x == doctest::Approx(request.target.x));
    CHECK(planResult.waypoints.back().y == doctest::Approx(request.target.y));
}

TEST_CASE("new sorpigal bridge path exposes terrain to bridge route")
{
    REQUIRE_MESSAGE(regressionMapLoaderLoaded(), regressionMapLoaderFailure());

    OpenYAMM::Game::GameDataLoader gameDataLoader = regressionMapLoader().gameDataLoader;
    REQUIRE(gameDataLoader.loadMapByFileNameForHeadlessGameplay(regressionMapLoader().assetFileSystem, "oute3.odm"));
    const std::optional<OpenYAMM::Game::MapAssetInfo> &selectedMap = gameDataLoader.getSelectedMap();
    REQUIRE(selectedMap.has_value());
    REQUIRE(selectedMap->outdoorMapData.has_value());

    OutdoorPathMapBuildOptions options = {};
    options.terrainMode = OutdoorPathTerrainMode::LandOnly;
    const OutdoorPathMapBuildResult buildResult =
        OutdoorPathfindingBuilder::buildPathMap(
            *selectedMap->outdoorMapData,
            selectedMap->outdoorMapDeltaData ? &*selectedMap->outdoorMapDeltaData : nullptr,
            nullptr,
            options,
            selectedMap->outdoorLandMask ? &*selectedMap->outdoorLandMask : nullptr);

    PathObject object = {};
    object.radius = 40.0f;
    object.stepLength = 64.0f;
    object.stepHeight = 128.0f;

    PathPlanRequest request = {};
    request.source = {-17420.1f, -7168.5f, 1.0f};
    request.target = {-16367.8f, -4737.73f, 353.0f};
    request.object = object;
    request.nodeLimit = 8000;
    request.mapRevision = buildResult.pathMap.revision();
    request.sourceSnapDistance = 512.0f;
    request.allowPartialPath = true;

    PathPlanner planner;
    const PathPlanResult planResult = planner.plan(buildResult.pathMap, request);

    bool routeUsesBModelRamp = false;
    bool routeReachesBridgeDeck = false;

    for (const PathPoint &waypoint : planResult.waypoints)
    {
        const PathFloorSample floor =
            buildResult.pathMap.floorAt({waypoint.x, waypoint.y, waypoint.z + 128.0f});

        if (!floor.hasFloor)
        {
            continue;
        }

        const int32_t sourceId = buildResult.pathMap.facets()[floor.facetIndex].sourceId;
        routeUsesBModelRamp = routeUsesBModelRamp || (sourceId >= 0 && floor.z > 0.0f && floor.z < 256.0f);
        routeReachesBridgeDeck =
            routeReachesBridgeDeck || (sourceId >= 0 && std::fabs(floor.z - 256.0f) < 0.01f);
    }

    REQUIRE(planResult.status == PathPlanStatus::Success);
    CHECK(routeUsesBModelRamp);
    CHECK(routeReachesBridgeDeck);
}

TEST_CASE("new sorpigal bridge lip path keeps ramp waypoints when direct handoff is disabled")
{
    REQUIRE_MESSAGE(regressionMapLoaderLoaded(), regressionMapLoaderFailure());

    OpenYAMM::Game::GameDataLoader gameDataLoader = regressionMapLoader().gameDataLoader;
    REQUIRE(gameDataLoader.loadMapByFileNameForHeadlessGameplay(regressionMapLoader().assetFileSystem, "oute3.odm"));
    const std::optional<OpenYAMM::Game::MapAssetInfo> &selectedMap = gameDataLoader.getSelectedMap();
    REQUIRE(selectedMap.has_value());
    REQUIRE(selectedMap->outdoorMapData.has_value());

    OutdoorPathMapBuildOptions options = {};
    options.terrainMode = OutdoorPathTerrainMode::LandOnly;
    const OutdoorPathMapBuildResult buildResult =
        OutdoorPathfindingBuilder::buildPathMap(
            *selectedMap->outdoorMapData,
            selectedMap->outdoorMapDeltaData ? &*selectedMap->outdoorMapDeltaData : nullptr,
            nullptr,
            options,
            selectedMap->outdoorLandMask ? &*selectedMap->outdoorLandMask : nullptr);

    PathObject object = {};
    object.radius = 40.0f;
    object.stepLength = 64.0f;
    object.stepHeight = 128.0f;

    PathPlanRequest request = {};
    request.source = {-15118.1f, -4840.0f, 1.0f};
    request.target = {-15715.6f, -4717.21f, 353.0f};
    request.object = object;
    request.nodeLimit = 8000;
    request.mapRevision = buildResult.pathMap.revision();
    request.sourceSnapDistance = 512.0f;
    request.allowPartialPath = true;
    request.allowDirect = false;

    PathPlanner planner;
    const PathPlanResult planResult = planner.plan(buildResult.pathMap, request);

    bool routeUsesBModelRamp = false;
    bool routeReachesBridgeDeck = false;

    for (const PathPoint &waypoint : planResult.waypoints)
    {
        const PathFloorSample floor =
            buildResult.pathMap.floorAt({waypoint.x, waypoint.y, waypoint.z + 128.0f});

        if (!floor.hasFloor)
        {
            continue;
        }

        const int32_t sourceId = buildResult.pathMap.facets()[floor.facetIndex].sourceId;
        routeUsesBModelRamp = routeUsesBModelRamp || (sourceId >= 0 && floor.z > 0.0f && floor.z < 256.0f);
        routeReachesBridgeDeck =
            routeReachesBridgeDeck || (sourceId >= 0 && std::fabs(floor.z - 256.0f) < 0.01f);
    }

    REQUIRE(planResult.status == PathPlanStatus::Success);
    REQUIRE(planResult.waypoints.size() > 1u);
    CHECK(routeUsesBModelRamp);
    CHECK(routeReachesBridgeDeck);
}

TEST_CASE("new sorpigal bridge path terrain waypoint can step onto bridge ramp")
{
    REQUIRE_MESSAGE(regressionMapLoaderLoaded(), regressionMapLoaderFailure());

    OpenYAMM::Game::GameDataLoader gameDataLoader = regressionMapLoader().gameDataLoader;
    REQUIRE(gameDataLoader.loadMapByFileNameForHeadlessGameplay(regressionMapLoader().assetFileSystem, "oute3.odm"));
    const std::optional<OpenYAMM::Game::MapAssetInfo> &selectedMap = gameDataLoader.getSelectedMap();
    REQUIRE(selectedMap.has_value());
    REQUIRE(selectedMap->outdoorMapData.has_value());

    const OutdoorMovementController controller(
        *selectedMap->outdoorMapData,
        std::nullopt,
        std::nullopt,
        std::nullopt,
        std::nullopt);

    constexpr float ActorRadius = 40.0f;
    OpenYAMM::Game::OutdoorMoveState state =
        controller.initializeActorStateForBodyPreservingZ(-15108.0f, -4795.15f, 1.0f, ActorRadius);
    REQUIRE_EQ(state.supportKind, OutdoorSupportKind::Terrain);

    const float targetX = -15172.0f;
    const float targetY = -4731.15f;

    for (int step = 0; step < 80 && state.supportKind != OutdoorSupportKind::BModelFace; ++step)
    {
        const float deltaX = targetX - state.x;
        const float deltaY = targetY - state.y;
        const float distance = std::sqrt(deltaX * deltaX + deltaY * deltaY);
        REQUIRE(distance > 0.001f);
        const float velocityX = deltaX / distance * 420.0f;
        const float velocityY = deltaY / distance * 420.0f;

        state =
            controller.resolveOutdoorActorMove(
                state,
                OpenYAMM::Game::OutdoorBodyDimensions{ActorRadius, 128.0f},
                velocityX,
                velocityY,
                0.0f,
                false,
                1.0f / 128.0f);
    }

    CHECK_EQ(state.supportKind, OutdoorSupportKind::BModelFace);
    CHECK(state.footZ > 1.0f);
}

TEST_CASE("ravenshore house stairs move party onto bmodel support")
{
    REQUIRE_MESSAGE(regressionMapLoaderLoaded(), regressionMapLoaderFailure());

    OpenYAMM::Game::GameDataLoader gameDataLoader = regressionMapLoader().gameDataLoader;
    REQUIRE(gameDataLoader.loadMapByFileNameForHeadlessGameplay(regressionMapLoader().assetFileSystem, "out02.odm"));
    const std::optional<OpenYAMM::Game::MapAssetInfo> &selectedMap = gameDataLoader.getSelectedMap();
    REQUIRE(selectedMap.has_value());
    REQUIRE(selectedMap->outdoorMapData.has_value());

    const OutdoorMovementController controller(
        *selectedMap->outdoorMapData,
        selectedMap->outdoorLandMask,
        std::nullopt,
        std::nullopt,
        std::nullopt);

    OpenYAMM::Game::OutdoorMoveState state =
        controller.initializeState(12323.1f, -7892.64f, 1.0f);
    REQUIRE_EQ(state.supportKind, OutdoorSupportKind::Terrain);

    for (int step = 0; step < 256 && state.y < -7297.5f; ++step)
    {
        state =
            controller.resolveMove(
                state,
                3.68373f,
                383.982f,
                0.0f,
                false,
                false,
                false,
                false,
                false,
                512.0f,
                0.0f,
                4000.0f,
                1.0f / 128.0f);
    }

    INFO("final position=" << state.x << "," << state.y << "," << state.footZ
        << " support=" << static_cast<int>(state.supportKind)
        << " bmodel=" << state.supportBModelIndex
        << " face=" << state.supportFaceIndex);
    CHECK_EQ(state.supportKind, OutdoorSupportKind::BModelFace);
    CHECK(state.footZ > 1.0f);
}
