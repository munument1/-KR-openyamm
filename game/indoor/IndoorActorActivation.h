#pragma once

#include "game/events/EvtEnums.h"

#include <cstdint>

namespace OpenYAMM::Game
{
inline uint32_t indoorGeneratedActorAttributes(bool hostileToParty)
{
    return hostileToParty ? static_cast<uint32_t>(EvtActorAttribute::Aggressor) : 0u;
}

inline bool indoorActorHasPreviouslyDetectedParty(uint32_t attributes, bool hostileToParty)
{
    return hostileToParty
        && (attributes & static_cast<uint32_t>(EvtActorAttribute::Nearby)) != 0;
}
}
