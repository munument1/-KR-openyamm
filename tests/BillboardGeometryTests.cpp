#include "doctest/doctest.h"

#include "game/render/BillboardGeometry.h"

TEST_CASE("bottom-anchored billboard keeps its lower edge at the world position")
{
    const bx::Vec3 cameraUp = {0.0f, -0.6f, 0.8f};
    const bx::Vec3 center = OpenYAMM::Game::bottomAnchoredBillboardCenter(
        10.0f,
        20.0f,
        30.0f,
        cameraUp,
        200.0f);
    const bx::Vec3 lowerEdgeCenter = {
        center.x - cameraUp.x * 100.0f,
        center.y - cameraUp.y * 100.0f,
        center.z - cameraUp.z * 100.0f,
    };

    CHECK_EQ(lowerEdgeCenter.x, doctest::Approx(10.0f));
    CHECK_EQ(lowerEdgeCenter.y, doctest::Approx(20.0f));
    CHECK_EQ(lowerEdgeCenter.z, doctest::Approx(30.0f));
}
