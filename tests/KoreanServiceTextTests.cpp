#include "game/ui/KoreanRuntimeTextOverrides.h"

#include <doctest/doctest.h>

using OpenYAMM::Game::KoreanRuntimeText::koreanRuntimeTextOverride;

TEST_CASE("Compound item inspection details retain all values and translate every caption")
{
    const std::pair<const char *, const char *> details[] = {
        {"Power: 25", "위력: 25"}, {"Value: 500", "가치: 500"},
        {"Attack: +2   Damage: 2D6+2", "공격: +2   피해: 2D6+2"},
        {"Shoot: +3   Damage: 3D4+3", "사격: +3   피해: 3D4+3"},
        {"Broken   Attack: +2   Damage: 2D6+2", "파손   공격: +2   피해: 2D6+2"},
        {"Charges: 2/20", "충전 횟수: 2/20"}, {"Armor: +12", "방어력: +12"},
        {"Duration: 1:yr 2:mo 3:dy 4:hr 5:mn", "지속 시간: 1년 2개월 3일 4시간 5분"},
        {"Duration: 0:mn", "지속 시간: 0분"},
        {"Special: 힘 +10\nSet: Custom (2/3, inactive)", "특수 효과: 힘 +10\n세트: Custom (2/3, 비활성)"},
        {"Set: Custom (3/3, active)", "세트: Custom (3/3, 활성)"},
    };
    for (const auto &[source, target] : details)
    {
        CAPTURE(source);
        CHECK(koreanRuntimeTextOverride(source) == target);
    }
}

TEST_CASE("Skill page translates skill and mastery separately without changing custom skill names")
{
    using OpenYAMM::Game::KoreanRuntimeText::characterSkillLabel;
    using OpenYAMM::Game::KoreanRuntimeText::skillMasteryLabel;
    CHECK(characterSkillLabel("Fire Magic", "Master") == "화염 마법 마스터");
    CHECK(characterSkillLabel("Identify Monster", "Expert") == "몬스터 식별 전문가");
    CHECK(characterSkillLabel("Vampire Ability", "Grandmaster") == "뱀파이어 능력 그랜드");
    CHECK(characterSkillLabel("Sword", "Normal") == "검");
    CHECK(characterSkillLabel("Sword", "None") == "검");
    CHECK(characterSkillLabel("Custom Skill", "Expert") == "Custom Skill 전문가");
    CHECK(characterSkillLabel("함정 해제", "Master") == "함정 해제 마스터");
    CHECK(skillMasteryLabel("Normal") == "일반");
    CHECK(skillMasteryLabel("None").empty());
    CHECK(OpenYAMM::Game::KoreanRuntimeText::className("Master") == "달인");
}

TEST_CASE("Monster attack labels translate display aliases while preserving data tokens")
{
    using OpenYAMM::Game::KoreanRuntimeText::monsterAttackTypeLabel;
    const std::pair<const char *, const char *> types[] = {
        {"Phys", "물리"}, {"Pois", "독"}, {"Ener", "에너지"}, {"Fire", "화염"}, {"Air", "대기"},
        {"Water", "물"}, {"Earth", "대지"}, {"Light", "빛"}, {"Dark", "어둠"},
    };
    for (const auto &[source, target] : types)
    {
        const std::string token = source;
        CAPTURE(token);
        CHECK(monsterAttackTypeLabel(token) == target);
        CHECK(token == source);
    }
    CHECK(monsterAttackTypeLabel("0") == "0");
    CHECK(monsterAttackTypeLabel("Custom damage") == "Custom damage");
}

TEST_CASE("MM9 fallback services and transport labels stay player-readable")
{
    CHECK(koreanRuntimeTextOverride("MM9 shop 42 has no mounted service definition.")
        == "MM9 상점 42번의 등록된 서비스 정의가 없습니다.");
    CHECK(koreanRuntimeTextOverride("MM9 healer service definition is invalid.")
        == "MM9 치료소 서비스 정의가 잘못되었습니다.");
    CHECK(koreanRuntimeTextOverride("MM9 skill training service is not implemented yet.")
        == "MM9 기술 훈련 서비스는 아직 구현되지 않았습니다.");
    CHECK(koreanRuntimeTextOverride("2 days to Ravenshore for 150 gold") == "Ravenshore까지 2일 이동 (150골드)");
    CHECK(koreanRuntimeTextOverride("1 day to 미스트 for 0 gold") == "미스트까지 1일 이동 (0골드)");
    CHECK(koreanRuntimeTextOverride("That route is not available.") == "이 이동 경로는 현재 이용할 수 없습니다.");
    CHECK(koreanRuntimeTextOverride("You don't have enough gold.") == "골드가 부족합니다.");
}

TEST_CASE("Lloyd beacon hover labels preserve both locations in Korean")
{
    CHECK(koreanRuntimeTextOverride("Recall to Ravenshore") == "Ravenshore(으)로 귀환");
    CHECK(koreanRuntimeTextOverride("Set beacon to 현재 위치") == "현재 위치에 봉화 설치");
    CHECK(koreanRuntimeTextOverride("Set Free Haven over Ravenshore")
        == "봉화 위치 변경: Ravenshore → Free Haven");
    CHECK(koreanRuntimeTextOverride("Set 미스트 over Ravenshore")
        == "봉화 위치 변경: Ravenshore → 미스트");
}

TEST_CASE("Monster inspection translates each effect before joining the list")
{
    using OpenYAMM::Game::KoreanRuntimeText::actorEffectsText;
    CHECK(actorEffectsText({}) == "없음");
    CHECK(actorEffectsText({"", "-", "0"}) == "없음");
    CHECK(actorEffectsText({"Haste"}) == "가속");
    CHECK(actorEffectsText({"Haste", "Shield"}) == "가속, 방패");
    CHECK(actorEffectsText({"Stoneskin", "Casting 가속", "Paralyzed"}) == "돌가죽, 시전 중: 가속, 마비");
    CHECK(actorEffectsText({"Custom, Effect", "Haste"}) == "Custom, Effect, 가속");
    CHECK(actorEffectsText({"가속", "방패"}) == "가속, 방패");

    const char *effects[] = {
        "Dead", "Stunned", "Paralyzed", "Slow", "Afraid", "Shrunk", "Dark Grasp", "Day of Protection",
        "Hour of Power", "Pain Reflection", "Hammerhands", "Haste", "Shield", "Stoneskin", "Bless",
        "Fate", "Heroism", "Charmed", "Berserk", "Enslaved", "Controlled", "Reanimated",
    };
    for (const char *pEffect : effects)
    {
        CAPTURE(pEffect);
        CHECK(actorEffectsText({pEffect}) != pEffect);
    }
}

TEST_CASE("Combat status reports translate outcomes while preserving participant names and damage")
{
    const std::pair<const char *, const char *> reports[] = {
        {"Ariel evades damage", "Ariel: 피해 회피"},
        {"미나 evades damage", "미나: 피해 회피"},
        {"Ariel paralyzes 고블린", "Ariel: 고블린 마비"},
        {"미나 stuns Goblin King", "미나: Goblin King 기절"},
        {"미나 hits 고블린 for 0 damage", "미나: 고블린 공격 (피해 0)"},
        {"Ariel shoots Goblin King for 125 points", "Ariel: Goblin King 사격 (피해 125)"},
        {"미나 inflicts 1234 points killing Goblin King", "미나: Goblin King 처치 (피해 1234)"},
        {"Ariel hits Guardian for Hire for 12 damage", "Ariel: Guardian for Hire 공격 (피해 12)"},
    };
    for (const auto &[source, target] : reports)
    {
        CAPTURE(source);
        CHECK(koreanRuntimeTextOverride(source) == target);
    }
    for (const char *pInvalid : {
        " evades damage", "Ariel hits Goblin for much damage", "Ariel shoots Goblin for -1 points",
        "Ariel inflicts some points killing Goblin", "Ariel paralyzes ", "Ariel stuns ",
        "Ariel hits for 12 damage", "Ariel: 피해 회피", "monster_attack_result result=evaded"})
    {
        CAPTURE(pInvalid);
        CHECK_FALSE(OpenYAMM::Game::KoreanRuntimeText::combatStatusText(pInvalid).has_value());
    }
}

TEST_CASE("Keyboard descriptions localize without changing physical key legends or unknown actions")
{
    using OpenYAMM::Game::KoreanRuntimeText::keyboardActionLabel;
    using OpenYAMM::Game::KoreanRuntimeText::keyboardBindingLabel;
    CHECK(keyboardActionLabel("Forward") == "앞으로");
    CHECK(keyboardActionLabel("Char Cycle") == "캐릭터 전환");
    CHECK(keyboardActionLabel("Quick Ref") == "파티 요약");
    CHECK(keyboardActionLabel("Cast Ready") == "빠른 주문 시전");
    CHECK(keyboardActionLabel("Left", true) == "왼쪽 회전");
    CHECK(keyboardActionLabel("Right", true) == "오른쪽 회전");
    CHECK(keyboardActionLabel("Left", false) == "왼쪽 이동");
    CHECK(keyboardActionLabel("Right", false) == "오른쪽 이동");
    CHECK(keyboardActionLabel("Cast Ready", true) == "빠른 주문 시전");
    CHECK(keyboardActionLabel("Custom Action") == "Custom Action");
    CHECK(keyboardActionLabel("앞으로") == "앞으로");
    CHECK(keyboardBindingLabel("Unbound") == "미지정");
    CHECK(keyboardBindingLabel("LMB") == "마우스 1");
    CHECK(keyboardBindingLabel("Mouse 5") == "마우스 5");
    CHECK(keyboardBindingLabel("Page Down") == "Page Down");
    CHECK(keyboardBindingLabel("Q") == "Q");
    CHECK_FALSE(koreanRuntimeTextOverride("forward").has_value());
}

TEST_CASE("Adventurers inn and item inspection captions localize after resolving game data")
{
    const std::pair<const char *, const char *> captions[] = {
        {"Name: Sword", "이름: Sword"}, {"Name: 미나", "이름: 미나"},
        {"Class: Master Archer", "직업: 명궁"}, {"Class: 기사", "직업: 기사"},
        {"Type: Sword", "유형: 검"}, {"Type: Misc", "유형: 기타"}, {"Type: 가죽 갑옷", "유형: 가죽 갑옷"},
        {"Cond: Good", "상태: 양호"}, {"Cond: Poisoned", "상태: 중독"},
        {"QSpell: None", "빠른 주문: 없음"}, {"QSpell: 화염구", "빠른 주문: 화염구"},
        {"HP: -5", "생명력: -5"}, {"SP: 100", "주문력: 100"}, {"AC: 20", "방어력: 20"},
        {"Level: 50", "레벨: 50"}, {"Skills: 8", "기술: 8"}, {"Points: 13", "기술 점수: 13"},
        {"Dmg: 10-20", "피해: 10-20"}, {"Attack: +5", "공격: +5"}, {"Shoot: -3", "사격: -3"},
    };
    for (const auto &[source, target] : captions)
    {
        CAPTURE(source);
        CHECK(koreanRuntimeTextOverride(source) == target);
    }
}

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
    CHECK(koreanRuntimeTextOverride("Endurance") == "체력");
    CHECK(koreanRuntimeTextOverride("You must have at least 50 base Endurance to learn Master Bodybuilding.")
        == "체력 단련을 마스터하려면 기본 체력이 50 이상이어야 합니다.");
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
