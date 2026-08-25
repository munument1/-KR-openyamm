#pragma once

#include <bx/math.h>

namespace OpenYAMM::Game
{
inline bx::Vec3 bottomAnchoredBillboardCenter(
    float x,
    float y,
    float z,
    const bx::Vec3 &cameraUp,
    float worldHeight)
{
    const float halfHeight = worldHeight * 0.5f;

    return {
        x + cameraUp.x * halfHeight,
        y + cameraUp.y * halfHeight,
        z + cameraUp.z * halfHeight,
    };
}
}
