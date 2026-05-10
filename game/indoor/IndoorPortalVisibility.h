#pragma once

#include "game/indoor/IndoorMapData.h"

#include <bx/math.h>

#include <cstdint>
#include <optional>
#include <string>
#include <vector>

namespace OpenYAMM::Game
{
struct EventRuntimeState;
struct IndoorPortalGraph;
struct MapDeltaData;

struct IndoorVisibilityPlane
{
    bx::Vec3 normal = {0.0f, 0.0f, 0.0f};
    float distance = 0.0f;
};

using IndoorVisibilityFrustum = std::vector<IndoorVisibilityPlane>;

struct IndoorVisibilityNode
{
    int16_t sectorId = -1;
    int16_t parentNodeIndex = -1;
    int16_t entryPortalFaceId = -1;
    uint16_t depth = 0;
    IndoorVisibilityFrustum frustumPlanes;
};

struct IndoorPortalVisibilityTrace
{
    int16_t sourceSectorId = -1;
    int16_t targetSectorId = -1;
    uint16_t faceId = 0;
    uint16_t portalLinkId = 0;
    uint16_t depth = 0;
    bool accepted = false;
    std::string reason;
};

struct IndoorPortalVisibilityInput
{
    const IndoorMapData *pMapData = nullptr;
    const IndoorPortalGraph *pPortalGraph = nullptr;
    const std::vector<IndoorVertex> *pVertices = nullptr;
    const std::vector<IndoorVertex> *pPortalVertices = nullptr;
    const MapDeltaData *pMapDeltaData = nullptr;
    const std::optional<EventRuntimeState> *pEventRuntimeState = nullptr;
    bx::Vec3 cameraPosition = {0.0f, 0.0f, 0.0f};
    bx::Vec3 cameraForward = {1.0f, 0.0f, 0.0f};
    bx::Vec3 cameraUp = {0.0f, 0.0f, 1.0f};
    float verticalFovDegrees = 60.0f;
    float aspectRatio = 1.0f;
    int16_t startSectorId = -1;
    uint16_t maxNodes = 256;
    uint16_t maxDepth = 32;
};

struct IndoorPortalVisibilityResult
{
    std::vector<uint8_t> visibleSectorMask;
    std::vector<IndoorVisibilityNode> nodes;
    std::vector<std::vector<uint16_t>> nodeIndicesBySector;
    std::vector<std::vector<IndoorVisibilityFrustum>> frustumsBySector;
    std::vector<IndoorPortalVisibilityTrace> portalTraces;
    uint32_t portalCandidateCount = 0;
    uint32_t acceptedPortalCount = 0;
    uint32_t rejectedPortalCount = 0;
    uint32_t invalidPortalCount = 0;
    uint32_t ancestorRejectedPortalCount = 0;
    uint32_t directionRejectedPortalCount = 0;
    uint32_t clippedPortalRejectedCount = 0;
    uint32_t orphanVisibleSectorCount = 0;
    bool maxNodeLimitHit = false;
};

IndoorPortalVisibilityResult buildIndoorPortalVisibility(const IndoorPortalVisibilityInput &input);
}
