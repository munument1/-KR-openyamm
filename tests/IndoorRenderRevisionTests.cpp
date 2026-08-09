#include "game/indoor/IndoorRenderRevision.h"

#include <doctest/doctest.h>

namespace
{
TEST_CASE("indoor light changes do not invalidate textured geometry")
{
    const OpenYAMM::Game::IndoorRenderRevisions initial =
        OpenYAMM::Game::indoorRenderRevisions(7, 11, 13);
    const OpenYAMM::Game::IndoorRenderRevisions lightChanged =
        OpenYAMM::Game::indoorRenderRevisions(7, 11, 14);

    CHECK_EQ(lightChanged.texturedBatchGeometry, initial.texturedBatchGeometry);
    CHECK_NE(lightChanged.bakedStaticLighting, initial.bakedStaticLighting);
}

TEST_CASE("indoor surface changes still invalidate textured geometry")
{
    const OpenYAMM::Game::IndoorRenderRevisions initial =
        OpenYAMM::Game::indoorRenderRevisions(7, 11, 13);
    const OpenYAMM::Game::IndoorRenderRevisions mapSurfaceChanged =
        OpenYAMM::Game::indoorRenderRevisions(8, 11, 13);
    const OpenYAMM::Game::IndoorRenderRevisions eventSurfaceChanged =
        OpenYAMM::Game::indoorRenderRevisions(7, 12, 13);

    CHECK_NE(mapSurfaceChanged.texturedBatchGeometry, initial.texturedBatchGeometry);
    CHECK_NE(eventSurfaceChanged.texturedBatchGeometry, initial.texturedBatchGeometry);
    CHECK_EQ(mapSurfaceChanged.bakedStaticLighting, initial.bakedStaticLighting);
    CHECK_EQ(eventSurfaceChanged.bakedStaticLighting, initial.bakedStaticLighting);
}
}
