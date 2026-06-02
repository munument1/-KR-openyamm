#include "doctest/doctest.h"

#include "game/gameplay/GameplaySaveLoadUiSupport.h"

using namespace OpenYAMM::Game;

TEST_CASE("save game name conflict ignores target slot and empty slots")
{
    GameplayUiController::SaveGameScreenState screen = {};
    GameplayUiController::SaveSlotSummary firstSlot = {};
    firstSlot.fileLabel = "Castle Alamos";
    firstSlot.populated = true;
    screen.slots.push_back(firstSlot);

    GameplayUiController::SaveSlotSummary secondSlot = {};
    secondSlot.fileLabel = "Empty";
    secondSlot.populated = false;
    screen.slots.push_back(secondSlot);

    CHECK_FALSE(saveGameNameConflictsWithExistingSlot(screen, "Castle Alamos", 0));
    CHECK(saveGameNameConflictsWithExistingSlot(screen, "castle alamos", 1));
    CHECK_FALSE(saveGameNameConflictsWithExistingSlot(screen, "Empty", 1));
    CHECK_FALSE(saveGameNameConflictsWithExistingSlot(screen, "   ", 1));
}
