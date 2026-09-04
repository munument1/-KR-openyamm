#pragma once

#include <cstddef>
#include <cstdint>
#include <string_view>

namespace OpenYAMM::Game
{
struct Utf8CodePointSpan
{
    uint32_t codePoint = 0xfffdu;
    size_t byteOffset = 0;
    size_t byteLength = 1;
    bool valid = false;
};

inline bool isUtf8ContinuationByte(unsigned char byte)
{
    return (byte & 0xc0u) == 0x80u;
}

inline Utf8CodePointSpan decodeUtf8CodePoint(std::string_view text, size_t byteOffset)
{
    Utf8CodePointSpan result = {};
    result.byteOffset = byteOffset;

    if (byteOffset >= text.size())
    {
        result.byteLength = 0;
        return result;
    }

    const unsigned char first = static_cast<unsigned char>(text[byteOffset]);

    if (first < 0x80u)
    {
        result.codePoint = first;
        result.byteLength = 1;
        result.valid = true;
        return result;
    }

    size_t byteLength = 0;
    uint32_t codePoint = 0;
    uint32_t minimumCodePoint = 0;

    if ((first & 0xe0u) == 0xc0u)
    {
        byteLength = 2;
        codePoint = first & 0x1fu;
        minimumCodePoint = 0x80u;
    }
    else if ((first & 0xf0u) == 0xe0u)
    {
        byteLength = 3;
        codePoint = first & 0x0fu;
        minimumCodePoint = 0x800u;
    }
    else if ((first & 0xf8u) == 0xf0u)
    {
        byteLength = 4;
        codePoint = first & 0x07u;
        minimumCodePoint = 0x10000u;
    }
    else
    {
        return result;
    }

    if (byteOffset + byteLength > text.size())
    {
        return result;
    }

    for (size_t continuationIndex = 1; continuationIndex < byteLength; ++continuationIndex)
    {
        const unsigned char continuation = static_cast<unsigned char>(text[byteOffset + continuationIndex]);
        if (!isUtf8ContinuationByte(continuation))
        {
            return result;
        }
        codePoint = (codePoint << 6u) | (continuation & 0x3fu);
    }

    const bool surrogate = codePoint >= 0xd800u && codePoint <= 0xdfffu;
    const bool outOfRange = codePoint > 0x10ffffu;
    const bool overlong = codePoint < minimumCodePoint;

    if (surrogate || outOfRange || overlong)
    {
        return result;
    }

    result.codePoint = codePoint;
    result.byteLength = byteLength;
    result.valid = true;
    return result;
}

inline size_t nextUtf8CodePointOffset(std::string_view text, size_t byteOffset)
{
    if (byteOffset >= text.size())
    {
        return text.size();
    }

    const Utf8CodePointSpan span = decodeUtf8CodePoint(text, byteOffset);
    return byteOffset + (span.byteLength > 0 ? span.byteLength : 1);
}

inline size_t previousUtf8CodePointOffset(std::string_view text, size_t byteOffset)
{
    size_t offset = byteOffset < text.size() ? byteOffset : text.size();

    if (offset == 0)
    {
        return 0;
    }

    --offset;
    while (offset > 0 && isUtf8ContinuationByte(static_cast<unsigned char>(text[offset])))
    {
        --offset;
    }
    return offset;
}

inline bool isHangulCodePoint(uint32_t codePoint)
{
    return (codePoint >= 0x1100u && codePoint <= 0x11ffu)
        || (codePoint >= 0x3130u && codePoint <= 0x318fu)
        || (codePoint >= 0xa960u && codePoint <= 0xa97fu)
        || (codePoint >= 0xac00u && codePoint <= 0xd7a3u)
        || (codePoint >= 0xd7b0u && codePoint <= 0xd7ffu);
}

inline bool isCjkCodePoint(uint32_t codePoint)
{
    return isHangulCodePoint(codePoint)
        || (codePoint >= 0x3040u && codePoint <= 0x30ffu)
        || (codePoint >= 0x3400u && codePoint <= 0x4dbfu)
        || (codePoint >= 0x4e00u && codePoint <= 0x9fffu)
        || (codePoint >= 0xf900u && codePoint <= 0xfaffu);
}
} // namespace OpenYAMM::Game
