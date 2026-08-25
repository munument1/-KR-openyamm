#pragma once

#include "engine/ApplicationConfig.h"

#include <cstdint>
#include <filesystem>
#include <string>
#include <vector>

namespace OpenYAMM::Game
{
class HeadlessGameplayDiagnostics
{
public:
    explicit HeadlessGameplayDiagnostics(const Engine::ApplicationConfig &config);

    int runOpenEvent(
        const std::filesystem::path &basePath,
        const std::string &mapFileName,
        uint16_t eventId,
        float advanceSeconds = 0.0f
    ) const;
    int runOpenActor(
        const std::filesystem::path &basePath,
        const std::string &mapFileName,
        size_t actorIndex
    ) const;
    int runDialogSequence(
        const std::filesystem::path &basePath,
        const std::string &mapFileName,
        uint16_t eventId,
        const std::vector<size_t> &actionIndices
    ) const;
    int runRegressionSuite(
        const std::filesystem::path &basePath,
        const std::string &suiteName
    ) const;
    int runProfileFullMapLoad(
        const std::filesystem::path &basePath,
        const std::string &mapFileName
    ) const;
    int runDumpOutdoorNavigation(
        const std::filesystem::path &basePath,
        const std::string &mapFileName
    ) const;
    int runVerifyOutdoorWorldItemFloor(
        const std::filesystem::path &basePath,
        const std::string &mapFileName
    ) const;
    int runVerifyOutdoorSaveRoundtrip(
        const std::filesystem::path &basePath,
        const std::string &mapFileName,
        uint16_t chestEventId,
        uint16_t mechanismEventId
    ) const;
    int runVerifyOutdoorMechanismPassage(
        const std::filesystem::path &basePath,
        const std::string &mapFileName,
        uint32_t mechanismId
    ) const;
    int runVerifyMm9PositionedTransition(
        const std::filesystem::path &basePath,
        const std::string &mapFileName,
        uint32_t sourceObjectIndex
    ) const;
    int runSimulateActor(
        const std::filesystem::path &basePath,
        const std::string &mapFileName,
        size_t actorIndex,
        int stepCount,
        float deltaSeconds,
        float partyOffsetX,
        uint16_t preEventId = 0
    ) const;
    int runTraceActorAi(
        const std::filesystem::path &basePath,
        const std::string &mapFileName,
        size_t actorIndex,
        int stepCount,
        float deltaSeconds,
        float partyOffsetX
    ) const;
    int runInspectActorPreview(
        const std::filesystem::path &basePath,
        const std::string &mapFileName,
        size_t actorIndex
    ) const;
    int runDumpActorSupport(
        const std::filesystem::path &basePath,
        const std::string &mapFileName,
        size_t actorIndex
    ) const;
    int runDumpActorPreviewTexture(
        const std::filesystem::path &basePath,
        const std::string &mapFileName,
        size_t actorIndex,
        const std::filesystem::path &outputPath
    ) const;
    int runCaptureProjectileFx(
        const std::filesystem::path &basePath,
        const std::filesystem::path &outputDirectory
    ) const;

private:
    Engine::ApplicationConfig m_config;
};
}
