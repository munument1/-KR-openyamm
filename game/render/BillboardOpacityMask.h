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
        m_width = 0;
        m_height = 0;
        m_bits.clear();

        if (width <= 0 || height <= 0)
        {
            return;
        }

        const size_t pixelCount = static_cast<size_t>(width) * static_cast<size_t>(height);

        if (pixels.size() < pixelCount * 4)
        {
            return;
        }

        m_width = width;
        m_height = height;
        m_bits.assign((pixelCount + 7) / 8, 0);

        for (size_t pixelIndex = 0; pixelIndex < pixelCount; ++pixelIndex)
        {
            if (pixels[pixelIndex * 4 + 3] != 0)
            {
                m_bits[pixelIndex / 8] |= static_cast<uint8_t>(1u << (pixelIndex % 8));
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

private:
    int m_width = 0;
    int m_height = 0;
    std::vector<uint8_t> m_bits;
};
}
