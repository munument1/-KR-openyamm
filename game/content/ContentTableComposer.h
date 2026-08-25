#pragma once

#include "game/content/ContentManifest.h"

#include <cstddef>
#include <string>
#include <vector>

namespace OpenYAMM::Game
{
struct ItemTableContributionRows
{
    std::string packageId;
    ContentIdRangeDefinition idRange;
    size_t sourceIdColumn = 0;
    size_t canonicalIdColumn = 0;
    std::vector<std::vector<std::string>> rows;
};

struct KeyedTableContributionRows
{
    std::string packageId;
    ContentIdRangeDefinition idRange;
    size_t idColumn = 0;
    std::vector<std::vector<std::string>> rows;
};

bool composeItemTableRows(
    const std::vector<std::vector<std::string>> &baseRows,
    const std::vector<ItemTableContributionRows> &contributions,
    std::vector<std::vector<std::string>> &composedRows,
    std::string &errorMessage
);

bool composeKeyedAppendTableRows(
    const std::vector<std::vector<std::string>> &baseRows,
    const std::vector<KeyedTableContributionRows> &contributions,
    std::vector<std::vector<std::string>> &composedRows,
    std::string &errorMessage,
    size_t baseIdColumn = 0
);
}
