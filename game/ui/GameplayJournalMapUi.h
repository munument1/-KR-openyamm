#pragma once

#include "game/gameplay/GameplaySaveLoadUiSupport.h"
#include "game/ui/GameplayUiController.h"

#include <algorithm>
#include <cctype>
#include <cmath>
#include <filesystem>
#include <string>

namespace OpenYAMM::Game
{
constexpr int GameplayJournalMapBaseZoom = 384;
constexpr float GameplayJournalMapPinLogicalSize = 10.0f;

struct GameplayJournalMapPoint
{
    float x = 0.0f;
    float y = 0.0f;
};

struct GameplayJournalMapTransform
{
    float uOrigin = 0.0f;
    float vOrigin = 0.0f;
    float uSpan = 1.0f;
    float vSpan = 1.0f;
};

inline int clampedGameplayJournalMapZoomValue(int zoomStep)
{
    const int clampedStep = std::clamp(zoomStep, 0, static_cast<int>(GameplayJournalMapZoomLevels.size()) - 1);
    return GameplayJournalMapZoomLevels[clampedStep];
}

inline GameplayJournalMapTransform gameplayJournalMapTransform(
    const GameplayUiController::JournalScreenState &journalScreen)
{
    const int zoom = clampedGameplayJournalMapZoomValue(journalScreen.mapZoomStep);
    const float zoomFactor = static_cast<float>(zoom) / static_cast<float>(GameplayJournalMapBaseZoom);
    const float uCenter =
        (journalScreen.mapCenterX + GameplayJournalMapWorldHalfExtent)
        / (GameplayJournalMapWorldHalfExtent * 2.0f);
    const float vCenter =
        (GameplayJournalMapWorldHalfExtent - journalScreen.mapCenterY)
        / (GameplayJournalMapWorldHalfExtent * 2.0f);
    const float uSpan = 1.0f / std::max(zoomFactor, 0.000001f);
    const float vSpan = 1.0f / std::max(zoomFactor, 0.000001f);

    return {
        uCenter - uSpan * 0.5f,
        vCenter - vSpan * 0.5f,
        uSpan,
        vSpan
    };
}

inline GameplayJournalMapPoint gameplayJournalWorldToScreen(
    float worldX,
    float worldY,
    float viewportX,
    float viewportY,
    float viewportWidth,
    float viewportHeight,
    const GameplayUiController::JournalScreenState &journalScreen)
{
    const GameplayJournalMapTransform transform = gameplayJournalMapTransform(journalScreen);
    const float u =
        (worldX + GameplayJournalMapWorldHalfExtent) / (GameplayJournalMapWorldHalfExtent * 2.0f);
    const float v =
        (GameplayJournalMapWorldHalfExtent - worldY) / (GameplayJournalMapWorldHalfExtent * 2.0f);

    return {
        viewportX + ((u - transform.uOrigin) / std::max(transform.uSpan, 0.000001f)) * viewportWidth,
        viewportY + ((v - transform.vOrigin) / std::max(transform.vSpan, 0.000001f)) * viewportHeight
    };
}

inline GameplayJournalMapPoint gameplayJournalScreenToWorld(
    float screenX,
    float screenY,
    float viewportX,
    float viewportY,
    float viewportWidth,
    float viewportHeight,
    const GameplayUiController::JournalScreenState &journalScreen)
{
    const GameplayJournalMapTransform transform = gameplayJournalMapTransform(journalScreen);
    const float u =
        transform.uOrigin + ((screenX - viewportX) / std::max(viewportWidth, 1.0f)) * transform.uSpan;
    const float v =
        transform.vOrigin + ((screenY - viewportY) / std::max(viewportHeight, 1.0f)) * transform.vSpan;

    return {
        u * (GameplayJournalMapWorldHalfExtent * 2.0f) - GameplayJournalMapWorldHalfExtent,
        GameplayJournalMapWorldHalfExtent - v * (GameplayJournalMapWorldHalfExtent * 2.0f)
    };
}

inline std::string gameplayJournalNormalizeMapFileName(const std::string &mapFileName)
{
    std::string normalized = std::filesystem::path(mapFileName).filename().string();

    std::transform(
        normalized.begin(),
        normalized.end(),
        normalized.begin(),
        [](unsigned char ch)
        {
            return static_cast<char>(std::tolower(ch));
        });

    return normalized;
}
} // namespace OpenYAMM::Game
