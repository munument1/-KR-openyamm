#include "game/party/SkillData.h"
#include "game/ui/KoreanRuntimeTextOverrides.h"
#include "game/ui/Utf8Text.h"

#include <doctest/doctest.h>

using namespace OpenYAMM::Game;

TEST_CASE("Every registered character skill and mastery fits its Korean skill-page label")
{
    const SkillMastery ranks[] = {
        SkillMastery::None, SkillMastery::Normal, SkillMastery::Expert,
        SkillMastery::Master, SkillMastery::Grandmaster,
    };
    const std::vector<std::string> skills = allCanonicalSkillNames();
    REQUIRE(skills.size() == 40);
    for (const std::string &skill : skills)
    {
        for (SkillMastery rank : ranks)
        {
            const std::string label = KoreanRuntimeText::characterSkillLabel(
                displaySkillName(skill), masteryDisplayName(rank));
            CAPTURE(skill);
            CAPTURE(label);
            CHECK(label.find_first_of("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz") == std::string::npos);
            float width = 0.0f;
            for (size_t offset = 0; offset < label.size(); offset = nextUtf8CodePointOffset(label, offset))
            {
                const Utf8CodePointSpan span = decodeUtf8CodePoint(label, offset);
                REQUIRE(span.valid);
                width += span.codePoint == ' ' ? 6.0f : 12.0f;
            }
            // The narrower skill-name column is 154 logical pixels, less a 6-pixel gap.
            CHECK(width <= 148.0f);
        }
    }
}
