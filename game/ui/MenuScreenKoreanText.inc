namespace OpenYAMM::Game
{
namespace
{
constexpr std::array<const char *, 2> MenuKoreanFallbackFontPaths = {
    "fonts/KoreanFallback.ttf",
    "fonts/KoreanFallback.otf"
};
constexpr int MenuKoreanAtlasWidth = 2048;
constexpr int MenuKoreanAtlasPadding = 1;
constexpr int MenuKoreanAtlasMaxHeight = 8192;

struct MenuKoreanGlyph
{
    int atlasX = 0;
    int atlasY = 0;
    int width = 0;
    int height = 0;
    int offsetX = 0;
    int offsetY = 0;
    int advance = 0;
};

struct MenuKoreanAtlas
{
    int pixelHeight = 0;
    int width = 0;
    int height = 0;
    std::unordered_map<uint32_t, MenuKoreanGlyph> glyphs;
    std::vector<uint8_t> mainPixels;
    bgfx::TextureHandle mainTextureHandle = BGFX_INVALID_HANDLE;
    bgfx::TextureHandle shadowTextureHandle = BGFX_INVALID_HANDLE;
};

struct MenuKoreanColorTexture
{
    int pixelHeight = 0;
    uint32_t colorAbgr = 0xffffffffu;
    bgfx::TextureHandle textureHandle = BGFX_INVALID_HANDLE;
};

struct MenuRasterizedGlyph
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

std::vector<MenuKoreanAtlas> g_menuKoreanAtlases;
std::vector<MenuKoreanColorTexture> g_menuKoreanColorTextures;
std::optional<std::vector<uint8_t>> g_menuKoreanFallbackFontBytes;
bool g_menuKoreanFallbackFontLoadAttempted = false;
bool g_menuKoreanFallbackMissingLogged = false;

void appendMenuCodePointRange(std::vector<uint32_t> &codePoints, uint32_t first, uint32_t last)
{
    for (uint32_t codePoint = first; codePoint <= last; ++codePoint)
    {
        codePoints.push_back(codePoint);
    }
}

std::vector<uint32_t> menuKoreanCodePoints()
{
    std::vector<uint32_t> codePoints;
    codePoints.reserve(12000);
    appendMenuCodePointRange(codePoints, 0x1100u, 0x11ffu);
    appendMenuCodePointRange(codePoints, 0x2000u, 0x206fu);
    appendMenuCodePointRange(codePoints, 0x2190u, 0x21ffu);
    appendMenuCodePointRange(codePoints, 0x25a0u, 0x25ffu);
    appendMenuCodePointRange(codePoints, 0x3000u, 0x303fu);
    appendMenuCodePointRange(codePoints, 0x3130u, 0x318fu);
    appendMenuCodePointRange(codePoints, 0xac00u, 0xd7a3u);
    appendMenuCodePointRange(codePoints, 0xff00u, 0xffefu);
    return codePoints;
}

std::vector<uint32_t> decodeMenuTextCodePoints(std::string_view text)
{
    std::vector<uint32_t> codePoints;
    codePoints.reserve(text.size());

    size_t byteOffset = 0;
    while (byteOffset < text.size())
    {
        const Utf8CodePointSpan span = decodeUtf8CodePoint(text, byteOffset);
        if (span.valid && span.byteLength > 0)
        {
            codePoints.push_back(span.codePoint);
            byteOffset += span.byteLength;
        }
        else
        {
            codePoints.push_back(static_cast<unsigned char>(text[byteOffset]));
            ++byteOffset;
        }
    }

    return codePoints;
}

bool menuTextNeedsUnicode(std::string_view text)
{
    size_t byteOffset = 0;
    while (byteOffset < text.size())
    {
        const Utf8CodePointSpan span = decodeUtf8CodePoint(text, byteOffset);
        if (span.valid && span.byteLength > 0)
        {
            if (span.codePoint > 0xffu)
            {
                return true;
            }
            byteOffset += span.byteLength;
        }
        else
        {
            ++byteOffset;
        }
    }
    return false;
}

const std::optional<std::vector<uint8_t>> &menuKoreanFallbackFontBytes(
    const Engine::AssetFileSystem &assetFileSystem)
{
    if (g_menuKoreanFallbackFontLoadAttempted)
    {
        return g_menuKoreanFallbackFontBytes;
    }

    g_menuKoreanFallbackFontLoadAttempted = true;
    for (const char *pPath : MenuKoreanFallbackFontPaths)
    {
        const std::optional<std::vector<uint8_t>> bytes = assetFileSystem.readBinaryFile(pPath);
        if (bytes && !bytes->empty())
        {
            g_menuKoreanFallbackFontBytes = *bytes;
            return g_menuKoreanFallbackFontBytes;
        }
    }

    if (!g_menuKoreanFallbackMissingLogged)
    {
        std::cout << "Korean menu fallback font not found under fonts/KoreanFallback.(ttf|otf)\n";
        g_menuKoreanFallbackMissingLogged = true;
    }
    return g_menuKoreanFallbackFontBytes;
}

MenuKoreanAtlas *findMenuKoreanAtlas(int pixelHeight)
{
    for (MenuKoreanAtlas &atlas : g_menuKoreanAtlases)
    {
        if (atlas.pixelHeight == pixelHeight)
        {
            return &atlas;
        }
    }
    return nullptr;
}

MenuKoreanAtlas *buildMenuKoreanAtlas(const Engine::AssetFileSystem &assetFileSystem, int pixelHeight)
{
    const int resolvedPixelHeight = std::max(6, pixelHeight);
    if (MenuKoreanAtlas *pExisting = findMenuKoreanAtlas(resolvedPixelHeight))
    {
        return pExisting;
    }

    const std::optional<std::vector<uint8_t>> &fontBytes = menuKoreanFallbackFontBytes(assetFileSystem);
    if (!fontBytes || fontBytes->empty())
    {
        return nullptr;
    }

    const int fontOffset = stbtt_GetFontOffsetForIndex(fontBytes->data(), 0);
    if (fontOffset < 0)
    {
        return nullptr;
    }

    stbtt_fontinfo fontInfo = {};
    if (stbtt_InitFont(&fontInfo, fontBytes->data(), fontOffset) == 0)
    {
        return nullptr;
    }

    const float fontScale = stbtt_ScaleForPixelHeight(&fontInfo, static_cast<float>(resolvedPixelHeight));
    int ascent = 0;
    int descent = 0;
    int lineGap = 0;
    stbtt_GetFontVMetrics(&fontInfo, &ascent, &descent, &lineGap);
    const int baseline = static_cast<int>(std::round(static_cast<float>(ascent) * fontScale));
    (void)descent;
    (void)lineGap;

    std::vector<MenuRasterizedGlyph> rasterizedGlyphs;
    const std::vector<uint32_t> codePoints = menuKoreanCodePoints();
    rasterizedGlyphs.reserve(codePoints.size());

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
        stbtt_GetGlyphBitmapBox(&fontInfo, glyphIndex, fontScale, fontScale, &x0, &y0, &x1, &y1);

        MenuRasterizedGlyph glyph = {};
        glyph.codePoint = codePoint;
        glyph.width = std::max(0, x1 - x0);
        glyph.height = std::max(0, y1 - y0);
        glyph.offsetX = x0;
        glyph.offsetY = baseline + y0;
        glyph.advance = std::max(1, static_cast<int>(std::round(static_cast<float>(advanceWidth) * fontScale)));

        if (glyph.width > 0 && glyph.height > 0)
        {
            glyph.alpha.resize(static_cast<size_t>(glyph.width) * static_cast<size_t>(glyph.height));
            stbtt_MakeGlyphBitmap(
                &fontInfo,
                glyph.alpha.data(),
                glyph.width,
                glyph.height,
                glyph.width,
                fontScale,
                fontScale,
                glyphIndex);
        }
        rasterizedGlyphs.push_back(std::move(glyph));
    }

    if (rasterizedGlyphs.empty())
    {
        return nullptr;
    }

    int penX = 0;
    int penY = MenuKoreanAtlasPadding;
    int rowHeight = 0;
    for (MenuRasterizedGlyph &glyph : rasterizedGlyphs)
    {
        if (glyph.width <= 0 || glyph.height <= 0)
        {
            continue;
        }

        const int packedWidth = glyph.width + MenuKoreanAtlasPadding * 2 + 1;
        const int packedHeight = glyph.height + MenuKoreanAtlasPadding * 2 + 1;
        if (penX + packedWidth > MenuKoreanAtlasWidth)
        {
            penX = 0;
            penY += rowHeight;
            rowHeight = 0;
        }

        glyph.atlasX = penX + MenuKoreanAtlasPadding;
        glyph.atlasY = penY + MenuKoreanAtlasPadding;
        penX += packedWidth;
        rowHeight = std::max(rowHeight, packedHeight);
    }

    const int atlasHeight = penY + rowHeight + MenuKoreanAtlasPadding;
    if (atlasHeight <= 0 || atlasHeight > MenuKoreanAtlasMaxHeight)
    {
        std::cout << "Korean menu atlas rejected: pixelHeight=" << resolvedPixelHeight
                  << " atlas=" << MenuKoreanAtlasWidth << "x" << atlasHeight << '\n';
        return nullptr;
    }

    MenuKoreanAtlas atlas = {};
    atlas.pixelHeight = resolvedPixelHeight;
    atlas.width = MenuKoreanAtlasWidth;
    atlas.height = atlasHeight;
    atlas.mainPixels.assign(static_cast<size_t>(atlas.width) * static_cast<size_t>(atlas.height) * 4, 0);
    std::vector<uint8_t> shadowPixels(atlas.mainPixels.size(), 0);

    for (const MenuRasterizedGlyph &glyph : rasterizedGlyphs)
    {
        MenuKoreanGlyph glyphData = {};
        glyphData.atlasX = glyph.atlasX;
        glyphData.atlasY = glyph.atlasY;
        glyphData.width = glyph.width;
        glyphData.height = glyph.height;
        glyphData.offsetX = glyph.offsetX;
        glyphData.offsetY = glyph.offsetY;
        glyphData.advance = glyph.advance;
        atlas.glyphs.emplace(glyph.codePoint, glyphData);

        if (glyph.alpha.empty())
        {
            continue;
        }

        for (int y = 0; y < glyph.height; ++y)
        {
            for (int x = 0; x < glyph.width; ++x)
            {
                const uint8_t alpha = glyph.alpha[static_cast<size_t>(y) * static_cast<size_t>(glyph.width) + x];
                if (alpha == 0)
                {
                    continue;
                }

                const size_t pixelOffset =
                    (static_cast<size_t>(glyph.atlasY + y) * static_cast<size_t>(atlas.width)
                        + static_cast<size_t>(glyph.atlasX + x)) * 4;
                atlas.mainPixels[pixelOffset + 0] = 255;
                atlas.mainPixels[pixelOffset + 1] = 255;
                atlas.mainPixels[pixelOffset + 2] = 255;
                atlas.mainPixels[pixelOffset + 3] = alpha;
                shadowPixels[pixelOffset + 3] = alpha;
            }
        }
    }

    atlas.mainTextureHandle = createBgraTexture2D(
        static_cast<uint16_t>(atlas.width),
        static_cast<uint16_t>(atlas.height),
        atlas.mainPixels.data(),
        static_cast<uint32_t>(atlas.mainPixels.size()),
        TextureFilterProfile::Text,
        BGFX_SAMPLER_U_CLAMP | BGFX_SAMPLER_V_CLAMP);
    atlas.shadowTextureHandle = createBgraTexture2D(
        static_cast<uint16_t>(atlas.width),
        static_cast<uint16_t>(atlas.height),
        shadowPixels.data(),
        static_cast<uint32_t>(shadowPixels.size()),
        TextureFilterProfile::Text,
        BGFX_SAMPLER_U_CLAMP | BGFX_SAMPLER_V_CLAMP);

    if (!bgfx::isValid(atlas.mainTextureHandle) || !bgfx::isValid(atlas.shadowTextureHandle))
    {
        if (bgfx::isValid(atlas.mainTextureHandle))
        {
            bgfx::destroy(atlas.mainTextureHandle);
        }
        if (bgfx::isValid(atlas.shadowTextureHandle))
        {
            bgfx::destroy(atlas.shadowTextureHandle);
        }
        return nullptr;
    }

    std::cout << "Loaded Korean menu fallback glyphs: pixelHeight=" << resolvedPixelHeight
              << " glyphs=" << atlas.glyphs.size()
              << " atlas=" << atlas.width << "x" << atlas.height << '\n';
    g_menuKoreanAtlases.push_back(std::move(atlas));
    return &g_menuKoreanAtlases.back();
}

bgfx::TextureHandle menuKoreanColorTexture(const MenuKoreanAtlas &atlas, uint32_t colorAbgr)
{
    if (colorAbgr == 0xffffffffu)
    {
        return atlas.mainTextureHandle;
    }

    for (const MenuKoreanColorTexture &colorTexture : g_menuKoreanColorTextures)
    {
        if (colorTexture.pixelHeight == atlas.pixelHeight && colorTexture.colorAbgr == colorAbgr)
        {
            return colorTexture.textureHandle;
        }
    }

    std::vector<uint8_t> tintedPixels = atlas.mainPixels;
    const uint8_t red = static_cast<uint8_t>(colorAbgr & 0xffu);
    const uint8_t green = static_cast<uint8_t>((colorAbgr >> 8u) & 0xffu);
    const uint8_t blue = static_cast<uint8_t>((colorAbgr >> 16u) & 0xffu);
    const uint8_t alpha = static_cast<uint8_t>((colorAbgr >> 24u) & 0xffu);

    for (size_t pixelIndex = 0; pixelIndex + 3 < tintedPixels.size(); pixelIndex += 4)
    {
        const uint8_t sourceAlpha = tintedPixels[pixelIndex + 3];
        if (sourceAlpha == 0)
        {
            continue;
        }
        tintedPixels[pixelIndex + 0] = blue;
        tintedPixels[pixelIndex + 1] = green;
        tintedPixels[pixelIndex + 2] = red;
        tintedPixels[pixelIndex + 3] =
            static_cast<uint8_t>((static_cast<uint32_t>(sourceAlpha) * alpha) / 255u);
    }

    const bgfx::TextureHandle textureHandle = createBgraTexture2D(
        static_cast<uint16_t>(atlas.width),
        static_cast<uint16_t>(atlas.height),
        tintedPixels.data(),
        static_cast<uint32_t>(tintedPixels.size()),
        TextureFilterProfile::Text,
        BGFX_SAMPLER_U_CLAMP | BGFX_SAMPLER_V_CLAMP);
    if (!bgfx::isValid(textureHandle))
    {
        return BGFX_INVALID_HANDLE;
    }

    MenuKoreanColorTexture colorTexture = {};
    colorTexture.pixelHeight = atlas.pixelHeight;
    colorTexture.colorAbgr = colorAbgr;
    colorTexture.textureHandle = textureHandle;
    g_menuKoreanColorTextures.push_back(colorTexture);
    return textureHandle;
}

void destroyMenuKoreanResources()
{
    if (Engine::BgfxContext::isBgfxInitialized())
    {
        for (MenuKoreanColorTexture &colorTexture : g_menuKoreanColorTextures)
        {
            if (bgfx::isValid(colorTexture.textureHandle))
            {
                bgfx::destroy(colorTexture.textureHandle);
            }
        }
        for (MenuKoreanAtlas &atlas : g_menuKoreanAtlases)
        {
            if (bgfx::isValid(atlas.mainTextureHandle))
            {
                bgfx::destroy(atlas.mainTextureHandle);
            }
            if (bgfx::isValid(atlas.shadowTextureHandle))
            {
                bgfx::destroy(atlas.shadowTextureHandle);
            }
        }
    }

    g_menuKoreanColorTextures.clear();
    g_menuKoreanAtlases.clear();
    g_menuKoreanFallbackFontBytes.reset();
    g_menuKoreanFallbackFontLoadAttempted = false;
    g_menuKoreanFallbackMissingLogged = false;
}
}

void MenuScreenBase::shutdownSharedResources()
{
    destroyMenuKoreanResources();
    shutdownSharedResourcesLegacy();
}

const MenuScreenBase::FontHandle *MenuScreenBase::ensureFont(const std::string &fontName)
{
    return ensureFontLegacy(fontName);
}

float MenuScreenBase::measureTextWidth(const std::string &fontName, const std::string &text, float scale)
{
    const std::string localizedText = KoreanRuntimeText::koreanRuntimeTextOverride(text).value_or(text);
    if (!menuTextNeedsUnicode(localizedText))
    {
        return measureTextWidthLegacy(fontName, localizedText, scale);
    }

    const FontHandle *pFont = ensureFontLegacy(fontName);
    if (pFont == nullptr)
    {
        return 0.0f;
    }

    MenuKoreanAtlas *pKoreanAtlas = buildMenuKoreanAtlas(assetFileSystem(), pFont->fontHeight);
    float widthPixels = 0.0f;
    const std::vector<uint32_t> codePoints = decodeMenuTextCodePoints(localizedText);

    for (uint32_t codePoint : codePoints)
    {
        if (codePoint == '\r' || codePoint == '\n')
        {
            break;
        }

        if (codePoint <= 0xffu)
        {
            const unsigned char character = static_cast<unsigned char>(codePoint);
            if (character < pFont->firstChar || character > pFont->lastChar)
            {
                widthPixels += static_cast<float>(pFont->atlasCellWidth) * scale;
                continue;
            }

            const FontGlyphMetrics &metrics = pFont->glyphMetrics[character];
            widthPixels += static_cast<float>(metrics.leftSpacing + metrics.width + metrics.rightSpacing) * scale;
            continue;
        }

        if (pKoreanAtlas != nullptr)
        {
            const auto glyphIt = pKoreanAtlas->glyphs.find(codePoint);
            if (glyphIt != pKoreanAtlas->glyphs.end())
            {
                widthPixels += static_cast<float>(glyphIt->second.advance) * scale;
                continue;
            }
        }

        widthPixels += static_cast<float>(std::max(pFont->atlasCellWidth, pFont->fontHeight)) * scale;
    }

    return widthPixels;
}

bool MenuScreenBase::drawText(
    const std::string &fontName,
    const std::string &text,
    float pixelX,
    float pixelY,
    uint32_t colorAbgr,
    float scale,
    bool drawShadow)
{
    const std::string localizedText = KoreanRuntimeText::koreanRuntimeTextOverride(text).value_or(text);
    if (!menuTextNeedsUnicode(localizedText))
    {
        return drawTextLegacy(fontName, localizedText, pixelX, pixelY, colorAbgr, scale, drawShadow);
    }

    const FontHandle *pFont = ensureFontLegacy(fontName);
    if (pFont == nullptr || !bgfx::isValid(pFont->mainTextureHandle))
    {
        return false;
    }

    MenuKoreanAtlas *pKoreanAtlas = buildMenuKoreanAtlas(assetFileSystem(), pFont->fontHeight);
    const std::vector<uint32_t> codePoints = decodeMenuTextCodePoints(localizedText);

    const auto advanceForCodePoint =
        [pFont, pKoreanAtlas](uint32_t codePoint) -> float
        {
            if (codePoint <= 0xffu)
            {
                const unsigned char character = static_cast<unsigned char>(codePoint);
                if (character >= pFont->firstChar && character <= pFont->lastChar)
                {
                    const FontGlyphMetrics &metrics = pFont->glyphMetrics[character];
                    return static_cast<float>(metrics.leftSpacing + metrics.width + metrics.rightSpacing);
                }
                return static_cast<float>(pFont->atlasCellWidth);
            }

            if (pKoreanAtlas != nullptr)
            {
                const auto glyphIt = pKoreanAtlas->glyphs.find(codePoint);
                if (glyphIt != pKoreanAtlas->glyphs.end())
                {
                    return static_cast<float>(glyphIt->second.advance);
                }
            }
            return static_cast<float>(std::max(pFont->atlasCellWidth, pFont->fontHeight));
        };

    const auto renderLayer =
        [this, pFont, pKoreanAtlas, &codePoints, &advanceForCodePoint, pixelX, pixelY, scale](
            bool unicodeLayer,
            bgfx::TextureHandle textureHandle,
            float layerOffset) -> bool
        {
            if (!bgfx::isValid(textureHandle))
            {
                return false;
            }

            uint32_t glyphCount = 0;
            for (uint32_t codePoint : codePoints)
            {
                if (codePoint == '\r' || codePoint == '\n')
                {
                    break;
                }

                if (!unicodeLayer && codePoint <= 0xffu)
                {
                    const unsigned char character = static_cast<unsigned char>(codePoint);
                    if (character >= pFont->firstChar
                        && character <= pFont->lastChar
                        && pFont->glyphMetrics[character].width > 0)
                    {
                        ++glyphCount;
                    }
                }
                else if (unicodeLayer && codePoint > 0xffu && pKoreanAtlas != nullptr)
                {
                    const auto glyphIt = pKoreanAtlas->glyphs.find(codePoint);
                    if (glyphIt != pKoreanAtlas->glyphs.end()
                        && glyphIt->second.width > 0
                        && glyphIt->second.height > 0)
                    {
                        ++glyphCount;
                    }
                }
            }

            if (glyphCount == 0)
            {
                return true;
            }

            const uint32_t vertexCount = glyphCount * 6;
            if (bgfx::getAvailTransientVertexBuffer(vertexCount, MenuVertex::ms_layout) < vertexCount)
            {
                return false;
            }

            bgfx::TransientVertexBuffer vertexBuffer;
            bgfx::allocTransientVertexBuffer(&vertexBuffer, vertexCount, MenuVertex::ms_layout);
            MenuVertex *pVertices = reinterpret_cast<MenuVertex *>(vertexBuffer.data);
            float penX = pixelX + layerOffset;
            uint32_t vertexIndex = 0;

            for (uint32_t codePoint : codePoints)
            {
                if (codePoint == '\r' || codePoint == '\n')
                {
                    break;
                }

                if (codePoint <= 0xffu)
                {
                    const unsigned char character = static_cast<unsigned char>(codePoint);
                    if (character < pFont->firstChar || character > pFont->lastChar)
                    {
                        penX += advanceForCodePoint(codePoint) * scale;
                        continue;
                    }

                    const FontGlyphMetrics &metrics = pFont->glyphMetrics[character];
                    penX += static_cast<float>(metrics.leftSpacing) * scale;
                    if (!unicodeLayer && metrics.width > 0)
                    {
                        const int cellX = (character % 16) * pFont->atlasCellWidth;
                        const int cellY = (character / 16) * pFont->fontHeight;
                        const float u0 = static_cast<float>(cellX) / static_cast<float>(pFont->atlasWidth);
                        const float v0 = static_cast<float>(cellY) / static_cast<float>(pFont->atlasHeight);
                        const float u1 = static_cast<float>(cellX + metrics.width) / static_cast<float>(pFont->atlasWidth);
                        const float v1 = static_cast<float>(cellY + pFont->fontHeight) / static_cast<float>(pFont->atlasHeight);
                        const float glyphWidth = static_cast<float>(metrics.width) * scale;
                        const float glyphHeight = static_cast<float>(pFont->fontHeight) * scale;
                        const float top = pixelY + layerOffset;
                        const float bottom = top + glyphHeight;

                        pVertices[vertexIndex + 0] = MenuVertex{penX, top, 0.0f, u0, v0};
                        pVertices[vertexIndex + 1] = MenuVertex{penX + glyphWidth, top, 0.0f, u1, v0};
                        pVertices[vertexIndex + 2] = MenuVertex{penX + glyphWidth, bottom, 0.0f, u1, v1};
                        pVertices[vertexIndex + 3] = MenuVertex{penX, top, 0.0f, u0, v0};
                        pVertices[vertexIndex + 4] = MenuVertex{penX + glyphWidth, bottom, 0.0f, u1, v1};
                        pVertices[vertexIndex + 5] = MenuVertex{penX, bottom, 0.0f, u0, v1};
                        vertexIndex += 6;
                    }
                    penX += static_cast<float>(metrics.width + metrics.rightSpacing) * scale;
                    continue;
                }

                if (pKoreanAtlas == nullptr)
                {
                    penX += advanceForCodePoint(codePoint) * scale;
                    continue;
                }

                const auto glyphIt = pKoreanAtlas->glyphs.find(codePoint);
                if (glyphIt == pKoreanAtlas->glyphs.end())
                {
                    penX += advanceForCodePoint(codePoint) * scale;
                    continue;
                }

                const MenuKoreanGlyph &glyph = glyphIt->second;
                if (unicodeLayer && glyph.width > 0 && glyph.height > 0)
                {
                    const float left = penX + static_cast<float>(glyph.offsetX) * scale;
                    const float top = pixelY + layerOffset + static_cast<float>(glyph.offsetY) * scale;
                    const float glyphWidth = static_cast<float>(glyph.width) * scale;
                    const float glyphHeight = static_cast<float>(glyph.height) * scale;
                    const float right = left + glyphWidth;
                    const float bottom = top + glyphHeight;
                    const float u0 = static_cast<float>(glyph.atlasX) / static_cast<float>(pKoreanAtlas->width);
                    const float v0 = static_cast<float>(glyph.atlasY) / static_cast<float>(pKoreanAtlas->height);
                    const float u1 = static_cast<float>(glyph.atlasX + glyph.width) / static_cast<float>(pKoreanAtlas->width);
                    const float v1 = static_cast<float>(glyph.atlasY + glyph.height) / static_cast<float>(pKoreanAtlas->height);

                    pVertices[vertexIndex + 0] = MenuVertex{left, top, 0.0f, u0, v0};
                    pVertices[vertexIndex + 1] = MenuVertex{right, top, 0.0f, u1, v0};
                    pVertices[vertexIndex + 2] = MenuVertex{right, bottom, 0.0f, u1, v1};
                    pVertices[vertexIndex + 3] = MenuVertex{left, top, 0.0f, u0, v0};
                    pVertices[vertexIndex + 4] = MenuVertex{right, bottom, 0.0f, u1, v1};
                    pVertices[vertexIndex + 5] = MenuVertex{left, bottom, 0.0f, u0, v1};
                    vertexIndex += 6;
                }
                penX += static_cast<float>(glyph.advance) * scale;
            }

            bgfx::setVertexBuffer(0, &vertexBuffer);
            bindTexture(0, m_textureUniformHandle, textureHandle, TextureFilterProfile::Text);
            bgfx::setState(BGFX_STATE_WRITE_RGB | BGFX_STATE_WRITE_A | BGFX_STATE_BLEND_ALPHA | BGFX_STATE_MSAA);
            bgfx::submit(m_renderViewId, m_texturedProgramHandle);
            return true;
        };

    const float shadowOffset = std::max(1.0f, scale);
    if (drawShadow)
    {
        if (bgfx::isValid(pFont->shadowTextureHandle))
        {
            renderLayer(false, pFont->shadowTextureHandle, shadowOffset);
        }
        if (pKoreanAtlas != nullptr && bgfx::isValid(pKoreanAtlas->shadowTextureHandle))
        {
            renderLayer(true, pKoreanAtlas->shadowTextureHandle, shadowOffset);
        }
    }

    bgfx::TextureHandle legacyMainTexture = ensureFontColor(*pFont, colorAbgr);
    if (!bgfx::isValid(legacyMainTexture))
    {
        legacyMainTexture = pFont->mainTextureHandle;
    }
    renderLayer(false, legacyMainTexture, 0.0f);

    if (pKoreanAtlas != nullptr)
    {
        bgfx::TextureHandle koreanMainTexture = menuKoreanColorTexture(*pKoreanAtlas, colorAbgr);
        if (!bgfx::isValid(koreanMainTexture))
        {
            koreanMainTexture = pKoreanAtlas->mainTextureHandle;
        }
        renderLayer(true, koreanMainTexture, 0.0f);
    }

    return true;
}
} // namespace OpenYAMM::Game
