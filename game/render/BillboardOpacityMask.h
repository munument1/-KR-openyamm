#pragma once

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <vector>

namespace OpenYAMM::Game
{
class BillboardOpacityMask
{
public:
    void assignFromBgra(const std::vector<uint8_t> &pixels, int width, int height)
    {
        assignFromBgraRegion(pixels, width, height, 0, 0, width, height);
    }

    void assignFromBgraRegion(const std::vector<uint8_t> &pixels, int sourceWidth, int sourceHeight,
        int originX, int originY, int width, int height)
    {
        m_width = 0;
        m_height = 0;
        m_opaqueTop = 0;
        m_hasOpaquePixel = false;
        m_bits.clear();

        if (width <= 0 || height <= 0 || sourceWidth < width || sourceHeight < height
            || originX < 0 || originY < 0 || originX > sourceWidth - width || originY > sourceHeight - height)
        {
            return;
        }

        const size_t pixelCount = static_cast<size_t>(width) * static_cast<size_t>(height);

        if (pixels.size() / 4 < size_t(sourceWidth) * sourceHeight)
        {
            return;
        }

        m_width = width;
        m_height = height;
        m_bits.assign((pixelCount + 7) / 8, 0);

        for (int y = 0; y < height; ++y)
        {
            const uint8_t *pRow = pixels.data() + (size_t(originY + y) * sourceWidth + originX) * 4;
            for (int x = 0; x < width; ++x)
            {
                if (pRow[size_t(x) * 4 + 3] != 0)
                {
                    const size_t pixelIndex = size_t(y) * width + x;
                    m_bits[pixelIndex / 8] |= uint8_t(1u << (pixelIndex % 8));
                    if (!m_hasOpaquePixel)
                    {
                        m_opaqueTop = y;
                        m_hasOpaquePixel = true;
                    }
                }
            }
        }
    }

    bool empty() const
    {
        return m_bits.empty();
    }

    size_t byteSize() const
    {
        return m_bits.size();
    }

    bool isOpaque(int x, int y) const
    {
        if (m_bits.empty() || m_width <= 0 || m_height <= 0)
        {
            return true;
        }

        if (x < 0 || x >= m_width || y < 0 || y >= m_height)
        {
            return false;
        }

        const size_t pixelIndex = static_cast<size_t>(y) * static_cast<size_t>(m_width) + static_cast<size_t>(x);
        return (m_bits[pixelIndex / 8] & static_cast<uint8_t>(1u << (pixelIndex % 8))) != 0;
    }

    bool isOpaqueNormalized(float normalizedU, float normalizedV) const
    {
        if (m_bits.empty() || m_width <= 0 || m_height <= 0)
        {
            return true;
        }

        const int x = std::clamp(
            static_cast<int>(std::floor(normalizedU * static_cast<float>(m_width))),
            0,
            m_width - 1);
        const int y = std::clamp(
            static_cast<int>(std::floor(normalizedV * static_cast<float>(m_height))),
            0,
            m_height - 1);
        return isOpaque(x, y);
    }

    float opaqueTopNormalized() const
    {
        if (!m_hasOpaquePixel || m_height <= 0)
        {
            return 0.0f;
        }
        return static_cast<float>(m_opaqueTop) / static_cast<float>(m_height);
    }

private:
    int m_width = 0;
    int m_height = 0;
    int m_opaqueTop = 0;
    bool m_hasOpaquePixel = false;
    std::vector<uint8_t> m_bits;
};
}
