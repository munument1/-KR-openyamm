#include "game/indoor/IndoorPortalGraph.h"

#include "game/FaceEnums.h"

#include <algorithm>

namespace OpenYAMM::Game
{
namespace
{
bool containsUInt16(const std::vector<uint16_t> &values, uint16_t value)
{
    return std::find(values.begin(), values.end(), value) != values.end();
}

void appendUniqueUInt16(std::vector<uint16_t> &values, uint16_t value)
{
    if (!containsUInt16(values, value))
    {
        values.push_back(value);
    }
}

uint32_t effectiveFaceAttributes(const IndoorFace &face, size_t faceId, const MapDeltaData *pMapDeltaData)
{
    if (pMapDeltaData != nullptr && faceId < pMapDeltaData->faceAttributes.size())
    {
        return pMapDeltaData->faceAttributes[faceId];
    }

    return face.attributes;
}

bool isPortalFace(const IndoorFace &face, size_t faceId, const MapDeltaData *pMapDeltaData)
{
    return face.isPortal
        || hasFaceAttribute(effectiveFaceAttributes(face, faceId, pMapDeltaData), FaceAttribute::IsPortal);
}

void addDiagnostic(
    IndoorPortalGraph &graph,
    IndoorPortalGraphDiagnosticKind kind,
    uint16_t sectorId,
    uint16_t faceId,
    uint16_t sectorA,
    uint16_t sectorB,
    uint32_t doorId,
    const std::string &message)
{
    graph.diagnostics.push_back({
        .kind = kind,
        .sectorId = sectorId,
        .faceId = faceId,
        .sectorA = sectorA,
        .sectorB = sectorB,
        .doorId = doorId,
        .message = message,
    });
}

bool sectorListsPortalFace(const IndoorMapData &mapData, uint16_t sectorId, uint16_t faceId)
{
    if (sectorId >= mapData.sectors.size())
    {
        return false;
    }

    return containsUInt16(mapData.sectors[sectorId].portalFaceIds, faceId);
}

void attachPortalToSector(
    IndoorPortalGraph &graph,
    uint16_t sectorId,
    uint16_t portalLinkId,
    uint16_t connectedSectorId)
{
    if (sectorId >= graph.sectors.size())
    {
        return;
    }

    IndoorSectorPortalCache &sector = graph.sectors[sectorId];
    appendUniqueUInt16(sector.portalLinkIds, portalLinkId);
    appendUniqueUInt16(sector.connectedSectorIds, connectedSectorId);
}

}

IndoorPortalGraph buildIndoorPortalGraph(const IndoorMapData &mapData, const MapDeltaData *pMapDeltaData)
{
    IndoorPortalGraph graph = {};
    graph.sectors.resize(mapData.sectors.size());
    graph.linkIdByFaceId.assign(mapData.faces.size(), -1);

    for (size_t sectorId = 0; sectorId < graph.sectors.size(); ++sectorId)
    {
        graph.sectors[sectorId].sectorId = static_cast<uint16_t>(sectorId);
    }

    for (size_t sectorIndex = 0; sectorIndex < mapData.sectors.size(); ++sectorIndex)
    {
        const uint16_t listedSectorId = static_cast<uint16_t>(sectorIndex);
        const IndoorSector &sector = mapData.sectors[sectorIndex];

        for (uint16_t faceId : sector.portalFaceIds)
        {
            if (faceId >= mapData.faces.size())
            {
                addDiagnostic(
                    graph,
                    IndoorPortalGraphDiagnosticKind::InvalidPortalFaceId,
                    listedSectorId,
                    faceId,
                    0,
                    0,
                    0,
                    "sector portal face id is out of range");
                continue;
            }

            if (graph.linkIdByFaceId[faceId] >= 0)
            {
                continue;
            }

            const IndoorFace &face = mapData.faces[faceId];

            if (!isPortalFace(face, faceId, pMapDeltaData))
            {
                addDiagnostic(
                    graph,
                    IndoorPortalGraphDiagnosticKind::NonPortalFace,
                    listedSectorId,
                    faceId,
                    face.roomNumber,
                    face.roomBehindNumber,
                    0,
                    "sector portal list references a non-portal face");
                continue;
            }

            if (face.roomNumber >= mapData.sectors.size() || face.roomBehindNumber >= mapData.sectors.size())
            {
                addDiagnostic(
                    graph,
                    IndoorPortalGraphDiagnosticKind::InvalidSector,
                    listedSectorId,
                    faceId,
                    face.roomNumber,
                    face.roomBehindNumber,
                    0,
                    "portal face references an invalid sector");
                continue;
            }

            if (face.roomNumber == face.roomBehindNumber)
            {
                addDiagnostic(
                    graph,
                    IndoorPortalGraphDiagnosticKind::SameSector,
                    listedSectorId,
                    faceId,
                    face.roomNumber,
                    face.roomBehindNumber,
                    0,
                    "portal face connects a sector to itself");
                continue;
            }

            if (face.roomNumber == 0 || face.roomBehindNumber == 0)
            {
                addDiagnostic(
                    graph,
                    IndoorPortalGraphDiagnosticKind::SuspiciousSectorZeroLink,
                    listedSectorId,
                    faceId,
                    face.roomNumber,
                    face.roomBehindNumber,
                    0,
                    "validated portal references sector 0");
            }

            const bool listedByA = sectorListsPortalFace(mapData, face.roomNumber, faceId);
            const bool listedByB = sectorListsPortalFace(mapData, face.roomBehindNumber, faceId);

            if (!listedByA || !listedByB)
            {
                addDiagnostic(
                    graph,
                    IndoorPortalGraphDiagnosticKind::OneSidedPortalListing,
                    listedSectorId,
                    faceId,
                    face.roomNumber,
                    face.roomBehindNumber,
                    0,
                    "portal face is not listed by both connected sectors");
            }

            IndoorPortalLink link = {};
            link.faceId = faceId;
            link.sectorA = face.roomNumber;
            link.sectorB = face.roomBehindNumber;

            const uint16_t linkId = static_cast<uint16_t>(graph.portals.size());
            graph.portals.push_back(std::move(link));
            graph.linkIdByFaceId[faceId] = static_cast<int16_t>(linkId);

            attachPortalToSector(graph, face.roomNumber, linkId, face.roomBehindNumber);
            attachPortalToSector(graph, face.roomBehindNumber, linkId, face.roomNumber);
        }
    }

    return graph;
}

const IndoorPortalLink *findIndoorPortalLinkByFaceId(const IndoorPortalGraph &graph, uint16_t faceId)
{
    if (faceId >= graph.linkIdByFaceId.size())
    {
        return nullptr;
    }

    const int16_t linkId = graph.linkIdByFaceId[faceId];

    if (linkId < 0 || static_cast<size_t>(linkId) >= graph.portals.size())
    {
        return nullptr;
    }

    return &graph.portals[static_cast<size_t>(linkId)];
}
}
