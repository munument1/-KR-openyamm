#include "engine/AssetFileSystem.h"
#include "engine/FontAsset.h"
#include "game/app/GameSettings.h"

#include <doctest/doctest.h>

#include <chrono>
#include <filesystem>
#include <fstream>

namespace
{
using namespace OpenYAMM;

struct FontFixture
{
    std::filesystem::path root = std::filesystem::temp_directory_path()
        / ("openyamm_font_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    Engine::AssetFileSystem assets;

    FontFixture()
    {
        const std::filesystem::path source = std::filesystem::path(OPENYAMM_SOURCE_DIR) / "assets_dev/engine/fonts";
        std::filesystem::create_directories(root / "engine/fonts/truetype");
        std::filesystem::copy_file(source / "icons/ARRUS.FNT", root / "engine/fonts/arrus.fnt");
        std::filesystem::copy_file(source / "icons/create.fnt", root / "engine/fonts/create.fnt");
        std::filesystem::copy_file(source / "icons/Lucida.fnt", root / "engine/fonts/lucida.fnt");
        std::filesystem::copy_file(source / "icons/SMALLNUM.FNT", root / "engine/fonts/smallnum.fnt");
        std::filesystem::copy_file(source / "icons/COMIC.FNT", root / "engine/fonts/comic.fnt");
        std::filesystem::copy_file(source / "icons/Book2.FNT", root / "engine/fonts/book2.fnt");
        std::filesystem::copy_file(source / "icons/AUTONOTE.FNT", root / "engine/fonts/autonote.fnt");
        std::filesystem::copy_file(source / "icons/ENDGAME.FNT", root / "engine/fonts/endgame.fnt");
        std::filesystem::copy_file(source / "icons/SPELL.FNT", root / "engine/fonts/spell.fnt");
        for (const char *pFile : {"arrus.yml", "openyamm_arrus_faithful.ttf",
            "create.yml", "openyamm_create_faithful.ttf", "lucida.yml", "openyamm_lucida_faithful.ttf",
            "smallnum.yml", "openyamm_smallnum_faithful.ttf", "comic.yml", "openyamm_comic_faithful.ttf",
            "book2.yml", "openyamm_book2_faithful.ttf", "autonote.yml", "openyamm_autonote_faithful.ttf",
            "endgame.yml", "openyamm_endgame_faithful.ttf", "spell.yml", "openyamm_spell_faithful.ttf"})
        {
            std::filesystem::copy_file(source / "truetype" / pFile, root / "engine/fonts/truetype" / pFile);
        }
        REQUIRE(assets.initialize(root, root, Engine::AssetScaleTier::X1));
    }

    ~FontFixture()
    {
        assets.shutdown();
        std::filesystem::remove_all(root);
    }
};

int textWidth(const Engine::FontAtlas &font, const std::string &text)
{
    int width = 0;
    for (unsigned char character : text)
    {
        const Engine::FontGlyphMetrics &metrics = font.glyphMetrics[character];
        width += metrics.leftSpacing + metrics.width + metrics.rightSpacing;
    }
    return width;
}
}

TEST_CASE("font atlas TTF preserves native layout and rasterizes all CP1252 cells without clipping")
{
    const char *pName = "Arrus";
    const char *pPath = "fonts/arrus.fnt";
    int height = 19;
    SUBCASE("Arrus")
    {
    }
    SUBCASE("Create")
    {
        pName = "Create";
        pPath = "fonts/create.fnt";
        height = 18;
    }
    SUBCASE("Lucida")
    {
        pName = "Lucida";
        pPath = "fonts/lucida.fnt";
        height = 17;
    }
    SUBCASE("SMALLNUM")
    {
        pName = "SMALLNUM";
        pPath = "fonts/smallnum.fnt";
        height = 14;
    }
    SUBCASE("Comic")
    {
        pName = "Comic";
        pPath = "fonts/comic.fnt";
        height = 19;
    }
    SUBCASE("Book2")
    {
        pName = "Book2";
        pPath = "fonts/book2.fnt";
        height = 30;
    }
    SUBCASE("AUTONOTE")
    {
        pName = "AUTONOTE";
        pPath = "fonts/autonote.fnt";
        height = 18;
    }
    SUBCASE("ENDGAME")
    {
        pName = "ENDGAME";
        pPath = "fonts/endgame.fnt";
        height = 20;
    }
    SUBCASE("SPELL")
    {
        pName = "SPELL";
        pPath = "fonts/spell.fnt";
        height = 16;
    }
    FontFixture fixture;
    const std::optional<std::vector<uint8_t>> bytes = fixture.assets.readBinaryFile(pPath);
    REQUIRE(bytes);
    std::string error;
    const std::optional<Engine::FontAtlasImage> bitmap =
        Engine::loadFontAtlas(fixture.assets, *bytes, pName, {}, error);
    REQUIRE_MESSAGE(bitmap, error);
    Engine::FontSettings settings;
    settings.preferTtf = true;
    settings.ttfFonts = {"arrus", "create", "lucida", "smallnum", "comic", "book2", "autonote", "endgame", "spell"};
    const std::optional<Engine::FontAtlasImage> ttf =
        Engine::loadFontAtlas(fixture.assets, *bytes, pName, settings, error);
    REQUIRE_MESSAGE(ttf, error);
    CHECK(ttf->atlas.fontHeight == height);
    CHECK(ttf->atlas.atlasScale == 4);
    CHECK(ttf->atlas.atlasWidth == (bitmap->atlas.atlasCellWidth + 10) * 16 * 4);
    CHECK(ttf->atlas.atlasHeight == (bitmap->atlas.fontHeight + 10) * 16 * 4);
    CHECK(ttf->atlas.firstChar == bitmap->atlas.firstChar);
    CHECK(ttf->atlas.lastChar == bitmap->atlas.lastChar);
    for (int character = 0; character < 256; ++character)
    {
        const Engine::FontGlyphMetrics &original = bitmap->atlas.glyphMetrics[character];
        const Engine::FontGlyphMetrics &replacement = ttf->atlas.glyphMetrics[character];
        CHECK(original.leftSpacing == replacement.leftSpacing);
        CHECK(original.width == replacement.width);
        CHECK(original.rightSpacing == replacement.rightSpacing);
    }
    for (const std::string &text : {"Welcome to New Sorpigal, traveller!", "Illusion, magic & adventure.",
        "A very long conversation about goblins and dragons.", "\x93\xc9lise\x94 \x97 \x80"})
    {
        CHECK(textWidth(ttf->atlas, text) == textWidth(bitmap->atlas, text));
    }
    const bool blackInk = std::string(pName) == "AUTONOTE";
    size_t partialAlphaCount = 0;
    size_t mainInkCount = 0;
    size_t shadowCount = 0;
    for (size_t offset = 3; offset < ttf->atlas.mainAtlasPixels.size(); offset += 4)
    {
        const uint8_t alpha = blackInk ? ttf->shadowPixels[offset] : ttf->atlas.mainAtlasPixels[offset];
        partialAlphaCount += alpha > 0 && alpha < 255;
        mainInkCount += ttf->atlas.mainAtlasPixels[offset] > 0;
        shadowCount += ttf->shadowPixels[offset] > 0;
    }
    CHECK(partialAlphaCount > 1000);
    if (std::string(pName) == "ENDGAME" || std::string(pName) == "SPELL")
    {
        CHECK(shadowCount == 0);
        CHECK(mainInkCount > 1000);
    }
    else
    {
        CHECK(shadowCount > 1000);
    }
    if (blackInk)
    {
        CHECK(mainInkCount == 0);
        // Restored l is the native vertical stroke at x=0, y=3..14: no synthetic +1,+1 copy.
        const int cellX = (108 % 16) * (ttf->atlas.atlasCellWidth + 10) * 4;
        const int cellY = (108 / 16) * (height + 10) * 4;
        bool coverageMatches = true;
        for (int y = 0; y < (height + 10) * 4; ++y)
        {
            for (int x = 0; x < 44; ++x)
            {
                const size_t offset = (size_t(cellY + y) * ttf->atlas.atlasWidth + cellX + x) * 4;
                const bool ink = x >= 20 && x < 24 && y >= 32 && y < 80;
                coverageMatches &= ttf->shadowPixels[offset + 3] == (ink ? 255 : 0);
                coverageMatches &= ttf->shadowPixels[offset] == 0
                    && ttf->shadowPixels[offset + 1] == 0 && ttf->shadowPixels[offset + 2] == 0;
            }
        }
        CHECK(coverageMatches);
    }

    // Compare native foreground/shadow pixels against the FNT, including reserved byte slots.
    bool nativePixelsMatch = true;
    for (int character = bitmap->atlas.firstChar; character <= bitmap->atlas.lastChar; ++character)
    {
        const size_t offsetPosition = 32 + 256 * 12 + character * 4;
        const uint32_t glyphOffset = uint32_t((*bytes)[offsetPosition])
            | (uint32_t((*bytes)[offsetPosition + 1]) << 8)
            | (uint32_t((*bytes)[offsetPosition + 2]) << 16)
            | (uint32_t((*bytes)[offsetPosition + 3]) << 24);
        const int width = bitmap->atlas.glyphMetrics[character].width;
        for (int y = 0; y < height; ++y)
        {
            for (int x = 0; x < width; ++x)
            {
                const uint8_t value = (*bytes)[32 + 4096 + glyphOffset + y * width + x];
                const size_t pixel = (size_t((character / 16) * height + y) * bitmap->atlas.atlasWidth
                    + (character % 16) * bitmap->atlas.atlasCellWidth + x) * 4;
                for (int channel = 0; channel < 4; ++channel)
                {
                    nativePixelsMatch &= bitmap->atlas.mainAtlasPixels[pixel + channel] == (value > 1 ? 255 : 0);
                }
                nativePixelsMatch &= bitmap->shadowPixels[pixel + 3] == (value == 1 ? 255 : 0);
            }
        }
    }
    CHECK(nativePixelsMatch);
}

TEST_CASE("font atlas selection is explicit and broken selected replacements report an error")
{
    FontFixture fixture;
    const std::optional<std::vector<uint8_t>> bytes = fixture.assets.readBinaryFile("fonts/arrus.fnt");
    REQUIRE(bytes);
    Engine::FontSettings settings;
    CHECK_FALSE(settings.usesTrueType("Arrus"));
    settings.preferTtf = true;
    CHECK(settings.usesTrueType("ARRUS"));
    CHECK_FALSE(settings.usesTrueType("Create"));
    std::string error;
    const std::optional<Engine::FontAtlasImage> unlisted =
        Engine::loadFontAtlas(fixture.assets, *bytes, "Create", settings, error);
    REQUIRE_MESSAGE(unlisted, error);
    CHECK(unlisted->atlas.atlasScale == 1);

    std::ofstream(fixture.root / "engine/fonts/truetype/arrus.yml")
        << "file: openyamm_arrus_faithful.ttf\nlogical_height: 19\nbaseline: 14\n"
        << "encoding: windows-1252\npresentation: unknown\n";
    CHECK_FALSE(Engine::loadFontAtlas(fixture.assets, *bytes, "Arrus", settings, error));
    CHECK(error.find("unsupported TTF presentation") != std::string::npos);
    std::ofstream(fixture.root / "engine/fonts/truetype/arrus.yml") << "file: bad.ttf\n";
    CHECK_FALSE(Engine::loadFontAtlas(fixture.assets, *bytes, "Arrus", settings, error));
    CHECK(error.find("invalid TTF descriptor") != std::string::npos);
    settings.preferTtf = false;
    CHECK(Engine::loadFontAtlas(fixture.assets, *bytes, "Arrus", settings, error));
    CHECK_FALSE(Engine::loadFontAtlas(fixture.assets, {0, 1, 2}, "Arrus", settings, error));
    CHECK(error == "invalid legacy FNT");
}

TEST_CASE("font atlas retains compact MMX bitmap parsing")
{
    Engine::AssetFileSystem assets;
    std::vector<uint8_t> bytes(32 + 1280 + 4, 0);
    bytes[0] = 65;
    bytes[1] = 65;
    bytes[2] = 8;
    bytes[5] = 2;
    bytes[32 + 65] = 2;
    bytes[32 + 1280] = 2;
    bytes[32 + 1280 + 3] = 1;
    std::string error;
    const std::optional<Engine::FontAtlasImage> font = Engine::loadFontAtlas(assets, bytes, "test", {}, error);
    REQUIRE_MESSAGE(font, error);
    CHECK(font->atlas.glyphMetrics[65].width == 2);
    const size_t firstPixel = (size_t(4 * 2) * font->atlas.atlasWidth + 2) * 4;
    CHECK(font->atlas.mainAtlasPixels[firstPixel + 3] == 255);
    CHECK(font->shadowPixels[firstPixel + (font->atlas.atlasWidth + 1) * 4 + 3] == 255);
    bytes.pop_back();
    CHECK_FALSE(Engine::loadFontAtlas(assets, bytes, "test", {}, error));
}

TEST_CASE("font settings round trip normalizes the selected font list and preserves bitmap mode")
{
    FontFixture fixture;
    const std::filesystem::path path = fixture.root / "settings.ini";
    std::ofstream(path) << "[fonts]\nprefer_ttf=true\nttf_fonts=Arrus, CREATE, arrus, ,\n";
    std::string error;
    std::optional<Game::GameSettings> settings = Game::loadGameSettings(path, error);
    REQUIRE_MESSAGE(settings, error);
    CHECK(settings->fonts.preferTtf);
    CHECK(settings->fonts.ttfFonts == std::vector<std::string>{"arrus", "create"});
    REQUIRE(Game::saveGameSettings(path, *settings, error));
    std::optional<Game::GameSettings> reloaded = Game::loadGameSettings(path, error);
    REQUIRE(reloaded);
    CHECK(reloaded->fonts == settings->fonts);
    settings->fonts.preferTtf = false;
    settings->fonts.ttfFonts.clear();
    REQUIRE(Game::saveGameSettings(path, *settings, error));
    reloaded = Game::loadGameSettings(path, error);
    REQUIRE(reloaded);
    CHECK_FALSE(reloaded->fonts.preferTtf);
    CHECK(reloaded->fonts.ttfFonts.empty());
}
