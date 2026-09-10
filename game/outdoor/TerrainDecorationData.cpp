#include "game/outdoor/TerrainDecorationData.h"

#include "engine/ImageAssetLoader.h"
#include "game/outdoor/OutdoorGeometryUtils.h"

#include <yaml-cpp/yaml.h>

#include <algorithm>
#include <cmath>
#include <filesystem>
#include <stdexcept>

namespace OpenYAMM::Game
{
namespace
{
uint32_t hash(uint32_t value)
{
    value ^= value >> 16;
    value *= 0x7feb352du;
    value ^= value >> 15;
    value *= 0x846ca68bu;
    return value ^ (value >> 16);
}

float randomUnit(uint32_t &state)
{
    state = hash(state + 0x9e3779b9u);
    return float(state >> 8) / 16777216.0f;
}

float boundedFloat(const YAML::Node &node, const char *pName, float fallback, float min, float max)
{
    const float value = node[pName] ? node[pName].as<float>() : fallback;
    if (!std::isfinite(value) || value < min || value > max)
    {
        throw std::runtime_error(std::string("invalid terrain decoration ") + pName);
    }
    return value;
}

bool blocked(const OutdoorMapData &map, float x, float y, float z, float radius)
{
    for (const OutdoorBModel &model : map.bmodels)
    {
        if (x >= model.minX - radius && x <= model.maxX + radius &&
            y >= model.minY - radius && y <= model.maxY + radius &&
            z <= model.maxZ + 48.0f && z + 96.0f >= model.minZ)
        {
            return true;
        }
    }
    for (const OutdoorEntity &entity : map.entities)
    {
        const float dx = x - entity.x;
        const float dy = y - entity.y;
        if (dx * dx + dy * dy < 80.0f * 80.0f && std::abs(z - entity.z) < 128.0f)
        {
            return true;
        }
    }
    return false;
}

float smoothUnit(float value)
{
    value = std::clamp(value, 0.0f, 1.0f);
    return value * value * (3.0f - 2.0f * value);
}

float patchNoise(float x, float y, uint32_t seed)
{
    const int ix = int(std::floor(x));
    const int iy = int(std::floor(y));
    const auto sample = [&](int dx, int dy)
    {
        return float(hash(seed ^ hash(uint32_t(ix + dx)) ^ hash(uint32_t(iy + dy) + 0x517cc1b7u)) >> 8)
            / 16777216.0f;
    };
    const float u = smoothUnit(x - ix);
    const float v = smoothUnit(y - iy);
    return std::lerp(std::lerp(sample(0, 0), sample(1, 0), u),
                     std::lerp(sample(0, 1), sample(1, 1), u), v);
}

float cellDensity(const TerrainDecorationConfig &config, float x, float y)
{
    if (config.densityMask.empty())
    {
        return 1.0f;
    }
    // Pixel centres correspond to terrain cell centres; interpolate across shared cell edges.
    x = std::clamp(x - 0.5f, 0.0f, 127.0f);
    y = std::clamp(y - 0.5f, 0.0f, 127.0f);
    const int ix = int(x);
    const int iy = int(y);
    const int nx = std::min(ix + 1, 127);
    const int ny = std::min(iy + 1, 127);
    return std::lerp(std::lerp(float(config.densityMask[iy * 128 + ix]),
                               float(config.densityMask[iy * 128 + nx]), x - ix),
                     std::lerp(float(config.densityMask[ny * 128 + ix]),
                               float(config.densityMask[ny * 128 + nx]), x - ix), y - iy) / 255.0f;
}

float materialCoverage(const TerrainDecorationRule &rule, float u, float v, bool fullFootprint = false)
{
    if (rule.coverage.empty())
    {
        return 1.0f;
    }
    // Short blades may overhang the blend; their roots must still be on grass. Stones and tall
    // clumps retain full-width clearance. A soft acceptance probability thins the grassy edge.
    const bool strict = rule.stone || fullFootprint;
    const float radiusWorld = strict ? rule.width * 0.65f : 4.0f;
    const int radius = std::max(1, int(std::ceil(radiusWorld * rule.maskWidth / 512.0f)));
    const int x = int(u * rule.maskWidth);
    const int y = int(v * rule.maskHeight);
    uint8_t minimum = 255;
    for (int dy = -radius; dy <= radius; ++dy)
    {
        for (int dx = -radius; dx <= radius; ++dx)
        {
            const int mx = std::clamp(x + dx, 0, rule.maskWidth - 1);
            const int my = std::clamp(y + dy, 0, rule.maskHeight - 1);
            minimum = std::min(minimum, rule.coverage[my * rule.maskWidth + mx]);
        }
    }
    return strict ? (minimum >= 240 ? 1.0f : 0.0f) : smoothUnit((float(minimum) - 128.0f) / 112.0f);
}
}

std::optional<TerrainDecorationConfig> loadTerrainDecorationConfig(
    const Engine::AssetFileSystem &assets, const OutdoorMapData &map, std::string &error)
{
    error.clear();
    const std::string directory = "worlds/" + map.worldId + "/terrain_decorations/";
    const std::string path = directory + std::filesystem::path(map.fileName).stem().string() + ".yml";
    const std::optional<std::string> text = assets.readTextFile(path);
    if (!text)
    {
        return std::nullopt;
    }
    try
    {
        const YAML::Node root = YAML::Load(*text);
        if (root["version"].as<int>() != 1 || !root["rules"].IsSequence() || root["rules"].size() > 256)
        {
            throw std::runtime_error("expected version 1 and at most 256 terrain decoration rules");
        }
        TerrainDecorationConfig config;
        config.seed = root["seed"].as<uint32_t>(1);
        config.distance = boundedFloat(root, "distance", 2048.0f, 256.0f, 8192.0f);
        config.minimumNormalZ = boundedFloat(root, "minimum_normal_z", 0.85f, 0.5f, 1.0f);
        config.densityVariation = boundedFloat(root, "density_variation", 0.0f, 0.0f, 1.0f);
        config.patchSize = boundedFloat(root, "patch_size", 768.0f, 128.0f, 8192.0f);
        config.tallGrassChance = boundedFloat(root, "tall_grass_chance", 0.0f, 0.0f, 0.25f);
        config.tallGrassScale = boundedFloat(root, "tall_grass_scale", 1.8f, 1.0f, 2.0f);
        config.tuftTexture = directory + root["tuft_texture"].as<std::string>();
        if (root["tuft_atlas_grid"])
        {
            config.tuftAtlasGrid = root["tuft_atlas_grid"].as<std::array<int, 2>>();
        }
        if (config.tuftAtlasGrid[0] < 1 || config.tuftAtlasGrid[0] > 4 ||
            config.tuftAtlasGrid[1] < 1 || config.tuftAtlasGrid[1] > 4)
        {
            throw std::runtime_error("tuft atlas grid dimensions must be 1..4");
        }
        if (root["tuft_variants"])
        {
            if (!root["tuft_variants"].IsSequence() || root["tuft_variants"].size() > 16)
            {
                throw std::runtime_error("tuft_variants must be a sequence of at most 16 variants");
            }
            config.tuftVariants.clear();
            for (const YAML::Node &variantNode : root["tuft_variants"])
            {
                TerrainDecorationVariant variant;
                variant.weight = boundedFloat(variantNode, "weight", 1.0f, 0.01f, 100.0f);
                // Width cannot exceed the rule's footprint used by material/building exclusions.
                variant.widthScale = boundedFloat(variantNode, "width_scale", 1.0f, 0.25f, 1.0f);
                variant.heightScale = boundedFloat(variantNode, "height_scale", 1.0f, 0.25f, 1.5f);
                config.tuftVariants.push_back(variant);
            }
        }
        if (config.tuftVariants.size() != size_t(config.tuftAtlasGrid[0] * config.tuftAtlasGrid[1]))
        {
            throw std::runtime_error("tuft variant count must equal atlas cell count");
        }
        Engine::BinaryAssetCache cache;
        if (root["density_mask"])
        {
            const std::string maskPath = directory + root["density_mask"].as<std::string>();
            const std::optional<Engine::ImagePixelsBgra> mask =
                Engine::loadImageAssetPixelsBgra(assets, maskPath, cache);
            if (!mask || mask->width != 128 || mask->height != 128)
            {
                throw std::runtime_error("terrain density mask must be 128x128: " + maskPath);
            }
            for (size_t i = 0; i < mask->pixels.size(); i += 4)
            {
                config.densityMask.push_back(mask->pixels[i + 2]);
            }
        }
        for (const YAML::Node &node : root["rules"])
        {
            TerrainDecorationRule rule;
            rule.texture = node["texture"].as<std::string>();
            const std::string kind = node["kind"].as<std::string>();
            if (kind != "grass" && kind != "stone")
            {
                throw std::runtime_error("terrain decoration kind must be grass or stone");
            }
            rule.stone = kind == "stone";
            rule.candidates = node["candidates"].as<int>();
            if (rule.texture.empty() || rule.candidates < 1 || rule.candidates > 128)
            {
                throw std::runtime_error("terrain decoration requires a texture and 1..128 candidates per cell");
            }
            rule.width = boundedFloat(node, "width", 40.0f, 2.0f, 96.0f);
            rule.density = boundedFloat(node, "density", 1.0f, 0.0f, 2.0f);
            rule.height = boundedFloat(node, "height", 28.0f, 2.0f, 64.0f);
            if (node["tint"])
            {
                rule.tint = node["tint"].as<std::array<float, 3>>();
                for (float value : rule.tint)
                {
                    if (!std::isfinite(value) || value < 0.0f || value > 1.5f)
                    {
                        throw std::runtime_error("invalid terrain decoration tint");
                    }
                }
            }
            if (node["mask"])
            {
                const std::string maskPath = directory + node["mask"].as<std::string>();
                const std::optional<Engine::ImagePixelsBgra> mask =
                    Engine::loadImageAssetPixelsBgra(assets, maskPath, cache);
                if (!mask || mask->width < 1 || mask->height < 1 || mask->width > 128 || mask->height > 128)
                {
                    throw std::runtime_error("invalid terrain decoration coverage mask: " + maskPath);
                }
                rule.maskWidth = mask->width;
                rule.maskHeight = mask->height;
                rule.coverage.reserve(mask->width * mask->height);
                const bool invert = node["invert_mask"].as<bool>(false);
                for (size_t i = 0; i < mask->pixels.size(); i += 4)
                {
                    // bimg expands grayscale PNGs from R8: intensity is in red, while blue/green
                    // remain zero. Red also holds intensity for ordinary RGB grayscale masks.
                    const uint8_t intensity = mask->pixels[i + 2];
                    rule.coverage.push_back(invert ? 255 - intensity : intensity);
                }
            }
            config.rules.push_back(std::move(rule));
        }
        return config;
    }
    catch (const std::exception &exception)
    {
        error = path + ": " + exception.what();
        return std::nullopt;
    }
}

TerrainDecorationPlacement scatterTerrainDecorations(
    const OutdoorMapData &map, const std::array<std::string, 256> &textures, const TerrainDecorationConfig &config)
{
    TerrainDecorationPlacement result;
    constexpr int width = OutdoorMapData::TerrainWidth;
    constexpr int height = OutdoorMapData::TerrainHeight;
    if (map.noTerrain || map.heightMap.size() != width * height || map.tileMap.size() != width * height)
    {
        return result;
    }
    std::array<std::vector<const TerrainDecorationRule *>, 256> rulesByTile;
    for (size_t tile = 0; tile < textures.size(); ++tile)
    {
        for (const TerrainDecorationRule &rule : config.rules)
        {
            if (textures[tile] == rule.texture)
            {
                rulesByTile[tile].push_back(&rule);
            }
        }
    }
    const auto footprintFits = [&](int cellX, int cellY, float u, float v,
                                   const TerrainDecorationRule &rule, bool fullFootprint = false)
    {
        if (materialCoverage(rule, u, v, fullFootprint) <= 0.0f)
        {
            return false;
        }
        const float radius = (rule.stone || fullFootprint ? rule.width * 0.65f : 4.0f)
            / OutdoorMapData::TerrainTileSize;
        for (int dy = -1; dy <= 1; ++dy)
        {
            for (int dx = -1; dx <= 1; ++dx)
            {
                const float gx = cellX + u + dx * radius;
                const float gy = cellY + v + dy * radius;
                const int tx = int(std::floor(gx));
                const int ty = int(std::floor(gy));
                if (tx == cellX && ty == cellY)
                {
                    continue;
                }
                if (tx < 0 || ty < 0 || tx >= width - 1 || ty >= height - 1)
                {
                    return false;
                }
                bool allowed = false;
                for (const TerrainDecorationRule *pNeighbor : rulesByTile[map.tileMap[ty * width + tx]])
                {
                    if (pNeighbor->stone == rule.stone &&
                        materialCoverage(*pNeighbor, gx - tx, gy - ty, fullFootprint) > 0.0f)
                    {
                        allowed = true;
                        break;
                    }
                }
                if (!allowed)
                {
                    return false;
                }
            }
        }
        return true;
    };
    float totalVariantWeight = 0.0f;
    for (const TerrainDecorationVariant &variant : config.tuftVariants)
    {
        totalVariantWeight += variant.weight;
    }
    // Keep each mesh kind contiguous so mixed tiles do not fragment merged draw ranges.
    // Placement is static; no scattering or uploads occur during frames.
    for (bool stone : {false, true})
    {
        for (int y = 0; y < height - 1; ++y)
        {
            for (int x = 0; x < width - 1; ++x)
            {
                const uint32_t cell = y * width + x;
                for (const TerrainDecorationRule *pRule : rulesByTile[map.tileMap[cell]])
                {
                    const TerrainDecorationRule &rule = *pRule;
                    if (rule.stone != stone)
                    {
                        continue;
                    }
                    TerrainDecorationPatch patch = {};
                    patch.first = uint32_t(result.instances.size());
                    patch.stone = rule.stone;
                    patch.min = {outdoorGridCornerWorldX(x) - 96.0f, outdoorGridCornerWorldY(y + 1) - 96.0f,
                                 1.0e9f};
                    patch.max = {outdoorGridCornerWorldX(x + 1) + 96.0f, outdoorGridCornerWorldY(y) + 96.0f,
                                 -1.0e9f};
                    uint32_t state = hash(config.seed ^ cell ^ (rule.stone ? 0x517cc1b7u : 0u));
                    const float variation = rule.stone ? 0.0f : config.densityVariation;
                    const float maximumDensity = rule.density * (1.0f + variation);
                    const int attempts = int(std::ceil(rule.candidates * maximumDensity));
                    for (int i = 0; i < attempts; ++i)
                    {
                        const float u = randomUnit(state);
                        const float v = randomUnit(state);
                        const float px = outdoorGridCornerWorldX(x) + u * 512.0f;
                        const float py = outdoorGridCornerWorldY(y) - v * 512.0f;
                        const float z = sampleOutdoorRenderedTerrainHeight(map, px, py);
                        const float scale = 0.7f + 0.6f * randomUnit(state);
                        const float yaw = randomUnit(state) * 6.2831853f;
                        const float shade = 0.9f + 0.15f * randomUnit(state);
                        const float noise = patchNoise(px / config.patchSize, py / config.patchSize, config.seed);
                        const float density = rule.density * (1.0f + variation * (2.0f * noise - 1.0f))
                            * cellDensity(config, x + u, y + v);
                        uint32_t detailState = hash(state ^ 0x9a372f51u);
                        const float acceptance = density * rule.candidates / attempts * materialCoverage(rule, u, v);
                        if (randomUnit(detailState) >= acceptance)
                        {
                            continue;
                        }
                        const bx::Vec3 normal = sampleOutdoorRenderedTerrainNormal(map, px, py);
                        if (!footprintFits(x, y, u, v, rule) || normal.z < config.minimumNormalZ ||
                            blocked(map, px, py, z, rule.width * 0.65f + 32.0f))
                        {
                            continue;
                        }
                        size_t variantIndex = 0;
                        TerrainDecorationVariant variant;
                        if (!rule.stone && !config.tuftVariants.empty())
                        {
                            // A separate random stream preserves all existing placement/rotation choices.
                            uint32_t variantState = hash(state ^ 0x85ebca6bu);
                            float choice = randomUnit(variantState) * totalVariantWeight;
                            while (variantIndex + 1 < config.tuftVariants.size() &&
                                   choice >= config.tuftVariants[variantIndex].weight)
                            {
                                choice -= config.tuftVariants[variantIndex].weight;
                                ++variantIndex;
                            }
                            variant = config.tuftVariants[variantIndex];
                        }
                        const float tallChance = config.tallGrassChance * 2.0f * smoothUnit((noise - 0.35f) / 0.4f);
                        const bool tall = !rule.stone && randomUnit(detailState) < tallChance &&
                            footprintFits(x, y, u, v, rule, true) &&
                            !blocked(map, px, py, z, 144.0f);
                        const float instanceHeight = rule.height * scale *
                            (tall ? std::max(variant.heightScale, config.tallGrassScale) : variant.heightScale);
                        TerrainDecorationInstance instance = {
                            {px, py, z - (rule.stone ? 1.5f : 3.0f), yaw},
                            {rule.width * scale * variant.widthScale, instanceHeight,
                             rule.stone ? 0.0f : 2.5f, rule.stone ? 1.0f : 0.0f},
                            {rule.tint[0] * shade, rule.tint[1] * shade, rule.tint[2] * shade, 1.0f},
                            {normal.x, normal.y, normal.z, float(variantIndex)}};
                        result.instances.push_back(instance);
                        patch.min[2] = std::min(patch.min[2], z - 8.0f);
                        patch.max[2] = std::max(patch.max[2], z + instanceHeight + 8.0f);
                    }
                    patch.count = uint32_t(result.instances.size()) - patch.first;
                    if (patch.count > 0)
                    {
                        result.patches.push_back(patch);
                    }
                }
            }
        }
    }
    return result;
}
} // namespace OpenYAMM::Game
