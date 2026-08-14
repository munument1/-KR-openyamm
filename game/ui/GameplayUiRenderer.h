#pragma once

namespace OpenYAMM::Game
{
class GameplayScreenRuntime;

class GameplayUiRenderer
{
public:
    static void renderGameplayHudArt(GameplayScreenRuntime &context, int width, int height);
    static void renderMobileInspectButton(GameplayScreenRuntime &context, int width, int height);
};
} // namespace OpenYAMM::Game
