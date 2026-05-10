#pragma once

#include "engine/AssetScaleTier.h"

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
    AssetScaleTier assetScaleTier;
    AssetScaleProfile assetScaleProfile;
    int windowWidth;
    int windowHeight;
    WindowMode windowMode;
    bool fpsTrace;

    static ApplicationConfig createDefault();
};
}
