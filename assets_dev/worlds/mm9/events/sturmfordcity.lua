-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "sturmfordcity"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 772,
        source_name = "SturmfordDocks",
        x = 2089,
        y = -1065,
        z = 19878,
        direction_yaw_units = 0,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 773,
        source_name = "SewerS",
        x = 1249,
        y = 52,
        z = 19863,
        direction_yaw_units = 512,
        move_player_to_floor = true,
    },
    {
        start_index = 2,
        source_object_index = 774,
        source_name = "SewerW",
        x = -5345,
        y = 12627,
        z = 19863,
        direction_yaw_units = 512,
        move_player_to_floor = true,
    },
    {
        start_index = 3,
        source_object_index = 775,
        source_name = "SewerE",
        x = 15360,
        y = 16876,
        z = 19863,
        direction_yaw_units = 512,
        move_player_to_floor = true,
    },
    {
        start_index = 4,
        source_object_index = 776,
        source_name = "Sturmford",
        x = 11141,
        y = 14519,
        z = 19863,
        direction_yaw_units = 512,
        move_player_to_floor = true,
    },
    {
        start_index = 5,
        source_object_index = 1330,
        source_name = "TownPortal",
        x = 4844,
        y = 8929,
        z = 19948,
        direction_yaw_units = 1019,
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
        mechanism_id = 900750,
        event_id = 30750,
        source_object_index = 750,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 900751,
        event_id = 30751,
        source_object_index = 751,
        source_class = "AIBarrier",
        source_name = "AIBarrier10",
        kind = "ai_barrier",
        hint = "AIBarrier10",
    },
    {
        mechanism_id = 900777,
        event_id = 30777,
        source_object_index = 777,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush9",
        kind = "collision_volume",
        hint = "InvisibleBrush9",
    },
    {
        mechanism_id = 900778,
        event_id = 30778,
        source_object_index = 778,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush8",
        kind = "collision_volume",
        hint = "InvisibleBrush8",
    },
    {
        mechanism_id = 900779,
        event_id = 30779,
        source_object_index = 779,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush7",
        kind = "collision_volume",
        hint = "InvisibleBrush7",
    },
    {
        mechanism_id = 900780,
        event_id = 30780,
        source_object_index = 780,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush6",
        kind = "collision_volume",
        hint = "InvisibleBrush6",
    },
    {
        mechanism_id = 900781,
        event_id = 30781,
        source_object_index = 781,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 900782,
        event_id = 30782,
        source_object_index = 782,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 900783,
        event_id = 30783,
        source_object_index = 783,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 900784,
        event_id = 30784,
        source_object_index = 784,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900785,
        event_id = 30785,
        source_object_index = 785,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush10",
        kind = "collision_volume",
        hint = "InvisibleBrush10",
    },
    {
        mechanism_id = 901133,
        event_id = 31133,
        source_object_index = 1133,
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
        mechanism_id = 901134,
        event_id = 31134,
        source_object_index = 1134,
        source_class = "RotatingDoor",
        source_name = "GenStoreDoor1",
        kind = "rotating_door",
        hint = "GenStoreDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901135,
        event_id = 31135,
        source_object_index = 1135,
        source_class = "RotatingDoor",
        source_name = "GenStoreDoor2",
        kind = "rotating_door",
        hint = "GenStoreDoor2",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901138,
        event_id = 31138,
        source_object_index = 1138,
        source_class = "RotatingDoor",
        source_name = "barflap1",
        kind = "rotating_door",
        hint = "barflap1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901139,
        event_id = 31139,
        source_object_index = 1139,
        source_class = "RotatingDoor",
        source_name = "barflap2",
        kind = "rotating_door",
        hint = "barflap2",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901140,
        event_id = 31140,
        source_object_index = 1140,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
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
        source_class = "RotatingDoor",
        source_name = "Door1",
        kind = "rotating_door",
        hint = "Door1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901145,
        event_id = 31145,
        source_object_index = 1145,
        source_class = "RotatingDoor",
        source_name = "Door2",
        kind = "rotating_door",
        hint = "Door2",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901146,
        event_id = 31146,
        source_object_index = 1146,
        source_class = "RotatingDoor",
        source_name = "Door3",
        kind = "rotating_door",
        hint = "Door3",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901147,
        event_id = 31147,
        source_object_index = 1147,
        source_class = "RotatingDoor",
        source_name = "Door4",
        kind = "rotating_door",
        hint = "Door4",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901148,
        event_id = 31148,
        source_object_index = 1148,
        source_class = "RotatingDoor",
        source_name = "ArchDoorLeft",
        kind = "rotating_door",
        hint = "ArchDoorLeft",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901149,
        event_id = 31149,
        source_object_index = 1149,
        source_class = "RotatingDoor",
        source_name = "ArchDoorRight",
        kind = "rotating_door",
        hint = "ArchDoorRight",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901150,
        event_id = 31150,
        source_object_index = 1150,
        source_class = "RotatingDoor",
        source_name = "BeetHovengrate",
        kind = "rotating_door",
        hint = "BeetHovengrate",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901151,
        event_id = 31151,
        source_object_index = 1151,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor33",
        kind = "rotating_door",
        hint = "RotatingDoor33",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901154,
        event_id = 31154,
        source_object_index = 1154,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush41",
        kind = "destructible_brush",
        hint = "DestructableBrush41",
    },
    {
        mechanism_id = 901155,
        event_id = 31155,
        source_object_index = 1155,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush40",
        kind = "destructible_brush",
        hint = "DestructableBrush40",
    },
    {
        mechanism_id = 901156,
        event_id = 31156,
        source_object_index = 1156,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush39",
        kind = "destructible_brush",
        hint = "DestructableBrush39",
    },
    {
        mechanism_id = 901157,
        event_id = 31157,
        source_object_index = 1157,
        source_class = "RotatingDoor",
        source_name = "f10doorl2",
        kind = "rotating_door",
        hint = "f10doorl2",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901158,
        event_id = 31158,
        source_object_index = 1158,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901159,
        event_id = 31159,
        source_object_index = 1159,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901161,
        event_id = 31161,
        source_object_index = 1161,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901162,
        event_id = 31162,
        source_object_index = 1162,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901163,
        event_id = 31163,
        source_object_index = 1163,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901164,
        event_id = 31164,
        source_object_index = 1164,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901165,
        event_id = 31165,
        source_object_index = 1165,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901166,
        event_id = 31166,
        source_object_index = 1166,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901167,
        event_id = 31167,
        source_object_index = 1167,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901169,
        event_id = 31169,
        source_object_index = 1169,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901170,
        event_id = 31170,
        source_object_index = 1170,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
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
        source_class = "RotatingDoor",
        source_name = "Jaildoor",
        kind = "rotating_door",
        hint = "Jaildoor",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
                name = "Door/locked_door01.wav",
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
        source_class = "RotatingDoor",
        source_name = "MagiL",
        kind = "rotating_door",
        hint = "MagiL",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901176,
        event_id = 31176,
        source_object_index = 1176,
        source_class = "RotatingDoor",
        source_name = "MagiR",
        kind = "rotating_door",
        hint = "MagiR",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901178,
        event_id = 31178,
        source_object_index = 1178,
        source_class = "RotatingDoor",
        source_name = "bankdoorL",
        kind = "rotating_door",
        hint = "bankdoorL",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901179,
        event_id = 31179,
        source_object_index = 1179,
        source_class = "RotatingDoor",
        source_name = "bankdoorR",
        kind = "rotating_door",
        hint = "bankdoorR",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901180,
        event_id = 31180,
        source_object_index = 1180,
        source_class = "RotatingDoor",
        source_name = "vaultdoor",
        kind = "rotating_door",
        hint = "vaultdoor",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
                name = "Door/locked_door01.wav",
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901182,
        event_id = 31182,
        source_object_index = 1182,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901183,
        event_id = 31183,
        source_object_index = 1183,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901184,
        event_id = 31184,
        source_object_index = 1184,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor28",
        kind = "rotating_door",
        hint = "RotatingDoor28",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901185,
        event_id = 31185,
        source_object_index = 1185,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor29",
        kind = "rotating_door",
        hint = "RotatingDoor29",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901186,
        event_id = 31186,
        source_object_index = 1186,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor32",
        kind = "rotating_door",
        hint = "RotatingDoor32",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901187,
        event_id = 31187,
        source_object_index = 1187,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush43",
        kind = "destructible_brush",
        hint = "DestructableBrush43",
    },
    {
        mechanism_id = 901188,
        event_id = 31188,
        source_object_index = 1188,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush44",
        kind = "destructible_brush",
        hint = "DestructableBrush44",
    },
    {
        mechanism_id = 901189,
        event_id = 31189,
        source_object_index = 1189,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush45",
        kind = "destructible_brush",
        hint = "DestructableBrush45",
    },
    {
        mechanism_id = 901190,
        event_id = 31190,
        source_object_index = 1190,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush46",
        kind = "destructible_brush",
        hint = "DestructableBrush46",
    },
    {
        mechanism_id = 901191,
        event_id = 31191,
        source_object_index = 1191,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush0",
        kind = "destructible_brush",
        hint = "DestructableBrush0",
    },
    {
        mechanism_id = 901192,
        event_id = 31192,
        source_object_index = 1192,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush1",
        kind = "destructible_brush",
        hint = "DestructableBrush1",
    },
    {
        mechanism_id = 901193,
        event_id = 31193,
        source_object_index = 1193,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush2",
        kind = "destructible_brush",
        hint = "DestructableBrush2",
    },
    {
        mechanism_id = 901194,
        event_id = 31194,
        source_object_index = 1194,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush3",
        kind = "destructible_brush",
        hint = "DestructableBrush3",
    },
    {
        mechanism_id = 901195,
        event_id = 31195,
        source_object_index = 1195,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush4",
        kind = "destructible_brush",
        hint = "DestructableBrush4",
    },
    {
        mechanism_id = 901196,
        event_id = 31196,
        source_object_index = 1196,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor30",
        kind = "rotating_door",
        hint = "RotatingDoor30",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901197,
        event_id = 31197,
        source_object_index = 1197,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor31",
        kind = "rotating_door",
        hint = "RotatingDoor31",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901198,
        event_id = 31198,
        source_object_index = 1198,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901199,
        event_id = 31199,
        source_object_index = 1199,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901213,
        event_id = 31213,
        source_object_index = 1213,
        source_class = "RotatingDoor",
        source_name = "LibraryR",
        kind = "rotating_door",
        hint = "LibraryR",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901214,
        event_id = 31214,
        source_object_index = 1214,
        source_class = "RotatingDoor",
        source_name = "LibraryL",
        kind = "rotating_door",
        hint = "LibraryL",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901215,
        event_id = 31215,
        source_object_index = 1215,
        source_class = "RotatingDoor",
        source_name = "Towngate1L",
        kind = "rotating_door",
        hint = "Towngate1L",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open01.wav",
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
        mechanism_id = 901216,
        event_id = 31216,
        source_object_index = 1216,
        source_class = "RotatingDoor",
        source_name = "Templegate2L",
        kind = "rotating_door",
        hint = "Templegate2L",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open01.wav",
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
        mechanism_id = 901217,
        event_id = 31217,
        source_object_index = 1217,
        source_class = "RotatingDoor",
        source_name = "Templegate1L",
        kind = "rotating_door",
        hint = "Templegate1L",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open01.wav",
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
        mechanism_id = 901220,
        event_id = 31220,
        source_object_index = 1220,
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
        mechanism_id = 901221,
        event_id = 31221,
        source_object_index = 1221,
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
        mechanism_id = 901222,
        event_id = 31222,
        source_object_index = 1222,
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
        mechanism_id = 901223,
        event_id = 31223,
        source_object_index = 1223,
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
        mechanism_id = 901224,
        event_id = 31224,
        source_object_index = 1224,
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
        mechanism_id = 901225,
        event_id = 31225,
        source_object_index = 1225,
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
        mechanism_id = 901226,
        event_id = 31226,
        source_object_index = 1226,
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
        mechanism_id = 901227,
        event_id = 31227,
        source_object_index = 1227,
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
        mechanism_id = 901228,
        event_id = 31228,
        source_object_index = 1228,
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
        mechanism_id = 901229,
        event_id = 31229,
        source_object_index = 1229,
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
        mechanism_id = 901230,
        event_id = 31230,
        source_object_index = 1230,
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
        mechanism_id = 901231,
        event_id = 31231,
        source_object_index = 1231,
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
        mechanism_id = 901232,
        event_id = 31232,
        source_object_index = 1232,
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
        mechanism_id = 901233,
        event_id = 31233,
        source_object_index = 1233,
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
        mechanism_id = 901234,
        event_id = 31234,
        source_object_index = 1234,
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
        mechanism_id = 901235,
        event_id = 31235,
        source_object_index = 1235,
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
        mechanism_id = 901236,
        event_id = 31236,
        source_object_index = 1236,
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
        mechanism_id = 901237,
        event_id = 31237,
        source_object_index = 1237,
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
        mechanism_id = 901238,
        event_id = 31238,
        source_object_index = 1238,
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
        mechanism_id = 901239,
        event_id = 31239,
        source_object_index = 1239,
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
        mechanism_id = 901240,
        event_id = 31240,
        source_object_index = 1240,
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
        mechanism_id = 901241,
        event_id = 31241,
        source_object_index = 1241,
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
        mechanism_id = 901242,
        event_id = 31242,
        source_object_index = 1242,
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
        mechanism_id = 901243,
        event_id = 31243,
        source_object_index = 1243,
        source_class = "RotatingDoor",
        source_name = "TestHouse1",
        kind = "rotating_door",
        hint = "TestHouse1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901244,
        event_id = 31244,
        source_object_index = 1244,
        source_class = "RotatingDoor",
        source_name = "f10doorl",
        kind = "rotating_door",
        hint = "f10doorl",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901245,
        event_id = 31245,
        source_object_index = 1245,
        source_class = "RotatingDoor",
        source_name = "f10doorr",
        kind = "rotating_door",
        hint = "f10doorr",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901246,
        event_id = 31246,
        source_object_index = 1246,
        source_class = "RotatingDoor",
        source_name = "f10doorl0",
        kind = "rotating_door",
        hint = "f10doorl0",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901247,
        event_id = 31247,
        source_object_index = 1247,
        source_class = "RotatingDoor",
        source_name = "f10doorr0",
        kind = "rotating_door",
        hint = "f10doorr0",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901248,
        event_id = 31248,
        source_object_index = 1248,
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
        mechanism_id = 901249,
        event_id = 31249,
        source_object_index = 1249,
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
        mechanism_id = 901250,
        event_id = 31250,
        source_object_index = 1250,
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
        mechanism_id = 901251,
        event_id = 31251,
        source_object_index = 1251,
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
        mechanism_id = 901252,
        event_id = 31252,
        source_object_index = 1252,
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
        mechanism_id = 901253,
        event_id = 31253,
        source_object_index = 1253,
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
        mechanism_id = 901254,
        event_id = 31254,
        source_object_index = 1254,
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
        mechanism_id = 901255,
        event_id = 31255,
        source_object_index = 1255,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901256,
        event_id = 31256,
        source_object_index = 1256,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901257,
        event_id = 31257,
        source_object_index = 1257,
        source_class = "RotatingDoor",
        source_name = "ThronedoorL",
        kind = "rotating_door",
        hint = "ThronedoorL",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901258,
        event_id = 31258,
        source_object_index = 1258,
        source_class = "RotatingDoor",
        source_name = "ThronedoorR",
        kind = "rotating_door",
        hint = "ThronedoorR",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901259,
        event_id = 31259,
        source_object_index = 1259,
        source_class = "RotatingDoor",
        source_name = "Backdoor",
        kind = "rotating_door",
        hint = "Backdoor",
    },
    {
        mechanism_id = 901260,
        event_id = 31260,
        source_object_index = 1260,
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
        mechanism_id = 901261,
        event_id = 31261,
        source_object_index = 1261,
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
        mechanism_id = 901262,
        event_id = 31262,
        source_object_index = 1262,
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
        mechanism_id = 901263,
        event_id = 31263,
        source_object_index = 1263,
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
        mechanism_id = 901269,
        event_id = 31269,
        source_object_index = 1269,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush37",
        kind = "destructible_brush",
        hint = "DestructableBrush37",
    },
    {
        mechanism_id = 901270,
        event_id = 31270,
        source_object_index = 1270,
        source_class = "DestructableBrush",
        source_name = "WorldObject19",
        kind = "destructible_brush",
        hint = "WorldObject19",
    },
    {
        mechanism_id = 901271,
        event_id = 31271,
        source_object_index = 1271,
        source_class = "DestructableBrush",
        source_name = "WorldObject18",
        kind = "destructible_brush",
        hint = "WorldObject18",
    },
    {
        mechanism_id = 901272,
        event_id = 31272,
        source_object_index = 1272,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush42",
        kind = "destructible_brush",
        hint = "DestructableBrush42",
    },
    {
        mechanism_id = 901273,
        event_id = 31273,
        source_object_index = 1273,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush38",
        kind = "destructible_brush",
        hint = "DestructableBrush38",
    },
    {
        mechanism_id = 901274,
        event_id = 31274,
        source_object_index = 1274,
        source_class = "DestructableBrush",
        source_name = "WorldObject10",
        kind = "destructible_brush",
        hint = "WorldObject10",
    },
    {
        mechanism_id = 901275,
        event_id = 31275,
        source_object_index = 1275,
        source_class = "RotatingDoor",
        source_name = "Churchdoor2",
        kind = "rotating_door",
        hint = "Churchdoor2",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901276,
        event_id = 31276,
        source_object_index = 1276,
        source_class = "RotatingDoor",
        source_name = "Churchdoor1",
        kind = "rotating_door",
        hint = "Churchdoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901277,
        event_id = 31277,
        source_object_index = 1277,
        source_class = "RotatingDoor",
        source_name = "ChurchdoorR",
        kind = "rotating_door",
        hint = "ChurchdoorR",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901278,
        event_id = 31278,
        source_object_index = 1278,
        source_class = "RotatingDoor",
        source_name = "ChurchdoorL",
        kind = "rotating_door",
        hint = "ChurchdoorL",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 901279,
        event_id = 31279,
        source_object_index = 1279,
        source_class = "DestructableBrush",
        source_name = "WorldObject37",
        kind = "destructible_brush",
        hint = "WorldObject37",
    },
    {
        mechanism_id = 901280,
        event_id = 31280,
        source_object_index = 1280,
        source_class = "DestructableBrush",
        source_name = "WorldObject1",
        kind = "destructible_brush",
        hint = "WorldObject1",
    },
    {
        mechanism_id = 901281,
        event_id = 31281,
        source_object_index = 1281,
        source_class = "DestructableBrush",
        source_name = "WorldObject2",
        kind = "destructible_brush",
        hint = "WorldObject2",
    },
    {
        mechanism_id = 901282,
        event_id = 31282,
        source_object_index = 1282,
        source_class = "DestructableBrush",
        source_name = "WorldObject38",
        kind = "destructible_brush",
        hint = "WorldObject38",
    },
    {
        mechanism_id = 901283,
        event_id = 31283,
        source_object_index = 1283,
        source_class = "DestructableBrush",
        source_name = "WorldObject39",
        kind = "destructible_brush",
        hint = "WorldObject39",
    },
    {
        mechanism_id = 901284,
        event_id = 31284,
        source_object_index = 1284,
        source_class = "DestructableBrush",
        source_name = "WorldObject40",
        kind = "destructible_brush",
        hint = "WorldObject40",
    },
    {
        mechanism_id = 901285,
        event_id = 31285,
        source_object_index = 1285,
        source_class = "DestructableBrush",
        source_name = "WorldObject41",
        kind = "destructible_brush",
        hint = "WorldObject41",
    },
    {
        mechanism_id = 901286,
        event_id = 31286,
        source_object_index = 1286,
        source_class = "DestructableBrush",
        source_name = "WorldObject42",
        kind = "destructible_brush",
        hint = "WorldObject42",
    },
    {
        mechanism_id = 901287,
        event_id = 31287,
        source_object_index = 1287,
        source_class = "DestructableBrush",
        source_name = "WorldObject43",
        kind = "destructible_brush",
        hint = "WorldObject43",
    },
    {
        mechanism_id = 901288,
        event_id = 31288,
        source_object_index = 1288,
        source_class = "DestructableBrush",
        source_name = "WorldObject44",
        kind = "destructible_brush",
        hint = "WorldObject44",
    },
    {
        mechanism_id = 901289,
        event_id = 31289,
        source_object_index = 1289,
        source_class = "DestructableBrush",
        source_name = "WorldObject45",
        kind = "destructible_brush",
        hint = "WorldObject45",
    },
    {
        mechanism_id = 901291,
        event_id = 31291,
        source_object_index = 1291,
        source_class = "Ladder",
        source_name = "Ladder2",
        kind = "ladder_volume",
        hint = "Ladder2",
    },
    {
        mechanism_id = 901293,
        event_id = 31293,
        source_object_index = 1293,
        source_class = "Ladder",
        source_name = "Ladder5",
        kind = "ladder_volume",
        hint = "Ladder5",
    },
    {
        mechanism_id = 901294,
        event_id = 31294,
        source_object_index = 1294,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901295,
        event_id = 31295,
        source_object_index = 1295,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901299,
        event_id = 31299,
        source_object_index = 1299,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901300,
        event_id = 31300,
        source_object_index = 1300,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901302,
        event_id = 31302,
        source_object_index = 1302,
        source_class = "Ladder",
        source_name = "Ladder4",
        kind = "ladder_volume",
        hint = "Ladder4",
    },
    {
        mechanism_id = 901304,
        event_id = 31304,
        source_object_index = 1304,
        source_class = "Ladder",
        source_name = "Ladder6",
        kind = "ladder_volume",
        hint = "Ladder6",
    },
    {
        mechanism_id = 901307,
        event_id = 31307,
        source_object_index = 1307,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush11",
        kind = "collision_volume",
        hint = "InvisibleBrush11",
    },
    {
        mechanism_id = 901308,
        event_id = 31308,
        source_object_index = 1308,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 901309,
        event_id = 31309,
        source_object_index = 1309,
        source_class = "Ladder",
        source_name = "Ladder7",
        kind = "ladder_volume",
        hint = "Ladder7",
    },
    {
        mechanism_id = 901311,
        event_id = 31311,
        source_object_index = 1311,
        source_class = "BlueWater",
        source_name = "Wellwater",
        kind = "water_volume",
        hint = "Wellwater",
    },
    {
        mechanism_id = 901331,
        event_id = 31331,
        source_object_index = 1331,
        source_class = "ScriptObject",
        source_name = "ScriptObject0",
        kind = "script_object",
        hint = "ScriptObject0",
    },
    {
        mechanism_id = 901332,
        event_id = 31332,
        source_object_index = 1332,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 901333,
        event_id = 31333,
        source_object_index = 1333,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 901334,
        event_id = 31334,
        source_object_index = 1334,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 901335,
        event_id = 31335,
        source_object_index = 1335,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 901336,
        event_id = 31336,
        source_object_index = 1336,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 901337,
        event_id = 31337,
        source_object_index = 1337,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 901338,
        event_id = 31338,
        source_object_index = 1338,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 901339,
        event_id = 31339,
        source_object_index = 1339,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush7",
        kind = "perception_brush",
        hint = "PerceptionBrush7",
    },
    {
        mechanism_id = 901340,
        event_id = 31340,
        source_object_index = 1340,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush8",
        kind = "perception_brush",
        hint = "PerceptionBrush8",
    },
    {
        mechanism_id = 901341,
        event_id = 31341,
        source_object_index = 1341,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush9",
        kind = "perception_brush",
        hint = "PerceptionBrush9",
    },
    {
        mechanism_id = 901342,
        event_id = 31342,
        source_object_index = 1342,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush10",
        kind = "perception_brush",
        hint = "PerceptionBrush10",
    },
    {
        mechanism_id = 901343,
        event_id = 31343,
        source_object_index = 1343,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush11",
        kind = "perception_brush",
        hint = "PerceptionBrush11",
    },
    {
        mechanism_id = 901344,
        event_id = 31344,
        source_object_index = 1344,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush12",
        kind = "perception_brush",
        hint = "PerceptionBrush12",
    },
    {
        mechanism_id = 901345,
        event_id = 31345,
        source_object_index = 1345,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush13",
        kind = "perception_brush",
        hint = "PerceptionBrush13",
    },
    {
        mechanism_id = 901346,
        event_id = 31346,
        source_object_index = 1346,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush14",
        kind = "perception_brush",
        hint = "PerceptionBrush14",
    },
    {
        mechanism_id = 901347,
        event_id = 31347,
        source_object_index = 1347,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush15",
        kind = "perception_brush",
        hint = "PerceptionBrush15",
    },
    {
        mechanism_id = 901348,
        event_id = 31348,
        source_object_index = 1348,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush16",
        kind = "perception_brush",
        hint = "PerceptionBrush16",
    },
    {
        mechanism_id = 901349,
        event_id = 31349,
        source_object_index = 1349,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush17",
        kind = "perception_brush",
        hint = "PerceptionBrush17",
    },
    {
        mechanism_id = 901350,
        event_id = 31350,
        source_object_index = 1350,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush18",
        kind = "perception_brush",
        hint = "PerceptionBrush18",
    },
    {
        mechanism_id = 901351,
        event_id = 31351,
        source_object_index = 1351,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush19",
        kind = "perception_brush",
        hint = "PerceptionBrush19",
    },
    {
        mechanism_id = 901352,
        event_id = 31352,
        source_object_index = 1352,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush20",
        kind = "perception_brush",
        hint = "PerceptionBrush20",
    },
    {
        mechanism_id = 901353,
        event_id = 31353,
        source_object_index = 1353,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush21",
        kind = "perception_brush",
        hint = "PerceptionBrush21",
    },
    {
        mechanism_id = 901354,
        event_id = 31354,
        source_object_index = 1354,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush22",
        kind = "perception_brush",
        hint = "PerceptionBrush22",
    },
    {
        mechanism_id = 901356,
        event_id = 31356,
        source_object_index = 1356,
        source_class = "Ladder",
        source_name = "Ladder3",
        kind = "ladder_volume",
        hint = "Ladder3",
    },
    {
        mechanism_id = 901394,
        event_id = 31394,
        source_object_index = 1394,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush23",
        kind = "perception_brush",
        hint = "PerceptionBrush23",
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
    [31133] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor16" },
    [31134] = { kind = "open_door", source = "mm9_mechanism", targetName = "GenStoreDoor1" },
    [31135] = { kind = "open_door", source = "mm9_mechanism", targetName = "GenStoreDoor2" },
    [31138] = { kind = "open_door", source = "mm9_mechanism", targetName = "barflap1" },
    [31139] = { kind = "open_door", source = "mm9_mechanism", targetName = "barflap2" },
    [31140] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0" },
    [31141] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor1" },
    [31142] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor2" },
    [31143] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor3" },
    [31144] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1" },
    [31145] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door2" },
    [31146] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door3" },
    [31147] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door4" },
    [31148] = { kind = "open_door", source = "mm9_mechanism", targetName = "ArchDoorLeft" },
    [31149] = { kind = "open_door", source = "mm9_mechanism", targetName = "ArchDoorRight" },
    [31150] = { kind = "open_door", source = "mm9_mechanism", targetName = "BeetHovengrate" },
    [31151] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor33" },
    [31157] = { kind = "open_door", source = "mm9_mechanism", targetName = "f10doorl2" },
    [31158] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor6" },
    [31159] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor10" },
    [31160] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor12" },
    [31161] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor13" },
    [31162] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor14" },
    [31163] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor15" },
    [31164] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor8" },
    [31165] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor19" },
    [31166] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor26" },
    [31167] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor25" },
    [31168] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor23" },
    [31169] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor24" },
    [31170] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor21" },
    [31171] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor22" },
    [31173] = { kind = "open_door", source = "mm9_mechanism", targetName = "Jaildoor" },
    [31175] = { kind = "open_door", source = "mm9_mechanism", targetName = "MagiL" },
    [31176] = { kind = "open_door", source = "mm9_mechanism", targetName = "MagiR" },
    [31178] = { kind = "open_door", source = "mm9_mechanism", targetName = "bankdoorL" },
    [31179] = { kind = "open_door", source = "mm9_mechanism", targetName = "bankdoorR" },
    [31180] = { kind = "open_door", source = "mm9_mechanism", targetName = "vaultdoor" },
    [31181] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor11" },
    [31182] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor20" },
    [31183] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor27" },
    [31184] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor28" },
    [31185] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor29" },
    [31186] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor32" },
    [31196] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor30" },
    [31197] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor31" },
    [31198] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor4" },
    [31199] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor5" },
    [31213] = { kind = "open_door", source = "mm9_mechanism", targetName = "LibraryR" },
    [31214] = { kind = "open_door", source = "mm9_mechanism", targetName = "LibraryL" },
    [31215] = { kind = "open_door", source = "mm9_mechanism", targetName = "Towngate1L" },
    [31216] = { kind = "open_door", source = "mm9_mechanism", targetName = "Templegate2L" },
    [31217] = { kind = "open_door", source = "mm9_mechanism", targetName = "Templegate1L" },
    [31220] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door34" },
    [31221] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door33" },
    [31222] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door32" },
    [31223] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door31" },
    [31224] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door30" },
    [31225] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door29" },
    [31226] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door28" },
    [31227] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door26" },
    [31228] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door25" },
    [31229] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door24" },
    [31230] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door21" },
    [31231] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door20" },
    [31232] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door19" },
    [31233] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door18" },
    [31234] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door17" },
    [31235] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door16" },
    [31236] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door15" },
    [31237] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door14" },
    [31238] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door13" },
    [31239] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door12" },
    [31240] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door11" },
    [31241] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door9" },
    [31242] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door8" },
    [31243] = { kind = "open_door", source = "mm9_mechanism", targetName = "TestHouse1" },
    [31244] = { kind = "open_door", source = "mm9_mechanism", targetName = "f10doorl" },
    [31245] = { kind = "open_door", source = "mm9_mechanism", targetName = "f10doorr" },
    [31246] = { kind = "open_door", source = "mm9_mechanism", targetName = "f10doorl0" },
    [31247] = { kind = "open_door", source = "mm9_mechanism", targetName = "f10doorr0" },
    [31248] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door7" },
    [31249] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door35" },
    [31250] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door6" },
    [31251] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door5" },
    [31252] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door0" },
    [31253] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door27" },
    [31254] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door23" },
    [31255] = { kind = "open_door", source = "mm9_mechanism", targetName = "PalacedoorL" },
    [31256] = { kind = "open_door", source = "mm9_mechanism", targetName = "PalacedoorR" },
    [31257] = { kind = "open_door", source = "mm9_mechanism", targetName = "ThronedoorL" },
    [31258] = { kind = "open_door", source = "mm9_mechanism", targetName = "ThronedoorR" },
    [31259] = { kind = "open_door", source = "mm9_mechanism", targetName = "Backdoor" },
    [31260] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door22" },
    [31261] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door36" },
    [31262] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door37" },
    [31263] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door38" },
    [31275] = { kind = "open_door", source = "mm9_mechanism", targetName = "Churchdoor2" },
    [31276] = { kind = "open_door", source = "mm9_mechanism", targetName = "Churchdoor1" },
    [31277] = { kind = "open_door", source = "mm9_mechanism", targetName = "ChurchdoorR" },
    [31278] = { kind = "open_door", source = "mm9_mechanism", targetName = "ChurchdoorL" },
    [31294] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor9" },
    [31295] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor7" },
    [31299] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor18" },
    [31300] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor17" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(31133, "RotatingDoor16", function()
    map.triggerMechanism(1133, 2)
end, "RotatingDoor16")

RegisterEvent(31134, "GenStoreDoor1", function()
    map.triggerMechanism(1134, 2)
end, "GenStoreDoor1")

RegisterEvent(31135, "GenStoreDoor2", function()
    map.triggerMechanism(1135, 2)
end, "GenStoreDoor2")

RegisterEvent(31138, "barflap1", function()
    map.triggerMechanism(1138, 2)
end, "barflap1")

RegisterEvent(31139, "barflap2", function()
    map.triggerMechanism(1139, 2)
end, "barflap2")

RegisterEvent(31140, "RotatingDoor0", function()
    map.triggerMechanism(1140, 2)
end, "RotatingDoor0")

RegisterEvent(31141, "RotatingDoor1", function()
    map.triggerMechanism(1141, 2)
end, "RotatingDoor1")

RegisterEvent(31142, "RotatingDoor2", function()
    map.triggerMechanism(1142, 2)
end, "RotatingDoor2")

RegisterEvent(31143, "RotatingDoor3", function()
    map.triggerMechanism(1143, 2)
end, "RotatingDoor3")

RegisterEvent(31144, "Door1", function()
    map.triggerMechanism(1144, 2)
end, "Door1")

RegisterEvent(31145, "Door2", function()
    map.triggerMechanism(1145, 2)
end, "Door2")

RegisterEvent(31146, "Door3", function()
    map.triggerMechanism(1146, 2)
end, "Door3")

RegisterEvent(31147, "Door4", function()
    map.triggerMechanism(1147, 2)
end, "Door4")

RegisterEvent(31148, "ArchDoorLeft", function()
    map.triggerMechanism(1148, 2)
end, "ArchDoorLeft")

RegisterEvent(31149, "ArchDoorRight", function()
    map.triggerMechanism(1149, 2)
end, "ArchDoorRight")

RegisterEvent(31150, "BeetHovengrate", function()
    map.triggerMechanism(1150, 2)
end, "BeetHovengrate")

RegisterEvent(31151, "RotatingDoor33", function()
    map.triggerMechanism(1151, 2)
end, "RotatingDoor33")

RegisterEvent(31157, "f10doorl2", function()
    map.triggerMechanism(1157, 2)
end, "f10doorl2")

RegisterEvent(31158, "RotatingDoor6", function()
    map.triggerMechanism(1158, 2)
end, "RotatingDoor6")

RegisterEvent(31159, "RotatingDoor10", function()
    map.triggerMechanism(1159, 2)
end, "RotatingDoor10")

RegisterEvent(31160, "RotatingDoor12", function()
    map.triggerMechanism(1160, 2)
end, "RotatingDoor12")

RegisterEvent(31161, "RotatingDoor13", function()
    map.triggerMechanism(1161, 2)
end, "RotatingDoor13")

RegisterEvent(31162, "RotatingDoor14", function()
    map.triggerMechanism(1162, 2)
end, "RotatingDoor14")

RegisterEvent(31163, "RotatingDoor15", function()
    map.triggerMechanism(1163, 2)
end, "RotatingDoor15")

RegisterEvent(31164, "RotatingDoor8", function()
    map.triggerMechanism(1164, 2)
end, "RotatingDoor8")

RegisterEvent(31165, "RotatingDoor19", function()
    map.triggerMechanism(1165, 2)
end, "RotatingDoor19")

RegisterEvent(31166, "RotatingDoor26", function()
    map.triggerMechanism(1166, 2)
end, "RotatingDoor26")

RegisterEvent(31167, "RotatingDoor25", function()
    map.triggerMechanism(1167, 2)
end, "RotatingDoor25")

RegisterEvent(31168, "RotatingDoor23", function()
    map.triggerMechanism(1168, 2)
end, "RotatingDoor23")

RegisterEvent(31169, "RotatingDoor24", function()
    map.triggerMechanism(1169, 2)
end, "RotatingDoor24")

RegisterEvent(31170, "RotatingDoor21", function()
    map.triggerMechanism(1170, 2)
end, "RotatingDoor21")

RegisterEvent(31171, "RotatingDoor22", function()
    map.triggerMechanism(1171, 2)
end, "RotatingDoor22")

RegisterEvent(31173, "Jaildoor", function()
    map.triggerMechanism(1173, 2)
end, "Jaildoor")

RegisterEvent(31175, "MagiL", function()
    map.triggerMechanism(1175, 2)
end, "MagiL")

RegisterEvent(31176, "MagiR", function()
    map.triggerMechanism(1176, 2)
end, "MagiR")

RegisterEvent(31178, "bankdoorL", function()
    map.triggerMechanism(1178, 2)
end, "bankdoorL")

RegisterEvent(31179, "bankdoorR", function()
    map.triggerMechanism(1179, 2)
end, "bankdoorR")

RegisterEvent(31180, "vaultdoor", function()
    map.triggerMechanism(1180, 2)
end, "vaultdoor")

RegisterEvent(31181, "RotatingDoor11", function()
    map.triggerMechanism(1181, 2)
end, "RotatingDoor11")

RegisterEvent(31182, "RotatingDoor20", function()
    map.triggerMechanism(1182, 2)
end, "RotatingDoor20")

RegisterEvent(31183, "RotatingDoor27", function()
    map.triggerMechanism(1183, 2)
end, "RotatingDoor27")

RegisterEvent(31184, "RotatingDoor28", function()
    map.triggerMechanism(1184, 2)
end, "RotatingDoor28")

RegisterEvent(31185, "RotatingDoor29", function()
    map.triggerMechanism(1185, 2)
end, "RotatingDoor29")

RegisterEvent(31186, "RotatingDoor32", function()
    map.triggerMechanism(1186, 2)
end, "RotatingDoor32")

RegisterEvent(31196, "RotatingDoor30", function()
    map.triggerMechanism(1196, 2)
end, "RotatingDoor30")

RegisterEvent(31197, "RotatingDoor31", function()
    map.triggerMechanism(1197, 2)
end, "RotatingDoor31")

RegisterEvent(31198, "RotatingDoor4", function()
    map.triggerMechanism(1198, 2)
end, "RotatingDoor4")

RegisterEvent(31199, "RotatingDoor5", function()
    map.triggerMechanism(1199, 2)
end, "RotatingDoor5")

RegisterEvent(31213, "LibraryR", function()
    map.triggerMechanism(1213, 2)
end, "LibraryR")

RegisterEvent(31214, "LibraryL", function()
    map.triggerMechanism(1214, 2)
end, "LibraryL")

RegisterEvent(31215, "Towngate1L", function()
    map.triggerMechanism(1215, 2)
end, "Towngate1L")

RegisterEvent(31216, "Templegate2L", function()
    map.triggerMechanism(1216, 2)
end, "Templegate2L")

RegisterEvent(31217, "Templegate1L", function()
    map.triggerMechanism(1217, 2)
end, "Templegate1L")

RegisterEvent(31220, "Door34", function()
    map.triggerMechanism(1220, 2)
end, "Door34")

RegisterEvent(31221, "Door33", function()
    map.triggerMechanism(1221, 2)
end, "Door33")

RegisterEvent(31222, "Door32", function()
    map.triggerMechanism(1222, 2)
end, "Door32")

RegisterEvent(31223, "Door31", function()
    map.triggerMechanism(1223, 2)
end, "Door31")

RegisterEvent(31224, "Door30", function()
    map.triggerMechanism(1224, 2)
end, "Door30")

RegisterEvent(31225, "Door29", function()
    map.triggerMechanism(1225, 2)
end, "Door29")

RegisterEvent(31226, "Door28", function()
    map.triggerMechanism(1226, 2)
end, "Door28")

RegisterEvent(31227, "Door26", function()
    map.triggerMechanism(1227, 2)
end, "Door26")

RegisterEvent(31228, "Door25", function()
    map.triggerMechanism(1228, 2)
end, "Door25")

RegisterEvent(31229, "Door24", function()
    map.triggerMechanism(1229, 2)
end, "Door24")

RegisterEvent(31230, "Door21", function()
    map.triggerMechanism(1230, 2)
end, "Door21")

RegisterEvent(31231, "Door20", function()
    map.triggerMechanism(1231, 2)
end, "Door20")

RegisterEvent(31232, "Door19", function()
    map.triggerMechanism(1232, 2)
end, "Door19")

RegisterEvent(31233, "Door18", function()
    map.triggerMechanism(1233, 2)
end, "Door18")

RegisterEvent(31234, "Door17", function()
    map.triggerMechanism(1234, 2)
end, "Door17")

RegisterEvent(31235, "Door16", function()
    map.triggerMechanism(1235, 2)
end, "Door16")

RegisterEvent(31236, "Door15", function()
    map.triggerMechanism(1236, 2)
end, "Door15")

RegisterEvent(31237, "Door14", function()
    map.triggerMechanism(1237, 2)
end, "Door14")

RegisterEvent(31238, "Door13", function()
    map.triggerMechanism(1238, 2)
end, "Door13")

RegisterEvent(31239, "Door12", function()
    map.triggerMechanism(1239, 2)
end, "Door12")

RegisterEvent(31240, "Door11", function()
    map.triggerMechanism(1240, 2)
end, "Door11")

RegisterEvent(31241, "Door9", function()
    map.triggerMechanism(1241, 2)
end, "Door9")

RegisterEvent(31242, "Door8", function()
    map.triggerMechanism(1242, 2)
end, "Door8")

RegisterEvent(31243, "TestHouse1", function()
    map.triggerMechanism(1243, 2)
end, "TestHouse1")

RegisterEvent(31244, "f10doorl", function()
    map.triggerMechanism(1244, 2)
end, "f10doorl")

RegisterEvent(31245, "f10doorr", function()
    map.triggerMechanism(1245, 2)
end, "f10doorr")

RegisterEvent(31246, "f10doorl0", function()
    map.triggerMechanism(1246, 2)
end, "f10doorl0")

RegisterEvent(31247, "f10doorr0", function()
    map.triggerMechanism(1247, 2)
end, "f10doorr0")

RegisterEvent(31248, "Door7", function()
    map.triggerMechanism(1248, 2)
end, "Door7")

RegisterEvent(31249, "Door35", function()
    map.triggerMechanism(1249, 2)
end, "Door35")

RegisterEvent(31250, "Door6", function()
    map.triggerMechanism(1250, 2)
end, "Door6")

RegisterEvent(31251, "Door5", function()
    map.triggerMechanism(1251, 2)
end, "Door5")

RegisterEvent(31252, "Door0", function()
    map.triggerMechanism(1252, 2)
end, "Door0")

RegisterEvent(31253, "Door27", function()
    map.triggerMechanism(1253, 2)
end, "Door27")

RegisterEvent(31254, "Door23", function()
    map.triggerMechanism(1254, 2)
end, "Door23")

RegisterEvent(31255, "PalacedoorL", function()
    map.triggerMechanism(1255, 2)
end, "PalacedoorL")

RegisterEvent(31256, "PalacedoorR", function()
    map.triggerMechanism(1256, 2)
end, "PalacedoorR")

RegisterEvent(31257, "ThronedoorL", function()
    map.triggerMechanism(1257, 2)
end, "ThronedoorL")

RegisterEvent(31258, "ThronedoorR", function()
    map.triggerMechanism(1258, 2)
end, "ThronedoorR")

RegisterEvent(31259, "Backdoor", function()
    map.triggerMechanism(1259, 2)
end, "Backdoor")

RegisterEvent(31260, "Door22", function()
    map.triggerMechanism(1260, 2)
end, "Door22")

RegisterEvent(31261, "Door36", function()
    map.triggerMechanism(1261, 2)
end, "Door36")

RegisterEvent(31262, "Door37", function()
    map.triggerMechanism(1262, 2)
end, "Door37")

RegisterEvent(31263, "Door38", function()
    map.triggerMechanism(1263, 2)
end, "Door38")

RegisterEvent(31275, "Churchdoor2", function()
    map.triggerMechanism(1275, 2)
end, "Churchdoor2")

RegisterEvent(31276, "Churchdoor1", function()
    map.triggerMechanism(1276, 2)
end, "Churchdoor1")

RegisterEvent(31277, "ChurchdoorR", function()
    map.triggerMechanism(1277, 2)
end, "ChurchdoorR")

RegisterEvent(31278, "ChurchdoorL", function()
    map.triggerMechanism(1278, 2)
end, "ChurchdoorL")

RegisterEvent(31294, "RotatingDoor9", function()
    map.triggerMechanism(1294, 2)
end, "RotatingDoor9")

RegisterEvent(31295, "RotatingDoor7", function()
    map.triggerMechanism(1295, 2)
end, "RotatingDoor7")

RegisterEvent(31299, "RotatingDoor18", function()
    map.triggerMechanism(1299, 2)
end, "RotatingDoor18")

RegisterEvent(31300, "RotatingDoor17", function()
    map.triggerMechanism(1300, 2)
end, "RotatingDoor17")

map.scripts["akeretainer.scr"] = {
    source = "AKERETAINER.scr",
    registered_triggers = {
        { line = 52, message = "Use", callback = "Onblabber" },
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
map.scripts["beathag.scr"] = {
    source = "BEATHAG.scr",
    registered_triggers = {
        { line = 69, message = "break", callback = "Onbreak" },
        { line = 70, message = "use", callback = "Onuse" },
    },
    movement_commands = {
    },
}
map.scripts["bjarni.scr"] = {
    source = "BJARNI.scr",
    registered_triggers = {
        { line = 241, message = "Use", callback = "OnUse" },
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
map.scripts["erccspeech.scr"] = {
    source = "ERCCSPEECH.scr",
    registered_triggers = {
        { line = 85, message = "Blabber", callback = "OnBlabber" },
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
map.scripts["ludwigvan.scr"] = {
    source = "LUDWIGVAN.scr",
    registered_triggers = {
        { line = 63, message = "Use", callback = "OnUse" },
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
map.scripts["npc48.scr"] = {
    source = "NPC48.scr",
    registered_triggers = {
        { line = 160, message = "Use", callback = "Onblabber" },
        { line = 161, message = "Start", callback = "OnWander" },
        { line = 162, message = "GoHome", callback = "OnHome" },
        { line = 163, message = "GotoJail", callback = "OnJail" },
    },
    movement_commands = {
        { line = 138, command = "setpos", arguments = "g_hmyobject xPos yPos zPos" },
    },
}
map.scripts["npc49.scr"] = {
    source = "NPC49.scr",
    registered_triggers = {
        { line = 51, message = "Use", callback = "Onblabber" },
    },
    movement_commands = {
        { line = 40, command = "setpos", arguments = "g_hmyobject xPos yPos zPos" },
    },
}
map.scripts["npc50.scr"] = {
    source = "NPC50.scr",
    registered_triggers = {
        { line = 46, message = "Use", callback = "Onblabber" },
    },
    movement_commands = {
    },
}
map.scripts["npc61.scr"] = {
    source = "NPC61.scr",
    registered_triggers = {
        { line = 173, message = "Use", callback = "OnUse" },
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
map.scripts["propanim.scr"] = {
    source = "PROPANIM.scr",
    registered_triggers = {
        { line = 42, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["randverrun.scr"] = {
    source = "RANDVERRUN.scr",
    registered_triggers = {
        { line = 128, message = "run", callback = "OnRudeExit2" },
        { line = 130, message = "use", callback = "Onuse" },
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
map.scripts["spieslikeus.scr"] = {
    source = "SPIESLIKEUS.scr",
    registered_triggers = {
        { line = 52, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["sturmgaardinn.scr"] = {
    source = "STURMGAARDINN.scr",
    registered_triggers = {
        { line = 71, message = "break", callback = "Onbreak" },
        { line = 72, message = "use", callback = "Onuse" },
    },
    movement_commands = {
    },
}
map.scripts["sturmguard.scr"] = {
    source = "STURMGUARD.scr",
    registered_triggers = {
        { line = 80, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
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
map.scripts["tryggvaspeech.scr"] = {
    source = "TRYGGVASPEECH.scr",
    registered_triggers = {
        { line = 115, message = "blabber", callback = "Onblabber" },
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
