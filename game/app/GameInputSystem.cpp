#include "game/app/GameInputSystem.h"

#include <SDL3/SDL.h>

#include <algorithm>
#include <cmath>
#include <cstring>
#include <utility>

namespace OpenYAMM::Game
{
namespace
{
constexpr float MobileLogicalHeight = 480.0f;
constexpr float MobileMovementZoneX = 0.0f;
constexpr float MobileMovementZoneY = 160.0f;
constexpr float MobileMovementZoneWidth = 300.0f;
constexpr float MobileMovementZoneHeight = 320.0f;
constexpr float MobileCameraZoneX = 300.0f;
constexpr float MobileJoystickRadius = 64.0f;
constexpr float MobileJoystickDeadZone = 10.0f;
constexpr float MobileGameplayTapMaxNormalizedDistanceSquared = 0.000225f;
constexpr float MobileDebugConsoleGestureTopEdgeNormalized = 0.055f;
constexpr float MobileDebugConsoleGestureMinDragNormalized = 0.14f;
constexpr float MobileDebugConsoleGestureMaxHorizontalNormalized = 0.09f;

GameplayButtonInputState buildButtonState(bool held, bool previousHeld)
{
    GameplayButtonInputState state = {};
    state.held = held;
    state.pressed = held && !previousHeld;
    state.released = !held && previousHeld;
    return state;
}

float mobileLogicalScale(int screenHeight)
{
    return screenHeight > 0 ? static_cast<float>(screenHeight) / MobileLogicalHeight : 1.0f;
}

bool pointInsideRect(float x, float y, float rectX, float rectY, float rectWidth, float rectHeight)
{
    return x >= rectX && y >= rectY && x <= rectX + rectWidth && y <= rectY + rectHeight;
}

void suppressButtonWhileHeld(bool physicalHeld, bool &logicalHeld, bool &suppressUntilReleased)
{
    if (!suppressUntilReleased)
    {
        return;
    }

    if (physicalHeld)
    {
        logicalHeld = false;
        return;
    }

    suppressUntilReleased = false;
}

} // namespace

void GameInputSystem::handleSdlEvent(const SDL_Event &event)
{
    if (event.type == SDL_EVENT_TEXT_INPUT)
    {
        if (event.text.text != nullptr)
        {
            m_pendingTextInput.append(event.text.text, std::strlen(event.text.text));
        }

        return;
    }

#if defined(__ANDROID__)
    const auto findTouch =
        [this](SDL_FingerID fingerId) -> MobileTouchPoint *
        {
            for (MobileTouchPoint &touch : m_mobileTouches)
            {
                if (touch.active && touch.fingerId == fingerId)
                {
                    return &touch;
                }
            }

            return nullptr;
        };

    if (event.type == SDL_EVENT_FINGER_DOWN)
    {
        MobileTouchPoint *pTouch = findTouch(event.tfinger.fingerID);

        if (pTouch == nullptr)
        {
            for (MobileTouchPoint &candidate : m_mobileTouches)
            {
                if (!candidate.active)
                {
                    pTouch = &candidate;
                    break;
                }
            }
        }

        if (pTouch == nullptr)
        {
            return;
        }

        *pTouch = {};
        pTouch->active = true;
        pTouch->fingerId = event.tfinger.fingerID;
        pTouch->startX = event.tfinger.x;
        pTouch->startY = event.tfinger.y;
        pTouch->x = event.tfinger.x;
        pTouch->y = event.tfinger.y;
        pTouch->debugConsoleGestureCandidate =
            event.tfinger.y >= 0.0f && event.tfinger.y <= MobileDebugConsoleGestureTopEdgeNormalized;
        return;
    }

    if (event.type == SDL_EVENT_FINGER_MOTION)
    {
        MobileTouchPoint *pTouch = findTouch(event.tfinger.fingerID);

        if (pTouch == nullptr)
        {
            return;
        }

        pTouch->deltaX += event.tfinger.x - pTouch->x;
        pTouch->deltaY += event.tfinger.y - pTouch->y;
        pTouch->x = event.tfinger.x;
        pTouch->y = event.tfinger.y;

        if (pTouch->debugConsoleGestureCandidate && !pTouch->debugConsoleGestureTriggered)
        {
            const float dragX = event.tfinger.x - pTouch->startX;
            const float dragY = event.tfinger.y - pTouch->startY;

            if (dragY >= MobileDebugConsoleGestureMinDragNormalized
                && std::abs(dragX) <= MobileDebugConsoleGestureMaxHorizontalNormalized)
            {
                pTouch->role = MobileTouchRole::DebugConsoleGesture;
                pTouch->debugConsoleGestureTriggered = true;
                m_mobilePendingHudTap = false;
                m_mobilePendingHudRelease = false;
                m_mobilePendingGameplayTap = false;
                m_mobilePendingGameplayRelease = false;
                m_mobileDebugConsoleToggleRequested = true;
            }
        }

        return;
    }

    if (event.type == SDL_EVENT_FINGER_UP || event.type == SDL_EVENT_FINGER_CANCELED)
    {
        MobileTouchPoint *pTouch = findTouch(event.tfinger.fingerID);

        if (pTouch != nullptr)
        {
            if (pTouch->role == MobileTouchRole::Hud)
            {
                m_mobilePendingHudRelease = true;
                m_mobilePendingHudReleaseX = event.tfinger.x;
                m_mobilePendingHudReleaseY = event.tfinger.y;
            }
            else if (pTouch->role == MobileTouchRole::Camera)
            {
                const float deltaX = event.tfinger.x - pTouch->startX;
                const float deltaY = event.tfinger.y - pTouch->startY;
                const float distanceSquared = deltaX * deltaX + deltaY * deltaY;

                if (distanceSquared <= MobileGameplayTapMaxNormalizedDistanceSquared)
                {
                    m_mobilePendingGameplayTap = true;
                    m_mobilePendingGameplayTapX = event.tfinger.x;
                    m_mobilePendingGameplayTapY = event.tfinger.y;
                }
            }
            else if (pTouch->role == MobileTouchRole::None)
            {
                m_mobilePendingHudTap = true;
                m_mobilePendingHudTapStartX = pTouch->startX;
                m_mobilePendingHudTapStartY = pTouch->startY;
                m_mobilePendingHudTapX = event.tfinger.x;
                m_mobilePendingHudTapY = event.tfinger.y;
            }

            *pTouch = {};
        }
    }
#else
    (void)event;
#endif
}

bool GameInputSystem::consumeMobileDebugConsoleToggleRequested()
{
    const bool requested = m_mobileDebugConsoleToggleRequested;
    m_mobileDebugConsoleToggleRequested = false;
    return requested;
}

void GameInputSystem::updateFromEngineInput(
    int screenWidth,
    int screenHeight,
    float mouseWheelDelta,
    const GameSettings &settings,
    bool blockGameplayInput,
    bool mobileGameplayTouchControlsEnabled)
{
    m_frame = {};
    m_frame.screenWidth = screenWidth;
    m_frame.screenHeight = screenHeight;
    m_frame.mouseWheelDelta = blockGameplayInput ? 0.0f : mouseWheelDelta;
    m_frame.textInput = blockGameplayInput ? std::string() : std::move(m_pendingTextInput);
    m_pendingTextInput.clear();

    int keyboardStateCount = 0;
    const bool *pKeyboardState = SDL_GetKeyboardState(&keyboardStateCount);

    if (pKeyboardState != nullptr)
    {
        for (int scancode = 0; scancode < keyboardStateCount && scancode < SDL_SCANCODE_COUNT; ++scancode)
        {
            m_frame.keyboardHeld[scancode] = blockGameplayInput ? false : pKeyboardState[scancode];
        }
    }

    float pointerX = 0.0f;
    float pointerY = 0.0f;
    const SDL_MouseButtonFlags mouseButtons = SDL_GetMouseState(&pointerX, &pointerY);
    m_frame.pointerX = pointerX;
    m_frame.pointerY = pointerY;

#if !defined(__ANDROID__)
    SDL_Window *pMouseLookWindow = SDL_GetMouseFocus();

    if (pMouseLookWindow == nullptr)
    {
        pMouseLookWindow = SDL_GetKeyboardFocus();
    }

    if (settings.controlScheme == ControlScheme::Modern
        && pMouseLookWindow != nullptr
        && SDL_GetWindowRelativeMouseMode(pMouseLookWindow)
        && screenWidth > 0
        && screenHeight > 0)
    {
        m_frame.pointerX = static_cast<float>(screenWidth) * 0.5f;
        m_frame.pointerY = static_cast<float>(screenHeight) * 0.5f;
    }
#endif

    float relativeMouseX = 0.0f;
    float relativeMouseY = 0.0f;
    SDL_GetRelativeMouseState(&relativeMouseX, &relativeMouseY);
#if defined(__ANDROID__)
    m_frame.relativeMouseX = 0.0f;
    m_frame.relativeMouseY = 0.0f;
#else
    const float mouseSensitivityScale = static_cast<float>(std::clamp(settings.mouseSensitivity, 0, 100)) / 100.0f;
    m_frame.relativeMouseX = blockGameplayInput ? 0.0f : relativeMouseX * mouseSensitivityScale;
    m_frame.relativeMouseY = blockGameplayInput ? 0.0f : relativeMouseY * mouseSensitivityScale;
#endif

    const bool physicalLeftMouseButtonHeld = (mouseButtons & SDL_BUTTON_LMASK) != 0;
    const bool physicalRightMouseButtonHeld = (mouseButtons & SDL_BUTTON_RMASK) != 0;
    const bool physicalMiddleMouseButtonHeld = (mouseButtons & SDL_BUTTON_MMASK) != 0;
    bool leftMouseButtonHeld = !blockGameplayInput && physicalLeftMouseButtonHeld;
    bool rightMouseButtonHeld = !blockGameplayInput && physicalRightMouseButtonHeld;
    bool middleMouseButtonHeld = !blockGameplayInput && physicalMiddleMouseButtonHeld;

    suppressButtonWhileHeld(
        physicalLeftMouseButtonHeld,
        leftMouseButtonHeld,
        m_suppressLeftMouseButtonUntilReleased);
    suppressButtonWhileHeld(
        physicalRightMouseButtonHeld,
        rightMouseButtonHeld,
        m_suppressRightMouseButtonUntilReleased);
    suppressButtonWhileHeld(
        physicalMiddleMouseButtonHeld,
        middleMouseButtonHeld,
        m_suppressMiddleMouseButtonUntilReleased);

    std::array<bool, KeyboardActionCount> actionHeld = {};

    for (const KeyboardBindingDefinition &definition : keyboardBindingDefinitions())
    {
        const InputBinding binding = settings.keyboard.binding(definition.action);
        bool held = false;

        if (binding.kind == InputBindingKind::Keyboard)
        {
            held =
                binding.scancode > SDL_SCANCODE_UNKNOWN
                && binding.scancode < SDL_SCANCODE_COUNT
                && m_frame.keyboardHeld[binding.scancode];
        }
        else if (binding.kind == InputBindingKind::MouseButton)
        {
            held =
                (binding.mouseButton == SDL_BUTTON_LEFT && leftMouseButtonHeld)
                || (binding.mouseButton == SDL_BUTTON_RIGHT && rightMouseButtonHeld)
                || (binding.mouseButton == SDL_BUTTON_MIDDLE && middleMouseButtonHeld);
        }

        actionHeld[keyboardActionIndex(definition.action)] = held;
    }

#if defined(__ANDROID__)
    const bool useMobileGameplayTouchControls = mobileGameplayTouchControlsEnabled && !blockGameplayInput;
    const auto setMobileActionHeld =
        [&settings, &actionHeld, this](KeyboardAction action)
        {
            actionHeld[keyboardActionIndex(action)] = true;

            const SDL_Scancode scancode = settings.keyboard.keyboardBinding(action);
            if (scancode > SDL_SCANCODE_UNKNOWN && scancode < SDL_SCANCODE_COUNT)
            {
                m_frame.keyboardHeld[scancode] = true;
            }
        };
    bool hasMovementTouch = false;
    bool hasCameraTouch = false;

    for (const MobileTouchPoint &touch : m_mobileTouches)
    {
        if (touch.active && touch.role == MobileTouchRole::Movement)
        {
            hasMovementTouch = true;
        }
        else if (touch.active && touch.role == MobileTouchRole::Camera)
        {
            hasCameraTouch = true;
        }
    }

    const float touchScale = mobileLogicalScale(screenHeight);
    const float logicalWidth = touchScale > 0.0f ? static_cast<float>(screenWidth) / touchScale : 0.0f;
    const auto touchLogicalX =
        [screenWidth, touchScale](float normalizedX) -> float
        {
            return touchScale > 0.0f ? normalizedX * static_cast<float>(screenWidth) / touchScale : 0.0f;
        };
    const auto touchLogicalY =
        [screenHeight, touchScale](float normalizedY) -> float
        {
            return touchScale > 0.0f ? normalizedY * static_cast<float>(screenHeight) / touchScale : 0.0f;
        };
    const auto touchStartsInHudZone =
        [logicalWidth, &settings, &touchLogicalX, &touchLogicalY](float normalizedX, float normalizedY) -> bool
        {
            const float startLogicalX = touchLogicalX(normalizedX);
            const float startLogicalY = touchLogicalY(normalizedY);
            return pointInsideRect(startLogicalX, startLogicalY, 0.0f, 0.0f, 520.0f, 120.0f)
                || pointInsideRect(startLogicalX, startLogicalY, logicalWidth - 180.0f, 0.0f, 180.0f, 170.0f)
                || pointInsideRect(startLogicalX, startLogicalY, 0.0f, 376.0f, 210.0f, 104.0f)
                || (settings.contextActionPopup
                    && pointInsideRect(startLogicalX, startLogicalY, logicalWidth - 268.0f, 416.0f, 260.0f, 56.0f))
                || pointInsideRect(startLogicalX, startLogicalY, logicalWidth - 236.0f, 292.0f, 236.0f, 120.0f)
                || pointInsideRect(startLogicalX, startLogicalY, 320.0f, 360.0f, 420.0f, 120.0f);
        };

    for (MobileTouchPoint &touch : m_mobileTouches)
    {
        if (!touch.active || touch.role != MobileTouchRole::None)
        {
            continue;
        }

        const float startLogicalX = touchLogicalX(touch.startX);
        const float startLogicalY = touchLogicalY(touch.startY);
        const bool startsInMovementZone = pointInsideRect(
            startLogicalX,
            startLogicalY,
            MobileMovementZoneX,
            MobileMovementZoneY,
            MobileMovementZoneWidth,
            MobileMovementZoneHeight);
        const bool startsInHudZone = touchStartsInHudZone(touch.startX, touch.startY);

        const bool startsInCameraZone = startLogicalX >= MobileCameraZoneX;

        if (!useMobileGameplayTouchControls || startsInHudZone)
        {
            touch.role = MobileTouchRole::Hud;
        }
        else if (startsInMovementZone && !hasMovementTouch)
        {
            touch.role = MobileTouchRole::Movement;
            hasMovementTouch = true;
        }
        else if (startsInCameraZone && !hasCameraTouch)
        {
            touch.role = MobileTouchRole::Camera;
            hasCameraTouch = true;
        }
        else
        {
            touch.role = MobileTouchRole::Hud;
        }

    }

    bool hasNonHudMobileTouch = false;
    bool hasHudTouch = false;
    float hudTouchX = 0.0f;
    float hudTouchY = 0.0f;

    for (MobileTouchPoint &touch : m_mobileTouches)
    {
        if (!touch.active)
        {
            continue;
        }

        if (touch.role == MobileTouchRole::Movement)
        {
            hasNonHudMobileTouch = true;
            const float startX = touch.startX * static_cast<float>(screenWidth);
            const float startY = touch.startY * static_cast<float>(screenHeight);
            const float deltaLogicalX = touchLogicalX(touch.x) - touchLogicalX(touch.startX);
            const float deltaLogicalY = touchLogicalY(touch.y) - touchLogicalY(touch.startY);
            const float distance = std::sqrt(deltaLogicalX * deltaLogicalX + deltaLogicalY * deltaLogicalY);
            const float clampedDistance = std::min(distance, MobileJoystickRadius);
            float clampedLogicalX = 0.0f;
            float clampedLogicalY = 0.0f;

            if (distance > 0.001f)
            {
                clampedLogicalX = deltaLogicalX * clampedDistance / distance;
                clampedLogicalY = deltaLogicalY * clampedDistance / distance;
            }

            m_frame.mobileJoystickActive = true;
            m_frame.mobileJoystickBaseX = startX;
            m_frame.mobileJoystickBaseY = startY;
            m_frame.mobileJoystickKnobX = startX + clampedLogicalX * touchScale;
            m_frame.mobileJoystickKnobY = startY + clampedLogicalY * touchScale;

            if (deltaLogicalY < -MobileJoystickDeadZone)
            {
                setMobileActionHeld(KeyboardAction::Forward);
            }
            else if (deltaLogicalY > MobileJoystickDeadZone)
            {
                setMobileActionHeld(KeyboardAction::Backward);
            }

            if (deltaLogicalX < -MobileJoystickDeadZone)
            {
                setMobileActionHeld(KeyboardAction::Left);
            }
            else if (deltaLogicalX > MobileJoystickDeadZone)
            {
                setMobileActionHeld(KeyboardAction::Right);
            }
        }
        else if (touch.role == MobileTouchRole::Camera)
        {
            hasNonHudMobileTouch = true;
            m_frame.relativeMouseX += touch.deltaX * static_cast<float>(screenWidth);
            m_frame.relativeMouseY += touch.deltaY * static_cast<float>(screenHeight);
        }
        else if (touch.role == MobileTouchRole::Hud && !hasHudTouch)
        {
            hasHudTouch = true;
            hudTouchX = touch.x * static_cast<float>(screenWidth);
            hudTouchY = touch.y * static_cast<float>(screenHeight);
        }
        else if (touch.role == MobileTouchRole::DebugConsoleGesture)
        {
            hasNonHudMobileTouch = true;
        }

        touch.deltaX = 0.0f;
        touch.deltaY = 0.0f;
    }

    if (hasHudTouch)
    {
        m_frame.pointerX = hudTouchX;
        m_frame.pointerY = hudTouchY;
        leftMouseButtonHeld = true;
        m_mobilePendingHudRelease = false;
    }
    else if (m_mobilePendingHudTap)
    {
        if (!useMobileGameplayTouchControls
            || touchStartsInHudZone(m_mobilePendingHudTapStartX, m_mobilePendingHudTapStartY))
        {
            m_frame.pointerX = m_mobilePendingHudTapX * static_cast<float>(screenWidth);
            m_frame.pointerY = m_mobilePendingHudTapY * static_cast<float>(screenHeight);
            leftMouseButtonHeld = true;
            m_mobilePendingHudRelease = true;
            m_mobilePendingHudReleaseX = m_mobilePendingHudTapX;
            m_mobilePendingHudReleaseY = m_mobilePendingHudTapY;
        }

        m_mobilePendingHudTap = false;
    }
    else if (m_mobilePendingHudRelease)
    {
        m_frame.pointerX = m_mobilePendingHudReleaseX * static_cast<float>(screenWidth);
        m_frame.pointerY = m_mobilePendingHudReleaseY * static_cast<float>(screenHeight);
        leftMouseButtonHeld = false;
        m_mobilePendingHudRelease = false;
    }
    else if (m_mobilePendingGameplayTap)
    {
        if (useMobileGameplayTouchControls)
        {
            m_frame.pointerX = m_mobilePendingGameplayTapX * static_cast<float>(screenWidth);
            m_frame.pointerY = m_mobilePendingGameplayTapY * static_cast<float>(screenHeight);
            leftMouseButtonHeld = true;
            m_mobilePendingGameplayRelease = true;
            m_mobilePendingGameplayReleaseX = m_mobilePendingGameplayTapX;
            m_mobilePendingGameplayReleaseY = m_mobilePendingGameplayTapY;
        }

        m_mobilePendingGameplayTap = false;
    }
    else if (m_mobilePendingGameplayRelease)
    {
        m_frame.pointerX = m_mobilePendingGameplayReleaseX * static_cast<float>(screenWidth);
        m_frame.pointerY = m_mobilePendingGameplayReleaseY * static_cast<float>(screenHeight);
        leftMouseButtonHeld = false;
        m_mobilePendingGameplayRelease = false;
    }

    if (hasNonHudMobileTouch && !hasHudTouch)
    {
        leftMouseButtonHeld = false;
    }
#endif

    m_frame.leftMouseButton = buildButtonState(leftMouseButtonHeld, m_previousLeftMouseButtonHeld);
    m_frame.rightMouseButton = buildButtonState(rightMouseButtonHeld, m_previousRightMouseButtonHeld);
    m_frame.middleMouseButton = buildButtonState(middleMouseButtonHeld, m_previousMiddleMouseButtonHeld);

    for (size_t actionIndex = 0; actionIndex < actionHeld.size(); ++actionIndex)
    {
        m_frame.actions[actionIndex] = buildButtonState(actionHeld[actionIndex], m_previousActionHeld[actionIndex]);
    }

    m_previousKeyboardHeld = m_frame.keyboardHeld;
    m_previousActionHeld = actionHeld;
    m_previousLeftMouseButtonHeld = leftMouseButtonHeld;
    m_previousRightMouseButtonHeld = rightMouseButtonHeld;
    m_previousMiddleMouseButtonHeld = middleMouseButtonHeld;
}

const GameplayInputFrame &GameInputSystem::frame() const
{
    return m_frame;
}

void GameInputSystem::resetRelativeMouseMotion()
{
    SDL_GetRelativeMouseState(nullptr, nullptr);
    m_frame.relativeMouseX = 0.0f;
    m_frame.relativeMouseY = 0.0f;
}

void GameInputSystem::suppressMouseButtonsUntilReleased()
{
    m_suppressLeftMouseButtonUntilReleased = true;
    m_suppressRightMouseButtonUntilReleased = true;
    m_suppressMiddleMouseButtonUntilReleased = true;
    m_previousLeftMouseButtonHeld = false;
    m_previousRightMouseButtonHeld = false;
    m_previousMiddleMouseButtonHeld = false;
}
} // namespace OpenYAMM::Game
