#pragma once

#include <cstdint>
#include <string_view>

namespace OpenYAMM::Game
{
struct Character;

enum class Mm9PrimaryStat : uint8_t
{
    Might,
    Magic,
    Endurance,
    Accuracy,
    Speed,
    Luck,
};

uint32_t *mm9PrimaryStatStorage(Character &character, Mm9PrimaryStat stat);
std::string_view mm9PrimaryStatName(Mm9PrimaryStat stat);
bool addMm9PermanentPrimaryStat(Character &character, Mm9PrimaryStat stat, uint32_t amount, uint32_t maximum);
}
