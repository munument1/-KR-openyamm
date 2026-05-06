#pragma once

#include <algorithm>
#include <cstdint>
#include <cmath>

namespace OpenYAMM::Game
{
struct OutdoorFogProfile
{
    float nearOpacity = 0.0f;
    float strongOpacity = 0.0f;
    float weakDistance = 0.0f;
    float strongDistance = 1.0f;
    float farDistance = 2.0f;
};

inline OutdoorFogProfile buildOutdoorFogProfile(
    int32_t authoredWeakDistance,
    int32_t authoredStrongDistance,
    float visibleDistance,
    float nearOpacity,
    float strongOpacity)
{
    constexpr float FogLeadFraction = 0.35f;
    constexpr float FogStrongStretchFraction = 0.20f;
    constexpr float FogTailFraction = 1.50f;

    const float weakDistance = std::max(static_cast<float>(authoredWeakDistance), 0.0f);
    const float strongDistance = std::max(static_cast<float>(authoredStrongDistance), weakDistance + 1.0f);
    const float distanceSpan = std::max(strongDistance - weakDistance, 1.0f);
    const float clampedVisibleDistance = std::max(visibleDistance, strongDistance + 1.0f);
    const float softenedWeakDistance = std::max(weakDistance - distanceSpan * FogLeadFraction, 0.0f);
    const float softenedStrongDistance =
        std::max(strongDistance + distanceSpan * FogStrongStretchFraction, softenedWeakDistance + 1.0f);
    const float softenedFarDistance =
        std::max(clampedVisibleDistance + distanceSpan * FogTailFraction, softenedStrongDistance + 1.0f);

    OutdoorFogProfile profile = {};
    profile.nearOpacity = std::clamp(nearOpacity, 0.0f, 1.0f);
    profile.strongOpacity = std::clamp(strongOpacity, profile.nearOpacity, 1.0f);
    profile.weakDistance = softenedWeakDistance;
    profile.strongDistance = softenedStrongDistance;
    profile.farDistance = softenedFarDistance;
    return profile;
}

inline OutdoorFogProfile buildOutdoorClearDistanceFogProfile(float visibleDistance)
{
    const float clampedVisibleDistance = std::max(visibleDistance, 1.0f);

    OutdoorFogProfile profile = {};
    profile.nearOpacity = 0.0f;
    profile.strongOpacity = 0.0f;
    profile.weakDistance = clampedVisibleDistance * 0.75f;
    profile.strongDistance = clampedVisibleDistance * 0.875f;
    profile.farDistance = clampedVisibleDistance;
    return profile;
}

inline uint8_t outdoorClearDistanceFogBrightness(float gameMinutes)
{
    const float minutesOfDay = std::fmod(std::max(gameMinutes, 0.0f), 1440.0f);

    if (minutesOfDay < 300.0f || minutesOfDay >= 1260.0f)
    {
        return 39;
    }

    const float daylightMinutes = minutesOfDay - 300.0f;
    const float mirroredDaylightMinutes = daylightMinutes >= 480.0f ? 960.0f - daylightMinutes : daylightMinutes;
    const int maxTerrainDimmingLevel = static_cast<int>(20.0f - mirroredDaylightMinutes / 480.0f * 20.0f);
    return static_cast<uint8_t>(std::clamp(255 - 8 * maxTerrainDimmingLevel, 0, 255));
}
} // namespace OpenYAMM::Game
