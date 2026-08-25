#include "game/mm9/Mm9TeacherSchedule.h"

#include "game/events/ISceneEventContext.h"
#include "game/gameplay/GameplayRuntimeInterfaces.h"
#include "game/maps/MapRegistry.h"

#include <algorithm>
#include <cctype>
#include <cmath>
#include <limits>
#include <optional>
#include <unordered_set>

namespace OpenYAMM::Game
{
namespace
{
constexpr size_t ExpectedColumnCount = 23;
constexpr double MinutesPerDay = 1440.0;

std::string lowerCopy(const std::string &value)
{
    std::string result = value;
    for (char &character : result)
    {
        character = static_cast<char>(std::tolower(static_cast<unsigned char>(character)));
    }
    return result;
}

bool parseInteger(const std::string &value, int &result)
{
    try
    {
        size_t consumed = 0;
        const long parsed = std::stol(value, &consumed);
        if (consumed != value.size() || parsed < std::numeric_limits<int>::min()
            || parsed > std::numeric_limits<int>::max())
        {
            return false;
        }
        result = static_cast<int>(parsed);
        return true;
    }
    catch (...)
    {
        return false;
    }
}

bool mapReferenceMatches(
    const MapRegistry &mapRegistry,
    const std::string &canonicalId,
    const std::string &fileName)
{
    const std::optional<MapStatsEntry> byCanonicalId = mapRegistry.findByCanonicalId(canonicalId);
    const std::optional<MapStatsEntry> byFileName = mapRegistry.findByFileName(fileName);
    return byCanonicalId.has_value() && byFileName.has_value()
        && lowerCopy(byCanonicalId->fileName) == lowerCopy(fileName)
        && lowerCopy(byFileName->canonicalId) == lowerCopy(canonicalId);
}

Mm9TeacherSchedulePosition positionFor(
    const Mm9TeacherScheduleEntry &entry,
    Mm9TeacherScheduleDestination destination)
{
    switch (destination)
    {
        case Mm9TeacherScheduleDestination::Work:
            return entry.work;
        case Mm9TeacherScheduleDestination::Misc:
            return entry.misc;
        case Mm9TeacherScheduleDestination::Home:
            return entry.home;
    }
    return entry.home;
}
}

void Mm9TeacherScheduleTable::clear()
{
    m_entries.clear();
    m_entryIndicesBySourceMapFile.clear();
    m_errors.clear();
}

bool Mm9TeacherScheduleTable::loadFromRows(
    const std::vector<std::vector<std::string>> &rows,
    const MapRegistry &mapRegistry)
{
    clear();
    std::unordered_set<std::string> canonicalIds;
    std::unordered_set<std::string> sourceObjectOwners;
    std::unordered_set<std::string> rudeOwners;

    for (size_t rowIndex = 0; rowIndex < rows.size(); ++rowIndex)
    {
        const std::vector<std::string> &row = rows[rowIndex];
        if (row.empty() || row[0].empty() || row[0] == "CanonicalId")
        {
            continue;
        }
        const size_t rowNumber = rowIndex + 1;
        if (row.size() < ExpectedColumnCount)
        {
            addError(rowNumber, "expected 23 columns");
            continue;
        }

        Mm9TeacherScheduleEntry entry = {};
        entry.canonicalId = row[0];
        entry.sourceMapCanonicalId = row[1];
        entry.sourceMapFileName = row[2];
        entry.sourceScript = row[19];
        entry.overrideId = row[20];
        entry.reviewState = row[21];
        entry.provenance = row[22];

        int rudeId = 0;
        int sourceObjectIndex = 0;
        int groupIndex = 0;
        const bool valid = parseInteger(row[3], rudeId)
            && parseInteger(row[4], sourceObjectIndex)
            && parseInteger(row[5], groupIndex)
            && parseInteger(row[6], entry.workMinute)
            && parseInteger(row[7], entry.miscMinute)
            && parseInteger(row[8], entry.returnWorkMinute)
            && parseInteger(row[9], entry.homeMinute)
            && parseInteger(row[10], entry.work.x)
            && parseInteger(row[11], entry.work.y)
            && parseInteger(row[12], entry.work.z)
            && parseInteger(row[13], entry.misc.x)
            && parseInteger(row[14], entry.misc.y)
            && parseInteger(row[15], entry.misc.z)
            && parseInteger(row[16], entry.home.x)
            && parseInteger(row[17], entry.home.y)
            && parseInteger(row[18], entry.home.z);
        if (!valid || rudeId <= 0 || sourceObjectIndex < 0 || groupIndex < 1 || groupIndex > 4)
        {
            addError(rowNumber, "invalid numeric field or schedule group");
            continue;
        }
        entry.rudeId = static_cast<uint32_t>(rudeId);
        entry.sourceObjectIndex = static_cast<uint32_t>(sourceObjectIndex);
        entry.groupIndex = static_cast<uint8_t>(groupIndex);

        if (!entry.canonicalId.starts_with("mm9:teacher_schedule/")
            || entry.sourceScript.empty() || entry.provenance.empty())
        {
            addError(rowNumber, "invalid schedule identity or provenance");
            continue;
        }
        if (entry.workMinute < 0 || entry.workMinute >= entry.miscMinute
            || entry.miscMinute >= entry.returnWorkMinute
            || entry.returnWorkMinute >= entry.homeMinute || entry.homeMinute >= MinutesPerDay)
        {
            addError(rowNumber, "schedule minutes must be ordered within one day");
            continue;
        }
        if ((entry.reviewState != "source_dat" && entry.reviewState != "reviewed_override")
            || (entry.reviewState == "reviewed_override" && entry.overrideId.empty()))
        {
            addError(rowNumber, "invalid review state or missing override id");
            continue;
        }
        if (!mapReferenceMatches(mapRegistry, entry.sourceMapCanonicalId, entry.sourceMapFileName))
        {
            addError(rowNumber, "source map reference is unresolved or inconsistent");
            continue;
        }

        const std::string normalizedId = lowerCopy(entry.canonicalId);
        const std::string normalizedSourceMap = lowerCopy(entry.sourceMapCanonicalId);
        const std::string sourceObjectOwner = normalizedSourceMap + "#" + std::to_string(entry.sourceObjectIndex);
        const std::string rudeOwner = normalizedSourceMap + "#" + std::to_string(entry.rudeId);
        if (!canonicalIds.insert(normalizedId).second)
        {
            addError(rowNumber, "duplicate canonical schedule id");
            continue;
        }
        if (!sourceObjectOwners.insert(sourceObjectOwner).second || !rudeOwners.insert(rudeOwner).second)
        {
            addError(rowNumber, "duplicate scheduled actor ownership");
            continue;
        }

        const size_t entryIndex = m_entries.size();
        m_entries.push_back(std::move(entry));
        m_entryIndicesBySourceMapFile[lowerCopy(m_entries.back().sourceMapFileName)].push_back(entryIndex);
    }

    return m_errors.empty();
}

std::vector<const Mm9TeacherScheduleEntry *> Mm9TeacherScheduleTable::forSourceMapFile(
    const std::string &sourceMapFileName) const
{
    std::vector<const Mm9TeacherScheduleEntry *> result;
    const auto iterator = m_entryIndicesBySourceMapFile.find(lowerCopy(sourceMapFileName));
    if (iterator == m_entryIndicesBySourceMapFile.end())
    {
        return result;
    }
    result.reserve(iterator->second.size());
    for (size_t entryIndex : iterator->second)
    {
        result.push_back(&m_entries[entryIndex]);
    }
    return result;
}

const std::vector<Mm9TeacherScheduleEntry> &Mm9TeacherScheduleTable::entries() const
{
    return m_entries;
}

const std::vector<std::string> &Mm9TeacherScheduleTable::errors() const
{
    return m_errors;
}

void Mm9TeacherScheduleTable::addError(size_t rowNumber, const std::string &message)
{
    m_errors.push_back("row " + std::to_string(rowNumber) + ": " + message);
}

Mm9TeacherScheduleDestination mm9TeacherScheduleDestinationAt(
    const Mm9TeacherScheduleEntry &entry,
    double gameMinutes)
{
    double minuteOfDay = std::fmod(gameMinutes, MinutesPerDay);
    if (minuteOfDay < 0.0)
    {
        minuteOfDay += MinutesPerDay;
    }
    if (minuteOfDay < entry.workMinute || minuteOfDay >= entry.homeMinute)
    {
        return Mm9TeacherScheduleDestination::Home;
    }
    if (minuteOfDay < entry.miscMinute || minuteOfDay >= entry.returnWorkMinute)
    {
        return Mm9TeacherScheduleDestination::Work;
    }
    return Mm9TeacherScheduleDestination::Misc;
}

void Mm9TeacherScheduleRuntime::configure(const std::vector<const Mm9TeacherScheduleEntry *> &entries)
{
    m_entries = entries;
    m_destinations.assign(entries.size(), std::nullopt);
}

void Mm9TeacherScheduleRuntime::reset()
{
    m_destinations.assign(m_entries.size(), std::nullopt);
}

std::vector<Mm9TeacherScheduleActivation> Mm9TeacherScheduleRuntime::update(double gameMinutes)
{
    std::vector<Mm9TeacherScheduleActivation> activations;
    for (size_t entryIndex = 0; entryIndex < m_entries.size(); ++entryIndex)
    {
        const Mm9TeacherScheduleEntry *pEntry = m_entries[entryIndex];
        if (pEntry == nullptr)
        {
            continue;
        }
        const Mm9TeacherScheduleDestination destination =
            mm9TeacherScheduleDestinationAt(*pEntry, gameMinutes);
        if (m_destinations[entryIndex] == destination)
        {
            continue;
        }
        m_destinations[entryIndex] = destination;
        activations.push_back(Mm9TeacherScheduleActivation{
            .pEntry = pEntry,
            .destination = destination,
            .position = positionFor(*pEntry, destination),
        });
    }
    return activations;
}

bool applyMm9TeacherScheduleActivations(
    const std::vector<Mm9TeacherScheduleActivation> &activations,
    IGameplayWorldRuntime &actorRuntime,
    ISceneEventContext &sceneEventContext)
{
    bool changed = false;
    for (const Mm9TeacherScheduleActivation &activation : activations)
    {
        if (activation.pEntry == nullptr)
        {
            continue;
        }
        for (size_t actorIndex = 0; actorIndex < actorRuntime.mapActorCount(); ++actorIndex)
        {
            GameplayRuntimeActorState state = {};
            if (!actorRuntime.actorRuntimeState(actorIndex, state)
                || state.mm9RudeId != activation.pEntry->rudeId
                || state.mm9SourceObjectIndex != activation.pEntry->sourceObjectIndex)
            {
                continue;
            }
            changed = sceneEventContext.setMapActorPosition(
                actorIndex,
                static_cast<float>(activation.position.x),
                static_cast<float>(activation.position.y),
                static_cast<float>(activation.position.z)) || changed;
            break;
        }
    }
    return changed;
}
}
