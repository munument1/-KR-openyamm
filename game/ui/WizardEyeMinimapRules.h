#pragma once

namespace OpenYAMM::Game
{
inline bool wizardEyeShowsActorMarker(bool isDead, bool hasDetectedParty, bool hostileToParty)
{
    return isDead || hasDetectedParty || !hostileToParty;
}
}
