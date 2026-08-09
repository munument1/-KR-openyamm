-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "drangheimprison"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 408,
        source_name = "DPSecretStart",
        x = 532,
        y = -614,
        z = -4293,
        direction_yaw_units = 1365,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 1043,
        source_name = "DPFrontDoor",
        x = -2171,
        y = -7148,
        z = -2089,
        direction_yaw_units = 0,
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
        source_class = "BlueWater",
        source_name = "SinkWater0",
        kind = "water_volume",
        hint = "SinkWater0",
    },
    {
        mechanism_id = 900001,
        event_id = 30001,
        source_object_index = 1,
        source_class = "RotatingDoor",
        source_name = "lever6",
        kind = "rotating_door",
        hint = "lever6",
    },
    {
        mechanism_id = 900002,
        event_id = 30002,
        source_object_index = 2,
        source_class = "RotatingDoor",
        source_name = "lever7",
        kind = "rotating_door",
        hint = "lever7",
    },
    {
        mechanism_id = 900003,
        event_id = 30003,
        source_object_index = 3,
        source_class = "RotatingDoor",
        source_name = "lever8",
        kind = "rotating_door",
        hint = "lever8",
    },
    {
        mechanism_id = 900004,
        event_id = 30004,
        source_object_index = 4,
        source_class = "RotatingDoor",
        source_name = "lever9",
        kind = "rotating_door",
        hint = "lever9",
    },
    {
        mechanism_id = 900005,
        event_id = 30005,
        source_object_index = 5,
        source_class = "RotatingDoor",
        source_name = "lever10",
        kind = "rotating_door",
        hint = "lever10",
    },
    {
        mechanism_id = 900006,
        event_id = 30006,
        source_object_index = 6,
        source_class = "RotatingDoor",
        source_name = "lever11",
        kind = "rotating_door",
        hint = "lever11",
    },
    {
        mechanism_id = 900007,
        event_id = 30007,
        source_object_index = 7,
        source_class = "RotatingDoor",
        source_name = "lever12",
        kind = "rotating_door",
        hint = "lever12",
    },
    {
        mechanism_id = 900008,
        event_id = 30008,
        source_object_index = 8,
        source_class = "RotatingDoor",
        source_name = "lever15",
        kind = "rotating_door",
        hint = "lever15",
    },
    {
        mechanism_id = 900009,
        event_id = 30009,
        source_object_index = 9,
        source_class = "RotatingDoor",
        source_name = "lever17",
        kind = "rotating_door",
        hint = "lever17",
    },
    {
        mechanism_id = 900010,
        event_id = 30010,
        source_object_index = 10,
        source_class = "RotatingDoor",
        source_name = "lever24",
        kind = "rotating_door",
        hint = "lever24",
    },
    {
        mechanism_id = 900011,
        event_id = 30011,
        source_object_index = 11,
        source_class = "RotatingDoor",
        source_name = "lever25",
        kind = "rotating_door",
        hint = "lever25",
    },
    {
        mechanism_id = 900012,
        event_id = 30012,
        source_object_index = 12,
        source_class = "RotatingDoor",
        source_name = "lever26",
        kind = "rotating_door",
        hint = "lever26",
    },
    {
        mechanism_id = 900013,
        event_id = 30013,
        source_object_index = 13,
        source_class = "RotatingDoor",
        source_name = "lever27",
        kind = "rotating_door",
        hint = "lever27",
    },
    {
        mechanism_id = 900014,
        event_id = 30014,
        source_object_index = 14,
        source_class = "RotatingDoor",
        source_name = "lever28",
        kind = "rotating_door",
        hint = "lever28",
    },
    {
        mechanism_id = 900019,
        event_id = 30019,
        source_object_index = 19,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 900020,
        event_id = 30020,
        source_object_index = 20,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900021,
        event_id = 30021,
        source_object_index = 21,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900022,
        event_id = 30022,
        source_object_index = 22,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900389,
        event_id = 30389,
        source_object_index = 389,
        source_class = "DestructableProp",
        source_name = "Barrel16",
        kind = "destructible_prop",
        hint = "Barrel16",
    },
    {
        mechanism_id = 900404,
        event_id = 30404,
        source_object_index = 404,
        source_class = "DestructableProp",
        source_name = "Barrel12",
        kind = "destructible_prop",
        hint = "Barrel12",
    },
    {
        mechanism_id = 900405,
        event_id = 30405,
        source_object_index = 405,
        source_class = "DestructableProp",
        source_name = "Barrel13",
        kind = "destructible_prop",
        hint = "Barrel13",
    },
    {
        mechanism_id = 900407,
        event_id = 30407,
        source_object_index = 407,
        source_class = "DestructableProp",
        source_name = "Barrel15",
        kind = "destructible_prop",
        hint = "Barrel15",
    },
    {
        mechanism_id = 900516,
        event_id = 30516,
        source_object_index = 516,
        source_class = "RotatingDoor",
        source_name = "Celldoor1",
        kind = "rotating_door",
        hint = "Celldoor1",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900517,
        event_id = 30517,
        source_object_index = 517,
        source_class = "RotatingDoor",
        source_name = "Celldoor2",
        kind = "rotating_door",
        hint = "Celldoor2",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900518,
        event_id = 30518,
        source_object_index = 518,
        source_class = "RotatingDoor",
        source_name = "Celldoor3",
        kind = "rotating_door",
        hint = "Celldoor3",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900519,
        event_id = 30519,
        source_object_index = 519,
        source_class = "RotatingDoor",
        source_name = "Celldoor4",
        kind = "rotating_door",
        hint = "Celldoor4",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900520,
        event_id = 30520,
        source_object_index = 520,
        source_class = "RotatingDoor",
        source_name = "Celldoor5",
        kind = "rotating_door",
        hint = "Celldoor5",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900521,
        event_id = 30521,
        source_object_index = 521,
        source_class = "RotatingDoor",
        source_name = "Celldoor6",
        kind = "rotating_door",
        hint = "Celldoor6",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900522,
        event_id = 30522,
        source_object_index = 522,
        source_class = "Door",
        source_name = "ElevatorDoorL",
        kind = "linear_door",
        hint = "ElevatorDoorL",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900523,
        event_id = 30523,
        source_object_index = 523,
        source_class = "Door",
        source_name = "ElevatorDoorR",
        kind = "linear_door",
        hint = "ElevatorDoorR",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900524,
        event_id = 30524,
        source_object_index = 524,
        source_class = "Door",
        source_name = "DDoor3a",
        kind = "linear_door",
        hint = "DDoor3a",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900525,
        event_id = 30525,
        source_object_index = 525,
        source_class = "Door",
        source_name = "DDoor3b",
        kind = "linear_door",
        hint = "DDoor3b",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900526,
        event_id = 30526,
        source_object_index = 526,
        source_class = "RotatingDoor",
        source_name = "SingleDoor1",
        kind = "rotating_door",
        hint = "SingleDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900527,
        event_id = 30527,
        source_object_index = 527,
        source_class = "RotatingDoor",
        source_name = "RightDoor0",
        kind = "rotating_door",
        hint = "RightDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900528,
        event_id = 30528,
        source_object_index = 528,
        source_class = "RotatingDoor",
        source_name = "LeftDoor0",
        kind = "rotating_door",
        hint = "LeftDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900529,
        event_id = 30529,
        source_object_index = 529,
        source_class = "Door",
        source_name = "DDoor4a",
        kind = "linear_door",
        hint = "DDoor4a",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900530,
        event_id = 30530,
        source_object_index = 530,
        source_class = "Door",
        source_name = "DDoor4b",
        kind = "linear_door",
        hint = "DDoor4b",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900531,
        event_id = 30531,
        source_object_index = 531,
        source_class = "Door",
        source_name = "DDoor5a",
        kind = "linear_door",
        hint = "DDoor5a",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900532,
        event_id = 30532,
        source_object_index = 532,
        source_class = "Door",
        source_name = "DDoor5b",
        kind = "linear_door",
        hint = "DDoor5b",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900533,
        event_id = 30533,
        source_object_index = 533,
        source_class = "Door",
        source_name = "DDoor6a",
        kind = "linear_door",
        hint = "DDoor6a",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900534,
        event_id = 30534,
        source_object_index = 534,
        source_class = "Door",
        source_name = "DDoor6b",
        kind = "linear_door",
        hint = "DDoor6b",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900535,
        event_id = 30535,
        source_object_index = 535,
        source_class = "Door",
        source_name = "DDoor7a",
        kind = "linear_door",
        hint = "DDoor7a",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900536,
        event_id = 30536,
        source_object_index = 536,
        source_class = "Door",
        source_name = "DDoor7b",
        kind = "linear_door",
        hint = "DDoor7b",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900537,
        event_id = 30537,
        source_object_index = 537,
        source_class = "Door",
        source_name = "DDoor8a",
        kind = "linear_door",
        hint = "DDoor8a",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900538,
        event_id = 30538,
        source_object_index = 538,
        source_class = "Door",
        source_name = "DDoor8b",
        kind = "linear_door",
        hint = "DDoor8b",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900539,
        event_id = 30539,
        source_object_index = 539,
        source_class = "Door",
        source_name = "Door0",
        kind = "linear_door",
        hint = "Door0",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900540,
        event_id = 30540,
        source_object_index = 540,
        source_class = "RotatingDoor",
        source_name = "BarrackDoor1",
        kind = "rotating_door",
        hint = "BarrackDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900541,
        event_id = 30541,
        source_object_index = 541,
        source_class = "RotatingDoor",
        source_name = "BarrackDoor02",
        kind = "rotating_door",
        hint = "BarrackDoor02",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900542,
        event_id = 30542,
        source_object_index = 542,
        source_class = "Door",
        source_name = "Door2",
        kind = "linear_door",
        hint = "Door2",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900543,
        event_id = 30543,
        source_object_index = 543,
        source_class = "RotatingDoor",
        source_name = "LidWheel1",
        kind = "rotating_door",
        hint = "LidWheel1",
        sounds = {
            ["open_busy"] = {
                name = "Ambient/PullySqueak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Ambient/PullySqueak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900544,
        event_id = 30544,
        source_object_index = 544,
        source_class = "RotatingDoor",
        source_name = "Lid1",
        kind = "rotating_door",
        hint = "Lid1",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900545,
        event_id = 30545,
        source_object_index = 545,
        source_class = "RotatingDoor",
        source_name = "MessHallDoor0",
        kind = "rotating_door",
        hint = "MessHallDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900546,
        event_id = 30546,
        source_object_index = 546,
        source_class = "RotatingDoor",
        source_name = "Celldoor29",
        kind = "rotating_door",
        hint = "Celldoor29",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900547,
        event_id = 30547,
        source_object_index = 547,
        source_class = "RotatingDoor",
        source_name = "Celldoor7",
        kind = "rotating_door",
        hint = "Celldoor7",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900548,
        event_id = 30548,
        source_object_index = 548,
        source_class = "RotatingDoor",
        source_name = "Celldoor8",
        kind = "rotating_door",
        hint = "Celldoor8",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900549,
        event_id = 30549,
        source_object_index = 549,
        source_class = "RotatingDoor",
        source_name = "Celldoor9",
        kind = "rotating_door",
        hint = "Celldoor9",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900550,
        event_id = 30550,
        source_object_index = 550,
        source_class = "RotatingDoor",
        source_name = "Celldoor10",
        kind = "rotating_door",
        hint = "Celldoor10",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900551,
        event_id = 30551,
        source_object_index = 551,
        source_class = "RotatingDoor",
        source_name = "Celldoor11",
        kind = "rotating_door",
        hint = "Celldoor11",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900552,
        event_id = 30552,
        source_object_index = 552,
        source_class = "RotatingDoor",
        source_name = "Celldoor12",
        kind = "rotating_door",
        hint = "Celldoor12",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900553,
        event_id = 30553,
        source_object_index = 553,
        source_class = "RotatingDoor",
        source_name = "Celldoor18",
        kind = "rotating_door",
        hint = "Celldoor18",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900554,
        event_id = 30554,
        source_object_index = 554,
        source_class = "RotatingDoor",
        source_name = "Celldoor25",
        kind = "rotating_door",
        hint = "Celldoor25",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900555,
        event_id = 30555,
        source_object_index = 555,
        source_class = "RotatingDoor",
        source_name = "Celldoor26",
        kind = "rotating_door",
        hint = "Celldoor26",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900556,
        event_id = 30556,
        source_object_index = 556,
        source_class = "RotatingDoor",
        source_name = "Celldoor27",
        kind = "rotating_door",
        hint = "Celldoor27",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900557,
        event_id = 30557,
        source_object_index = 557,
        source_class = "RotatingDoor",
        source_name = "Celldoor28",
        kind = "rotating_door",
        hint = "Celldoor28",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900558,
        event_id = 30558,
        source_object_index = 558,
        source_class = "RotatingDoor",
        source_name = "Celldoor30",
        kind = "rotating_door",
        hint = "Celldoor30",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900561,
        event_id = 30561,
        source_object_index = 561,
        source_class = "RotatingDoor",
        source_name = "Celldoor31",
        kind = "rotating_door",
        hint = "Celldoor31",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900562,
        event_id = 30562,
        source_object_index = 562,
        source_class = "RotatingDoor",
        source_name = "Celldoor32",
        kind = "rotating_door",
        hint = "Celldoor32",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900563,
        event_id = 30563,
        source_object_index = 563,
        source_class = "RotatingDoor",
        source_name = "Celldoor33",
        kind = "rotating_door",
        hint = "Celldoor33",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900564,
        event_id = 30564,
        source_object_index = 564,
        source_class = "RotatingDoor",
        source_name = "Celldoor34",
        kind = "rotating_door",
        hint = "Celldoor34",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900565,
        event_id = 30565,
        source_object_index = 565,
        source_class = "RotatingDoor",
        source_name = "Celldoor36",
        kind = "rotating_door",
        hint = "Celldoor36",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900566,
        event_id = 30566,
        source_object_index = 566,
        source_class = "RotatingDoor",
        source_name = "Celldoor37",
        kind = "rotating_door",
        hint = "Celldoor37",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900567,
        event_id = 30567,
        source_object_index = 567,
        source_class = "RotatingDoor",
        source_name = "Celldoor38",
        kind = "rotating_door",
        hint = "Celldoor38",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900568,
        event_id = 30568,
        source_object_index = 568,
        source_class = "RotatingDoor",
        source_name = "Celldoor35",
        kind = "rotating_door",
        hint = "Celldoor35",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900569,
        event_id = 30569,
        source_object_index = 569,
        source_class = "RotatingDoor",
        source_name = "SingleDoor9",
        kind = "rotating_door",
        hint = "SingleDoor9",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900570,
        event_id = 30570,
        source_object_index = 570,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor1",
        kind = "rotating_door",
        hint = "RotatingDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900571,
        event_id = 30571,
        source_object_index = 571,
        source_class = "RotatingDoor",
        source_name = "HallDoor1",
        kind = "rotating_door",
        hint = "HallDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900572,
        event_id = 30572,
        source_object_index = 572,
        source_class = "RotatingDoor",
        source_name = "HallDoor2",
        kind = "rotating_door",
        hint = "HallDoor2",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900573,
        event_id = 30573,
        source_object_index = 573,
        source_class = "RotatingDoor",
        source_name = "HallDoor3",
        kind = "rotating_door",
        hint = "HallDoor3",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900574,
        event_id = 30574,
        source_object_index = 574,
        source_class = "RotatingDoor",
        source_name = "HallDoor4",
        kind = "rotating_door",
        hint = "HallDoor4",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900575,
        event_id = 30575,
        source_object_index = 575,
        source_class = "Door",
        source_name = "SecretDoor0",
        kind = "linear_door",
        hint = "SecretDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900576,
        event_id = 30576,
        source_object_index = 576,
        source_class = "Door",
        source_name = "DDoor9a",
        kind = "linear_door",
        hint = "DDoor9a",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900577,
        event_id = 30577,
        source_object_index = 577,
        source_class = "Door",
        source_name = "DDoor9b",
        kind = "linear_door",
        hint = "DDoor9b",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900578,
        event_id = 30578,
        source_object_index = 578,
        source_class = "Door",
        source_name = "DDoor10a",
        kind = "linear_door",
        hint = "DDoor10a",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900579,
        event_id = 30579,
        source_object_index = 579,
        source_class = "Door",
        source_name = "DDoor10b",
        kind = "linear_door",
        hint = "DDoor10b",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900580,
        event_id = 30580,
        source_object_index = 580,
        source_class = "Door",
        source_name = "DDoor11a",
        kind = "linear_door",
        hint = "DDoor11a",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900581,
        event_id = 30581,
        source_object_index = 581,
        source_class = "Door",
        source_name = "DDoor11b",
        kind = "linear_door",
        hint = "DDoor11b",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doormetal_close02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900582,
        event_id = 30582,
        source_object_index = 582,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor10",
        kind = "rotating_door",
        hint = "RotatingDoor10",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900583,
        event_id = 30583,
        source_object_index = 583,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor11",
        kind = "rotating_door",
        hint = "RotatingDoor11",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900584,
        event_id = 30584,
        source_object_index = 584,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor6",
        kind = "rotating_door",
        hint = "RotatingDoor6",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900585,
        event_id = 30585,
        source_object_index = 585,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor7",
        kind = "rotating_door",
        hint = "RotatingDoor7",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900586,
        event_id = 30586,
        source_object_index = 586,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor8",
        kind = "rotating_door",
        hint = "RotatingDoor8",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900587,
        event_id = 30587,
        source_object_index = 587,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor9",
        kind = "rotating_door",
        hint = "RotatingDoor9",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900588,
        event_id = 30588,
        source_object_index = 588,
        source_class = "RotatingDoor",
        source_name = "Celldoor13",
        kind = "rotating_door",
        hint = "Celldoor13",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900589,
        event_id = 30589,
        source_object_index = 589,
        source_class = "RotatingDoor",
        source_name = "Celldoor17",
        kind = "rotating_door",
        hint = "Celldoor17",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900590,
        event_id = 30590,
        source_object_index = 590,
        source_class = "RotatingDoor",
        source_name = "Celldoor16",
        kind = "rotating_door",
        hint = "Celldoor16",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900591,
        event_id = 30591,
        source_object_index = 591,
        source_class = "RotatingDoor",
        source_name = "Celldoor15",
        kind = "rotating_door",
        hint = "Celldoor15",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900592,
        event_id = 30592,
        source_object_index = 592,
        source_class = "RotatingDoor",
        source_name = "Celldoor14",
        kind = "rotating_door",
        hint = "Celldoor14",
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
            ["jiggle"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900593,
        event_id = 30593,
        source_object_index = 593,
        source_class = "RotatingDoor",
        source_name = "guardstation1door",
        kind = "rotating_door",
        hint = "guardstation1door",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900594,
        event_id = 30594,
        source_object_index = 594,
        source_class = "RotatingDoor",
        source_name = "guardstation1door0",
        kind = "rotating_door",
        hint = "guardstation1door0",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900595,
        event_id = 30595,
        source_object_index = 595,
        source_class = "RotatingDoor",
        source_name = "guardstation1door1",
        kind = "rotating_door",
        hint = "guardstation1door1",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900596,
        event_id = 30596,
        source_object_index = 596,
        source_class = "RotatingDoor",
        source_name = "guardstation1door3",
        kind = "rotating_door",
        hint = "guardstation1door3",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900597,
        event_id = 30597,
        source_object_index = 597,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor3",
        kind = "rotating_door",
        hint = "RotatingDoor3",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
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
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900598,
        event_id = 30598,
        source_object_index = 598,
        source_class = "RotatingDoor",
        source_name = "RightDoor1a",
        kind = "rotating_door",
        hint = "RightDoor1a",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900599,
        event_id = 30599,
        source_object_index = 599,
        source_class = "RotatingDoor",
        source_name = "LeftDoor1a",
        kind = "rotating_door",
        hint = "LeftDoor1a",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900600,
        event_id = 30600,
        source_object_index = 600,
        source_class = "Ladder",
        source_name = "Ladder3",
        kind = "ladder_volume",
        hint = "Ladder3",
    },
    {
        mechanism_id = 900601,
        event_id = 30601,
        source_object_index = 601,
        source_class = "Ladder",
        source_name = "Ladder2",
        kind = "ladder_volume",
        hint = "Ladder2",
    },
    {
        mechanism_id = 900602,
        event_id = 30602,
        source_object_index = 602,
        source_class = "Ladder",
        source_name = "Ladder1",
        kind = "ladder_volume",
        hint = "Ladder1",
    },
    {
        mechanism_id = 900603,
        event_id = 30603,
        source_object_index = 603,
        source_class = "Ladder",
        source_name = "Ladder0",
        kind = "ladder_volume",
        hint = "Ladder0",
    },
    {
        mechanism_id = 900606,
        event_id = 30606,
        source_object_index = 606,
        source_class = "Ladder",
        source_name = "Ladder5",
        kind = "ladder_volume",
        hint = "Ladder5",
    },
    {
        mechanism_id = 900898,
        event_id = 30898,
        source_object_index = 898,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 901023,
        event_id = 31023,
        source_object_index = 1023,
        source_class = "Door",
        source_name = "Door1",
        kind = "linear_door",
        hint = "Door1",
    },
    {
        mechanism_id = 901024,
        event_id = 31024,
        source_object_index = 1024,
        source_class = "Door",
        source_name = "Door3",
        kind = "linear_door",
        hint = "Door3",
    },
    {
        mechanism_id = 901025,
        event_id = 31025,
        source_object_index = 1025,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 901027,
        event_id = 31027,
        source_object_index = 1027,
        source_class = "RotatingDoor",
        source_name = "lever0",
        kind = "rotating_door",
        hint = "lever0",
    },
    {
        mechanism_id = 901028,
        event_id = 31028,
        source_object_index = 1028,
        source_class = "RotatingDoor",
        source_name = "lever1",
        kind = "rotating_door",
        hint = "lever1",
    },
    {
        mechanism_id = 901029,
        event_id = 31029,
        source_object_index = 1029,
        source_class = "RotatingDoor",
        source_name = "lever2",
        kind = "rotating_door",
        hint = "lever2",
    },
    {
        mechanism_id = 901030,
        event_id = 31030,
        source_object_index = 1030,
        source_class = "RotatingDoor",
        source_name = "lever3",
        kind = "rotating_door",
        hint = "lever3",
    },
    {
        mechanism_id = 901031,
        event_id = 31031,
        source_object_index = 1031,
        source_class = "RotatingDoor",
        source_name = "lever4",
        kind = "rotating_door",
        hint = "lever4",
    },
    {
        mechanism_id = 901032,
        event_id = 31032,
        source_object_index = 1032,
        source_class = "RotatingDoor",
        source_name = "lever5",
        kind = "rotating_door",
        hint = "lever5",
    },
    {
        mechanism_id = 901036,
        event_id = 31036,
        source_object_index = 1036,
        source_class = "ScriptObject",
        source_name = "AlarmControl",
        kind = "script_object",
        hint = "AlarmControl",
    },
    {
        mechanism_id = 901074,
        event_id = 31074,
        source_object_index = 1074,
        source_class = "ScriptObject",
        source_name = "DRANGHEIM_FRIENDLY",
        kind = "script_object",
        hint = "DRANGHEIM_FRIENDLY",
    },
    {
        mechanism_id = 901075,
        event_id = 31075,
        source_object_index = 1075,
        source_class = "RotatingDoor",
        source_name = "blever1",
        kind = "rotating_door",
        hint = "blever1",
    },
    {
        mechanism_id = 901076,
        event_id = 31076,
        source_object_index = 1076,
        source_class = "RotatingDoor",
        source_name = "blever0",
        kind = "rotating_door",
        hint = "blever0",
    },
    {
        mechanism_id = 901077,
        event_id = 31077,
        source_object_index = 1077,
        source_class = "RotatingDoor",
        source_name = "blever2",
        kind = "rotating_door",
        hint = "blever2",
    },
    {
        mechanism_id = 901097,
        event_id = 31097,
        source_object_index = 1097,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 901098,
        event_id = 31098,
        source_object_index = 1098,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 901116,
        event_id = 31116,
        source_object_index = 1116,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 901117,
        event_id = 31117,
        source_object_index = 1117,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 901118,
        event_id = 31118,
        source_object_index = 1118,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 901119,
        event_id = 31119,
        source_object_index = 1119,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 901120,
        event_id = 31120,
        source_object_index = 1120,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 901121,
        event_id = 31121,
        source_object_index = 1121,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 901122,
        event_id = 31122,
        source_object_index = 1122,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush6",
        kind = "collision_volume",
        hint = "InvisibleBrush6",
    },
    {
        mechanism_id = 901123,
        event_id = 31123,
        source_object_index = 1123,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush7",
        kind = "collision_volume",
        hint = "InvisibleBrush7",
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
    [30001] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever6" },
    [30002] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever7" },
    [30003] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever8" },
    [30004] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever9" },
    [30005] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever10" },
    [30006] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever11" },
    [30007] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever12" },
    [30008] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever15" },
    [30009] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever17" },
    [30010] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever24" },
    [30011] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever25" },
    [30012] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever26" },
    [30013] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever27" },
    [30014] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever28" },
    [30516] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor1" },
    [30517] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor2" },
    [30518] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor3" },
    [30519] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor4" },
    [30520] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor5" },
    [30521] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor6" },
    [30522] = { kind = "open_door", source = "mm9_mechanism", targetName = "ElevatorDoorL" },
    [30523] = { kind = "open_door", source = "mm9_mechanism", targetName = "ElevatorDoorR" },
    [30524] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor3a" },
    [30525] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor3b" },
    [30526] = { kind = "open_door", source = "mm9_mechanism", targetName = "SingleDoor1" },
    [30527] = { kind = "open_door", source = "mm9_mechanism", targetName = "RightDoor0" },
    [30528] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeftDoor0" },
    [30529] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor4a" },
    [30530] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor4b" },
    [30531] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor5a" },
    [30532] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor5b" },
    [30533] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor6a" },
    [30534] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor6b" },
    [30535] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor7a" },
    [30536] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor7b" },
    [30537] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor8a" },
    [30538] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor8b" },
    [30539] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door0" },
    [30540] = { kind = "open_door", source = "mm9_mechanism", targetName = "BarrackDoor1" },
    [30541] = { kind = "open_door", source = "mm9_mechanism", targetName = "BarrackDoor02" },
    [30542] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door2" },
    [30543] = { kind = "open_door", source = "mm9_mechanism", targetName = "LidWheel1" },
    [30544] = { kind = "open_door", source = "mm9_mechanism", targetName = "Lid1" },
    [30545] = { kind = "open_door", source = "mm9_mechanism", targetName = "MessHallDoor0" },
    [30546] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor29" },
    [30547] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor7" },
    [30548] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor8" },
    [30549] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor9" },
    [30550] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor10" },
    [30551] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor11" },
    [30552] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor12" },
    [30553] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor18" },
    [30554] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor25" },
    [30555] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor26" },
    [30556] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor27" },
    [30557] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor28" },
    [30558] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor30" },
    [30561] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor31" },
    [30562] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor32" },
    [30563] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor33" },
    [30564] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor34" },
    [30565] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor36" },
    [30566] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor37" },
    [30567] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor38" },
    [30568] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor35" },
    [30569] = { kind = "open_door", source = "mm9_mechanism", targetName = "SingleDoor9" },
    [30570] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor1" },
    [30571] = { kind = "open_door", source = "mm9_mechanism", targetName = "HallDoor1" },
    [30572] = { kind = "open_door", source = "mm9_mechanism", targetName = "HallDoor2" },
    [30573] = { kind = "open_door", source = "mm9_mechanism", targetName = "HallDoor3" },
    [30574] = { kind = "open_door", source = "mm9_mechanism", targetName = "HallDoor4" },
    [30575] = { kind = "open_door", source = "mm9_mechanism", targetName = "SecretDoor0" },
    [30576] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor9a" },
    [30577] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor9b" },
    [30578] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor10a" },
    [30579] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor10b" },
    [30580] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor11a" },
    [30581] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoor11b" },
    [30582] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor10" },
    [30583] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor11" },
    [30584] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor6" },
    [30585] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor7" },
    [30586] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor8" },
    [30587] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor9" },
    [30588] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor13" },
    [30589] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor17" },
    [30590] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor16" },
    [30591] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor15" },
    [30592] = { kind = "open_door", source = "mm9_mechanism", targetName = "Celldoor14" },
    [30593] = { kind = "open_door", source = "mm9_mechanism", targetName = "guardstation1door" },
    [30594] = { kind = "open_door", source = "mm9_mechanism", targetName = "guardstation1door0" },
    [30595] = { kind = "open_door", source = "mm9_mechanism", targetName = "guardstation1door1" },
    [30596] = { kind = "open_door", source = "mm9_mechanism", targetName = "guardstation1door3" },
    [30597] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor3" },
    [30598] = { kind = "open_door", source = "mm9_mechanism", targetName = "RightDoor1a" },
    [30599] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeftDoor1a" },
    [31023] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1" },
    [31024] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door3" },
    [31027] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever0" },
    [31028] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever1" },
    [31029] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever2" },
    [31030] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever3" },
    [31031] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever4" },
    [31032] = { kind = "open_door", source = "mm9_mechanism", targetName = "lever5" },
    [31075] = { kind = "open_door", source = "mm9_mechanism", targetName = "blever1" },
    [31076] = { kind = "open_door", source = "mm9_mechanism", targetName = "blever0" },
    [31077] = { kind = "open_door", source = "mm9_mechanism", targetName = "blever2" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30001, "lever6", function()
    map.triggerMechanism(1, 2)
end, "lever6")

RegisterEvent(30002, "lever7", function()
    map.triggerMechanism(2, 2)
end, "lever7")

RegisterEvent(30003, "lever8", function()
    map.triggerMechanism(3, 2)
end, "lever8")

RegisterEvent(30004, "lever9", function()
    map.triggerMechanism(4, 2)
end, "lever9")

RegisterEvent(30005, "lever10", function()
    map.triggerMechanism(5, 2)
end, "lever10")

RegisterEvent(30006, "lever11", function()
    map.triggerMechanism(6, 2)
end, "lever11")

RegisterEvent(30007, "lever12", function()
    map.triggerMechanism(7, 2)
end, "lever12")

RegisterEvent(30008, "lever15", function()
    map.triggerMechanism(8, 2)
end, "lever15")

RegisterEvent(30009, "lever17", function()
    map.triggerMechanism(9, 2)
end, "lever17")

RegisterEvent(30010, "lever24", function()
    map.triggerMechanism(10, 2)
end, "lever24")

RegisterEvent(30011, "lever25", function()
    map.triggerMechanism(11, 2)
end, "lever25")

RegisterEvent(30012, "lever26", function()
    map.triggerMechanism(12, 2)
end, "lever26")

RegisterEvent(30013, "lever27", function()
    map.triggerMechanism(13, 2)
end, "lever27")

RegisterEvent(30014, "lever28", function()
    map.triggerMechanism(14, 2)
end, "lever28")

RegisterEvent(30516, "Celldoor1", function()
    map.triggerMechanism(516, 2)
end, "Celldoor1")

RegisterEvent(30517, "Celldoor2", function()
    map.triggerMechanism(517, 2)
end, "Celldoor2")

RegisterEvent(30518, "Celldoor3", function()
    map.triggerMechanism(518, 2)
end, "Celldoor3")

RegisterEvent(30519, "Celldoor4", function()
    map.triggerMechanism(519, 2)
end, "Celldoor4")

RegisterEvent(30520, "Celldoor5", function()
    map.triggerMechanism(520, 2)
end, "Celldoor5")

RegisterEvent(30521, "Celldoor6", function()
    map.triggerMechanism(521, 2)
end, "Celldoor6")

RegisterEvent(30522, "ElevatorDoorL", function()
    map.triggerMechanism(522, 2)
end, "ElevatorDoorL")

RegisterEvent(30523, "ElevatorDoorR", function()
    map.triggerMechanism(523, 2)
end, "ElevatorDoorR")

RegisterEvent(30524, "DDoor3a", function()
    map.triggerMechanism(524, 2)
end, "DDoor3a")

RegisterEvent(30525, "DDoor3b", function()
    map.triggerMechanism(525, 2)
end, "DDoor3b")

RegisterEvent(30526, "SingleDoor1", function()
    map.triggerMechanism(526, 2)
end, "SingleDoor1")

RegisterEvent(30527, "RightDoor0", function()
    map.triggerMechanism(527, 2)
end, "RightDoor0")

RegisterEvent(30528, "LeftDoor0", function()
    map.triggerMechanism(528, 2)
end, "LeftDoor0")

RegisterEvent(30529, "DDoor4a", function()
    map.triggerMechanism(529, 2)
end, "DDoor4a")

RegisterEvent(30530, "DDoor4b", function()
    map.triggerMechanism(530, 2)
end, "DDoor4b")

RegisterEvent(30531, "DDoor5a", function()
    map.triggerMechanism(531, 2)
end, "DDoor5a")

RegisterEvent(30532, "DDoor5b", function()
    map.triggerMechanism(532, 2)
end, "DDoor5b")

RegisterEvent(30533, "DDoor6a", function()
    map.triggerMechanism(533, 2)
end, "DDoor6a")

RegisterEvent(30534, "DDoor6b", function()
    map.triggerMechanism(534, 2)
end, "DDoor6b")

RegisterEvent(30535, "DDoor7a", function()
    map.triggerMechanism(535, 2)
end, "DDoor7a")

RegisterEvent(30536, "DDoor7b", function()
    map.triggerMechanism(536, 2)
end, "DDoor7b")

RegisterEvent(30537, "DDoor8a", function()
    map.triggerMechanism(537, 2)
end, "DDoor8a")

RegisterEvent(30538, "DDoor8b", function()
    map.triggerMechanism(538, 2)
end, "DDoor8b")

RegisterEvent(30539, "Door0", function()
    map.triggerMechanism(539, 2)
end, "Door0")

RegisterEvent(30540, "BarrackDoor1", function()
    map.triggerMechanism(540, 2)
end, "BarrackDoor1")

RegisterEvent(30541, "BarrackDoor02", function()
    map.triggerMechanism(541, 2)
end, "BarrackDoor02")

RegisterEvent(30542, "Door2", function()
    map.triggerMechanism(542, 2)
end, "Door2")

RegisterEvent(30543, "LidWheel1", function()
    map.triggerMechanism(543, 2)
end, "LidWheel1")

RegisterEvent(30544, "Lid1", function()
    map.triggerMechanism(544, 2)
end, "Lid1")

RegisterEvent(30545, "MessHallDoor0", function()
    map.triggerMechanism(545, 2)
end, "MessHallDoor0")

RegisterEvent(30546, "Celldoor29", function()
    map.triggerMechanism(546, 2)
end, "Celldoor29")

RegisterEvent(30547, "Celldoor7", function()
    map.triggerMechanism(547, 2)
end, "Celldoor7")

RegisterEvent(30548, "Celldoor8", function()
    map.triggerMechanism(548, 2)
end, "Celldoor8")

RegisterEvent(30549, "Celldoor9", function()
    map.triggerMechanism(549, 2)
end, "Celldoor9")

RegisterEvent(30550, "Celldoor10", function()
    map.triggerMechanism(550, 2)
end, "Celldoor10")

RegisterEvent(30551, "Celldoor11", function()
    map.triggerMechanism(551, 2)
end, "Celldoor11")

RegisterEvent(30552, "Celldoor12", function()
    map.triggerMechanism(552, 2)
end, "Celldoor12")

RegisterEvent(30553, "Celldoor18", function()
    map.triggerMechanism(553, 2)
end, "Celldoor18")

RegisterEvent(30554, "Celldoor25", function()
    map.triggerMechanism(554, 2)
end, "Celldoor25")

RegisterEvent(30555, "Celldoor26", function()
    map.triggerMechanism(555, 2)
end, "Celldoor26")

RegisterEvent(30556, "Celldoor27", function()
    map.triggerMechanism(556, 2)
end, "Celldoor27")

RegisterEvent(30557, "Celldoor28", function()
    map.triggerMechanism(557, 2)
end, "Celldoor28")

RegisterEvent(30558, "Celldoor30", function()
    map.triggerMechanism(558, 2)
end, "Celldoor30")

RegisterEvent(30561, "Celldoor31", function()
    map.triggerMechanism(561, 2)
end, "Celldoor31")

RegisterEvent(30562, "Celldoor32", function()
    map.triggerMechanism(562, 2)
end, "Celldoor32")

RegisterEvent(30563, "Celldoor33", function()
    map.triggerMechanism(563, 2)
end, "Celldoor33")

RegisterEvent(30564, "Celldoor34", function()
    map.triggerMechanism(564, 2)
end, "Celldoor34")

RegisterEvent(30565, "Celldoor36", function()
    map.triggerMechanism(565, 2)
end, "Celldoor36")

RegisterEvent(30566, "Celldoor37", function()
    map.triggerMechanism(566, 2)
end, "Celldoor37")

RegisterEvent(30567, "Celldoor38", function()
    map.triggerMechanism(567, 2)
end, "Celldoor38")

RegisterEvent(30568, "Celldoor35", function()
    map.triggerMechanism(568, 2)
end, "Celldoor35")

RegisterEvent(30569, "SingleDoor9", function()
    map.triggerMechanism(569, 2)
end, "SingleDoor9")

RegisterEvent(30570, "RotatingDoor1", function()
    map.triggerMechanism(570, 2)
end, "RotatingDoor1")

RegisterEvent(30571, "HallDoor1", function()
    map.triggerMechanism(571, 2)
end, "HallDoor1")

RegisterEvent(30572, "HallDoor2", function()
    map.triggerMechanism(572, 2)
end, "HallDoor2")

RegisterEvent(30573, "HallDoor3", function()
    map.triggerMechanism(573, 2)
end, "HallDoor3")

RegisterEvent(30574, "HallDoor4", function()
    map.triggerMechanism(574, 2)
end, "HallDoor4")

RegisterEvent(30575, "SecretDoor0", function()
    map.triggerMechanism(575, 2)
end, "SecretDoor0")

RegisterEvent(30576, "DDoor9a", function()
    map.triggerMechanism(576, 2)
end, "DDoor9a")

RegisterEvent(30577, "DDoor9b", function()
    map.triggerMechanism(577, 2)
end, "DDoor9b")

RegisterEvent(30578, "DDoor10a", function()
    map.triggerMechanism(578, 2)
end, "DDoor10a")

RegisterEvent(30579, "DDoor10b", function()
    map.triggerMechanism(579, 2)
end, "DDoor10b")

RegisterEvent(30580, "DDoor11a", function()
    map.triggerMechanism(580, 2)
end, "DDoor11a")

RegisterEvent(30581, "DDoor11b", function()
    map.triggerMechanism(581, 2)
end, "DDoor11b")

RegisterEvent(30582, "RotatingDoor10", function()
    map.triggerMechanism(582, 2)
end, "RotatingDoor10")

RegisterEvent(30583, "RotatingDoor11", function()
    map.triggerMechanism(583, 2)
end, "RotatingDoor11")

RegisterEvent(30584, "RotatingDoor6", function()
    map.triggerMechanism(584, 2)
end, "RotatingDoor6")

RegisterEvent(30585, "RotatingDoor7", function()
    map.triggerMechanism(585, 2)
end, "RotatingDoor7")

RegisterEvent(30586, "RotatingDoor8", function()
    map.triggerMechanism(586, 2)
end, "RotatingDoor8")

RegisterEvent(30587, "RotatingDoor9", function()
    map.triggerMechanism(587, 2)
end, "RotatingDoor9")

RegisterEvent(30588, "Celldoor13", function()
    map.triggerMechanism(588, 2)
end, "Celldoor13")

RegisterEvent(30589, "Celldoor17", function()
    map.triggerMechanism(589, 2)
end, "Celldoor17")

RegisterEvent(30590, "Celldoor16", function()
    map.triggerMechanism(590, 2)
end, "Celldoor16")

RegisterEvent(30591, "Celldoor15", function()
    map.triggerMechanism(591, 2)
end, "Celldoor15")

RegisterEvent(30592, "Celldoor14", function()
    map.triggerMechanism(592, 2)
end, "Celldoor14")

RegisterEvent(30593, "guardstation1door", function()
    map.triggerMechanism(593, 2)
end, "guardstation1door")

RegisterEvent(30594, "guardstation1door0", function()
    map.triggerMechanism(594, 2)
end, "guardstation1door0")

RegisterEvent(30595, "guardstation1door1", function()
    map.triggerMechanism(595, 2)
end, "guardstation1door1")

RegisterEvent(30596, "guardstation1door3", function()
    map.triggerMechanism(596, 2)
end, "guardstation1door3")

RegisterEvent(30597, "RotatingDoor3", function()
    map.triggerMechanism(597, 2)
end, "RotatingDoor3")

RegisterEvent(30598, "RightDoor1a", function()
    map.triggerMechanism(598, 2)
end, "RightDoor1a")

RegisterEvent(30599, "LeftDoor1a", function()
    map.triggerMechanism(599, 2)
end, "LeftDoor1a")

RegisterEvent(31023, "Door1", function()
    map.triggerMechanism(1023, 2)
end, "Door1")

RegisterEvent(31024, "Door3", function()
    map.triggerMechanism(1024, 2)
end, "Door3")

RegisterEvent(31027, "lever0", function()
    map.triggerMechanism(1027, 2)
end, "lever0")

RegisterEvent(31028, "lever1", function()
    map.triggerMechanism(1028, 2)
end, "lever1")

RegisterEvent(31029, "lever2", function()
    map.triggerMechanism(1029, 2)
end, "lever2")

RegisterEvent(31030, "lever3", function()
    map.triggerMechanism(1030, 2)
end, "lever3")

RegisterEvent(31031, "lever4", function()
    map.triggerMechanism(1031, 2)
end, "lever4")

RegisterEvent(31032, "lever5", function()
    map.triggerMechanism(1032, 2)
end, "lever5")

RegisterEvent(31075, "blever1", function()
    map.triggerMechanism(1075, 2)
end, "blever1")

RegisterEvent(31076, "blever0", function()
    map.triggerMechanism(1076, 2)
end, "blever0")

RegisterEvent(31077, "blever2", function()
    map.triggerMechanism(1077, 2)
end, "blever2")

map.scripts["alarmcontrol.scr"] = {
    source = "ALARMCONTROL.scr",
    registered_triggers = {
        { line = 40, message = "Alarm", callback = "OnAlarm" },
    },
    movement_commands = {
    },
}
map.scripts["dp_patrol.scr"] = {
    source = "DP_PATROL.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["drangheimdoorman.scr"] = {
    source = "DRANGHEIMDOORMAN.scr",
    registered_triggers = {
        { line = 31, message = "open", callback = "OpenRoom" },
        { line = 32, message = "close", callback = "CloseRoom" },
    },
    movement_commands = {
    },
}
map.scripts["drangheimguardbasic.scr"] = {
    source = "DRANGHEIMGUARDBASIC.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["drangheiminterrogator.scr"] = {
    source = "DRANGHEIMINTERROGATOR.scr",
    registered_triggers = {
        { line = 93, message = "start", callback = "StartScript" },
        { line = 94, message = "outside", callback = "OnPrisonerOut" },
        { line = 95, message = "inside", callback = "OnPrisonerIn" },
        { line = 198, message = "start", callback = "StartScript" },
    },
    movement_commands = {
    },
}
map.scripts["drangheimprisoner.scr"] = {
    source = "DRANGHEIMPRISONER.scr",
    registered_triggers = {
        { line = 35, message = "followme", callback = "StartFollowing" },
        { line = 36, message = "return", callback = "EnterCell" },
        { line = 37, message = "leave", callback = "LeaveCell" },
        { line = 38, message = "use", callback = "OnPlayerRescue" },
    },
    movement_commands = {
    },
}
map.scripts["drangheimsmith.scr"] = {
    source = "DRANGHEIMSMITH.scr",
    registered_triggers = {
        { line = 66, message = "off", callback = "TurnOff" },
        { line = 67, message = "on", callback = "OnReturnedWeapon" },
    },
    movement_commands = {
    },
}
map.scripts["drangheimwarden.scr"] = {
    source = "DRANGHEIMWARDEN.scr",
    registered_triggers = {
        { line = 33, message = "open", callback = "OpenCell" },
        { line = 34, message = "close", callback = "CloseCell" },
        { line = 35, message = "change", callback = "ChangeCell" },
    },
    movement_commands = {
    },
}
map.scripts["guardhelp.scr"] = {
    source = "GUARDHELP.scr",
    registered_triggers = {
        { line = 91, message = "help", callback = "OnGiveHelp" },
    },
    movement_commands = {
    },
}
map.scripts["guardrude.scr"] = {
    source = "GUARDRUDE.scr",
    registered_triggers = {
        { line = 142, message = "Use", callback = "Onuse" },
        { line = 145, message = "Alarm", callback = "ONAlarm" },
    },
    movement_commands = {
    },
}
map.scripts["guardtonegate.scr"] = {
    source = "GUARDTONEGATE.scr",
    registered_triggers = {
        { line = 133, message = "Hello", callback = "PlayerIsHere" },
    },
    movement_commands = {
    },
}
map.scripts["npc419.scr"] = {
    source = "NPC419.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["npc427.scr"] = {
    source = "NPC427.scr",
    registered_triggers = {
        { line = 73, message = "Use", callback = "ONUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc90.scr"] = {
    source = "NPC90.scr",
    registered_triggers = {
        { line = 274, message = "Use", callback = "OnUse" },
        { line = 275, message = "Stop", callback = "OnSTop" },
    },
    movement_commands = {
        { line = 78, command = "setpos", arguments = "g_hMyObject -2525 948 397" },
        { line = 84, command = "setpos", arguments = "g_hMyObject -4253 817 -6191" },
        { line = 227, command = "setpos", arguments = "g_hmyobject xPos yPos zPos" },
    },
}

function map.register(ctx)
    if ctx == nil or ctx.registerMm9MapEvents == nil then
        return
    end
    ctx:registerMm9MapEvents(map)
end

return map
