#include "doctest/doctest.h"

#include "engine/AssetFileSystem.h"
#include "engine/AssetScaleTier.h"
#include "engine/AudioSystem.h"
#include "game/FaceEnums.h"
#include "game/events/EventRuntime.h"
#include "game/events/EventDialogContent.h"
#include "game/gameplay/CorpseLootRuntime.h"
#include "game/gameplay/GameMechanics.h"
#include "game/gameplay/GameplayWorldItemInteraction.h"
#include "game/gameplay/SavePreviewImage.h"
#include "game/items/InventoryItemMixingRuntime.h"
#include "game/items/ItemRuntime.h"
#include "game/maps/IndoorSceneYml.h"
#include "game/maps/OutdoorSceneYml.h"
#include "game/maps/TerrainTileData.h"
#include "game/outdoor/OutdoorGeometryUtils.h"
#include "game/outdoor/OutdoorMovementController.h"
#include "game/party/Party.h"
#include "game/party/SpellIds.h"
#include "game/tables/JournalQuestTable.h"
#include "game/tables/SurfaceMaterialTable.h"

#include "tests/RegressionGameData.h"
#include "tests/PartySpellTestHarness.h"

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <filesystem>
#include <fstream>
#include <optional>
#include <random>
#include <sstream>

namespace
{
struct SyntheticOutdoorWaterBoundaryScenario
{
    OpenYAMM::Game::OutdoorMapData mapData = {};
    float landX = 0.0f;
    float landY = 0.0f;
    float waterX = 0.0f;
    float waterY = 0.0f;
};

class CorpseLootTestWorldRuntime : public OpenYAMM::Tests::PartySpellTestWorldRuntime
{
public:
    OpenYAMM::Game::GameplayCorpseViewState corpseView = {};
    std::vector<OpenYAMM::Game::GameplayHeldItemDropRequest> dropRequests;
    bool activeCorpse = true;
    bool allowDrop = true;

    std::optional<OpenYAMM::Game::GameplayHeldItemDropRequest> buildHeldItemDropRequest() const override
    {
        return OpenYAMM::Game::GameplayHeldItemDropRequest{
            .sourceX = 100.0f,
            .sourceY = 200.0f,
            .sourceZ = 300.0f,
            .yawRadians = 1.0f,
        };
    }

    bool dropHeldItemToWorld(const OpenYAMM::Game::GameplayHeldItemDropRequest &request) override
    {
        if (!allowDrop)
        {
            return false;
        }

        dropRequests.push_back(request);
        return true;
    }

    OpenYAMM::Game::GameplayCorpseViewState *activeCorpseView() override
    {
        return activeCorpse ? &corpseView : nullptr;
    }

    const OpenYAMM::Game::GameplayCorpseViewState *activeCorpseView() const override
    {
        return activeCorpse ? &corpseView : nullptr;
    }

    bool takeActiveCorpseItem(size_t itemIndex, OpenYAMM::Game::GameplayChestItemState &item) override
    {
        if (!activeCorpse || itemIndex >= corpseView.items.size())
        {
            return false;
        }

        item = corpseView.items[itemIndex];
        corpseView.items.erase(corpseView.items.begin() + static_cast<ptrdiff_t>(itemIndex));

        if (corpseView.items.empty())
        {
            activeCorpse = false;
        }

        return true;
    }

    void closeActiveCorpseView() override
    {
        activeCorpse = false;
    }
};

const OpenYAMM::Tests::RegressionGameData &requireRegressionGameData()
{
    REQUIRE_MESSAGE(
        OpenYAMM::Tests::regressionGameDataLoaded(),
        OpenYAMM::Tests::regressionGameDataFailure().c_str());
    return OpenYAMM::Tests::regressionGameData();
}

OpenYAMM::Game::Character makeRegressionPartyMember(
    const std::string &name,
    const std::string &className,
    const std::string &portraitTextureName,
    uint32_t characterDataId)
{
    OpenYAMM::Game::Character member = {};
    member.name = name;
    member.className = className;
    member.role = className;
    member.portraitTextureName = portraitTextureName;
    member.characterDataId = characterDataId;
    member.birthYear = 1160;
    member.experience = 0;
    member.level = 1;
    member.skillPoints = 5;
    member.might = 14;
    member.intellect = 14;
    member.personality = 14;
    member.endurance = 14;
    member.speed = 14;
    member.accuracy = 14;
    member.luck = 14;
    member.maxHealth = 40;
    member.health = 40;
    member.maxSpellPoints = 20;
    member.spellPoints = 20;
    return member;
}

OpenYAMM::Game::PartySeed createRegressionPartySeed()
{
    OpenYAMM::Game::PartySeed seed = {};
    seed.gold = 200;
    seed.food = 7;
    seed.members.push_back(makeRegressionPartyMember("Ariel", "Knight", "PC01-01", 1));
    seed.members.push_back(makeRegressionPartyMember("Brom", "Cleric", "PC03-01", 3));
    seed.members.push_back(makeRegressionPartyMember("Cedric", "Druid", "PC05-01", 5));
    seed.members.push_back(makeRegressionPartyMember("Daria", "Sorcerer", "PC07-01", 7));
    return seed;
}

OpenYAMM::Game::InventoryItem makeTestInventoryItem(uint32_t itemId, uint8_t width = 1, uint8_t height = 1)
{
    OpenYAMM::Game::InventoryItem item = {};
    item.objectDescriptionId = itemId;
    item.quantity = 1;
    item.width = width;
    item.height = height;
    return item;
}

OpenYAMM::Game::GameplayChestItemState makeTestCorpseItem(
    uint32_t itemId,
    uint8_t width = 1,
    uint8_t height = 1)
{
    OpenYAMM::Game::InventoryItem inventoryItem = makeTestInventoryItem(itemId, width, height);
    OpenYAMM::Game::GameplayChestItemState corpseItem = {};
    corpseItem.item = inventoryItem;
    corpseItem.itemId = itemId;
    corpseItem.quantity = 1;
    corpseItem.width = width;
    corpseItem.height = height;
    return corpseItem;
}

void fillMemberInventory(OpenYAMM::Game::Party &party, size_t memberIndex, uint32_t firstItemId)
{
    OpenYAMM::Game::Character *pMember = party.member(memberIndex);
    REQUIRE(pMember != nullptr);
    pMember->inventory.clear();

    uint32_t itemId = firstItemId;

    for (uint8_t y = 0; y < OpenYAMM::Game::Character::InventoryHeight; ++y)
    {
        for (uint8_t x = 0; x < OpenYAMM::Game::Character::InventoryWidth; ++x)
        {
            REQUIRE(pMember->addInventoryItemAt(makeTestInventoryItem(itemId++), x, y));
        }
    }
}

std::optional<OpenYAMM::Game::ScriptedEventProgram> loadSyntheticScriptedProgram(
    const std::string &body,
    const std::string &chunkName,
    OpenYAMM::Game::ScriptedEventScope scope,
    const std::vector<uint16_t> &onLoadEventIds = {})
{
    std::string error;
    std::string luaSourceText = body;
    luaSourceText += "\n";
    luaSourceText += "evt.meta = evt.meta or {}\n";
    luaSourceText += "evt.meta.map = evt.meta.map or {}\n";
    luaSourceText += "evt.meta.global = evt.meta.global or {}\n";
    luaSourceText += "evt.meta.CanShowTopic = evt.meta.CanShowTopic or {}\n";

    const char *pScopeName = scope == OpenYAMM::Game::ScriptedEventScope::Global ? "global" : "map";
    luaSourceText += "evt.meta.";
    luaSourceText += pScopeName;
    luaSourceText += ".onLoad = {";

    for (size_t index = 0; index < onLoadEventIds.size(); ++index)
    {
        if (index != 0)
        {
            luaSourceText += ", ";
        }

        luaSourceText += std::to_string(onLoadEventIds[index]);
    }

    luaSourceText += "}\n";
    luaSourceText += "evt.meta.";
    luaSourceText += pScopeName;
    luaSourceText += ".hint = {}\n";
    luaSourceText += "evt.meta.";
    luaSourceText += pScopeName;
    luaSourceText += ".summary = {}\n";
    luaSourceText += "evt.meta.";
    luaSourceText += pScopeName;
    luaSourceText += ".openedChestIds = {}\n";
    luaSourceText += "evt.meta.";
    luaSourceText += pScopeName;
    luaSourceText += ".textureNames = {}\n";
    luaSourceText += "evt.meta.";
    luaSourceText += pScopeName;
    luaSourceText += ".spriteNames = {}\n";
    luaSourceText += "evt.meta.";
    luaSourceText += pScopeName;
    luaSourceText += ".castSpellIds = {}\n";
    luaSourceText += "evt.meta.";
    luaSourceText += pScopeName;
    luaSourceText += ".timers = {}\n";

    const std::optional<OpenYAMM::Game::ScriptedEventProgram> program =
        OpenYAMM::Game::ScriptedEventProgram::loadFromLuaText(luaSourceText, chunkName, scope, error);
    INFO(error);
    return program;
}

std::optional<uint16_t> findSpecialEnchantId(
    const OpenYAMM::Game::SpecialItemEnchantTable &table,
    OpenYAMM::Game::SpecialItemEnchantKind kind)
{
    const std::vector<OpenYAMM::Game::SpecialItemEnchantEntry> &entries = table.entries();

    for (size_t index = 0; index < entries.size(); ++index)
    {
        if (entries[index].kind == kind)
        {
            return static_cast<uint16_t>(index + 1);
        }
    }

    return std::nullopt;
}

uint32_t findFirstItemIdBySkillGroup(const OpenYAMM::Game::ItemTable &itemTable, const std::string &skillGroup)
{
    for (const OpenYAMM::Game::ItemDefinition &entry : itemTable.entries())
    {
        if (entry.itemId != 0 && entry.skillGroup == skillGroup)
        {
            return entry.itemId;
        }
    }

    return 0;
}

bool isOutdoorLandMaskWaterForDiagnostics(
    const std::optional<std::vector<uint8_t>> &outdoorLandMask,
    float x,
    float y)
{
    if (!outdoorLandMask || outdoorLandMask->empty())
    {
        return false;
    }

    const float gridX = OpenYAMM::Game::outdoorWorldToGridXFloat(x);
    const float gridY = OpenYAMM::Game::outdoorWorldToGridYFloat(y);
    const int tileX = std::clamp(
        static_cast<int>(std::floor(gridX)),
        0,
        OpenYAMM::Game::OutdoorMapData::TerrainWidth - 2);
    const int tileY = std::clamp(
        static_cast<int>(std::floor(gridY)),
        0,
        OpenYAMM::Game::OutdoorMapData::TerrainHeight - 2);
    const int landMaskWidth = OpenYAMM::Game::OutdoorMapData::TerrainWidth - 1;
    const size_t tileIndex = static_cast<size_t>(tileY * landMaskWidth + tileX);

    if (tileIndex >= outdoorLandMask->size())
    {
        return false;
    }

    return (*outdoorLandMask)[tileIndex] == 0;
}

bool isOutdoorPositionWaterForDiagnostics(
    const OpenYAMM::Game::OutdoorMapData &outdoorMapData,
    const std::optional<std::vector<uint8_t>> &outdoorLandMask,
    float x,
    float y)
{
    return OpenYAMM::Game::isOutdoorTerrainWater(outdoorMapData, x, y)
        || isOutdoorLandMaskWaterForDiagnostics(outdoorLandMask, x, y);
}

SyntheticOutdoorWaterBoundaryScenario createSyntheticOutdoorWaterBoundaryScenario()
{
    SyntheticOutdoorWaterBoundaryScenario scenario = {};
    scenario.mapData.heightMap.resize(
        static_cast<size_t>(
            OpenYAMM::Game::OutdoorMapData::TerrainWidth * OpenYAMM::Game::OutdoorMapData::TerrainHeight),
        0);
    scenario.mapData.attributeMap.resize(
        static_cast<size_t>(
            OpenYAMM::Game::OutdoorMapData::TerrainWidth * OpenYAMM::Game::OutdoorMapData::TerrainHeight),
        0);

    const int landTileX = 63;
    const int landTileY = 63;
    const int waterTileX = 62;
    const int waterTileY = 63;
    const size_t waterTileIndex =
        static_cast<size_t>(waterTileY * OpenYAMM::Game::OutdoorMapData::TerrainWidth + waterTileX);

    if (waterTileIndex < scenario.mapData.attributeMap.size())
    {
        scenario.mapData.attributeMap[waterTileIndex] = 0x02;
    }

    const float halfTile = static_cast<float>(OpenYAMM::Game::OutdoorMapData::TerrainTileSize) * 0.5f;

    const auto tileCenter =
        [halfTile](int tileX, int tileY) -> std::pair<float, float>
    {
        const float worldX = OpenYAMM::Game::outdoorGridCornerWorldX(tileX) + halfTile;
        const float worldY = OpenYAMM::Game::outdoorGridCornerWorldY(tileY) - halfTile;
        return {worldX, worldY};
    };

    const auto [landX, landY] = tileCenter(landTileX, landTileY);
    const auto [waterX, waterY] = tileCenter(waterTileX, waterTileY);
    scenario.landX = landX;
    scenario.landY = landY;
    scenario.waterX = waterX;
    scenario.waterY = waterY;
    return scenario;
}

bool initializeTestAssetFileSystem(OpenYAMM::Engine::AssetFileSystem &assetFileSystem)
{
    const std::filesystem::path sourceRoot = OPENYAMM_SOURCE_DIR;
    const std::filesystem::path assetsRoot = sourceRoot / "assets_dev";
    return assetFileSystem.initialize(sourceRoot, assetsRoot, OpenYAMM::Engine::AssetScaleTier::X1);
}
}

TEST_CASE("party ground movement blocks water entry without water walk")
{
    const SyntheticOutdoorWaterBoundaryScenario boundary = createSyntheticOutdoorWaterBoundaryScenario();
    OpenYAMM::Game::OutdoorMovementController movementController(
        boundary.mapData,
        std::nullopt,
        std::nullopt,
        std::nullopt,
        std::nullopt);

    OpenYAMM::Game::OutdoorMoveState state = movementController.initializeState(boundary.landX, boundary.landY, 0.0f);
    const float moveVelocityX = (boundary.waterX - boundary.landX) * 2.0f;
    const float moveVelocityY = (boundary.waterY - boundary.landY) * 2.0f;
    const OpenYAMM::Game::OutdoorMoveState resolved = movementController.resolveMove(
        state,
        moveVelocityX,
        moveVelocityY,
        0.0f,
        false,
        false,
        false,
        false,
        false,
        512.0f,
        0.0f,
        4000.0f,
        0.5f);

    CHECK_FALSE(resolved.supportOnWater);
    CHECK_FALSE(isOutdoorPositionWaterForDiagnostics(boundary.mapData, std::nullopt, resolved.x, resolved.y));
}

TEST_CASE("outdoor terrain descriptors expose liquid flags for non-default tilesets")
{
    OpenYAMM::Engine::AssetFileSystem assetFileSystem;
    REQUIRE(initializeTestAssetFileSystem(assetFileSystem));

    OpenYAMM::Game::OutdoorMapData ironsand = {};
    ironsand.fileName = "out04.odm";
    ironsand.masterTile = 1;
    ironsand.tileSetLookupIndices = {594, 558, 450, 522};

    const std::optional<std::vector<OpenYAMM::Game::TerrainTileDescriptor>> ironsandDescriptors =
        OpenYAMM::Game::loadTerrainTileDescriptors(assetFileSystem, ironsand);
    REQUIRE(ironsandDescriptors.has_value());
    CHECK((*ironsandDescriptors)[1].textureName == "plntyl");
    CHECK((*ironsandDescriptors)[126].textureName == "lavtyl");
    CHECK(((*ironsandDescriptors)[126].flags & OpenYAMM::Game::TerrainTileFlagWater) != 0);
    CHECK(((*ironsandDescriptors)[126].flags & OpenYAMM::Game::TerrainTileFlagBurn) != 0);

    const std::filesystem::path ironsandScenePath =
        std::filesystem::path(OPENYAMM_SOURCE_DIR) / "assets_dev/worlds/mm8/maps/out04.scene.yml";
    std::ifstream ironsandSceneFile(ironsandScenePath);
    REQUIRE(ironsandSceneFile.good());
    std::ostringstream ironsandSceneText;
    ironsandSceneText << ironsandSceneFile.rdbuf();

    OpenYAMM::Game::OutdoorSceneYmlLoader sceneLoader = {};
    std::string sceneError;
    const std::optional<OpenYAMM::Game::OutdoorSceneData> ironsandScene =
        sceneLoader.loadFromText(ironsandSceneText.str(), sceneError);
    REQUIRE_MESSAGE(ironsandScene.has_value(), sceneError.c_str());
    OpenYAMM::Game::OutdoorSceneData mergedIronsandScene = *ironsandScene;

    const std::filesystem::path ironsandOverlayPath =
        std::filesystem::path(OPENYAMM_SOURCE_DIR) / "assets_dev/worlds/mm8/maps/out04_1.scene.yml";
    std::ifstream ironsandOverlayFile(ironsandOverlayPath);
    REQUIRE(ironsandOverlayFile.good());
    std::ostringstream ironsandOverlayText;
    ironsandOverlayText << ironsandOverlayFile.rdbuf();
    REQUIRE_MESSAGE(
        sceneLoader.applyOverlayFromText(mergedIronsandScene, ironsandOverlayText.str(), sceneError),
        sceneError.c_str());
    REQUIRE_EQ(mergedIronsandScene.terrainFootstepSoundOverrides.size(), 72u);
    CHECK_EQ(mergedIronsandScene.terrainFootstepSoundOverrides.front().tileId, 90);
    CHECK_EQ(mergedIronsandScene.terrainFootstepSoundOverrides.front().walkSoundId, 91u);
    CHECK_EQ(mergedIronsandScene.terrainFootstepSoundOverrides.front().runSoundId, 52u);
    const auto ironsandLavaOverride = std::find_if(
        mergedIronsandScene.terrainFootstepSoundOverrides.begin(),
        mergedIronsandScene.terrainFootstepSoundOverrides.end(),
        [](const OpenYAMM::Game::OutdoorSceneTerrainFootstepSoundOverride &overrideEntry)
        {
            return overrideEntry.tileId == 126;
        });
    REQUIRE(ironsandLavaOverride != mergedIronsandScene.terrainFootstepSoundOverrides.end());
    CHECK_EQ(ironsandLavaOverride->walkSoundId, 101u);
    CHECK_EQ(ironsandLavaOverride->runSoundId, 62u);
    const auto ironsandDefaultOverride = std::find_if(
        mergedIronsandScene.terrainFootstepSoundOverrides.begin(),
        mergedIronsandScene.terrainFootstepSoundOverrides.end(),
        [](const OpenYAMM::Game::OutdoorSceneTerrainFootstepSoundOverride &overrideEntry)
        {
            return overrideEntry.tileId == 162;
        });
    REQUIRE(ironsandDefaultOverride != mergedIronsandScene.terrainFootstepSoundOverrides.end());
    CHECK_EQ(ironsandDefaultOverride->walkSoundId, 90u);
    CHECK_EQ(ironsandDefaultOverride->runSoundId, 51u);

    OpenYAMM::Game::OutdoorMapData shadowspire = {};
    shadowspire.fileName = "out06.odm";
    shadowspire.masterTile = 2;
    shadowspire.tileSetLookupIndices = {702, 738, 666, 774};

    const std::optional<std::vector<OpenYAMM::Game::TerrainTileDescriptor>> shadowspireDescriptors =
        OpenYAMM::Game::loadTerrainTileDescriptors(assetFileSystem, shadowspire);
    REQUIRE(shadowspireDescriptors.has_value());
    CHECK((*shadowspireDescriptors)[1].textureName == "gdtyl");
    CHECK((*shadowspireDescriptors)[162].textureName == "tartyl");
    CHECK(((*shadowspireDescriptors)[162].flags & OpenYAMM::Game::TerrainTileFlagWater) != 0);
    CHECK(((*shadowspireDescriptors)[162].flags & OpenYAMM::Game::TerrainTileFlagBurn) == 0);
    CHECK((*shadowspireDescriptors)[174].textureName == "trne");
    CHECK(((*shadowspireDescriptors)[174].flags & OpenYAMM::Game::TerrainTileFlagTransition) != 0);

    const std::filesystem::path shadowspireScenePath =
        std::filesystem::path(OPENYAMM_SOURCE_DIR) / "assets_dev/worlds/mm8/maps/out06.scene.yml";
    std::ifstream shadowspireSceneFile(shadowspireScenePath);
    REQUIRE(shadowspireSceneFile.good());
    std::ostringstream shadowspireSceneText;
    shadowspireSceneText << shadowspireSceneFile.rdbuf();

    const std::optional<OpenYAMM::Game::OutdoorSceneData> shadowspireScene =
        sceneLoader.loadFromText(shadowspireSceneText.str(), sceneError);
    REQUIRE_MESSAGE(shadowspireScene.has_value(), sceneError.c_str());
    OpenYAMM::Game::OutdoorSceneData mergedShadowspireScene = *shadowspireScene;

    const std::filesystem::path shadowspireOverlayPath =
        std::filesystem::path(OPENYAMM_SOURCE_DIR) / "assets_dev/worlds/mm8/maps/out06_1.scene.yml";
    std::ifstream shadowspireOverlayFile(shadowspireOverlayPath);
    REQUIRE(shadowspireOverlayFile.good());
    std::ostringstream shadowspireOverlayText;
    shadowspireOverlayText << shadowspireOverlayFile.rdbuf();
    REQUIRE_MESSAGE(
        sceneLoader.applyOverlayFromText(mergedShadowspireScene, shadowspireOverlayText.str(), sceneError),
        sceneError.c_str());
    REQUIRE_EQ(mergedShadowspireScene.terrainFootstepSoundOverrides.size(), 12u);
    CHECK_EQ(mergedShadowspireScene.terrainFootstepSoundOverrides.front().tileId, 1);
    CHECK_EQ(mergedShadowspireScene.terrainFootstepSoundOverrides.front().walkSoundId, 101u);
    CHECK_EQ(mergedShadowspireScene.terrainFootstepSoundOverrides.front().runSoundId, 62u);
}

TEST_CASE("mm7 arena map fixups expose runtime restrictions and arena master topic")
{
    const std::filesystem::path arenaScenePath =
        std::filesystem::path(OPENYAMM_SOURCE_DIR) / "assets_dev/worlds/mm7/maps/7d05.scene.yml";
    std::ifstream arenaSceneFile(arenaScenePath);
    REQUIRE(arenaSceneFile.good());
    std::ostringstream arenaSceneText;
    arenaSceneText << arenaSceneFile.rdbuf();

    OpenYAMM::Game::IndoorSceneYmlLoader sceneLoader = {};
    std::string sceneError;
    const std::optional<OpenYAMM::Game::IndoorSceneData> arenaScene =
        sceneLoader.loadFromText(arenaSceneText.str(), sceneError);
    REQUIRE_MESSAGE(arenaScene.has_value(), sceneError.c_str());
    OpenYAMM::Game::IndoorSceneData mergedArenaScene = *arenaScene;

    const std::filesystem::path arenaOverlayPath =
        std::filesystem::path(OPENYAMM_SOURCE_DIR) / "assets_dev/worlds/mm7/maps/7d05_1.scene.yml";
    std::ifstream arenaOverlayFile(arenaOverlayPath);
    REQUIRE(arenaOverlayFile.good());
    std::ostringstream arenaOverlayText;
    arenaOverlayText << arenaOverlayFile.rdbuf();
    REQUIRE_MESSAGE(
        sceneLoader.applyOverlayFromText(mergedArenaScene, arenaOverlayText.str(), sceneError),
        sceneError.c_str());
    CHECK_FALSE(mergedArenaScene.runtimeRestrictions.allowSaveGame);
    CHECK_FALSE(mergedArenaScene.runtimeRestrictions.allowLloydsBeacon);
    CHECK(mergedArenaScene.runtimeRestrictions.isArena);

    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    const OpenYAMM::Game::NpcEntry *pArenaMaster = gameData.npcDialogTable.getNpc(639);
    REQUIRE(pArenaMaster != nullptr);
    REQUIRE_FALSE(pArenaMaster->topicIds.empty());
    CHECK_EQ(pArenaMaster->topicIds[0], 704u);
    CHECK(std::find(pArenaMaster->topicIds.begin(), pArenaMaster->topicIds.end(), 1149u)
          == pArenaMaster->topicIds.end());
}

TEST_CASE("mm8 arena map fixups expose runtime restrictions")
{
    const std::filesystem::path arenaScenePath =
        std::filesystem::path(OPENYAMM_SOURCE_DIR) / "assets_dev/worlds/mm8/maps/d42.scene.yml";
    std::ifstream arenaSceneFile(arenaScenePath);
    REQUIRE(arenaSceneFile.good());
    std::ostringstream arenaSceneText;
    arenaSceneText << arenaSceneFile.rdbuf();

    OpenYAMM::Game::IndoorSceneYmlLoader sceneLoader = {};
    std::string sceneError;
    const std::optional<OpenYAMM::Game::IndoorSceneData> arenaScene =
        sceneLoader.loadFromText(arenaSceneText.str(), sceneError);
    REQUIRE_MESSAGE(arenaScene.has_value(), sceneError.c_str());
    OpenYAMM::Game::IndoorSceneData mergedArenaScene = *arenaScene;

    const std::filesystem::path arenaOverlayPath =
        std::filesystem::path(OPENYAMM_SOURCE_DIR) / "assets_dev/worlds/mm8/maps/d42_1.scene.yml";
    std::ifstream arenaOverlayFile(arenaOverlayPath);
    REQUIRE(arenaOverlayFile.good());
    std::ostringstream arenaOverlayText;
    arenaOverlayText << arenaOverlayFile.rdbuf();
    REQUIRE_MESSAGE(
        sceneLoader.applyOverlayFromText(mergedArenaScene, arenaOverlayText.str(), sceneError),
        sceneError.c_str());
    CHECK_FALSE(mergedArenaScene.runtimeRestrictions.allowSaveGame);
    CHECK_FALSE(mergedArenaScene.runtimeRestrictions.allowLloydsBeacon);
    CHECK(mergedArenaScene.runtimeRestrictions.isArena);
}

TEST_CASE("mm7 Temple of the Moon scene keeps MMerge initial door states")
{
    const std::filesystem::path scenePath =
        std::filesystem::path(OPENYAMM_SOURCE_DIR) / "assets_dev/worlds/mm7/maps/7d06.scene.yml";
    std::ifstream sceneFile(scenePath);
    REQUIRE(sceneFile.good());
    std::ostringstream sceneText;
    sceneText << sceneFile.rdbuf();

    OpenYAMM::Game::IndoorSceneYmlLoader sceneLoader = {};
    std::string sceneError;
    const std::optional<OpenYAMM::Game::IndoorSceneData> scene =
        sceneLoader.loadFromText(sceneText.str(), sceneError);
    REQUIRE_MESSAGE(scene.has_value(), sceneError.c_str());

    const auto checkDoorState =
        [&](uint32_t doorId, uint16_t expectedState)
        {
            const auto doorIt = std::find_if(
                scene->initialState.doors.begin(),
                scene->initialState.doors.end(),
                [doorId](const OpenYAMM::Game::IndoorSceneDoor &door)
                {
                    return door.door.doorId == doorId;
                });
            REQUIRE(doorIt != scene->initialState.doors.end());
            CHECK_EQ(doorIt->door.state, expectedState);
        };

    for (uint32_t doorId : {5u, 6u, 7u, 8u})
    {
        checkDoorState(doorId, 2u);
    }

    for (uint32_t doorId : {9u, 10u})
    {
        checkDoorState(doorId, 0u);
    }
}

TEST_CASE("outdoor terrain descriptors use mm6 and mm7 merged tile tables")
{
    OpenYAMM::Engine::AssetFileSystem assetFileSystem;
    REQUIRE(initializeTestAssetFileSystem(assetFileSystem));

    const std::optional<std::string> surfaceMaterialYaml =
        assetFileSystem.readTextFile("Data/rendering/surface_materials.yml");
    REQUIRE(surfaceMaterialYaml.has_value());

    OpenYAMM::Game::SurfaceMaterialTable surfaceMaterialTable;
    std::string surfaceMaterialError;
    REQUIRE(surfaceMaterialTable.loadFromYaml(*surfaceMaterialYaml, surfaceMaterialError));
    const OpenYAMM::Game::SurfaceMaterialDefinition *pMm6WaterMaterial =
        surfaceMaterialTable.findMatch("6wtrtyl", 0, true);
    REQUIRE(pMm6WaterMaterial != nullptr);
    REQUIRE(pMm6WaterMaterial->animation.frames.size() == 14);
    CHECK(pMm6WaterMaterial->animation.animationLengthTicks == 210);
    CHECK(pMm6WaterMaterial->animation.frames.front().textureName == "6hdwtr000");
    CHECK(pMm6WaterMaterial->animation.frames.back().textureName == "6hdwtr013");

    for (const OpenYAMM::Game::SurfaceAnimationFrame &frame : pMm6WaterMaterial->animation.frames)
    {
        CHECK(frame.frameLengthTicks == 15);
    }

    REQUIRE(surfaceMaterialTable.findMatch("6wtrdrNE", 0, true) != nullptr);

    const OpenYAMM::Game::SurfaceMaterialDefinition *pMm7WaterMaterial =
        surfaceMaterialTable.findMatch("7wtrtyl", 0, true);
    REQUIRE(pMm7WaterMaterial != nullptr);
    CHECK(pMm7WaterMaterial->animation.frames.front().textureName == "7hdwtr000");
    CHECK(pMm7WaterMaterial->animation.frames.back().textureName == "7hdwtr013");
    REQUIRE(surfaceMaterialTable.findMatch("7hwtrdrne", 0, true) != nullptr);

    const OpenYAMM::Game::SurfaceMaterialDefinition *pMm8WaterMaterial =
        surfaceMaterialTable.findMatch("wtrtyl", 0, true);
    REQUIRE(pMm8WaterMaterial != nullptr);
    CHECK(pMm8WaterMaterial->animation.frames.front().textureName == "hdwtr000");
    CHECK(pMm8WaterMaterial->animation.frames.back().textureName == "hdwtr013");

    const OpenYAMM::Game::SurfaceMaterialDefinition *pLavaMaterial =
        surfaceMaterialTable.findMatch("lavtyl", 0, true);
    REQUIRE(pLavaMaterial != nullptr);
    REQUIRE(pLavaMaterial->animation.frames.size() == 14);
    CHECK(pLavaMaterial->animation.frames.front().textureName == "hdlav000");
    CHECK(pLavaMaterial->animation.frames.back().textureName == "hdlav013");

    const OpenYAMM::Game::SurfaceMaterialDefinition *pOilMaterial =
        surfaceMaterialTable.findMatch("tartyl", 0, true);
    REQUIRE(pOilMaterial != nullptr);
    REQUIRE(pOilMaterial->animation.frames.size() == 14);
    CHECK(pOilMaterial->animation.frames.front().textureName == "hwoil000");
    CHECK(pOilMaterial->animation.frames.back().textureName == "hwoil013");

    OpenYAMM::Game::OutdoorMapData newSorpigal = {};
    newSorpigal.fileName = "oute3.odm";
    newSorpigal.masterTile = 2;
    newSorpigal.tileSetLookupIndices = {90, 126, 198, 774};

    const std::optional<std::vector<OpenYAMM::Game::TerrainTileDescriptor>> newSorpigalDescriptors =
        OpenYAMM::Game::loadTerrainTileDescriptors(assetFileSystem, newSorpigal);
    REQUIRE(newSorpigalDescriptors.has_value());
    CHECK((*newSorpigalDescriptors)[1].textureName == "6dirttyl");
    CHECK((*newSorpigalDescriptors)[90].textureName == "6grastyl");
    CHECK((*newSorpigalDescriptors)[126].textureName == "6wtrtyl");
    CHECK(((*newSorpigalDescriptors)[126].flags & OpenYAMM::Game::TerrainTileFlagWater) != 0);

    OpenYAMM::Game::OutdoorMapData emeraldIsland = {};
    emeraldIsland.fileName = "7out01.odm";
    emeraldIsland.masterTile = 1;
    emeraldIsland.tileSetLookupIndices = {90, 126, 270, 414};

    const std::optional<std::vector<OpenYAMM::Game::TerrainTileDescriptor>> emeraldIslandDescriptors =
        OpenYAMM::Game::loadTerrainTileDescriptors(assetFileSystem, emeraldIsland);
    REQUIRE(emeraldIslandDescriptors.has_value());
    CHECK((*emeraldIslandDescriptors)[1].textureName == "7dirttyl");
    CHECK((*emeraldIslandDescriptors)[90].textureName == "7grastyl");
    CHECK((*emeraldIslandDescriptors)[126].textureName == "7wtrtyl");
    CHECK(((*emeraldIslandDescriptors)[126].flags & OpenYAMM::Game::TerrainTileFlagWater) != 0);
    CHECK(assetFileSystem.exists("terrain/7wtrtyl.bmp"));
}

TEST_CASE("outdoor terrain descriptor flags are applied to movement attributes")
{
    OpenYAMM::Engine::AssetFileSystem assetFileSystem;
    REQUIRE(initializeTestAssetFileSystem(assetFileSystem));

    OpenYAMM::Game::OutdoorMapData mapData = {};
    mapData.fileName = "out04.odm";
    mapData.masterTile = 1;
    mapData.tileSetLookupIndices = {594, 558, 450, 522};
    mapData.tileMap.assign(
        static_cast<size_t>(OpenYAMM::Game::OutdoorMapData::TerrainWidth)
            * static_cast<size_t>(OpenYAMM::Game::OutdoorMapData::TerrainHeight),
        90);
    mapData.attributeMap.assign(mapData.tileMap.size(), 0);

    const size_t lavaCellIndex =
        static_cast<size_t>(63 * OpenYAMM::Game::OutdoorMapData::TerrainWidth + 63);
    mapData.tileMap[lavaCellIndex] = 126;

    REQUIRE(OpenYAMM::Game::applyTerrainTileDescriptorAttributes(assetFileSystem, mapData));
    CHECK((mapData.attributeMap[lavaCellIndex] & 0x02) != 0);
    CHECK((mapData.attributeMap[lavaCellIndex] & 0x01) != 0);
}

TEST_CASE("world item pickup decision prefers inventory before held item")
{
    const OpenYAMM::Game::GameplayWorldItemPickupDecision decision =
        OpenYAMM::Game::GameplayWorldItemInteraction::decidePickupDestination(
            OpenYAMM::Game::GameplayWorldItemPickupDecisionInput{
                .isGold = false,
                .goldAmount = 0,
                .canStoreInInventory = true,
                .heldItemActive = false,
            });

    CHECK(decision.destination == OpenYAMM::Game::GameplayWorldItemPickupDestination::Inventory);
    CHECK(decision.goldAmount == 0);
}

TEST_CASE("world item pickup decision falls back to held item only when hand is empty")
{
    const OpenYAMM::Game::GameplayWorldItemPickupDecision emptyHandDecision =
        OpenYAMM::Game::GameplayWorldItemInteraction::decidePickupDestination(
            OpenYAMM::Game::GameplayWorldItemPickupDecisionInput{
                .isGold = false,
                .goldAmount = 0,
                .canStoreInInventory = false,
                .heldItemActive = false,
            });
    const OpenYAMM::Game::GameplayWorldItemPickupDecision occupiedHandDecision =
        OpenYAMM::Game::GameplayWorldItemInteraction::decidePickupDestination(
            OpenYAMM::Game::GameplayWorldItemPickupDecisionInput{
                .isGold = false,
                .goldAmount = 0,
                .canStoreInInventory = false,
                .heldItemActive = true,
            });

    CHECK(emptyHandDecision.destination == OpenYAMM::Game::GameplayWorldItemPickupDestination::HeldItem);
    CHECK(occupiedHandDecision.destination == OpenYAMM::Game::GameplayWorldItemPickupDestination::None);
}

TEST_CASE("world item pickup decision always accepts gold")
{
    const OpenYAMM::Game::GameplayWorldItemPickupDecision decision =
        OpenYAMM::Game::GameplayWorldItemInteraction::decidePickupDestination(
            OpenYAMM::Game::GameplayWorldItemPickupDecisionInput{
                .isGold = true,
                .goldAmount = 0,
                .canStoreInInventory = false,
                .heldItemActive = true,
            });

    CHECK(decision.destination == OpenYAMM::Game::GameplayWorldItemPickupDestination::Gold);
    CHECK(decision.goldAmount == 1);
}

TEST_CASE("corpse auto loot tries members from active member before using cursor")
{
    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());
    REQUIRE(party.setActiveMemberIndex(1));
    fillMemberInventory(party, 1, 1000);

    CorpseLootTestWorldRuntime worldRuntime = {};
    worldRuntime.corpseView.items.push_back(makeTestCorpseItem(2000, 2, 2));
    OpenYAMM::Game::GameplayUiController::HeldInventoryItemState heldItem = {};

    const OpenYAMM::Game::GameplayCorpseAutoLootResult result =
        OpenYAMM::Game::autoLootActiveCorpseView(worldRuntime, party, nullptr, &heldItem);

    REQUIRE(result.lootedAny);
    CHECK_FALSE(heldItem.active);
    CHECK(worldRuntime.dropRequests.empty());

    const OpenYAMM::Game::Character *pActiveMember = party.member(1);
    const OpenYAMM::Game::Character *pNextMember = party.member(2);

    REQUIRE(pActiveMember != nullptr);
    REQUIRE(pNextMember != nullptr);
    CHECK(std::none_of(
        pActiveMember->inventory.begin(),
        pActiveMember->inventory.end(),
        [](const OpenYAMM::Game::InventoryItem &item)
        {
            return item.objectDescriptionId == 2000;
        }));
    CHECK(std::any_of(
        pNextMember->inventory.begin(),
        pNextMember->inventory.end(),
        [](const OpenYAMM::Game::InventoryItem &item)
        {
            return item.objectDescriptionId == 2000;
        }));
}

TEST_CASE("corpse auto loot drops occupied cursor item before holding unplaced corpse item")
{
    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());

    for (size_t memberIndex = 0; memberIndex < party.members().size(); ++memberIndex)
    {
        fillMemberInventory(party, memberIndex, 3000 + static_cast<uint32_t>(memberIndex) * 200);
    }

    CorpseLootTestWorldRuntime worldRuntime = {};
    worldRuntime.corpseView.items.push_back(makeTestCorpseItem(5000, 2, 2));

    OpenYAMM::Game::GameplayUiController::HeldInventoryItemState heldItem = {};
    heldItem.active = true;
    heldItem.item = makeTestInventoryItem(4000, 1, 1);

    const OpenYAMM::Game::GameplayCorpseAutoLootResult result =
        OpenYAMM::Game::autoLootActiveCorpseView(worldRuntime, party, nullptr, &heldItem);

    REQUIRE(result.lootedAny);
    REQUIRE(heldItem.active);
    CHECK_EQ(heldItem.item.objectDescriptionId, 5000u);
    REQUIRE_EQ(worldRuntime.dropRequests.size(), 1u);
    CHECK_EQ(worldRuntime.dropRequests.front().item.objectDescriptionId, 4000u);
}

TEST_CASE("corpse auto loot silently closes empty corpse view")
{
    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());

    CorpseLootTestWorldRuntime worldRuntime = {};
    REQUIRE(worldRuntime.activeCorpseView() != nullptr);

    const OpenYAMM::Game::GameplayCorpseAutoLootResult result =
        OpenYAMM::Game::autoLootActiveCorpseView(worldRuntime, party, nullptr, nullptr);

    CHECK_FALSE(result.lootedAny);
    CHECK_FALSE(result.blockedByInventory);
    CHECK(result.empty);
    CHECK(result.statusText.empty());
    CHECK(worldRuntime.activeCorpseView() == nullptr);
}

TEST_CASE("charged wand attack profile prefers wand over equipped bow")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    OpenYAMM::Game::Character member = makeRegressionPartyMember("Ariel", "Knight", "PC01-01", 1);
    member.equipment.mainHand = 152;
    member.equipmentRuntime.mainHand.currentCharges = 3;
    member.equipmentRuntime.mainHand.maxCharges = 3;
    member.equipment.bow = findFirstItemIdBySkillGroup(gameData.itemTable, "Bow");
    member.equipmentRuntime.bow = {};

    const OpenYAMM::Game::CharacterAttackProfile profile =
        OpenYAMM::Game::GameMechanics::buildCharacterAttackProfile(
            member,
            &gameData.itemTable,
            &gameData.spellTable);
    std::mt19937 rng(7);
    const OpenYAMM::Game::CharacterAttackResult attack =
        OpenYAMM::Game::GameMechanics::resolveCharacterAttackAgainstArmorClass(
            member,
            &gameData.itemTable,
            &gameData.spellTable,
            10,
            1024.0f,
            rng);

    CHECK(profile.hasWand);
    CHECK(profile.hasBow);
    CHECK_EQ(profile.wandSpellId, OpenYAMM::Game::spellIdValue(OpenYAMM::Game::SpellId::FireBolt));
    CHECK_EQ(profile.rangedSkillLevel, 8u);
    CHECK_EQ(profile.rangedSkillMastery, static_cast<uint32_t>(OpenYAMM::Game::SkillMastery::Normal));
    CHECK(attack.mode == OpenYAMM::Game::CharacterAttackMode::Wand);
}

TEST_CASE("empty wand falls back to bow attack profile")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    OpenYAMM::Game::Character member = makeRegressionPartyMember("Ariel", "Knight", "PC01-01", 1);
    member.equipment.mainHand = 152;
    member.equipmentRuntime.mainHand.currentCharges = 0;
    member.equipmentRuntime.mainHand.maxCharges = 3;
    member.equipment.bow = findFirstItemIdBySkillGroup(gameData.itemTable, "Bow");
    member.equipmentRuntime.bow = {};

    const OpenYAMM::Game::CharacterAttackProfile profile =
        OpenYAMM::Game::GameMechanics::buildCharacterAttackProfile(
            member,
            &gameData.itemTable,
            &gameData.spellTable);
    std::mt19937 rng(7);
    const OpenYAMM::Game::CharacterAttackResult attack =
        OpenYAMM::Game::GameMechanics::resolveCharacterAttackAgainstArmorClass(
            member,
            &gameData.itemTable,
            &gameData.spellTable,
            10,
            1024.0f,
            rng);

    CHECK_FALSE(profile.hasWand);
    CHECK(profile.hasBow);
    CHECK(attack.mode == OpenYAMM::Game::CharacterAttackMode::Bow);
}

TEST_CASE("main-hand blaster shoots before bow and can reach zero recovery")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    OpenYAMM::Game::Character member = makeRegressionPartyMember("Ariel", "Knight", "PC01-01", 1);
    member.equipment.mainHand = findFirstItemIdBySkillGroup(gameData.itemTable, "Blaster");
    member.equipment.bow = findFirstItemIdBySkillGroup(gameData.itemTable, "Bow");
    member.skills["Blaster"] = {"Blaster", 10, OpenYAMM::Game::SkillMastery::Grandmaster};
    member.attackRecoveryReductionTicks = 1000;
    REQUIRE(member.equipment.mainHand != 0);
    REQUIRE(member.equipment.bow != 0);

    const OpenYAMM::Game::CharacterAttackProfile profile =
        OpenYAMM::Game::GameMechanics::buildCharacterAttackProfile(
            member,
            &gameData.itemTable,
            &gameData.spellTable);
    std::mt19937 rng(7);
    const OpenYAMM::Game::CharacterAttackResult attack =
        OpenYAMM::Game::GameMechanics::resolveCharacterAttackAgainstArmorClass(
            member,
            &gameData.itemTable,
            &gameData.spellTable,
            10,
            1024.0f,
            rng);

    CHECK(profile.hasBlaster);
    CHECK(profile.hasBow);
    REQUIRE(profile.rangedAttackBonus.has_value());
    CHECK_EQ(profile.rangedSkillLevel, 10u);
    CHECK_EQ(profile.rangedSkillMastery, static_cast<uint32_t>(OpenYAMM::Game::SkillMastery::Grandmaster));
    CHECK(profile.rangedRecoverySeconds == doctest::Approx(0.0f));
    CHECK(attack.mode == OpenYAMM::Game::CharacterAttackMode::Blaster);
    CHECK(attack.resolvesOnImpact);
    CHECK(attack.recoverySeconds == doctest::Approx(0.0f));
    CHECK(attack.attackSoundHook == "blaster_shot");
}

TEST_CASE("dragon character normal attack uses dragon ability firebolt profile")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    OpenYAMM::Game::Character member = makeRegressionPartyMember("Duroth", "Dragon", "PC13-01", 13);
    member.skills["DragonAbility"] = {"DragonAbility", 9, OpenYAMM::Game::SkillMastery::Master};
    member.equipment.mainHand = 152;
    member.equipmentRuntime.mainHand.currentCharges = 3;
    member.equipmentRuntime.mainHand.maxCharges = 3;
    member.equipment.bow = findFirstItemIdBySkillGroup(gameData.itemTable, "Bow");

    const OpenYAMM::Game::CharacterAttackProfile profile =
        OpenYAMM::Game::GameMechanics::buildCharacterAttackProfile(
            member,
            &gameData.itemTable,
            &gameData.spellTable);
    std::mt19937 rng(7);
    const OpenYAMM::Game::CharacterAttackResult attack =
        OpenYAMM::Game::GameMechanics::resolveCharacterAttackAgainstArmorClass(
            member,
            &gameData.itemTable,
            &gameData.spellTable,
            100,
            1024.0f,
            rng);

    CHECK(profile.hasDragonBreath);
    CHECK_EQ(profile.rangedAttackBonus, 9);
    CHECK_EQ(profile.rangedMinDamage, 9);
    CHECK_EQ(profile.rangedMaxDamage, 90);
    CHECK_EQ(
        profile.rangedSpellId,
        OpenYAMM::Game::spellIdValue(OpenYAMM::Game::SpellId::FireBolt));
    CHECK(attack.mode == OpenYAMM::Game::CharacterAttackMode::DragonBreath);
    CHECK(attack.resolvesOnImpact);
    CHECK(attack.hit);
    CHECK(attack.damageType == OpenYAMM::Game::CombatDamageType::Irresistible);
    CHECK_EQ(
        attack.spellId,
        OpenYAMM::Game::spellIdValue(OpenYAMM::Game::SpellId::FireBolt));
    CHECK(attack.attackBonus == 9);
    CHECK(attack.damage >= 9);
    CHECK(attack.damage <= 90);
}

TEST_CASE("starting dragon ability deals one to ten damage")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    OpenYAMM::Game::Character member = makeRegressionPartyMember("Duroth", "Dragon", "PC13-01", 13);
    member.skills["DragonAbility"] = {"DragonAbility", 1, OpenYAMM::Game::SkillMastery::Normal};

    const OpenYAMM::Game::CharacterAttackProfile profile =
        OpenYAMM::Game::GameMechanics::buildCharacterAttackProfile(
            member,
            &gameData.itemTable,
            &gameData.spellTable);

    CHECK(profile.hasDragonBreath);
    CHECK_EQ(profile.rangedAttackBonus, 1);
    CHECK_EQ(profile.rangedMinDamage, 1);
    CHECK_EQ(profile.rangedMaxDamage, 10);
}

TEST_CASE("dragon breath ranged recovery uses dragon breath spell data")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    OpenYAMM::Game::Character member = makeRegressionPartyMember("Duroth", "Dragon", "PC13-01", 13);
    member.skills["DragonAbility"] = {"DragonAbility", 9, OpenYAMM::Game::SkillMastery::Master};

    const OpenYAMM::Game::CharacterAttackProfile profile =
        OpenYAMM::Game::GameMechanics::buildCharacterAttackProfile(
            member,
            &gameData.itemTable,
            &gameData.spellTable);

    CHECK(profile.hasDragonBreath);
    CHECK(profile.rangedRecoverySeconds == doctest::Approx(2.0f));
}

TEST_CASE("equipped wand charge consumption decrements to empty and then stops")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    OpenYAMM::Game::PartySeed seed = {};
    seed.members.push_back(makeRegressionPartyMember("Ariel", "Knight", "PC01-01", 1));

    OpenYAMM::Game::Party party = {};
    party.setItemTable(&gameData.itemTable);
    party.seed(seed);

    OpenYAMM::Game::Character *pMember = party.member(0);
    REQUIRE(pMember != nullptr);
    pMember->equipment.mainHand = 152;
    pMember->equipmentRuntime.mainHand.currentCharges = 2;
    pMember->equipmentRuntime.mainHand.maxCharges = 2;

    CHECK(party.consumeEquippedWandCharge(0));
    CHECK_EQ(pMember->equipmentRuntime.mainHand.currentCharges, 1u);
    CHECK(party.consumeEquippedWandCharge(0));
    CHECK_EQ(pMember->equipmentRuntime.mainHand.currentCharges, 0u);
    CHECK_FALSE(party.consumeEquippedWandCharge(0));
}

TEST_CASE("inventory mixing creates reagent potion in target bottle")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    OpenYAMM::Game::PartySeed seed = {};
    seed.members.push_back(makeRegressionPartyMember("Ariel", "Knight", "PC01-01", 1));

    OpenYAMM::Game::Party party = {};
    party.setItemTable(&gameData.itemTable);
    party.seed(seed);

    OpenYAMM::Game::Character *pMember = party.member(0);
    REQUIRE(pMember != nullptr);
    pMember->skills["Alchemy"] = {"Alchemy", 2, OpenYAMM::Game::SkillMastery::Normal};

    OpenYAMM::Game::InventoryItem bottle = {};
    bottle.objectDescriptionId = 220;
    REQUIRE(pMember->addInventoryItemAt(bottle, 0, 0));

    OpenYAMM::Game::InventoryItem heldReagent = {};
    heldReagent.objectDescriptionId = 200;

    const OpenYAMM::Game::InventoryItemMixResult result =
        OpenYAMM::Game::InventoryItemMixingRuntime::tryApplyHeldItemToInventoryItem(
            party,
            0,
            heldReagent,
            0,
            0,
            gameData.itemTable,
            gameData.potionMixingTable,
            gameData.mergedPotionSettingTable,
            gameData.mergedReagentSettingTable);

    REQUIRE(result.handled);
    CHECK(result.success);
    CHECK(result.heldItemConsumed);

    const OpenYAMM::Game::InventoryItem *pMixedPotion = pMember->inventoryItemAt(0, 0);
    REQUIRE(pMixedPotion != nullptr);
    CHECK_EQ(pMixedPotion->objectDescriptionId, 222u);
    CHECK_EQ(pMixedPotion->standardEnchantPower, 3u);
}

TEST_CASE("inventory mixing creates reagent potion when held bottle is used on reagent")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    OpenYAMM::Game::PartySeed seed = {};
    seed.members.push_back(makeRegressionPartyMember("Ariel", "Knight", "PC01-01", 1));

    OpenYAMM::Game::Party party = {};
    party.setItemTable(&gameData.itemTable);
    party.seed(seed);

    OpenYAMM::Game::Character *pMember = party.member(0);
    REQUIRE(pMember != nullptr);
    pMember->skills["Alchemy"] = {"Alchemy", 2, OpenYAMM::Game::SkillMastery::Normal};

    OpenYAMM::Game::InventoryItem reagent = {};
    reagent.objectDescriptionId = 200;
    REQUIRE(pMember->addInventoryItemAt(reagent, 0, 0));

    OpenYAMM::Game::InventoryItem heldBottle = {};
    heldBottle.objectDescriptionId = 220;

    const OpenYAMM::Game::InventoryItemMixResult result =
        OpenYAMM::Game::InventoryItemMixingRuntime::tryApplyHeldItemToInventoryItem(
            party,
            0,
            heldBottle,
            0,
            0,
            gameData.itemTable,
            gameData.potionMixingTable,
            gameData.mergedPotionSettingTable,
            gameData.mergedReagentSettingTable,
            &gameData.potionNoteTable);

    REQUIRE(result.handled);
    CHECK(result.success);
    CHECK(result.heldItemConsumed);

    const OpenYAMM::Game::InventoryItem *pMixedPotion = pMember->inventoryItemAt(0, 0);
    REQUIRE(pMixedPotion != nullptr);
    CHECK_EQ(pMixedPotion->objectDescriptionId, 222u);
    CHECK_EQ(pMixedPotion->standardEnchantPower, 3u);
}

TEST_CASE("inventory mixing accepts merged reagent item ids")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    OpenYAMM::Game::PartySeed seed = {};
    seed.members.push_back(makeRegressionPartyMember("Ariel", "Knight", "PC01-01", 1));

    OpenYAMM::Game::Party party = {};
    party.setItemTable(&gameData.itemTable);
    party.seed(seed);

    OpenYAMM::Game::Character *pMember = party.member(0);
    REQUIRE(pMember != nullptr);
    pMember->skills["Alchemy"] = {"Alchemy", 2, OpenYAMM::Game::SkillMastery::Normal};

    OpenYAMM::Game::InventoryItem bottle = {};
    bottle.objectDescriptionId = 220;
    REQUIRE(pMember->addInventoryItemAt(bottle, 0, 0));

    OpenYAMM::Game::InventoryItem heldReagent = {};
    heldReagent.objectDescriptionId = 1002;

    const OpenYAMM::Game::InventoryItemMixResult result =
        OpenYAMM::Game::InventoryItemMixingRuntime::tryApplyHeldItemToInventoryItem(
            party,
            0,
            heldReagent,
            0,
            0,
            gameData.itemTable,
            gameData.potionMixingTable,
            gameData.mergedPotionSettingTable,
            gameData.mergedReagentSettingTable);

    REQUIRE(result.handled);
    CHECK(result.success);
    CHECK(result.heldItemConsumed);

    const OpenYAMM::Game::InventoryItem *pMixedPotion = pMember->inventoryItemAt(0, 0);
    REQUIRE(pMixedPotion != nullptr);
    CHECK_EQ(pMixedPotion->objectDescriptionId, 222u);
    CHECK_EQ(pMixedPotion->standardEnchantPower, 3u);
}

TEST_CASE("inventory mixing combines valid potions and returns an empty bottle")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    OpenYAMM::Game::PartySeed seed = {};
    seed.members.push_back(makeRegressionPartyMember("Ariel", "Knight", "PC01-01", 1));

    OpenYAMM::Game::Party party = {};
    party.setItemTable(&gameData.itemTable);
    party.seed(seed);

    OpenYAMM::Game::Character *pMember = party.member(0);
    REQUIRE(pMember != nullptr);
    pMember->skills["Alchemy"] = {"Alchemy", 2, OpenYAMM::Game::SkillMastery::Expert};

    OpenYAMM::Game::InventoryItem targetPotion = {};
    targetPotion.objectDescriptionId = 223;
    targetPotion.standardEnchantPower = 20;
    REQUIRE(pMember->addInventoryItemAt(targetPotion, 0, 0));

    OpenYAMM::Game::InventoryItem heldPotion = {};
    heldPotion.objectDescriptionId = 222;
    heldPotion.standardEnchantPower = 10;

    const OpenYAMM::Game::InventoryItemMixResult result =
        OpenYAMM::Game::InventoryItemMixingRuntime::tryApplyHeldItemToInventoryItem(
            party,
            0,
            heldPotion,
            0,
            0,
            gameData.itemTable,
            gameData.potionMixingTable,
            gameData.mergedPotionSettingTable,
            gameData.mergedReagentSettingTable,
            &gameData.potionNoteTable);

    REQUIRE(result.handled);
    CHECK(result.success);
    CHECK(result.heldItemConsumed);
    CHECK_FALSE(result.heldItemReplacement.has_value());
    CHECK_EQ(result.unlockedAutonoteId, 33u);

    const OpenYAMM::Game::InventoryItem *pMixedPotion = pMember->inventoryItemAt(0, 0);
    REQUIRE(pMixedPotion != nullptr);
    CHECK_EQ(pMixedPotion->objectDescriptionId, 226u);
    CHECK_EQ(pMixedPotion->standardEnchantPower, 15u);
    const bool hasReturnedBottle =
        pMember->inventoryItemAt(1, 0) != nullptr
        || pMember->inventoryItemAt(0, 1) != nullptr;
    CHECK(hasReturnedBottle);
}

TEST_CASE("inventory mixing invalid potion combination consumes both items")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    OpenYAMM::Game::PartySeed seed = {};
    seed.members.push_back(makeRegressionPartyMember("Ariel", "Knight", "PC01-01", 1));

    OpenYAMM::Game::Party party = {};
    party.setItemTable(&gameData.itemTable);
    party.seed(seed);

    OpenYAMM::Game::Character *pMember = party.member(0);
    REQUIRE(pMember != nullptr);

    OpenYAMM::Game::InventoryItem targetPotion = {};
    targetPotion.objectDescriptionId = 226;
    REQUIRE(pMember->addInventoryItemAt(targetPotion, 0, 0));

    OpenYAMM::Game::InventoryItem heldPotion = {};
    heldPotion.objectDescriptionId = 240;

    const OpenYAMM::Game::InventoryItemMixResult result =
        OpenYAMM::Game::InventoryItemMixingRuntime::tryApplyHeldItemToInventoryItem(
            party,
            0,
            heldPotion,
            0,
            0,
            gameData.itemTable,
            gameData.potionMixingTable,
            gameData.mergedPotionSettingTable,
            gameData.mergedReagentSettingTable);

    REQUIRE(result.handled);
    CHECK_FALSE(result.success);
    CHECK(result.heldItemConsumed);
    CHECK(result.targetItemRemoved);
    CHECK_EQ(result.failureDamageLevel, 3u);
    CHECK(pMember->inventoryItemAt(0, 0) == nullptr);
}

TEST_CASE("potion mixing table uses merged potion matrix columns")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();

    CHECK_EQ(gameData.potionMixingTable.combinationCount(), 4900u);

    const std::optional<OpenYAMM::Game::PotionMixingTable::PotionCombination> stoneToFleshWithMagic =
        gameData.potionMixingTable.potionCombination(262, 223);
    REQUIRE(stoneToFleshWithMagic.has_value());
    CHECK_EQ(stoneToFleshWithMagic->resultItemId, 806u);

    const std::optional<OpenYAMM::Game::PotionMixingTable::PotionCombination> strangeSelf =
        gameData.potionMixingTable.potionCombination(806, 806);
    REQUIRE(strangeSelf.has_value());
    CHECK(strangeSelf->noMix);
}

TEST_CASE("potion note table maps successful mixes to autonotes")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();

    CHECK_GT(gameData.potionNoteTable.entryCount(), 100u);

    const std::optional<uint32_t> redBlueNote = gameData.potionNoteTable.autonoteIdForMix(223u, 222u);
    REQUIRE(redBlueNote.has_value());
    CHECK_EQ(*redBlueNote, 33u);

    CHECK_FALSE(gameData.potionNoteTable.autonoteIdForMix(222u, 222u).has_value());
}

TEST_CASE("potion explosion level two damages the member and breaks one regular item")
{
    OpenYAMM::Game::PartySeed seed = {};
    seed.members.push_back(makeRegressionPartyMember("Ariel", "Knight", "PC01-01", 1));

    OpenYAMM::Game::Party party = {};
    party.seed(seed);

    OpenYAMM::Game::Character *pMember = party.member(0);
    REQUIRE(pMember != nullptr);
    pMember->health = 500;
    pMember->maxHealth = 500;

    OpenYAMM::Game::InventoryItem regularItem = {};
    regularItem.objectDescriptionId = 109;
    REQUIRE(pMember->addInventoryItemAt(regularItem, 0, 0));

    OpenYAMM::Game::InventoryItem potionItem = {};
    potionItem.objectDescriptionId = 222;
    REQUIRE(pMember->addInventoryItemAt(potionItem, 1, 0));

    REQUIRE(party.applyPotionExplosionToMember(0, 2));

    CHECK(pMember->health >= 400);
    CHECK(pMember->health <= 470);

    const OpenYAMM::Game::InventoryItem *pRegularItem = pMember->inventoryItemAt(0, 0);
    REQUIRE(pRegularItem != nullptr);
    CHECK(pRegularItem->broken);

    const OpenYAMM::Game::InventoryItem *pPotionItem = pMember->inventoryItemAt(1, 0);
    REQUIRE(pPotionItem != nullptr);
    CHECK_FALSE(pPotionItem->broken);
}

TEST_CASE("potion explosion level four eradicates the member and breaks all regular inventory items")
{
    OpenYAMM::Game::PartySeed seed = {};
    seed.members.push_back(makeRegressionPartyMember("Ariel", "Knight", "PC01-01", 1));

    OpenYAMM::Game::Party party = {};
    party.seed(seed);

    OpenYAMM::Game::Character *pMember = party.member(0);
    REQUIRE(pMember != nullptr);

    OpenYAMM::Game::InventoryItem firstRegularItem = {};
    firstRegularItem.objectDescriptionId = 109;
    REQUIRE(pMember->addInventoryItemAt(firstRegularItem, 0, 0));

    OpenYAMM::Game::InventoryItem secondRegularItem = {};
    secondRegularItem.objectDescriptionId = 111;
    REQUIRE(pMember->addInventoryItemAt(secondRegularItem, 1, 0));

    OpenYAMM::Game::InventoryItem potionItem = {};
    potionItem.objectDescriptionId = 222;
    REQUIRE(pMember->addInventoryItemAt(potionItem, 2, 0));

    REQUIRE(party.applyPotionExplosionToMember(0, 4));

    CHECK(pMember->conditions.test(static_cast<size_t>(OpenYAMM::Game::CharacterCondition::Eradicated)));

    const OpenYAMM::Game::InventoryItem *pFirstRegularItem = pMember->inventoryItemAt(0, 0);
    REQUIRE(pFirstRegularItem != nullptr);
    CHECK(pFirstRegularItem->broken);

    const OpenYAMM::Game::InventoryItem *pSecondRegularItem = pMember->inventoryItemAt(1, 0);
    REQUIRE(pSecondRegularItem != nullptr);
    CHECK(pSecondRegularItem->broken);

    const OpenYAMM::Game::InventoryItem *pPotionItem = pMember->inventoryItemAt(2, 0);
    REQUIRE(pPotionItem != nullptr);
    CHECK_FALSE(pPotionItem->broken);
}

TEST_CASE("party airborne movement allows water entry without water walk")
{
    const SyntheticOutdoorWaterBoundaryScenario boundary = createSyntheticOutdoorWaterBoundaryScenario();
    OpenYAMM::Game::OutdoorMovementController movementController(
        boundary.mapData,
        std::nullopt,
        std::nullopt,
        std::nullopt,
        std::nullopt);

    OpenYAMM::Game::OutdoorMoveState state = movementController.initializeState(boundary.landX, boundary.landY, 0.0f);
    state.footZ += 64.0f;
    state.airborne = true;
    state.verticalVelocity = 0.0f;
    state.fallStartZ = state.footZ;

    const float moveVelocityX = (boundary.waterX - boundary.landX) * 2.0f;
    const float moveVelocityY = (boundary.waterY - boundary.landY) * 2.0f;
    const OpenYAMM::Game::OutdoorMoveState resolved = movementController.resolveMove(
        state,
        moveVelocityX,
        moveVelocityY,
        0.0f,
        false,
        false,
        false,
        false,
        false,
        512.0f,
        0.0f,
        4000.0f,
        0.5f);

    CHECK(isOutdoorPositionWaterForDiagnostics(boundary.mapData, std::nullopt, resolved.x, resolved.y));
}

TEST_CASE("outdoor actor movement ignores pre-existing actor overlap")
{
    const SyntheticOutdoorWaterBoundaryScenario boundary = createSyntheticOutdoorWaterBoundaryScenario();
    OpenYAMM::Game::OutdoorMovementController movementController(
        boundary.mapData,
        std::nullopt,
        std::nullopt,
        std::nullopt,
        std::nullopt);

    OpenYAMM::Game::OutdoorMoveState state = movementController.initializeState(boundary.landX, boundary.landY, 0.0f);
    OpenYAMM::Game::OutdoorActorCollision overlappedActor = {};
    overlappedActor.source = OpenYAMM::Game::OutdoorActorCollisionSource::MapDelta;
    overlappedActor.sourceIndex = 42;
    overlappedActor.radius = 64;
    overlappedActor.height = 160;
    overlappedActor.worldX = static_cast<int>(std::lround(state.x));
    overlappedActor.worldY = static_cast<int>(std::lround(state.y));
    overlappedActor.worldZ = static_cast<int>(std::lround(state.footZ));
    movementController.setActorColliders({overlappedActor});

    std::vector<size_t> contactedActorIndices;
    const OpenYAMM::Game::OutdoorMoveState resolved =
        movementController.resolveOutdoorActorMove(
            state,
            OpenYAMM::Game::OutdoorBodyDimensions{64.0f, 160.0f},
            256.0f,
            0.0f,
            0.0f,
            false,
            0.5f,
            &contactedActorIndices,
            OpenYAMM::Game::OutdoorIgnoredActorCollider{
                OpenYAMM::Game::OutdoorActorCollisionSource::MapDelta,
                7});

    CHECK(contactedActorIndices.empty());
    CHECK(resolved.x > state.x + 32.0f);
}

TEST_CASE("event revealed outdoor bmodel collision updates party and actor movement caches")
{
    OpenYAMM::Game::OutdoorMapData mapData = {};
    mapData.heightMap.assign(
        OpenYAMM::Game::OutdoorMapData::TerrainWidth * OpenYAMM::Game::OutdoorMapData::TerrainHeight,
        0);
    mapData.attributeMap.assign(
        OpenYAMM::Game::OutdoorMapData::TerrainWidth * OpenYAMM::Game::OutdoorMapData::TerrainHeight,
        0);

    OpenYAMM::Game::OutdoorBModel bmodel = {};
    bmodel.vertices.push_back({128, -128, 0});
    bmodel.vertices.push_back({128, 128, 0});
    bmodel.vertices.push_back({128, 128, 256});
    bmodel.vertices.push_back({128, -128, 256});

    OpenYAMM::Game::OutdoorBModelFace face = {};
    face.attributes =
        OpenYAMM::Game::faceAttributeBit(OpenYAMM::Game::FaceAttribute::Invisible)
        | OpenYAMM::Game::faceAttributeBit(OpenYAMM::Game::FaceAttribute::Untouchable);
    face.vertexIndices = {0, 1, 2, 3};
    face.planeNormalX = -65536;
    face.planeNormalY = 0;
    face.planeNormalZ = 0;
    face.polygonType = 1;
    bmodel.faces.push_back(face);
    mapData.bmodels.push_back(bmodel);

    OpenYAMM::Game::OutdoorMovementController movementController(
        mapData,
        std::nullopt,
        std::nullopt,
        std::nullopt,
        std::nullopt);
    const uint32_t revealedAttributes =
        OpenYAMM::Game::faceAttributeBit(OpenYAMM::Game::FaceAttribute::Invisible);
    movementController.setFaceAttributes(0, 0, revealedAttributes);

    const OpenYAMM::Game::OutdoorMoveState partyStart = movementController.initializeState(0.0f, 0.0f, 0.0f);
    const OpenYAMM::Game::OutdoorMoveState partyResolved = movementController.resolveMove(
        partyStart,
        512.0f,
        0.0f,
        0.0f,
        false,
        false,
        false,
        false,
        false,
        512.0f,
        0.0f,
        4000.0f,
        0.5f);

    CHECK(partyResolved.x < 128.0f);

    OpenYAMM::Game::OutdoorMoveState actorStart = movementController.initializeStateForBody(0.0f, 32.0f, 0.0f, 40.0f);
    std::vector<size_t> contactedActorIndices;
    const OpenYAMM::Game::OutdoorMoveState actorResolved = movementController.resolveOutdoorActorMove(
        actorStart,
        OpenYAMM::Game::OutdoorBodyDimensions{40.0f, 128.0f},
        512.0f,
        0.0f,
        0.0f,
        false,
        0.5f,
        &contactedActorIndices);

    CHECK(actorResolved.x < 128.0f);
}

TEST_CASE("recovery enchant increases recovery progress")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    const std::optional<uint16_t> recoveryEnchantId = findSpecialEnchantId(
        gameData.specialItemEnchantTable,
        OpenYAMM::Game::SpecialItemEnchantKind::Recovery);
    REQUIRE(recoveryEnchantId.has_value());

    OpenYAMM::Game::Party party = {};
    party.setItemTable(&gameData.itemTable);
    party.setItemEnchantTables(&gameData.standardItemEnchantTable, &gameData.specialItemEnchantTable);
    party.seed(createRegressionPartySeed());

    OpenYAMM::Game::Character *pMember = party.member(0);
    const OpenYAMM::Game::ItemDefinition *pRingDefinition = gameData.itemTable.get(137);
    REQUIRE(pMember != nullptr);
    REQUIRE(pRingDefinition != nullptr);

    OpenYAMM::Game::InventoryItem enchantedRing = {
        pRingDefinition->itemId,
        1,
        pRingDefinition->inventoryWidth,
        pRingDefinition->inventoryHeight,
        0,
        0,
        true,
        false,
        false,
        0,
        0,
        *recoveryEnchantId,
        0
    };
    std::optional<OpenYAMM::Game::InventoryItem> heldReplacement;

    REQUIRE(party.tryEquipItemOnMember(
        0,
        OpenYAMM::Game::EquipmentSlot::Ring1,
        enchantedRing,
        std::nullopt,
        false,
        heldReplacement));

    CHECK(std::abs(pMember->recoveryProgressMultiplier - 1.5f) < 0.001f);

    pMember->recoverySecondsRemaining = 2.0f;
    party.updateRecovery(1.0f);

    CHECK(std::abs(pMember->recoverySecondsRemaining - 0.5f) < 0.001f);
}

TEST_CASE("running halves party recovery progress")
{
    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());

    OpenYAMM::Game::Character *pMember = party.member(0);
    REQUIRE(pMember != nullptr);

    pMember->recoverySecondsRemaining = 2.0f;
    party.updateRecovery(1.0f, 0.5f);

    CHECK(pMember->recoverySecondsRemaining == doctest::Approx(1.5f));
}

TEST_CASE("passive regeneration skill restores hit points over time")
{
    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());

    OpenYAMM::Game::Character *pMember = party.member(0);
    REQUIRE(pMember != nullptr);

    pMember->maxHealth = 200;
    pMember->health = 1;
    pMember->skills["Regeneration"] = {"Regeneration", 200, OpenYAMM::Game::SkillMastery::Grandmaster};
    party.refreshDerivedState();

    CHECK(pMember->healthRegenPerSecond == doctest::Approx(80.0f));

    party.updateRecovery(1.0f);

    CHECK_EQ(pMember->health, 81);
}

TEST_CASE("leather expertise removes leather recovery penalty")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    OpenYAMM::Game::Character normal = makeRegressionPartyMember("Ariel", "Knight", "PC01-01", 1);
    OpenYAMM::Game::Character expert = normal;
    const uint32_t leatherArmorId = findFirstItemIdBySkillGroup(gameData.itemTable, "Leather");
    REQUIRE(leatherArmorId != 0);

    normal.equipment.armor = leatherArmorId;
    normal.skills["LeatherArmor"] = {"LeatherArmor", 1, OpenYAMM::Game::SkillMastery::Normal};
    expert.equipment.armor = leatherArmorId;
    expert.skills["LeatherArmor"] = {"LeatherArmor", 1, OpenYAMM::Game::SkillMastery::Expert};

    const OpenYAMM::Game::CharacterAttackProfile normalProfile =
        OpenYAMM::Game::GameMechanics::buildCharacterAttackProfile(
            normal,
            &gameData.itemTable,
            &gameData.spellTable);
    const OpenYAMM::Game::CharacterAttackProfile expertProfile =
        OpenYAMM::Game::GameMechanics::buildCharacterAttackProfile(
            expert,
            &gameData.itemTable,
            &gameData.spellTable);

    CHECK(normalProfile.meleeRecoverySeconds > expertProfile.meleeRecoverySeconds);
}

TEST_CASE("haste reduces player attack recovery")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    OpenYAMM::Game::Party party = {};
    party.setItemTable(&gameData.itemTable);
    party.seed(createRegressionPartySeed());

    OpenYAMM::Game::Character *pMember = party.member(0);
    REQUIRE(pMember != nullptr);
    pMember->equipment.mainHand = findFirstItemIdBySkillGroup(gameData.itemTable, "Sword");
    REQUIRE(pMember->equipment.mainHand != 0);
    pMember->skills["Sword"] = {"Sword", 1, OpenYAMM::Game::SkillMastery::Normal};

    const OpenYAMM::Game::CharacterAttackProfile baseProfile =
        OpenYAMM::Game::GameMechanics::buildCharacterAttackProfile(
            *pMember,
            &gameData.itemTable,
            &gameData.spellTable);

    party.applyPartyBuff(
        OpenYAMM::Game::PartyBuffId::Haste,
        60.0f,
        0,
        OpenYAMM::Game::spellIdValue(OpenYAMM::Game::SpellId::Haste),
        1,
        OpenYAMM::Game::SkillMastery::Expert,
        0);

    const OpenYAMM::Game::CharacterAttackProfile hastedProfile =
        OpenYAMM::Game::GameMechanics::buildCharacterAttackProfile(
            *pMember,
            &gameData.itemTable,
            &gameData.spellTable);

    CHECK(hastedProfile.meleeRecoverySeconds < baseProfile.meleeRecoverySeconds);
}

TEST_CASE("event experience variable awards direct member experience without learning bonus")
{
    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());

    OpenYAMM::Game::Character *pFirst = party.member(0);
    OpenYAMM::Game::Character *pSecond = party.member(1);
    REQUIRE(pFirst != nullptr);
    REQUIRE(pSecond != nullptr);

    pFirst->skills["Learning"] = {"Learning", 10, OpenYAMM::Game::SkillMastery::Grandmaster};
    pSecond->conditions.set(static_cast<size_t>(OpenYAMM::Game::CharacterCondition::Dead));

    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    evt.ForPlayer(5)\n"
        "    evt.Add(13, 50)\n"
        "    return\n"
        "end\n",
        "@SyntheticExperience.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, &party, nullptr));
    CHECK_EQ(pFirst->experience, 50u);
    CHECK_EQ(pSecond->experience, 50u);
}

TEST_CASE("lua event runtime supports evt jump alias")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    evt.Jump(90, 0, 10)\n"
        "    evt.StatusText(\"jump ok\")\n"
        "    return\n"
        "end\n",
        "@SyntheticJump.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, nullptr, nullptr));
    REQUIRE_FALSE(runtimeState.statusMessages.empty());
    CHECK_EQ(runtimeState.statusMessages.back(), "jump ok");
}

TEST_CASE("history event variables are scoped to the active merged continent")
{
    const uint32_t historySevenVariable =
        static_cast<uint32_t>(OpenYAMM::Game::EvtVariable::HistoryBegin) + 6u;
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    evt.Set(" + std::to_string(historySevenVariable) + ", 1)\n"
        "    return\n"
        "end\n",
        "@SyntheticScopedHistory.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    OpenYAMM::Game::setActiveHistoryContinent(runtimeState, 2u);
    CHECK(runtimeState.historyEventTimesByContinent[2u].contains(1u));
    CHECK(runtimeState.historyEventTimesByContinent[2u].contains(2u));

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, nullptr, nullptr));
    CHECK(runtimeState.historyEventTimesByContinent[2u].contains(7u));
    CHECK_FALSE(runtimeState.historyEventTimesByContinent[1u].contains(7u));

    OpenYAMM::Game::setActiveHistoryContinent(runtimeState, 1u);
    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, nullptr, nullptr));
    CHECK(runtimeState.historyEventTimesByContinent[1u].contains(1u));
    CHECK(runtimeState.historyEventTimesByContinent[1u].contains(7u));
    CHECK(runtimeState.historyEventTimesByContinent[2u].contains(7u));
}

TEST_CASE("lua SetSprite stores visibility and decoration id")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt.SetSprite(300, 1, \"6tree06\")\n"
        "    evt.SetSprite(-339, 0, \"swrdstx\")\n"
        "    return\n"
        "end\n",
        "@SyntheticSetSprite.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, nullptr, nullptr));

    const auto visibleIterator = runtimeState.spriteOverrides.find(300);
    REQUIRE(visibleIterator != runtimeState.spriteOverrides.end());
    CHECK_FALSE(visibleIterator->second.hidden);
    REQUIRE(visibleIterator->second.textureName.has_value());
    CHECK_EQ(*visibleIterator->second.textureName, "6tree06");

    const auto hiddenIterator = runtimeState.spriteOverrides.find(339);
    REQUIRE(hiddenIterator != runtimeState.spriteOverrides.end());
    CHECK(hiddenIterator->second.hidden);
    REQUIRE(hiddenIterator->second.textureName.has_value());
    CHECK_EQ(*hiddenIterator->second.textureName, "swrdstx");
}

TEST_CASE("lua event runtime stores question answer metadata and resumes continuation step")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[166] = function(continueStep)\n"
        "    evt._BeginEvent(166)\n"
        "    if continueStep == 4 then\n"
        "        evt.SimpleMessage(\"ok\")\n"
        "        return\n"
        "    end\n"
        "    if continueStep == 2 then\n"
        "        evt.SimpleMessage(\"bad\")\n"
        "        return\n"
        "    end\n"
        "    evt.AskQuestion(166, 2, 603, 4, 104, 105, \"question\", {\"egg\", \"an egg\"})\n"
        "    return nil\n"
        "end\n",
        "@SyntheticAskQuestion.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 166, runtimeState, nullptr, nullptr));
    REQUIRE(runtimeState.pendingDialogueContext.has_value());
    CHECK_EQ(runtimeState.pendingDialogueContext->kind, OpenYAMM::Game::DialogueContextKind::MapEvent);
    REQUIRE(runtimeState.pendingInputPrompt.has_value());
    CHECK_EQ(runtimeState.pendingInputPrompt->eventId, 166);
    CHECK_EQ(runtimeState.pendingInputPrompt->continueStep, 2);
    CHECK_EQ(runtimeState.pendingInputPrompt->correctStep, 4);
    CHECK_EQ(runtimeState.pendingInputPrompt->textId, 603u);
    REQUIRE_EQ(runtimeState.pendingInputPrompt->answerTextIds.size(), 2u);
    CHECK_EQ(runtimeState.pendingInputPrompt->answerTextIds[0], 104u);
    CHECK_EQ(runtimeState.pendingInputPrompt->answerTextIds[1], 105u);
    REQUIRE_EQ(runtimeState.pendingInputPrompt->answers.size(), 2u);
    CHECK_EQ(runtimeState.pendingInputPrompt->answers[0], "egg");
    CHECK_EQ(runtimeState.pendingInputPrompt->answers[1], "an egg");
    REQUIRE_FALSE(runtimeState.messages.empty());
    CHECK_EQ(runtimeState.messages.back(), "question");

    const OpenYAMM::Game::EventDialogContent dialog = OpenYAMM::Game::buildEventDialogContent(
        runtimeState,
        0,
        true,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        0.0f);
    CHECK(dialog.isActive);
    REQUIRE_FALSE(dialog.lines.empty());
    CHECK_EQ(dialog.lines.back(), "question");

    OpenYAMM::Game::EventRuntimeState emptyMapEventState = {};
    OpenYAMM::Game::EventRuntimeState::PendingDialogueContext emptyMapEventContext = {};
    emptyMapEventContext.kind = OpenYAMM::Game::DialogueContextKind::MapEvent;
    emptyMapEventState.pendingDialogueContext = emptyMapEventContext;
    const OpenYAMM::Game::EventDialogContent emptyDialog = OpenYAMM::Game::buildEventDialogContent(
        emptyMapEventState,
        0,
        true,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        0.0f);
    CHECK_FALSE(emptyDialog.isActive);

    runtimeState.pendingInputPrompt.reset();

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 166, runtimeState, nullptr, nullptr, 4));
    REQUIRE_FALSE(runtimeState.messages.empty());
    CHECK_EQ(runtimeState.messages.back(), "ok");
}

TEST_CASE("lua on-load runtime preserves preseeded named globals")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[77] = function()\n"
        "    evt._BeginEvent(77)\n"
        "    evt.SetGlobalVar(\"Story.SeenOnLoad\", evt.GetGlobalVar(\"Story.Preseed\", 0))\n"
        "end\n",
        "@SyntheticNamedGlobalOnLoad.lua",
        OpenYAMM::Game::ScriptedEventScope::Map,
        {77});
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};
    runtimeState.namedGlobalVars["Story.Preseed"] = 42;

    REQUIRE(eventRuntime.buildOnLoadState(scriptedProgram, std::nullopt, std::nullopt, runtimeState));
    CHECK_EQ(runtimeState.namedGlobalVars["Story.Preseed"], 42);
    CHECK_EQ(runtimeState.namedGlobalVars["Story.SeenOnLoad"], 42);
}

TEST_CASE("lua map event continuations prefer local handlers over colliding global handlers")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> localProgram = loadSyntheticScriptedProgram(
        "evt.map[69] = function(continueStep)\n"
        "    evt._BeginEvent(69)\n"
        "    if continueStep == 4 then\n"
        "        evt.SimpleMessage(\"local\")\n"
        "        return\n"
        "    end\n"
        "    evt.AskQuestion(69, 4, 0, 0, 0, 0, \"password\", {\"JBARD\"})\n"
        "    return nil\n"
        "end\n",
        "@SyntheticLocalMapEvent.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> globalProgram = loadSyntheticScriptedProgram(
        "evt.global[69] = function()\n"
        "    evt._BeginEvent(69)\n"
        "    evt.SimpleMessage(\"global\")\n"
        "    return\n"
        "end\n",
        "@SyntheticGlobalEvent.lua",
        OpenYAMM::Game::ScriptedEventScope::Global);
    REQUIRE(localProgram.has_value());
    REQUIRE(globalProgram.has_value());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(localProgram, globalProgram, 69, runtimeState, nullptr, nullptr));
    REQUIRE(runtimeState.pendingInputPrompt.has_value());
    CHECK_EQ(runtimeState.messages.back(), "password");

    runtimeState.pendingInputPrompt.reset();
    REQUIRE(eventRuntime.executeEventById(localProgram, globalProgram, 69, runtimeState, nullptr, nullptr, 4));
    CHECK_EQ(runtimeState.messages.back(), "local");

    OpenYAMM::Game::EventRuntimeState npcTopicRuntimeState = {};
    REQUIRE(eventRuntime.executeNpcTopicEventById(
        localProgram,
        globalProgram,
        69,
        npcTopicRuntimeState,
        nullptr,
        nullptr));
    CHECK_EQ(npcTopicRuntimeState.messages.back(), "global");
}

TEST_CASE("lua event runtime Set applies condition variables")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    evt.Set(0x72, 0)\n"
        "    return\n"
        "end\n",
        "@SyntheticSetCondition.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());
    party.setActiveMemberIndex(1);

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, &party, nullptr));
    const OpenYAMM::Game::Character *pActiveMember = party.member(1);
    REQUIRE(pActiveMember != nullptr);
    CHECK(pActiveMember->conditions.test(static_cast<size_t>(OpenYAMM::Game::CharacterCondition::DiseaseMedium)));
    REQUIRE_EQ(runtimeState.portraitFxRequests.size(), 1u);
    CHECK_EQ(runtimeState.portraitFxRequests.front().kind, OpenYAMM::Game::PortraitFxEventKind::Disease);
    REQUIRE_EQ(runtimeState.portraitFxRequests.front().memberIndices.size(), 1u);
    CHECK_EQ(runtimeState.portraitFxRequests.front().memberIndices.front(), 1u);
}

TEST_CASE("event runtime queues qbit portrait fx only for visible quest entries")
{
    OpenYAMM::Game::JournalQuestTable questTable = {};
    REQUIRE(questTable.loadFromRows({
        {"5", "Kill the leader of the Regnan Pirate outpost at Dagger Wound.", "", ""},
        {"777", "", "Internal bookkeeping qbit", ""}
    }));

    OpenYAMM::Game::Party party = {};
    party.setJournalQuestTable(&questTable);
    party.seed(createRegressionPartySeed());

    OpenYAMM::Game::EventRuntimeState runtimeState = {};
    const OpenYAMM::Game::EventRuntime::VariableRef visibleQbit =
        OpenYAMM::Game::EventRuntime::decodeVariable(
            (5u << 16) | static_cast<uint32_t>(OpenYAMM::Game::EvtVariable::QBits));
    const OpenYAMM::Game::EventRuntime::VariableRef internalQbit =
        OpenYAMM::Game::EventRuntime::decodeVariable(
            (777u << 16) | static_cast<uint32_t>(OpenYAMM::Game::EvtVariable::QBits));

    OpenYAMM::Game::EventRuntime::setVariableValue(runtimeState, visibleQbit, 1, &party, {0});
    REQUIRE_EQ(runtimeState.portraitFxRequests.size(), 1u);
    CHECK_EQ(runtimeState.portraitFxRequests.front().kind, OpenYAMM::Game::PortraitFxEventKind::QuestComplete);
    REQUIRE_EQ(runtimeState.pendingSounds.size(), 1u);
    CHECK_EQ(runtimeState.pendingSounds.front().soundId, static_cast<uint32_t>(OpenYAMM::Game::SoundId::Quest));

    runtimeState.portraitFxRequests.clear();
    runtimeState.pendingSounds.clear();

    OpenYAMM::Game::EventRuntime::setVariableValue(runtimeState, visibleQbit, 1, &party, {0});
    CHECK(runtimeState.portraitFxRequests.empty());
    CHECK(runtimeState.pendingSounds.empty());

    OpenYAMM::Game::EventRuntime::addVariableValue(runtimeState, internalQbit, 777, &party, {0});
    CHECK(party.hasQuestBit(777));
    CHECK(runtimeState.portraitFxRequests.empty());
    CHECK(runtimeState.pendingSounds.empty());

    OpenYAMM::Game::EventRuntime::subtractVariableValue(runtimeState, visibleQbit, 5, &party, {0});
    CHECK_FALSE(party.hasQuestBit(5));
    CHECK(runtimeState.portraitFxRequests.empty());
    CHECK(runtimeState.pendingSounds.empty());
}

TEST_CASE("lua event runtime Subtract clears condition variables")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    evt.Subtract(0x72, 0)\n"
        "    return\n"
        "end\n",
        "@SyntheticSubtractCondition.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());
    party.setActiveMemberIndex(1);
    OpenYAMM::Game::Character *pActiveMember = party.member(1);
    REQUIRE(pActiveMember != nullptr);
    pActiveMember->conditions.set(static_cast<size_t>(OpenYAMM::Game::CharacterCondition::DiseaseMedium));

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, &party, nullptr));
    CHECK_FALSE(pActiveMember->conditions.test(static_cast<size_t>(OpenYAMM::Game::CharacterCondition::DiseaseMedium)));
}

TEST_CASE("lua event runtime door locked reaction targets active member")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    evt.ForPlayer(5)\n"
        "    evt.FaceAnimation(18)\n"
        "    return\n"
        "end\n",
        "@SyntheticDoorLockedReaction.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());
    party.setActiveMemberIndex(2);

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, &party, nullptr));
    const std::vector<OpenYAMM::Game::Party::PendingAudioRequest> &requests = party.pendingAudioRequests();
    REQUIRE_EQ(requests.size(), 1u);
    CHECK_EQ(requests.front().kind, OpenYAMM::Game::Party::PendingAudioRequest::Kind::Speech);
    CHECK_EQ(requests.front().memberIndex, 2u);
    CHECK_EQ(requests.front().speechId, OpenYAMM::Game::SpeechId::DoorLocked);
}

TEST_CASE("lua event runtime maps non-door face animations to speech reactions")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    evt.ForPlayer(1)\n"
        "    evt.FaceAnimation(47)\n"
        "    evt.FaceAnimation(74)\n"
        "    return\n"
        "end\n",
        "@SyntheticFaceAnimationReactions.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, &party, nullptr));
    const std::vector<OpenYAMM::Game::Party::PendingAudioRequest> &requests = party.pendingAudioRequests();
    REQUIRE_EQ(requests.size(), 2u);
    CHECK_EQ(requests[0].memberIndex, 1u);
    CHECK_EQ(requests[0].speechId, OpenYAMM::Game::SpeechId::LeaveDungeon);
    CHECK_EQ(requests[1].memberIndex, 1u);
    CHECK_EQ(requests[1].speechId, OpenYAMM::Game::SpeechId::ShopRepair);
}

TEST_CASE("lua event CheckSkill supports effective checks and explicit mastery checks")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    evt.ForPlayer(5)\n"
        "    if evt.CheckSkill(31, 0, 8) then\n"
        "        evt.StatusText(\"skill pass\")\n"
        "    else\n"
        "        evt.StatusText(\"skill fail\")\n"
        "    end\n"
        "    return\n"
        "end\n"
        "evt.map[2] = function()\n"
        "    evt._BeginEvent(2)\n"
        "    evt.ForPlayer(5)\n"
        "    if evt.CheckSkill(94, 3, 40) then\n"
        "        evt.StatusText(\"gm pass\")\n"
        "    else\n"
        "        evt.StatusText(\"gm fail\")\n"
        "    end\n"
        "    return\n"
        "end\n",
        "@SyntheticCheckSkill.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());
    OpenYAMM::Game::Character *pMember = party.member(0);
    REQUIRE(pMember != nullptr);
    pMember->skills["Perception"] = {"Perception", 4, OpenYAMM::Game::SkillMastery::Expert};
    pMember->skills["DisarmTraps"] = {"DisarmTraps", 40, OpenYAMM::Game::SkillMastery::Grandmaster};

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, &party, nullptr));
    REQUIRE_FALSE(runtimeState.statusMessages.empty());
    CHECK_EQ(runtimeState.statusMessages.back(), "skill pass");

    pMember->skills["Perception"] = {"Perception", 7, OpenYAMM::Game::SkillMastery::Normal};
    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, &party, nullptr));
    REQUIRE_FALSE(runtimeState.statusMessages.empty());
    CHECK_EQ(runtimeState.statusMessages.back(), "skill fail");

    pMember->skills["Perception"] = {"Perception", 40, OpenYAMM::Game::SkillMastery::Master};
    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 2, runtimeState, &party, nullptr));
    REQUIRE_FALSE(runtimeState.statusMessages.empty());
    CHECK_EQ(runtimeState.statusMessages.back(), "gm fail");

    pMember->skills["Perception"] = {"Perception", 1, OpenYAMM::Game::SkillMastery::Grandmaster};
    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 2, runtimeState, &party, nullptr));
    REQUIRE_FALSE(runtimeState.statusMessages.empty());
    CHECK_EQ(runtimeState.statusMessages.back(), "gm pass");

    const std::optional<OpenYAMM::Game::ScriptedEventProgram> disarmProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    evt.ForPlayer(5)\n"
        "    if evt.CheckSkill(33, 3, 40) then\n"
        "        evt.StatusText(\"disarm pass\")\n"
        "    else\n"
        "        evt.StatusText(\"disarm fail\")\n"
        "    end\n"
        "    return\n"
        "end\n",
        "@SyntheticCheckDisarmSkill.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(disarmProgram.has_value());

    pMember->skills["DisarmTraps"] = {"DisarmTraps", 1, OpenYAMM::Game::SkillMastery::Grandmaster};
    REQUIRE(eventRuntime.executeEventById(disarmProgram, std::nullopt, 1, runtimeState, &party, nullptr));
    REQUIRE_FALSE(runtimeState.statusMessages.empty());
    CHECK_EQ(runtimeState.statusMessages.back(), "disarm pass");
}

TEST_CASE("lua event DamagePlayer uses its explicit player argument")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    evt.ForPlayer(5)\n"
        "    evt.DamagePlayer(0, 0, 10)\n"
        "    return\n"
        "end\n",
        "@SyntheticDamagePlayerTarget.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());

    for (size_t memberIndex = 0; memberIndex < party.members().size(); ++memberIndex)
    {
        OpenYAMM::Game::Character *pMember = party.member(memberIndex);
        REQUIRE(pMember != nullptr);
        pMember->health = 100;
        pMember->maxHealth = 100;
    }

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, &party, nullptr));
    REQUIRE_GE(party.members().size(), 2u);
    CHECK_EQ(party.members()[0].health, 90);
    CHECK_EQ(party.members()[1].health, 100);
}

TEST_CASE("lua event player bits are character specific and unbounded")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    evt.ForPlayer(0)\n"
        "    evt.Add(4522215, 69)\n"
        "    evt.ForPlayer(1)\n"
        "    if evt.Cmp(4522215, 69) then\n"
        "        evt.StatusText(\"member1 set\")\n"
        "    else\n"
        "        evt.StatusText(\"member1 clear\")\n"
        "    end\n"
        "    evt.ForPlayer(0)\n"
        "    if evt.Cmp(4522215, 69) then\n"
        "        evt.StatusText(\"member0 set\")\n"
        "    else\n"
        "        evt.StatusText(\"member0 clear\")\n"
        "    end\n"
        "    return\n"
        "end\n",
        "@SyntheticPlayerBits.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, &party, nullptr));
    REQUIRE_GE(runtimeState.statusMessages.size(), 2u);
    CHECK_EQ(runtimeState.statusMessages[runtimeState.statusMessages.size() - 2], "member1 clear");
    CHECK_EQ(runtimeState.statusMessages.back(), "member0 set");

    const OpenYAMM::Game::Character *pMember0 = party.member(0);
    const OpenYAMM::Game::Character *pMember1 = party.member(1);
    REQUIRE(pMember0 != nullptr);
    REQUIRE(pMember1 != nullptr);
    CHECK(pMember0->playerBits.contains(69));
    CHECK_FALSE(pMember1->playerBits.contains(69));
}

TEST_CASE("lua class promotion API uses merged class metadata")
{
    REQUIRE(OpenYAMM::Tests::regressionGameDataLoaded());
    const OpenYAMM::Tests::RegressionGameData &gameData = OpenYAMM::Tests::regressionGameData();

    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    if evt.GetClassId(\"Knight\") == 16 then\n"
        "        evt.StatusText(\"knight id ok\")\n"
        "    end\n"
        "    if evt.GetPlayerClass(0) == 16 then\n"
        "        evt.StatusText(\"member class ok\")\n"
        "    end\n"
        "    if evt.CanClassLearnSkill(19, \"Sword\", 4) then\n"
        "        evt.StatusText(\"champion sword ok\")\n"
        "    end\n"
        "    if evt.SetPlayerClass(0, 19) then\n"
        "        evt.StatusText(evt.GetPlayerClassName(0))\n"
        "    end\n"
        "    return\n"
        "end\n",
        "@SyntheticClassPromotionApi.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());
    party.setClassSkillTable(&gameData.classSkillTable);

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, &party, nullptr));
    REQUIRE_GE(runtimeState.statusMessages.size(), 4u);
    CHECK_EQ(runtimeState.statusMessages[runtimeState.statusMessages.size() - 4], "knight id ok");
    CHECK_EQ(runtimeState.statusMessages[runtimeState.statusMessages.size() - 3], "member class ok");
    CHECK_EQ(runtimeState.statusMessages[runtimeState.statusMessages.size() - 2], "champion sword ok");
    CHECK_EQ(runtimeState.statusMessages.back(), "Champion");

    const OpenYAMM::Game::Character *pMember = party.member(0);
    REQUIRE(pMember != nullptr);
    CHECK_EQ(pMember->className, "Champion");
}

TEST_CASE("lua event inventory possession checks include equipped items")
{
    constexpr uint32_t CloakOfBaaItemId = 2105;
    constexpr uint32_t InventoryVariableTag = 0x0011;
    const uint32_t cloakInventoryVariable = (CloakOfBaaItemId << 16) | InventoryVariableTag;

    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        std::string("evt.map[1] = function()\n")
        + "    evt._BeginEvent(1)\n"
        + "    evt.ForPlayer(5)\n"
        "    if evt.Cmp(" + std::to_string(cloakInventoryVariable) + ", 1) then\n"
        "        evt.StatusText(\"has cloak\")\n"
        "    else\n"
        "        evt.StatusText(\"missing cloak\")\n"
        "    end\n"
        "    return\n"
        "end\n",
        "@SyntheticInventoryEquipped.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());
    OpenYAMM::Game::Character *pMember = party.member(0);
    REQUIRE(pMember != nullptr);
    pMember->inventory.clear();
    pMember->equipment.cloak = CloakOfBaaItemId;

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, &party, nullptr));
    REQUIRE_FALSE(runtimeState.statusMessages.empty());
    CHECK_EQ(runtimeState.statusMessages.back(), "has cloak");
}

TEST_CASE("lua event runtime SpeakNPC opens pending npc talk dialogue")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[451] = function()\n"
        "    evt._BeginEvent(451)\n"
        "    evt.SpeakNPC(39)\n"
        "    return\n"
        "end\n",
        "@SyntheticSpeakNpc.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 451, runtimeState, nullptr, nullptr));
    REQUIRE(runtimeState.pendingDialogueContext.has_value());
    CHECK_EQ(runtimeState.pendingDialogueContext->kind, OpenYAMM::Game::DialogueContextKind::NpcTalk);
    CHECK_EQ(runtimeState.pendingDialogueContext->sourceId, 39u);
    CHECK_EQ(runtimeState.pendingDialogueContext->hostHouseId, 0u);
}

TEST_CASE("lua event runtime onload executes SpeakNPC handlers")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[451] = function()\n"
        "    evt._BeginEvent(451)\n"
        "    evt.SpeakNPC(39)\n"
        "    return\n"
        "end\n"
        "evt.map[452] = function()\n"
        "    evt._BeginEvent(452)\n"
        "    evt.StatusText(\"setup still ran\")\n"
        "    return\n"
        "end\n",
        "@SyntheticOnLoadSpeakNpc.lua",
        OpenYAMM::Game::ScriptedEventScope::Map,
        {451, 452});
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.buildOnLoadState(scriptedProgram, std::nullopt, std::nullopt, runtimeState));
    CHECK_EQ(runtimeState.localOnLoadEventsExecuted, 2u);
    CHECK_EQ(runtimeState.globalOnLoadEventsExecuted, 0u);
    REQUIRE(runtimeState.pendingDialogueContext.has_value());
    CHECK_EQ(runtimeState.pendingDialogueContext->kind, OpenYAMM::Game::DialogueContextKind::NpcTalk);
    CHECK_EQ(runtimeState.pendingDialogueContext->sourceId, 39u);
}

TEST_CASE("lua event runtime onload sees party quest bits")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[2] = function()\n"
        "    evt._BeginEvent(2)\n"
        "    if evt.Cmp(2359312, 36) then\n"
        "        evt.SetFacetBit(25, 0x00002000, 0)\n"
        "    else\n"
        "        evt.SetFacetBit(25, 0x00002000, 1)\n"
        "    end\n"
        "    return\n"
        "end\n",
        "@SyntheticOnLoadPartyQuestBit.lua",
        OpenYAMM::Game::ScriptedEventScope::Map,
        {2});
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());
    party.setQuestBit(36, true);

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};
    const uint32_t invisibleBit = OpenYAMM::Game::faceAttributeBit(OpenYAMM::Game::FaceAttribute::Invisible);

    REQUIRE(eventRuntime.executeOnLoadEvents(scriptedProgram, std::nullopt, runtimeState, &party, nullptr));
    CHECK_EQ(runtimeState.localOnLoadEventsExecuted, 1u);
    REQUIRE(runtimeState.facetClearMasks.contains(25));
    CHECK((runtimeState.facetClearMasks.at(25) & invisibleBit) != 0);

    const auto setIt = runtimeState.facetSetMasks.find(25);
    const bool invisibleBitWasSet =
        setIt != runtimeState.facetSetMasks.end() && (setIt->second & invisibleBit) != 0;
    CHECK_FALSE(invisibleBitWasSet);
}

TEST_CASE("dagger wound onload seeds starting roster quest bits")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    REQUIRE(gameData.out01LocalEventProgram.has_value());

    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeOnLoadEvents(
        gameData.out01LocalEventProgram,
        gameData.globalEventProgram,
        runtimeState,
        &party,
        nullptr));
    CHECK_EQ(runtimeState.localOnLoadEventsExecuted, 4u);
    CHECK(party.hasQuestBit(226));
    CHECK(party.hasQuestBit(306));
    CHECK(party.hasQuestBit(401));
    CHECK(party.hasQuestBit(407));
}

TEST_CASE("lua event runtime resolves MM8 invisible event variable alias")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    if evt.Cmp(316, 0) then\n"
        "        evt.StatusText(\"blocked\")\n"
        "        return\n"
        "    end\n"
        "    evt.StatusText(\"warning\")\n"
        "    return\n"
        "end\n",
        "@SyntheticMm8InvisibleAlias.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};
    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, &party, nullptr));
    REQUIRE_FALSE(runtimeState.statusMessages.empty());
    CHECK_EQ(runtimeState.statusMessages.back(), "warning");

    runtimeState.statusMessages.clear();
    party.applyPartyBuff(
        OpenYAMM::Game::PartyBuffId::Invisibility,
        60.0f,
        0,
        0,
        0,
        OpenYAMM::Game::SkillMastery::Normal,
        0);

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, &party, nullptr));
    REQUIRE_FALSE(runtimeState.statusMessages.empty());
    CHECK_EQ(runtimeState.statusMessages.back(), "blocked");
}

TEST_CASE("lua event runtime separates persistent actor masks from current hostility requests")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    evt.SetMonGroupBit(44, 0x01000000, 1)\n"
        "    return\n"
        "end\n"
        "evt.map[2] = function()\n"
        "    evt._BeginEvent(2)\n"
        "    evt.StatusText(\"plate reset\")\n"
        "    return\n"
        "end\n",
        "@SyntheticHostilityRequests.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};
    const uint32_t hostileBit = static_cast<uint32_t>(OpenYAMM::Game::EvtActorAttribute::Hostile);

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, nullptr, nullptr));
    REQUIRE(runtimeState.actorGroupSetMasks.contains(44));
    CHECK((runtimeState.actorGroupSetMasks.at(44) & hostileBit) != 0);
    REQUIRE(runtimeState.actorGroupHostilityRequests.contains(44));
    CHECK(runtimeState.actorGroupHostilityRequests.at(44));

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 2, runtimeState, nullptr, nullptr));
    REQUIRE(runtimeState.actorGroupSetMasks.contains(44));
    CHECK((runtimeState.actorGroupSetMasks.at(44) & hostileBit) != 0);
    CHECK(runtimeState.actorGroupHostilityRequests.empty());
}

TEST_CASE("lua event runtime treats numeric zero as false for actor group bits")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    evt.SetMonGroupBit(44, 0x01000000, 0)\n"
        "    return\n"
        "end\n",
        "@SyntheticNumericZeroActorGroupBit.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};
    const uint32_t hostileBit = static_cast<uint32_t>(OpenYAMM::Game::EvtActorAttribute::Hostile);

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, nullptr, nullptr));
    REQUIRE(runtimeState.actorGroupClearMasks.contains(44));
    CHECK((runtimeState.actorGroupClearMasks.at(44) & hostileBit) != 0);
    CHECK_FALSE(runtimeState.actorGroupSetMasks.contains(44));
    REQUIRE(runtimeState.actorGroupHostilityRequests.contains(44));
    CHECK_FALSE(runtimeState.actorGroupHostilityRequests.at(44));
}

TEST_CASE("lua event runtime treats numeric zero as false for facet bits")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    evt.SetFacetBit(25, 0x00002000, 0)\n"
        "    return\n"
        "end\n",
        "@SyntheticNumericZeroFacetBit.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};
    const uint32_t invisibleBit = OpenYAMM::Game::faceAttributeBit(OpenYAMM::Game::FaceAttribute::Invisible);

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, nullptr, nullptr));
    REQUIRE(runtimeState.facetClearMasks.contains(25));
    CHECK((runtimeState.facetClearMasks.at(25) & invisibleBit) != 0);

    const auto setIt = runtimeState.facetSetMasks.find(25);
    const bool invisibleBitWasSet =
        setIt != runtimeState.facetSetMasks.end() && (setIt->second & invisibleBit) != 0;
    CHECK_FALSE(invisibleBitWasSet);
}

TEST_CASE("save preview bmp decoder accepts current 32 bit preview payloads")
{
    const std::vector<uint8_t> sourcePixels = {
        10, 20, 30, 255,
        40, 50, 60, 128
    };
    const std::vector<uint8_t> bmp = OpenYAMM::Game::SavePreviewImage::encodeBgraToBmp(2, 1, sourcePixels);
    REQUIRE_FALSE(bmp.empty());

    int width = 0;
    int height = 0;
    std::vector<uint8_t> decodedPixels;
    CHECK(OpenYAMM::Game::SavePreviewImage::decodeBmpBytesToBgra(bmp, width, height, decodedPixels));
    CHECK_EQ(width, 2);
    CHECK_EQ(height, 1);
    CHECK_EQ(decodedPixels, sourcePixels);
}

TEST_CASE("lua MoveToMap with transition ids opens shared transition dialog instead of immediate move")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    evt.MoveToMap(-500, -1567, -63, 512, 0, 0, 363, 9, \"\1D18.blv\")\n"
        "    return\n"
        "end\n",
        "@SyntheticDungeonTransition.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, nullptr, nullptr));
    CHECK_FALSE(runtimeState.pendingMapMove.has_value());
    REQUIRE(runtimeState.pendingDialogueContext.has_value());
    CHECK_EQ(runtimeState.pendingDialogueContext->kind, OpenYAMM::Game::DialogueContextKind::MapTransition);
    REQUIRE(runtimeState.pendingDialogueContext->transitionMapMove.has_value());
    CHECK_EQ(runtimeState.pendingDialogueContext->transitionMapMove->mapName, std::optional<std::string>("D18.blv"));
    CHECK_EQ(runtimeState.pendingDialogueContext->transitionMapMove->x, -500);
    CHECK_EQ(runtimeState.pendingDialogueContext->transitionTextId, 363u);
    CHECK_EQ(runtimeState.pendingDialogueContext->transitionImageId, 9u);
}

TEST_CASE("lua MoveToMap without transition ids queues direct map move")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    evt.MoveToMap(12808, 6832, 64, 512, 0, 0, 0, 0, \"outb3.odm\")\n"
        "    return\n"
        "end\n",
        "@SyntheticDirectMapMove.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, nullptr, nullptr));
    CHECK_FALSE(runtimeState.pendingDialogueContext.has_value());
    REQUIRE(runtimeState.pendingMapMove.has_value());
    CHECK_EQ(runtimeState.pendingMapMove->mapName, std::optional<std::string>("outb3.odm"));
    CHECK_EQ(runtimeState.pendingMapMove->x, 12808);
    CHECK_EQ(runtimeState.pendingMapMove->y, 6832);
    CHECK_EQ(runtimeState.pendingMapMove->z, 64);
}

TEST_CASE("lua MoveToMap current-map sentinel queues same-map teleport")
{
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram = loadSyntheticScriptedProgram(
        "evt.map[1] = function()\n"
        "    evt._BeginEvent(1)\n"
        "    evt.MoveToMap(-3136, 2240, 224, 1024, 0, 0, 0, 0, \"0.\")\n"
        "    return\n"
        "end\n",
        "@SyntheticSameMapMove.lua",
        OpenYAMM::Game::ScriptedEventScope::Map);
    REQUIRE(scriptedProgram.has_value());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 1, runtimeState, nullptr, nullptr));
    CHECK_FALSE(runtimeState.pendingDialogueContext.has_value());
    REQUIRE(runtimeState.pendingMapMove.has_value());
    CHECK_FALSE(runtimeState.pendingMapMove->mapName.has_value());
    CHECK_EQ(runtimeState.pendingMapMove->x, -3136);
    CHECK_EQ(runtimeState.pendingMapMove->y, 2240);
    CHECK_EQ(runtimeState.pendingMapMove->z, 224);
}

TEST_CASE("dungeon transition dialog uses trans table title text icon and transition video metadata")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    OpenYAMM::Game::EventRuntimeState runtimeState = {};
    OpenYAMM::Game::EventRuntimeState::PendingMapMove mapMove = {};
    mapMove.mapName = std::string("D18.blv");
    mapMove.x = -500;
    mapMove.y = -1567;
    mapMove.z = -63;

    OpenYAMM::Game::EventRuntimeState::PendingDialogueContext context = {};
    context.kind = OpenYAMM::Game::DialogueContextKind::MapTransition;
    context.transitionMapMove = mapMove;
    context.transitionTextId = 363;
    context.transitionImageId = 9;
    runtimeState.pendingDialogueContext = context;

    const OpenYAMM::Game::EventDialogContent dialog = OpenYAMM::Game::buildEventDialogContent(
        runtimeState,
        0,
        true,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        &gameData.transitionTable,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        0.0f);

    REQUIRE(dialog.isActive);
    CHECK_EQ(dialog.presentation, OpenYAMM::Game::EventDialogPresentation::Transition);
    CHECK_EQ(dialog.title, "Naga Vault");
    REQUIRE_FALSE(dialog.lines.empty());
    CHECK(dialog.lines.front().find("stonework") != std::string::npos);
    CHECK_EQ(dialog.participantTextureName, "IDOOR");
    CHECK_EQ(dialog.videoName, "naga_vlt");
    CHECK_EQ(dialog.videoDirectory, "Videos/Transitions");
    REQUIRE_EQ(dialog.actions.size(), 2u);
    CHECK_EQ(dialog.actions[0].kind, OpenYAMM::Game::EventDialogActionKind::MapTransitionConfirm);
    CHECK_EQ(dialog.actions[1].kind, OpenYAMM::Game::EventDialogActionKind::MapTransitionCancel);
}

TEST_CASE("merged dungeon transition dialog uses world house movie metadata before shared title fallback")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();

    OpenYAMM::Game::EventRuntimeState mm6RuntimeState = {};
    OpenYAMM::Game::EventRuntimeState::PendingMapMove mm6MapMove = {};
    mm6MapMove.mapName = std::string("6d02.blv");

    OpenYAMM::Game::EventRuntimeState::PendingDialogueContext mm6Context = {};
    mm6Context.kind = OpenYAMM::Game::DialogueContextKind::MapTransition;
    mm6Context.transitionMapMove = mm6MapMove;
    mm6Context.transitionTextId = 166;
    mm6Context.transitionImageId = 1;
    mm6RuntimeState.pendingDialogueContext = mm6Context;

    OpenYAMM::Game::MapStatsEntry newSorpigal = {};
    newSorpigal.id = 151;
    newSorpigal.name = "New Sorpigal";
    newSorpigal.fileName = "oute3.odm";
    OpenYAMM::Game::MapStatsEntry mm6AbandonedTemple = {};
    mm6AbandonedTemple.id = 153;
    mm6AbandonedTemple.name = "Abandoned Temple";
    mm6AbandonedTemple.fileName = "6d02.blv";
    const std::vector<OpenYAMM::Game::MapStatsEntry> mm6MapEntries = {newSorpigal, mm6AbandonedTemple};

    const OpenYAMM::Game::EventDialogContent mm6Dialog = OpenYAMM::Game::buildEventDialogContent(
        mm6RuntimeState,
        0,
        true,
        nullptr,
        &gameData.houseTable,
        nullptr,
        nullptr,
        &gameData.transitionTable,
        &newSorpigal,
        &mm6MapEntries,
        nullptr,
        nullptr,
        0.0f);

    REQUIRE(mm6Dialog.isActive);
    CHECK_EQ(mm6Dialog.title, "Abandoned Temple");
    CHECK_EQ(mm6Dialog.videoName, "d02");
    CHECK_EQ(mm6Dialog.videoDirectory, "Videos/Transitions");

    OpenYAMM::Game::EventRuntimeState mm6ExitRuntimeState = {};
    OpenYAMM::Game::EventRuntimeState::PendingMapMove mm6ExitMapMove = {};
    mm6ExitMapMove.mapName = std::string("oute3.odm");

    OpenYAMM::Game::EventRuntimeState::PendingDialogueContext mm6ExitContext = {};
    mm6ExitContext.kind = OpenYAMM::Game::DialogueContextKind::MapTransition;
    mm6ExitContext.transitionMapMove = mm6ExitMapMove;
    mm6ExitContext.transitionImageId = 1;
    mm6ExitRuntimeState.pendingDialogueContext = mm6ExitContext;

    const OpenYAMM::Game::EventDialogContent mm6ExitDialog = OpenYAMM::Game::buildEventDialogContent(
        mm6ExitRuntimeState,
        0,
        true,
        nullptr,
        &gameData.houseTable,
        nullptr,
        nullptr,
        &gameData.transitionTable,
        &mm6AbandonedTemple,
        &mm6MapEntries,
        nullptr,
        nullptr,
        0.0f);

    REQUIRE(mm6ExitDialog.isActive);
    CHECK_EQ(mm6ExitDialog.title, "Abandoned Temple");
    CHECK_EQ(mm6ExitDialog.videoName, "d02");
    CHECK_EQ(mm6ExitDialog.videoDirectory, "Videos/Transitions");

    OpenYAMM::Game::EventRuntimeState mm7RuntimeState = {};
    OpenYAMM::Game::EventRuntimeState::PendingMapMove mm7MapMove = {};
    mm7MapMove.mapName = std::string("7d06.blv");

    OpenYAMM::Game::EventRuntimeState::PendingDialogueContext mm7Context = {};
    mm7Context.kind = OpenYAMM::Game::DialogueContextKind::MapTransition;
    mm7Context.transitionMapMove = mm7MapMove;
    mm7Context.transitionTextId = 131;
    mm7Context.transitionImageId = 1;
    mm7RuntimeState.pendingDialogueContext = mm7Context;

    OpenYAMM::Game::MapStatsEntry emeraldIsland = {};
    emeraldIsland.id = 62;
    emeraldIsland.name = "Emerald Island";
    emeraldIsland.fileName = "7out01.odm";
    OpenYAMM::Game::MapStatsEntry mm7TempleOfTheMoon = {};
    mm7TempleOfTheMoon.id = 80;
    mm7TempleOfTheMoon.name = "The Temple of the Moon";
    mm7TempleOfTheMoon.fileName = "7d06.blv";
    const std::vector<OpenYAMM::Game::MapStatsEntry> mm7MapEntries = {emeraldIsland, mm7TempleOfTheMoon};

    const OpenYAMM::Game::EventDialogContent mm7Dialog = OpenYAMM::Game::buildEventDialogContent(
        mm7RuntimeState,
        0,
        true,
        nullptr,
        &gameData.houseTable,
        nullptr,
        nullptr,
        &gameData.transitionTable,
        &emeraldIsland,
        &mm7MapEntries,
        nullptr,
        nullptr,
        0.0f);

    REQUIRE(mm7Dialog.isActive);
    CHECK_EQ(mm7Dialog.title, "The Temple of the Moon");
    CHECK_EQ(mm7Dialog.videoName, "out01 temple of the moon");
    CHECK_EQ(mm7Dialog.videoDirectory, "Videos/Transitions");

    OpenYAMM::Game::EventRuntimeState mm7ExitRuntimeState = {};
    OpenYAMM::Game::EventRuntimeState::PendingMapMove mm7ExitMapMove = {};
    mm7ExitMapMove.mapName = std::string("7out01.odm");

    OpenYAMM::Game::EventRuntimeState::PendingDialogueContext mm7ExitContext = {};
    mm7ExitContext.kind = OpenYAMM::Game::DialogueContextKind::MapTransition;
    mm7ExitContext.transitionMapMove = mm7ExitMapMove;
    mm7ExitContext.transitionImageId = 1;
    mm7ExitRuntimeState.pendingDialogueContext = mm7ExitContext;

    const OpenYAMM::Game::EventDialogContent mm7ExitDialog = OpenYAMM::Game::buildEventDialogContent(
        mm7ExitRuntimeState,
        0,
        true,
        nullptr,
        &gameData.houseTable,
        nullptr,
        nullptr,
        &gameData.transitionTable,
        &mm7TempleOfTheMoon,
        &mm7MapEntries,
        nullptr,
        nullptr,
        0.0f);

    REQUIRE(mm7ExitDialog.isActive);
    CHECK_EQ(mm7ExitDialog.title, "The Temple of the Moon");
    CHECK_EQ(mm7ExitDialog.videoName, "out01 temple of the moon");
    CHECK_EQ(mm7ExitDialog.videoDirectory, "Videos/Transitions");
}

TEST_CASE("outdoor boundary transition dialog uses default outdoor map icon")
{
    OpenYAMM::Game::EventRuntimeState runtimeState = {};
    OpenYAMM::Game::MapStatsEntry originMap = {};
    originMap.name = "Ravenshore";
    originMap.fileName = "Out02.odm";
    OpenYAMM::Game::MapEdgeTransition eastTransition = {};
    eastTransition.destinationMapFileName = "Out06.odm";
    eastTransition.travelDays = 1;
    originMap.eastTransition = eastTransition;

    OpenYAMM::Game::MapStatsEntry destinationMap = {};
    destinationMap.name = "Garrote Gorge";
    destinationMap.fileName = "Out06.odm";
    const std::vector<OpenYAMM::Game::MapStatsEntry> mapEntries = {originMap, destinationMap};

    OpenYAMM::Game::EventRuntimeState::PendingDialogueContext context = {};
    context.kind = OpenYAMM::Game::DialogueContextKind::MapTransition;
    context.sourceId = static_cast<uint32_t>(OpenYAMM::Game::MapBoundaryEdge::East);
    runtimeState.pendingDialogueContext = context;

    const OpenYAMM::Game::EventDialogContent dialog = OpenYAMM::Game::buildEventDialogContent(
        runtimeState,
        0,
        true,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        &originMap,
        &mapEntries,
        nullptr,
        nullptr,
        0.0f);

    REQUIRE(dialog.isActive);
    CHECK_EQ(dialog.presentation, OpenYAMM::Game::EventDialogPresentation::Transition);
    CHECK_EQ(dialog.participantVisual, OpenYAMM::Game::EventDialogParticipantVisual::MapIcon);
    CHECK_EQ(dialog.title, "Garrote Gorge");
    CHECK_EQ(dialog.participantTextureName, "Outside");
}

TEST_CASE("dungeon to outdoor transition dialog keeps dungeon transition icon")
{
    OpenYAMM::Game::EventRuntimeState runtimeState = {};
    OpenYAMM::Game::EventRuntimeState::PendingMapMove mapMove = {};
    mapMove.mapName = std::string("Out02.odm");

    OpenYAMM::Game::EventRuntimeState::PendingDialogueContext context = {};
    context.kind = OpenYAMM::Game::DialogueContextKind::MapTransition;
    context.transitionMapMove = mapMove;
    runtimeState.pendingDialogueContext = context;

    OpenYAMM::Game::MapStatsEntry currentMap = {};
    currentMap.name = "Abandoned Temple";
    currentMap.fileName = "D18.blv";
    OpenYAMM::Game::MapStatsEntry destinationMap = {};
    destinationMap.name = "Ravenshore";
    destinationMap.fileName = "Out02.odm";
    const std::vector<OpenYAMM::Game::MapStatsEntry> mapEntries = {currentMap, destinationMap};

    const OpenYAMM::Game::EventDialogContent dialog = OpenYAMM::Game::buildEventDialogContent(
        runtimeState,
        0,
        true,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        &currentMap,
        &mapEntries,
        nullptr,
        nullptr,
        0.0f);

    REQUIRE(dialog.isActive);
    CHECK_EQ(dialog.presentation, OpenYAMM::Game::EventDialogPresentation::Transition);
    CHECK_EQ(dialog.title, "Abandoned Temple");
    CHECK_EQ(dialog.participantTextureName, "Ticon01");
}

TEST_CASE("lua event runtime treats explicit hint-only events as handled no-ops")
{
    std::string error;
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> scriptedProgram =
        OpenYAMM::Game::ScriptedEventProgram::loadFromLuaText(
        "evt.meta.map.hint = {[42] = \"Bookshelf\"}\n"
        "evt.meta.map.summary = {[42] = \"Bookshelf\"}\n",
        "@SyntheticHintOnlyEvent.lua",
        OpenYAMM::Game::ScriptedEventScope::Map,
        error);
    REQUIRE(scriptedProgram.has_value());
    CHECK(scriptedProgram->isHintOnlyEvent(42));

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    CHECK(eventRuntime.executeEventById(scriptedProgram, std::nullopt, 42, runtimeState, nullptr, nullptr));
}

TEST_CASE("lua map hint-only events shadow colliding global handlers")
{
    std::string error;
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> localProgram =
        OpenYAMM::Game::ScriptedEventProgram::loadFromLuaText(
        "evt.meta.map.hint = {[176] = \"Needful Things\"}\n"
        "evt.meta.map.summary = {[176] = \"Needful Things\"}\n",
        "@SyntheticLocalHintOnlyEvent.lua",
        OpenYAMM::Game::ScriptedEventScope::Map,
        error);
    REQUIRE_MESSAGE(localProgram.has_value(), error.c_str());
    REQUIRE(localProgram->isHintOnlyEvent(176));

    const std::optional<OpenYAMM::Game::ScriptedEventProgram> globalProgram = loadSyntheticScriptedProgram(
        "evt.global[176] = function()\n"
        "    evt._BeginEvent(176)\n"
        "    evt.SimpleMessage(\"global\")\n"
        "    return\n"
        "end\n",
        "@SyntheticGlobalCollisionEvent.lua",
        OpenYAMM::Game::ScriptedEventScope::Global);
    REQUIRE(globalProgram.has_value());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    CHECK(eventRuntime.executeEventById(localProgram, globalProgram, 176, runtimeState, nullptr, nullptr));
    CHECK(runtimeState.messages.empty());
}

TEST_CASE("event runtime caches facet invisible override state")
{
    OpenYAMM::Game::EventRuntimeState runtimeState = {};
    const uint32_t invisibleBit = OpenYAMM::Game::faceAttributeBit(OpenYAMM::Game::FaceAttribute::Invisible);

    runtimeState.facetSetMasks[12] = invisibleBit;
    CHECK(runtimeState.hasFacetInvisibleOverride(12));
    CHECK_FALSE(runtimeState.hasFacetInvisibleOverride(13));

    runtimeState.facetClearMasks[12] = invisibleBit;
    ++runtimeState.outdoorSurfaceRevision;
    CHECK_FALSE(runtimeState.hasFacetInvisibleOverride(12));

    runtimeState.facetClearMasks.erase(12);
    ++runtimeState.outdoorSurfaceRevision;
    CHECK(runtimeState.hasFacetInvisibleOverride(12));
}

TEST_CASE("outdoor bmodel collision geometry keeps invisible faces and uses authored planes")
{
    OpenYAMM::Game::OutdoorBModel bmodel = {};
    bmodel.vertices.push_back({0, 0, 0});
    bmodel.vertices.push_back({128, 0, 0});
    bmodel.vertices.push_back({128, 128, 0});
    bmodel.vertices.push_back({0, 128, 0});

    OpenYAMM::Game::OutdoorBModelFace face = {};
    face.attributes = OpenYAMM::Game::faceAttributeBit(OpenYAMM::Game::FaceAttribute::Invisible);
    face.vertexIndices = {0, 1, 2, 3};
    face.planeNormalX = 65536;
    face.planeNormalY = 0;
    face.planeNormalZ = 0;

    OpenYAMM::Game::OutdoorFaceGeometryData geometry = {};
    REQUIRE(OpenYAMM::Game::buildOutdoorFaceGeometry(bmodel, 0, face, 0, geometry));
    CHECK(geometry.normal.x > 0.99f);
    CHECK(std::abs(geometry.normal.z) < 0.01f);

    face.attributes = OpenYAMM::Game::faceAttributeBit(OpenYAMM::Game::FaceAttribute::Untouchable);
    CHECK_FALSE(OpenYAMM::Game::buildOutdoorFaceGeometry(bmodel, 0, face, 0, geometry));
    CHECK(OpenYAMM::Game::buildOutdoorFaceGeometry(bmodel, 0, face, 0, geometry, true));
}

TEST_CASE("resolve character attack sound id uses shared weapon family mapping")
{
    const OpenYAMM::Tests::RegressionGameData &gameData = requireRegressionGameData();
    const OpenYAMM::Game::ItemTable &itemTable = gameData.itemTable;

    OpenYAMM::Game::Character character = {};
    const uint32_t swordId = findFirstItemIdBySkillGroup(itemTable, "Sword");
    const uint32_t daggerId = findFirstItemIdBySkillGroup(itemTable, "Dagger");
    const uint32_t axeId = findFirstItemIdBySkillGroup(itemTable, "Axe");
    const uint32_t spearId = findFirstItemIdBySkillGroup(itemTable, "Spear");
    const uint32_t maceId = findFirstItemIdBySkillGroup(itemTable, "Mace");

    REQUIRE_NE(swordId, 0u);
    REQUIRE_NE(daggerId, 0u);
    REQUIRE_NE(axeId, 0u);
    REQUIRE_NE(spearId, 0u);
    REQUIRE_NE(maceId, 0u);

    character.equipment.mainHand = swordId;
    CHECK_EQ(
        OpenYAMM::Game::GameMechanics::resolveCharacterAttackSoundId(
            character,
            &itemTable,
            OpenYAMM::Game::CharacterAttackMode::Melee),
        OpenYAMM::Game::SoundId::SwingSword01);

    character.equipment.mainHand = daggerId;
    CHECK_EQ(
        OpenYAMM::Game::GameMechanics::resolveCharacterAttackSoundId(
            character,
            &itemTable,
            OpenYAMM::Game::CharacterAttackMode::Melee),
        OpenYAMM::Game::SoundId::SwingSword02);

    character.equipment.mainHand = axeId;
    CHECK_EQ(
        OpenYAMM::Game::GameMechanics::resolveCharacterAttackSoundId(
            character,
            &itemTable,
            OpenYAMM::Game::CharacterAttackMode::Melee),
        OpenYAMM::Game::SoundId::SwingAxe01);

    character.equipment.mainHand = spearId;
    CHECK_EQ(
        OpenYAMM::Game::GameMechanics::resolveCharacterAttackSoundId(
            character,
            &itemTable,
            OpenYAMM::Game::CharacterAttackMode::Melee),
        OpenYAMM::Game::SoundId::SwingAxe03);

    character.equipment.mainHand = maceId;
    CHECK_EQ(
        OpenYAMM::Game::GameMechanics::resolveCharacterAttackSoundId(
            character,
            &itemTable,
            OpenYAMM::Game::CharacterAttackMode::Melee),
        OpenYAMM::Game::SoundId::SwingBlunt03);

    CHECK_EQ(
        OpenYAMM::Game::GameMechanics::resolveCharacterAttackSoundId(
            character,
            &itemTable,
            OpenYAMM::Game::CharacterAttackMode::Bow),
        OpenYAMM::Game::SoundId::ShootBow);
    CHECK_EQ(
        OpenYAMM::Game::GameMechanics::resolveCharacterAttackSoundId(
            character,
            &itemTable,
            OpenYAMM::Game::CharacterAttackMode::Blaster),
        OpenYAMM::Game::SoundId::ShootBlaster);
    CHECK_EQ(
        OpenYAMM::Game::GameMechanics::resolveCharacterAttackSoundId(
            character,
            &itemTable,
            OpenYAMM::Game::CharacterAttackMode::DragonBreath),
        OpenYAMM::Game::SoundId::DragonBreath);
}

TEST_CASE("audio shutdown remains safe after SDL quit")
{
    SDL_Environment *pEnvironment = SDL_GetEnvironment();
    REQUIRE(pEnvironment != nullptr);
    REQUIRE(SDL_SetEnvironmentVariable(pEnvironment, "SDL_AUDIODRIVER", "dummy", true));

    OpenYAMM::Engine::AssetFileSystem assetFileSystem;
    REQUIRE(initializeTestAssetFileSystem(assetFileSystem));

    OpenYAMM::Engine::AudioSystem audioSystem;
    REQUIRE(audioSystem.initialize(assetFileSystem));

    SDL_Quit();
    audioSystem.shutdown();
    CHECK(SDL_Init(0));
}
