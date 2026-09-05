#include "game/ui/KoreanRuntimeTextOverrides.h"

#include <doctest/doctest.h>

using OpenYAMM::Game::KoreanRuntimeText::koreanRuntimeTextOverride;

TEST_CASE("Skill service sentences translate embedded display names without changing character names")
{
    const std::pair<const char *, const char *> skills[] = {
        {"Fire Magic", "화염 마법"},
        {"Mind Magic", "정신 마법"},
        {"Disarm Traps", "함정 해제"},
        {"Identify Monster", "몬스터 식별"},
        {"Leather Armor", "가죽 갑옷"},
        {"Body Building", "체력 단련"},
        {"Merchant", "상술"},
        {"Learning", "학습"},
    };
    for (const auto &[source, target] : skills)
    {
        const std::string skill = source;
        const std::string translated = target;
        CHECK(koreanRuntimeTextOverride("Learn " + skill + " for 125 gold")
            == translated + " 배우기 - 125골드");
        CHECK(koreanRuntimeTextOverride("Robin learns " + skill + " for 125 gold.")
            == "Robin: " + translated + " 습득 (125골드)");
        CHECK(koreanRuntimeTextOverride("미나 cannot learn " + skill + " here.")
            == "미나: 여기서는 배울 수 없는 기술입니다: " + translated);
        CHECK(koreanRuntimeTextOverride("Become Expert in " + skill + " for 500 gold")
            == translated + " 전문가 승급 - 500골드");
        CHECK(koreanRuntimeTextOverride("Robin is now a Master in " + skill + ".")
            == "Robin: " + translated + " 마스터 승급 완료.");
        CHECK(koreanRuntimeTextOverride("미나 is now a Grandmaster in " + skill + ".")
            == "미나: " + translated + " 그랜드마스터 승급 완료.");
    }
    CHECK(koreanRuntimeTextOverride("Learn 화염 마법 for 100 gold") == "화염 마법 배우기 - 100골드");
    CHECK(koreanRuntimeTextOverride("Learn Custom Skill for 100 gold") == "Custom Skill 배우기 - 100골드");
    CHECK(koreanRuntimeTextOverride("Sword learns Fire Magic for 125 gold.") == "Sword: 화염 마법 습득 (125골드)");
}

TEST_CASE("Mastery restrictions translate every offered promotion class")
{
    CHECK(koreanRuntimeTextOverride("This skill level can not be learned by the Knight class.")
        == "기사: 이 직업은 해당 숙련 등급을 배울 수 없습니다.");
    CHECK(koreanRuntimeTextOverride("This skill level can not be learned by the Master class.")
        == "달인: 이 직업은 해당 숙련 등급을 배울 수 없습니다.");
    CHECK(koreanRuntimeTextOverride("You have to be promoted to Knight to learn this skill.")
        == "이 기술을 배우려면 다음 직업으로 승급해야 합니다: 기사");
    CHECK(koreanRuntimeTextOverride("You have to be promoted to Master Archer or Sniper to learn this skill.")
        == "이 기술을 배우려면 다음 직업으로 승급해야 합니다: 명궁 또는 저격수");
    CHECK(koreanRuntimeTextOverride("You have to be promoted to Priest of the Light, Priest of the Dark or High Priest"
        " to learn this skill.")
        == "이 기술을 배우려면 다음 직업으로 승급해야 합니다: 빛의 사제, 어둠의 사제 또는 대사제");
}

TEST_CASE("Bounty fallback sentences preserve targets and rewards without English currency fragments")
{
    CHECK(koreanRuntimeTextOverride("This month's bounty is 고블린 for 500 gold.")
        == "이번 달 현상금 대상: 고블린 (보상: 500골드)");
    CHECK(koreanRuntimeTextOverride("You eliminated 고블린. Your reward is 500 gold.")
        == "고블린 처치 완료. 보상: 500골드.");
    CHECK(koreanRuntimeTextOverride("This month's bounty is Knight for Hire for 12345 gold.")
        == "이번 달 현상금 대상: Knight for Hire (보상: 12345골드)");
    CHECK(koreanRuntimeTextOverride("You eliminated Dragon. Your reward is 0 gold.")
        == "Dragon 처치 완료. 보상: 0골드.");
    CHECK_FALSE(koreanRuntimeTextOverride("This month's bounty is undecided").has_value());
    CHECK_FALSE(koreanRuntimeTextOverride("You eliminated nothing.").has_value());
}
