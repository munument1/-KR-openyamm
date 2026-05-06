#include "doctest/doctest.h"

#include "game/events/EventRuntime.h"
#include "game/events/ISceneEventContext.h"
#include "game/FaceEnums.h"
#include "game/gameplay/CorpseLootRuntime.h"
#include "game/gameplay/GameplayActorService.h"
#include "game/maps/MapAssetLoader.h"
#include "game/StringUtils.h"
#include "game/outdoor/OutdoorPartyRuntime.h"
#include "game/outdoor/OutdoorWorldRuntime.h"
#include "game/party/Party.h"

#include "tests/RegressionGameData.h"
#include "tests/RegressionMapLoader.h"

#include <algorithm>
#include <array>
#include <cstring>
#include <fstream>
#include <filesystem>
#include <optional>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

namespace
{
class RecordingSceneEventContext : public OpenYAMM::Game::ISceneEventContext
{
public:
    struct CastSpellCall
    {
        uint32_t spellId = 0;
        uint32_t skillLevel = 0;
        uint32_t skillMastery = 0;
        int32_t fromX = 0;
        int32_t fromY = 0;
        int32_t fromZ = 0;
        int32_t toX = 0;
        int32_t toY = 0;
        int32_t toZ = 0;
    };

    float currentGameMinutes() const override
    {
        return m_currentGameMinutes;
    }

    void setCurrentGameMinutes(float currentGameMinutes)
    {
        m_currentGameMinutes = currentGameMinutes;
    }

    const OpenYAMM::Game::MapDeltaData *mapDeltaData() const override
    {
        return nullptr;
    }

    OpenYAMM::Game::MapDeltaData *mapDeltaData() override
    {
        return nullptr;
    }

    bool setFacetBit(uint32_t cogNumber, uint32_t bit, bool isOn) override
    {
        (void)cogNumber;
        (void)bit;
        (void)isOn;
        return false;
    }

    bool castEventSpell(
        uint32_t spellId,
        uint32_t skillLevel,
        uint32_t skillMastery,
        int32_t fromX,
        int32_t fromY,
        int32_t fromZ,
        int32_t toX,
        int32_t toY,
        int32_t toZ) override
    {
        CastSpellCall call = {};
        call.spellId = spellId;
        call.skillLevel = skillLevel;
        call.skillMastery = skillMastery;
        call.fromX = fromX;
        call.fromY = fromY;
        call.fromZ = fromZ;
        call.toX = toX;
        call.toY = toY;
        call.toZ = toZ;
        castSpellCalls.push_back(call);
        return true;
    }

    bool summonMonsters(
        uint32_t typeIndexInMapStats,
        uint32_t level,
        uint32_t count,
        int32_t x,
        int32_t y,
        int32_t z,
        uint32_t group,
        uint32_t uniqueNameId) override
    {
        (void)typeIndexInMapStats;
        (void)level;
        (void)count;
        (void)x;
        (void)y;
        (void)z;
        (void)group;
        (void)uniqueNameId;
        return false;
    }

    bool summonEventItem(
        uint32_t itemId,
        int32_t x,
        int32_t y,
        int32_t z,
        int32_t speed,
        uint32_t count,
        bool randomRotate) override
    {
        (void)itemId;
        (void)x;
        (void)y;
        (void)z;
        (void)speed;
        (void)count;
        (void)randomRotate;
        return false;
    }

    bool checkMonstersKilled(uint32_t checkType, uint32_t id, uint32_t count, bool invisibleAsDead) const override
    {
        (void)checkType;
        (void)id;
        (void)count;
        (void)invisibleAsDead;
        return false;
    }

    std::vector<CastSpellCall> castSpellCalls;

private:
    float m_currentGameMinutes = 0.0f;
};

const OpenYAMM::Tests::RegressionMapLoader &requireRegressionMapLoader()
{
    REQUIRE_MESSAGE(
        OpenYAMM::Tests::regressionMapLoaderLoaded(),
        OpenYAMM::Tests::regressionMapLoaderFailure().c_str());
    return OpenYAMM::Tests::regressionMapLoader();
}

OpenYAMM::Game::Character makeScriptedRegressionMember()
{
    OpenYAMM::Game::Character member = {};
    member.name = "Ariel";
    member.className = "Knight";
    member.role = "Knight";
    member.portraitTextureName = "PC01-01";
    member.characterDataId = 1;
    member.birthYear = 1160;
    member.level = 1;
    member.might = 14;
    member.intellect = 14;
    member.personality = 14;
    member.endurance = 14;
    member.speed = 14;
    member.accuracy = 14;
    member.luck = 14;
    member.maxHealth = 40;
    member.health = 40;
    return member;
}

OpenYAMM::Game::Party makeScriptedRegressionParty()
{
    OpenYAMM::Game::PartySeed seed = {};
    seed.members.push_back(makeScriptedRegressionMember());
    OpenYAMM::Game::Party party = {};
    party.seed(seed);
    return party;
}

bool loadOutdoorMapWithCompanionOptions(
    const OpenYAMM::Engine::AssetFileSystem &assetFileSystem,
    const OpenYAMM::Game::GameDataLoader &gameDataLoader,
    const std::string &mapFileName,
    OpenYAMM::Game::MapLoadPurpose loadPurpose,
    const OpenYAMM::Game::MapCompanionLoadOptions &loadOptions,
    OpenYAMM::Game::MapAssetInfo &mapAssetInfo)
{
    const OpenYAMM::Game::MapStatsEntry *pMapEntry = gameDataLoader.getMapStats().findByFileName(mapFileName);

    if (pMapEntry == nullptr)
    {
        return false;
    }

    OpenYAMM::Game::MapAssetLoader loader = {};
    const std::optional<OpenYAMM::Game::MapAssetInfo> loadedMap = loader.load(
        assetFileSystem,
        *pMapEntry,
        gameDataLoader.getMonsterTable(),
        gameDataLoader.getObjectTable(),
        loadPurpose,
        loadOptions);

    if (!loadedMap || !loadedMap->outdoorMapData || !loadedMap->outdoorMapDeltaData)
    {
        return false;
    }

    mapAssetInfo = *loadedMap;
    return true;
}

std::string cachedMapKey(
    const char *pKind,
    const std::string &mapFileName,
    OpenYAMM::Game::MapLoadPurpose loadPurpose,
    const OpenYAMM::Game::MapCompanionLoadOptions &loadOptions)
{
    return std::string(pKind)
        + "|"
        + mapFileName
        + "|"
        + std::to_string(static_cast<int>(loadPurpose))
        + "|"
        + (loadOptions.allowSceneYml ? "scene" : "no_scene")
        + "|"
        + (loadOptions.allowLegacyCompanion ? "legacy" : "no_legacy");
}

const OpenYAMM::Game::MapAssetInfo *loadCachedMapWithCompanionOptions(
    const OpenYAMM::Engine::AssetFileSystem &assetFileSystem,
    const OpenYAMM::Game::GameDataLoader &gameDataLoader,
    const std::string &mapFileName,
    OpenYAMM::Game::MapLoadPurpose loadPurpose,
    const OpenYAMM::Game::MapCompanionLoadOptions &loadOptions,
    bool indoor)
{
    static std::unordered_map<std::string, OpenYAMM::Game::MapAssetInfo> cachedMaps;

    const std::string key = cachedMapKey(
        indoor ? "indoor" : "outdoor",
        mapFileName,
        loadPurpose,
        loadOptions);
    const std::unordered_map<std::string, OpenYAMM::Game::MapAssetInfo>::const_iterator cachedIt =
        cachedMaps.find(key);

    if (cachedIt != cachedMaps.end())
    {
        return &cachedIt->second;
    }

    const OpenYAMM::Game::MapStatsEntry *pMapEntry = gameDataLoader.getMapStats().findByFileName(mapFileName);

    if (pMapEntry == nullptr)
    {
        return nullptr;
    }

    OpenYAMM::Game::MapAssetLoader loader = {};
    std::optional<OpenYAMM::Game::MapAssetInfo> loadedMap = loader.load(
        assetFileSystem,
        *pMapEntry,
        gameDataLoader.getMonsterTable(),
        gameDataLoader.getObjectTable(),
        loadPurpose,
        loadOptions);

    if (!loadedMap)
    {
        return nullptr;
    }

    if (indoor)
    {
        if (!loadedMap->indoorMapData || !loadedMap->indoorMapDeltaData)
        {
            return nullptr;
        }
    }
    else if (!loadedMap->outdoorMapData || !loadedMap->outdoorMapDeltaData)
    {
        return nullptr;
    }

    const auto inserted = cachedMaps.emplace(key, std::move(*loadedMap));
    return &inserted.first->second;
}

const OpenYAMM::Game::MapAssetInfo *loadCachedOutdoorMapWithCompanionOptions(
    const OpenYAMM::Engine::AssetFileSystem &assetFileSystem,
    const OpenYAMM::Game::GameDataLoader &gameDataLoader,
    const std::string &mapFileName,
    OpenYAMM::Game::MapLoadPurpose loadPurpose,
    const OpenYAMM::Game::MapCompanionLoadOptions &loadOptions)
{
    return loadCachedMapWithCompanionOptions(
        assetFileSystem,
        gameDataLoader,
        mapFileName,
        loadPurpose,
        loadOptions,
        false);
}

const OpenYAMM::Game::MapAssetInfo *loadCachedIndoorMapWithCompanionOptions(
    const OpenYAMM::Engine::AssetFileSystem &assetFileSystem,
    const OpenYAMM::Game::GameDataLoader &gameDataLoader,
    const std::string &mapFileName,
    OpenYAMM::Game::MapLoadPurpose loadPurpose,
    const OpenYAMM::Game::MapCompanionLoadOptions &loadOptions)
{
    return loadCachedMapWithCompanionOptions(
        assetFileSystem,
        gameDataLoader,
        mapFileName,
        loadPurpose,
        loadOptions,
        true);
}

bool loadIndoorMapWithCompanionOptions(
    const OpenYAMM::Engine::AssetFileSystem &assetFileSystem,
    const OpenYAMM::Game::GameDataLoader &gameDataLoader,
    const std::string &mapFileName,
    OpenYAMM::Game::MapLoadPurpose loadPurpose,
    const OpenYAMM::Game::MapCompanionLoadOptions &loadOptions,
    OpenYAMM::Game::MapAssetInfo &mapAssetInfo)
{
    const OpenYAMM::Game::MapStatsEntry *pMapEntry = gameDataLoader.getMapStats().findByFileName(mapFileName);

    if (pMapEntry == nullptr)
    {
        return false;
    }

    OpenYAMM::Game::MapAssetLoader loader = {};
    const std::optional<OpenYAMM::Game::MapAssetInfo> loadedMap = loader.load(
        assetFileSystem,
        *pMapEntry,
        gameDataLoader.getMonsterTable(),
        gameDataLoader.getObjectTable(),
        loadPurpose,
        loadOptions);

    if (!loadedMap || !loadedMap->indoorMapData || !loadedMap->indoorMapDeltaData)
    {
        return false;
    }

    mapAssetInfo = *loadedMap;
    return true;
}

bool bitmapTextureSetContains(
    const std::vector<OpenYAMM::Game::OutdoorBitmapTexture> &textures,
    const std::string &textureName)
{
    const std::string normalizedTextureName = OpenYAMM::Game::toLowerCopy(textureName);

    for (const OpenYAMM::Game::OutdoorBitmapTexture &texture : textures)
    {
        if (OpenYAMM::Game::toLowerCopy(texture.textureName) == normalizedTextureName)
        {
            return true;
        }
    }

    return false;
}

const OpenYAMM::Game::SurfaceAnimationSequence *findSurfaceAnimationBinding(
    const std::vector<std::pair<std::string, OpenYAMM::Game::SurfaceAnimationSequence>> &bindings,
    const std::string &textureName)
{
    const std::string normalizedTextureName = OpenYAMM::Game::toLowerCopy(textureName);

    for (const auto &binding : bindings)
    {
        if (OpenYAMM::Game::toLowerCopy(binding.first) == normalizedTextureName)
        {
            return &binding.second;
        }
    }

    return nullptr;
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

std::string bytesToUpperHex(const std::vector<uint8_t> &bytes)
{
    static constexpr char HexDigits[] = "0123456789ABCDEF";

    std::string text;
    text.reserve(bytes.size() * 2);

    for (uint8_t value : bytes)
    {
        text.push_back(HexDigits[(value >> 4) & 0x0F]);
        text.push_back(HexDigits[value & 0x0F]);
    }

    return text;
}

std::optional<std::string> readSourceTextFile(const std::filesystem::path &path)
{
    std::ifstream stream(path);

    if (!stream)
    {
        return std::nullopt;
    }

    std::ostringstream contents;
    contents << stream.rdbuf();
    return contents.str();
}

void appendNormalizedPosition(std::ostringstream &stream, int x, int y, int z)
{
    stream << x << ',' << y << ',' << z;
}

std::string buildNormalizedOutdoorAuthoredSnapshot(const OpenYAMM::Game::MapAssetInfo &mapAssetInfo)
{
    std::ostringstream stream;

    if (!mapAssetInfo.outdoorMapData || !mapAssetInfo.outdoorMapDeltaData)
    {
        stream << "missing_outdoor_state\n";
        return stream.str();
    }

    const OpenYAMM::Game::OutdoorMapData &outdoorMapData = *mapAssetInfo.outdoorMapData;
    const OpenYAMM::Game::MapDeltaData &mapDeltaData = *mapAssetInfo.outdoorMapDeltaData;
    const std::string effectiveSkyTexture =
        !mapDeltaData.locationTime.skyTextureName.empty()
        ? mapDeltaData.locationTime.skyTextureName
        : outdoorMapData.skyTexture;
    uint32_t mapExtraBitsRaw = 0;
    int32_t ceiling = 0;

    if (mapDeltaData.locationTime.reserved.size() >= sizeof(mapExtraBitsRaw) + sizeof(ceiling))
    {
        std::memcpy(&mapExtraBitsRaw, mapDeltaData.locationTime.reserved.data(), sizeof(mapExtraBitsRaw));
        std::memcpy(
            &ceiling,
            mapDeltaData.locationTime.reserved.data() + sizeof(mapExtraBitsRaw),
            sizeof(ceiling));
    }

    stream << "environment\n";
    stream << "sky_texture=" << effectiveSkyTexture << '\n';
    stream << "ground_tileset_name=" << outdoorMapData.groundTilesetName << '\n';
    stream << "master_tile=" << static_cast<int>(outdoorMapData.masterTile) << '\n';
    stream << "tile_set_lookup_indices="
           << outdoorMapData.tileSetLookupIndices[0] << ','
           << outdoorMapData.tileSetLookupIndices[1] << ','
           << outdoorMapData.tileSetLookupIndices[2] << ','
           << outdoorMapData.tileSetLookupIndices[3] << '\n';
    stream << "day_bits_raw=" << mapDeltaData.locationTime.weatherFlags << '\n';
    stream << "map_extra_bits_raw=" << mapExtraBitsRaw << '\n';
    stream << "flag_foggy=" << (((mapDeltaData.locationTime.weatherFlags & 0x1) != 0) ? 1 : 0) << '\n';
    stream << "flag_raining=" << (((mapExtraBitsRaw & 0x1) != 0) ? 1 : 0) << '\n';
    stream << "flag_snowing=" << (((mapExtraBitsRaw & 0x2) != 0) ? 1 : 0) << '\n';
    stream << "flag_underwater=" << (((mapExtraBitsRaw & 0x4) != 0) ? 1 : 0) << '\n';
    stream << "flag_no_terrain=" << (((mapExtraBitsRaw & 0x8) != 0) ? 1 : 0) << '\n';
    stream << "flag_always_dark=" << (((mapExtraBitsRaw & 0x10) != 0) ? 1 : 0) << '\n';
    stream << "flag_always_light=" << (((mapExtraBitsRaw & 0x20) != 0) ? 1 : 0) << '\n';
    stream << "flag_always_foggy=" << (((mapExtraBitsRaw & 0x40) != 0) ? 1 : 0) << '\n';
    stream << "flag_red_fog=" << (((mapExtraBitsRaw & 0x80) != 0) ? 1 : 0) << '\n';
    stream << "fog_weak_distance=" << mapDeltaData.locationTime.fogWeakDistance << '\n';
    stream << "fog_strong_distance=" << mapDeltaData.locationTime.fogStrongDistance << '\n';
    stream << "ceiling=" << ceiling << '\n';

    stream << "terrain\n";

    for (size_t cellIndex = 0; cellIndex < outdoorMapData.attributeMap.size(); ++cellIndex)
    {
        const uint8_t value = outdoorMapData.attributeMap[cellIndex];

        if (value == 0)
        {
            continue;
        }

        const size_t x = cellIndex % OpenYAMM::Game::OutdoorMapData::TerrainWidth;
        const size_t y = cellIndex / OpenYAMM::Game::OutdoorMapData::TerrainWidth;
        stream << x << ',' << y << ',' << static_cast<int>(value)
               << ',' << (((value & 0x01) != 0) ? 1 : 0)
               << ',' << (((value & 0x02) != 0) ? 1 : 0) << '\n';
    }

    stream << "interactive_faces\n";

    for (size_t bmodelIndex = 0; bmodelIndex < outdoorMapData.bmodels.size(); ++bmodelIndex)
    {
        const OpenYAMM::Game::OutdoorBModel &bmodel = outdoorMapData.bmodels[bmodelIndex];

        for (size_t faceIndex = 0; faceIndex < bmodel.faces.size(); ++faceIndex)
        {
            const OpenYAMM::Game::OutdoorBModelFace &face = bmodel.faces[faceIndex];

            if (face.attributes == 0
                && face.cogNumber == 0
                && face.cogTriggeredNumber == 0
                && face.cogTrigger == 0)
            {
                continue;
            }

            stream << bmodelIndex << ',' << faceIndex << ','
                   << face.attributes << ','
                   << face.cogNumber << ','
                   << face.cogTriggeredNumber << ','
                   << face.cogTrigger << '\n';
        }
    }

    stream << "entities\n";

    for (size_t entityIndex = 0; entityIndex < outdoorMapData.entities.size(); ++entityIndex)
    {
        const OpenYAMM::Game::OutdoorEntity &entity = outdoorMapData.entities[entityIndex];
        const uint16_t decorationFlag =
            entityIndex < mapDeltaData.decorationFlags.size()
            ? mapDeltaData.decorationFlags[entityIndex]
            : 0;

        stream << entity.name << '|'
               << entity.decorationListId << '|'
               << entity.aiAttributes << '|';
        appendNormalizedPosition(stream, entity.x, entity.y, entity.z);
        stream << '|'
               << entity.facing << '|'
               << entity.eventIdPrimary << '|'
               << entity.eventIdSecondary << '|'
               << entity.variablePrimary << '|'
               << entity.variableSecondary << '|'
               << entity.specialTrigger << '|'
               << decorationFlag << '\n';
    }

    stream << "spawns\n";

    for (const OpenYAMM::Game::OutdoorSpawn &spawn : outdoorMapData.spawns)
    {
        appendNormalizedPosition(stream, spawn.x, spawn.y, spawn.z);
        stream << '|'
               << spawn.radius << '|'
               << spawn.typeId << '|'
               << spawn.index << '|'
               << spawn.attributes << '|'
               << spawn.group << '\n';
    }

    stream << "location\n";
    stream << mapDeltaData.locationInfo.respawnCount << '|'
           << mapDeltaData.locationInfo.lastRespawnDay << '|'
           << mapDeltaData.locationInfo.reputation << '|'
           << mapDeltaData.locationInfo.alertStatus << '\n';

    stream << "face_attribute_overrides\n";
    size_t flattenedFaceIndex = 0;

    for (size_t bmodelIndex = 0; bmodelIndex < outdoorMapData.bmodels.size(); ++bmodelIndex)
    {
        const OpenYAMM::Game::OutdoorBModel &bmodel = outdoorMapData.bmodels[bmodelIndex];

        for (size_t faceIndex = 0; faceIndex < bmodel.faces.size(); ++faceIndex, ++flattenedFaceIndex)
        {
            const uint32_t baseValue = bmodel.faces[faceIndex].attributes;
            const uint32_t overrideValue =
                flattenedFaceIndex < mapDeltaData.faceAttributes.size()
                ? mapDeltaData.faceAttributes[flattenedFaceIndex]
                : baseValue;

            if (overrideValue == baseValue)
            {
                continue;
            }

            stream << bmodelIndex << ',' << faceIndex << ',' << overrideValue << '\n';
        }
    }

    stream << "actors\n";

    for (const OpenYAMM::Game::MapDeltaActor &actor : mapDeltaData.actors)
    {
        stream << actor.name << '|'
               << actor.npcId << '|'
               << actor.attributes << '|'
               << actor.hp << '|'
               << static_cast<int>(actor.hostilityType) << '|'
               << actor.monsterInfoId << '|'
               << actor.monsterId << '|'
               << actor.radius << '|'
               << actor.height << '|'
               << actor.moveSpeed << '|';
        appendNormalizedPosition(stream, actor.x, actor.y, actor.z);
        stream << '|'
               << actor.spriteIds[0] << ','
               << actor.spriteIds[1] << ','
               << actor.spriteIds[2] << ','
               << actor.spriteIds[3] << '|'
               << actor.sectorId << '|'
               << actor.currentActionAnimation << '|'
               << actor.group << '|'
               << actor.ally << '|'
               << actor.uniqueNameIndex << '\n';
    }

    stream << "sprite_objects\n";

    for (const OpenYAMM::Game::MapDeltaSpriteObject &spriteObject : mapDeltaData.spriteObjects)
    {
        stream << spriteObject.spriteId << '|'
               << spriteObject.objectDescriptionId << '|';
        appendNormalizedPosition(stream, spriteObject.x, spriteObject.y, spriteObject.z);
        stream << '|';
        appendNormalizedPosition(
            stream,
            spriteObject.velocityX,
            spriteObject.velocityY,
            spriteObject.velocityZ);
        stream << '|'
               << spriteObject.yawAngle << '|'
               << spriteObject.soundId << '|'
               << spriteObject.attributes << '|'
               << spriteObject.sectorId << '|'
               << spriteObject.timeSinceCreated << '|'
               << spriteObject.temporaryLifetime << '|'
               << spriteObject.glowRadiusMultiplier << '|'
               << spriteObject.spellId << '|'
               << spriteObject.spellLevel << '|'
               << spriteObject.spellSkill << '|'
               << spriteObject.field54 << '|'
               << spriteObject.spellCasterPid << '|'
               << spriteObject.spellTargetPid << '|'
               << static_cast<int>(spriteObject.lodDistance) << '|'
               << static_cast<int>(spriteObject.spellCasterAbility) << '|';
        appendNormalizedPosition(
            stream,
            spriteObject.initialX,
            spriteObject.initialY,
            spriteObject.initialZ);
        stream << '|'
               << bytesToUpperHex(spriteObject.rawContainingItem) << '\n';
    }

    stream << "chests\n";

    for (const OpenYAMM::Game::MapDeltaChest &chest : mapDeltaData.chests)
    {
        stream << chest.chestTypeId << '|'
               << chest.flags << '|'
               << bytesToUpperHex(chest.rawItems) << '|';

        for (size_t index = 0; index < chest.inventoryMatrix.size(); ++index)
        {
            if (index > 0)
            {
                stream << ',';
            }

            stream << chest.inventoryMatrix[index];
        }

        stream << '\n';
    }

    stream << "variables_map\n";

    for (size_t index = 0; index < mapDeltaData.eventVariables.mapVars.size(); ++index)
    {
        if (index > 0)
        {
            stream << ',';
        }

        stream << static_cast<int>(mapDeltaData.eventVariables.mapVars[index]);
    }

    stream << "\nvariables_decor\n";

    for (size_t index = 0; index < mapDeltaData.eventVariables.decorVars.size(); ++index)
    {
        if (index > 0)
        {
            stream << ',';
        }

        stream << static_cast<int>(mapDeltaData.eventVariables.decorVars[index]);
    }

    stream << '\n';
    return stream.str();
}
}

TEST_CASE("generated_lua_event_scripts_are_loaded_from_files")
{
    const OpenYAMM::Tests::RegressionMapLoader &mapLoader = requireRegressionMapLoader();
    const std::optional<OpenYAMM::Game::MapAssetInfo> &selectedMap = mapLoader.gameDataLoader.getSelectedMap();

    REQUIRE(selectedMap.has_value());
    REQUIRE(selectedMap->globalEventProgram.has_value());
    REQUIRE(selectedMap->globalEventProgram->luaSourceText().has_value());
    REQUIRE(selectedMap->globalEventProgram->luaSourceName().has_value());
    CHECK(selectedMap->globalEventProgram->luaSourceName()->starts_with("@events/Global.lua"));
    CHECK(
        selectedMap->globalEventProgram->luaSourceName()->find("events/Global_mmmerge.lua")
        != std::string::npos);
    CHECK(std::filesystem::exists(
        std::filesystem::path(OPENYAMM_SOURCE_DIR) / "assets_dev/engine/events/Global.lua"));
    CHECK_FALSE(std::filesystem::exists(
        std::filesystem::path(OPENYAMM_SOURCE_DIR) / "assets_dev/engine/scripts/Global.lua"));
    CHECK_FALSE(std::filesystem::exists(
        std::filesystem::path(OPENYAMM_SOURCE_DIR) / "assets_dev/worlds/mm8/events/Global.lua"));

    REQUIRE(selectedMap->localEventProgram.has_value());
    REQUIRE(selectedMap->localEventProgram->luaSourceText().has_value());
    REQUIRE(selectedMap->localEventProgram->luaSourceName().has_value());

    const std::string expectedLocalSourceName =
        "@events/maps/"
        + OpenYAMM::Game::toLowerCopy(std::filesystem::path(selectedMap->map.fileName).stem().string())
        + ".lua";

    CHECK_EQ(*selectedMap->localEventProgram->luaSourceName(), expectedLocalSourceName);
}

TEST_CASE("mm6 new sorpigal tree event stores decoration sprite override")
{
    const std::filesystem::path sourceRoot = OPENYAMM_SOURCE_DIR;
    const std::optional<std::string> supportLua =
        readSourceTextFile(sourceRoot / "assets_dev/engine/scripts/common/event_support.lua");
    const std::optional<std::string> oute3Lua =
        readSourceTextFile(sourceRoot / "assets_dev/worlds/mm6/events/maps/oute3.lua");

    REQUIRE(supportLua.has_value());
    REQUIRE(oute3Lua.has_value());

    std::string error;
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> localEventProgram =
        OpenYAMM::Game::ScriptedEventProgram::loadFromLuaText(
            *supportLua + "\n\n" + *oute3Lua,
            "@events/maps/oute3.lua",
            OpenYAMM::Game::ScriptedEventScope::Map,
            error);
    REQUIRE_MESSAGE(localEventProgram.has_value(), error.c_str());

    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());

    OpenYAMM::Game::EventRuntimeState runtimeState = {};
    OpenYAMM::Game::EventRuntime eventRuntime = {};

    REQUIRE(eventRuntime.executeEventById(localEventProgram, std::nullopt, 113, runtimeState, &party, nullptr));

    const auto overrideIterator = runtimeState.spriteOverrides.find(300);
    REQUIRE(overrideIterator != runtimeState.spriteOverrides.end());
    CHECK_FALSE(overrideIterator->second.hidden);
    REQUIRE(overrideIterator->second.textureName.has_value());
    CHECK_EQ(*overrideIterator->second.textureName, "6tree06");
}

TEST_CASE("map Lua overlays can remove and replace generated events")
{
    const std::filesystem::path sourceRoot = OPENYAMM_SOURCE_DIR;
    const std::optional<std::string> supportLua =
        readSourceTextFile(sourceRoot / "assets_dev/engine/scripts/common/event_support.lua");

    REQUIRE(supportLua.has_value());

    const std::string luaSource =
        *supportLua
        + R"lua(

SetMapMetadata({
    onLoad = {10, 11},
    onLeave = {10},
    openedChestIds = {
        [10] = {1},
    },
    timers = {
        { eventId = 10, repeating = true, intervalGameMinutes = 2, remainingGameMinutes = 2 },
    },
})

RegisterEvent(10, "Generated", function()
end, "Generated hint")

RegisterEvent(11, "Kept", function()
end, "Kept hint")

RemoveMapEvent(10)
ReplaceMapEvent(11, "Overlay", function()
end, "Overlay hint")

)lua";

    std::string error;
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> localEventProgram =
        OpenYAMM::Game::ScriptedEventProgram::loadFromLuaText(
            luaSource,
            "@events/maps/test_overlay.lua",
            OpenYAMM::Game::ScriptedEventScope::Map,
            error);

    REQUIRE_MESSAGE(localEventProgram.has_value(), error.c_str());

    CHECK_FALSE(localEventProgram->hasEvent(10));
    CHECK_FALSE(localEventProgram->getHint(10).has_value());
    CHECK(localEventProgram->getOpenedChestIds(10).empty());
    CHECK(std::find(
        localEventProgram->onLoadEventIds().begin(),
        localEventProgram->onLoadEventIds().end(),
        10) == localEventProgram->onLoadEventIds().end());
    CHECK(std::find(
        localEventProgram->onLeaveEventIds().begin(),
        localEventProgram->onLeaveEventIds().end(),
        10) == localEventProgram->onLeaveEventIds().end());

    bool hasRemovedTimer = false;

    for (const OpenYAMM::Game::ScriptedEventProgram::TimerTrigger &timer : localEventProgram->timerTriggers())
    {
        if (timer.eventId == 10)
        {
            hasRemovedTimer = true;
        }
    }

    CHECK_FALSE(hasRemovedTimer);
    CHECK(localEventProgram->hasEvent(11));
    const std::optional<std::string> replacementSummary = localEventProgram->summarizeEvent(11);
    const std::optional<std::string> replacementHint = localEventProgram->getHint(11);
    REQUIRE(replacementSummary.has_value());
    REQUIRE(replacementHint.has_value());
    CHECK_EQ(*replacementSummary, "Overlay");
    CHECK_EQ(*replacementHint, "Overlay hint");
}

TEST_CASE("mm7 lincoln mmmerge supplement registers containment actors on load")
{
    const std::filesystem::path sourceRoot = OPENYAMM_SOURCE_DIR;
    const std::optional<std::string> supportLua =
        readSourceTextFile(sourceRoot / "assets_dev/engine/scripts/common/event_support.lua");
    const std::optional<std::string> baseLua =
        readSourceTextFile(sourceRoot / "assets_dev/worlds/mm7/events/maps/7d23.lua");
    const std::optional<std::string> overlayLua =
        readSourceTextFile(sourceRoot / "assets_dev/worlds/mm7/events/maps/7d23_mmmerge.lua");

    REQUIRE(supportLua.has_value());
    REQUIRE(baseLua.has_value());
    REQUIRE(overlayLua.has_value());

    std::string error;
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> localEventProgram =
        OpenYAMM::Game::ScriptedEventProgram::loadFromLuaText(
            *supportLua + "\n\n" + *baseLua + "\n\n" + *overlayLua,
            "@events/maps/7d23.lua + events/maps/7d23_mmmerge.lua",
            OpenYAMM::Game::ScriptedEventScope::Map,
            error);

    REQUIRE_MESSAGE(localEventProgram.has_value(), error.c_str());
    CHECK(localEventProgram->hasEvent(65023));
    CHECK(std::find(
        localEventProgram->onLoadEventIds().begin(),
        localEventProgram->onLoadEventIds().end(),
        65023) != localEventProgram->onLoadEventIds().end());

    OpenYAMM::Game::EventRuntimeState runtimeState = {};
    OpenYAMM::Game::EventRuntime eventRuntime = {};

    REQUIRE(eventRuntime.buildOnLoadState(localEventProgram, std::nullopt, std::nullopt, runtimeState));
    CHECK_EQ(
        runtimeState.actorGroupClearMasks[56] & static_cast<uint32_t>(OpenYAMM::Game::EvtActorAttribute::Hostile),
        static_cast<uint32_t>(OpenYAMM::Game::EvtActorAttribute::Hostile));
    CHECK_EQ(
        runtimeState.actorGroupSetMasks[56] & static_cast<uint32_t>(OpenYAMM::Game::EvtActorAttribute::Invisible),
        static_cast<uint32_t>(OpenYAMM::Game::EvtActorAttribute::Invisible));
}

TEST_CASE("mm6 outdoor mmmerge supplements unlock local town portal destinations")
{
    struct Case
    {
        const char *pBaseName = nullptr;
        const char *pOverlayName = nullptr;
        uint32_t qbitId = 0;
        uint16_t onLoadEventId = 0;
        bool clearsGuardHostility = false;
        uint32_t dragonTowerQbitId = 0;
        uint16_t dragonTowerEventId = 0;
        uint32_t dragonTowerModelIndex = 0;
        uint32_t dragonTowerFaceIndex = 0;
        uint32_t peacefulMonsterKind = 0;
    };

    constexpr std::array<Case, 6> Cases = {{
        {"outb2", "outb2_mmmerge", 310, 65024, true, 1184, 211, 61, 42, 196},
        {"outc1", "outc1_mmmerge", 315, 65025, true, 1185, 210, 114, 42, 0},
        {"outc2", "outc2_mmmerge", 311, 65026, false, 1183, 210, 25, 55, 0},
        {"outd1", "outd1_mmmerge", 314, 65027, false, 1182, 210, 117, 42, 211},
        {"oute2", "oute2_mmmerge", 312, 65028, false, 1181, 211, 53, 42, 211},
        {"oute3", "oute3_mmmerge", 313, 65029, false, 1180, 231, 84, 42, 185},
    }};

    const std::filesystem::path sourceRoot = OPENYAMM_SOURCE_DIR;
    const std::optional<std::string> supportLua =
        readSourceTextFile(sourceRoot / "assets_dev/engine/scripts/common/event_support.lua");
    const std::optional<std::string> mm6CommonLua =
        readSourceTextFile(sourceRoot / "assets_dev/worlds/mm6/events/common/mm6_common.lua");
    REQUIRE(supportLua.has_value());
    REQUIRE(mm6CommonLua.has_value());

    for (const Case &testCase : Cases)
    {
        const std::optional<std::string> baseLua =
            readSourceTextFile(
                sourceRoot / "assets_dev/worlds/mm6/events/maps" / (std::string(testCase.pBaseName) + ".lua"));
        const std::optional<std::string> overlayLua =
            readSourceTextFile(
                sourceRoot / "assets_dev/worlds/mm6/events/maps" / (std::string(testCase.pOverlayName) + ".lua"));

        REQUIRE(baseLua.has_value());
        REQUIRE(overlayLua.has_value());

        std::string error;
        const std::optional<OpenYAMM::Game::ScriptedEventProgram> localEventProgram =
            OpenYAMM::Game::ScriptedEventProgram::loadFromLuaText(
                *supportLua + "\n\n" + *mm6CommonLua + "\n\n" + *baseLua + "\n\n" + *overlayLua,
                std::string("@events/maps/") + testCase.pBaseName + ".lua + events/maps/"
                    + testCase.pOverlayName + ".lua",
                OpenYAMM::Game::ScriptedEventScope::Map,
                error);

        REQUIRE_MESSAGE(localEventProgram.has_value(), error.c_str());
        CHECK(localEventProgram->hasEvent(testCase.onLoadEventId));
        CHECK(std::find(
            localEventProgram->onLoadEventIds().begin(),
            localEventProgram->onLoadEventIds().end(),
            testCase.onLoadEventId) != localEventProgram->onLoadEventIds().end());
        const uint16_t dragonTowerTimerEventId = testCase.dragonTowerEventId - 1;
        CHECK(localEventProgram->hasEvent(dragonTowerTimerEventId));

        size_t dragonTowerTimerCount = 0;
        for (const OpenYAMM::Game::ScriptedEventProgram::TimerTrigger &timer : localEventProgram->timerTriggers())
        {
            if (timer.eventId == dragonTowerTimerEventId)
            {
                ++dragonTowerTimerCount;
                CHECK(timer.repeating);
                CHECK_EQ(timer.intervalGameMinutes, 5.0f);
                CHECK_EQ(timer.remainingGameMinutes, 5.0f);
            }
        }
        CHECK_EQ(dragonTowerTimerCount, 1u);

        OpenYAMM::Game::Party party = makeScriptedRegressionParty();
        OpenYAMM::Game::EventRuntimeState runtimeState = {};
        OpenYAMM::Game::EventRuntime eventRuntime = {};

        REQUIRE(eventRuntime.buildOnLoadState(localEventProgram, std::nullopt, std::nullopt, runtimeState, &party));
        CHECK(party.hasQuestBit(testCase.qbitId));
        CHECK_FALSE(party.hasQuestBit(testCase.dragonTowerQbitId));

        if (std::string(testCase.pBaseName) == "outc1")
        {
            REQUIRE(runtimeState.outdoorSkyTextureOverride.has_value());
            CHECK_EQ(*runtimeState.outdoorSkyTextureOverride, "sky04");
            REQUIRE(runtimeState.outdoorFogWeakDistanceOverride.has_value());
            CHECK_EQ(*runtimeState.outdoorFogWeakDistanceOverride, 100);
            REQUIRE(runtimeState.outdoorFogStrongDistanceOverride.has_value());
            CHECK_EQ(*runtimeState.outdoorFogStrongDistanceOverride, 1000);
            REQUIRE(runtimeState.snowEnabled.has_value());
            CHECK(*runtimeState.snowEnabled);
        }

        const uint32_t textureKey =
            OpenYAMM::Game::EventRuntime::outdoorModelFacetTextureOverrideKey(
                testCase.dragonTowerModelIndex,
                testCase.dragonTowerFaceIndex);
        CHECK_FALSE(runtimeState.outdoorModelFacetTextureOverrides.contains(textureKey));

        if (testCase.peacefulMonsterKind != 0)
        {
            const uint32_t relationKey =
                OpenYAMM::Game::EventRuntime::monsterRelationOverrideKey(testCase.peacefulMonsterKind, 0);
            REQUIRE(runtimeState.monsterRelationOverrides.contains(relationKey));
            CHECK_EQ(runtimeState.monsterRelationOverrides.at(relationKey), 0);
        }

        OpenYAMM::Game::EventRuntimeState towerState = {};
        REQUIRE(eventRuntime.buildOnLoadState(localEventProgram, std::nullopt, std::nullopt, towerState, &party));
        CHECK_FALSE(towerState.outdoorModelFacetTextureOverrides.contains(textureKey));
        party.grantItem(2106);
        REQUIRE(eventRuntime.executeEventById(
            localEventProgram,
            std::nullopt,
            testCase.dragonTowerEventId,
            towerState,
            &party,
            nullptr));
        CHECK(party.hasQuestBit(testCase.dragonTowerQbitId));

        REQUIRE(towerState.outdoorModelFacetTextureOverrides.contains(textureKey));
        CHECK_EQ(towerState.outdoorModelFacetTextureOverrides.at(textureKey), "t1swbu");

        OpenYAMM::Game::EventRuntimeState noFlyTimerState = {};
        OpenYAMM::Game::Party noFlyParty = makeScriptedRegressionParty();
        RecordingSceneEventContext noFlyContext = {};
        REQUIRE(eventRuntime.executeEventById(
            localEventProgram,
            std::nullopt,
            dragonTowerTimerEventId,
            noFlyTimerState,
            &noFlyParty,
            &noFlyContext));
        CHECK(noFlyContext.castSpellCalls.empty());

        OpenYAMM::Game::EventRuntimeState flyTimerState = {};
        OpenYAMM::Game::Party flyParty = makeScriptedRegressionParty();
        flyParty.applyPartyBuff(
            OpenYAMM::Game::PartyBuffId::Fly,
            300.0f,
            0,
            0,
            0,
            OpenYAMM::Game::SkillMastery::Normal,
            0);
        RecordingSceneEventContext flyContext = {};
        REQUIRE(eventRuntime.executeEventById(
            localEventProgram,
            std::nullopt,
            dragonTowerTimerEventId,
            flyTimerState,
            &flyParty,
            &flyContext));
        REQUIRE_EQ(flyContext.castSpellCalls.size(), 1u);
        CHECK_EQ(flyContext.castSpellCalls.front().spellId, 6u);
        CHECK_EQ(flyContext.castSpellCalls.front().skillLevel, 5u);
        CHECK_EQ(flyContext.castSpellCalls.front().skillMastery, 3u);
        CHECK_EQ(flyContext.castSpellCalls.front().toX, 0);
        CHECK_EQ(flyContext.castSpellCalls.front().toY, 0);
        CHECK_EQ(flyContext.castSpellCalls.front().toZ, 0);

        OpenYAMM::Game::EventRuntimeState invisibleTimerState = {};
        OpenYAMM::Game::Party invisibleParty = makeScriptedRegressionParty();
        invisibleParty.applyPartyBuff(
            OpenYAMM::Game::PartyBuffId::Fly,
            300.0f,
            0,
            0,
            0,
            OpenYAMM::Game::SkillMastery::Normal,
            0);
        invisibleParty.applyPartyBuff(
            OpenYAMM::Game::PartyBuffId::Invisibility,
            300.0f,
            0,
            0,
            0,
            OpenYAMM::Game::SkillMastery::Normal,
            0);
        RecordingSceneEventContext invisibleContext = {};
        REQUIRE(eventRuntime.executeEventById(
            localEventProgram,
            std::nullopt,
            dragonTowerTimerEventId,
            invisibleTimerState,
            &invisibleParty,
            &invisibleContext));
        CHECK(invisibleContext.castSpellCalls.empty());

        OpenYAMM::Game::EventRuntimeState disabledTimerState = {};
        OpenYAMM::Game::Party disabledParty = makeScriptedRegressionParty();
        disabledParty.applyPartyBuff(
            OpenYAMM::Game::PartyBuffId::Fly,
            300.0f,
            0,
            0,
            0,
            OpenYAMM::Game::SkillMastery::Normal,
            0);
        disabledParty.setQuestBit(testCase.dragonTowerQbitId, true);
        RecordingSceneEventContext disabledContext = {};
        REQUIRE(eventRuntime.executeEventById(
            localEventProgram,
            std::nullopt,
            dragonTowerTimerEventId,
            disabledTimerState,
            &disabledParty,
            &disabledContext));
        CHECK(disabledContext.castSpellCalls.empty());

        if (testCase.clearsGuardHostility)
        {
            const uint32_t hostileBit =
                static_cast<uint32_t>(OpenYAMM::Game::EvtActorAttribute::Hostile);
            CHECK_EQ(runtimeState.actorGroupClearMasks[39] & hostileBit, hostileBit);
            REQUIRE(runtimeState.actorGroupHostilityRequests.contains(39));
            CHECK_FALSE(runtimeState.actorGroupHostilityRequests.at(39));
        }
    }
}

TEST_CASE("mm6 loretta stable overlays preserve stable entry")
{
    REQUIRE_MESSAGE(
        OpenYAMM::Tests::regressionGameDataLoaded(),
        OpenYAMM::Tests::regressionGameDataFailure().c_str());

    struct Case
    {
        const char *pBaseName = nullptr;
        const char *pOverlayName = nullptr;
        uint16_t eventId = 0;
        uint32_t houseId = 0;
        uint32_t lorettaQbitId = 0;
    };

    constexpr std::array<Case, 9> Cases = {{
        {"outb1", "outb1_mmmerge", 8, 477, 1515},
        {"outb2", "outb2_mmmerge", 10, 478, 1516},
        {"outc1", "outc1_mmmerge", 31, 476, 1517},
        {"outc2", "outc2_mmmerge", 14, 472, 1518},
        {"outc2", "outc2_mmmerge", 16, 473, 1519},
        {"outc3", "outc3_mmmerge", 8, 474, 1520},
        {"outd1", "outd1_mmmerge", 10, 475, 1521},
        {"outd3", "outd3_mmmerge", 8, 471, 1522},
        {"oute3", "oute3_mmmerge", 15, 470, 1523},
    }};

    const std::filesystem::path sourceRoot = OPENYAMM_SOURCE_DIR;
    const std::optional<std::string> supportLua =
        readSourceTextFile(sourceRoot / "assets_dev/engine/scripts/common/event_support.lua");
    const std::optional<std::string> mm6CommonLua =
        readSourceTextFile(sourceRoot / "assets_dev/worlds/mm6/events/common/mm6_common.lua");
    REQUIRE(supportLua.has_value());
    REQUIRE(mm6CommonLua.has_value());

    for (const Case &testCase : Cases)
    {
        const std::optional<std::string> baseLua =
            readSourceTextFile(
                sourceRoot / "assets_dev/worlds/mm6/events/maps" / (std::string(testCase.pBaseName) + ".lua"));
        const std::optional<std::string> overlayLua =
            readSourceTextFile(
                sourceRoot / "assets_dev/worlds/mm6/events/maps" / (std::string(testCase.pOverlayName) + ".lua"));
        REQUIRE(baseLua.has_value());
        REQUIRE(overlayLua.has_value());

        std::string error;
        const std::optional<OpenYAMM::Game::ScriptedEventProgram> localEventProgram =
            OpenYAMM::Game::ScriptedEventProgram::loadFromLuaText(
                *supportLua + "\n\n" + *mm6CommonLua + "\n\n" + *baseLua + "\n\n" + *overlayLua,
                std::string("@events/maps/") + testCase.pBaseName + ".lua + events/maps/"
                    + testCase.pOverlayName + ".lua",
                OpenYAMM::Game::ScriptedEventScope::Map,
                error);

        REQUIRE_MESSAGE(localEventProgram.has_value(), error.c_str());
        REQUIRE(localEventProgram->hasEvent(testCase.eventId));

        OpenYAMM::Game::EventRuntime eventRuntime(&OpenYAMM::Tests::regressionGameData().houseTable);
        RecordingSceneEventContext noonContext = {};
        noonContext.setCurrentGameMinutes(12.0f * 60.0f);

        OpenYAMM::Game::Party fallbackParty = makeScriptedRegressionParty();
        OpenYAMM::Game::EventRuntimeState fallbackState = {};
        REQUIRE(eventRuntime.executeEventById(
            localEventProgram,
            std::nullopt,
            testCase.eventId,
            fallbackState,
            &fallbackParty,
            &noonContext));
        CHECK_FALSE(fallbackParty.hasQuestBit(testCase.lorettaQbitId));
        REQUIRE(fallbackState.pendingDialogueContext.has_value());
        CHECK_EQ(fallbackState.pendingDialogueContext->kind, OpenYAMM::Game::DialogueContextKind::HouseService);
        CHECK_EQ(fallbackState.pendingDialogueContext->sourceId, testCase.houseId);

        OpenYAMM::Game::Party activeParty = makeScriptedRegressionParty();
        activeParty.setQuestBit(1140, true);
        OpenYAMM::Game::EventRuntimeState activeState = {};
        REQUIRE(eventRuntime.executeEventById(
            localEventProgram,
            std::nullopt,
            testCase.eventId,
            activeState,
            &activeParty,
            &noonContext));
        CHECK_FALSE(activeParty.hasQuestBit(testCase.lorettaQbitId));
        CHECK_FALSE(activeParty.hasQuestBit(1141));
        REQUIRE(activeState.pendingDialogueContext.has_value());
        CHECK_EQ(activeState.pendingDialogueContext->kind, OpenYAMM::Game::DialogueContextKind::HouseService);
        CHECK_EQ(activeState.pendingDialogueContext->sourceId, testCase.houseId);
    }
}

TEST_CASE("mm6 outc2 overlay ports council and temple local fixes")
{
    const std::filesystem::path sourceRoot = OPENYAMM_SOURCE_DIR;
    const std::optional<std::string> supportLua =
        readSourceTextFile(sourceRoot / "assets_dev/engine/scripts/common/event_support.lua");
    const std::optional<std::string> mm6CommonLua =
        readSourceTextFile(sourceRoot / "assets_dev/worlds/mm6/events/common/mm6_common.lua");
    const std::optional<std::string> baseLua =
        readSourceTextFile(sourceRoot / "assets_dev/worlds/mm6/events/maps/outc2.lua");
    const std::optional<std::string> overlayLua =
        readSourceTextFile(sourceRoot / "assets_dev/worlds/mm6/events/maps/outc2_mmmerge.lua");

    REQUIRE(supportLua.has_value());
    REQUIRE(mm6CommonLua.has_value());
    REQUIRE(baseLua.has_value());
    REQUIRE(overlayLua.has_value());

    std::string error;
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> localEventProgram =
        OpenYAMM::Game::ScriptedEventProgram::loadFromLuaText(
            *supportLua + "\n\n" + *mm6CommonLua + "\n\n" + *baseLua + "\n\n" + *overlayLua,
            "@events/maps/outc2.lua + events/maps/outc2_mmmerge.lua",
            OpenYAMM::Game::ScriptedEventScope::Map,
            error);

    REQUIRE_MESSAGE(localEventProgram.has_value(), error.c_str());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::Party councilParty = makeScriptedRegressionParty();
    councilParty.grantItem(2122);
    OpenYAMM::Game::EventRuntimeState councilState = {};

    REQUIRE(eventRuntime.executeEventById(
        localEventProgram,
        std::nullopt,
        49,
        councilState,
        &councilParty,
        nullptr));
    REQUIRE(councilState.pendingMovie.has_value());
    CHECK_EQ(councilState.pendingMovie->movieName, "citytrtr");
    CHECK_EQ(councilState.npcHouseOverrides[1089], 0u);
    CHECK(councilParty.hasQuestBit(1192));
    CHECK(councilParty.hasAward(63));
    REQUIRE(councilState.pendingDialogueContext.has_value());
    CHECK_EQ(councilState.pendingDialogueContext->sourceId, 209u);

    OpenYAMM::Game::Party templeParty = makeScriptedRegressionParty();
    OpenYAMM::Game::EventRuntimeState templeState = {};
    templeState.hiredNpcFollowers.push_back({20001, 63, 0});
    templeState.hiredNpcFollowers.push_back({20002, 64, 0});

    REQUIRE(eventRuntime.executeEventById(
        localEventProgram,
        std::nullopt,
        19,
        templeState,
        &templeParty,
        nullptr));
    CHECK(templeParty.hasQuestBit(1130));
    CHECK(templeState.hiredNpcFollowers.empty());
    REQUIRE_FALSE(templeState.messages.empty());
    CHECK_EQ(templeState.messages.back(), "The stone cutter and carpenter begin rebuilding the temple.");
}

TEST_CASE("mm6 oute3 overlay ports dimension door and volcano events")
{
    const std::filesystem::path sourceRoot = OPENYAMM_SOURCE_DIR;
    const std::optional<std::string> supportLua =
        readSourceTextFile(sourceRoot / "assets_dev/engine/scripts/common/event_support.lua");
    const std::optional<std::string> mm6CommonLua =
        readSourceTextFile(sourceRoot / "assets_dev/worlds/mm6/events/common/mm6_common.lua");
    const std::optional<std::string> baseLua =
        readSourceTextFile(sourceRoot / "assets_dev/worlds/mm6/events/maps/oute3.lua");
    const std::optional<std::string> overlayLua =
        readSourceTextFile(sourceRoot / "assets_dev/worlds/mm6/events/maps/oute3_mmmerge.lua");

    REQUIRE(supportLua.has_value());
    REQUIRE(mm6CommonLua.has_value());
    REQUIRE(baseLua.has_value());
    REQUIRE(overlayLua.has_value());

    std::string error;
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> localEventProgram =
        OpenYAMM::Game::ScriptedEventProgram::loadFromLuaText(
            *supportLua + "\n\n" + *mm6CommonLua + "\n\n" + *baseLua + "\n\n" + *overlayLua,
            "@events/maps/oute3.lua + events/maps/oute3_mmmerge.lua",
            OpenYAMM::Game::ScriptedEventScope::Map,
            error);

    REQUIRE_MESSAGE(localEventProgram.has_value(), error.c_str());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::Party party = makeScriptedRegressionParty();
    OpenYAMM::Game::EventRuntimeState dimensionState = {};

    REQUIRE(eventRuntime.executeEventById(
        localEventProgram,
        std::nullopt,
        140,
        dimensionState,
        &party,
        nullptr));
    CHECK(dimensionState.pendingDimensionDoorOverlay);

    OpenYAMM::Game::EventRuntimeState blockedDimensionState = {};
    blockedDimensionState.mapVars[50] = 1;
    REQUIRE(eventRuntime.executeEventById(
        localEventProgram,
        std::nullopt,
        140,
        blockedDimensionState,
        &party,
        nullptr));
    CHECK_FALSE(blockedDimensionState.pendingDimensionDoorOverlay);

    OpenYAMM::Game::EventRuntimeState volcanoState = {};
    RecordingSceneEventContext volcanoContext = {};
    REQUIRE(eventRuntime.executeEventById(
        localEventProgram,
        std::nullopt,
        220,
        volcanoState,
        &party,
        &volcanoContext));
    CHECK_EQ(volcanoContext.castSpellCalls.size(), 15u);
    REQUIRE_FALSE(volcanoState.pendingSounds.empty());
    CHECK_EQ(volcanoState.pendingSounds.front().soundId, 18090u);
}

TEST_CASE("mm6 shadow guild scene applies spike trap facet type fixup")
{
    const OpenYAMM::Tests::RegressionMapLoader &mapLoader = requireRegressionMapLoader();
    const OpenYAMM::Game::MapAssetInfo *pLoadedMap = loadCachedIndoorMapWithCompanionOptions(
        mapLoader.assetFileSystem,
        mapLoader.gameDataLoader,
        "6d08.blv",
        OpenYAMM::Game::MapLoadPurpose::HeadlessGameplay,
        OpenYAMM::Game::MapCompanionLoadOptions{
            .allowSceneYml = true,
            .allowLegacyCompanion = true,
        });

    REQUIRE(pLoadedMap != nullptr);
    REQUIRE(pLoadedMap->indoorMapData.has_value());
    REQUIRE_GT(pLoadedMap->indoorMapData->faces.size(), 373u);
    CHECK_EQ(pLoadedMap->indoorMapData->faces[373].facetType, 5);
}

TEST_CASE("mm6 castle alamos password plate keeps pressure trigger metadata")
{
    const OpenYAMM::Tests::RegressionMapLoader &mapLoader = requireRegressionMapLoader();
    const OpenYAMM::Game::MapAssetInfo *pLoadedMap = loadCachedIndoorMapWithCompanionOptions(
        mapLoader.assetFileSystem,
        mapLoader.gameDataLoader,
        "cd1.blv",
        OpenYAMM::Game::MapLoadPurpose::HeadlessGameplay,
        OpenYAMM::Game::MapCompanionLoadOptions{
            .allowSceneYml = true,
            .allowLegacyCompanion = true,
        });

    REQUIRE(pLoadedMap != nullptr);
    REQUIRE(pLoadedMap->indoorMapData.has_value());

    size_t passwordPlateCount = 0;

    for (const OpenYAMM::Game::IndoorFace &face : pLoadedMap->indoorMapData->faces)
    {
        if (face.cogTriggered == 69
            && OpenYAMM::Game::hasFaceAttribute(face.attributes, OpenYAMM::Game::FaceAttribute::PressurePlate))
        {
            ++passwordPlateCount;
        }
    }

    CHECK_GT(passwordPlateCount, 0u);
}

TEST_CASE("mm6 castle alamos wrong password sends party to current-map fallback point")
{
    const std::filesystem::path sourceRoot = OPENYAMM_SOURCE_DIR;
    const std::optional<std::string> supportLua =
        readSourceTextFile(sourceRoot / "assets_dev/engine/scripts/common/event_support.lua");
    const std::optional<std::string> cd1Lua =
        readSourceTextFile(sourceRoot / "assets_dev/worlds/mm6/events/maps/cd1.lua");

    REQUIRE(supportLua.has_value());
    REQUIRE(cd1Lua.has_value());

    std::string error;
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> localEventProgram =
        OpenYAMM::Game::ScriptedEventProgram::loadFromLuaText(
            *supportLua + "\n\n" + *cd1Lua,
            "@events/maps/cd1.lua",
            OpenYAMM::Game::ScriptedEventScope::Map,
            error);
    REQUIRE_MESSAGE(localEventProgram.has_value(), error.c_str());

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(localEventProgram, std::nullopt, 69, runtimeState, nullptr, nullptr));
    REQUIRE(runtimeState.pendingInputPrompt.has_value());
    CHECK_EQ(runtimeState.pendingInputPrompt->eventId, 69);
    CHECK_EQ(runtimeState.pendingInputPrompt->continueStep, 4);

    runtimeState.pendingInputPrompt.reset();
    REQUIRE(eventRuntime.executeNpcTopicEventById(
        localEventProgram,
        std::nullopt,
        69,
        runtimeState,
        nullptr,
        nullptr,
        4));
    REQUIRE(runtimeState.pendingMapMove.has_value());
    CHECK_FALSE(runtimeState.pendingDialogueContext.has_value());
    CHECK_FALSE(runtimeState.pendingMapMove->mapName.has_value());
    CHECK_EQ(runtimeState.pendingMapMove->x, -3136);
    CHECK_EQ(runtimeState.pendingMapMove->y, 2240);
    CHECK_EQ(runtimeState.pendingMapMove->z, 224);
}

TEST_CASE("mm6 new sorpigal dragonsand exit keeps destination map name")
{
    const std::filesystem::path sourceRoot = OPENYAMM_SOURCE_DIR;
    const std::optional<std::string> supportLua =
        readSourceTextFile(sourceRoot / "assets_dev/engine/scripts/common/event_support.lua");
    const std::optional<std::string> oute3Lua =
        readSourceTextFile(sourceRoot / "assets_dev/worlds/mm6/events/maps/oute3.lua");

    REQUIRE(supportLua.has_value());
    REQUIRE(oute3Lua.has_value());

    std::string error;
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> localEventProgram =
        OpenYAMM::Game::ScriptedEventProgram::loadFromLuaText(
            *supportLua + "\n\n" + *oute3Lua,
            "@events/maps/oute3.lua",
            OpenYAMM::Game::ScriptedEventScope::Map,
            error);
    REQUIRE_MESSAGE(localEventProgram.has_value(), error.c_str());

    OpenYAMM::Game::Party party = {};
    party.seed(createRegressionPartySeed());

    OpenYAMM::Game::EventRuntimeState runtimeState = {};
    OpenYAMM::Game::EventRuntime eventRuntime = {};

    REQUIRE(eventRuntime.executeEventById(localEventProgram, std::nullopt, 104, runtimeState, &party, nullptr));
    REQUIRE(runtimeState.pendingMapMove.has_value());
    CHECK_EQ(runtimeState.pendingMapMove->mapName, std::optional<std::string>("outb3.odm"));
    CHECK_EQ(runtimeState.pendingMapMove->x, 12808);
    CHECK_EQ(runtimeState.pendingMapMove->y, 6832);
    CHECK_EQ(runtimeState.pendingMapMove->z, 64);
}

TEST_CASE("d19 blv MoveNPC updates party global npc house overrides")
{
    const OpenYAMM::Tests::RegressionMapLoader &mapLoader = requireRegressionMapLoader();
    const OpenYAMM::Game::MapStatsEntry *pMapEntry =
        mapLoader.gameDataLoader.getMapStats().findByFileName("d19.blv");
    const std::optional<std::string> supportLua =
        mapLoader.assetFileSystem.readTextFile("Data/scripts/common/event_support.lua");
    const std::optional<std::string> d19Lua =
        mapLoader.assetFileSystem.readTextFile("Data/scripts/maps/d19.lua");

    REQUIRE(pMapEntry != nullptr);
    REQUIRE(supportLua.has_value());
    REQUIRE(d19Lua.has_value());

    std::string error;
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> localEventProgram =
        OpenYAMM::Game::ScriptedEventProgram::loadFromLuaText(
            *supportLua + "\n\n" + *d19Lua,
            "@Data/scripts/maps/d19.lua",
            OpenYAMM::Game::ScriptedEventScope::Map,
            error);

    REQUIRE_MESSAGE(localEventProgram.has_value(), error.c_str());

    OpenYAMM::Game::Party party = {};
    party.setItemTable(&mapLoader.gameDataLoader.getItemTable());
    party.setItemEnchantTables(
        &mapLoader.gameDataLoader.getStandardItemEnchantTable(),
        &mapLoader.gameDataLoader.getSpecialItemEnchantTable());
    party.setClassMultiplierTable(&mapLoader.gameDataLoader.getClassMultiplierTable());
    party.setClassSkillTable(&mapLoader.gameDataLoader.getClassSkillTable());
    party.seed(createRegressionPartySeed());
    party.setQuestBit(19, true);

    OpenYAMM::Game::EventRuntimeState runtimeState = {};
    OpenYAMM::Game::EventRuntime eventRuntime = {};

    REQUIRE(eventRuntime.executeEventById(
        localEventProgram,
        std::nullopt,
        6,
        runtimeState,
        &party));

    CHECK_EQ(runtimeState.npcHouseOverrides[9], 0u);
    CHECK_EQ(runtimeState.npcHouseOverrides[56], 751u);
    CHECK_EQ(runtimeState.npcHouseOverrides[63], 213u);

    OpenYAMM::Game::EventRuntimeState seededRuntimeState = {};
    party.applyGlobalNpcStateTo(seededRuntimeState);

    CHECK_EQ(seededRuntimeState.npcHouseOverrides[9], 0u);
    CHECK_EQ(seededRuntimeState.npcHouseOverrides[56], 751u);
    CHECK_EQ(seededRuntimeState.npcHouseOverrides[63], 213u);
}

TEST_CASE("d16 on-leave events move allied dragon hunters before map exit")
{
    const OpenYAMM::Tests::RegressionMapLoader &mapLoader = requireRegressionMapLoader();
    const std::optional<std::string> supportLua =
        mapLoader.assetFileSystem.readTextFile("Data/scripts/common/event_support.lua");
    const std::optional<std::string> d16Lua =
        mapLoader.assetFileSystem.readTextFile("Data/scripts/maps/d16.lua");

    REQUIRE(supportLua.has_value());
    REQUIRE(d16Lua.has_value());

    std::string error;
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> localEventProgram =
        OpenYAMM::Game::ScriptedEventProgram::loadFromLuaText(
            *supportLua + "\n\n" + *d16Lua,
            "@Data/scripts/maps/d16.lua",
            OpenYAMM::Game::ScriptedEventScope::Map,
            error);

    REQUIRE_MESSAGE(localEventProgram.has_value(), error.c_str());
    REQUIRE_EQ(localEventProgram->onLeaveEventIds().size(), 5u);
    CHECK_EQ(localEventProgram->onLeaveEventIds()[0], 6u);
    CHECK_EQ(localEventProgram->onLeaveEventIds()[4], 10u);

    OpenYAMM::Game::Party party = {};
    party.setItemTable(&mapLoader.gameDataLoader.getItemTable());
    party.setItemEnchantTables(
        &mapLoader.gameDataLoader.getStandardItemEnchantTable(),
        &mapLoader.gameDataLoader.getSpecialItemEnchantTable());
    party.setClassMultiplierTable(&mapLoader.gameDataLoader.getClassMultiplierTable());
    party.setClassSkillTable(&mapLoader.gameDataLoader.getClassSkillTable());
    party.seed(createRegressionPartySeed());
    party.setQuestBit(21, true);

    OpenYAMM::Game::EventRuntimeState runtimeState = {};
    OpenYAMM::Game::EventRuntime eventRuntime = {};

    REQUIRE(eventRuntime.executeOnLeaveEvents(localEventProgram, std::nullopt, runtimeState, &party));

    CHECK_EQ(runtimeState.npcHouseOverrides[19], 0u);
    CHECK_EQ(runtimeState.npcHouseOverrides[52], 751u);
    CHECK_EQ(runtimeState.npcHouseOverrides[51], 753u);

    OpenYAMM::Game::EventRuntimeState seededRuntimeState = {};
    party.applyGlobalNpcStateTo(seededRuntimeState);

    CHECK_EQ(seededRuntimeState.npcHouseOverrides[19], 0u);
    CHECK_EQ(seededRuntimeState.npcHouseOverrides[52], 751u);
    CHECK_EQ(seededRuntimeState.npcHouseOverrides[51], 753u);
}

TEST_CASE("out05 authored special actors preserve relation override and carried item")
{
    const OpenYAMM::Tests::RegressionMapLoader &mapLoader = requireRegressionMapLoader();
    OpenYAMM::Game::MapAssetInfo loadedMap = {};

    REQUIRE(loadOutdoorMapWithCompanionOptions(
        mapLoader.assetFileSystem,
        mapLoader.gameDataLoader,
        "out05.odm",
        OpenYAMM::Game::MapLoadPurpose::HeadlessGameplay,
        OpenYAMM::Game::MapCompanionLoadOptions{
            .allowSceneYml = true,
            .allowLegacyCompanion = true,
        },
        loadedMap));
    REQUIRE(loadedMap.outdoorMapDeltaData.has_value());
    REQUIRE_GT(loadedMap.outdoorMapDeltaData->actors.size(), 3u);

    CHECK_EQ(loadedMap.outdoorMapDeltaData->actors[0].monsterInfoId, 72);
    CHECK_EQ(loadedMap.outdoorMapDeltaData->actors[0].uniqueNameIndex, 3);
    CHECK_EQ(loadedMap.outdoorMapDeltaData->actors[0].ally, 15u);
    CHECK_EQ(loadedMap.outdoorMapDeltaData->actors[1].ally, 15u);
    CHECK_EQ(loadedMap.outdoorMapDeltaData->actors[2].ally, 15u);
    CHECK_EQ(loadedMap.outdoorMapDeltaData->actors[3].monsterInfoId, 45);
    CHECK_EQ(loadedMap.outdoorMapDeltaData->actors[3].uniqueNameIndex, 2);
    CHECK_EQ(loadedMap.outdoorMapDeltaData->actors[3].carriedItemId, 540u);

    OpenYAMM::Game::GameplayActorService actorService = {};
    actorService.bindTables(&mapLoader.gameDataLoader.getMonsterTable(), &mapLoader.gameDataLoader.getSpellTable());

    OpenYAMM::Game::GameplayActorTargetPolicyState dragonslayer = {};
    dragonslayer.monsterId = 45;
    dragonslayer.relationMonsterId = actorService.relationMonsterId(dragonslayer.monsterId, 15);
    dragonslayer.height = 160;

    OpenYAMM::Game::GameplayActorTargetPolicyState pet = {};
    pet.monsterId = 72;
    pet.relationMonsterId = actorService.relationMonsterId(pet.monsterId, 15);
    pet.height = 500;

    CHECK_GT(mapLoader.gameDataLoader.getMonsterTable().getRelationBetweenMonsters(45, 72), 0);
    CHECK_FALSE(actorService.resolveActorTargetPolicy(dragonslayer, pet).canTarget);

    OpenYAMM::Game::GameplayActorTargetPolicyState naturalDragonslayer = dragonslayer;
    naturalDragonslayer.relationMonsterId =
        actorService.relationMonsterId(naturalDragonslayer.monsterId, 0);

    OpenYAMM::Game::GameplayActorTargetPolicyState naturalDragon = pet;
    naturalDragon.relationMonsterId = actorService.relationMonsterId(naturalDragon.monsterId, 0);

    CHECK(actorService.resolveActorTargetPolicy(naturalDragonslayer, naturalDragon).canTarget);
    CHECK_FALSE(actorService.resolveActorTargetPolicy(naturalDragon, naturalDragonslayer).canTarget);

    naturalDragonslayer.group = 24;
    naturalDragon.group = 24;
    CHECK_FALSE(actorService.resolveActorTargetPolicy(naturalDragonslayer, naturalDragon).canTarget);
}

TEST_CASE("mm7 world prefixed monster sprites resolve on Emerald Island")
{
    const OpenYAMM::Tests::RegressionMapLoader &mapLoader = requireRegressionMapLoader();
    const OpenYAMM::Game::MapAssetInfo *pLoadedMap = loadCachedOutdoorMapWithCompanionOptions(
        mapLoader.assetFileSystem,
        mapLoader.gameDataLoader,
        "7out01.odm",
        OpenYAMM::Game::MapLoadPurpose::ActorPreviews,
        OpenYAMM::Game::MapCompanionLoadOptions{
            .allowSceneYml = true,
            .allowLegacyCompanion = true,
        });
    REQUIRE(pLoadedMap != nullptr);
    REQUIRE(pLoadedMap->outdoorActorPreviewBillboardSet.has_value());

    const OpenYAMM::Game::ActorPreviewBillboardSet &billboardSet =
        *pLoadedMap->outdoorActorPreviewBillboardSet;
    CHECK(billboardSet.spriteFrameTable.findFrameIndexBySpriteName("7m409s").has_value());

    const auto standingTextureIt = std::find_if(
        billboardSet.textures.begin(),
        billboardSet.textures.end(),
        [](const OpenYAMM::Game::OutdoorBitmapTexture &texture)
        {
            return texture.textureName == "m406sa0" && texture.paletteId == 409;
        });
    REQUIRE(standingTextureIt != billboardSet.textures.end());
    REQUIRE_GE(standingTextureIt->physicalWidth, 133);
    REQUIRE_GE(standingTextureIt->physicalHeight, 94);

    const size_t torsoPixelOffset =
        (static_cast<size_t>(78) * static_cast<size_t>(standingTextureIt->physicalWidth) + 127u) * 4u;
    REQUIRE_LT(torsoPixelOffset + 3u, standingTextureIt->pixels.size());
    CHECK_EQ(standingTextureIt->pixels[torsoPixelOffset + 0u], 68u);
    CHECK_EQ(standingTextureIt->pixels[torsoPixelOffset + 1u], 73u);
    CHECK_EQ(standingTextureIt->pixels[torsoPixelOffset + 2u], 82u);
    CHECK_EQ(standingTextureIt->pixels[torsoPixelOffset + 3u], 255u);

    bool foundAdventurer = false;

    for (const OpenYAMM::Game::ActorPreviewBillboard &billboard : billboardSet.billboards)
    {
        if (billboard.monsterId != 405)
        {
            continue;
        }

        foundAdventurer = true;
        CHECK_NE(billboard.spriteFrameIndex, 0u);
        CHECK_NE(
            billboard.actionSpriteFrameIndices[
                static_cast<size_t>(OpenYAMM::Game::OutdoorWorldRuntime::ActorAnimation::Standing)],
            0u);
    }

    CHECK(foundAdventurer);
}

TEST_CASE("mm7 world prefixed monster sprites load for indoor actor previews")
{
    const OpenYAMM::Tests::RegressionMapLoader &mapLoader = requireRegressionMapLoader();
    const OpenYAMM::Game::MapAssetInfo *pLoadedMap = loadCachedIndoorMapWithCompanionOptions(
        mapLoader.assetFileSystem,
        mapLoader.gameDataLoader,
        "7d06.blv",
        OpenYAMM::Game::MapLoadPurpose::ActorPreviews,
        OpenYAMM::Game::MapCompanionLoadOptions{
            .allowSceneYml = true,
            .allowLegacyCompanion = true,
        });
    REQUIRE(pLoadedMap != nullptr);
    REQUIRE(pLoadedMap->indoorActorPreviewBillboardSet.has_value());

    const OpenYAMM::Game::ActorPreviewBillboardSet &billboardSet =
        *pLoadedMap->indoorActorPreviewBillboardSet;
    const std::optional<uint16_t> swordsmanFrameIndex =
        billboardSet.spriteFrameTable.findFrameIndexBySpriteName("7m407s");
    REQUIRE(swordsmanFrameIndex.has_value());
    const OpenYAMM::Game::SpriteFrameEntry *pSwordsmanFrame =
        billboardSet.spriteFrameTable.getFrame(*swordsmanFrameIndex, 0);
    REQUIRE(pSwordsmanFrame != nullptr);
    const OpenYAMM::Game::ResolvedSpriteTexture swordsmanTexture =
        OpenYAMM::Game::SpriteFrameTable::resolveTexture(*pSwordsmanFrame, 0);
    CHECK_EQ(swordsmanTexture.textureName, "m406sa0");
    CHECK_EQ(pSwordsmanFrame->paletteId, 70);
    REQUIRE_GT(billboardSet.mapDeltaActorCount, 0u);
    CHECK_EQ(billboardSet.missingTextureActorCount, 0u);
    CHECK_EQ(billboardSet.texturedActorCount, billboardSet.billboards.size());
    CHECK_FALSE(billboardSet.textures.empty());
}

TEST_CASE("mm7 dragon lair loads indoor billboards and lights")
{
    const OpenYAMM::Tests::RegressionMapLoader &mapLoader = requireRegressionMapLoader();
    const OpenYAMM::Game::MapAssetInfo *pLoadedMap = loadCachedIndoorMapWithCompanionOptions(
        mapLoader.assetFileSystem,
        mapLoader.gameDataLoader,
        "7d28.blv",
        OpenYAMM::Game::MapLoadPurpose::BillboardPreviews,
        OpenYAMM::Game::MapCompanionLoadOptions{
            .allowSceneYml = true,
            .allowLegacyCompanion = true,
        });
    REQUIRE(pLoadedMap != nullptr);
    REQUIRE(pLoadedMap->indoorMapData.has_value());
    CHECK_FALSE(pLoadedMap->indoorMapData->lights.empty());
    REQUIRE(pLoadedMap->indoorDecorationBillboardSet.has_value());
    CHECK_FALSE(pLoadedMap->indoorDecorationBillboardSet->billboards.empty());
    CHECK_FALSE(pLoadedMap->indoorDecorationBillboardSet->textures.empty());
    CHECK(std::any_of(
        pLoadedMap->indoorDecorationBillboardSet->billboards.begin(),
        pLoadedMap->indoorDecorationBillboardSet->billboards.end(),
        [](const OpenYAMM::Game::DecorationBillboard &billboard)
        {
            return billboard.sectorId >= 0;
        }));
    REQUIRE(pLoadedMap->indoorActorPreviewBillboardSet.has_value());
    CHECK_GT(pLoadedMap->indoorActorPreviewBillboardSet->billboards.size(), 0u);
    CHECK_EQ(pLoadedMap->indoorActorPreviewBillboardSet->missingTextureActorCount, 0u);
    CHECK_EQ(
        pLoadedMap->indoorActorPreviewBillboardSet->texturedActorCount,
        pLoadedMap->indoorActorPreviewBillboardSet->billboards.size());
}

TEST_CASE("outdoor water bmodel faces load terrain-owned animation frames")
{
    const OpenYAMM::Tests::RegressionMapLoader &mapLoader = requireRegressionMapLoader();

    struct WaterMapCase
    {
        const char *pMapFileName = nullptr;
        const char *pBaseTextureName = nullptr;
        const char *pFirstFrameTextureName = nullptr;
        const char *pLastFrameTextureName = nullptr;
    };

    const std::array<WaterMapCase, 3> waterMapCases = {{
        {"out01.odm", "wtrtyl", "hdwtr000", "hdwtr013"},
        {"7out01.odm", "7wtrtyl", "7hdwtr000", "7hdwtr013"},
        {"oute3.odm", "6wtrtyl", "6hdwtr000", "6hdwtr013"},
    }};

    for (const WaterMapCase &waterMapCase : waterMapCases)
    {
        const OpenYAMM::Game::MapAssetInfo *pLoadedMap = loadCachedOutdoorMapWithCompanionOptions(
            mapLoader.assetFileSystem,
            mapLoader.gameDataLoader,
            waterMapCase.pMapFileName,
            OpenYAMM::Game::MapLoadPurpose::RenderSurfaces,
            OpenYAMM::Game::MapCompanionLoadOptions{
                .allowSceneYml = true,
                .allowLegacyCompanion = true,
            });
        REQUIRE(pLoadedMap != nullptr);
        REQUIRE(pLoadedMap->outdoorBModelTextureSet.has_value());

        const OpenYAMM::Game::OutdoorBModelTextureSet &textureSet = *pLoadedMap->outdoorBModelTextureSet;
        CHECK(bitmapTextureSetContains(textureSet.textures, waterMapCase.pBaseTextureName));
        CHECK(bitmapTextureSetContains(textureSet.textures, waterMapCase.pFirstFrameTextureName));
        CHECK(bitmapTextureSetContains(textureSet.textures, waterMapCase.pLastFrameTextureName));

        const OpenYAMM::Game::SurfaceAnimationSequence *pAnimation =
            findSurfaceAnimationBinding(textureSet.animationBindings, waterMapCase.pBaseTextureName);
        REQUIRE(pAnimation != nullptr);
        CHECK(pAnimation->frames.size() == 14);
        CHECK(pAnimation->animationLengthTicks == 210);
        CHECK(pAnimation->frames.front().textureName == waterMapCase.pFirstFrameTextureName);
        CHECK(pAnimation->frames.back().textureName == waterMapCase.pLastFrameTextureName);
    }
}

TEST_CASE("outdoor terrain water transition tiles do not use full-tile shader warp")
{
    const OpenYAMM::Tests::RegressionMapLoader &mapLoader = requireRegressionMapLoader();

    struct WaterTransitionMapCase
    {
        const char *pMapFileName = nullptr;
        uint8_t fullWaterTileId = 0;
        uint8_t transitionWaterTileId = 0;
    };

    const std::array<WaterTransitionMapCase, 3> waterMapCases = {{
        {"out01.odm", 126, 138},
        {"7out01.odm", 126, 138},
        {"oute3.odm", 126, 138},
    }};

    for (const WaterTransitionMapCase &waterMapCase : waterMapCases)
    {
        const OpenYAMM::Game::MapAssetInfo *pLoadedMap = loadCachedOutdoorMapWithCompanionOptions(
            mapLoader.assetFileSystem,
            mapLoader.gameDataLoader,
            waterMapCase.pMapFileName,
            OpenYAMM::Game::MapLoadPurpose::RenderSurfaces,
            OpenYAMM::Game::MapCompanionLoadOptions{
                .allowSceneYml = true,
                .allowLegacyCompanion = true,
            });
        REQUIRE(pLoadedMap != nullptr);
        REQUIRE(pLoadedMap->outdoorTerrainTextureAtlas.has_value());

        const OpenYAMM::Game::OutdoorTerrainTextureAtlas &atlas = *pLoadedMap->outdoorTerrainTextureAtlas;
        const OpenYAMM::Game::OutdoorTerrainAtlasRegion &fullWaterRegion =
            atlas.tileRegions[static_cast<size_t>(waterMapCase.fullWaterTileId)];
        const OpenYAMM::Game::OutdoorTerrainAtlasRegion &cachedFullWaterRegion =
            atlas.tileRegions[static_cast<size_t>(waterMapCase.fullWaterTileId + 1)];
        const OpenYAMM::Game::OutdoorTerrainAtlasRegion &transitionWaterRegion =
            atlas.tileRegions[static_cast<size_t>(waterMapCase.transitionWaterTileId)];

        REQUIRE(fullWaterRegion.isValid);
        CHECK(fullWaterRegion.isWater);
        CHECK_FALSE(fullWaterRegion.isTransitionOverlay);

        REQUIRE(cachedFullWaterRegion.isValid);
        CHECK(cachedFullWaterRegion.isWater);
        CHECK_FALSE(cachedFullWaterRegion.isTransitionOverlay);

        REQUIRE(transitionWaterRegion.isValid);
        CHECK(transitionWaterRegion.isWater);
        CHECK(transitionWaterRegion.isTransitionOverlay);

        const auto findAnimatedTileSource =
            [&](const OpenYAMM::Game::OutdoorTerrainAtlasRegion &region)
            -> const OpenYAMM::Game::OutdoorAnimatedWaterTileSource *
            {
                for (const OpenYAMM::Game::OutdoorAnimatedWaterTileSource &source : atlas.animatedWaterTiles)
                {
                    if (source.region.u0 == region.u0
                        && source.region.v0 == region.v0
                        && source.region.u1 == region.u1
                        && source.region.v1 == region.v1)
                    {
                        return &source;
                    }
                }

                return nullptr;
            };

        const OpenYAMM::Game::OutdoorAnimatedWaterTileSource *pFullWaterSource =
            findAnimatedTileSource(fullWaterRegion);
        const OpenYAMM::Game::OutdoorAnimatedWaterTileSource *pCachedFullWaterSource =
            findAnimatedTileSource(cachedFullWaterRegion);

        REQUIRE(pFullWaterSource != nullptr);
        REQUIRE(pCachedFullWaterSource != nullptr);
        CHECK(pFullWaterSource->framePixels.size() == 14);
        CHECK(pFullWaterSource->animation.frames.size() == 14);
        CHECK(pFullWaterSource->animation.animationLengthTicks == 210);
        CHECK(pCachedFullWaterSource->framePixels.size() == 14);
        CHECK(pCachedFullWaterSource->animation.frames.size() == 14);
        CHECK(pCachedFullWaterSource->animation.animationLengthTicks == 210);
    }
}

TEST_CASE("d06 indoor actor loader preserves Blackwell Cooper guaranteed key drop")
{
    const OpenYAMM::Tests::RegressionMapLoader &mapLoader = requireRegressionMapLoader();
    OpenYAMM::Game::MapAssetInfo loadedMap = {};

    REQUIRE(loadIndoorMapWithCompanionOptions(
        mapLoader.assetFileSystem,
        mapLoader.gameDataLoader,
        "d06.blv",
        OpenYAMM::Game::MapLoadPurpose::HeadlessGameplay,
        OpenYAMM::Game::MapCompanionLoadOptions{
            .allowSceneYml = false,
            .allowLegacyCompanion = true,
        },
        loadedMap));
    REQUIRE(loadedMap.indoorMapDeltaData.has_value());
    REQUIRE_GT(loadedMap.indoorMapDeltaData->actors.size(), 0u);

    const OpenYAMM::Game::MapDeltaActor &blackwell = loadedMap.indoorMapDeltaData->actors[0];
    CHECK_EQ(blackwell.uniqueNameIndex, 1);
    CHECK_EQ(blackwell.sectorId, 11);
    CHECK_EQ(blackwell.carriedItemId, 619u);

    OpenYAMM::Game::MapAssetInfo sceneLoadedMap = {};
    REQUIRE(loadIndoorMapWithCompanionOptions(
        mapLoader.assetFileSystem,
        mapLoader.gameDataLoader,
        "d06.blv",
        OpenYAMM::Game::MapLoadPurpose::HeadlessGameplay,
        OpenYAMM::Game::MapCompanionLoadOptions{
            .allowSceneYml = true,
            .allowLegacyCompanion = true,
        },
        sceneLoadedMap));
    REQUIRE(sceneLoadedMap.indoorMapDeltaData.has_value());
    REQUIRE_GT(sceneLoadedMap.indoorMapDeltaData->actors.size(), 0u);
    CHECK_EQ(sceneLoadedMap.indoorMapDeltaData->actors[0].carriedItemId, 619u);
}

TEST_CASE("d06 submarine event plays cutscene and moves to small sub pen")
{
    const OpenYAMM::Tests::RegressionMapLoader &mapLoader = requireRegressionMapLoader();
    const std::optional<std::string> supportLua =
        mapLoader.assetFileSystem.readTextFile("Data/scripts/common/event_support.lua");
    const std::optional<std::string> d06Lua =
        mapLoader.assetFileSystem.readTextFile("Data/scripts/maps/d06.lua");

    REQUIRE(supportLua.has_value());
    REQUIRE(d06Lua.has_value());

    std::string error;
    const std::optional<OpenYAMM::Game::ScriptedEventProgram> localEventProgram =
        OpenYAMM::Game::ScriptedEventProgram::loadFromLuaText(
            *supportLua + "\n\n" + *d06Lua,
            "@Data/scripts/maps/d06.lua",
            OpenYAMM::Game::ScriptedEventScope::Map,
            error);
    REQUIRE_MESSAGE(localEventProgram.has_value(), error.c_str());

    OpenYAMM::Game::Party party = {};
    party.setItemTable(&mapLoader.gameDataLoader.getItemTable());
    party.setItemEnchantTables(
        &mapLoader.gameDataLoader.getStandardItemEnchantTable(),
        &mapLoader.gameDataLoader.getSpecialItemEnchantTable());
    party.setClassMultiplierTable(&mapLoader.gameDataLoader.getClassMultiplierTable());
    party.setClassSkillTable(&mapLoader.gameDataLoader.getClassSkillTable());
    party.seed(createRegressionPartySeed());

    OpenYAMM::Game::InventoryItem pirateLeaderKey = {};
    pirateLeaderKey.objectDescriptionId = 619;
    REQUIRE(party.tryGrantInventoryItem(pirateLeaderKey));

    OpenYAMM::Game::EventRuntime eventRuntime = {};
    OpenYAMM::Game::EventRuntimeState runtimeState = {};

    REQUIRE(eventRuntime.executeEventById(localEventProgram, std::nullopt, 451, runtimeState, &party, nullptr));
    REQUIRE(runtimeState.pendingMovie.has_value());
    CHECK_EQ(runtimeState.pendingMovie->movieName, "\"Subcut\"");
    CHECK(runtimeState.pendingMovie->restoreAfterPlayback);
    REQUIRE(runtimeState.pendingMapMove.has_value());
    CHECK_EQ(runtimeState.pendingMapMove->mapName, std::optional<std::string>("d34.blv"));
    CHECK_EQ(runtimeState.pendingMapMove->x, -2416);
    CHECK_EQ(runtimeState.pendingMapMove->y, 1850);
    CHECK_EQ(runtimeState.pendingMapMove->z, -687);
}

TEST_CASE("corpse loot includes authored guaranteed carried item")
{
    const OpenYAMM::Tests::RegressionMapLoader &mapLoader = requireRegressionMapLoader();
    OpenYAMM::Game::MonsterTable::LootPrototype noRandomLoot = {};

    const OpenYAMM::Game::GameplayCorpseViewState corpse = OpenYAMM::Game::buildMonsterCorpseView(
        "Jeric Whistlebone",
        noRandomLoot,
        &mapLoader.gameDataLoader.getItemTable(),
        nullptr,
        540);

    REQUIRE_EQ(corpse.items.size(), 1u);
    CHECK_EQ(corpse.items.front().itemId, 540u);
    CHECK_EQ(corpse.items.front().item.objectDescriptionId, 540u);
}

TEST_CASE("outdoor_party_runtime_wait_advances_buff_durations_with_game_clock")
{
    const OpenYAMM::Tests::RegressionMapLoader &mapLoader = requireRegressionMapLoader();
    OpenYAMM::Game::MapAssetInfo loadedMap = {};

    REQUIRE(loadOutdoorMapWithCompanionOptions(
        mapLoader.assetFileSystem,
        mapLoader.gameDataLoader,
        "out01.odm",
        OpenYAMM::Game::MapLoadPurpose::HeadlessGameplay,
        OpenYAMM::Game::MapCompanionLoadOptions{
            .allowSceneYml = true,
            .allowLegacyCompanion = true,
        },
        loadedMap));
    REQUIRE(loadedMap.outdoorMapData.has_value());

    OpenYAMM::Game::OutdoorMovementDriver movementDriver(
        *loadedMap.outdoorMapData,
        loadedMap.outdoorLandMask,
        loadedMap.outdoorDecorationCollisionSet,
        loadedMap.outdoorActorCollisionSet,
        loadedMap.outdoorSpriteObjectCollisionSet);
    OpenYAMM::Game::OutdoorPartyRuntime partyRuntime(
        std::move(movementDriver),
        mapLoader.gameDataLoader.getItemTable());
    OpenYAMM::Game::Party party = {};
    party.setItemTable(&mapLoader.gameDataLoader.getItemTable());
    party.setItemEnchantTables(
        &mapLoader.gameDataLoader.getStandardItemEnchantTable(),
        &mapLoader.gameDataLoader.getSpecialItemEnchantTable());
    party.setClassMultiplierTable(&mapLoader.gameDataLoader.getClassMultiplierTable());
    party.setClassSkillTable(&mapLoader.gameDataLoader.getClassSkillTable());
    party.seed(createRegressionPartySeed());
    party.applyPartyBuff(
        OpenYAMM::Game::PartyBuffId::FireResistance,
        36000.0f,
        1,
        0,
        0,
        OpenYAMM::Game::SkillMastery::None,
        0);
    partyRuntime.setParty(party);
    partyRuntime.initialize(8704.0f, 2000.0f, 686.0f, false);

    const OpenYAMM::Game::PartyBuffState *pInitialBuff =
        partyRuntime.party().partyBuff(OpenYAMM::Game::PartyBuffId::FireResistance);
    REQUIRE(pInitialBuff != nullptr);
    CHECK(pInitialBuff->remainingSeconds == doctest::Approx(36000.0f));

    OpenYAMM::Game::OutdoorMovementInput idleInput = {};
    partyRuntime.update(idleInput, 2.0f);

    const OpenYAMM::Game::PartyBuffState *pUpdatedBuff =
        partyRuntime.party().partyBuff(OpenYAMM::Game::PartyBuffId::FireResistance);
    REQUIRE(pUpdatedBuff != nullptr);
    CHECK(pUpdatedBuff->remainingSeconds == doctest::Approx(35940.0f));
}
