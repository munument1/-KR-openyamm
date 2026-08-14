#pragma once

namespace OpenYAMM::Game
{
enum class MobileJoystickDirection
{
    Neutral,
    North,
    NorthEast,
    East,
    SouthEast,
    South,
    SouthWest,
    West,
    NorthWest
};

inline MobileJoystickDirection quantizeMobileJoystickDirection(float deltaX, float deltaY, float deadZone)
{
    if (deltaX * deltaX + deltaY * deltaY <= deadZone * deadZone)
    {
        return MobileJoystickDirection::Neutral;
    }

    const float absoluteX = deltaX < 0.0f ? -deltaX : deltaX;
    const float absoluteY = deltaY < 0.0f ? -deltaY : deltaY;

    // tan(25 degrees) gives cardinal directions 50-degree sectors and diagonals 40-degree sectors.
    constexpr float CardinalPreferenceSlope = 0.46630766f;

    if (absoluteX <= absoluteY * CardinalPreferenceSlope)
    {
        return deltaY < 0.0f ? MobileJoystickDirection::North : MobileJoystickDirection::South;
    }

    if (absoluteY <= absoluteX * CardinalPreferenceSlope)
    {
        return deltaX < 0.0f ? MobileJoystickDirection::West : MobileJoystickDirection::East;
    }

    if (deltaY < 0.0f)
    {
        return deltaX < 0.0f ? MobileJoystickDirection::NorthWest : MobileJoystickDirection::NorthEast;
    }

    return deltaX < 0.0f ? MobileJoystickDirection::SouthWest : MobileJoystickDirection::SouthEast;
}
} // namespace OpenYAMM::Game
