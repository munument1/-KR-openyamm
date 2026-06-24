#include "doctest/doctest.h"

#include "game/pathfinding/PathMap.h"

#include <cmath>
#include <limits>
#include <vector>

using OpenYAMM::Game::PathFacet;
using OpenYAMM::Game::PathFacetKind;
using OpenYAMM::Game::PathFloorSample;
using OpenYAMM::Game::PathMap;
using OpenYAMM::Game::PathObject;
using OpenYAMM::Game::PathPoint;
using OpenYAMM::Game::PathTraceResult;
using OpenYAMM::Game::PathWalkRejectReason;
using OpenYAMM::Game::PathWalkSegmentDebug;

namespace
{
constexpr float TestEpsilon = 0.001f;

PathFacet makeFloor(float minX, float maxX, float minY, float maxY, float z)
{
    PathFacet facet = {};
    facet.kind = PathFacetKind::Floor;
    facet.blocking = false;
    facet.walkableFloor = true;
    facet.vertices = {
        {minX, minY, z},
        {maxX, minY, z},
        {maxX, maxY, z},
        {minX, maxY, z}
    };
    return facet;
}

PathFacet makeWall(float x, float minY, float maxY, float minZ, float maxZ)
{
    PathFacet facet = {};
    facet.kind = PathFacetKind::Wall;
    facet.blocking = true;
    facet.vertices = {
        {x, minY, minZ},
        {x, maxY, minZ},
        {x, maxY, maxZ},
        {x, minY, maxZ}
    };
    return facet;
}

PathFacet makeHorizontalWall(float y, float minX, float maxX, float minZ, float maxZ)
{
    PathFacet facet = {};
    facet.kind = PathFacetKind::Wall;
    facet.blocking = true;
    facet.vertices = {
        {minX, y, minZ},
        {maxX, y, minZ},
        {maxX, y, maxZ},
        {minX, y, maxZ}
    };
    return facet;
}
}

TEST_CASE("path map line trace blocks through a wall and allows a route around it")
{
    PathMap map;
    map.setFacets({
        makeWall(50.0f, -10.0f, 10.0f, 0.0f, 100.0f)
    });

    const PathTraceResult blocked = map.traceLine({0.0f, 0.0f, 50.0f}, {100.0f, 0.0f, 50.0f});
    CHECK(blocked.blocked);
    CHECK_EQ(blocked.facetIndex, 0u);
    CHECK(std::fabs(blocked.point.x - 50.0f) < TestEpsilon);

    const PathTraceResult clear = map.traceLine({0.0f, 30.0f, 50.0f}, {100.0f, 30.0f, 50.0f});
    CHECK_FALSE(clear.blocked);
}

TEST_CASE("path map floor selection prefers the nearest floor below and marks floors above as void")
{
    PathMap map;
    map.setFacets({
        makeFloor(-100.0f, 100.0f, -100.0f, 100.0f, 0.0f),
        makeFloor(-100.0f, 100.0f, -100.0f, 100.0f, 50.0f)
    });

    const PathFloorSample below = map.floorAt({0.0f, 0.0f, 30.0f});
    REQUIRE(below.hasFloor);
    CHECK_FALSE(below.inVoid);
    CHECK(std::fabs(below.z - 0.0f) < TestEpsilon);

    const PathFloorSample above = map.floorAt({0.0f, 0.0f, -10.0f});
    REQUIRE(above.hasFloor);
    CHECK(above.inVoid);
    CHECK(std::fabs(above.z - 0.0f) < TestEpsilon);
}

TEST_CASE("path map walking rejects segments through void")
{
    PathMap map;
    map.setFacets({
        makeFloor(0.0f, 100.0f, 0.0f, 100.0f, 0.0f)
    });

    PathObject object = {};
    object.radius = 8.0f;
    object.stepLength = 24.0f;
    object.stepHeight = 40.0f;

    CHECK(map.traceWalkSegment({10.0f, 50.0f, 0.0f}, {90.0f, 50.0f, 0.0f}, object));
    CHECK_FALSE(map.traceWalkSegment({10.0f, 50.0f, 0.0f}, {150.0f, 50.0f, 0.0f}, object));
}

TEST_CASE("path map walking samples below long path step length near void edge")
{
    PathMap map;
    map.setFacets({
        makeFloor(0.0f, 10.0f, 0.0f, 100.0f, 0.0f),
        makeFloor(40.0f, 160.0f, 0.0f, 100.0f, 0.0f)
    });

    PathObject object = {};
    object.radius = 40.0f;
    object.stepLength = 64.0f;
    object.stepHeight = 48.0f;

    const PathWalkSegmentDebug debug =
        map.debugTraceWalkSegment({8.0f, 50.0f, 0.0f}, {120.0f, 50.0f, 0.0f}, object);

    CHECK_FALSE(debug.success);
    CHECK_EQ(debug.rejectReason, PathWalkRejectReason::SampleNoFloor);
}

TEST_CASE("path map walking rejects diagonal corner cuts through a small void span")
{
    PathMap map;
    map.setFacets({
        makeFloor(0.0f, 512.0f, 0.0f, 512.0f, 0.0f),
        makeFloor(512.0f, 1024.0f, 512.0f, 1024.0f, 0.0f)
    });

    PathObject object = {};
    object.radius = 40.0f;
    object.stepLength = 64.0f;
    object.stepHeight = 128.0f;

    const PathWalkSegmentDebug debug =
        map.debugTraceWalkSegment({500.0f, 510.0f, 0.0f}, {564.0f, 574.0f, 0.0f}, object);

    CHECK_FALSE(debug.success);
    CHECK_EQ(debug.rejectReason, PathWalkRejectReason::SampleNoFloor);
}

TEST_CASE("path map walking rejects narrow void strips before bridge support")
{
    PathMap map;
    map.setFacets({
        makeFloor(0.0f, 3.0f, 0.0f, 100.0f, 0.0f),
        makeFloor(5.0f, 100.0f, 0.0f, 100.0f, 0.0f)
    });

    PathObject object = {};
    object.radius = 40.0f;
    object.stepLength = 64.0f;
    object.stepHeight = 128.0f;

    const PathWalkSegmentDebug debug =
        map.debugTraceWalkSegment({0.5f, 50.0f, 0.0f}, {64.5f, 50.0f, 0.0f}, object);

    CHECK_FALSE(debug.success);
    CHECK_EQ(debug.rejectReason, PathWalkRejectReason::SampleNoFloor);
}

TEST_CASE("path map walking rejects floor height deltas above the actor step height")
{
    PathMap map;
    map.setFacets({
        makeFloor(0.0f, 50.0f, 0.0f, 100.0f, 0.0f),
        makeFloor(50.0f, 100.0f, 0.0f, 100.0f, 80.0f)
    });

    PathObject object = {};
    object.radius = 8.0f;
    object.stepLength = 24.0f;
    object.stepHeight = 40.0f;

    CHECK_FALSE(map.traceWalkSegment({25.0f, 50.0f, 0.0f}, {75.0f, 50.0f, 0.0f}, object));

    object.stepHeight = 90.0f;
    CHECK(map.traceWalkSegment({25.0f, 50.0f, 0.0f}, {75.0f, 50.0f, 80.0f}, object));
}

TEST_CASE("path map walking rejects a higher overlapping target when trace stays on lower floor")
{
    PathMap map;
    map.setFacets({
        makeFloor(0.0f, 120.0f, 0.0f, 100.0f, 0.0f),
        makeFloor(40.0f, 120.0f, 0.0f, 100.0f, 256.0f)
    });

    PathObject object = {};
    object.radius = 40.0f;
    object.stepLength = 64.0f;
    object.stepHeight = 128.0f;

    const PathWalkSegmentDebug debug =
        map.debugTraceWalkSegment({10.0f, 50.0f, 0.0f}, {90.0f, 50.0f, 256.0f}, object);

    CHECK_FALSE(debug.success);
    CHECK_EQ(debug.rejectReason, PathWalkRejectReason::StepHeight);
    CHECK(debug.stepDeltaZ > object.stepHeight);
}

TEST_CASE("path map rejects non-finite path queries without touching spatial grids")
{
    PathMap map;
    map.setFacets({
        makeFloor(-100.0f, 100.0f, -100.0f, 100.0f, 0.0f),
        makeWall(50.0f, -10.0f, 10.0f, 0.0f, 100.0f)
    });
    map.buildSpatialGrid(16.0f);

    const float nan = std::numeric_limits<float>::quiet_NaN();
    const PathFloorSample floor = map.floorAt({nan, 0.0f, 40.0f});
    CHECK_FALSE(floor.hasFloor);
    CHECK(floor.inVoid);

    const PathTraceResult trace = map.traceLine({0.0f, 0.0f, 40.0f}, {nan, 0.0f, 40.0f}, 8.0f, true);
    CHECK(trace.blocked);

    PathObject object = {};
    object.radius = 8.0f;
    object.stepLength = 24.0f;
    object.stepHeight = 40.0f;
    CHECK_FALSE(map.traceWalkSegment({0.0f, 0.0f, 0.0f}, {nan, 0.0f, 0.0f}, object));
}

TEST_CASE("path map body-radius side trace rejects narrow wall clearance")
{
    PathMap map;
    map.setFacets({
        makeWall(50.0f, 10.0f, 20.0f, 0.0f, 100.0f)
    });

    const PathTraceResult center = map.traceLine({0.0f, 0.0f, 50.0f}, {100.0f, 0.0f, 50.0f});
    CHECK_FALSE(center.blocked);

    const PathTraceResult body = map.traceLine({0.0f, 0.0f, 50.0f}, {100.0f, 0.0f, 50.0f}, 15.0f, true);
    CHECK(body.blocked);
    CHECK_EQ(body.facetIndex, 0u);
}

TEST_CASE("path map body-radius forward trace rejects wall clearance before center crossing")
{
    PathMap map;
    map.setFacets({
        makeHorizontalWall(115.0f, -16.0f, 16.0f, 0.0f, 100.0f)
    });

    const PathTraceResult center = map.traceLine({0.0f, 0.0f, 50.0f}, {0.0f, 100.0f, 50.0f});
    CHECK_FALSE(center.blocked);

    const PathTraceResult body = map.traceLine({0.0f, 0.0f, 50.0f}, {0.0f, 100.0f, 50.0f}, 20.0f, true);
    CHECK(body.blocked);
    CHECK_EQ(body.facetIndex, 0u);
}

TEST_CASE("path map body-radius trace rejects parallel movement into a wall")
{
    PathMap map;
    map.setFacets({
        makeWall(0.0f, -100.0f, 100.0f, 0.0f, 100.0f)
    });

    const PathTraceResult clear =
        map.traceLine({10.0f, 0.0f, 50.0f}, {10.0f, 40.0f, 50.0f}, 12.0f, true);
    CHECK_FALSE(clear.blocked);

    const PathTraceResult blocked =
        map.traceLine({13.0f, 0.0f, 50.0f}, {11.0f, 40.0f, 50.0f}, 12.0f, true);
    CHECK(blocked.blocked);
    CHECK_EQ(blocked.facetIndex, 0u);
}

TEST_CASE("path map spatial grid preserves floor and trace queries")
{
    PathMap map;
    map.setFacets({
        makeFloor(-100.0f, 100.0f, -100.0f, 100.0f, 0.0f),
        makeWall(50.0f, -10.0f, 10.0f, 0.0f, 100.0f)
    });
    map.buildSpatialGrid(64.0f);

    const PathFloorSample floor = map.floorAt({0.0f, 0.0f, 30.0f});
    REQUIRE(floor.hasFloor);
    CHECK_FALSE(floor.inVoid);
    CHECK(std::fabs(floor.z - 0.0f) < TestEpsilon);

    const PathTraceResult blocked = map.traceLine({0.0f, 0.0f, 50.0f}, {100.0f, 0.0f, 50.0f});
    CHECK(blocked.blocked);
    CHECK_EQ(blocked.facetIndex, 1u);
}
