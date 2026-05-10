#include "game/app/ScreenManager.h"

#include <doctest/doctest.h>

namespace OpenYAMM::Tests
{
namespace
{
class TestScreen final : public Game::IScreen
{
public:
    TestScreen(
        Game::AppMode mode,
        bool *pDestroyed,
        int *pEntered,
        int *pExited
    )
        : m_mode(mode)
        , m_pDestroyed(pDestroyed)
        , m_pEntered(pEntered)
        , m_pExited(pExited)
    {
    }

    ~TestScreen() override
    {
        if (m_pDestroyed != nullptr)
        {
            *m_pDestroyed = true;
        }
    }

    Game::AppMode mode() const override
    {
        return m_mode;
    }

    void renderFrame(
        int width,
        int height,
        const Game::GameplayInputFrame &inputFrame,
        float deltaSeconds) override
    {
        static_cast<void>(width);
        static_cast<void>(height);
        static_cast<void>(inputFrame);
        static_cast<void>(deltaSeconds);
    }

    void onEnter() override
    {
        if (m_pEntered != nullptr)
        {
            ++(*m_pEntered);
        }
    }

    void onExit() override
    {
        if (m_pExited != nullptr)
        {
            ++(*m_pExited);
        }
    }

private:
    Game::AppMode m_mode = Game::AppMode::MainMenu;
    bool *m_pDestroyed = nullptr;
    int *m_pEntered = nullptr;
    int *m_pExited = nullptr;
};
}

TEST_CASE("screen switch requested during active screen render is applied after render")
{
    Game::ScreenManager screenManager;

    bool firstDestroyed = false;
    bool secondDestroyed = false;
    int firstEntered = 0;
    int firstExited = 0;
    int secondEntered = 0;
    int secondExited = 0;

    std::unique_ptr<TestScreen> pFirstScreen = std::make_unique<TestScreen>(
        Game::AppMode::MainMenu,
        &firstDestroyed,
        &firstEntered,
        &firstExited);
    TestScreen *pFirstScreenRaw = pFirstScreen.get();

    screenManager.setActiveScreen(std::move(pFirstScreen));
    CHECK(screenManager.activeScreen() == pFirstScreenRaw);
    CHECK(firstEntered == 1);

    screenManager.beginActiveScreenRender();
    screenManager.setActiveScreen(std::make_unique<TestScreen>(
        Game::AppMode::GameplayIndoor,
        &secondDestroyed,
        &secondEntered,
        &secondExited));

    CHECK(screenManager.activeScreen() == pFirstScreenRaw);
    CHECK(firstExited == 0);
    CHECK(!firstDestroyed);
    CHECK(secondEntered == 0);

    screenManager.endActiveScreenRender();

    CHECK(screenManager.activeScreen() != pFirstScreenRaw);
    CHECK(screenManager.currentMode() == Game::AppMode::GameplayIndoor);
    CHECK(firstExited == 1);
    CHECK(firstDestroyed);
    CHECK(secondEntered == 1);
    CHECK(secondExited == 0);
    CHECK(!secondDestroyed);
}
}
