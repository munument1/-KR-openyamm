#pragma once

#include <array>
#include <cstddef>
#include <cstdint>
#include <optional>
#include <string>
#include <unordered_map>
#include <vector>

namespace OpenYAMM::Game
{
struct MmergeClassExtraEntry
{
    uint32_t classId = 0;
    uint32_t kind = 0;
    uint32_t promotionStep = 0;
    std::string note;
};

struct MmergeCharacterSelectionContinent
{
    std::string name;
    std::vector<uint32_t> availableClassIds;
    std::vector<uint32_t> availableRaceIds;
};

struct MmergeTeacherTopicEntry
{
    uint32_t topicId = 0;
    std::string note;
    uint32_t skillId = 0;
    uint32_t mastery = 0;
    uint32_t textId = 0;
    uint32_t requiredGold = 0;
    uint32_t requiredSkill = 0;
};

struct MmergeNpcProfessionEntry
{
    uint32_t id = 0;
    std::string profession;
    uint32_t globalTextId = 0;
    uint32_t rarity = 0;
    uint32_t weeklyCost = 0;
    std::string personality;
    uint32_t actionTopicId = 0;
    bool joins = false;
    bool recruit = false;
    uint32_t joinTextId = 0;
    uint32_t descriptionTextId = 0;
};

struct MmergeNewsTopicEntry
{
    uint32_t ownerId = 0;
    uint32_t topicTextId = 0;
    uint32_t newsTextId = 0;
};

struct MmergeMonsterKindEntry
{
    uint32_t monsterId = 0;
    std::string name;
    bool undead = false;
    bool dragon = false;
    bool swimmer = false;
    bool immobile = false;
    bool peasant = false;
    bool noArena = false;
    bool ogre = false;
    bool elemental = false;
};

struct MmergePotionSettingEntry
{
    uint32_t potionId = 0;
    uint32_t itemId = 0;
    std::optional<uint32_t> requiredMastery;
    bool drinkable = false;
    bool usable = false;
    std::string note;
};

struct MmergeReagentSettingEntry
{
    uint32_t reagentId = 0;
    uint32_t itemId = 0;
    uint32_t resultItemId = 0;
    std::string note;
};

struct MmergeTeacherAutonoteMapping
{
    uint32_t topicId = 0;
    uint32_t npcId = 0;
    uint32_t autonoteId = 0;
};

struct MmergeRaceSkillOverride
{
    std::string target;
    std::string skillName;
    std::string token;
};

struct MmergeNewsProfessionDayTopic
{
    uint32_t professionId = 0;
    uint32_t dayIndex = 0;
    uint32_t topicTextId = 0;
    uint32_t newsTextId = 0;
};

struct MmergeAdditionalUiEntry
{
    uint32_t id = 0;
    std::string lodName;
    std::string dLodName;
    bool showBlankHostileIndicator = false;
    int32_t hostileIndicatorY = 0;
    int32_t hostileIndicatorXOffset = 0;
    bool selectionRingOnTop = false;
    int32_t selectionRingY = 0;
    int32_t selectionRingXOffset = 0;
    std::string notes;
};

struct MmergeBolsterFormulaEntry
{
    std::string target;
    std::optional<uint32_t> monsterKindId;
    std::string stat;
    std::string formula;
    std::string notes;
};

struct MmergeBolsterMapEntry
{
    uint32_t id = 0;
    std::string note;
    uint32_t continent = 0;
    std::string bolsterKind;
    bool spells = false;
    bool summons = false;
    bool weather = false;
    uint32_t bolsterExtra = 0;
    std::optional<uint32_t> professionMaxRarity;
    std::string customSky;
};

struct MmergeBolsterMonsterEntry
{
    uint32_t id = 0;
    std::string note;
    std::string type;
    std::vector<std::string> extraTypes;
    std::string creed;
    std::string gender;
    std::string style;
    std::string preferredMagic;
    bool noBountyHunt = false;
    bool newRangedAttacks = false;
    bool newSpells = false;
    bool sizeAffectsHp = false;
    bool replicate = false;
    bool newSummons = false;
    std::optional<uint32_t> summonId;
    std::optional<uint32_t> extraPoints;
    std::optional<uint32_t> maxHpBoostPercent;
};

struct MmergeCharacterVoiceEntry
{
    std::string soundType;
    std::vector<uint32_t> soundIdsByVoiceSetId;
};

struct MmergeClassStartingStatEntry
{
    std::string statName;
    std::string raceName;
    std::optional<uint32_t> raceId;
    uint32_t baseValue = 0;
    uint32_t maxValue = 0;
    uint32_t addNumerator = 0;
    uint32_t addDenominator = 1;
};

struct MmergeComplexItemPictureOffsetEntry
{
    uint32_t portraitId = 0;
    uint32_t itemId = 0;
    int32_t x = 0;
    int32_t y = 0;
};

struct MmergePoint
{
    int32_t x = 0;
    int32_t y = 0;
    int32_t z = 0;
};

struct MmergeComplexItemPictureEntry
{
    uint32_t id = 0;
    uint32_t itemId = 0;
    std::string notes;
    std::vector<MmergePoint> points;
};

struct MmergeContinentSettingEntry
{
    uint32_t id = 0;
    std::string note;
    bool reputationAffectsGuards = false;
    bool reputationAffectsShops = false;
    bool reputationAffectsNpc = false;
    bool tellProfessionNews = false;
    bool npcFollowers = false;
    double saturation = 0.0;
    double softness = 0.0;
    std::string deathMovie;
    std::string specificWater;
    std::string deathMap1;
    int32_t deathMap1X = 0;
    int32_t deathMap1Y = 0;
    int32_t deathMap1Z = 0;
    int32_t deathMap1Direction = 0;
    std::string deathMap2;
    int32_t deathMap2X = 0;
    int32_t deathMap2Y = 0;
    int32_t deathMap2Z = 0;
    int32_t deathMap2Direction = 0;
    std::vector<std::string> skies;
    std::vector<std::string> loadingPictures;
};

struct MmergeHardwareWaterTextureEntry
{
    std::string softwareTexture;
    std::string hardwareTexturePrefix;
};

struct MmergeHouseExitEntry
{
    std::string mapName;
    std::vector<MmergePoint> positions;
};

struct MmergeHouseExitTableData
{
    std::vector<uint32_t> npcPictureIds;
    std::optional<uint32_t> freeNpcId;
    std::optional<uint32_t> freeTopicId;
    std::vector<MmergeHouseExitEntry> exits;
};

struct MmergeHouseRuleSection
{
    std::string name;
    std::vector<std::vector<int32_t>> numericRows;
};

struct MmergeHistoryEntry
{
    uint32_t id = 0;
    std::string text;
    std::string time;
    std::string pageTitle;
};

struct MmergeOutdoorTravelDirection
{
    std::string mapName;
    std::string side;
    std::optional<uint32_t> days;
};

struct MmergeOutdoorTravelEntry
{
    std::string keyMap;
    MmergeOutdoorTravelDirection up;
    MmergeOutdoorTravelDirection down;
    MmergeOutdoorTravelDirection left;
    MmergeOutdoorTravelDirection right;
    bool straightTravel = false;
    std::string notes;
};

struct MmergeOverlayEntry
{
    uint32_t id = 0;
    uint32_t type = 0;
    std::string sftGroup;
};

struct MmergeTownPortalDestination
{
    uint32_t id = 0;
    uint32_t mapId = 0;
    int32_t x = 0;
    int32_t y = 0;
    int32_t z = 0;
    int32_t direction = 0;
    int32_t lookAngle = 0;
    std::string iconName;
    int32_t iconX = 0;
    int32_t iconY = 0;
    std::optional<uint32_t> iconWidth;
    std::optional<uint32_t> iconHeight;
    uint32_t qbitIndex = 0;
    std::string description;
};

struct MmergeTownPortalSwitchGroup
{
    std::string name;
    uint32_t topicId = 0;
    std::vector<MmergeTownPortalDestination> destinations;
};

struct MmergeTransportIndexEntry
{
    uint32_t houseEventId = 0;
    std::vector<int32_t> locationIndicesByPeriod;
};

struct MmergeTransportLocationEntry
{
    uint32_t id = 0;
    std::string mapName;
    std::array<bool, 7> weekdays = {};
    uint32_t daysCount = 0;
    int32_t x = 0;
    int32_t y = 0;
    int32_t z = 0;
    int32_t direction = 0;
    uint32_t qbit = 0;
};

class MmergeClassExtraTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeClassExtraEntry> &entries() const;

private:
    std::vector<MmergeClassExtraEntry> m_entries;
};

class MmergeCharacterSelectionTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeCharacterSelectionContinent> &continents() const;
    size_t raceCount() const;

private:
    std::unordered_map<uint32_t, std::vector<std::string>> m_characterSelectionAllowedClassesByRaceId;
    std::vector<MmergeCharacterSelectionContinent> m_characterSelectionContinents;
};

class MmergeRaceSkillTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    size_t overrideCount() const;

private:
    std::vector<MmergeRaceSkillOverride> m_overrides;
};

class MmergeTeacherTopicTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeTeacherTopicEntry> &entries() const;

private:
    std::vector<MmergeTeacherTopicEntry> m_entries;
};

class MmergeTeacherAutonoteTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    size_t mappingCount() const;

private:
    std::vector<MmergeTeacherAutonoteMapping> m_mappings;
};

class MmergeNpcProfessionTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const MmergeNpcProfessionEntry *get(uint32_t professionId) const;
    const std::vector<MmergeNpcProfessionEntry> &entries() const;

private:
    std::vector<MmergeNpcProfessionEntry> m_entries;
};

class MmergeNpcNameTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    size_t maleNameCount() const;
    size_t femaleNameCount() const;

private:
    std::vector<std::string> m_npcMaleNames;
    std::vector<std::string> m_npcFemaleNames;
};

class MmergeNpcBtbTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    size_t personalityCount() const;

private:
    std::vector<std::string> m_npcBtbPersonalities;
};

class MmergeNewsTopicTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeNewsTopicEntry> &entries() const;

private:
    std::vector<MmergeNewsTopicEntry> m_entries;
};

class MmergeNewsProfessionTopicTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const MmergeNewsProfessionDayTopic *get(uint32_t professionId, uint32_t dayIndex) const;
    size_t topicCount() const;

private:
    std::vector<MmergeNewsProfessionDayTopic> m_topics;
};

class MmergeMonsterPortraitTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    std::optional<uint32_t> firstPortraitForName(const std::string &name) const;
    size_t groupCount() const;

private:
    std::unordered_map<uint32_t, std::vector<uint32_t>> m_monsterPortraitsByGroupId;
    std::unordered_map<std::string, std::vector<uint32_t>> m_monsterPortraitsByName;
};

class MmergeMonsterKindTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeMonsterKindEntry> &entries() const;

private:
    std::vector<MmergeMonsterKindEntry> m_entries;
};

class MmergePotionSettingTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergePotionSettingEntry> &entries() const;

private:
    std::vector<MmergePotionSettingEntry> m_entries;
};

class MmergeReagentSettingTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeReagentSettingEntry> &entries() const;

private:
    std::vector<MmergeReagentSettingEntry> m_entries;
};

class MmergeAdditionalUiTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeAdditionalUiEntry> &entries() const;

private:
    std::vector<MmergeAdditionalUiEntry> m_entries;
};

class MmergeBolsterFormulaTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeBolsterFormulaEntry> &entries() const;

private:
    std::vector<MmergeBolsterFormulaEntry> m_entries;
};

class MmergeBolsterMapTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeBolsterMapEntry> &entries() const;
    const MmergeBolsterMapEntry *findById(uint32_t id) const;

private:
    std::vector<MmergeBolsterMapEntry> m_entries;
};

class MmergeBolsterMonsterTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeBolsterMonsterEntry> &entries() const;

private:
    std::vector<MmergeBolsterMonsterEntry> m_entries;
};

class MmergeCharacterVoiceTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeCharacterVoiceEntry> &entries() const;

private:
    std::vector<MmergeCharacterVoiceEntry> m_entries;
};

class MmergeClassStartingStatTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeClassStartingStatEntry> &entries() const;

private:
    std::vector<MmergeClassStartingStatEntry> m_entries;
};

class MmergeComplexItemPictureOffsetTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeComplexItemPictureOffsetEntry> &entries() const;

private:
    std::vector<MmergeComplexItemPictureOffsetEntry> m_entries;
};

class MmergeComplexItemPictureTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeComplexItemPictureEntry> &entries() const;

private:
    std::vector<MmergeComplexItemPictureEntry> m_entries;
};

class MmergeContinentSettingTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeContinentSettingEntry> &entries() const;
    const MmergeContinentSettingEntry *findById(uint32_t id) const;

private:
    std::vector<MmergeContinentSettingEntry> m_entries;
};

class MmergeHardwareWaterTextureTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeHardwareWaterTextureEntry> &entries() const;

private:
    std::vector<MmergeHardwareWaterTextureEntry> m_entries;
};

class MmergeHouseExitTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const MmergeHouseExitTableData &data() const;

private:
    MmergeHouseExitTableData m_data;
};

class MmergeHouseRuleTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeHouseRuleSection> &sections() const;

private:
    std::vector<MmergeHouseRuleSection> m_sections;
};

class MmergeHistoryTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeHistoryEntry> &entries() const;

private:
    std::vector<MmergeHistoryEntry> m_entries;
};

class MmergeOutdoorTravelTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeOutdoorTravelEntry> &entries() const;

private:
    std::vector<MmergeOutdoorTravelEntry> m_entries;
};

class MmergeOverlayTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeOverlayEntry> &entries() const;

private:
    std::vector<MmergeOverlayEntry> m_entries;
};

class MmergeTownPortalSwitchTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeTownPortalSwitchGroup> &groups() const;

private:
    std::vector<MmergeTownPortalSwitchGroup> m_groups;
};

class MmergeTransportIndexTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeTransportIndexEntry> &entries() const;

private:
    std::vector<MmergeTransportIndexEntry> m_entries;
};

class MmergeTransportLocationTable
{
public:
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows);
    const std::vector<MmergeTransportLocationEntry> &entries() const;

private:
    std::vector<MmergeTransportLocationEntry> m_entries;
};
}
