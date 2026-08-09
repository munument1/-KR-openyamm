-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "dungeonofsecrets"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 0,
        source_name = "StartPoint0",
        x = 4997,
        y = -1065,
        z = 102,
        direction_yaw_units = 508,
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
        mechanism_id = 900002,
        event_id = 30002,
        source_object_index = 2,
        source_class = "RotatingDoor",
        source_name = "Blade",
        kind = "rotating_door",
        hint = "Blade",
        sounds = {
            ["open_start"] = {
                name = "Door/metaldoorslide01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Environmental/metalgearworks.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/metaldoorslide01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Environmental/metalgearworks.wav",
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
        source_class = "Door",
        source_name = "Sliding Panels",
        kind = "linear_door",
        hint = "Sliding Panels",
        sounds = {
            ["open_busy"] = {
                name = "Environmental/stonestonescrape03.wav",
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
                name = "Environmental/stonestonescrape03.wav",
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
        mechanism_id = 900011,
        event_id = 30011,
        source_object_index = 11,
        source_class = "RotatingDoor",
        source_name = "Side Door",
        kind = "rotating_door",
        hint = "Side Door",
        sounds = {
            ["open_start"] = {
                name = "Environmental/stonestonescrape01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Environmental/stonestonescrape01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorlatch01.wav",
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
        source_class = "Door",
        source_name = "Top Door",
        kind = "linear_door",
        hint = "Top Door",
        sounds = {
            ["close_stop"] = {
                name = "Door/doorlatch01.wav",
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
        source_class = "Door",
        source_name = "Bottom Door",
        kind = "linear_door",
        hint = "Bottom Door",
    },
    {
        mechanism_id = 900014,
        event_id = 30014,
        source_object_index = 14,
        source_class = "Door",
        source_name = "Axe Mover",
        kind = "linear_door",
        hint = "Axe Mover",
    },
    {
        mechanism_id = 900015,
        event_id = 30015,
        source_object_index = 15,
        source_class = "Door",
        source_name = "Panel Mover",
        kind = "linear_door",
        hint = "Panel Mover",
    },
    {
        mechanism_id = 900016,
        event_id = 30016,
        source_object_index = 16,
        source_class = "RotatingDoor",
        source_name = "Bottom Axe",
        kind = "rotating_door",
        hint = "Bottom Axe",
        sounds = {
            ["open_start"] = {
                name = "Door/metaldoorslide01.wav",
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
                name = "Door/metaldoorslide01.wav",
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
        source_name = "Top Axe",
        kind = "rotating_door",
        hint = "Top Axe",
    },
    {
        mechanism_id = 900018,
        event_id = 30018,
        source_object_index = 18,
        source_class = "Door",
        source_name = "doubleaxe upper trigger",
        kind = "linear_door",
        hint = "doubleaxe upper trigger",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
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
        },
    },
    {
        mechanism_id = 900019,
        event_id = 30019,
        source_object_index = 19,
        source_class = "Door",
        source_name = "doubleaxe lower trigger",
        kind = "linear_door",
        hint = "doubleaxe lower trigger",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
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
        },
    },
    {
        mechanism_id = 900022,
        event_id = 30022,
        source_object_index = 22,
        source_class = "RotatingDoor",
        source_name = "axe door 10",
        kind = "rotating_door",
        hint = "axe door 10",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JailCellDoor01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doormetal_close01.wav",
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
        source_name = "axe trap 10",
        kind = "rotating_door",
        hint = "axe trap 10",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JAilCellDoor02.wav",
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
        },
    },
    {
        mechanism_id = 900024,
        event_id = 30024,
        source_object_index = 24,
        source_class = "Door",
        source_name = "timer lever 10",
        kind = "linear_door",
        hint = "timer lever 10",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/metalhitmetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/metalmetal03.wav",
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
        source_name = "axe door 09",
        kind = "rotating_door",
        hint = "axe door 09",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JailCellDoor01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doormetal_close01.wav",
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
        source_name = "axe trap 09",
        kind = "rotating_door",
        hint = "axe trap 09",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JAilCellDoor02.wav",
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
        },
    },
    {
        mechanism_id = 900029,
        event_id = 30029,
        source_object_index = 29,
        source_class = "Door",
        source_name = "timer lever 09",
        kind = "linear_door",
        hint = "timer lever 09",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/metalhitmetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/metalmetal03.wav",
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
        source_name = "axe door 08",
        kind = "rotating_door",
        hint = "axe door 08",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JailCellDoor01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doormetal_close01.wav",
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
        source_name = "axe trap 08",
        kind = "rotating_door",
        hint = "axe trap 08",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JAilCellDoor02.wav",
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
        },
    },
    {
        mechanism_id = 900034,
        event_id = 30034,
        source_object_index = 34,
        source_class = "Door",
        source_name = "timer lever 08",
        kind = "linear_door",
        hint = "timer lever 08",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/metalhitmetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/metalmetal03.wav",
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
        source_name = "axe door 06",
        kind = "rotating_door",
        hint = "axe door 06",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JailCellDoor01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doormetal_close01.wav",
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
        source_class = "RotatingDoor",
        source_name = "axe trap 06",
        kind = "rotating_door",
        hint = "axe trap 06",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JAilCellDoor02.wav",
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
        },
    },
    {
        mechanism_id = 900039,
        event_id = 30039,
        source_object_index = 39,
        source_class = "Door",
        source_name = "timer lever 06",
        kind = "linear_door",
        hint = "timer lever 06",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/metalhitmetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/metalmetal03.wav",
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
        source_class = "RotatingDoor",
        source_name = "axe door 05",
        kind = "rotating_door",
        hint = "axe door 05",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JailCellDoor01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doormetal_close01.wav",
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
        source_name = "axe trap 05",
        kind = "rotating_door",
        hint = "axe trap 05",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JAilCellDoor02.wav",
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
        },
    },
    {
        mechanism_id = 900044,
        event_id = 30044,
        source_object_index = 44,
        source_class = "Door",
        source_name = "timer lever 05",
        kind = "linear_door",
        hint = "timer lever 05",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/metalhitmetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/metalmetal03.wav",
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
        source_name = "axe door 04",
        kind = "rotating_door",
        hint = "axe door 04",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JailCellDoor01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doormetal_close01.wav",
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
        source_name = "axe trap 04",
        kind = "rotating_door",
        hint = "axe trap 04",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JAilCellDoor02.wav",
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
        },
    },
    {
        mechanism_id = 900049,
        event_id = 30049,
        source_object_index = 49,
        source_class = "Door",
        source_name = "timer lever 04",
        kind = "linear_door",
        hint = "timer lever 04",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/metalhitmetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/metalmetal03.wav",
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
        source_name = "axe door 03",
        kind = "rotating_door",
        hint = "axe door 03",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JailCellDoor01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doormetal_close01.wav",
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
        source_name = "axe trap 03",
        kind = "rotating_door",
        hint = "axe trap 03",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JAilCellDoor02.wav",
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
        },
    },
    {
        mechanism_id = 900054,
        event_id = 30054,
        source_object_index = 54,
        source_class = "Door",
        source_name = "timer lever 03",
        kind = "linear_door",
        hint = "timer lever 03",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_busy"] = {
                name = "Events/metalhitmetal03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/metalmetal03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900055,
        event_id = 30055,
        source_object_index = 55,
        source_class = "Door",
        source_name = "timer lever 03a",
        kind = "linear_door",
        hint = "timer lever 03a",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_busy"] = {
                name = "Events/metalhitmetal03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/metalmetal03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900058,
        event_id = 30058,
        source_object_index = 58,
        source_class = "RotatingDoor",
        source_name = "axe door 02",
        kind = "rotating_door",
        hint = "axe door 02",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JailCellDoor01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doormetal_close01.wav",
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
        source_class = "RotatingDoor",
        source_name = "axe trap 02",
        kind = "rotating_door",
        hint = "axe trap 02",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JAilCellDoor02.wav",
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
        },
    },
    {
        mechanism_id = 900060,
        event_id = 30060,
        source_object_index = 60,
        source_class = "Door",
        source_name = "timer lever 02",
        kind = "linear_door",
        hint = "timer lever 02",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/metalhitmetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/metalmetal03.wav",
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
        source_name = "axe door 01",
        kind = "rotating_door",
        hint = "axe door 01",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JailCellDoor01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doormetal_close01.wav",
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
        source_class = "RotatingDoor",
        source_name = "axe trap 01",
        kind = "rotating_door",
        hint = "axe trap 01",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/JAilCellDoor02.wav",
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
        },
    },
    {
        mechanism_id = 900065,
        event_id = 30065,
        source_object_index = 65,
        source_class = "Door",
        source_name = "timer lever 01",
        kind = "linear_door",
        hint = "timer lever 01",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/metalhitmetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/metalmetal03.wav",
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
        source_name = "floor01",
        kind = "linear_door",
        hint = "floor01",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_name = "floor02",
        kind = "linear_door",
        hint = "floor02",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_name = "floor03",
        kind = "linear_door",
        hint = "floor03",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_name = "floor04",
        kind = "linear_door",
        hint = "floor04",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_name = "floor05",
        kind = "linear_door",
        hint = "floor05",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_name = "floor06",
        kind = "linear_door",
        hint = "floor06",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor07",
        kind = "linear_door",
        hint = "floor07",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor08",
        kind = "linear_door",
        hint = "floor08",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor09",
        kind = "linear_door",
        hint = "floor09",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor10",
        kind = "linear_door",
        hint = "floor10",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_name = "floor11",
        kind = "linear_door",
        hint = "floor11",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_name = "floor12",
        kind = "linear_door",
        hint = "floor12",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_name = "floor13",
        kind = "linear_door",
        hint = "floor13",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_name = "floor14",
        kind = "linear_door",
        hint = "floor14",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor15",
        kind = "linear_door",
        hint = "floor15",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor16",
        kind = "linear_door",
        hint = "floor16",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900084,
        event_id = 30084,
        source_object_index = 84,
        source_class = "Door",
        source_name = "floor17",
        kind = "linear_door",
        hint = "floor17",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor18",
        kind = "linear_door",
        hint = "floor18",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor19",
        kind = "linear_door",
        hint = "floor19",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor20",
        kind = "linear_door",
        hint = "floor20",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor22",
        kind = "linear_door",
        hint = "floor22",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900089,
        event_id = 30089,
        source_object_index = 89,
        source_class = "Door",
        source_name = "floor21",
        kind = "linear_door",
        hint = "floor21",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900090,
        event_id = 30090,
        source_object_index = 90,
        source_class = "Door",
        source_name = "floor23",
        kind = "linear_door",
        hint = "floor23",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900091,
        event_id = 30091,
        source_object_index = 91,
        source_class = "Door",
        source_name = "floor24",
        kind = "linear_door",
        hint = "floor24",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_name = "floor25",
        kind = "linear_door",
        hint = "floor25",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_name = "floor26",
        kind = "linear_door",
        hint = "floor26",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor27",
        kind = "linear_door",
        hint = "floor27",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor28",
        kind = "linear_door",
        hint = "floor28",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor29",
        kind = "linear_door",
        hint = "floor29",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor30",
        kind = "linear_door",
        hint = "floor30",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor31",
        kind = "linear_door",
        hint = "floor31",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor32",
        kind = "linear_door",
        hint = "floor32",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor33",
        kind = "linear_door",
        hint = "floor33",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor34",
        kind = "linear_door",
        hint = "floor34",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor35",
        kind = "linear_door",
        hint = "floor35",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_name = "floor36",
        kind = "linear_door",
        hint = "floor36",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900104,
        event_id = 30104,
        source_object_index = 104,
        source_class = "Door",
        source_name = "floor37",
        kind = "linear_door",
        hint = "floor37",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor38",
        kind = "linear_door",
        hint = "floor38",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor39",
        kind = "linear_door",
        hint = "floor39",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900107,
        event_id = 30107,
        source_object_index = 107,
        source_class = "Door",
        source_name = "floor40",
        kind = "linear_door",
        hint = "floor40",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900108,
        event_id = 30108,
        source_object_index = 108,
        source_class = "Door",
        source_name = "floor41",
        kind = "linear_door",
        hint = "floor41",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900109,
        event_id = 30109,
        source_object_index = 109,
        source_class = "Door",
        source_name = "floor42",
        kind = "linear_door",
        hint = "floor42",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor43",
        kind = "linear_door",
        hint = "floor43",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor44",
        kind = "linear_door",
        hint = "floor44",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900112,
        event_id = 30112,
        source_object_index = 112,
        source_class = "Door",
        source_name = "floor45",
        kind = "linear_door",
        hint = "floor45",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900113,
        event_id = 30113,
        source_object_index = 113,
        source_class = "Door",
        source_name = "floor46",
        kind = "linear_door",
        hint = "floor46",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900114,
        event_id = 30114,
        source_object_index = 114,
        source_class = "Door",
        source_name = "floor47",
        kind = "linear_door",
        hint = "floor47",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900115,
        event_id = 30115,
        source_object_index = 115,
        source_class = "Door",
        source_name = "floor48",
        kind = "linear_door",
        hint = "floor48",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900116,
        event_id = 30116,
        source_object_index = 116,
        source_class = "Door",
        source_name = "floor49",
        kind = "linear_door",
        hint = "floor49",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900117,
        event_id = 30117,
        source_object_index = 117,
        source_class = "Door",
        source_name = "floor50",
        kind = "linear_door",
        hint = "floor50",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor51",
        kind = "linear_door",
        hint = "floor51",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor52",
        kind = "linear_door",
        hint = "floor52",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor53",
        kind = "linear_door",
        hint = "floor53",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor54",
        kind = "linear_door",
        hint = "floor54",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor55",
        kind = "linear_door",
        hint = "floor55",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor56",
        kind = "linear_door",
        hint = "floor56",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor57",
        kind = "linear_door",
        hint = "floor57",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor58",
        kind = "linear_door",
        hint = "floor58",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Door",
        source_name = "floor59",
        kind = "linear_door",
        hint = "floor59",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900127,
        event_id = 30127,
        source_object_index = 127,
        source_class = "Door",
        source_name = "floor60",
        kind = "linear_door",
        hint = "floor60",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_name = "floor61",
        kind = "linear_door",
        hint = "floor61",
        sounds = {
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
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
        source_class = "Shooter",
        source_name = "shooter13",
        kind = "shooter",
        hint = "shooter13",
    },
    {
        mechanism_id = 900130,
        event_id = 30130,
        source_object_index = 130,
        source_class = "Shooter",
        source_name = "shooter27",
        kind = "shooter",
        hint = "shooter27",
    },
    {
        mechanism_id = 900131,
        event_id = 30131,
        source_object_index = 131,
        source_class = "Shooter",
        source_name = "shooter41",
        kind = "shooter",
        hint = "shooter41",
    },
    {
        mechanism_id = 900132,
        event_id = 30132,
        source_object_index = 132,
        source_class = "Shooter",
        source_name = "shooter55",
        kind = "shooter",
        hint = "shooter55",
    },
    {
        mechanism_id = 900133,
        event_id = 30133,
        source_object_index = 133,
        source_class = "Shooter",
        source_name = "shooter14",
        kind = "shooter",
        hint = "shooter14",
    },
    {
        mechanism_id = 900134,
        event_id = 30134,
        source_object_index = 134,
        source_class = "Shooter",
        source_name = "shooter28",
        kind = "shooter",
        hint = "shooter28",
    },
    {
        mechanism_id = 900135,
        event_id = 30135,
        source_object_index = 135,
        source_class = "Shooter",
        source_name = "shooter42",
        kind = "shooter",
        hint = "shooter42",
    },
    {
        mechanism_id = 900136,
        event_id = 30136,
        source_object_index = 136,
        source_class = "Shooter",
        source_name = "shooter56",
        kind = "shooter",
        hint = "shooter56",
    },
    {
        mechanism_id = 900137,
        event_id = 30137,
        source_object_index = 137,
        source_class = "Shooter",
        source_name = "shooter4",
        kind = "shooter",
        hint = "shooter4",
    },
    {
        mechanism_id = 900138,
        event_id = 30138,
        source_object_index = 138,
        source_class = "Shooter",
        source_name = "shooter18",
        kind = "shooter",
        hint = "shooter18",
    },
    {
        mechanism_id = 900139,
        event_id = 30139,
        source_object_index = 139,
        source_class = "Shooter",
        source_name = "shooter32",
        kind = "shooter",
        hint = "shooter32",
    },
    {
        mechanism_id = 900140,
        event_id = 30140,
        source_object_index = 140,
        source_class = "Shooter",
        source_name = "shooter46",
        kind = "shooter",
        hint = "shooter46",
    },
    {
        mechanism_id = 900141,
        event_id = 30141,
        source_object_index = 141,
        source_class = "Shooter",
        source_name = "shooter60",
        kind = "shooter",
        hint = "shooter60",
    },
    {
        mechanism_id = 900142,
        event_id = 30142,
        source_object_index = 142,
        source_class = "Shooter",
        source_name = "shooter5",
        kind = "shooter",
        hint = "shooter5",
    },
    {
        mechanism_id = 900143,
        event_id = 30143,
        source_object_index = 143,
        source_class = "Shooter",
        source_name = "shooter19",
        kind = "shooter",
        hint = "shooter19",
    },
    {
        mechanism_id = 900144,
        event_id = 30144,
        source_object_index = 144,
        source_class = "Shooter",
        source_name = "shooter33",
        kind = "shooter",
        hint = "shooter33",
    },
    {
        mechanism_id = 900145,
        event_id = 30145,
        source_object_index = 145,
        source_class = "Shooter",
        source_name = "shooter47",
        kind = "shooter",
        hint = "shooter47",
    },
    {
        mechanism_id = 900146,
        event_id = 30146,
        source_object_index = 146,
        source_class = "Shooter",
        source_name = "shooter61",
        kind = "shooter",
        hint = "shooter61",
    },
    {
        mechanism_id = 900147,
        event_id = 30147,
        source_object_index = 147,
        source_class = "Shooter",
        source_name = "shooter12",
        kind = "shooter",
        hint = "shooter12",
    },
    {
        mechanism_id = 900148,
        event_id = 30148,
        source_object_index = 148,
        source_class = "Shooter",
        source_name = "shooter26",
        kind = "shooter",
        hint = "shooter26",
    },
    {
        mechanism_id = 900149,
        event_id = 30149,
        source_object_index = 149,
        source_class = "Shooter",
        source_name = "shooter40",
        kind = "shooter",
        hint = "shooter40",
    },
    {
        mechanism_id = 900150,
        event_id = 30150,
        source_object_index = 150,
        source_class = "Shooter",
        source_name = "shooter54",
        kind = "shooter",
        hint = "shooter54",
    },
    {
        mechanism_id = 900151,
        event_id = 30151,
        source_object_index = 151,
        source_class = "Shooter",
        source_name = "shooter11",
        kind = "shooter",
        hint = "shooter11",
    },
    {
        mechanism_id = 900152,
        event_id = 30152,
        source_object_index = 152,
        source_class = "Shooter",
        source_name = "shooter25",
        kind = "shooter",
        hint = "shooter25",
    },
    {
        mechanism_id = 900153,
        event_id = 30153,
        source_object_index = 153,
        source_class = "Shooter",
        source_name = "shooter39",
        kind = "shooter",
        hint = "shooter39",
    },
    {
        mechanism_id = 900154,
        event_id = 30154,
        source_object_index = 154,
        source_class = "Shooter",
        source_name = "shooter53",
        kind = "shooter",
        hint = "shooter53",
    },
    {
        mechanism_id = 900155,
        event_id = 30155,
        source_object_index = 155,
        source_class = "Shooter",
        source_name = "shooter10L",
        kind = "shooter",
        hint = "shooter10L",
    },
    {
        mechanism_id = 900156,
        event_id = 30156,
        source_object_index = 156,
        source_class = "Shooter",
        source_name = "shooter24L",
        kind = "shooter",
        hint = "shooter24L",
    },
    {
        mechanism_id = 900157,
        event_id = 30157,
        source_object_index = 157,
        source_class = "Shooter",
        source_name = "shooter38L",
        kind = "shooter",
        hint = "shooter38L",
    },
    {
        mechanism_id = 900158,
        event_id = 30158,
        source_object_index = 158,
        source_class = "Shooter",
        source_name = "shooter52L",
        kind = "shooter",
        hint = "shooter52L",
    },
    {
        mechanism_id = 900159,
        event_id = 30159,
        source_object_index = 159,
        source_class = "Shooter",
        source_name = "shooter3L",
        kind = "shooter",
        hint = "shooter3L",
    },
    {
        mechanism_id = 900160,
        event_id = 30160,
        source_object_index = 160,
        source_class = "Shooter",
        source_name = "shooter17L",
        kind = "shooter",
        hint = "shooter17L",
    },
    {
        mechanism_id = 900161,
        event_id = 30161,
        source_object_index = 161,
        source_class = "Shooter",
        source_name = "shooter31L",
        kind = "shooter",
        hint = "shooter31L",
    },
    {
        mechanism_id = 900162,
        event_id = 30162,
        source_object_index = 162,
        source_class = "Shooter",
        source_name = "shooter45L",
        kind = "shooter",
        hint = "shooter45L",
    },
    {
        mechanism_id = 900163,
        event_id = 30163,
        source_object_index = 163,
        source_class = "Shooter",
        source_name = "shooter59L",
        kind = "shooter",
        hint = "shooter59L",
    },
    {
        mechanism_id = 900164,
        event_id = 30164,
        source_object_index = 164,
        source_class = "Shooter",
        source_name = "shooter17R",
        kind = "shooter",
        hint = "shooter17R",
    },
    {
        mechanism_id = 900165,
        event_id = 30165,
        source_object_index = 165,
        source_class = "Shooter",
        source_name = "shooter31R",
        kind = "shooter",
        hint = "shooter31R",
    },
    {
        mechanism_id = 900166,
        event_id = 30166,
        source_object_index = 166,
        source_class = "Shooter",
        source_name = "shooter3R",
        kind = "shooter",
        hint = "shooter3R",
    },
    {
        mechanism_id = 900167,
        event_id = 30167,
        source_object_index = 167,
        source_class = "Shooter",
        source_name = "shooter45R",
        kind = "shooter",
        hint = "shooter45R",
    },
    {
        mechanism_id = 900168,
        event_id = 30168,
        source_object_index = 168,
        source_class = "Shooter",
        source_name = "shooter59R",
        kind = "shooter",
        hint = "shooter59R",
    },
    {
        mechanism_id = 900169,
        event_id = 30169,
        source_object_index = 169,
        source_class = "Shooter",
        source_name = "shooter10R",
        kind = "shooter",
        hint = "shooter10R",
    },
    {
        mechanism_id = 900170,
        event_id = 30170,
        source_object_index = 170,
        source_class = "Shooter",
        source_name = "shooter24R",
        kind = "shooter",
        hint = "shooter24R",
    },
    {
        mechanism_id = 900171,
        event_id = 30171,
        source_object_index = 171,
        source_class = "Shooter",
        source_name = "shooter38R",
        kind = "shooter",
        hint = "shooter38R",
    },
    {
        mechanism_id = 900172,
        event_id = 30172,
        source_object_index = 172,
        source_class = "Shooter",
        source_name = "shooter52R",
        kind = "shooter",
        hint = "shooter52R",
    },
    {
        mechanism_id = 900173,
        event_id = 30173,
        source_object_index = 173,
        source_class = "Shooter",
        source_name = "shooter23",
        kind = "shooter",
        hint = "shooter23",
    },
    {
        mechanism_id = 900174,
        event_id = 30174,
        source_object_index = 174,
        source_class = "Shooter",
        source_name = "shooter37",
        kind = "shooter",
        hint = "shooter37",
    },
    {
        mechanism_id = 900175,
        event_id = 30175,
        source_object_index = 175,
        source_class = "Shooter",
        source_name = "shooter51",
        kind = "shooter",
        hint = "shooter51",
    },
    {
        mechanism_id = 900176,
        event_id = 30176,
        source_object_index = 176,
        source_class = "Shooter",
        source_name = "shooter9",
        kind = "shooter",
        hint = "shooter9",
    },
    {
        mechanism_id = 900177,
        event_id = 30177,
        source_object_index = 177,
        source_class = "Shooter",
        source_name = "shooter22",
        kind = "shooter",
        hint = "shooter22",
    },
    {
        mechanism_id = 900178,
        event_id = 30178,
        source_object_index = 178,
        source_class = "Shooter",
        source_name = "shooter36",
        kind = "shooter",
        hint = "shooter36",
    },
    {
        mechanism_id = 900179,
        event_id = 30179,
        source_object_index = 179,
        source_class = "Shooter",
        source_name = "shooter50",
        kind = "shooter",
        hint = "shooter50",
    },
    {
        mechanism_id = 900180,
        event_id = 30180,
        source_object_index = 180,
        source_class = "Shooter",
        source_name = "shooter8",
        kind = "shooter",
        hint = "shooter8",
    },
    {
        mechanism_id = 900181,
        event_id = 30181,
        source_object_index = 181,
        source_class = "Shooter",
        source_name = "shooter1",
        kind = "shooter",
        hint = "shooter1",
    },
    {
        mechanism_id = 900182,
        event_id = 30182,
        source_object_index = 182,
        source_class = "Shooter",
        source_name = "shooter15",
        kind = "shooter",
        hint = "shooter15",
    },
    {
        mechanism_id = 900183,
        event_id = 30183,
        source_object_index = 183,
        source_class = "Shooter",
        source_name = "shooter29",
        kind = "shooter",
        hint = "shooter29",
    },
    {
        mechanism_id = 900184,
        event_id = 30184,
        source_object_index = 184,
        source_class = "Shooter",
        source_name = "shooter43",
        kind = "shooter",
        hint = "shooter43",
    },
    {
        mechanism_id = 900185,
        event_id = 30185,
        source_object_index = 185,
        source_class = "Shooter",
        source_name = "shooter57",
        kind = "shooter",
        hint = "shooter57",
    },
    {
        mechanism_id = 900186,
        event_id = 30186,
        source_object_index = 186,
        source_class = "Shooter",
        source_name = "shooter2",
        kind = "shooter",
        hint = "shooter2",
    },
    {
        mechanism_id = 900187,
        event_id = 30187,
        source_object_index = 187,
        source_class = "Shooter",
        source_name = "shooter16",
        kind = "shooter",
        hint = "shooter16",
    },
    {
        mechanism_id = 900188,
        event_id = 30188,
        source_object_index = 188,
        source_class = "Shooter",
        source_name = "shooter30",
        kind = "shooter",
        hint = "shooter30",
    },
    {
        mechanism_id = 900189,
        event_id = 30189,
        source_object_index = 189,
        source_class = "Shooter",
        source_name = "shooter44",
        kind = "shooter",
        hint = "shooter44",
    },
    {
        mechanism_id = 900190,
        event_id = 30190,
        source_object_index = 190,
        source_class = "Shooter",
        source_name = "shooter58",
        kind = "shooter",
        hint = "shooter58",
    },
    {
        mechanism_id = 900191,
        event_id = 30191,
        source_object_index = 191,
        source_class = "Shooter",
        source_name = "shooter20",
        kind = "shooter",
        hint = "shooter20",
    },
    {
        mechanism_id = 900192,
        event_id = 30192,
        source_object_index = 192,
        source_class = "Shooter",
        source_name = "shooter34",
        kind = "shooter",
        hint = "shooter34",
    },
    {
        mechanism_id = 900193,
        event_id = 30193,
        source_object_index = 193,
        source_class = "Shooter",
        source_name = "shooter48",
        kind = "shooter",
        hint = "shooter48",
    },
    {
        mechanism_id = 900194,
        event_id = 30194,
        source_object_index = 194,
        source_class = "Shooter",
        source_name = "shooter6",
        kind = "shooter",
        hint = "shooter6",
    },
    {
        mechanism_id = 900195,
        event_id = 30195,
        source_object_index = 195,
        source_class = "Shooter",
        source_name = "shooter21",
        kind = "shooter",
        hint = "shooter21",
    },
    {
        mechanism_id = 900196,
        event_id = 30196,
        source_object_index = 196,
        source_class = "Shooter",
        source_name = "shooter35",
        kind = "shooter",
        hint = "shooter35",
    },
    {
        mechanism_id = 900197,
        event_id = 30197,
        source_object_index = 197,
        source_class = "Shooter",
        source_name = "shooter49",
        kind = "shooter",
        hint = "shooter49",
    },
    {
        mechanism_id = 900198,
        event_id = 30198,
        source_object_index = 198,
        source_class = "Shooter",
        source_name = "shooter7",
        kind = "shooter",
        hint = "shooter7",
    },
    {
        mechanism_id = 900199,
        event_id = 30199,
        source_object_index = 199,
        source_class = "Shooter",
        source_name = "shooter0",
        kind = "shooter",
        hint = "shooter0",
    },
    {
        mechanism_id = 900281,
        event_id = 30281,
        source_object_index = 281,
        source_class = "Door",
        source_name = "gplate2",
        kind = "linear_door",
        hint = "gplate2",
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
        },
    },
    {
        mechanism_id = 900282,
        event_id = 30282,
        source_object_index = 282,
        source_class = "Door",
        source_name = "gplate3",
        kind = "linear_door",
        hint = "gplate3",
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
        },
    },
    {
        mechanism_id = 900283,
        event_id = 30283,
        source_object_index = 283,
        source_class = "Door",
        source_name = "gplate4",
        kind = "linear_door",
        hint = "gplate4",
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
        },
    },
    {
        mechanism_id = 900284,
        event_id = 30284,
        source_object_index = 284,
        source_class = "Door",
        source_name = "gplate5",
        kind = "linear_door",
        hint = "gplate5",
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
        },
    },
    {
        mechanism_id = 900285,
        event_id = 30285,
        source_object_index = 285,
        source_class = "Door",
        source_name = "gplate6",
        kind = "linear_door",
        hint = "gplate6",
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
        },
    },
    {
        mechanism_id = 900286,
        event_id = 30286,
        source_object_index = 286,
        source_class = "Door",
        source_name = "gplate7",
        kind = "linear_door",
        hint = "gplate7",
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
        },
    },
    {
        mechanism_id = 900287,
        event_id = 30287,
        source_object_index = 287,
        source_class = "Door",
        source_name = "gplate8",
        kind = "linear_door",
        hint = "gplate8",
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
        },
    },
    {
        mechanism_id = 900288,
        event_id = 30288,
        source_object_index = 288,
        source_class = "Door",
        source_name = "gplate9",
        kind = "linear_door",
        hint = "gplate9",
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
        },
    },
    {
        mechanism_id = 900289,
        event_id = 30289,
        source_object_index = 289,
        source_class = "Door",
        source_name = "gplate1",
        kind = "linear_door",
        hint = "gplate1",
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
        },
    },
    {
        mechanism_id = 900290,
        event_id = 30290,
        source_object_index = 290,
        source_class = "Door",
        source_name = "gplate10",
        kind = "linear_door",
        hint = "gplate10",
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
        },
    },
    {
        mechanism_id = 900303,
        event_id = 30303,
        source_object_index = 303,
        source_class = "RotatingDoor",
        source_name = "gtrap1",
        kind = "rotating_door",
        hint = "gtrap1",
        sounds = {
            ["open_start"] = {
                name = "Weapons/knifereload.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Weapons/ArrowLaunch.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/metaldoorslide02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/cell_door_close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900304,
        event_id = 30304,
        source_object_index = 304,
        source_class = "RotatingDoor",
        source_name = "gtrap2",
        kind = "rotating_door",
        hint = "gtrap2",
        sounds = {
            ["open_start"] = {
                name = "Weapons/knifereload.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Weapons/ArrowLaunch.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/metaldoorslide02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/cell_door_close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900305,
        event_id = 30305,
        source_object_index = 305,
        source_class = "Door",
        source_name = "gtrap3",
        kind = "linear_door",
        hint = "gtrap3",
        sounds = {
            ["open_start"] = {
                name = "Events/draweropenwood.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/drawerclosewood.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900306,
        event_id = 30306,
        source_object_index = 306,
        source_class = "Door",
        source_name = "gtrap4",
        kind = "linear_door",
        hint = "gtrap4",
        sounds = {
            ["open_start"] = {
                name = "AnimSounds/DragonRedhop.wav",
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
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/unlock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900307,
        event_id = 30307,
        source_object_index = 307,
        source_class = "RotatingDoor",
        source_name = "gtrap7a",
        kind = "rotating_door",
        hint = "gtrap7a",
        sounds = {
            ["open_start"] = {
                name = "Door/metaldoorslide01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Environmental/metalgearworks.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/metaldoorslide01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Environmental/metalgearworks.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900308,
        event_id = 30308,
        source_object_index = 308,
        source_class = "RotatingDoor",
        source_name = "gtrap7b",
        kind = "rotating_door",
        hint = "gtrap7b",
        sounds = {
            ["open_start"] = {
                name = "Weapons/maceswing.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Environmental/metalgearworks.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Weapons/maceswing.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Environmental/metalgearworks.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900311,
        event_id = 30311,
        source_object_index = 311,
        source_class = "Door",
        source_name = "gtrap8b",
        kind = "linear_door",
        hint = "gtrap8b",
        sounds = {
            ["open_start"] = {
                name = "Ambient/metalcreak01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/steam_burst06.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Ambient/metalcreak02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/steam_burst05.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900312,
        event_id = 30312,
        source_object_index = 312,
        source_class = "RotatingBrush",
        source_name = "saw8b",
        kind = "rotating_brush",
        hint = "saw8b",
    },
    {
        mechanism_id = 900313,
        event_id = 30313,
        source_object_index = 313,
        source_class = "Door",
        source_name = "gtrap8a",
        kind = "linear_door",
        hint = "gtrap8a",
        sounds = {
            ["open_start"] = {
                name = "Ambient/metalcreak01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/steam_burst06.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Ambient/metalcreak02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/PUSHTERRAIN.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/steam_burst05.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900314,
        event_id = 30314,
        source_object_index = 314,
        source_class = "RotatingBrush",
        source_name = "saw8a",
        kind = "rotating_brush",
        hint = "saw8a",
    },
    {
        mechanism_id = 900316,
        event_id = 30316,
        source_object_index = 316,
        source_class = "RotatingDoor",
        source_name = "gtrap9",
        kind = "rotating_door",
        hint = "gtrap9",
        sounds = {
            ["open_start"] = {
                name = "Events/drawbridge02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/gears01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Ambient/machinery02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Weapons/BowTwang01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900317,
        event_id = 30317,
        source_object_index = 317,
        source_class = "RotatingBrush",
        source_name = "saw9",
        kind = "rotating_brush",
        hint = "saw9",
    },
    {
        mechanism_id = 900318,
        event_id = 30318,
        source_object_index = 318,
        source_class = "RotatingDoor",
        source_name = "gtrap5",
        kind = "rotating_door",
        hint = "gtrap5",
        sounds = {
            ["open_start"] = {
                name = "Events/steam_burst03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/slam.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/steam_burst04.wav",
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
        mechanism_id = 900319,
        event_id = 30319,
        source_object_index = 319,
        source_class = "RotatingDoor",
        source_name = "gtrap10",
        kind = "rotating_door",
        hint = "gtrap10",
        sounds = {
            ["open_start"] = {
                name = "Events/steam_burst03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/slam.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/steam_burst04.wav",
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
        mechanism_id = 900320,
        event_id = 30320,
        source_object_index = 320,
        source_class = "RotatingDoor",
        source_name = "gtrap6",
        kind = "rotating_door",
        hint = "gtrap6",
        sounds = {
            ["open_start"] = {
                name = "Events/steam_burst03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/slam.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/steam_burst04.wav",
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
        mechanism_id = 900347,
        event_id = 30347,
        source_object_index = 347,
        source_class = "RotatingDoor",
        source_name = "entrance gate",
        kind = "rotating_door",
        hint = "entrance gate",
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
        mechanism_id = 900348,
        event_id = 30348,
        source_object_index = 348,
        source_class = "Door",
        source_name = "entrance button",
        kind = "linear_door",
        hint = "entrance button",
        sounds = {
            ["open_stop"] = {
                name = "Door/door05open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900349,
        event_id = 30349,
        source_object_index = 349,
        source_class = "RotatingDoor",
        source_name = "exit gate",
        kind = "rotating_door",
        hint = "exit gate",
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
        mechanism_id = 900561,
        event_id = 30561,
        source_object_index = 561,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900562,
        event_id = 30562,
        source_object_index = 562,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900563,
        event_id = 30563,
        source_object_index = 563,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900564,
        event_id = 30564,
        source_object_index = 564,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900565,
        event_id = 30565,
        source_object_index = 565,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 900566,
        event_id = 30566,
        source_object_index = 566,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 900567,
        event_id = 30567,
        source_object_index = 567,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 900568,
        event_id = 30568,
        source_object_index = 568,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush7",
        kind = "perception_brush",
        hint = "PerceptionBrush7",
    },
    {
        mechanism_id = 900569,
        event_id = 30569,
        source_object_index = 569,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush8",
        kind = "perception_brush",
        hint = "PerceptionBrush8",
    },
    {
        mechanism_id = 900570,
        event_id = 30570,
        source_object_index = 570,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush9",
        kind = "perception_brush",
        hint = "PerceptionBrush9",
    },
    {
        mechanism_id = 900571,
        event_id = 30571,
        source_object_index = 571,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush10",
        kind = "perception_brush",
        hint = "PerceptionBrush10",
    },
    {
        mechanism_id = 900572,
        event_id = 30572,
        source_object_index = 572,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush11",
        kind = "perception_brush",
        hint = "PerceptionBrush11",
    },
    {
        mechanism_id = 900573,
        event_id = 30573,
        source_object_index = 573,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush12",
        kind = "perception_brush",
        hint = "PerceptionBrush12",
    },
    {
        mechanism_id = 900574,
        event_id = 30574,
        source_object_index = 574,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush13",
        kind = "perception_brush",
        hint = "PerceptionBrush13",
    },
    {
        mechanism_id = 900575,
        event_id = 30575,
        source_object_index = 575,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush14",
        kind = "perception_brush",
        hint = "PerceptionBrush14",
    },
    {
        mechanism_id = 900576,
        event_id = 30576,
        source_object_index = 576,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush15",
        kind = "perception_brush",
        hint = "PerceptionBrush15",
    },
    {
        mechanism_id = 900577,
        event_id = 30577,
        source_object_index = 577,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush16",
        kind = "perception_brush",
        hint = "PerceptionBrush16",
    },
    {
        mechanism_id = 900578,
        event_id = 30578,
        source_object_index = 578,
        source_class = "RotatingDoor",
        source_name = "water grate",
        kind = "rotating_door",
        hint = "water grate",
    },
    {
        mechanism_id = 900580,
        event_id = 30580,
        source_object_index = 580,
        source_class = "RotatingDoor",
        source_name = "water grate opener",
        kind = "rotating_door",
        hint = "water grate opener",
    },
    {
        mechanism_id = 900581,
        event_id = 30581,
        source_object_index = 581,
        source_class = "Door",
        source_name = "elevator",
        kind = "linear_door",
        hint = "elevator",
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
        },
    },
    {
        mechanism_id = 900609,
        event_id = 30609,
        source_object_index = 609,
        source_class = "Shooter",
        source_name = "ratshooter08a",
        kind = "shooter",
        hint = "ratshooter08a",
    },
    {
        mechanism_id = 900610,
        event_id = 30610,
        source_object_index = 610,
        source_class = "Shooter",
        source_name = "ratshooter01",
        kind = "shooter",
        hint = "ratshooter01",
    },
    {
        mechanism_id = 900611,
        event_id = 30611,
        source_object_index = 611,
        source_class = "Shooter",
        source_name = "ratshooter08b",
        kind = "shooter",
        hint = "ratshooter08b",
    },
    {
        mechanism_id = 900612,
        event_id = 30612,
        source_object_index = 612,
        source_class = "Shooter",
        source_name = "ratshooter06",
        kind = "shooter",
        hint = "ratshooter06",
    },
    {
        mechanism_id = 900613,
        event_id = 30613,
        source_object_index = 613,
        source_class = "Shooter",
        source_name = "ratshooter07",
        kind = "shooter",
        hint = "ratshooter07",
    },
    {
        mechanism_id = 900614,
        event_id = 30614,
        source_object_index = 614,
        source_class = "Shooter",
        source_name = "ratshooter03",
        kind = "shooter",
        hint = "ratshooter03",
    },
    {
        mechanism_id = 900615,
        event_id = 30615,
        source_object_index = 615,
        source_class = "Shooter",
        source_name = "ratshooter02",
        kind = "shooter",
        hint = "ratshooter02",
    },
    {
        mechanism_id = 900616,
        event_id = 30616,
        source_object_index = 616,
        source_class = "Shooter",
        source_name = "ratshooter04",
        kind = "shooter",
        hint = "ratshooter04",
    },
    {
        mechanism_id = 900617,
        event_id = 30617,
        source_object_index = 617,
        source_class = "Shooter",
        source_name = "ratshooter05",
        kind = "shooter",
        hint = "ratshooter05",
    },
    {
        mechanism_id = 900634,
        event_id = 30634,
        source_object_index = 634,
        source_class = "Door",
        source_name = "ratdoortrigger",
        kind = "linear_door",
        hint = "ratdoortrigger",
    },
    {
        mechanism_id = 900637,
        event_id = 30637,
        source_object_index = 637,
        source_class = "Door",
        source_name = "fake lever 1",
        kind = "linear_door",
        hint = "fake lever 1",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900638,
        event_id = 30638,
        source_object_index = 638,
        source_class = "Door",
        source_name = "fake lever 2",
        kind = "linear_door",
        hint = "fake lever 2",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900639,
        event_id = 30639,
        source_object_index = 639,
        source_class = "Door",
        source_name = "fake lever 3",
        kind = "linear_door",
        hint = "fake lever 3",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900640,
        event_id = 30640,
        source_object_index = 640,
        source_class = "Door",
        source_name = "fake lever 4",
        kind = "linear_door",
        hint = "fake lever 4",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900641,
        event_id = 30641,
        source_object_index = 641,
        source_class = "Door",
        source_name = "fake lever 5",
        kind = "linear_door",
        hint = "fake lever 5",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900642,
        event_id = 30642,
        source_object_index = 642,
        source_class = "Door",
        source_name = "fake lever 6",
        kind = "linear_door",
        hint = "fake lever 6",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900643,
        event_id = 30643,
        source_object_index = 643,
        source_class = "Door",
        source_name = "fake lever 7",
        kind = "linear_door",
        hint = "fake lever 7",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900644,
        event_id = 30644,
        source_object_index = 644,
        source_class = "Door",
        source_name = "fake lever 8",
        kind = "linear_door",
        hint = "fake lever 8",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900645,
        event_id = 30645,
        source_object_index = 645,
        source_class = "Door",
        source_name = "fake lever 9",
        kind = "linear_door",
        hint = "fake lever 9",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900646,
        event_id = 30646,
        source_object_index = 646,
        source_class = "Door",
        source_name = "fake lever 10",
        kind = "linear_door",
        hint = "fake lever 10",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900647,
        event_id = 30647,
        source_object_index = 647,
        source_class = "Door",
        source_name = "fake lever 11",
        kind = "linear_door",
        hint = "fake lever 11",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900648,
        event_id = 30648,
        source_object_index = 648,
        source_class = "Door",
        source_name = "fake lever 12",
        kind = "linear_door",
        hint = "fake lever 12",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900649,
        event_id = 30649,
        source_object_index = 649,
        source_class = "Door",
        source_name = "fake lever 13",
        kind = "linear_door",
        hint = "fake lever 13",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900650,
        event_id = 30650,
        source_object_index = 650,
        source_class = "Door",
        source_name = "fake lever 14",
        kind = "linear_door",
        hint = "fake lever 14",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900651,
        event_id = 30651,
        source_object_index = 651,
        source_class = "Door",
        source_name = "fake lever 15",
        kind = "linear_door",
        hint = "fake lever 15",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900652,
        event_id = 30652,
        source_object_index = 652,
        source_class = "Door",
        source_name = "fake lever 16",
        kind = "linear_door",
        hint = "fake lever 16",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900653,
        event_id = 30653,
        source_object_index = 653,
        source_class = "Door",
        source_name = "fake lever 17",
        kind = "linear_door",
        hint = "fake lever 17",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900654,
        event_id = 30654,
        source_object_index = 654,
        source_class = "Door",
        source_name = "fake lever 18",
        kind = "linear_door",
        hint = "fake lever 18",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900655,
        event_id = 30655,
        source_object_index = 655,
        source_class = "Door",
        source_name = "fake lever 19",
        kind = "linear_door",
        hint = "fake lever 19",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900656,
        event_id = 30656,
        source_object_index = 656,
        source_class = "Door",
        source_name = "fake lever 20",
        kind = "linear_door",
        hint = "fake lever 20",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
        },
    },
    {
        mechanism_id = 900657,
        event_id = 30657,
        source_object_index = 657,
        source_class = "Door",
        source_name = "fake lever 21",
        kind = "linear_door",
        hint = "fake lever 21",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideclosed.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 778,
                y = 2836,
                z = 809,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 778,
                y = 2836,
                z = 809,
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
    [30002] = { kind = "open_door", source = "mm9_mechanism", targetName = "Blade" },
    [30003] = { kind = "open_door", source = "mm9_mechanism", targetName = "Sliding Panels" },
    [30011] = { kind = "open_door", source = "mm9_mechanism", targetName = "Side Door" },
    [30012] = { kind = "open_door", source = "mm9_mechanism", targetName = "Top Door" },
    [30013] = { kind = "open_door", source = "mm9_mechanism", targetName = "Bottom Door" },
    [30014] = { kind = "open_door", source = "mm9_mechanism", targetName = "Axe Mover" },
    [30015] = { kind = "open_door", source = "mm9_mechanism", targetName = "Panel Mover" },
    [30016] = { kind = "open_door", source = "mm9_mechanism", targetName = "Bottom Axe" },
    [30017] = { kind = "open_door", source = "mm9_mechanism", targetName = "Top Axe" },
    [30018] = { kind = "open_door", source = "mm9_mechanism", targetName = "doubleaxe upper trigger" },
    [30019] = { kind = "open_door", source = "mm9_mechanism", targetName = "doubleaxe lower trigger" },
    [30022] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe door 10" },
    [30023] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe trap 10" },
    [30024] = { kind = "open_door", source = "mm9_mechanism", targetName = "timer lever 10" },
    [30027] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe door 09" },
    [30028] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe trap 09" },
    [30029] = { kind = "open_door", source = "mm9_mechanism", targetName = "timer lever 09" },
    [30032] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe door 08" },
    [30033] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe trap 08" },
    [30034] = { kind = "open_door", source = "mm9_mechanism", targetName = "timer lever 08" },
    [30037] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe door 06" },
    [30038] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe trap 06" },
    [30039] = { kind = "open_door", source = "mm9_mechanism", targetName = "timer lever 06" },
    [30042] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe door 05" },
    [30043] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe trap 05" },
    [30044] = { kind = "open_door", source = "mm9_mechanism", targetName = "timer lever 05" },
    [30047] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe door 04" },
    [30048] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe trap 04" },
    [30049] = { kind = "open_door", source = "mm9_mechanism", targetName = "timer lever 04" },
    [30052] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe door 03" },
    [30053] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe trap 03" },
    [30054] = { kind = "open_door", source = "mm9_mechanism", targetName = "timer lever 03" },
    [30055] = { kind = "open_door", source = "mm9_mechanism", targetName = "timer lever 03a" },
    [30058] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe door 02" },
    [30059] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe trap 02" },
    [30060] = { kind = "open_door", source = "mm9_mechanism", targetName = "timer lever 02" },
    [30063] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe door 01" },
    [30064] = { kind = "open_door", source = "mm9_mechanism", targetName = "axe trap 01" },
    [30065] = { kind = "open_door", source = "mm9_mechanism", targetName = "timer lever 01" },
    [30068] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor01" },
    [30069] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor02" },
    [30070] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor03" },
    [30071] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor04" },
    [30072] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor05" },
    [30073] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor06" },
    [30074] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor07" },
    [30075] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor08" },
    [30076] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor09" },
    [30077] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor10" },
    [30078] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor11" },
    [30079] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor12" },
    [30080] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor13" },
    [30081] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor14" },
    [30082] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor15" },
    [30083] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor16" },
    [30084] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor17" },
    [30085] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor18" },
    [30086] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor19" },
    [30087] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor20" },
    [30088] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor22" },
    [30089] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor21" },
    [30090] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor23" },
    [30091] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor24" },
    [30092] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor25" },
    [30093] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor26" },
    [30094] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor27" },
    [30095] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor28" },
    [30096] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor29" },
    [30097] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor30" },
    [30098] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor31" },
    [30099] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor32" },
    [30100] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor33" },
    [30101] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor34" },
    [30102] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor35" },
    [30103] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor36" },
    [30104] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor37" },
    [30105] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor38" },
    [30106] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor39" },
    [30107] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor40" },
    [30108] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor41" },
    [30109] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor42" },
    [30110] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor43" },
    [30111] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor44" },
    [30112] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor45" },
    [30113] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor46" },
    [30114] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor47" },
    [30115] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor48" },
    [30116] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor49" },
    [30117] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor50" },
    [30118] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor51" },
    [30119] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor52" },
    [30120] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor53" },
    [30121] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor54" },
    [30122] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor55" },
    [30123] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor56" },
    [30124] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor57" },
    [30125] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor58" },
    [30126] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor59" },
    [30127] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor60" },
    [30128] = { kind = "open_door", source = "mm9_mechanism", targetName = "floor61" },
    [30281] = { kind = "open_door", source = "mm9_mechanism", targetName = "gplate2" },
    [30282] = { kind = "open_door", source = "mm9_mechanism", targetName = "gplate3" },
    [30283] = { kind = "open_door", source = "mm9_mechanism", targetName = "gplate4" },
    [30284] = { kind = "open_door", source = "mm9_mechanism", targetName = "gplate5" },
    [30285] = { kind = "open_door", source = "mm9_mechanism", targetName = "gplate6" },
    [30286] = { kind = "open_door", source = "mm9_mechanism", targetName = "gplate7" },
    [30287] = { kind = "open_door", source = "mm9_mechanism", targetName = "gplate8" },
    [30288] = { kind = "open_door", source = "mm9_mechanism", targetName = "gplate9" },
    [30289] = { kind = "open_door", source = "mm9_mechanism", targetName = "gplate1" },
    [30290] = { kind = "open_door", source = "mm9_mechanism", targetName = "gplate10" },
    [30303] = { kind = "open_door", source = "mm9_mechanism", targetName = "gtrap1" },
    [30304] = { kind = "open_door", source = "mm9_mechanism", targetName = "gtrap2" },
    [30305] = { kind = "open_door", source = "mm9_mechanism", targetName = "gtrap3" },
    [30306] = { kind = "open_door", source = "mm9_mechanism", targetName = "gtrap4" },
    [30307] = { kind = "open_door", source = "mm9_mechanism", targetName = "gtrap7a" },
    [30308] = { kind = "open_door", source = "mm9_mechanism", targetName = "gtrap7b" },
    [30311] = { kind = "open_door", source = "mm9_mechanism", targetName = "gtrap8b" },
    [30312] = { kind = "generic_event", source = "mm9_mechanism", targetName = "saw8b" },
    [30313] = { kind = "open_door", source = "mm9_mechanism", targetName = "gtrap8a" },
    [30314] = { kind = "generic_event", source = "mm9_mechanism", targetName = "saw8a" },
    [30316] = { kind = "open_door", source = "mm9_mechanism", targetName = "gtrap9" },
    [30317] = { kind = "generic_event", source = "mm9_mechanism", targetName = "saw9" },
    [30318] = { kind = "open_door", source = "mm9_mechanism", targetName = "gtrap5" },
    [30319] = { kind = "open_door", source = "mm9_mechanism", targetName = "gtrap10" },
    [30320] = { kind = "open_door", source = "mm9_mechanism", targetName = "gtrap6" },
    [30347] = { kind = "open_door", source = "mm9_mechanism", targetName = "entrance gate" },
    [30348] = { kind = "open_door", source = "mm9_mechanism", targetName = "entrance button" },
    [30349] = { kind = "open_door", source = "mm9_mechanism", targetName = "exit gate" },
    [30578] = { kind = "open_door", source = "mm9_mechanism", targetName = "water grate" },
    [30580] = { kind = "open_door", source = "mm9_mechanism", targetName = "water grate opener" },
    [30581] = { kind = "open_door", source = "mm9_mechanism", targetName = "elevator" },
    [30634] = { kind = "open_door", source = "mm9_mechanism", targetName = "ratdoortrigger" },
    [30637] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 1" },
    [30638] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 2" },
    [30639] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 3" },
    [30640] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 4" },
    [30641] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 5" },
    [30642] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 6" },
    [30643] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 7" },
    [30644] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 8" },
    [30645] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 9" },
    [30646] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 10" },
    [30647] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 11" },
    [30648] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 12" },
    [30649] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 13" },
    [30650] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 14" },
    [30651] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 15" },
    [30652] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 16" },
    [30653] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 17" },
    [30654] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 18" },
    [30655] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 19" },
    [30656] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 20" },
    [30657] = { kind = "open_door", source = "mm9_mechanism", targetName = "fake lever 21" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30002, "Blade", function()
    map.triggerMechanism(2, 2)
end, "Blade")

RegisterEvent(30003, "Sliding Panels", function()
    map.triggerMechanism(3, 2)
end, "Sliding Panels")

RegisterEvent(30011, "Side Door", function()
    map.triggerMechanism(11, 2)
end, "Side Door")

RegisterEvent(30012, "Top Door", function()
    map.triggerMechanism(12, 2)
end, "Top Door")

RegisterEvent(30013, "Bottom Door", function()
    map.triggerMechanism(13, 2)
end, "Bottom Door")

RegisterEvent(30014, "Axe Mover", function()
    map.triggerMechanism(14, 2)
end, "Axe Mover")

RegisterEvent(30015, "Panel Mover", function()
    map.triggerMechanism(15, 2)
end, "Panel Mover")

RegisterEvent(30016, "Bottom Axe", function()
    map.triggerMechanism(16, 2)
end, "Bottom Axe")

RegisterEvent(30017, "Top Axe", function()
    map.triggerMechanism(17, 2)
end, "Top Axe")

RegisterEvent(30018, "doubleaxe upper trigger", function()
    map.triggerMechanism(18, 2)
end, "doubleaxe upper trigger")

RegisterEvent(30019, "doubleaxe lower trigger", function()
    map.triggerMechanism(19, 2)
end, "doubleaxe lower trigger")

RegisterEvent(30022, "axe door 10", function()
    map.triggerMechanism(22, 2)
end, "axe door 10")

RegisterEvent(30023, "axe trap 10", function()
    map.triggerMechanism(23, 2)
end, "axe trap 10")

RegisterEvent(30024, "timer lever 10", function()
    map.triggerMechanism(24, 2)
end, "timer lever 10")

RegisterEvent(30027, "axe door 09", function()
    map.triggerMechanism(27, 2)
end, "axe door 09")

RegisterEvent(30028, "axe trap 09", function()
    map.triggerMechanism(28, 2)
end, "axe trap 09")

RegisterEvent(30029, "timer lever 09", function()
    map.triggerMechanism(29, 2)
end, "timer lever 09")

RegisterEvent(30032, "axe door 08", function()
    map.triggerMechanism(32, 2)
end, "axe door 08")

RegisterEvent(30033, "axe trap 08", function()
    map.triggerMechanism(33, 2)
end, "axe trap 08")

RegisterEvent(30034, "timer lever 08", function()
    map.triggerMechanism(34, 2)
end, "timer lever 08")

RegisterEvent(30037, "axe door 06", function()
    map.triggerMechanism(37, 2)
end, "axe door 06")

RegisterEvent(30038, "axe trap 06", function()
    map.triggerMechanism(38, 2)
end, "axe trap 06")

RegisterEvent(30039, "timer lever 06", function()
    map.triggerMechanism(39, 2)
end, "timer lever 06")

RegisterEvent(30042, "axe door 05", function()
    map.triggerMechanism(42, 2)
end, "axe door 05")

RegisterEvent(30043, "axe trap 05", function()
    map.triggerMechanism(43, 2)
end, "axe trap 05")

RegisterEvent(30044, "timer lever 05", function()
    map.triggerMechanism(44, 2)
end, "timer lever 05")

RegisterEvent(30047, "axe door 04", function()
    map.triggerMechanism(47, 2)
end, "axe door 04")

RegisterEvent(30048, "axe trap 04", function()
    map.triggerMechanism(48, 2)
end, "axe trap 04")

RegisterEvent(30049, "timer lever 04", function()
    map.triggerMechanism(49, 2)
end, "timer lever 04")

RegisterEvent(30052, "axe door 03", function()
    map.triggerMechanism(52, 2)
end, "axe door 03")

RegisterEvent(30053, "axe trap 03", function()
    map.triggerMechanism(53, 2)
end, "axe trap 03")

RegisterEvent(30054, "timer lever 03", function()
    map.triggerMechanism(54, 2)
end, "timer lever 03")

RegisterEvent(30055, "timer lever 03a", function()
    map.triggerMechanism(55, 2)
end, "timer lever 03a")

RegisterEvent(30058, "axe door 02", function()
    map.triggerMechanism(58, 2)
end, "axe door 02")

RegisterEvent(30059, "axe trap 02", function()
    map.triggerMechanism(59, 2)
end, "axe trap 02")

RegisterEvent(30060, "timer lever 02", function()
    map.triggerMechanism(60, 2)
end, "timer lever 02")

RegisterEvent(30063, "axe door 01", function()
    map.triggerMechanism(63, 2)
end, "axe door 01")

RegisterEvent(30064, "axe trap 01", function()
    map.triggerMechanism(64, 2)
end, "axe trap 01")

RegisterEvent(30065, "timer lever 01", function()
    map.triggerMechanism(65, 2)
end, "timer lever 01")

RegisterEvent(30068, "floor01", function()
    map.triggerMechanism(68, 2)
end, "floor01")

RegisterEvent(30069, "floor02", function()
    map.triggerMechanism(69, 2)
end, "floor02")

RegisterEvent(30070, "floor03", function()
    map.triggerMechanism(70, 2)
end, "floor03")

RegisterEvent(30071, "floor04", function()
    map.triggerMechanism(71, 2)
end, "floor04")

RegisterEvent(30072, "floor05", function()
    map.triggerMechanism(72, 2)
end, "floor05")

RegisterEvent(30073, "floor06", function()
    map.triggerMechanism(73, 2)
end, "floor06")

RegisterEvent(30074, "floor07", function()
    map.triggerMechanism(74, 2)
end, "floor07")

RegisterEvent(30075, "floor08", function()
    map.triggerMechanism(75, 2)
end, "floor08")

RegisterEvent(30076, "floor09", function()
    map.triggerMechanism(76, 2)
end, "floor09")

RegisterEvent(30077, "floor10", function()
    map.triggerMechanism(77, 2)
end, "floor10")

RegisterEvent(30078, "floor11", function()
    map.triggerMechanism(78, 2)
end, "floor11")

RegisterEvent(30079, "floor12", function()
    map.triggerMechanism(79, 2)
end, "floor12")

RegisterEvent(30080, "floor13", function()
    map.triggerMechanism(80, 2)
end, "floor13")

RegisterEvent(30081, "floor14", function()
    map.triggerMechanism(81, 2)
end, "floor14")

RegisterEvent(30082, "floor15", function()
    map.triggerMechanism(82, 2)
end, "floor15")

RegisterEvent(30083, "floor16", function()
    map.triggerMechanism(83, 2)
end, "floor16")

RegisterEvent(30084, "floor17", function()
    map.triggerMechanism(84, 2)
end, "floor17")

RegisterEvent(30085, "floor18", function()
    map.triggerMechanism(85, 2)
end, "floor18")

RegisterEvent(30086, "floor19", function()
    map.triggerMechanism(86, 2)
end, "floor19")

RegisterEvent(30087, "floor20", function()
    map.triggerMechanism(87, 2)
end, "floor20")

RegisterEvent(30088, "floor22", function()
    map.triggerMechanism(88, 2)
end, "floor22")

RegisterEvent(30089, "floor21", function()
    map.triggerMechanism(89, 2)
end, "floor21")

RegisterEvent(30090, "floor23", function()
    map.triggerMechanism(90, 2)
end, "floor23")

RegisterEvent(30091, "floor24", function()
    map.triggerMechanism(91, 2)
end, "floor24")

RegisterEvent(30092, "floor25", function()
    map.triggerMechanism(92, 2)
end, "floor25")

RegisterEvent(30093, "floor26", function()
    map.triggerMechanism(93, 2)
end, "floor26")

RegisterEvent(30094, "floor27", function()
    map.triggerMechanism(94, 2)
end, "floor27")

RegisterEvent(30095, "floor28", function()
    map.triggerMechanism(95, 2)
end, "floor28")

RegisterEvent(30096, "floor29", function()
    map.triggerMechanism(96, 2)
end, "floor29")

RegisterEvent(30097, "floor30", function()
    map.triggerMechanism(97, 2)
end, "floor30")

RegisterEvent(30098, "floor31", function()
    map.triggerMechanism(98, 2)
end, "floor31")

RegisterEvent(30099, "floor32", function()
    map.triggerMechanism(99, 2)
end, "floor32")

RegisterEvent(30100, "floor33", function()
    map.triggerMechanism(100, 2)
end, "floor33")

RegisterEvent(30101, "floor34", function()
    map.triggerMechanism(101, 2)
end, "floor34")

RegisterEvent(30102, "floor35", function()
    map.triggerMechanism(102, 2)
end, "floor35")

RegisterEvent(30103, "floor36", function()
    map.triggerMechanism(103, 2)
end, "floor36")

RegisterEvent(30104, "floor37", function()
    map.triggerMechanism(104, 2)
end, "floor37")

RegisterEvent(30105, "floor38", function()
    map.triggerMechanism(105, 2)
end, "floor38")

RegisterEvent(30106, "floor39", function()
    map.triggerMechanism(106, 2)
end, "floor39")

RegisterEvent(30107, "floor40", function()
    map.triggerMechanism(107, 2)
end, "floor40")

RegisterEvent(30108, "floor41", function()
    map.triggerMechanism(108, 2)
end, "floor41")

RegisterEvent(30109, "floor42", function()
    map.triggerMechanism(109, 2)
end, "floor42")

RegisterEvent(30110, "floor43", function()
    map.triggerMechanism(110, 2)
end, "floor43")

RegisterEvent(30111, "floor44", function()
    map.triggerMechanism(111, 2)
end, "floor44")

RegisterEvent(30112, "floor45", function()
    map.triggerMechanism(112, 2)
end, "floor45")

RegisterEvent(30113, "floor46", function()
    map.triggerMechanism(113, 2)
end, "floor46")

RegisterEvent(30114, "floor47", function()
    map.triggerMechanism(114, 2)
end, "floor47")

RegisterEvent(30115, "floor48", function()
    map.triggerMechanism(115, 2)
end, "floor48")

RegisterEvent(30116, "floor49", function()
    map.triggerMechanism(116, 2)
end, "floor49")

RegisterEvent(30117, "floor50", function()
    map.triggerMechanism(117, 2)
end, "floor50")

RegisterEvent(30118, "floor51", function()
    map.triggerMechanism(118, 2)
end, "floor51")

RegisterEvent(30119, "floor52", function()
    map.triggerMechanism(119, 2)
end, "floor52")

RegisterEvent(30120, "floor53", function()
    map.triggerMechanism(120, 2)
end, "floor53")

RegisterEvent(30121, "floor54", function()
    map.triggerMechanism(121, 2)
end, "floor54")

RegisterEvent(30122, "floor55", function()
    map.triggerMechanism(122, 2)
end, "floor55")

RegisterEvent(30123, "floor56", function()
    map.triggerMechanism(123, 2)
end, "floor56")

RegisterEvent(30124, "floor57", function()
    map.triggerMechanism(124, 2)
end, "floor57")

RegisterEvent(30125, "floor58", function()
    map.triggerMechanism(125, 2)
end, "floor58")

RegisterEvent(30126, "floor59", function()
    map.triggerMechanism(126, 2)
end, "floor59")

RegisterEvent(30127, "floor60", function()
    map.triggerMechanism(127, 2)
end, "floor60")

RegisterEvent(30128, "floor61", function()
    map.triggerMechanism(128, 2)
end, "floor61")

RegisterEvent(30281, "gplate2", function()
    map.triggerMechanism(281, 2)
end, "gplate2")

RegisterEvent(30282, "gplate3", function()
    map.triggerMechanism(282, 2)
end, "gplate3")

RegisterEvent(30283, "gplate4", function()
    map.triggerMechanism(283, 2)
end, "gplate4")

RegisterEvent(30284, "gplate5", function()
    map.triggerMechanism(284, 2)
end, "gplate5")

RegisterEvent(30285, "gplate6", function()
    map.triggerMechanism(285, 2)
end, "gplate6")

RegisterEvent(30286, "gplate7", function()
    map.triggerMechanism(286, 2)
end, "gplate7")

RegisterEvent(30287, "gplate8", function()
    map.triggerMechanism(287, 2)
end, "gplate8")

RegisterEvent(30288, "gplate9", function()
    map.triggerMechanism(288, 2)
end, "gplate9")

RegisterEvent(30289, "gplate1", function()
    map.triggerMechanism(289, 2)
end, "gplate1")

RegisterEvent(30290, "gplate10", function()
    map.triggerMechanism(290, 2)
end, "gplate10")

RegisterEvent(30303, "gtrap1", function()
    map.triggerMechanism(303, 2)
end, "gtrap1")

RegisterEvent(30304, "gtrap2", function()
    map.triggerMechanism(304, 2)
end, "gtrap2")

RegisterEvent(30305, "gtrap3", function()
    map.triggerMechanism(305, 2)
end, "gtrap3")

RegisterEvent(30306, "gtrap4", function()
    map.triggerMechanism(306, 2)
end, "gtrap4")

RegisterEvent(30307, "gtrap7a", function()
    map.triggerMechanism(307, 2)
end, "gtrap7a")

RegisterEvent(30308, "gtrap7b", function()
    map.triggerMechanism(308, 2)
end, "gtrap7b")

RegisterEvent(30311, "gtrap8b", function()
    map.triggerMechanism(311, 2)
end, "gtrap8b")

RegisterEvent(30312, "saw8b", function()
    map.triggerMechanism(312, 2)
end, "saw8b")

RegisterEvent(30313, "gtrap8a", function()
    map.triggerMechanism(313, 2)
end, "gtrap8a")

RegisterEvent(30314, "saw8a", function()
    map.triggerMechanism(314, 2)
end, "saw8a")

RegisterEvent(30316, "gtrap9", function()
    map.triggerMechanism(316, 2)
end, "gtrap9")

RegisterEvent(30317, "saw9", function()
    map.triggerMechanism(317, 2)
end, "saw9")

RegisterEvent(30318, "gtrap5", function()
    map.triggerMechanism(318, 2)
end, "gtrap5")

RegisterEvent(30319, "gtrap10", function()
    map.triggerMechanism(319, 2)
end, "gtrap10")

RegisterEvent(30320, "gtrap6", function()
    map.triggerMechanism(320, 2)
end, "gtrap6")

RegisterEvent(30347, "entrance gate", function()
    map.triggerMechanism(347, 2)
end, "entrance gate")

RegisterEvent(30348, "entrance button", function()
    map.triggerMechanism(348, 2)
end, "entrance button")

RegisterEvent(30349, "exit gate", function()
    map.triggerMechanism(349, 2)
end, "exit gate")

RegisterEvent(30578, "water grate", function()
    map.triggerMechanism(578, 2)
end, "water grate")

RegisterEvent(30580, "water grate opener", function()
    map.triggerMechanism(580, 2)
end, "water grate opener")

RegisterEvent(30581, "elevator", function()
    map.triggerMechanism(581, 2)
end, "elevator")

RegisterEvent(30634, "ratdoortrigger", function()
    map.triggerMechanism(634, 2)
end, "ratdoortrigger")

RegisterEvent(30637, "fake lever 1", function()
    map.triggerMechanism(637, 2)
end, "fake lever 1")

RegisterEvent(30638, "fake lever 2", function()
    map.triggerMechanism(638, 2)
end, "fake lever 2")

RegisterEvent(30639, "fake lever 3", function()
    map.triggerMechanism(639, 2)
end, "fake lever 3")

RegisterEvent(30640, "fake lever 4", function()
    map.triggerMechanism(640, 2)
end, "fake lever 4")

RegisterEvent(30641, "fake lever 5", function()
    map.triggerMechanism(641, 2)
end, "fake lever 5")

RegisterEvent(30642, "fake lever 6", function()
    map.triggerMechanism(642, 2)
end, "fake lever 6")

RegisterEvent(30643, "fake lever 7", function()
    map.triggerMechanism(643, 2)
end, "fake lever 7")

RegisterEvent(30644, "fake lever 8", function()
    map.triggerMechanism(644, 2)
end, "fake lever 8")

RegisterEvent(30645, "fake lever 9", function()
    map.triggerMechanism(645, 2)
end, "fake lever 9")

RegisterEvent(30646, "fake lever 10", function()
    map.triggerMechanism(646, 2)
end, "fake lever 10")

RegisterEvent(30647, "fake lever 11", function()
    map.triggerMechanism(647, 2)
end, "fake lever 11")

RegisterEvent(30648, "fake lever 12", function()
    map.triggerMechanism(648, 2)
end, "fake lever 12")

RegisterEvent(30649, "fake lever 13", function()
    map.triggerMechanism(649, 2)
end, "fake lever 13")

RegisterEvent(30650, "fake lever 14", function()
    map.triggerMechanism(650, 2)
end, "fake lever 14")

RegisterEvent(30651, "fake lever 15", function()
    map.triggerMechanism(651, 2)
end, "fake lever 15")

RegisterEvent(30652, "fake lever 16", function()
    map.triggerMechanism(652, 2)
end, "fake lever 16")

RegisterEvent(30653, "fake lever 17", function()
    map.triggerMechanism(653, 2)
end, "fake lever 17")

RegisterEvent(30654, "fake lever 18", function()
    map.triggerMechanism(654, 2)
end, "fake lever 18")

RegisterEvent(30655, "fake lever 19", function()
    map.triggerMechanism(655, 2)
end, "fake lever 19")

RegisterEvent(30656, "fake lever 20", function()
    map.triggerMechanism(656, 2)
end, "fake lever 20")

RegisterEvent(30657, "fake lever 21", function()
    map.triggerMechanism(657, 2)
end, "fake lever 21")

map.scripts["npc417.scr"] = {
    source = "NPC417.scr",
    registered_triggers = {
        { line = 99, message = "Use", callback = "OnUse" },
        { line = 100, message = "DoTrap", callback = "OnTrap" },
        { line = 101, message = "RemoveTrap", callback = "OnRemove" },
        { line = 102, message = "done", callback = "OnFinish" },
        { line = 112, message = "Use", callback = "OnUse" },
        { line = 113, message = "DoTrap", callback = "OnTrap" },
        { line = 114, message = "RemoveTrap", callback = "OnRemove" },
        { line = 115, message = "done", callback = "OnFinish" },
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
