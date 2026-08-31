#include "game/mm9/Mm9PrimaryStats.h"

#include "game/party/Party.h"

namespace OpenYAMM::Game
{
uint32_t *mm9PrimaryStatStorage(Character &character, Mm9PrimaryStat stat)
{
    switch (stat)
    {
        case Mm9PrimaryStat::Might: return &character.might;
        case Mm9PrimaryStat::Magic: return &character.intellect;
        case Mm9PrimaryStat::Endurance: return &character.endurance;
        case Mm9PrimaryStat::Accuracy: return &character.accuracy;
        case Mm9PrimaryStat::Speed: return &character.speed;
        case Mm9PrimaryStat::Luck: return &character.luck;
    }
    return nullptr;
}

std::string_view mm9PrimaryStatName(Mm9PrimaryStat stat)
{
    switch (stat)
    {
        case Mm9PrimaryStat::Might: return "Might";
        case Mm9PrimaryStat::Magic: return "Magic";
        case Mm9PrimaryStat::Endurance: return "Endurance";
        case Mm9PrimaryStat::Accuracy: return "Accuracy";
        case Mm9PrimaryStat::Speed: return "Speed";
        case Mm9PrimaryStat::Luck: return "Luck";
    }
    return {};
}

bool addMm9PermanentPrimaryStat(Character &character, Mm9PrimaryStat stat, uint32_t amount, uint32_t maximum)
{
    uint32_t *pValue = mm9PrimaryStatStorage(character, stat);
    if (pValue == nullptr || *pValue > maximum || amount > maximum - *pValue)
    {
        return false;
    }
    *pValue += amount;
    return true;
}
}
