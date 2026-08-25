#pragma once

#include <cstddef>
#include <cstdint>
#include <string>
#include <unordered_map>
#include <vector>

namespace OpenYAMM::Engine
{
class AssetFileSystem;
}

namespace OpenYAMM::Game
{
class JournalQuestTable;
class Mm9RudeDialogueTable;
class Party;

enum class Mm9QuestMarkerState : uint8_t
{
    None = 0,
    InProgress,
    Available,
    Ready,
};

struct Mm9QuestActorIdentity
{
    std::string mapId;
    uint32_t sourceObjectIndex = 0;
    uint32_t rudeId = 0;
    bool interactable = true;
};

struct Mm9QuestInteractionBinding
{
    std::string mapId;
    uint32_t sourceObjectIndex = 0;
};

struct Mm9QuestInteraction
{
    std::string id;
    uint32_t rudeId = 0;
    size_t rudeRowIndex = 0;
    bool scrPredicate = false;
    bool offer = false;
    bool handoff = false;
    std::vector<uint32_t> requiredQBits;
    std::vector<uint32_t> forbiddenQBits;
    std::vector<uint32_t> anyRequiredQBits;
    int minimumGold = 0;
    std::vector<uint32_t> activatedJournalEntries;
    std::vector<uint32_t> completedJournalEntries;
    std::vector<Mm9QuestInteractionBinding> bindings;
};

class Mm9QuestInteractionTable
{
  public:
    bool load(const Engine::AssetFileSystem &assetFileSystem);
    bool loadText(const std::string &sourceName, const std::string &text);
    void clear();

    const std::vector<Mm9QuestInteraction> &interactions() const;
    const std::vector<std::string> &errors() const;

  private:
    std::vector<Mm9QuestInteraction> m_interactions;
    std::vector<std::string> m_errors;
};

class Mm9QuestMarkerResolver
{
  public:
    Mm9QuestMarkerState markerFor(const Mm9QuestActorIdentity &actor, const Party &party,
                                  const JournalQuestTable &journalQuestTable,
                                  const Mm9RudeDialogueTable &rudeDialogueTable,
                                  const Mm9QuestInteractionTable &interactionTable) const;
};

struct Mm9QuestEligibilityStamp
{
    uint64_t partyRevision = 0;
    uint64_t mapRevision = 0;

    bool operator==(const Mm9QuestEligibilityStamp &) const = default;
};

struct Mm9LoadedQuestMarkerActor
{
    uint32_t actorId = 0;
    Mm9QuestActorIdentity identity;
};

class Mm9LoadedLocationQuestMarkerCache
{
  public:
    void loadLocation(bool mm9Active, const std::vector<Mm9LoadedQuestMarkerActor> &actors,
                      Mm9QuestEligibilityStamp stamp, const Party &party, const JournalQuestTable &journalQuestTable,
                      const Mm9RudeDialogueTable &rudeDialogueTable, const Mm9QuestInteractionTable &interactionTable);
    bool update(const std::vector<Mm9LoadedQuestMarkerActor> &actors, Mm9QuestEligibilityStamp stamp,
                const Party &party, const JournalQuestTable &journalQuestTable,
                const Mm9RudeDialogueTable &rudeDialogueTable, const Mm9QuestInteractionTable &interactionTable);
    void clear();

    Mm9QuestMarkerState markerForActor(uint32_t actorId) const;
    bool active() const;
    uint64_t rebuildCount() const;

  private:
    void rebuild(const std::vector<Mm9LoadedQuestMarkerActor> &actors, const Party &party,
                 const JournalQuestTable &journalQuestTable, const Mm9RudeDialogueTable &rudeDialogueTable,
                 const Mm9QuestInteractionTable &interactionTable);

    bool m_active = false;
    Mm9QuestEligibilityStamp m_evaluatedStamp;
    std::unordered_map<uint32_t, Mm9QuestMarkerState> m_markers;
    uint64_t m_rebuildCount = 0;
};
} // namespace OpenYAMM::Game
