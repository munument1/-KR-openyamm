#pragma once

#include <cstddef>
#include <cstdint>
#include <string>
#include <unordered_map>
#include <vector>

namespace OpenYAMM::Game
{
class MapRegistry;

struct Mm9MapTransition
{
    std::string canonicalId;
    std::string sourceMapCanonicalId;
    std::string sourceMapFileName;
    uint32_t sourceObjectIndex = 0;
    std::string sourceName;
    int centerX = 0;
    int centerY = 0;
    int centerZ = 0;
    int halfExtentX = 0;
    int halfExtentY = 0;
    int halfExtentZ = 0;
    std::string destinationMapCanonicalId;
    std::string destinationMapFileName;
    std::string sourceStartPointName;
    std::string resolvedStartPointName;
    int arrivalX = 0;
    int arrivalY = 0;
    int arrivalZ = 0;
    double facingDegrees = 0.0;
    uint16_t facingYawUnits = 0;
    bool movePlayerToFloor = false;
    bool askPlayer = false;
    int travelDays = 0;
    bool sourceDefaultTravelDays = false;
    std::string loadScreen;
    std::string sourceDat;
    std::string overrideId;
    std::string provenance;
};

class Mm9MapTransitionTable
{
public:
    void clear();
    bool loadFromRows(const std::vector<std::vector<std::string>> &rows, const MapRegistry &mapRegistry);
    const Mm9MapTransition *findByCanonicalId(const std::string &canonicalId) const;
    std::vector<const Mm9MapTransition *> forSourceMapFile(const std::string &sourceMapFileName) const;
    const std::vector<Mm9MapTransition> &entries() const;
    const std::vector<std::string> &errors() const;

private:
    void addError(size_t rowNumber, const std::string &message);

    std::vector<Mm9MapTransition> m_entries;
    std::unordered_map<std::string, size_t> m_entryIndexByCanonicalId;
    std::unordered_map<std::string, std::vector<size_t>> m_entryIndicesBySourceMapFile;
    std::vector<std::string> m_errors;
};
}
