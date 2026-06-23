#include "game/outdoor/OutdoorPathfindingBuilder.h"

#include "game/FaceEnums.h"
#include "game/maps/MapDeltaData.h"

#include <algorithm>
#include <cmath>
#include <limits>

namespace OpenYAMM::Game
{
namespace
{
constexpr size_t OutdoorTerrainCellWidth = OutdoorMapData::TerrainWidth - 1;
constexpr size_t OutdoorTerrainCellHeight = OutdoorMapData::TerrainHeight - 1;
constexpr size_t OutdoorTerrainSampleCount =
    static_cast<size_t>(OutdoorMapData::TerrainWidth) * static_cast<size_t>(OutdoorMapData::TerrainHeight);
constexpr size_t OutdoorBModelSourceFaceStride = 4096;
constexpr size_t OutdoorBModelSourceMaxBModelIndex =
    static_cast<size_t>((std::numeric_limits<int32_t>::max() - 1) / OutdoorBModelSourceFaceStride);

float terrainHeightAtSample(const OutdoorMapData &outdoorMapData, size_t gridX, size_t gridY)
{
    const size_t sampleIndex = gridY * static_cast<size_t>(OutdoorMapData::TerrainWidth) + gridX;
    return static_cast<float>(outdoorMapData.heightMap[sampleIndex])
        * static_cast<float>(OutdoorMapData::TerrainHeightScale);
}

bool outdoorTerrainDataIsUsable(const OutdoorMapData &outdoorMapData)
{
    return !outdoorMapData.noTerrain && outdoorMapData.heightMap.size() >= OutdoorTerrainSampleCount;
}

bool outdoorLandMaskCellIsWater(const std::vector<uint8_t> *pOutdoorLandMask, size_t gridX, size_t gridY)
{
    if (pOutdoorLandMask == nullptr || pOutdoorLandMask->empty())
    {
        return false;
    }

    const size_t tileIndex = gridY * OutdoorTerrainCellWidth + gridX;

    if (tileIndex >= pOutdoorLandMask->size())
    {
        return false;
    }

    return (*pOutdoorLandMask)[tileIndex] == 0;
}

bool terrainCellIsWater(
    const OutdoorMapData &outdoorMapData,
    const std::vector<uint8_t> *pOutdoorLandMask,
    size_t gridX,
    size_t gridY)
{
    const float centerX =
        (outdoorGridCornerWorldX(static_cast<int>(gridX))
            + outdoorGridCornerWorldX(static_cast<int>(gridX + 1))) * 0.5f;
    const float centerY =
        (outdoorGridCornerWorldY(static_cast<int>(gridY))
            + outdoorGridCornerWorldY(static_cast<int>(gridY + 1))) * 0.5f;
    return isOutdoorTerrainWater(outdoorMapData, centerX, centerY)
        || outdoorLandMaskCellIsWater(pOutdoorLandMask, gridX, gridY);
}

PathFacet buildTerrainTriangle(const PathPoint &a, const PathPoint &b, const PathPoint &c)
{
    PathFacet facet = {};
    facet.vertices = {a, b, c};
    facet.kind = PathFacetKind::Floor;
    facet.walkableFloor = true;
    facet.blocking = false;
    return facet;
}

PathFacetKind convertOutdoorPathFacetKind(const OutdoorFaceGeometryData &geometry, uint32_t attributes)
{
    if (hasFaceAttribute(attributes, FaceAttribute::IsPortal))
    {
        return PathFacetKind::Portal;
    }

    if (geometry.isWalkable)
    {
        return PathFacetKind::Floor;
    }

    if (std::fabs(geometry.normal.z) < 0.5f)
    {
        return PathFacetKind::Wall;
    }

    return PathFacetKind::Generic;
}

std::vector<size_t> bModelFaceOffsets(const OutdoorMapData &outdoorMapData)
{
    std::vector<size_t> offsets;
    offsets.reserve(outdoorMapData.bmodels.size());
    size_t flattenedFaceIndex = 0;

    for (const OutdoorBModel &bModel : outdoorMapData.bmodels)
    {
        offsets.push_back(flattenedFaceIndex);
        flattenedFaceIndex += bModel.faces.size();
    }

    return offsets;
}

uint32_t currentOutdoorFaceAttributes(
    const OutdoorFaceGeometryData &geometry,
    const OutdoorMapData &outdoorMapData,
    const MapDeltaData *pMapDeltaData,
    const std::vector<size_t> &faceOffsets)
{
    uint32_t attributes = geometry.attributes;

    if (pMapDeltaData == nullptr || geometry.bModelIndex >= faceOffsets.size())
    {
        return attributes;
    }

    const size_t flattenedFaceIndex = faceOffsets[geometry.bModelIndex] + geometry.faceIndex;

    if (flattenedFaceIndex >= pMapDeltaData->faceAttributes.size())
    {
        return attributes;
    }

    if (geometry.bModelIndex >= outdoorMapData.bmodels.size()
        || geometry.faceIndex >= outdoorMapData.bmodels[geometry.bModelIndex].faces.size())
    {
        return attributes;
    }

    return pMapDeltaData->faceAttributes[flattenedFaceIndex];
}

PathFacet buildBModelPathFacet(const OutdoorFaceGeometryData &geometry, uint32_t attributes)
{
    PathFacet facet = {};
    facet.kind = convertOutdoorPathFacetKind(geometry, attributes);
    facet.attributes.portal = hasFaceAttribute(attributes, FaceAttribute::IsPortal);
    facet.attributes.invisible = hasFaceAttribute(attributes, FaceAttribute::Invisible);
    facet.attributes.untouchable = hasFaceAttribute(attributes, FaceAttribute::Untouchable);
    facet.walkableFloor = geometry.isWalkable;
    facet.blocking = !facet.attributes.portal && !facet.attributes.untouchable;
    facet.sourceId = OutdoorPathfindingBuilder::bModelSourceId(geometry.bModelIndex, geometry.faceIndex);
    facet.vertices.reserve(geometry.vertices.size());

    for (const bx::Vec3 &vertex : geometry.vertices)
    {
        facet.vertices.push_back({vertex.x, vertex.y, vertex.z});
    }

    return facet;
}

void appendTerrainFacets(
    const OutdoorMapData &outdoorMapData,
    const std::vector<uint8_t> *pOutdoorLandMask,
    const OutdoorPathMapBuildOptions &options,
    OutdoorPathMapBuildResult &result,
    std::vector<PathFacet> &pathFacets)
{
    if (!options.includeTerrain || !outdoorTerrainDataIsUsable(outdoorMapData))
    {
        return;
    }

    pathFacets.reserve(pathFacets.size() + OutdoorTerrainCellWidth * OutdoorTerrainCellHeight * 2);

    for (size_t gridY = 0; gridY < OutdoorTerrainCellHeight; ++gridY)
    {
        for (size_t gridX = 0; gridX < OutdoorTerrainCellWidth; ++gridX)
        {
            if (options.terrainMode == OutdoorPathTerrainMode::LandOnly
                && terrainCellIsWater(outdoorMapData, pOutdoorLandMask, gridX, gridY))
            {
                result.skippedWaterTerrainTriangleCount += 2;
                continue;
            }

            const float x0 = outdoorGridCornerWorldX(static_cast<int>(gridX));
            const float x1 = outdoorGridCornerWorldX(static_cast<int>(gridX + 1));
            const float y0 = outdoorGridCornerWorldY(static_cast<int>(gridY));
            const float y1 = outdoorGridCornerWorldY(static_cast<int>(gridY + 1));
            const float z00 = terrainHeightAtSample(outdoorMapData, gridX, gridY);
            const float z10 = terrainHeightAtSample(outdoorMapData, gridX + 1, gridY);
            const float z01 = terrainHeightAtSample(outdoorMapData, gridX, gridY + 1);
            const float z11 = terrainHeightAtSample(outdoorMapData, gridX + 1, gridY + 1);
            const PathPoint p00 = {x0, y0, z00};
            const PathPoint p10 = {x1, y0, z10};
            const PathPoint p01 = {x0, y1, z01};
            const PathPoint p11 = {x1, y1, z11};

            pathFacets.push_back(buildTerrainTriangle(p00, p01, p10));
            pathFacets.push_back(buildTerrainTriangle(p11, p10, p01));
            result.terrainTriangleCount += 2;
        }
    }
}

void appendBModelFacetsFromGeometry(
    const OutdoorMapData &outdoorMapData,
    const MapDeltaData *pMapDeltaData,
    const std::vector<OutdoorFaceGeometryData> &faceGeometries,
    OutdoorPathMapBuildResult &result,
    std::vector<PathFacet> &pathFacets)
{
    const std::vector<size_t> faceOffsets = bModelFaceOffsets(outdoorMapData);
    result.sourceBModelFaceCount = faceGeometries.size();
    pathFacets.reserve(pathFacets.size() + faceGeometries.size());

    for (const OutdoorFaceGeometryData &geometry : faceGeometries)
    {
        if (!geometry.hasPlane || geometry.vertices.size() < 3)
        {
            ++result.skippedBModelFaceCount;
            continue;
        }

        const uint32_t attributes =
            currentOutdoorFaceAttributes(geometry, outdoorMapData, pMapDeltaData, faceOffsets);
        pathFacets.push_back(buildBModelPathFacet(geometry, attributes));
        ++result.bModelPathFacetCount;
    }
}

void appendBModelFacetsFromMapData(
    const OutdoorMapData &outdoorMapData,
    const MapDeltaData *pMapDeltaData,
    OutdoorPathMapBuildResult &result,
    std::vector<PathFacet> &pathFacets)
{
    const std::vector<size_t> faceOffsets = bModelFaceOffsets(outdoorMapData);
    size_t sourceFaceCount = 0;

    for (const OutdoorBModel &bModel : outdoorMapData.bmodels)
    {
        sourceFaceCount += bModel.faces.size();
    }

    result.sourceBModelFaceCount = sourceFaceCount;
    pathFacets.reserve(pathFacets.size() + sourceFaceCount);

    for (size_t bModelIndex = 0; bModelIndex < outdoorMapData.bmodels.size(); ++bModelIndex)
    {
        const OutdoorBModel &bModel = outdoorMapData.bmodels[bModelIndex];

        for (size_t faceIndex = 0; faceIndex < bModel.faces.size(); ++faceIndex)
        {
            OutdoorFaceGeometryData geometry = {};

            if (!buildOutdoorFaceGeometry(bModel, bModelIndex, bModel.faces[faceIndex], faceIndex, geometry, true))
            {
                ++result.skippedBModelFaceCount;
                continue;
            }

            const uint32_t attributes =
                currentOutdoorFaceAttributes(geometry, outdoorMapData, pMapDeltaData, faceOffsets);
            pathFacets.push_back(buildBModelPathFacet(geometry, attributes));
            ++result.bModelPathFacetCount;
        }
    }
}
}

OutdoorPathMapBuildResult OutdoorPathfindingBuilder::buildPathMap(
    const OutdoorMapData &outdoorMapData,
    const MapDeltaData *pMapDeltaData,
    const std::vector<OutdoorFaceGeometryData> *pFaceGeometries,
    const OutdoorPathMapBuildOptions &options,
    const std::vector<uint8_t> *pOutdoorLandMask)
{
    OutdoorPathMapBuildResult result = {};
    std::vector<PathFacet> pathFacets;

    appendTerrainFacets(outdoorMapData, pOutdoorLandMask, options, result, pathFacets);

    if (options.includeBModels)
    {
        if (pFaceGeometries != nullptr)
        {
            appendBModelFacetsFromGeometry(
                outdoorMapData,
                pMapDeltaData,
                *pFaceGeometries,
                result,
                pathFacets);
        }
        else
        {
            appendBModelFacetsFromMapData(outdoorMapData, pMapDeltaData, result, pathFacets);
        }
    }

    result.pathFacetCount = pathFacets.size();
    result.pathMap.setFacets(std::move(pathFacets));
    result.pathMap.buildSpatialGrid(options.spatialGridCellSize);
    return result;
}

int32_t OutdoorPathfindingBuilder::bModelSourceId(size_t bModelIndex, size_t faceIndex)
{
    if (bModelIndex > OutdoorBModelSourceMaxBModelIndex || faceIndex >= OutdoorBModelSourceFaceStride)
    {
        return -1;
    }

    return static_cast<int32_t>(1 + bModelIndex * OutdoorBModelSourceFaceStride + faceIndex);
}
}
