#pragma once

#include "game/pathfinding/PathfindingTypes.h"

#include <cstddef>
#include <cstdint>
#include <unordered_map>
#include <vector>

namespace OpenYAMM::Game
{
struct PathTraceResult
{
    bool blocked = false;
    size_t facetIndex = 0;
    PathPoint point;
};

class PathMap
{
public:
    void clear();
    void setFacets(std::vector<PathFacet> facets);
    size_t addFacet(const PathFacet &facet);
    void buildSpatialGrid(float cellSize);

    const std::vector<PathFacet> &facets() const;
    size_t revision() const;

    PathFloorSample floorAt(const PathPoint &position) const;
    PathTraceResult traceLine(
        const PathPoint &from,
        const PathPoint &to,
        float radius = 0.0f,
        bool checkBody = false
    ) const;
    bool traceWalkSegment(const PathPoint &from, const PathPoint &to, const PathObject &object) const;
    bool canReachDirectly(const PathPoint &from, const PathPoint &to, const PathObject &object) const;

private:
    struct FacetGeometry
    {
        PathBounds bounds;
        PathPoint normal;
        bool valid = false;
        bool nonBlocking = false;
    };

    struct GridCellKey
    {
        int32_t x = 0;
        int32_t y = 0;
        int32_t z = 0;

        bool operator==(const GridCellKey &other) const;
    };

    struct GridCellKeyHash
    {
        size_t operator()(const GridCellKey &key) const;
    };

    struct FloorCellKey
    {
        int32_t x = 0;
        int32_t y = 0;

        bool operator==(const FloorCellKey &other) const;
    };

    struct FloorCellKeyHash
    {
        size_t operator()(const FloorCellKey &key) const;
    };

    std::vector<size_t> candidateFacetsForBounds(const PathBounds &bounds) const;
    std::vector<size_t> candidateFloorFacetsForPoint(float x, float y) const;
    void rebuildGeometry();
    void rebuildSpatialGrid();
    int32_t gridCoordinate(float value) const;

    std::vector<PathFacet> m_facets;
    std::vector<FacetGeometry> m_geometry;
    std::vector<size_t> m_floorFacetIndices;
    std::unordered_map<GridCellKey, std::vector<size_t>, GridCellKeyHash> m_spatialGrid;
    std::unordered_map<FloorCellKey, std::vector<size_t>, FloorCellKeyHash> m_floorGrid;
    size_t m_revision = 0;
    float m_gridCellSize = 0.0f;
};
}
