-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "ruinedtemple"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 3,
        source_name = "StartPoint0",
        x = 0,
        y = -858,
        z = -1590,
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
        mechanism_id = 900006,
        event_id = 30006,
        source_object_index = 6,
        source_class = "DestructableProp",
        source_name = "Crate2",
        kind = "destructible_prop",
        hint = "Crate2",
    },
    {
        mechanism_id = 900007,
        event_id = 30007,
        source_object_index = 7,
        source_class = "DestructableProp",
        source_name = "Barrel3",
        kind = "destructible_prop",
        hint = "Barrel3",
    },
    {
        mechanism_id = 900012,
        event_id = 30012,
        source_object_index = 12,
        source_class = "Door",
        source_name = "HiddenDoor2",
        kind = "linear_door",
        hint = "HiddenDoor2",
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
                name = "Door/stonedoorslam.wav",
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
        source_name = "SunButton3",
        kind = "linear_door",
        hint = "SunButton3",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
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
        mechanism_id = 900014,
        event_id = 30014,
        source_object_index = 14,
        source_class = "Door",
        source_name = "SunButton4",
        kind = "linear_door",
        hint = "SunButton4",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
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
        mechanism_id = 900015,
        event_id = 30015,
        source_object_index = 15,
        source_class = "Door",
        source_name = "AltarDoorLeft",
        kind = "linear_door",
        hint = "AltarDoorLeft",
        sounds = {
            ["open_busy"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/doorslideclosed.wav",
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
        mechanism_id = 900016,
        event_id = 30016,
        source_object_index = 16,
        source_class = "Door",
        source_name = "AltarDoorRight",
        kind = "linear_door",
        hint = "AltarDoorRight",
        sounds = {
            ["open_busy"] = {
                name = "Door/doorslideopen.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/doorslideclosed.wav",
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
        mechanism_id = 900017,
        event_id = 30017,
        source_object_index = 17,
        source_class = "Door",
        source_name = "HiddenDoor",
        kind = "linear_door",
        hint = "HiddenDoor",
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
                name = "Door/stonedoorslam.wav",
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
        source_name = "SunButton",
        kind = "linear_door",
        hint = "SunButton",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
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
        source_name = "SunButton2",
        kind = "linear_door",
        hint = "SunButton2",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
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
        mechanism_id = 900020,
        event_id = 30020,
        source_object_index = 20,
        source_class = "Door",
        source_name = "MoonButton1",
        kind = "linear_door",
        hint = "MoonButton1",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
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
        mechanism_id = 900021,
        event_id = 30021,
        source_object_index = 21,
        source_class = "Door",
        source_name = "DiamondButton1",
        kind = "linear_door",
        hint = "DiamondButton1",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
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
        source_class = "Door",
        source_name = "StarButton1",
        kind = "linear_door",
        hint = "StarButton1",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
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
        mechanism_id = 900023,
        event_id = 30023,
        source_object_index = 23,
        source_class = "Door",
        source_name = "MoonButton2",
        kind = "linear_door",
        hint = "MoonButton2",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
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
        mechanism_id = 900024,
        event_id = 30024,
        source_object_index = 24,
        source_class = "Door",
        source_name = "DiamondButton2",
        kind = "linear_door",
        hint = "DiamondButton2",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
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
        mechanism_id = 900025,
        event_id = 30025,
        source_object_index = 25,
        source_class = "Door",
        source_name = "StarButton2",
        kind = "linear_door",
        hint = "StarButton2",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
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
        mechanism_id = 900026,
        event_id = 30026,
        source_object_index = 26,
        source_class = "Door",
        source_name = "SecondButton",
        kind = "linear_door",
        hint = "SecondButton",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
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
        mechanism_id = 900028,
        event_id = 30028,
        source_object_index = 28,
        source_class = "Door",
        source_name = "UpDoor",
        kind = "linear_door",
        hint = "UpDoor",
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
                name = "Door/stonedoorslam.wav",
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
        source_name = "HiddenButton",
        kind = "linear_door",
        hint = "HiddenButton",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900030,
        event_id = 30030,
        source_object_index = 30,
        source_class = "Door",
        source_name = "HiddenButton2",
        kind = "linear_door",
        hint = "HiddenButton2",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        mechanism_id = 900031,
        event_id = 30031,
        source_object_index = 31,
        source_class = "Door",
        source_name = "HiddenDoor3",
        kind = "linear_door",
        hint = "HiddenDoor3",
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
                name = "Door/stonedoorslam.wav",
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
        source_name = "LeftDoor",
        kind = "linear_door",
        hint = "LeftDoor",
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
                name = "Door/stonedoorslam.wav",
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
        source_class = "Door",
        source_name = "PrisonEntrance2",
        kind = "linear_door",
        hint = "PrisonEntrance2",
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
                name = "Door/stonedoorslam.wav",
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
        source_name = "PrisonEntrance",
        kind = "linear_door",
        hint = "PrisonEntrance",
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
                name = "Door/stonedoorslam.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900035,
        event_id = 30035,
        source_object_index = 35,
        source_class = "RotatingBrush",
        source_name = "RopeWheel",
        kind = "rotating_brush",
        hint = "RopeWheel",
    },
    {
        mechanism_id = 900036,
        event_id = 30036,
        source_object_index = 36,
        source_class = "Door",
        source_name = "PrisonBars",
        kind = "linear_door",
        hint = "PrisonBars",
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
        mechanism_id = 900037,
        event_id = 30037,
        source_object_index = 37,
        source_class = "Door",
        source_name = "PrisonDoor",
        kind = "linear_door",
        hint = "PrisonDoor",
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
        mechanism_id = 900038,
        event_id = 30038,
        source_object_index = 38,
        source_class = "Door",
        source_name = "PrisonButton2",
        kind = "linear_door",
        hint = "PrisonButton2",
        sounds = {
            ["open_stop"] = {
                name = "Door/doorlatch01.wav",
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
        mechanism_id = 900039,
        event_id = 30039,
        source_object_index = 39,
        source_class = "Door",
        source_name = "MainButton",
        kind = "linear_door",
        hint = "MainButton",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
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
        mechanism_id = 900040,
        event_id = 30040,
        source_object_index = 40,
        source_class = "Ladder",
        source_name = "Ladder",
        kind = "ladder_volume",
        hint = "Ladder",
    },
    {
        mechanism_id = 900204,
        event_id = 30204,
        source_object_index = 204,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900268,
        event_id = 30268,
        source_object_index = 268,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900303,
        event_id = 30303,
        source_object_index = 303,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 900313,
        event_id = 30313,
        source_object_index = 313,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900314,
        event_id = 30314,
        source_object_index = 314,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900315,
        event_id = 30315,
        source_object_index = 315,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900316,
        event_id = 30316,
        source_object_index = 316,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 900317,
        event_id = 30317,
        source_object_index = 317,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 900318,
        event_id = 30318,
        source_object_index = 318,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 900319,
        event_id = 30319,
        source_object_index = 319,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush7",
        kind = "perception_brush",
        hint = "PerceptionBrush7",
    },
    {
        mechanism_id = 900320,
        event_id = 30320,
        source_object_index = 320,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush8",
        kind = "perception_brush",
        hint = "PerceptionBrush8",
    },
    {
        mechanism_id = 900321,
        event_id = 30321,
        source_object_index = 321,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush9",
        kind = "perception_brush",
        hint = "PerceptionBrush9",
    },
    {
        mechanism_id = 900322,
        event_id = 30322,
        source_object_index = 322,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900323,
        event_id = 30323,
        source_object_index = 323,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush10",
        kind = "perception_brush",
        hint = "PerceptionBrush10",
    },
    {
        mechanism_id = 900325,
        event_id = 30325,
        source_object_index = 325,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush6",
        kind = "destructible_brush",
        hint = "DestructableBrush6",
    },
    {
        mechanism_id = 900326,
        event_id = 30326,
        source_object_index = 326,
        source_class = "DestructableBrush",
        source_name = "glass1",
        kind = "destructible_brush",
        hint = "glass1",
    },
    {
        mechanism_id = 900327,
        event_id = 30327,
        source_object_index = 327,
        source_class = "DestructableBrush",
        source_name = "glass6",
        kind = "destructible_brush",
        hint = "glass6",
    },
    {
        mechanism_id = 900328,
        event_id = 30328,
        source_object_index = 328,
        source_class = "DestructableBrush",
        source_name = "glass2",
        kind = "destructible_brush",
        hint = "glass2",
    },
    {
        mechanism_id = 900329,
        event_id = 30329,
        source_object_index = 329,
        source_class = "DestructableBrush",
        source_name = "glass3",
        kind = "destructible_brush",
        hint = "glass3",
    },
    {
        mechanism_id = 900330,
        event_id = 30330,
        source_object_index = 330,
        source_class = "DestructableBrush",
        source_name = "glass4",
        kind = "destructible_brush",
        hint = "glass4",
    },
    {
        mechanism_id = 900331,
        event_id = 30331,
        source_object_index = 331,
        source_class = "DestructableBrush",
        source_name = "glass7",
        kind = "destructible_brush",
        hint = "glass7",
    },
    {
        mechanism_id = 900332,
        event_id = 30332,
        source_object_index = 332,
        source_class = "DestructableBrush",
        source_name = "glass5",
        kind = "destructible_brush",
        hint = "glass5",
    },
    {
        mechanism_id = 900333,
        event_id = 30333,
        source_object_index = 333,
        source_class = "DestructableBrush",
        source_name = "glass8",
        kind = "destructible_brush",
        hint = "glass8",
    },
    {
        mechanism_id = 900339,
        event_id = 30339,
        source_object_index = 339,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush0",
        kind = "destructible_brush",
        hint = "DestructableBrush0",
    },
    {
        mechanism_id = 900340,
        event_id = 30340,
        source_object_index = 340,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush1",
        kind = "destructible_brush",
        hint = "DestructableBrush1",
    },
    {
        mechanism_id = 900341,
        event_id = 30341,
        source_object_index = 341,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush2",
        kind = "destructible_brush",
        hint = "DestructableBrush2",
    },
    {
        mechanism_id = 900342,
        event_id = 30342,
        source_object_index = 342,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush3",
        kind = "destructible_brush",
        hint = "DestructableBrush3",
    },
    {
        mechanism_id = 900343,
        event_id = 30343,
        source_object_index = 343,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush4",
        kind = "destructible_brush",
        hint = "DestructableBrush4",
    },
    {
        mechanism_id = 900344,
        event_id = 30344,
        source_object_index = 344,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush5",
        kind = "destructible_brush",
        hint = "DestructableBrush5",
    },
    {
        mechanism_id = 900345,
        event_id = 30345,
        source_object_index = 345,
        source_class = "DestructableBrush",
        source_name = "DB_Crypt0",
        kind = "destructible_brush",
        hint = "DB_Crypt0",
    },
    {
        mechanism_id = 900351,
        event_id = 30351,
        source_object_index = 351,
        source_class = "Door",
        source_name = "PrisonButton3",
        kind = "linear_door",
        hint = "PrisonButton3",
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
        mechanism_id = 900362,
        event_id = 30362,
        source_object_index = 362,
        source_class = "DestructableBrush",
        source_name = "DB_RailRight",
        kind = "destructible_brush",
        hint = "DB_RailRight",
    },
    {
        mechanism_id = 900363,
        event_id = 30363,
        source_object_index = 363,
        source_class = "DestructableBrush",
        source_name = "DB_RailLeft",
        kind = "destructible_brush",
        hint = "DB_RailLeft",
    },
    {
        mechanism_id = 900368,
        event_id = 30368,
        source_object_index = 368,
        source_class = "DestructableBrush",
        source_name = "DBFloor1",
        kind = "destructible_brush",
        hint = "DBFloor1",
    },
    {
        mechanism_id = 900369,
        event_id = 30369,
        source_object_index = 369,
        source_class = "DestructableBrush",
        source_name = "DBFloor2",
        kind = "destructible_brush",
        hint = "DBFloor2",
    },
    {
        mechanism_id = 900379,
        event_id = 30379,
        source_object_index = 379,
        source_class = "DestructableBrush",
        source_name = "DB_CeilingRight",
        kind = "destructible_brush",
        hint = "DB_CeilingRight",
    },
    {
        mechanism_id = 900380,
        event_id = 30380,
        source_object_index = 380,
        source_class = "DestructableBrush",
        source_name = "DB_CeilingLeft",
        kind = "destructible_brush",
        hint = "DB_CeilingLeft",
    },
    {
        mechanism_id = 900381,
        event_id = 30381,
        source_object_index = 381,
        source_class = "DestructableBrush",
        source_name = "DBFloor",
        kind = "destructible_brush",
        hint = "DBFloor",
    },
    {
        mechanism_id = 900383,
        event_id = 30383,
        source_object_index = 383,
        source_class = "DestructableBrush",
        source_name = "DBFloor0",
        kind = "destructible_brush",
        hint = "DBFloor0",
    },
    {
        mechanism_id = 900385,
        event_id = 30385,
        source_object_index = 385,
        source_class = "Door",
        source_name = "DoorCryptEscape0",
        kind = "linear_door",
        hint = "DoorCryptEscape0",
        sounds = {
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
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
        mechanism_id = 900386,
        event_id = 30386,
        source_object_index = 386,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
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
    [30012] = { kind = "open_door", source = "mm9_mechanism", targetName = "HiddenDoor2" },
    [30013] = { kind = "open_door", source = "mm9_mechanism", targetName = "SunButton3" },
    [30014] = { kind = "open_door", source = "mm9_mechanism", targetName = "SunButton4" },
    [30015] = { kind = "open_door", source = "mm9_mechanism", targetName = "AltarDoorLeft" },
    [30016] = { kind = "open_door", source = "mm9_mechanism", targetName = "AltarDoorRight" },
    [30017] = { kind = "open_door", source = "mm9_mechanism", targetName = "HiddenDoor" },
    [30018] = { kind = "open_door", source = "mm9_mechanism", targetName = "SunButton" },
    [30019] = { kind = "open_door", source = "mm9_mechanism", targetName = "SunButton2" },
    [30020] = { kind = "open_door", source = "mm9_mechanism", targetName = "MoonButton1" },
    [30021] = { kind = "open_door", source = "mm9_mechanism", targetName = "DiamondButton1" },
    [30022] = { kind = "open_door", source = "mm9_mechanism", targetName = "StarButton1" },
    [30023] = { kind = "open_door", source = "mm9_mechanism", targetName = "MoonButton2" },
    [30024] = { kind = "open_door", source = "mm9_mechanism", targetName = "DiamondButton2" },
    [30025] = { kind = "open_door", source = "mm9_mechanism", targetName = "StarButton2" },
    [30026] = { kind = "open_door", source = "mm9_mechanism", targetName = "SecondButton" },
    [30028] = { kind = "open_door", source = "mm9_mechanism", targetName = "UpDoor" },
    [30029] = { kind = "open_door", source = "mm9_mechanism", targetName = "HiddenButton" },
    [30030] = { kind = "open_door", source = "mm9_mechanism", targetName = "HiddenButton2" },
    [30031] = { kind = "open_door", source = "mm9_mechanism", targetName = "HiddenDoor3" },
    [30032] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeftDoor" },
    [30033] = { kind = "open_door", source = "mm9_mechanism", targetName = "PrisonEntrance2" },
    [30034] = { kind = "open_door", source = "mm9_mechanism", targetName = "PrisonEntrance" },
    [30035] = { kind = "generic_event", source = "mm9_mechanism", targetName = "RopeWheel" },
    [30036] = { kind = "open_door", source = "mm9_mechanism", targetName = "PrisonBars" },
    [30037] = { kind = "open_door", source = "mm9_mechanism", targetName = "PrisonDoor" },
    [30038] = { kind = "open_door", source = "mm9_mechanism", targetName = "PrisonButton2" },
    [30039] = { kind = "open_door", source = "mm9_mechanism", targetName = "MainButton" },
    [30351] = { kind = "open_door", source = "mm9_mechanism", targetName = "PrisonButton3" },
    [30385] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoorCryptEscape0" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30012, "HiddenDoor2", function()
    map.triggerMechanism(12, 2)
end, "HiddenDoor2")

RegisterEvent(30013, "SunButton3", function()
    map.triggerMechanism(13, 2)
end, "SunButton3")

RegisterEvent(30014, "SunButton4", function()
    map.triggerMechanism(14, 2)
end, "SunButton4")

RegisterEvent(30015, "AltarDoorLeft", function()
    map.triggerMechanism(15, 2)
end, "AltarDoorLeft")

RegisterEvent(30016, "AltarDoorRight", function()
    map.triggerMechanism(16, 2)
end, "AltarDoorRight")

RegisterEvent(30017, "HiddenDoor", function()
    map.triggerMechanism(17, 2)
end, "HiddenDoor")

RegisterEvent(30018, "SunButton", function()
    map.triggerMechanism(18, 2)
end, "SunButton")

RegisterEvent(30019, "SunButton2", function()
    map.triggerMechanism(19, 2)
end, "SunButton2")

RegisterEvent(30020, "MoonButton1", function()
    map.triggerMechanism(20, 2)
end, "MoonButton1")

RegisterEvent(30021, "DiamondButton1", function()
    map.triggerMechanism(21, 2)
end, "DiamondButton1")

RegisterEvent(30022, "StarButton1", function()
    map.triggerMechanism(22, 2)
end, "StarButton1")

RegisterEvent(30023, "MoonButton2", function()
    map.triggerMechanism(23, 2)
end, "MoonButton2")

RegisterEvent(30024, "DiamondButton2", function()
    map.triggerMechanism(24, 2)
end, "DiamondButton2")

RegisterEvent(30025, "StarButton2", function()
    map.triggerMechanism(25, 2)
end, "StarButton2")

RegisterEvent(30026, "SecondButton", function()
    map.triggerMechanism(26, 2)
end, "SecondButton")

RegisterEvent(30028, "UpDoor", function()
    map.triggerMechanism(28, 2)
end, "UpDoor")

RegisterEvent(30029, "HiddenButton", function()
    map.triggerMechanism(29, 2)
end, "HiddenButton")

RegisterEvent(30030, "HiddenButton2", function()
    map.triggerMechanism(30, 2)
end, "HiddenButton2")

RegisterEvent(30031, "HiddenDoor3", function()
    map.triggerMechanism(31, 2)
end, "HiddenDoor3")

RegisterEvent(30032, "LeftDoor", function()
    map.triggerMechanism(32, 2)
end, "LeftDoor")

RegisterEvent(30033, "PrisonEntrance2", function()
    map.triggerMechanism(33, 2)
end, "PrisonEntrance2")

RegisterEvent(30034, "PrisonEntrance", function()
    map.triggerMechanism(34, 2)
end, "PrisonEntrance")

RegisterEvent(30035, "RopeWheel", function()
    map.triggerMechanism(35, 2)
end, "RopeWheel")

RegisterEvent(30036, "PrisonBars", function()
    map.triggerMechanism(36, 2)
end, "PrisonBars")

RegisterEvent(30037, "PrisonDoor", function()
    map.triggerMechanism(37, 2)
end, "PrisonDoor")

RegisterEvent(30038, "PrisonButton2", function()
    map.triggerMechanism(38, 2)
end, "PrisonButton2")

RegisterEvent(30039, "MainButton", function()
    map.triggerMechanism(39, 2)
end, "MainButton")

RegisterEvent(30351, "PrisonButton3", function()
    map.triggerMechanism(351, 2)
end, "PrisonButton3")

RegisterEvent(30385, "DoorCryptEscape0", function()
    map.triggerMechanism(385, 2)
end, "DoorCryptEscape0")

map.scripts["bookletter.scr"] = {
    source = "BOOKLETTER.scr",
    registered_triggers = {
        { line = 74, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["colloidalgenie.scr"] = {
    source = "COLLOIDALGENIE.scr",
    registered_triggers = {
        { line = 55, message = "appear", callback = "AppearWait" },
        { line = 100, message = "use", callback = "BlockRUDE" },
    },
    movement_commands = {
        { line = 80, command = "SetPOS", arguments = "hMe, x,y,z" },
    },
}
map.scripts["geniecrystal.scr"] = {
    source = "GENIECRYSTAL.scr",
    registered_triggers = {
        { line = 19, message = "use", callback = "CallGenie" },
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
map.scripts["rt_cavein.scr"] = {
    source = "RT_CAVEIN.scr",
    registered_triggers = {
        { line = 60, message = "Fall", callback = "Delay" },
    },
    movement_commands = {
        { line = 45, command = "MoveToPos", arguments = "nVarX, nVarY, nVarZ, 220, StopHere" },
    },
}
map.scripts["rt_counterbalance.scr"] = {
    source = "RT_COUNTERBALANCE.scr",
    registered_triggers = {
        { line = 43, message = "Fall", callback = "MoveToMarker" },
    },
    movement_commands = {
        { line = 38, command = "MoveToPos", arguments = "nVarX, nVarY, nVarZ, 300, StopHere" },
    },
}
map.scripts["suntemplebuttons.scr"] = {
    source = "SUNTEMPLEBUTTONS.scr",
    registered_triggers = {
        { line = 127, message = "Star1", callback = "HandleStar1" },
        { line = 128, message = "Star2", callback = "HandleStar2" },
        { line = 129, message = "Diamond1", callback = "HandleDiamond1" },
        { line = 130, message = "Diamond2", callback = "HandleDiamond2" },
        { line = 131, message = "Moon1", callback = "HandleMoon1" },
        { line = 132, message = "Moon2", callback = "HandleMoon2" },
        { line = 133, message = "Use", callback = "HandleMainButton" },
    },
    movement_commands = {
    },
}
map.scripts["treeoflife.scr"] = {
    source = "TREEOFLIFE.scr",
    registered_triggers = {
        { line = 38, message = "Use", callback = "Onuse" },
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
