#pragma once

#include "game/ui/Utf8Text.h"

#include <string>
#include <vector>

namespace OpenYAMM::Game
{
// The caller must localize the complete text before measuring or splitting it.
template <typename MeasureWidth>
std::vector<std::string> wrapUtf8Text(const std::string &text, float maxWidth, MeasureWidth measureWidth)
{
    std::vector<std::string> lines;
    if (text.empty())
    {
        return lines;
    }
    size_t paragraphStart = 0;
    while (paragraphStart <= text.size())
    {
        const size_t paragraphEnd = text.find('\n', paragraphStart);
        const std::string paragraph = text.substr(paragraphStart, paragraphEnd == std::string::npos
            ? std::string::npos : paragraphEnd - paragraphStart);
        std::string currentLine;
        size_t wordStart = 0;
        while (wordStart < paragraph.size())
        {
            wordStart = paragraph.find_first_not_of(' ', wordStart);
            if (wordStart == std::string::npos)
            {
                break;
            }
            const size_t separator = paragraph.find(' ', wordStart);
            const size_t wordEnd = separator == std::string::npos ? paragraph.size() : separator;
            std::string word = paragraph.substr(wordStart, wordEnd - wordStart);
            const std::string candidate = currentLine.empty() ? word : currentLine + " " + word;
            if (!currentLine.empty() && measureWidth(candidate) > maxWidth)
            {
                lines.push_back(currentLine);
                currentLine.clear();
            }
            while (!word.empty() && measureWidth(word) > maxWidth)
            {
                // Always consume at least one whole code point, even if it cannot fit.
                size_t splitLength = nextUtf8CodePointOffset(word, 0);
                while (splitLength < word.size())
                {
                    const size_t next = nextUtf8CodePointOffset(word, splitLength);
                    if (measureWidth(word.substr(0, next)) > maxWidth)
                    {
                        break;
                    }
                    splitLength = next;
                }
                lines.push_back(word.substr(0, splitLength));
                word.erase(0, splitLength);
            }
            if (!word.empty())
            {
                currentLine = currentLine.empty() ? word : currentLine + " " + word;
            }
            wordStart = wordEnd;
        }
        if (!currentLine.empty() || paragraph.empty())
        {
            lines.push_back(currentLine);
        }
        if (paragraphEnd == std::string::npos)
        {
            break;
        }
        paragraphStart = paragraphEnd + 1;
    }
    return lines;
}
}
