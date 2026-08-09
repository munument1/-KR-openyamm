-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "thronheimcity"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 149,
        source_name = "StartPoint0",
        x = 14377,
        y = 164,
        z = 3277,
        direction_yaw_units = 285,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 152,
        source_name = "TownPortal",
        x = -10015,
        y = 11878,
        z = 3482,
        direction_yaw_units = 1081,
        move_player_to_floor = true,
    },
    {
        start_index = 2,
        source_object_index = 948,
        source_name = "StartPoint1",
        x = 2048,
        y = 14664,
        z = 3430,
        direction_yaw_units = 1026,
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
        mechanism_id = 900003,
        event_id = 30003,
        source_object_index = 3,
        source_class = "RotatingDoor",
        source_name = "TownHallDoor1",
        kind = "rotating_door",
        hint = "TownHallDoor1",
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
        mechanism_id = 900004,
        event_id = 30004,
        source_object_index = 4,
        source_class = "RotatingDoor",
        source_name = "TownHallDoor2",
        kind = "rotating_door",
        hint = "TownHallDoor2",
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
        mechanism_id = 900005,
        event_id = 30005,
        source_object_index = 5,
        source_class = "RotatingDoor",
        source_name = "Magic0",
        kind = "rotating_door",
        hint = "Magic0",
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
        mechanism_id = 900006,
        event_id = 30006,
        source_object_index = 6,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor15",
        kind = "rotating_door",
        hint = "RotatingDoor15",
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
        mechanism_id = 900007,
        event_id = 30007,
        source_object_index = 7,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor16",
        kind = "rotating_door",
        hint = "RotatingDoor16",
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
        mechanism_id = 900008,
        event_id = 30008,
        source_object_index = 8,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor3",
        kind = "rotating_door",
        hint = "RotatingDoor3",
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
        mechanism_id = 900011,
        event_id = 30011,
        source_object_index = 11,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor17",
        kind = "rotating_door",
        hint = "RotatingDoor17",
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
        mechanism_id = 900012,
        event_id = 30012,
        source_object_index = 12,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor11",
        kind = "rotating_door",
        hint = "RotatingDoor11",
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
        mechanism_id = 900013,
        event_id = 30013,
        source_object_index = 13,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor12",
        kind = "rotating_door",
        hint = "RotatingDoor12",
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
        mechanism_id = 900014,
        event_id = 30014,
        source_object_index = 14,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor13",
        kind = "rotating_door",
        hint = "RotatingDoor13",
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
        mechanism_id = 900015,
        event_id = 30015,
        source_object_index = 15,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor14",
        kind = "rotating_door",
        hint = "RotatingDoor14",
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
        mechanism_id = 900016,
        event_id = 30016,
        source_object_index = 16,
        source_class = "RotatingDoor",
        source_name = "Prisondoor0",
        kind = "rotating_door",
        hint = "Prisondoor0",
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
                name = "Door/locked_door01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900017,
        event_id = 30017,
        source_object_index = 17,
        source_class = "RotatingDoor",
        source_name = "Prisondoor1",
        kind = "rotating_door",
        hint = "Prisondoor1",
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
                name = "Door/locked_door01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900018,
        event_id = 30018,
        source_object_index = 18,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush2",
        kind = "destructible_brush",
        hint = "DestructableBrush2",
    },
    {
        mechanism_id = 900019,
        event_id = 30019,
        source_object_index = 19,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush3",
        kind = "destructible_brush",
        hint = "DestructableBrush3",
    },
    {
        mechanism_id = 900020,
        event_id = 30020,
        source_object_index = 20,
        source_class = "RotatingDoor",
        source_name = "InnDoor1",
        kind = "rotating_door",
        hint = "InnDoor1",
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
        mechanism_id = 900021,
        event_id = 30021,
        source_object_index = 21,
        source_class = "RotatingDoor",
        source_name = "InnDoor2",
        kind = "rotating_door",
        hint = "InnDoor2",
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
        mechanism_id = 900022,
        event_id = 30022,
        source_object_index = 22,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor8",
        kind = "rotating_door",
        hint = "RotatingDoor8",
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
        mechanism_id = 900023,
        event_id = 30023,
        source_object_index = 23,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor9",
        kind = "rotating_door",
        hint = "RotatingDoor9",
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
        source_name = "vaultdoor",
        kind = "rotating_door",
        hint = "vaultdoor",
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
                name = "Door/locked_door01.wav",
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
        source_name = "RotatingDoor4",
        kind = "rotating_door",
        hint = "RotatingDoor4",
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
        mechanism_id = 900035,
        event_id = 30035,
        source_object_index = 35,
        source_class = "Door",
        source_name = "Door4",
        kind = "linear_door",
        hint = "Door4",
        sounds = {
            ["jiggle"] = {
                name = "Door/knock.wav",
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
        source_name = "RotatingDoor6",
        kind = "rotating_door",
        hint = "RotatingDoor6",
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
        source_name = "RotatingDoor7",
        kind = "rotating_door",
        hint = "RotatingDoor7",
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
        mechanism_id = 900045,
        event_id = 30045,
        source_object_index = 45,
        source_class = "RotatingDoor",
        source_name = "WeaponDoor2",
        kind = "rotating_door",
        hint = "WeaponDoor2",
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
        mechanism_id = 900046,
        event_id = 30046,
        source_object_index = 46,
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
        mechanism_id = 900047,
        event_id = 30047,
        source_object_index = 47,
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
        mechanism_id = 900048,
        event_id = 30048,
        source_object_index = 48,
        source_class = "RotatingDoor",
        source_name = "LibraryDoor2",
        kind = "rotating_door",
        hint = "LibraryDoor2",
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
        mechanism_id = 900049,
        event_id = 30049,
        source_object_index = 49,
        source_class = "RotatingDoor",
        source_name = "CounselDoor0",
        kind = "rotating_door",
        hint = "CounselDoor0",
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
        mechanism_id = 900050,
        event_id = 30050,
        source_object_index = 50,
        source_class = "RotatingDoor",
        source_name = "CounselDoor1",
        kind = "rotating_door",
        hint = "CounselDoor1",
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
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900052,
        event_id = 30052,
        source_object_index = 52,
        source_class = "Ladder",
        source_name = "Ladder1",
        kind = "ladder_volume",
        hint = "Ladder1",
    },
    {
        mechanism_id = 900065,
        event_id = 30065,
        source_object_index = 65,
        source_class = "DestructableBrush",
        source_name = "PrisonWall",
        kind = "destructible_brush",
        hint = "PrisonWall",
    },
    {
        mechanism_id = 900099,
        event_id = 30099,
        source_object_index = 99,
        source_class = "RotatingDoor",
        source_name = "TempleRatDoor1",
        kind = "rotating_door",
        hint = "TempleRatDoor1",
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
        mechanism_id = 900100,
        event_id = 30100,
        source_object_index = 100,
        source_class = "RotatingDoor",
        source_name = "TempleRatDoor2",
        kind = "rotating_door",
        hint = "TempleRatDoor2",
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
        mechanism_id = 900101,
        event_id = 30101,
        source_object_index = 101,
        source_class = "RotatingDoor",
        source_name = "TempleThronDoor2",
        kind = "rotating_door",
        hint = "TempleThronDoor2",
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
        source_name = "TempleThronDoor1",
        kind = "rotating_door",
        hint = "TempleThronDoor1",
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
        mechanism_id = 900105,
        event_id = 30105,
        source_object_index = 105,
        source_class = "RotatingDoor",
        source_name = "KiraDoor1",
        kind = "rotating_door",
        hint = "KiraDoor1",
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
        mechanism_id = 900106,
        event_id = 30106,
        source_object_index = 106,
        source_class = "RotatingDoor",
        source_name = "KiraDoor2",
        kind = "rotating_door",
        hint = "KiraDoor2",
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
        mechanism_id = 900139,
        event_id = 30139,
        source_object_index = 139,
        source_class = "ScriptObject",
        source_name = "ScriptObject0",
        kind = "script_object",
        hint = "ScriptObject0",
    },
    {
        mechanism_id = 900154,
        event_id = 30154,
        source_object_index = 154,
        source_class = "Door",
        source_name = "Door3",
        kind = "linear_door",
        hint = "Door3",
        sounds = {
            ["jiggle"] = {
                name = "Door/knock.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900155,
        event_id = 30155,
        source_object_index = 155,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900156,
        event_id = 30156,
        source_object_index = 156,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900157,
        event_id = 30157,
        source_object_index = 157,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900158,
        event_id = 30158,
        source_object_index = 158,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 900159,
        event_id = 30159,
        source_object_index = 159,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 900160,
        event_id = 30160,
        source_object_index = 160,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush11",
        kind = "perception_brush",
        hint = "PerceptionBrush11",
    },
    {
        mechanism_id = 900161,
        event_id = 30161,
        source_object_index = 161,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush10",
        kind = "perception_brush",
        hint = "PerceptionBrush10",
    },
    {
        mechanism_id = 900162,
        event_id = 30162,
        source_object_index = 162,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 900163,
        event_id = 30163,
        source_object_index = 163,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush7",
        kind = "perception_brush",
        hint = "PerceptionBrush7",
    },
    {
        mechanism_id = 900164,
        event_id = 30164,
        source_object_index = 164,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush8",
        kind = "perception_brush",
        hint = "PerceptionBrush8",
    },
    {
        mechanism_id = 900165,
        event_id = 30165,
        source_object_index = 165,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush9",
        kind = "perception_brush",
        hint = "PerceptionBrush9",
    },
    {
        mechanism_id = 900194,
        event_id = 30194,
        source_object_index = 194,
        source_class = "ScriptObject",
        source_name = "Argueman",
        kind = "script_object",
        hint = "Argueman",
    },
    {
        mechanism_id = 900213,
        event_id = 30213,
        source_object_index = 213,
        source_class = "ScriptObject",
        source_name = "ARG_Unhide",
        kind = "script_object",
        hint = "ARG_Unhide",
    },
    {
        mechanism_id = 900241,
        event_id = 30241,
        source_object_index = 241,
        source_class = "Ladder",
        source_name = "Ladder0",
        kind = "ladder_volume",
        hint = "Ladder0",
    },
    {
        mechanism_id = 900300,
        event_id = 30300,
        source_object_index = 300,
        source_class = "RotatingDoor",
        source_name = "Secretdoor0",
        kind = "rotating_door",
        hint = "Secretdoor0",
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
        mechanism_id = 900301,
        event_id = 30301,
        source_object_index = 301,
        source_class = "DestructableProp",
        source_name = "Bookcase47",
        kind = "destructible_prop",
        hint = "Bookcase47",
    },
    {
        mechanism_id = 900317,
        event_id = 30317,
        source_object_index = 317,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 900318,
        event_id = 30318,
        source_object_index = 318,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush6",
        kind = "collision_volume",
        hint = "InvisibleBrush6",
    },
    {
        mechanism_id = 900319,
        event_id = 30319,
        source_object_index = 319,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush7",
        kind = "collision_volume",
        hint = "InvisibleBrush7",
    },
    {
        mechanism_id = 900328,
        event_id = 30328,
        source_object_index = 328,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 900329,
        event_id = 30329,
        source_object_index = 329,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 900330,
        event_id = 30330,
        source_object_index = 330,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900334,
        event_id = 30334,
        source_object_index = 334,
        source_class = "Door",
        source_name = "Door1",
        kind = "linear_door",
        hint = "Door1",
        sounds = {
            ["jiggle"] = {
                name = "Door/knock.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900378,
        event_id = 30378,
        source_object_index = 378,
        source_class = "Door",
        source_name = "Door2",
        kind = "linear_door",
        hint = "Door2",
        sounds = {
            ["jiggle"] = {
                name = "Door/knock.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900442,
        event_id = 30442,
        source_object_index = 442,
        source_class = "DestructableProp",
        source_name = "Flowerboxes3",
        kind = "destructible_prop",
        hint = "Flowerboxes3",
    },
    {
        mechanism_id = 900443,
        event_id = 30443,
        source_object_index = 443,
        source_class = "DestructableProp",
        source_name = "Flowerboxes5",
        kind = "destructible_prop",
        hint = "Flowerboxes5",
    },
    {
        mechanism_id = 900444,
        event_id = 30444,
        source_object_index = 444,
        source_class = "DestructableProp",
        source_name = "Flowerboxes6",
        kind = "destructible_prop",
        hint = "Flowerboxes6",
    },
    {
        mechanism_id = 900445,
        event_id = 30445,
        source_object_index = 445,
        source_class = "DestructableProp",
        source_name = "Flowerboxes7",
        kind = "destructible_prop",
        hint = "Flowerboxes7",
    },
    {
        mechanism_id = 900446,
        event_id = 30446,
        source_object_index = 446,
        source_class = "DestructableProp",
        source_name = "Flowerboxes10",
        kind = "destructible_prop",
        hint = "Flowerboxes10",
    },
    {
        mechanism_id = 900447,
        event_id = 30447,
        source_object_index = 447,
        source_class = "DestructableProp",
        source_name = "Flowerboxes12",
        kind = "destructible_prop",
        hint = "Flowerboxes12",
    },
    {
        mechanism_id = 900448,
        event_id = 30448,
        source_object_index = 448,
        source_class = "DestructableProp",
        source_name = "Flowerboxes13",
        kind = "destructible_prop",
        hint = "Flowerboxes13",
    },
    {
        mechanism_id = 900449,
        event_id = 30449,
        source_object_index = 449,
        source_class = "DestructableProp",
        source_name = "Flowerboxes14",
        kind = "destructible_prop",
        hint = "Flowerboxes14",
    },
    {
        mechanism_id = 900450,
        event_id = 30450,
        source_object_index = 450,
        source_class = "DestructableProp",
        source_name = "Flowerboxes17",
        kind = "destructible_prop",
        hint = "Flowerboxes17",
    },
    {
        mechanism_id = 900451,
        event_id = 30451,
        source_object_index = 451,
        source_class = "DestructableProp",
        source_name = "Flowerboxes18",
        kind = "destructible_prop",
        hint = "Flowerboxes18",
    },
    {
        mechanism_id = 900452,
        event_id = 30452,
        source_object_index = 452,
        source_class = "DestructableProp",
        source_name = "Flowerboxes20",
        kind = "destructible_prop",
        hint = "Flowerboxes20",
    },
    {
        mechanism_id = 900453,
        event_id = 30453,
        source_object_index = 453,
        source_class = "DestructableProp",
        source_name = "Flowerboxes19",
        kind = "destructible_prop",
        hint = "Flowerboxes19",
    },
    {
        mechanism_id = 900454,
        event_id = 30454,
        source_object_index = 454,
        source_class = "DestructableProp",
        source_name = "Flowerboxes15",
        kind = "destructible_prop",
        hint = "Flowerboxes15",
    },
    {
        mechanism_id = 900455,
        event_id = 30455,
        source_object_index = 455,
        source_class = "Ladder",
        source_name = "Ladder2",
        kind = "ladder_volume",
        hint = "Ladder2",
    },
    {
        mechanism_id = 900605,
        event_id = 30605,
        source_object_index = 605,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900606,
        event_id = 30606,
        source_object_index = 606,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 900625,
        event_id = 30625,
        source_object_index = 625,
        source_class = "AIBarrier",
        source_name = "AIBarrier2",
        kind = "ai_barrier",
        hint = "AIBarrier2",
    },
    {
        mechanism_id = 900626,
        event_id = 30626,
        source_object_index = 626,
        source_class = "AIBarrier",
        source_name = "AIBarrier3",
        kind = "ai_barrier",
        hint = "AIBarrier3",
    },
    {
        mechanism_id = 900627,
        event_id = 30627,
        source_object_index = 627,
        source_class = "AIBarrier",
        source_name = "AIBarrier4",
        kind = "ai_barrier",
        hint = "AIBarrier4",
    },
    {
        mechanism_id = 900628,
        event_id = 30628,
        source_object_index = 628,
        source_class = "AIBarrier",
        source_name = "AIBarrier5",
        kind = "ai_barrier",
        hint = "AIBarrier5",
    },
    {
        mechanism_id = 900907,
        event_id = 30907,
        source_object_index = 907,
        source_class = "AIBarrier",
        source_name = "AIBarrier6",
        kind = "ai_barrier",
        hint = "AIBarrier6",
    },
    {
        mechanism_id = 900918,
        event_id = 30918,
        source_object_index = 918,
        source_class = "AIBarrier",
        source_name = "AIBarrier8",
        kind = "ai_barrier",
        hint = "AIBarrier8",
    },
    {
        mechanism_id = 900919,
        event_id = 30919,
        source_object_index = 919,
        source_class = "AIBarrier",
        source_name = "AIBarrier7",
        kind = "ai_barrier",
        hint = "AIBarrier7",
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
    [30003] = { kind = "open_door", source = "mm9_mechanism", targetName = "TownHallDoor1" },
    [30004] = { kind = "open_door", source = "mm9_mechanism", targetName = "TownHallDoor2" },
    [30005] = { kind = "open_door", source = "mm9_mechanism", targetName = "Magic0" },
    [30006] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor15" },
    [30007] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor16" },
    [30008] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor3" },
    [30011] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor17" },
    [30012] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor11" },
    [30013] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor12" },
    [30014] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor13" },
    [30015] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor14" },
    [30016] = { kind = "open_door", source = "mm9_mechanism", targetName = "Prisondoor0" },
    [30017] = { kind = "open_door", source = "mm9_mechanism", targetName = "Prisondoor1" },
    [30020] = { kind = "open_door", source = "mm9_mechanism", targetName = "InnDoor1" },
    [30021] = { kind = "open_door", source = "mm9_mechanism", targetName = "InnDoor2" },
    [30022] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor8" },
    [30023] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor9" },
    [30024] = { kind = "open_door", source = "mm9_mechanism", targetName = "vaultdoor" },
    [30034] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor4" },
    [30035] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door4" },
    [30036] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor6" },
    [30037] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor7" },
    [30045] = { kind = "open_door", source = "mm9_mechanism", targetName = "WeaponDoor2" },
    [30046] = { kind = "open_door", source = "mm9_mechanism", targetName = "WeaponDoor1" },
    [30047] = { kind = "open_door", source = "mm9_mechanism", targetName = "LibraryDoor1" },
    [30048] = { kind = "open_door", source = "mm9_mechanism", targetName = "LibraryDoor2" },
    [30049] = { kind = "open_door", source = "mm9_mechanism", targetName = "CounselDoor0" },
    [30050] = { kind = "open_door", source = "mm9_mechanism", targetName = "CounselDoor1" },
    [30099] = { kind = "open_door", source = "mm9_mechanism", targetName = "TempleRatDoor1" },
    [30100] = { kind = "open_door", source = "mm9_mechanism", targetName = "TempleRatDoor2" },
    [30101] = { kind = "open_door", source = "mm9_mechanism", targetName = "TempleThronDoor2" },
    [30102] = { kind = "open_door", source = "mm9_mechanism", targetName = "TempleThronDoor1" },
    [30105] = { kind = "open_door", source = "mm9_mechanism", targetName = "KiraDoor1" },
    [30106] = { kind = "open_door", source = "mm9_mechanism", targetName = "KiraDoor2" },
    [30154] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door3" },
    [30300] = { kind = "open_door", source = "mm9_mechanism", targetName = "Secretdoor0" },
    [30334] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1" },
    [30378] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door2" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30003, "TownHallDoor1", function()
    map.triggerMechanism(3, 2)
end, "TownHallDoor1")

RegisterEvent(30004, "TownHallDoor2", function()
    map.triggerMechanism(4, 2)
end, "TownHallDoor2")

RegisterEvent(30005, "Magic0", function()
    map.triggerMechanism(5, 2)
end, "Magic0")

RegisterEvent(30006, "RotatingDoor15", function()
    map.triggerMechanism(6, 2)
end, "RotatingDoor15")

RegisterEvent(30007, "RotatingDoor16", function()
    map.triggerMechanism(7, 2)
end, "RotatingDoor16")

RegisterEvent(30008, "RotatingDoor3", function()
    map.triggerMechanism(8, 2)
end, "RotatingDoor3")

RegisterEvent(30011, "RotatingDoor17", function()
    map.triggerMechanism(11, 2)
end, "RotatingDoor17")

RegisterEvent(30012, "RotatingDoor11", function()
    map.triggerMechanism(12, 2)
end, "RotatingDoor11")

RegisterEvent(30013, "RotatingDoor12", function()
    map.triggerMechanism(13, 2)
end, "RotatingDoor12")

RegisterEvent(30014, "RotatingDoor13", function()
    map.triggerMechanism(14, 2)
end, "RotatingDoor13")

RegisterEvent(30015, "RotatingDoor14", function()
    map.triggerMechanism(15, 2)
end, "RotatingDoor14")

RegisterEvent(30016, "Prisondoor0", function()
    map.triggerMechanism(16, 2)
end, "Prisondoor0")

RegisterEvent(30017, "Prisondoor1", function()
    map.triggerMechanism(17, 2)
end, "Prisondoor1")

RegisterEvent(30020, "InnDoor1", function()
    map.triggerMechanism(20, 2)
end, "InnDoor1")

RegisterEvent(30021, "InnDoor2", function()
    map.triggerMechanism(21, 2)
end, "InnDoor2")

RegisterEvent(30022, "RotatingDoor8", function()
    map.triggerMechanism(22, 2)
end, "RotatingDoor8")

RegisterEvent(30023, "RotatingDoor9", function()
    map.triggerMechanism(23, 2)
end, "RotatingDoor9")

RegisterEvent(30024, "vaultdoor", function()
    map.triggerMechanism(24, 2)
end, "vaultdoor")

RegisterEvent(30034, "RotatingDoor4", function()
    map.triggerMechanism(34, 2)
end, "RotatingDoor4")

RegisterEvent(30035, "Door4", function()
    map.triggerMechanism(35, 2)
end, "Door4")

RegisterEvent(30036, "RotatingDoor6", function()
    map.triggerMechanism(36, 2)
end, "RotatingDoor6")

RegisterEvent(30037, "RotatingDoor7", function()
    map.triggerMechanism(37, 2)
end, "RotatingDoor7")

RegisterEvent(30045, "WeaponDoor2", function()
    map.triggerMechanism(45, 2)
end, "WeaponDoor2")

RegisterEvent(30046, "WeaponDoor1", function()
    map.triggerMechanism(46, 2)
end, "WeaponDoor1")

RegisterEvent(30047, "LibraryDoor1", function()
    map.triggerMechanism(47, 2)
end, "LibraryDoor1")

RegisterEvent(30048, "LibraryDoor2", function()
    map.triggerMechanism(48, 2)
end, "LibraryDoor2")

RegisterEvent(30049, "CounselDoor0", function()
    map.triggerMechanism(49, 2)
end, "CounselDoor0")

RegisterEvent(30050, "CounselDoor1", function()
    map.triggerMechanism(50, 2)
end, "CounselDoor1")

RegisterEvent(30099, "TempleRatDoor1", function()
    map.triggerMechanism(99, 2)
end, "TempleRatDoor1")

RegisterEvent(30100, "TempleRatDoor2", function()
    map.triggerMechanism(100, 2)
end, "TempleRatDoor2")

RegisterEvent(30101, "TempleThronDoor2", function()
    map.triggerMechanism(101, 2)
end, "TempleThronDoor2")

RegisterEvent(30102, "TempleThronDoor1", function()
    map.triggerMechanism(102, 2)
end, "TempleThronDoor1")

RegisterEvent(30105, "KiraDoor1", function()
    map.triggerMechanism(105, 2)
end, "KiraDoor1")

RegisterEvent(30106, "KiraDoor2", function()
    map.triggerMechanism(106, 2)
end, "KiraDoor2")

RegisterEvent(30154, "Door3", function()
    map.triggerMechanism(154, 2)
end, "Door3")

RegisterEvent(30300, "Secretdoor0", function()
    map.triggerMechanism(300, 2)
end, "Secretdoor0")

RegisterEvent(30334, "Door1", function()
    map.triggerMechanism(334, 2)
end, "Door1")

RegisterEvent(30378, "Door2", function()
    map.triggerMechanism(378, 2)
end, "Door2")

map.scripts["ake.scr"] = {
    source = "AKE.scr",
    registered_triggers = {
        { line = 208, message = "blabber", callback = "Onblabber" },
        { line = 209, message = "Use", callback = "OnUse" },
        { line = 210, message = "shutup", callback = "onexit" },
        { line = 227, message = "GoPosition1", callback = "GoPosition1" },
        { line = 228, message = "GoPosition2", callback = "GoPosition2" },
        { line = 229, message = "GoPosition3", callback = "GoPosition3" },
        { line = 230, message = "GoPosition4", callback = "GoPosition4" },
    },
    movement_commands = {
        { line = 134, command = "SetPos", arguments = "g_hMyObject,3328.0,1344.0,-480.0" },
        { line = 142, command = "SetPos", arguments = "g_hMyObject,3557,1254,3331" },
        { line = 151, command = "SetPos", arguments = "g_hMyObject,-720,1246,2166" },
        { line = 160, command = "SetPos", arguments = "g_hMyObject,-2176,1246,4711" },
    },
}
map.scripts["arg_bjarni.scr"] = {
    source = "ARG_BJARNI.scr",
    registered_triggers = {
        { line = 183, message = "Shot1A", callback = "On1A" },
        { line = 190, message = "Speak2", callback = "OnSpeak2" },
        { line = 193, message = "Speak9", callback = "OnSpeak9" },
        { line = 195, message = "Speak16", callback = "OnSpeak16" },
        { line = 198, message = "Shake", callback = "OnShake" },
        { line = 199, message = "Clap", callback = "OnApplause" },
        { line = 201, message = "Agree", callback = "OnAgree" },
    },
    movement_commands = {
    },
}
map.scripts["arg_forad.scr"] = {
    source = "ARG_FORAD.scr",
    registered_triggers = {
        { line = 129, message = "Speak6", callback = "OnSpeak6" },
        { line = 131, message = "Speak20", callback = "OnSpeak20" },
        { line = 134, message = "Clap", callback = "OnApplause" },
        { line = 136, message = "Agree", callback = "OnAgree" },
    },
    movement_commands = {
    },
}
map.scripts["arg_kira.scr"] = {
    source = "ARG_KIRA.scr",
    registered_triggers = {
        { line = 307, message = "Clap", callback = "OnApplause" },
        { line = 308, message = "Speak5", callback = "OnSpeak5" },
        { line = 310, message = "Speak7", callback = "OnSpeak7" },
        { line = 312, message = "Speak10", callback = "OnSpeak10" },
        { line = 314, message = "Speak12", callback = "OnSpeak12" },
        { line = 316, message = "Speak14", callback = "OnSpeak14" },
        { line = 321, message = "Stand", callback = "OnStand" },
        { line = 323, message = "Speak18", callback = "OnSpeak18" },
        { line = 324, message = "Speak19", callback = "OnSpeak19" },
        { line = 330, message = "Agree", callback = "OnAgree" },
    },
    movement_commands = {
    },
}
map.scripts["arg_markel.scr"] = {
    source = "ARG_MARKEL.scr",
    registered_triggers = {
        { line = 237, message = "Scene2", callback = "OnScene2" },
        { line = 239, message = "Speak4", callback = "OnSpeak4" },
        { line = 241, message = "Speak8", callback = "OnSpeak8" },
        { line = 243, message = "Speak11", callback = "OnSpeak11" },
        { line = 245, message = "Speak13", callback = "OnSpeak13" },
        { line = 247, message = "Speak15", callback = "OnSpeak15" },
        { line = 249, message = "Move", callback = "OnMove" },
        { line = 251, message = "Kill", callback = "OnKill" },
        { line = 253, message = "Clap", callback = "OnApplause" },
        { line = 255, message = "Agree", callback = "OnAgree" },
    },
    movement_commands = {
    },
}
map.scripts["arg_sigmund.scr"] = {
    source = "ARG_SIGMUND.scr",
    registered_triggers = {
        { line = 135, message = "Shot1A", callback = "OnShot1A" },
        { line = 141, message = "Speak3", callback = "ONSpeak3" },
        { line = 143, message = "Shake", callback = "OnShake" },
        { line = 144, message = "Clap", callback = "OnApplause" },
        { line = 146, message = "Agree", callback = "OnAgree" },
    },
    movement_commands = {
    },
}
map.scripts["arg_sven.scr"] = {
    source = "ARG_SVEN.scr",
    registered_triggers = {
        { line = 81, message = "Clap", callback = "OnApplause" },
        { line = 83, message = "Agree", callback = "OnAgree" },
    },
    movement_commands = {
    },
}
map.scripts["arg_tryygva.scr"] = {
    source = "ARG_TRYYGVA.scr",
    registered_triggers = {
        { line = 81, message = "Clap", callback = "ONApplause" },
        { line = 83, message = "Agree", callback = "OnAgree" },
    },
    movement_commands = {
    },
}
map.scripts["arg_unhide.scr"] = {
    source = "ARG_UNHIDE.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["arg_yrsa.scr"] = {
    source = "ARG_YRSA.scr",
    registered_triggers = {
        { line = 119, message = "Appear", callback = "OnAppear" },
    },
    movement_commands = {
    },
}
map.scripts["arguecam1.scr"] = {
    source = "ARGUECAM1.scr",
    registered_triggers = {
        { line = 55, message = "Play", callback = "OnPlay" },
    },
    movement_commands = {
        { line = 35, command = "MoveToPos", arguments = "xpos Ypos Zpos nSpeed OnArrive" },
    },
}
map.scripts["arguetreaty.scr"] = {
    source = "ARGUETREATY.scr",
    registered_triggers = {
        { line = 48, message = "Play", callback = "OnPlay" },
    },
    movement_commands = {
        { line = 34, command = "MoveToPos", arguments = "xpos Ypos Zpos nSpeed DoNothing" },
    },
}
map.scripts["argument.scr"] = {
    source = "ARGUMENT.scr",
    registered_triggers = {
        { line = 759, message = "Done", callback = "OnDone" },
        { line = 760, message = "ForceStart", callback = "ForceStart" },
        { line = 761, message = "Start", callback = "Init" },
    },
    movement_commands = {
    },
}
map.scripts["bankorb.scr"] = {
    source = "BANKORB.scr",
    registered_triggers = {
        { line = 179, message = "Use", callback = "ONUse" },
    },
    movement_commands = {
    },
}
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
map.scripts["dorude.scr"] = {
    source = "DORUDE.scr",
    registered_triggers = {
        { line = 71, message = "Use", callback = "Onuse" },
    },
    movement_commands = {
    },
}
map.scripts["foradworld.scr"] = {
    source = "FORADWORLD.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["honkies.scr"] = {
    source = "HONKIES.scr",
    registered_triggers = {
        { line = 145, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["kirashield.scr"] = {
    source = "KIRASHIELD.scr",
    registered_triggers = {
        { line = 49, message = "Use", callback = "Onuse" },
    },
    movement_commands = {
    },
}
map.scripts["knutspeech.scr"] = {
    source = "KNUTSPEECH.scr",
    registered_triggers = {
        { line = 172, message = "blabber", callback = "Onblabber" },
        { line = 173, message = "Use", callback = "OnUse" },
        { line = 186, message = "GoPosition1", callback = "GoPosition1" },
        { line = 187, message = "GoPosition2", callback = "GoPosition2" },
        { line = 188, message = "GoPosition3", callback = "GoPosition3" },
        { line = 189, message = "GoPosition4", callback = "GoPosition4" },
    },
    movement_commands = {
        { line = 99, command = "SetPos", arguments = "g_hMyObject,3424.0 1344.0 -672.0" },
        { line = 107, command = "SetPos", arguments = "g_hMyObject,3494,1254,3166" },
        { line = 116, command = "SetPos", arguments = "g_hMyObject,-933,1254,2036" },
        { line = 125, command = "SetPos", arguments = "g_hMyObject,-2324,1254,4559" },
    },
}
map.scripts["npc239.scr"] = {
    source = "NPC239.scr",
    registered_triggers = {
        { line = 239, message = "Use", callback = "OnUse" },
        { line = 240, message = "KillMarkel", callback = "OnKillMarkel" },
    },
    movement_commands = {
    },
}
map.scripts["npc240.scr"] = {
    source = "NPC240.scr",
    registered_triggers = {
        { line = 53, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc241.scr"] = {
    source = "NPC241.scr",
    registered_triggers = {
        { line = 69, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc242.scr"] = {
    source = "NPC242.scr",
    registered_triggers = {
        { line = 95, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc246.scr"] = {
    source = "NPC246.scr",
    registered_triggers = {
        { line = 78, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc378.scr"] = {
    source = "NPC378.scr",
    registered_triggers = {
        { line = 281, message = "Use", callback = "OnUse" },
        { line = 282, message = "Appear", callback = "OnAppear" },
        { line = 283, message = "Appear2", callback = "OnAppear2" },
    },
    movement_commands = {
        { line = 108, command = "setpos", arguments = "g_hobject -2806 1240 5040" },
        { line = 144, command = "setpos", arguments = "g_hmyobject MyX MyY MyZ" },
        { line = 165, command = "setpos", arguments = "g_hmyobject XPos YPos ZPos" },
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
map.scripts["retainer.scr"] = {
    source = "RETAINER.scr",
    registered_triggers = {
        { line = 74, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["shopkeeper.scr"] = {
    source = "SHOPKEEPER.scr",
    registered_triggers = {
        { line = 50, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
        { line = 70, command = "SetPos", arguments = "g_hMyObject -6415 544 4768" },
    },
}
map.scripts["thronheimcity_actor.scr"] = {
    source = "THRONHEIMCITY_ACTOR.scr",
    registered_triggers = {
        { line = 64, message = "HereComesBadAss", callback = "OnHereComesBadAssShmoe" },
        { line = 153, message = "RunAwayFromMe", callback = "RunAwayFromBadAss" },
        { line = 154, message = "HereComesBadAss", callback = "OnHereComesBadAssBen" },
    },
    movement_commands = {
    },
}
map.scripts["thronheimcity_badass.scr"] = {
    source = "THRONHEIMCITY_BADASS.scr",
    registered_triggers = {
        { line = 304, message = "BreakOut", callback = "OnBreakOut" },
        { line = 305, message = "test", callback = "OnTest" },
    },
    movement_commands = {
    },
}
map.scripts["thronheimcity_guard.scr"] = {
    source = "THRONHEIMCITY_GUARD.scr",
    registered_triggers = {
        { line = 78, message = "ComeGetMe", callback = "GetBadAss" },
        { line = 79, message = "OpenEyes", callback = "OpenEyes" },
    },
    movement_commands = {
    },
}
map.scripts["townportal.scr"] = {
    source = "TOWNPORTAL.scr",
    registered_triggers = {
        { line = 103, message = "Use", callback = "OnUse" },
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
