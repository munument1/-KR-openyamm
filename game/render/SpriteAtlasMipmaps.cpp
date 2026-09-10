#include "game/render/SpriteAtlasMipmaps.h"

#include <algorithm>
#include <map>
#include <stdexcept>

namespace OpenYAMM::Game
{
namespace
{
constexpr int CellAlignment = 1 << SpriteAtlasMaxMip;

int alignCell(int value)
{
    return (value + CellAlignment - 1) / CellAlignment * CellAlignment;
}

struct Cell
{
    std::array<int, 4> source;
    std::vector<std::string> names;
    int x = 0;
    int y = 0;
    int width = 0;
    int height = 0;
};

// Supply one transparent texel of edge colors at each mip for bilinear filtering.
// Read only nonzero-alpha neighbors within the same cell; alpha never changes.
void bleedMipEdges(SpriteAtlasMipLevel &level, const std::vector<Cell> &cells, int mip, int channels)
{
    for (const Cell &cell : cells)
    {
        const int left = cell.x >> mip;
        const int top = cell.y >> mip;
        const int right = (cell.x + cell.width) >> mip;
        const int bottom = (cell.y + cell.height) >> mip;
        for (int y = top; y < bottom; ++y)
        {
            for (int x = left; x < right; ++x)
            {
                const size_t pixel = size_t(y) * level.width + x;
                if (level.baseBgra[pixel * 4 + 3] != 0)
                {
                    continue;
                }
                uint32_t weight = 0;
                std::array<uint32_t, 3> color = {};
                std::array<uint32_t, 4> mask = {};
                for (int sy = std::max(top, y - 1); sy <= std::min(bottom - 1, y + 1); ++sy)
                {
                    for (int sx = std::max(left, x - 1); sx <= std::min(right - 1, x + 1); ++sx)
                    {
                        const size_t source = size_t(sy) * level.width + sx;
                        const uint32_t alpha = level.baseBgra[source * 4 + 3];
                        weight += alpha;
                        for (int c = 0; c < 3; ++c)
                        {
                            color[c] += level.baseBgra[source * 4 + c] * alpha;
                        }
                        for (int c = 0; c < channels; ++c)
                        {
                            mask[c] += level.mask[source * channels + c] * alpha;
                        }
                    }
                }
                if (weight != 0)
                {
                    for (int c = 0; c < 3; ++c)
                    {
                        level.baseBgra[pixel * 4 + c] = (color[c] + weight / 2) / weight;
                    }
                    for (int c = 0; c < channels; ++c)
                    {
                        // Floor keeps the sum of material weights at or below 255.
                        level.mask[pixel * channels + c] = mask[c] / weight;
                    }
                }
            }
        }
    }
}
}

SpriteAtlasMipPage buildSpriteAtlasMipPage(const Engine::SpriteAtlas &atlas, int pageIndex,
    const std::vector<uint8_t> &baseBgra, const std::vector<uint8_t> &maskBgra, int maxTextureSize)
{
    const Engine::SpriteAtlasPage &page = atlas.pages.at(pageIndex);
    const size_t bytes = size_t(page.size[0]) * page.size[1] * 4;
    const int channels = atlas.maskChannels;
    if (baseBgra.size() != bytes || maskBgra.size() != bytes || (channels != 1 && channels != 2 && channels != 4))
    {
        throw std::invalid_argument("Invalid sprite mip source dimensions or channels");
    }
    std::map<std::array<int, 4>, std::vector<std::string>> sources;
    for (const auto &[name, frame] : atlas.frames)
    {
        if (frame.page == pageIndex)
        {
            sources[frame.rectangle].push_back(name);
        }
    }
    std::vector<Cell> cells;
    for (const auto &[rect, names] : sources)
    {
        cells.push_back({rect, names, 0, 0,
            alignCell(rect[2]) + 2 * CellAlignment, alignCell(rect[3]) + 2 * CellAlignment});
    }
    if (cells.empty())
    {
        throw std::invalid_argument("Sprite mip page has no frames");
    }
    std::sort(cells.begin(), cells.end(), [](const Cell &a, const Cell &b)
    {
        return a.height != b.height ? a.height > b.height : a.source < b.source;
    });
    maxTextureSize = maxTextureSize / CellAlignment * CellAlignment;
    int width = alignCell(page.size[0]);
    for (const Cell &cell : cells)
    {
        width = std::max(width, cell.width);
    }
    int height = 0;
    int usedWidth = 0;
    for (;;)
    {
        if (width > maxTextureSize)
        {
            throw std::runtime_error("Sprite mip atlas exceeds GPU texture size limit");
        }
        int x = 0;
        int y = 0;
        int rowHeight = 0;
        usedWidth = 0;
        for (Cell &cell : cells)
        {
            if (x + cell.width > width)
            {
                y += rowHeight;
                x = 0;
                rowHeight = 0;
            }
            cell.x = x;
            cell.y = y;
            x += cell.width;
            rowHeight = std::max(rowHeight, cell.height);
            usedWidth = std::max(usedWidth, x);
        }
        height = y + rowHeight;
        if (height <= maxTextureSize)
        {
            break;
        }
        if (width == maxTextureSize)
        {
            throw std::runtime_error("Sprite mip atlas cannot fit GPU texture size limit");
        }
        width = std::min(maxTextureSize, width * 2);
    }
    SpriteAtlasMipPage result;
    SpriteAtlasMipLevel level;
    level.width = usedWidth;
    level.height = height;
    level.baseBgra.resize(size_t(usedWidth) * height * 4);
    level.mask.resize(size_t(usedWidth) * height * channels);
    constexpr std::array<int, 4> bgraChannels = {2, 1, 0, 3};
    for (const Cell &cell : cells)
    {
        for (const std::string &name : cell.names)
        {
            result.rectangles[name] = {cell.x + CellAlignment, cell.y + CellAlignment,
                cell.source[2], cell.source[3]};
        }
        for (int y = 0; y < cell.height; ++y)
        {
            const int sy = cell.source[1] + std::clamp(y - CellAlignment, 0, cell.source[3] - 1);
            for (int x = 0; x < cell.width; ++x)
            {
                const int sx = cell.source[0] + std::clamp(x - CellAlignment, 0, cell.source[2] - 1);
                const size_t source = size_t(sy) * page.size[0] + sx;
                const size_t target = size_t(cell.y + y) * usedWidth + cell.x + x;
                std::copy_n(&baseBgra[source * 4], 4, &level.baseBgra[target * 4]);
                for (int c = 0; c < channels; ++c)
                {
                    level.mask[target * channels + c] = maskBgra[source * 4 + bgraChannels[c]];
                }
            }
        }
    }
    result.levels.push_back(std::move(level));
    for (int mip = 1; mip <= SpriteAtlasMaxMip; ++mip)
    {
        const SpriteAtlasMipLevel &source = result.levels.back();
        SpriteAtlasMipLevel target;
        target.width = source.width / 2;
        target.height = source.height / 2;
        target.baseBgra.resize(size_t(target.width) * target.height * 4);
        target.mask.resize(size_t(target.width) * target.height * channels);
        for (int y = 0; y < target.height; ++y)
        {
            for (int x = 0; x < target.width; ++x)
            {
                uint32_t alpha = 0;
                std::array<uint32_t, 3> color = {};
                std::array<uint32_t, 3> transparentColor = {};
                std::array<uint32_t, 4> mask = {};
                std::array<uint32_t, 4> transparentMask = {};
                for (int dy = 0; dy < 2; ++dy)
                {
                    for (int dx = 0; dx < 2; ++dx)
                    {
                        const size_t pixel = size_t(2 * y + dy) * source.width + 2 * x + dx;
                        const uint32_t a = source.baseBgra[pixel * 4 + 3];
                        alpha += a;
                        for (int c = 0; c < 3; ++c)
                        {
                            color[c] += source.baseBgra[pixel * 4 + c] * a;
                            transparentColor[c] += source.baseBgra[pixel * 4 + c];
                        }
                        for (int c = 0; c < channels; ++c)
                        {
                            mask[c] += source.mask[pixel * channels + c] * a;
                            transparentMask[c] += source.mask[pixel * channels + c];
                        }
                    }
                }
                const size_t pixel = size_t(y) * target.width + x;
                target.baseBgra[pixel * 4 + 3] = (alpha + 2) / 4;
                for (int c = 0; c < 3; ++c)
                {
                    target.baseBgra[pixel * 4 + c] = alpha != 0
                        ? (color[c] + alpha / 2) / alpha : (transparentColor[c] + 2) / 4;
                }
                for (int c = 0; c < channels; ++c)
                {
                    target.mask[pixel * channels + c] = alpha != 0 ? mask[c] / alpha : transparentMask[c] / 4;
                }
            }
        }
        bleedMipEdges(target, cells, mip, channels);
        result.levels.push_back(std::move(target));
    }
    return result;
}
}
