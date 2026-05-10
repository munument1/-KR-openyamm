#include "game/indoor/IndoorPortalVisibility.h"

#include "game/events/EventRuntime.h"
#include "game/events/EvtEnums.h"
#include "game/FaceEnums.h"
#include "game/indoor/IndoorGeometryUtils.h"
#include "game/indoor/IndoorPortalGraph.h"
#include "game/maps/MapDeltaData.h"

#include <algorithm>
#include <cmath>
#include <limits>
#include <unordered_map>
#include <utility>

namespace OpenYAMM::Game
{
namespace
{
constexpr float VisibilityEpsilon = 0.001f;
constexpr float FrustumClipEpsilon = 5.0f;
constexpr float NearPortalSlack = 128.0f;

float dotVec(const bx::Vec3 &left, const bx::Vec3 &right)
{
    return left.x * right.x + left.y * right.y + left.z * right.z;
}

bx::Vec3 addVec(const bx::Vec3 &left, const bx::Vec3 &right)
{
    return {left.x + right.x, left.y + right.y, left.z + right.z};
}

bx::Vec3 subtractVec(const bx::Vec3 &left, const bx::Vec3 &right)
{
    return {left.x - right.x, left.y - right.y, left.z - right.z};
}

bx::Vec3 scaleVec(const bx::Vec3 &value, float scale)
{
    return {value.x * scale, value.y * scale, value.z * scale};
}

bx::Vec3 crossVec(const bx::Vec3 &left, const bx::Vec3 &right)
{
    return {
        left.y * right.z - left.z * right.y,
        left.z * right.x - left.x * right.z,
        left.x * right.y - left.y * right.x
    };
}

float lengthVec(const bx::Vec3 &value)
{
    return std::sqrt(dotVec(value, value));
}

bx::Vec3 normalizeVec(const bx::Vec3 &value)
{
    const float length = lengthVec(value);

    if (length <= VisibilityEpsilon)
    {
        return {0.0f, 0.0f, 0.0f};
    }

    return scaleVec(value, 1.0f / length);
}

float signedPlaneDistance(const IndoorVisibilityPlane &plane, const bx::Vec3 &point)
{
    return dotVec(plane.normal, point) + plane.distance;
}

IndoorVisibilityPlane makePlaneFromPoints(
    const bx::Vec3 &a,
    const bx::Vec3 &b,
    const bx::Vec3 &c,
    const bx::Vec3 &insidePoint
)
{
    IndoorVisibilityPlane plane = {};
    plane.normal = normalizeVec(crossVec(subtractVec(b, a), subtractVec(c, a)));
    plane.distance = -dotVec(plane.normal, a);

    if (signedPlaneDistance(plane, insidePoint) < 0.0f)
    {
        plane.normal = scaleVec(plane.normal, -1.0f);
        plane.distance = -plane.distance;
    }

    return plane;
}

std::vector<IndoorVisibilityPlane> buildCameraFrustumPlanes(const IndoorPortalVisibilityInput &input)
{
    const bx::Vec3 forward = normalizeVec(input.cameraForward);
    const bx::Vec3 up = normalizeVec(input.cameraUp);
    bx::Vec3 right = normalizeVec(crossVec(forward, up));

    if (lengthVec(right) <= VisibilityEpsilon)
    {
        right = {0.0f, -1.0f, 0.0f};
    }

    const bx::Vec3 correctedUp = normalizeVec(crossVec(right, forward));
    const float halfHeight = std::tan((input.verticalFovDegrees * 3.14159265358979323846f / 180.0f) * 0.5f);
    const float halfWidth = halfHeight * std::max(input.aspectRatio, 0.01f);
    const bx::Vec3 center = addVec(input.cameraPosition, forward);
    const bx::Vec3 rightOffset = scaleVec(right, halfWidth);
    const bx::Vec3 upOffset = scaleVec(correctedUp, halfHeight);
    const bx::Vec3 topLeft = addVec(subtractVec(center, rightOffset), upOffset);
    const bx::Vec3 topRight = addVec(addVec(center, rightOffset), upOffset);
    const bx::Vec3 bottomLeft = subtractVec(subtractVec(center, rightOffset), upOffset);
    const bx::Vec3 bottomRight = subtractVec(addVec(center, rightOffset), upOffset);
    const bx::Vec3 insidePoint = addVec(input.cameraPosition, forward);

    std::vector<IndoorVisibilityPlane> planes;
    planes.reserve(4);
    planes.push_back(makePlaneFromPoints(input.cameraPosition, topLeft, bottomLeft, insidePoint));
    planes.push_back(makePlaneFromPoints(input.cameraPosition, bottomRight, topRight, insidePoint));
    planes.push_back(makePlaneFromPoints(input.cameraPosition, topRight, topLeft, insidePoint));
    planes.push_back(makePlaneFromPoints(input.cameraPosition, bottomLeft, bottomRight, insidePoint));
    return planes;
}

std::vector<bx::Vec3> clipPolygonToPlane(
    const std::vector<bx::Vec3> &polygon,
    const IndoorVisibilityPlane &plane
)
{
    if (polygon.empty())
    {
        return {};
    }

    std::vector<bx::Vec3> clipped;
    clipped.reserve(polygon.size() + 1);

    for (size_t pointIndex = 0; pointIndex < polygon.size(); ++pointIndex)
    {
        const bx::Vec3 &current = polygon[pointIndex];
        const bx::Vec3 &next = polygon[(pointIndex + 1) % polygon.size()];
        const float currentDistance = signedPlaneDistance(plane, current);
        const float nextDistance = signedPlaneDistance(plane, next);
        const bool currentInside = currentDistance >= -FrustumClipEpsilon;
        const bool nextInside = nextDistance >= -FrustumClipEpsilon;

        if (currentInside && nextInside)
        {
            clipped.push_back(next);
        }
        else if (currentInside != nextInside)
        {
            const float denominator = currentDistance - nextDistance;
            const float factor = std::fabs(denominator) > VisibilityEpsilon ? currentDistance / denominator : 0.0f;
            const bx::Vec3 edge = subtractVec(next, current);
            clipped.push_back(addVec(current, scaleVec(edge, factor)));

            if (nextInside)
            {
                clipped.push_back(next);
            }
        }
    }

    return clipped;
}

std::vector<bx::Vec3> clipPolygonToFrustum(
    const std::vector<bx::Vec3> &polygon,
    const std::vector<IndoorVisibilityPlane> &planes
)
{
    std::vector<bx::Vec3> clipped = polygon;

    for (const IndoorVisibilityPlane &plane : planes)
    {
        clipped = clipPolygonToPlane(clipped, plane);

        if (clipped.size() < 3)
        {
            return {};
        }
    }

    return clipped;
}

std::vector<IndoorVisibilityPlane> buildPortalFrustumPlanes(
    const bx::Vec3 &cameraPosition,
    const std::vector<bx::Vec3> &portalPolygon
)
{
    if (portalPolygon.size() < 3)
    {
        return {};
    }

    bx::Vec3 centroid = {0.0f, 0.0f, 0.0f};
    for (const bx::Vec3 &point : portalPolygon)
    {
        centroid = addVec(centroid, point);
    }
    centroid = scaleVec(centroid, 1.0f / static_cast<float>(portalPolygon.size()));

    std::vector<IndoorVisibilityPlane> planes;
    planes.reserve(portalPolygon.size());

    for (size_t pointIndex = 0; pointIndex < portalPolygon.size(); ++pointIndex)
    {
        const bx::Vec3 &current = portalPolygon[pointIndex];
        const bx::Vec3 &next = portalPolygon[(pointIndex + 1) % portalPolygon.size()];
        IndoorVisibilityPlane plane = makePlaneFromPoints(cameraPosition, current, next, centroid);

        if (lengthVec(plane.normal) > VisibilityEpsilon)
        {
            planes.push_back(plane);
        }
    }

    return planes;
}

bool indoorPortalFaceVisible(
    size_t faceIndex,
    const std::optional<EventRuntimeState> *pEventRuntimeState)
{
    return pEventRuntimeState == nullptr
        || !pEventRuntimeState->has_value()
        || !(*pEventRuntimeState)->hasFacetInvisibleOverride(static_cast<uint32_t>(faceIndex));
}

uint16_t resolveMechanismState(
    const MapDeltaDoor &door,
    const std::optional<EventRuntimeState> *pEventRuntimeState
)
{
    if (pEventRuntimeState == nullptr || !pEventRuntimeState->has_value())
    {
        return door.state;
    }

    const std::unordered_map<uint32_t, RuntimeMechanismState>::const_iterator mechanismIterator =
        (*pEventRuntimeState)->mechanisms.find(door.doorId);

    if (mechanismIterator == (*pEventRuntimeState)->mechanisms.end())
    {
        return door.state;
    }

    return mechanismIterator->second.state;
}

bool segmentIntersectsTriangle(
    const bx::Vec3 &origin,
    const bx::Vec3 &target,
    const bx::Vec3 &a,
    const bx::Vec3 &b,
    const bx::Vec3 &c)
{
    const bx::Vec3 direction = subtractVec(target, origin);
    const bx::Vec3 edgeAB = subtractVec(b, a);
    const bx::Vec3 edgeAC = subtractVec(c, a);
    const bx::Vec3 pVector = crossVec(direction, edgeAC);
    const float determinant = dotVec(edgeAB, pVector);

    if (std::fabs(determinant) <= VisibilityEpsilon)
    {
        return false;
    }

    const float inverseDeterminant = 1.0f / determinant;
    const bx::Vec3 tVector = subtractVec(origin, a);
    const float u = dotVec(tVector, pVector) * inverseDeterminant;

    if (u < -VisibilityEpsilon || u > 1.0f + VisibilityEpsilon)
    {
        return false;
    }

    const bx::Vec3 qVector = crossVec(tVector, edgeAB);
    const float v = dotVec(direction, qVector) * inverseDeterminant;

    if (v < -VisibilityEpsilon || u + v > 1.0f + VisibilityEpsilon)
    {
        return false;
    }

    const float t = dotVec(edgeAC, qVector) * inverseDeterminant;
    return t > VisibilityEpsilon && t < 0.995f;
}

bool segmentIntersectsFace(
    const IndoorMapData &mapData,
    const std::vector<IndoorVertex> &vertices,
    uint16_t faceId,
    const bx::Vec3 &origin,
    const bx::Vec3 &target)
{
    if (faceId >= mapData.faces.size())
    {
        return false;
    }

    const IndoorFace &face = mapData.faces[faceId];

    if (face.vertexIndices.size() < 3)
    {
        return false;
    }

    const uint16_t firstVertexId = face.vertexIndices[0];

    if (firstVertexId >= vertices.size())
    {
        return false;
    }

    const IndoorVertex &firstVertex = vertices[firstVertexId];
    const bx::Vec3 a = {
        static_cast<float>(firstVertex.x),
        static_cast<float>(firstVertex.y),
        static_cast<float>(firstVertex.z)
    };

    for (size_t vertexOffset = 1; vertexOffset + 1 < face.vertexIndices.size(); ++vertexOffset)
    {
        const uint16_t vertexIdB = face.vertexIndices[vertexOffset];
        const uint16_t vertexIdC = face.vertexIndices[vertexOffset + 1];

        if (vertexIdB >= vertices.size() || vertexIdC >= vertices.size())
        {
            continue;
        }

        const IndoorVertex &vertexB = vertices[vertexIdB];
        const IndoorVertex &vertexC = vertices[vertexIdC];
        const bx::Vec3 b = {
            static_cast<float>(vertexB.x),
            static_cast<float>(vertexB.y),
            static_cast<float>(vertexB.z)
        };
        const bx::Vec3 c = {
            static_cast<float>(vertexC.x),
            static_cast<float>(vertexC.y),
            static_cast<float>(vertexC.z)
        };

        if (segmentIntersectsTriangle(origin, target, a, b, c))
        {
            return true;
        }
    }

    return false;
}

bool indoorFaceIsPortalAperture(const IndoorMapData &mapData, uint16_t faceId)
{
    if (faceId >= mapData.faces.size())
    {
        return false;
    }

    const IndoorFace &face = mapData.faces[faceId];
    return face.isPortal || hasFaceAttribute(face.attributes, FaceAttribute::IsPortal);
}

bool closedDoorOccludesPortal(
    const IndoorMapData &mapData,
    const std::vector<IndoorVertex> &vertices,
    const MapDeltaDoor &door,
    uint16_t portalFaceId,
    const bx::Vec3 &cameraPosition,
    const std::vector<bx::Vec3> &visiblePortalPolygon)
{
    if (visiblePortalPolygon.empty())
    {
        return false;
    }

    bx::Vec3 portalCenter = {0.0f, 0.0f, 0.0f};

    for (const bx::Vec3 &point : visiblePortalPolygon)
    {
        portalCenter = addVec(portalCenter, point);
    }

    portalCenter = scaleVec(portalCenter, 1.0f / static_cast<float>(visiblePortalPolygon.size()));
    bool testedSolidDoorFace = false;

    for (uint16_t doorFaceId : door.faceIds)
    {
        if (doorFaceId == portalFaceId || indoorFaceIsPortalAperture(mapData, doorFaceId))
        {
            continue;
        }

        testedSolidDoorFace = true;

        if (segmentIntersectsFace(mapData, vertices, doorFaceId, cameraPosition, portalCenter))
        {
            return true;
        }
    }

    return false;
}

bool containsDoorId(const std::vector<uint32_t> &doorIds, uint32_t doorId)
{
    return std::find(doorIds.begin(), doorIds.end(), doorId) != doorIds.end();
}

void appendUniqueDoorId(std::vector<uint32_t> &doorIds, uint32_t doorId)
{
    if (!containsDoorId(doorIds, doorId))
    {
        doorIds.push_back(doorId);
    }
}

std::vector<IndoorPortalVisibilityDoorTrace> collectPortalBlockerDoorTraces(
    const IndoorPortalLink &portalLink,
    const IndoorMapData &mapData,
    const std::vector<IndoorVertex> &vertices,
    const MapDeltaData *pMapDeltaData,
    const std::optional<EventRuntimeState> *pEventRuntimeState,
    const bx::Vec3 &cameraPosition,
    const std::vector<bx::Vec3> &visiblePortalPolygon,
    const std::vector<uint32_t> &crossedDoorIds
)
{
    if (pMapDeltaData == nullptr)
    {
        return {};
    }

    std::vector<IndoorPortalVisibilityDoorTrace> blockerDoorTraces;

    for (const MapDeltaDoor &door : pMapDeltaData->doors)
    {
        if (containsDoorId(crossedDoorIds, door.doorId))
        {
            continue;
        }

        const bool linked =
            std::find(portalLink.blockingDoorIds.begin(), portalLink.blockingDoorIds.end(), door.doorId)
                != portalLink.blockingDoorIds.end();
        const uint16_t state = resolveMechanismState(door, pEventRuntimeState);
        const bool closed = state == static_cast<uint16_t>(EvtMechanismState::Closed);
        const bool blocks =
            closed
            && closedDoorOccludesPortal(
                mapData,
                vertices,
                door,
                portalLink.faceId,
                cameraPosition,
                visiblePortalPolygon);

        if (!linked && !blocks)
        {
            continue;
        }

        blockerDoorTraces.push_back({
            .doorId = door.doorId,
            .state = state,
            .blocks = blocks,
        });
    }

    return blockerDoorTraces;
}

bool hasBlockingClosedDoor(const std::vector<IndoorPortalVisibilityDoorTrace> &blockerDoorTraces)
{
    return std::any_of(
        blockerDoorTraces.begin(),
        blockerDoorTraces.end(),
        [](const IndoorPortalVisibilityDoorTrace &trace)
        {
            return trace.blocks;
        });
}

bool hasAncestorSector(
    const std::vector<IndoorVisibilityNode> &nodes,
    int16_t nodeIndex,
    int16_t sectorId
)
{
    int16_t currentIndex = nodeIndex;

    while (currentIndex >= 0 && static_cast<size_t>(currentIndex) < nodes.size())
    {
        const IndoorVisibilityNode &node = nodes[static_cast<size_t>(currentIndex)];

        if (node.sectorId == sectorId)
        {
            return true;
        }

        currentIndex = node.parentNodeIndex;
    }

    return false;
}

bool cameraNearPortal(const bx::Vec3 &cameraPosition, const std::vector<bx::Vec3> &portalPolygon)
{
    if (portalPolygon.empty())
    {
        return false;
    }

    bx::Vec3 minBounds = portalPolygon.front();
    bx::Vec3 maxBounds = portalPolygon.front();

    for (const bx::Vec3 &point : portalPolygon)
    {
        minBounds.x = std::min(minBounds.x, point.x);
        minBounds.y = std::min(minBounds.y, point.y);
        minBounds.z = std::min(minBounds.z, point.z);
        maxBounds.x = std::max(maxBounds.x, point.x);
        maxBounds.y = std::max(maxBounds.y, point.y);
        maxBounds.z = std::max(maxBounds.z, point.z);
    }

    return cameraPosition.x >= minBounds.x - NearPortalSlack
        && cameraPosition.x <= maxBounds.x + NearPortalSlack
        && cameraPosition.y >= minBounds.y - NearPortalSlack
        && cameraPosition.y <= maxBounds.y + NearPortalSlack
        && cameraPosition.z >= minBounds.z - NearPortalSlack
        && cameraPosition.z <= maxBounds.z + NearPortalSlack;
}

bool portalPolygonBehindCamera(
    const std::vector<bx::Vec3> &portalPolygon,
    const bx::Vec3 &cameraPosition,
    const bx::Vec3 &cameraForward)
{
    if (portalPolygon.empty())
    {
        return true;
    }

    const bx::Vec3 forward = normalizeVec(cameraForward);

    for (const bx::Vec3 &point : portalPolygon)
    {
        if (dotVec(forward, subtractVec(point, cameraPosition)) >= -NearPortalSlack)
        {
            return false;
        }
    }

    return true;
}

bool sectorHasPortalGraphLinks(const IndoorPortalGraph &portalGraph, int16_t sectorId)
{
    return sectorId >= 0
        && static_cast<size_t>(sectorId) < portalGraph.sectors.size()
        && !portalGraph.sectors[static_cast<size_t>(sectorId)].portalLinkIds.empty();
}

void appendRootVisibilityNode(
    IndoorPortalVisibilityResult &result,
    int16_t sectorId,
    const std::vector<IndoorVisibilityPlane> &rootFrustumPlanes)
{
    if (sectorId < 0
        || static_cast<size_t>(sectorId) >= result.visibleSectorMask.size()
        || result.visibleSectorMask[static_cast<size_t>(sectorId)] != 0)
    {
        return;
    }

    IndoorVisibilityNode rootNode = {};
    rootNode.sectorId = sectorId;
    rootNode.parentNodeIndex = -1;
    rootNode.entryPortalFaceId = -1;
    rootNode.depth = 0;
    rootNode.frustumPlanes = rootFrustumPlanes;
    const uint16_t rootNodeIndex = static_cast<uint16_t>(result.nodes.size());
    result.nodes.push_back(std::move(rootNode));
    result.visibleSectorMask[static_cast<size_t>(sectorId)] = 1;
    result.nodeIndicesBySector[static_cast<size_t>(sectorId)].push_back(rootNodeIndex);

    if (static_cast<size_t>(sectorId) < result.frustumsBySector.size())
    {
        result.frustumsBySector[static_cast<size_t>(sectorId)].push_back(rootFrustumPlanes);
    }
}

void appendPortalTrace(
    IndoorPortalVisibilityResult &result,
    int16_t sourceSectorId,
    int16_t targetSectorId,
    uint16_t faceId,
    uint16_t portalLinkId,
    uint16_t depth,
    bool accepted,
    const std::string &reason,
    std::vector<IndoorPortalVisibilityDoorTrace> blockerDoors = {})
{
    result.portalTraces.push_back({
        .sourceSectorId = sourceSectorId,
        .targetSectorId = targetSectorId,
        .faceId = faceId,
        .portalLinkId = portalLinkId,
        .depth = depth,
        .accepted = accepted,
        .reason = reason,
        .blockerDoors = std::move(blockerDoors),
    });
}
}

IndoorPortalVisibilityResult buildIndoorPortalVisibility(const IndoorPortalVisibilityInput &input)
{
    IndoorPortalVisibilityResult result = {};

    if (input.pMapData == nullptr
        || input.pVertices == nullptr
        || input.startSectorId < 0
        || static_cast<size_t>(input.startSectorId) >= input.pMapData->sectors.size())
    {
        return result;
    }

    const IndoorMapData &mapData = *input.pMapData;
    const std::vector<IndoorVertex> &vertices = *input.pVertices;
    IndoorPortalGraph localPortalGraph = {};
    const IndoorPortalGraph *pPortalGraph = input.pPortalGraph;

    if (pPortalGraph == nullptr)
    {
        localPortalGraph = buildIndoorPortalGraph(mapData, input.pMapDeltaData);
        pPortalGraph = &localPortalGraph;
    }

    const std::vector<IndoorVisibilityPlane> rootFrustumPlanes = buildCameraFrustumPlanes(input);

    result.visibleSectorMask.assign(mapData.sectors.size(), 0);
    result.nodeIndicesBySector.resize(mapData.sectors.size());
    result.frustumsBySector.resize(mapData.sectors.size());
    result.nodes.reserve(std::min<size_t>(input.maxNodes, mapData.sectors.size() * 2 + 1));

    appendRootVisibilityNode(result, input.startSectorId, rootFrustumPlanes);

    IndoorFaceGeometryCache geometryCache(mapData.faces.size());

    for (size_t nodeIndex = 0; nodeIndex < result.nodes.size(); ++nodeIndex)
    {
        if (nodeIndex >= input.maxNodes)
        {
            break;
        }

        const IndoorVisibilityNode currentNode = result.nodes[nodeIndex];

        if (currentNode.depth >= input.maxDepth
            || currentNode.sectorId < 0
            || static_cast<size_t>(currentNode.sectorId) >= mapData.sectors.size())
        {
            continue;
        }

        if (!sectorHasPortalGraphLinks(*pPortalGraph, currentNode.sectorId))
        {
            continue;
        }

        const IndoorSectorPortalCache &sectorCache =
            pPortalGraph->sectors[static_cast<size_t>(currentNode.sectorId)];

        for (uint16_t portalLinkId : sectorCache.portalLinkIds)
        {
            if (result.nodes.size() >= input.maxNodes || portalLinkId >= pPortalGraph->portals.size())
            {
                result.maxNodeLimitHit = result.nodes.size() >= input.maxNodes;
                ++result.rejectedPortalCount;
                ++result.invalidPortalCount;
                appendPortalTrace(
                    result,
                    currentNode.sectorId,
                    -1,
                    0,
                    portalLinkId,
                    currentNode.depth,
                    false,
                    result.maxNodeLimitHit ? "max_node_limit" : "invalid_portal_link");
                continue;
            }

            const IndoorPortalLink &portalLink = pPortalGraph->portals[portalLinkId];
            const uint16_t faceId = portalLink.faceId;
            int16_t connectedSectorId = -1;

            if (portalLink.sectorA == static_cast<uint16_t>(currentNode.sectorId))
            {
                connectedSectorId = static_cast<int16_t>(portalLink.sectorB);
            }
            else if (portalLink.sectorB == static_cast<uint16_t>(currentNode.sectorId))
            {
                connectedSectorId = static_cast<int16_t>(portalLink.sectorA);
            }

            if (faceId >= mapData.faces.size())
            {
                ++result.rejectedPortalCount;
                ++result.invalidPortalCount;
                appendPortalTrace(
                    result,
                    currentNode.sectorId,
                    connectedSectorId,
                    faceId,
                    portalLinkId,
                    currentNode.depth,
                    false,
                    "invalid_face_id");
                continue;
            }

            ++result.portalCandidateCount;
            const IndoorFace &face = mapData.faces[faceId];
            const uint32_t effectiveAttributes =
                input.pMapDeltaData != nullptr && faceId < input.pMapDeltaData->faceAttributes.size()
                    ? input.pMapDeltaData->faceAttributes[faceId]
                    : face.attributes;

            if (static_cast<int16_t>(faceId) == currentNode.entryPortalFaceId
                || (!face.isPortal && !hasFaceAttribute(effectiveAttributes, FaceAttribute::IsPortal))
                || !indoorPortalFaceVisible(faceId, input.pEventRuntimeState))
            {
                ++result.rejectedPortalCount;
                ++result.invalidPortalCount;
                const std::string reason =
                    static_cast<int16_t>(faceId) == currentNode.entryPortalFaceId
                        ? "entry_portal"
                        : ((!face.isPortal && !hasFaceAttribute(effectiveAttributes, FaceAttribute::IsPortal))
                            ? "not_portal_face"
                            : "portal_hidden_override");
                appendPortalTrace(
                    result,
                    currentNode.sectorId,
                    connectedSectorId,
                    faceId,
                    portalLinkId,
                    currentNode.depth,
                    false,
                    reason);
                continue;
            }

            if (connectedSectorId < 0
                || static_cast<size_t>(connectedSectorId) >= mapData.sectors.size()
                || hasAncestorSector(result.nodes, static_cast<int16_t>(nodeIndex), connectedSectorId))
            {
                ++result.rejectedPortalCount;
                ++result.ancestorRejectedPortalCount;
                const std::string reason =
                    connectedSectorId < 0 || static_cast<size_t>(connectedSectorId) >= mapData.sectors.size()
                        ? "invalid_target_sector"
                        : "ancestor_sector";
                appendPortalTrace(
                    result,
                    currentNode.sectorId,
                    connectedSectorId,
                    faceId,
                    portalLinkId,
                    currentNode.depth,
                    false,
                    reason);
                continue;
            }

            const IndoorFaceGeometryData *pGeometry =
                geometryCache.geometryForFace(mapData, vertices, static_cast<size_t>(faceId));

            if (pGeometry == nullptr || pGeometry->vertices.size() < 3)
            {
                ++result.rejectedPortalCount;
                ++result.invalidPortalCount;
                appendPortalTrace(
                    result,
                    currentNode.sectorId,
                    connectedSectorId,
                    faceId,
                    portalLinkId,
                    currentNode.depth,
                    false,
                    pGeometry == nullptr ? "missing_geometry" : "small_geometry");
                continue;
            }

            const bool nearPortal = cameraNearPortal(input.cameraPosition, pGeometry->vertices);

            if (!nearPortal && portalPolygonBehindCamera(pGeometry->vertices, input.cameraPosition, input.cameraForward))
            {
                ++result.rejectedPortalCount;
                ++result.directionRejectedPortalCount;
                appendPortalTrace(
                    result,
                    currentNode.sectorId,
                    connectedSectorId,
                    faceId,
                    portalLinkId,
                    currentNode.depth,
                    false,
                    "behind_camera");
                continue;
            }

            const std::vector<bx::Vec3> clippedPortal =
                nearPortal
                ? pGeometry->vertices
                : clipPolygonToFrustum(pGeometry->vertices, currentNode.frustumPlanes);

            if (clippedPortal.size() < 3)
            {
                ++result.rejectedPortalCount;
                ++result.clippedPortalRejectedCount;
                appendPortalTrace(
                    result,
                    currentNode.sectorId,
                    connectedSectorId,
                    faceId,
                    portalLinkId,
                    currentNode.depth,
                    false,
                    nearPortal ? "near_portal_small" : "clipped_portal");
                continue;
            }

            std::vector<IndoorVisibilityPlane> childFrustumPlanes;
            if (std::fabs(pGeometry->normal.z) > 0.999f || nearPortal)
            {
                childFrustumPlanes = rootFrustumPlanes;
            }
            else
            {
                childFrustumPlanes = buildPortalFrustumPlanes(input.cameraPosition, clippedPortal);
            }

            if (childFrustumPlanes.size() < 3)
            {
                ++result.rejectedPortalCount;
                ++result.clippedPortalRejectedCount;
                appendPortalTrace(
                    result,
                    currentNode.sectorId,
                    connectedSectorId,
                    faceId,
                    portalLinkId,
                    currentNode.depth,
                    false,
                    "child_frustum_small");
                continue;
            }

            std::vector<IndoorPortalVisibilityDoorTrace> blockerDoorTraces =
                collectPortalBlockerDoorTraces(
                    portalLink,
                    mapData,
                    vertices,
                    input.pMapDeltaData,
                    input.pEventRuntimeState,
                    input.cameraPosition,
                    clippedPortal,
                    currentNode.crossedDoorIds);

            if (!input.ignoreMechanismBlockers && hasBlockingClosedDoor(blockerDoorTraces))
            {
                ++result.rejectedPortalCount;
                ++result.blockedPortalCount;
                appendPortalTrace(
                    result,
                    currentNode.sectorId,
                    connectedSectorId,
                    faceId,
                    portalLinkId,
                    currentNode.depth,
                    false,
                    "blocked_by_closed_door",
                    std::move(blockerDoorTraces));
                continue;
            }

            IndoorVisibilityNode childNode = {};
            childNode.sectorId = connectedSectorId;
            childNode.parentNodeIndex = static_cast<int16_t>(nodeIndex);
            childNode.entryPortalFaceId = static_cast<int16_t>(faceId);
            childNode.depth = static_cast<uint16_t>(currentNode.depth + 1);
            childNode.frustumPlanes = std::move(childFrustumPlanes);
            childNode.crossedDoorIds = currentNode.crossedDoorIds;

            for (uint32_t doorId : portalLink.blockingDoorIds)
            {
                appendUniqueDoorId(childNode.crossedDoorIds, doorId);
            }

            const uint16_t childNodeIndex = static_cast<uint16_t>(result.nodes.size());
            result.nodes.push_back(std::move(childNode));
            result.nodeIndicesBySector[static_cast<size_t>(connectedSectorId)].push_back(childNodeIndex);
            result.frustumsBySector[static_cast<size_t>(connectedSectorId)].push_back(
                result.nodes.back().frustumPlanes);
            result.visibleSectorMask[static_cast<size_t>(connectedSectorId)] = 1;
            appendPortalTrace(
                result,
                currentNode.sectorId,
                connectedSectorId,
                faceId,
                portalLinkId,
                currentNode.depth,
                true,
                "accepted",
                std::move(blockerDoorTraces));
            ++result.acceptedPortalCount;
        }
    }

    return result;
}
}
