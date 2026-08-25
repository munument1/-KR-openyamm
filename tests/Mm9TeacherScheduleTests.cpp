#include "game/mm9/Mm9TeacherSchedule.h"

#include "game/maps/MapRegistry.h"

#include <doctest/doctest.h>

using namespace OpenYAMM::Game;

namespace
{
std::vector<std::string> scheduleRow()
{
    return {
        "mm9:teacher_schedule/yorwick/412", "mm9:map/yorwick", "yorwick.odm", "412", "77", "1",
        "375", "780", "900", "1080", "10", "20", "30", "40", "50", "60", "70", "80", "90",
        "MM_YORWICK.scr", "", "source_dat", "MM_YORWICK.scr + yorwick.dat",
    };
}

MapRegistry testMapRegistry()
{
    MapRegistry registry;
    MapStatsEntry map = {};
    map.canonicalId = "mm9:map/yorwick";
    map.fileName = "yorwick.odm";
    registry.initialize({map});
    return registry;
}
}

TEST_CASE("MM9 teacher schedule table validates identity and source actor ownership")
{
    Mm9TeacherScheduleTable table;
    std::vector<std::string> header(23, "Header");
    header[0] = "CanonicalId";
    CHECK(table.loadFromRows({header, scheduleRow()}, testMapRegistry()));
    REQUIRE(table.entries().size() == 1);
    CHECK(table.entries()[0].rudeId == 412);
    CHECK(table.forSourceMapFile("YORWICK.ODM").size() == 1);

    std::vector<std::string> duplicateOwner = scheduleRow();
    duplicateOwner[0] = "mm9:teacher_schedule/yorwick/duplicate";
    CHECK_FALSE(table.loadFromRows({header, scheduleRow(), duplicateOwner}, testMapRegistry()));
    CHECK(table.errors().size() == 1);
    CHECK(table.errors()[0].find("duplicate scheduled actor ownership") != std::string::npos);
}

TEST_CASE("MM9 teacher schedule selects source-defined daily destinations")
{
    Mm9TeacherScheduleEntry entry = {};
    entry.workMinute = 375;
    entry.miscMinute = 780;
    entry.returnWorkMinute = 900;
    entry.homeMinute = 1080;

    CHECK(mm9TeacherScheduleDestinationAt(entry, 374) == Mm9TeacherScheduleDestination::Home);
    CHECK(mm9TeacherScheduleDestinationAt(entry, 375) == Mm9TeacherScheduleDestination::Work);
    CHECK(mm9TeacherScheduleDestinationAt(entry, 780) == Mm9TeacherScheduleDestination::Misc);
    CHECK(mm9TeacherScheduleDestinationAt(entry, 900) == Mm9TeacherScheduleDestination::Work);
    CHECK(mm9TeacherScheduleDestinationAt(entry, 1080) == Mm9TeacherScheduleDestination::Home);
    CHECK(mm9TeacherScheduleDestinationAt(entry, 1440 + 375) == Mm9TeacherScheduleDestination::Work);
}

TEST_CASE("MM9 teacher schedule runtime is transient and deterministic across reconstruction")
{
    Mm9TeacherScheduleEntry entry = {};
    entry.workMinute = 375;
    entry.miscMinute = 780;
    entry.returnWorkMinute = 900;
    entry.homeMinute = 1080;
    entry.home = {70, 80, 90};

    Mm9TeacherScheduleRuntime first;
    first.configure({&entry});
    const std::vector<Mm9TeacherScheduleActivation> firstActivation = first.update(1200);
    REQUIRE(firstActivation.size() == 1);
    CHECK(firstActivation[0].destination == Mm9TeacherScheduleDestination::Home);
    CHECK(firstActivation[0].position.x == 70);
    CHECK(first.update(1200).empty());

    Mm9TeacherScheduleRuntime reconstructed;
    reconstructed.configure({&entry});
    const std::vector<Mm9TeacherScheduleActivation> reconstructedActivation = reconstructed.update(1200);
    REQUIRE(reconstructedActivation.size() == 1);
    CHECK(reconstructedActivation[0].destination == Mm9TeacherScheduleDestination::Home);
    CHECK(reconstructedActivation[0].position.x == 70);
}
