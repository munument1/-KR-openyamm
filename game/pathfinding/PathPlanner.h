#pragma once

#include "game/pathfinding/PathMap.h"
#include "game/pathfinding/PathfindingTypes.h"

namespace OpenYAMM::Game
{
class PathPlanner
{
public:
    PathPlanResult plan(const PathMap &map, const PathPlanRequest &request);
};
}
