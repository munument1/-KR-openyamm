#pragma once

#include "engine/AssetScaleTier.h"

#include <cstddef>
#include <optional>
#include <string>

namespace OpenYAMM::Engine
{
enum class WindowMode
{
    Windowed,
    WindowedFullscreen,
    Fullscreen
};

struct ApplicationConfig
{
    std::string appName;
    std::string assetRoot;
    std::string activeWorldId;
    std::string startupMapFileOverride;
    std::optional<size_t> loadUniqueActorIndex;
    AssetScaleTier assetScaleTier;
    AssetScaleProfile assetScaleProfile;
    int windowWidth;
    int windowHeight;
    WindowMode windowMode;
    bool verticalSync;
    bool fpsTrace;
    bool performanceTrace;
    bool hitchTrace;
    float hitchThresholdMilliseconds;

    static ApplicationConfig createDefault();
};
}
