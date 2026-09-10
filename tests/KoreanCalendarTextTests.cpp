#include "game/ui/KoreanRuntimeTextOverrides.h"

#include <doctest/doctest.h>

using OpenYAMM::Game::KoreanRuntimeText::koreanRuntimeTextOverride;

TEST_CASE("Both save screen clock formats translate every weekday and meridiem")
{
    const std::pair<const char *, const char *> days[] = {
        {"Monday", "월요일"}, {"Tuesday", "화요일"}, {"Wednesday", "수요일"},
        {"Thursday", "목요일"}, {"Friday", "금요일"}, {"Saturday", "토요일"}, {"Sunday", "일요일"},
    };
    for (const auto &[source, target] : days)
    {
        const std::string day = source;
        const std::string translated = target;
        CHECK(koreanRuntimeTextOverride(day + " 09:00AM") == translated + " 오전 09:00");
        CHECK(koreanRuntimeTextOverride(day + " 12:00PM") == translated + " 오후 12:00");
        CHECK(koreanRuntimeTextOverride(day.substr(0, 3) + " 9:00 AM") == translated + " 오전 9:00");
        CHECK(koreanRuntimeTextOverride(day.substr(0, 3) + " 12:00 PM") == translated + " 오후 12:00");
    }
    CHECK(koreanRuntimeTextOverride("12:00 AM") == "오전 12:00");
    CHECK(koreanRuntimeTextOverride("12:00 PM") == "오후 12:00");
    CHECK(koreanRuntimeTextOverride("2:30 PM") == "오후 2:30");
    CHECK(koreanRuntimeTextOverride("11:59PM") == "오후 11:59");
}

TEST_CASE("Both save screen date formats translate all twelve months")
{
    const std::string months[] = {
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December",
    };
    for (size_t month = 0; month < 12; ++month)
    {
        const std::string expected = "1168년 " + std::to_string(month + 1) + "월 1일";
        CHECK(koreanRuntimeTextOverride("1 " + months[month] + " 1168") == expected);
        CHECK(koreanRuntimeTextOverride(months[month].substr(0, 3) + " 1, 1168") == expected);
    }
    CHECK(koreanRuntimeTextOverride("31 December 1168") == "1168년 12월 31일");
    CHECK(koreanRuntimeTextOverride("Jan 01, 0001") == "0001년 1월 01일");
}

TEST_CASE("Calendar matching does not rewrite malformed fields or unrelated prose")
{
    const char *invalid[] = {
        "Monday 00:00AM", "Mon 13:00 PM", "9:60 AM", "9:1 AM", "9:000 AM", "-1:00 AM",
        "99999999999999999:00 AM", "Mon 9:xx AM", "Someday 9:00 AM", "Meet me at 9:00 AM",
        "9:00  AM", "9:00 am", "AM", "PM", "", "0 January 1168", "32 January 1168",
        "999999999999 January 1168", "Jan 1, year", "Jan 1, ", "Jan , 1168", "Jan 1 1168",
        "1 January", "In January 1168", "1 January 1168 more", "January 1, 1168",
    };
    for (const char *text : invalid)
    {
        CAPTURE(text);
        CHECK_FALSE(koreanRuntimeTextOverride(text).has_value());
    }
}
