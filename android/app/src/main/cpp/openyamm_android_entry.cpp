#include "game/app/OpenYammMain.h"

#include <android/log.h>
#include <SDL3/SDL_filesystem.h>
#include <SDL3/SDL_iostream.h>
#include <SDL3/SDL_main.h>
#include <SDL3/SDL_system.h>

#include <array>
#include <cstdarg>
#include <cstdint>
#include <exception>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <streambuf>
#include <string>
#include <vector>

namespace
{
constexpr const char *LogTag = "OpenYAMM";
constexpr size_t CopyBufferSize = 1024 * 1024;

struct PackagedAsset
{
    const char *pApkPath;
    const char *pExtractedPath;
};

class AndroidLogBuffer final : public std::streambuf
{
public:
    explicit AndroidLogBuffer(android_LogPriority priority)
        : m_priority(priority)
    {
    }

protected:
    int overflow(int character) override
    {
        if (character == traits_type::eof())
        {
            return traits_type::not_eof(character);
        }

        appendCharacter(static_cast<char>(character));
        return character;
    }

    int sync() override
    {
        flushLine();
        return 0;
    }

private:
    void appendCharacter(char character)
    {
        if (character == '\n')
        {
            flushLine();
            return;
        }

        m_line.push_back(character);

        if (m_line.size() >= 512)
        {
            flushLine();
        }
    }

    void flushLine()
    {
        if (m_line.empty())
        {
            return;
        }

        __android_log_print(m_priority, LogTag, "%s", m_line.c_str());
        m_line.clear();
    }

    android_LogPriority m_priority;
    std::string m_line;
};

constexpr std::array<PackagedAsset, 18> PackagedShaders = {{
    {"runtime/shaders/essl/fs_cubes.bin", "runtime/shaders/essl/fs_cubes.bin"},
    {"runtime/shaders/essl/fs_editor_preview_material.bin", "runtime/shaders/essl/fs_editor_preview_material.bin"},
    {"runtime/shaders/essl/fs_indoor_textured_lit.bin", "runtime/shaders/essl/fs_indoor_textured_lit.bin"},
    {"runtime/shaders/essl/fs_outdoor_billboard_lit.bin", "runtime/shaders/essl/fs_outdoor_billboard_lit.bin"},
    {"runtime/shaders/essl/fs_outdoor_force_perspective.bin", "runtime/shaders/essl/fs_outdoor_force_perspective.bin"},
    {"runtime/shaders/essl/fs_outdoor_textured_fog.bin", "runtime/shaders/essl/fs_outdoor_textured_fog.bin"},
    {"runtime/shaders/essl/fs_particle.bin", "runtime/shaders/essl/fs_particle.bin"},
    {"runtime/shaders/essl/fs_shadowmaps_texture.bin", "runtime/shaders/essl/fs_shadowmaps_texture.bin"},
    {"runtime/shaders/essl/fs_spell_area_preview.bin", "runtime/shaders/essl/fs_spell_area_preview.bin"},
    {"runtime/shaders/essl/vs_cubes.bin", "runtime/shaders/essl/vs_cubes.bin"},
    {"runtime/shaders/essl/vs_editor_preview_material.bin", "runtime/shaders/essl/vs_editor_preview_material.bin"},
    {"runtime/shaders/essl/vs_indoor_textured_lit.bin", "runtime/shaders/essl/vs_indoor_textured_lit.bin"},
    {"runtime/shaders/essl/vs_outdoor_billboard_lit.bin", "runtime/shaders/essl/vs_outdoor_billboard_lit.bin"},
    {"runtime/shaders/essl/vs_outdoor_force_perspective.bin", "runtime/shaders/essl/vs_outdoor_force_perspective.bin"},
    {"runtime/shaders/essl/vs_outdoor_textured_fog.bin", "runtime/shaders/essl/vs_outdoor_textured_fog.bin"},
    {"runtime/shaders/essl/vs_particle.bin", "runtime/shaders/essl/vs_particle.bin"},
    {"runtime/shaders/essl/vs_shadowmaps_texture.bin", "runtime/shaders/essl/vs_shadowmaps_texture.bin"},
    {"runtime/shaders/essl/vs_spell_area_preview.bin", "runtime/shaders/essl/vs_spell_area_preview.bin"}
}};

void openYammLog(const char *pFormat, ...)
{
    va_list args;
    va_start(args, pFormat);
    __android_log_vprint(ANDROID_LOG_INFO, LogTag, pFormat, args);
    va_end(args);
}

std::filesystem::path getAndroidInternalStorageRoot()
{
    const char *pInternalStoragePath = SDL_GetAndroidInternalStoragePath();

    if (pInternalStoragePath == nullptr || pInternalStoragePath[0] == '\0')
    {
        throw std::runtime_error("SDL_GetAndroidInternalStoragePath returned no path");
    }

    return pInternalStoragePath;
}

bool extractedAssetIsCurrent(const std::filesystem::path &targetPath, Sint64 sourceSize)
{
    if (sourceSize < 0)
    {
        return std::filesystem::is_regular_file(targetPath);
    }

    std::error_code sizeError;
    const uintmax_t targetSize = std::filesystem::file_size(targetPath, sizeError);

    return !sizeError && targetSize == static_cast<uintmax_t>(sourceSize);
}

void copyPackagedAssetToFile(SDL_IOStream &sourceStream, const std::filesystem::path &targetPath, Sint64 sourceSize)
{
    std::filesystem::create_directories(targetPath.parent_path());

    const std::filesystem::path temporaryPath = targetPath.string() + ".tmp";
    std::ofstream outputStream(temporaryPath, std::ios::binary | std::ios::trunc);

    if (!outputStream)
    {
        throw std::runtime_error("Failed to create " + temporaryPath.string());
    }

    std::vector<uint8_t> buffer(CopyBufferSize);
    uint64_t copiedBytes = 0;

    while (true)
    {
        const size_t readBytes = SDL_ReadIO(&sourceStream, buffer.data(), buffer.size());

        if (readBytes == 0)
        {
            const SDL_IOStatus status = SDL_GetIOStatus(&sourceStream);

            if (status == SDL_IO_STATUS_EOF)
            {
                break;
            }

            throw std::runtime_error(std::string("Failed to read APK asset: ") + SDL_GetError());
        }

        outputStream.write(reinterpret_cast<const char *>(buffer.data()), static_cast<std::streamsize>(readBytes));

        if (!outputStream)
        {
            throw std::runtime_error("Failed to write " + temporaryPath.string());
        }

        copiedBytes += readBytes;
    }

    outputStream.close();

    if (!outputStream)
    {
        throw std::runtime_error("Failed to finish writing " + temporaryPath.string());
    }

    if (sourceSize >= 0 && copiedBytes != static_cast<uint64_t>(sourceSize))
    {
        throw std::runtime_error(
            "Short copy for " + targetPath.string() + ": copied " + std::to_string(copiedBytes)
            + " of " + std::to_string(sourceSize));
    }

    std::error_code removeError;
    std::filesystem::remove(targetPath, removeError);

    std::error_code renameError;
    std::filesystem::rename(temporaryPath, targetPath, renameError);

    if (renameError)
    {
        throw std::runtime_error("Failed to install " + targetPath.string() + ": " + renameError.message());
    }
}

void extractPackagedAssetIfNeeded(const std::filesystem::path &storageRoot, const PackagedAsset &asset)
{
    SDL_IOStream *pSourceStream = SDL_IOFromFile(asset.pApkPath, "rb");

    if (pSourceStream == nullptr)
    {
        throw std::runtime_error(std::string("Failed to open APK asset ") + asset.pApkPath + ": " + SDL_GetError());
    }

    const Sint64 sourceSize = SDL_GetIOSize(pSourceStream);
    const std::filesystem::path targetPath = storageRoot / asset.pExtractedPath;

    if (extractedAssetIsCurrent(targetPath, sourceSize))
    {
        SDL_CloseIO(pSourceStream);
        openYammLog("Asset current: %s", targetPath.string().c_str());
        return;
    }

    openYammLog(
        "Extracting %s to %s (%lld bytes)",
        asset.pApkPath,
        targetPath.string().c_str(),
        static_cast<long long>(sourceSize));

    try
    {
        copyPackagedAssetToFile(*pSourceStream, targetPath, sourceSize);
    }
    catch (...)
    {
        SDL_CloseIO(pSourceStream);

        std::error_code removeError;
        std::filesystem::remove(targetPath.string() + ".tmp", removeError);
        throw;
    }

    SDL_CloseIO(pSourceStream);
    openYammLog("Extracted %s", targetPath.string().c_str());
}

void prepareAndroidAssetRoot()
{
    const std::filesystem::path storageRoot = getAndroidInternalStorageRoot();

    for (const PackagedAsset &shader : PackagedShaders)
    {
        extractPackagedAssetIfNeeded(storageRoot, shader);
    }

    std::filesystem::current_path(storageRoot);
    openYammLog("Android working directory: %s", storageRoot.string().c_str());
    openYammLog("Android asset root: installed APK assets");
}

void installAndroidLogStreams()
{
    static AndroidLogBuffer outputBuffer(ANDROID_LOG_INFO);
    static AndroidLogBuffer errorBuffer(ANDROID_LOG_ERROR);

    std::cout.rdbuf(&outputBuffer);
    std::cerr.rdbuf(&errorBuffer);
}
}

int main(int argc, char **argv)
{
    try
    {
        installAndroidLogStreams();
        openYammLog("Starting shared OpenYAMM game entry argc=%d", argc);
        prepareAndroidAssetRoot();
        const int result = OpenYAMM::Game::runApplication(argc, argv);
        openYammLog("Shared OpenYAMM game entry returned %d", result);
        return result;
    }
    catch (const std::exception &exception)
    {
        openYammLog("Fatal error: %s", exception.what());
        return 1;
    }
    catch (...)
    {
        openYammLog("Fatal unknown error");
        return 1;
    }
}
