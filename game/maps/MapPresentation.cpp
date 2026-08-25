#include "game/maps/MapPresentation.h"

#include "game/maps/MapIdentity.h"

#include <yaml-cpp/yaml.h>

#include <exception>

namespace OpenYAMM::Game
{
namespace
{
bool readRequiredFloat(
    const YAML::Node &node,
    const char *key,
    float &value,
    std::string &errorMessage)
{
    const YAML::Node valueNode = node[key];

    if (!valueNode || !valueNode.IsScalar())
    {
        errorMessage = std::string("map presentation field must be a scalar: ") + key;
        return false;
    }

    try
    {
        value = valueNode.as<float>();
    }
    catch (const std::exception &exception)
    {
        errorMessage = std::string("invalid map presentation field ") + key + ": " + exception.what();
        return false;
    }

    return true;
}

std::optional<MapPresentation> parsePresentation(
    const YAML::Node &mapNode,
    std::string &errorMessage)
{
    const YAML::Node boundsNode = mapNode["world_bounds"];
    const YAML::Node variantsNode = mapNode["variants"];

    if (!boundsNode || !boundsNode.IsMap())
    {
        errorMessage = "map presentation world_bounds must be a map";
        return std::nullopt;
    }

    if (!variantsNode || !variantsNode.IsSequence() || variantsNode.size() == 0)
    {
        errorMessage = "map presentation variants must be a non-empty sequence";
        return std::nullopt;
    }

    MapPresentation presentation = {};

    if (!readRequiredFloat(boundsNode, "min_x", presentation.worldMinX, errorMessage)
        || !readRequiredFloat(boundsNode, "max_x", presentation.worldMaxX, errorMessage)
        || !readRequiredFloat(boundsNode, "min_y", presentation.worldMinY, errorMessage)
        || !readRequiredFloat(boundsNode, "max_y", presentation.worldMaxY, errorMessage))
    {
        return std::nullopt;
    }

    if (presentation.worldMaxX <= presentation.worldMinX || presentation.worldMaxY <= presentation.worldMinY)
    {
        errorMessage = "map presentation world bounds must have positive extents";
        return std::nullopt;
    }

    try
    {
        presentation.flipU = mapNode["flip_u"] ? mapNode["flip_u"].as<bool>() : false;
        presentation.flipV = mapNode["flip_v"] ? mapNode["flip_v"].as<bool>() : true;
        presentation.revealEntireMap = mapNode["reveal_entire_map"]
            ? mapNode["reveal_entire_map"].as<bool>()
            : false;

        for (const YAML::Node &variantNode : variantsNode)
        {
            if (!variantNode.IsMap()
                || !variantNode["texture"]
                || !variantNode["width"]
                || !variantNode["height"])
            {
                errorMessage = "map presentation variant requires texture, width, and height";
                return std::nullopt;
            }

            MapPresentationVariant variant = {};
            variant.textureName = variantNode["texture"].as<std::string>();
            variant.pixelWidth = variantNode["width"].as<int>();
            variant.pixelHeight = variantNode["height"].as<int>();

            if (variantNode["minimum_z"])
            {
                variant.minimumZ = variantNode["minimum_z"].as<float>();
            }

            if (variantNode["maximum_z"])
            {
                variant.maximumZ = variantNode["maximum_z"].as<float>();
            }

            if (variant.textureName.empty() || variant.pixelWidth <= 0 || variant.pixelHeight <= 0)
            {
                errorMessage = "map presentation variant has invalid texture dimensions";
                return std::nullopt;
            }

            presentation.variants.push_back(std::move(variant));
        }
    }
    catch (const std::exception &exception)
    {
        errorMessage = std::string("invalid map presentation catalog: ") + exception.what();
        return std::nullopt;
    }

    return presentation;
}
}

std::optional<MapPresentation> loadMapPresentationFromCatalog(
    const std::string &catalogText,
    const std::string &mapFileName,
    std::string &errorMessage)
{
    errorMessage.clear();

    try
    {
        const YAML::Node root = YAML::Load(catalogText);
        const YAML::Node mapsNode = root["maps"];

        if (!root["format_version"] || root["format_version"].as<int>() != 1
            || !root["kind"] || root["kind"].as<std::string>() != "world_map_presentation_catalog")
        {
            errorMessage = "unsupported map presentation catalog format";
            return std::nullopt;
        }

        if (!mapsNode || !mapsNode.IsSequence())
        {
            errorMessage = "map presentation catalog requires a maps sequence";
            return std::nullopt;
        }

        const std::string targetStem = normalizeMapFileStem(mapFileName);

        for (const YAML::Node &mapNode : mapsNode)
        {
            if (!mapNode.IsMap() || !mapNode["map"] || !mapNode["map"].IsScalar())
            {
                errorMessage = "map presentation catalog entry requires a map field";
                return std::nullopt;
            }

            if (normalizeMapFileStem(mapNode["map"].as<std::string>()) == targetStem)
            {
                return parsePresentation(mapNode, errorMessage);
            }
        }
    }
    catch (const std::exception &exception)
    {
        errorMessage = std::string("failed to parse map presentation catalog: ") + exception.what();
        return std::nullopt;
    }

    return std::nullopt;
}

const MapPresentationVariant *resolveMapPresentationVariant(
    const MapPresentation &presentation,
    float partyZ)
{
    for (const MapPresentationVariant &variant : presentation.variants)
    {
        const bool aboveMinimum = !variant.minimumZ || partyZ > *variant.minimumZ;
        const bool belowMaximum = !variant.maximumZ || partyZ <= *variant.maximumZ;

        if (aboveMinimum && belowMaximum)
        {
            return &variant;
        }
    }

    return presentation.variants.empty() ? nullptr : &presentation.variants.front();
}
}
