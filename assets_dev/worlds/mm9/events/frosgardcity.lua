-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "frosgardcity"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 47,
        source_name = "FallingStart",
        x = -11633,
        y = -9830,
        z = 6554,
        direction_yaw_units = 1746,
        move_player_to_floor = false,
    },
    {
        start_index = 1,
        source_object_index = 49,
        source_name = "FrosgardCityStart",
        x = 10486,
        y = 7209,
        z = 458,
        direction_yaw_units = 885,
        move_player_to_floor = true,
    },
    {
        start_index = 2,
        source_object_index = 68,
        source_name = "StartPoint0",
        x = 4260,
        y = -10486,
        z = 236,
        direction_yaw_units = 1532,
        move_player_to_floor = true,
    },
    {
        start_index = 3,
        source_object_index = 335,
        source_name = "TownPortal",
        x = 12431,
        y = 3768,
        z = 164,
        direction_yaw_units = 1025,
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
        source_name = "Trainingdoor",
        kind = "rotating_door",
        hint = "Trainingdoor",
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
        source_name = "Taverndoor",
        kind = "rotating_door",
        hint = "Taverndoor",
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
        source_name = "Apothdoor",
        kind = "rotating_door",
        hint = "Apothdoor",
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
        source_name = "WAdoorL",
        kind = "rotating_door",
        hint = "WAdoorL",
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
        source_name = "WAdoorR",
        kind = "rotating_door",
        hint = "WAdoorR",
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
        source_name = "Bankwindow",
        kind = "linear_door",
        hint = "Bankwindow",
    },
    {
        mechanism_id = 900006,
        event_id = 30006,
        source_object_index = 6,
        source_class = "Door",
        source_name = "Bankdoor",
        kind = "linear_door",
        hint = "Bankdoor",
    },
    {
        mechanism_id = 900007,
        event_id = 30007,
        source_object_index = 7,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush12",
        kind = "destructible_brush",
        hint = "DestructableBrush12",
    },
    {
        mechanism_id = 900008,
        event_id = 30008,
        source_object_index = 8,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush13",
        kind = "destructible_brush",
        hint = "DestructableBrush13",
    },
    {
        mechanism_id = 900009,
        event_id = 30009,
        source_object_index = 9,
        source_class = "RotatingDoor",
        source_name = "Magidoor",
        kind = "rotating_door",
        hint = "Magidoor",
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
        mechanism_id = 900011,
        event_id = 30011,
        source_object_index = 11,
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
        mechanism_id = 900012,
        event_id = 30012,
        source_object_index = 12,
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
        mechanism_id = 900013,
        event_id = 30013,
        source_object_index = 13,
        source_class = "RotatingDoor",
        source_name = "RDoor0",
        kind = "rotating_door",
        hint = "RDoor0",
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
        source_name = "Door7",
        kind = "rotating_door",
        hint = "Door7",
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
                name = "Door/knock.wav",
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
        source_name = "Door13",
        kind = "rotating_door",
        hint = "Door13",
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
                name = "Door/knock.wav",
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
        mechanism_id = 900017,
        event_id = 30017,
        source_object_index = 17,
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
        mechanism_id = 900018,
        event_id = 30018,
        source_object_index = 18,
        source_class = "Door",
        source_name = "Door0",
        kind = "linear_door",
        hint = "Door0",
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
        mechanism_id = 900019,
        event_id = 30019,
        source_object_index = 19,
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
        mechanism_id = 900020,
        event_id = 30020,
        source_object_index = 20,
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
        mechanism_id = 900021,
        event_id = 30021,
        source_object_index = 21,
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
        mechanism_id = 900022,
        event_id = 30022,
        source_object_index = 22,
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
        mechanism_id = 900023,
        event_id = 30023,
        source_object_index = 23,
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
        mechanism_id = 900024,
        event_id = 30024,
        source_object_index = 24,
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
        mechanism_id = 900025,
        event_id = 30025,
        source_object_index = 25,
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
        mechanism_id = 900026,
        event_id = 30026,
        source_object_index = 26,
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
        mechanism_id = 900027,
        event_id = 30027,
        source_object_index = 27,
        source_class = "Door",
        source_name = "Door14",
        kind = "linear_door",
        hint = "Door14",
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
        source_class = "Door",
        source_name = "Door15",
        kind = "linear_door",
        hint = "Door15",
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
        mechanism_id = 900029,
        event_id = 30029,
        source_object_index = 29,
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
        mechanism_id = 900030,
        event_id = 30030,
        source_object_index = 30,
        source_class = "Door",
        source_name = "Door16",
        kind = "linear_door",
        hint = "Door16",
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
        mechanism_id = 900031,
        event_id = 30031,
        source_object_index = 31,
        source_class = "Door",
        source_name = "Door17",
        kind = "linear_door",
        hint = "Door17",
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
        mechanism_id = 900032,
        event_id = 30032,
        source_object_index = 32,
        source_class = "Door",
        source_name = "Door18",
        kind = "linear_door",
        hint = "Door18",
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
        mechanism_id = 900033,
        event_id = 30033,
        source_object_index = 33,
        source_class = "Door",
        source_name = "Door19",
        kind = "linear_door",
        hint = "Door19",
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
        mechanism_id = 900034,
        event_id = 30034,
        source_object_index = 34,
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
        mechanism_id = 900035,
        event_id = 30035,
        source_object_index = 35,
        source_class = "Door",
        source_name = "Door20",
        kind = "linear_door",
        hint = "Door20",
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
        mechanism_id = 900037,
        event_id = 30037,
        source_object_index = 37,
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
        mechanism_id = 900040,
        event_id = 30040,
        source_object_index = 40,
        source_class = "ScriptObject",
        source_name = "BattleMan",
        kind = "script_object",
        hint = "BattleMan",
    },
    {
        mechanism_id = 900041,
        event_id = 30041,
        source_object_index = 41,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 900045,
        event_id = 30045,
        source_object_index = 45,
        source_class = "DestructableProp",
        source_name = "DestructableProp1",
        kind = "destructible_prop",
        hint = "DestructableProp1",
    },
    {
        mechanism_id = 900056,
        event_id = 30056,
        source_object_index = 56,
        source_class = "ScriptObject",
        source_name = "ScriptObject0",
        kind = "script_object",
        hint = "ScriptObject0",
    },
    {
        mechanism_id = 900062,
        event_id = 30062,
        source_object_index = 62,
        source_class = "Shooter",
        source_name = "Shooter2",
        kind = "shooter",
        hint = "Shooter2",
    },
    {
        mechanism_id = 900063,
        event_id = 30063,
        source_object_index = 63,
        source_class = "Shooter",
        source_name = "Shooter3",
        kind = "shooter",
        hint = "Shooter3",
    },
    {
        mechanism_id = 900064,
        event_id = 30064,
        source_object_index = 64,
        source_class = "Shooter",
        source_name = "Shooter4",
        kind = "shooter",
        hint = "Shooter4",
    },
    {
        mechanism_id = 900065,
        event_id = 30065,
        source_object_index = 65,
        source_class = "Shooter",
        source_name = "Shooter5",
        kind = "shooter",
        hint = "Shooter5",
    },
    {
        mechanism_id = 900066,
        event_id = 30066,
        source_object_index = 66,
        source_class = "Shooter",
        source_name = "Shooter6",
        kind = "shooter",
        hint = "Shooter6",
    },
    {
        mechanism_id = 900067,
        event_id = 30067,
        source_object_index = 67,
        source_class = "Shooter",
        source_name = "Shooter7",
        kind = "shooter",
        hint = "Shooter7",
    },
    {
        mechanism_id = 900077,
        event_id = 30077,
        source_object_index = 77,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900078,
        event_id = 30078,
        source_object_index = 78,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 900079,
        event_id = 30079,
        source_object_index = 79,
        source_class = "AIBarrier",
        source_name = "AIBarrier2",
        kind = "ai_barrier",
        hint = "AIBarrier2",
    },
    {
        mechanism_id = 900080,
        event_id = 30080,
        source_object_index = 80,
        source_class = "AIBarrier",
        source_name = "AIBarrier3",
        kind = "ai_barrier",
        hint = "AIBarrier3",
    },
    {
        mechanism_id = 900081,
        event_id = 30081,
        source_object_index = 81,
        source_class = "AIBarrier",
        source_name = "AIBarrier4",
        kind = "ai_barrier",
        hint = "AIBarrier4",
    },
    {
        mechanism_id = 900082,
        event_id = 30082,
        source_object_index = 82,
        source_class = "AIBarrier",
        source_name = "AIBarrier7",
        kind = "ai_barrier",
        hint = "AIBarrier7",
    },
    {
        mechanism_id = 900083,
        event_id = 30083,
        source_object_index = 83,
        source_class = "AIBarrier",
        source_name = "AIBarrier6",
        kind = "ai_barrier",
        hint = "AIBarrier6",
    },
    {
        mechanism_id = 900084,
        event_id = 30084,
        source_object_index = 84,
        source_class = "AIBarrier",
        source_name = "AIBarrier5",
        kind = "ai_barrier",
        hint = "AIBarrier5",
    },
    {
        mechanism_id = 900092,
        event_id = 30092,
        source_object_index = 92,
        source_class = "AIBarrier",
        source_name = "AIBarrier8",
        kind = "ai_barrier",
        hint = "AIBarrier8",
    },
    {
        mechanism_id = 900093,
        event_id = 30093,
        source_object_index = 93,
        source_class = "AIBarrier",
        source_name = "AIBarrier9",
        kind = "ai_barrier",
        hint = "AIBarrier9",
    },
    {
        mechanism_id = 900094,
        event_id = 30094,
        source_object_index = 94,
        source_class = "AIBarrier",
        source_name = "AIBarrier10",
        kind = "ai_barrier",
        hint = "AIBarrier10",
    },
    {
        mechanism_id = 900095,
        event_id = 30095,
        source_object_index = 95,
        source_class = "AIBarrier",
        source_name = "AIBarrier11",
        kind = "ai_barrier",
        hint = "AIBarrier11",
    },
    {
        mechanism_id = 900096,
        event_id = 30096,
        source_object_index = 96,
        source_class = "AIBarrier",
        source_name = "AIBarrier12",
        kind = "ai_barrier",
        hint = "AIBarrier12",
    },
    {
        mechanism_id = 900145,
        event_id = 30145,
        source_object_index = 145,
        source_class = "AIBarrier",
        source_name = "AIBarrier13",
        kind = "ai_barrier",
        hint = "AIBarrier13",
    },
    {
        mechanism_id = 900599,
        event_id = 30599,
        source_object_index = 599,
        source_class = "ScriptObject",
        source_name = "BreakIce",
        kind = "script_object",
        hint = "BreakIce",
    },
    {
        mechanism_id = 900600,
        event_id = 30600,
        source_object_index = 600,
        source_class = "Shooter",
        source_name = "Shooter0",
        kind = "shooter",
        hint = "Shooter0",
    },
    {
        mechanism_id = 900607,
        event_id = 30607,
        source_object_index = 607,
        source_class = "DestructableProp",
        source_name = "DestructableProp0",
        kind = "destructible_prop",
        hint = "DestructableProp0",
    },
    {
        mechanism_id = 900608,
        event_id = 30608,
        source_object_index = 608,
        source_class = "Shooter",
        source_name = "Shooter1",
        kind = "shooter",
        hint = "Shooter1",
    },
    {
        mechanism_id = 900610,
        event_id = 30610,
        source_object_index = 610,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush14",
        kind = "destructible_brush",
        hint = "DestructableBrush14",
    },
    {
        mechanism_id = 900611,
        event_id = 30611,
        source_object_index = 611,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush15",
        kind = "destructible_brush",
        hint = "DestructableBrush15",
    },
    {
        mechanism_id = 900612,
        event_id = 30612,
        source_object_index = 612,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush16",
        kind = "destructible_brush",
        hint = "DestructableBrush16",
    },
    {
        mechanism_id = 900613,
        event_id = 30613,
        source_object_index = 613,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush17",
        kind = "destructible_brush",
        hint = "DestructableBrush17",
    },
    {
        mechanism_id = 900614,
        event_id = 30614,
        source_object_index = 614,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush18",
        kind = "destructible_brush",
        hint = "DestructableBrush18",
    },
    {
        mechanism_id = 900615,
        event_id = 30615,
        source_object_index = 615,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush19",
        kind = "destructible_brush",
        hint = "DestructableBrush19",
    },
    {
        mechanism_id = 900616,
        event_id = 30616,
        source_object_index = 616,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush20",
        kind = "destructible_brush",
        hint = "DestructableBrush20",
    },
    {
        mechanism_id = 900617,
        event_id = 30617,
        source_object_index = 617,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush21",
        kind = "destructible_brush",
        hint = "DestructableBrush21",
    },
    {
        mechanism_id = 900618,
        event_id = 30618,
        source_object_index = 618,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush22",
        kind = "destructible_brush",
        hint = "DestructableBrush22",
    },
    {
        mechanism_id = 900619,
        event_id = 30619,
        source_object_index = 619,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush23",
        kind = "destructible_brush",
        hint = "DestructableBrush23",
    },
    {
        mechanism_id = 900620,
        event_id = 30620,
        source_object_index = 620,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush24",
        kind = "destructible_brush",
        hint = "DestructableBrush24",
    },
    {
        mechanism_id = 900621,
        event_id = 30621,
        source_object_index = 621,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush25",
        kind = "destructible_brush",
        hint = "DestructableBrush25",
    },
    {
        mechanism_id = 900622,
        event_id = 30622,
        source_object_index = 622,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush26",
        kind = "destructible_brush",
        hint = "DestructableBrush26",
    },
    {
        mechanism_id = 900623,
        event_id = 30623,
        source_object_index = 623,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush27",
        kind = "destructible_brush",
        hint = "DestructableBrush27",
    },
    {
        mechanism_id = 900624,
        event_id = 30624,
        source_object_index = 624,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush28",
        kind = "destructible_brush",
        hint = "DestructableBrush28",
    },
    {
        mechanism_id = 900625,
        event_id = 30625,
        source_object_index = 625,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush29",
        kind = "destructible_brush",
        hint = "DestructableBrush29",
    },
    {
        mechanism_id = 900626,
        event_id = 30626,
        source_object_index = 626,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush30",
        kind = "destructible_brush",
        hint = "DestructableBrush30",
    },
    {
        mechanism_id = 900627,
        event_id = 30627,
        source_object_index = 627,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush31",
        kind = "destructible_brush",
        hint = "DestructableBrush31",
    },
    {
        mechanism_id = 900628,
        event_id = 30628,
        source_object_index = 628,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush32",
        kind = "destructible_brush",
        hint = "DestructableBrush32",
    },
    {
        mechanism_id = 900629,
        event_id = 30629,
        source_object_index = 629,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush33",
        kind = "destructible_brush",
        hint = "DestructableBrush33",
    },
    {
        mechanism_id = 900630,
        event_id = 30630,
        source_object_index = 630,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush34",
        kind = "destructible_brush",
        hint = "DestructableBrush34",
    },
    {
        mechanism_id = 900631,
        event_id = 30631,
        source_object_index = 631,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush35",
        kind = "destructible_brush",
        hint = "DestructableBrush35",
    },
    {
        mechanism_id = 900632,
        event_id = 30632,
        source_object_index = 632,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush36",
        kind = "destructible_brush",
        hint = "DestructableBrush36",
    },
    {
        mechanism_id = 900633,
        event_id = 30633,
        source_object_index = 633,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush37",
        kind = "destructible_brush",
        hint = "DestructableBrush37",
    },
    {
        mechanism_id = 900634,
        event_id = 30634,
        source_object_index = 634,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush38",
        kind = "destructible_brush",
        hint = "DestructableBrush38",
    },
    {
        mechanism_id = 900635,
        event_id = 30635,
        source_object_index = 635,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush39",
        kind = "destructible_brush",
        hint = "DestructableBrush39",
    },
    {
        mechanism_id = 900636,
        event_id = 30636,
        source_object_index = 636,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush40",
        kind = "destructible_brush",
        hint = "DestructableBrush40",
    },
    {
        mechanism_id = 900637,
        event_id = 30637,
        source_object_index = 637,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush41",
        kind = "destructible_brush",
        hint = "DestructableBrush41",
    },
    {
        mechanism_id = 900638,
        event_id = 30638,
        source_object_index = 638,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush42",
        kind = "destructible_brush",
        hint = "DestructableBrush42",
    },
    {
        mechanism_id = 900639,
        event_id = 30639,
        source_object_index = 639,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush43",
        kind = "destructible_brush",
        hint = "DestructableBrush43",
    },
    {
        mechanism_id = 900640,
        event_id = 30640,
        source_object_index = 640,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush44",
        kind = "destructible_brush",
        hint = "DestructableBrush44",
    },
    {
        mechanism_id = 900641,
        event_id = 30641,
        source_object_index = 641,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush45",
        kind = "destructible_brush",
        hint = "DestructableBrush45",
    },
    {
        mechanism_id = 900642,
        event_id = 30642,
        source_object_index = 642,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush6",
        kind = "destructible_brush",
        hint = "DestructableBrush6",
    },
    {
        mechanism_id = 900643,
        event_id = 30643,
        source_object_index = 643,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush7",
        kind = "destructible_brush",
        hint = "DestructableBrush7",
    },
    {
        mechanism_id = 900644,
        event_id = 30644,
        source_object_index = 644,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush8",
        kind = "destructible_brush",
        hint = "DestructableBrush8",
    },
    {
        mechanism_id = 900645,
        event_id = 30645,
        source_object_index = 645,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush9",
        kind = "destructible_brush",
        hint = "DestructableBrush9",
    },
    {
        mechanism_id = 900646,
        event_id = 30646,
        source_object_index = 646,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush46",
        kind = "destructible_brush",
        hint = "DestructableBrush46",
    },
    {
        mechanism_id = 900647,
        event_id = 30647,
        source_object_index = 647,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900671,
        event_id = 30671,
        source_object_index = 671,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900672,
        event_id = 30672,
        source_object_index = 672,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900673,
        event_id = 30673,
        source_object_index = 673,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900674,
        event_id = 30674,
        source_object_index = 674,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900675,
        event_id = 30675,
        source_object_index = 675,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900676,
        event_id = 30676,
        source_object_index = 676,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 900677,
        event_id = 30677,
        source_object_index = 677,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 900678,
        event_id = 30678,
        source_object_index = 678,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 900679,
        event_id = 30679,
        source_object_index = 679,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush7",
        kind = "perception_brush",
        hint = "PerceptionBrush7",
    },
    {
        mechanism_id = 900680,
        event_id = 30680,
        source_object_index = 680,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush8",
        kind = "perception_brush",
        hint = "PerceptionBrush8",
    },
    {
        mechanism_id = 900681,
        event_id = 30681,
        source_object_index = 681,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush9",
        kind = "perception_brush",
        hint = "PerceptionBrush9",
    },
    {
        mechanism_id = 900682,
        event_id = 30682,
        source_object_index = 682,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush10",
        kind = "perception_brush",
        hint = "PerceptionBrush10",
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
    [30000] = { kind = "open_door", source = "mm9_mechanism", targetName = "Trainingdoor" },
    [30001] = { kind = "open_door", source = "mm9_mechanism", targetName = "Taverndoor" },
    [30002] = { kind = "open_door", source = "mm9_mechanism", targetName = "Apothdoor" },
    [30003] = { kind = "open_door", source = "mm9_mechanism", targetName = "WAdoorL" },
    [30004] = { kind = "open_door", source = "mm9_mechanism", targetName = "WAdoorR" },
    [30005] = { kind = "open_door", source = "mm9_mechanism", targetName = "Bankwindow" },
    [30006] = { kind = "open_door", source = "mm9_mechanism", targetName = "Bankdoor" },
    [30009] = { kind = "open_door", source = "mm9_mechanism", targetName = "Magidoor" },
    [30010] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door5" },
    [30011] = { kind = "open_door", source = "mm9_mechanism", targetName = "TownhallR" },
    [30012] = { kind = "open_door", source = "mm9_mechanism", targetName = "TownhallL" },
    [30013] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor0" },
    [30014] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door7" },
    [30015] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door13" },
    [30016] = { kind = "open_door", source = "mm9_mechanism", targetName = "TempledoorL" },
    [30017] = { kind = "open_door", source = "mm9_mechanism", targetName = "TempledoorR" },
    [30018] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door0" },
    [30019] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1" },
    [30020] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door2" },
    [30021] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door4" },
    [30022] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door6" },
    [30023] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door8" },
    [30024] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door9" },
    [30025] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door10" },
    [30026] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door12" },
    [30027] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door14" },
    [30028] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door15" },
    [30029] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door11" },
    [30030] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door16" },
    [30031] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door17" },
    [30032] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door18" },
    [30033] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door19" },
    [30034] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door21" },
    [30035] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door20" },
    [30036] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door23" },
    [30037] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door22" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30000, "Trainingdoor", function()
    map.triggerMechanism(0, 2)
end, "Trainingdoor")

RegisterEvent(30001, "Taverndoor", function()
    map.triggerMechanism(1, 2)
end, "Taverndoor")

RegisterEvent(30002, "Apothdoor", function()
    map.triggerMechanism(2, 2)
end, "Apothdoor")

RegisterEvent(30003, "WAdoorL", function()
    map.triggerMechanism(3, 2)
end, "WAdoorL")

RegisterEvent(30004, "WAdoorR", function()
    map.triggerMechanism(4, 2)
end, "WAdoorR")

RegisterEvent(30005, "Bankwindow", function()
    map.triggerMechanism(5, 2)
end, "Bankwindow")

RegisterEvent(30006, "Bankdoor", function()
    map.triggerMechanism(6, 2)
end, "Bankdoor")

RegisterEvent(30009, "Magidoor", function()
    map.triggerMechanism(9, 2)
end, "Magidoor")

RegisterEvent(30010, "Door5", function()
    map.triggerMechanism(10, 2)
end, "Door5")

RegisterEvent(30011, "TownhallR", function()
    map.triggerMechanism(11, 2)
end, "TownhallR")

RegisterEvent(30012, "TownhallL", function()
    map.triggerMechanism(12, 2)
end, "TownhallL")

RegisterEvent(30013, "RDoor0", function()
    map.triggerMechanism(13, 2)
end, "RDoor0")

RegisterEvent(30014, "Door7", function()
    map.triggerMechanism(14, 2)
end, "Door7")

RegisterEvent(30015, "Door13", function()
    map.triggerMechanism(15, 2)
end, "Door13")

RegisterEvent(30016, "TempledoorL", function()
    map.triggerMechanism(16, 2)
end, "TempledoorL")

RegisterEvent(30017, "TempledoorR", function()
    map.triggerMechanism(17, 2)
end, "TempledoorR")

RegisterEvent(30018, "Door0", function()
    map.triggerMechanism(18, 2)
end, "Door0")

RegisterEvent(30019, "Door1", function()
    map.triggerMechanism(19, 2)
end, "Door1")

RegisterEvent(30020, "Door2", function()
    map.triggerMechanism(20, 2)
end, "Door2")

RegisterEvent(30021, "Door4", function()
    map.triggerMechanism(21, 2)
end, "Door4")

RegisterEvent(30022, "Door6", function()
    map.triggerMechanism(22, 2)
end, "Door6")

RegisterEvent(30023, "Door8", function()
    map.triggerMechanism(23, 2)
end, "Door8")

RegisterEvent(30024, "Door9", function()
    map.triggerMechanism(24, 2)
end, "Door9")

RegisterEvent(30025, "Door10", function()
    map.triggerMechanism(25, 2)
end, "Door10")

RegisterEvent(30026, "Door12", function()
    map.triggerMechanism(26, 2)
end, "Door12")

RegisterEvent(30027, "Door14", function()
    map.triggerMechanism(27, 2)
end, "Door14")

RegisterEvent(30028, "Door15", function()
    map.triggerMechanism(28, 2)
end, "Door15")

RegisterEvent(30029, "Door11", function()
    map.triggerMechanism(29, 2)
end, "Door11")

RegisterEvent(30030, "Door16", function()
    map.triggerMechanism(30, 2)
end, "Door16")

RegisterEvent(30031, "Door17", function()
    map.triggerMechanism(31, 2)
end, "Door17")

RegisterEvent(30032, "Door18", function()
    map.triggerMechanism(32, 2)
end, "Door18")

RegisterEvent(30033, "Door19", function()
    map.triggerMechanism(33, 2)
end, "Door19")

RegisterEvent(30034, "Door21", function()
    map.triggerMechanism(34, 2)
end, "Door21")

RegisterEvent(30035, "Door20", function()
    map.triggerMechanism(35, 2)
end, "Door20")

RegisterEvent(30036, "Door23", function()
    map.triggerMechanism(36, 2)
end, "Door23")

RegisterEvent(30037, "Door22", function()
    map.triggerMechanism(37, 2)
end, "Door22")

map.scripts["battleman.scr"] = {
    source = "BATTLEMAN.scr",
    registered_triggers = {
        { line = 194, message = "Fight2", callback = "OnFight2" },
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
map.scripts["breakice.scr"] = {
    source = "BREAKICE.scr",
    registered_triggers = {
        { line = 451, message = "Start", callback = "OnStart" },
        { line = 452, message = "Cam3", callback = "OnCam3" },
    },
    movement_commands = {
    },
}
map.scripts["changemodel.scr"] = {
    source = "CHANGEMODEL.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["destructon.scr"] = {
    source = "DESTRUCTON.scr",
    registered_triggers = {
        { line = 37, message = "DamageOn", callback = "OnDamageOn" },
    },
    movement_commands = {
    },
}
map.scripts["forad.scr"] = {
    source = "FORAD.scr",
    registered_triggers = {
        { line = 176, message = "Use", callback = "OnUse" },
        { line = 177, message = "Appear", callback = "OnAppear" },
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
map.scripts["frosgardshooter.scr"] = {
    source = "FROSGARDSHOOTER.scr",
    registered_triggers = {
        { line = 97, message = "Start", callback = "OnStart" },
    },
    movement_commands = {
    },
}
map.scripts["hidemodel.scr"] = {
    source = "HIDEMODEL.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["icecam1.scr"] = {
    source = "ICECAM1.scr",
    registered_triggers = {
        { line = 53, message = "Start", callback = "OnStart" },
        { line = 54, message = "Move", callback = "OnMove" },
    },
    movement_commands = {
        { line = 39, command = "MoveToPos", arguments = "xpos Ypos Zpos 150 OnArrive" },
    },
}
map.scripts["npc180.scr"] = {
    source = "NPC180.scr",
    registered_triggers = {
        { line = 179, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc181.scr"] = {
    source = "NPC181.scr",
    registered_triggers = {
        { line = 136, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc182.scr"] = {
    source = "NPC182.scr",
    registered_triggers = {
        { line = 51, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc183.scr"] = {
    source = "NPC183.scr",
    registered_triggers = {
        { line = 67, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc184.scr"] = {
    source = "NPC184.scr",
    registered_triggers = {
        { line = 122, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc185.scr"] = {
    source = "NPC185.scr",
    registered_triggers = {
        { line = 83, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc188.scr"] = {
    source = "NPC188.scr",
    registered_triggers = {
        { line = 72, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc190.scr"] = {
    source = "NPC190.scr",
    registered_triggers = {
        { line = 88, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc191.scr"] = {
    source = "NPC191.scr",
    registered_triggers = {
        { line = 50, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc192.scr"] = {
    source = "NPC192.scr",
    registered_triggers = {
        { line = 49, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc193.scr"] = {
    source = "NPC193.scr",
    registered_triggers = {
        { line = 48, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc194.scr"] = {
    source = "NPC194.scr",
    registered_triggers = {
        { line = 52, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc195.scr"] = {
    source = "NPC195.scr",
    registered_triggers = {
        { line = 52, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc196.scr"] = {
    source = "NPC196.scr",
    registered_triggers = {
        { line = 51, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc197.scr"] = {
    source = "NPC197.scr",
    registered_triggers = {
        { line = 50, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc198.scr"] = {
    source = "NPC198.scr",
    registered_triggers = {
        { line = 51, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc199.scr"] = {
    source = "NPC199.scr",
    registered_triggers = {
        { line = 52, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc206.scr"] = {
    source = "NPC206.scr",
    registered_triggers = {
        { line = 69, message = "bank", callback = "OnBank" },
    },
    movement_commands = {
    },
}
map.scripts["npc209.scr"] = {
    source = "NPC209.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["npc213.scr"] = {
    source = "NPC213.scr",
    registered_triggers = {
        { line = 124, message = "Speak2", callback = "OnSpeak2" },
        { line = 125, message = "Speak4", callback = "OnSpeak4" },
        { line = 126, message = "Speak6", callback = "OnSpeak6" },
        { line = 127, message = "Speak8", callback = "OnSpeak8" },
        { line = 128, message = "Target", callback = "OnTarget" },
    },
    movement_commands = {
    },
}
map.scripts["npc214.scr"] = {
    source = "NPC214.scr",
    registered_triggers = {
        { line = 146, message = "Start", callback = "OnStart" },
        { line = 147, message = "Speak3", callback = "OnSpeak3" },
        { line = 148, message = "Speak5", callback = "OnSpeak5" },
        { line = 149, message = "Speak7", callback = "OnSpeak7" },
        { line = 150, message = "Speak9", callback = "OnSpeak9" },
    },
    movement_commands = {
    },
}
map.scripts["npc215.scr"] = {
    source = "NPC215.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["npc309.scr"] = {
    source = "NPC309.scr",
    registered_triggers = {
        { line = 106, message = "Appear", callback = "OnAppear" },
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
map.scripts["pledge.scr"] = {
    source = "PLEDGE.scr",
    registered_triggers = {
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
