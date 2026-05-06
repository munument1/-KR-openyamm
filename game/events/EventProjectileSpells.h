#pragma once

#include <cstdint>

namespace OpenYAMM::Game
{
struct EventProjectileSpellDefinition
{
    uint32_t spellId = 0;
    int objectId = 0;
    int impactObjectId = 0;
};

inline const EventProjectileSpellDefinition *eventProjectileSpellDefinition(uint32_t spellId)
{
    // MMerge spell definitions stay authoritative; this is an MM8 event projectile id used by evt.CastSpell.
    static constexpr EventProjectileSpellDefinition CannonballDefinition = {
        136,
        560,
        601,
    };

    return spellId == CannonballDefinition.spellId ? &CannonballDefinition : nullptr;
}
}
