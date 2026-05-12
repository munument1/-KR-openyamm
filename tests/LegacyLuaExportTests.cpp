#include "doctest/doctest.h"

#include "tools/LegacyLuaExport.h"

#include <cstdint>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <string>
#include <vector>

namespace
{
std::vector<uint8_t> readBinaryFixture(const std::filesystem::path &path)
{
    std::ifstream stream(path, std::ios::binary);
    REQUIRE_MESSAGE(stream.good(), path.string().c_str());
    return std::vector<uint8_t>(
        std::istreambuf_iterator<char>(stream),
        std::istreambuf_iterator<char>());
}
}

TEST_CASE("legacy lua exporter preserves return for castle gloaming soul jar chest")
{
    const std::filesystem::path sourceRoot = OPENYAMM_SOURCE_DIR;
    const std::vector<uint8_t> evtBytes =
        readBinaryFixture(sourceRoot / "assets_dev/worlds/mm7/_legacy/events/d03.EVT");
    const std::vector<uint8_t> strBytes =
        readBinaryFixture(sourceRoot / "assets_dev/worlds/mm7/_legacy/events/d03.STR");

    OpenYAMM::Game::EvtProgram evtProgram = {};
    REQUIRE(evtProgram.loadFromBytes(evtBytes));

    OpenYAMM::Game::StrTable strTable = {};
    REQUIRE(strTable.loadFromBytes(strBytes));

    OpenYAMM::Game::LegacyLuaExportLookups lookups = {};
    lookups.mapName = "Castle Gloaming";

    const std::string lua = OpenYAMM::Game::generateLegacyEventLuaChunk(
        evtProgram,
        strTable,
        lookups,
        OpenYAMM::Game::LegacyLuaExportScope::Map,
        OpenYAMM::Game::LegacyEventVersion::Mm7);

    const size_t eventStart = lua.find("RegisterEvent(176");
    REQUIRE(eventStart != std::string::npos);
    const size_t eventEnd = lua.find("RegisterEvent(177", eventStart);
    REQUIRE(eventEnd != std::string::npos);
    const std::string eventLua = lua.substr(eventStart, eventEnd - eventStart);
    INFO(eventLua);

    const size_t chest0 = eventLua.find("evt.OpenChest(0)");
    const size_t qbit743 = eventLua.find("SetQBit(QBit(743))", chest0);
    const size_t qbit662 = eventLua.find("SetQBit(QBit(662))", qbit743);
    const size_t branchReturn = eventLua.find("return", qbit662);
    const size_t laterChest1 = eventLua.find("evt.OpenChest(1)", qbit662);

    REQUIRE(chest0 != std::string::npos);
    REQUIRE(qbit743 != std::string::npos);
    REQUIRE(qbit662 != std::string::npos);
    REQUIRE(branchReturn != std::string::npos);
    REQUIRE(laterChest1 != std::string::npos);
    CHECK(chest0 < qbit743);
    CHECK(qbit743 < qbit662);
    CHECK(qbit662 < branchReturn);
    CHECK(branchReturn < laterChest1);
}
