#include "game/app/ScreenManager.h"

namespace OpenYAMM::Game
{
void ScreenManager::setCurrentMode(AppMode mode)
{
    m_currentMode = mode;
}

AppMode ScreenManager::currentMode() const
{
    return m_currentMode;
}

void ScreenManager::setActiveScreen(std::unique_ptr<IScreen> pScreen)
{
    if (m_activeScreenRenderDepth != 0)
    {
        m_pPendingScreen = std::move(pScreen);
        m_hasPendingScreen = true;
        return;
    }

    applyActiveScreen(std::move(pScreen));
}

void ScreenManager::beginActiveScreenRender()
{
    ++m_activeScreenRenderDepth;
}

void ScreenManager::endActiveScreenRender()
{
    if (m_activeScreenRenderDepth == 0)
    {
        return;
    }

    --m_activeScreenRenderDepth;

    if (m_activeScreenRenderDepth == 0 && m_hasPendingScreen)
    {
        m_hasPendingScreen = false;
        applyActiveScreen(std::move(m_pPendingScreen));
    }
}

void ScreenManager::applyActiveScreen(std::unique_ptr<IScreen> pScreen)
{
    if (m_pActiveScreen)
    {
        m_pActiveScreen->onExit();
    }

    m_pActiveScreen = std::move(pScreen);

    if (m_pActiveScreen)
    {
        m_currentMode = m_pActiveScreen->mode();
        m_pActiveScreen->onEnter();
    }
}

IScreen *ScreenManager::activeScreen()
{
    return m_pActiveScreen.get();
}

const IScreen *ScreenManager::activeScreen() const
{
    return m_pActiveScreen.get();
}
}
