-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "thjorgardcity"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 684,
        source_name = "ArenaExit",
        x = 9585,
        y = 11141,
        z = 164,
        direction_yaw_units = 0,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 687,
        source_name = "StartPoint0",
        x = 655,
        y = 164,
        z = 82,
        direction_yaw_units = 0,
        move_player_to_floor = true,
    },
    {
        start_index = 2,
        source_object_index = 688,
        source_name = "StartPointTerrain",
        x = -8028,
        y = 3277,
        z = 225,
        direction_yaw_units = 1764,
        move_player_to_floor = true,
    },
    {
        start_index = 3,
        source_object_index = 1109,
        source_name = "TownPortal",
        x = 82,
        y = 20808,
        z = 3850,
        direction_yaw_units = 1021,
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
        mechanism_id = 900000,
        event_id = 30000,
        source_object_index = 0,
        source_class = "RotatingDoor",
        source_name = "MeetingroomR",
        kind = "rotating_door",
        hint = "MeetingroomR",
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
        mechanism_id = 900001,
        event_id = 30001,
        source_object_index = 1,
        source_class = "RotatingDoor",
        source_name = "MeetingroomL",
        kind = "rotating_door",
        hint = "MeetingroomL",
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
        mechanism_id = 900002,
        event_id = 30002,
        source_object_index = 2,
        source_class = "RotatingDoor",
        source_name = "Officedoor",
        kind = "rotating_door",
        hint = "Officedoor",
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
        mechanism_id = 900003,
        event_id = 30003,
        source_object_index = 3,
        source_class = "RotatingDoor",
        source_name = "TownhallL",
        kind = "rotating_door",
        hint = "TownhallL",
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
        source_name = "TownhallR",
        kind = "rotating_door",
        hint = "TownhallR",
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
        source_class = "Door",
        source_name = "Door21",
        kind = "linear_door",
        hint = "Door21",
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
        mechanism_id = 900006,
        event_id = 30006,
        source_object_index = 6,
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
        mechanism_id = 900007,
        event_id = 30007,
        source_object_index = 7,
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
        mechanism_id = 900008,
        event_id = 30008,
        source_object_index = 8,
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
        mechanism_id = 900009,
        event_id = 30009,
        source_object_index = 9,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor10",
        kind = "rotating_door",
        hint = "RotatingDoor10",
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
        mechanism_id = 900010,
        event_id = 30010,
        source_object_index = 10,
        source_class = "DestructableBrush",
        source_name = "WorldObject1",
        kind = "destructible_brush",
        hint = "WorldObject1",
    },
    {
        mechanism_id = 900011,
        event_id = 30011,
        source_object_index = 11,
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
        mechanism_id = 900012,
        event_id = 30012,
        source_object_index = 12,
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
        mechanism_id = 900013,
        event_id = 30013,
        source_object_index = 13,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor5",
        kind = "rotating_door",
        hint = "RotatingDoor5",
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
        mechanism_id = 900015,
        event_id = 30015,
        source_object_index = 15,
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
        mechanism_id = 900016,
        event_id = 30016,
        source_object_index = 16,
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
        mechanism_id = 900017,
        event_id = 30017,
        source_object_index = 17,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor2",
        kind = "rotating_door",
        hint = "RotatingDoor2",
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
        mechanism_id = 900018,
        event_id = 30018,
        source_object_index = 18,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush54",
        kind = "destructible_brush",
        hint = "DestructableBrush54",
    },
    {
        mechanism_id = 900019,
        event_id = 30019,
        source_object_index = 19,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush52",
        kind = "destructible_brush",
        hint = "DestructableBrush52",
    },
    {
        mechanism_id = 900020,
        event_id = 30020,
        source_object_index = 20,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush53",
        kind = "destructible_brush",
        hint = "DestructableBrush53",
    },
    {
        mechanism_id = 900021,
        event_id = 30021,
        source_object_index = 21,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush51",
        kind = "destructible_brush",
        hint = "DestructableBrush51",
    },
    {
        mechanism_id = 900023,
        event_id = 30023,
        source_object_index = 23,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor22",
        kind = "rotating_door",
        hint = "RotatingDoor22",
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
        source_name = "RotatingDoor23",
        kind = "rotating_door",
        hint = "RotatingDoor23",
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
        source_class = "Door",
        source_name = "Door35",
        kind = "linear_door",
        hint = "Door35",
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
        mechanism_id = 900026,
        event_id = 30026,
        source_object_index = 26,
        source_class = "Door",
        source_name = "Door36",
        kind = "linear_door",
        hint = "Door36",
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
        mechanism_id = 900027,
        event_id = 30027,
        source_object_index = 27,
        source_class = "Door",
        source_name = "Door37",
        kind = "linear_door",
        hint = "Door37",
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
        mechanism_id = 900028,
        event_id = 30028,
        source_object_index = 28,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor24",
        kind = "rotating_door",
        hint = "RotatingDoor24",
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
        source_name = "RotatingDoor25",
        kind = "rotating_door",
        hint = "RotatingDoor25",
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
        source_name = "RotatingDoor26",
        kind = "rotating_door",
        hint = "RotatingDoor26",
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
        source_name = "RotatingDoor27",
        kind = "rotating_door",
        hint = "RotatingDoor27",
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
        mechanism_id = 900033,
        event_id = 30033,
        source_object_index = 33,
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
        mechanism_id = 900034,
        event_id = 30034,
        source_object_index = 34,
        source_class = "Door",
        source_name = "Door25",
        kind = "linear_door",
        hint = "Door25",
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
        mechanism_id = 900035,
        event_id = 30035,
        source_object_index = 35,
        source_class = "Door",
        source_name = "Door26",
        kind = "linear_door",
        hint = "Door26",
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
        source_class = "Door",
        source_name = "Door27",
        kind = "linear_door",
        hint = "Door27",
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
        mechanism_id = 900037,
        event_id = 30037,
        source_object_index = 37,
        source_class = "Door",
        source_name = "Door28",
        kind = "linear_door",
        hint = "Door28",
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
        mechanism_id = 900038,
        event_id = 30038,
        source_object_index = 38,
        source_class = "Door",
        source_name = "Door29",
        kind = "linear_door",
        hint = "Door29",
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
        mechanism_id = 900039,
        event_id = 30039,
        source_object_index = 39,
        source_class = "Door",
        source_name = "Door30",
        kind = "linear_door",
        hint = "Door30",
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
        mechanism_id = 900040,
        event_id = 30040,
        source_object_index = 40,
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
        mechanism_id = 900041,
        event_id = 30041,
        source_object_index = 41,
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
        mechanism_id = 900042,
        event_id = 30042,
        source_object_index = 42,
        source_class = "Door",
        source_name = "Door31",
        kind = "linear_door",
        hint = "Door31",
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
        mechanism_id = 900043,
        event_id = 30043,
        source_object_index = 43,
        source_class = "Door",
        source_name = "Door32",
        kind = "linear_door",
        hint = "Door32",
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
        mechanism_id = 900044,
        event_id = 30044,
        source_object_index = 44,
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
        mechanism_id = 900045,
        event_id = 30045,
        source_object_index = 45,
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
        mechanism_id = 900046,
        event_id = 30046,
        source_object_index = 46,
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
        mechanism_id = 900047,
        event_id = 30047,
        source_object_index = 47,
        source_class = "Door",
        source_name = "Door33",
        kind = "linear_door",
        hint = "Door33",
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
        mechanism_id = 900048,
        event_id = 30048,
        source_object_index = 48,
        source_class = "Door",
        source_name = "Door34",
        kind = "linear_door",
        hint = "Door34",
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
        mechanism_id = 900049,
        event_id = 30049,
        source_object_index = 49,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor18",
        kind = "rotating_door",
        hint = "RotatingDoor18",
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
        source_name = "RotatingDoor19",
        kind = "rotating_door",
        hint = "RotatingDoor19",
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
        source_name = "RotatingDoor20",
        kind = "rotating_door",
        hint = "RotatingDoor20",
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
        source_name = "RotatingDoor21",
        kind = "rotating_door",
        hint = "RotatingDoor21",
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
        source_name = "TempledoorL",
        kind = "rotating_door",
        hint = "TempledoorL",
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
        source_name = "TempledoorR",
        kind = "rotating_door",
        hint = "TempledoorR",
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
        mechanism_id = 900055,
        event_id = 30055,
        source_object_index = 55,
        source_class = "Door",
        source_name = "Door64",
        kind = "linear_door",
        hint = "Door64",
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
        mechanism_id = 900056,
        event_id = 30056,
        source_object_index = 56,
        source_class = "RotatingDoor",
        source_name = "ApothDoor0",
        kind = "rotating_door",
        hint = "ApothDoor0",
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
        source_class = "Door",
        source_name = "Door71",
        kind = "linear_door",
        hint = "Door71",
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
        mechanism_id = 900061,
        event_id = 30061,
        source_object_index = 61,
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
        mechanism_id = 900062,
        event_id = 30062,
        source_object_index = 62,
        source_class = "RotatingDoor",
        source_name = "BankdoorR",
        kind = "rotating_door",
        hint = "BankdoorR",
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
        mechanism_id = 900063,
        event_id = 30063,
        source_object_index = 63,
        source_class = "RotatingDoor",
        source_name = "BankdoorL",
        kind = "rotating_door",
        hint = "BankdoorL",
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
        mechanism_id = 900064,
        event_id = 30064,
        source_object_index = 64,
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
        mechanism_id = 900065,
        event_id = 30065,
        source_object_index = 65,
        source_class = "Door",
        source_name = "Door12",
        kind = "linear_door",
        hint = "Door12",
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
        mechanism_id = 900066,
        event_id = 30066,
        source_object_index = 66,
        source_class = "Door",
        source_name = "Door13",
        kind = "linear_door",
        hint = "Door13",
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
        mechanism_id = 900067,
        event_id = 30067,
        source_object_index = 67,
        source_class = "RotatingDoor",
        source_name = "StoredoorL",
        kind = "rotating_door",
        hint = "StoredoorL",
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
        mechanism_id = 900068,
        event_id = 30068,
        source_object_index = 68,
        source_class = "RotatingDoor",
        source_name = "StoredoorR",
        kind = "rotating_door",
        hint = "StoredoorR",
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
        mechanism_id = 900078,
        event_id = 30078,
        source_object_index = 78,
        source_class = "RotatingDoor",
        source_name = "LibrarydoorL",
        kind = "rotating_door",
        hint = "LibrarydoorL",
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
        mechanism_id = 900079,
        event_id = 30079,
        source_object_index = 79,
        source_class = "RotatingDoor",
        source_name = "LibrarydoorR",
        kind = "rotating_door",
        hint = "LibrarydoorR",
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
        mechanism_id = 900080,
        event_id = 30080,
        source_object_index = 80,
        source_class = "RotatingDoor",
        source_name = "MageDoorL",
        kind = "rotating_door",
        hint = "MageDoorL",
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
        mechanism_id = 900081,
        event_id = 30081,
        source_object_index = 81,
        source_class = "RotatingDoor",
        source_name = "MageDoorR",
        kind = "rotating_door",
        hint = "MageDoorR",
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
        mechanism_id = 900088,
        event_id = 30088,
        source_object_index = 88,
        source_class = "DestructableProp",
        source_name = "Beaker2",
        kind = "destructible_prop",
        hint = "Beaker2",
    },
    {
        mechanism_id = 900089,
        event_id = 30089,
        source_object_index = 89,
        source_class = "DestructableProp",
        source_name = "Beaker1",
        kind = "destructible_prop",
        hint = "Beaker1",
    },
    {
        mechanism_id = 900091,
        event_id = 30091,
        source_object_index = 91,
        source_class = "Door",
        source_name = "Door22",
        kind = "linear_door",
        hint = "Door22",
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
        mechanism_id = 900092,
        event_id = 30092,
        source_object_index = 92,
        source_class = "Door",
        source_name = "Door23",
        kind = "linear_door",
        hint = "Door23",
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
        mechanism_id = 900093,
        event_id = 30093,
        source_object_index = 93,
        source_class = "Door",
        source_name = "Door24",
        kind = "linear_door",
        hint = "Door24",
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
        mechanism_id = 900094,
        event_id = 30094,
        source_object_index = 94,
        source_class = "RotatingDoor",
        source_name = "THDLL",
        kind = "rotating_door",
        hint = "THDLL",
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
        mechanism_id = 900095,
        event_id = 30095,
        source_object_index = 95,
        source_class = "RotatingDoor",
        source_name = "THDRR",
        kind = "rotating_door",
        hint = "THDRR",
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
        mechanism_id = 900096,
        event_id = 30096,
        source_object_index = 96,
        source_class = "RotatingDoor",
        source_name = "THDLR",
        kind = "rotating_door",
        hint = "THDLR",
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
        mechanism_id = 900097,
        event_id = 30097,
        source_object_index = 97,
        source_class = "RotatingDoor",
        source_name = "THDRL",
        kind = "rotating_door",
        hint = "THDRL",
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
        mechanism_id = 900098,
        event_id = 30098,
        source_object_index = 98,
        source_class = "RotatingDoor",
        source_name = "TraininghalldoorR",
        kind = "rotating_door",
        hint = "TraininghalldoorR",
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
        source_name = "TraininghalldoorL",
        kind = "rotating_door",
        hint = "TraininghalldoorL",
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
        source_name = "Tavernstoreroom",
        kind = "rotating_door",
        hint = "Tavernstoreroom",
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
        source_name = "TavernkitchenL",
        kind = "rotating_door",
        hint = "TavernkitchenL",
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
        source_name = "TavernkitchenR",
        kind = "rotating_door",
        hint = "TavernkitchenR",
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
        source_class = "Door",
        source_name = "Door14",
        kind = "linear_door",
        hint = "Door14",
        sounds = {
            ["jiggle"] = {
                name = "Door/knock.wav",
                x = 0,
                y = 0,
                z = 3,
            },
        },
    },
    {
        mechanism_id = 900104,
        event_id = 30104,
        source_object_index = 104,
        source_class = "Door",
        source_name = "Door16",
        kind = "linear_door",
        hint = "Door16",
        sounds = {
            ["jiggle"] = {
                name = "Door/knock.wav",
                x = 0,
                y = 0,
                z = 3,
            },
        },
    },
    {
        mechanism_id = 900105,
        event_id = 30105,
        source_object_index = 105,
        source_class = "Door",
        source_name = "Door17",
        kind = "linear_door",
        hint = "Door17",
        sounds = {
            ["jiggle"] = {
                name = "Door/knock.wav",
                x = 0,
                y = 0,
                z = 3,
            },
        },
    },
    {
        mechanism_id = 900106,
        event_id = 30106,
        source_object_index = 106,
        source_class = "Door",
        source_name = "Door18",
        kind = "linear_door",
        hint = "Door18",
        sounds = {
            ["jiggle"] = {
                name = "Door/knock.wav",
                x = 0,
                y = 0,
                z = 3,
            },
        },
    },
    {
        mechanism_id = 900107,
        event_id = 30107,
        source_object_index = 107,
        source_class = "Door",
        source_name = "Door19",
        kind = "linear_door",
        hint = "Door19",
        sounds = {
            ["jiggle"] = {
                name = "Door/knock.wav",
                x = 0,
                y = 0,
                z = 3,
            },
        },
    },
    {
        mechanism_id = 900108,
        event_id = 30108,
        source_object_index = 108,
        source_class = "Door",
        source_name = "Door20",
        kind = "linear_door",
        hint = "Door20",
        sounds = {
            ["jiggle"] = {
                name = "Door/knock.wav",
                x = 0,
                y = 0,
                z = 3,
            },
        },
    },
    {
        mechanism_id = 900109,
        event_id = 30109,
        source_object_index = 109,
        source_class = "RotatingDoor",
        source_name = "TaverndoorL",
        kind = "rotating_door",
        hint = "TaverndoorL",
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
        mechanism_id = 900110,
        event_id = 30110,
        source_object_index = 110,
        source_class = "RotatingDoor",
        source_name = "TaverndoorR",
        kind = "rotating_door",
        hint = "TaverndoorR",
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
        mechanism_id = 900111,
        event_id = 30111,
        source_object_index = 111,
        source_class = "RotatingDoor",
        source_name = "Door15",
        kind = "rotating_door",
        hint = "Door15",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 3,
            },
            ["close_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 3,
            },
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 3,
            },
            ["jiggle"] = {
                name = "Door/knock.wav",
                x = 0,
                y = 0,
                z = 3,
            },
        },
    },
    {
        mechanism_id = 900112,
        event_id = 30112,
        source_object_index = 112,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush9",
        kind = "destructible_brush",
        hint = "DestructableBrush9",
    },
    {
        mechanism_id = 900113,
        event_id = 30113,
        source_object_index = 113,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush10",
        kind = "destructible_brush",
        hint = "DestructableBrush10",
    },
    {
        mechanism_id = 900114,
        event_id = 30114,
        source_object_index = 114,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush2",
        kind = "destructible_brush",
        hint = "DestructableBrush2",
    },
    {
        mechanism_id = 900115,
        event_id = 30115,
        source_object_index = 115,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush6",
        kind = "destructible_brush",
        hint = "DestructableBrush6",
    },
    {
        mechanism_id = 900116,
        event_id = 30116,
        source_object_index = 116,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush24",
        kind = "destructible_brush",
        hint = "DestructableBrush24",
    },
    {
        mechanism_id = 900117,
        event_id = 30117,
        source_object_index = 117,
        source_class = "RotatingDoor",
        source_name = "ArmorBeddoor0",
        kind = "rotating_door",
        hint = "ArmorBeddoor0",
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
        mechanism_id = 900118,
        event_id = 30118,
        source_object_index = 118,
        source_class = "RotatingDoor",
        source_name = "ForgedoorL0",
        kind = "rotating_door",
        hint = "ForgedoorL0",
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
        mechanism_id = 900119,
        event_id = 30119,
        source_object_index = 119,
        source_class = "RotatingDoor",
        source_name = "ForgedoorR0",
        kind = "rotating_door",
        hint = "ForgedoorR0",
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
        mechanism_id = 900120,
        event_id = 30120,
        source_object_index = 120,
        source_class = "RotatingDoor",
        source_name = "Weapon-Forge0",
        kind = "rotating_door",
        hint = "Weapon-Forge0",
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
        mechanism_id = 900121,
        event_id = 30121,
        source_object_index = 121,
        source_class = "RotatingDoor",
        source_name = "Armor-Forge0",
        kind = "rotating_door",
        hint = "Armor-Forge0",
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
        mechanism_id = 900122,
        event_id = 30122,
        source_object_index = 122,
        source_class = "RotatingDoor",
        source_name = "WeapondoorR0",
        kind = "rotating_door",
        hint = "WeapondoorR0",
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
        mechanism_id = 900123,
        event_id = 30123,
        source_object_index = 123,
        source_class = "RotatingDoor",
        source_name = "WeapondoorL0",
        kind = "rotating_door",
        hint = "WeapondoorL0",
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
        mechanism_id = 900124,
        event_id = 30124,
        source_object_index = 124,
        source_class = "RotatingDoor",
        source_name = "ArmordoorL0",
        kind = "rotating_door",
        hint = "ArmordoorL0",
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
        mechanism_id = 900125,
        event_id = 30125,
        source_object_index = 125,
        source_class = "RotatingDoor",
        source_name = "ArmordoorR0",
        kind = "rotating_door",
        hint = "ArmordoorR0",
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
        mechanism_id = 900126,
        event_id = 30126,
        source_object_index = 126,
        source_class = "RotatingDoor",
        source_name = "WeaponBeddoor0",
        kind = "rotating_door",
        hint = "WeaponBeddoor0",
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
        mechanism_id = 900128,
        event_id = 30128,
        source_object_index = 128,
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
        mechanism_id = 900129,
        event_id = 30129,
        source_object_index = 129,
        source_class = "Door",
        source_name = "Door5",
        kind = "linear_door",
        hint = "Door5",
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
        mechanism_id = 900130,
        event_id = 30130,
        source_object_index = 130,
        source_class = "RotatingDoor",
        source_name = "BembStudy1",
        kind = "rotating_door",
        hint = "BembStudy1",
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
        mechanism_id = 900131,
        event_id = 30131,
        source_object_index = 131,
        source_class = "RotatingDoor",
        source_name = "BembStudy2",
        kind = "rotating_door",
        hint = "BembStudy2",
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
        mechanism_id = 900132,
        event_id = 30132,
        source_object_index = 132,
        source_class = "Door",
        source_name = "Door6",
        kind = "linear_door",
        hint = "Door6",
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
        mechanism_id = 900133,
        event_id = 30133,
        source_object_index = 133,
        source_class = "Door",
        source_name = "Door7",
        kind = "linear_door",
        hint = "Door7",
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
        mechanism_id = 900134,
        event_id = 30134,
        source_object_index = 134,
        source_class = "Door",
        source_name = "Door8",
        kind = "linear_door",
        hint = "Door8",
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
        mechanism_id = 900135,
        event_id = 30135,
        source_object_index = 135,
        source_class = "Door",
        source_name = "Door9",
        kind = "linear_door",
        hint = "Door9",
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
        mechanism_id = 900136,
        event_id = 30136,
        source_object_index = 136,
        source_class = "Door",
        source_name = "Door10",
        kind = "linear_door",
        hint = "Door10",
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
        mechanism_id = 900137,
        event_id = 30137,
        source_object_index = 137,
        source_class = "RotatingDoor",
        source_name = "HearingroomR",
        kind = "rotating_door",
        hint = "HearingroomR",
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
        source_class = "RotatingDoor",
        source_name = "HearingroomL",
        kind = "rotating_door",
        hint = "HearingroomL",
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
        source_class = "Door",
        source_name = "Door11",
        kind = "linear_door",
        hint = "Door11",
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
        mechanism_id = 900140,
        event_id = 30140,
        source_object_index = 140,
        source_class = "RotatingDoor",
        source_name = "BembdoorR",
        kind = "rotating_door",
        hint = "BembdoorR",
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
        mechanism_id = 900141,
        event_id = 30141,
        source_object_index = 141,
        source_class = "RotatingDoor",
        source_name = "BembdoorL",
        kind = "rotating_door",
        hint = "BembdoorL",
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
        mechanism_id = 900142,
        event_id = 30142,
        source_object_index = 142,
        source_class = "RotatingDoor",
        source_name = "BembgateR",
        kind = "rotating_door",
        hint = "BembgateR",
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
        mechanism_id = 900143,
        event_id = 30143,
        source_object_index = 143,
        source_class = "RotatingDoor",
        source_name = "BembgateL",
        kind = "rotating_door",
        hint = "BembgateL",
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
        mechanism_id = 900144,
        event_id = 30144,
        source_object_index = 144,
        source_class = "RotatingDoor",
        source_name = "PalacedoorL",
        kind = "rotating_door",
        hint = "PalacedoorL",
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
        mechanism_id = 900145,
        event_id = 30145,
        source_object_index = 145,
        source_class = "RotatingDoor",
        source_name = "PalacedoorR",
        kind = "rotating_door",
        hint = "PalacedoorR",
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
        mechanism_id = 900146,
        event_id = 30146,
        source_object_index = 146,
        source_class = "Door",
        source_name = "Door65",
        kind = "linear_door",
        hint = "Door65",
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
        mechanism_id = 900147,
        event_id = 30147,
        source_object_index = 147,
        source_class = "Door",
        source_name = "Door66",
        kind = "linear_door",
        hint = "Door66",
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
        mechanism_id = 900148,
        event_id = 30148,
        source_object_index = 148,
        source_class = "Door",
        source_name = "Door67",
        kind = "linear_door",
        hint = "Door67",
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
        mechanism_id = 900149,
        event_id = 30149,
        source_object_index = 149,
        source_class = "Door",
        source_name = "Door68",
        kind = "linear_door",
        hint = "Door68",
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
        mechanism_id = 900150,
        event_id = 30150,
        source_object_index = 150,
        source_class = "Door",
        source_name = "Door69",
        kind = "linear_door",
        hint = "Door69",
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
        mechanism_id = 900151,
        event_id = 30151,
        source_object_index = 151,
        source_class = "Door",
        source_name = "Door70",
        kind = "linear_door",
        hint = "Door70",
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
        mechanism_id = 900156,
        event_id = 30156,
        source_object_index = 156,
        source_class = "Door",
        source_name = "Door38",
        kind = "linear_door",
        hint = "Door38",
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
        mechanism_id = 900157,
        event_id = 30157,
        source_object_index = 157,
        source_class = "Door",
        source_name = "Door39",
        kind = "linear_door",
        hint = "Door39",
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
        mechanism_id = 900158,
        event_id = 30158,
        source_object_index = 158,
        source_class = "Door",
        source_name = "Door40",
        kind = "linear_door",
        hint = "Door40",
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
        mechanism_id = 900160,
        event_id = 30160,
        source_object_index = 160,
        source_class = "Door",
        source_name = "Door41",
        kind = "linear_door",
        hint = "Door41",
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
        mechanism_id = 900161,
        event_id = 30161,
        source_object_index = 161,
        source_class = "Door",
        source_name = "Door42",
        kind = "linear_door",
        hint = "Door42",
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
        mechanism_id = 900162,
        event_id = 30162,
        source_object_index = 162,
        source_class = "Door",
        source_name = "Door43",
        kind = "linear_door",
        hint = "Door43",
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
        mechanism_id = 900163,
        event_id = 30163,
        source_object_index = 163,
        source_class = "Door",
        source_name = "Door44",
        kind = "linear_door",
        hint = "Door44",
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
        mechanism_id = 900165,
        event_id = 30165,
        source_object_index = 165,
        source_class = "Door",
        source_name = "Door45",
        kind = "linear_door",
        hint = "Door45",
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
        mechanism_id = 900166,
        event_id = 30166,
        source_object_index = 166,
        source_class = "Door",
        source_name = "Door46",
        kind = "linear_door",
        hint = "Door46",
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
        mechanism_id = 900167,
        event_id = 30167,
        source_object_index = 167,
        source_class = "Door",
        source_name = "Door47",
        kind = "linear_door",
        hint = "Door47",
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
        mechanism_id = 900168,
        event_id = 30168,
        source_object_index = 168,
        source_class = "Door",
        source_name = "Door48",
        kind = "linear_door",
        hint = "Door48",
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
        mechanism_id = 900169,
        event_id = 30169,
        source_object_index = 169,
        source_class = "Door",
        source_name = "Door49",
        kind = "linear_door",
        hint = "Door49",
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
        mechanism_id = 900170,
        event_id = 30170,
        source_object_index = 170,
        source_class = "Door",
        source_name = "Door50",
        kind = "linear_door",
        hint = "Door50",
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
        mechanism_id = 900171,
        event_id = 30171,
        source_object_index = 171,
        source_class = "Door",
        source_name = "Door51",
        kind = "linear_door",
        hint = "Door51",
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
        mechanism_id = 900172,
        event_id = 30172,
        source_object_index = 172,
        source_class = "Door",
        source_name = "Door52",
        kind = "linear_door",
        hint = "Door52",
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
        mechanism_id = 900174,
        event_id = 30174,
        source_object_index = 174,
        source_class = "Door",
        source_name = "Door54",
        kind = "linear_door",
        hint = "Door54",
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
        mechanism_id = 900175,
        event_id = 30175,
        source_object_index = 175,
        source_class = "Door",
        source_name = "Door53",
        kind = "linear_door",
        hint = "Door53",
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
        mechanism_id = 900176,
        event_id = 30176,
        source_object_index = 176,
        source_class = "Door",
        source_name = "Door55",
        kind = "linear_door",
        hint = "Door55",
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
        mechanism_id = 900177,
        event_id = 30177,
        source_object_index = 177,
        source_class = "Door",
        source_name = "Door56",
        kind = "linear_door",
        hint = "Door56",
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
        mechanism_id = 900178,
        event_id = 30178,
        source_object_index = 178,
        source_class = "Door",
        source_name = "Door57",
        kind = "linear_door",
        hint = "Door57",
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
        mechanism_id = 900180,
        event_id = 30180,
        source_object_index = 180,
        source_class = "Door",
        source_name = "Door58",
        kind = "linear_door",
        hint = "Door58",
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
        mechanism_id = 900181,
        event_id = 30181,
        source_object_index = 181,
        source_class = "Door",
        source_name = "Door59",
        kind = "linear_door",
        hint = "Door59",
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
        mechanism_id = 900182,
        event_id = 30182,
        source_object_index = 182,
        source_class = "Door",
        source_name = "Door60",
        kind = "linear_door",
        hint = "Door60",
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
        mechanism_id = 900183,
        event_id = 30183,
        source_object_index = 183,
        source_class = "Door",
        source_name = "Door61",
        kind = "linear_door",
        hint = "Door61",
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
        mechanism_id = 900184,
        event_id = 30184,
        source_object_index = 184,
        source_class = "Door",
        source_name = "Door62",
        kind = "linear_door",
        hint = "Door62",
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
        mechanism_id = 900185,
        event_id = 30185,
        source_object_index = 185,
        source_class = "Door",
        source_name = "Door63",
        kind = "linear_door",
        hint = "Door63",
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
        mechanism_id = 900204,
        event_id = 30204,
        source_object_index = 204,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900340,
        event_id = 30340,
        source_object_index = 340,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900341,
        event_id = 30341,
        source_object_index = 341,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900345,
        event_id = 30345,
        source_object_index = 345,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 900367,
        event_id = 30367,
        source_object_index = 367,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 900368,
        event_id = 30368,
        source_object_index = 368,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 900386,
        event_id = 30386,
        source_object_index = 386,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush6",
        kind = "collision_volume",
        hint = "InvisibleBrush6",
    },
    {
        mechanism_id = 900397,
        event_id = 30397,
        source_object_index = 397,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900398,
        event_id = 30398,
        source_object_index = 398,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 900425,
        event_id = 30425,
        source_object_index = 425,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush7",
        kind = "collision_volume",
        hint = "InvisibleBrush7",
    },
    {
        mechanism_id = 900440,
        event_id = 30440,
        source_object_index = 440,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush8",
        kind = "collision_volume",
        hint = "InvisibleBrush8",
    },
    {
        mechanism_id = 900590,
        event_id = 30590,
        source_object_index = 590,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush9",
        kind = "collision_volume",
        hint = "InvisibleBrush9",
    },
    {
        mechanism_id = 900608,
        event_id = 30608,
        source_object_index = 608,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush10",
        kind = "collision_volume",
        hint = "InvisibleBrush10",
    },
    {
        mechanism_id = 900663,
        event_id = 30663,
        source_object_index = 663,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush11",
        kind = "collision_volume",
        hint = "InvisibleBrush11",
    },
    {
        mechanism_id = 900664,
        event_id = 30664,
        source_object_index = 664,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush12",
        kind = "collision_volume",
        hint = "InvisibleBrush12",
    },
    {
        mechanism_id = 900668,
        event_id = 30668,
        source_object_index = 668,
        source_class = "AIBarrier",
        source_name = "AIBarrier4",
        kind = "ai_barrier",
        hint = "AIBarrier4",
    },
    {
        mechanism_id = 900669,
        event_id = 30669,
        source_object_index = 669,
        source_class = "AIBarrier",
        source_name = "AIBarrier6",
        kind = "ai_barrier",
        hint = "AIBarrier6",
    },
    {
        mechanism_id = 900670,
        event_id = 30670,
        source_object_index = 670,
        source_class = "AIBarrier",
        source_name = "AIBarrier5",
        kind = "ai_barrier",
        hint = "AIBarrier5",
    },
    {
        mechanism_id = 900682,
        event_id = 30682,
        source_object_index = 682,
        source_class = "AIBarrier",
        source_name = "AIBarrier2",
        kind = "ai_barrier",
        hint = "AIBarrier2",
    },
    {
        mechanism_id = 900683,
        event_id = 30683,
        source_object_index = 683,
        source_class = "AIBarrier",
        source_name = "AIBarrier3",
        kind = "ai_barrier",
        hint = "AIBarrier3",
    },
    {
        mechanism_id = 900686,
        event_id = 30686,
        source_object_index = 686,
        source_class = "ScriptObject",
        source_name = "ScriptObject0",
        kind = "script_object",
        hint = "ScriptObject0",
    },
    {
        mechanism_id = 901006,
        event_id = 31006,
        source_object_index = 1006,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush15",
        kind = "collision_volume",
        hint = "InvisibleBrush15",
    },
    {
        mechanism_id = 901007,
        event_id = 31007,
        source_object_index = 1007,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush14",
        kind = "collision_volume",
        hint = "InvisibleBrush14",
    },
    {
        mechanism_id = 901008,
        event_id = 31008,
        source_object_index = 1008,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush13",
        kind = "collision_volume",
        hint = "InvisibleBrush13",
    },
    {
        mechanism_id = 901020,
        event_id = 31020,
        source_object_index = 1020,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 901021,
        event_id = 31021,
        source_object_index = 1021,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 901022,
        event_id = 31022,
        source_object_index = 1022,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 901023,
        event_id = 31023,
        source_object_index = 1023,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 901024,
        event_id = 31024,
        source_object_index = 1024,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 901025,
        event_id = 31025,
        source_object_index = 1025,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 901026,
        event_id = 31026,
        source_object_index = 1026,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 901027,
        event_id = 31027,
        source_object_index = 1027,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush7",
        kind = "perception_brush",
        hint = "PerceptionBrush7",
    },
    {
        mechanism_id = 901028,
        event_id = 31028,
        source_object_index = 1028,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush8",
        kind = "perception_brush",
        hint = "PerceptionBrush8",
    },
    {
        mechanism_id = 901029,
        event_id = 31029,
        source_object_index = 1029,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush9",
        kind = "perception_brush",
        hint = "PerceptionBrush9",
    },
    {
        mechanism_id = 901030,
        event_id = 31030,
        source_object_index = 1030,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush10",
        kind = "perception_brush",
        hint = "PerceptionBrush10",
    },
    {
        mechanism_id = 901031,
        event_id = 31031,
        source_object_index = 1031,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush11",
        kind = "perception_brush",
        hint = "PerceptionBrush11",
    },
    {
        mechanism_id = 901032,
        event_id = 31032,
        source_object_index = 1032,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush12",
        kind = "perception_brush",
        hint = "PerceptionBrush12",
    },
    {
        mechanism_id = 901033,
        event_id = 31033,
        source_object_index = 1033,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush13",
        kind = "perception_brush",
        hint = "PerceptionBrush13",
    },
    {
        mechanism_id = 901034,
        event_id = 31034,
        source_object_index = 1034,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush14",
        kind = "perception_brush",
        hint = "PerceptionBrush14",
    },
    {
        mechanism_id = 901035,
        event_id = 31035,
        source_object_index = 1035,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush15",
        kind = "perception_brush",
        hint = "PerceptionBrush15",
    },
    {
        mechanism_id = 901036,
        event_id = 31036,
        source_object_index = 1036,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush16",
        kind = "perception_brush",
        hint = "PerceptionBrush16",
    },
    {
        mechanism_id = 901037,
        event_id = 31037,
        source_object_index = 1037,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush17",
        kind = "perception_brush",
        hint = "PerceptionBrush17",
    },
    {
        mechanism_id = 901038,
        event_id = 31038,
        source_object_index = 1038,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush18",
        kind = "perception_brush",
        hint = "PerceptionBrush18",
    },
    {
        mechanism_id = 901039,
        event_id = 31039,
        source_object_index = 1039,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush19",
        kind = "perception_brush",
        hint = "PerceptionBrush19",
    },
    {
        mechanism_id = 901040,
        event_id = 31040,
        source_object_index = 1040,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush20",
        kind = "perception_brush",
        hint = "PerceptionBrush20",
    },
    {
        mechanism_id = 901041,
        event_id = 31041,
        source_object_index = 1041,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush23",
        kind = "perception_brush",
        hint = "PerceptionBrush23",
    },
    {
        mechanism_id = 901042,
        event_id = 31042,
        source_object_index = 1042,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush22",
        kind = "perception_brush",
        hint = "PerceptionBrush22",
    },
    {
        mechanism_id = 901043,
        event_id = 31043,
        source_object_index = 1043,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush21",
        kind = "perception_brush",
        hint = "PerceptionBrush21",
    },
    {
        mechanism_id = 901095,
        event_id = 31095,
        source_object_index = 1095,
        source_class = "RotatingDoor",
        source_name = "BembStudy3",
        kind = "rotating_door",
        hint = "BembStudy3",
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
    [30000] = { kind = "open_door", source = "mm9_mechanism", targetName = "MeetingroomR" },
    [30001] = { kind = "open_door", source = "mm9_mechanism", targetName = "MeetingroomL" },
    [30002] = { kind = "open_door", source = "mm9_mechanism", targetName = "Officedoor" },
    [30003] = { kind = "open_door", source = "mm9_mechanism", targetName = "TownhallL" },
    [30004] = { kind = "open_door", source = "mm9_mechanism", targetName = "TownhallR" },
    [30005] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door21" },
    [30006] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor7" },
    [30007] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor8" },
    [30008] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor9" },
    [30009] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor10" },
    [30011] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor3" },
    [30012] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor4" },
    [30013] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor5" },
    [30014] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor6" },
    [30015] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0" },
    [30016] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor1" },
    [30017] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor2" },
    [30023] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor22" },
    [30024] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor23" },
    [30025] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door35" },
    [30026] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door36" },
    [30027] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door37" },
    [30028] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor24" },
    [30029] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor25" },
    [30030] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor26" },
    [30031] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor27" },
    [30032] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor11" },
    [30033] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor12" },
    [30034] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door25" },
    [30035] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door26" },
    [30036] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door27" },
    [30037] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door28" },
    [30038] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door29" },
    [30039] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door30" },
    [30040] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor13" },
    [30041] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor14" },
    [30042] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door31" },
    [30043] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door32" },
    [30044] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor15" },
    [30045] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor16" },
    [30046] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor17" },
    [30047] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door33" },
    [30048] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door34" },
    [30049] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor18" },
    [30050] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor19" },
    [30051] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor20" },
    [30052] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor21" },
    [30053] = { kind = "open_door", source = "mm9_mechanism", targetName = "TempledoorL" },
    [30054] = { kind = "open_door", source = "mm9_mechanism", targetName = "TempledoorR" },
    [30055] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door64" },
    [30056] = { kind = "open_door", source = "mm9_mechanism", targetName = "ApothDoor0" },
    [30057] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door71" },
    [30061] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door2" },
    [30062] = { kind = "open_door", source = "mm9_mechanism", targetName = "BankdoorR" },
    [30063] = { kind = "open_door", source = "mm9_mechanism", targetName = "BankdoorL" },
    [30064] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door3" },
    [30065] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door12" },
    [30066] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door13" },
    [30067] = { kind = "open_door", source = "mm9_mechanism", targetName = "StoredoorL" },
    [30068] = { kind = "open_door", source = "mm9_mechanism", targetName = "StoredoorR" },
    [30078] = { kind = "open_door", source = "mm9_mechanism", targetName = "LibrarydoorL" },
    [30079] = { kind = "open_door", source = "mm9_mechanism", targetName = "LibrarydoorR" },
    [30080] = { kind = "open_door", source = "mm9_mechanism", targetName = "MageDoorL" },
    [30081] = { kind = "open_door", source = "mm9_mechanism", targetName = "MageDoorR" },
    [30091] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door22" },
    [30092] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door23" },
    [30093] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door24" },
    [30094] = { kind = "open_door", source = "mm9_mechanism", targetName = "THDLL" },
    [30095] = { kind = "open_door", source = "mm9_mechanism", targetName = "THDRR" },
    [30096] = { kind = "open_door", source = "mm9_mechanism", targetName = "THDLR" },
    [30097] = { kind = "open_door", source = "mm9_mechanism", targetName = "THDRL" },
    [30098] = { kind = "open_door", source = "mm9_mechanism", targetName = "TraininghalldoorR" },
    [30099] = { kind = "open_door", source = "mm9_mechanism", targetName = "TraininghalldoorL" },
    [30100] = { kind = "open_door", source = "mm9_mechanism", targetName = "Tavernstoreroom" },
    [30101] = { kind = "open_door", source = "mm9_mechanism", targetName = "TavernkitchenL" },
    [30102] = { kind = "open_door", source = "mm9_mechanism", targetName = "TavernkitchenR" },
    [30103] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door14" },
    [30104] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door16" },
    [30105] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door17" },
    [30106] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door18" },
    [30107] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door19" },
    [30108] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door20" },
    [30109] = { kind = "open_door", source = "mm9_mechanism", targetName = "TaverndoorL" },
    [30110] = { kind = "open_door", source = "mm9_mechanism", targetName = "TaverndoorR" },
    [30111] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door15" },
    [30117] = { kind = "open_door", source = "mm9_mechanism", targetName = "ArmorBeddoor0" },
    [30118] = { kind = "open_door", source = "mm9_mechanism", targetName = "ForgedoorL0" },
    [30119] = { kind = "open_door", source = "mm9_mechanism", targetName = "ForgedoorR0" },
    [30120] = { kind = "open_door", source = "mm9_mechanism", targetName = "Weapon-Forge0" },
    [30121] = { kind = "open_door", source = "mm9_mechanism", targetName = "Armor-Forge0" },
    [30122] = { kind = "open_door", source = "mm9_mechanism", targetName = "WeapondoorR0" },
    [30123] = { kind = "open_door", source = "mm9_mechanism", targetName = "WeapondoorL0" },
    [30124] = { kind = "open_door", source = "mm9_mechanism", targetName = "ArmordoorL0" },
    [30125] = { kind = "open_door", source = "mm9_mechanism", targetName = "ArmordoorR0" },
    [30126] = { kind = "open_door", source = "mm9_mechanism", targetName = "WeaponBeddoor0" },
    [30128] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door4" },
    [30129] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door5" },
    [30130] = { kind = "open_door", source = "mm9_mechanism", targetName = "BembStudy1" },
    [30131] = { kind = "open_door", source = "mm9_mechanism", targetName = "BembStudy2" },
    [30132] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door6" },
    [30133] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door7" },
    [30134] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door8" },
    [30135] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door9" },
    [30136] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door10" },
    [30137] = { kind = "open_door", source = "mm9_mechanism", targetName = "HearingroomR" },
    [30138] = { kind = "open_door", source = "mm9_mechanism", targetName = "HearingroomL" },
    [30139] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door11" },
    [30140] = { kind = "open_door", source = "mm9_mechanism", targetName = "BembdoorR" },
    [30141] = { kind = "open_door", source = "mm9_mechanism", targetName = "BembdoorL" },
    [30142] = { kind = "open_door", source = "mm9_mechanism", targetName = "BembgateR" },
    [30143] = { kind = "open_door", source = "mm9_mechanism", targetName = "BembgateL" },
    [30144] = { kind = "open_door", source = "mm9_mechanism", targetName = "PalacedoorL" },
    [30145] = { kind = "open_door", source = "mm9_mechanism", targetName = "PalacedoorR" },
    [30146] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door65" },
    [30147] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door66" },
    [30148] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door67" },
    [30149] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door68" },
    [30150] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door69" },
    [30151] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door70" },
    [30156] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door38" },
    [30157] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door39" },
    [30158] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door40" },
    [30160] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door41" },
    [30161] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door42" },
    [30162] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door43" },
    [30163] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door44" },
    [30165] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door45" },
    [30166] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door46" },
    [30167] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door47" },
    [30168] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door48" },
    [30169] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door49" },
    [30170] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door50" },
    [30171] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door51" },
    [30172] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door52" },
    [30174] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door54" },
    [30175] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door53" },
    [30176] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door55" },
    [30177] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door56" },
    [30178] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door57" },
    [30180] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door58" },
    [30181] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door59" },
    [30182] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door60" },
    [30183] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door61" },
    [30184] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door62" },
    [30185] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door63" },
    [31095] = { kind = "open_door", source = "mm9_mechanism", targetName = "BembStudy3" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30000, "MeetingroomR", function()
    map.triggerMechanism(0, 2)
end, "MeetingroomR")

RegisterEvent(30001, "MeetingroomL", function()
    map.triggerMechanism(1, 2)
end, "MeetingroomL")

RegisterEvent(30002, "Officedoor", function()
    map.triggerMechanism(2, 2)
end, "Officedoor")

RegisterEvent(30003, "TownhallL", function()
    map.triggerMechanism(3, 2)
end, "TownhallL")

RegisterEvent(30004, "TownhallR", function()
    map.triggerMechanism(4, 2)
end, "TownhallR")

RegisterEvent(30005, "Door21", function()
    map.triggerMechanism(5, 2)
end, "Door21")

RegisterEvent(30006, "RotatingDoor7", function()
    map.triggerMechanism(6, 2)
end, "RotatingDoor7")

RegisterEvent(30007, "RotatingDoor8", function()
    map.triggerMechanism(7, 2)
end, "RotatingDoor8")

RegisterEvent(30008, "RotatingDoor9", function()
    map.triggerMechanism(8, 2)
end, "RotatingDoor9")

RegisterEvent(30009, "RotatingDoor10", function()
    map.triggerMechanism(9, 2)
end, "RotatingDoor10")

RegisterEvent(30011, "RotatingDoor3", function()
    map.triggerMechanism(11, 2)
end, "RotatingDoor3")

RegisterEvent(30012, "RotatingDoor4", function()
    map.triggerMechanism(12, 2)
end, "RotatingDoor4")

RegisterEvent(30013, "RotatingDoor5", function()
    map.triggerMechanism(13, 2)
end, "RotatingDoor5")

RegisterEvent(30014, "RotatingDoor6", function()
    map.triggerMechanism(14, 2)
end, "RotatingDoor6")

RegisterEvent(30015, "RotatingDoor0", function()
    map.triggerMechanism(15, 2)
end, "RotatingDoor0")

RegisterEvent(30016, "RotatingDoor1", function()
    map.triggerMechanism(16, 2)
end, "RotatingDoor1")

RegisterEvent(30017, "RotatingDoor2", function()
    map.triggerMechanism(17, 2)
end, "RotatingDoor2")

RegisterEvent(30023, "RotatingDoor22", function()
    map.triggerMechanism(23, 2)
end, "RotatingDoor22")

RegisterEvent(30024, "RotatingDoor23", function()
    map.triggerMechanism(24, 2)
end, "RotatingDoor23")

RegisterEvent(30025, "Door35", function()
    map.triggerMechanism(25, 2)
end, "Door35")

RegisterEvent(30026, "Door36", function()
    map.triggerMechanism(26, 2)
end, "Door36")

RegisterEvent(30027, "Door37", function()
    map.triggerMechanism(27, 2)
end, "Door37")

RegisterEvent(30028, "RotatingDoor24", function()
    map.triggerMechanism(28, 2)
end, "RotatingDoor24")

RegisterEvent(30029, "RotatingDoor25", function()
    map.triggerMechanism(29, 2)
end, "RotatingDoor25")

RegisterEvent(30030, "RotatingDoor26", function()
    map.triggerMechanism(30, 2)
end, "RotatingDoor26")

RegisterEvent(30031, "RotatingDoor27", function()
    map.triggerMechanism(31, 2)
end, "RotatingDoor27")

RegisterEvent(30032, "RotatingDoor11", function()
    map.triggerMechanism(32, 2)
end, "RotatingDoor11")

RegisterEvent(30033, "RotatingDoor12", function()
    map.triggerMechanism(33, 2)
end, "RotatingDoor12")

RegisterEvent(30034, "Door25", function()
    map.triggerMechanism(34, 2)
end, "Door25")

RegisterEvent(30035, "Door26", function()
    map.triggerMechanism(35, 2)
end, "Door26")

RegisterEvent(30036, "Door27", function()
    map.triggerMechanism(36, 2)
end, "Door27")

RegisterEvent(30037, "Door28", function()
    map.triggerMechanism(37, 2)
end, "Door28")

RegisterEvent(30038, "Door29", function()
    map.triggerMechanism(38, 2)
end, "Door29")

RegisterEvent(30039, "Door30", function()
    map.triggerMechanism(39, 2)
end, "Door30")

RegisterEvent(30040, "RotatingDoor13", function()
    map.triggerMechanism(40, 2)
end, "RotatingDoor13")

RegisterEvent(30041, "RotatingDoor14", function()
    map.triggerMechanism(41, 2)
end, "RotatingDoor14")

RegisterEvent(30042, "Door31", function()
    map.triggerMechanism(42, 2)
end, "Door31")

RegisterEvent(30043, "Door32", function()
    map.triggerMechanism(43, 2)
end, "Door32")

RegisterEvent(30044, "RotatingDoor15", function()
    map.triggerMechanism(44, 2)
end, "RotatingDoor15")

RegisterEvent(30045, "RotatingDoor16", function()
    map.triggerMechanism(45, 2)
end, "RotatingDoor16")

RegisterEvent(30046, "RotatingDoor17", function()
    map.triggerMechanism(46, 2)
end, "RotatingDoor17")

RegisterEvent(30047, "Door33", function()
    map.triggerMechanism(47, 2)
end, "Door33")

RegisterEvent(30048, "Door34", function()
    map.triggerMechanism(48, 2)
end, "Door34")

RegisterEvent(30049, "RotatingDoor18", function()
    map.triggerMechanism(49, 2)
end, "RotatingDoor18")

RegisterEvent(30050, "RotatingDoor19", function()
    map.triggerMechanism(50, 2)
end, "RotatingDoor19")

RegisterEvent(30051, "RotatingDoor20", function()
    map.triggerMechanism(51, 2)
end, "RotatingDoor20")

RegisterEvent(30052, "RotatingDoor21", function()
    map.triggerMechanism(52, 2)
end, "RotatingDoor21")

RegisterEvent(30053, "TempledoorL", function()
    map.triggerMechanism(53, 2)
end, "TempledoorL")

RegisterEvent(30054, "TempledoorR", function()
    map.triggerMechanism(54, 2)
end, "TempledoorR")

RegisterEvent(30055, "Door64", function()
    map.triggerMechanism(55, 2)
end, "Door64")

RegisterEvent(30056, "ApothDoor0", function()
    map.triggerMechanism(56, 2)
end, "ApothDoor0")

RegisterEvent(30057, "Door71", function()
    map.triggerMechanism(57, 2)
end, "Door71")

RegisterEvent(30061, "Door2", function()
    map.triggerMechanism(61, 2)
end, "Door2")

RegisterEvent(30062, "BankdoorR", function()
    map.triggerMechanism(62, 2)
end, "BankdoorR")

RegisterEvent(30063, "BankdoorL", function()
    map.triggerMechanism(63, 2)
end, "BankdoorL")

RegisterEvent(30064, "Door3", function()
    map.triggerMechanism(64, 2)
end, "Door3")

RegisterEvent(30065, "Door12", function()
    map.triggerMechanism(65, 2)
end, "Door12")

RegisterEvent(30066, "Door13", function()
    map.triggerMechanism(66, 2)
end, "Door13")

RegisterEvent(30067, "StoredoorL", function()
    map.triggerMechanism(67, 2)
end, "StoredoorL")

RegisterEvent(30068, "StoredoorR", function()
    map.triggerMechanism(68, 2)
end, "StoredoorR")

RegisterEvent(30078, "LibrarydoorL", function()
    map.triggerMechanism(78, 2)
end, "LibrarydoorL")

RegisterEvent(30079, "LibrarydoorR", function()
    map.triggerMechanism(79, 2)
end, "LibrarydoorR")

RegisterEvent(30080, "MageDoorL", function()
    map.triggerMechanism(80, 2)
end, "MageDoorL")

RegisterEvent(30081, "MageDoorR", function()
    map.triggerMechanism(81, 2)
end, "MageDoorR")

RegisterEvent(30091, "Door22", function()
    map.triggerMechanism(91, 2)
end, "Door22")

RegisterEvent(30092, "Door23", function()
    map.triggerMechanism(92, 2)
end, "Door23")

RegisterEvent(30093, "Door24", function()
    map.triggerMechanism(93, 2)
end, "Door24")

RegisterEvent(30094, "THDLL", function()
    map.triggerMechanism(94, 2)
end, "THDLL")

RegisterEvent(30095, "THDRR", function()
    map.triggerMechanism(95, 2)
end, "THDRR")

RegisterEvent(30096, "THDLR", function()
    map.triggerMechanism(96, 2)
end, "THDLR")

RegisterEvent(30097, "THDRL", function()
    map.triggerMechanism(97, 2)
end, "THDRL")

RegisterEvent(30098, "TraininghalldoorR", function()
    map.triggerMechanism(98, 2)
end, "TraininghalldoorR")

RegisterEvent(30099, "TraininghalldoorL", function()
    map.triggerMechanism(99, 2)
end, "TraininghalldoorL")

RegisterEvent(30100, "Tavernstoreroom", function()
    map.triggerMechanism(100, 2)
end, "Tavernstoreroom")

RegisterEvent(30101, "TavernkitchenL", function()
    map.triggerMechanism(101, 2)
end, "TavernkitchenL")

RegisterEvent(30102, "TavernkitchenR", function()
    map.triggerMechanism(102, 2)
end, "TavernkitchenR")

RegisterEvent(30103, "Door14", function()
    map.triggerMechanism(103, 2)
end, "Door14")

RegisterEvent(30104, "Door16", function()
    map.triggerMechanism(104, 2)
end, "Door16")

RegisterEvent(30105, "Door17", function()
    map.triggerMechanism(105, 2)
end, "Door17")

RegisterEvent(30106, "Door18", function()
    map.triggerMechanism(106, 2)
end, "Door18")

RegisterEvent(30107, "Door19", function()
    map.triggerMechanism(107, 2)
end, "Door19")

RegisterEvent(30108, "Door20", function()
    map.triggerMechanism(108, 2)
end, "Door20")

RegisterEvent(30109, "TaverndoorL", function()
    map.triggerMechanism(109, 2)
end, "TaverndoorL")

RegisterEvent(30110, "TaverndoorR", function()
    map.triggerMechanism(110, 2)
end, "TaverndoorR")

RegisterEvent(30111, "Door15", function()
    map.triggerMechanism(111, 2)
end, "Door15")

RegisterEvent(30117, "ArmorBeddoor0", function()
    map.triggerMechanism(117, 2)
end, "ArmorBeddoor0")

RegisterEvent(30118, "ForgedoorL0", function()
    map.triggerMechanism(118, 2)
end, "ForgedoorL0")

RegisterEvent(30119, "ForgedoorR0", function()
    map.triggerMechanism(119, 2)
end, "ForgedoorR0")

RegisterEvent(30120, "Weapon-Forge0", function()
    map.triggerMechanism(120, 2)
end, "Weapon-Forge0")

RegisterEvent(30121, "Armor-Forge0", function()
    map.triggerMechanism(121, 2)
end, "Armor-Forge0")

RegisterEvent(30122, "WeapondoorR0", function()
    map.triggerMechanism(122, 2)
end, "WeapondoorR0")

RegisterEvent(30123, "WeapondoorL0", function()
    map.triggerMechanism(123, 2)
end, "WeapondoorL0")

RegisterEvent(30124, "ArmordoorL0", function()
    map.triggerMechanism(124, 2)
end, "ArmordoorL0")

RegisterEvent(30125, "ArmordoorR0", function()
    map.triggerMechanism(125, 2)
end, "ArmordoorR0")

RegisterEvent(30126, "WeaponBeddoor0", function()
    map.triggerMechanism(126, 2)
end, "WeaponBeddoor0")

RegisterEvent(30128, "Door4", function()
    map.triggerMechanism(128, 2)
end, "Door4")

RegisterEvent(30129, "Door5", function()
    map.triggerMechanism(129, 2)
end, "Door5")

RegisterEvent(30130, "BembStudy1", function()
    map.triggerMechanism(130, 2)
end, "BembStudy1")

RegisterEvent(30131, "BembStudy2", function()
    map.triggerMechanism(131, 2)
end, "BembStudy2")

RegisterEvent(30132, "Door6", function()
    map.triggerMechanism(132, 2)
end, "Door6")

RegisterEvent(30133, "Door7", function()
    map.triggerMechanism(133, 2)
end, "Door7")

RegisterEvent(30134, "Door8", function()
    map.triggerMechanism(134, 2)
end, "Door8")

RegisterEvent(30135, "Door9", function()
    map.triggerMechanism(135, 2)
end, "Door9")

RegisterEvent(30136, "Door10", function()
    map.triggerMechanism(136, 2)
end, "Door10")

RegisterEvent(30137, "HearingroomR", function()
    map.triggerMechanism(137, 2)
end, "HearingroomR")

RegisterEvent(30138, "HearingroomL", function()
    map.triggerMechanism(138, 2)
end, "HearingroomL")

RegisterEvent(30139, "Door11", function()
    map.triggerMechanism(139, 2)
end, "Door11")

RegisterEvent(30140, "BembdoorR", function()
    map.triggerMechanism(140, 2)
end, "BembdoorR")

RegisterEvent(30141, "BembdoorL", function()
    map.triggerMechanism(141, 2)
end, "BembdoorL")

RegisterEvent(30142, "BembgateR", function()
    map.triggerMechanism(142, 2)
end, "BembgateR")

RegisterEvent(30143, "BembgateL", function()
    map.triggerMechanism(143, 2)
end, "BembgateL")

RegisterEvent(30144, "PalacedoorL", function()
    map.triggerMechanism(144, 2)
end, "PalacedoorL")

RegisterEvent(30145, "PalacedoorR", function()
    map.triggerMechanism(145, 2)
end, "PalacedoorR")

RegisterEvent(30146, "Door65", function()
    map.triggerMechanism(146, 2)
end, "Door65")

RegisterEvent(30147, "Door66", function()
    map.triggerMechanism(147, 2)
end, "Door66")

RegisterEvent(30148, "Door67", function()
    map.triggerMechanism(148, 2)
end, "Door67")

RegisterEvent(30149, "Door68", function()
    map.triggerMechanism(149, 2)
end, "Door68")

RegisterEvent(30150, "Door69", function()
    map.triggerMechanism(150, 2)
end, "Door69")

RegisterEvent(30151, "Door70", function()
    map.triggerMechanism(151, 2)
end, "Door70")

RegisterEvent(30156, "Door38", function()
    map.triggerMechanism(156, 2)
end, "Door38")

RegisterEvent(30157, "Door39", function()
    map.triggerMechanism(157, 2)
end, "Door39")

RegisterEvent(30158, "Door40", function()
    map.triggerMechanism(158, 2)
end, "Door40")

RegisterEvent(30160, "Door41", function()
    map.triggerMechanism(160, 2)
end, "Door41")

RegisterEvent(30161, "Door42", function()
    map.triggerMechanism(161, 2)
end, "Door42")

RegisterEvent(30162, "Door43", function()
    map.triggerMechanism(162, 2)
end, "Door43")

RegisterEvent(30163, "Door44", function()
    map.triggerMechanism(163, 2)
end, "Door44")

RegisterEvent(30165, "Door45", function()
    map.triggerMechanism(165, 2)
end, "Door45")

RegisterEvent(30166, "Door46", function()
    map.triggerMechanism(166, 2)
end, "Door46")

RegisterEvent(30167, "Door47", function()
    map.triggerMechanism(167, 2)
end, "Door47")

RegisterEvent(30168, "Door48", function()
    map.triggerMechanism(168, 2)
end, "Door48")

RegisterEvent(30169, "Door49", function()
    map.triggerMechanism(169, 2)
end, "Door49")

RegisterEvent(30170, "Door50", function()
    map.triggerMechanism(170, 2)
end, "Door50")

RegisterEvent(30171, "Door51", function()
    map.triggerMechanism(171, 2)
end, "Door51")

RegisterEvent(30172, "Door52", function()
    map.triggerMechanism(172, 2)
end, "Door52")

RegisterEvent(30174, "Door54", function()
    map.triggerMechanism(174, 2)
end, "Door54")

RegisterEvent(30175, "Door53", function()
    map.triggerMechanism(175, 2)
end, "Door53")

RegisterEvent(30176, "Door55", function()
    map.triggerMechanism(176, 2)
end, "Door55")

RegisterEvent(30177, "Door56", function()
    map.triggerMechanism(177, 2)
end, "Door56")

RegisterEvent(30178, "Door57", function()
    map.triggerMechanism(178, 2)
end, "Door57")

RegisterEvent(30180, "Door58", function()
    map.triggerMechanism(180, 2)
end, "Door58")

RegisterEvent(30181, "Door59", function()
    map.triggerMechanism(181, 2)
end, "Door59")

RegisterEvent(30182, "Door60", function()
    map.triggerMechanism(182, 2)
end, "Door60")

RegisterEvent(30183, "Door61", function()
    map.triggerMechanism(183, 2)
end, "Door61")

RegisterEvent(30184, "Door62", function()
    map.triggerMechanism(184, 2)
end, "Door62")

RegisterEvent(30185, "Door63", function()
    map.triggerMechanism(185, 2)
end, "Door63")

RegisterEvent(31095, "BembStudy3", function()
    map.triggerMechanism(1095, 2)
end, "BembStudy3")

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
map.scripts["foradworld.scr"] = {
    source = "FORADWORLD.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["greatbookkey.scr"] = {
    source = "GREATBOOKKEY.scr",
    registered_triggers = {
        { line = 74, message = "Use", callback = "OnUse" },
        { line = 75, message = "appear", callback = "OnAppear" },
    },
    movement_commands = {
    },
}
map.scripts["npc161.scr"] = {
    source = "NPC161.scr",
    registered_triggers = {
        { line = 180, message = "Use", callback = "OnUse" },
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
map.scripts["npc4.scr"] = {
    source = "NPC4.scr",
    registered_triggers = {
        { line = 151, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc416.scr"] = {
    source = "NPC416.scr",
    registered_triggers = {
        { line = 70, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc5.scr"] = {
    source = "NPC5.scr",
    registered_triggers = {
        { line = 129, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc7.scr"] = {
    source = "NPC7.scr",
    registered_triggers = {
        { line = 450, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["orbtrigger.scr"] = {
    source = "ORBTRIGGER.scr",
    registered_triggers = {
        { line = 32, message = "Use", callback = "OnUse" },
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
map.scripts["randverretainer.scr"] = {
    source = "RANDVERRETAINER.scr",
    registered_triggers = {
        { line = 75, message = "Use", callback = "Onblabber" },
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
