#include "game/app/MobileJoystickDirection.h"

#include <doctest/doctest.h>

namespace OpenYAMM::Game
{
TEST_CASE("mobile joystick quantizes input to eight digital directions")
{
    constexpr float DeadZone = 10.0f;

    CHECK(quantizeMobileJoystickDirection(0.0f, -20.0f, DeadZone) == MobileJoystickDirection::North);
    CHECK(quantizeMobileJoystickDirection(20.0f, -20.0f, DeadZone) == MobileJoystickDirection::NorthEast);
    CHECK(quantizeMobileJoystickDirection(20.0f, 0.0f, DeadZone) == MobileJoystickDirection::East);
    CHECK(quantizeMobileJoystickDirection(20.0f, 20.0f, DeadZone) == MobileJoystickDirection::SouthEast);
    CHECK(quantizeMobileJoystickDirection(0.0f, 20.0f, DeadZone) == MobileJoystickDirection::South);
    CHECK(quantizeMobileJoystickDirection(-20.0f, 20.0f, DeadZone) == MobileJoystickDirection::SouthWest);
    CHECK(quantizeMobileJoystickDirection(-20.0f, 0.0f, DeadZone) == MobileJoystickDirection::West);
    CHECK(quantizeMobileJoystickDirection(-20.0f, -20.0f, DeadZone) == MobileJoystickDirection::NorthWest);
}

TEST_CASE("mobile joystick slightly prefers cardinal directions")
{
    constexpr float DeadZone = 10.0f;

    CHECK(quantizeMobileJoystickDirection(46.0f, -100.0f, DeadZone) == MobileJoystickDirection::North);
    CHECK(quantizeMobileJoystickDirection(50.0f, -100.0f, DeadZone) == MobileJoystickDirection::NorthEast);
    CHECK(quantizeMobileJoystickDirection(100.0f, -46.0f, DeadZone) == MobileJoystickDirection::East);
    CHECK(quantizeMobileJoystickDirection(100.0f, -50.0f, DeadZone) == MobileJoystickDirection::NorthEast);
}

TEST_CASE("mobile joystick retains a radial neutral dead zone")
{
    constexpr float DeadZone = 10.0f;

    CHECK(quantizeMobileJoystickDirection(0.0f, 0.0f, DeadZone) == MobileJoystickDirection::Neutral);
    CHECK(quantizeMobileJoystickDirection(6.0f, 8.0f, DeadZone) == MobileJoystickDirection::Neutral);
    CHECK(quantizeMobileJoystickDirection(6.1f, 8.0f, DeadZone) == MobileJoystickDirection::SouthEast);
}

TEST_CASE("mobile joystick movement speed ramps to full speed at seventy percent travel")
{
    constexpr float Radius = 64.0f;
    constexpr float DeadZone = 10.0f;
    constexpr float FullSpeedRadius = Radius * 0.7f;

    CHECK(mobileJoystickMovementSpeedScale(0.0f, 0.0f, DeadZone, FullSpeedRadius) == doctest::Approx(0.0f));
    CHECK(mobileJoystickMovementSpeedScale(0.0f, -DeadZone, DeadZone, FullSpeedRadius) == doctest::Approx(0.0f));
    CHECK(
        mobileJoystickMovementSpeedScale(0.0f, -27.4f, DeadZone, FullSpeedRadius)
        == doctest::Approx(0.5f));
    CHECK(
        mobileJoystickMovementSpeedScale(0.0f, -FullSpeedRadius, DeadZone, FullSpeedRadius)
        == doctest::Approx(1.0f));
    CHECK(mobileJoystickMovementSpeedScale(Radius, 0.0f, DeadZone, FullSpeedRadius) == doctest::Approx(1.0f));
}
} // namespace OpenYAMM::Game
