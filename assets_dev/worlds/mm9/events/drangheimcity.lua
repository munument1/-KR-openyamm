-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "drangheimcity"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 63,
        source_name = "KlusoWindowExit",
        x = 15340,
        y = -10281,
        z = 2509,
        direction_yaw_units = 0,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 65,
        source_name = "KlusoDoorExit",
        x = 14541,
        y = -8274,
        z = 1659,
        direction_yaw_units = 0,
        move_player_to_floor = true,
    },
    {
        start_index = 2,
        source_object_index = 76,
        source_name = "TownPortal",
        x = 19016,
        y = -5683,
        z = 1720,
        direction_yaw_units = 1950,
        move_player_to_floor = true,
    },
    {
        start_index = 3,
        source_object_index = 83,
        source_name = "StartPoint0",
        x = 10240,
        y = -4178,
        z = 1311,
        direction_yaw_units = 1595,
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
        source_name = "SmithShackDoor",
        kind = "rotating_door",
        hint = "SmithShackDoor",
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
        mechanism_id = 900004,
        event_id = 30004,
        source_object_index = 4,
        source_class = "RotatingDoor",
        source_name = "SmalHouse1Door",
        kind = "rotating_door",
        hint = "SmalHouse1Door",
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
        mechanism_id = 900005,
        event_id = 30005,
        source_object_index = 5,
        source_class = "Ladder",
        source_name = "HouseLadder",
        kind = "ladder_volume",
        hint = "HouseLadder",
    },
    {
        mechanism_id = 900007,
        event_id = 30007,
        source_object_index = 7,
        source_class = "RotatingDoor",
        source_name = "TempleDoorRight",
        kind = "rotating_door",
        hint = "TempleDoorRight",
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
        mechanism_id = 900008,
        event_id = 30008,
        source_object_index = 8,
        source_class = "RotatingDoor",
        source_name = "TempleDoorLeft",
        kind = "rotating_door",
        hint = "TempleDoorLeft",
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
        mechanism_id = 900010,
        event_id = 30010,
        source_object_index = 10,
        source_class = "RotatingDoor",
        source_name = "TempleUpperDoor",
        kind = "rotating_door",
        hint = "TempleUpperDoor",
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
        mechanism_id = 900011,
        event_id = 30011,
        source_object_index = 11,
        source_class = "RotatingDoor",
        source_name = "TownHallDoorRight",
        kind = "rotating_door",
        hint = "TownHallDoorRight",
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
        mechanism_id = 900012,
        event_id = 30012,
        source_object_index = 12,
        source_class = "RotatingDoor",
        source_name = "TownHallDoorLeft",
        kind = "rotating_door",
        hint = "TownHallDoorLeft",
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
        mechanism_id = 900013,
        event_id = 30013,
        source_object_index = 13,
        source_class = "Ladder",
        source_name = "TowerLadder",
        kind = "ladder_volume",
        hint = "TowerLadder",
    },
    {
        mechanism_id = 900016,
        event_id = 30016,
        source_object_index = 16,
        source_class = "RotatingDoor",
        source_name = "TowerDoor",
        kind = "rotating_door",
        hint = "TowerDoor",
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
        mechanism_id = 900021,
        event_id = 30021,
        source_object_index = 21,
        source_class = "RotatingDoor",
        source_name = "MayorHouseDoor3",
        kind = "rotating_door",
        hint = "MayorHouseDoor3",
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
        mechanism_id = 900022,
        event_id = 30022,
        source_object_index = 22,
        source_class = "RotatingDoor",
        source_name = "MayorHouseDoor2",
        kind = "rotating_door",
        hint = "MayorHouseDoor2",
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
        mechanism_id = 900023,
        event_id = 30023,
        source_object_index = 23,
        source_class = "RotatingDoor",
        source_name = "MayorHouseDoor",
        kind = "rotating_door",
        hint = "MayorHouseDoor",
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
        mechanism_id = 900036,
        event_id = 30036,
        source_object_index = 36,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor3",
        kind = "rotating_door",
        hint = "RotatingDoor3",
    },
    {
        mechanism_id = 900037,
        event_id = 30037,
        source_object_index = 37,
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
        mechanism_id = 900038,
        event_id = 30038,
        source_object_index = 38,
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
        mechanism_id = 900039,
        event_id = 30039,
        source_object_index = 39,
        source_class = "RotatingDoor",
        source_name = "StairDoor",
        kind = "rotating_door",
        hint = "StairDoor",
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
        mechanism_id = 900040,
        event_id = 30040,
        source_object_index = 40,
        source_class = "RotatingDoor",
        source_name = "StoreDoor1",
        kind = "rotating_door",
        hint = "StoreDoor1",
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
        mechanism_id = 900041,
        event_id = 30041,
        source_object_index = 41,
        source_class = "RotatingDoor",
        source_name = "StoreDoor2",
        kind = "rotating_door",
        hint = "StoreDoor2",
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
        mechanism_id = 900042,
        event_id = 30042,
        source_object_index = 42,
        source_class = "RotatingDoor",
        source_name = "SettlersDoor",
        kind = "rotating_door",
        hint = "SettlersDoor",
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
        mechanism_id = 900043,
        event_id = 30043,
        source_object_index = 43,
        source_class = "RotatingDoor",
        source_name = "InnDoorRight",
        kind = "rotating_door",
        hint = "InnDoorRight",
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
        mechanism_id = 900044,
        event_id = 30044,
        source_object_index = 44,
        source_class = "RotatingDoor",
        source_name = "InnDoorLeft",
        kind = "rotating_door",
        hint = "InnDoorLeft",
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
        mechanism_id = 900045,
        event_id = 30045,
        source_object_index = 45,
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
                name = "Door/knock.wav",
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
        source_name = "SmalHouse2Door",
        kind = "rotating_door",
        hint = "SmalHouse2Door",
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
        mechanism_id = 900050,
        event_id = 30050,
        source_object_index = 50,
        source_class = "RotatingDoor",
        source_name = "NewHouseDoor1",
        kind = "rotating_door",
        hint = "NewHouseDoor1",
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
        mechanism_id = 900051,
        event_id = 30051,
        source_object_index = 51,
        source_class = "RotatingDoor",
        source_name = "NewHouseDoor0",
        kind = "rotating_door",
        hint = "NewHouseDoor0",
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
        mechanism_id = 900052,
        event_id = 30052,
        source_object_index = 52,
        source_class = "RotatingDoor",
        source_name = "SettlersDoor0",
        kind = "rotating_door",
        hint = "SettlersDoor0",
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
        mechanism_id = 900053,
        event_id = 30053,
        source_object_index = 53,
        source_class = "RotatingDoor",
        source_name = "TrainingDoor1",
        kind = "rotating_door",
        hint = "TrainingDoor1",
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
        mechanism_id = 900054,
        event_id = 30054,
        source_object_index = 54,
        source_class = "RotatingDoor",
        source_name = "TrainingDoor0",
        kind = "rotating_door",
        hint = "TrainingDoor0",
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
        mechanism_id = 900057,
        event_id = 30057,
        source_object_index = 57,
        source_class = "Ladder",
        source_name = "TowerLadder1",
        kind = "ladder_volume",
        hint = "TowerLadder1",
    },
    {
        mechanism_id = 900059,
        event_id = 30059,
        source_object_index = 59,
        source_class = "RotatingDoor",
        source_name = "AlchemistDoorRight",
        kind = "rotating_door",
        hint = "AlchemistDoorRight",
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
        mechanism_id = 900060,
        event_id = 30060,
        source_object_index = 60,
        source_class = "RotatingDoor",
        source_name = "AlchemistDoorLeft",
        kind = "rotating_door",
        hint = "AlchemistDoorLeft",
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
        mechanism_id = 900069,
        event_id = 30069,
        source_object_index = 69,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush8",
        kind = "collision_volume",
        hint = "InvisibleBrush8",
    },
    {
        mechanism_id = 900073,
        event_id = 30073,
        source_object_index = 73,
        source_class = "RotatingDoor",
        source_name = "HouseDoor1",
        kind = "rotating_door",
        hint = "HouseDoor1",
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
        mechanism_id = 900074,
        event_id = 30074,
        source_object_index = 74,
        source_class = "RotatingDoor",
        source_name = "HouseDoor2",
        kind = "rotating_door",
        hint = "HouseDoor2",
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
        mechanism_id = 900075,
        event_id = 30075,
        source_object_index = 75,
        source_class = "ScriptObject",
        source_name = "ScriptObject0",
        kind = "script_object",
        hint = "ScriptObject0",
    },
    {
        mechanism_id = 900090,
        event_id = 30090,
        source_object_index = 90,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 900202,
        event_id = 30202,
        source_object_index = 202,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 900203,
        event_id = 30203,
        source_object_index = 203,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 900605,
        event_id = 30605,
        source_object_index = 605,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900606,
        event_id = 30606,
        source_object_index = 606,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900607,
        event_id = 30607,
        source_object_index = 607,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900624,
        event_id = 30624,
        source_object_index = 624,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush6",
        kind = "collision_volume",
        hint = "InvisibleBrush6",
    },
    {
        mechanism_id = 900628,
        event_id = 30628,
        source_object_index = 628,
        source_class = "RotatingDoor",
        source_name = "BlacksmithDoor0",
        kind = "rotating_door",
        hint = "BlacksmithDoor0",
    },
    {
        mechanism_id = 900629,
        event_id = 30629,
        source_object_index = 629,
        source_class = "RotatingDoor",
        source_name = "BlacksmithDoor1",
        kind = "rotating_door",
        hint = "BlacksmithDoor1",
    },
    {
        mechanism_id = 900634,
        event_id = 30634,
        source_object_index = 634,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900635,
        event_id = 30635,
        source_object_index = 635,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900636,
        event_id = 30636,
        source_object_index = 636,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900637,
        event_id = 30637,
        source_object_index = 637,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900638,
        event_id = 30638,
        source_object_index = 638,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 900639,
        event_id = 30639,
        source_object_index = 639,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 900640,
        event_id = 30640,
        source_object_index = 640,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 900641,
        event_id = 30641,
        source_object_index = 641,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush7",
        kind = "perception_brush",
        hint = "PerceptionBrush7",
    },
    {
        mechanism_id = 900642,
        event_id = 30642,
        source_object_index = 642,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush8",
        kind = "perception_brush",
        hint = "PerceptionBrush8",
    },
    {
        mechanism_id = 900643,
        event_id = 30643,
        source_object_index = 643,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush9",
        kind = "perception_brush",
        hint = "PerceptionBrush9",
    },
    {
        mechanism_id = 900644,
        event_id = 30644,
        source_object_index = 644,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush10",
        kind = "perception_brush",
        hint = "PerceptionBrush10",
    },
    {
        mechanism_id = 900645,
        event_id = 30645,
        source_object_index = 645,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush11",
        kind = "perception_brush",
        hint = "PerceptionBrush11",
    },
    {
        mechanism_id = 900646,
        event_id = 30646,
        source_object_index = 646,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush12",
        kind = "perception_brush",
        hint = "PerceptionBrush12",
    },
    {
        mechanism_id = 900647,
        event_id = 30647,
        source_object_index = 647,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush13",
        kind = "perception_brush",
        hint = "PerceptionBrush13",
    },
    {
        mechanism_id = 900648,
        event_id = 30648,
        source_object_index = 648,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush14",
        kind = "perception_brush",
        hint = "PerceptionBrush14",
    },
    {
        mechanism_id = 900649,
        event_id = 30649,
        source_object_index = 649,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush15",
        kind = "perception_brush",
        hint = "PerceptionBrush15",
    },
    {
        mechanism_id = 900650,
        event_id = 30650,
        source_object_index = 650,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush16",
        kind = "perception_brush",
        hint = "PerceptionBrush16",
    },
    {
        mechanism_id = 900651,
        event_id = 30651,
        source_object_index = 651,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900652,
        event_id = 30652,
        source_object_index = 652,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush12",
        kind = "collision_volume",
        hint = "InvisibleBrush12",
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
    [30000] = { kind = "open_door", source = "mm9_mechanism", targetName = "SmithShackDoor" },
    [30004] = { kind = "open_door", source = "mm9_mechanism", targetName = "SmalHouse1Door" },
    [30007] = { kind = "open_door", source = "mm9_mechanism", targetName = "TempleDoorRight" },
    [30008] = { kind = "open_door", source = "mm9_mechanism", targetName = "TempleDoorLeft" },
    [30010] = { kind = "open_door", source = "mm9_mechanism", targetName = "TempleUpperDoor" },
    [30011] = { kind = "open_door", source = "mm9_mechanism", targetName = "TownHallDoorRight" },
    [30012] = { kind = "open_door", source = "mm9_mechanism", targetName = "TownHallDoorLeft" },
    [30016] = { kind = "open_door", source = "mm9_mechanism", targetName = "TowerDoor" },
    [30021] = { kind = "open_door", source = "mm9_mechanism", targetName = "MayorHouseDoor3" },
    [30022] = { kind = "open_door", source = "mm9_mechanism", targetName = "MayorHouseDoor2" },
    [30023] = { kind = "open_door", source = "mm9_mechanism", targetName = "MayorHouseDoor" },
    [30036] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor3" },
    [30037] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0" },
    [30038] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor2" },
    [30039] = { kind = "open_door", source = "mm9_mechanism", targetName = "StairDoor" },
    [30040] = { kind = "open_door", source = "mm9_mechanism", targetName = "StoreDoor1" },
    [30041] = { kind = "open_door", source = "mm9_mechanism", targetName = "StoreDoor2" },
    [30042] = { kind = "open_door", source = "mm9_mechanism", targetName = "SettlersDoor" },
    [30043] = { kind = "open_door", source = "mm9_mechanism", targetName = "InnDoorRight" },
    [30044] = { kind = "open_door", source = "mm9_mechanism", targetName = "InnDoorLeft" },
    [30045] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor1" },
    [30048] = { kind = "open_door", source = "mm9_mechanism", targetName = "SmalHouse2Door" },
    [30050] = { kind = "open_door", source = "mm9_mechanism", targetName = "NewHouseDoor1" },
    [30051] = { kind = "open_door", source = "mm9_mechanism", targetName = "NewHouseDoor0" },
    [30052] = { kind = "open_door", source = "mm9_mechanism", targetName = "SettlersDoor0" },
    [30053] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrainingDoor1" },
    [30054] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrainingDoor0" },
    [30059] = { kind = "open_door", source = "mm9_mechanism", targetName = "AlchemistDoorRight" },
    [30060] = { kind = "open_door", source = "mm9_mechanism", targetName = "AlchemistDoorLeft" },
    [30073] = { kind = "open_door", source = "mm9_mechanism", targetName = "HouseDoor1" },
    [30074] = { kind = "open_door", source = "mm9_mechanism", targetName = "HouseDoor2" },
    [30628] = { kind = "open_door", source = "mm9_mechanism", targetName = "BlacksmithDoor0" },
    [30629] = { kind = "open_door", source = "mm9_mechanism", targetName = "BlacksmithDoor1" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30000, "SmithShackDoor", function()
    map.triggerMechanism(0, 2)
end, "SmithShackDoor")

RegisterEvent(30004, "SmalHouse1Door", function()
    map.triggerMechanism(4, 2)
end, "SmalHouse1Door")

RegisterEvent(30007, "TempleDoorRight", function()
    map.triggerMechanism(7, 2)
end, "TempleDoorRight")

RegisterEvent(30008, "TempleDoorLeft", function()
    map.triggerMechanism(8, 2)
end, "TempleDoorLeft")

RegisterEvent(30010, "TempleUpperDoor", function()
    map.triggerMechanism(10, 2)
end, "TempleUpperDoor")

RegisterEvent(30011, "TownHallDoorRight", function()
    map.triggerMechanism(11, 2)
end, "TownHallDoorRight")

RegisterEvent(30012, "TownHallDoorLeft", function()
    map.triggerMechanism(12, 2)
end, "TownHallDoorLeft")

RegisterEvent(30016, "TowerDoor", function()
    map.triggerMechanism(16, 2)
end, "TowerDoor")

RegisterEvent(30021, "MayorHouseDoor3", function()
    map.triggerMechanism(21, 2)
end, "MayorHouseDoor3")

RegisterEvent(30022, "MayorHouseDoor2", function()
    map.triggerMechanism(22, 2)
end, "MayorHouseDoor2")

RegisterEvent(30023, "MayorHouseDoor", function()
    map.triggerMechanism(23, 2)
end, "MayorHouseDoor")

RegisterEvent(30036, "RotatingDoor3", function()
    map.triggerMechanism(36, 2)
end, "RotatingDoor3")

RegisterEvent(30037, "RotatingDoor0", function()
    map.triggerMechanism(37, 2)
end, "RotatingDoor0")

RegisterEvent(30038, "RotatingDoor2", function()
    map.triggerMechanism(38, 2)
end, "RotatingDoor2")

RegisterEvent(30039, "StairDoor", function()
    map.triggerMechanism(39, 2)
end, "StairDoor")

RegisterEvent(30040, "StoreDoor1", function()
    map.triggerMechanism(40, 2)
end, "StoreDoor1")

RegisterEvent(30041, "StoreDoor2", function()
    map.triggerMechanism(41, 2)
end, "StoreDoor2")

RegisterEvent(30042, "SettlersDoor", function()
    map.triggerMechanism(42, 2)
end, "SettlersDoor")

RegisterEvent(30043, "InnDoorRight", function()
    map.triggerMechanism(43, 2)
end, "InnDoorRight")

RegisterEvent(30044, "InnDoorLeft", function()
    map.triggerMechanism(44, 2)
end, "InnDoorLeft")

RegisterEvent(30045, "RotatingDoor1", function()
    map.triggerMechanism(45, 2)
end, "RotatingDoor1")

RegisterEvent(30048, "SmalHouse2Door", function()
    map.triggerMechanism(48, 2)
end, "SmalHouse2Door")

RegisterEvent(30050, "NewHouseDoor1", function()
    map.triggerMechanism(50, 2)
end, "NewHouseDoor1")

RegisterEvent(30051, "NewHouseDoor0", function()
    map.triggerMechanism(51, 2)
end, "NewHouseDoor0")

RegisterEvent(30052, "SettlersDoor0", function()
    map.triggerMechanism(52, 2)
end, "SettlersDoor0")

RegisterEvent(30053, "TrainingDoor1", function()
    map.triggerMechanism(53, 2)
end, "TrainingDoor1")

RegisterEvent(30054, "TrainingDoor0", function()
    map.triggerMechanism(54, 2)
end, "TrainingDoor0")

RegisterEvent(30059, "AlchemistDoorRight", function()
    map.triggerMechanism(59, 2)
end, "AlchemistDoorRight")

RegisterEvent(30060, "AlchemistDoorLeft", function()
    map.triggerMechanism(60, 2)
end, "AlchemistDoorLeft")

RegisterEvent(30073, "HouseDoor1", function()
    map.triggerMechanism(73, 2)
end, "HouseDoor1")

RegisterEvent(30074, "HouseDoor2", function()
    map.triggerMechanism(74, 2)
end, "HouseDoor2")

RegisterEvent(30628, "BlacksmithDoor0", function()
    map.triggerMechanism(628, 2)
end, "BlacksmithDoor0")

RegisterEvent(30629, "BlacksmithDoor1", function()
    map.triggerMechanism(629, 2)
end, "BlacksmithDoor1")

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
map.scripts["npc109.scr"] = {
    source = "NPC109.scr",
    registered_triggers = {
        { line = 141, message = "Speak2", callback = "OnSpeak2" },
        { line = 142, message = "Speak4", callback = "OnSpeak4" },
        { line = 143, message = "Speak6", callback = "OnSpeak6" },
        { line = 144, message = "Fight", callback = "OnFight" },
        { line = 145, message = "Target", callback = "OnTarget" },
    },
    movement_commands = {
    },
}
map.scripts["npc110.scr"] = {
    source = "NPC110.scr",
    registered_triggers = {
        { line = 179, message = "Start", callback = "OnStart" },
        { line = 180, message = "Speak3", callback = "OnSpeak3" },
        { line = 181, message = "Speak5", callback = "OnSpeak5" },
        { line = 182, message = "Speak7", callback = "OnSpeak7" },
    },
    movement_commands = {
        { line = 157, command = "setpos", arguments = "g_hmyobject xPos yPos zPos" },
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
map.scripts["npc414.scr"] = {
    source = "NPC414.scr",
    registered_triggers = {
        { line = 98, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc87.scr"] = {
    source = "NPC87.scr",
    registered_triggers = {
        { line = 192, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc88.scr"] = {
    source = "NPC88.scr",
    registered_triggers = {
        { line = 134, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc89.scr"] = {
    source = "NPC89.scr",
    registered_triggers = {
        { line = 132, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc95.scr"] = {
    source = "NPC95.scr",
    registered_triggers = {
        { line = 108, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc96.scr"] = {
    source = "NPC96.scr",
    registered_triggers = {
        { line = 83, message = "Use", callback = "OnUse" },
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

function map.register(ctx)
    if ctx == nil or ctx.registerMm9MapEvents == nil then
        return
    end
    ctx:registerMm9MapEvents(map)
end

return map
