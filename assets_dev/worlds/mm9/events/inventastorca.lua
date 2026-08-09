-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "inventastorca"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 451,
        source_name = "StartPoint0",
        x = 369,
        y = -82,
        z = -732,
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
        source_class = "RotatingDoor",
        source_name = "DresserDoorR8",
        kind = "rotating_door",
        hint = "DresserDoorR8",
    },
    {
        mechanism_id = 900001,
        event_id = 30001,
        source_object_index = 1,
        source_class = "RotatingDoor",
        source_name = "DresserDoorL8",
        kind = "rotating_door",
        hint = "DresserDoorL8",
    },
    {
        mechanism_id = 900002,
        event_id = 30002,
        source_object_index = 2,
        source_class = "Door",
        source_name = "Drawer15",
        kind = "linear_door",
        hint = "Drawer15",
    },
    {
        mechanism_id = 900003,
        event_id = 30003,
        source_object_index = 3,
        source_class = "Door",
        source_name = "Drawer16",
        kind = "linear_door",
        hint = "Drawer16",
    },
    {
        mechanism_id = 900004,
        event_id = 30004,
        source_object_index = 4,
        source_class = "RotatingDoor",
        source_name = "DresserDoorR7",
        kind = "rotating_door",
        hint = "DresserDoorR7",
    },
    {
        mechanism_id = 900005,
        event_id = 30005,
        source_object_index = 5,
        source_class = "RotatingDoor",
        source_name = "DresserDoorL7",
        kind = "rotating_door",
        hint = "DresserDoorL7",
    },
    {
        mechanism_id = 900006,
        event_id = 30006,
        source_object_index = 6,
        source_class = "Door",
        source_name = "Drawer13",
        kind = "linear_door",
        hint = "Drawer13",
    },
    {
        mechanism_id = 900007,
        event_id = 30007,
        source_object_index = 7,
        source_class = "Door",
        source_name = "Drawer14",
        kind = "linear_door",
        hint = "Drawer14",
    },
    {
        mechanism_id = 900008,
        event_id = 30008,
        source_object_index = 8,
        source_class = "RotatingDoor",
        source_name = "DresserDoorR6",
        kind = "rotating_door",
        hint = "DresserDoorR6",
    },
    {
        mechanism_id = 900009,
        event_id = 30009,
        source_object_index = 9,
        source_class = "RotatingDoor",
        source_name = "DresserDoorL6",
        kind = "rotating_door",
        hint = "DresserDoorL6",
    },
    {
        mechanism_id = 900010,
        event_id = 30010,
        source_object_index = 10,
        source_class = "Door",
        source_name = "Drawer11",
        kind = "linear_door",
        hint = "Drawer11",
    },
    {
        mechanism_id = 900011,
        event_id = 30011,
        source_object_index = 11,
        source_class = "Door",
        source_name = "Drawer12",
        kind = "linear_door",
        hint = "Drawer12",
    },
    {
        mechanism_id = 900012,
        event_id = 30012,
        source_object_index = 12,
        source_class = "RotatingDoor",
        source_name = "DresserDoorR5",
        kind = "rotating_door",
        hint = "DresserDoorR5",
    },
    {
        mechanism_id = 900013,
        event_id = 30013,
        source_object_index = 13,
        source_class = "RotatingDoor",
        source_name = "DresserDoorL5",
        kind = "rotating_door",
        hint = "DresserDoorL5",
    },
    {
        mechanism_id = 900014,
        event_id = 30014,
        source_object_index = 14,
        source_class = "Door",
        source_name = "Drawer9",
        kind = "linear_door",
        hint = "Drawer9",
    },
    {
        mechanism_id = 900015,
        event_id = 30015,
        source_object_index = 15,
        source_class = "Door",
        source_name = "Drawer10",
        kind = "linear_door",
        hint = "Drawer10",
    },
    {
        mechanism_id = 900016,
        event_id = 30016,
        source_object_index = 16,
        source_class = "RotatingDoor",
        source_name = "DresserDoorR4",
        kind = "rotating_door",
        hint = "DresserDoorR4",
    },
    {
        mechanism_id = 900017,
        event_id = 30017,
        source_object_index = 17,
        source_class = "RotatingDoor",
        source_name = "DresserDoorL4",
        kind = "rotating_door",
        hint = "DresserDoorL4",
    },
    {
        mechanism_id = 900018,
        event_id = 30018,
        source_object_index = 18,
        source_class = "Door",
        source_name = "Drawer7",
        kind = "linear_door",
        hint = "Drawer7",
    },
    {
        mechanism_id = 900019,
        event_id = 30019,
        source_object_index = 19,
        source_class = "Door",
        source_name = "Drawer8",
        kind = "linear_door",
        hint = "Drawer8",
    },
    {
        mechanism_id = 900020,
        event_id = 30020,
        source_object_index = 20,
        source_class = "RotatingDoor",
        source_name = "DresserDoorR3",
        kind = "rotating_door",
        hint = "DresserDoorR3",
    },
    {
        mechanism_id = 900021,
        event_id = 30021,
        source_object_index = 21,
        source_class = "RotatingDoor",
        source_name = "DresserDoorL3",
        kind = "rotating_door",
        hint = "DresserDoorL3",
    },
    {
        mechanism_id = 900022,
        event_id = 30022,
        source_object_index = 22,
        source_class = "Door",
        source_name = "Drawer5",
        kind = "linear_door",
        hint = "Drawer5",
    },
    {
        mechanism_id = 900023,
        event_id = 30023,
        source_object_index = 23,
        source_class = "Door",
        source_name = "Drawer6",
        kind = "linear_door",
        hint = "Drawer6",
    },
    {
        mechanism_id = 900024,
        event_id = 30024,
        source_object_index = 24,
        source_class = "RotatingDoor",
        source_name = "DresserDoorR2",
        kind = "rotating_door",
        hint = "DresserDoorR2",
    },
    {
        mechanism_id = 900025,
        event_id = 30025,
        source_object_index = 25,
        source_class = "RotatingDoor",
        source_name = "DresserDoorL2",
        kind = "rotating_door",
        hint = "DresserDoorL2",
    },
    {
        mechanism_id = 900026,
        event_id = 30026,
        source_object_index = 26,
        source_class = "Door",
        source_name = "Drawer3",
        kind = "linear_door",
        hint = "Drawer3",
    },
    {
        mechanism_id = 900027,
        event_id = 30027,
        source_object_index = 27,
        source_class = "Door",
        source_name = "Drawer4",
        kind = "linear_door",
        hint = "Drawer4",
    },
    {
        mechanism_id = 900028,
        event_id = 30028,
        source_object_index = 28,
        source_class = "RotatingDoor",
        source_name = "DresserDoorR1",
        kind = "rotating_door",
        hint = "DresserDoorR1",
    },
    {
        mechanism_id = 900029,
        event_id = 30029,
        source_object_index = 29,
        source_class = "RotatingDoor",
        source_name = "DresserDoorL1",
        kind = "rotating_door",
        hint = "DresserDoorL1",
    },
    {
        mechanism_id = 900030,
        event_id = 30030,
        source_object_index = 30,
        source_class = "Door",
        source_name = "Drawer2",
        kind = "linear_door",
        hint = "Drawer2",
    },
    {
        mechanism_id = 900031,
        event_id = 30031,
        source_object_index = 31,
        source_class = "Door",
        source_name = "Drawer1",
        kind = "linear_door",
        hint = "Drawer1",
    },
    {
        mechanism_id = 900032,
        event_id = 30032,
        source_object_index = 32,
        source_class = "Door",
        source_name = "DeskDrawer0",
        kind = "linear_door",
        hint = "DeskDrawer0",
    },
    {
        mechanism_id = 900033,
        event_id = 30033,
        source_object_index = 33,
        source_class = "Door",
        source_name = "DeskDrawer",
        kind = "linear_door",
        hint = "DeskDrawer",
    },
    {
        mechanism_id = 900356,
        event_id = 30356,
        source_object_index = 356,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 900357,
        event_id = 30357,
        source_object_index = 357,
        source_class = "BlueWater",
        source_name = "BlueWater1",
        kind = "water_volume",
        hint = "BlueWater1",
    },
    {
        mechanism_id = 900358,
        event_id = 30358,
        source_object_index = 358,
        source_class = "Door",
        source_name = "LadderDoor",
        kind = "linear_door",
        hint = "LadderDoor",
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
        mechanism_id = 900359,
        event_id = 30359,
        source_object_index = 359,
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
        },
    },
    {
        mechanism_id = 900360,
        event_id = 30360,
        source_object_index = 360,
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
        },
    },
    {
        mechanism_id = 900361,
        event_id = 30361,
        source_object_index = 361,
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
        },
    },
    {
        mechanism_id = 900362,
        event_id = 30362,
        source_object_index = 362,
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
        },
    },
    {
        mechanism_id = 900363,
        event_id = 30363,
        source_object_index = 363,
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
        },
    },
    {
        mechanism_id = 900364,
        event_id = 30364,
        source_object_index = 364,
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
        },
    },
    {
        mechanism_id = 900365,
        event_id = 30365,
        source_object_index = 365,
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
        },
    },
    {
        mechanism_id = 900366,
        event_id = 30366,
        source_object_index = 366,
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
        },
    },
    {
        mechanism_id = 900367,
        event_id = 30367,
        source_object_index = 367,
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
        },
    },
    {
        mechanism_id = 900368,
        event_id = 30368,
        source_object_index = 368,
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
        },
    },
    {
        mechanism_id = 900369,
        event_id = 30369,
        source_object_index = 369,
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
        },
    },
    {
        mechanism_id = 900370,
        event_id = 30370,
        source_object_index = 370,
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
        },
    },
    {
        mechanism_id = 900371,
        event_id = 30371,
        source_object_index = 371,
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
        },
    },
    {
        mechanism_id = 900372,
        event_id = 30372,
        source_object_index = 372,
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
        },
    },
    {
        mechanism_id = 900373,
        event_id = 30373,
        source_object_index = 373,
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
        },
    },
    {
        mechanism_id = 900374,
        event_id = 30374,
        source_object_index = 374,
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
        },
    },
    {
        mechanism_id = 900375,
        event_id = 30375,
        source_object_index = 375,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL12",
        kind = "rotating_door",
        hint = "DoubleDoorL12",
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
        mechanism_id = 900376,
        event_id = 30376,
        source_object_index = 376,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR12",
        kind = "rotating_door",
        hint = "DoubleDoorR12",
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
        mechanism_id = 900377,
        event_id = 30377,
        source_object_index = 377,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL11",
        kind = "rotating_door",
        hint = "DoubleDoorL11",
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
        mechanism_id = 900378,
        event_id = 30378,
        source_object_index = 378,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR11",
        kind = "rotating_door",
        hint = "DoubleDoorR11",
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
        mechanism_id = 900379,
        event_id = 30379,
        source_object_index = 379,
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
        },
    },
    {
        mechanism_id = 900380,
        event_id = 30380,
        source_object_index = 380,
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
        },
    },
    {
        mechanism_id = 900381,
        event_id = 30381,
        source_object_index = 381,
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
        },
    },
    {
        mechanism_id = 900382,
        event_id = 30382,
        source_object_index = 382,
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
        },
    },
    {
        mechanism_id = 900383,
        event_id = 30383,
        source_object_index = 383,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL13",
        kind = "rotating_door",
        hint = "DoubleDoorL13",
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
        mechanism_id = 900384,
        event_id = 30384,
        source_object_index = 384,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR13",
        kind = "rotating_door",
        hint = "DoubleDoorR13",
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
        mechanism_id = 900385,
        event_id = 30385,
        source_object_index = 385,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL14",
        kind = "rotating_door",
        hint = "DoubleDoorL14",
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
        mechanism_id = 900386,
        event_id = 30386,
        source_object_index = 386,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR14",
        kind = "rotating_door",
        hint = "DoubleDoorR14",
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
        mechanism_id = 900420,
        event_id = 30420,
        source_object_index = 420,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush2",
        kind = "destructible_brush",
        hint = "DestructableBrush2",
    },
    {
        mechanism_id = 900421,
        event_id = 30421,
        source_object_index = 421,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush1",
        kind = "destructible_brush",
        hint = "DestructableBrush1",
    },
    {
        mechanism_id = 900422,
        event_id = 30422,
        source_object_index = 422,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush0",
        kind = "destructible_brush",
        hint = "DestructableBrush0",
    },
    {
        mechanism_id = 900423,
        event_id = 30423,
        source_object_index = 423,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush3",
        kind = "destructible_brush",
        hint = "DestructableBrush3",
    },
    {
        mechanism_id = 900425,
        event_id = 30425,
        source_object_index = 425,
        source_class = "Ladder",
        source_name = "Ladder5",
        kind = "ladder_volume",
        hint = "Ladder5",
    },
    {
        mechanism_id = 900426,
        event_id = 30426,
        source_object_index = 426,
        source_class = "RotatingDoor",
        source_name = "FallingBookcase6",
        kind = "rotating_door",
        hint = "FallingBookcase6",
        sounds = {
            ["open_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900427,
        event_id = 30427,
        source_object_index = 427,
        source_class = "Door",
        source_name = "FalseSwitch6",
        kind = "linear_door",
        hint = "FalseSwitch6",
        sounds = {
            ["open_busy"] = {
                name = "PickUpItems/InBackpack/putpaper.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "PickUpItems/InBackpack/putpaper.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900428,
        event_id = 30428,
        source_object_index = 428,
        source_class = "RotatingDoor",
        source_name = "FallingBookcase1",
        kind = "rotating_door",
        hint = "FallingBookcase1",
        sounds = {
            ["open_stop"] = {
                name = "Events/metalbreak01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900429,
        event_id = 30429,
        source_object_index = 429,
        source_class = "Door",
        source_name = "FalseSwitch1",
        kind = "linear_door",
        hint = "FalseSwitch1",
        sounds = {
            ["open_busy"] = {
                name = "PickUpItems/InBackpack/putpaper.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "PickUpItems/InBackpack/putpaper.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900430,
        event_id = 30430,
        source_object_index = 430,
        source_class = "Door",
        source_name = "FallingBookcaseSwitch",
        kind = "linear_door",
        hint = "FallingBookcaseSwitch",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/InBackpack/putpaper.wav",
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
                name = "PickUpItems/InBackpack/putpaper.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900431,
        event_id = 30431,
        source_object_index = 431,
        source_class = "RotatingDoor",
        source_name = "FallingBookcase2",
        kind = "rotating_door",
        hint = "FallingBookcase2",
        sounds = {
            ["open_stop"] = {
                name = "Events/metalbreak01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900432,
        event_id = 30432,
        source_object_index = 432,
        source_class = "Door",
        source_name = "FalseSwitch2",
        kind = "linear_door",
        hint = "FalseSwitch2",
        sounds = {
            ["open_busy"] = {
                name = "PickUpItems/InBackpack/putpaper.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "PickUpItems/InBackpack/putpaper.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900433,
        event_id = 30433,
        source_object_index = 433,
        source_class = "RotatingDoor",
        source_name = "FallingBookcase3",
        kind = "rotating_door",
        hint = "FallingBookcase3",
        sounds = {
            ["open_stop"] = {
                name = "Events/metalbreak01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900434,
        event_id = 30434,
        source_object_index = 434,
        source_class = "Door",
        source_name = "FalseSwitch3",
        kind = "linear_door",
        hint = "FalseSwitch3",
        sounds = {
            ["open_busy"] = {
                name = "PickUpItems/InBackpack/putpaper.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "PickUpItems/InBackpack/putpaper.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900435,
        event_id = 30435,
        source_object_index = 435,
        source_class = "RotatingDoor",
        source_name = "FallingBookcase5",
        kind = "rotating_door",
        hint = "FallingBookcase5",
        sounds = {
            ["open_stop"] = {
                name = "Events/metalbreak01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900436,
        event_id = 30436,
        source_object_index = 436,
        source_class = "Door",
        source_name = "FalseSwitch5",
        kind = "linear_door",
        hint = "FalseSwitch5",
        sounds = {
            ["open_busy"] = {
                name = "PickUpItems/InBackpack/putpaper.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "PickUpItems/InBackpack/putpaper.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900437,
        event_id = 30437,
        source_object_index = 437,
        source_class = "RotatingDoor",
        source_name = "FallingBookcase4",
        kind = "rotating_door",
        hint = "FallingBookcase4",
        sounds = {
            ["open_stop"] = {
                name = "Events/metalbreak01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900438,
        event_id = 30438,
        source_object_index = 438,
        source_class = "Door",
        source_name = "SecretSwitch1",
        kind = "linear_door",
        hint = "SecretSwitch1",
        sounds = {
            ["open_busy"] = {
                name = "PickUpItems/InBackpack/putpaper.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "PickUpItems/InBackpack/putpaper.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900439,
        event_id = 30439,
        source_object_index = 439,
        source_class = "Door",
        source_name = "FalseSwitch4",
        kind = "linear_door",
        hint = "FalseSwitch4",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/InBackpack/putpaper.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/InBackpack/putpaper.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900440,
        event_id = 30440,
        source_object_index = 440,
        source_class = "RotatingDoor",
        source_name = "FBR1",
        kind = "rotating_door",
        hint = "FBR1",
        sounds = {
            ["open_start"] = {
                name = "Events/WoodCreak1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/metalwood01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900441,
        event_id = 30441,
        source_object_index = 441,
        source_class = "RotatingDoor",
        source_name = "FBR2",
        kind = "rotating_door",
        hint = "FBR2",
        sounds = {
            ["open_start"] = {
                name = "Events/WoodCreak1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/metalwood01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900442,
        event_id = 30442,
        source_object_index = 442,
        source_class = "RotatingDoor",
        source_name = "FBR3",
        kind = "rotating_door",
        hint = "FBR3",
        sounds = {
            ["open_start"] = {
                name = "Events/WoodCreak1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/metalwood01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900443,
        event_id = 30443,
        source_object_index = 443,
        source_class = "RotatingDoor",
        source_name = "FBR4",
        kind = "rotating_door",
        hint = "FBR4",
        sounds = {
            ["open_start"] = {
                name = "Events/WoodCreak1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/metalwood01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900444,
        event_id = 30444,
        source_object_index = 444,
        source_class = "RotatingDoor",
        source_name = "FBR5",
        kind = "rotating_door",
        hint = "FBR5",
        sounds = {
            ["open_start"] = {
                name = "Events/WoodCreak1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/metalwood01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900445,
        event_id = 30445,
        source_object_index = 445,
        source_class = "RotatingDoor",
        source_name = "SecretPanel",
        kind = "rotating_door",
        hint = "SecretPanel",
    },
    {
        mechanism_id = 900446,
        event_id = 30446,
        source_object_index = 446,
        source_class = "RotatingDoor",
        source_name = "SecretPanel0",
        kind = "rotating_door",
        hint = "SecretPanel0",
    },
    {
        mechanism_id = 900447,
        event_id = 30447,
        source_object_index = 447,
        source_class = "Door",
        source_name = "SecretSwitch",
        kind = "linear_door",
        hint = "SecretSwitch",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/InBackpack/putpaper.wav",
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
                name = "PickUpItems/InBackpack/putpaper.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900448,
        event_id = 30448,
        source_object_index = 448,
        source_class = "Door",
        source_name = "SecretSwitch0",
        kind = "linear_door",
        hint = "SecretSwitch0",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/InBackpack/putpaper.wav",
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
                name = "PickUpItems/InBackpack/putpaper.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900449,
        event_id = 30449,
        source_object_index = 449,
        source_class = "Door",
        source_name = "SecretPanel1",
        kind = "linear_door",
        hint = "SecretPanel1",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900504,
        event_id = 30504,
        source_object_index = 504,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900541,
        event_id = 30541,
        source_object_index = 541,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900555,
        event_id = 30555,
        source_object_index = 555,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900556,
        event_id = 30556,
        source_object_index = 556,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 900665,
        event_id = 30665,
        source_object_index = 665,
        source_class = "ScriptObject",
        source_name = "SpookObject",
        kind = "script_object",
        hint = "SpookObject",
    },
    {
        mechanism_id = 900670,
        event_id = 30670,
        source_object_index = 670,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush5",
        kind = "destructible_brush",
        hint = "DestructableBrush5",
    },
    {
        mechanism_id = 900671,
        event_id = 30671,
        source_object_index = 671,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush4",
        kind = "destructible_brush",
        hint = "DestructableBrush4",
    },
    {
        mechanism_id = 900683,
        event_id = 30683,
        source_object_index = 683,
        source_class = "BlueWater",
        source_name = "BlueWater2",
        kind = "water_volume",
        hint = "BlueWater2",
    },
    {
        mechanism_id = 900685,
        event_id = 30685,
        source_object_index = 685,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900686,
        event_id = 30686,
        source_object_index = 686,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900687,
        event_id = 30687,
        source_object_index = 687,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900688,
        event_id = 30688,
        source_object_index = 688,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900689,
        event_id = 30689,
        source_object_index = 689,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 900690,
        event_id = 30690,
        source_object_index = 690,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5Level10",
        kind = "perception_brush",
        hint = "PerceptionBrush5Level10",
    },
    {
        mechanism_id = 900691,
        event_id = 30691,
        source_object_index = 691,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 900692,
        event_id = 30692,
        source_object_index = 692,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush7",
        kind = "perception_brush",
        hint = "PerceptionBrush7",
    },
    {
        mechanism_id = 900693,
        event_id = 30693,
        source_object_index = 693,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush8",
        kind = "perception_brush",
        hint = "PerceptionBrush8",
    },
    {
        mechanism_id = 900694,
        event_id = 30694,
        source_object_index = 694,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush9",
        kind = "perception_brush",
        hint = "PerceptionBrush9",
    },
    {
        mechanism_id = 900695,
        event_id = 30695,
        source_object_index = 695,
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
    [30000] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorR8" },
    [30001] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorL8" },
    [30002] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer15" },
    [30003] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer16" },
    [30004] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorR7" },
    [30005] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorL7" },
    [30006] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer13" },
    [30007] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer14" },
    [30008] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorR6" },
    [30009] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorL6" },
    [30010] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer11" },
    [30011] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer12" },
    [30012] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorR5" },
    [30013] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorL5" },
    [30014] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer9" },
    [30015] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer10" },
    [30016] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorR4" },
    [30017] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorL4" },
    [30018] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer7" },
    [30019] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer8" },
    [30020] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorR3" },
    [30021] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorL3" },
    [30022] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer5" },
    [30023] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer6" },
    [30024] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorR2" },
    [30025] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorL2" },
    [30026] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer3" },
    [30027] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer4" },
    [30028] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorR1" },
    [30029] = { kind = "open_door", source = "mm9_mechanism", targetName = "DresserDoorL1" },
    [30030] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer2" },
    [30031] = { kind = "open_door", source = "mm9_mechanism", targetName = "Drawer1" },
    [30032] = { kind = "open_door", source = "mm9_mechanism", targetName = "DeskDrawer0" },
    [30033] = { kind = "open_door", source = "mm9_mechanism", targetName = "DeskDrawer" },
    [30358] = { kind = "open_door", source = "mm9_mechanism", targetName = "LadderDoor" },
    [30359] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL10" },
    [30360] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR10" },
    [30361] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL9" },
    [30362] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR9" },
    [30363] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL8" },
    [30364] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR8" },
    [30365] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL7" },
    [30366] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR7" },
    [30367] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL6" },
    [30368] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR6" },
    [30369] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL5" },
    [30370] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR5" },
    [30371] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL4" },
    [30372] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR4" },
    [30373] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL3" },
    [30374] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR3" },
    [30375] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL12" },
    [30376] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR12" },
    [30377] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL11" },
    [30378] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR11" },
    [30379] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL2" },
    [30380] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR2" },
    [30381] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL1" },
    [30382] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR1" },
    [30383] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL13" },
    [30384] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR13" },
    [30385] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL14" },
    [30386] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR14" },
    [30426] = { kind = "open_door", source = "mm9_mechanism", targetName = "FallingBookcase6" },
    [30427] = { kind = "open_door", source = "mm9_mechanism", targetName = "FalseSwitch6" },
    [30428] = { kind = "open_door", source = "mm9_mechanism", targetName = "FallingBookcase1" },
    [30429] = { kind = "open_door", source = "mm9_mechanism", targetName = "FalseSwitch1" },
    [30430] = { kind = "open_door", source = "mm9_mechanism", targetName = "FallingBookcaseSwitch" },
    [30431] = { kind = "open_door", source = "mm9_mechanism", targetName = "FallingBookcase2" },
    [30432] = { kind = "open_door", source = "mm9_mechanism", targetName = "FalseSwitch2" },
    [30433] = { kind = "open_door", source = "mm9_mechanism", targetName = "FallingBookcase3" },
    [30434] = { kind = "open_door", source = "mm9_mechanism", targetName = "FalseSwitch3" },
    [30435] = { kind = "open_door", source = "mm9_mechanism", targetName = "FallingBookcase5" },
    [30436] = { kind = "open_door", source = "mm9_mechanism", targetName = "FalseSwitch5" },
    [30437] = { kind = "open_door", source = "mm9_mechanism", targetName = "FallingBookcase4" },
    [30438] = { kind = "open_door", source = "mm9_mechanism", targetName = "SecretSwitch1" },
    [30439] = { kind = "open_door", source = "mm9_mechanism", targetName = "FalseSwitch4" },
    [30440] = { kind = "open_door", source = "mm9_mechanism", targetName = "FBR1" },
    [30441] = { kind = "open_door", source = "mm9_mechanism", targetName = "FBR2" },
    [30442] = { kind = "open_door", source = "mm9_mechanism", targetName = "FBR3" },
    [30443] = { kind = "open_door", source = "mm9_mechanism", targetName = "FBR4" },
    [30444] = { kind = "open_door", source = "mm9_mechanism", targetName = "FBR5" },
    [30445] = { kind = "open_door", source = "mm9_mechanism", targetName = "SecretPanel" },
    [30446] = { kind = "open_door", source = "mm9_mechanism", targetName = "SecretPanel0" },
    [30447] = { kind = "open_door", source = "mm9_mechanism", targetName = "SecretSwitch" },
    [30448] = { kind = "open_door", source = "mm9_mechanism", targetName = "SecretSwitch0" },
    [30449] = { kind = "open_door", source = "mm9_mechanism", targetName = "SecretPanel1" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30000, "DresserDoorR8", function()
    map.triggerMechanism(0, 2)
end, "DresserDoorR8")

RegisterEvent(30001, "DresserDoorL8", function()
    map.triggerMechanism(1, 2)
end, "DresserDoorL8")

RegisterEvent(30002, "Drawer15", function()
    map.triggerMechanism(2, 2)
end, "Drawer15")

RegisterEvent(30003, "Drawer16", function()
    map.triggerMechanism(3, 2)
end, "Drawer16")

RegisterEvent(30004, "DresserDoorR7", function()
    map.triggerMechanism(4, 2)
end, "DresserDoorR7")

RegisterEvent(30005, "DresserDoorL7", function()
    map.triggerMechanism(5, 2)
end, "DresserDoorL7")

RegisterEvent(30006, "Drawer13", function()
    map.triggerMechanism(6, 2)
end, "Drawer13")

RegisterEvent(30007, "Drawer14", function()
    map.triggerMechanism(7, 2)
end, "Drawer14")

RegisterEvent(30008, "DresserDoorR6", function()
    map.triggerMechanism(8, 2)
end, "DresserDoorR6")

RegisterEvent(30009, "DresserDoorL6", function()
    map.triggerMechanism(9, 2)
end, "DresserDoorL6")

RegisterEvent(30010, "Drawer11", function()
    map.triggerMechanism(10, 2)
end, "Drawer11")

RegisterEvent(30011, "Drawer12", function()
    map.triggerMechanism(11, 2)
end, "Drawer12")

RegisterEvent(30012, "DresserDoorR5", function()
    map.triggerMechanism(12, 2)
end, "DresserDoorR5")

RegisterEvent(30013, "DresserDoorL5", function()
    map.triggerMechanism(13, 2)
end, "DresserDoorL5")

RegisterEvent(30014, "Drawer9", function()
    map.triggerMechanism(14, 2)
end, "Drawer9")

RegisterEvent(30015, "Drawer10", function()
    map.triggerMechanism(15, 2)
end, "Drawer10")

RegisterEvent(30016, "DresserDoorR4", function()
    map.triggerMechanism(16, 2)
end, "DresserDoorR4")

RegisterEvent(30017, "DresserDoorL4", function()
    map.triggerMechanism(17, 2)
end, "DresserDoorL4")

RegisterEvent(30018, "Drawer7", function()
    map.triggerMechanism(18, 2)
end, "Drawer7")

RegisterEvent(30019, "Drawer8", function()
    map.triggerMechanism(19, 2)
end, "Drawer8")

RegisterEvent(30020, "DresserDoorR3", function()
    map.triggerMechanism(20, 2)
end, "DresserDoorR3")

RegisterEvent(30021, "DresserDoorL3", function()
    map.triggerMechanism(21, 2)
end, "DresserDoorL3")

RegisterEvent(30022, "Drawer5", function()
    map.triggerMechanism(22, 2)
end, "Drawer5")

RegisterEvent(30023, "Drawer6", function()
    map.triggerMechanism(23, 2)
end, "Drawer6")

RegisterEvent(30024, "DresserDoorR2", function()
    map.triggerMechanism(24, 2)
end, "DresserDoorR2")

RegisterEvent(30025, "DresserDoorL2", function()
    map.triggerMechanism(25, 2)
end, "DresserDoorL2")

RegisterEvent(30026, "Drawer3", function()
    map.triggerMechanism(26, 2)
end, "Drawer3")

RegisterEvent(30027, "Drawer4", function()
    map.triggerMechanism(27, 2)
end, "Drawer4")

RegisterEvent(30028, "DresserDoorR1", function()
    map.triggerMechanism(28, 2)
end, "DresserDoorR1")

RegisterEvent(30029, "DresserDoorL1", function()
    map.triggerMechanism(29, 2)
end, "DresserDoorL1")

RegisterEvent(30030, "Drawer2", function()
    map.triggerMechanism(30, 2)
end, "Drawer2")

RegisterEvent(30031, "Drawer1", function()
    map.triggerMechanism(31, 2)
end, "Drawer1")

RegisterEvent(30032, "DeskDrawer0", function()
    map.triggerMechanism(32, 2)
end, "DeskDrawer0")

RegisterEvent(30033, "DeskDrawer", function()
    map.triggerMechanism(33, 2)
end, "DeskDrawer")

RegisterEvent(30358, "LadderDoor", function()
    map.triggerMechanism(358, 2)
end, "LadderDoor")

RegisterEvent(30359, "DoubleDoorL10", function()
    map.triggerMechanism(359, 2)
end, "DoubleDoorL10")

RegisterEvent(30360, "DoubleDoorR10", function()
    map.triggerMechanism(360, 2)
end, "DoubleDoorR10")

RegisterEvent(30361, "DoubleDoorL9", function()
    map.triggerMechanism(361, 2)
end, "DoubleDoorL9")

RegisterEvent(30362, "DoubleDoorR9", function()
    map.triggerMechanism(362, 2)
end, "DoubleDoorR9")

RegisterEvent(30363, "DoubleDoorL8", function()
    map.triggerMechanism(363, 2)
end, "DoubleDoorL8")

RegisterEvent(30364, "DoubleDoorR8", function()
    map.triggerMechanism(364, 2)
end, "DoubleDoorR8")

RegisterEvent(30365, "DoubleDoorL7", function()
    map.triggerMechanism(365, 2)
end, "DoubleDoorL7")

RegisterEvent(30366, "DoubleDoorR7", function()
    map.triggerMechanism(366, 2)
end, "DoubleDoorR7")

RegisterEvent(30367, "DoubleDoorL6", function()
    map.triggerMechanism(367, 2)
end, "DoubleDoorL6")

RegisterEvent(30368, "DoubleDoorR6", function()
    map.triggerMechanism(368, 2)
end, "DoubleDoorR6")

RegisterEvent(30369, "DoubleDoorL5", function()
    map.triggerMechanism(369, 2)
end, "DoubleDoorL5")

RegisterEvent(30370, "DoubleDoorR5", function()
    map.triggerMechanism(370, 2)
end, "DoubleDoorR5")

RegisterEvent(30371, "DoubleDoorL4", function()
    map.triggerMechanism(371, 2)
end, "DoubleDoorL4")

RegisterEvent(30372, "DoubleDoorR4", function()
    map.triggerMechanism(372, 2)
end, "DoubleDoorR4")

RegisterEvent(30373, "DoubleDoorL3", function()
    map.triggerMechanism(373, 2)
end, "DoubleDoorL3")

RegisterEvent(30374, "DoubleDoorR3", function()
    map.triggerMechanism(374, 2)
end, "DoubleDoorR3")

RegisterEvent(30375, "DoubleDoorL12", function()
    map.triggerMechanism(375, 2)
end, "DoubleDoorL12")

RegisterEvent(30376, "DoubleDoorR12", function()
    map.triggerMechanism(376, 2)
end, "DoubleDoorR12")

RegisterEvent(30377, "DoubleDoorL11", function()
    map.triggerMechanism(377, 2)
end, "DoubleDoorL11")

RegisterEvent(30378, "DoubleDoorR11", function()
    map.triggerMechanism(378, 2)
end, "DoubleDoorR11")

RegisterEvent(30379, "DoubleDoorL2", function()
    map.triggerMechanism(379, 2)
end, "DoubleDoorL2")

RegisterEvent(30380, "DoubleDoorR2", function()
    map.triggerMechanism(380, 2)
end, "DoubleDoorR2")

RegisterEvent(30381, "DoubleDoorL1", function()
    map.triggerMechanism(381, 2)
end, "DoubleDoorL1")

RegisterEvent(30382, "DoubleDoorR1", function()
    map.triggerMechanism(382, 2)
end, "DoubleDoorR1")

RegisterEvent(30383, "DoubleDoorL13", function()
    map.triggerMechanism(383, 2)
end, "DoubleDoorL13")

RegisterEvent(30384, "DoubleDoorR13", function()
    map.triggerMechanism(384, 2)
end, "DoubleDoorR13")

RegisterEvent(30385, "DoubleDoorL14", function()
    map.triggerMechanism(385, 2)
end, "DoubleDoorL14")

RegisterEvent(30386, "DoubleDoorR14", function()
    map.triggerMechanism(386, 2)
end, "DoubleDoorR14")

RegisterEvent(30426, "FallingBookcase6", function()
    map.triggerMechanism(426, 2)
end, "FallingBookcase6")

RegisterEvent(30427, "FalseSwitch6", function()
    map.triggerMechanism(427, 2)
end, "FalseSwitch6")

RegisterEvent(30428, "FallingBookcase1", function()
    map.triggerMechanism(428, 2)
end, "FallingBookcase1")

RegisterEvent(30429, "FalseSwitch1", function()
    map.triggerMechanism(429, 2)
end, "FalseSwitch1")

RegisterEvent(30430, "FallingBookcaseSwitch", function()
    map.triggerMechanism(430, 2)
end, "FallingBookcaseSwitch")

RegisterEvent(30431, "FallingBookcase2", function()
    map.triggerMechanism(431, 2)
end, "FallingBookcase2")

RegisterEvent(30432, "FalseSwitch2", function()
    map.triggerMechanism(432, 2)
end, "FalseSwitch2")

RegisterEvent(30433, "FallingBookcase3", function()
    map.triggerMechanism(433, 2)
end, "FallingBookcase3")

RegisterEvent(30434, "FalseSwitch3", function()
    map.triggerMechanism(434, 2)
end, "FalseSwitch3")

RegisterEvent(30435, "FallingBookcase5", function()
    map.triggerMechanism(435, 2)
end, "FallingBookcase5")

RegisterEvent(30436, "FalseSwitch5", function()
    map.triggerMechanism(436, 2)
end, "FalseSwitch5")

RegisterEvent(30437, "FallingBookcase4", function()
    map.triggerMechanism(437, 2)
end, "FallingBookcase4")

RegisterEvent(30438, "SecretSwitch1", function()
    map.triggerMechanism(438, 2)
end, "SecretSwitch1")

RegisterEvent(30439, "FalseSwitch4", function()
    map.triggerMechanism(439, 2)
end, "FalseSwitch4")

RegisterEvent(30440, "FBR1", function()
    map.triggerMechanism(440, 2)
end, "FBR1")

RegisterEvent(30441, "FBR2", function()
    map.triggerMechanism(441, 2)
end, "FBR2")

RegisterEvent(30442, "FBR3", function()
    map.triggerMechanism(442, 2)
end, "FBR3")

RegisterEvent(30443, "FBR4", function()
    map.triggerMechanism(443, 2)
end, "FBR4")

RegisterEvent(30444, "FBR5", function()
    map.triggerMechanism(444, 2)
end, "FBR5")

RegisterEvent(30445, "SecretPanel", function()
    map.triggerMechanism(445, 2)
end, "SecretPanel")

RegisterEvent(30446, "SecretPanel0", function()
    map.triggerMechanism(446, 2)
end, "SecretPanel0")

RegisterEvent(30447, "SecretSwitch", function()
    map.triggerMechanism(447, 2)
end, "SecretSwitch")

RegisterEvent(30448, "SecretSwitch0", function()
    map.triggerMechanism(448, 2)
end, "SecretSwitch0")

RegisterEvent(30449, "SecretPanel1", function()
    map.triggerMechanism(449, 2)
end, "SecretPanel1")

map.scripts["bookletter.scr"] = {
    source = "BOOKLETTER.scr",
    registered_triggers = {
        { line = 74, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["greenparty.scr"] = {
    source = "GREENPARTY.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["is_dyingnpc.scr"] = {
    source = "IS_DYINGNPC.scr",
    registered_triggers = {
        { line = 24, message = "Die", callback = "NpcDie" },
    },
    movement_commands = {
    },
}
map.scripts["is_ficky.scr"] = {
    source = "IS_FICKY.scr",
    registered_triggers = {
        { line = 89, message = "Scatter", callback = "scatter" },
    },
    movement_commands = {
    },
}
map.scripts["is_fickyflock.scr"] = {
    source = "IS_FICKYFLOCK.scr",
    registered_triggers = {
        { line = 120, message = "Go", callback = "Go" },
    },
    movement_commands = {
    },
}
map.scripts["is_killinglich.scr"] = {
    source = "IS_KILLINGLICH.scr",
    registered_triggers = {
        { line = 32, message = "Kill", callback = "KillNpc" },
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
map.scripts["orb.scr"] = {
    source = "ORB.scr",
    registered_triggers = {
        { line = 49, message = "use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["scurrycreature.scr"] = {
    source = "SCURRYCREATURE.scr",
    registered_triggers = {
        { line = 38, message = "Hide", callback = "GoHide" },
    },
    movement_commands = {
    },
}
map.scripts["spook.scr"] = {
    source = "SPOOK.scr",
    registered_triggers = {
        { line = 63, message = "Play", callback = "PlaySound" },
        { line = 64, message = "PlayHere", callback = "PlaySoundHere" },
        { line = 65, message = "RandomOff", callback = "TurnRandomOff" },
        { line = 66, message = "RandomOn", callback = "TurnRandomOn" },
        { line = 67, message = "On", callback = "TurnOn" },
        { line = 68, message = "Off", callback = "TurnOff" },
    },
    movement_commands = {
        { line = 126, command = "SetPOS", arguments = "hMe, x,y,z" },
    },
}

function map.register(ctx)
    if ctx == nil or ctx.registerMm9MapEvents == nil then
        return
    end
    ctx:registerMm9MapEvents(map)
end

return map
