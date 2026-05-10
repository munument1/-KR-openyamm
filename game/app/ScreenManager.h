#pragma once

#include "game/app/AppMode.h"
#include "game/ui/IScreen.h"

#include <cstddef>
#include <memory>

namespace OpenYAMM::Game
{
class ScreenManager
{
public:
    void setCurrentMode(AppMode mode);
    AppMode currentMode() const;

    void setActiveScreen(std::unique_ptr<IScreen> pScreen);
    void beginActiveScreenRender();
    void endActiveScreenRender();
    IScreen *activeScreen();
    const IScreen *activeScreen() const;

private:
    void applyActiveScreen(std::unique_ptr<IScreen> pScreen);

    AppMode m_currentMode = AppMode::MainMenu;
    std::unique_ptr<IScreen> m_pActiveScreen;
    std::unique_ptr<IScreen> m_pPendingScreen;
    bool m_hasPendingScreen = false;
    size_t m_activeScreenRenderDepth = 0;
};
}
