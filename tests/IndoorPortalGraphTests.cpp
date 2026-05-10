#include "doctest/doctest.h"

#include "game/FaceEnums.h"
#include "game/indoor/IndoorMapData.h"
#include "game/indoor/IndoorPortalGraph.h"
#include "game/maps/MapDeltaData.h"

#include <yaml-cpp/yaml.h>

#include <algorithm>
#include <array>
#include <fstream>
#include <filesystem>
#include <optional>
#include <set>
#include <string>
#include <unordered_map>
#include <vector>

using namespace OpenYAMM::Game;

namespace
{
struct SnapshotPortal
{
    uint16_t faceId = 0;
    uint16_t room = 0;
    uint16_t behindRoom = 0;
    uint16_t connectedRoom = 0;
    std::vector<uint32_t> directBlockingDoorIds;
};

struct IndoorRoomSnapshot
{
    std::string mapName;
    uint16_t roomId = 0;
    std::vector<uint16_t> connectedRooms;
    std::vector<uint16_t> rawPortalFaceIds;
    std::vector<uint16_t> rawFaceIds;
    std::vector<SnapshotPortal> portals;
    std::vector<uint16_t> decorationIds;
    std::vector<uint16_t> lightIds;
    std::vector<uint16_t> actorIds;
    std::vector<uint16_t> spriteObjectIds;
};

struct LoadedIndoorMap
{
    IndoorMapData mapData;
    MapDeltaData mapDeltaData;
};

uint16_t addVertex(IndoorMapData &mapData, int x, int y, int z)
{
    mapData.vertices.push_back({x, y, z});
    return static_cast<uint16_t>(mapData.vertices.size() - 1);
}

uint16_t addPortalFace(IndoorMapData &mapData, uint16_t sectorId, uint16_t behindSectorId)
{
    IndoorFace face = {};
    face.attributes = faceAttributeBit(FaceAttribute::IsPortal);
    face.roomNumber = sectorId;
    face.roomBehindNumber = behindSectorId;
    face.facetType = 1;
    face.isPortal = true;
    face.vertexIndices = {
        addVertex(mapData, 0, 0, 0),
        addVertex(mapData, 0, 0, 64),
        addVertex(mapData, 0, 64, 64),
    };

    mapData.faces.push_back(std::move(face));
    return static_cast<uint16_t>(mapData.faces.size() - 1);
}

template <typename T>
std::set<T> asSet(const std::vector<T> &values)
{
    return std::set<T>(values.begin(), values.end());
}

template <typename T>
std::vector<T> parseUIntVector(const YAML::Node &node)
{
    std::vector<T> values;

    if (!node || !node.IsSequence())
    {
        return values;
    }

    for (const YAML::Node &entry : node)
    {
        values.push_back(entry.as<T>());
    }

    return values;
}

std::vector<IndoorRoomSnapshot> loadSnapshots(const std::filesystem::path &path)
{
    std::vector<IndoorRoomSnapshot> snapshots;
    const std::vector<YAML::Node> documents = YAML::LoadAllFromFile(path.string());

    for (const YAML::Node &document : documents)
    {
        if (!document || !document.IsMap())
        {
            continue;
        }

        IndoorRoomSnapshot snapshot = {};
        snapshot.mapName = document["map"].as<std::string>();
        snapshot.roomId = document["room_id"].as<uint16_t>();
        snapshot.connectedRooms = parseUIntVector<uint16_t>(document["connected_rooms"]);
        snapshot.rawPortalFaceIds = parseUIntVector<uint16_t>(document["raw_portal_face_ids"]);
        snapshot.rawFaceIds = parseUIntVector<uint16_t>(document["raw_face_ids"]);

        const YAML::Node portalsNode = document["portals"];

        if (portalsNode && portalsNode.IsSequence())
        {
            for (const YAML::Node &portalNode : portalsNode)
            {
                SnapshotPortal portal = {};
                portal.faceId = portalNode["face_id"].as<uint16_t>();
                portal.room = portalNode["room"].as<uint16_t>();
                portal.behindRoom = portalNode["behind_room"].as<uint16_t>();
                portal.connectedRoom = portalNode["connected_room"].as<uint16_t>();
                portal.directBlockingDoorIds =
                    parseUIntVector<uint32_t>(portalNode["direct_blocking_door_ids"]);
                snapshot.portals.push_back(std::move(portal));
            }
        }

        const YAML::Node objectsNode = document["objects"];

        if (objectsNode)
        {
            snapshot.decorationIds = parseUIntVector<uint16_t>(objectsNode["decorations"]["ids"]);
            snapshot.lightIds = parseUIntVector<uint16_t>(objectsNode["lights"]["ids"]);
            snapshot.actorIds = parseUIntVector<uint16_t>(objectsNode["actors"]["ids"]);
            snapshot.spriteObjectIds = parseUIntVector<uint16_t>(objectsNode["sprite_objects"]["ids"]);
        }

        snapshots.push_back(std::move(snapshot));
    }

    return snapshots;
}

std::vector<uint8_t> readBinaryFile(const std::filesystem::path &path)
{
    std::ifstream input(path, std::ios::binary);

    if (!input)
    {
        return {};
    }

    input.seekg(0, std::ios::end);
    const std::streamoff size = input.tellg();

    if (size <= 0)
    {
        return {};
    }

    std::vector<uint8_t> bytes(static_cast<size_t>(size));
    input.seekg(0, std::ios::beg);
    input.read(reinterpret_cast<char *>(bytes.data()), size);
    return input ? bytes : std::vector<uint8_t>{};
}

const LoadedIndoorMap *loadCachedIndoorMap(const std::string &mapFileName)
{
    static std::unordered_map<std::string, LoadedIndoorMap> cachedMaps;
    const std::unordered_map<std::string, LoadedIndoorMap>::const_iterator cachedIt = cachedMaps.find(mapFileName);

    if (cachedIt != cachedMaps.end())
    {
        return &cachedIt->second;
    }

    const std::filesystem::path sourceRoot = OPENYAMM_SOURCE_DIR;
    const std::filesystem::path mapPath = sourceRoot / "assets_dev" / "worlds" / "mm6" / "maps" / mapFileName;
    const std::filesystem::path deltaPath =
        sourceRoot
        / "assets_dev"
        / "worlds"
        / "mm6"
        / "_legacy"
        / "map_delta"
        / std::filesystem::path(mapFileName).replace_extension(".dlv");
    const std::vector<uint8_t> mapBytes = readBinaryFile(mapPath);
    const std::vector<uint8_t> deltaBytes = readBinaryFile(deltaPath);

    if (mapBytes.empty() || deltaBytes.empty())
    {
        return nullptr;
    }

    const IndoorMapDataLoader mapDataLoader = {};
    std::optional<IndoorMapData> mapData = mapDataLoader.loadFromBytes(mapBytes);

    if (!mapData)
    {
        return nullptr;
    }

    const MapDeltaDataLoader mapDeltaDataLoader = {};
    std::optional<MapDeltaData> mapDeltaData = mapDeltaDataLoader.loadIndoorFromBytes(deltaBytes, *mapData);

    if (!mapDeltaData)
    {
        return nullptr;
    }

    LoadedIndoorMap loadedMap = {};
    loadedMap.mapData = std::move(*mapData);
    loadedMap.mapDeltaData = std::move(*mapDeltaData);

    const auto inserted = cachedMaps.emplace(mapFileName, std::move(loadedMap));
    return &inserted.first->second;
}

std::vector<uint16_t> portalFacesForSector(const IndoorPortalGraph &graph, uint16_t sectorId)
{
    std::vector<uint16_t> faceIds;

    if (sectorId >= graph.sectors.size())
    {
        return faceIds;
    }

    for (uint16_t linkId : graph.sectors[sectorId].portalLinkIds)
    {
        REQUIRE_LT(linkId, graph.portals.size());
        faceIds.push_back(graph.portals[linkId].faceId);
    }

    return faceIds;
}

uint16_t oppositeSector(const IndoorPortalLink &link, uint16_t sectorId)
{
    if (link.sectorA == sectorId)
    {
        return link.sectorB;
    }

    if (link.sectorB == sectorId)
    {
        return link.sectorA;
    }

    return UINT16_MAX;
}
}

TEST_CASE("indoor portal graph ignores arbitrary non-portal face adjacency")
{
    IndoorMapData mapData = {};
    mapData.sectors.resize(2);

    IndoorFace face = {};
    face.roomNumber = 0;
    face.roomBehindNumber = 1;
    face.vertexIndices = {
        addVertex(mapData, 0, 0, 0),
        addVertex(mapData, 0, 0, 64),
        addVertex(mapData, 0, 64, 64),
    };
    mapData.faces.push_back(std::move(face));
    mapData.sectors[0].faceIds.push_back(0);

    const IndoorPortalGraph graph = buildIndoorPortalGraph(mapData);

    REQUIRE_EQ(graph.sectors.size(), 2);
    CHECK(graph.portals.empty());
    CHECK(graph.sectors[0].connectedSectorIds.empty());
    CHECK(graph.sectors[1].connectedSectorIds.empty());
}

TEST_CASE("indoor portal graph canonicalizes one portal into both connected sectors")
{
    IndoorMapData mapData = {};
    mapData.sectors.resize(2);
    const uint16_t faceId = addPortalFace(mapData, 0, 1);
    mapData.sectors[0].portalFaceIds.push_back(faceId);

    MapDeltaData mapDeltaData = {};
    MapDeltaDoor door = {};
    door.doorId = 42;
    door.faceIds.push_back(faceId);
    mapDeltaData.doors.push_back(door);

    const IndoorPortalGraph graph = buildIndoorPortalGraph(mapData, &mapDeltaData);

    REQUIRE_EQ(graph.portals.size(), 1);
    CHECK_EQ(graph.portals[0].faceId, faceId);
    CHECK_EQ(graph.portals[0].sectorA, 0);
    CHECK_EQ(graph.portals[0].sectorB, 1);
    CHECK_EQ(asSet(graph.portals[0].blockingDoorIds), std::set<uint32_t>{42});
    CHECK_EQ(asSet(graph.sectors[0].connectedSectorIds), std::set<uint16_t>{1});
    CHECK_EQ(asSet(graph.sectors[1].connectedSectorIds), std::set<uint16_t>{0});
    CHECK_EQ(asSet(portalFacesForSector(graph, 0)), std::set<uint16_t>{faceId});
    CHECK_EQ(asSet(portalFacesForSector(graph, 1)), std::set<uint16_t>{faceId});
}

TEST_CASE("indoor portal graph fixture snapshots are well-formed")
{
    const std::filesystem::path fixtureRoot = std::filesystem::path(OPENYAMM_SOURCE_DIR) / "tests" / "indoor_geometry";
    const std::array<std::filesystem::path, 2> fixturePaths = {{
        fixtureRoot / "6d01.yml",
        fixtureRoot / "cd2.yml",
    }};

    for (const std::filesystem::path &fixturePath : fixturePaths)
    {
        const std::vector<IndoorRoomSnapshot> snapshots = loadSnapshots(fixturePath);

        CAPTURE(fixturePath.string());
        REQUIRE_FALSE(snapshots.empty());

        for (const IndoorRoomSnapshot &snapshot : snapshots)
        {
            CAPTURE(snapshot.mapName);
            CAPTURE(snapshot.roomId);
            CHECK_FALSE(snapshot.mapName.empty());
            CHECK_FALSE(snapshot.rawFaceIds.empty());
            CHECK_EQ(snapshot.portals.size(), snapshot.rawPortalFaceIds.size());

            for (const SnapshotPortal &portal : snapshot.portals)
            {
                const bool portalTouchesSnapshotRoom =
                    portal.room == snapshot.roomId || portal.behindRoom == snapshot.roomId;
                CHECK(portalTouchesSnapshotRoom);
                CHECK_EQ(portal.connectedRoom, portal.room == snapshot.roomId ? portal.behindRoom : portal.room);
            }
        }
    }
}

TEST_CASE("indoor portal graph matches editor room snapshots")
{
    const std::filesystem::path fixtureRoot = std::filesystem::path(OPENYAMM_SOURCE_DIR) / "tests" / "indoor_geometry";
    const std::array<std::filesystem::path, 2> fixturePaths = {{
        fixtureRoot / "6d01.yml",
        fixtureRoot / "cd2.yml",
    }};

    for (const std::filesystem::path &fixturePath : fixturePaths)
    {
        const std::vector<IndoorRoomSnapshot> snapshots = loadSnapshots(fixturePath);
        REQUIRE_FALSE(snapshots.empty());

        for (const IndoorRoomSnapshot &snapshot : snapshots)
        {
            CAPTURE(fixturePath.string());
            CAPTURE(snapshot.mapName);
            CAPTURE(snapshot.roomId);

            const LoadedIndoorMap *pLoadedMap = loadCachedIndoorMap(snapshot.mapName);
            REQUIRE(pLoadedMap != nullptr);

            const IndoorPortalGraph graph = buildIndoorPortalGraph(pLoadedMap->mapData, &pLoadedMap->mapDeltaData);

            REQUIRE_LT(snapshot.roomId, graph.sectors.size());
            CHECK_EQ(asSet(graph.sectors[snapshot.roomId].connectedSectorIds), asSet(snapshot.connectedRooms));
            CHECK_EQ(asSet(portalFacesForSector(graph, snapshot.roomId)), asSet(snapshot.rawPortalFaceIds));

            for (const SnapshotPortal &snapshotPortal : snapshot.portals)
            {
                const IndoorPortalLink *pLink = findIndoorPortalLinkByFaceId(graph, snapshotPortal.faceId);
                REQUIRE(pLink != nullptr);
                CHECK_EQ(pLink->sectorA, snapshotPortal.room);
                CHECK_EQ(pLink->sectorB, snapshotPortal.behindRoom);
                CHECK_EQ(oppositeSector(*pLink, snapshot.roomId), snapshotPortal.connectedRoom);
                CHECK_EQ(asSet(pLink->blockingDoorIds), asSet(snapshotPortal.directBlockingDoorIds));
            }
        }
    }
}
