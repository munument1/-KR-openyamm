#include "doctest/doctest.h"

#include "game/gameplay/MasteryTeacherDialog.h"
#include "game/mm9/Mm9SkillTrainer.h"
#include "game/party/Party.h"
#include "game/tables/ClassSkillTable.h"
#include "game/tables/NpcDialogTable.h"

#include <string>
#include <vector>

namespace
{
std::string rudeRow()
{
    std::vector<std::string> columns(30, "0");
    columns[0] = "80";
    columns[1] = "80";
    columns[2] = "1";
    columns[3] = "Become Expert in Blade";
    columns[4] = "Ready?";
    columns[5] = "-4";
    columns[15] = "2006";
    std::string result;
    for (size_t index = 0; index < columns.size(); ++index)
    {
        if (index != 0)
        {
            result += ',';
        }
        result += columns[index];
    }
    return result + '\n';
}

std::vector<std::string> header()
{
    return {
        "CanonicalId", "RudeId", "RudeRowIndex", "SourceLine", "ChoiceSlot", "RawTrainerId",
        "Mm9Skill", "SharedSkills", "TargetMastery", "RequiredSkillRank", "RequiredGold",
        "RequiredRawKeys", "ForbiddenRawKeys", "ExpectedRegion", "SourceDisplayNames", "Npc998Hint",
        "ActorOwnership", "ActorSources", "SourceRude", "Provenance",
    };
}

std::vector<std::string> row()
{
    return {
        "mm9:trainer/80/1", "80", "0", "1", "1", "2006", "Blade", "Sword|Dagger", "Expert", "4", "0",
        "", "", "Sturmford", "Katrina Vianni", "Katrina Vianni of Sturmford teaches Blade.", "static",
        "assets_dev/worlds/mm9/maps/sturmfordcity.scene.yml", "NPC80.rude", "rude:-4+npc998_crosscheck",
    };
}
}

TEST_CASE("MM9 skill trainer table binds composite services to authoritative RUDE rows")
{
    OpenYAMM::Game::Mm9RudeDialogueTable rudeTable;
    REQUIRE(rudeTable.loadDialogueText("NPC80.rude", rudeRow()));
    OpenYAMM::Game::Mm9SkillTrainerTable table;
    REQUIRE(table.loadFromRows({header(), row()}, rudeTable));
    CHECK(table.errors().empty());

    const OpenYAMM::Game::Mm9SkillTrainerService *pService = table.find(80, 0);
    REQUIRE(pService != nullptr);
    CHECK(pService->canonicalId == "mm9:trainer/80/1");
    CHECK(pService->mm9Skill == "Blade");
    CHECK(pService->topic.targetMastery == OpenYAMM::Game::SkillMastery::Expert);
    CHECK((pService->topic.skillNames == std::vector<std::string>{"Sword", "Dagger"}));
    CHECK_EQ(pService->requiredSkillRank, 4);
}

TEST_CASE("MM9 skill trainer table rejects stale RUDE row ownership")
{
    OpenYAMM::Game::Mm9RudeDialogueTable rudeTable;
    REQUIRE(rudeTable.loadDialogueText("NPC80.rude", rudeRow()));
    std::vector<std::string> stale = row();
    stale[3] = "2";
    OpenYAMM::Game::Mm9SkillTrainerTable table;

    CHECK_FALSE(table.loadFromRows({header(), stale}, rudeTable));
    REQUIRE_EQ(table.errors().size(), 1);
    CHECK(table.errors().front().find("authoritative RUDE row") != std::string::npos);
}

TEST_CASE("Composite mastery training fails atomically when one member is ineligible")
{
    OpenYAMM::Game::ClassSkillTable classSkillTable;
    REQUIRE(classSkillTable.loadCapsFromRows({
        {"", "Test Class"},
        {"Sword", "G"},
        {"Dagger", "B"},
    }));
    OpenYAMM::Game::Character member = {};
    member.name = "Trainer Test";
    member.className = "Test Class";
    member.skills["Sword"] = {"Sword", 4, OpenYAMM::Game::SkillMastery::Normal};
    member.skills["Dagger"] = {"Dagger", 4, OpenYAMM::Game::SkillMastery::Normal};
    OpenYAMM::Game::PartySeed seed = {};
    seed.gold = 5000;
    seed.members.push_back(member);
    OpenYAMM::Game::Party party;
    party.seed(seed);
    OpenYAMM::Game::NpcDialogTable npcDialogTable;
    const OpenYAMM::Game::SkillMasteryGroupTrainingRequest request = {
        .displayName = "Blade",
        .skillNames = {"Sword", "Dagger"},
        .targetMastery = OpenYAMM::Game::SkillMastery::Expert,
        .requiredSkill = 4,
    };
    std::string message;

    CHECK_FALSE(OpenYAMM::Game::applySkillMasteryGroupTraining(
        request, party, classSkillTable, npcDialogTable, message));
    REQUIRE(party.activeMember() != nullptr);
    CHECK(party.activeMember()->findSkill("Sword")->mastery == OpenYAMM::Game::SkillMastery::Normal);
    CHECK(party.activeMember()->findSkill("Dagger")->mastery == OpenYAMM::Game::SkillMastery::Normal);
    CHECK_EQ(party.gold(), 5000);
}

TEST_CASE("Composite mastery training charges once and preserves a higher member")
{
    OpenYAMM::Game::ClassSkillTable classSkillTable;
    REQUIRE(classSkillTable.loadCapsFromRows({
        {"", "Test Class"},
        {"Sword", "G"},
        {"Dagger", "G"},
    }));
    OpenYAMM::Game::Character member = {};
    member.name = "Trainer Test";
    member.className = "Test Class";
    member.skills["Sword"] = {"Sword", 7, OpenYAMM::Game::SkillMastery::Master};
    member.skills["Dagger"] = {"Dagger", 4, OpenYAMM::Game::SkillMastery::Normal};
    OpenYAMM::Game::PartySeed seed = {};
    seed.gold = 5000;
    seed.members.push_back(member);
    OpenYAMM::Game::Party party;
    party.seed(seed);
    OpenYAMM::Game::NpcDialogTable npcDialogTable;
    const OpenYAMM::Game::SkillMasteryGroupTrainingRequest request = {
        .displayName = "Blade",
        .skillNames = {"Sword", "Dagger"},
        .targetMastery = OpenYAMM::Game::SkillMastery::Expert,
        .requiredSkill = 4,
    };
    std::string message;

    REQUIRE(OpenYAMM::Game::applySkillMasteryGroupTraining(
        request, party, classSkillTable, npcDialogTable, message));
    REQUIRE(party.activeMember() != nullptr);
    CHECK(party.activeMember()->findSkill("Sword")->mastery == OpenYAMM::Game::SkillMastery::Master);
    CHECK(party.activeMember()->findSkill("Dagger")->mastery == OpenYAMM::Game::SkillMastery::Expert);
    CHECK_EQ(party.gold(), 3000);
    CHECK(message == "Trainer Test is now a Expert in Blade.");
}
