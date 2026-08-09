-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "tasaracademy"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 317,
        source_name = "StartPoint0",
        x = 2621,
        y = 655,
        z = 184,
        direction_yaw_units = 1023,
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
        source_name = "LibraryDoor",
        kind = "rotating_door",
        hint = "LibraryDoor",
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
        mechanism_id = 900389,
        event_id = 30389,
        source_object_index = 389,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900390,
        event_id = 30390,
        source_object_index = 390,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900598,
        event_id = 30598,
        source_object_index = 598,
        source_class = "Door",
        source_name = "SecretDoor1",
        kind = "linear_door",
        hint = "SecretDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
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
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
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
        mechanism_id = 900599,
        event_id = 30599,
        source_object_index = 599,
        source_class = "DestructableBrush",
        source_name = "door crack",
        kind = "destructible_brush",
        hint = "door crack",
    },
    {
        mechanism_id = 900600,
        event_id = 30600,
        source_object_index = 600,
        source_class = "DestructableBrush",
        source_name = "door crack 2",
        kind = "destructible_brush",
        hint = "door crack 2",
    },
    {
        mechanism_id = 900601,
        event_id = 30601,
        source_object_index = 601,
        source_class = "Door",
        source_name = "SecretDoor0",
        kind = "linear_door",
        hint = "SecretDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
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
            ["close_start"] = {
                name = "Door/doorslideclosed.wav",
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
        mechanism_id = 900602,
        event_id = 30602,
        source_object_index = 602,
        source_class = "Door",
        source_name = "DoubleDoorL11",
        kind = "linear_door",
        hint = "DoubleDoorL11",
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
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900603,
        event_id = 30603,
        source_object_index = 603,
        source_class = "Door",
        source_name = "DoubleDoorR11",
        kind = "linear_door",
        hint = "DoubleDoorR11",
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
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900604,
        event_id = 30604,
        source_object_index = 604,
        source_class = "Door",
        source_name = "Door32",
        kind = "linear_door",
        hint = "Door32",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900605,
        event_id = 30605,
        source_object_index = 605,
        source_class = "Door",
        source_name = "Door33",
        kind = "linear_door",
        hint = "Door33",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900606,
        event_id = 30606,
        source_object_index = 606,
        source_class = "Door",
        source_name = "Door30",
        kind = "linear_door",
        hint = "Door30",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900607,
        event_id = 30607,
        source_object_index = 607,
        source_class = "Door",
        source_name = "Door31",
        kind = "linear_door",
        hint = "Door31",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900608,
        event_id = 30608,
        source_object_index = 608,
        source_class = "Door",
        source_name = "Door28",
        kind = "linear_door",
        hint = "Door28",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        source_class = "Door",
        source_name = "Door29",
        kind = "linear_door",
        hint = "Door29",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900610,
        event_id = 30610,
        source_object_index = 610,
        source_class = "Door",
        source_name = "Door26",
        kind = "linear_door",
        hint = "Door26",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900611,
        event_id = 30611,
        source_object_index = 611,
        source_class = "Door",
        source_name = "Door27",
        kind = "linear_door",
        hint = "Door27",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900612,
        event_id = 30612,
        source_object_index = 612,
        source_class = "Door",
        source_name = "Door24",
        kind = "linear_door",
        hint = "Door24",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900613,
        event_id = 30613,
        source_object_index = 613,
        source_class = "Door",
        source_name = "Door25",
        kind = "linear_door",
        hint = "Door25",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900614,
        event_id = 30614,
        source_object_index = 614,
        source_class = "Door",
        source_name = "Door22",
        kind = "linear_door",
        hint = "Door22",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900615,
        event_id = 30615,
        source_object_index = 615,
        source_class = "Door",
        source_name = "Door23",
        kind = "linear_door",
        hint = "Door23",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900616,
        event_id = 30616,
        source_object_index = 616,
        source_class = "Door",
        source_name = "Door20",
        kind = "linear_door",
        hint = "Door20",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900617,
        event_id = 30617,
        source_object_index = 617,
        source_class = "Door",
        source_name = "Door21",
        kind = "linear_door",
        hint = "Door21",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900618,
        event_id = 30618,
        source_object_index = 618,
        source_class = "Door",
        source_name = "Door18",
        kind = "linear_door",
        hint = "Door18",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900619,
        event_id = 30619,
        source_object_index = 619,
        source_class = "Door",
        source_name = "Door19",
        kind = "linear_door",
        hint = "Door19",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900620,
        event_id = 30620,
        source_object_index = 620,
        source_class = "Door",
        source_name = "Door16",
        kind = "linear_door",
        hint = "Door16",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900621,
        event_id = 30621,
        source_object_index = 621,
        source_class = "Door",
        source_name = "Door17",
        kind = "linear_door",
        hint = "Door17",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900622,
        event_id = 30622,
        source_object_index = 622,
        source_class = "Door",
        source_name = "Door14",
        kind = "linear_door",
        hint = "Door14",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900623,
        event_id = 30623,
        source_object_index = 623,
        source_class = "Door",
        source_name = "Door15",
        kind = "linear_door",
        hint = "Door15",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900624,
        event_id = 30624,
        source_object_index = 624,
        source_class = "Door",
        source_name = "Door10",
        kind = "linear_door",
        hint = "Door10",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900625,
        event_id = 30625,
        source_object_index = 625,
        source_class = "Door",
        source_name = "Door13",
        kind = "linear_door",
        hint = "Door13",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900626,
        event_id = 30626,
        source_object_index = 626,
        source_class = "Door",
        source_name = "Door8",
        kind = "linear_door",
        hint = "Door8",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900627,
        event_id = 30627,
        source_object_index = 627,
        source_class = "Door",
        source_name = "Door9",
        kind = "linear_door",
        hint = "Door9",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900628,
        event_id = 30628,
        source_object_index = 628,
        source_class = "Door",
        source_name = "Door6",
        kind = "linear_door",
        hint = "Door6",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900629,
        event_id = 30629,
        source_object_index = 629,
        source_class = "Door",
        source_name = "Door7",
        kind = "linear_door",
        hint = "Door7",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900630,
        event_id = 30630,
        source_object_index = 630,
        source_class = "Door",
        source_name = "Door4",
        kind = "linear_door",
        hint = "Door4",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900631,
        event_id = 30631,
        source_object_index = 631,
        source_class = "Door",
        source_name = "Door5",
        kind = "linear_door",
        hint = "Door5",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900632,
        event_id = 30632,
        source_object_index = 632,
        source_class = "Door",
        source_name = "Door2",
        kind = "linear_door",
        hint = "Door2",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900633,
        event_id = 30633,
        source_object_index = 633,
        source_class = "Door",
        source_name = "Door3",
        kind = "linear_door",
        hint = "Door3",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900634,
        event_id = 30634,
        source_object_index = 634,
        source_class = "Door",
        source_name = "Door0",
        kind = "linear_door",
        hint = "Door0",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900635,
        event_id = 30635,
        source_object_index = 635,
        source_class = "Door",
        source_name = "Door1",
        kind = "linear_door",
        hint = "Door1",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900638,
        event_id = 30638,
        source_object_index = 638,
        source_class = "Door",
        source_name = "BookButtonFront1",
        kind = "linear_door",
        hint = "BookButtonFront1",
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
        mechanism_id = 900639,
        event_id = 30639,
        source_object_index = 639,
        source_class = "RotatingDoor",
        source_name = "RotatingBookcase1",
        kind = "rotating_door",
        hint = "RotatingBookcase1",
        sounds = {
            ["open_start"] = {
                name = "Door/DoorSlideStone.wav",
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
            ["close_start"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900640,
        event_id = 30640,
        source_object_index = 640,
        source_class = "Door",
        source_name = "BookButtonBack1",
        kind = "linear_door",
        hint = "BookButtonBack1",
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
        mechanism_id = 900642,
        event_id = 30642,
        source_object_index = 642,
        source_class = "RotatingDoor",
        source_name = "PitDoorLeft1",
        kind = "rotating_door",
        hint = "PitDoorLeft1",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900643,
        event_id = 30643,
        source_object_index = 643,
        source_class = "RotatingDoor",
        source_name = "PitDoorRight1",
        kind = "rotating_door",
        hint = "PitDoorRight1",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
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
            ["close_stop"] = {
                name = "Door/trapdoorclose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900647,
        event_id = 30647,
        source_object_index = 647,
        source_class = "Ladder",
        source_name = "Ladder0",
        kind = "ladder_volume",
        hint = "Ladder0",
    },
    {
        mechanism_id = 900648,
        event_id = 30648,
        source_object_index = 648,
        source_class = "Ladder",
        source_name = "Ladder1",
        kind = "ladder_volume",
        hint = "Ladder1",
    },
    {
        mechanism_id = 900751,
        event_id = 30751,
        source_object_index = 751,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900752,
        event_id = 30752,
        source_object_index = 752,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900753,
        event_id = 30753,
        source_object_index = 753,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900754,
        event_id = 30754,
        source_object_index = 754,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900755,
        event_id = 30755,
        source_object_index = 755,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 900806,
        event_id = 30806,
        source_object_index = 806,
        source_class = "DestructableProp",
        source_name = "DestructableProp0",
        kind = "destructible_prop",
        hint = "DestructableProp0",
    },
    {
        mechanism_id = 900823,
        event_id = 30823,
        source_object_index = 823,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
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
    [30000] = { kind = "open_door", source = "mm9_mechanism", targetName = "LibraryDoor" },
    [30598] = { kind = "open_door", source = "mm9_mechanism", targetName = "SecretDoor1" },
    [30601] = { kind = "open_door", source = "mm9_mechanism", targetName = "SecretDoor0" },
    [30602] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL11" },
    [30603] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR11" },
    [30604] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door32" },
    [30605] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door33" },
    [30606] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door30" },
    [30607] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door31" },
    [30608] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door28" },
    [30609] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door29" },
    [30610] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door26" },
    [30611] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door27" },
    [30612] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door24" },
    [30613] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door25" },
    [30614] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door22" },
    [30615] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door23" },
    [30616] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door20" },
    [30617] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door21" },
    [30618] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door18" },
    [30619] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door19" },
    [30620] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door16" },
    [30621] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door17" },
    [30622] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door14" },
    [30623] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door15" },
    [30624] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door10" },
    [30625] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door13" },
    [30626] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door8" },
    [30627] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door9" },
    [30628] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door6" },
    [30629] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door7" },
    [30630] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door4" },
    [30631] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door5" },
    [30632] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door2" },
    [30633] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door3" },
    [30634] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door0" },
    [30635] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1" },
    [30638] = { kind = "open_door", source = "mm9_mechanism", targetName = "BookButtonFront1" },
    [30639] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingBookcase1" },
    [30640] = { kind = "open_door", source = "mm9_mechanism", targetName = "BookButtonBack1" },
    [30642] = { kind = "open_door", source = "mm9_mechanism", targetName = "PitDoorLeft1" },
    [30643] = { kind = "open_door", source = "mm9_mechanism", targetName = "PitDoorRight1" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30000, "LibraryDoor", function()
    map.triggerMechanism(0, 2)
end, "LibraryDoor")

RegisterEvent(30598, "SecretDoor1", function()
    map.triggerMechanism(598, 2)
end, "SecretDoor1")

RegisterEvent(30601, "SecretDoor0", function()
    map.triggerMechanism(601, 2)
end, "SecretDoor0")

RegisterEvent(30602, "DoubleDoorL11", function()
    map.triggerMechanism(602, 2)
end, "DoubleDoorL11")

RegisterEvent(30603, "DoubleDoorR11", function()
    map.triggerMechanism(603, 2)
end, "DoubleDoorR11")

RegisterEvent(30604, "Door32", function()
    map.triggerMechanism(604, 2)
end, "Door32")

RegisterEvent(30605, "Door33", function()
    map.triggerMechanism(605, 2)
end, "Door33")

RegisterEvent(30606, "Door30", function()
    map.triggerMechanism(606, 2)
end, "Door30")

RegisterEvent(30607, "Door31", function()
    map.triggerMechanism(607, 2)
end, "Door31")

RegisterEvent(30608, "Door28", function()
    map.triggerMechanism(608, 2)
end, "Door28")

RegisterEvent(30609, "Door29", function()
    map.triggerMechanism(609, 2)
end, "Door29")

RegisterEvent(30610, "Door26", function()
    map.triggerMechanism(610, 2)
end, "Door26")

RegisterEvent(30611, "Door27", function()
    map.triggerMechanism(611, 2)
end, "Door27")

RegisterEvent(30612, "Door24", function()
    map.triggerMechanism(612, 2)
end, "Door24")

RegisterEvent(30613, "Door25", function()
    map.triggerMechanism(613, 2)
end, "Door25")

RegisterEvent(30614, "Door22", function()
    map.triggerMechanism(614, 2)
end, "Door22")

RegisterEvent(30615, "Door23", function()
    map.triggerMechanism(615, 2)
end, "Door23")

RegisterEvent(30616, "Door20", function()
    map.triggerMechanism(616, 2)
end, "Door20")

RegisterEvent(30617, "Door21", function()
    map.triggerMechanism(617, 2)
end, "Door21")

RegisterEvent(30618, "Door18", function()
    map.triggerMechanism(618, 2)
end, "Door18")

RegisterEvent(30619, "Door19", function()
    map.triggerMechanism(619, 2)
end, "Door19")

RegisterEvent(30620, "Door16", function()
    map.triggerMechanism(620, 2)
end, "Door16")

RegisterEvent(30621, "Door17", function()
    map.triggerMechanism(621, 2)
end, "Door17")

RegisterEvent(30622, "Door14", function()
    map.triggerMechanism(622, 2)
end, "Door14")

RegisterEvent(30623, "Door15", function()
    map.triggerMechanism(623, 2)
end, "Door15")

RegisterEvent(30624, "Door10", function()
    map.triggerMechanism(624, 2)
end, "Door10")

RegisterEvent(30625, "Door13", function()
    map.triggerMechanism(625, 2)
end, "Door13")

RegisterEvent(30626, "Door8", function()
    map.triggerMechanism(626, 2)
end, "Door8")

RegisterEvent(30627, "Door9", function()
    map.triggerMechanism(627, 2)
end, "Door9")

RegisterEvent(30628, "Door6", function()
    map.triggerMechanism(628, 2)
end, "Door6")

RegisterEvent(30629, "Door7", function()
    map.triggerMechanism(629, 2)
end, "Door7")

RegisterEvent(30630, "Door4", function()
    map.triggerMechanism(630, 2)
end, "Door4")

RegisterEvent(30631, "Door5", function()
    map.triggerMechanism(631, 2)
end, "Door5")

RegisterEvent(30632, "Door2", function()
    map.triggerMechanism(632, 2)
end, "Door2")

RegisterEvent(30633, "Door3", function()
    map.triggerMechanism(633, 2)
end, "Door3")

RegisterEvent(30634, "Door0", function()
    map.triggerMechanism(634, 2)
end, "Door0")

RegisterEvent(30635, "Door1", function()
    map.triggerMechanism(635, 2)
end, "Door1")

RegisterEvent(30638, "BookButtonFront1", function()
    map.triggerMechanism(638, 2)
end, "BookButtonFront1")

RegisterEvent(30639, "RotatingBookcase1", function()
    map.triggerMechanism(639, 2)
end, "RotatingBookcase1")

RegisterEvent(30640, "BookButtonBack1", function()
    map.triggerMechanism(640, 2)
end, "BookButtonBack1")

RegisterEvent(30642, "PitDoorLeft1", function()
    map.triggerMechanism(642, 2)
end, "PitDoorLeft1")

RegisterEvent(30643, "PitDoorRight1", function()
    map.triggerMechanism(643, 2)
end, "PitDoorRight1")

map.scripts["bookletter.scr"] = {
    source = "BOOKLETTER.scr",
    registered_triggers = {
        { line = 74, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["bookofrules.scr"] = {
    source = "BOOKOFRULES.scr",
    registered_triggers = {
        { line = 69, message = "Use", callback = "Onuse" },
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
map.scripts["proptrigger.scr"] = {
    source = "PROPTRIGGER.scr",
    registered_triggers = {
        { line = 64, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["skillbook.scr"] = {
    source = "SKILLBOOK.scr",
    registered_triggers = {
        { line = 195, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["tasarbook.scr"] = {
    source = "TASARBOOK.scr",
    registered_triggers = {
        { line = 138, message = "Use", callback = "OnUse" },
        { line = 153, message = "Use", callback = "OnUse" },
        { line = 154, message = "Visible1", callback = "OnVisible" },
    },
    movement_commands = {
    },
}
map.scripts["tasarchalice.scr"] = {
    source = "TASARCHALICE.scr",
    registered_triggers = {
        { line = 35, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["tasarguardduty.scr"] = {
    source = "TASARGUARDDUTY.scr",
    registered_triggers = {
        { line = 138, message = "use", callback = "OnOffDuty" },
    },
    movement_commands = {
        { line = 84, command = "Setpos", arguments = "g_hobject PosX PosY PosZ" },
        { line = 116, command = "Setpos", arguments = "g_hobject StartPosX StartPosY StartPosZ" },
    },
}
map.scripts["tasarstudent.scr"] = {
    source = "TASARSTUDENT.scr",
    registered_triggers = {
        { line = 26, message = "Hate", callback = "OnHate" },
    },
    movement_commands = {
    },
}
map.scripts["tasartable.scr"] = {
    source = "TASARTABLE.scr",
    registered_triggers = {
        { line = 164, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["tasarteacher.scr"] = {
    source = "TASARTEACHER.scr",
    registered_triggers = {
        { line = 64, message = "Fight", callback = "OnSpawn" },
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
