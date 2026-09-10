#pragma once

#include <array>
#include <optional>
#include <string>
#include <unordered_map>
#include <vector>

namespace OpenYAMM::Engine
{
struct SpriteAtlasPage
{
    std::string base;
    std::string mask;
    std::array<int, 2> size = {};
};

struct SpriteAtlasFrame
{
    int page = 0;
    std::array<int, 4> rectangle = {};
    std::array<int, 2> cropOrigin = {};
};

struct SpriteAtlasVariant
{
    // RGB ramp; w=0 bypass, w=1 green chroma, w=2 luminance, w=3 two-region, w=4 four-region luminance.
    std::array<float, 4> chroma = {};
    std::array<float, 4> secondChroma = {};
    std::array<float, 4> thirdChroma = {};
    std::array<float, 4> fourthChroma = {};
};

struct SpriteAtlas
{
    float pixelsPerLogicalPixel = 1.0f;
    int maskChannels = 1;
    std::array<int, 2> logicalCanvas = {};
    std::array<float, 2> logicalPivot = {};
    std::vector<SpriteAtlasPage> pages;
    std::unordered_map<std::string, SpriteAtlasFrame> frames;
    std::unordered_map<int, SpriteAtlasVariant> variants;

    static std::optional<SpriteAtlas> parse(const std::string &text, std::string &error);
};

struct SpriteAtlasReference
{
    std::string package;
    std::string frame;
};

// Explicit opt-in; native texture names never probe the enhanced asset directory.
std::optional<SpriteAtlasReference> parseSpriteAtlasReference(const std::string &name);
}
