#pragma once

#include "game/party/SkillData.h"

#include <string>
#include <unordered_map>
#include <vector>

namespace OpenYAMM::Game
{
struct ClassMetadataEntry
{
    uint32_t classId = 0;
    std::string className;
    uint32_t classKind = 0;
    uint32_t promotionStep = 0;
};

class ClassSkillTable
{
public:
    bool loadCapsFromRows(const std::vector<std::vector<std::string>> &rows);
    bool loadStartingSkillsFromRows(const std::vector<std::vector<std::string>> &rows);
    bool loadClassMetadataFromRows(const std::vector<std::vector<std::string>> &rows);

    SkillMastery getClassCap(const std::string &className, const std::string &skillName) const;
    SkillMastery getHighestPromotionCap(const std::string &className, const std::string &skillName) const;
    StartingSkillAvailability getStartingSkillAvailability(const std::string &className, const std::string &skillName)
        const;
    std::vector<CharacterSkill> getDefaultSkillsForClass(const std::string &className) const;

private:
    std::vector<std::string> promotionClassNamesFromMetadata(const std::string &className) const;

    std::unordered_map<std::string, std::unordered_map<std::string, SkillMastery>> m_caps;
    std::unordered_map<std::string, std::unordered_map<std::string, StartingSkillAvailability>> m_startingSkills;
    std::unordered_map<std::string, ClassMetadataEntry> m_classMetadata;
};
}
