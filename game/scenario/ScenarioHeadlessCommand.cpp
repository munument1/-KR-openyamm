#include "game/scenario/ScenarioHeadlessCommand.h"

#include "game/scenario/ScenarioRunner.h"
#include "game/scenario/ScenarioYamlLoader.h"

#include <iostream>

namespace OpenYAMM::Game
{
int runScenarioHeadlessCommand(
    const std::filesystem::path &basePath,
    const Engine::ApplicationConfig &config,
    const std::vector<std::string> &arguments,
    bool validateOnly)
{
    if (arguments.size() < 2)
    {
        std::cerr << "Usage: " << arguments[0]
                  << " <scenario.yml> [--scenario-dry-run] [--scenario-quiet] [--scenario-no-color]\n";
        return 2;
    }

    ScenarioRunOptions options = {};

    for (size_t argumentIndex = 2; argumentIndex < arguments.size(); ++argumentIndex)
    {
        if (arguments[argumentIndex] == "--scenario-dry-run")
        {
            options.dryRun = true;
            continue;
        }

        if (arguments[argumentIndex] == "--scenario-quiet")
        {
            options.trace = false;
            continue;
        }

        if (arguments[argumentIndex] == "--scenario-no-color")
        {
            options.colors = false;
            continue;
        }

        std::cerr << "Unknown scenario option: " << arguments[argumentIndex] << '\n';
        return 2;
    }

    ScenarioYamlLoader loader;
    const ScenarioLoadResult loadResult = loader.load(arguments[1]);

    if (!loadResult.errors.empty())
    {
        for (const std::string &error : loadResult.errors)
        {
            std::cerr << "Scenario validation error: " << error << '\n';
        }

        return 1;
    }

    std::cout << "Scenario validated: " << loadResult.document.id
              << " steps=" << loadResult.document.steps.size() << '\n';
    std::cout.flush();

    if (validateOnly)
    {
        return 0;
    }

    ScenarioRunner runner;
    const ScenarioRunResult runResult = runner.run(basePath, config, loadResult.document, options);

    if (!runResult.success)
    {
        for (const std::string &failure : runResult.failures)
        {
            std::cerr << "Scenario failure: " << failure << '\n';
        }

        return 1;
    }

    std::cout << "Scenario passed: " << loadResult.document.id << '\n';
    return 0;
}
}
