-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "beethoven"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 687,
        source_name = "SewerE",
        x = 4465,
        y = 17567,
        z = 205,
        direction_yaw_units = 512,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 688,
        source_name = "SewerS",
        x = -9830,
        y = 543,
        z = 655,
        direction_yaw_units = 1536,
        move_player_to_floor = true,
    },
    {
        start_index = 2,
        source_object_index = 689,
        source_name = "SewerW",
        x = -16425,
        y = 13102,
        z = 655,
        direction_yaw_units = 1536,
        move_player_to_floor = true,
    },
    {
        start_index = 3,
        source_object_index = 690,
        source_name = "Sewergrate",
        x = -1720,
        y = 2867,
        z = 410,
        direction_yaw_units = 1024,
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
        mechanism_id = 900001,
        event_id = 30001,
        source_object_index = 1,
        source_class = "Ladder",
        source_name = "Ladder8",
        kind = "ladder_volume",
        hint = "Ladder8",
    },
    {
        mechanism_id = 900003,
        event_id = 30003,
        source_object_index = 3,
        source_class = "Ladder",
        source_name = "Ladder4",
        kind = "ladder_volume",
        hint = "Ladder4",
    },
    {
        mechanism_id = 900004,
        event_id = 30004,
        source_object_index = 4,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor18",
        kind = "rotating_door",
        hint = "RotatingDoor18",
    },
    {
        mechanism_id = 900231,
        event_id = 30231,
        source_object_index = 231,
        source_class = "Ladder",
        source_name = "Ladder2",
        kind = "ladder_volume",
        hint = "Ladder2",
    },
    {
        mechanism_id = 900233,
        event_id = 30233,
        source_object_index = 233,
        source_class = "Ladder",
        source_name = "Ladder7",
        kind = "ladder_volume",
        hint = "Ladder7",
    },
    {
        mechanism_id = 900321,
        event_id = 30321,
        source_object_index = 321,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900322,
        event_id = 30322,
        source_object_index = 322,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900323,
        event_id = 30323,
        source_object_index = 323,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900324,
        event_id = 30324,
        source_object_index = 324,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 900325,
        event_id = 30325,
        source_object_index = 325,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 900326,
        event_id = 30326,
        source_object_index = 326,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 900327,
        event_id = 30327,
        source_object_index = 327,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush6",
        kind = "collision_volume",
        hint = "InvisibleBrush6",
    },
    {
        mechanism_id = 900328,
        event_id = 30328,
        source_object_index = 328,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush7",
        kind = "collision_volume",
        hint = "InvisibleBrush7",
    },
    {
        mechanism_id = 900345,
        event_id = 30345,
        source_object_index = 345,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900375,
        event_id = 30375,
        source_object_index = 375,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 900376,
        event_id = 30376,
        source_object_index = 376,
        source_class = "AIBarrier",
        source_name = "AIBarrier2",
        kind = "ai_barrier",
        hint = "AIBarrier2",
    },
    {
        mechanism_id = 900413,
        event_id = 30413,
        source_object_index = 413,
        source_class = "AIBarrier",
        source_name = "AIBarrier3",
        kind = "ai_barrier",
        hint = "AIBarrier3",
    },
    {
        mechanism_id = 900414,
        event_id = 30414,
        source_object_index = 414,
        source_class = "AIBarrier",
        source_name = "AIBarrier4",
        kind = "ai_barrier",
        hint = "AIBarrier4",
    },
    {
        mechanism_id = 900775,
        event_id = 30775,
        source_object_index = 775,
        source_class = "BlueWater",
        source_name = "frigidarium water",
        kind = "water_volume",
        hint = "frigidarium water",
    },
    {
        mechanism_id = 900779,
        event_id = 30779,
        source_object_index = 779,
        source_class = "Ladder",
        source_name = "Ladder0",
        kind = "ladder_volume",
        hint = "Ladder0",
    },
    {
        mechanism_id = 900781,
        event_id = 30781,
        source_object_index = 781,
        source_class = "RotatingDoor",
        source_name = "LeftDoor2",
        kind = "rotating_door",
        hint = "LeftDoor2",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900782,
        event_id = 30782,
        source_object_index = 782,
        source_class = "RotatingDoor",
        source_name = "RightDoor2",
        kind = "rotating_door",
        hint = "RightDoor2",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900783,
        event_id = 30783,
        source_object_index = 783,
        source_class = "RotatingDoor",
        source_name = "LeftDoor3",
        kind = "rotating_door",
        hint = "LeftDoor3",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900784,
        event_id = 30784,
        source_object_index = 784,
        source_class = "RotatingDoor",
        source_name = "RightDoor3",
        kind = "rotating_door",
        hint = "RightDoor3",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900785,
        event_id = 30785,
        source_object_index = 785,
        source_class = "RotatingDoor",
        source_name = "LeftDoor5",
        kind = "rotating_door",
        hint = "LeftDoor5",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900786,
        event_id = 30786,
        source_object_index = 786,
        source_class = "RotatingDoor",
        source_name = "RightDoor5",
        kind = "rotating_door",
        hint = "RightDoor5",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900787,
        event_id = 30787,
        source_object_index = 787,
        source_class = "RotatingDoor",
        source_name = "LeftDoor10",
        kind = "rotating_door",
        hint = "LeftDoor10",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900788,
        event_id = 30788,
        source_object_index = 788,
        source_class = "RotatingDoor",
        source_name = "RightDoor10",
        kind = "rotating_door",
        hint = "RightDoor10",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900789,
        event_id = 30789,
        source_object_index = 789,
        source_class = "RotatingDoor",
        source_name = "LeftDoor9",
        kind = "rotating_door",
        hint = "LeftDoor9",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900790,
        event_id = 30790,
        source_object_index = 790,
        source_class = "RotatingDoor",
        source_name = "RightDoor9",
        kind = "rotating_door",
        hint = "RightDoor9",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900791,
        event_id = 30791,
        source_object_index = 791,
        source_class = "RotatingDoor",
        source_name = "LeftDoor12",
        kind = "rotating_door",
        hint = "LeftDoor12",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900792,
        event_id = 30792,
        source_object_index = 792,
        source_class = "RotatingDoor",
        source_name = "RightDoor12",
        kind = "rotating_door",
        hint = "RightDoor12",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900793,
        event_id = 30793,
        source_object_index = 793,
        source_class = "RotatingDoor",
        source_name = "LeftDoor15",
        kind = "rotating_door",
        hint = "LeftDoor15",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900794,
        event_id = 30794,
        source_object_index = 794,
        source_class = "RotatingDoor",
        source_name = "RightDoor15",
        kind = "rotating_door",
        hint = "RightDoor15",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900795,
        event_id = 30795,
        source_object_index = 795,
        source_class = "RotatingDoor",
        source_name = "LeftDoor18",
        kind = "rotating_door",
        hint = "LeftDoor18",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900796,
        event_id = 30796,
        source_object_index = 796,
        source_class = "RotatingDoor",
        source_name = "RightDoor18",
        kind = "rotating_door",
        hint = "RightDoor18",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900797,
        event_id = 30797,
        source_object_index = 797,
        source_class = "RotatingDoor",
        source_name = "LeftDoor16",
        kind = "rotating_door",
        hint = "LeftDoor16",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900798,
        event_id = 30798,
        source_object_index = 798,
        source_class = "RotatingDoor",
        source_name = "RightDoor16",
        kind = "rotating_door",
        hint = "RightDoor16",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900799,
        event_id = 30799,
        source_object_index = 799,
        source_class = "RotatingDoor",
        source_name = "LeftDoor14",
        kind = "rotating_door",
        hint = "LeftDoor14",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900800,
        event_id = 30800,
        source_object_index = 800,
        source_class = "RotatingDoor",
        source_name = "RightDoor14",
        kind = "rotating_door",
        hint = "RightDoor14",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900801,
        event_id = 30801,
        source_object_index = 801,
        source_class = "RotatingDoor",
        source_name = "LeftDoor19",
        kind = "rotating_door",
        hint = "LeftDoor19",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900802,
        event_id = 30802,
        source_object_index = 802,
        source_class = "RotatingDoor",
        source_name = "RightDoor19",
        kind = "rotating_door",
        hint = "RightDoor19",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900803,
        event_id = 30803,
        source_object_index = 803,
        source_class = "RotatingDoor",
        source_name = "LeftDoor21",
        kind = "rotating_door",
        hint = "LeftDoor21",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900804,
        event_id = 30804,
        source_object_index = 804,
        source_class = "RotatingDoor",
        source_name = "RightDoor21",
        kind = "rotating_door",
        hint = "RightDoor21",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900805,
        event_id = 30805,
        source_object_index = 805,
        source_class = "RotatingDoor",
        source_name = "LeftDoor22",
        kind = "rotating_door",
        hint = "LeftDoor22",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900806,
        event_id = 30806,
        source_object_index = 806,
        source_class = "RotatingDoor",
        source_name = "RightDoor22",
        kind = "rotating_door",
        hint = "RightDoor22",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/WoodCreak1.wav",
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
        mechanism_id = 900807,
        event_id = 30807,
        source_object_index = 807,
        source_class = "Door",
        source_name = "SDoor11",
        kind = "linear_door",
        hint = "SDoor11",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/stonedoorslide02.wav",
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
        },
    },
    {
        mechanism_id = 900808,
        event_id = 30808,
        source_object_index = 808,
        source_class = "Door",
        source_name = "SDoor12",
        kind = "linear_door",
        hint = "SDoor12",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/stonedoorslide02.wav",
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
        },
    },
    {
        mechanism_id = 900809,
        event_id = 30809,
        source_object_index = 809,
        source_class = "Door",
        source_name = "Lever5",
        kind = "linear_door",
        hint = "Lever5",
    },
    {
        mechanism_id = 900810,
        event_id = 30810,
        source_object_index = 810,
        source_class = "Door",
        source_name = "Lever6",
        kind = "linear_door",
        hint = "Lever6",
    },
    {
        mechanism_id = 900811,
        event_id = 30811,
        source_object_index = 811,
        source_class = "Ladder",
        source_name = "Ladder1",
        kind = "ladder_volume",
        hint = "Ladder1",
    },
    {
        mechanism_id = 900858,
        event_id = 30858,
        source_object_index = 858,
        source_class = "RotatingDoor",
        source_name = "HedgeDoor1",
        kind = "rotating_door",
        hint = "HedgeDoor1",
    },
    {
        mechanism_id = 900859,
        event_id = 30859,
        source_object_index = 859,
        source_class = "RotatingDoor",
        source_name = "HedgeDoor2",
        kind = "rotating_door",
        hint = "HedgeDoor2",
    },
    {
        mechanism_id = 900860,
        event_id = 30860,
        source_object_index = 860,
        source_class = "RotatingDoor",
        source_name = "HedgeDoor3",
        kind = "rotating_door",
        hint = "HedgeDoor3",
    },
    {
        mechanism_id = 900861,
        event_id = 30861,
        source_object_index = 861,
        source_class = "BlueWater",
        source_name = "BlueWater4",
        kind = "water_volume",
        hint = "BlueWater4",
    },
    {
        mechanism_id = 900862,
        event_id = 30862,
        source_object_index = 862,
        source_class = "BlueWater",
        source_name = "BlueWater1",
        kind = "water_volume",
        hint = "BlueWater1",
    },
    {
        mechanism_id = 900863,
        event_id = 30863,
        source_object_index = 863,
        source_class = "BlueWater",
        source_name = "BlueWater5",
        kind = "water_volume",
        hint = "BlueWater5",
    },
    {
        mechanism_id = 900864,
        event_id = 30864,
        source_object_index = 864,
        source_class = "BlueWater",
        source_name = "BlueWater2",
        kind = "water_volume",
        hint = "BlueWater2",
    },
    {
        mechanism_id = 901153,
        event_id = 31153,
        source_object_index = 1153,
        source_class = "DestructableProp",
        source_name = "CoffinRaised9",
        kind = "destructible_prop",
        hint = "CoffinRaised9",
    },
    {
        mechanism_id = 901156,
        event_id = 31156,
        source_object_index = 1156,
        source_class = "DestructableProp",
        source_name = "CoffinRaised8",
        kind = "destructible_prop",
        hint = "CoffinRaised8",
    },
    {
        mechanism_id = 901159,
        event_id = 31159,
        source_object_index = 1159,
        source_class = "DestructableProp",
        source_name = "CoffinRaised6",
        kind = "destructible_prop",
        hint = "CoffinRaised6",
    },
    {
        mechanism_id = 901161,
        event_id = 31161,
        source_object_index = 1161,
        source_class = "DestructableProp",
        source_name = "CoffinRaised7",
        kind = "destructible_prop",
        hint = "CoffinRaised7",
    },
    {
        mechanism_id = 901164,
        event_id = 31164,
        source_object_index = 1164,
        source_class = "DestructableProp",
        source_name = "CoffinRaised5",
        kind = "destructible_prop",
        hint = "CoffinRaised5",
    },
    {
        mechanism_id = 901167,
        event_id = 31167,
        source_object_index = 1167,
        source_class = "DestructableProp",
        source_name = "CoffinRaised3",
        kind = "destructible_prop",
        hint = "CoffinRaised3",
    },
    {
        mechanism_id = 901170,
        event_id = 31170,
        source_object_index = 1170,
        source_class = "DestructableProp",
        source_name = "CoffinRaised15",
        kind = "destructible_prop",
        hint = "CoffinRaised15",
    },
    {
        mechanism_id = 901173,
        event_id = 31173,
        source_object_index = 1173,
        source_class = "DestructableProp",
        source_name = "CoffinRaised4",
        kind = "destructible_prop",
        hint = "CoffinRaised4",
    },
    {
        mechanism_id = 901183,
        event_id = 31183,
        source_object_index = 1183,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush8",
        kind = "collision_volume",
        hint = "InvisibleBrush8",
    },
    {
        mechanism_id = 901185,
        event_id = 31185,
        source_object_index = 1185,
        source_class = "DestructableProp",
        source_name = "Urn0",
        kind = "destructible_prop",
        hint = "Urn0",
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
    [30004] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor18" },
    [30781] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeftDoor2" },
    [30782] = { kind = "open_door", source = "mm9_mechanism", targetName = "RightDoor2" },
    [30783] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeftDoor3" },
    [30784] = { kind = "open_door", source = "mm9_mechanism", targetName = "RightDoor3" },
    [30785] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeftDoor5" },
    [30786] = { kind = "open_door", source = "mm9_mechanism", targetName = "RightDoor5" },
    [30787] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeftDoor10" },
    [30788] = { kind = "open_door", source = "mm9_mechanism", targetName = "RightDoor10" },
    [30789] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeftDoor9" },
    [30790] = { kind = "open_door", source = "mm9_mechanism", targetName = "RightDoor9" },
    [30791] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeftDoor12" },
    [30792] = { kind = "open_door", source = "mm9_mechanism", targetName = "RightDoor12" },
    [30793] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeftDoor15" },
    [30794] = { kind = "open_door", source = "mm9_mechanism", targetName = "RightDoor15" },
    [30795] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeftDoor18" },
    [30796] = { kind = "open_door", source = "mm9_mechanism", targetName = "RightDoor18" },
    [30797] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeftDoor16" },
    [30798] = { kind = "open_door", source = "mm9_mechanism", targetName = "RightDoor16" },
    [30799] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeftDoor14" },
    [30800] = { kind = "open_door", source = "mm9_mechanism", targetName = "RightDoor14" },
    [30801] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeftDoor19" },
    [30802] = { kind = "open_door", source = "mm9_mechanism", targetName = "RightDoor19" },
    [30803] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeftDoor21" },
    [30804] = { kind = "open_door", source = "mm9_mechanism", targetName = "RightDoor21" },
    [30805] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeftDoor22" },
    [30806] = { kind = "open_door", source = "mm9_mechanism", targetName = "RightDoor22" },
    [30807] = { kind = "open_door", source = "mm9_mechanism", targetName = "SDoor11" },
    [30808] = { kind = "open_door", source = "mm9_mechanism", targetName = "SDoor12" },
    [30809] = { kind = "open_door", source = "mm9_mechanism", targetName = "Lever5" },
    [30810] = { kind = "open_door", source = "mm9_mechanism", targetName = "Lever6" },
    [30858] = { kind = "open_door", source = "mm9_mechanism", targetName = "HedgeDoor1" },
    [30859] = { kind = "open_door", source = "mm9_mechanism", targetName = "HedgeDoor2" },
    [30860] = { kind = "open_door", source = "mm9_mechanism", targetName = "HedgeDoor3" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30004, "RotatingDoor18", function()
    map.triggerMechanism(4, 2)
end, "RotatingDoor18")

RegisterEvent(30781, "LeftDoor2", function()
    map.triggerMechanism(781, 2)
end, "LeftDoor2")

RegisterEvent(30782, "RightDoor2", function()
    map.triggerMechanism(782, 2)
end, "RightDoor2")

RegisterEvent(30783, "LeftDoor3", function()
    map.triggerMechanism(783, 2)
end, "LeftDoor3")

RegisterEvent(30784, "RightDoor3", function()
    map.triggerMechanism(784, 2)
end, "RightDoor3")

RegisterEvent(30785, "LeftDoor5", function()
    map.triggerMechanism(785, 2)
end, "LeftDoor5")

RegisterEvent(30786, "RightDoor5", function()
    map.triggerMechanism(786, 2)
end, "RightDoor5")

RegisterEvent(30787, "LeftDoor10", function()
    map.triggerMechanism(787, 2)
end, "LeftDoor10")

RegisterEvent(30788, "RightDoor10", function()
    map.triggerMechanism(788, 2)
end, "RightDoor10")

RegisterEvent(30789, "LeftDoor9", function()
    map.triggerMechanism(789, 2)
end, "LeftDoor9")

RegisterEvent(30790, "RightDoor9", function()
    map.triggerMechanism(790, 2)
end, "RightDoor9")

RegisterEvent(30791, "LeftDoor12", function()
    map.triggerMechanism(791, 2)
end, "LeftDoor12")

RegisterEvent(30792, "RightDoor12", function()
    map.triggerMechanism(792, 2)
end, "RightDoor12")

RegisterEvent(30793, "LeftDoor15", function()
    map.triggerMechanism(793, 2)
end, "LeftDoor15")

RegisterEvent(30794, "RightDoor15", function()
    map.triggerMechanism(794, 2)
end, "RightDoor15")

RegisterEvent(30795, "LeftDoor18", function()
    map.triggerMechanism(795, 2)
end, "LeftDoor18")

RegisterEvent(30796, "RightDoor18", function()
    map.triggerMechanism(796, 2)
end, "RightDoor18")

RegisterEvent(30797, "LeftDoor16", function()
    map.triggerMechanism(797, 2)
end, "LeftDoor16")

RegisterEvent(30798, "RightDoor16", function()
    map.triggerMechanism(798, 2)
end, "RightDoor16")

RegisterEvent(30799, "LeftDoor14", function()
    map.triggerMechanism(799, 2)
end, "LeftDoor14")

RegisterEvent(30800, "RightDoor14", function()
    map.triggerMechanism(800, 2)
end, "RightDoor14")

RegisterEvent(30801, "LeftDoor19", function()
    map.triggerMechanism(801, 2)
end, "LeftDoor19")

RegisterEvent(30802, "RightDoor19", function()
    map.triggerMechanism(802, 2)
end, "RightDoor19")

RegisterEvent(30803, "LeftDoor21", function()
    map.triggerMechanism(803, 2)
end, "LeftDoor21")

RegisterEvent(30804, "RightDoor21", function()
    map.triggerMechanism(804, 2)
end, "RightDoor21")

RegisterEvent(30805, "LeftDoor22", function()
    map.triggerMechanism(805, 2)
end, "LeftDoor22")

RegisterEvent(30806, "RightDoor22", function()
    map.triggerMechanism(806, 2)
end, "RightDoor22")

RegisterEvent(30807, "SDoor11", function()
    map.triggerMechanism(807, 2)
end, "SDoor11")

RegisterEvent(30808, "SDoor12", function()
    map.triggerMechanism(808, 2)
end, "SDoor12")

RegisterEvent(30809, "Lever5", function()
    map.triggerMechanism(809, 2)
end, "Lever5")

RegisterEvent(30810, "Lever6", function()
    map.triggerMechanism(810, 2)
end, "Lever6")

RegisterEvent(30858, "HedgeDoor1", function()
    map.triggerMechanism(858, 2)
end, "HedgeDoor1")

RegisterEvent(30859, "HedgeDoor2", function()
    map.triggerMechanism(859, 2)
end, "HedgeDoor2")

RegisterEvent(30860, "HedgeDoor3", function()
    map.triggerMechanism(860, 2)
end, "HedgeDoor3")

map.scripts["bottlefollow.scr"] = {
    source = "BOTTLEFOLLOW.scr",
    registered_triggers = {
    },
    movement_commands = {
        { line = 100, command = "Rotate", arguments = "0,1,0, ANGLE_DIST, ANGLE_RATE, DoNothing" },
        { line = 104, command = "MoveDir", arguments = "0,nDir,0, FLOAT_DIST, FLOAT_RATE, FloatLoop" },
        { line = 120, command = "SetPOS", arguments = "hMe, xMe,yMe,zMe" },
        { line = 134, command = "SetPOS", arguments = "hMe, xMe,yMe,zMe" },
    },
}
map.scripts["coffinmummy.scr"] = {
    source = "COFFINMUMMY.scr",
    registered_triggers = {
        { line = 46, message = "awaken", callback = "WakeUp" },
    },
    movement_commands = {
    },
}
map.scripts["coffinraise.scr"] = {
    source = "COFFINRAISE.scr",
    registered_triggers = {
        { line = 17, message = "raise", callback = "OnRaise" },
        { line = 18, message = "open", callback = "OnRaise" },
    },
    movement_commands = {
    },
}
map.scripts["ludwigsmanuscript.scr"] = {
    source = "LUDWIGSMANUSCRIPT.scr",
    registered_triggers = {
        { line = 78, message = "Use", callback = "Onuse" },
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

function map.register(ctx)
    if ctx == nil or ctx.registerMm9MapEvents == nil then
        return
    end
    ctx:registerMm9MapEvents(map)
end

return map
