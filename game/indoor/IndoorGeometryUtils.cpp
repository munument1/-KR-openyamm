#include "game/indoor/IndoorGeometryUtils.h"

#include "game/FaceEnums.h"
#include "game/events/EvtEnums.h"
#include "game/indoor/IndoorPortalGraph.h"

#include <algorithm>
#include <array>
#include <cmath>
#include <limits>
#include <utility>

namespace OpenYAMM::Game
{
namespace
{
constexpr float GeometryEpsilon = 0.0001f;
constexpr float FloorSlack = 8.0f;
constexpr float FloorContainmentSlack = 3.0f;
constexpr float WalkableSlopeNormalZ = 0.68664550781f;
constexpr float InitialActorPlacementWallMinHeight = 50.0f;
constexpr float InitialActorPlacementFloorSlack = 1024.0f;
constexpr size_t MaxIndoorFaceVertexCount = 128;

struct ProjectedFacePoint
{
    float x = 0.0f;
    float y = 0.0f;
};

float calculateMechanismDistance(
    const MapDeltaDoor &door,
    const RuntimeMechanismState &runtimeMechanism
)
{
    if (runtimeMechanism.state == static_cast<uint16_t>(EvtMechanismState::Open))
    {
        return 0.0f;
    }

    if (runtimeMechanism.state == static_cast<uint16_t>(EvtMechanismState::Closing))
    {
        const float closingDistance =
            runtimeMechanism.timeSinceTriggeredMs * static_cast<float>(door.closeSpeed) / 1000.0f;
        return std::min(closingDistance, static_cast<float>(door.moveLength));
    }

    if (runtimeMechanism.state == static_cast<uint16_t>(EvtMechanismState::Opening))
    {
        const float openingDistance =
            runtimeMechanism.timeSinceTriggeredMs * static_cast<float>(door.openSpeed) / 1000.0f;
        return std::max(0.0f, static_cast<float>(door.moveLength) - openingDistance);
    }

    if (runtimeMechanism.state == static_cast<uint16_t>(EvtMechanismState::Closed) || (door.attributes & 0x2) != 0)
    {
        return static_cast<float>(door.moveLength);
    }

    return 0.0f;
}

bx::Vec3 vecSubtract(const bx::Vec3 &left, const bx::Vec3 &right)
{
    return {left.x - right.x, left.y - right.y, left.z - right.z};
}

float vecDot(const bx::Vec3 &left, const bx::Vec3 &right)
{
    return left.x * right.x + left.y * right.y + left.z * right.z;
}

float vecLength(const bx::Vec3 &value)
{
    return std::sqrt(vecDot(value, value));
}

bx::Vec3 vecNormalize(const bx::Vec3 &value)
{
    const float length = vecLength(value);

    if (length <= GeometryEpsilon)
    {
        return {0.0f, 0.0f, 0.0f};
    }

    return {value.x / length, value.y / length, value.z / length};
}

bx::Vec3 computeFaceNormal(const std::vector<IndoorVertex> &vertices, const IndoorFace &face)
{
    bx::Vec3 normal = {0.0f, 0.0f, 0.0f};

    if (face.vertexIndices.size() < 3)
    {
        return normal;
    }

    for (size_t index = 0; index < face.vertexIndices.size(); ++index)
    {
        const uint16_t currentVertexIndex = face.vertexIndices[index];
        const uint16_t nextVertexIndex = face.vertexIndices[(index + 1) % face.vertexIndices.size()];

        if (currentVertexIndex >= vertices.size() || nextVertexIndex >= vertices.size())
        {
            return {0.0f, 0.0f, 0.0f};
        }

        const IndoorVertex &currentVertex = vertices[currentVertexIndex];
        const IndoorVertex &nextVertex = vertices[nextVertexIndex];

        normal.x += (static_cast<float>(currentVertex.y) - static_cast<float>(nextVertex.y))
            * (static_cast<float>(currentVertex.z) + static_cast<float>(nextVertex.z));
        normal.y += (static_cast<float>(currentVertex.z) - static_cast<float>(nextVertex.z))
            * (static_cast<float>(currentVertex.x) + static_cast<float>(nextVertex.x));
        normal.z += (static_cast<float>(currentVertex.x) - static_cast<float>(nextVertex.x))
            * (static_cast<float>(currentVertex.y) + static_cast<float>(nextVertex.y));
    }

    return normal;
}

IndoorProjectionAxis chooseProjectionAxis(const bx::Vec3 &normal)
{
    const float absoluteX = std::fabs(normal.x);
    const float absoluteY = std::fabs(normal.y);
    const float absoluteZ = std::fabs(normal.z);

    if (absoluteX >= absoluteY && absoluteX >= absoluteZ)
    {
        return IndoorProjectionAxis::DropX;
    }

    if (absoluteY >= absoluteX && absoluteY >= absoluteZ)
    {
        return IndoorProjectionAxis::DropY;
    }

    return IndoorProjectionAxis::DropZ;
}

ProjectedFacePoint projectFacePoint(IndoorProjectionAxis projectionAxis, const bx::Vec3 &vertex)
{
    switch (projectionAxis)
    {
        case IndoorProjectionAxis::DropX:
            return {vertex.y, vertex.z};
        case IndoorProjectionAxis::DropY:
            return {vertex.x, vertex.z};
        case IndoorProjectionAxis::DropZ:
        default:
            return {vertex.x, vertex.y};
    }
}

float orient2d(const ProjectedFacePoint &a, const ProjectedFacePoint &b, const ProjectedFacePoint &c)
{
    return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
}

bool faceIsWalkable(const IndoorFace &face, const bx::Vec3 &normal)
{
    if (face.vertexIndices.size() < 3)
    {
        return false;
    }

    if (face.facetType == 3)
    {
        return normal.z > 0.0f;
    }

    if (face.facetType == 4)
    {
        return normal.z > WalkableSlopeNormalZ;
    }

    if (face.facetType == 5 || face.facetType == 6)
    {
        return false;
    }

    return normal.z > WalkableSlopeNormalZ;
}

bool faceCanDefineFloorHeight(const IndoorFaceGeometryData &geometry)
{
    return geometry.kind == IndoorFaceKind::Floor
        || (geometry.facetType == 4 && geometry.normal.z > GeometryEpsilon);
}

bool faceCanDefineCeilingHeight(const IndoorFaceGeometryData &geometry)
{
    return geometry.kind == IndoorFaceKind::Ceiling
        || (geometry.facetType == 6 && geometry.normal.z < -GeometryEpsilon);
}

bool faceIsSteepFloorCollisionSurface(const IndoorFaceGeometryData &geometry)
{
    if (geometry.normal.z <= 0.0f || geometry.normal.z >= WalkableSlopeNormalZ)
    {
        return false;
    }

    if (geometry.facetType == 4 && hasFaceAttribute(geometry.attributes, FaceAttribute::Invisible))
    {
        return false;
    }

    return geometry.facetType == 3 || geometry.facetType == 4 || geometry.kind == IndoorFaceKind::Floor;
}

bool faceBlocksInitialActorPlacement(const IndoorFaceGeometryData &geometry, float footZ)
{
    if (geometry.kind != IndoorFaceKind::Wall
        || geometry.isPortal
        || hasFaceAttribute(geometry.attributes, FaceAttribute::Untouchable)
        || geometry.maxZ <= footZ + InitialActorPlacementWallMinHeight)
    {
        return false;
    }

    return !faceIsSteepFloorCollisionSurface(geometry);
}

bool sectorBoundingBoxIntersectsProbe(const IndoorSector &sector, const bx::Vec3 &point)
{
    constexpr float ProbeHalfWidth = 5.0f;
    constexpr float ProbeHalfHeight = 64.0f;

    return point.x + ProbeHalfWidth >= sector.minX
        && point.x - ProbeHalfWidth <= sector.maxX
        && point.y + ProbeHalfWidth >= sector.minY
        && point.y - ProbeHalfWidth <= sector.maxY
        && point.z + ProbeHalfHeight >= sector.minZ
        && point.z - ProbeHalfHeight <= sector.maxZ;
}

IndoorFaceKind classifyFaceKind(const IndoorFace &face, const bx::Vec3 &normal)
{
    if (face.facetType == 1)
    {
        return IndoorFaceKind::Wall;
    }

    if (face.facetType == 3)
    {
        return IndoorFaceKind::Floor;
    }

    if (face.facetType == 4)
    {
        return normal.z > WalkableSlopeNormalZ ? IndoorFaceKind::Floor : IndoorFaceKind::Wall;
    }

    if (face.facetType == 5)
    {
        return IndoorFaceKind::Ceiling;
    }

    if (face.facetType == 6)
    {
        return normal.z < -WalkableSlopeNormalZ ? IndoorFaceKind::Ceiling : IndoorFaceKind::Wall;
    }

    if (normal.z > WalkableSlopeNormalZ)
    {
        return IndoorFaceKind::Floor;
    }

    if (normal.z < -WalkableSlopeNormalZ)
    {
        return IndoorFaceKind::Ceiling;
    }

    return IndoorFaceKind::Wall;
}

float faceCandidatePriority(
    int16_t sectorId,
    std::optional<int16_t> preferredSectorId
)
{
    if (!preferredSectorId)
    {
        return 0.0f;
    }

    return sectorId == *preferredSectorId ? 1000000.0f : 0.0f;
}

void appendConnectedIndoorSectors(
    const IndoorMapData &indoorMapData,
    int16_t sectorId,
    std::vector<int16_t> &sectorIds,
    std::vector<uint8_t> &visitedSectorMask
)
{
    if (sectorId < 0 || static_cast<size_t>(sectorId) >= indoorMapData.sectors.size())
    {
        return;
    }

    if (static_cast<size_t>(sectorId) >= visitedSectorMask.size() || visitedSectorMask[sectorId] != 0)
    {
        return;
    }

    visitedSectorMask[sectorId] = 1;
    sectorIds.push_back(sectorId);

    const IndoorSector &sector = indoorMapData.sectors[sectorId];

    auto appendConnectedSector = [&](uint16_t connectedSectorId)
    {
        if (connectedSectorId >= indoorMapData.sectors.size())
        {
            return;
        }

        if (visitedSectorMask[connectedSectorId] != 0)
        {
            return;
        }

        visitedSectorMask[connectedSectorId] = 1;
        sectorIds.push_back(static_cast<int16_t>(connectedSectorId));
    };

    for (uint16_t faceId : sector.portalFaceIds)
    {
        if (faceId >= indoorMapData.faces.size())
        {
            continue;
        }

        const IndoorFace &face = indoorMapData.faces[faceId];

        if (face.roomNumber == sectorId)
        {
            appendConnectedSector(face.roomBehindNumber);
        }
        else if (face.roomBehindNumber == sectorId)
        {
            appendConnectedSector(face.roomNumber);
        }
    }

    for (uint16_t faceId : sector.faceIds)
    {
        if (faceId >= indoorMapData.faces.size())
        {
            continue;
        }

        const IndoorFace &face = indoorMapData.faces[faceId];

        if (face.roomNumber == sectorId)
        {
            appendConnectedSector(face.roomBehindNumber);
        }
        else if (face.roomBehindNumber == sectorId)
        {
            appendConnectedSector(face.roomNumber);
        }
    }
}

bool isPointInsideProjectedPolygon(
    const ProjectedFacePoint &projectedPoint,
    const std::vector<IndoorProjectedFacePoint> &projectedVertices
)
{
    if (projectedVertices.size() < 3)
    {
        return false;
    }

    auto pointOnSegment = [&](const IndoorProjectedFacePoint &start, const IndoorProjectedFacePoint &end) -> bool
    {
        const float cross =
            (projectedPoint.x - start.x) * (end.y - start.y)
            - (projectedPoint.y - start.y) * (end.x - start.x);

        if (std::fabs(cross) > GeometryEpsilon)
        {
            return false;
        }

        const float minX = std::min(start.x, end.x) - GeometryEpsilon;
        const float maxX = std::max(start.x, end.x) + GeometryEpsilon;
        const float minY = std::min(start.y, end.y) - GeometryEpsilon;
        const float maxY = std::max(start.y, end.y) + GeometryEpsilon;
        return projectedPoint.x >= minX
            && projectedPoint.x <= maxX
            && projectedPoint.y >= minY
            && projectedPoint.y <= maxY;
    };

    bool inside = false;

    for (size_t index = 0; index < projectedVertices.size(); ++index)
    {
        const IndoorProjectedFacePoint &current = projectedVertices[index];
        const IndoorProjectedFacePoint &next = projectedVertices[(index + 1) % projectedVertices.size()];

        if (pointOnSegment(current, next))
        {
            return true;
        }

        const bool intersectsYAxis =
            (current.y > projectedPoint.y) != (next.y > projectedPoint.y);

        if (!intersectsYAxis)
        {
            continue;
        }

        const float edgeHeight = next.y - current.y;

        if (std::fabs(edgeHeight) <= GeometryEpsilon)
        {
            continue;
        }

        const float intersectionX =
            current.x + (projectedPoint.y - current.y) * (next.x - current.x) / edgeHeight;

        if (intersectionX >= projectedPoint.x - GeometryEpsilon)
        {
            inside = !inside;
        }
    }

    return inside;
}

bool isPointInsideFaceXYPolygon(const bx::Vec3 &point, const std::vector<bx::Vec3> &vertices)
{
    if (vertices.size() < 3)
    {
        return false;
    }

    auto pointOnSegment = [&](const bx::Vec3 &start, const bx::Vec3 &end) -> bool
    {
        const float cross =
            (point.x - start.x) * (end.y - start.y)
            - (point.y - start.y) * (end.x - start.x);

        const float minX = std::min(start.x, end.x) - GeometryEpsilon;
        const float maxX = std::max(start.x, end.x) + GeometryEpsilon;
        const float minY = std::min(start.y, end.y) - GeometryEpsilon;
        const float maxY = std::max(start.y, end.y) + GeometryEpsilon;

        if (std::fabs(cross) <= GeometryEpsilon
            && point.x >= minX
            && point.x <= maxX
            && point.y >= minY
            && point.y <= maxY)
        {
            return true;
        }

        const float segmentX = end.x - start.x;
        const float segmentY = end.y - start.y;
        const float segmentLengthSquared = segmentX * segmentX + segmentY * segmentY;

        if (segmentLengthSquared <= GeometryEpsilon)
        {
            const float deltaX = point.x - start.x;
            const float deltaY = point.y - start.y;
            return deltaX * deltaX + deltaY * deltaY <= FloorContainmentSlack * FloorContainmentSlack;
        }

        const float projected =
            ((point.x - start.x) * segmentX + (point.y - start.y) * segmentY) / segmentLengthSquared;
        const float clampedProjected = std::clamp(projected, 0.0f, 1.0f);
        const float closestX = start.x + segmentX * clampedProjected;
        const float closestY = start.y + segmentY * clampedProjected;
        const float deltaX = point.x - closestX;
        const float deltaY = point.y - closestY;
        return deltaX * deltaX + deltaY * deltaY <= FloorContainmentSlack * FloorContainmentSlack;
    };

    bool inside = false;

    for (size_t index = 0; index < vertices.size(); ++index)
    {
        const bx::Vec3 &current = vertices[index];
        const bx::Vec3 &next = vertices[(index + 1) % vertices.size()];

        if (pointOnSegment(current, next))
        {
            return true;
        }

        const bool intersectsYAxis = (current.y > point.y) != (next.y > point.y);

        if (!intersectsYAxis)
        {
            continue;
        }

        const float edgeHeight = next.y - current.y;

        if (std::fabs(edgeHeight) <= GeometryEpsilon)
        {
            continue;
        }

        const float intersectionX = current.x + (point.y - current.y) * (next.x - current.x) / edgeHeight;

        if (intersectionX >= point.x - GeometryEpsilon)
        {
            inside = !inside;
        }
    }

    return inside;
}

const IndoorFaceGeometryData *getIndoorFaceGeometry(
    const IndoorMapData &indoorMapData,
    const std::vector<IndoorVertex> &vertices,
    size_t faceIndex,
    IndoorFaceGeometryCache *pGeometryCache,
    IndoorFaceGeometryData &geometryStorage
)
{
    if (pGeometryCache != nullptr)
    {
        return pGeometryCache->geometryForFace(indoorMapData, vertices, faceIndex);
    }

    if (!buildIndoorFaceGeometry(indoorMapData, vertices, faceIndex, geometryStorage))
    {
        return nullptr;
    }

    return &geometryStorage;
}

IndoorFloorSample evaluateIndoorFloorFace(
    const IndoorMapData &indoorMapData,
    const std::vector<IndoorVertex> &vertices,
    size_t faceIndex,
    float x,
    float y,
    float z,
    float maxRise,
    float maxDrop,
    const std::vector<uint8_t> *pFaceExclusionMask,
    IndoorFaceGeometryCache *pGeometryCache
)
{
    if (pFaceExclusionMask != nullptr
        && faceIndex < pFaceExclusionMask->size()
        && (*pFaceExclusionMask)[faceIndex] != 0)
    {
        return {};
    }

    IndoorFaceGeometryData geometryStorage = {};
    const IndoorFaceGeometryData *pGeometry = getIndoorFaceGeometry(
        indoorMapData,
        vertices,
        faceIndex,
        pGeometryCache,
        geometryStorage);

    if (pGeometry == nullptr
        || pGeometry->isPortal
        || hasFaceAttribute(pGeometry->attributes, FaceAttribute::Untouchable)
        || !faceCanDefineFloorHeight(*pGeometry)
        || x < pGeometry->minX - FloorSlack
        || x > pGeometry->maxX + FloorSlack
        || y < pGeometry->minY - FloorSlack
        || y > pGeometry->maxY + FloorSlack)
    {
        return {};
    }

    const bx::Vec3 point = {x, y, pGeometry->vertices.front().z};

    if (!isPointInsideFaceXYPolygon(point, pGeometry->vertices))
    {
        return {};
    }

    const float height = calculateIndoorFaceHeight(*pGeometry, x, y);
    const float delta = height - z;

    if (delta > maxRise || delta < -maxDrop)
    {
        return {};
    }

    IndoorFloorSample sample = {};
    sample.hasFloor = true;
    sample.isWalkable = pGeometry->isWalkable;
    sample.height = height;
    sample.normalZ = pGeometry->normal.z;
    sample.sectorId = static_cast<int16_t>(pGeometry->sectorId);
    sample.faceIndex = faceIndex;
    return sample;
}
}

IndoorFaceGeometryCache::IndoorFaceGeometryCache(size_t faceCount)
{
    reset(faceCount);
}

namespace
{
float indoorDotProduct(const bx::Vec3 &left, const bx::Vec3 &right)
{
    return left.x * right.x + left.y * right.y + left.z * right.z;
}

bool indoorSegmentMayTouchFaceBounds(
    const bx::Vec3 &segmentStart,
    const bx::Vec3 &segmentEnd,
    const IndoorFaceGeometryData &geometry,
    float padding)
{
    return std::max(segmentStart.x, segmentEnd.x) + padding >= geometry.minX
        && std::min(segmentStart.x, segmentEnd.x) - padding <= geometry.maxX
        && std::max(segmentStart.y, segmentEnd.y) + padding >= geometry.minY
        && std::min(segmentStart.y, segmentEnd.y) - padding <= geometry.maxY
        && std::max(segmentStart.z, segmentEnd.z) + padding >= geometry.minZ
        && std::min(segmentStart.z, segmentEnd.z) - padding <= geometry.maxZ;
}

bool indoorPortalFacesRaySource(
    const IndoorFaceGeometryData &geometry,
    const bx::Vec3 &raySource,
    int16_t currentSectorId)
{
    if (geometry.vertices.empty() || indoorSectorBehindPortal(geometry, currentSectorId) < 0)
    {
        return false;
    }

    const bx::Vec3 planeDelta = {
        geometry.vertices.front().x - raySource.x,
        geometry.vertices.front().y - raySource.y,
        geometry.vertices.front().z - raySource.z
    };
    float facingDot = indoorDotProduct(geometry.normal, planeDelta);

    if (currentSectorId != static_cast<int16_t>(geometry.sectorId))
    {
        facingDot = -facingDot;
    }

    return facingDot < 0.0f;
}
}

int16_t indoorSectorBehindPortal(const IndoorFaceGeometryData &geometry, int16_t currentSectorId)
{
    if (geometry.sectorId == currentSectorId)
    {
        return static_cast<int16_t>(geometry.backSectorId);
    }

    if (geometry.backSectorId == currentSectorId)
    {
        return static_cast<int16_t>(geometry.sectorId);
    }

    return -1;
}

IndoorPortalSectorTrace traceIndoorLineThroughPortalSectors(
    const IndoorMapData &indoorMapData,
    const std::vector<IndoorVertex> &vertices,
    IndoorFaceGeometryCache &geometryCache,
    const bx::Vec3 &start,
    int16_t sourceSectorId,
    const bx::Vec3 &end,
    int16_t targetSectorId,
    int portalLimit)
{
    constexpr float PlaneEpsilon = 0.0001f;
    IndoorPortalSectorTrace trace = {};

    const auto appendSectorId = [&trace, &indoorMapData](int16_t sectorId)
    {
        if (sectorId < 0
            || static_cast<size_t>(sectorId) >= indoorMapData.sectors.size()
            || std::find(trace.sectorIds.begin(), trace.sectorIds.end(), sectorId) != trace.sectorIds.end())
        {
            return;
        }

        trace.sectorIds.push_back(sectorId);
    };

    if (sourceSectorId < 0
        || targetSectorId < 0
        || static_cast<size_t>(sourceSectorId) >= indoorMapData.sectors.size()
        || static_cast<size_t>(targetSectorId) >= indoorMapData.sectors.size())
    {
        return trace;
    }

    appendSectorId(sourceSectorId);

    if (sourceSectorId == targetSectorId)
    {
        trace.reachedTargetSector = true;
        return trace;
    }

    const bx::Vec3 segment = {end.x - start.x, end.y - start.y, end.z - start.z};
    int16_t currentSectorId = sourceSectorId;

    for (int portalStep = 0; portalStep < portalLimit; ++portalStep)
    {
        if (currentSectorId < 0 || static_cast<size_t>(currentSectorId) >= indoorMapData.sectors.size())
        {
            return trace;
        }

        const IndoorSector &sector = indoorMapData.sectors[currentSectorId];
        int16_t nextSectorId = -1;

        for (uint16_t faceId : sector.portalFaceIds)
        {
            const IndoorFaceGeometryData *pGeometry = geometryCache.geometryForFace(indoorMapData, vertices, faceId);

            if (pGeometry == nullptr
                || !pGeometry->hasPlane
                || !pGeometry->isPortal
                || !indoorPortalFacesRaySource(*pGeometry, start, currentSectorId)
                || !indoorSegmentMayTouchFaceBounds(start, end, *pGeometry, 0.0f))
            {
                continue;
            }

            const float denominator = indoorDotProduct(segment, pGeometry->normal);

            if (std::fabs(denominator) <= PlaneEpsilon)
            {
                continue;
            }

            const bx::Vec3 planeDelta = {
                pGeometry->vertices.front().x - start.x,
                pGeometry->vertices.front().y - start.y,
                pGeometry->vertices.front().z - start.z
            };
            const float progress = indoorDotProduct(planeDelta, pGeometry->normal) / denominator;

            if (progress < 0.0f || progress > 1.0f)
            {
                continue;
            }

            const bx::Vec3 portalPoint = {
                start.x + segment.x * progress,
                start.y + segment.y * progress,
                start.z + segment.z * progress
            };

            if (!isPointInsideIndoorPolygonProjected(portalPoint, pGeometry->vertices, pGeometry->normal))
            {
                continue;
            }

            nextSectorId = indoorSectorBehindPortal(*pGeometry, currentSectorId);
            break;
        }

        if (nextSectorId < 0 || nextSectorId == currentSectorId)
        {
            return trace;
        }

        appendSectorId(nextSectorId);

        if (nextSectorId == targetSectorId)
        {
            trace.reachedTargetSector = true;
            return trace;
        }

        currentSectorId = nextSectorId;
    }

    trace.reachedTargetSector = currentSectorId == targetSectorId;
    return trace;
}

std::vector<std::vector<uint16_t>> buildNeighboringIndoorSectorIds(const IndoorMapData &indoorMapData)
{
    const IndoorPortalGraph portalGraph = buildIndoorPortalGraph(indoorMapData);
    std::vector<std::vector<uint16_t>> sectorIds(indoorMapData.sectors.size());

    for (size_t sectorIndex = 0; sectorIndex < indoorMapData.sectors.size(); ++sectorIndex)
    {
        if (sectorIndex > std::numeric_limits<uint16_t>::max())
        {
            continue;
        }

        std::vector<uint16_t> &neighbors = sectorIds[sectorIndex];
        neighbors.reserve(portalGraph.sectors[sectorIndex].connectedSectorIds.size() + 1);
        neighbors.push_back(static_cast<uint16_t>(sectorIndex));

        for (uint16_t connectedSectorId : portalGraph.sectors[sectorIndex].connectedSectorIds)
        {
            neighbors.push_back(connectedSectorId);
        }
    }

    return sectorIds;
}

void IndoorFaceGeometryCache::reset(size_t faceCount)
{
    m_entryStates.assign(faceCount, 0);
    m_entries.resize(faceCount);
}

void IndoorFaceGeometryCache::invalidateFace(size_t faceIndex)
{
    if (faceIndex < m_entryStates.size())
    {
        m_entryStates[faceIndex] = 0;
    }
}

void IndoorFaceGeometryCache::setAttributeOverrides(const MapDeltaData *pMapDeltaData)
{
    const uint64_t attributeRevision = pMapDeltaData != nullptr ? pMapDeltaData->surfaceRevision : 0;

    if (m_pAttributeOverrides == pMapDeltaData && m_attributeRevision == attributeRevision)
    {
        return;
    }

    m_pAttributeOverrides = pMapDeltaData;
    m_attributeRevision = attributeRevision;
    std::fill(m_entryStates.begin(), m_entryStates.end(), 0);
}

const IndoorFaceGeometryData *IndoorFaceGeometryCache::geometryForFace(
    const IndoorMapData &indoorMapData,
    const std::vector<IndoorVertex> &vertices,
    size_t faceIndex
)
{
    if (faceIndex >= m_entryStates.size() || faceIndex >= m_entries.size())
    {
        return nullptr;
    }

    if (m_entryStates[faceIndex] == 0)
    {
        const bool valid =
            buildIndoorFaceGeometry(indoorMapData, vertices, faceIndex, m_entries[faceIndex], m_pAttributeOverrides);
        m_entryStates[faceIndex] = valid ? 2 : 1;
    }

    return m_entryStates[faceIndex] == 2 ? &m_entries[faceIndex] : nullptr;
}

float fixedIndoorDoorDirectionComponentToFloat(int value)
{
    return static_cast<float>(value) / 65536.0f;
}

bool indoorDoorCarriesPartySupport(const MapDeltaDoor &door)
{
    return door.directionZ != 0;
}

void applyIndoorMechanismDoorToVertices(
    const MapDeltaDoor &door,
    float distance,
    std::vector<IndoorVertex> &vertices
)
{
    const size_t movableVertexCount = std::min(
        door.vertexIds.size(),
        std::min(door.xOffsets.size(), std::min(door.yOffsets.size(), door.zOffsets.size()))
    );

    if (movableVertexCount == 0)
    {
        return;
    }

    const float directionX = fixedIndoorDoorDirectionComponentToFloat(door.directionX);
    const float directionY = fixedIndoorDoorDirectionComponentToFloat(door.directionY);
    const float directionZ = fixedIndoorDoorDirectionComponentToFloat(door.directionZ);

    for (size_t vertexOffsetIndex = 0; vertexOffsetIndex < movableVertexCount; ++vertexOffsetIndex)
    {
        const uint16_t vertexId = door.vertexIds[vertexOffsetIndex];

        if (vertexId >= vertices.size())
        {
            continue;
        }

        IndoorVertex &vertex = vertices[vertexId];
        vertex.x = static_cast<int>(std::lround(
            static_cast<float>(door.xOffsets[vertexOffsetIndex]) + directionX * distance));
        vertex.y = static_cast<int>(std::lround(
            static_cast<float>(door.yOffsets[vertexOffsetIndex]) + directionY * distance));
        vertex.z = static_cast<int>(std::lround(
            static_cast<float>(door.zOffsets[vertexOffsetIndex]) + directionZ * distance));
    }
}

std::vector<IndoorVertex> buildIndoorMechanismAdjustedVertices(
    const IndoorMapData &indoorMapData,
    const MapDeltaData *pIndoorMapDeltaData,
    const EventRuntimeState *pEventRuntimeState
)
{
    std::vector<IndoorVertex> vertices = indoorMapData.vertices;

    if (pIndoorMapDeltaData == nullptr)
    {
        return vertices;
    }

    for (const MapDeltaDoor &baseDoor : pIndoorMapDeltaData->doors)
    {
        MapDeltaDoor door = baseDoor;
        RuntimeMechanismState runtimeMechanism = {};
        runtimeMechanism.state = door.state;
        runtimeMechanism.timeSinceTriggeredMs = static_cast<float>(door.timeSinceTriggered);
        runtimeMechanism.currentDistance = calculateMechanismDistance(door, runtimeMechanism);
        runtimeMechanism.isMoving =
            door.state == static_cast<uint16_t>(EvtMechanismState::Opening)
            || door.state == static_cast<uint16_t>(EvtMechanismState::Closing);
        float distance = runtimeMechanism.currentDistance;

        if (pEventRuntimeState != nullptr)
        {
            const std::unordered_map<uint32_t, RuntimeMechanismState>::const_iterator mechanismIterator =
                pEventRuntimeState->mechanisms.find(door.doorId);

            if (mechanismIterator != pEventRuntimeState->mechanisms.end())
            {
                distance = mechanismIterator->second.currentDistance;
            }
        }

        applyIndoorMechanismDoorToVertices(door, distance, vertices);
    }

    return vertices;
}

bx::Vec3 indoorVertexToWorld(const IndoorVertex &vertex)
{
    return {
        static_cast<float>(vertex.x),
        static_cast<float>(vertex.y),
        static_cast<float>(vertex.z)
    };
}

bool buildIndoorFaceGeometry(
    const IndoorMapData &indoorMapData,
    const std::vector<IndoorVertex> &vertices,
    size_t faceIndex,
    IndoorFaceGeometryData &geometry,
    const MapDeltaData *pMapDeltaData
)
{
    if (faceIndex >= indoorMapData.faces.size())
    {
        return false;
    }

    const IndoorFace &face = indoorMapData.faces[faceIndex];
    const uint32_t attributes =
        pMapDeltaData != nullptr && faceIndex < pMapDeltaData->faceAttributes.size()
            ? pMapDeltaData->faceAttributes[faceIndex]
            : face.attributes;

    if (face.vertexIndices.size() < 3 || face.vertexIndices.size() > MaxIndoorFaceVertexCount)
    {
        return false;
    }

    IndoorFaceGeometryData rebuiltGeometry = {};
    rebuiltGeometry.faceIndex = faceIndex;
    rebuiltGeometry.attributes = attributes;
    rebuiltGeometry.sectorId = face.roomNumber;
    rebuiltGeometry.backSectorId = face.roomBehindNumber;
    rebuiltGeometry.facetType = face.facetType;
    rebuiltGeometry.isPortal = face.isPortal || hasFaceAttribute(attributes, FaceAttribute::IsPortal);
    rebuiltGeometry.vertices.reserve(face.vertexIndices.size());
    rebuiltGeometry.projectedVertices.reserve(face.vertexIndices.size());

    for (uint16_t vertexIndex : face.vertexIndices)
    {
        if (vertexIndex >= vertices.size())
        {
            return false;
        }

        rebuiltGeometry.vertices.push_back(indoorVertexToWorld(vertices[vertexIndex]));
    }

    rebuiltGeometry.minX = rebuiltGeometry.maxX = rebuiltGeometry.vertices[0].x;
    rebuiltGeometry.minY = rebuiltGeometry.maxY = rebuiltGeometry.vertices[0].y;
    rebuiltGeometry.minZ = rebuiltGeometry.maxZ = rebuiltGeometry.vertices[0].z;

    for (const bx::Vec3 &vertex : rebuiltGeometry.vertices)
    {
        rebuiltGeometry.minX = std::min(rebuiltGeometry.minX, vertex.x);
        rebuiltGeometry.maxX = std::max(rebuiltGeometry.maxX, vertex.x);
        rebuiltGeometry.minY = std::min(rebuiltGeometry.minY, vertex.y);
        rebuiltGeometry.maxY = std::max(rebuiltGeometry.maxY, vertex.y);
        rebuiltGeometry.minZ = std::min(rebuiltGeometry.minZ, vertex.z);
        rebuiltGeometry.maxZ = std::max(rebuiltGeometry.maxZ, vertex.z);
    }

    rebuiltGeometry.normal = vecNormalize(computeFaceNormal(vertices, face));
    rebuiltGeometry.projectionAxis = chooseProjectionAxis(rebuiltGeometry.normal);
    rebuiltGeometry.hasPlane = vecLength(rebuiltGeometry.normal) > GeometryEpsilon;
    rebuiltGeometry.kind = classifyFaceKind(face, rebuiltGeometry.normal);
    rebuiltGeometry.isWalkable =
        !hasFaceAttribute(attributes, FaceAttribute::Untouchable) && faceIsWalkable(face, rebuiltGeometry.normal);

    for (const bx::Vec3 &vertex : rebuiltGeometry.vertices)
    {
        const ProjectedFacePoint projected = projectFacePoint(rebuiltGeometry.projectionAxis, vertex);
        rebuiltGeometry.projectedVertices.push_back({projected.x, projected.y});
    }

    geometry = std::move(rebuiltGeometry);
    return true;
}

bool isPointInsideIndoorPolygonProjected(
    const bx::Vec3 &point,
    const std::vector<bx::Vec3> &vertices,
    const bx::Vec3 &normal
)
{
    if (vertices.size() < 3)
    {
        return false;
    }

    std::vector<ProjectedFacePoint> projectedVertices;
    projectedVertices.reserve(vertices.size());
    const IndoorProjectionAxis projectionAxis = chooseProjectionAxis(normal);

    for (const bx::Vec3 &vertex : vertices)
    {
        projectedVertices.push_back(projectFacePoint(projectionAxis, vertex));
    }

    const ProjectedFacePoint projectedPoint = projectFacePoint(projectionAxis, point);
    float sign = 0.0f;

    for (size_t index = 0; index < projectedVertices.size(); ++index)
    {
        const ProjectedFacePoint &current = projectedVertices[index];
        const ProjectedFacePoint &next = projectedVertices[(index + 1) % projectedVertices.size()];
        const float orientation = orient2d(current, next, projectedPoint);

        if (std::fabs(orientation) <= GeometryEpsilon)
        {
            continue;
        }

        if (sign == 0.0f)
        {
            sign = orientation;
            continue;
        }

        if ((sign > 0.0f && orientation < -GeometryEpsilon)
            || (sign < 0.0f && orientation > GeometryEpsilon))
        {
            return false;
        }
    }

    return true;
}

float calculateIndoorFaceHeight(const IndoorFaceGeometryData &geometry, float x, float y)
{
    if (!geometry.hasPlane || std::fabs(geometry.normal.z) <= GeometryEpsilon || geometry.vertices.empty())
    {
        return geometry.vertices.empty() ? 0.0f : geometry.vertices.front().z;
    }

    return geometry.vertices.front().z
        - (geometry.normal.x * (x - geometry.vertices.front().x)
           + geometry.normal.y * (y - geometry.vertices.front().y))
            / geometry.normal.z;
}

bool isIndoorCylinderBlockedByFace(
    const IndoorFaceGeometryData &geometry,
    float x,
    float y,
    float z,
    float radius,
    float height
)
{
    if (!geometry.hasPlane || geometry.vertices.empty())
    {
        return false;
    }

    if ((x + radius) < geometry.minX
        || (x - radius) > geometry.maxX
        || (y + radius) < geometry.minY
        || (y - radius) > geometry.maxY
        || (z + height) < geometry.minZ
        || z > geometry.maxZ)
    {
        return false;
    }

    const bx::Vec3 center = {
        x,
        y,
        z + std::min(height * 0.5f, std::max(radius, 1.0f))
    };
    const bx::Vec3 pointDelta = vecSubtract(center, geometry.vertices.front());
    const float signedDistance = vecDot(pointDelta, geometry.normal);

    if (std::abs(signedDistance) > radius)
    {
        return false;
    }

    const bx::Vec3 projectedPoint = {
        center.x - geometry.normal.x * signedDistance,
        center.y - geometry.normal.y * signedDistance,
        center.z - geometry.normal.z * signedDistance
    };
    const ProjectedFacePoint projectedFacePoint = projectFacePoint(geometry.projectionAxis, projectedPoint);
    return isPointInsideProjectedPolygon(projectedFacePoint, geometry.projectedVertices);
}

bool indoorActorPlacementOverlapsBlockingWall(
    const IndoorMapData &indoorMapData,
    const std::vector<IndoorVertex> &vertices,
    IndoorFaceGeometryCache &geometryCache,
    float x,
    float y,
    float z,
    float radius,
    float height,
    int16_t sectorId)
{
    const auto testFace = [&](uint16_t faceId) -> bool
    {
        const IndoorFaceGeometryData *pGeometry = geometryCache.geometryForFace(indoorMapData, vertices, faceId);

        if (pGeometry == nullptr || !faceBlocksInitialActorPlacement(*pGeometry, z))
        {
            return false;
        }

        return isIndoorCylinderBlockedByFace(*pGeometry, x, y, z, radius, height);
    };

    if (sectorId >= 0 && static_cast<size_t>(sectorId) < indoorMapData.sectors.size())
    {
        const IndoorSector &sector = indoorMapData.sectors[sectorId];

        for (uint16_t faceId : sector.faceIds)
        {
            if (testFace(faceId))
            {
                return true;
            }
        }

        return false;
    }

    for (size_t faceIndex = 0; faceIndex < indoorMapData.faces.size(); ++faceIndex)
    {
        if (faceIndex <= static_cast<size_t>(std::numeric_limits<uint16_t>::max())
            && testFace(static_cast<uint16_t>(faceIndex)))
        {
            return true;
        }
    }

    return false;
}

IndoorInitialActorPlacement resolveIndoorInitialActorPlacement(
    const IndoorMapData &indoorMapData,
    const std::vector<IndoorVertex> &vertices,
    IndoorFaceGeometryCache &geometryCache,
    float x,
    float y,
    float z,
    float radius,
    float height,
    bool canFly,
    float maxRise,
    float maxDrop)
{
    IndoorInitialActorPlacement result = {};
    result.x = x;
    result.y = y;
    result.z = z;

    if (vertices.empty())
    {
        return result;
    }

    const IndoorFloorSample floorSample =
        sampleIndoorFloor(
            indoorMapData,
            vertices,
            x,
            y,
            z + radius,
            maxRise,
            maxDrop,
            std::nullopt,
            nullptr,
            &geometryCache);

    if (!floorSample.hasFloor)
    {
        return result;
    }

    result.hasFloor = true;
    result.sectorId = floorSample.sectorId;

    if (!canFly || z <= floorSample.height + 1.0f)
    {
        result.z = floorSample.height;
    }

    if (!indoorActorPlacementOverlapsBlockingWall(
            indoorMapData,
            vertices,
            geometryCache,
            result.x,
            result.y,
            result.z,
            radius,
            height,
            result.sectorId))
    {
        return result;
    }

    constexpr std::array<float, 6> SearchRadii = {{8.0f, 16.0f, 32.0f, 48.0f, 64.0f, 96.0f}};
    constexpr int SearchAngles = 16;
    constexpr float TwoPi = 6.28318530717958647692f;

    for (float searchRadius : SearchRadii)
    {
        for (int angleIndex = 0; angleIndex < SearchAngles; ++angleIndex)
        {
            const float angle = TwoPi * static_cast<float>(angleIndex) / static_cast<float>(SearchAngles);
            const float candidateX = x + std::cos(angle) * searchRadius;
            const float candidateY = y + std::sin(angle) * searchRadius;
            const IndoorFloorSample candidateFloor =
                sampleIndoorFloor(
                    indoorMapData,
                    vertices,
                    candidateX,
                    candidateY,
                    z + radius,
                    maxRise,
                    maxDrop,
                    result.sectorId,
                    nullptr,
                    &geometryCache);

            if (!candidateFloor.hasFloor
                || candidateFloor.sectorId != result.sectorId
                || std::fabs(candidateFloor.height - floorSample.height) > InitialActorPlacementFloorSlack)
            {
                continue;
            }

            float candidateZ = z;

            if (!canFly || z <= candidateFloor.height + 1.0f)
            {
                candidateZ = candidateFloor.height;
            }

            if (indoorActorPlacementOverlapsBlockingWall(
                    indoorMapData,
                    vertices,
                    geometryCache,
                    candidateX,
                    candidateY,
                    candidateZ,
                    radius,
                    height,
                    candidateFloor.sectorId))
            {
                continue;
            }

            result.x = candidateX;
            result.y = candidateY;
            result.z = candidateZ;
            result.sectorId = candidateFloor.sectorId;
            result.movedHorizontally = true;
            result.wallOverlapResolved = true;
            return result;
        }
    }

    return result;
}

IndoorFloorSample sampleIndoorFloor(
    const IndoorMapData &indoorMapData,
    const std::vector<IndoorVertex> &vertices,
    float x,
    float y,
    float z,
    float maxRise,
    float maxDrop,
    std::optional<int16_t> preferredSectorId,
    const std::vector<uint8_t> *pFaceExclusionMask,
    IndoorFaceGeometryCache *pGeometryCache
)
{
    IndoorFloorSample bestSample = {};
    float bestScore = -std::numeric_limits<float>::infinity();

    auto evaluateFloorFaces = [&](const std::vector<uint16_t> &faceIds)
    {
        for (uint16_t faceId : faceIds)
        {
            const IndoorFloorSample candidate = evaluateIndoorFloorFace(
                indoorMapData,
                vertices,
                faceId,
                x,
                y,
                z,
                maxRise,
                maxDrop,
                pFaceExclusionMask,
                pGeometryCache);

            if (!candidate.hasFloor)
            {
                continue;
            }

            const float score = faceCandidatePriority(candidate.sectorId, preferredSectorId)
                - std::fabs(candidate.height - z);

            if (!bestSample.hasFloor || score > bestScore)
            {
                bestSample = candidate;
                bestScore = score;
            }
        }
    };

    auto evaluateSectorFloorFaces = [&](int16_t sectorId) -> bool
    {
        if (sectorId < 0 || static_cast<size_t>(sectorId) >= indoorMapData.sectors.size())
        {
            return false;
        }

        const IndoorSector &sector = indoorMapData.sectors[sectorId];
        evaluateFloorFaces(sector.floorFaceIds);

        if ((sector.flags & 0x8) != 0)
        {
            evaluateFloorFaces(sector.portalFaceIds);
        }

        return bestSample.hasFloor;
    };

    if (preferredSectorId
        && *preferredSectorId >= 0
        && static_cast<size_t>(*preferredSectorId) < indoorMapData.sectors.size())
    {
        if (evaluateSectorFloorFaces(*preferredSectorId))
        {
            return bestSample;
        }
    }

    const std::optional<int16_t> resolvedSectorId =
        findIndoorSectorForPoint(indoorMapData, vertices, {x, y, z}, pGeometryCache);

    if (resolvedSectorId
        && (!preferredSectorId || *resolvedSectorId != *preferredSectorId))
    {
        if (evaluateSectorFloorFaces(*resolvedSectorId))
        {
            return bestSample;
        }
    }

    return bestSample;
}

IndoorFloorSample sampleIndoorFloorOnFace(
    const IndoorMapData &indoorMapData,
    const std::vector<IndoorVertex> &vertices,
    size_t faceIndex,
    float x,
    float y,
    float z,
    float maxRise,
    float maxDrop,
    const std::vector<uint8_t> *pFaceExclusionMask,
    IndoorFaceGeometryCache *pGeometryCache
)
{
    return evaluateIndoorFloorFace(
        indoorMapData,
        vertices,
        faceIndex,
        x,
        y,
        z,
        maxRise,
        maxDrop,
        pFaceExclusionMask,
        pGeometryCache);
}

IndoorCeilingSample sampleIndoorCeiling(
    const IndoorMapData &indoorMapData,
    const std::vector<IndoorVertex> &vertices,
    float x,
    float y,
    float z,
    std::optional<int16_t> preferredSectorId,
    const std::vector<uint8_t> *pFaceExclusionMask,
    IndoorFaceGeometryCache *pGeometryCache
)
{
    IndoorCeilingSample bestSample = {};
    float bestHeight = std::numeric_limits<float>::max();

    auto evaluateCeilingFaces = [&](const std::vector<uint16_t> &faceIds)
    {
        for (uint16_t faceId : faceIds)
        {
            if (pFaceExclusionMask != nullptr
                && faceId < pFaceExclusionMask->size()
                && (*pFaceExclusionMask)[faceId] != 0)
            {
                continue;
            }

            IndoorFaceGeometryData geometryStorage = {};
            const IndoorFaceGeometryData *pGeometry = getIndoorFaceGeometry(
                indoorMapData,
                vertices,
                faceId,
                pGeometryCache,
                geometryStorage);

            if (pGeometry == nullptr
                || hasFaceAttribute(pGeometry->attributes, FaceAttribute::Untouchable)
                || !faceCanDefineCeilingHeight(*pGeometry)
                || x < pGeometry->minX - FloorSlack
                || x > pGeometry->maxX + FloorSlack
                || y < pGeometry->minY - FloorSlack
                || y > pGeometry->maxY + FloorSlack)
            {
                continue;
            }

            const bx::Vec3 point = {x, y, pGeometry->vertices.front().z};

            if (!isPointInsideFaceXYPolygon(point, pGeometry->vertices))
            {
                continue;
            }

            const float height = calculateIndoorFaceHeight(*pGeometry, x, y);

            if (height + FloorSlack < z)
            {
                continue;
            }

            if (!bestSample.hasCeiling
                || height < bestHeight
                || (std::fabs(height - bestHeight) <= GeometryEpsilon
                    && pGeometry->sectorId == static_cast<uint16_t>(preferredSectorId.value_or(-1))))
            {
                bestSample.hasCeiling = true;
                bestSample.height = height;
                bestSample.sectorId = static_cast<int16_t>(pGeometry->sectorId);
                bestSample.faceIndex = faceId;
                bestHeight = height;
            }
        }
    };

    auto evaluateSectorCeilingFaces = [&](int16_t sectorId) -> bool
    {
        if (sectorId < 0 || static_cast<size_t>(sectorId) >= indoorMapData.sectors.size())
        {
            return false;
        }

        evaluateCeilingFaces(indoorMapData.sectors[sectorId].ceilingFaceIds);
        return bestSample.hasCeiling;
    };

    if (preferredSectorId
        && *preferredSectorId >= 0
        && static_cast<size_t>(*preferredSectorId) < indoorMapData.sectors.size())
    {
        if (evaluateSectorCeilingFaces(*preferredSectorId))
        {
            return bestSample;
        }
    }

    const std::optional<int16_t> resolvedSectorId =
        findIndoorSectorForPoint(indoorMapData, vertices, {x, y, z}, pGeometryCache);

    if (resolvedSectorId
        && (!preferredSectorId || *resolvedSectorId != *preferredSectorId))
    {
        if (evaluateSectorCeilingFaces(*resolvedSectorId))
        {
            return bestSample;
        }
    }

    return bestSample;
}

std::optional<int16_t> findIndoorSectorForPoint(
    const IndoorMapData &indoorMapData,
    const std::vector<IndoorVertex> &vertices,
    const bx::Vec3 &point,
    IndoorFaceGeometryCache *pGeometryCache,
    bool allowBoundingSectorFallback
)
{
    if (indoorMapData.sectors.empty())
    {
        return std::nullopt;
    }

    struct SectorFaceCandidate
    {
        int16_t sectorId = -1;
        float height = 0.0f;
    };

    std::vector<SectorFaceCandidate> candidates;
    candidates.reserve(5);
    std::optional<int16_t> backupBoundingSectorId;
    std::optional<int16_t> singleSectorId;
    bool singleSector = true;
    const size_t startingSectorIndex = indoorMapData.sectors.size() > 1 ? 1 : 0;

    auto appendSectorCandidate = [&](int16_t sectorId, float height)
    {
        if (candidates.size() >= 5)
        {
            return;
        }

        candidates.push_back({sectorId, height});
    };

    for (size_t sectorIndex = startingSectorIndex; sectorIndex < indoorMapData.sectors.size(); ++sectorIndex)
    {
        const IndoorSector &sector = indoorMapData.sectors[sectorIndex];

        if (!sectorBoundingBoxIntersectsProbe(sector, point))
        {
            continue;
        }

        if (!backupBoundingSectorId)
        {
            backupBoundingSectorId = static_cast<int16_t>(sectorIndex);
        }

        if (sector.floorFaceIds.empty() && sector.portalFaceIds.empty())
        {
            continue;
        }

        if (!singleSectorId)
        {
            singleSectorId = static_cast<int16_t>(sectorIndex);
        }
        else if (*singleSectorId != static_cast<int16_t>(sectorIndex))
        {
            singleSector = false;
        }

        const auto evaluateSectorFaces = [&](const std::vector<uint16_t> &faceIds)
        {
            for (uint16_t faceId : faceIds)
            {
                IndoorFaceGeometryData geometryStorage = {};
                const IndoorFaceGeometryData *pGeometry = getIndoorFaceGeometry(
                    indoorMapData,
                    vertices,
                    faceId,
                    pGeometryCache,
                    geometryStorage);

                if (pGeometry == nullptr
                    || hasFaceAttribute(pGeometry->attributes, FaceAttribute::Untouchable)
                    || !faceCanDefineFloorHeight(*pGeometry)
                    || point.x < pGeometry->minX - FloorSlack
                    || point.x > pGeometry->maxX + FloorSlack
                    || point.y < pGeometry->minY - FloorSlack
                    || point.y > pGeometry->maxY + FloorSlack)
                {
                    continue;
                }

                if (!isPointInsideFaceXYPolygon(point, pGeometry->vertices))
                {
                    continue;
                }

                appendSectorCandidate(static_cast<int16_t>(sectorIndex), calculateIndoorFaceHeight(*pGeometry, point.x, point.y));

                if (candidates.size() >= 5)
                {
                    return;
                }
            }
        };

        evaluateSectorFaces(sector.floorFaceIds);

        if ((sector.flags & 0x8) != 0 && candidates.size() < 5)
        {
            evaluateSectorFaces(sector.portalFaceIds);
        }

        if (candidates.size() >= 5)
        {
            break;
        }
    }

    if (candidates.size() == 1)
    {
        return candidates.front().sectorId;
    }

    if (singleSectorId && singleSector && !candidates.empty())
    {
        return *singleSectorId;
    }

    if (candidates.empty())
    {
        if (!allowBoundingSectorFallback)
        {
            return std::nullopt;
        }

        return backupBoundingSectorId;
    }

    std::optional<int16_t> bestBelowSectorId;
    std::optional<int16_t> bestAboveSectorId;
    float bestBelowDistance = std::numeric_limits<float>::max();
    float bestAboveDistance = std::numeric_limits<float>::max();

    for (const SectorFaceCandidate &candidate : candidates)
    {
        const float zDistance = point.z - candidate.height;

        if (zDistance >= 0.0f)
        {
            if (zDistance < bestBelowDistance)
            {
                bestBelowDistance = zDistance;
                bestBelowSectorId = candidate.sectorId;
            }
        }
        else
        {
            const float aboveDistance = std::fabs(zDistance);

            if (aboveDistance < bestAboveDistance)
            {
                bestAboveDistance = aboveDistance;
                bestAboveSectorId = candidate.sectorId;
            }
        }
    }

    if (bestBelowSectorId)
    {
        return bestBelowSectorId;
    }

    return bestAboveSectorId;
}
}
