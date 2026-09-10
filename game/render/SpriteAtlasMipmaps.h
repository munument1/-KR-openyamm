#pragma once

#include "engine/SpriteAtlas.h"

#include <cstdint>
#include <vector>

namespace OpenYAMM::Game
{
// Sixteen-pixel aligned cells and gutters isolate frames through the 1/16 mip.
// Sampling must clamp its LOD to this limit, including for selection outlines.
constexpr int SpriteAtlasMaxMip = 4;

struct SpriteAtlasMipLevel
{
    int width = 0;
    int height = 0;
    std::vector<uint8_t> baseBgra;
    std::vector<uint8_t> mask;
};

struct SpriteAtlasMipPage
{
    std::unordered_map<std::string, std::array<int, 4>> rectangles;
    std::vector<SpriteAtlasMipLevel> levels;
};

// Repack for GPU sampling only. Source crops, pivots and on-disk atlases stay intact.
// Mask channels use RGBA order; base alpha weights both color and material reduction.
SpriteAtlasMipPage buildSpriteAtlasMipPage(const Engine::SpriteAtlas &atlas, int pageIndex,
    const std::vector<uint8_t> &baseBgra, const std::vector<uint8_t> &maskBgra, int maxTextureSize);
}
