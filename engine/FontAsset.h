#pragma once

#include <array>
#include <cstdint>
#include <optional>
#include <string>
#include <vector>

namespace OpenYAMM::Engine
{
class AssetFileSystem;

struct FontSettings
{
    bool preferTtf = false;
    std::vector<std::string> ttfFonts = {"arrus"};

    bool usesTrueType(const std::string &fontName) const;
    bool operator==(const FontSettings &) const = default;
};

struct FontGlyphMetrics
{
    int leftSpacing = 0;
    int width = 0;
    int rightSpacing = 0;
};

// Geometry and advances stay in legacy logical pixels; only the atlas is supersampled.
struct FontAtlas
{
    int firstChar = 0;
    int lastChar = 0;
    int fontHeight = 0;
    int atlasCellWidth = 0;
    int atlasWidth = 0;
    int atlasHeight = 0;
    int atlasScale = 1;
    int atlasPadding = 0;
    std::array<FontGlyphMetrics, 256> glyphMetrics = {{}};
    std::vector<uint8_t> mainAtlasPixels;
};

struct FontAtlasImage
{
    FontAtlas atlas;
    std::vector<uint8_t> shadowPixels;
};

// A selected TTF requires fonts/truetype/<name>.yml and its font file in the mounted assets.
// The original FNT supplies layout metrics. Invalid selected replacements return an explicit error.
std::optional<FontAtlasImage> loadFontAtlas(
    const AssetFileSystem &assetFileSystem,
    const std::vector<uint8_t> &bitmapBytes,
    const std::string &fontName,
    const FontSettings &settings,
    std::string &error);
}
