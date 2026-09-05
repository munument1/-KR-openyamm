#pragma once

#include <optional>
#include <string>
#include <string_view>

namespace OpenYAMM::Game::KoreanRuntimeText
{
inline bool calendarNumber(std::string_view value)
{
    return !value.empty() && value.find_first_not_of("0123456789") == std::string_view::npos;
}

inline std::optional<std::string> koreanClockTextOverride(std::string_view text)
{
    if (!text.ends_with("AM") && !text.ends_with("PM"))
    {
        return std::nullopt;
    }
    const bool afternoon = text.ends_with("PM");
    text.remove_suffix(2);
    if (text.ends_with(' '))
    {
        text.remove_suffix(1);
    }
    static constexpr std::string_view Days[] = {
        "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
    static constexpr std::string_view KoreanDays[] = {
        "월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"};
    std::string weekday;
    for (size_t index = 0; index < 7; ++index)
    {
        const std::string full = std::string(Days[index]) + " ";
        const std::string shortName = std::string(Days[index].substr(0, 3)) + " ";
        if (text.starts_with(full) || text.starts_with(shortName))
        {
            text.remove_prefix(text.starts_with(full) ? full.size() : shortName.size());
            weekday = std::string(KoreanDays[index]) + " ";
            break;
        }
    }
    const size_t colon = text.find(':');
    if ((colon != 1 && colon != 2) || text.size() != colon + 3
        || !calendarNumber(text.substr(0, colon)) || !calendarNumber(text.substr(colon + 1)))
    {
        return std::nullopt;
    }
    const int hour = std::stoi(std::string(text.substr(0, colon)));
    const int minute = std::stoi(std::string(text.substr(colon + 1)));
    if (hour < 1 || hour > 12 || minute > 59)
    {
        return std::nullopt;
    }
    return weekday + (afternoon ? "오후 " : "오전 ") + std::string(text);
}

inline std::optional<std::string> koreanDateTextOverride(std::string_view text)
{
    static constexpr std::string_view Months[] = {
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"};
    for (size_t month = 0; month < 12; ++month)
    {
        std::string_view day;
        std::string_view year;
        const std::string middle = " " + std::string(Months[month]) + " ";
        const std::string prefix = std::string(Months[month].substr(0, 3)) + " ";
        const size_t monthStart = text.find(middle);
        if (monthStart != std::string_view::npos)
        {
            day = text.substr(0, monthStart);
            year = text.substr(monthStart + middle.size());
        }
        else if (text.starts_with(prefix))
        {
            const size_t comma = text.find(", ", prefix.size());
            if (comma == std::string_view::npos)
            {
                continue;
            }
            day = text.substr(prefix.size(), comma - prefix.size());
            year = text.substr(comma + 2);
        }
        if (day.size() > 2 || !calendarNumber(day) || !calendarNumber(year))
        {
            continue;
        }
        const int dayNumber = std::stoi(std::string(day));
        if (dayNumber >= 1 && dayNumber <= 31)
        {
            return std::string(year) + "년 " + std::to_string(month + 1) + "월 " + std::string(day) + "일";
        }
    }
    return std::nullopt;
}
}
