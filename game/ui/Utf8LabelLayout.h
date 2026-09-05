#pragma once

#include "game/ui/Utf8Text.h"

#include <algorithm>
#include <cmath>
#include <limits>
#include <string>
#include <vector>

namespace OpenYAMM::Game
{
inline std::string trimLabelSpaces(const std::string &text)
{
    const size_t begin = text.find_first_not_of(' ');
    return begin == std::string::npos ? "" : text.substr(begin, text.find_last_not_of(' ') - begin + 1);
}

template <typename MeasureWidth>
std::string ellipsizeUtf8Label(const std::string &text, float maxWidth, MeasureWidth measureWidth)
{
    if (maxWidth <= 0.0f)
    {
        return "";
    }
    if (measureWidth(text) <= maxWidth)
    {
        return text;
    }
    std::string ellipsis = "...";
    while (!ellipsis.empty() && measureWidth(ellipsis) > maxWidth)
    {
        ellipsis.pop_back();
    }
    std::string prefix = text;
    while (!prefix.empty())
    {
        prefix.resize(previousUtf8CodePointOffset(prefix, prefix.size()));
        prefix = trimLabelSpaces(prefix);
        if (measureWidth(prefix + ellipsis) <= maxWidth)
        {
            return prefix + ellipsis;
        }
    }
    return ellipsis;
}

// Localize the complete label first. Widths include the caller's display scale.
template <typename MeasureWidth>
std::vector<std::string> fitUtf8LabelToTwoLines(
    const std::string &source, float maxWidth, MeasureWidth measureWidth)
{
    const std::string text = trimLabelSpaces(source);
    if (text.empty() || maxWidth <= 0.0f)
    {
        return {};
    }
    if (measureWidth(text) <= maxWidth)
    {
        return {text};
    }

    // Preserve the original preference for balanced lines split between words.
    size_t bestSplit = std::string::npos;
    float bestScore = std::numeric_limits<float>::max();
    for (size_t split = text.find(' '); split != std::string::npos; split = text.find(' ', split + 1))
    {
        const std::string first = trimLabelSpaces(text.substr(0, split));
        const std::string second = trimLabelSpaces(text.substr(split + 1));
        const float firstWidth = measureWidth(first);
        const float secondWidth = measureWidth(second);
        if (!first.empty() && !second.empty() && firstWidth <= maxWidth && secondWidth <= maxWidth)
        {
            const float score = std::max(firstWidth, secondWidth) + std::abs(firstWidth - secondWidth) * 0.25f;
            if (score < bestScore)
            {
                bestScore = score;
                bestSplit = split;
            }
        }
    }
    if (bestSplit != std::string::npos)
    {
        return {trimLabelSpaces(text.substr(0, bestSplit)), trimLabelSpaces(text.substr(bestSplit + 1))};
    }

    size_t prefixEnd = 0;
    while (prefixEnd < text.size())
    {
        const size_t next = nextUtf8CodePointOffset(text, prefixEnd);
        if (measureWidth(text.substr(0, next)) > maxWidth)
        {
            break;
        }
        prefixEnd = next;
    }
    if (prefixEnd == 0)
    {
        return {ellipsizeUtf8Label(text, maxWidth, measureWidth)};
    }
    // Prefer a whole first word; split an unspaced Korean label only at a code point.
    const size_t lastSpace = text.rfind(' ', prefixEnd);
    if (lastSpace != std::string::npos && lastSpace > 0)
    {
        prefixEnd = lastSpace;
    }
    const std::string first = trimLabelSpaces(text.substr(0, prefixEnd));
    const std::string remaining = trimLabelSpaces(text.substr(prefixEnd));
    return {first, ellipsizeUtf8Label(remaining, maxWidth, measureWidth)};
}
}
