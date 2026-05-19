#pragma once

#include "game/app/GameSettings.h"
#include "game/gameplay/GameplayInputFrame.h"

#include <array>
#include <string>

namespace OpenYAMM::Game
{
class GameInputSystem
{
public:
    void handleSdlEvent(const SDL_Event &event);

    void updateFromEngineInput(
        int screenWidth,
        int screenHeight,
        float mouseWheelDelta,
        const GameSettings &settings,
        bool blockGameplayInput = false,
        bool mobileGameplayTouchControlsEnabled = true);

    const GameplayInputFrame &frame() const;
    bool consumeMobileDebugConsoleToggleRequested();
    void resetRelativeMouseMotion();
    void suppressMouseButtonsUntilReleased();

private:
    enum class MobileTouchRole
    {
        None,
        Movement,
        Camera,
        Hud,
        DebugConsoleGesture
    };

    struct MobileTouchPoint
    {
        bool active = false;
        SDL_FingerID fingerId = 0;
        MobileTouchRole role = MobileTouchRole::None;
        float startX = 0.0f;
        float startY = 0.0f;
        float x = 0.0f;
        float y = 0.0f;
        float deltaX = 0.0f;
        float deltaY = 0.0f;
        bool debugConsoleGestureCandidate = false;
        bool debugConsoleGestureTriggered = false;
    };

    GameplayInputFrame m_frame = {};
    std::string m_pendingTextInput;
    std::array<bool, SDL_SCANCODE_COUNT> m_previousKeyboardHeld = {};
    std::array<bool, KeyboardActionCount> m_previousActionHeld = {};
    std::array<MobileTouchPoint, 8> m_mobileTouches = {};
    bool m_mobilePendingHudTap = false;
    float m_mobilePendingHudTapStartX = 0.0f;
    float m_mobilePendingHudTapStartY = 0.0f;
    float m_mobilePendingHudTapX = 0.0f;
    float m_mobilePendingHudTapY = 0.0f;
    bool m_mobilePendingHudRelease = false;
    float m_mobilePendingHudReleaseX = 0.0f;
    float m_mobilePendingHudReleaseY = 0.0f;
    bool m_mobilePendingGameplayTap = false;
    float m_mobilePendingGameplayTapX = 0.0f;
    float m_mobilePendingGameplayTapY = 0.0f;
    bool m_mobilePendingGameplayRelease = false;
    float m_mobilePendingGameplayReleaseX = 0.0f;
    float m_mobilePendingGameplayReleaseY = 0.0f;
    bool m_mobileDebugConsoleToggleRequested = false;
    bool m_previousLeftMouseButtonHeld = false;
    bool m_previousRightMouseButtonHeld = false;
    bool m_previousMiddleMouseButtonHeld = false;
    bool m_suppressLeftMouseButtonUntilReleased = false;
    bool m_suppressRightMouseButtonUntilReleased = false;
    bool m_suppressMiddleMouseButtonUntilReleased = false;
};
} // namespace OpenYAMM::Game
