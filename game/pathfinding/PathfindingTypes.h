#pragma once

#include <cstddef>
#include <cstdint>
#include <vector>

namespace OpenYAMM::Game
{
struct PathPoint
{
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
};

struct PathBounds
{
    float minX = 0.0f;
    float maxX = 0.0f;
    float minY = 0.0f;
    float maxY = 0.0f;
    float minZ = 0.0f;
    float maxZ = 0.0f;
};

enum class PathFacetKind
{
    Generic,
    Floor,
    Wall,
    Ceiling,
    Portal
};

struct PathFacetAttributes
{
    bool portal = false;
    bool invisible = false;
    bool untouchable = false;
};

struct PathFacet
{
    std::vector<PathPoint> vertices;
    PathFacetKind kind = PathFacetKind::Generic;
    PathFacetAttributes attributes;
    bool blocking = true;
    bool walkableFloor = false;
    bool dynamic = false;
    int32_t sourceId = -1;
};

struct PathFloorSample
{
    bool hasFloor = false;
    bool inVoid = false;
    float z = 0.0f;
    float normalZ = 0.0f;
    size_t facetIndex = 0;
};

struct PathObject
{
    bool canFly = false;
    float radius = 0.0f;
    float stepLength = 24.0f;
    float stepHeight = 40.0f;
};

struct PathPlanRequest
{
    size_t actorIndex = 0;
    PathPoint source;
    PathPoint target;
    PathObject object;
    size_t nodeLimit = 8000;
    uint32_t mapRevision = 0;
    bool allowPartialPath = false;
};

struct PathPlanDebugInfo
{
    bool sourceValid = false;
    bool targetValid = false;
    bool directReachable = false;
    PathPoint requestSource;
    PathPoint requestTarget;
    PathPoint snappedSource;
    PathPoint snappedTarget;
    PathPoint bestPoint;
    PathPoint maxStepRejectFrom;
    PathPoint maxStepRejectTo;
    size_t sourceFloorFacet = static_cast<size_t>(-1);
    size_t targetFloorFacet = static_cast<size_t>(-1);
    size_t bestFloorFacet = static_cast<size_t>(-1);
    float bestDistance2d = 0.0f;
    float bestDistance3d = 0.0f;
    float maxRejectedStepDeltaZ = 0.0f;
    size_t generatedCandidates = 0;
    size_t acceptedCandidates = 0;
    size_t rejectedNoFloor = 0;
    size_t rejectedStepHeight = 0;
    size_t rejectedWalkSegment = 0;
    size_t rejectedFlyingInvalid = 0;
    size_t rejectedDuplicate = 0;
    size_t reopenedCandidates = 0;
    size_t skippedClosedNodes = 0;
};

enum class PathPlanStatus
{
    NotRequested,
    Success,
    Partial,
    NoRoute,
    NodeLimitExceeded,
    StaleRevision
};

struct PathPlanResult
{
    PathPlanStatus status = PathPlanStatus::NotRequested;
    std::vector<PathPoint> waypoints;
    PathPlanDebugInfo debug;
    size_t analyzedNodeCount = 0;
    uint32_t mapRevision = 0;
};

struct ActorPathState
{
    PathPoint targetSnapshot;
    PathPoint sourceSnapshot;
    std::vector<PathPoint> waypoints;
    size_t waypointIndex = 0;
    uint64_t requestId = 0;
    bool inProgress = false;
    bool directCheckValid = false;
    bool lastDirectReachable = false;
    PathPlanStatus planStatus = PathPlanStatus::NotRequested;
    double failedUntilSeconds = 0.0;
    double nextDirectCheckSeconds = 0.0;
    double nextPlanSeconds = 0.0;
    double nextShortcutCheckSeconds = 0.0;
    double lastWaypointProgressSeconds = 0.0;
    float bestWaypointDistance = 0.0f;
    float targetMovedThreshold = 1024.0f;
    size_t progressWaypointIndex = 0;
    PathPoint lastSourcePosition;
    uint32_t mapRevision = 0;
};
}
