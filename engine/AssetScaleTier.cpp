#include "engine/AssetScaleTier.h"

#include <algorithm>
#include <cctype>

namespace OpenYAMM::Engine
{
const char *assetScaleTierToString(AssetScaleTier assetScaleTier)
{
    switch (assetScaleTier)
    {
        case AssetScaleTier::X1:
            return "x1";

        case AssetScaleTier::X2:
            return "x2";

        case AssetScaleTier::X4:
            return "x4";
    }

    return "unknown";
}

std::optional<AssetScaleTier> parseAssetScaleTier(const std::string &value)
{
    std::string normalizedValue = value;
    std::transform(
        normalizedValue.begin(),
        normalizedValue.end(),
        normalizedValue.begin(),
        [](unsigned char character)
        {
            return static_cast<char>(std::tolower(character));
        });

    if (normalizedValue == "1" || normalizedValue == "x1")
    {
        return AssetScaleTier::X1;
    }

    if (normalizedValue == "2" || normalizedValue == "x2")
    {
        return AssetScaleTier::X2;
    }

    if (normalizedValue == "4" || normalizedValue == "x4")
    {
        return AssetScaleTier::X4;
    }

    return std::nullopt;
}

int assetScaleTierFactor(AssetScaleTier assetScaleTier)
{
    switch (assetScaleTier)
    {
        case AssetScaleTier::X1:
            return 1;

        case AssetScaleTier::X2:
            return 2;

        case AssetScaleTier::X4:
            return 4;
    }

    return 1;
}

std::string assetScaleTierDirectorySuffix(AssetScaleTier assetScaleTier)
{
    switch (assetScaleTier)
    {
        case AssetScaleTier::X1:
            return "";

        case AssetScaleTier::X2:
            return "_x2";

        case AssetScaleTier::X4:
            return "_x4";
    }

    return "";
}

int scalePhysicalPixelsToLogical(int physicalPixels, AssetScaleTier assetScaleTier)
{
    if (physicalPixels <= 0)
    {
        return 0;
    }

    const int scaleFactor = assetScaleTierFactor(assetScaleTier);
    return std::max(1, (physicalPixels + scaleFactor - 1) / scaleFactor);
}

AssetScaleProfile createUniformAssetScaleProfile(AssetScaleTier assetScaleTier)
{
    AssetScaleProfile assetScaleProfile;
    assetScaleProfile.textures = assetScaleTier;
    assetScaleProfile.terrain = assetScaleTier;
    assetScaleProfile.sky = assetScaleTier;
    assetScaleProfile.sprites = assetScaleTier;
    assetScaleProfile.decorations = assetScaleTier;
    assetScaleProfile.icons = assetScaleTier;
    assetScaleProfile.ui = assetScaleTier;
    assetScaleProfile.effects = assetScaleTier;
    assetScaleProfile.fonts = assetScaleTier;
    return assetScaleProfile;
}

AssetScaleTier assetScaleTierForCategory(
    const AssetScaleProfile &assetScaleProfile,
    AssetScaleCategory assetScaleCategory)
{
    switch (assetScaleCategory)
    {
        case AssetScaleCategory::Textures:
            return assetScaleProfile.textures;

        case AssetScaleCategory::Terrain:
            return assetScaleProfile.terrain;

        case AssetScaleCategory::Sky:
            return assetScaleProfile.sky;

        case AssetScaleCategory::Sprites:
            return assetScaleProfile.sprites;

        case AssetScaleCategory::Decorations:
            return assetScaleProfile.decorations;

        case AssetScaleCategory::Icons:
            return assetScaleProfile.icons;

        case AssetScaleCategory::Ui:
            return assetScaleProfile.ui;

        case AssetScaleCategory::Effects:
            return assetScaleProfile.effects;

        case AssetScaleCategory::Fonts:
            return assetScaleProfile.fonts;
    }

    return AssetScaleTier::X1;
}

void setAssetScaleTierForCategory(
    AssetScaleProfile &assetScaleProfile,
    AssetScaleCategory assetScaleCategory,
    AssetScaleTier assetScaleTier)
{
    switch (assetScaleCategory)
    {
        case AssetScaleCategory::Textures:
            assetScaleProfile.textures = assetScaleTier;
            return;

        case AssetScaleCategory::Terrain:
            assetScaleProfile.terrain = assetScaleTier;
            return;

        case AssetScaleCategory::Sky:
            assetScaleProfile.sky = assetScaleTier;
            return;

        case AssetScaleCategory::Sprites:
            assetScaleProfile.sprites = assetScaleTier;
            return;

        case AssetScaleCategory::Decorations:
            assetScaleProfile.decorations = assetScaleTier;
            return;

        case AssetScaleCategory::Icons:
            assetScaleProfile.icons = assetScaleTier;
            return;

        case AssetScaleCategory::Ui:
            assetScaleProfile.ui = assetScaleTier;
            return;

        case AssetScaleCategory::Effects:
            assetScaleProfile.effects = assetScaleTier;
            return;

        case AssetScaleCategory::Fonts:
            assetScaleProfile.fonts = assetScaleTier;
            return;
    }
}
}
