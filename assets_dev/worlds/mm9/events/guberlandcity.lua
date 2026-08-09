-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "guberlandcity"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 180,
        source_name = "StartPoint0",
        x = -655,
        y = -287,
        z = 328,
        direction_yaw_units = 1024,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 720,
        source_name = "TownPortal",
        x = 5571,
        y = -13107,
        z = 128,
        direction_yaw_units = 507,
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
        source_class = "DestructableBrush",
        source_name = "DestructableBrush0",
        kind = "destructible_brush",
        hint = "DestructableBrush0",
    },
    {
        mechanism_id = 900001,
        event_id = 30001,
        source_object_index = 1,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush1",
        kind = "destructible_brush",
        hint = "DestructableBrush1",
    },
    {
        mechanism_id = 900002,
        event_id = 30002,
        source_object_index = 2,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush2",
        kind = "destructible_brush",
        hint = "DestructableBrush2",
    },
    {
        mechanism_id = 900003,
        event_id = 30003,
        source_object_index = 3,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush3",
        kind = "destructible_brush",
        hint = "DestructableBrush3",
    },
    {
        mechanism_id = 900004,
        event_id = 30004,
        source_object_index = 4,
        source_class = "RotatingDoor",
        source_name = "TavernL",
        kind = "rotating_door",
        hint = "TavernL",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door06close.wav",
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
        source_name = "TavernR",
        kind = "rotating_door",
        hint = "TavernR",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door06close.wav",
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
            ["close_busy"] = {
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
            ["close_busy"] = {
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
            ["close_busy"] = {
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
            ["close_busy"] = {
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
        source_class = "RotatingDoor",
        source_name = "Bar",
        kind = "rotating_door",
        hint = "Bar",
    },
    {
        mechanism_id = 900011,
        event_id = 30011,
        source_object_index = 11,
        source_class = "Door",
        source_name = "Curtain",
        kind = "linear_door",
        hint = "Curtain",
    },
    {
        mechanism_id = 900013,
        event_id = 30013,
        source_object_index = 13,
        source_class = "RotatingDoor",
        source_name = "TempleL",
        kind = "rotating_door",
        hint = "TempleL",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door06close.wav",
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
        source_name = "TempleR",
        kind = "rotating_door",
        hint = "TempleR",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door06close.wav",
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
        source_name = "RotatingDoor0",
        kind = "rotating_door",
        hint = "RotatingDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/door02open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door02close.wav",
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
        source_name = "RotatingDoor1",
        kind = "rotating_door",
        hint = "RotatingDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door02open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door02close.wav",
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
        source_class = "RotatingDoor",
        source_name = "ThroneL",
        kind = "rotating_door",
        hint = "ThroneL",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door06close.wav",
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
        source_class = "RotatingDoor",
        source_name = "ThroneR",
        kind = "rotating_door",
        hint = "ThroneR",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door06close.wav",
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
        source_class = "RotatingDoor",
        source_name = "PalaceL",
        kind = "rotating_door",
        hint = "PalaceL",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door06close.wav",
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
        source_name = "PalaceR",
        kind = "rotating_door",
        hint = "PalaceR",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door06close.wav",
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
        source_class = "DestructableBrush",
        source_name = "DestructableBrush15",
        kind = "destructible_brush",
        hint = "DestructableBrush15",
    },
    {
        mechanism_id = 900023,
        event_id = 30023,
        source_object_index = 23,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush16",
        kind = "destructible_brush",
        hint = "DestructableBrush16",
    },
    {
        mechanism_id = 900024,
        event_id = 30024,
        source_object_index = 24,
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
            ["close_busy"] = {
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
            ["close_busy"] = {
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
            ["close_busy"] = {
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
            ["close_busy"] = {
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
        source_class = "DestructableBrush",
        source_name = "DestructableBrush6",
        kind = "destructible_brush",
        hint = "DestructableBrush6",
    },
    {
        mechanism_id = 900029,
        event_id = 30029,
        source_object_index = 29,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush7",
        kind = "destructible_brush",
        hint = "DestructableBrush7",
    },
    {
        mechanism_id = 900030,
        event_id = 30030,
        source_object_index = 30,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush8",
        kind = "destructible_brush",
        hint = "DestructableBrush8",
    },
    {
        mechanism_id = 900031,
        event_id = 30031,
        source_object_index = 31,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush9",
        kind = "destructible_brush",
        hint = "DestructableBrush9",
    },
    {
        mechanism_id = 900032,
        event_id = 30032,
        source_object_index = 32,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush10",
        kind = "destructible_brush",
        hint = "DestructableBrush10",
    },
    {
        mechanism_id = 900033,
        event_id = 30033,
        source_object_index = 33,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush11",
        kind = "destructible_brush",
        hint = "DestructableBrush11",
    },
    {
        mechanism_id = 900034,
        event_id = 30034,
        source_object_index = 34,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush13",
        kind = "destructible_brush",
        hint = "DestructableBrush13",
    },
    {
        mechanism_id = 900035,
        event_id = 30035,
        source_object_index = 35,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush12",
        kind = "destructible_brush",
        hint = "DestructableBrush12",
    },
    {
        mechanism_id = 900036,
        event_id = 30036,
        source_object_index = 36,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush14",
        kind = "destructible_brush",
        hint = "DestructableBrush14",
    },
    {
        mechanism_id = 900037,
        event_id = 30037,
        source_object_index = 37,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush17",
        kind = "destructible_brush",
        hint = "DestructableBrush17",
    },
    {
        mechanism_id = 900038,
        event_id = 30038,
        source_object_index = 38,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush18",
        kind = "destructible_brush",
        hint = "DestructableBrush18",
    },
    {
        mechanism_id = 900039,
        event_id = 30039,
        source_object_index = 39,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush19",
        kind = "destructible_brush",
        hint = "DestructableBrush19",
    },
    {
        mechanism_id = 900040,
        event_id = 30040,
        source_object_index = 40,
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
            ["close_busy"] = {
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
        source_class = "Door",
        source_name = "Door2",
        kind = "linear_door",
        hint = "Door2",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
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
        mechanism_id = 900042,
        event_id = 30042,
        source_object_index = 42,
        source_class = "Door",
        source_name = "Door3",
        kind = "linear_door",
        hint = "Door3",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
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
        mechanism_id = 900043,
        event_id = 30043,
        source_object_index = 43,
        source_class = "RotatingDoor",
        source_name = "BankL",
        kind = "rotating_door",
        hint = "BankL",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door06close.wav",
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
        source_name = "BankR",
        kind = "rotating_door",
        hint = "BankR",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door06close.wav",
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
        source_class = "Door",
        source_name = "Door32",
        kind = "linear_door",
        hint = "Door32",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
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
        mechanism_id = 900047,
        event_id = 30047,
        source_object_index = 47,
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
            ["close_busy"] = {
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
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 900050,
        event_id = 30050,
        source_object_index = 50,
        source_class = "Door",
        source_name = "Door6",
        kind = "linear_door",
        hint = "Door6",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900051,
        event_id = 30051,
        source_object_index = 51,
        source_class = "Door",
        source_name = "Door9",
        kind = "linear_door",
        hint = "Door9",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900052,
        event_id = 30052,
        source_object_index = 52,
        source_class = "Door",
        source_name = "Door10",
        kind = "linear_door",
        hint = "Door10",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900053,
        event_id = 30053,
        source_object_index = 53,
        source_class = "Door",
        source_name = "Door0",
        kind = "linear_door",
        hint = "Door0",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900054,
        event_id = 30054,
        source_object_index = 54,
        source_class = "Door",
        source_name = "Door4",
        kind = "linear_door",
        hint = "Door4",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900055,
        event_id = 30055,
        source_object_index = 55,
        source_class = "Door",
        source_name = "Door27",
        kind = "linear_door",
        hint = "Door27",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900056,
        event_id = 30056,
        source_object_index = 56,
        source_class = "Door",
        source_name = "Door18",
        kind = "linear_door",
        hint = "Door18",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900057,
        event_id = 30057,
        source_object_index = 57,
        source_class = "Door",
        source_name = "Door1",
        kind = "linear_door",
        hint = "Door1",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900058,
        event_id = 30058,
        source_object_index = 58,
        source_class = "Door",
        source_name = "Door28",
        kind = "linear_door",
        hint = "Door28",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900059,
        event_id = 30059,
        source_object_index = 59,
        source_class = "Door",
        source_name = "Door30",
        kind = "linear_door",
        hint = "Door30",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900060,
        event_id = 30060,
        source_object_index = 60,
        source_class = "Door",
        source_name = "Door31",
        kind = "linear_door",
        hint = "Door31",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900061,
        event_id = 30061,
        source_object_index = 61,
        source_class = "Door",
        source_name = "Door12",
        kind = "linear_door",
        hint = "Door12",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900062,
        event_id = 30062,
        source_object_index = 62,
        source_class = "Door",
        source_name = "Door11",
        kind = "linear_door",
        hint = "Door11",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900063,
        event_id = 30063,
        source_object_index = 63,
        source_class = "Door",
        source_name = "Door7",
        kind = "linear_door",
        hint = "Door7",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900064,
        event_id = 30064,
        source_object_index = 64,
        source_class = "Door",
        source_name = "Door13",
        kind = "linear_door",
        hint = "Door13",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900065,
        event_id = 30065,
        source_object_index = 65,
        source_class = "Door",
        source_name = "Door14",
        kind = "linear_door",
        hint = "Door14",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900066,
        event_id = 30066,
        source_object_index = 66,
        source_class = "Door",
        source_name = "Door8",
        kind = "linear_door",
        hint = "Door8",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900067,
        event_id = 30067,
        source_object_index = 67,
        source_class = "Door",
        source_name = "Door16",
        kind = "linear_door",
        hint = "Door16",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900068,
        event_id = 30068,
        source_object_index = 68,
        source_class = "Door",
        source_name = "Door20",
        kind = "linear_door",
        hint = "Door20",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900069,
        event_id = 30069,
        source_object_index = 69,
        source_class = "Door",
        source_name = "Door19",
        kind = "linear_door",
        hint = "Door19",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900070,
        event_id = 30070,
        source_object_index = 70,
        source_class = "Door",
        source_name = "Door17",
        kind = "linear_door",
        hint = "Door17",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900071,
        event_id = 30071,
        source_object_index = 71,
        source_class = "Door",
        source_name = "Door23",
        kind = "linear_door",
        hint = "Door23",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900072,
        event_id = 30072,
        source_object_index = 72,
        source_class = "Door",
        source_name = "Door21",
        kind = "linear_door",
        hint = "Door21",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900073,
        event_id = 30073,
        source_object_index = 73,
        source_class = "Door",
        source_name = "Door24",
        kind = "linear_door",
        hint = "Door24",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900076,
        event_id = 30076,
        source_object_index = 76,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor4",
        kind = "rotating_door",
        hint = "RotatingDoor4",
    },
    {
        mechanism_id = 900077,
        event_id = 30077,
        source_object_index = 77,
        source_class = "Door",
        source_name = "Door25",
        kind = "linear_door",
        hint = "Door25",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900078,
        event_id = 30078,
        source_object_index = 78,
        source_class = "Door",
        source_name = "Door29",
        kind = "linear_door",
        hint = "Door29",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900079,
        event_id = 30079,
        source_object_index = 79,
        source_class = "Door",
        source_name = "Door22",
        kind = "linear_door",
        hint = "Door22",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900080,
        event_id = 30080,
        source_object_index = 80,
        source_class = "Door",
        source_name = "Door15",
        kind = "linear_door",
        hint = "Door15",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900081,
        event_id = 30081,
        source_object_index = 81,
        source_class = "Door",
        source_name = "Door26",
        kind = "linear_door",
        hint = "Door26",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 900178,
        event_id = 30178,
        source_object_index = 178,
        source_class = "ScriptObject",
        source_name = "ScriptObject0",
        kind = "script_object",
        hint = "ScriptObject0",
    },
    {
        mechanism_id = 900246,
        event_id = 30246,
        source_object_index = 246,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900250,
        event_id = 30250,
        source_object_index = 250,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 900270,
        event_id = 30270,
        source_object_index = 270,
        source_class = "AIBarrier",
        source_name = "AIBarrier2",
        kind = "ai_barrier",
        hint = "AIBarrier2",
    },
    {
        mechanism_id = 900271,
        event_id = 30271,
        source_object_index = 271,
        source_class = "AIBarrier",
        source_name = "AIBarrier3",
        kind = "ai_barrier",
        hint = "AIBarrier3",
    },
    {
        mechanism_id = 900272,
        event_id = 30272,
        source_object_index = 272,
        source_class = "AIBarrier",
        source_name = "AIBarrier4",
        kind = "ai_barrier",
        hint = "AIBarrier4",
    },
    {
        mechanism_id = 900273,
        event_id = 30273,
        source_object_index = 273,
        source_class = "AIBarrier",
        source_name = "AIBarrier5",
        kind = "ai_barrier",
        hint = "AIBarrier5",
    },
    {
        mechanism_id = 900274,
        event_id = 30274,
        source_object_index = 274,
        source_class = "AIBarrier",
        source_name = "AIBarrier6",
        kind = "ai_barrier",
        hint = "AIBarrier6",
    },
    {
        mechanism_id = 900275,
        event_id = 30275,
        source_object_index = 275,
        source_class = "AIBarrier",
        source_name = "AIBarrier7",
        kind = "ai_barrier",
        hint = "AIBarrier7",
    },
    {
        mechanism_id = 900492,
        event_id = 30492,
        source_object_index = 492,
        source_class = "AIBarrier",
        source_name = "AIBarrier8",
        kind = "ai_barrier",
        hint = "AIBarrier8",
    },
    {
        mechanism_id = 900493,
        event_id = 30493,
        source_object_index = 493,
        source_class = "AIBarrier",
        source_name = "AIBarrier10",
        kind = "ai_barrier",
        hint = "AIBarrier10",
    },
    {
        mechanism_id = 900494,
        event_id = 30494,
        source_object_index = 494,
        source_class = "AIBarrier",
        source_name = "AIBarrier9",
        kind = "ai_barrier",
        hint = "AIBarrier9",
    },
    {
        mechanism_id = 900637,
        event_id = 30637,
        source_object_index = 637,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor2",
        kind = "rotating_door",
        hint = "RotatingDoor2",
        sounds = {
            ["open_start"] = {
                name = "Door/door02open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door02close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900638,
        event_id = 30638,
        source_object_index = 638,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor7",
        kind = "rotating_door",
        hint = "RotatingDoor7",
        sounds = {
            ["open_start"] = {
                name = "Door/door02open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door02close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900847,
        event_id = 30847,
        source_object_index = 847,
        source_class = "Door",
        source_name = "Gate8L",
        kind = "linear_door",
        hint = "Gate8L",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900848,
        event_id = 30848,
        source_object_index = 848,
        source_class = "Door",
        source_name = "Gate8R",
        kind = "linear_door",
        hint = "Gate8R",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900850,
        event_id = 30850,
        source_object_index = 850,
        source_class = "Door",
        source_name = "Gate7L",
        kind = "linear_door",
        hint = "Gate7L",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900851,
        event_id = 30851,
        source_object_index = 851,
        source_class = "Door",
        source_name = "Gate7R",
        kind = "linear_door",
        hint = "Gate7R",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900853,
        event_id = 30853,
        source_object_index = 853,
        source_class = "Door",
        source_name = "Gate6L",
        kind = "linear_door",
        hint = "Gate6L",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900854,
        event_id = 30854,
        source_object_index = 854,
        source_class = "Door",
        source_name = "Gate6R",
        kind = "linear_door",
        hint = "Gate6R",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900856,
        event_id = 30856,
        source_object_index = 856,
        source_class = "Door",
        source_name = "Gate5L",
        kind = "linear_door",
        hint = "Gate5L",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900857,
        event_id = 30857,
        source_object_index = 857,
        source_class = "Door",
        source_name = "Gate5R",
        kind = "linear_door",
        hint = "Gate5R",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900859,
        event_id = 30859,
        source_object_index = 859,
        source_class = "Door",
        source_name = "Gate4L",
        kind = "linear_door",
        hint = "Gate4L",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900860,
        event_id = 30860,
        source_object_index = 860,
        source_class = "Door",
        source_name = "Gate4R",
        kind = "linear_door",
        hint = "Gate4R",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900862,
        event_id = 30862,
        source_object_index = 862,
        source_class = "Door",
        source_name = "Gate3L",
        kind = "linear_door",
        hint = "Gate3L",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900863,
        event_id = 30863,
        source_object_index = 863,
        source_class = "Door",
        source_name = "Gate3R",
        kind = "linear_door",
        hint = "Gate3R",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900865,
        event_id = 30865,
        source_object_index = 865,
        source_class = "Door",
        source_name = "Gate1L",
        kind = "linear_door",
        hint = "Gate1L",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900866,
        event_id = 30866,
        source_object_index = 866,
        source_class = "Door",
        source_name = "Gate1R",
        kind = "linear_door",
        hint = "Gate1R",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900868,
        event_id = 30868,
        source_object_index = 868,
        source_class = "Door",
        source_name = "Gate2L",
        kind = "linear_door",
        hint = "Gate2L",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900869,
        event_id = 30869,
        source_object_index = 869,
        source_class = "Door",
        source_name = "Gate2R",
        kind = "linear_door",
        hint = "Gate2R",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900872,
        event_id = 30872,
        source_object_index = 872,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor3",
        kind = "rotating_door",
        hint = "RotatingDoor3",
        sounds = {
            ["open_start"] = {
                name = "Door/cell_door_open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/cell_door_close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900876,
        event_id = 30876,
        source_object_index = 876,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900877,
        event_id = 30877,
        source_object_index = 877,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900878,
        event_id = 30878,
        source_object_index = 878,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900879,
        event_id = 30879,
        source_object_index = 879,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900880,
        event_id = 30880,
        source_object_index = 880,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 900881,
        event_id = 30881,
        source_object_index = 881,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 900882,
        event_id = 30882,
        source_object_index = 882,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 900883,
        event_id = 30883,
        source_object_index = 883,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush7",
        kind = "perception_brush",
        hint = "PerceptionBrush7",
    },
    {
        mechanism_id = 900885,
        event_id = 30885,
        source_object_index = 885,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900886,
        event_id = 30886,
        source_object_index = 886,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900887,
        event_id = 30887,
        source_object_index = 887,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900888,
        event_id = 30888,
        source_object_index = 888,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 900898,
        event_id = 30898,
        source_object_index = 898,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush8",
        kind = "perception_brush",
        hint = "PerceptionBrush8",
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
    [30004] = { kind = "open_door", source = "mm9_mechanism", targetName = "TavernL" },
    [30005] = { kind = "open_door", source = "mm9_mechanism", targetName = "TavernR" },
    [30006] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor16" },
    [30007] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor17" },
    [30008] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor19" },
    [30009] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor20" },
    [30010] = { kind = "open_door", source = "mm9_mechanism", targetName = "Bar" },
    [30011] = { kind = "open_door", source = "mm9_mechanism", targetName = "Curtain" },
    [30013] = { kind = "open_door", source = "mm9_mechanism", targetName = "TempleL" },
    [30014] = { kind = "open_door", source = "mm9_mechanism", targetName = "TempleR" },
    [30016] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0" },
    [30017] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor1" },
    [30018] = { kind = "open_door", source = "mm9_mechanism", targetName = "ThroneL" },
    [30019] = { kind = "open_door", source = "mm9_mechanism", targetName = "ThroneR" },
    [30020] = { kind = "open_door", source = "mm9_mechanism", targetName = "PalaceL" },
    [30021] = { kind = "open_door", source = "mm9_mechanism", targetName = "PalaceR" },
    [30024] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor10" },
    [30025] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor11" },
    [30026] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor12" },
    [30027] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor13" },
    [30040] = { kind = "open_door", source = "mm9_mechanism", targetName = "Apothdoor" },
    [30041] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door2" },
    [30042] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door3" },
    [30043] = { kind = "open_door", source = "mm9_mechanism", targetName = "BankL" },
    [30044] = { kind = "open_door", source = "mm9_mechanism", targetName = "BankR" },
    [30046] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door32" },
    [30047] = { kind = "open_door", source = "mm9_mechanism", targetName = "Magidoor" },
    [30050] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door6" },
    [30051] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door9" },
    [30052] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door10" },
    [30053] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door0" },
    [30054] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door4" },
    [30055] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door27" },
    [30056] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door18" },
    [30057] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1" },
    [30058] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door28" },
    [30059] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door30" },
    [30060] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door31" },
    [30061] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door12" },
    [30062] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door11" },
    [30063] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door7" },
    [30064] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door13" },
    [30065] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door14" },
    [30066] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door8" },
    [30067] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door16" },
    [30068] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door20" },
    [30069] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door19" },
    [30070] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door17" },
    [30071] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door23" },
    [30072] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door21" },
    [30073] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door24" },
    [30076] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor4" },
    [30077] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door25" },
    [30078] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door29" },
    [30079] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door22" },
    [30080] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door15" },
    [30081] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door26" },
    [30637] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor2" },
    [30638] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor7" },
    [30847] = { kind = "open_door", source = "mm9_mechanism", targetName = "Gate8L" },
    [30848] = { kind = "open_door", source = "mm9_mechanism", targetName = "Gate8R" },
    [30850] = { kind = "open_door", source = "mm9_mechanism", targetName = "Gate7L" },
    [30851] = { kind = "open_door", source = "mm9_mechanism", targetName = "Gate7R" },
    [30853] = { kind = "open_door", source = "mm9_mechanism", targetName = "Gate6L" },
    [30854] = { kind = "open_door", source = "mm9_mechanism", targetName = "Gate6R" },
    [30856] = { kind = "open_door", source = "mm9_mechanism", targetName = "Gate5L" },
    [30857] = { kind = "open_door", source = "mm9_mechanism", targetName = "Gate5R" },
    [30859] = { kind = "open_door", source = "mm9_mechanism", targetName = "Gate4L" },
    [30860] = { kind = "open_door", source = "mm9_mechanism", targetName = "Gate4R" },
    [30862] = { kind = "open_door", source = "mm9_mechanism", targetName = "Gate3L" },
    [30863] = { kind = "open_door", source = "mm9_mechanism", targetName = "Gate3R" },
    [30865] = { kind = "open_door", source = "mm9_mechanism", targetName = "Gate1L" },
    [30866] = { kind = "open_door", source = "mm9_mechanism", targetName = "Gate1R" },
    [30868] = { kind = "open_door", source = "mm9_mechanism", targetName = "Gate2L" },
    [30869] = { kind = "open_door", source = "mm9_mechanism", targetName = "Gate2R" },
    [30872] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor3" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30004, "TavernL", function()
    map.triggerMechanism(4, 2)
end, "TavernL")

RegisterEvent(30005, "TavernR", function()
    map.triggerMechanism(5, 2)
end, "TavernR")

RegisterEvent(30006, "RotatingDoor16", function()
    map.triggerMechanism(6, 2)
end, "RotatingDoor16")

RegisterEvent(30007, "RotatingDoor17", function()
    map.triggerMechanism(7, 2)
end, "RotatingDoor17")

RegisterEvent(30008, "RotatingDoor19", function()
    map.triggerMechanism(8, 2)
end, "RotatingDoor19")

RegisterEvent(30009, "RotatingDoor20", function()
    map.triggerMechanism(9, 2)
end, "RotatingDoor20")

RegisterEvent(30010, "Bar", function()
    map.triggerMechanism(10, 2)
end, "Bar")

RegisterEvent(30011, "Curtain", function()
    map.triggerMechanism(11, 2)
end, "Curtain")

RegisterEvent(30013, "TempleL", function()
    map.triggerMechanism(13, 2)
end, "TempleL")

RegisterEvent(30014, "TempleR", function()
    map.triggerMechanism(14, 2)
end, "TempleR")

RegisterEvent(30016, "RotatingDoor0", function()
    map.triggerMechanism(16, 2)
end, "RotatingDoor0")

RegisterEvent(30017, "RotatingDoor1", function()
    map.triggerMechanism(17, 2)
end, "RotatingDoor1")

RegisterEvent(30018, "ThroneL", function()
    map.triggerMechanism(18, 2)
end, "ThroneL")

RegisterEvent(30019, "ThroneR", function()
    map.triggerMechanism(19, 2)
end, "ThroneR")

RegisterEvent(30020, "PalaceL", function()
    map.triggerMechanism(20, 2)
end, "PalaceL")

RegisterEvent(30021, "PalaceR", function()
    map.triggerMechanism(21, 2)
end, "PalaceR")

RegisterEvent(30024, "RotatingDoor10", function()
    map.triggerMechanism(24, 2)
end, "RotatingDoor10")

RegisterEvent(30025, "RotatingDoor11", function()
    map.triggerMechanism(25, 2)
end, "RotatingDoor11")

RegisterEvent(30026, "RotatingDoor12", function()
    map.triggerMechanism(26, 2)
end, "RotatingDoor12")

RegisterEvent(30027, "RotatingDoor13", function()
    map.triggerMechanism(27, 2)
end, "RotatingDoor13")

RegisterEvent(30040, "Apothdoor", function()
    map.triggerMechanism(40, 2)
end, "Apothdoor")

RegisterEvent(30041, "Door2", function()
    map.triggerMechanism(41, 2)
end, "Door2")

RegisterEvent(30042, "Door3", function()
    map.triggerMechanism(42, 2)
end, "Door3")

RegisterEvent(30043, "BankL", function()
    map.triggerMechanism(43, 2)
end, "BankL")

RegisterEvent(30044, "BankR", function()
    map.triggerMechanism(44, 2)
end, "BankR")

RegisterEvent(30046, "Door32", function()
    map.triggerMechanism(46, 2)
end, "Door32")

RegisterEvent(30047, "Magidoor", function()
    map.triggerMechanism(47, 2)
end, "Magidoor")

RegisterEvent(30050, "Door6", function()
    map.triggerMechanism(50, 2)
end, "Door6")

RegisterEvent(30051, "Door9", function()
    map.triggerMechanism(51, 2)
end, "Door9")

RegisterEvent(30052, "Door10", function()
    map.triggerMechanism(52, 2)
end, "Door10")

RegisterEvent(30053, "Door0", function()
    map.triggerMechanism(53, 2)
end, "Door0")

RegisterEvent(30054, "Door4", function()
    map.triggerMechanism(54, 2)
end, "Door4")

RegisterEvent(30055, "Door27", function()
    map.triggerMechanism(55, 2)
end, "Door27")

RegisterEvent(30056, "Door18", function()
    map.triggerMechanism(56, 2)
end, "Door18")

RegisterEvent(30057, "Door1", function()
    map.triggerMechanism(57, 2)
end, "Door1")

RegisterEvent(30058, "Door28", function()
    map.triggerMechanism(58, 2)
end, "Door28")

RegisterEvent(30059, "Door30", function()
    map.triggerMechanism(59, 2)
end, "Door30")

RegisterEvent(30060, "Door31", function()
    map.triggerMechanism(60, 2)
end, "Door31")

RegisterEvent(30061, "Door12", function()
    map.triggerMechanism(61, 2)
end, "Door12")

RegisterEvent(30062, "Door11", function()
    map.triggerMechanism(62, 2)
end, "Door11")

RegisterEvent(30063, "Door7", function()
    map.triggerMechanism(63, 2)
end, "Door7")

RegisterEvent(30064, "Door13", function()
    map.triggerMechanism(64, 2)
end, "Door13")

RegisterEvent(30065, "Door14", function()
    map.triggerMechanism(65, 2)
end, "Door14")

RegisterEvent(30066, "Door8", function()
    map.triggerMechanism(66, 2)
end, "Door8")

RegisterEvent(30067, "Door16", function()
    map.triggerMechanism(67, 2)
end, "Door16")

RegisterEvent(30068, "Door20", function()
    map.triggerMechanism(68, 2)
end, "Door20")

RegisterEvent(30069, "Door19", function()
    map.triggerMechanism(69, 2)
end, "Door19")

RegisterEvent(30070, "Door17", function()
    map.triggerMechanism(70, 2)
end, "Door17")

RegisterEvent(30071, "Door23", function()
    map.triggerMechanism(71, 2)
end, "Door23")

RegisterEvent(30072, "Door21", function()
    map.triggerMechanism(72, 2)
end, "Door21")

RegisterEvent(30073, "Door24", function()
    map.triggerMechanism(73, 2)
end, "Door24")

RegisterEvent(30076, "RotatingDoor4", function()
    map.triggerMechanism(76, 2)
end, "RotatingDoor4")

RegisterEvent(30077, "Door25", function()
    map.triggerMechanism(77, 2)
end, "Door25")

RegisterEvent(30078, "Door29", function()
    map.triggerMechanism(78, 2)
end, "Door29")

RegisterEvent(30079, "Door22", function()
    map.triggerMechanism(79, 2)
end, "Door22")

RegisterEvent(30080, "Door15", function()
    map.triggerMechanism(80, 2)
end, "Door15")

RegisterEvent(30081, "Door26", function()
    map.triggerMechanism(81, 2)
end, "Door26")

RegisterEvent(30637, "RotatingDoor2", function()
    map.triggerMechanism(637, 2)
end, "RotatingDoor2")

RegisterEvent(30638, "RotatingDoor7", function()
    map.triggerMechanism(638, 2)
end, "RotatingDoor7")

RegisterEvent(30847, "Gate8L", function()
    map.triggerMechanism(847, 2)
end, "Gate8L")

RegisterEvent(30848, "Gate8R", function()
    map.triggerMechanism(848, 2)
end, "Gate8R")

RegisterEvent(30850, "Gate7L", function()
    map.triggerMechanism(850, 2)
end, "Gate7L")

RegisterEvent(30851, "Gate7R", function()
    map.triggerMechanism(851, 2)
end, "Gate7R")

RegisterEvent(30853, "Gate6L", function()
    map.triggerMechanism(853, 2)
end, "Gate6L")

RegisterEvent(30854, "Gate6R", function()
    map.triggerMechanism(854, 2)
end, "Gate6R")

RegisterEvent(30856, "Gate5L", function()
    map.triggerMechanism(856, 2)
end, "Gate5L")

RegisterEvent(30857, "Gate5R", function()
    map.triggerMechanism(857, 2)
end, "Gate5R")

RegisterEvent(30859, "Gate4L", function()
    map.triggerMechanism(859, 2)
end, "Gate4L")

RegisterEvent(30860, "Gate4R", function()
    map.triggerMechanism(860, 2)
end, "Gate4R")

RegisterEvent(30862, "Gate3L", function()
    map.triggerMechanism(862, 2)
end, "Gate3L")

RegisterEvent(30863, "Gate3R", function()
    map.triggerMechanism(863, 2)
end, "Gate3R")

RegisterEvent(30865, "Gate1L", function()
    map.triggerMechanism(865, 2)
end, "Gate1L")

RegisterEvent(30866, "Gate1R", function()
    map.triggerMechanism(866, 2)
end, "Gate1R")

RegisterEvent(30868, "Gate2L", function()
    map.triggerMechanism(868, 2)
end, "Gate2L")

RegisterEvent(30869, "Gate2R", function()
    map.triggerMechanism(869, 2)
end, "Gate2R")

RegisterEvent(30872, "RotatingDoor3", function()
    map.triggerMechanism(872, 2)
end, "RotatingDoor3")

map.scripts["abriel.scr"] = {
    source = "ABRIEL.scr",
    registered_triggers = {
        { line = 254, message = "walk1", callback = "OnWalk1" },
        { line = 255, message = "speak4", callback = "OnSpeak4" },
        { line = 256, message = "speak6", callback = "OnSpeak6" },
        { line = 257, message = "speak8", callback = "OnSpeak8" },
        { line = 258, message = "Speak14", callback = "OnSpeak14" },
        { line = 259, message = "Speak17", callback = "OnSpeak17" },
        { line = 260, message = "Speak19", callback = "OnSpeak19" },
        { line = 261, message = "Exit", callback = "OnExit" },
        { line = 262, message = "Walk2", callback = "OnWalk2" },
        { line = 263, message = "CastCall", callback = "OnCastCall" },
        { line = 264, message = "Bow", callback = "OnBow" },
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
map.scripts["foradworld.scr"] = {
    source = "FORADWORLD.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["leffery.scr"] = {
    source = "LEFFERY.scr",
    registered_triggers = {
        { line = 137, message = "Start", callback = "OnStart" },
        { line = 138, message = "Speak12", callback = "OnSpeak12" },
        { line = 139, message = "speak14", callback = "OnSpeak14" },
        { line = 140, message = "target", callback = "OnTarget" },
        { line = 141, message = "Exit", callback = "OnExit" },
        { line = 142, message = "Walk2", callback = "OnWalk2" },
        { line = 143, message = "CastCall", callback = "OnCastCall" },
        { line = 144, message = "Bow", callback = "OnBow" },
    },
    movement_commands = {
    },
}
map.scripts["narrator.scr"] = {
    source = "NARRATOR.scr",
    registered_triggers = {
        { line = 251, message = "start", callback = "Onstart" },
        { line = 252, message = "stop", callback = "OnStop" },
        { line = 253, message = "Speak9", callback = "OnSpeak9" },
        { line = 254, message = "Speak21", callback = "OnSpeak21" },
        { line = 255, message = "Speak22", callback = "OnSpeak22" },
        { line = 256, message = "Speak27", callback = "OnSpeak27" },
    },
    movement_commands = {
    },
}
map.scripts["npc127.scr"] = {
    source = "NPC127.scr",
    registered_triggers = {
        { line = 222, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc128.scr"] = {
    source = "NPC128.scr",
    registered_triggers = {
        { line = 161, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc129.scr"] = {
    source = "NPC129.scr",
    registered_triggers = {
        { line = 171, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc131.scr"] = {
    source = "NPC131.scr",
    registered_triggers = {
        { line = 82, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc141.scr"] = {
    source = "NPC141.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["npc142.scr"] = {
    source = "NPC142.scr",
    registered_triggers = {
        { line = 107, message = "Use", callback = "OnUse" },
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
map.scripts["ralof.scr"] = {
    source = "RALOF.scr",
    registered_triggers = {
        { line = 297, message = "start", callback = "OnStart" },
        { line = 298, message = "Speak11", callback = "OnSpeak11" },
        { line = 299, message = "Speak13", callback = "OnSpeak13" },
        { line = 300, message = "Speak16", callback = "OnSpeak16" },
        { line = 301, message = "Speak18", callback = "OnSpeak18" },
        { line = 302, message = "Speak20", callback = "OnSpeak20" },
        { line = 303, message = "Exit", callback = "OnExit" },
        { line = 304, message = "Walk2", callback = "OnWalk2" },
        { line = 305, message = "Speak24", callback = "OnSpeak24" },
        { line = 306, message = "Speak26", callback = "OnSpeak26" },
        { line = 307, message = "CastCall", callback = "OnCastCall" },
        { line = 308, message = "Bow", callback = "OnBow" },
        { line = 309, message = "Wince", callback = "OnWince" },
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
map.scripts["trislan.scr"] = {
    source = "TRISLAN.scr",
    registered_triggers = {
        { line = 235, message = "Walk1", callback = "OnWalk1" },
        { line = 236, message = "Speak5", callback = "OnSpeak5" },
        { line = 237, message = "Speak7", callback = "OnSpeak7" },
        { line = 238, message = "Walk2", callback = "OnWalk2" },
        { line = 239, message = "exit", callback = "Onexit" },
        { line = 240, message = "Speak23", callback = "OnSpeak23" },
        { line = 241, message = "Speak25", callback = "OnSpeak25" },
        { line = 242, message = "Die", callback = "OnDie" },
        { line = 243, message = "CastCall", callback = "OnCastCall" },
        { line = 244, message = "Bow", callback = "OnBow" },
    },
    movement_commands = {
    },
}
map.scripts["wilam.scr"] = {
    source = "WILAM.scr",
    registered_triggers = {
        { line = 153, message = "Start", callback = "OnStart" },
        { line = 154, message = "Speak9", callback = "OnSpeak9" },
        { line = 155, message = "target", callback = "OnTarget" },
        { line = 156, message = "Attention", callback = "OnAttention" },
        { line = 157, message = "Exit", callback = "OnExit" },
        { line = 158, message = "walk2", callback = "OnWalk2" },
        { line = 159, message = "CastCall", callback = "OnCastCall" },
        { line = 160, message = "Bow", callback = "OnBow" },
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
