#include "game/ui/KoreanFontMetrics.h"
#include "game/ui/KoreanRuntimeTextOverrides.h"
#include "game/ui/Utf8TextWrapping.h"

#include <doctest/doctest.h>

using namespace OpenYAMM::Game;

namespace
{
float codePointWidth(const std::string &text)
{
    float width = 0.0f;
    for (size_t offset = 0; offset < text.size(); offset = nextUtf8CodePointOffset(text, offset))
    {
        const Utf8CodePointSpan span = decodeUtf8CodePoint(text, offset);
        REQUIRE(span.valid);
        width += span.codePoint == ' ' ? 6.0f : 12.0f;
    }
    return width;
}
}

TEST_CASE("Character creation localizes complete skill names before wrapping")
{
    const std::pair<const char *, const char *> cases[] = {
        {"Vampire Ability", "뱀파이어 능력"},
        {"Mind Magic", "정신 마법"},
        {"Disarm Traps", "함정 해제"},
        {"Identify Monster", "몬스터 식별"},
        {"Body Building", "체력 단련"},
        {"Leather", "가죽 갑옷"},
    };
    for (const auto &[source, expected] : cases)
    {
        const std::optional<std::string> translated = KoreanRuntimeText::koreanRuntimeTextOverride(source);
        REQUIRE(translated.has_value());
        CHECK(*translated == expected);
        const std::vector<std::string> lines = wrapUtf8Text(*translated, 84.0f, codePointWidth);
        REQUIRE(lines.size() == 1);
        CHECK(lines.front() == expected);
    }
}

TEST_CASE("Wrapping preserves UTF-8, word order and explicit blank lines")
{
    CHECK(wrapUtf8Text("앞 아주긴한글단어 뒤", 36.0f, codePointWidth)
        == std::vector<std::string>{"앞", "아주긴", "한글단", "어 뒤"});
    CHECK(wrapUtf8Text("가나다", 1.0f, codePointWidth)
        == std::vector<std::string>{"가", "나", "다"});
    CHECK(wrapUtf8Text("가\n\n나\n", 84.0f, codePointWidth)
        == std::vector<std::string>{"가", "", "나", ""});
    CHECK(wrapUtf8Text("A 가나다라 B", 36.0f, codePointWidth)
        == std::vector<std::string>{"A", "가나다", "라 B"});
    CHECK(wrapUtf8Text("", 84.0f, codePointWidth).empty());
    CHECK(wrapUtf8Text("AB CD", 0.0f, codePointWidth)
        == std::vector<std::string>{"A", "B", "C", "D"});
}

TEST_CASE("Quick reference labels translate and fit their 60 pixel layout columns")
{
    const std::pair<const char *, const char *> labels[] = {
        {"Name", "이름"}, {"Level", "레벨"}, {"Class", "직업"}, {"HP", "생명력"},
        {"SP", "주문력"}, {"AC", "방어력"}, {"Attack", "공격"}, {"Dmg", "피해"},
        {"Shoot", "사격"}, {"Skills", "기술"}, {"Points", "점수"}, {"Cond", "상태"},
        {"QSpell", "빠른 주문"},
    };
    for (const auto &[source, target] : labels)
    {
        CAPTURE(source);
        const std::optional<std::string> translated = KoreanRuntimeText::koreanRuntimeTextOverride(source);
        REQUIRE(translated.has_value());
        CHECK(*translated == target);
        CHECK(codePointWidth(*translated) <= 60.0f);
    }
}

TEST_CASE("Runtime YAML captions and tabs have complete Korean display translations")
{
    const std::pair<const char *, const char *> labels[] = {
        {"Hit Points", "생명력"}, {"Spell Points", "주문력"}, {"Armor Class", "방어력"},
        {"Skill Points:", "기술 점수:"}, {"Condition:", "상태:"}, {"Quick Spell:", "빠른 주문:"},
        {"Age", "나이"}, {"Experience", "경험치"}, {"Resistances", "저항력"},
        {"Fire", "화염"}, {"Air", "대기"}, {"Water", "물"}, {"Earth", "대지"}, {"Mind", "정신"},
        {"Body", "신체"}, {"Spirit", "영혼"}, {"Light", "빛"}, {"Dark", "어둠"}, {"Physical", "물리"},
        {"Weapons", "무기"}, {"Armor", "방어구"}, {"Magic", "마법"}, {"Misc", "기타"},
        {"Effects", "효과"}, {"Spell", "주문"}, {"Damage", "피해"},
        {"Day", "일"}, {"Month", "월"}, {"Year", "년"},
        {"Set Beacon", "봉화 설치"}, {"Recall Beacon", "봉화로 귀환"},
    };
    for (const auto &[source, target] : labels)
    {
        CAPTURE(source);
        CHECK(KoreanRuntimeText::koreanRuntimeTextOverride(source) == target);
    }
}

TEST_CASE("Party overview distinguishes class names from mastery terms and translates reputation")
{
    using namespace KoreanRuntimeText;
    CHECK(className("Knight") == "기사");
    CHECK(className("Master") == "달인");
    CHECK(className("Master Archer") == "명궁");
    CHECK(className("Priest of the Light") == "빛의 사제");
    CHECK(className("Custom Class") == "Custom Class");
    CHECK(className("기사") == "기사");
    CHECK(koreanRuntimeTextOverride("Reputation:") == "평판:");
    CHECK(koreanRuntimeTextOverride("Saintly") == "고결함");
    CHECK(koreanRuntimeTextOverride("Friendly") == "우호적");
    CHECK(koreanRuntimeTextOverride("Neutral") == "중립");
    CHECK(koreanRuntimeTextOverride("Unfriendly") == "비우호적");
    CHECK(koreanRuntimeTextOverride("Notorious") == "악명 높음");
    CHECK(koreanRuntimeTextOverride("Fame: 123456") == "명성: 123456");
}

TEST_CASE("Galmuri11 uses native integer pixel grids without overflowing its line")
{
    CHECK(koreanFontEmPixels(14) == 12.0f);
    CHECK(koreanFontEmPixels(19) == 12.0f);
    CHECK(koreanFontEmPixels(28) == 24.0f);
    for (int height = 6; height <= 64; ++height)
    {
        CHECK(koreanFontEmPixels(height) * 14.0f / 12.0f <= doctest::Approx(height));
    }
}

TEST_CASE("Victory certificate localizes names, classes, score and singular or plural time units")
{
    using KoreanRuntimeText::koreanRuntimeTextOverride;
    CHECK(koreanRuntimeTextOverride("Congratulations!") == "축하합니다!");
    CHECK(koreanRuntimeTextOverride("Alice the Level 50 Master Archer") == "Alice - 레벨 50 명궁");
    CHECK(koreanRuntimeTextOverride("미나 the Level 1 Adventurer") == "미나 - 레벨 1 모험가");
    CHECK(koreanRuntimeTextOverride("the Level Song the Level 12 Knight") == "the Level Song - 레벨 12 기사");
    CHECK(koreanRuntimeTextOverride("미나 the Level 10 기사") == "미나 - 레벨 10 기사");
    CHECK_FALSE(koreanRuntimeTextOverride("Alice the Level high Knight").has_value());
    CHECK_FALSE(koreanRuntimeTextOverride("Alice the Level 12").has_value());
    CHECK(koreanRuntimeTextOverride("Your score: 12345") == "점수: 12345");
    CHECK(koreanRuntimeTextOverride("Total Time: 0 Years, 0 Months, 0 Days") == "총 시간: 0년, 0개월, 0일");
    CHECK(koreanRuntimeTextOverride("Total Time: 1 Year, 1 Month, 1 Day") == "총 시간: 1년, 1개월, 1일");
    CHECK(koreanRuntimeTextOverride("Total Time: 2 Years, 1 Month, 27 Days") == "총 시간: 2년, 1개월, 27일");
}

TEST_CASE("The complete translated ending fits above the certificate time line")
{
    const std::string source =
        "Excellent work! By thwarting the Destroyer of Worlds, you have pulled your world from the brink of "
        "unending oblivion. Not only may life continue, but a new peace reigns over Jadame. The mighty alliance "
        "you forged will see to the land's restoration and eventual prosperity.";
    const std::optional<std::string> translated = KoreanRuntimeText::koreanRuntimeTextOverride(source);
    REQUIRE(translated.has_value());
    const std::vector<std::string> lines = wrapUtf8Text(*translated, 520.0f, codePointWidth);
    REQUIRE_FALSE(lines.empty());
    // ENDGAME has 20-pixel lines with 3-pixel leading; text starts at 230, time at 355.
    CHECK(lines.size() * 23 <= 355 - 230);
    std::string reconstructed;
    for (const std::string &line : lines)
    {
        CHECK(codePointWidth(line) <= 520.0f);
        CHECK(line.find_first_of("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz") == std::string::npos);
        reconstructed += (reconstructed.empty() ? "" : " ") + line;
    }
    CHECK(reconstructed == *translated);
}
