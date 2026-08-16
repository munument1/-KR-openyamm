#pragma once

#include <cstdint>

namespace OpenYAMM::Game
{
class MobileJumpDoubleTapGesture
{
public:
    bool registerCameraTap(uint64_t timestampNanoseconds, float logicalX, float logicalY)
    {
        constexpr uint64_t MaxTapIntervalNanoseconds = 300'000'000ULL;
        constexpr float MaxTapDistance = 48.0f;
        constexpr float MaxTapDistanceSquared = MaxTapDistance * MaxTapDistance;

        const float deltaX = logicalX - m_firstTapLogicalX;
        const float deltaY = logicalY - m_firstTapLogicalY;
        const float distanceSquared = deltaX * deltaX + deltaY * deltaY;
        const bool completesDoubleTap =
            m_firstTapActive
            && timestampNanoseconds >= m_firstTapTimestampNanoseconds
            && timestampNanoseconds - m_firstTapTimestampNanoseconds <= MaxTapIntervalNanoseconds
            && distanceSquared <= MaxTapDistanceSquared;

        if (completesDoubleTap)
        {
            cancel();
            return true;
        }

        m_firstTapActive = true;
        m_firstTapTimestampNanoseconds = timestampNanoseconds;
        m_firstTapLogicalX = logicalX;
        m_firstTapLogicalY = logicalY;
        return false;
    }

    void cancel()
    {
        m_firstTapActive = false;
        m_firstTapTimestampNanoseconds = 0;
        m_firstTapLogicalX = 0.0f;
        m_firstTapLogicalY = 0.0f;
    }

private:
    bool m_firstTapActive = false;
    uint64_t m_firstTapTimestampNanoseconds = 0;
    float m_firstTapLogicalX = 0.0f;
    float m_firstTapLogicalY = 0.0f;
};
} // namespace OpenYAMM::Game
