#include "game/ui/KoreanRuntimeTextOverrides.h"
#include "game/ui/Utf8LabelLayout.h"

#include <doctest/doctest.h>

using namespace OpenYAMM::Game;

namespace
{
float labelWidth(const std::string &text)
{
    float width = 0.0f;
    for (size_t offset = 0; offset < text.size(); offset = nextUtf8CodePointOffset(text, offset))
    {
        REQUIRE(decodeUtf8CodePoint(text, offset).valid);
        width += 1.0f;
    }
    return width;
}
}

TEST_CASE("Action label truncation preserves complete UTF-8 characters and fits narrow boxes")
{
    CHECK(ellipsizeUtf8Label("가나다라마바사", 5.0f, labelWidth) == "가나...");
    CHECK(ellipsizeUtf8Label("가나다라마바사", 2.0f, labelWidth) == "..");
    CHECK(ellipsizeUtf8Label("가나다라마바사", 0.0f, labelWidth).empty());
    CHECK(ellipsizeUtf8Label("한글", 2.0f, labelWidth) == "한글");
    CHECK(ellipsizeUtf8Label("abcd", 3.0f, labelWidth) == "...");
}

TEST_CASE("Action labels use two lines without duplicating the first word of the second line")
{
    CHECK(fitUtf8LabelToTwoLines("AAAA BB CC DD EEE", 7.0f, labelWidth)
        == std::vector<std::string>{"AAAA BB", "CC D..."});
    CHECK(fitUtf8LabelToTwoLines("가나다라마바사아자차카타파하", 8.0f, labelWidth)
        == std::vector<std::string>{"가나다라마바사아", "자차카타파하"});
    CHECK(fitUtf8LabelToTwoLines("상자 열기", 4.0f, labelWidth)
        == std::vector<std::string>{"상자", "열기"});
    CHECK(fitUtf8LabelToTwoLines("  상자  ", 4.0f, labelWidth) == std::vector<std::string>{"상자"});
    CHECK(fitUtf8LabelToTwoLines("   ", 4.0f, labelWidth).empty());
    CHECK(fitUtf8LabelToTwoLines("상자", 0.0f, labelWidth).empty());
}

TEST_CASE("Named action labels translate before fitting at different display scales")
{
    const auto translated = KoreanRuntimeText::koreanRuntimeTextOverride("Open Chest (고대 보물 상자)");
    REQUIRE(translated.has_value());
    CHECK(*translated == "상자 열기 (고대 보물 상자)");
    CHECK(KoreanRuntimeText::koreanRuntimeTextOverride("Open Chest (Ancient Chest)")
        == "상자 열기 (Ancient Chest)");
    for (float scale : {0.5f, 1.0f, 2.0f, 3.0f})
    {
        const auto measure = [scale](const std::string &value) { return labelWidth(value) * scale; };
        const auto lines = fitUtf8LabelToTwoLines(*translated, 9.0f * scale, measure);
        REQUIRE(lines.size() == 2);
        CHECK(lines[0] + " " + lines[1] == *translated);
        for (const std::string &line : lines)
        {
            CHECK(measure(line) <= 9.0f * scale);
        }
    }
}

TEST_CASE("All fitted action lines remain valid and within width")
{
    for (const std::string text : {"ABCDEFGHIJKLMN", "아주긴한글이름의아이템", "상자 열기 (A와 B의 보물)"})
    {
        for (int width = 1; width <= 25; ++width)
        {
            const auto lines = fitUtf8LabelToTwoLines(text, static_cast<float>(width), labelWidth);
            CHECK(lines.size() <= 2);
            for (const std::string &line : lines)
            {
                CHECK(labelWidth(line) <= width);
            }
        }
    }
}
