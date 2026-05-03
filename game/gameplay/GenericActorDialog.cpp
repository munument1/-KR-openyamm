#include "game/gameplay/GenericActorDialog.h"

#include "game/tables/MmergeBaseTables.h"
#include "game/tables/MapStats.h"
#include "game/tables/NpcDialogTable.h"

#include <algorithm>

namespace OpenYAMM::Game
{
namespace
{
uint32_t findNpcIdByName(const NpcDialogTable &npcDialogTable, const std::string &name)
{
    const NpcEntry *pNpcEntry = npcDialogTable.findNpcByName(name);
    return pNpcEntry != nullptr ? pNpcEntry->id : 0;
}

std::string resolveGenericNpcName(const std::string &actorName, uint32_t actorGroup)
{
    if (actorName == "Lizardman Peasant")
    {
        return "Lizardman Peasant";
    }

    if (actorName == "Lizardman Villager")
    {
        return "Lizardman Peasant";
    }

    if (actorName == "Lizardman Guard"
        || actorName == "Guard"
        || actorName == "Lizardman Soldier"
        || actorName == "Lizardman Warrior"
        || actorName == "Lizardman Lookout")
    {
        return "Lizardman Guard";
    }

    if (actorName == "Dark Elf Peasant")
    {
        return "Dark Elf Peasant";
    }

    if (actorName == "Dark Elf Guard")
    {
        return "Dark Elf Guard";
    }

    if (actorName == "Ogre Peasant")
    {
        return "Ogre Peasant";
    }

    if (actorName == "Wererat Peasant" || actorName == "Wererat Peasants")
    {
        return "Wererat Peasants";
    }

    if (actorName == "Troll Peasant")
    {
        return "Troll Peasant";
    }

    if (actorName == "Dragon Hunter")
    {
        return "Dragon Hunter";
    }

    if (actorName == "Necromancer Peasant")
    {
        return "Necromancer Peasant";
    }

    if (actorName == "Cleric Peasant")
    {
        return "Cleric Peasant";
    }

    if (actorName == "Regnan Peasant" || actorName == "Pirate")
    {
        return "Regnan Peasant";
    }

    if (actorName == "Minotaur Peasant")
    {
        return "Minotaur Peasant";
    }

    switch (actorGroup)
    {
        case 1:
        case 3:
            return "Lizardman Peasant";

        case 2:
        case 9:
            return "Lizardman Guard";

        case 5:
        case 6:
        case 7:
        case 16:
        case 17:
        case 18:
            return "Dark Elf Peasant";

        case 8:
            return "Wererat Peasants";

        case 19:
        case 20:
        case 21:
            return "Troll Peasant";

        case 22:
        case 23:
        case 24:
            return "Dragon Hunter";

        case 25:
        case 26:
        case 27:
            return "Necromancer Peasant";

        case 28:
        case 29:
            return "Cleric Peasant";

        case 32:
        case 33:
        case 34:
            return "Regnan Peasant";

        case 35:
        case 36:
        case 37:
            return "Minotaur Peasant";

        default:
            return {};
    }
}

std::optional<uint32_t> firstMapAreaNewsId(
    const MapStatsEntry *pCurrentMap,
    const MmergeNewsTopicTable *pNewsAreaTopicTable)
{
    if (pCurrentMap == nullptr || pNewsAreaTopicTable == nullptr)
    {
        return std::nullopt;
    }

    const uint32_t mapId = static_cast<uint32_t>(std::max(pCurrentMap->id, 0));

    for (const MmergeNewsTopicEntry &entry : pNewsAreaTopicTable->entries())
    {
        if (entry.ownerId == mapId && entry.newsTextId != 0)
        {
            return entry.newsTextId;
        }
    }

    return std::nullopt;
}

bool isPlaceholderGroupNews(uint32_t newsId)
{
    // MMerge uses this as a default "change me" entry for many imported MM6/MM7 peasant groups.
    return newsId == 51;
}
}

std::optional<GenericActorDialogResolution> resolveGenericActorDialog(
    const std::string &mapFileName,
    const std::string &actorName,
    uint32_t actorGroup,
    const EventRuntimeState &runtimeState,
    const NpcDialogTable &npcDialogTable,
    const MmergeMonsterPortraitTable *pMonsterPortraitTable,
    const MapStatsEntry *pCurrentMap,
    const MmergeNewsTopicTable *pNewsAreaTopicTable
)
{
    (void)mapFileName;
    uint32_t newsId = 0;
    const std::unordered_map<uint32_t, uint32_t>::const_iterator overrideIt =
        runtimeState.npcGroupNews.find(actorGroup);

    if (overrideIt != runtimeState.npcGroupNews.end())
    {
        newsId = overrideIt->second;
    }
    else
    {
        const std::optional<uint32_t> defaultNewsId = npcDialogTable.getNewsIdForGroup(actorGroup);

        if (defaultNewsId)
        {
            newsId = *defaultNewsId;
        }
    }

    if (isPlaceholderGroupNews(newsId))
    {
        newsId = 0;
    }

    if (newsId == 0)
    {
        newsId = firstMapAreaNewsId(pCurrentMap, pNewsAreaTopicTable).value_or(0);
    }

    if (newsId == 0 || !npcDialogTable.getNewsDialogText(newsId))
    {
        return std::nullopt;
    }

    GenericActorDialogResolution resolution = {};
    resolution.npcId = findNpcIdByName(npcDialogTable, resolveGenericNpcName(actorName, actorGroup));
    resolution.newsId = newsId;
    if (pMonsterPortraitTable != nullptr)
    {
        resolution.portraitPictureId = pMonsterPortraitTable->firstPortraitForName(actorName).value_or(0);
    }
    return resolution;
}
}
