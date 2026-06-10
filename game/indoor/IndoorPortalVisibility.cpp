#include "game/indoor/IndoorPortalVisibility.h"

#include "game/events/EventRuntime.h"
#include "game/FaceEnums.h"
#include "game/indoor/IndoorGeometryUtils.h"
#include "game/indoor/IndoorPortalGraph.h"
#include "game/maps/MapDeltaData.h"

#include <algorithm>
#include <cmath>
#include <string_view>
#include <utility>

namespace OpenYAMM::Game
{
namespace
{
constexpr float VisibilityEpsilon = 0.001f;
constexpr float FrustumClipEpsilon = 5.0f;
constexpr float NearPortalSlack = 128.0f;
constexpr float ClippedPortalRecoverySlack = 512.0f;
constexpr float SharedBoundaryClippedPortalRecoverySlack = 1024.0f;
constexpr float DegenerateVerticalPortalMaxNormalZ = 0.1f;
constexpr float DegeneratePortalMaxHeight = 8.0f;
constexpr float SynthesizedPortalMinWidth = 8.0f;
constexpr float SynthesizedPortalMinHeight = 16.0f;
constexpr uint16_t DegenerateChildFrustumRecoveryMaxDepth = 1;

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

uint32_t effectiveFaceAttributes(
    const IndoorFace &face,
    uint16_t faceId,
    const MapDeltaData *pMapDeltaData)
{
    if (pMapDeltaData != nullptr && faceId < pMapDeltaData->faceAttributes.size())
    {
        return pMapDeltaData->faceAttributes[faceId];
    }

    return face.attributes;
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

bool cameraNearPortal(
    const bx::Vec3 &cameraPosition,
    const std::vector<bx::Vec3> &portalPolygon,
    float slack = NearPortalSlack)
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

    return cameraPosition.x >= minBounds.x - slack
        && cameraPosition.x <= maxBounds.x + slack
        && cameraPosition.y >= minBounds.y - slack
        && cameraPosition.y <= maxBounds.y + slack
        && cameraPosition.z >= minBounds.z - slack
        && cameraPosition.z <= maxBounds.z + slack;
}

bool rangeOverlap(float leftMin, float leftMax, float rightMin, float rightMax, float &overlapMin, float &overlapMax)
{
    overlapMin = std::max(leftMin, rightMin);
    overlapMax = std::min(leftMax, rightMax);
    return overlapMax > overlapMin + VisibilityEpsilon;
}

int dominantAxis(const bx::Vec3 &normal)
{
    const float absX = std::fabs(normal.x);
    const float absY = std::fabs(normal.y);
    const float absZ = std::fabs(normal.z);

    if (absX >= absY && absX >= absZ)
    {
        return 0;
    }

    return absY >= absZ ? 1 : 2;
}

float averagePortalAxisCoordinate(const std::vector<bx::Vec3> &vertices, int axis)
{
    if (vertices.empty())
    {
        return 0.0f;
    }

    float value = 0.0f;

    for (const bx::Vec3 &point : vertices)
    {
        if (axis == 0)
        {
            value += point.x;
        }
        else if (axis == 1)
        {
            value += point.y;
        }
        else
        {
            value += point.z;
        }
    }

    return value / static_cast<float>(vertices.size());
}

bool portalNormalSupportsSharedBoundaryPolygon(const bx::Vec3 &normal)
{
    constexpr float AxisAlignedPortalNormalThreshold = 0.95f;
    const float dominantComponent = std::max(std::fabs(normal.x), std::max(std::fabs(normal.y), std::fabs(normal.z)));
    return dominantComponent >= AxisAlignedPortalNormalThreshold;
}

std::vector<bx::Vec3> sectorBoundsCorners(const IndoorSector &sector)
{
    return {
        {static_cast<float>(sector.minX), static_cast<float>(sector.minY), static_cast<float>(sector.minZ)},
        {static_cast<float>(sector.minX), static_cast<float>(sector.minY), static_cast<float>(sector.maxZ)},
        {static_cast<float>(sector.minX), static_cast<float>(sector.maxY), static_cast<float>(sector.minZ)},
        {static_cast<float>(sector.minX), static_cast<float>(sector.maxY), static_cast<float>(sector.maxZ)},
        {static_cast<float>(sector.maxX), static_cast<float>(sector.minY), static_cast<float>(sector.minZ)},
        {static_cast<float>(sector.maxX), static_cast<float>(sector.minY), static_cast<float>(sector.maxZ)},
        {static_cast<float>(sector.maxX), static_cast<float>(sector.maxY), static_cast<float>(sector.minZ)},
        {static_cast<float>(sector.maxX), static_cast<float>(sector.maxY), static_cast<float>(sector.maxZ)}
    };
}

void projectSectorBoundsToPortalPlaneAxes(
    const IndoorSector &sector,
    const bx::Vec3 &horizontalAxis,
    float &minHorizontal,
    float &maxHorizontal,
    float &minZ,
    float &maxZ)
{
    const std::vector<bx::Vec3> corners = sectorBoundsCorners(sector);
    minHorizontal = maxHorizontal = dotVec(horizontalAxis, corners.front());
    minZ = maxZ = corners.front().z;

    for (const bx::Vec3 &corner : corners)
    {
        const float horizontal = dotVec(horizontalAxis, corner);
        minHorizontal = std::min(minHorizontal, horizontal);
        maxHorizontal = std::max(maxHorizontal, horizontal);
        minZ = std::min(minZ, corner.z);
        maxZ = std::max(maxZ, corner.z);
    }
}

bool buildDegenerateVerticalPortalBoundaryPolygon(
    const IndoorMapData &mapData,
    const IndoorFaceGeometryData &geometry,
    int16_t sectorAId,
    int16_t sectorBId,
    std::vector<bx::Vec3> &portalPolygon)
{
    if (!geometry.hasPlane
        || std::fabs(geometry.normal.z) > DegenerateVerticalPortalMaxNormalZ
        || geometry.maxZ - geometry.minZ > DegeneratePortalMaxHeight
        || sectorAId < 0
        || sectorBId < 0
        || static_cast<size_t>(sectorAId) >= mapData.sectors.size()
        || static_cast<size_t>(sectorBId) >= mapData.sectors.size())
    {
        return false;
    }

    const bx::Vec3 horizontalNormal = normalizeVec({geometry.normal.x, geometry.normal.y, 0.0f});
    if (lengthVec(horizontalNormal) <= VisibilityEpsilon || geometry.vertices.empty())
    {
        return false;
    }

    const bx::Vec3 up = {0.0f, 0.0f, 1.0f};
    const bx::Vec3 horizontalAxis = normalizeVec(crossVec(up, horizontalNormal));
    if (lengthVec(horizontalAxis) <= VisibilityEpsilon)
    {
        return false;
    }

    const IndoorSector &sectorA = mapData.sectors[static_cast<size_t>(sectorAId)];
    const IndoorSector &sectorB = mapData.sectors[static_cast<size_t>(sectorBId)];
    float minHorizontalA = 0.0f;
    float maxHorizontalA = 0.0f;
    float minZA = 0.0f;
    float maxZA = 0.0f;
    float minHorizontalB = 0.0f;
    float maxHorizontalB = 0.0f;
    float minZB = 0.0f;
    float maxZB = 0.0f;

    projectSectorBoundsToPortalPlaneAxes(sectorA, horizontalAxis, minHorizontalA, maxHorizontalA, minZA, maxZA);
    projectSectorBoundsToPortalPlaneAxes(sectorB, horizontalAxis, minHorizontalB, maxHorizontalB, minZB, maxZB);

    float minHorizontal = 0.0f;
    float maxHorizontal = 0.0f;
    float minZ = 0.0f;
    float maxZ = 0.0f;
    if (!rangeOverlap(minHorizontalA, maxHorizontalA, minHorizontalB, maxHorizontalB, minHorizontal, maxHorizontal)
        || !rangeOverlap(minZA, maxZA, minZB, maxZB, minZ, maxZ)
        || maxHorizontal - minHorizontal < SynthesizedPortalMinWidth
        || maxZ - minZ < SynthesizedPortalMinHeight)
    {
        return false;
    }

    const float planeDistance = -dotVec(horizontalNormal, geometry.vertices.front());
    const auto pointOnPortalPlane =
        [horizontalNormal, horizontalAxis, planeDistance](float horizontal, float z)
    {
        return addVec(
            addVec(scaleVec(horizontalAxis, horizontal), {0.0f, 0.0f, z}),
            scaleVec(horizontalNormal, -planeDistance));
    };

    portalPolygon = {
        pointOnPortalPlane(minHorizontal, minZ),
        pointOnPortalPlane(minHorizontal, maxZ),
        pointOnPortalPlane(maxHorizontal, maxZ),
        pointOnPortalPlane(maxHorizontal, minZ)
    };
    return true;
}

bool buildSharedSectorBoundaryPortalPolygon(
    const IndoorMapData &mapData,
    const IndoorFaceGeometryData &geometry,
    int16_t sectorAId,
    int16_t sectorBId,
    std::vector<bx::Vec3> &portalPolygon)
{
    if (!geometry.hasPlane
        || !portalNormalSupportsSharedBoundaryPolygon(geometry.normal)
        || sectorAId < 0
        || sectorBId < 0
        || static_cast<size_t>(sectorAId) >= mapData.sectors.size()
        || static_cast<size_t>(sectorBId) >= mapData.sectors.size())
    {
        return false;
    }

    const IndoorSector &sectorA = mapData.sectors[static_cast<size_t>(sectorAId)];
    const IndoorSector &sectorB = mapData.sectors[static_cast<size_t>(sectorBId)];
    float minFirst = 0.0f;
    float maxFirst = 0.0f;
    float minSecond = 0.0f;
    float maxSecond = 0.0f;
    portalPolygon.clear();
    const int planeAxis = dominantAxis(geometry.normal);
    const float planeCoordinate = averagePortalAxisCoordinate(geometry.vertices, planeAxis);

    const auto appendXPlane =
        [&portalPolygon](float x, float minY, float maxY, float minZ, float maxZ)
    {
        portalPolygon = {
            {x, minY, minZ},
            {x, minY, maxZ},
            {x, maxY, maxZ},
            {x, maxY, minZ}
        };
    };

    const auto appendYPlane =
        [&portalPolygon](float y, float minX, float maxX, float minZ, float maxZ)
    {
        portalPolygon = {
            {minX, y, minZ},
            {minX, y, maxZ},
            {maxX, y, maxZ},
            {maxX, y, minZ}
        };
    };

    const auto appendZPlane =
        [&portalPolygon](float z, float minX, float maxX, float minY, float maxY)
    {
        portalPolygon = {
            {minX, minY, z},
            {minX, maxY, z},
            {maxX, maxY, z},
            {maxX, minY, z}
        };
    };

    if (planeAxis == 0
        && rangeOverlap(sectorA.minY, sectorA.maxY, sectorB.minY, sectorB.maxY, minFirst, maxFirst)
        && rangeOverlap(sectorA.minZ, sectorA.maxZ, sectorB.minZ, sectorB.maxZ, minSecond, maxSecond))
    {
        appendXPlane(planeCoordinate, minFirst, maxFirst, minSecond, maxSecond);
        return true;
    }

    if (planeAxis == 1
        && rangeOverlap(sectorA.minX, sectorA.maxX, sectorB.minX, sectorB.maxX, minFirst, maxFirst)
        && rangeOverlap(sectorA.minZ, sectorA.maxZ, sectorB.minZ, sectorB.maxZ, minSecond, maxSecond))
    {
        appendYPlane(planeCoordinate, minFirst, maxFirst, minSecond, maxSecond);
        return true;
    }

    if (planeAxis == 2
        && rangeOverlap(sectorA.minX, sectorA.maxX, sectorB.minX, sectorB.maxX, minFirst, maxFirst)
        && rangeOverlap(sectorA.minY, sectorA.maxY, sectorB.minY, sectorB.maxY, minSecond, maxSecond))
    {
        appendZPlane(planeCoordinate, minFirst, maxFirst, minSecond, maxSecond);
        return true;
    }

    return false;
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

bool sameVisibilityPlane(const IndoorVisibilityPlane &left, const IndoorVisibilityPlane &right)
{
    return left.normal.x == right.normal.x
        && left.normal.y == right.normal.y
        && left.normal.z == right.normal.z
        && left.distance == right.distance;
}

bool sameVisibilityFrustum(const IndoorVisibilityFrustum &left, const IndoorVisibilityFrustum &right)
{
    if (left.size() != right.size())
    {
        return false;
    }

    for (size_t index = 0; index < left.size(); ++index)
    {
        if (!sameVisibilityPlane(left[index], right[index]))
        {
            return false;
        }
    }

    return true;
}

void appendUniqueSectorFrustum(
    IndoorPortalVisibilityResult &result,
    int16_t sectorId,
    const IndoorVisibilityFrustum &frustum)
{
    if (sectorId < 0 || static_cast<size_t>(sectorId) >= result.frustumsBySector.size())
    {
        return;
    }

    std::vector<IndoorVisibilityFrustum> &sectorFrustums =
        result.frustumsBySector[static_cast<size_t>(sectorId)];

    for (const IndoorVisibilityFrustum &existingFrustum : sectorFrustums)
    {
        if (sameVisibilityFrustum(existingFrustum, frustum))
        {
            return;
        }
    }

    sectorFrustums.push_back(frustum);
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

    appendUniqueSectorFrustum(result, sectorId, rootFrustumPlanes);
}

void appendPortalTrace(
    IndoorPortalVisibilityResult &result,
    bool collectTrace,
    int16_t sourceSectorId,
    int16_t targetSectorId,
    uint16_t faceId,
    uint16_t portalLinkId,
    uint16_t depth,
    bool accepted,
    std::string_view reason)
{
    if (!collectTrace)
    {
        return;
    }

    result.portalTraces.push_back({
        .sourceSectorId = sourceSectorId,
        .targetSectorId = targetSectorId,
        .faceId = faceId,
        .portalLinkId = portalLinkId,
        .depth = depth,
        .accepted = accepted,
        .reason = std::string(reason),
    });
}

void appendAcceptedPortalVisibility(
    IndoorPortalVisibilityResult &result,
    int16_t targetSectorId,
    uint16_t faceId)
{
    result.acceptedPortals.push_back({
        .targetSectorId = targetSectorId,
        .faceId = faceId,
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
    const std::vector<IndoorVertex> &portalVertices =
        input.pPortalVertices != nullptr ? *input.pPortalVertices : *input.pVertices;
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
        std::vector<bx::Vec3> sharedBoundaryPortalPolygon;
        sharedBoundaryPortalPolygon.reserve(4);

        for (uint16_t portalLinkId : sectorCache.portalLinkIds)
        {
            if (result.nodes.size() >= input.maxNodes || portalLinkId >= pPortalGraph->portals.size())
            {
                result.maxNodeLimitHit = result.nodes.size() >= input.maxNodes;
                ++result.rejectedPortalCount;
                ++result.invalidPortalCount;
                appendPortalTrace(
                    result,
                    input.collectPortalTraces,
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
                    input.collectPortalTraces,
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
                const char *reason =
                    static_cast<int16_t>(faceId) == currentNode.entryPortalFaceId
                        ? "entry_portal"
                        : ((!face.isPortal && !hasFaceAttribute(effectiveAttributes, FaceAttribute::IsPortal))
                            ? "not_portal_face"
                            : "portal_hidden_override");
                appendPortalTrace(
                    result,
                    input.collectPortalTraces,
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
                const char *reason =
                    connectedSectorId < 0 || static_cast<size_t>(connectedSectorId) >= mapData.sectors.size()
                        ? "invalid_target_sector"
                        : "ancestor_sector";
                appendPortalTrace(
                    result,
                    input.collectPortalTraces,
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
                geometryCache.geometryForFace(mapData, portalVertices, static_cast<size_t>(faceId));

            if (pGeometry == nullptr || pGeometry->vertices.size() < 3)
            {
                ++result.rejectedPortalCount;
                ++result.invalidPortalCount;
                appendPortalTrace(
                    result,
                    input.collectPortalTraces,
                    currentNode.sectorId,
                    connectedSectorId,
                    faceId,
                    portalLinkId,
                    currentNode.depth,
                    false,
                    pGeometry == nullptr ? "missing_geometry" : "small_geometry");
                continue;
            }

            sharedBoundaryPortalPolygon.clear();
            const std::vector<bx::Vec3> *pVisibilityPortalPolygon = &pGeometry->vertices;
            bool usingSharedBoundaryPortalPolygon = false;

            if (buildSharedSectorBoundaryPortalPolygon(
                    mapData,
                    *pGeometry,
                    currentNode.sectorId,
                    connectedSectorId,
                    sharedBoundaryPortalPolygon))
            {
                pVisibilityPortalPolygon = &sharedBoundaryPortalPolygon;
                usingSharedBoundaryPortalPolygon = true;
            }
            else if (buildDegenerateVerticalPortalBoundaryPolygon(
                    mapData,
                    *pGeometry,
                    currentNode.sectorId,
                    connectedSectorId,
                    sharedBoundaryPortalPolygon))
            {
                pVisibilityPortalPolygon = &sharedBoundaryPortalPolygon;
                usingSharedBoundaryPortalPolygon = true;
            }

            const std::vector<bx::Vec3> &visibilityPortalPolygon = *pVisibilityPortalPolygon;
            const bool nearPortal = cameraNearPortal(input.cameraPosition, visibilityPortalPolygon);

            if (!nearPortal
                && portalPolygonBehindCamera(visibilityPortalPolygon, input.cameraPosition, input.cameraForward))
            {
                ++result.rejectedPortalCount;
                ++result.directionRejectedPortalCount;
                appendPortalTrace(
                    result,
                    input.collectPortalTraces,
                    currentNode.sectorId,
                    connectedSectorId,
                    faceId,
                    portalLinkId,
                    currentNode.depth,
                    false,
                    "behind_camera");
                continue;
            }

            const bool recoverDegenerateChildFrustum =
                currentNode.depth <= DegenerateChildFrustumRecoveryMaxDepth;
            std::vector<bx::Vec3> clippedPortal =
                nearPortal
                ? visibilityPortalPolygon
                : clipPolygonToFrustum(visibilityPortalPolygon, currentNode.frustumPlanes);
            bool recoveredClippedPortal = false;

            if (clippedPortal.size() < 3)
            {
                const float clippedPortalRecoverySlack =
                    usingSharedBoundaryPortalPolygon
                    ? SharedBoundaryClippedPortalRecoverySlack
                    : ClippedPortalRecoverySlack;
                if (!nearPortal
                    && (!usingSharedBoundaryPortalPolygon || currentNode.depth > 0)
                    && recoverDegenerateChildFrustum
                    && cameraNearPortal(input.cameraPosition, visibilityPortalPolygon, clippedPortalRecoverySlack))
                {
                    clippedPortal = visibilityPortalPolygon;
                    recoveredClippedPortal = true;
                }
                else
                {
                    ++result.rejectedPortalCount;
                    ++result.clippedPortalRejectedCount;
                    appendPortalTrace(
                        result,
                        input.collectPortalTraces,
                        currentNode.sectorId,
                        connectedSectorId,
                        faceId,
                        portalLinkId,
                        currentNode.depth,
                        false,
                        nearPortal
                            ? "near_portal_small"
                            : (usingSharedBoundaryPortalPolygon ? "clipped_shared_boundary" : "clipped_portal"));
                    continue;
                }
            }

            std::vector<IndoorVisibilityPlane> childFrustumPlanes;
            bool appendParentSectorFrustum = recoveredClippedPortal;
            if (std::fabs(pGeometry->normal.z) > 0.999f || nearPortal)
            {
                childFrustumPlanes = rootFrustumPlanes;
            }
            else
            {
                childFrustumPlanes = buildPortalFrustumPlanes(input.cameraPosition, clippedPortal);
                if (childFrustumPlanes.size() < 3 && recoverDegenerateChildFrustum)
                {
                    appendParentSectorFrustum = true;
                    childFrustumPlanes = buildPortalFrustumPlanes(input.cameraPosition, visibilityPortalPolygon);
                }
            }

            if (childFrustumPlanes.size() < 3)
            {
                if (recoverDegenerateChildFrustum)
                {
                    childFrustumPlanes = currentNode.frustumPlanes;
                    appendParentSectorFrustum = false;
                }
                else
                {
                    ++result.rejectedPortalCount;
                    ++result.clippedPortalRejectedCount;
                    appendPortalTrace(
                        result,
                        input.collectPortalTraces,
                        currentNode.sectorId,
                        connectedSectorId,
                        faceId,
                        portalLinkId,
                        currentNode.depth,
                        false,
                        "child_frustum_small");
                    continue;
                }
            }

            IndoorVisibilityNode childNode = {};
            childNode.sectorId = connectedSectorId;
            childNode.parentNodeIndex = static_cast<int16_t>(nodeIndex);
            childNode.entryPortalFaceId = static_cast<int16_t>(faceId);
            childNode.depth = static_cast<uint16_t>(currentNode.depth + 1);
            childNode.frustumPlanes = std::move(childFrustumPlanes);

            const uint16_t childNodeIndex = static_cast<uint16_t>(result.nodes.size());
            result.nodes.push_back(std::move(childNode));
            result.nodeIndicesBySector[static_cast<size_t>(connectedSectorId)].push_back(childNodeIndex);
            appendUniqueSectorFrustum(result, connectedSectorId, result.nodes.back().frustumPlanes);
            if (appendParentSectorFrustum)
            {
                appendUniqueSectorFrustum(result, connectedSectorId, currentNode.frustumPlanes);
            }
            result.visibleSectorMask[static_cast<size_t>(connectedSectorId)] = 1;
            appendAcceptedPortalVisibility(result, connectedSectorId, faceId);
            appendPortalTrace(
                result,
                input.collectPortalTraces,
                currentNode.sectorId,
                connectedSectorId,
                faceId,
                portalLinkId,
                currentNode.depth,
                true,
                "accepted");
            ++result.acceptedPortalCount;
        }
    }

    return result;
}
}
