#include "doctest/doctest.h"

#include "game/maps/MapRegistry.h"
#include "game/mm9/Mm9MapTransition.h"
#include "game/mm9/Mm9PositionedTransitionRuntime.h"

#include <string>
#include <vector>

namespace
{
std::vector<std::string> header()
{
    return {
        "CanonicalId", "SourceMap", "SourceMapFile", "SourceObjectIndex", "SourceName", "SourceClass",
        "CenterX", "CenterY", "CenterZ", "HalfExtentX", "HalfExtentY", "HalfExtentZ", "DestinationMap",
        "DestinationMapFile", "SourceStartPoint", "ResolvedStartPoint", "ArrivalX", "ArrivalY", "ArrivalZ",
        "FacingDegrees", "FacingYawUnits", "MovePlayerToFloor", "AskPlayer", "TravelDays",
        "TravelDaysSentinel", "LoadScreen", "SourceDat", "OverrideId", "Provenance",
    };
}

std::vector<std::string> row()
{
    return {
        "mm9:transition/source/7", "world.mm9.map.source", "source.odm", "7", "Exit0", "ExitTrigger",
        "100", "200", "300", "10", "20", "30", "world.mm9.map.target", "target.odm", "SourceTypo",
        "Arrival", "400", "500", "600", "180", "1024", "1", "1", "-1", "source_default",
        "loadscreen.pcx", "WORLDS/SOURCE.dat", "mm9:transition_override/source/7", "dat+reviewed_override",
    };
}

OpenYAMM::Game::MapRegistry mapRegistry()
{
    OpenYAMM::Game::MapStatsEntry source = {};
    source.id = 1;
    source.worldId = "mm9";
    source.canonicalId = "world.mm9.map.source";
    source.fileName = "source.odm";
    OpenYAMM::Game::MapStatsEntry target = {};
    target.id = 2;
    target.worldId = "mm9";
    target.canonicalId = "world.mm9.map.target";
    target.fileName = "target.odm";
    OpenYAMM::Game::MapRegistry result;
    result.initialize({source, target});
    return result;
}
}

TEST_CASE("MM9 positioned transition table parses resolved source records")
{
    OpenYAMM::Game::Mm9MapTransitionTable table;
    REQUIRE(table.loadFromRows({header(), row()}, mapRegistry()));
    CHECK(table.errors().empty());
    REQUIRE_EQ(table.entries().size(), 1);

    const OpenYAMM::Game::Mm9MapTransition *pEntry =
        table.findByCanonicalId("MM9:TRANSITION/SOURCE/7");
    REQUIRE(pEntry != nullptr);
    CHECK_EQ(pEntry->sourceObjectIndex, 7);
    CHECK_EQ(pEntry->travelDays, -1);
    CHECK(pEntry->sourceDefaultTravelDays);
    CHECK(pEntry->askPlayer);
    CHECK_EQ(pEntry->destinationMapFileName, "target.odm");
    CHECK_EQ(table.forSourceMapFile("SOURCE.ODM").size(), 1);
}

TEST_CASE("MM9 positioned transition table rejects duplicate source ownership")
{
    std::vector<std::string> duplicate = row();
    duplicate[0] = "mm9:transition/source/duplicate";
    OpenYAMM::Game::Mm9MapTransitionTable table;

    CHECK_FALSE(table.loadFromRows({header(), row(), duplicate}, mapRegistry()));
    REQUIRE_EQ(table.errors().size(), 1);
    CHECK(table.errors().front().find("duplicate source object ownership") != std::string::npos);
}

TEST_CASE("MM9 positioned transition table rejects unresolved canonical maps")
{
    std::vector<std::string> unresolved = row();
    unresolved[12] = "world.mm9.map.missing";
    unresolved[13] = "missing.odm";
    OpenYAMM::Game::Mm9MapTransitionTable table;

    CHECK_FALSE(table.loadFromRows({header(), unresolved}, mapRegistry()));
    REQUIRE_EQ(table.errors().size(), 1);
    CHECK(table.errors().front().find("map reference is unresolved") != std::string::npos);
}

TEST_CASE("MM9 positioned transition runtime triggers only on a fresh volume entry")
{
    OpenYAMM::Game::Mm9MapTransitionTable table;
    REQUIRE(table.loadFromRows({header(), row()}, mapRegistry()));
    OpenYAMM::Game::Mm9PositionedTransitionRuntime runtime;
    runtime.configure(table.forSourceMapFile("source.odm"));
    OpenYAMM::Game::EventRuntimeState eventRuntimeState = {};

    CHECK_FALSE(runtime.update(0.0f, 0.0f, 0.0f, eventRuntimeState).has_value());
    const std::optional<OpenYAMM::Game::Mm9PositionedTransitionActivation> activation =
        runtime.update(100.0f, 200.0f, 300.0f, eventRuntimeState);
    REQUIRE(activation.has_value());
    CHECK_EQ(activation->pTransition->sourceObjectIndex, 7);
    REQUIRE(eventRuntimeState.pendingDialogueContext.has_value());
    REQUIRE(eventRuntimeState.pendingDialogueContext->transitionMapMove.has_value());
    CHECK(eventRuntimeState.pendingDialogueContext->transitionMapMove->mapName == "target.odm");
    CHECK_EQ(eventRuntimeState.pendingDialogueContext->transitionMapMove->x, 400);
    REQUIRE(eventRuntimeState.lastMapTransitionRequested.has_value());
    CHECK(eventRuntimeState.lastMapTransitionRequested->sourceKind == "mm9_exit_trigger");

    eventRuntimeState.pendingDialogueContext.reset();
    CHECK_FALSE(runtime.update(100.0f, 200.0f, 300.0f, eventRuntimeState).has_value());
    CHECK_FALSE(runtime.update(0.0f, 0.0f, 0.0f, eventRuntimeState).has_value());
    CHECK(runtime.update(100.0f, 200.0f, 300.0f, eventRuntimeState).has_value());
}

TEST_CASE("MM9 positioned transition runtime initializes safely inside and queues automatic moves")
{
    std::vector<std::string> automatic = row();
    automatic[22] = "0";
    automatic[23] = "6";
    automatic[24] = "";
    OpenYAMM::Game::Mm9MapTransitionTable table;
    REQUIRE(table.loadFromRows({header(), automatic}, mapRegistry()));
    OpenYAMM::Game::Mm9PositionedTransitionRuntime runtime;
    runtime.configure(table.forSourceMapFile("source.odm"));
    OpenYAMM::Game::EventRuntimeState eventRuntimeState = {};

    CHECK_FALSE(runtime.update(100.0f, 200.0f, 300.0f, eventRuntimeState).has_value());
    CHECK_FALSE(eventRuntimeState.pendingMapMove.has_value());
    CHECK_FALSE(runtime.update(0.0f, 0.0f, 0.0f, eventRuntimeState).has_value());
    REQUIRE(runtime.update(100.0f, 200.0f, 300.0f, eventRuntimeState).has_value());
    REQUIRE(eventRuntimeState.pendingMapMove.has_value());
    CHECK(eventRuntimeState.pendingMapMove->mapName == "target.odm");
    REQUIRE(eventRuntimeState.lastMapTransitionRequested.has_value());
    CHECK_EQ(eventRuntimeState.lastMapTransitionRequested->travelDays, 6);
    CHECK_FALSE(eventRuntimeState.lastMapTransitionRequested->confirmationRequired);
}
