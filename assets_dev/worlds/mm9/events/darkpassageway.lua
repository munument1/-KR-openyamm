-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "darkpassageway"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 334,
        source_name = "StartPoint",
        x = -18995,
        y = 1393,
        z = 297,
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
        source_class = "Door",
        source_name = "ExitRoomTempleDoor0",
        kind = "linear_door",
        hint = "ExitRoomTempleDoor0",
    },
    {
        mechanism_id = 900001,
        event_id = 30001,
        source_object_index = 1,
        source_class = "Door",
        source_name = "ExitRoomTempleDoor1",
        kind = "linear_door",
        hint = "ExitRoomTempleDoor1",
    },
    {
        mechanism_id = 900003,
        event_id = 30003,
        source_object_index = 3,
        source_class = "Ladder",
        source_name = "Ladder5",
        kind = "ladder_volume",
        hint = "Ladder5",
    },
    {
        mechanism_id = 900004,
        event_id = 30004,
        source_object_index = 4,
        source_class = "RotatingDoor",
        source_name = "SpikeDoor3",
        kind = "rotating_door",
        hint = "SpikeDoor3",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
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
        source_class = "RotatingDoor",
        source_name = "SpikeDoor1",
        kind = "rotating_door",
        hint = "SpikeDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
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
        source_class = "RotatingDoor",
        source_name = "SpikeDoor2",
        kind = "rotating_door",
        hint = "SpikeDoor2",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
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
        source_class = "RotatingDoor",
        source_name = "SpikeDoor4",
        kind = "rotating_door",
        hint = "SpikeDoor4",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
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
        source_name = "Door7",
        kind = "rotating_door",
        hint = "Door7",
    },
    {
        mechanism_id = 900011,
        event_id = 30011,
        source_object_index = 11,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL28",
        kind = "rotating_door",
        hint = "DoubleDoorL28",
    },
    {
        mechanism_id = 900012,
        event_id = 30012,
        source_object_index = 12,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR28",
        kind = "rotating_door",
        hint = "DoubleDoorR28",
    },
    {
        mechanism_id = 900013,
        event_id = 30013,
        source_object_index = 13,
        source_class = "Door",
        source_name = "DesertRoomDoor1",
        kind = "linear_door",
        hint = "DesertRoomDoor1",
    },
    {
        mechanism_id = 900014,
        event_id = 30014,
        source_object_index = 14,
        source_class = "Door",
        source_name = "DoubleDoorL40",
        kind = "linear_door",
        hint = "DoubleDoorL40",
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
        mechanism_id = 900015,
        event_id = 30015,
        source_object_index = 15,
        source_class = "Door",
        source_name = "DoubleDoorR40",
        kind = "linear_door",
        hint = "DoubleDoorR40",
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
        mechanism_id = 900016,
        event_id = 30016,
        source_object_index = 16,
        source_class = "RotatingDoor",
        source_name = "Painting",
        kind = "rotating_door",
        hint = "Painting",
        sounds = {
            ["open_start"] = {
                name = "Door/DoorSlideStone.wav",
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
        },
    },
    {
        mechanism_id = 900017,
        event_id = 30017,
        source_object_index = 17,
        source_class = "Door",
        source_name = "MountainForestDoor",
        kind = "linear_door",
        hint = "MountainForestDoor",
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
        mechanism_id = 900018,
        event_id = 30018,
        source_object_index = 18,
        source_class = "Door",
        source_name = "Door0",
        kind = "linear_door",
        hint = "Door0",
    },
    {
        mechanism_id = 900019,
        event_id = 30019,
        source_object_index = 19,
        source_class = "Door",
        source_name = "ExitRoomDoor",
        kind = "linear_door",
        hint = "ExitRoomDoor",
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
        mechanism_id = 900020,
        event_id = 30020,
        source_object_index = 20,
        source_class = "Door",
        source_name = "TrapRoomDoor1",
        kind = "linear_door",
        hint = "TrapRoomDoor1",
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
        mechanism_id = 900021,
        event_id = 30021,
        source_object_index = 21,
        source_class = "Door",
        source_name = "TrapRoomDoor2",
        kind = "linear_door",
        hint = "TrapRoomDoor2",
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
        mechanism_id = 900062,
        event_id = 30062,
        source_object_index = 62,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 900069,
        event_id = 30069,
        source_object_index = 69,
        source_class = "Ladder",
        source_name = "Ladder0",
        kind = "ladder_volume",
        hint = "Ladder0",
    },
    {
        mechanism_id = 900072,
        event_id = 30072,
        source_object_index = 72,
        source_class = "Door",
        source_name = "FlameCage",
        kind = "linear_door",
        hint = "FlameCage",
    },
    {
        mechanism_id = 900090,
        event_id = 30090,
        source_object_index = 90,
        source_class = "InvisibleBrush",
        source_name = "WorldObject4",
        kind = "collision_volume",
        hint = "WorldObject4",
    },
    {
        mechanism_id = 900091,
        event_id = 30091,
        source_object_index = 91,
        source_class = "InvisibleBrush",
        source_name = "WorldObject5",
        kind = "collision_volume",
        hint = "WorldObject5",
    },
    {
        mechanism_id = 900092,
        event_id = 30092,
        source_object_index = 92,
        source_class = "InvisibleBrush",
        source_name = "WorldObject2",
        kind = "collision_volume",
        hint = "WorldObject2",
    },
    {
        mechanism_id = 900093,
        event_id = 30093,
        source_object_index = 93,
        source_class = "InvisibleBrush",
        source_name = "WorldObject3",
        kind = "collision_volume",
        hint = "WorldObject3",
    },
    {
        mechanism_id = 900273,
        event_id = 30273,
        source_object_index = 273,
        source_class = "BlueWater",
        source_name = "Ocean",
        kind = "water_volume",
        hint = "Ocean",
    },
    {
        mechanism_id = 900275,
        event_id = 30275,
        source_object_index = 275,
        source_class = "Door",
        source_name = "ExitRamp",
        kind = "linear_door",
        hint = "ExitRamp",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900277,
        event_id = 30277,
        source_object_index = 277,
        source_class = "Door",
        source_name = "ExitRiser",
        kind = "linear_door",
        hint = "ExitRiser",
    },
    {
        mechanism_id = 900288,
        event_id = 30288,
        source_object_index = 288,
        source_class = "Ladder",
        source_name = "Ladder1",
        kind = "ladder_volume",
        hint = "Ladder1",
    },
    {
        mechanism_id = 900305,
        event_id = 30305,
        source_object_index = 305,
        source_class = "ScriptObject",
        source_name = "PuzzleManager0",
        kind = "script_object",
        hint = "PuzzleManager0",
    },
    {
        mechanism_id = 900306,
        event_id = 30306,
        source_object_index = 306,
        source_class = "Door",
        source_name = "TeleportDoor0",
        kind = "linear_door",
        hint = "TeleportDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/metaldoorslide02.wav",
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
        mechanism_id = 900309,
        event_id = 30309,
        source_object_index = 309,
        source_class = "Shooter",
        source_name = "BansheeAEye0",
        kind = "shooter",
        hint = "BansheeAEye0",
    },
    {
        mechanism_id = 900310,
        event_id = 30310,
        source_object_index = 310,
        source_class = "Shooter",
        source_name = "BansheeAEye1",
        kind = "shooter",
        hint = "BansheeAEye1",
    },
    {
        mechanism_id = 900311,
        event_id = 30311,
        source_object_index = 311,
        source_class = "Shooter",
        source_name = "BansheeAEye2",
        kind = "shooter",
        hint = "BansheeAEye2",
    },
    {
        mechanism_id = 900312,
        event_id = 30312,
        source_object_index = 312,
        source_class = "Shooter",
        source_name = "BansheeAEye3",
        kind = "shooter",
        hint = "BansheeAEye3",
    },
    {
        mechanism_id = 900313,
        event_id = 30313,
        source_object_index = 313,
        source_class = "Shooter",
        source_name = "BansheeAEye4",
        kind = "shooter",
        hint = "BansheeAEye4",
    },
    {
        mechanism_id = 900314,
        event_id = 30314,
        source_object_index = 314,
        source_class = "Shooter",
        source_name = "BansheeAEye5",
        kind = "shooter",
        hint = "BansheeAEye5",
    },
    {
        mechanism_id = 900315,
        event_id = 30315,
        source_object_index = 315,
        source_class = "Shooter",
        source_name = "BansheeAEye6",
        kind = "shooter",
        hint = "BansheeAEye6",
    },
    {
        mechanism_id = 900316,
        event_id = 30316,
        source_object_index = 316,
        source_class = "Shooter",
        source_name = "BansheeAEye7",
        kind = "shooter",
        hint = "BansheeAEye7",
    },
    {
        mechanism_id = 900317,
        event_id = 30317,
        source_object_index = 317,
        source_class = "Door",
        source_name = "CanyonDoorL0",
        kind = "linear_door",
        hint = "CanyonDoorL0",
    },
    {
        mechanism_id = 900318,
        event_id = 30318,
        source_object_index = 318,
        source_class = "Door",
        source_name = "CanyonDoorR0",
        kind = "linear_door",
        hint = "CanyonDoorR0",
    },
    {
        mechanism_id = 900326,
        event_id = 30326,
        source_object_index = 326,
        source_class = "Door",
        source_name = "TeleportDoor1",
        kind = "linear_door",
        hint = "TeleportDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/metaldoorslide02.wav",
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
        mechanism_id = 900328,
        event_id = 30328,
        source_object_index = 328,
        source_class = "Door",
        source_name = "ForestDoor0",
        kind = "linear_door",
        hint = "ForestDoor0",
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
        mechanism_id = 900332,
        event_id = 30332,
        source_object_index = 332,
        source_class = "DestructableBrush",
        source_name = "DB_TeleporterCage0",
        kind = "destructible_brush",
        hint = "DB_TeleporterCage0",
    },
    {
        mechanism_id = 900335,
        event_id = 30335,
        source_object_index = 335,
        source_class = "Shooter",
        source_name = "GemLight0",
        kind = "shooter",
        hint = "GemLight0",
    },
    {
        mechanism_id = 900337,
        event_id = 30337,
        source_object_index = 337,
        source_class = "Door",
        source_name = "DesertDoor0",
        kind = "linear_door",
        hint = "DesertDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/metaldoorslide02.wav",
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
        },
    },
    {
        mechanism_id = 900342,
        event_id = 30342,
        source_object_index = 342,
        source_class = "Shooter",
        source_name = "LightBeam0",
        kind = "shooter",
        hint = "LightBeam0",
    },
    {
        mechanism_id = 900343,
        event_id = 30343,
        source_object_index = 343,
        source_class = "Shooter",
        source_name = "LightBeam1",
        kind = "shooter",
        hint = "LightBeam1",
    },
    {
        mechanism_id = 900344,
        event_id = 30344,
        source_object_index = 344,
        source_class = "Shooter",
        source_name = "LightBeam2",
        kind = "shooter",
        hint = "LightBeam2",
    },
    {
        mechanism_id = 900345,
        event_id = 30345,
        source_object_index = 345,
        source_class = "Shooter",
        source_name = "LightBeam3",
        kind = "shooter",
        hint = "LightBeam3",
    },
    {
        mechanism_id = 900530,
        event_id = 30530,
        source_object_index = 530,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900531,
        event_id = 30531,
        source_object_index = 531,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900532,
        event_id = 30532,
        source_object_index = 532,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900533,
        event_id = 30533,
        source_object_index = 533,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900535,
        event_id = 30535,
        source_object_index = 535,
        source_class = "ScriptObject",
        source_name = "SpawnNjam0",
        kind = "script_object",
        hint = "SpawnNjam0",
    },
    {
        mechanism_id = 900570,
        event_id = 30570,
        source_object_index = 570,
        source_class = "Door",
        source_name = "Door1",
        kind = "linear_door",
        hint = "Door1",
    },
    {
        mechanism_id = 900571,
        event_id = 30571,
        source_object_index = 571,
        source_class = "Door",
        source_name = "Door2",
        kind = "linear_door",
        hint = "Door2",
    },
    {
        mechanism_id = 900572,
        event_id = 30572,
        source_object_index = 572,
        source_class = "Door",
        source_name = "Door3",
        kind = "linear_door",
        hint = "Door3",
    },
    {
        mechanism_id = 900573,
        event_id = 30573,
        source_object_index = 573,
        source_class = "Door",
        source_name = "Door4",
        kind = "linear_door",
        hint = "Door4",
    },
    {
        mechanism_id = 900574,
        event_id = 30574,
        source_object_index = 574,
        source_class = "Door",
        source_name = "Door5",
        kind = "linear_door",
        hint = "Door5",
    },
    {
        mechanism_id = 900575,
        event_id = 30575,
        source_object_index = 575,
        source_class = "Door",
        source_name = "Door6",
        kind = "linear_door",
        hint = "Door6",
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
    [30000] = { kind = "open_door", source = "mm9_mechanism", targetName = "ExitRoomTempleDoor0" },
    [30001] = { kind = "open_door", source = "mm9_mechanism", targetName = "ExitRoomTempleDoor1" },
    [30004] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeDoor3" },
    [30005] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeDoor1" },
    [30006] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeDoor2" },
    [30007] = { kind = "open_door", source = "mm9_mechanism", targetName = "SpikeDoor4" },
    [30010] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door7" },
    [30011] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL28" },
    [30012] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR28" },
    [30013] = { kind = "open_door", source = "mm9_mechanism", targetName = "DesertRoomDoor1" },
    [30014] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL40" },
    [30015] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR40" },
    [30016] = { kind = "open_door", source = "mm9_mechanism", targetName = "Painting" },
    [30017] = { kind = "open_door", source = "mm9_mechanism", targetName = "MountainForestDoor" },
    [30018] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door0" },
    [30019] = { kind = "open_door", source = "mm9_mechanism", targetName = "ExitRoomDoor" },
    [30020] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrapRoomDoor1" },
    [30021] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrapRoomDoor2" },
    [30072] = { kind = "open_door", source = "mm9_mechanism", targetName = "FlameCage" },
    [30275] = { kind = "open_door", source = "mm9_mechanism", targetName = "ExitRamp" },
    [30277] = { kind = "open_door", source = "mm9_mechanism", targetName = "ExitRiser" },
    [30306] = { kind = "open_door", source = "mm9_mechanism", targetName = "TeleportDoor0" },
    [30317] = { kind = "open_door", source = "mm9_mechanism", targetName = "CanyonDoorL0" },
    [30318] = { kind = "open_door", source = "mm9_mechanism", targetName = "CanyonDoorR0" },
    [30326] = { kind = "open_door", source = "mm9_mechanism", targetName = "TeleportDoor1" },
    [30328] = { kind = "open_door", source = "mm9_mechanism", targetName = "ForestDoor0" },
    [30337] = { kind = "open_door", source = "mm9_mechanism", targetName = "DesertDoor0" },
    [30570] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1" },
    [30571] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door2" },
    [30572] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door3" },
    [30573] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door4" },
    [30574] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door5" },
    [30575] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door6" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30000, "ExitRoomTempleDoor0", function()
    map.triggerMechanism(0, 2)
end, "ExitRoomTempleDoor0")

RegisterEvent(30001, "ExitRoomTempleDoor1", function()
    map.triggerMechanism(1, 2)
end, "ExitRoomTempleDoor1")

RegisterEvent(30004, "SpikeDoor3", function()
    map.triggerMechanism(4, 2)
end, "SpikeDoor3")

RegisterEvent(30005, "SpikeDoor1", function()
    map.triggerMechanism(5, 2)
end, "SpikeDoor1")

RegisterEvent(30006, "SpikeDoor2", function()
    map.triggerMechanism(6, 2)
end, "SpikeDoor2")

RegisterEvent(30007, "SpikeDoor4", function()
    map.triggerMechanism(7, 2)
end, "SpikeDoor4")

RegisterEvent(30010, "Door7", function()
    map.triggerMechanism(10, 2)
end, "Door7")

RegisterEvent(30011, "DoubleDoorL28", function()
    map.triggerMechanism(11, 2)
end, "DoubleDoorL28")

RegisterEvent(30012, "DoubleDoorR28", function()
    map.triggerMechanism(12, 2)
end, "DoubleDoorR28")

RegisterEvent(30013, "DesertRoomDoor1", function()
    map.triggerMechanism(13, 2)
end, "DesertRoomDoor1")

RegisterEvent(30014, "DoubleDoorL40", function()
    map.triggerMechanism(14, 2)
end, "DoubleDoorL40")

RegisterEvent(30015, "DoubleDoorR40", function()
    map.triggerMechanism(15, 2)
end, "DoubleDoorR40")

RegisterEvent(30016, "Painting", function()
    map.triggerMechanism(16, 2)
end, "Painting")

RegisterEvent(30017, "MountainForestDoor", function()
    map.triggerMechanism(17, 2)
end, "MountainForestDoor")

RegisterEvent(30018, "Door0", function()
    map.triggerMechanism(18, 2)
end, "Door0")

RegisterEvent(30019, "ExitRoomDoor", function()
    map.triggerMechanism(19, 2)
end, "ExitRoomDoor")

RegisterEvent(30020, "TrapRoomDoor1", function()
    map.triggerMechanism(20, 2)
end, "TrapRoomDoor1")

RegisterEvent(30021, "TrapRoomDoor2", function()
    map.triggerMechanism(21, 2)
end, "TrapRoomDoor2")

RegisterEvent(30072, "FlameCage", function()
    map.triggerMechanism(72, 2)
end, "FlameCage")

RegisterEvent(30275, "ExitRamp", function()
    map.triggerMechanism(275, 2)
end, "ExitRamp")

RegisterEvent(30277, "ExitRiser", function()
    map.triggerMechanism(277, 2)
end, "ExitRiser")

RegisterEvent(30306, "TeleportDoor0", function()
    map.triggerMechanism(306, 2)
end, "TeleportDoor0")

RegisterEvent(30317, "CanyonDoorL0", function()
    map.triggerMechanism(317, 2)
end, "CanyonDoorL0")

RegisterEvent(30318, "CanyonDoorR0", function()
    map.triggerMechanism(318, 2)
end, "CanyonDoorR0")

RegisterEvent(30326, "TeleportDoor1", function()
    map.triggerMechanism(326, 2)
end, "TeleportDoor1")

RegisterEvent(30328, "ForestDoor0", function()
    map.triggerMechanism(328, 2)
end, "ForestDoor0")

RegisterEvent(30337, "DesertDoor0", function()
    map.triggerMechanism(337, 2)
end, "DesertDoor0")

RegisterEvent(30570, "Door1", function()
    map.triggerMechanism(570, 2)
end, "Door1")

RegisterEvent(30571, "Door2", function()
    map.triggerMechanism(571, 2)
end, "Door2")

RegisterEvent(30572, "Door3", function()
    map.triggerMechanism(572, 2)
end, "Door3")

RegisterEvent(30573, "Door4", function()
    map.triggerMechanism(573, 2)
end, "Door4")

RegisterEvent(30574, "Door5", function()
    map.triggerMechanism(574, 2)
end, "Door5")

RegisterEvent(30575, "Door6", function()
    map.triggerMechanism(575, 2)
end, "Door6")

map.scripts["darkp_bridgepuzzle.scr"] = {
    source = "DARKP_BRIDGEPUZZLE.scr",
    registered_triggers = {
        { line = 133, message = "HitA", callback = "HitA" },
        { line = 134, message = "HitB", callback = "HitB" },
        { line = 135, message = "HitC", callback = "HitC" },
        { line = 136, message = "HitD", callback = "HitD" },
        { line = 137, message = "Reset", callback = "Reset" },
    },
    movement_commands = {
    },
}
map.scripts["darkp_bridgereset.scr"] = {
    source = "DARKP_BRIDGERESET.scr",
    registered_triggers = {
        { line = 41, message = "Use", callback = "MoveMe" },
        { line = 42, message = "Stop", callback = "TurnSwitchOff" },
    },
    movement_commands = {
    },
}
map.scripts["darkp_canyonswitch.scr"] = {
    source = "DARKP_CANYONSWITCH.scr",
    registered_triggers = {
        { line = 86, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["darkp_npcdie.scr"] = {
    source = "DARKP_NPCDIE.scr",
    registered_triggers = {
        { line = 31, message = "Wince", callback = "TakeHit" },
        { line = 32, message = "destroy", callback = "Die" },
    },
    movement_commands = {
    },
}
map.scripts["darkp_raisingbridge.scr"] = {
    source = "DARKP_RAISINGBRIDGE.scr",
    registered_triggers = {
        { line = 61, message = "Move", callback = "MoveMe" },
    },
    movement_commands = {
        { line = 35, command = "MoveToPos", arguments = "nVarX, nVarY, nVarZ, 180, StopHere" },
        { line = 44, command = "MoveToPos", arguments = "nVarX, nVarY, nVarZ, 180, StopHere" },
    },
}
map.scripts["darkp_raisingswitch.scr"] = {
    source = "DARKP_RAISINGSWITCH.scr",
    registered_triggers = {
        { line = 48, message = "Use", callback = "MoveMe" },
        { line = 49, message = "Stop", callback = "TurnSwitchOff" },
    },
    movement_commands = {
    },
}
map.scripts["darkp_warrior.scr"] = {
    source = "DARKP_WARRIOR.scr",
    registered_triggers = {
        { line = 40, message = "HitNpc", callback = "BeginSequence" },
    },
    movement_commands = {
    },
}
map.scripts["dp_cagemonster.scr"] = {
    source = "DP_CAGEMONSTER.scr",
    registered_triggers = {
        { line = 25, message = "on", callback = "TurnOn" },
        { line = 26, message = "off", callback = "TurnOff" },
        { line = 28, message = "go", callback = "OpenCage" },
        { line = 59, message = "go", callback = "OpenCage" },
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
map.scripts["magiccarpet.scr"] = {
    source = "MAGICCARPET.scr",
    registered_triggers = {
        { line = 37, message = "Use", callback = "StartRising" },
        { line = 107, message = "Use", callback = "StartRising" },
    },
    movement_commands = {
    },
}
map.scripts["npc338.scr"] = {
    source = "NPC338.scr",
    registered_triggers = {
        { line = 104, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["passagegemstone.scr"] = {
    source = "PASSAGEGEMSTONE.scr",
    registered_triggers = {
        { line = 38, message = "use", callback = "ShineLight" },
        { line = 39, message = "trigger", callback = "ReleaseMonsters" },
        { line = 100, message = "use", callback = "ShineLight" },
    },
    movement_commands = {
    },
}
map.scripts["passagelaser.scr"] = {
    source = "PASSAGELASER.scr",
    registered_triggers = {
        { line = 29, message = "rotate", callback = "Rotate" },
    },
    movement_commands = {
    },
}
map.scripts["passagemirror.scr"] = {
    source = "PASSAGEMIRROR.scr",
    registered_triggers = {
        { line = 53, message = "use", callback = "Rotate" },
        { line = 54, message = "off", callback = "TakeFocus" },
        { line = 55, message = "trigger", callback = "GiveFocus" },
    },
    movement_commands = {
        { line = 71, command = "Rotate", arguments = "0,1,0, dA, 180, DoNothing" },
    },
}
map.scripts["spawnnjamcameo.scr"] = {
    source = "SPAWNNJAMCAMEO.scr",
    registered_triggers = {
        { line = 122, message = "Spawn", callback = "Onspawn" },
        { line = 123, message = "KillNjam", callback = "Vanish2c" },
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
