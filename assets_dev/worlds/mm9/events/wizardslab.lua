-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "wizardslab"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 837,
        source_name = "StartPoint0",
        x = 3154,
        y = 7165,
        z = 184,
        direction_yaw_units = 511,
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
        mechanism_id = 900035,
        event_id = 30035,
        source_object_index = 35,
        source_class = "InvisibleBrush",
        source_name = "firethrough",
        kind = "collision_volume",
        hint = "firethrough",
    },
    {
        mechanism_id = 900053,
        event_id = 30053,
        source_object_index = 53,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush6",
        kind = "collision_volume",
        hint = "InvisibleBrush6",
    },
    {
        mechanism_id = 900056,
        event_id = 30056,
        source_object_index = 56,
        source_class = "Door",
        source_name = "Cell21",
        kind = "linear_door",
        hint = "Cell21",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/wooddoorslide01.wav",
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
        mechanism_id = 900057,
        event_id = 30057,
        source_object_index = 57,
        source_class = "Door",
        source_name = "Cell20",
        kind = "linear_door",
        hint = "Cell20",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/wooddoorslide01.wav",
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
        mechanism_id = 900058,
        event_id = 30058,
        source_object_index = 58,
        source_class = "Door",
        source_name = "Cell19",
        kind = "linear_door",
        hint = "Cell19",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/wooddoorslide01.wav",
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
        mechanism_id = 900059,
        event_id = 30059,
        source_object_index = 59,
        source_class = "Door",
        source_name = "Cell18",
        kind = "linear_door",
        hint = "Cell18",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/wooddoorslide01.wav",
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
        mechanism_id = 900060,
        event_id = 30060,
        source_object_index = 60,
        source_class = "Door",
        source_name = "Cell17",
        kind = "linear_door",
        hint = "Cell17",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/wooddoorslide01.wav",
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
        mechanism_id = 900061,
        event_id = 30061,
        source_object_index = 61,
        source_class = "Door",
        source_name = "Cell16",
        kind = "linear_door",
        hint = "Cell16",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/wooddoorslide01.wav",
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
        mechanism_id = 900062,
        event_id = 30062,
        source_object_index = 62,
        source_class = "Door",
        source_name = "Cell15",
        kind = "linear_door",
        hint = "Cell15",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/wooddoorslide01.wav",
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
        mechanism_id = 900063,
        event_id = 30063,
        source_object_index = 63,
        source_class = "Door",
        source_name = "Cell28",
        kind = "linear_door",
        hint = "Cell28",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/wooddoorslide01.wav",
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
        mechanism_id = 900064,
        event_id = 30064,
        source_object_index = 64,
        source_class = "Door",
        source_name = "Cell27",
        kind = "linear_door",
        hint = "Cell27",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/wooddoorslide01.wav",
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
        mechanism_id = 900065,
        event_id = 30065,
        source_object_index = 65,
        source_class = "Door",
        source_name = "Cell26",
        kind = "linear_door",
        hint = "Cell26",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/wooddoorslide01.wav",
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
        mechanism_id = 900066,
        event_id = 30066,
        source_object_index = 66,
        source_class = "Door",
        source_name = "Cell25",
        kind = "linear_door",
        hint = "Cell25",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/wooddoorslide01.wav",
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
        mechanism_id = 900067,
        event_id = 30067,
        source_object_index = 67,
        source_class = "Door",
        source_name = "Cell24",
        kind = "linear_door",
        hint = "Cell24",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/wooddoorslide01.wav",
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
        mechanism_id = 900068,
        event_id = 30068,
        source_object_index = 68,
        source_class = "Door",
        source_name = "Cell23",
        kind = "linear_door",
        hint = "Cell23",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/wooddoorslide01.wav",
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
        mechanism_id = 900069,
        event_id = 30069,
        source_object_index = 69,
        source_class = "Door",
        source_name = "Cell22",
        kind = "linear_door",
        hint = "Cell22",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
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
            ["close_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/wooddoorslide01.wav",
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
        mechanism_id = 900070,
        event_id = 30070,
        source_object_index = 70,
        source_class = "RotatingDoor",
        source_name = "Switch20",
        kind = "rotating_door",
        hint = "Switch20",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
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
        source_class = "RotatingDoor",
        source_name = "Switch19",
        kind = "rotating_door",
        hint = "Switch19",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
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
        source_class = "RotatingDoor",
        source_name = "Switch21",
        kind = "rotating_door",
        hint = "Switch21",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
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
        source_class = "RotatingDoor",
        source_name = "Switch16",
        kind = "rotating_door",
        hint = "Switch16",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900074,
        event_id = 30074,
        source_object_index = 74,
        source_class = "RotatingDoor",
        source_name = "Switch18",
        kind = "rotating_door",
        hint = "Switch18",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900075,
        event_id = 30075,
        source_object_index = 75,
        source_class = "RotatingDoor",
        source_name = "Switch15",
        kind = "rotating_door",
        hint = "Switch15",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
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
        source_name = "Switch17",
        kind = "rotating_door",
        hint = "Switch17",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900077,
        event_id = 30077,
        source_object_index = 77,
        source_class = "RotatingDoor",
        source_name = "Switch27",
        kind = "rotating_door",
        hint = "Switch27",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
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
        source_name = "Switch26",
        kind = "rotating_door",
        hint = "Switch26",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
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
        source_name = "Switch28",
        kind = "rotating_door",
        hint = "Switch28",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
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
        source_name = "Switch23",
        kind = "rotating_door",
        hint = "Switch23",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
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
        source_name = "Switch25",
        kind = "rotating_door",
        hint = "Switch25",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900082,
        event_id = 30082,
        source_object_index = 82,
        source_class = "RotatingDoor",
        source_name = "Switch22",
        kind = "rotating_door",
        hint = "Switch22",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900083,
        event_id = 30083,
        source_object_index = 83,
        source_class = "RotatingDoor",
        source_name = "Switch24",
        kind = "rotating_door",
        hint = "Switch24",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900233,
        event_id = 30233,
        source_object_index = 233,
        source_class = "Door",
        source_name = "super eye door",
        kind = "linear_door",
        hint = "super eye door",
    },
    {
        mechanism_id = 900492,
        event_id = 30492,
        source_object_index = 492,
        source_class = "RotatingDoor",
        source_name = "DresserDoorR1",
        kind = "rotating_door",
        hint = "DresserDoorR1",
    },
    {
        mechanism_id = 900493,
        event_id = 30493,
        source_object_index = 493,
        source_class = "RotatingDoor",
        source_name = "DresserDoorL1",
        kind = "rotating_door",
        hint = "DresserDoorL1",
    },
    {
        mechanism_id = 900494,
        event_id = 30494,
        source_object_index = 494,
        source_class = "Door",
        source_name = "Drawer2",
        kind = "linear_door",
        hint = "Drawer2",
    },
    {
        mechanism_id = 900495,
        event_id = 30495,
        source_object_index = 495,
        source_class = "Door",
        source_name = "Drawer1",
        kind = "linear_door",
        hint = "Drawer1",
    },
    {
        mechanism_id = 900496,
        event_id = 30496,
        source_object_index = 496,
        source_class = "RotatingDoor",
        source_name = "Closet2Door1",
        kind = "rotating_door",
        hint = "Closet2Door1",
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
        mechanism_id = 900497,
        event_id = 30497,
        source_object_index = 497,
        source_class = "RotatingDoor",
        source_name = "Closet2Door2",
        kind = "rotating_door",
        hint = "Closet2Door2",
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
        mechanism_id = 900498,
        event_id = 30498,
        source_object_index = 498,
        source_class = "RotatingDoor",
        source_name = "Closet1Door1",
        kind = "rotating_door",
        hint = "Closet1Door1",
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
        mechanism_id = 900499,
        event_id = 30499,
        source_object_index = 499,
        source_class = "RotatingDoor",
        source_name = "Closet1Door2",
        kind = "rotating_door",
        hint = "Closet1Door2",
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
        mechanism_id = 900500,
        event_id = 30500,
        source_object_index = 500,
        source_class = "RotatingDoor",
        source_name = "DresserDoorR2",
        kind = "rotating_door",
        hint = "DresserDoorR2",
    },
    {
        mechanism_id = 900501,
        event_id = 30501,
        source_object_index = 501,
        source_class = "RotatingDoor",
        source_name = "DresserDoorL2",
        kind = "rotating_door",
        hint = "DresserDoorL2",
    },
    {
        mechanism_id = 900502,
        event_id = 30502,
        source_object_index = 502,
        source_class = "Door",
        source_name = "Drawer3",
        kind = "linear_door",
        hint = "Drawer3",
    },
    {
        mechanism_id = 900503,
        event_id = 30503,
        source_object_index = 503,
        source_class = "Door",
        source_name = "Drawer4",
        kind = "linear_door",
        hint = "Drawer4",
    },
    {
        mechanism_id = 900682,
        event_id = 30682,
        source_object_index = 682,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900743,
        event_id = 30743,
        source_object_index = 743,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900744,
        event_id = 30744,
        source_object_index = 744,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900745,
        event_id = 30745,
        source_object_index = 745,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900746,
        event_id = 30746,
        source_object_index = 746,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 900747,
        event_id = 30747,
        source_object_index = 747,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 900748,
        event_id = 30748,
        source_object_index = 748,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 900804,
        event_id = 30804,
        source_object_index = 804,
        source_class = "Shooter",
        source_name = "ShooterSummon0",
        kind = "shooter",
        hint = "ShooterSummon0",
    },
    {
        mechanism_id = 900805,
        event_id = 30805,
        source_object_index = 805,
        source_class = "Shooter",
        source_name = "ShooterSummon5",
        kind = "shooter",
        hint = "ShooterSummon5",
    },
    {
        mechanism_id = 900806,
        event_id = 30806,
        source_object_index = 806,
        source_class = "Shooter",
        source_name = "ShooterSummon1",
        kind = "shooter",
        hint = "ShooterSummon1",
    },
    {
        mechanism_id = 900807,
        event_id = 30807,
        source_object_index = 807,
        source_class = "Shooter",
        source_name = "ShooterSummon6",
        kind = "shooter",
        hint = "ShooterSummon6",
    },
    {
        mechanism_id = 900808,
        event_id = 30808,
        source_object_index = 808,
        source_class = "Shooter",
        source_name = "ShooterSummon4",
        kind = "shooter",
        hint = "ShooterSummon4",
    },
    {
        mechanism_id = 900809,
        event_id = 30809,
        source_object_index = 809,
        source_class = "Shooter",
        source_name = "ShooterSummon2",
        kind = "shooter",
        hint = "ShooterSummon2",
    },
    {
        mechanism_id = 900810,
        event_id = 30810,
        source_object_index = 810,
        source_class = "Shooter",
        source_name = "ShooterSummon3",
        kind = "shooter",
        hint = "ShooterSummon3",
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
    [30056] = { kind = "open_door", source = "mm9_mechanism", targetName = "Cell21" },
    [30057] = { kind = "open_door", source = "mm9_mechanism", targetName = "Cell20" },
    [30058] = { kind = "open_door", source = "mm9_mechanism", targetName = "Cell19" },
    [30059] = { kind = "open_door", source = "mm9_mechanism", targetName = "Cell18" },
    [30060] = { kind = "open_door", source = "mm9_mechanism", targetName = "Cell17" },
    [30061] = { kind = "open_door", source = "mm9_mechanism", targetName = "Cell16" },
    [30062] = { kind = "open_door", source = "mm9_mechanism", targetName = "Cell15" },
    [30063] = { kind = "open_door", source = "mm9_mechanism", targetName = "Cell28" },
    [30064] = { kind = "open_door", source = "mm9_mechanism", targetName = "Cell27" },
    [30065] = { kind = "open_door", source = "mm9_mechanism", targetName = "Cell26" },
    [30066] = { kind = "open_door", source = "mm9_mechanism", targetName = "Cell25" },
    [30067] = { kind = "open_door", source = "mm9_mechanism", targetName = "Cell24" },
    [30068] = { kind = "open_door", source = "mm9_mechanism", targetName = "Cell23" },
    [30069] = { kind = "open_door", source = "mm9_mechanism", targetName = "Cell22" },
    [30070] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch20" },
    [30071] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch19" },
    [30072] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch21" },
    [30073] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch16" },
    [30074] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch18" },
    [30075] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch15" },
    [30076] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch17" },
    [30077] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch27" },
    [30078] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch26" },
    [30079] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch28" },
    [30080] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch23" },
    [30081] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch25" },
    [30082] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch22" },
    [30083] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch24" },
    [30233] = { kind = "open_door", source = "mm9_mechanism", targetName = "super eye door" },
    [30492] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorR1" },
    [30493] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorL1" },
    [30494] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer2" },
    [30495] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer1" },
    [30496] = { kind = "open_door", source = "mm9_mechanism", targetName = "Closet2Door1" },
    [30497] = { kind = "open_door", source = "mm9_mechanism", targetName = "Closet2Door2" },
    [30498] = { kind = "open_door", source = "mm9_mechanism", targetName = "Closet1Door1" },
    [30499] = { kind = "open_door", source = "mm9_mechanism", targetName = "Closet1Door2" },
    [30500] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorR2" },
    [30501] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorL2" },
    [30502] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer3" },
    [30503] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer4" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30056, "Cell21", function()
    map.triggerMechanism(56, 2)
end, "Cell21")

RegisterEvent(30057, "Cell20", function()
    map.triggerMechanism(57, 2)
end, "Cell20")

RegisterEvent(30058, "Cell19", function()
    map.triggerMechanism(58, 2)
end, "Cell19")

RegisterEvent(30059, "Cell18", function()
    map.triggerMechanism(59, 2)
end, "Cell18")

RegisterEvent(30060, "Cell17", function()
    map.triggerMechanism(60, 2)
end, "Cell17")

RegisterEvent(30061, "Cell16", function()
    map.triggerMechanism(61, 2)
end, "Cell16")

RegisterEvent(30062, "Cell15", function()
    map.triggerMechanism(62, 2)
end, "Cell15")

RegisterEvent(30063, "Cell28", function()
    map.triggerMechanism(63, 2)
end, "Cell28")

RegisterEvent(30064, "Cell27", function()
    map.triggerMechanism(64, 2)
end, "Cell27")

RegisterEvent(30065, "Cell26", function()
    map.triggerMechanism(65, 2)
end, "Cell26")

RegisterEvent(30066, "Cell25", function()
    map.triggerMechanism(66, 2)
end, "Cell25")

RegisterEvent(30067, "Cell24", function()
    map.triggerMechanism(67, 2)
end, "Cell24")

RegisterEvent(30068, "Cell23", function()
    map.triggerMechanism(68, 2)
end, "Cell23")

RegisterEvent(30069, "Cell22", function()
    map.triggerMechanism(69, 2)
end, "Cell22")

RegisterEvent(30070, "Switch20", function()
    map.triggerMechanism(70, 2)
end, "Switch20")

RegisterEvent(30071, "Switch19", function()
    map.triggerMechanism(71, 2)
end, "Switch19")

RegisterEvent(30072, "Switch21", function()
    map.triggerMechanism(72, 2)
end, "Switch21")

RegisterEvent(30073, "Switch16", function()
    map.triggerMechanism(73, 2)
end, "Switch16")

RegisterEvent(30074, "Switch18", function()
    map.triggerMechanism(74, 2)
end, "Switch18")

RegisterEvent(30075, "Switch15", function()
    map.triggerMechanism(75, 2)
end, "Switch15")

RegisterEvent(30076, "Switch17", function()
    map.triggerMechanism(76, 2)
end, "Switch17")

RegisterEvent(30077, "Switch27", function()
    map.triggerMechanism(77, 2)
end, "Switch27")

RegisterEvent(30078, "Switch26", function()
    map.triggerMechanism(78, 2)
end, "Switch26")

RegisterEvent(30079, "Switch28", function()
    map.triggerMechanism(79, 2)
end, "Switch28")

RegisterEvent(30080, "Switch23", function()
    map.triggerMechanism(80, 2)
end, "Switch23")

RegisterEvent(30081, "Switch25", function()
    map.triggerMechanism(81, 2)
end, "Switch25")

RegisterEvent(30082, "Switch22", function()
    map.triggerMechanism(82, 2)
end, "Switch22")

RegisterEvent(30083, "Switch24", function()
    map.triggerMechanism(83, 2)
end, "Switch24")

RegisterEvent(30233, "super eye door", function()
    map.triggerMechanism(233, 2)
end, "super eye door")

RegisterEvent(30492, "DresserDoorR1", function()
    map.triggerMechanism(492, 2)
end, "DresserDoorR1")

RegisterEvent(30493, "DresserDoorL1", function()
    map.triggerMechanism(493, 2)
end, "DresserDoorL1")

RegisterEvent(30494, "Drawer2", function()
    map.triggerMechanism(494, 2)
end, "Drawer2")

RegisterEvent(30495, "Drawer1", function()
    map.triggerMechanism(495, 2)
end, "Drawer1")

RegisterEvent(30496, "Closet2Door1", function()
    map.triggerMechanism(496, 2)
end, "Closet2Door1")

RegisterEvent(30497, "Closet2Door2", function()
    map.triggerMechanism(497, 2)
end, "Closet2Door2")

RegisterEvent(30498, "Closet1Door1", function()
    map.triggerMechanism(498, 2)
end, "Closet1Door1")

RegisterEvent(30499, "Closet1Door2", function()
    map.triggerMechanism(499, 2)
end, "Closet1Door2")

RegisterEvent(30500, "DresserDoorR2", function()
    map.triggerMechanism(500, 2)
end, "DresserDoorR2")

RegisterEvent(30501, "DresserDoorL2", function()
    map.triggerMechanism(501, 2)
end, "DresserDoorL2")

RegisterEvent(30502, "Drawer3", function()
    map.triggerMechanism(502, 2)
end, "Drawer3")

RegisterEvent(30503, "Drawer4", function()
    map.triggerMechanism(503, 2)
end, "Drawer4")

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
map.scripts["givetake.scr"] = {
    source = "GIVETAKE.scr",
    registered_triggers = {
        { line = 70, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc55.scr"] = {
    source = "NPC55.scr",
    registered_triggers = {
        { line = 81, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["relic.scr"] = {
    source = "RELIC.scr",
    registered_triggers = {
        { line = 64, message = "Use", callback = "Onuse" },
    },
    movement_commands = {
    },
}
map.scripts["teleportermulti.scr"] = {
    source = "TELEPORTERMULTI.scr",
    registered_triggers = {
        { line = 19, message = "update", callback = "UpdateDestination" },
    },
    movement_commands = {
    },
}
map.scripts["teleporterswitch.scr"] = {
    source = "TELEPORTERSWITCH.scr",
    registered_triggers = {
        { line = 31, message = "use", callback = "SetDestination" },
        { line = 84, message = "use", callback = "SetDestination" },
    },
    movement_commands = {
    },
}
map.scripts["wizardeffect.scr"] = {
    source = "WIZARDEFFECT.scr",
    registered_triggers = {
        { line = 35, message = "play", callback = "PlayConjureEffect" },
        { line = 36, message = "shoot", callback = "PlayShootEffect" },
    },
    movement_commands = {
    },
}
map.scripts["wizardlabcamera.scr"] = {
    source = "WIZARDLABCAMERA.scr",
    registered_triggers = {
        { line = 19, message = "next", callback = "SoftExit" },
        { line = 29, message = "next", callback = "StartNextScene" },
    },
    movement_commands = {
    },
}
map.scripts["wizardmaster.scr"] = {
    source = "WIZARDMASTER.scr",
    registered_triggers = {
        { line = 47, message = "start", callback = "ConjureSpell" },
        { line = 48, message = "finish", callback = "BanishDemon" },
    },
    movement_commands = {
    },
}
map.scripts["wizardsummoner.scr"] = {
    source = "WIZARDSUMMONER.scr",
    registered_triggers = {
        { line = 43, message = "start", callback = "ConjureSpell" },
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
