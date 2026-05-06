#include "game/gameplay/NpcFollowerRuntime.h"

#include "game/tables/MergedBaseTables.h"
#include "game/tables/NpcDialogTable.h"

#include <algorithm>
#include <utility>

namespace OpenYAMM::Game
{
namespace
{
constexpr uint32_t SailorProfessionId = 8;
constexpr uint32_t NavigatorProfessionId = 9;
constexpr uint32_t HorsemanProfessionId = 35;
constexpr uint32_t ExplorerProfessionId = 44;
constexpr uint32_t PirateProfessionId = 45;

NpcEntry resolvedNpcEntry(
    const EventRuntimeState &eventRuntimeState,
    const NpcDialogTable &npcDialogTable,
    uint32_t npcId)
{
    NpcEntry npc = {};
    const NpcEntry *pBaseNpc = npcDialogTable.getNpc(npcId);

    if (pBaseNpc != nullptr)
    {
        npc = *pBaseNpc;
    }
    else
    {
        npc.id = npcId;
    }

    const std::unordered_map<uint32_t, std::string>::const_iterator nameIt =
        eventRuntimeState.npcNameOverrides.find(npcId);

    if (nameIt != eventRuntimeState.npcNameOverrides.end())
    {
        npc.name = nameIt->second;
    }

    const std::unordered_map<uint32_t, uint32_t>::const_iterator pictureIt =
        eventRuntimeState.npcPictureOverrides.find(npcId);

    if (pictureIt != eventRuntimeState.npcPictureOverrides.end())
    {
        npc.pictureId = pictureIt->second;
    }

    const std::unordered_map<uint32_t, uint32_t>::const_iterator professionIt =
        eventRuntimeState.npcProfessionOverrides.find(npcId);

    if (professionIt != eventRuntimeState.npcProfessionOverrides.end())
    {
        npc.professionId = professionIt->second;
    }

    return npc;
}

int professionTransportDayReduction(uint32_t professionId, bool stable)
{
    if (stable)
    {
        switch (professionId)
        {
            case HorsemanProfessionId:
                return 2;

            case ExplorerProfessionId:
                return 1;

            default:
                return 0;
        }
    }

    switch (professionId)
    {
        case SailorProfessionId:
        case PirateProfessionId:
            return 2;

        case NavigatorProfessionId:
            return 3;

        case ExplorerProfessionId:
            return 1;

        default:
            return 0;
    }
}
}

std::vector<HiredNpcFollowerView> buildHiredNpcFollowerViews(
    const EventRuntimeState &eventRuntimeState,
    const NpcDialogTable &npcDialogTable,
    const MergedNpcProfessionTable &npcProfessionTable
)
{
    std::vector<HiredNpcFollowerView> views;
    views.reserve(eventRuntimeState.hiredNpcFollowers.size());

    for (const EventRuntimeState::HiredNpcFollower &follower : eventRuntimeState.hiredNpcFollowers)
    {
        const NpcEntry npc = resolvedNpcEntry(eventRuntimeState, npcDialogTable, follower.npcId);
        const uint32_t professionId = follower.professionId != 0 ? follower.professionId : npc.professionId;
        const MergedNpcProfessionEntry *pProfession = npcProfessionTable.get(professionId);

        HiredNpcFollowerView view = {};
        view.npcId = follower.npcId;
        view.professionId = professionId;
        view.weeklyCost = follower.weeklyCost;
        view.feePercent = follower.weeklyCost / 100u;
        view.portraitPictureId = npc.pictureId;
        view.name = npc.name;
        view.profession = pProfession != nullptr ? pProfession->profession : std::string();
        views.push_back(std::move(view));
    }

    return views;
}

uint32_t totalHiredNpcFollowerFeePercent(const EventRuntimeState &eventRuntimeState)
{
    uint32_t total = 0;

    for (const EventRuntimeState::HiredNpcFollower &follower : eventRuntimeState.hiredNpcFollowers)
    {
        total += follower.weeklyCost / 100u;
    }

    return total;
}

uint32_t hiredNpcFollowerGoldShare(uint32_t goldAmount, const EventRuntimeState &eventRuntimeState)
{
    return goldAmount * totalHiredNpcFollowerFeePercent(eventRuntimeState) / 100u;
}

bool hiredNpcHasProfession(const EventRuntimeState &eventRuntimeState, uint32_t professionId)
{
    return std::find_if(
        eventRuntimeState.hiredNpcFollowers.begin(),
        eventRuntimeState.hiredNpcFollowers.end(),
        [professionId](const EventRuntimeState::HiredNpcFollower &follower)
        {
            return follower.professionId == professionId;
        }) != eventRuntimeState.hiredNpcFollowers.end();
}

int hiredNpcTransportDayReduction(const EventRuntimeState &eventRuntimeState, bool stable)
{
    int reduction = 0;

    for (const EventRuntimeState::HiredNpcFollower &follower : eventRuntimeState.hiredNpcFollowers)
    {
        reduction += professionTransportDayReduction(follower.professionId, stable);
    }

    return reduction;
}
}
