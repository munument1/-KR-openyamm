#pragma once

#include <cstdint>

namespace OpenYAMM::Game
{
struct HiredNpcFollower
{
    uint32_t npcId = 0;
    uint32_t professionId = 0;
    uint32_t weeklyCost = 0;
    uint32_t abilityUsedDay = 0;
};
}
