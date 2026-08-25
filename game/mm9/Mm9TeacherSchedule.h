#pragma once

#include <cstddef>
#include <cstdint>
#include <optional>
#include <string>
#include <unordered_map>
#include <vector>

namespace OpenYAMM::Game
{
class IGameplayWorldRuntime;
class ISceneEventContext;
class MapRegistry;

enum class Mm9TeacherScheduleDestination
{
    Work,
    Misc,
    Home,
};

struct Mm9TeacherSchedulePosition
{
    int x = 0;
    int y = 0;
    int z = 0;
};

struct Mm9TeacherScheduleEntry
{
    std::string canonicalId;
    std::string sourceMapCanonicalId;
    std::string sourceMapFileName;
    uint32_t rudeId = 0;
    uint32_t sourceObjectIndex = 0;
    uint8_t groupIndex = 0;
    int workMinute = 0;
    int miscMinute = 0;
    int returnWorkMinute = 0;
    int homeMinute = 0;
    Mm9TeacherSchedulePosition work;
    Mm9TeacherSchedulePosition misc;
    Mm9TeacherSchedulePosition home;
    std::string sourceScript;
    std::string overrideId;
    std::string reviewState;
    std::string provenance;
};

class Mm9TeacherScheduleTable
{
public:
    void clear();
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows, const MapRegistry &mapRegistry);
    std::vector<const Mm9TeacherScheduleEntry *> forSourceMapFile(const std::string &sourceMapFileName) const;
    const std::vector<Mm9TeacherScheduleEntry> &entries() const;
    const std::vector<std::string> &errors() const;

private:
    void addError(size_t rowNumber, const std::string &message);

    std::vector<Mm9TeacherScheduleEntry> m_entries;
    std::unordered_map<std::string, std::vector<size_t>> m_entryIndicesBySourceMapFile;
    std::vector<std::string> m_errors;
};

struct Mm9TeacherScheduleActivation
{
    const Mm9TeacherScheduleEntry *pEntry = nullptr;
    Mm9TeacherScheduleDestination destination = Mm9TeacherScheduleDestination::Home;
    Mm9TeacherSchedulePosition position;
};

Mm9TeacherScheduleDestination mm9TeacherScheduleDestinationAt(
    const Mm9TeacherScheduleEntry &entry,
    double gameMinutes);

class Mm9TeacherScheduleRuntime
{
public:
    void configure(const std::vector<const Mm9TeacherScheduleEntry *> &entries);
    void reset();
    std::vector<Mm9TeacherScheduleActivation> update(double gameMinutes);

private:
    std::vector<const Mm9TeacherScheduleEntry *> m_entries;
    std::vector<std::optional<Mm9TeacherScheduleDestination>> m_destinations;
};

bool applyMm9TeacherScheduleActivations(
    const std::vector<Mm9TeacherScheduleActivation> &activations,
    IGameplayWorldRuntime &actorRuntime,
    ISceneEventContext &sceneEventContext);
}
