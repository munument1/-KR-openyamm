#pragma once

#include <optional>
#include <string>
#include <vector>

namespace OpenYAMM::Game
{
struct MapPresentationVariant
{
    std::string textureName;
    int pixelWidth = 0;
    int pixelHeight = 0;
    std::optional<float> minimumZ;
    std::optional<float> maximumZ;
};

struct MapPresentation
{
    float worldMinX = -32768.0f;
    float worldMaxX = 32768.0f;
    float worldMinY = -32768.0f;
    float worldMaxY = 32768.0f;
    bool flipU = false;
    bool flipV = true;
    bool revealEntireMap = false;
    std::vector<MapPresentationVariant> variants;
};

std::optional<MapPresentation> loadMapPresentationFromCatalog(
    const std::string &catalogText,
    const std::string &mapFileName,
    std::string &errorMessage);

const MapPresentationVariant *resolveMapPresentationVariant(
    const MapPresentation &presentation,
    float partyZ);
}
