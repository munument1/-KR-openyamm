#pragma once

#include "game/fx/ParticleSystem.h"
#include "game/render/lighting/RenderLight.h"

#include <cstdint>
#include <unordered_map>
#include <unordered_set>
#include <vector>

namespace OpenYAMM::Game
{
class GameSession;
struct PartySpellCastResult;

struct WorldFxGlowBillboard
{
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
    float radius = 0.0f;
    uint32_t colorAbgr = 0xffffffffu;
    bool renderVisibleBillboard = true;
};

struct WorldFxLightEmitter
{
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
    float radius = 0.0f;
    uint32_t colorAbgr = 0xffffffffu;
    float intensity = 1.0f;
    int16_t sectorId = -1;
    RenderLightKind kind = RenderLightKind::GenericFx;
    uint32_t stableId = 0;
    bool important = false;
};

struct WorldFxContactShadow
{
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
    float radius = 0.0f;
    uint32_t colorAbgr = 0x50000000u;
};

struct WorldFxSegmentProjectile
{
    float startX = 0.0f;
    float startY = 0.0f;
    float startZ = 0.0f;
    float endX = 0.0f;
    float endY = 0.0f;
    float endZ = 0.0f;
    float width = 0.0f;
    uint32_t colorAbgr = 0xffffffffu;
};

class WorldFxSystem
{
public:
    void reset();
    void beginFrame();
    void updateParticles(float deltaSeconds, bool paused);
    void syncProjectileFx(GameSession &session, float deltaSeconds, bool refreshSpatialFx);
    void triggerPartySpellFx(const PartySpellCastResult &result);
    void setShadowsEnabled(bool enabled);
    void spawnActorDebuffFx(
        uint32_t spellId,
        uint32_t seed,
        float x,
        float y,
        float z,
        float actorHeight,
        float frontDirectionX,
        float frontDirectionY);
    void spawnActorBuffFx(
        uint32_t spellId,
        uint32_t seed,
        float x,
        float y,
        float z,
        float actorHeight,
        float frontDirectionX,
        float frontDirectionY);

    void clearSpatialFx();
    void addContactShadow(float x, float y, float z, float radius, uint32_t colorAbgr = 0x50000000u);
    void addSegmentProjectile(
        float startX,
        float startY,
        float startZ,
        float endX,
        float endY,
        float endZ,
        float width,
        uint32_t colorAbgr);
    void addGlowBillboard(
        float x,
        float y,
        float z,
        float radius,
        uint32_t colorAbgr,
        bool renderVisibleBillboard = true);
    void addLightEmitter(
        float x,
        float y,
        float z,
        float radius,
        uint32_t colorAbgr,
        int16_t sectorId = -1,
        RenderLightKind kind = RenderLightKind::GenericFx,
        uint32_t stableId = 0,
        bool important = false);

    ParticleSystem &particles();
    const ParticleSystem &particles() const;
    const std::vector<WorldFxGlowBillboard> &glowBillboards() const;
    const std::vector<WorldFxLightEmitter> &lightEmitters() const
    {
        return m_lightEmitters;
    }
    const std::vector<WorldFxContactShadow> &contactShadows() const;
    const std::vector<WorldFxSegmentProjectile> &segmentProjectiles() const;

private:
    struct ProjectileFxTrailState
    {
        bool hasPreviousPosition = false;
        float previousX = 0.0f;
        float previousY = 0.0f;
        float previousZ = 0.0f;
        float cooldownSeconds = 0.0f;
    };

    struct PersistentImpactLight
    {
        float x = 0.0f;
        float y = 0.0f;
        float z = 0.0f;
        float radius = 0.0f;
        float elapsedSeconds = 0.0f;
        float durationSeconds = 0.0f;
        uint32_t colorAbgr = 0xffffffffu;
        int16_t sectorId = -1;
    };

    void updateProjectileTrailCooldowns(float deltaSeconds);
    void updatePersistentImpactLights(float deltaSeconds);
    void emitPersistentImpactLights(bool refreshSpatialFx);
    void syncProjectileTrails(GameSession &session, bool refreshSpatialFx);
    void syncProjectileImpacts(GameSession &session);
    void cleanupSeenProjectileImpactIds(GameSession &session);

    float m_particleUpdateAccumulatorSeconds = 0.0f;
    ParticleSystem m_particleSystem;
    std::vector<WorldFxGlowBillboard> m_glowBillboards;
    std::vector<WorldFxLightEmitter> m_lightEmitters;
    std::vector<WorldFxContactShadow> m_contactShadows;
    std::vector<WorldFxSegmentProjectile> m_segmentProjectiles;
    std::unordered_map<uint32_t, ProjectileFxTrailState> m_projectileTrailStates;
    std::unordered_map<uint32_t, PersistentImpactLight> m_persistentImpactLights;
    std::unordered_set<uint32_t> m_seenImpactIds;
    bool m_shadowsEnabled = false;
};
}
