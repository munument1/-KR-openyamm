#include "doctest/doctest.h"

#include "engine/TextTable.h"
#include "game/tables/MmergeBaseTables.h"

#include <filesystem>
#include <fstream>
#include <optional>
#include <sstream>
#include <string>
#include <vector>

namespace
{
std::string readSourceTextFile(const std::filesystem::path &path)
{
    std::ifstream stream(path);
    REQUIRE(stream.is_open());

    std::ostringstream buffer;
    buffer << stream.rdbuf();
    return buffer.str();
}

std::vector<std::vector<std::string>> loadRows(const char *pFileName)
{
    const std::string text =
        readSourceTextFile(
            std::filesystem::path(OPENYAMM_SOURCE_DIR) / "assets_dev/engine/data_tables" / pFileName);

    const std::optional<OpenYAMM::Engine::TextTable> table =
        OpenYAMM::Engine::TextTable::parseTabSeparated(text);

    REQUIRE(table.has_value());

    std::vector<std::vector<std::string>> rows;

    for (size_t index = 0; index < table->getRowCount(); ++index)
    {
        rows.push_back(table->getRow(index));
    }

    return rows;
}
}

TEST_CASE("MMerge base engine tables load without changing active MM8 runtime tables")
{
    OpenYAMM::Game::MmergeClassExtraTable classExtraTable;
    OpenYAMM::Game::MmergeCharacterSelectionTable characterSelectionTable;
    OpenYAMM::Game::MmergeRaceSkillTable raceSkillTable;
    OpenYAMM::Game::MmergeTeacherTopicTable teacherTopicTable;
    OpenYAMM::Game::MmergeTeacherAutonoteTable teacherAutonoteTable;
    OpenYAMM::Game::MmergeNpcProfessionTable npcProfessionTable;
    OpenYAMM::Game::MmergeNpcNameTable npcNameTable;
    OpenYAMM::Game::MmergeNpcBtbTable npcBtbTable;
    OpenYAMM::Game::MmergeNewsTopicTable newsAreaTopicTable;
    OpenYAMM::Game::MmergeNewsTopicTable newsContinentTopicTable;
    OpenYAMM::Game::MmergeNewsProfessionTopicTable newsProfessionTopicTable;
    OpenYAMM::Game::MmergeMonsterPortraitTable monsterPortraitTable;
    OpenYAMM::Game::MmergeMonsterKindTable monsterKindTable;
    OpenYAMM::Game::MmergePotionSettingTable potionSettingTable;
    OpenYAMM::Game::MmergeReagentSettingTable reagentSettingTable;
    OpenYAMM::Game::MmergeAdditionalUiTable additionalUiTable;
    OpenYAMM::Game::MmergeBolsterFormulaTable bolsterFormulaTable;
    OpenYAMM::Game::MmergeBolsterMapTable bolsterMapTable;
    OpenYAMM::Game::MmergeBolsterMonsterTable bolsterMonsterTable;
    OpenYAMM::Game::MmergeCharacterVoiceTable characterVoiceTable;
    OpenYAMM::Game::MmergeClassStartingStatTable classStartingStatTable;
    OpenYAMM::Game::MmergeComplexItemPictureOffsetTable complexItemPictureOffsetTable;
    OpenYAMM::Game::MmergeComplexItemPictureTable complexItemPictureTable;
    OpenYAMM::Game::MmergeContinentSettingTable continentSettingTable;
    OpenYAMM::Game::MmergeHardwareWaterTextureTable hardwareWaterTextureTable;
    OpenYAMM::Game::MmergeHouseExitTable houseExitTable;
    OpenYAMM::Game::MmergeHouseRuleTable houseRuleTable;
    OpenYAMM::Game::MmergeHistoryTable mm7HistoryTable;
    OpenYAMM::Game::MmergeOutdoorTravelTable outdoorTravelTable;
    OpenYAMM::Game::MmergeOverlayTable overlayTable;
    OpenYAMM::Game::MmergeTownPortalSwitchTable townPortalSwitchTable;
    OpenYAMM::Game::MmergeTransportIndexTable transportIndexTable;
    OpenYAMM::Game::MmergeTransportLocationTable transportLocationTable;

    REQUIRE(classExtraTable.loadFromRows(loadRows("class_extra.txt")));
    REQUIRE(characterSelectionTable.loadFromRows(loadRows("character_selection.txt")));
    REQUIRE(raceSkillTable.loadFromRows(loadRows("race_skills.txt")));
    REQUIRE(teacherTopicTable.loadFromRows(loadRows("teacher_topics.txt")));
    REQUIRE(teacherAutonoteTable.loadFromRows(loadRows("teacher_autonotes.txt")));
    REQUIRE(npcProfessionTable.loadFromRows(loadRows("npc_professions.txt")));
    REQUIRE(npcNameTable.loadFromRows(loadRows("npc_names.txt")));
    REQUIRE(npcBtbTable.loadFromRows(loadRows("npc_btb.txt")));
    REQUIRE(newsAreaTopicTable.loadFromRows(loadRows("news_topics_area.txt")));
    REQUIRE(newsContinentTopicTable.loadFromRows(loadRows("news_topics_continent.txt")));
    REQUIRE(newsProfessionTopicTable.loadFromRows(loadRows("news_topics_profession.txt")));
    REQUIRE(monsterPortraitTable.loadFromRows(loadRows("monster_portraits.txt")));
    REQUIRE(monsterKindTable.loadFromRows(loadRows("monster_kinds.txt")));
    REQUIRE(potionSettingTable.loadFromRows(loadRows("potion_settings.txt")));
    REQUIRE(reagentSettingTable.loadFromRows(loadRows("reagent_settings.txt")));
    REQUIRE(additionalUiTable.loadFromRows(loadRows("additional_ui.txt")));
    REQUIRE(bolsterFormulaTable.loadFromRows(loadRows("bolster_formulas.txt")));
    REQUIRE(bolsterMapTable.loadFromRows(loadRows("bolster_maps.txt")));
    REQUIRE(bolsterMonsterTable.loadFromRows(loadRows("bolster_monsters.txt")));
    REQUIRE(characterVoiceTable.loadFromRows(loadRows("character_voices.txt")));
    REQUIRE(classStartingStatTable.loadFromRows(loadRows("class_starting_stats.txt")));
    REQUIRE(complexItemPictureOffsetTable.loadFromRows(loadRows("complex_item_picture_offsets.txt")));
    REQUIRE(complexItemPictureTable.loadFromRows(loadRows("complex_item_pictures.txt")));
    REQUIRE(continentSettingTable.loadFromRows(loadRows("continent_settings.txt")));
    REQUIRE(hardwareWaterTextureTable.loadFromRows(loadRows("hw_water_textures.txt")));
    REQUIRE(houseExitTable.loadFromRows(loadRows("house_exits.txt")));
    REQUIRE(houseRuleTable.loadFromRows(loadRows("house_rules.txt")));
    REQUIRE(mm7HistoryTable.loadFromRows(loadRows("english/mm7_history.txt")));
    REQUIRE(outdoorTravelTable.loadFromRows(loadRows("outdoor_travels.txt")));
    REQUIRE(overlayTable.loadFromRows(loadRows("overlay.txt")));
    REQUIRE(townPortalSwitchTable.loadFromRows(loadRows("town_portal_switch.txt")));
    REQUIRE(transportIndexTable.loadFromRows(loadRows("transport_index.txt")));
    REQUIRE(transportLocationTable.loadFromRows(loadRows("transport_locations.txt")));

    REQUIRE_GT(classExtraTable.entries().size(), 50u);
    CHECK_EQ(classExtraTable.entries()[10].note, "Dragon");
    CHECK_EQ(classExtraTable.entries()[10].kind, 4u);

    CHECK_EQ(characterSelectionTable.raceCount(), 11u);
    REQUIRE_EQ(characterSelectionTable.continents().size(), 4u);
    CHECK_EQ(characterSelectionTable.continents()[0].name, "Jadam");

    CHECK_GT(raceSkillTable.overrideCount(), 0u);

    REQUIRE_GT(teacherTopicTable.entries().size(), 70u);
    CHECK_EQ(teacherTopicTable.entries()[21].topicId, 971u);
    CHECK_EQ(teacherTopicTable.entries()[21].requiredGold, 2000u);

    CHECK_GT(teacherAutonoteTable.mappingCount(), 100u);

    REQUIRE_GT(npcProfessionTable.entries().size(), 70u);
    CHECK_EQ(npcProfessionTable.entries()[41].profession, "Gate Master");
    CHECK_EQ(npcProfessionTable.entries()[41].actionTopicId, 1718u);

    CHECK_GT(npcNameTable.maleNameCount(), 100u);
    CHECK_GT(npcNameTable.femaleNameCount(), 100u);
    CHECK_EQ(npcBtbTable.personalityCount(), 13u);

    CHECK_GT(newsAreaTopicTable.entries().size(), 200u);
    CHECK_GT(newsContinentTopicTable.entries().size(), 10u);
    CHECK_GT(newsProfessionTopicTable.topicCount(), 400u);

    CHECK_GT(monsterPortraitTable.groupCount(), 50u);
    REQUIRE_GT(monsterKindTable.entries().size(), 100u);
    CHECK(monsterKindTable.entries()[1].peasant);
    CHECK(monsterKindTable.entries()[1].noArena);

    REQUIRE_GT(potionSettingTable.entries().size(), 50u);
    CHECK_EQ(potionSettingTable.entries()[1].itemId, 221u);
    CHECK(potionSettingTable.entries()[1].drinkable);

    REQUIRE_GT(reagentSettingTable.entries().size(), 40u);
    CHECK_EQ(reagentSettingTable.entries()[0].resultItemId, 222u);

    REQUIRE_EQ(additionalUiTable.entries().size(), 3u);
    CHECK_EQ(additionalUiTable.entries()[0].lodName, "default");

    CHECK_GT(bolsterFormulaTable.entries().size(), 10u);
    CHECK_EQ(bolsterFormulaTable.entries()[0].stat, "HP");

    CHECK_GT(bolsterMapTable.entries().size(), 20u);
    CHECK_EQ(bolsterMapTable.entries()[1].note, "Dagger Wound Island");

    CHECK_GT(bolsterMonsterTable.entries().size(), 100u);
    CHECK_EQ(bolsterMonsterTable.entries()[1].type, "Lizardman");

    CHECK_GT(characterVoiceTable.entries().size(), 40u);
    CHECK_EQ(characterVoiceTable.entries()[0].soundIdsByVoiceSetId[0], 5000u);

    CHECK_GT(classStartingStatTable.entries().size(), 100u);
    CHECK_EQ(classStartingStatTable.entries()[0].raceName, "Human");
    CHECK_EQ(classStartingStatTable.entries()[0].maxValue, 25u);

    REQUIRE_EQ(complexItemPictureOffsetTable.entries().size(), 1u);
    CHECK_EQ(complexItemPictureOffsetTable.entries()[0].portraitId, 26u);

    CHECK_GT(complexItemPictureTable.entries().size(), 10u);
    CHECK_EQ(complexItemPictureTable.entries()[0].itemId, 84u);

    REQUIRE_EQ(continentSettingTable.entries().size(), 4u);
    CHECK_EQ(continentSettingTable.entries()[0].note, "Jadam");

    REQUIRE_EQ(hardwareWaterTextureTable.entries().size(), 6u);
    CHECK_EQ(hardwareWaterTextureTable.entries()[0].hardwareTexturePrefix, "7hdwtr");

    REQUIRE_GT(houseExitTable.data().npcPictureIds.size(), 6u);
    CHECK_EQ(houseExitTable.data().exits[0].mapName, "sewer.blv");

    CHECK_GT(houseRuleTable.sections().size(), 5u);
    CHECK_EQ(houseRuleTable.sections()[0].name, "Weapon shops Standart");

    CHECK_GT(mm7HistoryTable.entries().size(), 20u);
    CHECK_EQ(mm7HistoryTable.entries()[0].pageTitle, "Author's Forward");

    CHECK_GT(outdoorTravelTable.entries().size(), 20u);
    CHECK_EQ(outdoorTravelTable.entries()[0].keyMap, "7out02.odm");

    CHECK_GT(overlayTable.entries().size(), 10u);
    CHECK_EQ(overlayTable.entries()[0].id, 1020u);

    CHECK_GT(townPortalSwitchTable.groups().size(), 2u);
    CHECK_EQ(townPortalSwitchTable.groups()[0].topicId, 300u);

    CHECK_GE(transportIndexTable.entries().size(), 20u);
    CHECK_EQ(transportIndexTable.entries()[0].houseEventId, 54u);

    CHECK_GT(transportLocationTable.entries().size(), 20u);
    CHECK_EQ(transportLocationTable.entries()[0].mapName, "Out03.odm");
}
