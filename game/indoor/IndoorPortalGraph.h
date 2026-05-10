#pragma once

#include "game/indoor/IndoorMapData.h"
#include "game/maps/MapDeltaData.h"

#include <cstdint>
#include <string>
#include <vector>

namespace OpenYAMM::Game
{
enum class IndoorPortalGraphDiagnosticKind
{
    InvalidPortalFaceId,
    NonPortalFace,
    InvalidSector,
    SameSector,
    DuplicatePortalFace,
    OneSidedPortalListing,
    SuspiciousSectorZeroLink,
    DoorOverlapWithoutExplicitLink,
};

struct IndoorPortalGraphDiagnostic
{
    IndoorPortalGraphDiagnosticKind kind = IndoorPortalGraphDiagnosticKind::InvalidPortalFaceId;
    uint16_t sectorId = 0;
    uint16_t faceId = 0;
    uint16_t sectorA = 0;
    uint16_t sectorB = 0;
    uint32_t doorId = 0;
    std::string message;
};

struct IndoorPortalLink
{
    uint16_t faceId = 0;
    uint16_t sectorA = 0;
    uint16_t sectorB = 0;
    std::vector<uint32_t> blockingDoorIds;
};

struct IndoorSectorPortalCache
{
    uint16_t sectorId = 0;
    std::vector<uint16_t> portalLinkIds;
    std::vector<uint16_t> connectedSectorIds;
};

struct IndoorPortalGraph
{
    std::vector<IndoorSectorPortalCache> sectors;
    std::vector<IndoorPortalLink> portals;
    std::vector<IndoorPortalGraphDiagnostic> diagnostics;
    std::vector<int16_t> linkIdByFaceId;
};

IndoorPortalGraph buildIndoorPortalGraph(
    const IndoorMapData &mapData,
    const MapDeltaData *pMapDeltaData = nullptr);

const IndoorPortalLink *findIndoorPortalLinkByFaceId(const IndoorPortalGraph &graph, uint16_t faceId);
}
