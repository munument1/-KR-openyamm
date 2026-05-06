#include "doctest/doctest.h"

#include "engine/TextTable.h"
#include "game/tables/MergedBaseTables.h"

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

TEST_CASE("merged base engine tables load without changing active MM8 runtime tables")
{
    OpenYAMM::Game::MergedClassExtraTable classExtraTable;
    OpenYAMM::Game::MergedCharacterSelectionTable characterSelectionTable;
    OpenYAMM::Game::MergedRaceSkillTable raceSkillTable;
    OpenYAMM::Game::MergedTeacherTopicTable teacherTopicTable;
    OpenYAMM::Game::MergedTeacherAutonoteTable teacherAutonoteTable;
    OpenYAMM::Game::MergedNpcProfessionTable npcProfessionTable;
    OpenYAMM::Game::MergedNpcNameTable npcNameTable;
    OpenYAMM::Game::MergedNpcBtbTable npcBtbTable;
    OpenYAMM::Game::MergedNewsTopicTable newsAreaTopicTable;
    OpenYAMM::Game::MergedNewsTopicTable newsContinentTopicTable;
    OpenYAMM::Game::MergedNewsProfessionTopicTable newsProfessionTopicTable;
    OpenYAMM::Game::MergedMonsterPortraitTable monsterPortraitTable;
    OpenYAMM::Game::MergedMonsterKindTable monsterKindTable;
    OpenYAMM::Game::MergedPotionSettingTable potionSettingTable;
    OpenYAMM::Game::MergedReagentSettingTable reagentSettingTable;
    OpenYAMM::Game::MergedAdditionalUiTable additionalUiTable;
    OpenYAMM::Game::MergedBolsterFormulaTable bolsterFormulaTable;
    OpenYAMM::Game::MergedBolsterMapTable bolsterMapTable;
    OpenYAMM::Game::MergedBolsterMonsterTable bolsterMonsterTable;
    OpenYAMM::Game::MergedCharacterVoiceTable characterVoiceTable;
    OpenYAMM::Game::MergedClassStartingStatTable classStartingStatTable;
    OpenYAMM::Game::MergedComplexItemPictureOffsetTable complexItemPictureOffsetTable;
    OpenYAMM::Game::MergedComplexItemPictureTable complexItemPictureTable;
    OpenYAMM::Game::MergedContinentSettingTable continentSettingTable;
    OpenYAMM::Game::MergedHardwareWaterTextureTable hardwareWaterTextureTable;
    OpenYAMM::Game::MergedHouseExitTable houseExitTable;
    OpenYAMM::Game::MergedHouseRuleTable houseRuleTable;
    OpenYAMM::Game::MergedHistoryTable mm7HistoryTable;
    OpenYAMM::Game::MergedOutdoorTravelTable outdoorTravelTable;
    OpenYAMM::Game::MergedOverlayTable overlayTable;
    OpenYAMM::Game::MergedTownPortalSwitchTable townPortalSwitchTable;
    OpenYAMM::Game::MergedTransportIndexTable transportIndexTable;
    OpenYAMM::Game::MergedTransportLocationTable transportLocationTable;

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
    REQUIRE(teacherTopicTable.get(971u) != nullptr);
    CHECK_EQ(teacherTopicTable.get(971u)->skillId, 7u);

    CHECK_GT(teacherAutonoteTable.mappingCount(), 100u);
    CHECK_EQ(teacherAutonoteTable.autonoteIdForTopicAndNpc(300u, 440u), 307u);

    REQUIRE_GT(npcProfessionTable.entries().size(), 70u);
    CHECK_EQ(npcProfessionTable.entries()[41].profession, "Gate Master");
    CHECK_EQ(npcProfessionTable.entries()[41].actionTopicId, 1718u);

    CHECK_GT(npcNameTable.maleNameCount(), 100u);
    CHECK_GT(npcNameTable.femaleNameCount(), 100u);
    CHECK_EQ(npcNameTable.maleNames().front(), "Aaron");
    CHECK_EQ(npcNameTable.femaleNames().front(), "Alice");
    CHECK_EQ(npcBtbTable.personalityCount(), 13u);
    const OpenYAMM::Game::MergedNpcBtbEntry *pMerchantBtb = npcBtbTable.get("Merchant");
    REQUIRE(pMerchantBtb != nullptr);
    CHECK_FALSE(pMerchantBtb->acceptBeg);
    CHECK(pMerchantBtb->acceptBribe);
    CHECK(pMerchantBtb->acceptThreat);
    CHECK_EQ(pMerchantBtb->bribeSuccessTextId, 2469u);

    CHECK_GT(newsAreaTopicTable.entries().size(), 200u);
    CHECK_GT(newsContinentTopicTable.entries().size(), 10u);
    CHECK_GT(newsProfessionTopicTable.topicCount(), 400u);

    CHECK_GT(monsterPortraitTable.groupCount(), 50u);
    REQUIRE(monsterPortraitTable.firstPortraitForName("Peasant").has_value());
    REQUIRE(monsterPortraitTable.portraitForName("Peasant", 0).has_value());
    REQUIRE(monsterPortraitTable.portraitForName("Peasant", 1).has_value());
    CHECK_NE(
        *monsterPortraitTable.portraitForName("Peasant", 0),
        *monsterPortraitTable.portraitForName("Peasant", 1));
    REQUIRE_GT(monsterKindTable.entries().size(), 100u);
    CHECK(monsterKindTable.entries()[1].peasant);
    CHECK(monsterKindTable.entries()[1].noArena);

    REQUIRE_GT(potionSettingTable.entries().size(), 50u);
    CHECK_EQ(potionSettingTable.entries()[1].itemId, 221u);
    CHECK(potionSettingTable.entries()[1].drinkable);
    CHECK_EQ(potionSettingTable.emptyBottleItemId(), 220u);
    CHECK_EQ(potionSettingTable.catalystPotionItemId(), 221u);
    REQUIRE(potionSettingTable.getByItemId(233u) != nullptr);
    CHECK(potionSettingTable.getByItemId(233u)->usable);

    REQUIRE_GT(reagentSettingTable.entries().size(), 40u);
    CHECK_EQ(reagentSettingTable.entries()[0].resultItemId, 222u);
    CHECK_EQ(reagentSettingTable.resultItemIdForReagent(1002u), 222u);

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
    const OpenYAMM::Game::MergedComplexItemPictureEntry *pLeatherJerkin = complexItemPictureTable.get(84u);
    REQUIRE(pLeatherJerkin != nullptr);
    REQUIRE_GE(pLeatherJerkin->points.size(), 5u);
    CHECK_EQ(pLeatherJerkin->points[0].x, 47);
    CHECK_EQ(pLeatherJerkin->points[0].y, 78);
    CHECK_EQ(pLeatherJerkin->points[4].x, -2);
    CHECK_EQ(pLeatherJerkin->points[4].y, 0);
    const OpenYAMM::Game::MergedComplexItemPictureEntry *pWetsuit = complexItemPictureTable.get(1406u);
    REQUIRE(pWetsuit != nullptr);
    REQUIRE_GE(pWetsuit->points.size(), 5u);
    CHECK_EQ(pWetsuit->points[0].x, 0);
    CHECK_EQ(pWetsuit->points[0].y, -1);
    CHECK_EQ(pWetsuit->points[2].x, 9);
    CHECK_EQ(pWetsuit->points[2].y, 23);
    const OpenYAMM::Game::MergedComplexItemPictureEntry *pTravelersCloak = complexItemPictureTable.get(122u);
    REQUIRE(pTravelersCloak != nullptr);
    REQUIRE_EQ(pTravelersCloak->points.size(), 6u);
    CHECK_EQ(pTravelersCloak->points[4].x, 43);
    CHECK_EQ(pTravelersCloak->points[4].y, 117);
    CHECK_EQ(pTravelersCloak->points[5].x, 0);
    CHECK_EQ(pTravelersCloak->points[5].y, 0);
    CHECK(complexItemPictureTable.get(999999u) == nullptr);

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
