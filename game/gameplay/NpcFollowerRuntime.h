#pragma once

#include "game/events/EventRuntime.h"

#include <cstdint>
#include <string>
#include <vector>

namespace OpenYAMM::Game
{
class MergedNpcProfessionTable;
class NpcDialogTable;

struct HiredNpcFollowerView
{
    uint32_t npcId = 0;
    uint32_t professionId = 0;
    uint32_t weeklyCost = 0;
    uint32_t feePercent = 0;
    uint32_t portraitPictureId = 0;
    std::string name;
    std::string profession;
};

std::vector<HiredNpcFollowerView> buildHiredNpcFollowerViews(
    const EventRuntimeState &eventRuntimeState,
    const NpcDialogTable &npcDialogTable,
    const MergedNpcProfessionTable &npcProfessionTable
);

uint32_t totalHiredNpcFollowerFeePercent(const EventRuntimeState &eventRuntimeState);
uint32_t hiredNpcFollowerGoldShare(uint32_t goldAmount, const EventRuntimeState &eventRuntimeState);
bool hiredNpcHasProfession(const EventRuntimeState &eventRuntimeState, uint32_t professionId);
int hiredNpcTransportDayReduction(const EventRuntimeState &eventRuntimeState, bool stable);
}
