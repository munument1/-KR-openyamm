#include "game/pathfinding/PathMap.h"

#include <algorithm>
#include <array>
#include <cmath>
#include <limits>
#include <utility>

namespace OpenYAMM::Game
{
namespace
{
constexpr float PathEpsilon = 0.0001f;

PathPoint pointAdd(const PathPoint &left, const PathPoint &right)
{
    return {left.x + right.x, left.y + right.y, left.z + right.z};
}

PathPoint pointSubtract(const PathPoint &left, const PathPoint &right)
{
    return {left.x - right.x, left.y - right.y, left.z - right.z};
}

PathPoint pointScale(const PathPoint &point, float scale)
{
    return {point.x * scale, point.y * scale, point.z * scale};
}

float pointDot(const PathPoint &left, const PathPoint &right)
{
    return left.x * right.x + left.y * right.y + left.z * right.z;
}

PathPoint pointCross(const PathPoint &left, const PathPoint &right)
{
    return {
        left.y * right.z - left.z * right.y,
        left.z * right.x - left.x * right.z,
        left.x * right.y - left.y * right.x
    };
}

float pointLengthSquared(const PathPoint &point)
{
    return pointDot(point, point);
}

float pointLength(const PathPoint &point)
{
    return std::sqrt(pointLengthSquared(point));
}

PathPoint pointNormalize(const PathPoint &point)
{
    const float length = pointLength(point);

    if (length <= PathEpsilon)
    {
        return {};
    }

    return {point.x / length, point.y / length, point.z / length};
}

float xyDistance(const PathPoint &from, const PathPoint &to)
{
    const float dx = to.x - from.x;
    const float dy = to.y - from.y;
    return std::sqrt(dx * dx + dy * dy);
}

PathPoint interpolatePoint(const PathPoint &from, const PathPoint &to, float t)
{
    return {
        from.x + (to.x - from.x) * t,
        from.y + (to.y - from.y) * t,
        from.z + (to.z - from.z) * t
    };
}

PathBounds facetBounds(const PathFacet &facet)
{
    PathBounds bounds = {};

    if (facet.vertices.empty())
    {
        return bounds;
    }

    bounds.minX = facet.vertices.front().x;
    bounds.maxX = facet.vertices.front().x;
    bounds.minY = facet.vertices.front().y;
    bounds.maxY = facet.vertices.front().y;
    bounds.minZ = facet.vertices.front().z;
    bounds.maxZ = facet.vertices.front().z;

    for (const PathPoint &vertex : facet.vertices)
    {
        bounds.minX = std::min(bounds.minX, vertex.x);
        bounds.maxX = std::max(bounds.maxX, vertex.x);
        bounds.minY = std::min(bounds.minY, vertex.y);
        bounds.maxY = std::max(bounds.maxY, vertex.y);
        bounds.minZ = std::min(bounds.minZ, vertex.z);
        bounds.maxZ = std::max(bounds.maxZ, vertex.z);
    }

    return bounds;
}

PathBounds segmentBounds(const PathPoint &from, const PathPoint &to, float padding)
{
    PathBounds bounds = {};
    bounds.minX = std::min(from.x, to.x) - padding;
    bounds.maxX = std::max(from.x, to.x) + padding;
    bounds.minY = std::min(from.y, to.y) - padding;
    bounds.maxY = std::max(from.y, to.y) + padding;
    bounds.minZ = std::min(from.z, to.z) - padding;
    bounds.maxZ = std::max(from.z, to.z) + padding;
    return bounds;
}

bool boundsOverlap(const PathBounds &left, const PathBounds &right)
{
    return left.maxX + PathEpsilon >= right.minX
        && left.minX - PathEpsilon <= right.maxX
        && left.maxY + PathEpsilon >= right.minY
        && left.minY - PathEpsilon <= right.maxY
        && left.maxZ + PathEpsilon >= right.minZ
        && left.minZ - PathEpsilon <= right.maxZ;
}

PathPoint computeFacetNormal(const PathFacet &facet)
{
    if (facet.vertices.size() < 3)
    {
        return {};
    }

    const PathPoint &origin = facet.vertices.front();

    for (size_t index = 1; index + 1 < facet.vertices.size(); ++index)
    {
        const PathPoint edgeA = pointSubtract(facet.vertices[index], origin);
        const PathPoint edgeB = pointSubtract(facet.vertices[index + 1], origin);
        const PathPoint normal = pointNormalize(pointCross(edgeA, edgeB));

        if (pointLengthSquared(normal) > PathEpsilon)
        {
            return normal;
        }
    }

    return {};
}

int dominantAxisToDrop(const PathPoint &normal)
{
    const float absX = std::fabs(normal.x);
    const float absY = std::fabs(normal.y);
    const float absZ = std::fabs(normal.z);

    if (absX >= absY && absX >= absZ)
    {
        return 0;
    }

    if (absY >= absZ)
    {
        return 1;
    }

    return 2;
}

void projectPoint(const PathPoint &point, int dropAxis, float &outX, float &outY)
{
    if (dropAxis == 0)
    {
        outX = point.y;
        outY = point.z;
        return;
    }

    if (dropAxis == 1)
    {
        outX = point.x;
        outY = point.z;
        return;
    }

    outX = point.x;
    outY = point.y;
}

bool projectedPointOnSegment(float px, float py, float ax, float ay, float bx, float by)
{
    const float cross = (px - ax) * (by - ay) - (py - ay) * (bx - ax);

    if (std::fabs(cross) > PathEpsilon)
    {
        return false;
    }

    return px >= std::min(ax, bx) - PathEpsilon
        && px <= std::max(ax, bx) + PathEpsilon
        && py >= std::min(ay, by) - PathEpsilon
        && py <= std::max(ay, by) + PathEpsilon;
}

bool pointInsideFacet(const PathPoint &point, const PathFacet &facet, const PathPoint &normal)
{
    if (facet.vertices.size() < 3)
    {
        return false;
    }

    const int dropAxis = dominantAxisToDrop(normal);
    float px = 0.0f;
    float py = 0.0f;
    projectPoint(point, dropAxis, px, py);

    bool inside = false;

    for (size_t index = 0; index < facet.vertices.size(); ++index)
    {
        const PathPoint &current = facet.vertices[index];
        const PathPoint &next = facet.vertices[(index + 1) % facet.vertices.size()];
        float currentX = 0.0f;
        float currentY = 0.0f;
        float nextX = 0.0f;
        float nextY = 0.0f;
        projectPoint(current, dropAxis, currentX, currentY);
        projectPoint(next, dropAxis, nextX, nextY);

        if (projectedPointOnSegment(px, py, currentX, currentY, nextX, nextY))
        {
            return true;
        }

        if ((currentY > py) == (nextY > py))
        {
            continue;
        }

        const float intersectionX = (nextX - currentX) * (py - currentY) / (nextY - currentY) + currentX;

        if (px < intersectionX)
        {
            inside = !inside;
        }
    }

    return inside;
}

bool segmentIntersectsFacet(
    const PathPoint &from,
    const PathPoint &to,
    const PathFacet &facet,
    const PathPoint &normal,
    PathPoint &outPoint
)
{
    if (facet.vertices.size() < 3 || pointLengthSquared(normal) <= PathEpsilon)
    {
        return false;
    }

    const PathPoint segment = pointSubtract(to, from);
    const float denominator = pointDot(normal, segment);

    if (std::fabs(denominator) <= PathEpsilon)
    {
        return false;
    }

    const float t = pointDot(normal, pointSubtract(facet.vertices.front(), from)) / denominator;

    if (t < -PathEpsilon || t > 1.0f + PathEpsilon)
    {
        return false;
    }

    outPoint = interpolatePoint(from, to, std::clamp(t, 0.0f, 1.0f));
    return pointInsideFacet(outPoint, facet, normal);
}

bool facetIsNonBlocking(const PathFacet &facet)
{
    return !facet.blocking
        || facet.attributes.portal
        || facet.kind == PathFacetKind::Portal
        || (facet.attributes.invisible && facet.attributes.untouchable);
}
}

void PathMap::clear()
{
    m_facets.clear();
    m_geometry.clear();
    m_floorFacetIndices.clear();
    m_spatialGrid.clear();
    m_floorGrid.clear();
    ++m_revision;
}

void PathMap::setFacets(std::vector<PathFacet> facets)
{
    m_facets = std::move(facets);
    rebuildGeometry();
    ++m_revision;
}

size_t PathMap::addFacet(const PathFacet &facet)
{
    m_facets.push_back(facet);
    rebuildGeometry();
    ++m_revision;
    return m_facets.size() - 1;
}

void PathMap::buildSpatialGrid(float cellSize)
{
    m_gridCellSize = std::max(0.0f, cellSize);
    rebuildSpatialGrid();
}

const std::vector<PathFacet> &PathMap::facets() const
{
    return m_facets;
}

size_t PathMap::revision() const
{
    return m_revision;
}

PathFloorSample PathMap::floorAt(const PathPoint &position) const
{
    PathFloorSample bestBelow = {};
    float bestBelowDistance = std::numeric_limits<float>::max();
    PathFloorSample bestAbove = {};
    float bestAboveDistance = std::numeric_limits<float>::max();

    const std::vector<size_t> candidates = candidateFloorFacetsForPoint(position.x, position.y);

    for (size_t index : candidates)
    {
        const PathFacet &facet = m_facets[index];
        const FacetGeometry &geometry = m_geometry[index];

        if (!facet.walkableFloor || !geometry.valid || std::fabs(geometry.normal.z) <= PathEpsilon)
        {
            continue;
        }

        if (position.x < geometry.bounds.minX - PathEpsilon
            || position.x > geometry.bounds.maxX + PathEpsilon
            || position.y < geometry.bounds.minY - PathEpsilon
            || position.y > geometry.bounds.maxY + PathEpsilon)
        {
            continue;
        }

        const float z =
            facet.vertices.front().z
            - (geometry.normal.x * (position.x - facet.vertices.front().x)
                + geometry.normal.y * (position.y - facet.vertices.front().y)) / geometry.normal.z;
        const PathPoint floorPoint = {position.x, position.y, z};

        if (!pointInsideFacet(floorPoint, facet, geometry.normal))
        {
            continue;
        }

        if (z <= position.z + PathEpsilon)
        {
            const float distance = position.z - z;

            if (distance < bestBelowDistance)
            {
                bestBelowDistance = distance;
                bestBelow.hasFloor = true;
                bestBelow.inVoid = false;
                bestBelow.z = z;
                bestBelow.normalZ = geometry.normal.z;
                bestBelow.facetIndex = index;
            }
        }
        else
        {
            const float distance = z - position.z;

            if (distance < bestAboveDistance)
            {
                bestAboveDistance = distance;
                bestAbove.hasFloor = true;
                bestAbove.inVoid = true;
                bestAbove.z = z;
                bestAbove.normalZ = geometry.normal.z;
                bestAbove.facetIndex = index;
            }
        }
    }

    if (bestBelow.hasFloor)
    {
        return bestBelow;
    }

    if (bestAbove.hasFloor)
    {
        return bestAbove;
    }

    PathFloorSample voidSample = {};
    voidSample.inVoid = true;
    return voidSample;
}

PathTraceResult PathMap::traceLine(
    const PathPoint &from,
    const PathPoint &to,
    float radius,
    bool checkBody
) const
{
    std::array<std::pair<PathPoint, PathPoint>, 3> traces = {};
    size_t traceCount = 1;
    traces[0] = {from, to};

    const float xyLength = xyDistance(from, to);

    if (checkBody && radius > PathEpsilon && xyLength > PathEpsilon)
    {
        const float sideX = -(to.y - from.y) / xyLength * radius;
        const float sideY = (to.x - from.x) / xyLength * radius;
        const PathPoint sideOffset = {sideX, sideY, 0.0f};
        traces[traceCount++] = {pointAdd(from, sideOffset), pointAdd(to, sideOffset)};
        traces[traceCount++] = {pointSubtract(from, sideOffset), pointSubtract(to, sideOffset)};
    }

    PathTraceResult result = {};

    for (size_t traceIndex = 0; traceIndex < traceCount; ++traceIndex)
    {
        const std::pair<PathPoint, PathPoint> &trace = traces[traceIndex];
        const PathBounds bounds = segmentBounds(trace.first, trace.second, radius);
        const std::vector<size_t> candidates = candidateFacetsForBounds(bounds);

        for (size_t facetIndex : candidates)
        {
            const PathFacet &facet = m_facets[facetIndex];
            const FacetGeometry &geometry = m_geometry[facetIndex];

            if (!geometry.valid || geometry.nonBlocking || !boundsOverlap(bounds, geometry.bounds))
            {
                continue;
            }

            PathPoint hitPoint = {};

            if (segmentIntersectsFacet(trace.first, trace.second, facet, geometry.normal, hitPoint))
            {
                result.blocked = true;
                result.facetIndex = facetIndex;
                result.point = hitPoint;
                return result;
            }
        }
    }

    return result;
}

bool PathMap::traceWalkSegment(const PathPoint &from, const PathPoint &to, const PathObject &object) const
{
    const float distance = xyDistance(from, to);
    const float sampleStep = std::max(24.0f, object.stepLength);
    const size_t sampleCount = std::max<size_t>(1, static_cast<size_t>(std::ceil(distance / sampleStep)));
    const float stepHeight = std::max(0.0f, object.stepHeight);

    PathPoint previousPoint = from;
    PathFloorSample previousFloor = floorAt({from.x, from.y, from.z + stepHeight});

    if (!previousFloor.hasFloor || previousFloor.inVoid)
    {
        return false;
    }

    for (size_t sampleIndex = 1; sampleIndex <= sampleCount; ++sampleIndex)
    {
        const float t = static_cast<float>(sampleIndex) / static_cast<float>(sampleCount);
        const PathPoint probe = interpolatePoint(from, to, t);
        const PathFloorSample floor = floorAt({probe.x, probe.y, previousFloor.z + stepHeight + PathEpsilon});

        if (!floor.hasFloor || floor.inVoid)
        {
            return false;
        }

        if (std::fabs(floor.z - previousFloor.z) > stepHeight + PathEpsilon)
        {
            return false;
        }

        const PathPoint segmentFrom = {previousPoint.x, previousPoint.y, previousFloor.z + object.radius};
        const PathPoint segmentTo = {probe.x, probe.y, floor.z + object.radius};

        if (traceLine(segmentFrom, segmentTo, object.radius, true).blocked)
        {
            return false;
        }

        previousPoint = probe;
        previousFloor = floor;
    }

    return true;
}

bool PathMap::canReachDirectly(const PathPoint &from, const PathPoint &to, const PathObject &object) const
{
    if (object.canFly)
    {
        return !traceLine(from, to, object.radius, true).blocked;
    }

    return traceWalkSegment(from, to, object);
}

std::vector<size_t> PathMap::candidateFacetsForBounds(const PathBounds &bounds) const
{
    struct CandidateScratch
    {
        std::vector<uint32_t> marks;
        uint32_t markId = 0;
        std::vector<size_t> candidates;
    };

    thread_local CandidateScratch scratch;

    if (m_gridCellSize <= PathEpsilon || m_spatialGrid.empty())
    {
        std::vector<size_t> candidates;
        candidates.reserve(m_facets.size());

        for (size_t index = 0; index < m_geometry.size(); ++index)
        {
            if (boundsOverlap(bounds, m_geometry[index].bounds))
            {
                candidates.push_back(index);
            }
        }

        return candidates;
    }

    if (scratch.marks.size() != m_geometry.size())
    {
        scratch.marks.assign(m_geometry.size(), 0u);
        scratch.markId = 0;
    }

    ++scratch.markId;

    if (scratch.markId == 0)
    {
        std::fill(scratch.marks.begin(), scratch.marks.end(), 0u);
        ++scratch.markId;
    }

    scratch.candidates.clear();
    const int32_t minCellX = gridCoordinate(bounds.minX);
    const int32_t maxCellX = gridCoordinate(bounds.maxX);
    const int32_t minCellY = gridCoordinate(bounds.minY);
    const int32_t maxCellY = gridCoordinate(bounds.maxY);
    const int32_t minCellZ = gridCoordinate(bounds.minZ);
    const int32_t maxCellZ = gridCoordinate(bounds.maxZ);

    for (int32_t cellX = minCellX; cellX <= maxCellX; ++cellX)
    {
        for (int32_t cellY = minCellY; cellY <= maxCellY; ++cellY)
        {
            for (int32_t cellZ = minCellZ; cellZ <= maxCellZ; ++cellZ)
            {
                const auto cellIt = m_spatialGrid.find({cellX, cellY, cellZ});

                if (cellIt == m_spatialGrid.end())
                {
                    continue;
                }

                for (size_t facetIndex : cellIt->second)
                {
                    if (boundsOverlap(bounds, m_geometry[facetIndex].bounds))
                    {
                        if (facetIndex < scratch.marks.size() && scratch.marks[facetIndex] != scratch.markId)
                        {
                            scratch.marks[facetIndex] = scratch.markId;
                            scratch.candidates.push_back(facetIndex);
                        }
                    }
                }
            }
        }
    }

    return scratch.candidates;
}

std::vector<size_t> PathMap::candidateFloorFacetsForPoint(float x, float y) const
{
    if (m_gridCellSize <= PathEpsilon || m_floorGrid.empty())
    {
        return m_floorFacetIndices;
    }

    const auto cellIt = m_floorGrid.find({gridCoordinate(x), gridCoordinate(y)});

    if (cellIt == m_floorGrid.end())
    {
        return {};
    }

    return cellIt->second;
}

void PathMap::rebuildGeometry()
{
    m_geometry.clear();
    m_floorFacetIndices.clear();
    m_geometry.reserve(m_facets.size());
    m_floorFacetIndices.reserve(m_facets.size());

    for (size_t index = 0; index < m_facets.size(); ++index)
    {
        const PathFacet &facet = m_facets[index];
        FacetGeometry geometry = {};
        geometry.bounds = facetBounds(facet);
        geometry.normal = computeFacetNormal(facet);
        geometry.valid = facet.vertices.size() >= 3 && pointLengthSquared(geometry.normal) > PathEpsilon;
        geometry.nonBlocking = facetIsNonBlocking(facet);

        if (facet.walkableFloor && geometry.valid)
        {
            m_floorFacetIndices.push_back(index);
        }

        m_geometry.push_back(geometry);
    }
    rebuildSpatialGrid();
}

void PathMap::rebuildSpatialGrid()
{
    m_spatialGrid.clear();
    m_floorGrid.clear();

    if (m_gridCellSize <= PathEpsilon || m_geometry.empty())
    {
        return;
    }

    for (size_t index = 0; index < m_geometry.size(); ++index)
    {
        const FacetGeometry &geometry = m_geometry[index];

        if (!geometry.valid)
        {
            continue;
        }

        const int32_t minCellX = gridCoordinate(geometry.bounds.minX);
        const int32_t maxCellX = gridCoordinate(geometry.bounds.maxX);
        const int32_t minCellY = gridCoordinate(geometry.bounds.minY);
        const int32_t maxCellY = gridCoordinate(geometry.bounds.maxY);
        const int32_t minCellZ = gridCoordinate(geometry.bounds.minZ);
        const int32_t maxCellZ = gridCoordinate(geometry.bounds.maxZ);

        for (int32_t cellX = minCellX; cellX <= maxCellX; ++cellX)
        {
            for (int32_t cellY = minCellY; cellY <= maxCellY; ++cellY)
            {
                for (int32_t cellZ = minCellZ; cellZ <= maxCellZ; ++cellZ)
                {
                    m_spatialGrid[{cellX, cellY, cellZ}].push_back(index);
                }
            }
        }

        if (!m_facets[index].walkableFloor)
        {
            continue;
        }

        for (int32_t cellX = minCellX; cellX <= maxCellX; ++cellX)
        {
            for (int32_t cellY = minCellY; cellY <= maxCellY; ++cellY)
            {
                m_floorGrid[{cellX, cellY}].push_back(index);
            }
        }
    }
}

int32_t PathMap::gridCoordinate(float value) const
{
    return static_cast<int32_t>(std::floor(value / m_gridCellSize));
}

bool PathMap::GridCellKey::operator==(const GridCellKey &other) const
{
    return x == other.x && y == other.y && z == other.z;
}

size_t PathMap::GridCellKeyHash::operator()(const GridCellKey &key) const
{
    const uint32_t x = static_cast<uint32_t>(key.x) * 73856093u;
    const uint32_t y = static_cast<uint32_t>(key.y) * 19349663u;
    const uint32_t z = static_cast<uint32_t>(key.z) * 83492791u;
    return static_cast<size_t>(x ^ y ^ z);
}

bool PathMap::FloorCellKey::operator==(const FloorCellKey &other) const
{
    return x == other.x && y == other.y;
}

size_t PathMap::FloorCellKeyHash::operator()(const FloorCellKey &key) const
{
    const uint32_t x = static_cast<uint32_t>(key.x) * 73856093u;
    const uint32_t y = static_cast<uint32_t>(key.y) * 19349663u;
    return static_cast<size_t>(x ^ y);
}
}
