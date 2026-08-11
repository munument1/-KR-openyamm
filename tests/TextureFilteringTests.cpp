#include "game/render/TextureFiltering.h"

#include <doctest/doctest.h>

#include <cstdint>
#include <vector>

using namespace OpenYAMM::Game;

TEST_CASE("Billboard upload preparation fills transparent edge colors without changing alpha")
{
    std::vector<uint8_t> pixels = {
        20, 40, 60, 255,
        0, 0, 0, 0,
        90, 110, 130, 255,
    };

    const bool prepared = prepareBgraTexturePixelsForUploadInPlace(
        3,
        1,
        pixels,
        TextureFilterProfile::Billboard);

    CHECK(prepared);
    CHECK(pixels[4] == 20);
    CHECK(pixels[5] == 40);
    CHECK(pixels[6] == 60);
    CHECK(pixels[7] == 0);
}

TEST_CASE("Upload preparation leaves profiles without transparent edge bleeding unchanged")
{
    std::vector<uint8_t> pixels = {
        20, 40, 60, 255,
        0, 0, 0, 0,
    };
    const std::vector<uint8_t> originalPixels = pixels;

    const bool prepared = prepareBgraTexturePixelsForUploadInPlace(
        2,
        1,
        pixels,
        TextureFilterProfile::BModel);

    CHECK_FALSE(prepared);
    CHECK(pixels == originalPixels);
}
