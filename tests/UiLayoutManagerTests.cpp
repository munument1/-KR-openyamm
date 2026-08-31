#include "doctest/doctest.h"

#include "game/ui/UiLayoutManager.h"

#include <algorithm>
#include <filesystem>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>

namespace
{
std::string loadLayoutSource(const std::filesystem::path &relativePath)
{
    std::ifstream input(std::filesystem::path(OPENYAMM_SOURCE_DIR) / relativePath);
    std::ostringstream text;
    text << input.rdbuf();
    return text.str();
}
}

TEST_CASE("mobile gameplay layout overrides preserve follower child draw order")
{
    const std::string gameplayLayout = loadLayoutSource("assets_dev/engine/ui/gameplay/gameplay.yml");
    const std::string mobileLayout = loadLayoutSource("assets_dev/engine/ui/gameplay/gameplay_mobile.yml");
    REQUIRE_FALSE(gameplayLayout.empty());
    REQUIRE_FALSE(mobileLayout.empty());

    OpenYAMM::Game::UiLayoutManager layoutManager;
    REQUIRE(layoutManager.loadLayoutText("gameplay.yml", gameplayLayout));
    REQUIRE(layoutManager.loadLayoutText("gameplay_mobile.yml", mobileLayout));

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

    const std::vector<std::string>::const_iterator goldBarIterator =
        std::find(layoutIds.begin(), layoutIds.end(), "OutdoorGoldBar");
    REQUIRE(goldBarIterator != layoutIds.end());

    const char *pTopBarButtonIds[] = {
        "OutdoorButtonRest",
        "OutdoorButtonBooks",
        "OutdoorButtonQuickReference",
        "OutdoorButtonOptions",
    };

    for (const char *pButtonId : pTopBarButtonIds)
    {
        CHECK_EQ(std::count(layoutIds.begin(), layoutIds.end(), pButtonId), 1);
        const std::vector<std::string>::const_iterator buttonIterator =
            std::find(layoutIds.begin(), layoutIds.end(), pButtonId);
        REQUIRE(buttonIterator != layoutIds.end());
        CHECK(goldBarIterator < buttonIterator);

        const OpenYAMM::Game::UiLayoutManager::LayoutElement *pButton = layoutManager.findElement(pButtonId);
        REQUIRE(pButton != nullptr);
        CHECK_EQ(pButton->parentId, "OutdoorGoldBar");
    }
}

TEST_CASE("character doll boots render above armor")
{
    const std::string characterLayout = loadLayoutSource("assets_dev/engine/ui/gameplay/character.yml");
    REQUIRE_FALSE(characterLayout.empty());

    OpenYAMM::Game::UiLayoutManager layoutManager;
    REQUIRE(layoutManager.loadLayoutText("character.yml", characterLayout));

    const OpenYAMM::Game::UiLayoutManager::LayoutElement *pArmor =
        layoutManager.findElement("CharacterDollArmorSlot");
    const OpenYAMM::Game::UiLayoutManager::LayoutElement *pBoots =
        layoutManager.findElement("CharacterDollBootsSlot");
    REQUIRE(pArmor != nullptr);
    REQUIRE(pBoots != nullptr);
    CHECK_GT(pBoots->zIndex, pArmor->zIndex);

    const std::vector<std::string> layoutIds = layoutManager.sortedLayoutIdsForScreen("Character");
    const std::vector<std::string>::const_iterator armorIterator =
        std::find(layoutIds.begin(), layoutIds.end(), "CharacterDollArmorSlot");
    const std::vector<std::string>::const_iterator bootsIterator =
        std::find(layoutIds.begin(), layoutIds.end(), "CharacterDollBootsSlot");
    REQUIRE(armorIterator != layoutIds.end());
    REQUIRE(bootsIterator != layoutIds.end());
    CHECK(armorIterator < bootsIterator);
}

TEST_CASE("character inspect layout provides a skill bonus row")
{
    const std::string inspectLayout = loadLayoutSource("assets_dev/engine/ui/gameplay/character_inspect.yml");
    REQUIRE_FALSE(inspectLayout.empty());

    OpenYAMM::Game::UiLayoutManager layoutManager;
    REQUIRE(layoutManager.loadLayoutText("character_inspect.yml", inspectLayout));

    const OpenYAMM::Game::UiLayoutManager::LayoutElement *pSkillBonus =
        layoutManager.findElement("CharacterInspectSkillBonus");
    REQUIRE(pSkillBonus != nullptr);
    CHECK_EQ(pSkillBonus->parentId, "CharacterInspectRoot");
    CHECK_EQ(pSkillBonus->fontName, "SMALLNUM");
}
