#include "game/ui/screens/CutsceneVideoScreen.h"
#include "game/ui/Utf8TextWrapping.h"

#include <algorithm>
#include <array>
#include <cctype>
#include <cmath>
#include <cstdio>
#include <optional>
#include <sstream>

namespace OpenYAMM::Game
{
namespace
{
constexpr const char *SubtitleFontName = "Create";
constexpr uint32_t SubtitleTextColor = 0xffffffffu;
constexpr float SubtitleReferenceWidth = 640.0f;
constexpr float SubtitleReferenceHeight = 480.0f;
constexpr float SubtitleMaxUiScale = 3.0f;
constexpr float SubtitleBottomInset = 20.0f;
constexpr float SubtitleHorizontalInset = 24.0f;

std::string trimAscii(std::string value)
{
    while (!value.empty() && std::isspace(static_cast<unsigned char>(value.front())) != 0)
    {
        value.erase(value.begin());
    }
    while (!value.empty() && std::isspace(static_cast<unsigned char>(value.back())) != 0)
    {
        value.pop_back();
    }
    return value;
}

std::string lowercaseAscii(std::string value)
{
    std::transform(value.begin(), value.end(), value.begin(), [](unsigned char character)
    {
        return static_cast<char>(std::tolower(character));
    });
    return value;
}

bool parseSrtTimestamp(const std::string &text, float *pSeconds)
{
    if (pSeconds == nullptr)
    {
        return false;
    }

    int hours = 0;
    int minutes = 0;
    int seconds = 0;
    int milliseconds = 0;
    char separator = '\0';
    if (std::sscanf(text.c_str(), "%d:%d:%d%c%d", &hours, &minutes, &seconds, &separator, &milliseconds) != 5
        || (separator != ',' && separator != '.')
        || hours < 0 || minutes < 0 || minutes > 59 || seconds < 0 || seconds > 59
        || milliseconds < 0 || milliseconds > 999)
    {
        return false;
    }

    *pSeconds = static_cast<float>(hours * 3600 + minutes * 60 + seconds)
        + static_cast<float>(milliseconds) / 1000.0f;
    return true;
}

std::vector<CutsceneVideoScreen::SubtitleCue> parseSrt(const std::string &rawText)
{
    std::string text = rawText;
    if (text.size() >= 3
        && static_cast<unsigned char>(text[0]) == 0xef
        && static_cast<unsigned char>(text[1]) == 0xbb
        && static_cast<unsigned char>(text[2]) == 0xbf)
    {
        text.erase(0, 3);
    }

    std::vector<CutsceneVideoScreen::SubtitleCue> result;
    std::istringstream stream(text);
    std::string line;
    while (std::getline(stream, line))
    {
        if (!line.empty() && line.back() == '\r')
        {
            line.pop_back();
        }
        line = trimAscii(line);
        if (line.empty())
        {
            continue;
        }

        std::string timingLine = line;
        const bool indexLine = std::all_of(line.begin(), line.end(), [](unsigned char character)
        {
            return std::isdigit(character) != 0;
        });
        if (indexLine)
        {
            if (!std::getline(stream, timingLine))
            {
                break;
            }
            if (!timingLine.empty() && timingLine.back() == '\r')
            {
                timingLine.pop_back();
            }
            timingLine = trimAscii(timingLine);
        }

        const size_t arrow = timingLine.find("-->");
        if (arrow == std::string::npos)
        {
            continue;
        }

        float startSeconds = 0.0f;
        float endSeconds = 0.0f;
        if (!parseSrtTimestamp(trimAscii(timingLine.substr(0, arrow)), &startSeconds)
            || !parseSrtTimestamp(trimAscii(timingLine.substr(arrow + 3)), &endSeconds)
            || endSeconds <= startSeconds)
        {
            continue;
        }

        std::string cueText;
        while (std::getline(stream, line))
        {
            if (!line.empty() && line.back() == '\r')
            {
                line.pop_back();
            }
            if (trimAscii(line).empty())
            {
                break;
            }
            if (!cueText.empty())
            {
                cueText += '\n';
            }
            cueText += line;
        }

        if (!cueText.empty())
        {
            result.push_back({startSeconds, endSeconds, cueText});
        }
    }

    std::sort(result.begin(), result.end(), [](const auto &left, const auto &right)
    {
        return left.startSeconds < right.startSeconds;
    });
    return result;
}
}

CutsceneVideoScreen::CutsceneVideoScreen(
    const Engine::AssetFileSystem &assetFileSystem,
    GameAudioSystem *pGameAudioSystem,
    const std::string &videoDirectory,
    const std::string &videoStem,
    AppMode mode)
    : MenuScreenBase(assetFileSystem)
    , m_pGameAudioSystem(pGameAudioSystem)
    , m_videoDirectory(videoDirectory)
    , m_videoStem(videoStem)
    , m_mode(mode)
{
}

AppMode CutsceneVideoScreen::mode() const
{
    return m_mode;
}

bool CutsceneVideoScreen::shouldClose() const
{
    return m_shouldClose;
}

void CutsceneVideoScreen::onEnter()
{
    if (m_pGameAudioSystem != nullptr)
    {
        m_pausedBackgroundMusic = !m_pGameAudioSystem->isBackgroundMusicPaused();

        if (m_pausedBackgroundMusic)
        {
            m_pGameAudioSystem->pauseBackgroundMusic();
        }
    }

    loadSubtitles();
    m_videoPlayer.initialize();
}

void CutsceneVideoScreen::onExit()
{
    m_videoPlayer.shutdown();
    m_subtitles.clear();

    if (m_pausedBackgroundMusic && m_pGameAudioSystem != nullptr)
    {
        m_pGameAudioSystem->resumeBackgroundMusic();
    }

    m_pausedBackgroundMusic = false;
}

void CutsceneVideoScreen::handleSdlEvent(const SDL_Event &event)
{
    if (event.type == SDL_EVENT_MOUSE_BUTTON_DOWN || event.type == SDL_EVENT_FINGER_UP)
    {
        m_shouldClose = true;
        return;
    }

    if (event.type != SDL_EVENT_KEY_DOWN)
    {
        return;
    }

    if (event.key.key == SDLK_ESCAPE)
    {
        m_shouldClose = true;
    }
}

void CutsceneVideoScreen::loadSubtitles()
{
    m_subtitles.clear();
    const std::string lowerStem = lowercaseAscii(m_videoStem);
    const std::array<std::string, 4> candidates = {{
        "subtitles/" + m_videoStem + ".srt",
        "Subtitles/" + m_videoStem + ".srt",
        "subtitles/" + lowerStem + ".srt",
        "Subtitles/" + lowerStem + ".srt",
    }};

    for (const std::string &candidate : candidates)
    {
        const std::optional<std::string> subtitleText = assetFileSystem().readTextFile(candidate);
        if (!subtitleText.has_value())
        {
            continue;
        }
        m_subtitles = parseSrt(*subtitleText);
        return;
    }
}

void CutsceneVideoScreen::drawSubtitles(const Rect &videoRect)
{
    if (m_subtitles.empty())
    {
        return;
    }

    const float playbackSeconds = m_videoPlayer.playbackSeconds();
    std::string activeText;
    for (const SubtitleCue &cue : m_subtitles)
    {
        if (playbackSeconds < cue.startSeconds)
        {
            break;
        }
        if (playbackSeconds >= cue.startSeconds && playbackSeconds <= cue.endSeconds)
        {
            if (!activeText.empty())
            {
                activeText += '\n';
            }
            activeText += cue.text;
        }
    }

    if (activeText.empty())
    {
        return;
    }

    const float uiScale = std::min(
        std::min(
            static_cast<float>(frameWidth()) / SubtitleReferenceWidth,
            static_cast<float>(frameHeight()) / SubtitleReferenceHeight),
        SubtitleMaxUiScale);
    const float textScale = std::max(1.0f, uiScale);
    const float maxWidth = std::max(1.0f, videoRect.width - SubtitleHorizontalInset * 2.0f * textScale);
    const std::vector<std::string> lines = wrapUtf8Text(activeText, maxWidth, [this, textScale](const std::string &value)
    {
        return measureTextWidth(SubtitleFontName, value, textScale);
    });
    if (lines.empty())
    {
        return;
    }

    const float lineAdvance = static_cast<float>(fontHeight(SubtitleFontName) + 3) * textScale;
    float y = videoRect.y + videoRect.height - SubtitleBottomInset * textScale - lineAdvance * static_cast<float>(lines.size());
    for (const std::string &subtitleLine : lines)
    {
        const float width = measureTextWidth(SubtitleFontName, subtitleLine, textScale);
        const float x = std::round(videoRect.x + (videoRect.width - width) * 0.5f);
        drawText(SubtitleFontName, subtitleLine, x, std::round(y), SubtitleTextColor, textScale, true);
        y += lineAdvance;
    }
}

void CutsceneVideoScreen::drawScreen(float deltaSeconds)
{
    const Rect fullFrame = {0.0f, 0.0f, static_cast<float>(frameWidth()), static_cast<float>(frameHeight())};
    drawPixelsBgra("__cutscene_video_black__", 1, 1, m_blackPixel, fullFrame);

    if (!m_playAttempted)
    {
        m_playAttempted = true;
        if (m_pGameAudioSystem != nullptr)
        {
            m_videoPlayer.setAudioVolume(m_pGameAudioSystem->soundVolume());
        }

        m_startedPlayback = m_videoPlayer.play(assetFileSystem(), m_videoStem, m_videoDirectory, false);

        if (!m_startedPlayback)
        {
            m_shouldClose = true;
            return;
        }
    }

    if (!m_startedPlayback)
    {
        return;
    }

    if (m_pGameAudioSystem != nullptr)
    {
        m_videoPlayer.setAudioVolume(m_pGameAudioSystem->soundVolume());
    }

    m_videoPlayer.update(deltaSeconds);

    if (m_videoPlayer.hasFinishedPlayback())
    {
        m_shouldClose = true;
    }

    if (!m_videoPlayer.hasActiveFrame())
    {
        return;
    }

    const bgfx::TextureHandle textureHandle = m_videoPlayer.textureHandle();
    const int textureWidth = m_videoPlayer.videoTextureWidth();
    const int textureHeight = m_videoPlayer.videoTextureHeight();

    if (textureWidth <= 0 || textureHeight <= 0)
    {
        return;
    }

    const float sourceWidth = static_cast<float>(textureWidth);
    const float sourceHeight = static_cast<float>(textureHeight);
    const float scale = std::min(
        static_cast<float>(frameWidth()) / sourceWidth,
        static_cast<float>(frameHeight()) / sourceHeight);
    const float drawWidth = std::round(sourceWidth * scale);
    const float drawHeight = std::round(sourceHeight * scale);
    const float drawX = std::round((static_cast<float>(frameWidth()) - drawWidth) * 0.5f);
    const float drawY = std::round((static_cast<float>(frameHeight()) - drawHeight) * 0.5f);
    const Rect videoRect = {drawX, drawY, drawWidth, drawHeight};
    drawTextureHandle(textureHandle, videoRect);
    drawSubtitles(videoRect);
}
}
