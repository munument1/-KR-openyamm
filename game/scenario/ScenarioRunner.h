#pragma once

#include "engine/ApplicationConfig.h"
#include "game/scenario/ScenarioDocument.h"

namespace OpenYAMM::Game
{
struct ScenarioRunOptions
{
    bool dryRun = false;
    bool trace = true;
    bool colors = true;
};

struct ScenarioRunResult
{
    bool success = false;
    std::vector<std::string> failures;
};

class ScenarioRunner
{
public:
    ScenarioRunResult run(
        const std::filesystem::path &basePath,
        const Engine::ApplicationConfig &config,
        const ScenarioDocument &document,
        const ScenarioRunOptions &options);
};
}
