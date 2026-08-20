#pragma once

#include <bgfx/bgfx.h>

#include <cstdint>
#include <vector>

namespace OpenYAMM::Game
{
enum class TextureFilterProfile
{
    Terrain,
    BModel,
    Lightmap,
    Sky,
    Billboard,
    Ui,
    Text,
};

enum class TextureFilterMode
{
    Nearest,
    Linear,
    Anisotropic,
};

enum class BgraTexturePixelPreparation
{
    Required,
    AlreadyPrepared,
};

struct TextureFilteringConfig
{
    bool enabled = true;
    TextureFilterMode terrain = TextureFilterMode::Anisotropic;
    TextureFilterMode bmodel = TextureFilterMode::Anisotropic;
    TextureFilterMode sky = TextureFilterMode::Anisotropic;
    TextureFilterMode billboard = TextureFilterMode::Linear;
    TextureFilterMode ui = TextureFilterMode::Linear;
    TextureFilterMode text = TextureFilterMode::Nearest;
};

uint64_t textureFilterSamplerFlags(TextureFilterProfile profile);
bool textureFilteringEnabled();
void setTextureFilteringEnabled(bool enabled);
void setTextureFilteringConfig(const TextureFilteringConfig &config);
bool toggleTextureFilteringEnabled();
uint32_t textureBindingSamplerFlags(TextureFilterProfile profile, uint32_t extraFlags = BGFX_SAMPLER_NONE);
void bindTexture(
    uint8_t stage,
    bgfx::UniformHandle sampler,
    bgfx::TextureHandle textureHandle,
    TextureFilterProfile profile,
    uint32_t extraFlags = BGFX_SAMPLER_NONE);

bgfx::TextureFormat::Enum bgraTextureUploadFormat();
const bgfx::Memory *copyBgraTextureUploadMemory(const uint8_t *pPixels, uint32_t pixelBytes);

bool prepareBgraTexturePixelsForUploadInPlace(
    uint16_t width,
    uint16_t height,
    std::vector<uint8_t> &pixels,
    TextureFilterProfile profile);

bgfx::TextureHandle createBgraTexture2D(
    uint16_t width,
    uint16_t height,
    const uint8_t *pPixels,
    uint32_t pixelBytes,
    TextureFilterProfile profile,
    uint64_t extraFlags = BGFX_TEXTURE_NONE,
    BgraTexturePixelPreparation pixelPreparation = BgraTexturePixelPreparation::Required);

bgfx::TextureHandle createEmptyBgraTexture2D(
    uint16_t width,
    uint16_t height,
    TextureFilterProfile profile,
    uint64_t extraFlags = BGFX_TEXTURE_NONE);
}
