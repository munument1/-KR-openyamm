#pragma once

#include <cstdint>
#include <string>

namespace OpenYAMM::Game
{
struct HiredNpcFollower
{
    uint32_t npcId = 0;
    uint32_t professionId = 0;
    uint32_t weeklyCost = 0;
    uint32_t abilityUsedDay = 0;
    std::string name;
    uint32_t pictureId = 0;
};
}
