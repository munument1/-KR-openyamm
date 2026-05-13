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

TEST_CASE("legacy lua exporter separates timer continuation from direct event body")
{
    const std::filesystem::path sourceRoot = OPENYAMM_SOURCE_DIR;
    const std::vector<uint8_t> evtBytes =
        readBinaryFixture(sourceRoot / "assets_dev/worlds/mm7/_legacy/events/7d35.EVT");
    const std::vector<uint8_t> strBytes =
        readBinaryFixture(sourceRoot / "assets_dev/worlds/mm7/_legacy/events/7d35.STR");

    OpenYAMM::Game::EvtProgram evtProgram = {};
    REQUIRE(evtProgram.loadFromBytes(evtBytes));

    OpenYAMM::Game::StrTable strTable = {};
    REQUIRE(strTable.loadFromBytes(strBytes));

    OpenYAMM::Game::LegacyLuaExportLookups lookups = {};
    lookups.mapName = "Nighon Tunnels";

    const std::string lua = OpenYAMM::Game::generateLegacyEventLuaChunk(
        evtProgram,
        strTable,
        lookups,
        OpenYAMM::Game::LegacyLuaExportScope::Map,
        OpenYAMM::Game::LegacyEventVersion::Mm7);

    const size_t timerLineMatch = lua.find("intervalGameMinutes = 2.5");
    REQUIRE(timerLineMatch != std::string::npos);
    const size_t timerLineStart = lua.rfind('{', timerLineMatch);
    const size_t timerLineEnd = lua.find('\n', timerLineMatch);
    REQUIRE(timerLineStart != std::string::npos);
    REQUIRE(timerLineEnd != std::string::npos);
    const std::string timerLine = lua.substr(timerLineStart, timerLineEnd - timerLineStart);
    INFO(timerLine);
    CHECK(timerLine.find("eventId = 452") == std::string::npos);

    const size_t timerEventIdStart = timerLine.find("eventId = ");
    REQUIRE(timerEventIdStart != std::string::npos);
    const size_t timerEventIdValueStart = timerEventIdStart + std::string("eventId = ").size();
    const size_t timerEventIdValueEnd = timerLine.find(',', timerEventIdValueStart);
    REQUIRE(timerEventIdValueEnd != std::string::npos);
    const std::string timerEventIdText =
        timerLine.substr(timerEventIdValueStart, timerEventIdValueEnd - timerEventIdValueStart);

    const size_t directEventStart = lua.find("RegisterEvent(452");
    REQUIRE(directEventStart != std::string::npos);
    const size_t directEventEnd = lua.find("RegisterEvent(454", directEventStart);
    REQUIRE(directEventEnd != std::string::npos);
    const std::string directEventLua = lua.substr(directEventStart, directEventEnd - directEventStart);
    INFO(directEventLua);
    CHECK(directEventLua.find("evt.MoveToMap(1232, 6896, -384") != std::string::npos);
    CHECK(directEventLua.find("evt.CastSpell(6") == std::string::npos);

    const std::string syntheticRegistration = "RegisterEvent(" + timerEventIdText;
    const size_t timerEventStart = lua.find(syntheticRegistration);
    REQUIRE(timerEventStart != std::string::npos);
    const size_t timerEventEnd = lua.find("\n\n", timerEventStart);
    REQUIRE(timerEventEnd != std::string::npos);
    const std::string timerEventLua = lua.substr(timerEventStart, timerEventEnd - timerEventStart);
    INFO(timerEventLua);
    CHECK(timerEventLua.find("evt.MoveToMap(1232, 6896, -384") == std::string::npos);
    CHECK(timerEventLua.find("evt.CastSpell(6, 7, 4, 13891") != std::string::npos);
    CHECK(timerEventLua.find("evt.CastSpell(6, 7, 4, 14618") != std::string::npos);
}

TEST_CASE("legacy lua exporter prefers house names over stale mouseover hints for house events")
{
    const std::filesystem::path sourceRoot = OPENYAMM_SOURCE_DIR;
    const std::vector<uint8_t> evtBytes =
        readBinaryFixture(sourceRoot / "assets_dev/worlds/mm6/_legacy/events/OUTB2.EVT");
    const std::vector<uint8_t> strBytes =
        readBinaryFixture(sourceRoot / "assets_dev/worlds/mm6/_legacy/events/OUTB2.STR");

    OpenYAMM::Game::EvtProgram evtProgram = {};
    REQUIRE(evtProgram.loadFromBytes(evtBytes));

    OpenYAMM::Game::StrTable strTable = {};
    REQUIRE(strTable.loadFromBytes(strBytes));

    OpenYAMM::Game::LegacyLuaExportLookups lookups = {};
    lookups.mapName = "Blackshire";
    lookups.houseNames[34] = "Stout Heart Staff and Spear";

    const std::string lua = OpenYAMM::Game::generateLegacyEventLuaChunk(
        evtProgram,
        strTable,
        lookups,
        OpenYAMM::Game::LegacyLuaExportScope::Map,
        OpenYAMM::Game::LegacyEventVersion::Mm6);

    const size_t eventStart = lua.find("RegisterEvent(2");
    REQUIRE(eventStart != std::string::npos);
    const size_t eventEnd = lua.find("RegisterEvent(3", eventStart);
    REQUIRE(eventEnd != std::string::npos);
    const std::string eventLua = lua.substr(eventStart, eventEnd - eventStart);
    INFO(eventLua);

    CHECK(eventLua.find("RegisterEvent(2, \"Stout Heart Staff and Spear\"") != std::string::npos);
    CHECK(eventLua.find("end, \"Stout Heart Staff and Spear\")") != std::string::npos);
    CHECK(eventLua.find("You pray at the shrine") == std::string::npos);
}
