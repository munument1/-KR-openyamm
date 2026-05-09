#pragma once

#include "engine/ApplicationConfig.h"

#include <filesystem>
#include <string>
#include <vector>

namespace OpenYAMM::Game
{
int runScenarioHeadlessCommand(
    const std::filesystem::path &basePath,
    const Engine::ApplicationConfig &config,
    const std::vector<std::string> &arguments,
    bool validateOnly);
}
