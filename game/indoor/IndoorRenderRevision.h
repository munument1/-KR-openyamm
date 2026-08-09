#pragma once

#include <cstdint>

namespace OpenYAMM::Game
{
struct IndoorRenderRevisions
{
    uint64_t texturedBatchGeometry = 0;
    uint64_t bakedStaticLighting = 0;
};

inline IndoorRenderRevisions indoorRenderRevisions(
    uint64_t mapSurfaceRevision,
    uint64_t eventSurfaceRevision,
    uint64_t indoorLightRevision)
{
    IndoorRenderRevisions revisions = {};
    revisions.texturedBatchGeometry = mapSurfaceRevision;
    revisions.texturedBatchGeometry ^=
        eventSurfaceRevision
        + 0x9e3779b97f4a7c15ull
        + (revisions.texturedBatchGeometry << 6)
        + (revisions.texturedBatchGeometry >> 2);
    revisions.bakedStaticLighting = indoorLightRevision;
    return revisions;
}
}
