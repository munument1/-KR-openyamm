#pragma once

#include "game/maps/MapItemSourceData.h"

#include <string>

namespace YAML
{
class Node;
}

namespace OpenYAMM::Game
{
bool parseMapItemSourceData(
    const YAML::Node &rootNode,
    MapItemSourceData &itemSources,
    std::string &errorMessage);
}
