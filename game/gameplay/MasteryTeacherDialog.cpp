#include "game/gameplay/MasteryTeacherDialog.h"

#include "game/tables/MergedBaseTables.h"
#include "game/tables/NpcDialogTable.h"
#include "game/party/Party.h"

#include <cctype>

namespace OpenYAMM::Game
{
namespace
{
std::string npcTextOrFallback(const NpcDialogTable &npcDialogTable, uint32_t textId, const std::string &fallback)
{
    const std::optional<std::string> text = npcDialogTable.getText(textId);

    if (text && !text->empty())
    {
        return *text;
    }

    return fallback;
}

std::string trimCopy(const std::string &text)
{
    size_t start = 0;
    size_t end = text.size();

    while (start < end && std::isspace(static_cast<unsigned char>(text[start])) != 0)
    {
        ++start;
    }

    while (end > start && std::isspace(static_cast<unsigned char>(text[end - 1])) != 0)
    {
        --end;
    }

    return text.substr(start, end - start);
}

std::optional<std::string> skillNameForMergedSkillId(uint32_t skillId)
{
    const std::vector<std::string> skillNames = allCanonicalSkillNames();

    if (skillId >= skillNames.size())
    {
        return std::nullopt;
    }

    return skillNames[skillId];
}

SkillMastery masteryForMergedTeacherTopic(uint32_t mastery)
{
    switch (mastery)
    {
        case 1:
            return SkillMastery::Expert;
        case 2:
            return SkillMastery::Master;
        case 3:
            return SkillMastery::Grandmaster;
        default:
            return SkillMastery::None;
    }
}
}

std::optional<MasteryTeacherTopicDefinition> resolveMasteryTeacherTopic(
    uint32_t topicId,
    const MergedTeacherTopicTable *pTeacherTopicTable
)
{
    MasteryTeacherTopicDefinition definition = {};

    const MergedTeacherTopicEntry *pTeacherTopic =
        pTeacherTopicTable != nullptr ? pTeacherTopicTable->get(topicId) : nullptr;

    if (pTeacherTopic != nullptr)
    {
        definition.topicId = pTeacherTopic->topicId;
        definition.skillId = pTeacherTopic->skillId;
        definition.masteryRank = pTeacherTopic->mastery;
        definition.textId = pTeacherTopic->textId;
        definition.requiredGold = pTeacherTopic->requiredGold;
        definition.requiredSkill = pTeacherTopic->requiredSkill;
    }
    else if (topicId >= 300 && topicId <= 416)
    {
        // MMerge keeps these original MM8 topic ids active even when Teacher topics.txt only extends the table.
        definition.topicId = topicId;
        definition.skillId = (topicId - 300) / 3;
        definition.masteryRank = ((topicId - 300) % 3) + 1;
        definition.textId = topicId;
    }
    else
    {
        return std::nullopt;
    }

    const std::optional<std::string> skillName = skillNameForMergedSkillId(definition.skillId);
    if (!skillName.has_value())
    {
        return std::nullopt;
    }

    definition.skillName = *skillName;
    definition.targetMastery = masteryForMergedTeacherTopic(definition.masteryRank);

    if (definition.skillName.empty() || definition.targetMastery == SkillMastery::None)
    {
        return std::nullopt;
    }

    return definition;
}

bool isMasteryTeacherTopic(
    uint32_t topicId,
    const MergedTeacherTopicTable *pTeacherTopicTable
)
{
    return resolveMasteryTeacherTopic(topicId, pTeacherTopicTable).has_value();
}

namespace
{
uint32_t alreadyHasTextId(SkillMastery mastery)
{
    switch (mastery)
    {
        case SkillMastery::Expert:
            return 129;
        case SkillMastery::Master:
            return 130;
        case SkillMastery::Grandmaster:
            return 131;
        default:
            return 128;
    }
}

int masteryTeacherCost(const std::string &skillName, SkillMastery targetMastery)
{
    const std::string canonicalSkill = canonicalSkillName(skillName);

    if (targetMastery == SkillMastery::Expert)
    {
        if (canonicalSkill == "Blaster")
        {
            return 2000;
        }

        if (canonicalSkill == "Shield"
            || canonicalSkill == "LeatherArmor"
            || canonicalSkill == "ChainArmor"
            || canonicalSkill == "PlateArmor"
            || canonicalSkill == "FireMagic"
            || canonicalSkill == "AirMagic"
            || canonicalSkill == "WaterMagic"
            || canonicalSkill == "EarthMagic"
            || canonicalSkill == "SpiritMagic"
            || canonicalSkill == "MindMagic"
            || canonicalSkill == "BodyMagic")
        {
            return 1000;
        }

        if (canonicalSkill == "Staff"
            || canonicalSkill == "Sword"
            || canonicalSkill == "Dagger"
            || canonicalSkill == "Axe"
            || canonicalSkill == "Spear"
            || canonicalSkill == "Bow"
            || canonicalSkill == "Mace"
            || canonicalSkill == "LightMagic"
            || canonicalSkill == "DarkMagic"
            || canonicalSkill == "Merchant"
            || canonicalSkill == "Dodging"
            || canonicalSkill == "Unarmed"
            || canonicalSkill == "Armsmaster"
            || canonicalSkill == "Learning")
        {
            return 2000;
        }

        if (canonicalSkill == "IdentifyItem"
            || canonicalSkill == "RepairItem"
            || canonicalSkill == "Bodybuilding"
            || canonicalSkill == "Meditation"
            || canonicalSkill == "Perception"
            || canonicalSkill == "Regeneration"
            || canonicalSkill == "DisarmTraps"
            || canonicalSkill == "IdentifyMonster"
            || canonicalSkill == "Stealing"
            || canonicalSkill == "Alchemy"
            || canonicalSkill == "DarkElfAbility"
            || canonicalSkill == "VampireAbility"
            || canonicalSkill == "DragonAbility")
        {
            return 500;
        }
    }

    if (targetMastery == SkillMastery::Master)
    {
        if (canonicalSkill == "Blaster")
        {
            return 5000;
        }

        if (canonicalSkill == "Shield"
            || canonicalSkill == "LeatherArmor"
            || canonicalSkill == "ChainArmor"
            || canonicalSkill == "PlateArmor")
        {
            return 3000;
        }

        if (canonicalSkill == "FireMagic"
            || canonicalSkill == "AirMagic"
            || canonicalSkill == "WaterMagic"
            || canonicalSkill == "EarthMagic"
            || canonicalSkill == "SpiritMagic"
            || canonicalSkill == "MindMagic"
            || canonicalSkill == "BodyMagic")
        {
            return 4000;
        }

        if (canonicalSkill == "Staff"
            || canonicalSkill == "Sword"
            || canonicalSkill == "Dagger"
            || canonicalSkill == "Axe"
            || canonicalSkill == "Spear"
            || canonicalSkill == "Bow"
            || canonicalSkill == "Mace"
            || canonicalSkill == "LightMagic"
            || canonicalSkill == "DarkMagic"
            || canonicalSkill == "Merchant"
            || canonicalSkill == "Dodging"
            || canonicalSkill == "Unarmed"
            || canonicalSkill == "Armsmaster"
            || canonicalSkill == "Learning")
        {
            return 5000;
        }

        if (canonicalSkill == "IdentifyItem"
            || canonicalSkill == "RepairItem"
            || canonicalSkill == "Bodybuilding"
            || canonicalSkill == "Meditation"
            || canonicalSkill == "Perception"
            || canonicalSkill == "Regeneration"
            || canonicalSkill == "DisarmTraps"
            || canonicalSkill == "IdentifyMonster"
            || canonicalSkill == "Stealing"
            || canonicalSkill == "Alchemy"
            || canonicalSkill == "DarkElfAbility"
            || canonicalSkill == "VampireAbility"
            || canonicalSkill == "DragonAbility")
        {
            return 2500;
        }
    }

    if (targetMastery == SkillMastery::Grandmaster)
    {
        if (canonicalSkill == "Blaster")
        {
            return 10000;
        }

        if (canonicalSkill == "Shield"
            || canonicalSkill == "LeatherArmor"
            || canonicalSkill == "ChainArmor"
            || canonicalSkill == "PlateArmor")
        {
            return 7000;
        }

        if (canonicalSkill == "Staff"
            || canonicalSkill == "Sword"
            || canonicalSkill == "Dagger"
            || canonicalSkill == "Axe"
            || canonicalSkill == "Spear"
            || canonicalSkill == "Bow"
            || canonicalSkill == "Mace"
            || canonicalSkill == "FireMagic"
            || canonicalSkill == "AirMagic"
            || canonicalSkill == "WaterMagic"
            || canonicalSkill == "EarthMagic"
            || canonicalSkill == "SpiritMagic"
            || canonicalSkill == "MindMagic"
            || canonicalSkill == "BodyMagic"
            || canonicalSkill == "LightMagic"
            || canonicalSkill == "DarkMagic"
            || canonicalSkill == "Merchant"
            || canonicalSkill == "Dodging"
            || canonicalSkill == "Unarmed"
            || canonicalSkill == "Armsmaster"
            || canonicalSkill == "Learning")
        {
            return 8000;
        }

        if (canonicalSkill == "IdentifyItem"
            || canonicalSkill == "RepairItem"
            || canonicalSkill == "Bodybuilding"
            || canonicalSkill == "Meditation"
            || canonicalSkill == "Perception"
            || canonicalSkill == "Regeneration"
            || canonicalSkill == "DisarmTraps"
            || canonicalSkill == "IdentifyMonster"
            || canonicalSkill == "Stealing"
            || canonicalSkill == "Alchemy"
            || canonicalSkill == "DarkElfAbility"
            || canonicalSkill == "VampireAbility"
            || canonicalSkill == "DragonAbility")
        {
            return 6000;
        }
    }

    return 0;
}

bool meetsMasteryRequirements(
    const Character &character,
    const std::string &skillName,
    SkillMastery targetMastery,
    uint32_t requiredSkillLevel
)
{
    const CharacterSkill *pSkill = character.findSkill(skillName);

    if (pSkill == nullptr)
    {
        return false;
    }

    if (requiredSkillLevel != 0 && pSkill->level < requiredSkillLevel)
    {
        return false;
    }

    if (targetMastery == SkillMastery::Expert)
    {
        return pSkill->level >= 4;
    }

    if (targetMastery == SkillMastery::Master)
    {
        if (pSkill->level < 7 || pSkill->mastery != SkillMastery::Expert)
        {
            return false;
        }

        if (skillName == "Merchant")
        {
            return character.personality >= 50;
        }

        if (skillName == "Bodybuilding")
        {
            return character.endurance >= 50;
        }

        if (skillName == "Learning")
        {
            return character.intellect >= 50;
        }

        return true;
    }

    if (targetMastery == SkillMastery::Grandmaster)
    {
        if (pSkill->level < 10 || pSkill->mastery != SkillMastery::Master)
        {
            return false;
        }

        if (skillName == "Dodging")
        {
            const CharacterSkill *pUnarmed = character.findSkill("Unarmed");
            return pUnarmed != nullptr && pUnarmed->level >= 10;
        }

        if (skillName == "Unarmed")
        {
            const CharacterSkill *pDodging = character.findSkill("Dodging");
            return pDodging != nullptr && pDodging->level >= 10;
        }

        return true;
    }

    return false;
}
}

std::optional<MasteryTeacherEvaluation> evaluateMasteryTeacherTopic(
    uint32_t topicId,
    const Party &party,
    const ClassSkillTable &classSkillTable,
    const NpcDialogTable &npcDialogTable,
    const MergedTeacherTopicTable *pTeacherTopicTable
)
{
    const Character *pCharacter = party.activeMember();

    if (pCharacter == nullptr)
    {
        return std::nullopt;
    }

    MasteryTeacherEvaluation evaluation = {};
    const std::optional<MasteryTeacherTopicDefinition> teacherTopic =
        resolveMasteryTeacherTopic(topicId, pTeacherTopicTable);

    if (!teacherTopic.has_value())
    {
        return std::nullopt;
    }

    evaluation.skillName = teacherTopic->skillName;
    evaluation.targetMastery = teacherTopic->targetMastery;
    evaluation.cost = static_cast<int>(teacherTopic->requiredGold);

    if (evaluation.skillName.empty() || evaluation.targetMastery == SkillMastery::None)
    {
        return std::nullopt;
    }

    if (evaluation.cost == 0)
    {
        evaluation.cost = masteryTeacherCost(evaluation.skillName, evaluation.targetMastery);
    }

    const SkillMastery classCap = classSkillTable.getClassCap(pCharacter->className, evaluation.skillName);

    if (classCap < evaluation.targetMastery)
    {
        const std::optional<std::string> nextPromotion = nextPromotionClassName(pCharacter->className);

        if (nextPromotion
            && classSkillTable.getClassCap(*nextPromotion, evaluation.skillName) >= evaluation.targetMastery)
        {
            evaluation.displayText =
                "You have to be promoted to " + displayClassName(*nextPromotion) + " to learn this skill.";
            return evaluation;
        }

        evaluation.displayText =
            "This skill level can not be learned by the " + displayClassName(pCharacter->className) + " class.";
        return evaluation;
    }

    if (!pCharacter->hasSkill(evaluation.skillName))
    {
        evaluation.displayText = npcTextOrFallback(npcDialogTable, 132, "This character does not know that skill.");
        return evaluation;
    }

    const CharacterSkill *pSkill = pCharacter->findSkill(evaluation.skillName);

    if (pSkill != nullptr && pSkill->mastery >= evaluation.targetMastery)
    {
        evaluation.displayText = npcTextOrFallback(
            npcDialogTable,
            alreadyHasTextId(evaluation.targetMastery),
            "This character already knows that mastery."
        );
        return evaluation;
    }

    if (!meetsMasteryRequirements(
            *pCharacter,
            evaluation.skillName,
            evaluation.targetMastery,
            teacherTopic->requiredSkill))
    {
        evaluation.displayText = npcTextOrFallback(
            npcDialogTable,
            128,
            "The requirements for this training are unmet."
        );
        return evaluation;
    }

    if (party.gold() < evaluation.cost)
    {
        evaluation.displayText = npcTextOrFallback(npcDialogTable, 125, "You do not have enough gold.");
        return evaluation;
    }

    evaluation.approved = true;
    evaluation.displayText =
        "Become " + masteryDisplayName(evaluation.targetMastery)
        + " in " + displaySkillName(evaluation.skillName)
        + " for " + std::to_string(evaluation.cost) + " gold";
    return evaluation;
}

bool applyMasteryTeacherTopic(
    uint32_t topicId,
    Party &party,
    const ClassSkillTable &classSkillTable,
    const NpcDialogTable &npcDialogTable,
    const MergedTeacherTopicTable *pTeacherTopicTable,
    std::string &message
)
{
    const std::optional<MasteryTeacherEvaluation> evaluation =
        evaluateMasteryTeacherTopic(topicId, party, classSkillTable, npcDialogTable, pTeacherTopicTable);

    if (!evaluation || !evaluation->approved)
    {
        return false;
    }

    Character *pCharacter = party.activeMember();

    if (pCharacter == nullptr || !pCharacter->setSkillMastery(evaluation->skillName, evaluation->targetMastery))
    {
        return false;
    }

    party.addGold(-evaluation->cost);
    message =
        pCharacter->name + " is now a "
        + masteryDisplayName(evaluation->targetMastery)
        + " in " + displaySkillName(evaluation->skillName) + ".";
    return true;
}
}
