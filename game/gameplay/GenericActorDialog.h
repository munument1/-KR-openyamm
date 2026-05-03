#pragma once

#include "game/events/EventRuntime.h"

#include <cstdint>
#include <optional>
#include <string>

namespace OpenYAMM::Game
{
class NpcDialogTable;
class MmergeMonsterPortraitTable;
class MmergeNewsTopicTable;
struct MapStatsEntry;

struct GenericActorDialogResolution
{
    uint32_t npcId = 0;
    uint32_t newsId = 0;
    uint32_t portraitPictureId = 0;
};

std::optional<GenericActorDialogResolution> resolveGenericActorDialog(
    const std::string &mapFileName,
    const std::string &actorName,
    uint32_t actorGroup,
    const EventRuntimeState &runtimeState,
    const NpcDialogTable &npcDialogTable,
    const MmergeMonsterPortraitTable *pMonsterPortraitTable = nullptr,
    const MapStatsEntry *pCurrentMap = nullptr,
    const MmergeNewsTopicTable *pNewsAreaTopicTable = nullptr
);
}
