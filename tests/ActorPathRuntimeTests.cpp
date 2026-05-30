#include "doctest/doctest.h"

#include "game/pathfinding/ActorPathRuntime.h"

#include <chrono>
#include <cmath>
#include <thread>

using OpenYAMM::Game::ActorPathResolveRequest;
using OpenYAMM::Game::ActorPathResolveResult;
using OpenYAMM::Game::ActorPathRuntime;
using OpenYAMM::Game::PathFacet;
using OpenYAMM::Game::PathFacetKind;
using OpenYAMM::Game::PathMap;
using OpenYAMM::Game::PathObject;
using OpenYAMM::Game::PathPoint;

namespace
{
PathFacet makeRuntimeFloor(float minX, float maxX, float minY, float maxY, float z)
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

PathFacet makeRuntimeWall(float x, float minY, float maxY, float minZ, float maxZ)
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

PathObject makeRuntimeObject()
{
    PathObject object = {};
    object.radius = 8.0f;
    object.stepLength = 24.0f;
    object.stepHeight = 40.0f;
    return object;
}

ActorPathResolveRequest makeRuntimeRequest()
{
    ActorPathResolveRequest request = {};
    request.object = makeRuntimeObject();
    request.nodeLimit = 8000;
    request.waypointReachDistance = request.object.radius;
    return request;
}
}

TEST_CASE("actor path runtime keeps direct movement when target is reachable")
{
    PathMap map;
    map.setFacets({
        makeRuntimeFloor(-48.0f, 192.0f, -48.0f, 48.0f, 0.0f)
    });

    ActorPathResolveRequest request = makeRuntimeRequest();
    request.source = {0.0f, 0.0f, 0.0f};
    request.target = {144.0f, 0.0f, 0.0f};
    request.mapRevision = map.revision();

    ActorPathRuntime runtime;
    const ActorPathResolveResult result = runtime.resolveWaypoint(map, request);

    CHECK(result.directReachable);
    CHECK_FALSE(result.pathActive);
    CHECK_FALSE(result.planned);
}

TEST_CASE("actor path runtime plans a waypoint when direct movement is blocked")
{
    PathMap map;
    map.setFacets({
        makeRuntimeFloor(-48.0f, 192.0f, -120.0f, 120.0f, 0.0f),
        makeRuntimeWall(72.0f, -60.0f, 60.0f, 0.0f, 120.0f)
    });

    ActorPathResolveRequest request = makeRuntimeRequest();
    request.source = {0.0f, 0.0f, 0.0f};
    request.target = {144.0f, 0.0f, 0.0f};
    request.mapRevision = map.revision();

    ActorPathRuntime runtime;
    const ActorPathResolveResult result = runtime.resolveWaypoint(map, request);

    CHECK_FALSE(result.directReachable);
    REQUIRE(result.pathActive);
    CHECK(result.planned);
    CHECK_EQ(result.waypointIndex, 0);
    const bool waypointMoved =
        std::fabs(result.waypoint.x - request.source.x) > 0.001f
        || std::fabs(result.waypoint.y - request.source.y) > 0.001f;
    CHECK(waypointMoved);
}

TEST_CASE("actor path runtime applies failed route cooldown")
{
    PathMap map;
    map.setFacets({
        makeRuntimeFloor(192.0f, 288.0f, -48.0f, 48.0f, 0.0f)
    });

    ActorPathResolveRequest request = makeRuntimeRequest();
    request.source = {0.0f, 0.0f, 0.0f};
    request.target = {240.0f, 0.0f, 0.0f};
    request.mapRevision = map.revision();
    request.nowSeconds = 10.0;
    request.failedRetrySeconds = 5.0;

    ActorPathRuntime runtime;
    const ActorPathResolveResult failed = runtime.resolveWaypoint(map, request);
    CHECK(failed.failed);
    CHECK(failed.planned);

    request.nowSeconds = 12.0;
    const ActorPathResolveResult cooldown = runtime.resolveWaypoint(map, request);
    CHECK(cooldown.cooldown);
    CHECK_FALSE(cooldown.planned);
}

TEST_CASE("actor path runtime uses best reachable point after first failed route")
{
    PathMap map;
    map.setFacets({
        makeRuntimeFloor(-96.0f, 240.0f, -120.0f, 120.0f, 0.0f),
        makeRuntimeWall(72.0f, -120.0f, 120.0f, 0.0f, 120.0f)
    });

    ActorPathResolveRequest request = makeRuntimeRequest();
    request.source = {0.0f, 0.0f, 0.0f};
    request.target = {192.0f, 0.0f, 0.0f};
    request.mapRevision = map.revision();
    request.nowSeconds = 10.0;
    request.failedRetrySeconds = 5.0;

    ActorPathRuntime runtime;
    const ActorPathResolveResult failed = runtime.resolveWaypoint(map, request);
    CHECK(failed.failed);
    CHECK(failed.planned);
    REQUIRE(failed.pathActive);
    CHECK(failed.waypoint.x > request.source.x);

    request.nowSeconds = 12.0;
    const ActorPathResolveResult recovery = runtime.resolveWaypoint(map, request);
    CHECK_FALSE(recovery.cooldown);
    REQUIRE(recovery.pathActive);
    CHECK(recovery.waypoint.x == doctest::Approx(failed.waypoint.x));
}

TEST_CASE("actor path runtime drops stalled recovery best waypoint")
{
    PathMap map;
    map.setFacets({
        makeRuntimeFloor(-96.0f, 240.0f, -120.0f, 120.0f, 0.0f),
        makeRuntimeWall(72.0f, -120.0f, 120.0f, 0.0f, 120.0f)
    });

    ActorPathResolveRequest request = makeRuntimeRequest();
    request.source = {0.0f, 0.0f, 0.0f};
    request.target = {192.0f, 0.0f, 0.0f};
    request.mapRevision = map.revision();
    request.nowSeconds = 10.0;
    request.failedRetrySeconds = 5.0;
    request.directCheckIntervalSeconds = 100.0;
    request.shortcutCheckIntervalSeconds = 100.0;

    ActorPathRuntime runtime;
    const ActorPathResolveResult failed = runtime.resolveWaypoint(map, request);
    REQUIRE(failed.failed);
    REQUIRE(failed.pathActive);

    request.source = {
        failed.waypoint.x - 20.0f,
        failed.waypoint.y,
        failed.waypoint.z
    };

    request.nowSeconds = 10.10;
    ActorPathResolveResult active = runtime.resolveWaypoint(map, request);
    REQUIRE(active.pathActive);

    request.nowSeconds = 10.60;
    const ActorPathResolveResult stalled = runtime.resolveWaypoint(map, request);
    CHECK(stalled.stalledWaypointCount == 1);
    CHECK_FALSE(stalled.pathActive);

    request.nowSeconds = 11.00;
    const ActorPathResolveResult cooldown = runtime.resolveWaypoint(map, request);
    CHECK(cooldown.cooldown);
    CHECK_FALSE(cooldown.pathActive);
}

TEST_CASE("actor path runtime defers blocked route planning when plan budget is exhausted")
{
    PathMap map;
    map.setFacets({
        makeRuntimeFloor(-48.0f, 192.0f, -120.0f, 120.0f, 0.0f),
        makeRuntimeWall(72.0f, -60.0f, 60.0f, 0.0f, 120.0f)
    });

    ActorPathResolveRequest request = makeRuntimeRequest();
    request.source = {0.0f, 0.0f, 0.0f};
    request.target = {144.0f, 0.0f, 0.0f};
    request.mapRevision = map.revision();
    request.nowSeconds = 10.0;
    request.allowPlan = false;

    ActorPathRuntime runtime;
    const ActorPathResolveResult deferred = runtime.resolveWaypoint(map, request);
    CHECK(deferred.deferred);
    CHECK_FALSE(deferred.planned);
    CHECK_FALSE(deferred.pathActive);

    request.nowSeconds = 10.01;
    request.allowPlan = true;
    const ActorPathResolveResult planned = runtime.resolveWaypoint(map, request);
    CHECK(planned.planned);
    CHECK(planned.pathActive);
}

TEST_CASE("actor path runtime can finish blocked route planning on a worker thread")
{
    PathMap map;
    map.setFacets({
        makeRuntimeFloor(-48.0f, 192.0f, -120.0f, 120.0f, 0.0f),
        makeRuntimeWall(72.0f, -60.0f, 60.0f, 0.0f, 120.0f)
    });

    ActorPathResolveRequest request = makeRuntimeRequest();
    request.source = {0.0f, 0.0f, 0.0f};
    request.target = {144.0f, 0.0f, 0.0f};
    request.mapRevision = map.revision();
    request.nowSeconds = 10.0;

    ActorPathRuntime runtime;
    runtime.setWorkerCount(1);

    const ActorPathResolveResult queued = runtime.resolveWaypoint(map, request);
    CHECK(queued.queued);
    CHECK(queued.deferred);
    CHECK_FALSE(queued.planned);
    CHECK_FALSE(queued.pathActive);

    ActorPathResolveResult completed = {};

    for (size_t attempt = 0; attempt < 100; ++attempt)
    {
        std::this_thread::sleep_for(std::chrono::milliseconds(1));
        request.nowSeconds += 0.01;
        completed = runtime.resolveWaypoint(map, request);

        if (completed.planned)
        {
            break;
        }
    }

    CHECK(completed.planned);
    CHECK(completed.pathActive);
}

TEST_CASE("actor path runtime keeps active route when replan fails")
{
    PathMap map;
    map.setFacets({
        makeRuntimeFloor(-48.0f, 192.0f, -120.0f, 120.0f, 0.0f),
        makeRuntimeWall(72.0f, -60.0f, 60.0f, 0.0f, 120.0f)
    });

    ActorPathResolveRequest request = makeRuntimeRequest();
    request.source = {0.0f, 0.0f, 0.0f};
    request.target = {144.0f, 0.0f, 0.0f};
    request.mapRevision = map.revision();
    request.nowSeconds = 10.0;
    request.failedRetrySeconds = 5.0;

    ActorPathRuntime runtime;
    const ActorPathResolveResult planned = runtime.resolveWaypoint(map, request);
    REQUIRE(planned.planned);
    REQUIRE(planned.pathActive);

    request.nowSeconds = 12.0;
    request.target = {2000.0f, 0.0f, 0.0f};
    const ActorPathResolveResult failedReplan = runtime.resolveWaypoint(map, request);

    CHECK(failedReplan.failed);
    CHECK(failedReplan.pathActive);
    CHECK_FALSE(failedReplan.directReachable);
}

TEST_CASE("actor path runtime skips a near waypoint after progress stalls")
{
    PathMap map;
    map.setFacets({
        makeRuntimeFloor(-48.0f, 192.0f, -120.0f, 120.0f, 0.0f),
        makeRuntimeWall(72.0f, -60.0f, 60.0f, 0.0f, 120.0f)
    });

    ActorPathResolveRequest request = makeRuntimeRequest();
    request.source = {0.0f, 0.0f, 0.0f};
    request.target = {144.0f, 0.0f, 0.0f};
    request.mapRevision = map.revision();
    request.nowSeconds = 10.0;
    request.directCheckIntervalSeconds = 100.0;
    request.shortcutCheckIntervalSeconds = 100.0;

    ActorPathRuntime runtime;
    const ActorPathResolveResult planned = runtime.resolveWaypoint(map, request);
    REQUIRE(planned.planned);
    REQUIRE(planned.pathActive);
    REQUIRE(planned.waypointIndex + 1 < planned.waypointCount);

    request.nowSeconds = 10.01;
    ActorPathResolveResult active = runtime.resolveWaypoint(map, request);
    REQUIRE(active.pathActive);
    REQUIRE(active.waypointIndex + 1 < planned.waypointCount);

    const PathPoint waypoint = active.waypoint;
    request.source = {
        waypoint.x + request.waypointReachDistance + 4.0f,
        waypoint.y,
        waypoint.z
    };

    request.nowSeconds = 10.10;
    active = runtime.resolveWaypoint(map, request);
    REQUIRE(active.pathActive);
    const size_t stalledIndex = active.waypointIndex;

    request.nowSeconds = 10.60;
    const ActorPathResolveResult skipped = runtime.resolveWaypoint(map, request);

    CHECK(skipped.pathActive);
    CHECK(skipped.stalledWaypointCount == 1);
    CHECK(skipped.waypointIndex == stalledIndex + 1);
}

TEST_CASE("actor path runtime reports out of range without suppressing direct fallback")
{
    PathMap map;
    map.setFacets({
        makeRuntimeFloor(-48.0f, 288.0f, -48.0f, 48.0f, 0.0f)
    });

    ActorPathResolveRequest request = makeRuntimeRequest();
    request.source = {0.0f, 0.0f, 0.0f};
    request.target = {240.0f, 0.0f, 0.0f};
    request.mapRevision = map.revision();
    request.planningRange = 16.0f;

    ActorPathRuntime runtime;
    const ActorPathResolveResult result = runtime.resolveWaypoint(map, request);

    CHECK(result.outOfRange);
    CHECK_FALSE(result.failed);
    CHECK_FALSE(result.cooldown);
    CHECK_FALSE(result.pathActive);
}

TEST_CASE("actor path runtime plans flying waypoints around solid walls")
{
    PathMap map;
    map.setFacets({
        makeRuntimeFloor(-48.0f, 192.0f, -120.0f, 120.0f, 0.0f),
        makeRuntimeWall(72.0f, -24.0f, 24.0f, 0.0f, 120.0f)
    });

    ActorPathResolveRequest request = makeRuntimeRequest();
    request.object.canFly = true;
    request.object.radius = 8.0f;
    request.object.stepLength = 32.0f;
    request.object.stepHeight = 40.0f;
    request.source = {0.0f, 0.0f, 64.0f};
    request.target = {144.0f, 0.0f, 64.0f};
    request.mapRevision = map.revision();
    request.planningRange = 6000.0f;
    request.allowPlan = true;

    ActorPathRuntime runtime;
    const ActorPathResolveResult result = runtime.resolveWaypoint(map, request);

    CHECK_FALSE(result.directReachable);
    REQUIRE(result.pathActive);
    CHECK(result.planned);
    CHECK(result.waypointCount > 0);
    CHECK(result.waypoint.z == doctest::Approx(64.0f));
}
