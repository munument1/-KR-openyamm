#include "doctest/doctest.h"

#include "game/party/SpellIds.h"
#include "game/ui/GameplayUiController.h"
#include "game/ui/SpellbookUiLayout.h"

using OpenYAMM::Game::findSpellbookSchoolUiDefinition;
using OpenYAMM::Game::findSpellbookSchoolUiDefinitionForSpellId;
using OpenYAMM::Game::GameplayUiController;
using OpenYAMM::Game::SpellbookSchoolUiDefinition;
using OpenYAMM::Game::SpellId;
using OpenYAMM::Game::spellbookSpellLayoutId;
using OpenYAMM::Game::spellIdValue;

TEST_CASE("spellbook ui layout uses canonical school slot mapping")
{
    const SpellbookSchoolUiDefinition *pBodyDefinition =
        findSpellbookSchoolUiDefinition(GameplayUiController::SpellbookSchool::Body);
    const SpellbookSchoolUiDefinition *pLightDefinition =
        findSpellbookSchoolUiDefinition(GameplayUiController::SpellbookSchool::Light);
    const SpellbookSchoolUiDefinition *pMindDefinition =
        findSpellbookSchoolUiDefinition(GameplayUiController::SpellbookSchool::Mind);

    REQUIRE(pBodyDefinition != nullptr);
    REQUIRE(pLightDefinition != nullptr);
    REQUIRE(pMindDefinition != nullptr);

    CHECK_EQ(pBodyDefinition->firstSpellId, spellIdValue(SpellId::CureWeakness));
    CHECK_EQ(pLightDefinition->firstSpellId, spellIdValue(SpellId::LightBolt));
    CHECK_EQ(pMindDefinition->firstSpellId, spellIdValue(SpellId::Telepathy));

    CHECK_EQ(
        spellbookSpellLayoutId(GameplayUiController::SpellbookSchool::Body, 2),
        "SpellbookPageBodySpellHeal");
    CHECK_EQ(
        spellbookSpellLayoutId(GameplayUiController::SpellbookSchool::Body, 5),
        "SpellbookPageBodySpellRegeneration");
    CHECK_EQ(
        spellbookSpellLayoutId(GameplayUiController::SpellbookSchool::Body, 7),
        "SpellbookPageBodySpellHammerhands");
    CHECK_EQ(
        spellbookSpellLayoutId(GameplayUiController::SpellbookSchool::Light, 9),
        "SpellbookPageLightSpellHourofpower");
    CHECK_EQ(
        spellbookSpellLayoutId(GameplayUiController::SpellbookSchool::Mind, 2),
        "SpellbookPageMindSpellRemovefear");

    const SpellbookSchoolUiDefinition *pHourOfPowerDefinition =
        findSpellbookSchoolUiDefinitionForSpellId(spellIdValue(SpellId::HourOfPower));

    REQUIRE(pHourOfPowerDefinition != nullptr);
    CHECK(pHourOfPowerDefinition->school == GameplayUiController::SpellbookSchool::Light);
    CHECK(spellbookSpellLayoutId(GameplayUiController::SpellbookSchool::Light, 12).empty());
}

TEST_CASE("spellbook remembers selected school after closing")
{
    GameplayUiController uiController = {};

    uiController.openSpellbook(GameplayUiController::SpellbookSchool::Body);
    uiController.spellbook().selectedSpellId = spellIdValue(SpellId::Heal);
    uiController.closeSpellbook();

    CHECK_FALSE(uiController.spellbook().active);
    CHECK(uiController.spellbook().hasRememberedSchool);
    CHECK(uiController.spellbook().school == GameplayUiController::SpellbookSchool::Body);
    CHECK_EQ(uiController.spellbook().selectedSpellId, 0u);
}

TEST_CASE("status bar hover text does not replace active event text")
{
    GameplayUiController uiController = {};

    uiController.setStatusBarHoverText("Old hover");
    CHECK_EQ(uiController.statusBar().hoverText, "Old hover");

    uiController.setStatusBarEvent("You found an item!", 2.0f);
    uiController.setStatusBarHoverText("New hover");

    CHECK(uiController.statusBarEventActive());
    CHECK_EQ(uiController.statusBar().eventText, "You found an item!");
    CHECK_EQ(uiController.statusBar().hoverText, "Old hover");

    uiController.updateStatusBarEvent(2.0f);
    CHECK_FALSE(uiController.statusBarEventActive());

    uiController.setStatusBarHoverText("New hover");
    CHECK_EQ(uiController.statusBar().hoverText, "New hover");
}

TEST_CASE("status bar hover text can clear while event text is active")
{
    GameplayUiController uiController = {};

    uiController.setStatusBarHoverText("Old hover");
    uiController.setStatusBarEvent("You found gold!", 2.0f);
    uiController.clearStatusBarHoverText();

    CHECK(uiController.statusBarEventActive());
    CHECK_EQ(uiController.statusBar().eventText, "You found gold!");
    CHECK(uiController.statusBar().hoverText.empty());
}

TEST_CASE("high priority status bar event resists normal overwrite until expiry")
{
    GameplayUiController uiController = {};

    uiController.setStatusBarEvent(
        "You have killed all of the Ogres",
        2.0f,
        GameplayUiController::StatusBarEventPriority::High);
    uiController.setStatusBarEvent("You are burning!", 2.0f);

    CHECK(uiController.statusBarEventActive());
    CHECK_EQ(uiController.statusBar().eventText, "You have killed all of the Ogres");

    uiController.setStatusBarEvent(
        "Another quest update",
        2.0f,
        GameplayUiController::StatusBarEventPriority::High);
    CHECK_EQ(uiController.statusBar().eventText, "Another quest update");

    uiController.updateStatusBarEvent(2.0f);
    CHECK_FALSE(uiController.statusBarEventActive());

    uiController.setStatusBarEvent("You are burning!", 2.0f);
    CHECK_EQ(uiController.statusBar().eventText, "You are burning!");
}
