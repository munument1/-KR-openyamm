-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "chasmofthedead"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 232,
        source_name = "StartPoint0",
        x = -13189,
        y = 28303,
        z = 1761,
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
        mechanism_id = 900000,
        event_id = 30000,
        source_object_index = 0,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 900002,
        event_id = 30002,
        source_object_index = 2,
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
        mechanism_id = 900003,
        event_id = 30003,
        source_object_index = 3,
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
        mechanism_id = 900004,
        event_id = 30004,
        source_object_index = 4,
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
        mechanism_id = 900005,
        event_id = 30005,
        source_object_index = 5,
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
        mechanism_id = 900006,
        event_id = 30006,
        source_object_index = 6,
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
        mechanism_id = 900007,
        event_id = 30007,
        source_object_index = 7,
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
        mechanism_id = 900008,
        event_id = 30008,
        source_object_index = 8,
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
        mechanism_id = 900009,
        event_id = 30009,
        source_object_index = 9,
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
        mechanism_id = 900010,
        event_id = 30010,
        source_object_index = 10,
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
        mechanism_id = 900011,
        event_id = 30011,
        source_object_index = 11,
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
        mechanism_id = 900012,
        event_id = 30012,
        source_object_index = 12,
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
        mechanism_id = 900013,
        event_id = 30013,
        source_object_index = 13,
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
        mechanism_id = 900014,
        event_id = 30014,
        source_object_index = 14,
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
        mechanism_id = 900015,
        event_id = 30015,
        source_object_index = 15,
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
        mechanism_id = 900016,
        event_id = 30016,
        source_object_index = 16,
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
        mechanism_id = 900017,
        event_id = 30017,
        source_object_index = 17,
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
        mechanism_id = 900018,
        event_id = 30018,
        source_object_index = 18,
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
        mechanism_id = 900019,
        event_id = 30019,
        source_object_index = 19,
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
        mechanism_id = 900020,
        event_id = 30020,
        source_object_index = 20,
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
        mechanism_id = 900021,
        event_id = 30021,
        source_object_index = 21,
        source_class = "Door",
        source_name = "Door12",
        kind = "linear_door",
        hint = "Door12",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900022,
        event_id = 30022,
        source_object_index = 22,
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
        mechanism_id = 900023,
        event_id = 30023,
        source_object_index = 23,
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
        mechanism_id = 900024,
        event_id = 30024,
        source_object_index = 24,
        source_class = "Door",
        source_name = "Door11",
        kind = "linear_door",
        hint = "Door11",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900025,
        event_id = 30025,
        source_object_index = 25,
        source_class = "BlueWater",
        source_name = "BlueWater1",
        kind = "water_volume",
        hint = "BlueWater1",
    },
    {
        mechanism_id = 900026,
        event_id = 30026,
        source_object_index = 26,
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
        mechanism_id = 900027,
        event_id = 30027,
        source_object_index = 27,
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
        mechanism_id = 900028,
        event_id = 30028,
        source_object_index = 28,
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
        mechanism_id = 900029,
        event_id = 30029,
        source_object_index = 29,
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
        mechanism_id = 900030,
        event_id = 30030,
        source_object_index = 30,
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
        mechanism_id = 900031,
        event_id = 30031,
        source_object_index = 31,
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
        mechanism_id = 900032,
        event_id = 30032,
        source_object_index = 32,
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
        mechanism_id = 900243,
        event_id = 30243,
        source_object_index = 243,
        source_class = "AIBarrier",
        source_name = "AIBarrier2",
        kind = "ai_barrier",
        hint = "AIBarrier2",
    },
    {
        mechanism_id = 900244,
        event_id = 30244,
        source_object_index = 244,
        source_class = "AIBarrier",
        source_name = "AIBarrier3",
        kind = "ai_barrier",
        hint = "AIBarrier3",
    },
    {
        mechanism_id = 900245,
        event_id = 30245,
        source_object_index = 245,
        source_class = "AIBarrier",
        source_name = "AIBarrier4",
        kind = "ai_barrier",
        hint = "AIBarrier4",
    },
    {
        mechanism_id = 900246,
        event_id = 30246,
        source_object_index = 246,
        source_class = "AIBarrier",
        source_name = "AIBarrier5",
        kind = "ai_barrier",
        hint = "AIBarrier5",
    },
    {
        mechanism_id = 900247,
        event_id = 30247,
        source_object_index = 247,
        source_class = "AIBarrier",
        source_name = "AIBarrier6",
        kind = "ai_barrier",
        hint = "AIBarrier6",
    },
    {
        mechanism_id = 900248,
        event_id = 30248,
        source_object_index = 248,
        source_class = "AIBarrier",
        source_name = "AIBarrier7",
        kind = "ai_barrier",
        hint = "AIBarrier7",
    },
    {
        mechanism_id = 900249,
        event_id = 30249,
        source_object_index = 249,
        source_class = "AIBarrier",
        source_name = "AIBarrier8",
        kind = "ai_barrier",
        hint = "AIBarrier8",
    },
    {
        mechanism_id = 900250,
        event_id = 30250,
        source_object_index = 250,
        source_class = "AIBarrier",
        source_name = "AIBarrier9",
        kind = "ai_barrier",
        hint = "AIBarrier9",
    },
    {
        mechanism_id = 900251,
        event_id = 30251,
        source_object_index = 251,
        source_class = "AIBarrier",
        source_name = "AIBarrier10",
        kind = "ai_barrier",
        hint = "AIBarrier10",
    },
    {
        mechanism_id = 900252,
        event_id = 30252,
        source_object_index = 252,
        source_class = "AIBarrier",
        source_name = "AIBarrier11",
        kind = "ai_barrier",
        hint = "AIBarrier11",
    },
    {
        mechanism_id = 900278,
        event_id = 30278,
        source_object_index = 278,
        source_class = "AIBarrier",
        source_name = "AIBarrier14",
        kind = "ai_barrier",
        hint = "AIBarrier14",
    },
    {
        mechanism_id = 900279,
        event_id = 30279,
        source_object_index = 279,
        source_class = "AIBarrier",
        source_name = "AIBarrier15",
        kind = "ai_barrier",
        hint = "AIBarrier15",
    },
    {
        mechanism_id = 900287,
        event_id = 30287,
        source_object_index = 287,
        source_class = "AIBarrier",
        source_name = "AIBarrier16",
        kind = "ai_barrier",
        hint = "AIBarrier16",
    },
    {
        mechanism_id = 900288,
        event_id = 30288,
        source_object_index = 288,
        source_class = "AIBarrier",
        source_name = "AIBarrier17",
        kind = "ai_barrier",
        hint = "AIBarrier17",
    },
    {
        mechanism_id = 900289,
        event_id = 30289,
        source_object_index = 289,
        source_class = "AIBarrier",
        source_name = "AIBarrier18",
        kind = "ai_barrier",
        hint = "AIBarrier18",
    },
    {
        mechanism_id = 900290,
        event_id = 30290,
        source_object_index = 290,
        source_class = "AIBarrier",
        source_name = "AIBarrier19",
        kind = "ai_barrier",
        hint = "AIBarrier19",
    },
    {
        mechanism_id = 900291,
        event_id = 30291,
        source_object_index = 291,
        source_class = "AIBarrier",
        source_name = "AIBarrier20",
        kind = "ai_barrier",
        hint = "AIBarrier20",
    },
    {
        mechanism_id = 900292,
        event_id = 30292,
        source_object_index = 292,
        source_class = "AIBarrier",
        source_name = "AIBarrier22",
        kind = "ai_barrier",
        hint = "AIBarrier22",
    },
    {
        mechanism_id = 900293,
        event_id = 30293,
        source_object_index = 293,
        source_class = "AIBarrier",
        source_name = "AIBarrier23",
        kind = "ai_barrier",
        hint = "AIBarrier23",
    },
    {
        mechanism_id = 900294,
        event_id = 30294,
        source_object_index = 294,
        source_class = "AIBarrier",
        source_name = "AIBarrier24",
        kind = "ai_barrier",
        hint = "AIBarrier24",
    },
    {
        mechanism_id = 900295,
        event_id = 30295,
        source_object_index = 295,
        source_class = "AIBarrier",
        source_name = "AIBarrier25",
        kind = "ai_barrier",
        hint = "AIBarrier25",
    },
    {
        mechanism_id = 900296,
        event_id = 30296,
        source_object_index = 296,
        source_class = "AIBarrier",
        source_name = "AIBarrier26",
        kind = "ai_barrier",
        hint = "AIBarrier26",
    },
    {
        mechanism_id = 900297,
        event_id = 30297,
        source_object_index = 297,
        source_class = "AIBarrier",
        source_name = "AIBarrier27",
        kind = "ai_barrier",
        hint = "AIBarrier27",
    },
    {
        mechanism_id = 900327,
        event_id = 30327,
        source_object_index = 327,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900352,
        event_id = 30352,
        source_object_index = 352,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900353,
        event_id = 30353,
        source_object_index = 353,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 900374,
        event_id = 30374,
        source_object_index = 374,
        source_class = "AIBarrier",
        source_name = "AIBarrier12",
        kind = "ai_barrier",
        hint = "AIBarrier12",
    },
    {
        mechanism_id = 900375,
        event_id = 30375,
        source_object_index = 375,
        source_class = "AIBarrier",
        source_name = "AIBarrier13",
        kind = "ai_barrier",
        hint = "AIBarrier13",
    },
    {
        mechanism_id = 900515,
        event_id = 30515,
        source_object_index = 515,
        source_class = "AIBarrier",
        source_name = "AIBarrier21",
        kind = "ai_barrier",
        hint = "AIBarrier21",
    },
    {
        mechanism_id = 900617,
        event_id = 30617,
        source_object_index = 617,
        source_class = "AIBarrier",
        source_name = "AIBarrier28",
        kind = "ai_barrier",
        hint = "AIBarrier28",
    },
    {
        mechanism_id = 900618,
        event_id = 30618,
        source_object_index = 618,
        source_class = "AIBarrier",
        source_name = "AIBarrier29",
        kind = "ai_barrier",
        hint = "AIBarrier29",
    },
    {
        mechanism_id = 900619,
        event_id = 30619,
        source_object_index = 619,
        source_class = "AIBarrier",
        source_name = "AIBarrier30",
        kind = "ai_barrier",
        hint = "AIBarrier30",
    },
    {
        mechanism_id = 900620,
        event_id = 30620,
        source_object_index = 620,
        source_class = "AIBarrier",
        source_name = "AIBarrier31",
        kind = "ai_barrier",
        hint = "AIBarrier31",
    },
    {
        mechanism_id = 900659,
        event_id = 30659,
        source_object_index = 659,
        source_class = "AIBarrier",
        source_name = "AIBarrier32",
        kind = "ai_barrier",
        hint = "AIBarrier32",
    },
    {
        mechanism_id = 900660,
        event_id = 30660,
        source_object_index = 660,
        source_class = "AIBarrier",
        source_name = "AIBarrier33",
        kind = "ai_barrier",
        hint = "AIBarrier33",
    },
    {
        mechanism_id = 900661,
        event_id = 30661,
        source_object_index = 661,
        source_class = "AIBarrier",
        source_name = "AIBarrier34",
        kind = "ai_barrier",
        hint = "AIBarrier34",
    },
    {
        mechanism_id = 900662,
        event_id = 30662,
        source_object_index = 662,
        source_class = "AIBarrier",
        source_name = "AIBarrier35",
        kind = "ai_barrier",
        hint = "AIBarrier35",
    },
    {
        mechanism_id = 900663,
        event_id = 30663,
        source_object_index = 663,
        source_class = "AIBarrier",
        source_name = "AIBarrier36",
        kind = "ai_barrier",
        hint = "AIBarrier36",
    },
    {
        mechanism_id = 900664,
        event_id = 30664,
        source_object_index = 664,
        source_class = "AIBarrier",
        source_name = "AIBarrier37",
        kind = "ai_barrier",
        hint = "AIBarrier37",
    },
    {
        mechanism_id = 900665,
        event_id = 30665,
        source_object_index = 665,
        source_class = "AIBarrier",
        source_name = "AIBarrier38",
        kind = "ai_barrier",
        hint = "AIBarrier38",
    },
    {
        mechanism_id = 900666,
        event_id = 30666,
        source_object_index = 666,
        source_class = "AIBarrier",
        source_name = "AIBarrier39",
        kind = "ai_barrier",
        hint = "AIBarrier39",
    },
    {
        mechanism_id = 900667,
        event_id = 30667,
        source_object_index = 667,
        source_class = "AIBarrier",
        source_name = "AIBarrier40",
        kind = "ai_barrier",
        hint = "AIBarrier40",
    },
    {
        mechanism_id = 900668,
        event_id = 30668,
        source_object_index = 668,
        source_class = "AIBarrier",
        source_name = "AIBarrier41",
        kind = "ai_barrier",
        hint = "AIBarrier41",
    },
    {
        mechanism_id = 900669,
        event_id = 30669,
        source_object_index = 669,
        source_class = "AIBarrier",
        source_name = "AIBarrier42",
        kind = "ai_barrier",
        hint = "AIBarrier42",
    },
    {
        mechanism_id = 900670,
        event_id = 30670,
        source_object_index = 670,
        source_class = "AIBarrier",
        source_name = "AIBarrier43",
        kind = "ai_barrier",
        hint = "AIBarrier43",
    },
    {
        mechanism_id = 900671,
        event_id = 30671,
        source_object_index = 671,
        source_class = "AIBarrier",
        source_name = "AIBarrier44",
        kind = "ai_barrier",
        hint = "AIBarrier44",
    },
    {
        mechanism_id = 900672,
        event_id = 30672,
        source_object_index = 672,
        source_class = "AIBarrier",
        source_name = "AIBarrier45",
        kind = "ai_barrier",
        hint = "AIBarrier45",
    },
    {
        mechanism_id = 900673,
        event_id = 30673,
        source_object_index = 673,
        source_class = "AIBarrier",
        source_name = "AIBarrier46",
        kind = "ai_barrier",
        hint = "AIBarrier46",
    },
    {
        mechanism_id = 900674,
        event_id = 30674,
        source_object_index = 674,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900675,
        event_id = 30675,
        source_object_index = 675,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900976,
        event_id = 30976,
        source_object_index = 976,
        source_class = "AIBarrier",
        source_name = "AIBarrier51",
        kind = "ai_barrier",
        hint = "AIBarrier51",
    },
    {
        mechanism_id = 900977,
        event_id = 30977,
        source_object_index = 977,
        source_class = "AIBarrier",
        source_name = "AIBarrier52",
        kind = "ai_barrier",
        hint = "AIBarrier52",
    },
    {
        mechanism_id = 900978,
        event_id = 30978,
        source_object_index = 978,
        source_class = "AIBarrier",
        source_name = "AIBarrier53",
        kind = "ai_barrier",
        hint = "AIBarrier53",
    },
    {
        mechanism_id = 900979,
        event_id = 30979,
        source_object_index = 979,
        source_class = "AIBarrier",
        source_name = "AIBarrier54",
        kind = "ai_barrier",
        hint = "AIBarrier54",
    },
    {
        mechanism_id = 900980,
        event_id = 30980,
        source_object_index = 980,
        source_class = "AIBarrier",
        source_name = "AIBarrier55",
        kind = "ai_barrier",
        hint = "AIBarrier55",
    },
    {
        mechanism_id = 900981,
        event_id = 30981,
        source_object_index = 981,
        source_class = "AIBarrier",
        source_name = "AIBarrier56",
        kind = "ai_barrier",
        hint = "AIBarrier56",
    },
    {
        mechanism_id = 900982,
        event_id = 30982,
        source_object_index = 982,
        source_class = "AIBarrier",
        source_name = "AIBarrier57",
        kind = "ai_barrier",
        hint = "AIBarrier57",
    },
    {
        mechanism_id = 900983,
        event_id = 30983,
        source_object_index = 983,
        source_class = "AIBarrier",
        source_name = "AIBarrier58",
        kind = "ai_barrier",
        hint = "AIBarrier58",
    },
    {
        mechanism_id = 900984,
        event_id = 30984,
        source_object_index = 984,
        source_class = "AIBarrier",
        source_name = "AIBarrier59",
        kind = "ai_barrier",
        hint = "AIBarrier59",
    },
    {
        mechanism_id = 900985,
        event_id = 30985,
        source_object_index = 985,
        source_class = "AIBarrier",
        source_name = "AIBarrier60",
        kind = "ai_barrier",
        hint = "AIBarrier60",
    },
    {
        mechanism_id = 900986,
        event_id = 30986,
        source_object_index = 986,
        source_class = "AIBarrier",
        source_name = "AIBarrier61",
        kind = "ai_barrier",
        hint = "AIBarrier61",
    },
    {
        mechanism_id = 900987,
        event_id = 30987,
        source_object_index = 987,
        source_class = "AIBarrier",
        source_name = "AIBarrier62",
        kind = "ai_barrier",
        hint = "AIBarrier62",
    },
    {
        mechanism_id = 900988,
        event_id = 30988,
        source_object_index = 988,
        source_class = "AIBarrier",
        source_name = "AIBarrier63",
        kind = "ai_barrier",
        hint = "AIBarrier63",
    },
    {
        mechanism_id = 900989,
        event_id = 30989,
        source_object_index = 989,
        source_class = "AIBarrier",
        source_name = "AIBarrier64",
        kind = "ai_barrier",
        hint = "AIBarrier64",
    },
    {
        mechanism_id = 900990,
        event_id = 30990,
        source_object_index = 990,
        source_class = "AIBarrier",
        source_name = "AIBarrier65",
        kind = "ai_barrier",
        hint = "AIBarrier65",
    },
    {
        mechanism_id = 900991,
        event_id = 30991,
        source_object_index = 991,
        source_class = "AIBarrier",
        source_name = "AIBarrier66",
        kind = "ai_barrier",
        hint = "AIBarrier66",
    },
    {
        mechanism_id = 900992,
        event_id = 30992,
        source_object_index = 992,
        source_class = "AIBarrier",
        source_name = "AIBarrier67",
        kind = "ai_barrier",
        hint = "AIBarrier67",
    },
    {
        mechanism_id = 900993,
        event_id = 30993,
        source_object_index = 993,
        source_class = "AIBarrier",
        source_name = "AIBarrier68",
        kind = "ai_barrier",
        hint = "AIBarrier68",
    },
    {
        mechanism_id = 900994,
        event_id = 30994,
        source_object_index = 994,
        source_class = "AIBarrier",
        source_name = "AIBarrier69",
        kind = "ai_barrier",
        hint = "AIBarrier69",
    },
    {
        mechanism_id = 900995,
        event_id = 30995,
        source_object_index = 995,
        source_class = "AIBarrier",
        source_name = "AIBarrier70",
        kind = "ai_barrier",
        hint = "AIBarrier70",
    },
    {
        mechanism_id = 900996,
        event_id = 30996,
        source_object_index = 996,
        source_class = "AIBarrier",
        source_name = "AIBarrier71",
        kind = "ai_barrier",
        hint = "AIBarrier71",
    },
    {
        mechanism_id = 900997,
        event_id = 30997,
        source_object_index = 997,
        source_class = "AIBarrier",
        source_name = "AIBarrier47",
        kind = "ai_barrier",
        hint = "AIBarrier47",
    },
    {
        mechanism_id = 900998,
        event_id = 30998,
        source_object_index = 998,
        source_class = "AIBarrier",
        source_name = "AIBarrier48",
        kind = "ai_barrier",
        hint = "AIBarrier48",
    },
    {
        mechanism_id = 900999,
        event_id = 30999,
        source_object_index = 999,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 901000,
        event_id = 31000,
        source_object_index = 1000,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 901001,
        event_id = 31001,
        source_object_index = 1001,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 901002,
        event_id = 31002,
        source_object_index = 1002,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush6",
        kind = "collision_volume",
        hint = "InvisibleBrush6",
    },
    {
        mechanism_id = 901003,
        event_id = 31003,
        source_object_index = 1003,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush7",
        kind = "collision_volume",
        hint = "InvisibleBrush7",
    },
    {
        mechanism_id = 901004,
        event_id = 31004,
        source_object_index = 1004,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush8",
        kind = "collision_volume",
        hint = "InvisibleBrush8",
    },
    {
        mechanism_id = 901005,
        event_id = 31005,
        source_object_index = 1005,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush9",
        kind = "collision_volume",
        hint = "InvisibleBrush9",
    },
    {
        mechanism_id = 901006,
        event_id = 31006,
        source_object_index = 1006,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush10",
        kind = "collision_volume",
        hint = "InvisibleBrush10",
    },
    {
        mechanism_id = 901007,
        event_id = 31007,
        source_object_index = 1007,
        source_class = "AIBarrier",
        source_name = "AIBarrier49",
        kind = "ai_barrier",
        hint = "AIBarrier49",
    },
    {
        mechanism_id = 901008,
        event_id = 31008,
        source_object_index = 1008,
        source_class = "AIBarrier",
        source_name = "AIBarrier50",
        kind = "ai_barrier",
        hint = "AIBarrier50",
    },
    {
        mechanism_id = 901096,
        event_id = 31096,
        source_object_index = 1096,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush11",
        kind = "collision_volume",
        hint = "InvisibleBrush11",
    },
    {
        mechanism_id = 901101,
        event_id = 31101,
        source_object_index = 1101,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush12",
        kind = "collision_volume",
        hint = "InvisibleBrush12",
    },
    {
        mechanism_id = 901102,
        event_id = 31102,
        source_object_index = 1102,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush13",
        kind = "collision_volume",
        hint = "InvisibleBrush13",
    },
    {
        mechanism_id = 901103,
        event_id = 31103,
        source_object_index = 1103,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush14",
        kind = "collision_volume",
        hint = "InvisibleBrush14",
    },
    {
        mechanism_id = 901111,
        event_id = 31111,
        source_object_index = 1111,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush15",
        kind = "collision_volume",
        hint = "InvisibleBrush15",
    },
    {
        mechanism_id = 901112,
        event_id = 31112,
        source_object_index = 1112,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush16",
        kind = "collision_volume",
        hint = "InvisibleBrush16",
    },
    {
        mechanism_id = 901115,
        event_id = 31115,
        source_object_index = 1115,
        source_class = "Shooter",
        source_name = "CeilingShooter1",
        kind = "shooter",
        hint = "CeilingShooter1",
    },
    {
        mechanism_id = 901116,
        event_id = 31116,
        source_object_index = 1116,
        source_class = "Door",
        source_name = "ShooterPlate2",
        kind = "linear_door",
        hint = "ShooterPlate2",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901118,
        event_id = 31118,
        source_object_index = 1118,
        source_class = "Door",
        source_name = "CWR1",
        kind = "linear_door",
        hint = "CWR1",
    },
    {
        mechanism_id = 901119,
        event_id = 31119,
        source_object_index = 1119,
        source_class = "Door",
        source_name = "CWL1",
        kind = "linear_door",
        hint = "CWL1",
    },
    {
        mechanism_id = 901120,
        event_id = 31120,
        source_object_index = 1120,
        source_class = "Door",
        source_name = "CWPlate1",
        kind = "linear_door",
        hint = "CWPlate1",
    },
    {
        mechanism_id = 901122,
        event_id = 31122,
        source_object_index = 1122,
        source_class = "Door",
        source_name = "CWR2",
        kind = "linear_door",
        hint = "CWR2",
    },
    {
        mechanism_id = 901123,
        event_id = 31123,
        source_object_index = 1123,
        source_class = "Door",
        source_name = "CWL2",
        kind = "linear_door",
        hint = "CWL2",
    },
    {
        mechanism_id = 901128,
        event_id = 31128,
        source_object_index = 1128,
        source_class = "Shooter",
        source_name = "Shooter1",
        kind = "shooter",
        hint = "Shooter1",
    },
    {
        mechanism_id = 901129,
        event_id = 31129,
        source_object_index = 1129,
        source_class = "Door",
        source_name = "ShooterPlate1",
        kind = "linear_door",
        hint = "ShooterPlate1",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901131,
        event_id = 31131,
        source_object_index = 1131,
        source_class = "Door",
        source_name = "SpikeRow2",
        kind = "linear_door",
        hint = "SpikeRow2",
        sounds = {
            ["open_start"] = {
                name = "Weapons/maceswing.wav",
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
        mechanism_id = 901132,
        event_id = 31132,
        source_object_index = 1132,
        source_class = "Door",
        source_name = "SpikeRow3",
        kind = "linear_door",
        hint = "SpikeRow3",
        sounds = {
            ["open_start"] = {
                name = "Weapons/maceswing.wav",
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
        mechanism_id = 901133,
        event_id = 31133,
        source_object_index = 1133,
        source_class = "Door",
        source_name = "SpikeRow4",
        kind = "linear_door",
        hint = "SpikeRow4",
        sounds = {
            ["open_start"] = {
                name = "Weapons/maceswing.wav",
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
        mechanism_id = 901134,
        event_id = 31134,
        source_object_index = 1134,
        source_class = "Door",
        source_name = "SpikeRow5",
        kind = "linear_door",
        hint = "SpikeRow5",
        sounds = {
            ["open_start"] = {
                name = "Weapons/maceswing.wav",
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
        mechanism_id = 901135,
        event_id = 31135,
        source_object_index = 1135,
        source_class = "Door",
        source_name = "SpikeRow6",
        kind = "linear_door",
        hint = "SpikeRow6",
        sounds = {
            ["open_start"] = {
                name = "Weapons/maceswing.wav",
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
        mechanism_id = 901136,
        event_id = 31136,
        source_object_index = 1136,
        source_class = "Door",
        source_name = "SpikeRow7",
        kind = "linear_door",
        hint = "SpikeRow7",
        sounds = {
            ["open_start"] = {
                name = "Weapons/maceswing.wav",
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
        mechanism_id = 901137,
        event_id = 31137,
        source_object_index = 1137,
        source_class = "Door",
        source_name = "SpikeRow8",
        kind = "linear_door",
        hint = "SpikeRow8",
        sounds = {
            ["open_start"] = {
                name = "Weapons/maceswing.wav",
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
        mechanism_id = 901138,
        event_id = 31138,
        source_object_index = 1138,
        source_class = "Door",
        source_name = "SpikeRow9",
        kind = "linear_door",
        hint = "SpikeRow9",
        sounds = {
            ["open_start"] = {
                name = "Weapons/maceswing.wav",
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
        mechanism_id = 901139,
        event_id = 31139,
        source_object_index = 1139,
        source_class = "Door",
        source_name = "SpikeRow10",
        kind = "linear_door",
        hint = "SpikeRow10",
        sounds = {
            ["open_start"] = {
                name = "Weapons/maceswing.wav",
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
        mechanism_id = 901140,
        event_id = 31140,
        source_object_index = 1140,
        source_class = "Door",
        source_name = "SpikeRow11",
        kind = "linear_door",
        hint = "SpikeRow11",
        sounds = {
            ["open_start"] = {
                name = "Weapons/maceswing.wav",
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
        mechanism_id = 901141,
        event_id = 31141,
        source_object_index = 1141,
        source_class = "Door",
        source_name = "SpikeRow12",
        kind = "linear_door",
        hint = "SpikeRow12",
        sounds = {
            ["open_start"] = {
                name = "Weapons/maceswing.wav",
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
        mechanism_id = 901142,
        event_id = 31142,
        source_object_index = 1142,
        source_class = "Door",
        source_name = "SpikeRow13",
        kind = "linear_door",
        hint = "SpikeRow13",
        sounds = {
            ["open_start"] = {
                name = "Weapons/maceswing.wav",
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
        mechanism_id = 901143,
        event_id = 31143,
        source_object_index = 1143,
        source_class = "Door",
        source_name = "SpikeRow14",
        kind = "linear_door",
        hint = "SpikeRow14",
        sounds = {
            ["open_start"] = {
                name = "Weapons/maceswing.wav",
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
        mechanism_id = 901144,
        event_id = 31144,
        source_object_index = 1144,
        source_class = "Door",
        source_name = "SpikeRow1",
        kind = "linear_door",
        hint = "SpikeRow1",
        sounds = {
            ["open_start"] = {
                name = "Weapons/maceswing.wav",
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
        mechanism_id = 901146,
        event_id = 31146,
        source_object_index = 1146,
        source_class = "Door",
        source_name = "SpikeRowPlate1",
        kind = "linear_door",
        hint = "SpikeRowPlate1",
    },
    {
        mechanism_id = 901147,
        event_id = 31147,
        source_object_index = 1147,
        source_class = "Door",
        source_name = "ShooterPlate4",
        kind = "linear_door",
        hint = "ShooterPlate4",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901148,
        event_id = 31148,
        source_object_index = 1148,
        source_class = "Shooter",
        source_name = "CeilingShooter2",
        kind = "shooter",
        hint = "CeilingShooter2",
    },
    {
        mechanism_id = 901150,
        event_id = 31150,
        source_object_index = 1150,
        source_class = "Door",
        source_name = "HSP1",
        kind = "linear_door",
        hint = "HSP1",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901152,
        event_id = 31152,
        source_object_index = 1152,
        source_class = "Shooter",
        source_name = "HS1",
        kind = "shooter",
        hint = "HS1",
    },
    {
        mechanism_id = 901153,
        event_id = 31153,
        source_object_index = 1153,
        source_class = "RotatingDoor",
        source_name = "SDL1",
        kind = "rotating_door",
        hint = "SDL1",
    },
    {
        mechanism_id = 901154,
        event_id = 31154,
        source_object_index = 1154,
        source_class = "RotatingDoor",
        source_name = "SDU1",
        kind = "rotating_door",
        hint = "SDU1",
    },
    {
        mechanism_id = 901155,
        event_id = 31155,
        source_object_index = 1155,
        source_class = "Shooter",
        source_name = "HS2",
        kind = "shooter",
        hint = "HS2",
    },
    {
        mechanism_id = 901156,
        event_id = 31156,
        source_object_index = 1156,
        source_class = "RotatingDoor",
        source_name = "SDL2",
        kind = "rotating_door",
        hint = "SDL2",
    },
    {
        mechanism_id = 901157,
        event_id = 31157,
        source_object_index = 1157,
        source_class = "RotatingDoor",
        source_name = "SDU2",
        kind = "rotating_door",
        hint = "SDU2",
    },
    {
        mechanism_id = 901158,
        event_id = 31158,
        source_object_index = 1158,
        source_class = "Door",
        source_name = "HSP2",
        kind = "linear_door",
        hint = "HSP2",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901160,
        event_id = 31160,
        source_object_index = 1160,
        source_class = "Shooter",
        source_name = "HS3",
        kind = "shooter",
        hint = "HS3",
    },
    {
        mechanism_id = 901161,
        event_id = 31161,
        source_object_index = 1161,
        source_class = "RotatingDoor",
        source_name = "SDL3",
        kind = "rotating_door",
        hint = "SDL3",
    },
    {
        mechanism_id = 901162,
        event_id = 31162,
        source_object_index = 1162,
        source_class = "RotatingDoor",
        source_name = "SDU3",
        kind = "rotating_door",
        hint = "SDU3",
    },
    {
        mechanism_id = 901163,
        event_id = 31163,
        source_object_index = 1163,
        source_class = "Shooter",
        source_name = "HS4",
        kind = "shooter",
        hint = "HS4",
    },
    {
        mechanism_id = 901164,
        event_id = 31164,
        source_object_index = 1164,
        source_class = "RotatingDoor",
        source_name = "SDL4",
        kind = "rotating_door",
        hint = "SDL4",
    },
    {
        mechanism_id = 901165,
        event_id = 31165,
        source_object_index = 1165,
        source_class = "RotatingDoor",
        source_name = "SDU4",
        kind = "rotating_door",
        hint = "SDU4",
    },
    {
        mechanism_id = 901166,
        event_id = 31166,
        source_object_index = 1166,
        source_class = "Shooter",
        source_name = "Shooter2",
        kind = "shooter",
        hint = "Shooter2",
    },
    {
        mechanism_id = 901167,
        event_id = 31167,
        source_object_index = 1167,
        source_class = "Door",
        source_name = "ShooterPlate5",
        kind = "linear_door",
        hint = "ShooterPlate5",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901168,
        event_id = 31168,
        source_object_index = 1168,
        source_class = "Door",
        source_name = "ShooterPlate6",
        kind = "linear_door",
        hint = "ShooterPlate6",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901171,
        event_id = 31171,
        source_object_index = 1171,
        source_class = "Door",
        source_name = "ShooterPlate7",
        kind = "linear_door",
        hint = "ShooterPlate7",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901173,
        event_id = 31173,
        source_object_index = 1173,
        source_class = "Shooter",
        source_name = "Shooter3",
        kind = "shooter",
        hint = "Shooter3",
    },
    {
        mechanism_id = 901174,
        event_id = 31174,
        source_object_index = 1174,
        source_class = "Door",
        source_name = "ShooterPlate8",
        kind = "linear_door",
        hint = "ShooterPlate8",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901175,
        event_id = 31175,
        source_object_index = 1175,
        source_class = "Door",
        source_name = "ShooterPlate9",
        kind = "linear_door",
        hint = "ShooterPlate9",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901176,
        event_id = 31176,
        source_object_index = 1176,
        source_class = "Door",
        source_name = "ShooterPlate10",
        kind = "linear_door",
        hint = "ShooterPlate10",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901181,
        event_id = 31181,
        source_object_index = 1181,
        source_class = "Door",
        source_name = "CeilingCrushPlate4",
        kind = "linear_door",
        hint = "CeilingCrushPlate4",
    },
    {
        mechanism_id = 901183,
        event_id = 31183,
        source_object_index = 1183,
        source_class = "RotatingDoor",
        source_name = "PivotWallTrap1",
        kind = "rotating_door",
        hint = "PivotWallTrap1",
        sounds = {
            ["open_start"] = {
                name = "Ambient/metalcreak02.wav",
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
                name = "Ambient/metalcreak02.wav",
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
        mechanism_id = 901186,
        event_id = 31186,
        source_object_index = 1186,
        source_class = "RotatingDoor",
        source_name = "TrapExitDoor1",
        kind = "rotating_door",
        hint = "TrapExitDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/trapdooropen.wav",
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
        mechanism_id = 901187,
        event_id = 31187,
        source_object_index = 1187,
        source_class = "Ladder",
        source_name = "Ladder4",
        kind = "ladder_volume",
        hint = "Ladder4",
    },
    {
        mechanism_id = 901189,
        event_id = 31189,
        source_object_index = 1189,
        source_class = "Door",
        source_name = "PivotButton1",
        kind = "linear_door",
        hint = "PivotButton1",
        sounds = {
            ["open_stop"] = {
                name = "events/chestopeningwood.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901190,
        event_id = 31190,
        source_object_index = 1190,
        source_class = "Door",
        source_name = "PivotTreasurePanel1",
        kind = "linear_door",
        hint = "PivotTreasurePanel1",
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
        mechanism_id = 901193,
        event_id = 31193,
        source_object_index = 1193,
        source_class = "Door",
        source_name = "CeilingCrushPlate3",
        kind = "linear_door",
        hint = "CeilingCrushPlate3",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901195,
        event_id = 31195,
        source_object_index = 1195,
        source_class = "RotatingDoor",
        source_name = "PendulumWhoosh1",
        kind = "rotating_door",
        hint = "PendulumWhoosh1",
        sounds = {
            ["open_stop"] = {
                name = "events/PendulumSwing.wav",
                x = -7127,
                y = -6792,
                z = -768,
            },
            ["close_stop"] = {
                name = "events/PendulumSwingUp.wav",
                x = -7127,
                y = -6792,
                z = -768,
            },
        },
    },
    {
        mechanism_id = 901196,
        event_id = 31196,
        source_object_index = 1196,
        source_class = "RotatingDoor",
        source_name = "Pendulum1",
        kind = "rotating_door",
        hint = "Pendulum1",
    },
    {
        mechanism_id = 901198,
        event_id = 31198,
        source_object_index = 1198,
        source_class = "RotatingDoor",
        source_name = "PendulumWhoosh2",
        kind = "rotating_door",
        hint = "PendulumWhoosh2",
        sounds = {
            ["open_stop"] = {
                name = "events/PendulumSwing.wav",
                x = -7127,
                y = -6792,
                z = -768,
            },
            ["close_stop"] = {
                name = "events/PendulumSwingUp.wav",
                x = -7127,
                y = -6792,
                z = -768,
            },
        },
    },
    {
        mechanism_id = 901199,
        event_id = 31199,
        source_object_index = 1199,
        source_class = "RotatingDoor",
        source_name = "Pendulum2",
        kind = "rotating_door",
        hint = "Pendulum2",
    },
    {
        mechanism_id = 901201,
        event_id = 31201,
        source_object_index = 1201,
        source_class = "Door",
        source_name = "HSP6",
        kind = "linear_door",
        hint = "HSP6",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901203,
        event_id = 31203,
        source_object_index = 1203,
        source_class = "Shooter",
        source_name = "HS6",
        kind = "shooter",
        hint = "HS6",
    },
    {
        mechanism_id = 901204,
        event_id = 31204,
        source_object_index = 1204,
        source_class = "RotatingDoor",
        source_name = "SDL6",
        kind = "rotating_door",
        hint = "SDL6",
    },
    {
        mechanism_id = 901205,
        event_id = 31205,
        source_object_index = 1205,
        source_class = "RotatingDoor",
        source_name = "SDU6",
        kind = "rotating_door",
        hint = "SDU6",
    },
    {
        mechanism_id = 901206,
        event_id = 31206,
        source_object_index = 1206,
        source_class = "Door",
        source_name = "HSP7",
        kind = "linear_door",
        hint = "HSP7",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901208,
        event_id = 31208,
        source_object_index = 1208,
        source_class = "Shooter",
        source_name = "HS7",
        kind = "shooter",
        hint = "HS7",
    },
    {
        mechanism_id = 901209,
        event_id = 31209,
        source_object_index = 1209,
        source_class = "RotatingDoor",
        source_name = "SDL7",
        kind = "rotating_door",
        hint = "SDL7",
    },
    {
        mechanism_id = 901210,
        event_id = 31210,
        source_object_index = 1210,
        source_class = "RotatingDoor",
        source_name = "SDU7",
        kind = "rotating_door",
        hint = "SDU7",
    },
    {
        mechanism_id = 901212,
        event_id = 31212,
        source_object_index = 1212,
        source_class = "Door",
        source_name = "Gratetrap0",
        kind = "linear_door",
        hint = "Gratetrap0",
        sounds = {
            ["open_start"] = {
                name = "Door/stone_door01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/stone_door02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901214,
        event_id = 31214,
        source_object_index = 1214,
        source_class = "Door",
        source_name = "Door0",
        kind = "linear_door",
        hint = "Door0",
    },
    {
        mechanism_id = 901215,
        event_id = 31215,
        source_object_index = 1215,
        source_class = "Door",
        source_name = "ShooterPlate3",
        kind = "linear_door",
        hint = "ShooterPlate3",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901216,
        event_id = 31216,
        source_object_index = 1216,
        source_class = "Shooter",
        source_name = "CeilingShooter3",
        kind = "shooter",
        hint = "CeilingShooter3",
    },
    {
        mechanism_id = 901445,
        event_id = 31445,
        source_object_index = 1445,
        source_class = "Door",
        source_name = "Door35",
        kind = "linear_door",
        hint = "Door35",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 901446,
        event_id = 31446,
        source_object_index = 1446,
        source_class = "Door",
        source_name = "Door34",
        kind = "linear_door",
        hint = "Door34",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 901447,
        event_id = 31447,
        source_object_index = 1447,
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
        mechanism_id = 901624,
        event_id = 31624,
        source_object_index = 1624,
        source_class = "Shooter",
        source_name = "Shooter0",
        kind = "shooter",
        hint = "Shooter0",
    },
    {
        mechanism_id = 901644,
        event_id = 31644,
        source_object_index = 1644,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 901645,
        event_id = 31645,
        source_object_index = 1645,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 901646,
        event_id = 31646,
        source_object_index = 1646,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 901647,
        event_id = 31647,
        source_object_index = 1647,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 901648,
        event_id = 31648,
        source_object_index = 1648,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 901649,
        event_id = 31649,
        source_object_index = 1649,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 901650,
        event_id = 31650,
        source_object_index = 1650,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 901651,
        event_id = 31651,
        source_object_index = 1651,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush7",
        kind = "perception_brush",
        hint = "PerceptionBrush7",
    },
    {
        mechanism_id = 901652,
        event_id = 31652,
        source_object_index = 1652,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush8",
        kind = "perception_brush",
        hint = "PerceptionBrush8",
    },
    {
        mechanism_id = 901653,
        event_id = 31653,
        source_object_index = 1653,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush9",
        kind = "perception_brush",
        hint = "PerceptionBrush9",
    },
    {
        mechanism_id = 901654,
        event_id = 31654,
        source_object_index = 1654,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush10",
        kind = "perception_brush",
        hint = "PerceptionBrush10",
    },
    {
        mechanism_id = 901655,
        event_id = 31655,
        source_object_index = 1655,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush11",
        kind = "perception_brush",
        hint = "PerceptionBrush11",
    },
    {
        mechanism_id = 901656,
        event_id = 31656,
        source_object_index = 1656,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush12",
        kind = "perception_brush",
        hint = "PerceptionBrush12",
    },
    {
        mechanism_id = 901657,
        event_id = 31657,
        source_object_index = 1657,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush13",
        kind = "perception_brush",
        hint = "PerceptionBrush13",
    },
    {
        mechanism_id = 901658,
        event_id = 31658,
        source_object_index = 1658,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush14",
        kind = "perception_brush",
        hint = "PerceptionBrush14",
    },
    {
        mechanism_id = 901659,
        event_id = 31659,
        source_object_index = 1659,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush15",
        kind = "perception_brush",
        hint = "PerceptionBrush15",
    },
    {
        mechanism_id = 901660,
        event_id = 31660,
        source_object_index = 1660,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush16",
        kind = "perception_brush",
        hint = "PerceptionBrush16",
    },
    {
        mechanism_id = 901663,
        event_id = 31663,
        source_object_index = 1663,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush17",
        kind = "perception_brush",
        hint = "PerceptionBrush17",
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
    [30002] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door32" },
    [30003] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door31" },
    [30004] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door30" },
    [30005] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door29" },
    [30006] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door28" },
    [30007] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door27" },
    [30008] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door26" },
    [30009] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door25" },
    [30010] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door24" },
    [30011] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door23" },
    [30012] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door22" },
    [30013] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door21" },
    [30014] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door6" },
    [30015] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door5" },
    [30016] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door4" },
    [30017] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door3" },
    [30018] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door2" },
    [30019] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1" },
    [30020] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door10" },
    [30021] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door12" },
    [30022] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door9" },
    [30023] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door8" },
    [30024] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door11" },
    [30026] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door20" },
    [30027] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door19" },
    [30028] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door18" },
    [30029] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door17" },
    [30030] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door16" },
    [30031] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door15" },
    [30032] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door14" },
    [31116] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate2" },
    [31118] = { kind = "open_door", source = "mm9_mechanism", targetName = "CWR1" },
    [31119] = { kind = "open_door", source = "mm9_mechanism", targetName = "CWL1" },
    [31120] = { kind = "open_door", source = "mm9_mechanism", targetName = "CWPlate1" },
    [31122] = { kind = "open_door", source = "mm9_mechanism", targetName = "CWR2" },
    [31123] = { kind = "open_door", source = "mm9_mechanism", targetName = "CWL2" },
    [31129] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate1" },
    [31131] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeRow2" },
    [31132] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeRow3" },
    [31133] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeRow4" },
    [31134] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeRow5" },
    [31135] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeRow6" },
    [31136] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeRow7" },
    [31137] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeRow8" },
    [31138] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeRow9" },
    [31139] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeRow10" },
    [31140] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeRow11" },
    [31141] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeRow12" },
    [31142] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeRow13" },
    [31143] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeRow14" },
    [31144] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeRow1" },
    [31146] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeRowPlate1" },
    [31147] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate4" },
    [31150] = { kind = "open_door", source = "mm9_mechanism", targetName = "HSP1" },
    [31153] = { kind = "open_door", source = "mm9_mechanism", targetName = "SDL1" },
    [31154] = { kind = "open_door", source = "mm9_mechanism", targetName = "SDU1" },
    [31156] = { kind = "open_door", source = "mm9_mechanism", targetName = "SDL2" },
    [31157] = { kind = "open_door", source = "mm9_mechanism", targetName = "SDU2" },
    [31158] = { kind = "open_door", source = "mm9_mechanism", targetName = "HSP2" },
    [31161] = { kind = "open_door", source = "mm9_mechanism", targetName = "SDL3" },
    [31162] = { kind = "open_door", source = "mm9_mechanism", targetName = "SDU3" },
    [31164] = { kind = "open_door", source = "mm9_mechanism", targetName = "SDL4" },
    [31165] = { kind = "open_door", source = "mm9_mechanism", targetName = "SDU4" },
    [31167] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate5" },
    [31168] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate6" },
    [31171] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate7" },
    [31174] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate8" },
    [31175] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate9" },
    [31176] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate10" },
    [31181] = { kind = "open_door", source = "mm9_mechanism", targetName = "CeilingCrushPlate4" },
    [31183] = { kind = "open_door", source = "mm9_mechanism", targetName = "PivotWallTrap1" },
    [31186] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrapExitDoor1" },
    [31189] = { kind = "open_door", source = "mm9_mechanism", targetName = "PivotButton1" },
    [31190] = { kind = "open_door", source = "mm9_mechanism", targetName = "PivotTreasurePanel1" },
    [31193] = { kind = "open_door", source = "mm9_mechanism", targetName = "CeilingCrushPlate3" },
    [31195] = { kind = "open_door", source = "mm9_mechanism", targetName = "PendulumWhoosh1" },
    [31196] = { kind = "open_door", source = "mm9_mechanism", targetName = "Pendulum1" },
    [31198] = { kind = "open_door", source = "mm9_mechanism", targetName = "PendulumWhoosh2" },
    [31199] = { kind = "open_door", source = "mm9_mechanism", targetName = "Pendulum2" },
    [31201] = { kind = "open_door", source = "mm9_mechanism", targetName = "HSP6" },
    [31204] = { kind = "open_door", source = "mm9_mechanism", targetName = "SDL6" },
    [31205] = { kind = "open_door", source = "mm9_mechanism", targetName = "SDU6" },
    [31206] = { kind = "open_door", source = "mm9_mechanism", targetName = "HSP7" },
    [31209] = { kind = "open_door", source = "mm9_mechanism", targetName = "SDL7" },
    [31210] = { kind = "open_door", source = "mm9_mechanism", targetName = "SDU7" },
    [31212] = { kind = "open_door", source = "mm9_mechanism", targetName = "Gratetrap0" },
    [31214] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door0" },
    [31215] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate3" },
    [31445] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door35" },
    [31446] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door34" },
    [31447] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door33" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30002, "Door32", function()
    map.triggerMechanism(2, 2)
end, "Door32")

RegisterEvent(30003, "Door31", function()
    map.triggerMechanism(3, 2)
end, "Door31")

RegisterEvent(30004, "Door30", function()
    map.triggerMechanism(4, 2)
end, "Door30")

RegisterEvent(30005, "Door29", function()
    map.triggerMechanism(5, 2)
end, "Door29")

RegisterEvent(30006, "Door28", function()
    map.triggerMechanism(6, 2)
end, "Door28")

RegisterEvent(30007, "Door27", function()
    map.triggerMechanism(7, 2)
end, "Door27")

RegisterEvent(30008, "Door26", function()
    map.triggerMechanism(8, 2)
end, "Door26")

RegisterEvent(30009, "Door25", function()
    map.triggerMechanism(9, 2)
end, "Door25")

RegisterEvent(30010, "Door24", function()
    map.triggerMechanism(10, 2)
end, "Door24")

RegisterEvent(30011, "Door23", function()
    map.triggerMechanism(11, 2)
end, "Door23")

RegisterEvent(30012, "Door22", function()
    map.triggerMechanism(12, 2)
end, "Door22")

RegisterEvent(30013, "Door21", function()
    map.triggerMechanism(13, 2)
end, "Door21")

RegisterEvent(30014, "Door6", function()
    map.triggerMechanism(14, 2)
end, "Door6")

RegisterEvent(30015, "Door5", function()
    map.triggerMechanism(15, 2)
end, "Door5")

RegisterEvent(30016, "Door4", function()
    map.triggerMechanism(16, 2)
end, "Door4")

RegisterEvent(30017, "Door3", function()
    map.triggerMechanism(17, 2)
end, "Door3")

RegisterEvent(30018, "Door2", function()
    map.triggerMechanism(18, 2)
end, "Door2")

RegisterEvent(30019, "Door1", function()
    map.triggerMechanism(19, 2)
end, "Door1")

RegisterEvent(30020, "Door10", function()
    map.triggerMechanism(20, 2)
end, "Door10")

RegisterEvent(30021, "Door12", function()
    map.triggerMechanism(21, 2)
end, "Door12")

RegisterEvent(30022, "Door9", function()
    map.triggerMechanism(22, 2)
end, "Door9")

RegisterEvent(30023, "Door8", function()
    map.triggerMechanism(23, 2)
end, "Door8")

RegisterEvent(30024, "Door11", function()
    map.triggerMechanism(24, 2)
end, "Door11")

RegisterEvent(30026, "Door20", function()
    map.triggerMechanism(26, 2)
end, "Door20")

RegisterEvent(30027, "Door19", function()
    map.triggerMechanism(27, 2)
end, "Door19")

RegisterEvent(30028, "Door18", function()
    map.triggerMechanism(28, 2)
end, "Door18")

RegisterEvent(30029, "Door17", function()
    map.triggerMechanism(29, 2)
end, "Door17")

RegisterEvent(30030, "Door16", function()
    map.triggerMechanism(30, 2)
end, "Door16")

RegisterEvent(30031, "Door15", function()
    map.triggerMechanism(31, 2)
end, "Door15")

RegisterEvent(30032, "Door14", function()
    map.triggerMechanism(32, 2)
end, "Door14")

RegisterEvent(31116, "ShooterPlate2", function()
    map.triggerMechanism(1116, 2)
end, "ShooterPlate2")

RegisterEvent(31118, "CWR1", function()
    map.triggerMechanism(1118, 2)
end, "CWR1")

RegisterEvent(31119, "CWL1", function()
    map.triggerMechanism(1119, 2)
end, "CWL1")

RegisterEvent(31120, "CWPlate1", function()
    map.triggerMechanism(1120, 2)
end, "CWPlate1")

RegisterEvent(31122, "CWR2", function()
    map.triggerMechanism(1122, 2)
end, "CWR2")

RegisterEvent(31123, "CWL2", function()
    map.triggerMechanism(1123, 2)
end, "CWL2")

RegisterEvent(31129, "ShooterPlate1", function()
    map.triggerMechanism(1129, 2)
end, "ShooterPlate1")

RegisterEvent(31131, "SpikeRow2", function()
    map.triggerMechanism(1131, 2)
end, "SpikeRow2")

RegisterEvent(31132, "SpikeRow3", function()
    map.triggerMechanism(1132, 2)
end, "SpikeRow3")

RegisterEvent(31133, "SpikeRow4", function()
    map.triggerMechanism(1133, 2)
end, "SpikeRow4")

RegisterEvent(31134, "SpikeRow5", function()
    map.triggerMechanism(1134, 2)
end, "SpikeRow5")

RegisterEvent(31135, "SpikeRow6", function()
    map.triggerMechanism(1135, 2)
end, "SpikeRow6")

RegisterEvent(31136, "SpikeRow7", function()
    map.triggerMechanism(1136, 2)
end, "SpikeRow7")

RegisterEvent(31137, "SpikeRow8", function()
    map.triggerMechanism(1137, 2)
end, "SpikeRow8")

RegisterEvent(31138, "SpikeRow9", function()
    map.triggerMechanism(1138, 2)
end, "SpikeRow9")

RegisterEvent(31139, "SpikeRow10", function()
    map.triggerMechanism(1139, 2)
end, "SpikeRow10")

RegisterEvent(31140, "SpikeRow11", function()
    map.triggerMechanism(1140, 2)
end, "SpikeRow11")

RegisterEvent(31141, "SpikeRow12", function()
    map.triggerMechanism(1141, 2)
end, "SpikeRow12")

RegisterEvent(31142, "SpikeRow13", function()
    map.triggerMechanism(1142, 2)
end, "SpikeRow13")

RegisterEvent(31143, "SpikeRow14", function()
    map.triggerMechanism(1143, 2)
end, "SpikeRow14")

RegisterEvent(31144, "SpikeRow1", function()
    map.triggerMechanism(1144, 2)
end, "SpikeRow1")

RegisterEvent(31146, "SpikeRowPlate1", function()
    map.triggerMechanism(1146, 2)
end, "SpikeRowPlate1")

RegisterEvent(31147, "ShooterPlate4", function()
    map.triggerMechanism(1147, 2)
end, "ShooterPlate4")

RegisterEvent(31150, "HSP1", function()
    map.triggerMechanism(1150, 2)
end, "HSP1")

RegisterEvent(31153, "SDL1", function()
    map.triggerMechanism(1153, 2)
end, "SDL1")

RegisterEvent(31154, "SDU1", function()
    map.triggerMechanism(1154, 2)
end, "SDU1")

RegisterEvent(31156, "SDL2", function()
    map.triggerMechanism(1156, 2)
end, "SDL2")

RegisterEvent(31157, "SDU2", function()
    map.triggerMechanism(1157, 2)
end, "SDU2")

RegisterEvent(31158, "HSP2", function()
    map.triggerMechanism(1158, 2)
end, "HSP2")

RegisterEvent(31161, "SDL3", function()
    map.triggerMechanism(1161, 2)
end, "SDL3")

RegisterEvent(31162, "SDU3", function()
    map.triggerMechanism(1162, 2)
end, "SDU3")

RegisterEvent(31164, "SDL4", function()
    map.triggerMechanism(1164, 2)
end, "SDL4")

RegisterEvent(31165, "SDU4", function()
    map.triggerMechanism(1165, 2)
end, "SDU4")

RegisterEvent(31167, "ShooterPlate5", function()
    map.triggerMechanism(1167, 2)
end, "ShooterPlate5")

RegisterEvent(31168, "ShooterPlate6", function()
    map.triggerMechanism(1168, 2)
end, "ShooterPlate6")

RegisterEvent(31171, "ShooterPlate7", function()
    map.triggerMechanism(1171, 2)
end, "ShooterPlate7")

RegisterEvent(31174, "ShooterPlate8", function()
    map.triggerMechanism(1174, 2)
end, "ShooterPlate8")

RegisterEvent(31175, "ShooterPlate9", function()
    map.triggerMechanism(1175, 2)
end, "ShooterPlate9")

RegisterEvent(31176, "ShooterPlate10", function()
    map.triggerMechanism(1176, 2)
end, "ShooterPlate10")

RegisterEvent(31181, "CeilingCrushPlate4", function()
    map.triggerMechanism(1181, 2)
end, "CeilingCrushPlate4")

RegisterEvent(31183, "PivotWallTrap1", function()
    map.triggerMechanism(1183, 2)
end, "PivotWallTrap1")

RegisterEvent(31186, "TrapExitDoor1", function()
    map.triggerMechanism(1186, 2)
end, "TrapExitDoor1")

RegisterEvent(31189, "PivotButton1", function()
    map.triggerMechanism(1189, 2)
end, "PivotButton1")

RegisterEvent(31190, "PivotTreasurePanel1", function()
    map.triggerMechanism(1190, 2)
end, "PivotTreasurePanel1")

RegisterEvent(31193, "CeilingCrushPlate3", function()
    map.triggerMechanism(1193, 2)
end, "CeilingCrushPlate3")

RegisterEvent(31195, "PendulumWhoosh1", function()
    map.triggerMechanism(1195, 2)
end, "PendulumWhoosh1")

RegisterEvent(31196, "Pendulum1", function()
    map.triggerMechanism(1196, 2)
end, "Pendulum1")

RegisterEvent(31198, "PendulumWhoosh2", function()
    map.triggerMechanism(1198, 2)
end, "PendulumWhoosh2")

RegisterEvent(31199, "Pendulum2", function()
    map.triggerMechanism(1199, 2)
end, "Pendulum2")

RegisterEvent(31201, "HSP6", function()
    map.triggerMechanism(1201, 2)
end, "HSP6")

RegisterEvent(31204, "SDL6", function()
    map.triggerMechanism(1204, 2)
end, "SDL6")

RegisterEvent(31205, "SDU6", function()
    map.triggerMechanism(1205, 2)
end, "SDU6")

RegisterEvent(31206, "HSP7", function()
    map.triggerMechanism(1206, 2)
end, "HSP7")

RegisterEvent(31209, "SDL7", function()
    map.triggerMechanism(1209, 2)
end, "SDL7")

RegisterEvent(31210, "SDU7", function()
    map.triggerMechanism(1210, 2)
end, "SDU7")

RegisterEvent(31212, "Gratetrap0", function()
    map.triggerMechanism(1212, 2)
end, "Gratetrap0")

RegisterEvent(31214, "Door0", function()
    map.triggerMechanism(1214, 2)
end, "Door0")

RegisterEvent(31215, "ShooterPlate3", function()
    map.triggerMechanism(1215, 2)
end, "ShooterPlate3")

RegisterEvent(31445, "Door35", function()
    map.triggerMechanism(1445, 2)
end, "Door35")

RegisterEvent(31446, "Door34", function()
    map.triggerMechanism(1446, 2)
end, "Door34")

RegisterEvent(31447, "Door33", function()
    map.triggerMechanism(1447, 2)
end, "Door33")

map.scripts["autoresurrect.scr"] = {
    source = "AUTORESURRECT.scr",
    registered_triggers = {
        { line = 83, message = "TMSG_RESURRECT", callback = "OnResurrect" },
    },
    movement_commands = {
    },
}
map.scripts["chasm_ghostspawner.scr"] = {
    source = "CHASM_GHOSTSPAWNER.scr",
    registered_triggers = {
        { line = 36, message = "spawn", callback = "SpawnCreature" },
    },
    movement_commands = {
    },
}
map.scripts["cronakiga.scr"] = {
    source = "CRONAKIGA.scr",
    registered_triggers = {
        { line = 101, message = "Use", callback = "Onuse" },
    },
    movement_commands = {
    },
}
map.scripts["lichinstructions.scr"] = {
    source = "LICHINSTRUCTIONS.scr",
    registered_triggers = {
        { line = 46, message = "Use", callback = "Onuse" },
    },
    movement_commands = {
    },
}
map.scripts["mummyawaken.scr"] = {
    source = "MUMMYAWAKEN.scr",
    registered_triggers = {
        { line = 61, message = "awaken", callback = "WakeUp" },
    },
    movement_commands = {
    },
}
map.scripts["offrailtrigger.scr"] = {
    source = "OFFRAILTRIGGER.scr",
    registered_triggers = {
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
