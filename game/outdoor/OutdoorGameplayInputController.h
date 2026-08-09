#pragma once

namespace OpenYAMM::Game
{
struct GameplayInputFrame;
struct GameplayWorldMovementFrameDiagnostics;
class OutdoorGameView;

class OutdoorGameplayInputController
{
public:
    static void updateCameraFromInput(
        OutdoorGameView &view,
        const GameplayInputFrame &input,
        float deltaSeconds,
        GameplayWorldMovementFrameDiagnostics *pPerformanceDiagnostics = nullptr);
};
} // namespace OpenYAMM::Game
