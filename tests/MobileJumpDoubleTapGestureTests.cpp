#include "game/app/MobileJumpDoubleTapGesture.h"

#include <doctest/doctest.h>

namespace OpenYAMM::Game
{
TEST_CASE("mobile jump gesture recognizes two nearby camera taps")
{
    MobileJumpDoubleTapGesture gesture;

    CHECK_FALSE(gesture.registerCameraTap(1'000'000'000ULL, 500.0f, 220.0f));
    CHECK(gesture.registerCameraTap(1'250'000'000ULL, 530.0f, 250.0f));
    CHECK_FALSE(gesture.registerCameraTap(1'300'000'000ULL, 530.0f, 250.0f));
}

TEST_CASE("mobile jump gesture rejects taps that are too slow")
{
    MobileJumpDoubleTapGesture gesture;

    CHECK_FALSE(gesture.registerCameraTap(1'000'000'000ULL, 500.0f, 220.0f));
    CHECK_FALSE(gesture.registerCameraTap(1'300'000'001ULL, 500.0f, 220.0f));
    CHECK(gesture.registerCameraTap(1'500'000'000ULL, 500.0f, 220.0f));
}

TEST_CASE("mobile jump gesture rejects taps that are too far apart")
{
    MobileJumpDoubleTapGesture gesture;

    CHECK_FALSE(gesture.registerCameraTap(1'000'000'000ULL, 500.0f, 220.0f));
    CHECK_FALSE(gesture.registerCameraTap(1'200'000'000ULL, 560.0f, 220.0f));
    CHECK(gesture.registerCameraTap(1'400'000'000ULL, 560.0f, 220.0f));
}

TEST_CASE("mobile jump gesture cancellation discards the first tap")
{
    MobileJumpDoubleTapGesture gesture;

    CHECK_FALSE(gesture.registerCameraTap(1'000'000'000ULL, 500.0f, 220.0f));
    gesture.cancel();
    CHECK_FALSE(gesture.registerCameraTap(1'200'000'000ULL, 500.0f, 220.0f));
}
} // namespace OpenYAMM::Game
