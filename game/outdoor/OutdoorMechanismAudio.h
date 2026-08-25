#pragma once

#include <cstdint>
#include <string>

namespace OpenYAMM::Game
{
struct OutdoorMechanismAudioProfile
{
    std::string openSound;
    std::string closeSound;
    std::string openStartSound;
    std::string openBusySound;
    std::string openStopSound;
    std::string closeStartSound;
    std::string closeBusySound;
    std::string closeStopSound;
    std::string jiggleSound;
    int32_t x = 0;
    int32_t y = 0;
    int32_t z = 0;
    bool positional = false;
};
}
