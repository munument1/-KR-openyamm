#include "game/content/ContentTableComposer.h"

#include "game/StringUtils.h"

#include <algorithm>
#include <cctype>
#include <cstdint>
#include <optional>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

namespace OpenYAMM::Game
{
namespace
{
constexpr size_t StandardPackageIdColumn = 17;
constexpr size_t StandardCanonicalIdColumn = 18;
constexpr size_t StandardSourceIdColumn = 19;

std::string trimmed(const std::string &value)
{
    size_t begin = 0;

    while (begin < value.size() && std::isspace(static_cast<unsigned char>(value[begin])))
    {
        ++begin;
    }

    size_t end = value.size();

    while (end > begin && std::isspace(static_cast<unsigned char>(value[end - 1])))
    {
        --end;
    }

    return value.substr(begin, end - begin);
}

std::string cell(const std::vector<std::string> &row, size_t index)
{
    return index < row.size() ? trimmed(row[index]) : std::string();
}

std::optional<uint32_t> parseUnsigned(const std::string &value)
{
    const std::string normalized = trimmed(value);

    if (normalized.empty())
    {
        return std::nullopt;
    }

    for (char character : normalized)
    {
        if (!std::isdigit(static_cast<unsigned char>(character)))
        {
            return std::nullopt;
        }
    }

    try
    {
        return static_cast<uint32_t>(std::stoul(normalized));
    }
    catch (...)
    {
        return std::nullopt;
    }
}

bool rangesOverlap(const ContentIdRangeDefinition &left, const ContentIdRangeDefinition &right)
{
    return left.begin <= right.end && right.begin <= left.end;
}

bool validateRanges(const std::vector<ItemTableContributionRows> &contributions, std::string &errorMessage)
{
    for (size_t leftIndex = 0; leftIndex < contributions.size(); ++leftIndex)
    {
        const ItemTableContributionRows &left = contributions[leftIndex];

        if (left.packageId.empty() || left.idRange.domain != "items" || left.idRange.begin == 0
            || left.idRange.begin > left.idRange.end || left.sourceIdColumn == left.canonicalIdColumn)
        {
            errorMessage = "invalid item contribution range for package '" + left.packageId + "'";
            return false;
        }

        for (size_t rightIndex = leftIndex + 1; rightIndex < contributions.size(); ++rightIndex)
        {
            const ItemTableContributionRows &right = contributions[rightIndex];

            if (rangesOverlap(left.idRange, right.idRange))
            {
                errorMessage = "overlapping item id ranges for packages '" + left.packageId + "' and '"
                    + right.packageId + "'";
                return false;
            }
        }
    }

    return true;
}
}

bool composeItemTableRows(
    const std::vector<std::vector<std::string>> &baseRows,
    const std::vector<ItemTableContributionRows> &contributions,
    std::vector<std::vector<std::string>> &composedRows,
    std::string &errorMessage)
{
    composedRows.clear();
    errorMessage.clear();

    if (!validateRanges(contributions, errorMessage))
    {
        return false;
    }

    std::unordered_map<uint32_t, std::string> itemOwners;
    std::unordered_set<std::string> canonicalIds;

    for (const std::vector<std::string> &row : baseRows)
    {
        const std::optional<uint32_t> itemId = parseUnsigned(cell(row, 0));

        if (itemId)
        {
            const std::pair<std::unordered_map<uint32_t, std::string>::iterator, bool> inserted =
                itemOwners.emplace(*itemId, "engine");

            if (!inserted.second)
            {
                errorMessage = "duplicate base item id " + std::to_string(*itemId);
                return false;
            }
        }

        composedRows.push_back(row);
    }

    std::vector<const ItemTableContributionRows *> sortedContributions;
    sortedContributions.reserve(contributions.size());

    for (const ItemTableContributionRows &contribution : contributions)
    {
        sortedContributions.push_back(&contribution);
    }

    std::sort(
        sortedContributions.begin(),
        sortedContributions.end(),
        [](const ItemTableContributionRows *pLeft, const ItemTableContributionRows *pRight)
        {
            return pLeft->packageId < pRight->packageId;
        });

    for (const ItemTableContributionRows *pContribution : sortedContributions)
    {
        for (const std::vector<std::string> &row : pContribution->rows)
        {
            const std::optional<uint32_t> itemId = parseUnsigned(cell(row, 0));

            if (!itemId)
            {
                continue;
            }

            if (*itemId < pContribution->idRange.begin || *itemId > pContribution->idRange.end)
            {
                errorMessage = "item id " + std::to_string(*itemId) + " is outside package '"
                    + pContribution->packageId + "' declared range";
                return false;
            }

            const std::pair<std::unordered_map<uint32_t, std::string>::iterator, bool> insertedItem =
                itemOwners.emplace(*itemId, pContribution->packageId);

            if (!insertedItem.second)
            {
                errorMessage = "item id " + std::to_string(*itemId) + " from package '"
                    + pContribution->packageId + "' collides with package '" + insertedItem.first->second + "'";
                return false;
            }

            const std::optional<uint32_t> sourceItemId = parseUnsigned(cell(row, pContribution->sourceIdColumn));
            const std::string canonicalId = cell(row, pContribution->canonicalIdColumn);
            const std::string expectedCanonicalPrefix = pContribution->packageId + ":item/";

            if (!sourceItemId || canonicalId.empty()
                || !toLowerCopy(canonicalId).starts_with(toLowerCopy(expectedCanonicalPrefix)))
            {
                errorMessage = "item id " + std::to_string(*itemId) + " from package '"
                    + pContribution->packageId + "' lacks valid source or canonical provenance";
                return false;
            }

            if (!canonicalIds.insert(toLowerCopy(canonicalId)).second)
            {
                errorMessage = "duplicate canonical item id '" + canonicalId + "'";
                return false;
            }

            std::vector<std::string> normalizedRow = row;
            normalizedRow.resize(std::max(normalizedRow.size(), StandardSourceIdColumn + 1));
            normalizedRow[StandardPackageIdColumn] = pContribution->packageId;
            normalizedRow[StandardCanonicalIdColumn] = canonicalId;
            normalizedRow[StandardSourceIdColumn] = std::to_string(*sourceItemId);
            composedRows.push_back(std::move(normalizedRow));
        }
    }

    return true;
}

bool composeKeyedAppendTableRows(
    const std::vector<std::vector<std::string>> &baseRows,
    const std::vector<KeyedTableContributionRows> &contributions,
    std::vector<std::vector<std::string>> &composedRows,
    std::string &errorMessage,
    size_t baseIdColumn)
{
    composedRows.clear();
    errorMessage.clear();

    std::unordered_map<uint32_t, std::string> rowOwners;

    for (const std::vector<std::string> &row : baseRows)
    {
        const std::optional<uint32_t> rowId = parseUnsigned(cell(row, baseIdColumn));

        if (rowId && !rowOwners.emplace(*rowId, "engine").second)
        {
            errorMessage = "duplicate base row id " + std::to_string(*rowId);
            return false;
        }

        composedRows.push_back(row);
    }

    std::vector<const KeyedTableContributionRows *> sortedContributions;
    sortedContributions.reserve(contributions.size());

    for (const KeyedTableContributionRows &contribution : contributions)
    {
        if (contribution.packageId.empty() || contribution.idRange.begin == 0
            || contribution.idRange.begin > contribution.idRange.end)
        {
            errorMessage = "invalid keyed table contribution range for package '" + contribution.packageId + "'";
            return false;
        }

        sortedContributions.push_back(&contribution);
    }

    std::sort(
        sortedContributions.begin(),
        sortedContributions.end(),
        [](const KeyedTableContributionRows *pLeft, const KeyedTableContributionRows *pRight)
        {
            return pLeft->packageId < pRight->packageId;
        });

    for (size_t leftIndex = 0; leftIndex < sortedContributions.size(); ++leftIndex)
    {
        for (size_t rightIndex = leftIndex + 1; rightIndex < sortedContributions.size(); ++rightIndex)
        {
            if (rangesOverlap(
                sortedContributions[leftIndex]->idRange,
                sortedContributions[rightIndex]->idRange))
            {
                errorMessage = "overlapping keyed table id ranges for packages '"
                    + sortedContributions[leftIndex]->packageId + "' and '"
                    + sortedContributions[rightIndex]->packageId + "'";
                return false;
            }
        }
    }

    for (const KeyedTableContributionRows *pContribution : sortedContributions)
    {
        for (const std::vector<std::string> &row : pContribution->rows)
        {
            const std::optional<uint32_t> rowId = parseUnsigned(cell(row, pContribution->idColumn));

            if (!rowId)
            {
                continue;
            }

            if (*rowId < pContribution->idRange.begin || *rowId > pContribution->idRange.end)
            {
                errorMessage = "row id " + std::to_string(*rowId) + " is outside package '"
                    + pContribution->packageId + "' declared range";
                return false;
            }

            const std::pair<std::unordered_map<uint32_t, std::string>::iterator, bool> inserted =
                rowOwners.emplace(*rowId, pContribution->packageId);

            if (!inserted.second)
            {
                errorMessage = "row id " + std::to_string(*rowId) + " from package '"
                    + pContribution->packageId + "' collides with package '" + inserted.first->second + "'";
                return false;
            }

            composedRows.push_back(row);
        }
    }

    return true;
}
}
