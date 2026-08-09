-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "verhoffinruins"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 228,
        source_name = "StartPoint0",
        x = -1230,
        y = -5969,
        z = -82,
        direction_yaw_units = 76,
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
        mechanism_id = 900152,
        event_id = 30152,
        source_object_index = 152,
        source_class = "RotatingDoor",
        source_name = "PrisonDoor1",
        kind = "rotating_door",
        hint = "PrisonDoor1",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900153,
        event_id = 30153,
        source_object_index = 153,
        source_class = "RotatingDoor",
        source_name = "PrisonDoor4",
        kind = "rotating_door",
        hint = "PrisonDoor4",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900154,
        event_id = 30154,
        source_object_index = 154,
        source_class = "RotatingDoor",
        source_name = "PrisonDoor2",
        kind = "rotating_door",
        hint = "PrisonDoor2",
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
                name = "Door/doorlock01.wav",
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
        source_class = "RotatingDoor",
        source_name = "CellBars8",
        kind = "rotating_door",
        hint = "CellBars8",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
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
        source_class = "RotatingDoor",
        source_name = "CellDoor8",
        kind = "rotating_door",
        hint = "CellDoor8",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
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
        source_class = "RotatingDoor",
        source_name = "PrisonDoor3",
        kind = "rotating_door",
        hint = "PrisonDoor3",
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
                name = "Door/doorlock01.wav",
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
        source_class = "RotatingDoor",
        source_name = "TortureChamberDoor7",
        kind = "rotating_door",
        hint = "TortureChamberDoor7",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900159,
        event_id = 30159,
        source_object_index = 159,
        source_class = "RotatingDoor",
        source_name = "TortureChamberDoor6",
        kind = "rotating_door",
        hint = "TortureChamberDoor6",
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
                name = "Door/doorlock01.wav",
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
        source_class = "RotatingDoor",
        source_name = "CellBars7",
        kind = "rotating_door",
        hint = "CellBars7",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
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
        source_class = "RotatingDoor",
        source_name = "CellDoor7",
        kind = "rotating_door",
        hint = "CellDoor7",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
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
        source_class = "RotatingDoor",
        source_name = "CellBars6",
        kind = "rotating_door",
        hint = "CellBars6",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
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
        source_class = "RotatingDoor",
        source_name = "CellDoor6",
        kind = "rotating_door",
        hint = "CellDoor6",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900164,
        event_id = 30164,
        source_object_index = 164,
        source_class = "RotatingDoor",
        source_name = "CellBars5",
        kind = "rotating_door",
        hint = "CellBars5",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
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
        source_class = "RotatingDoor",
        source_name = "CellDoor5",
        kind = "rotating_door",
        hint = "CellDoor5",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
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
        source_class = "RotatingDoor",
        source_name = "CellBars4",
        kind = "rotating_door",
        hint = "CellBars4",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
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
        source_class = "RotatingDoor",
        source_name = "CellDoor4",
        kind = "rotating_door",
        hint = "CellDoor4",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
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
        source_class = "RotatingDoor",
        source_name = "CellBars10",
        kind = "rotating_door",
        hint = "CellBars10",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
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
        source_class = "RotatingDoor",
        source_name = "CellDoor10",
        kind = "rotating_door",
        hint = "CellDoor10",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
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
        source_class = "RotatingDoor",
        source_name = "CellBars12",
        kind = "rotating_door",
        hint = "CellBars12",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
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
        source_class = "RotatingDoor",
        source_name = "CellDoor12",
        kind = "rotating_door",
        hint = "CellDoor12",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
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
        source_class = "RotatingDoor",
        source_name = "CellBars11",
        kind = "rotating_door",
        hint = "CellBars11",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900173,
        event_id = 30173,
        source_object_index = 173,
        source_class = "RotatingDoor",
        source_name = "CellDoor11",
        kind = "rotating_door",
        hint = "CellDoor11",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
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
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL5",
        kind = "rotating_door",
        hint = "DoubleDoorL5",
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
                name = "Door/doorlock01.wav",
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
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR5",
        kind = "rotating_door",
        hint = "DoubleDoorR5",
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
                name = "Door/doorlock01.wav",
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
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL6",
        kind = "rotating_door",
        hint = "DoubleDoorL6",
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
                name = "Door/doorlock01.wav",
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
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR6",
        kind = "rotating_door",
        hint = "DoubleDoorR6",
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
                name = "Door/doorlock01.wav",
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
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL4",
        kind = "rotating_door",
        hint = "DoubleDoorL4",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900179,
        event_id = 30179,
        source_object_index = 179,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR4",
        kind = "rotating_door",
        hint = "DoubleDoorR4",
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
                name = "Door/doorlock01.wav",
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
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL3",
        kind = "rotating_door",
        hint = "DoubleDoorL3",
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
                name = "Door/doorlock01.wav",
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
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR3",
        kind = "rotating_door",
        hint = "DoubleDoorR3",
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
                name = "Door/doorlock01.wav",
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
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL2",
        kind = "rotating_door",
        hint = "DoubleDoorL2",
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
                name = "Door/doorlock01.wav",
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
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR2",
        kind = "rotating_door",
        hint = "DoubleDoorR2",
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
                name = "Door/doorlock01.wav",
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
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL1",
        kind = "rotating_door",
        hint = "DoubleDoorL1",
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
                name = "Door/doorlock01.wav",
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
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR1",
        kind = "rotating_door",
        hint = "DoubleDoorR1",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900186,
        event_id = 30186,
        source_object_index = 186,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL9",
        kind = "rotating_door",
        hint = "DoubleDoorL9",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900187,
        event_id = 30187,
        source_object_index = 187,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR9",
        kind = "rotating_door",
        hint = "DoubleDoorR9",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900188,
        event_id = 30188,
        source_object_index = 188,
        source_class = "RotatingDoor",
        source_name = "CellBars13",
        kind = "rotating_door",
        hint = "CellBars13",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900189,
        event_id = 30189,
        source_object_index = 189,
        source_class = "RotatingDoor",
        source_name = "CellDoor13",
        kind = "rotating_door",
        hint = "CellDoor13",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900190,
        event_id = 30190,
        source_object_index = 190,
        source_class = "RotatingDoor",
        source_name = "BrokenDoor1",
        kind = "rotating_door",
        hint = "BrokenDoor1",
        sounds = {
            ["open_start"] = {
                name = "events/WoodCreak1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "events/WoodCreak1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900191,
        event_id = 30191,
        source_object_index = 191,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL8",
        kind = "rotating_door",
        hint = "DoubleDoorL8",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900192,
        event_id = 30192,
        source_object_index = 192,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR8",
        kind = "rotating_door",
        hint = "DoubleDoorR8",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900193,
        event_id = 30193,
        source_object_index = 193,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL7",
        kind = "rotating_door",
        hint = "DoubleDoorL7",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900194,
        event_id = 30194,
        source_object_index = 194,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR7",
        kind = "rotating_door",
        hint = "DoubleDoorR7",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900195,
        event_id = 30195,
        source_object_index = 195,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL10",
        kind = "rotating_door",
        hint = "DoubleDoorL10",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900196,
        event_id = 30196,
        source_object_index = 196,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR10",
        kind = "rotating_door",
        hint = "DoubleDoorR10",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900197,
        event_id = 30197,
        source_object_index = 197,
        source_class = "RotatingDoor",
        source_name = "FallingDoor",
        kind = "rotating_door",
        hint = "FallingDoor",
        sounds = {
            ["open_start"] = {
                name = "events/WoodCreak1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "events/metalwood01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900198,
        event_id = 30198,
        source_object_index = 198,
        source_class = "RotatingDoor",
        source_name = "TortureChamberDoor1",
        kind = "rotating_door",
        hint = "TortureChamberDoor1",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900199,
        event_id = 30199,
        source_object_index = 199,
        source_class = "RotatingDoor",
        source_name = "TortureChamberDoor0",
        kind = "rotating_door",
        hint = "TortureChamberDoor0",
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
                name = "Door/doorlock01.wav",
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
        source_class = "Shooter",
        source_name = "DoorShooter0",
        kind = "shooter",
        hint = "DoorShooter0",
    },
    {
        mechanism_id = 900209,
        event_id = 30209,
        source_object_index = 209,
        source_class = "Shooter",
        source_name = "DoorShooter1",
        kind = "shooter",
        hint = "DoorShooter1",
    },
    {
        mechanism_id = 900210,
        event_id = 30210,
        source_object_index = 210,
        source_class = "RotatingDoor",
        source_name = "Door5",
        kind = "rotating_door",
        hint = "Door5",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900211,
        event_id = 30211,
        source_object_index = 211,
        source_class = "RotatingDoor",
        source_name = "DDoorL11",
        kind = "rotating_door",
        hint = "DDoorL11",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900212,
        event_id = 30212,
        source_object_index = 212,
        source_class = "RotatingDoor",
        source_name = "DDoorR11",
        kind = "rotating_door",
        hint = "DDoorR11",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900213,
        event_id = 30213,
        source_object_index = 213,
        source_class = "RotatingDoor",
        source_name = "DDoorL12",
        kind = "rotating_door",
        hint = "DDoorL12",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900214,
        event_id = 30214,
        source_object_index = 214,
        source_class = "RotatingDoor",
        source_name = "DDoorR12",
        kind = "rotating_door",
        hint = "DDoorR12",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900215,
        event_id = 30215,
        source_object_index = 215,
        source_class = "RotatingDoor",
        source_name = "DDoorL13",
        kind = "rotating_door",
        hint = "DDoorL13",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900216,
        event_id = 30216,
        source_object_index = 216,
        source_class = "RotatingDoor",
        source_name = "DDoorR13",
        kind = "rotating_door",
        hint = "DDoorR13",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900217,
        event_id = 30217,
        source_object_index = 217,
        source_class = "RotatingDoor",
        source_name = "CellBars14",
        kind = "rotating_door",
        hint = "CellBars14",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900218,
        event_id = 30218,
        source_object_index = 218,
        source_class = "RotatingDoor",
        source_name = "CellDoor14",
        kind = "rotating_door",
        hint = "CellDoor14",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900219,
        event_id = 30219,
        source_object_index = 219,
        source_class = "RotatingDoor",
        source_name = "CellBars15",
        kind = "rotating_door",
        hint = "CellBars15",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900220,
        event_id = 30220,
        source_object_index = 220,
        source_class = "RotatingDoor",
        source_name = "CellDoor15",
        kind = "rotating_door",
        hint = "CellDoor15",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900221,
        event_id = 30221,
        source_object_index = 221,
        source_class = "RotatingDoor",
        source_name = "CellBars16",
        kind = "rotating_door",
        hint = "CellBars16",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900222,
        event_id = 30222,
        source_object_index = 222,
        source_class = "RotatingDoor",
        source_name = "CellDoor16",
        kind = "rotating_door",
        hint = "CellDoor16",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900223,
        event_id = 30223,
        source_object_index = 223,
        source_class = "RotatingDoor",
        source_name = "CellBars17",
        kind = "rotating_door",
        hint = "CellBars17",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900224,
        event_id = 30224,
        source_object_index = 224,
        source_class = "RotatingDoor",
        source_name = "CellDoor17",
        kind = "rotating_door",
        hint = "CellDoor17",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900225,
        event_id = 30225,
        source_object_index = 225,
        source_class = "RotatingDoor",
        source_name = "DDoorL14",
        kind = "rotating_door",
        hint = "DDoorL14",
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
                name = "Door/doorlock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900226,
        event_id = 30226,
        source_object_index = 226,
        source_class = "RotatingDoor",
        source_name = "DDoorR14",
        kind = "rotating_door",
        hint = "DDoorR14",
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
                name = "Door/doorlock01.wav",
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
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900520,
        event_id = 30520,
        source_object_index = 520,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900521,
        event_id = 30521,
        source_object_index = 521,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 900522,
        event_id = 30522,
        source_object_index = 522,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 900523,
        event_id = 30523,
        source_object_index = 523,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 900524,
        event_id = 30524,
        source_object_index = 524,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900532,
        event_id = 30532,
        source_object_index = 532,
        source_class = "BlueWater",
        source_name = "ElectricWater1",
        kind = "water_volume",
        hint = "ElectricWater1",
    },
    {
        mechanism_id = 900542,
        event_id = 30542,
        source_object_index = 542,
        source_class = "Door",
        source_name = "WaterRoomButton1",
        kind = "linear_door",
        hint = "WaterRoomButton1",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorlatch02.wav",
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
        source_name = "WaterNozzle3",
        kind = "rotating_door",
        hint = "WaterNozzle3",
        sounds = {
            ["open_start"] = {
                name = "Events/stonemetalscrape.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/metalhitmetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/stonemetalscrape.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/metalhitmetal03.wav",
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
        source_name = "WaterNozzle2",
        kind = "rotating_door",
        hint = "WaterNozzle2",
        sounds = {
            ["open_start"] = {
                name = "Events/stonemetalscrape.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/metalhitmetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/stonemetalscrape.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/metalhitmetal03.wav",
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
        source_name = "WaterNozzle1",
        kind = "rotating_door",
        hint = "WaterNozzle1",
        sounds = {
            ["open_start"] = {
                name = "Events/stonemetalscrape.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/metalhitmetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/stonemetalscrape.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/metalhitmetal03.wav",
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
        source_name = "WaterNozzle0",
        kind = "rotating_door",
        hint = "WaterNozzle0",
        sounds = {
            ["open_start"] = {
                name = "Events/stonemetalscrape.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/metalhitmetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/stonemetalscrape.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/metalhitmetal03.wav",
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
        source_class = "Door",
        source_name = "WaterRoomButton2",
        kind = "linear_door",
        hint = "WaterRoomButton2",
        sounds = {
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
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
        source_class = "PerceptionBrush",
        source_name = "PerceptionLightWaterTrap",
        kind = "perception_brush",
        hint = "PerceptionLightWaterTrap",
    },
    {
        mechanism_id = 900557,
        event_id = 30557,
        source_object_index = 557,
        source_class = "RotatingDoor",
        source_name = "Paddle",
        kind = "rotating_door",
        hint = "Paddle",
        sounds = {
            ["open_start"] = {
                name = "events/WoodCreak1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "events/WoodCreak1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900559,
        event_id = 30559,
        source_object_index = 559,
        source_class = "Door",
        source_name = "PaddlePlate",
        kind = "linear_door",
        hint = "PaddlePlate",
    },
    {
        mechanism_id = 900560,
        event_id = 30560,
        source_object_index = 560,
        source_class = "RotatingDoor",
        source_name = "SwingPaddle",
        kind = "rotating_door",
        hint = "SwingPaddle",
        sounds = {
            ["open_start"] = {
                name = "events/WoodCreak1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "events/WoodCreak1.wav",
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
        source_class = "Door",
        source_name = "PaddleMesh",
        kind = "linear_door",
        hint = "PaddleMesh",
    },
    {
        mechanism_id = 900562,
        event_id = 30562,
        source_object_index = 562,
        source_class = "RotatingBrush",
        source_name = "SawBlade1",
        kind = "rotating_brush",
        hint = "SawBlade1",
    },
    {
        mechanism_id = 900563,
        event_id = 30563,
        source_object_index = 563,
        source_class = "Door",
        source_name = "SawBladeArm1",
        kind = "linear_door",
        hint = "SawBladeArm1",
    },
    {
        mechanism_id = 900565,
        event_id = 30565,
        source_object_index = 565,
        source_class = "Door",
        source_name = "TriggerTimer1",
        kind = "linear_door",
        hint = "TriggerTimer1",
    },
    {
        mechanism_id = 900566,
        event_id = 30566,
        source_object_index = 566,
        source_class = "AIBarrier",
        source_name = "saw blade ai barrier",
        kind = "ai_barrier",
        hint = "saw blade ai barrier",
    },
    {
        mechanism_id = 900570,
        event_id = 30570,
        source_object_index = 570,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900572,
        event_id = 30572,
        source_object_index = 572,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 900573,
        event_id = 30573,
        source_object_index = 573,
        source_class = "BlueWater",
        source_name = "BlueWater1",
        kind = "water_volume",
        hint = "BlueWater1",
    },
    {
        mechanism_id = 900576,
        event_id = 30576,
        source_object_index = 576,
        source_class = "BlueWater",
        source_name = "WaterTrap",
        kind = "water_volume",
        hint = "WaterTrap",
    },
    {
        mechanism_id = 900579,
        event_id = 30579,
        source_object_index = 579,
        source_class = "ScriptObject",
        source_name = "PentagramPuzzle",
        kind = "script_object",
        hint = "PentagramPuzzle",
    },
    {
        mechanism_id = 900597,
        event_id = 30597,
        source_object_index = 597,
        source_class = "DestructableBrush",
        source_name = "BreakOut1",
        kind = "destructible_brush",
        hint = "BreakOut1",
    },
    {
        mechanism_id = 900598,
        event_id = 30598,
        source_object_index = 598,
        source_class = "DestructableBrush",
        source_name = "BreakOut0",
        kind = "destructible_brush",
        hint = "BreakOut0",
    },
    {
        mechanism_id = 900617,
        event_id = 30617,
        source_object_index = 617,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush6",
        kind = "collision_volume",
        hint = "InvisibleBrush6",
    },
    {
        mechanism_id = 900646,
        event_id = 30646,
        source_object_index = 646,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900647,
        event_id = 30647,
        source_object_index = 647,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900648,
        event_id = 30648,
        source_object_index = 648,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush12",
        kind = "destructible_brush",
        hint = "DestructableBrush12",
    },
    {
        mechanism_id = 900652,
        event_id = 30652,
        source_object_index = 652,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
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
    [30152] = { kind = "open_door", source = "mm9_mechanism", targetName = "PrisonDoor1" },
    [30153] = { kind = "open_door", source = "mm9_mechanism", targetName = "PrisonDoor4" },
    [30154] = { kind = "open_door", source = "mm9_mechanism", targetName = "PrisonDoor2" },
    [30155] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellBars8" },
    [30156] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellDoor8" },
    [30157] = { kind = "open_door", source = "mm9_mechanism", targetName = "PrisonDoor3" },
    [30158] = { kind = "open_door", source = "mm9_mechanism", targetName = "TortureChamberDoor7" },
    [30159] = { kind = "open_door", source = "mm9_mechanism", targetName = "TortureChamberDoor6" },
    [30160] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellBars7" },
    [30161] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellDoor7" },
    [30162] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellBars6" },
    [30163] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellDoor6" },
    [30164] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellBars5" },
    [30165] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellDoor5" },
    [30166] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellBars4" },
    [30167] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellDoor4" },
    [30168] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellBars10" },
    [30169] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellDoor10" },
    [30170] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellBars12" },
    [30171] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellDoor12" },
    [30172] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellBars11" },
    [30173] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellDoor11" },
    [30174] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL5" },
    [30175] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR5" },
    [30176] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL6" },
    [30177] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR6" },
    [30178] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL4" },
    [30179] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR4" },
    [30180] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL3" },
    [30181] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR3" },
    [30182] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL2" },
    [30183] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR2" },
    [30184] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL1" },
    [30185] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR1" },
    [30186] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL9" },
    [30187] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR9" },
    [30188] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellBars13" },
    [30189] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellDoor13" },
    [30190] = { kind = "open_door", source = "mm9_mechanism", targetName = "BrokenDoor1" },
    [30191] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL8" },
    [30192] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR8" },
    [30193] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL7" },
    [30194] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR7" },
    [30195] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL10" },
    [30196] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR10" },
    [30197] = { kind = "open_door", source = "mm9_mechanism", targetName = "FallingDoor" },
    [30198] = { kind = "open_door", source = "mm9_mechanism", targetName = "TortureChamberDoor1" },
    [30199] = { kind = "open_door", source = "mm9_mechanism", targetName = "TortureChamberDoor0" },
    [30210] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door5" },
    [30211] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoorL11" },
    [30212] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoorR11" },
    [30213] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoorL12" },
    [30214] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoorR12" },
    [30215] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoorL13" },
    [30216] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoorR13" },
    [30217] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellBars14" },
    [30218] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellDoor14" },
    [30219] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellBars15" },
    [30220] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellDoor15" },
    [30221] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellBars16" },
    [30222] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellDoor16" },
    [30223] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellBars17" },
    [30224] = { kind = "open_door", source = "mm9_mechanism", targetName = "CellDoor17" },
    [30225] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoorL14" },
    [30226] = { kind = "open_door", source = "mm9_mechanism", targetName = "DDoorR14" },
    [30542] = { kind = "open_door", source = "mm9_mechanism", targetName = "WaterRoomButton1" },
    [30543] = { kind = "open_door", source = "mm9_mechanism", targetName = "WaterNozzle3" },
    [30544] = { kind = "open_door", source = "mm9_mechanism", targetName = "WaterNozzle2" },
    [30545] = { kind = "open_door", source = "mm9_mechanism", targetName = "WaterNozzle1" },
    [30546] = { kind = "open_door", source = "mm9_mechanism", targetName = "WaterNozzle0" },
    [30547] = { kind = "open_door", source = "mm9_mechanism", targetName = "WaterRoomButton2" },
    [30557] = { kind = "open_door", source = "mm9_mechanism", targetName = "Paddle" },
    [30559] = { kind = "open_door", source = "mm9_mechanism", targetName = "PaddlePlate" },
    [30560] = { kind = "open_door", source = "mm9_mechanism", targetName = "SwingPaddle" },
    [30561] = { kind = "open_door", source = "mm9_mechanism", targetName = "PaddleMesh" },
    [30562] = { kind = "generic_event", source = "mm9_mechanism", targetName = "SawBlade1" },
    [30563] = { kind = "open_door", source = "mm9_mechanism", targetName = "SawBladeArm1" },
    [30565] = { kind = "open_door", source = "mm9_mechanism", targetName = "TriggerTimer1" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30152, "PrisonDoor1", function()
    map.triggerMechanism(152, 2)
end, "PrisonDoor1")

RegisterEvent(30153, "PrisonDoor4", function()
    map.triggerMechanism(153, 2)
end, "PrisonDoor4")

RegisterEvent(30154, "PrisonDoor2", function()
    map.triggerMechanism(154, 2)
end, "PrisonDoor2")

RegisterEvent(30155, "CellBars8", function()
    map.triggerMechanism(155, 2)
end, "CellBars8")

RegisterEvent(30156, "CellDoor8", function()
    map.triggerMechanism(156, 2)
end, "CellDoor8")

RegisterEvent(30157, "PrisonDoor3", function()
    map.triggerMechanism(157, 2)
end, "PrisonDoor3")

RegisterEvent(30158, "TortureChamberDoor7", function()
    map.triggerMechanism(158, 2)
end, "TortureChamberDoor7")

RegisterEvent(30159, "TortureChamberDoor6", function()
    map.triggerMechanism(159, 2)
end, "TortureChamberDoor6")

RegisterEvent(30160, "CellBars7", function()
    map.triggerMechanism(160, 2)
end, "CellBars7")

RegisterEvent(30161, "CellDoor7", function()
    map.triggerMechanism(161, 2)
end, "CellDoor7")

RegisterEvent(30162, "CellBars6", function()
    map.triggerMechanism(162, 2)
end, "CellBars6")

RegisterEvent(30163, "CellDoor6", function()
    map.triggerMechanism(163, 2)
end, "CellDoor6")

RegisterEvent(30164, "CellBars5", function()
    map.triggerMechanism(164, 2)
end, "CellBars5")

RegisterEvent(30165, "CellDoor5", function()
    map.triggerMechanism(165, 2)
end, "CellDoor5")

RegisterEvent(30166, "CellBars4", function()
    map.triggerMechanism(166, 2)
end, "CellBars4")

RegisterEvent(30167, "CellDoor4", function()
    map.triggerMechanism(167, 2)
end, "CellDoor4")

RegisterEvent(30168, "CellBars10", function()
    map.triggerMechanism(168, 2)
end, "CellBars10")

RegisterEvent(30169, "CellDoor10", function()
    map.triggerMechanism(169, 2)
end, "CellDoor10")

RegisterEvent(30170, "CellBars12", function()
    map.triggerMechanism(170, 2)
end, "CellBars12")

RegisterEvent(30171, "CellDoor12", function()
    map.triggerMechanism(171, 2)
end, "CellDoor12")

RegisterEvent(30172, "CellBars11", function()
    map.triggerMechanism(172, 2)
end, "CellBars11")

RegisterEvent(30173, "CellDoor11", function()
    map.triggerMechanism(173, 2)
end, "CellDoor11")

RegisterEvent(30174, "DoubleDoorL5", function()
    map.triggerMechanism(174, 2)
end, "DoubleDoorL5")

RegisterEvent(30175, "DoubleDoorR5", function()
    map.triggerMechanism(175, 2)
end, "DoubleDoorR5")

RegisterEvent(30176, "DoubleDoorL6", function()
    map.triggerMechanism(176, 2)
end, "DoubleDoorL6")

RegisterEvent(30177, "DoubleDoorR6", function()
    map.triggerMechanism(177, 2)
end, "DoubleDoorR6")

RegisterEvent(30178, "DoubleDoorL4", function()
    map.triggerMechanism(178, 2)
end, "DoubleDoorL4")

RegisterEvent(30179, "DoubleDoorR4", function()
    map.triggerMechanism(179, 2)
end, "DoubleDoorR4")

RegisterEvent(30180, "DoubleDoorL3", function()
    map.triggerMechanism(180, 2)
end, "DoubleDoorL3")

RegisterEvent(30181, "DoubleDoorR3", function()
    map.triggerMechanism(181, 2)
end, "DoubleDoorR3")

RegisterEvent(30182, "DoubleDoorL2", function()
    map.triggerMechanism(182, 2)
end, "DoubleDoorL2")

RegisterEvent(30183, "DoubleDoorR2", function()
    map.triggerMechanism(183, 2)
end, "DoubleDoorR2")

RegisterEvent(30184, "DoubleDoorL1", function()
    map.triggerMechanism(184, 2)
end, "DoubleDoorL1")

RegisterEvent(30185, "DoubleDoorR1", function()
    map.triggerMechanism(185, 2)
end, "DoubleDoorR1")

RegisterEvent(30186, "DoubleDoorL9", function()
    map.triggerMechanism(186, 2)
end, "DoubleDoorL9")

RegisterEvent(30187, "DoubleDoorR9", function()
    map.triggerMechanism(187, 2)
end, "DoubleDoorR9")

RegisterEvent(30188, "CellBars13", function()
    map.triggerMechanism(188, 2)
end, "CellBars13")

RegisterEvent(30189, "CellDoor13", function()
    map.triggerMechanism(189, 2)
end, "CellDoor13")

RegisterEvent(30190, "BrokenDoor1", function()
    map.triggerMechanism(190, 2)
end, "BrokenDoor1")

RegisterEvent(30191, "DoubleDoorL8", function()
    map.triggerMechanism(191, 2)
end, "DoubleDoorL8")

RegisterEvent(30192, "DoubleDoorR8", function()
    map.triggerMechanism(192, 2)
end, "DoubleDoorR8")

RegisterEvent(30193, "DoubleDoorL7", function()
    map.triggerMechanism(193, 2)
end, "DoubleDoorL7")

RegisterEvent(30194, "DoubleDoorR7", function()
    map.triggerMechanism(194, 2)
end, "DoubleDoorR7")

RegisterEvent(30195, "DoubleDoorL10", function()
    map.triggerMechanism(195, 2)
end, "DoubleDoorL10")

RegisterEvent(30196, "DoubleDoorR10", function()
    map.triggerMechanism(196, 2)
end, "DoubleDoorR10")

RegisterEvent(30197, "FallingDoor", function()
    map.triggerMechanism(197, 2)
end, "FallingDoor")

RegisterEvent(30198, "TortureChamberDoor1", function()
    map.triggerMechanism(198, 2)
end, "TortureChamberDoor1")

RegisterEvent(30199, "TortureChamberDoor0", function()
    map.triggerMechanism(199, 2)
end, "TortureChamberDoor0")

RegisterEvent(30210, "Door5", function()
    map.triggerMechanism(210, 2)
end, "Door5")

RegisterEvent(30211, "DDoorL11", function()
    map.triggerMechanism(211, 2)
end, "DDoorL11")

RegisterEvent(30212, "DDoorR11", function()
    map.triggerMechanism(212, 2)
end, "DDoorR11")

RegisterEvent(30213, "DDoorL12", function()
    map.triggerMechanism(213, 2)
end, "DDoorL12")

RegisterEvent(30214, "DDoorR12", function()
    map.triggerMechanism(214, 2)
end, "DDoorR12")

RegisterEvent(30215, "DDoorL13", function()
    map.triggerMechanism(215, 2)
end, "DDoorL13")

RegisterEvent(30216, "DDoorR13", function()
    map.triggerMechanism(216, 2)
end, "DDoorR13")

RegisterEvent(30217, "CellBars14", function()
    map.triggerMechanism(217, 2)
end, "CellBars14")

RegisterEvent(30218, "CellDoor14", function()
    map.triggerMechanism(218, 2)
end, "CellDoor14")

RegisterEvent(30219, "CellBars15", function()
    map.triggerMechanism(219, 2)
end, "CellBars15")

RegisterEvent(30220, "CellDoor15", function()
    map.triggerMechanism(220, 2)
end, "CellDoor15")

RegisterEvent(30221, "CellBars16", function()
    map.triggerMechanism(221, 2)
end, "CellBars16")

RegisterEvent(30222, "CellDoor16", function()
    map.triggerMechanism(222, 2)
end, "CellDoor16")

RegisterEvent(30223, "CellBars17", function()
    map.triggerMechanism(223, 2)
end, "CellBars17")

RegisterEvent(30224, "CellDoor17", function()
    map.triggerMechanism(224, 2)
end, "CellDoor17")

RegisterEvent(30225, "DDoorL14", function()
    map.triggerMechanism(225, 2)
end, "DDoorL14")

RegisterEvent(30226, "DDoorR14", function()
    map.triggerMechanism(226, 2)
end, "DDoorR14")

RegisterEvent(30542, "WaterRoomButton1", function()
    map.triggerMechanism(542, 2)
end, "WaterRoomButton1")

RegisterEvent(30543, "WaterNozzle3", function()
    map.triggerMechanism(543, 2)
end, "WaterNozzle3")

RegisterEvent(30544, "WaterNozzle2", function()
    map.triggerMechanism(544, 2)
end, "WaterNozzle2")

RegisterEvent(30545, "WaterNozzle1", function()
    map.triggerMechanism(545, 2)
end, "WaterNozzle1")

RegisterEvent(30546, "WaterNozzle0", function()
    map.triggerMechanism(546, 2)
end, "WaterNozzle0")

RegisterEvent(30547, "WaterRoomButton2", function()
    map.triggerMechanism(547, 2)
end, "WaterRoomButton2")

RegisterEvent(30557, "Paddle", function()
    map.triggerMechanism(557, 2)
end, "Paddle")

RegisterEvent(30559, "PaddlePlate", function()
    map.triggerMechanism(559, 2)
end, "PaddlePlate")

RegisterEvent(30560, "SwingPaddle", function()
    map.triggerMechanism(560, 2)
end, "SwingPaddle")

RegisterEvent(30561, "PaddleMesh", function()
    map.triggerMechanism(561, 2)
end, "PaddleMesh")

RegisterEvent(30562, "SawBlade1", function()
    map.triggerMechanism(562, 2)
end, "SawBlade1")

RegisterEvent(30563, "SawBladeArm1", function()
    map.triggerMechanism(563, 2)
end, "SawBladeArm1")

RegisterEvent(30565, "TriggerTimer1", function()
    map.triggerMechanism(565, 2)
end, "TriggerTimer1")

map.scripts["bookletter.scr"] = {
    source = "BOOKLETTER.scr",
    registered_triggers = {
        { line = 74, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["capstone.scr"] = {
    source = "CAPSTONE.scr",
    registered_triggers = {
        { line = 135, message = "place", callback = "OnPlace" },
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
map.scripts["drainwater.scr"] = {
    source = "DRAINWATER.scr",
    registered_triggers = {
        { line = 50, message = "drain", callback = "DrainWater" },
        { line = 51, message = "fill", callback = "FillWater" },
        { line = 66, message = "drain", callback = "DrainWater" },
        { line = 78, message = "fill", callback = "FillWater" },
    },
    movement_commands = {
        { line = 70, command = "MoveToPOS", arguments = "xMe,yMe,zMe, 10, OnFillWater" },
        { line = 82, command = "MoveToPOS", arguments = "xMe,yMe,zMe, 10, OnDrainWater" },
    },
}
map.scripts["fakebook.scr"] = {
    source = "FAKEBOOK.scr",
    registered_triggers = {
        { line = 70, message = "Use", callback = "Onuse" },
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
map.scripts["kingkong.scr"] = {
    source = "KINGKONG.scr",
    registered_triggers = {
        { line = 41, message = "ForceBreak", callback = "RushCage" },
        { line = 42, message = "ForceFall", callback = "FallThrough" },
        { line = 43, message = "ForceAttack", callback = "TurnOff" },
    },
    movement_commands = {
    },
}
map.scripts["pentagrampuzzle.scr"] = {
    source = "PENTAGRAMPUZZLE.scr",
    registered_triggers = {
        { line = 49, message = "start", callback = "StartPuzzle" },
        { line = 72, message = "first", callback = "FirstStep" },
        { line = 73, message = "second", callback = "SecondStep" },
        { line = 74, message = "third", callback = "ThirdStep" },
        { line = 75, message = "fourth", callback = "FourthStep" },
        { line = 76, message = "fifth", callback = "FifthStep" },
    },
    movement_commands = {
    },
}
map.scripts["placecapstone.scr"] = {
    source = "PLACECAPSTONE.scr",
    registered_triggers = {
        { line = 48, message = "Use", callback = "Onuse" },
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
map.scripts["writ.scr"] = {
    source = "WRIT.scr",
    registered_triggers = {
        { line = 71, message = "Use", callback = "Onuse" },
        { line = 81, message = "init", callback = "OnInit" },
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
