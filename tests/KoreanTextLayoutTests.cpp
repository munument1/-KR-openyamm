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
