#pragma once

#include "game/scenario/ScenarioDocument.h"

namespace OpenYAMM::Game
{
class ScenarioYamlLoader
{
public:
    ScenarioLoadResult load(const std::filesystem::path &path) const;

private:
    static std::string formatLocation(const std::filesystem::path &path, int line);
    static bool parseMode(
        const std::string &value,
        ScenarioMode &mode);
    static bool parseStepKind(
        const std::string &value,
        ScenarioStepKind &kind);
};
}
