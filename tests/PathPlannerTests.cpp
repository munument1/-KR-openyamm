#include "doctest/doctest.h"

#include "game/pathfinding/PathPlanner.h"

#include <cmath>
#include <vector>

using OpenYAMM::Game::PathFacet;
using OpenYAMM::Game::PathFacetKind;
using OpenYAMM::Game::PathMap;
using OpenYAMM::Game::PathObject;
using OpenYAMM::Game::PathPlanRequest;
using OpenYAMM::Game::PathPlanResult;
using OpenYAMM::Game::PathPlanStatus;
using OpenYAMM::Game::PathPlanner;

namespace
{
PathFacet makePlannerFloor(float minX, float maxX, float minY, float maxY, float z)
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

PathFacet makePlannerWall(float x, float minY, float maxY, float minZ, float maxZ)
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

PathObject makeGroundObject()
{
    PathObject object = {};
    object.radius = 8.0f;
    object.stepLength = 24.0f;
    object.stepHeight = 40.0f;
    return object;
}

PathPlanRequest makeRequest()
{
    PathPlanRequest request = {};
    request.object = makeGroundObject();
    request.nodeLimit = 8000;
    return request;
}
}

TEST_CASE("path planner routes ground movement around a wall")
{
    PathMap map;
    map.setFacets({
        makePlannerFloor(-48.0f, 192.0f, -120.0f, 120.0f, 0.0f),
        makePlannerWall(72.0f, -60.0f, 60.0f, 0.0f, 120.0f)
    });

    PathPlanRequest request = makeRequest();
    request.source = {0.0f, 0.0f, 0.0f};
    request.target = {144.0f, 0.0f, 0.0f};

    PathPlanner planner;
    const PathPlanResult result = planner.plan(map, request);

    REQUIRE(result.status == PathPlanStatus::Success);
    REQUIRE(result.waypoints.size() > 1);
    CHECK(result.analyzedNodeCount > 0u);
    CHECK(std::fabs(result.waypoints.back().x - request.target.x) < 0.001f);
    CHECK(std::fabs(result.waypoints.back().y - request.target.y) < 0.001f);
}

TEST_CASE("path planner snaps elevated ground target to floor")
{
    PathMap map;
    map.setFacets({
        makePlannerFloor(-48.0f, 192.0f, -48.0f, 48.0f, 0.0f)
    });

    PathPlanRequest request = makeRequest();
    request.source = {0.0f, 0.0f, 0.0f};
    request.target = {144.0f, 0.0f, 300.0f};

    PathPlanner planner;
    const PathPlanResult result = planner.plan(map, request);

    REQUIRE(result.status == PathPlanStatus::Success);
    REQUIRE_FALSE(result.waypoints.empty());
    CHECK(std::fabs(result.waypoints.back().x - request.target.x) < 0.001f);
    CHECK(std::fabs(result.waypoints.back().y - request.target.y) < 0.001f);
    CHECK(std::fabs(result.waypoints.back().z) < 0.001f);
}

TEST_CASE("path planner returns no route across missing floor")
{
    PathMap map;
    map.setFacets({
        makePlannerFloor(-48.0f, 48.0f, -48.0f, 48.0f, 0.0f),
        makePlannerFloor(192.0f, 288.0f, -48.0f, 48.0f, 0.0f)
    });

    PathPlanRequest request = makeRequest();
    request.source = {0.0f, 0.0f, 0.0f};
    request.target = {240.0f, 0.0f, 0.0f};

    PathPlanner planner;
    const PathPlanResult result = planner.plan(map, request);

    CHECK(result.status == PathPlanStatus::NoRoute);
}

TEST_CASE("path planner can return best partial route when requested")
{
    PathMap map;
    map.setFacets({
        makePlannerFloor(-48.0f, 48.0f, -48.0f, 48.0f, 0.0f),
        makePlannerFloor(192.0f, 288.0f, -48.0f, 48.0f, 0.0f)
    });

    PathPlanRequest request = makeRequest();
    request.source = {0.0f, 0.0f, 0.0f};
    request.target = {240.0f, 0.0f, 0.0f};
    request.allowPartialPath = true;

    PathPlanner planner;
    const PathPlanResult result = planner.plan(map, request);

    CHECK(result.status == PathPlanStatus::Partial);
    REQUIRE_FALSE(result.waypoints.empty());
    CHECK(result.waypoints.back().x > request.source.x);
    CHECK(result.waypoints.back().x < request.target.x);
}

TEST_CASE("path planner accepts stairs within step height")
{
    PathMap map;
    map.setFacets({
        makePlannerFloor(0.0f, 48.0f, -48.0f, 48.0f, 0.0f),
        makePlannerFloor(48.0f, 96.0f, -48.0f, 48.0f, 24.0f),
        makePlannerFloor(96.0f, 144.0f, -48.0f, 48.0f, 48.0f)
    });

    PathPlanRequest request = makeRequest();
    request.object.stepHeight = 32.0f;
    request.source = {24.0f, 0.0f, 0.0f};
    request.target = {120.0f, 0.0f, 48.0f};

    PathPlanner planner;
    const PathPlanResult result = planner.plan(map, request);

    CHECK(result.status == PathPlanStatus::Success);
}

TEST_CASE("path planner rejects stairs above step height")
{
    PathMap map;
    map.setFacets({
        makePlannerFloor(0.0f, 72.0f, -48.0f, 48.0f, 0.0f),
        makePlannerFloor(72.0f, 144.0f, -48.0f, 48.0f, 80.0f)
    });

    PathPlanRequest request = makeRequest();
    request.source = {24.0f, 0.0f, 0.0f};
    request.target = {120.0f, 0.0f, 80.0f};

    PathPlanner planner;
    const PathPlanResult result = planner.plan(map, request);

    CHECK(result.status == PathPlanStatus::NoRoute);
}

TEST_CASE("path planner lets flying movement pass over low ground obstacles")
{
    PathMap map;
    map.setFacets({
        makePlannerFloor(-48.0f, 192.0f, -48.0f, 48.0f, 0.0f),
        makePlannerWall(72.0f, -24.0f, 24.0f, 0.0f, 20.0f)
    });

    PathPlanRequest request = makeRequest();
    request.object.canFly = true;
    request.source = {0.0f, 0.0f, 80.0f};
    request.target = {144.0f, 0.0f, 80.0f};

    PathPlanner planner;
    const PathPlanResult result = planner.plan(map, request);

    REQUIRE(result.status == PathPlanStatus::Success);
    REQUIRE_EQ(result.waypoints.size(), 1u);
    CHECK(std::fabs(result.waypoints.front().z - 80.0f) < 0.001f);
}

TEST_CASE("path planner reports node limit failure before unbounded searches")
{
    PathMap map;
    map.setFacets({
        makePlannerFloor(-48.0f, 192.0f, -120.0f, 120.0f, 0.0f),
        makePlannerWall(72.0f, -60.0f, 60.0f, 0.0f, 120.0f)
    });

    PathPlanRequest request = makeRequest();
    request.source = {0.0f, 0.0f, 0.0f};
    request.target = {144.0f, 0.0f, 0.0f};
    request.nodeLimit = 1;

    PathPlanner planner;
    const PathPlanResult result = planner.plan(map, request);

    CHECK(result.status == PathPlanStatus::NodeLimitExceeded);
}
