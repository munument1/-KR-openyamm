
float GameplayHudCommon::measureHudTextWidth(const GameplayHudFontData &font, const std::string &text)
{
    float widthPixels = 0.0f;
    const std::string_view textView(text);
    size_t byteOffset = 0;

    while (byteOffset < textView.size())
    {
        const Utf8CodePointSpan span = decodeUtf8CodePoint(textView, byteOffset);
        if (span.codePoint == '\r' || span.codePoint == '\n')
        {
            break;
        }
        widthPixels += unicodeGlyphAdvance(font, span.codePoint);
        byteOffset = nextUtf8CodePointOffset(textView, byteOffset);
    }

    return std::max(0.0f, widthPixels);
}

std::string GameplayHudCommon::clampHudTextToWidth(
    const GameplayHudFontData &font,
    const std::string &text,
    float maxWidth)
{
    std::string clampedText = text;
    while (!clampedText.empty() && measureHudTextWidth(font, clampedText) > maxWidth)
    {
        const size_t previousOffset = previousUtf8CodePointOffset(clampedText, clampedText.size());
        clampedText.resize(previousOffset);
    }
    return clampedText;
}

std::vector<std::string> GameplayHudCommon::wrapHudTextToWidth(
    const GameplayHudFontData &font,
    const std::string &text,
    float maxWidth)
{
    if (text.empty())
    {
        return {""};
    }
    if (maxWidth <= 0.0f)
    {
        return {text};
    }

    std::vector<std::string> lines;
    std::string currentLine;
    std::string currentWord;
    bool pendingSpace = false;

    const auto flushLine = [&lines, &currentLine]()
    {
        lines.push_back(currentLine);
        currentLine.clear();
    };

    const auto appendWord = [&font, &currentLine, &currentWord, &pendingSpace, &flushLine, maxWidth]()
    {
        if (currentWord.empty())
        {
            return;
        }

        std::string candidate = currentLine;
        if (!candidate.empty() && pendingSpace)
        {
            candidate.push_back(' ');
        }
        candidate += currentWord;

        if (currentLine.empty() || measureHudTextWidth(font, candidate) <= maxWidth)
        {
            currentLine = std::move(candidate);
        }
        else
        {
            flushLine();
            currentLine = currentWord;
        }
        currentWord.clear();
        pendingSpace = false;
    };

    const std::string_view textView(text);
    size_t byteOffset = 0;
    while (byteOffset < textView.size())
    {
        const Utf8CodePointSpan span = decodeUtf8CodePoint(textView, byteOffset);
        const uint32_t codePoint = span.codePoint;

        if (codePoint == '\r')
        {
            byteOffset = nextUtf8CodePointOffset(textView, byteOffset);
            continue;
        }
        if (codePoint == '\n')
        {
            appendWord();
            flushLine();
            pendingSpace = false;
            byteOffset = nextUtf8CodePointOffset(textView, byteOffset);
            continue;
        }
        if (codePoint == ' ')
        {
            appendWord();
            pendingSpace = !currentLine.empty();
            byteOffset = nextUtf8CodePointOffset(textView, byteOffset);
            continue;
        }

        if (isCjkLineBreakCodePoint(codePoint))
        {
            appendWord();
            std::string glyphText;
            appendUtf8Span(glyphText, textView, span);
            std::string candidate = currentLine;
            if (!candidate.empty() && pendingSpace)
            {
                candidate.push_back(' ');
            }
            candidate += glyphText;

            if (!currentLine.empty() && measureHudTextWidth(font, candidate) > maxWidth)
            {
                flushLine();
                candidate = glyphText;
            }
            currentLine = std::move(candidate);
            pendingSpace = false;
        }
        else
        {
            appendUtf8Span(currentWord, textView, span);
        }

        byteOffset = nextUtf8CodePointOffset(textView, byteOffset);
    }

    appendWord();
    if (!currentLine.empty() || lines.empty())
    {
        lines.push_back(currentLine);
    }
    return lines;
}

void GameplayHudCommon::renderHudFontLayer(
    const GameplayHudFontData &font,
    bgfx::TextureHandle textureHandle,
    const std::string &text,
    float textX,
    float textY,
    float fontScale,
    const SubmitTexturedQuadFn &submitTexturedQuad)
{
    if (!bgfx::isValid(textureHandle))
    {
        return;
    }

    float penX = textX;
    const std::string_view textView(text);
    size_t byteOffset = 0;
    while (byteOffset < textView.size())
    {
        const Utf8CodePointSpan span = decodeUtf8CodePoint(textView, byteOffset);
        const uint32_t codePoint = span.codePoint;
        if (codePoint == '\r' || codePoint == '\n')
        {
            break;
        }

        if (codePoint <= 0xffu)
        {
            const unsigned char character = static_cast<unsigned char>(codePoint);
            if (character >= font.firstChar && character <= font.lastChar)
            {
                const GameplayHudFontGlyphMetricsData &metrics = font.glyphMetrics[character];
                penX += static_cast<float>(metrics.leftSpacing) * fontScale;
                if (metrics.width > 0)
                {
                    const int cellX = (character % 16) * font.atlasCellWidth;
                    const int cellY = (character / 16) * font.fontHeight;
                    const float u0 = static_cast<float>(cellX) / font.atlasWidth;
                    const float v0 = static_cast<float>(cellY) / font.atlasHeight;
                    const float u1 = static_cast<float>(cellX + metrics.width) / font.atlasWidth;
                    const float v1 = static_cast<float>(cellY + font.fontHeight) / font.atlasHeight;
                    submitTexturedQuad(
                        textureHandle,
                        penX,
                        textY,
                        static_cast<float>(metrics.width) * fontScale,
                        static_cast<float>(font.fontHeight) * fontScale,
                        u0,
                        v0,
                        u1,
                        v1,
                        TextureFilterProfile::Text);
                }
                penX += static_cast<float>(metrics.width + metrics.rightSpacing) * fontScale;
                byteOffset = nextUtf8CodePointOffset(textView, byteOffset);
                continue;
            }
        }

        const auto glyphIterator = font.unicodeGlyphs.find(codePoint);
        if (glyphIterator == font.unicodeGlyphs.end())
        {
            penX += unicodeGlyphAdvance(font, codePoint) * fontScale;
            byteOffset = nextUtf8CodePointOffset(textView, byteOffset);
            continue;
        }

        const GameplayHudUnicodeGlyphData &glyph = glyphIterator->second;
        if (glyph.width > 0 && glyph.height > 0)
        {
            const float u0 = static_cast<float>(glyph.atlasX) / font.atlasWidth;
            const float v0 = static_cast<float>(glyph.atlasY) / font.atlasHeight;
            const float u1 = static_cast<float>(glyph.atlasX + glyph.width) / font.atlasWidth;
            const float v1 = static_cast<float>(glyph.atlasY + glyph.height) / font.atlasHeight;
            submitTexturedQuad(
                textureHandle,
                penX + static_cast<float>(glyph.offsetX) * fontScale,
                textY + static_cast<float>(glyph.offsetY) * fontScale,
                static_cast<float>(glyph.width) * fontScale,
                static_cast<float>(glyph.height) * fontScale,
                u0,
                v0,
                u1,
                v1,
                TextureFilterProfile::Text);
        }
        penX += static_cast<float>(glyph.advance) * fontScale;
        byteOffset = nextUtf8CodePointOffset(textView, byteOffset);
    }
}

void GameplayHudCommon::renderLayoutLabel(
    const UiLayoutManager::LayoutElement &layout,
    const GameplayResolvedHudLayoutElement &resolved,
    const std::string &label,
    const FindHudFontFn &findHudFontFn,
    const EnsureHudFontColorFn &ensureHudFontColorFn,
    const RenderHudFontLayerFn &renderHudFontLayerFn)
{
    if (label.empty())
    {
        return;
    }

    const GameplayHudFontData *pFont = findHudFontFn(layout.fontName);
    if (pFont == nullptr)
    {
        static std::unordered_set<std::string> missingFontLogs;
        const std::string logKey = "missing-font:" + toLowerCopy(layout.id) + ":" + toLowerCopy(layout.fontName);
        if (!missingFontLogs.contains(logKey))
        {
            std::cout << "HUD label skipped: id=" << layout.id
                      << " font=\"" << layout.fontName
                      << "\" reason=missing-font label=\"" << label << "\"\n";
            missingFontLogs.insert(logKey);
        }
        return;
    }

    float fontScale = resolved.scale * std::max(0.1f, layout.textScale);
    if (fontScale >= 1.0f)
    {
        fontScale = GameplayHudCommon::snappedHudFontScale(fontScale);
    }
    else
    {
        fontScale = std::max(0.5f, fontScale);
    }

    const float labelHeightPixels = static_cast<float>(pFont->fontHeight) * fontScale;
    const float maxLabelWidth = std::max(0.0f, resolved.width - std::abs(layout.textPadX * fontScale) * 2.0f);
    std::string clampedLabel = clampHudTextToWidth(*pFont, label, maxLabelWidth);
    if (clampedLabel.empty())
    {
        const GameplayHudFontData *pFallbackFont = findHudFontFn("Lucida");
        if (pFallbackFont != nullptr)
        {
            pFont = pFallbackFont;
            clampedLabel = clampHudTextToWidth(*pFont, label, maxLabelWidth);
        }
    }
    if (clampedLabel.empty())
    {
        clampedLabel = label;
    }

    const float labelWidthPixels = measureHudTextWidth(*pFont, clampedLabel) * fontScale;
    float textX = resolved.x + layout.textPadX * resolved.scale;
    float textY = resolved.y + layout.textPadY * resolved.scale;

    switch (layout.textAlignX)
    {
    case UiLayoutManager::TextAlignX::Left:
        break;
    case UiLayoutManager::TextAlignX::Center:
        textX = resolved.x + (resolved.width - labelWidthPixels) * 0.5f + layout.textPadX * resolved.scale;
        break;
    case UiLayoutManager::TextAlignX::Right:
        textX = resolved.x + resolved.width - labelWidthPixels + layout.textPadX * resolved.scale;
        break;
    }

    switch (layout.textAlignY)
    {
    case UiLayoutManager::TextAlignY::Top:
        break;
    case UiLayoutManager::TextAlignY::Middle:
        textY = resolved.y + (resolved.height - labelHeightPixels) * 0.5f + layout.textPadY * resolved.scale;
        break;
    case UiLayoutManager::TextAlignY::Bottom:
        textY = resolved.y + resolved.height - labelHeightPixels + layout.textPadY * resolved.scale;
        break;
    }

    textX = std::round(textX);
    textY = std::round(textY);
    bgfx::TextureHandle coloredMainTextureHandle = ensureHudFontColorFn(*pFont, layout.textColorAbgr);
    if (!bgfx::isValid(coloredMainTextureHandle))
    {
        coloredMainTextureHandle = pFont->mainTextureHandle;
    }

    renderHudFontLayerFn(*pFont, pFont->shadowTextureHandle, clampedLabel, textX, textY, fontScale);
    renderHudFontLayerFn(*pFont, coloredMainTextureHandle, clampedLabel, textX, textY, fontScale);
}
} // namespace OpenYAMM::Game
