#include "game/gameplay/GameplayScreenRuntime.h"

namespace OpenYAMM::Game
{
GameplayOverlayInteractionState &GameplayScreenRuntime::interactionState() const
{
    static GameplayOverlayInteractionState interactionState = {};
    return interactionState;
}

const ItemTable *GameplayScreenRuntime::itemTable() const
{
    return nullptr;
}

const StandardItemEnchantTable *GameplayScreenRuntime::standardItemEnchantTable() const
{
    return nullptr;
}

const SpecialItemEnchantTable *GameplayScreenRuntime::specialItemEnchantTable() const
{
    return nullptr;
}

void GameplayScreenRuntime::playSpeechReaction(size_t memberIndex, SpeechId speechId, bool triggerFaceAnimation)
{
    (void)memberIndex;
    (void)speechId;
    (void)triggerFaceAnimation;
}

uint32_t GameplayScreenRuntime::animationTicks() const
{
    return 0;
}

void GameplayScreenRuntime::triggerPortraitFaceAnimation(size_t memberIndex, FaceAnimationId animationId)
{
    (void)memberIndex;
    (void)animationId;
}

void GameplayScreenRuntime::triggerPortraitFaceAnimationForAllLivingMembers(FaceAnimationId animationId)
{
    (void)animationId;
}

void GameplayScreenRuntime::playHouseSound(uint32_t soundId)
{
    (void)soundId;
}

void GameplayScreenRuntime::playCommonUiSound(SoundId soundId)
{
    (void)soundId;
}

void GameplayScreenRuntime::setStatusBarEvent(const std::string &text, float durationSeconds)
{
    (void)text;
    (void)durationSeconds;
}

const GameSettings &GameplayScreenRuntime::settingsSnapshot() const
{
    static GameSettings settings = {};
    return settings;
}

void GameplayScreenRuntime::stopAllAudioPlayback()
{
}
}
