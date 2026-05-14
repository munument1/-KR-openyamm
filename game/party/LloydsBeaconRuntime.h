#pragma once

#include "game/party/SkillData.h"

#include <cstddef>
#include <cstdint>
#include <string>

namespace OpenYAMM::Game
{
struct Character;

size_t lloydsBeaconMaxSlotsForMastery(SkillMastery mastery);
size_t lloydsBeaconMaxSlotsForCharacter(const Character *pCharacter);
bool lloydsBeaconHasRecallableBeacon(const Character *pCharacter);
float lloydsBeaconDurationSeconds(uint32_t waterSkillLevel);
std::string lloydsBeaconRemainingDurationText(float remainingSeconds);
}
