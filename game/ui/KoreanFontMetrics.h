#pragma once

#include <algorithm>

namespace OpenYAMM::Game
{
inline float koreanFontEmPixels(int lineHeight)
{
    // Galmuri11 has a 12-pixel em and a 14-pixel line box. Integer multiples
    // preserve its pixel grid. Only exceptionally small lines need downscaling.
    if (lineHeight < 14)
    {
        return static_cast<float>(std::max(1, lineHeight)) * 12.0f / 14.0f;
    }
    return static_cast<float>(lineHeight / 14 * 12);
}
}
