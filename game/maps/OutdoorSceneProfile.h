#pragma once

namespace OpenYAMM::Game
{
enum class OutdoorSceneProfile
{
    ClassicOdm,
    BModelWorld
};

enum class OutdoorLocationType
{
    Exterior,
    Enclosed
};

constexpr bool outdoorLocationUsesIndoorGameplay(OutdoorLocationType locationType)
{
    return locationType == OutdoorLocationType::Enclosed;
}

constexpr const char *outdoorSceneProfileName(OutdoorSceneProfile profile)
{
    switch (profile)
    {
    case OutdoorSceneProfile::BModelWorld:
        return "bmodel_world";

    case OutdoorSceneProfile::ClassicOdm:
    default:
        return "classic_odm";
    }
}

constexpr const char *outdoorLocationTypeName(OutdoorLocationType locationType)
{
    switch (locationType)
    {
    case OutdoorLocationType::Enclosed:
        return "enclosed";

    case OutdoorLocationType::Exterior:
    default:
        return "exterior";
    }
}
}
