#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN

#include "engine/AssetFileSystem.h"
#include "engine/AssetScaleTier.h"
#include "game/audio/HouseVideoPlayer.h"

#include <SDL3/SDL.h>
#include <doctest/doctest.h>

#include <chrono>
#include <filesystem>
#include <thread>
#include <vector>

namespace OpenYAMM::Game
{
struct HouseVideoPlayerTestAccess
{
    static uint64_t presentedFrameSerial(const HouseVideoPlayer &player)
    {
        return player.m_presentedFrameSerial;
    }

    static double presentedFrameSeconds(const HouseVideoPlayer &player)
    {
        return player.m_presentedFrameSeconds;
    }
};
}

TEST_CASE("HouseVideoPlayer streams a complete OGV without predecoding the clip")
{
    SDL_setenv_unsafe("SDL_AUDIODRIVER", "dummy", 1);
    const std::filesystem::path sourceRoot = OPENYAMM_SOURCE_DIR;
    OpenYAMM::Engine::AssetFileSystem assetFileSystem;
    REQUIRE(assetFileSystem.initialize(
        sourceRoot,
        sourceRoot / "assets_dev",
        OpenYAMM::Engine::AssetScaleTier::X1,
        "mm6"));

    OpenYAMM::Game::HouseVideoPlayer videoPlayer;
    REQUIRE(videoPlayer.initialize());
    REQUIRE(videoPlayer.play(assetFileSystem, "thfpoor", "Videos/Houses", false));

    const std::chrono::steady_clock::time_point deadline =
        std::chrono::steady_clock::now() + std::chrono::seconds(5);

    while (!videoPlayer.hasFinishedPlayback() && std::chrono::steady_clock::now() < deadline)
    {
        videoPlayer.update(0.1f);
        std::this_thread::sleep_for(std::chrono::milliseconds(1));
    }

    CHECK(videoPlayer.hasFinishedPlayback());
    videoPlayer.stop();
    CHECK_FALSE(videoPlayer.hasActiveFrame());

    REQUIRE(videoPlayer.play(assetFileSystem, "elemair", "Videos/Houses", false));
    const std::chrono::steady_clock::time_point audioDeadline =
        std::chrono::steady_clock::now() + std::chrono::seconds(5);

    while (!videoPlayer.hasFinishedPlayback() && std::chrono::steady_clock::now() < audioDeadline)
    {
        videoPlayer.update(0.01f);
        std::this_thread::sleep_for(std::chrono::milliseconds(2));
    }

    CHECK(videoPlayer.hasFinishedPlayback());

    REQUIRE(videoPlayer.play(assetFileSystem, "lwpshp", "Videos/Houses", false));
    const std::chrono::steady_clock::time_point weaponShopDeadline =
        std::chrono::steady_clock::now() + std::chrono::seconds(6);
    uint64_t presentedFrameSerial = 0;
    std::vector<double> presentedFrameTimestamps;
    std::vector<std::chrono::steady_clock::time_point> presentedFrameWallTimes;

    while (!videoPlayer.hasFinishedPlayback() && std::chrono::steady_clock::now() < weaponShopDeadline)
    {
        videoPlayer.update(0.01f);

        const uint64_t currentFrameSerial =
            OpenYAMM::Game::HouseVideoPlayerTestAccess::presentedFrameSerial(videoPlayer);

        if (currentFrameSerial != presentedFrameSerial)
        {
            presentedFrameSerial = currentFrameSerial;
            presentedFrameTimestamps.push_back(
                OpenYAMM::Game::HouseVideoPlayerTestAccess::presentedFrameSeconds(videoPlayer));
            presentedFrameWallTimes.push_back(std::chrono::steady_clock::now());
        }

        std::this_thread::sleep_for(std::chrono::milliseconds(2));
    }

    CHECK(videoPlayer.hasFinishedPlayback());
    REQUIRE_GE(presentedFrameTimestamps.size(), 30);

    for (size_t index = 1; index < presentedFrameTimestamps.size(); ++index)
    {
        CHECK_LE(presentedFrameTimestamps[index] - presentedFrameTimestamps[index - 1], 0.14);
        CHECK_LE(
            std::chrono::duration<double>(presentedFrameWallTimes[index] - presentedFrameWallTimes[index - 1])
                .count(),
            0.2);
    }

    REQUIRE(videoPlayer.play(assetFileSystem, "elemair", "Videos/Houses", true));
    const std::chrono::steady_clock::time_point loopDeadline =
        std::chrono::steady_clock::now() + std::chrono::milliseconds(2500);
    presentedFrameSerial = 0;
    presentedFrameTimestamps.clear();
    presentedFrameWallTimes.clear();

    while (std::chrono::steady_clock::now() < loopDeadline)
    {
        videoPlayer.update(0.01f);

        const uint64_t currentFrameSerial =
            OpenYAMM::Game::HouseVideoPlayerTestAccess::presentedFrameSerial(videoPlayer);

        if (currentFrameSerial != presentedFrameSerial)
        {
            presentedFrameSerial = currentFrameSerial;
            presentedFrameTimestamps.push_back(
                OpenYAMM::Game::HouseVideoPlayerTestAccess::presentedFrameSeconds(videoPlayer));
            presentedFrameWallTimes.push_back(std::chrono::steady_clock::now());
        }

        std::this_thread::sleep_for(std::chrono::milliseconds(2));
    }

    CHECK_FALSE(videoPlayer.hasFinishedPlayback());
    CHECK(videoPlayer.play(assetFileSystem, "elemair", "Videos/Houses", true));
    REQUIRE_GE(presentedFrameTimestamps.size(), 20);

    for (size_t index = 1; index < presentedFrameTimestamps.size(); ++index)
    {
        CHECK_LE(presentedFrameTimestamps[index] - presentedFrameTimestamps[index - 1], 0.2);
        CHECK_LE(
            std::chrono::duration<double>(presentedFrameWallTimes[index] - presentedFrameWallTimes[index - 1])
                .count(),
            0.2);
    }

    videoPlayer.stop();
}

TEST_CASE("HouseVideoPlayer streams MM7 event cutscenes")
{
    SDL_setenv_unsafe("SDL_AUDIODRIVER", "dummy", 1);
    const std::filesystem::path sourceRoot = OPENYAMM_SOURCE_DIR;
    OpenYAMM::Engine::AssetFileSystem assetFileSystem;
    REQUIRE(assetFileSystem.initialize(
        sourceRoot,
        sourceRoot / "assets_dev",
        OpenYAMM::Engine::AssetScaleTier::X1,
        "mm7"));

    OpenYAMM::Game::HouseVideoPlayer videoPlayer;
    REQUIRE(videoPlayer.initialize());
    REQUIRE(videoPlayer.play(assetFileSystem, "arbiter good", "Videos/Cutscenes", false));

    const std::chrono::steady_clock::time_point deadline =
        std::chrono::steady_clock::now() + std::chrono::seconds(5);

    while (!videoPlayer.hasFinishedPlayback()
        && OpenYAMM::Game::HouseVideoPlayerTestAccess::presentedFrameSeconds(videoPlayer) < 1.5
        && std::chrono::steady_clock::now() < deadline)
    {
        videoPlayer.update(0.1f);
        std::this_thread::sleep_for(std::chrono::milliseconds(1));
    }

    CHECK_FALSE(videoPlayer.hasFinishedPlayback());
    CHECK_GT(OpenYAMM::Game::HouseVideoPlayerTestAccess::presentedFrameSerial(videoPlayer), 0);
    CHECK_GE(OpenYAMM::Game::HouseVideoPlayerTestAccess::presentedFrameSeconds(videoPlayer), 1.5);
}
