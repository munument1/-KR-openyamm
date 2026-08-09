-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "arslegardcity"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 1,
        source_name = "BathHouseExit",
        x = 5161,
        y = -33116,
        z = -127,
        direction_yaw_units = 0,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 55,
        source_name = "StartPoint0",
        x = 14400,
        y = -17475,
        z = -41,
        direction_yaw_units = 1018,
        move_player_to_floor = true,
    },
    {
        start_index = 2,
        source_object_index = 97,
        source_name = "HallOfTheGodsExit",
        x = 19999,
        y = -31703,
        z = 678,
        direction_yaw_units = 521,
        move_player_to_floor = true,
    },
    {
        start_index = 3,
        source_object_index = 101,
        source_name = "1000TerrorsExit",
        x = -614,
        y = -26542,
        z = -297,
        direction_yaw_units = 1284,
        move_player_to_floor = true,
    },
}
map.start_point_by_name = {}
map.start_point_by_source_object_index = {}
for _, start_point in ipairs(map.start_points) do
    if start_point.source_name ~= nil and start_point.source_name ~= "" then
        map.start_point_by_name[start_point.source_name] = start_point
    end
    map.start_point_by_source_object_index[start_point.source_object_index] = start_point
end

function map.resolveStartPoint(nameOrIndex)
    if type(nameOrIndex) == "number" then
        return map.start_points[nameOrIndex + 1] or map.start_point_by_source_object_index[nameOrIndex]
    end
    if type(nameOrIndex) == "string" then
        return map.start_point_by_name[nameOrIndex]
    end
    return nil
end

function map.moveToStartPoint(nameOrIndex, targetMapFileName)
    local start_point = map.resolveStartPoint(nameOrIndex)
    if start_point == nil or evt == nil or evt.MoveToMap == nil then
        return false
    end
    evt.MoveToMap(
        start_point.x,
        start_point.y,
        start_point.z,
        start_point.direction_yaw_units,
        0,
        0,
        0,
        1,
        targetMapFileName)
    return true
end

map.mechanisms = {
    {
        mechanism_id = 900019,
        event_id = 30019,
        source_object_index = 19,
        source_class = "Ladder",
        source_name = "Ladder6",
        kind = "ladder_volume",
        hint = "Ladder6",
    },
    {
        mechanism_id = 900021,
        event_id = 30021,
        source_object_index = 21,
        source_class = "Ladder",
        source_name = "Ladder7",
        kind = "ladder_volume",
        hint = "Ladder7",
    },
    {
        mechanism_id = 900023,
        event_id = 30023,
        source_object_index = 23,
        source_class = "RotatingDoor",
        source_name = "TavernDoor0",
        kind = "rotating_door",
        hint = "TavernDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900024,
        event_id = 30024,
        source_object_index = 24,
        source_class = "RotatingDoor",
        source_name = "TavernDoor1",
        kind = "rotating_door",
        hint = "TavernDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900025,
        event_id = 30025,
        source_object_index = 25,
        source_class = "RotatingDoor",
        source_name = "BankDoor0",
        kind = "rotating_door",
        hint = "BankDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900026,
        event_id = 30026,
        source_object_index = 26,
        source_class = "RotatingDoor",
        source_name = "BankDoor1",
        kind = "rotating_door",
        hint = "BankDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900027,
        event_id = 30027,
        source_object_index = 27,
        source_class = "RotatingDoor",
        source_name = "WeaponDoor0",
        kind = "rotating_door",
        hint = "WeaponDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900028,
        event_id = 30028,
        source_object_index = 28,
        source_class = "RotatingDoor",
        source_name = "WeaponDoor1",
        kind = "rotating_door",
        hint = "WeaponDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900029,
        event_id = 30029,
        source_object_index = 29,
        source_class = "RotatingDoor",
        source_name = "ArmorDoor0",
        kind = "rotating_door",
        hint = "ArmorDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900030,
        event_id = 30030,
        source_object_index = 30,
        source_class = "RotatingDoor",
        source_name = "ArmorDoor1",
        kind = "rotating_door",
        hint = "ArmorDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900031,
        event_id = 30031,
        source_object_index = 31,
        source_class = "RotatingDoor",
        source_name = "LibraryDoor1",
        kind = "rotating_door",
        hint = "LibraryDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900032,
        event_id = 30032,
        source_object_index = 32,
        source_class = "RotatingDoor",
        source_name = "LibraryDoor0",
        kind = "rotating_door",
        hint = "LibraryDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900033,
        event_id = 30033,
        source_object_index = 33,
        source_class = "RotatingDoor",
        source_name = "NjamDoor0",
        kind = "rotating_door",
        hint = "NjamDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/locked_door02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900034,
        event_id = 30034,
        source_object_index = 34,
        source_class = "RotatingDoor",
        source_name = "NjamDoor1",
        kind = "rotating_door",
        hint = "NjamDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/locked_door02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900035,
        event_id = 30035,
        source_object_index = 35,
        source_class = "RotatingDoor",
        source_name = "NjamBackDoor0",
        kind = "rotating_door",
        hint = "NjamBackDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/locked_door02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900036,
        event_id = 30036,
        source_object_index = 36,
        source_class = "RotatingDoor",
        source_name = "MagicDoor0",
        kind = "rotating_door",
        hint = "MagicDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900037,
        event_id = 30037,
        source_object_index = 37,
        source_class = "RotatingDoor",
        source_name = "MagicDoor1",
        kind = "rotating_door",
        hint = "MagicDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900051,
        event_id = 30051,
        source_object_index = 51,
        source_class = "RotatingDoor",
        source_name = "TrainingDoor0",
        kind = "rotating_door",
        hint = "TrainingDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900052,
        event_id = 30052,
        source_object_index = 52,
        source_class = "RotatingDoor",
        source_name = "TrainingDoor1",
        kind = "rotating_door",
        hint = "TrainingDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900053,
        event_id = 30053,
        source_object_index = 53,
        source_class = "RotatingDoor",
        source_name = "TempleDoor1",
        kind = "rotating_door",
        hint = "TempleDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900054,
        event_id = 30054,
        source_object_index = 54,
        source_class = "RotatingDoor",
        source_name = "TempleDoor0",
        kind = "rotating_door",
        hint = "TempleDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900057,
        event_id = 30057,
        source_object_index = 57,
        source_class = "RotatingDoor",
        source_name = "CounterDoor",
        kind = "rotating_door",
        hint = "CounterDoor",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900085,
        event_id = 30085,
        source_object_index = 85,
        source_class = "RotatingDoor",
        source_name = "GeneralDoor0",
        kind = "rotating_door",
        hint = "GeneralDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900086,
        event_id = 30086,
        source_object_index = 86,
        source_class = "RotatingDoor",
        source_name = "GeneralDoor1",
        kind = "rotating_door",
        hint = "GeneralDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900087,
        event_id = 30087,
        source_object_index = 87,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 900088,
        event_id = 30088,
        source_object_index = 88,
        source_class = "BlueWater",
        source_name = "BlueWater1",
        kind = "water_volume",
        hint = "BlueWater1",
    },
    {
        mechanism_id = 900090,
        event_id = 30090,
        source_object_index = 90,
        source_class = "BlueWater",
        source_name = "BlueWater2",
        kind = "water_volume",
        hint = "BlueWater2",
    },
    {
        mechanism_id = 900091,
        event_id = 30091,
        source_object_index = 91,
        source_class = "BlueWater",
        source_name = "BlueWater3",
        kind = "water_volume",
        hint = "BlueWater3",
    },
    {
        mechanism_id = 900098,
        event_id = 30098,
        source_object_index = 98,
        source_class = "RotatingDoor",
        source_name = "ClankDoor1",
        kind = "rotating_door",
        hint = "ClankDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900099,
        event_id = 30099,
        source_object_index = 99,
        source_class = "RotatingDoor",
        source_name = "ClankDoor2",
        kind = "rotating_door",
        hint = "ClankDoor2",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900102,
        event_id = 30102,
        source_object_index = 102,
        source_class = "RotatingDoor",
        source_name = "GeneralDoor3",
        kind = "rotating_door",
        hint = "GeneralDoor3",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900103,
        event_id = 30103,
        source_object_index = 103,
        source_class = "RotatingDoor",
        source_name = "GeneralDoor2",
        kind = "rotating_door",
        hint = "GeneralDoor2",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900138,
        event_id = 30138,
        source_object_index = 138,
        source_class = "ScriptObject",
        source_name = "Fateman",
        kind = "script_object",
        hint = "Fateman",
    },
    {
        mechanism_id = 900139,
        event_id = 30139,
        source_object_index = 139,
        source_class = "ScriptObject",
        source_name = "Loseman",
        kind = "script_object",
        hint = "Loseman",
    },
    {
        mechanism_id = 900141,
        event_id = 30141,
        source_object_index = 141,
        source_class = "ScriptObject",
        source_name = "Fateman0",
        kind = "script_object",
        hint = "Fateman0",
    },
    {
        mechanism_id = 900146,
        event_id = 30146,
        source_object_index = 146,
        source_class = "ScriptObject",
        source_name = "Writman",
        kind = "script_object",
        hint = "Writman",
    },
    {
        mechanism_id = 900431,
        event_id = 30431,
        source_object_index = 431,
        source_class = "RotatingDoor",
        source_name = "Njamdoor",
        kind = "rotating_door",
        hint = "Njamdoor",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/locked_door02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900641,
        event_id = 30641,
        source_object_index = 641,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900642,
        event_id = 30642,
        source_object_index = 642,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 900643,
        event_id = 30643,
        source_object_index = 643,
        source_class = "AIBarrier",
        source_name = "AIBarrier2",
        kind = "ai_barrier",
        hint = "AIBarrier2",
    },
    {
        mechanism_id = 900644,
        event_id = 30644,
        source_object_index = 644,
        source_class = "AIBarrier",
        source_name = "AIBarrier3",
        kind = "ai_barrier",
        hint = "AIBarrier3",
    },
    {
        mechanism_id = 900649,
        event_id = 30649,
        source_object_index = 649,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor1",
        kind = "rotating_door",
        hint = "RotatingDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900650,
        event_id = 30650,
        source_object_index = 650,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor0",
        kind = "rotating_door",
        hint = "RotatingDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900651,
        event_id = 30651,
        source_object_index = 651,
        source_class = "Door",
        source_name = "Door0",
        kind = "linear_door",
        hint = "Door0",
    },
}
map.mechanism_by_name = {}
map.mechanism_by_source_object_index = {}
map.mechanism_by_door_id = {}
for _, mechanism in ipairs(map.mechanisms) do
    if mechanism.source_name ~= nil and mechanism.source_name ~= "" then
        map.mechanism_by_name[mechanism.source_name] = mechanism
    end
    map.mechanism_by_source_object_index[mechanism.source_object_index] = mechanism
    map.mechanism_by_door_id[mechanism.mechanism_id] = mechanism
    if mechanism.classic_door_id ~= nil then
        map.mechanism_by_door_id[mechanism.classic_door_id] = mechanism
    end
end

function map.resolveMechanism(nameOrId)
    if type(nameOrId) == "number" then
        return map.mechanism_by_door_id[nameOrId] or map.mechanism_by_source_object_index[nameOrId]
    end
    if type(nameOrId) == "string" then
        return map.mechanism_by_name[nameOrId]
    end
    return nil
end

function map.playMechanismSound(mechanism, action)
    if mechanism == nil or mechanism.sounds == nil or evt == nil or evt.PlaySoundName == nil then
        return
    end
    local sound = nil
    if action == 1 then
        sound = mechanism.sounds.close_start or mechanism.sounds.close
    else
        sound = mechanism.sounds.open_start or mechanism.sounds.open
    end
    if sound == nil or sound.name == nil or sound.name == "" then
        return
    end
    evt.PlaySoundName(sound.name, sound.x or 0, sound.y or 0, sound.z or 0)
end

function map.triggerMechanism(nameOrId, action)
    local mechanism = map.resolveMechanism(nameOrId)
    if mechanism == nil then
        return false
    end
    local resolved_action = action or 2
    map.playMechanismSound(mechanism, resolved_action)
    if mechanism.classic_door_id ~= nil and evt ~= nil and evt.SetDoorState ~= nil then
        evt.SetDoorState(mechanism.classic_door_id, resolved_action)
        return true
    end
    if evt ~= nil and evt.SetOutdoorModelMechanismState ~= nil then
        evt.SetOutdoorModelMechanismState(mechanism.mechanism_id, resolved_action)
        return true
    end
    return false
end

SetMapMetadata({
    onLoad = {},
    onLeave = {},
    contextActions = {
    [30023] = { kind = "open_door", source = "mm9_mechanism", targetName = "TavernDoor0" },
    [30024] = { kind = "open_door", source = "mm9_mechanism", targetName = "TavernDoor1" },
    [30025] = { kind = "open_door", source = "mm9_mechanism", targetName = "BankDoor0" },
    [30026] = { kind = "open_door", source = "mm9_mechanism", targetName = "BankDoor1" },
    [30027] = { kind = "open_door", source = "mm9_mechanism", targetName = "WeaponDoor0" },
    [30028] = { kind = "open_door", source = "mm9_mechanism", targetName = "WeaponDoor1" },
    [30029] = { kind = "open_door", source = "mm9_mechanism", targetName = "ArmorDoor0" },
    [30030] = { kind = "open_door", source = "mm9_mechanism", targetName = "ArmorDoor1" },
    [30031] = { kind = "open_door", source = "mm9_mechanism", targetName = "LibraryDoor1" },
    [30032] = { kind = "open_door", source = "mm9_mechanism", targetName = "LibraryDoor0" },
    [30033] = { kind = "open_door", source = "mm9_mechanism", targetName = "NjamDoor0" },
    [30034] = { kind = "open_door", source = "mm9_mechanism", targetName = "NjamDoor1" },
    [30035] = { kind = "open_door", source = "mm9_mechanism", targetName = "NjamBackDoor0" },
    [30036] = { kind = "open_door", source = "mm9_mechanism", targetName = "MagicDoor0" },
    [30037] = { kind = "open_door", source = "mm9_mechanism", targetName = "MagicDoor1" },
    [30051] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrainingDoor0" },
    [30052] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrainingDoor1" },
    [30053] = { kind = "open_door", source = "mm9_mechanism", targetName = "TempleDoor1" },
    [30054] = { kind = "open_door", source = "mm9_mechanism", targetName = "TempleDoor0" },
    [30057] = { kind = "open_door", source = "mm9_mechanism", targetName = "CounterDoor" },
    [30085] = { kind = "open_door", source = "mm9_mechanism", targetName = "GeneralDoor0" },
    [30086] = { kind = "open_door", source = "mm9_mechanism", targetName = "GeneralDoor1" },
    [30098] = { kind = "open_door", source = "mm9_mechanism", targetName = "ClankDoor1" },
    [30099] = { kind = "open_door", source = "mm9_mechanism", targetName = "ClankDoor2" },
    [30102] = { kind = "open_door", source = "mm9_mechanism", targetName = "GeneralDoor3" },
    [30103] = { kind = "open_door", source = "mm9_mechanism", targetName = "GeneralDoor2" },
    [30431] = { kind = "open_door", source = "mm9_mechanism", targetName = "Njamdoor" },
    [30649] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor1" },
    [30650] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0" },
    [30651] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door0" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30023, "TavernDoor0", function()
    map.triggerMechanism(23, 2)
end, "TavernDoor0")

RegisterEvent(30024, "TavernDoor1", function()
    map.triggerMechanism(24, 2)
end, "TavernDoor1")

RegisterEvent(30025, "BankDoor0", function()
    map.triggerMechanism(25, 2)
end, "BankDoor0")

RegisterEvent(30026, "BankDoor1", function()
    map.triggerMechanism(26, 2)
end, "BankDoor1")

RegisterEvent(30027, "WeaponDoor0", function()
    map.triggerMechanism(27, 2)
end, "WeaponDoor0")

RegisterEvent(30028, "WeaponDoor1", function()
    map.triggerMechanism(28, 2)
end, "WeaponDoor1")

RegisterEvent(30029, "ArmorDoor0", function()
    map.triggerMechanism(29, 2)
end, "ArmorDoor0")

RegisterEvent(30030, "ArmorDoor1", function()
    map.triggerMechanism(30, 2)
end, "ArmorDoor1")

RegisterEvent(30031, "LibraryDoor1", function()
    map.triggerMechanism(31, 2)
end, "LibraryDoor1")

RegisterEvent(30032, "LibraryDoor0", function()
    map.triggerMechanism(32, 2)
end, "LibraryDoor0")

RegisterEvent(30033, "NjamDoor0", function()
    map.triggerMechanism(33, 2)
end, "NjamDoor0")

RegisterEvent(30034, "NjamDoor1", function()
    map.triggerMechanism(34, 2)
end, "NjamDoor1")

RegisterEvent(30035, "NjamBackDoor0", function()
    map.triggerMechanism(35, 2)
end, "NjamBackDoor0")

RegisterEvent(30036, "MagicDoor0", function()
    map.triggerMechanism(36, 2)
end, "MagicDoor0")

RegisterEvent(30037, "MagicDoor1", function()
    map.triggerMechanism(37, 2)
end, "MagicDoor1")

RegisterEvent(30051, "TrainingDoor0", function()
    map.triggerMechanism(51, 2)
end, "TrainingDoor0")

RegisterEvent(30052, "TrainingDoor1", function()
    map.triggerMechanism(52, 2)
end, "TrainingDoor1")

RegisterEvent(30053, "TempleDoor1", function()
    map.triggerMechanism(53, 2)
end, "TempleDoor1")

RegisterEvent(30054, "TempleDoor0", function()
    map.triggerMechanism(54, 2)
end, "TempleDoor0")

RegisterEvent(30057, "CounterDoor", function()
    map.triggerMechanism(57, 2)
end, "CounterDoor")

RegisterEvent(30085, "GeneralDoor0", function()
    map.triggerMechanism(85, 2)
end, "GeneralDoor0")

RegisterEvent(30086, "GeneralDoor1", function()
    map.triggerMechanism(86, 2)
end, "GeneralDoor1")

RegisterEvent(30098, "ClankDoor1", function()
    map.triggerMechanism(98, 2)
end, "ClankDoor1")

RegisterEvent(30099, "ClankDoor2", function()
    map.triggerMechanism(99, 2)
end, "ClankDoor2")

RegisterEvent(30102, "GeneralDoor3", function()
    map.triggerMechanism(102, 2)
end, "GeneralDoor3")

RegisterEvent(30103, "GeneralDoor2", function()
    map.triggerMechanism(103, 2)
end, "GeneralDoor2")

RegisterEvent(30431, "Njamdoor", function()
    map.triggerMechanism(431, 2)
end, "Njamdoor")

RegisterEvent(30649, "RotatingDoor1", function()
    map.triggerMechanism(649, 2)
end, "RotatingDoor1")

RegisterEvent(30650, "RotatingDoor0", function()
    map.triggerMechanism(650, 2)
end, "RotatingDoor0")

RegisterEvent(30651, "Door0", function()
    map.triggerMechanism(651, 2)
end, "Door0")

map.scripts["book.scr"] = {
    source = "BOOK.scr",
    registered_triggers = {
        { line = 50, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["bookletter.scr"] = {
    source = "BOOKLETTER.scr",
    registered_triggers = {
        { line = 74, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["doorlock.scr"] = {
    source = "DOORLOCK.scr",
    registered_triggers = {
        { line = 57, message = "use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["fateman.scr"] = {
    source = "FATEMAN.scr",
    registered_triggers = {
        { line = 452, message = "Lose", callback = "OnLose" },
        { line = 453, message = "Cam2", callback = "OnCam2" },
        { line = 454, message = "cam3", callback = "OnCam3" },
        { line = 455, message = "FadeOut", callback = "Close" },
        { line = 456, message = "Done", callback = "OnDone" },
    },
    movement_commands = {
    },
}
map.scripts["givetake.scr"] = {
    source = "GIVETAKE.scr",
    registered_triggers = {
        { line = 70, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["hanndl.scr"] = {
    source = "HANNDL.scr",
    registered_triggers = {
        { line = 238, message = "Speak", callback = "Speak1" },
        { line = 239, message = "Speak9", callback = "OnSpeak9" },
        { line = 240, message = "Speak10", callback = "OnSpeak10" },
        { line = 241, message = "Speak11", callback = "OnSpeak11" },
        { line = 242, message = "Speak12", callback = "OnSpeak12" },
        { line = 243, message = "Speak13", callback = "OnSpeak13" },
        { line = 244, message = "Speak14", callback = "OnSpeak14" },
        { line = 245, message = "Speak15", callback = "OnSpeak15" },
        { line = 246, message = "Speak16", callback = "OnSpeak16" },
        { line = 247, message = "Speak17", callback = "OnSpeak17" },
    },
    movement_commands = {
    },
}
map.scripts["losecam1.scr"] = {
    source = "LOSECAM1.scr",
    registered_triggers = {
        { line = 73, message = "Play", callback = "OnPlay" },
    },
    movement_commands = {
        { line = 48, command = "MoveToPos", arguments = "xpos Ypos Zpos 100 OnArrive1" },
        { line = 64, command = "SetPos", arguments = "g_hmyobject MyX MyY MyZ DoNothing" },
    },
}
map.scripts["losecam2.scr"] = {
    source = "LOSECAM2.scr",
    registered_triggers = {
        { line = 70, message = "Play", callback = "OnPlay" },
    },
    movement_commands = {
        { line = 45, command = "MoveToPos", arguments = "xpos Ypos Zpos 150 OnArrive1" },
        { line = 61, command = "SetPos", arguments = "g_hmyobject MyX MyY MyZ DoNothing" },
    },
}
map.scripts["losecam3.scr"] = {
    source = "LOSECAM3.scr",
    registered_triggers = {
        { line = 73, message = "Play", callback = "OnPlay" },
    },
    movement_commands = {
        { line = 47, command = "MoveToPos", arguments = "xpos Ypos Zpos 100 OnArrive1" },
        { line = 62, command = "SetPos", arguments = "g_hmyobject MyX MyY MyZ DoNothing" },
    },
}
map.scripts["loseman.scr"] = {
    source = "LOSEMAN.scr",
    registered_triggers = {
        { line = 113, message = "Lose", callback = "OnLose" },
        { line = 114, message = "Cam2", callback = "OnCam2" },
        { line = 115, message = "cam3", callback = "OnCam3" },
        { line = 116, message = "FadeOut", callback = "Close" },
    },
    movement_commands = {
    },
}
map.scripts["njamchase.scr"] = {
    source = "NJAMCHASE.scr",
    registered_triggers = {
        { line = 79, message = "Chase", callback = "OnChase" },
    },
    movement_commands = {
    },
}
map.scripts["npc3.scr"] = {
    source = "NPC3.scr",
    registered_triggers = {
        { line = 237, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
        { line = 198, command = "MoveToPos", arguments = "32 1438 8100" },
    },
}
map.scripts["npc334.scr"] = {
    source = "NPC334.scr",
    registered_triggers = {
        { line = 88, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["propanim.scr"] = {
    source = "PROPANIM.scr",
    registered_triggers = {
        { line = 42, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["writman.scr"] = {
    source = "WRITMAN.scr",
    registered_triggers = {
        { line = 284, message = "Lose", callback = "OnLose" },
        { line = 285, message = "Cam2", callback = "OnCam2" },
        { line = 286, message = "cam3", callback = "OnCam3" },
        { line = 287, message = "FadeOut", callback = "Close" },
        { line = 292, message = "Done", callback = "OnDone" },
    },
    movement_commands = {
    },
}

function map.register(ctx)
    if ctx == nil or ctx.registerMm9MapEvents == nil then
        return
    end
    ctx:registerMm9MapEvents(map)
end

return map
