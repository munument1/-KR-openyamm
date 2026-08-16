#include "doctest/doctest.h"

#include "engine/AssetFileSystem.h"
#include "game/ui/UiLayoutManager.h"

#include <algorithm>
#include <filesystem>
#include <string>
#include <vector>

TEST_CASE("mobile gameplay layout overrides preserve follower child draw order")
{
    const std::filesystem::path sourceRoot = OPENYAMM_SOURCE_DIR;
    OpenYAMM::Engine::AssetFileSystem assetFileSystem;
    REQUIRE(assetFileSystem.initialize(
        sourceRoot,
        sourceRoot / "assets_dev",
        OpenYAMM::Engine::AssetScaleTier::X1));

    OpenYAMM::Game::UiLayoutManager layoutManager;
    REQUIRE(layoutManager.loadLayoutFile(assetFileSystem, "Data/ui/gameplay/gameplay.yml"));
    REQUIRE(layoutManager.loadLayoutFile(assetFileSystem, "Data/ui/gameplay/gameplay_mobile.yml"));

    const std::vector<std::string> layoutIds = layoutManager.sortedLayoutIdsForScreen("OutdoorHud");
    CHECK_EQ(std::count(layoutIds.begin(), layoutIds.end(), "OutdoorFollowerPanel"), 1);

    const std::vector<std::string>::const_iterator panelIterator =
        std::find(layoutIds.begin(), layoutIds.end(), "OutdoorFollowerPanel");
    const std::vector<std::string>::const_iterator portraitIterator =
        std::find(layoutIds.begin(), layoutIds.end(), "OutdoorFollowerPortrait_1");
    REQUIRE(panelIterator != layoutIds.end());
    REQUIRE(portraitIterator != layoutIds.end());
    CHECK(panelIterator < portraitIterator);

    const OpenYAMM::Game::UiLayoutManager::LayoutElement *pPortrait =
        layoutManager.findElement("OutdoorFollowerPortrait_1");
    REQUIRE(pPortrait != nullptr);
    CHECK_EQ(pPortrait->parentId, "OutdoorFollowerPanel");
}
