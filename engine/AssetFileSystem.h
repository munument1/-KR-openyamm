#pragma once

#include "engine/AssetScaleTier.h"

#include <filesystem>
#include <cstdint>
#include <optional>
#include <string>
#include <vector>

namespace OpenYAMM::Engine
{
class AssetFileSystem
{
public:
    AssetFileSystem();
    ~AssetFileSystem();

    AssetFileSystem(const AssetFileSystem &) = delete;
    AssetFileSystem &operator=(const AssetFileSystem &) = delete;

    bool initialize(
        const std::filesystem::path &basePath,
        const std::filesystem::path &assetRoot,
        AssetScaleTier assetScaleTier
    );
    bool initialize(
        const std::filesystem::path &basePath,
        const std::filesystem::path &assetRoot,
        AssetScaleTier assetScaleTier,
        const std::string &activeWorldId
    );
    bool initialize(
        const std::filesystem::path &basePath,
        const std::filesystem::path &assetRoot,
        AssetScaleTier assetScaleTier,
        const AssetScaleProfile &assetScaleProfile,
        const std::string &activeWorldId
    );
    bool switchActiveWorld(const std::string &activeWorldId);
    bool mountDevelopmentRoot(const std::filesystem::path &assetRoot);
    bool exists(const std::string &virtualPath) const;
    std::vector<std::string> enumerate(const std::string &virtualPath) const;
    std::optional<std::vector<uint8_t>> readBinaryFile(const std::string &virtualPath) const;
    std::optional<std::string> readTextFile(const std::string &virtualPath) const;
    std::optional<std::filesystem::path> resolvePhysicalPath(const std::string &virtualPath) const;
    std::vector<std::string> getSearchPaths() const;
    const std::filesystem::path &getDevelopmentRoot() const;
    const std::filesystem::path &getEditorDevelopmentRoot() const;
    const std::string &getActiveWorldId() const;
    AssetScaleTier getAssetScaleTier() const;
    AssetScaleTier getAssetScaleTier(AssetScaleCategory assetScaleCategory) const;
    AssetScaleTier getAssetScaleTierForVirtualPath(const std::string &virtualPath) const;
    const AssetScaleProfile &getAssetScaleProfile() const;
    void shutdown();

private:
    struct SearchMount
    {
        std::filesystem::path root;
        std::string mountPoint;
        bool archive = false;
    };

    bool isInitialized() const;
    bool validateTierDirectories(const std::filesystem::path &assetRoot) const;
    bool validateTierDirectoriesInMountedPackages() const;
    bool isPackagedAssetRoot(const std::filesystem::path &assetRoot) const;
    bool mountDevelopmentPackageRoots(const std::filesystem::path &assetRoot, const std::string &activeWorldId);
    bool mountPackagedAssetRoot(const std::filesystem::path &assetRoot, const std::string &activeWorldId);
    bool mountPackageArchiveIfPresent(const std::filesystem::path &archivePath, bool appendToPath);
    bool mountSearchRoot(const std::filesystem::path &assetRoot, bool appendToPath);
    bool mountSearchRootAt(
        const std::filesystem::path &assetRoot,
        const std::string &mountPoint,
        bool appendToPath
    );
    bool validateMergedIconRoots(const std::filesystem::path &assetRoot) const;
    bool validateMergedAudioRoots(const std::filesystem::path &assetRoot) const;
    bool validateMergedMusicRoots(const std::filesystem::path &assetRoot) const;
    bool validateMergedPackageRoots(
        const std::filesystem::path &assetRoot,
        const char *pPackageDirectoryName,
        const char *pAssetTypeName
    ) const;
    bool mountMergedWorldIconRoots(const std::filesystem::path &assetRoot, const std::string &activeWorldId);
    bool mountMergedWorldAudioRoots(const std::filesystem::path &assetRoot, const std::string &activeWorldId);
    bool mountMergedWorldMusicRoots(const std::filesystem::path &assetRoot, const std::string &activeWorldId);
    bool mountMergedWorldVideoRoots(const std::filesystem::path &assetRoot, const std::string &activeWorldId);
    bool mountMergedWorldMapRuntimeRoots(const std::filesystem::path &assetRoot, const std::string &activeWorldId);
    bool mountMergedWorldScaledPackageRoots(
        const std::filesystem::path &assetRoot,
        const std::string &activeWorldId,
        const char *pPackageDirectoryName,
        AssetScaleTier assetScaleTier
    );
    bool mountMergedWorldPackageRoots(
        const std::filesystem::path &assetRoot,
        const std::string &activeWorldId,
        const char *pPackageDirectoryName
    );
    std::string resolveVirtualPath(const std::string &virtualPath) const;
    std::vector<std::string> resolveVirtualPathCandidates(const std::string &virtualPath) const;
    static std::string normalizeVirtualPath(const std::string &virtualPath);
    static std::string normalizePackageId(const std::string &packageId, const std::string &defaultPackageId);
    static std::vector<std::string> expandPackageAliasCandidates(const std::string &virtualPath);
    static AssetScaleCategory assetScaleCategoryForVirtualPath(const std::string &virtualPath);
    static std::string baseTieredVirtualPath(const std::string &virtualPath);
    static std::string remapTieredVirtualPath(
        const std::string &virtualPath,
        const AssetScaleProfile &assetScaleProfile
    );

    bool m_isInitialized;
    std::filesystem::path m_basePath;
    std::filesystem::path m_developmentRoot;
    std::filesystem::path m_editorDevelopmentRoot;
    std::string m_activeWorldId;
    AssetScaleTier m_assetScaleTier;
    AssetScaleProfile m_assetScaleProfile;
    std::vector<SearchMount> m_searchMounts;
};
}
