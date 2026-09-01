#include "doctest/doctest.h"

#include "game/app/GameInputSystem.h"

using namespace OpenYAMM::Game;

TEST_CASE("game input preserves a transient key press until the next frame")
{
    GameInputSystem inputSystem;
    SDL_Event keyDown = {};
    keyDown.type = SDL_EVENT_KEY_DOWN;
    keyDown.key.scancode = SDL_SCANCODE_BACKSPACE;
    keyDown.key.key = SDLK_BACKSPACE;

    SDL_Event keyUp = keyDown;
    keyUp.type = SDL_EVENT_KEY_UP;

    inputSystem.handleSdlEvent(keyDown);
    inputSystem.handleSdlEvent(keyUp);

    GameSettings settings = {};
    inputSystem.updateFromEngineInput(640, 480, 0.0f, settings);

    CHECK_FALSE(inputSystem.frame().isScancodeHeld(SDL_SCANCODE_BACKSPACE));
    CHECK(inputSystem.frame().scancodePressCount(SDL_SCANCODE_BACKSPACE) == 1);

    inputSystem.updateFromEngineInput(640, 480, 0.0f, settings);

    CHECK(inputSystem.frame().scancodePressCount(SDL_SCANCODE_BACKSPACE) == 0);
}

TEST_CASE("game input reports a held use key press only on its initial frame")
{
    GameInputSystem inputSystem;
    SDL_Event keyDown = {};
    keyDown.type = SDL_EVENT_KEY_DOWN;
    keyDown.key.scancode = SDL_SCANCODE_E;
    keyDown.key.key = SDLK_E;

    inputSystem.handleSdlEvent(keyDown);

    GameSettings settings = {};
    inputSystem.updateFromEngineInput(640, 480, 0.0f, settings);

    CHECK(inputSystem.frame().scancodePressCount(SDL_SCANCODE_E) == 1);

    inputSystem.updateFromEngineInput(640, 480, 0.0f, settings);

    CHECK(inputSystem.frame().scancodePressCount(SDL_SCANCODE_E) == 0);
}
