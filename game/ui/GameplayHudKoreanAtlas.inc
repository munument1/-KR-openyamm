namespace OpenYAMM::Game
{
namespace
{
constexpr std::array<const char *, 2> KoreanFallbackFontFileNames = {"KoreanFallback.ttf", "KoreanFallback.otf"};
constexpr int KoreanAtlasWidth = 2048;
constexpr int KoreanAtlasPadding = 1;
constexpr int KoreanAtlasMaxHeight = 8192;

struct RasterizedUnicodeGlyph
{
    uint32_t codePoint = 0;
    int width = 0;
    int height = 0;
    int offsetX = 0;
    int offsetY = 0;
    int advance = 0;
    int atlasX = 0;
    int atlasY = 0;
    std::vector<uint8_t> alpha;
};

void appendCodePointRange(std::vector<uint32_t> &codePoints, uint32_t first, uint32_t last)
{
    for (uint32_t codePoint = first; codePoint <= last; ++codePoint)
    {
        codePoints.push_back(codePoint);
    }
}

std::vector<uint32_t> koreanFallbackCodePoints()
{
    std::vector<uint32_t> codePoints;
    codePoints.reserve(12000);
    appendCodePointRange(codePoints, 0x1100u, 0x11ffu);
    appendCodePointRange(codePoints, 0x2000u, 0x206fu);
    appendCodePointRange(codePoints, 0x2190u, 0x21ffu);
    appendCodePointRange(codePoints, 0x25a0u, 0x25ffu);
    appendCodePointRange(codePoints, 0x3000u, 0x303fu);
    appendCodePointRange(codePoints, 0x3130u, 0x318fu);
    appendCodePointRange(codePoints, 0xac00u, 0xd7a3u);
    appendCodePointRange(codePoints, 0xff00u, 0xffefu);
    return codePoints;
}

GameplayHudFontData *findMutableHudFont(std::vector<GameplayHudFontData> &fonts, const std::string &fontName)
{
    const std::string normalizedFontName = toLowerCopy(fontName);
    for (GameplayHudFontData &font : fonts)
    {
        if (font.fontName == normalizedFontName)
        {
            return &font;
        }
    }
    return nullptr;
}

std::optional<ParsedHudBitmapFont> loadLegacyParsedFont(
    const Engine::AssetFileSystem *pAssetFileSystem,
    GameplayAssetLoadCache &cache,
    const std::string &fontName)
{
    std::optional<std::string> fontPath = GameplayHudCommon::findCachedAssetPath(
        pAssetFileSystem,
        cache,
        "Data/icons",
        fontName + ".fnt");
    if (!fontPath)
    {
        fontPath = GameplayHudCommon::findCachedAssetPath(
            pAssetFileSystem,
            cache,
            "Data/EnglishT",
            fontName + ".fnt");
    }
    if (!fontPath)
    {
        return std::nullopt;
    }

    const std::optional<std::vector<uint8_t>> fontBytes =
        GameplayHudCommon::readCachedBinaryFile(pAssetFileSystem, cache, *fontPath);
    return fontBytes ? parseHudBitmapFont(*fontBytes) : std::nullopt;
}

std::optional<std::vector<uint8_t>> loadKoreanFallbackFontBytes(
    const Engine::AssetFileSystem *pAssetFileSystem,
    GameplayAssetLoadCache &cache)
{
    for (const char *pFontFileName : KoreanFallbackFontFileNames)
    {
        const std::optional<std::string> fontPath = GameplayHudCommon::findCachedAssetPath(
            pAssetFileSystem,
            cache,
            "fonts",
            pFontFileName);
        if (!fontPath)
        {
            continue;
        }

        const std::optional<std::vector<uint8_t>> fontBytes =
            GameplayHudCommon::readCachedBinaryFile(pAssetFileSystem, cache, *fontPath);
        if (fontBytes && !fontBytes->empty())
        {
            return fontBytes;
        }
    }
    return std::nullopt;
}

std::vector<RasterizedUnicodeGlyph> rasterizeKoreanGlyphs(
    const std::vector<uint8_t> &fontBytes,
    int pixelHeight)
{
    std::vector<RasterizedUnicodeGlyph> glyphs;
    if (fontBytes.empty())
    {
        return glyphs;
    }

    const int fontOffset = stbtt_GetFontOffsetForIndex(fontBytes.data(), 0);
    if (fontOffset < 0)
    {
        return glyphs;
    }

    stbtt_fontinfo fontInfo = {};
    if (stbtt_InitFont(&fontInfo, fontBytes.data(), fontOffset) == 0)
    {
        return glyphs;
    }

    const float scale = stbtt_ScaleForMappingEmToPixels(&fontInfo, koreanFontEmPixels(pixelHeight));
    int ascent = 0;
    int descent = 0;
    int lineGap = 0;
    stbtt_GetFontVMetrics(&fontInfo, &ascent, &descent, &lineGap);
    const float lineBoxHeight = static_cast<float>(ascent - descent) * scale;
    const int baseline = static_cast<int>(std::round(
        (static_cast<float>(pixelHeight) - lineBoxHeight) * 0.5f + static_cast<float>(ascent) * scale));
    (void)descent;
    (void)lineGap;

    const std::vector<uint32_t> codePoints = koreanFallbackCodePoints();
    glyphs.reserve(codePoints.size());
    for (uint32_t codePoint : codePoints)
    {
        const int glyphIndex = stbtt_FindGlyphIndex(&fontInfo, static_cast<int>(codePoint));
        if (glyphIndex == 0)
        {
            continue;
        }

        int advanceWidth = 0;
        int leftSideBearing = 0;
        stbtt_GetGlyphHMetrics(&fontInfo, glyphIndex, &advanceWidth, &leftSideBearing);
        (void)leftSideBearing;

        int x0 = 0;
        int y0 = 0;
        int x1 = 0;
        int y1 = 0;
        stbtt_GetGlyphBitmapBox(&fontInfo, glyphIndex, scale, scale, &x0, &y0, &x1, &y1);

        RasterizedUnicodeGlyph glyph = {};
        glyph.codePoint = codePoint;
        glyph.width = std::max(0, x1 - x0);
        glyph.height = std::max(0, y1 - y0);
        glyph.offsetX = x0;
        glyph.offsetY = baseline + y0;
        glyph.advance = std::max(1, static_cast<int>(std::round(static_cast<float>(advanceWidth) * scale)));

        if (glyph.width > 0 && glyph.height > 0)
        {
            glyph.alpha.resize(static_cast<size_t>(glyph.width) * static_cast<size_t>(glyph.height));
            stbtt_MakeGlyphBitmap(
                &fontInfo,
                glyph.alpha.data(),
                glyph.width,
                glyph.height,
                glyph.width,
                scale,
                scale,
                glyphIndex);
        }
        glyphs.push_back(std::move(glyph));
    }

    return glyphs;
}

bool rebuildFontAtlasWithKorean(
    GameplayHudFontData &font,
    const std::optional<ParsedHudBitmapFont> &legacyParsedFont,
    const std::vector<uint8_t> &fallbackFontBytes)
{
    if (font.unicodeFallbackLoaded || fallbackFontBytes.empty())
    {
        return font.unicodeFallbackLoaded;
    }

    std::vector<RasterizedUnicodeGlyph> glyphs =
        rasterizeKoreanGlyphs(fallbackFontBytes, font.fontHeight);
    if (glyphs.empty())
    {
        return false;
    }

    const int oldAtlasWidth = font.atlasWidth;
    const int oldAtlasHeight = font.atlasHeight;
    const int atlasWidth = std::max(KoreanAtlasWidth, oldAtlasWidth);
    int penX = 0;
    int penY = oldAtlasHeight + KoreanAtlasPadding;
    int rowHeight = 0;

    for (RasterizedUnicodeGlyph &glyph : glyphs)
    {
        if (glyph.width <= 0 || glyph.height <= 0)
        {
            continue;
        }

        const int packedWidth = glyph.width + KoreanAtlasPadding * 2 + 1;
        const int packedHeight = glyph.height + KoreanAtlasPadding * 2 + 1;
        if (penX + packedWidth > atlasWidth)
        {
            penX = 0;
            penY += rowHeight;
            rowHeight = 0;
        }

        glyph.atlasX = penX + KoreanAtlasPadding;
        glyph.atlasY = penY + KoreanAtlasPadding;
        penX += packedWidth;
        rowHeight = std::max(rowHeight, packedHeight);
    }

    const int atlasHeight = penY + rowHeight + KoreanAtlasPadding;
    if (atlasWidth <= 0 || atlasHeight <= 0 || atlasHeight > KoreanAtlasMaxHeight)
    {
        std::cout << "Korean HUD font atlas rejected: font=\"" << font.fontName
                  << "\" atlas=" << atlasWidth << "x" << atlasHeight << '\n';
        return false;
    }

    std::vector<uint8_t> mainPixels(static_cast<size_t>(atlasWidth) * atlasHeight * 4, 0);
    std::vector<uint8_t> shadowPixels(static_cast<size_t>(atlasWidth) * atlasHeight * 4, 0);

    if (!font.mainAtlasPixels.empty() && oldAtlasWidth > 0 && oldAtlasHeight > 0)
    {
        for (int y = 0; y < oldAtlasHeight; ++y)
        {
            const size_t sourceOffset = static_cast<size_t>(y) * oldAtlasWidth * 4;
            const size_t targetOffset = static_cast<size_t>(y) * atlasWidth * 4;
            std::copy_n(
                font.mainAtlasPixels.begin() + static_cast<ptrdiff_t>(sourceOffset),
                static_cast<size_t>(oldAtlasWidth) * 4,
                mainPixels.begin() + static_cast<ptrdiff_t>(targetOffset));
        }
    }

    if (legacyParsedFont)
    {
        for (int glyphIndex = legacyParsedFont->firstChar; glyphIndex <= legacyParsedFont->lastChar; ++glyphIndex)
        {
            const ParsedHudFontGlyphMetrics &metrics = legacyParsedFont->glyphMetrics[glyphIndex];
            if (metrics.width <= 0)
            {
                continue;
            }

            const int cellX = (glyphIndex % 16) * font.atlasCellWidth;
            const int cellY = (glyphIndex / 16) * font.fontHeight;
            const size_t glyphOffset = legacyParsedFont->glyphOffsets[glyphIndex];
            for (int y = 0; y < font.fontHeight; ++y)
            {
                for (int x = 0; x < metrics.width; ++x)
                {
                    const uint8_t pixelValue =
                        legacyParsedFont->pixels[glyphOffset + static_cast<size_t>(y) * metrics.width + x];
                    if (pixelValue != 1)
                    {
                        continue;
                    }
                    const size_t pixelOffset =
                        (static_cast<size_t>(cellY + y) * atlasWidth + static_cast<size_t>(cellX + x)) * 4;
                    shadowPixels[pixelOffset + 3] = 255;
                }
            }
        }
    }

    font.unicodeGlyphs.clear();
    for (const RasterizedUnicodeGlyph &glyph : glyphs)
    {
        GameplayHudUnicodeGlyphData glyphData = {};
        glyphData.atlasX = glyph.atlasX;
        glyphData.atlasY = glyph.atlasY;
        glyphData.width = glyph.width > 0 ? glyph.width + 1 : 0;
        glyphData.height = glyph.height > 0 ? glyph.height + 1 : 0;
        glyphData.offsetX = glyph.offsetX;
        glyphData.offsetY = glyph.offsetY;
        glyphData.advance = glyph.advance;
        font.unicodeGlyphs.emplace(glyph.codePoint, glyphData);

        if (glyph.alpha.empty())
        {
            continue;
        }

        for (int y = 0; y < glyph.height; ++y)
        {
            for (int x = 0; x < glyph.width; ++x)
            {
                const uint8_t alpha = glyph.alpha[static_cast<size_t>(y) * glyph.width + x];
                if (alpha == 0)
                {
                    continue;
                }

                const size_t mainOffset =
                    (static_cast<size_t>(glyph.atlasY + y) * atlasWidth + glyph.atlasX + x) * 4;
                mainPixels[mainOffset + 0] = 255;
                mainPixels[mainOffset + 1] = 255;
                mainPixels[mainOffset + 2] = 255;
                mainPixels[mainOffset + 3] = alpha;

                const size_t shadowOffset =
                    (static_cast<size_t>(glyph.atlasY + y + 1) * atlasWidth + glyph.atlasX + x + 1) * 4;
                shadowPixels[shadowOffset + 3] = std::max(shadowPixels[shadowOffset + 3], alpha);
            }
        }
    }

    const bgfx::TextureHandle mainTextureHandle = createBgraTexture2D(
        static_cast<uint16_t>(atlasWidth),
        static_cast<uint16_t>(atlasHeight),
        mainPixels.data(),
        static_cast<uint32_t>(mainPixels.size()),
        TextureFilterProfile::Text);
    const bgfx::TextureHandle shadowTextureHandle = createBgraTexture2D(
        static_cast<uint16_t>(atlasWidth),
        static_cast<uint16_t>(atlasHeight),
        shadowPixels.data(),
        static_cast<uint32_t>(shadowPixels.size()),
        TextureFilterProfile::Text);

    if (!bgfx::isValid(mainTextureHandle) || !bgfx::isValid(shadowTextureHandle))
    {
        if (bgfx::isValid(mainTextureHandle))
        {
            bgfx::destroy(mainTextureHandle);
        }
        if (bgfx::isValid(shadowTextureHandle))
        {
            bgfx::destroy(shadowTextureHandle);
        }
        font.unicodeGlyphs.clear();
        return false;
    }

    if (bgfx::isValid(font.mainTextureHandle))
    {
        bgfx::destroy(font.mainTextureHandle);
    }
    if (bgfx::isValid(font.shadowTextureHandle))
    {
        bgfx::destroy(font.shadowTextureHandle);
    }

    font.atlasWidth = atlasWidth;
    font.atlasHeight = atlasHeight;
    font.mainAtlasPixels = std::move(mainPixels);
    font.mainTextureHandle = mainTextureHandle;
    font.shadowTextureHandle = shadowTextureHandle;
    font.unicodeFallbackLoaded = true;
    std::cout << "Loaded Korean HUD fallback glyphs: font=\"" << font.fontName
              << "\" glyphs=" << font.unicodeGlyphs.size()
              << " atlas=" << atlasWidth << "x" << atlasHeight << '\n';
    return true;
}

float unicodeGlyphAdvance(const GameplayHudFontData &font, uint32_t codePoint)
{
    if (codePoint <= 0xffu)
    {
        const unsigned char character = static_cast<unsigned char>(codePoint);
        if (character >= font.firstChar && character <= font.lastChar)
        {
            const GameplayHudFontGlyphMetricsData &metrics = font.glyphMetrics[character];
            return static_cast<float>(metrics.leftSpacing + metrics.width + metrics.rightSpacing);
        }
    }

    const auto unicodeGlyph = font.unicodeGlyphs.find(codePoint);
    if (unicodeGlyph != font.unicodeGlyphs.end())
    {
        return static_cast<float>(unicodeGlyph->second.advance);
    }
    return static_cast<float>(std::max(font.atlasCellWidth, font.fontHeight));
}

bool isCjkLineBreakCodePoint(uint32_t codePoint)
{
    return isCjkCodePoint(codePoint)
        || (codePoint >= 0x3000u && codePoint <= 0x303fu)
        || (codePoint >= 0xff00u && codePoint <= 0xffefu);
}

void appendUtf8Span(std::string &target, std::string_view text, const Utf8CodePointSpan &span)
{
    target.append(text.substr(span.byteOffset, span.byteLength));
}
}

bool GameplayHudCommon::loadHudFont(
    const Engine::AssetFileSystem *pAssetFileSystem,
    GameplayAssetLoadCache &cache,
    const std::string &fontName,
    std::vector<GameplayHudFontData> &fonts)
{
    if (!loadHudFontLegacy(pAssetFileSystem, cache, fontName, fonts))
    {
        return false;
    }

    GameplayHudFontData *pFont = findMutableHudFont(fonts, fontName);
    if (pFont == nullptr || pFont->unicodeFallbackLoaded)
    {
        return true;
    }

    const std::optional<std::vector<uint8_t>> fallbackFontBytes =
        loadKoreanFallbackFontBytes(pAssetFileSystem, cache);
    if (!fallbackFontBytes || fallbackFontBytes->empty())
    {
        return true;
    }

    const std::optional<ParsedHudBitmapFont> legacyParsedFont =
        loadLegacyParsedFont(pAssetFileSystem, cache, fontName);
    rebuildFontAtlasWithKorean(*pFont, legacyParsedFont, *fallbackFontBytes);
    return true;
}
