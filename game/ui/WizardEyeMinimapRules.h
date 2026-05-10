#pragma once

namespace OpenYAMM::Game
{
inline bool wizardEyeShowsActorMarker(bool isDead, bool hasDetectedParty)
{
    return isDead || hasDetectedParty;
}
}
