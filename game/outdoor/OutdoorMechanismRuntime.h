#pragma once

#include "game/events/EventRuntime.h"
#include "game/outdoor/OutdoorGeometryUtils.h"

#include <cstddef>
#include <optional>

namespace OpenYAMM::Game
{
struct OutdoorBModelRuntimeTransformState
{
    OutdoorBModelTransform transform = {};
    float fraction = 0.0f;
};

float outdoorMechanismOpenFraction(
    const RuntimeMechanismState &mechanism,
    const EventRuntimeState::OutdoorModelMechanismDefinition &definition);
void queueOutdoorMechanismMovementAudio(
    EventRuntimeState &runtimeState,
    uint32_t mechanismId,
    const EventRuntimeState::OutdoorModelMechanismDefinition &definition,
    uint16_t previousState,
    bool wasMoving,
    const RuntimeMechanismState &mechanism);
void queueOutdoorMechanismCompletionAudio(
    EventRuntimeState &runtimeState,
    uint32_t mechanismId,
    const EventRuntimeState::OutdoorModelMechanismDefinition &definition,
    const RuntimeMechanismState &mechanism);
void queueOutdoorMechanismAudioStop(EventRuntimeState &runtimeState, uint32_t mechanismId);
std::optional<uint16_t> outdoorBModelRuntimeInteractionEventId(
    const EventRuntimeState *pEventRuntimeState,
    size_t bModelIndex);
int8_t outdoorMechanismOpenAwayRotationDirection(
    const EventRuntimeState::OutdoorModelMechanismDefinition &definition,
    const bx::Vec3 &closedCenter,
    const bx::Vec3 &activatorPosition);
std::optional<OutdoorBModelRuntimeTransformState> outdoorBModelRuntimeTransform(
    const EventRuntimeState *pEventRuntimeState,
    size_t bModelIndex);
bx::Vec3 applyOutdoorBModelRuntimeTransform(
    const std::optional<OutdoorBModelRuntimeTransformState> &runtimeTransform,
    const bx::Vec3 &point);
OutdoorBModel transformOutdoorBModelForRuntime(
    const OutdoorBModel &bmodel,
    const EventRuntimeState *pEventRuntimeState,
    size_t bModelIndex);
}
