-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "traininghall"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 223,
        source_name = "StartPoint0",
        x = 0,
        y = 287,
        z = 1843,
        direction_yaw_units = 1023,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 225,
        source_name = "StartPoint1",
        x = 0,
        y = -3359,
        z = 128,
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
        source_class = "Door",
        source_name = "drop",
        kind = "linear_door",
        hint = "drop",
        sounds = {
            ["open_start"] = {
                name = "Events/Clap01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/stonecrumble.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900001,
        event_id = 30001,
        source_object_index = 1,
        source_class = "Ladder",
        source_name = "Chain Ladder",
        kind = "ladder_volume",
        hint = "Chain Ladder",
    },
    {
        mechanism_id = 900002,
        event_id = 30002,
        source_object_index = 2,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush6",
        kind = "destructible_brush",
        hint = "DestructableBrush6",
    },
    {
        mechanism_id = 900012,
        event_id = 30012,
        source_object_index = 12,
        source_class = "Ladder",
        source_name = "Ladder14",
        kind = "ladder_volume",
        hint = "Ladder14",
    },
    {
        mechanism_id = 900014,
        event_id = 30014,
        source_object_index = 14,
        source_class = "Ladder",
        source_name = "Ladder13",
        kind = "ladder_volume",
        hint = "Ladder13",
    },
    {
        mechanism_id = 900016,
        event_id = 30016,
        source_object_index = 16,
        source_class = "Ladder",
        source_name = "Ladder11",
        kind = "ladder_volume",
        hint = "Ladder11",
    },
    {
        mechanism_id = 900018,
        event_id = 30018,
        source_object_index = 18,
        source_class = "Ladder",
        source_name = "Ladder10",
        kind = "ladder_volume",
        hint = "Ladder10",
    },
    {
        mechanism_id = 900020,
        event_id = 30020,
        source_object_index = 20,
        source_class = "Ladder",
        source_name = "Ladder9",
        kind = "ladder_volume",
        hint = "Ladder9",
    },
    {
        mechanism_id = 900022,
        event_id = 30022,
        source_object_index = 22,
        source_class = "Ladder",
        source_name = "Ladder8",
        kind = "ladder_volume",
        hint = "Ladder8",
    },
    {
        mechanism_id = 900024,
        event_id = 30024,
        source_object_index = 24,
        source_class = "Ladder",
        source_name = "Ladder7",
        kind = "ladder_volume",
        hint = "Ladder7",
    },
    {
        mechanism_id = 900026,
        event_id = 30026,
        source_object_index = 26,
        source_class = "Ladder",
        source_name = "Ladder6",
        kind = "ladder_volume",
        hint = "Ladder6",
    },
    {
        mechanism_id = 900028,
        event_id = 30028,
        source_object_index = 28,
        source_class = "Ladder",
        source_name = "Ladder5",
        kind = "ladder_volume",
        hint = "Ladder5",
    },
    {
        mechanism_id = 900030,
        event_id = 30030,
        source_object_index = 30,
        source_class = "Ladder",
        source_name = "Ladder4",
        kind = "ladder_volume",
        hint = "Ladder4",
    },
    {
        mechanism_id = 900032,
        event_id = 30032,
        source_object_index = 32,
        source_class = "Ladder",
        source_name = "Ladder12",
        kind = "ladder_volume",
        hint = "Ladder12",
    },
    {
        mechanism_id = 900033,
        event_id = 30033,
        source_object_index = 33,
        source_class = "RotatingDoor",
        source_name = "resetlever1",
        kind = "rotating_door",
        hint = "resetlever1",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Events/metalhitstone02.wav",
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
        source_class = "RotatingDoor",
        source_name = "resetlever2",
        kind = "rotating_door",
        hint = "resetlever2",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Events/metalhitstone02.wav",
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
        source_class = "RotatingDoor",
        source_name = "resetlever3",
        kind = "rotating_door",
        hint = "resetlever3",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Events/metalhitstone02.wav",
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
        source_name = "resetlever4",
        kind = "rotating_door",
        hint = "resetlever4",
        sounds = {
            ["open_stop"] = {
                name = "Events/lock02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Events/metalhitstone02.wav",
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
        source_class = "DestructableBrush",
        source_name = "DestructableBrush0",
        kind = "destructible_brush",
        hint = "DestructableBrush0",
    },
    {
        mechanism_id = 900038,
        event_id = 30038,
        source_object_index = 38,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush1",
        kind = "destructible_brush",
        hint = "DestructableBrush1",
    },
    {
        mechanism_id = 900039,
        event_id = 30039,
        source_object_index = 39,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush2",
        kind = "destructible_brush",
        hint = "DestructableBrush2",
    },
    {
        mechanism_id = 900040,
        event_id = 30040,
        source_object_index = 40,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush3",
        kind = "destructible_brush",
        hint = "DestructableBrush3",
    },
    {
        mechanism_id = 900041,
        event_id = 30041,
        source_object_index = 41,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush4",
        kind = "destructible_brush",
        hint = "DestructableBrush4",
    },
    {
        mechanism_id = 900042,
        event_id = 30042,
        source_object_index = 42,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush5",
        kind = "destructible_brush",
        hint = "DestructableBrush5",
    },
    {
        mechanism_id = 900043,
        event_id = 30043,
        source_object_index = 43,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush8",
        kind = "destructible_brush",
        hint = "DestructableBrush8",
    },
    {
        mechanism_id = 900044,
        event_id = 30044,
        source_object_index = 44,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush7",
        kind = "destructible_brush",
        hint = "DestructableBrush7",
    },
    {
        mechanism_id = 900045,
        event_id = 30045,
        source_object_index = 45,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush9",
        kind = "destructible_brush",
        hint = "DestructableBrush9",
    },
    {
        mechanism_id = 900046,
        event_id = 30046,
        source_object_index = 46,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush10",
        kind = "destructible_brush",
        hint = "DestructableBrush10",
    },
    {
        mechanism_id = 900047,
        event_id = 30047,
        source_object_index = 47,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush11",
        kind = "destructible_brush",
        hint = "DestructableBrush11",
    },
    {
        mechanism_id = 900052,
        event_id = 30052,
        source_object_index = 52,
        source_class = "Door",
        source_name = "dummy2door",
        kind = "linear_door",
        hint = "dummy2door",
        sounds = {
            ["open_start"] = {
                name = "Events/steam_burst02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Events/drawbridge02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/metalbreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/steam_burst02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/gears01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/steam_burst06.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900056,
        event_id = 30056,
        source_object_index = 56,
        source_class = "RotatingBrush",
        source_name = "d2w4",
        kind = "rotating_brush",
        hint = "d2w4",
    },
    {
        mechanism_id = 900057,
        event_id = 30057,
        source_object_index = 57,
        source_class = "RotatingBrush",
        source_name = "d2w3",
        kind = "rotating_brush",
        hint = "d2w3",
    },
    {
        mechanism_id = 900058,
        event_id = 30058,
        source_object_index = 58,
        source_class = "RotatingBrush",
        source_name = "d2w2",
        kind = "rotating_brush",
        hint = "d2w2",
    },
    {
        mechanism_id = 900059,
        event_id = 30059,
        source_object_index = 59,
        source_class = "RotatingBrush",
        source_name = "d2w1",
        kind = "rotating_brush",
        hint = "d2w1",
    },
    {
        mechanism_id = 900060,
        event_id = 30060,
        source_object_index = 60,
        source_class = "Door",
        source_name = "dummy4door",
        kind = "linear_door",
        hint = "dummy4door",
    },
    {
        mechanism_id = 900063,
        event_id = 30063,
        source_object_index = 63,
        source_class = "Door",
        source_name = "dummy4guide",
        kind = "linear_door",
        hint = "dummy4guide",
        sounds = {
            ["open_start"] = {
                name = "Events/steam_burst02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Events/drawbridge02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/metalbreak03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/steam_burst02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/gears02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/steam_burst06.wav",
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
        source_class = "RotatingBrush",
        source_name = "d4w1",
        kind = "rotating_brush",
        hint = "d4w1",
    },
    {
        mechanism_id = 900066,
        event_id = 30066,
        source_object_index = 66,
        source_class = "RotatingBrush",
        source_name = "d4w2",
        kind = "rotating_brush",
        hint = "d4w2",
    },
    {
        mechanism_id = 900067,
        event_id = 30067,
        source_object_index = 67,
        source_class = "RotatingBrush",
        source_name = "d4w3",
        kind = "rotating_brush",
        hint = "d4w3",
    },
    {
        mechanism_id = 900068,
        event_id = 30068,
        source_object_index = 68,
        source_class = "RotatingBrush",
        source_name = "d4w4",
        kind = "rotating_brush",
        hint = "d4w4",
    },
    {
        mechanism_id = 900200,
        event_id = 30200,
        source_object_index = 200,
        source_class = "BlueWater",
        source_name = "BlueWater1",
        kind = "water_volume",
        hint = "BlueWater1",
    },
    {
        mechanism_id = 900226,
        event_id = 30226,
        source_object_index = 226,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor2",
        kind = "rotating_door",
        hint = "RotatingDoor2",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorcreak02.wav",
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
        mechanism_id = 900227,
        event_id = 30227,
        source_object_index = 227,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor0",
        kind = "rotating_door",
        hint = "RotatingDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorcreak02.wav",
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
        mechanism_id = 900228,
        event_id = 30228,
        source_object_index = 228,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor3",
        kind = "rotating_door",
        hint = "RotatingDoor3",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorcreak02.wav",
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
        mechanism_id = 900229,
        event_id = 30229,
        source_object_index = 229,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor1",
        kind = "rotating_door",
        hint = "RotatingDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorcreak02.wav",
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
        mechanism_id = 900230,
        event_id = 30230,
        source_object_index = 230,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 900231,
        event_id = 30231,
        source_object_index = 231,
        source_class = "Ladder",
        source_name = "Ladder0",
        kind = "ladder_volume",
        hint = "Ladder0",
    },
    {
        mechanism_id = 900233,
        event_id = 30233,
        source_object_index = 233,
        source_class = "Ladder",
        source_name = "Ladder1",
        kind = "ladder_volume",
        hint = "Ladder1",
    },
    {
        mechanism_id = 900235,
        event_id = 30235,
        source_object_index = 235,
        source_class = "DestructableBrush",
        source_name = "upperbreak1",
        kind = "destructible_brush",
        hint = "upperbreak1",
    },
    {
        mechanism_id = 900236,
        event_id = 30236,
        source_object_index = 236,
        source_class = "DestructableBrush",
        source_name = "lowerbreak1",
        kind = "destructible_brush",
        hint = "lowerbreak1",
    },
    {
        mechanism_id = 900238,
        event_id = 30238,
        source_object_index = 238,
        source_class = "DestructableBrush",
        source_name = "upperbreak2",
        kind = "destructible_brush",
        hint = "upperbreak2",
    },
    {
        mechanism_id = 900239,
        event_id = 30239,
        source_object_index = 239,
        source_class = "DestructableBrush",
        source_name = "lowerbreak2",
        kind = "destructible_brush",
        hint = "lowerbreak2",
    },
    {
        mechanism_id = 900241,
        event_id = 30241,
        source_object_index = 241,
        source_class = "DestructableBrush",
        source_name = "woodexplosion",
        kind = "destructible_brush",
        hint = "woodexplosion",
    },
    {
        mechanism_id = 900246,
        event_id = 30246,
        source_object_index = 246,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900247,
        event_id = 30247,
        source_object_index = 247,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900315,
        event_id = 30315,
        source_object_index = 315,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900420,
        event_id = 30420,
        source_object_index = 420,
        source_class = "RotatingDoor",
        source_name = "dragonroomdoorR",
        kind = "rotating_door",
        hint = "dragonroomdoorR",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorcreak02.wav",
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
        mechanism_id = 900424,
        event_id = 30424,
        source_object_index = 424,
        source_class = "RotatingDoor",
        source_name = "dragonroomdoorL",
        kind = "rotating_door",
        hint = "dragonroomdoorL",
        sounds = {
            ["open_start"] = {
                name = "Door/doorcreak02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/doorcreak02.wav",
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
        mechanism_id = 900438,
        event_id = 30438,
        source_object_index = 438,
        source_class = "Door",
        source_name = "Pusher0",
        kind = "linear_door",
        hint = "Pusher0",
        sounds = {
            ["open_busy"] = {
                name = "Events/stonestonescrape03.wav",
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
            ["close_busy"] = {
                name = "Events/stonestonescrape03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/slam.wav",
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
        source_name = "Pusher1",
        kind = "linear_door",
        hint = "Pusher1",
        sounds = {
            ["open_busy"] = {
                name = "Events/stonestonescrape03.wav",
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
            ["close_busy"] = {
                name = "Events/stonestonescrape03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/slam.wav",
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
        source_class = "Door",
        source_name = "Pusher2",
        kind = "linear_door",
        hint = "Pusher2",
        sounds = {
            ["open_busy"] = {
                name = "Events/stonestonescrape03.wav",
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
            ["close_busy"] = {
                name = "Events/stonestonescrape03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/slam.wav",
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
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900442,
        event_id = 30442,
        source_object_index = 442,
        source_class = "ScriptObject",
        source_name = "TrainingTrigger",
        kind = "script_object",
        hint = "TrainingTrigger",
    },
    {
        mechanism_id = 900443,
        event_id = 30443,
        source_object_index = 443,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush12",
        kind = "destructible_brush",
        hint = "DestructableBrush12",
    },
    {
        mechanism_id = 900444,
        event_id = 30444,
        source_object_index = 444,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900445,
        event_id = 30445,
        source_object_index = 445,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900446,
        event_id = 30446,
        source_object_index = 446,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900447,
        event_id = 30447,
        source_object_index = 447,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900448,
        event_id = 30448,
        source_object_index = 448,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 900449,
        event_id = 30449,
        source_object_index = 449,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 900450,
        event_id = 30450,
        source_object_index = 450,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 900451,
        event_id = 30451,
        source_object_index = 451,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush7",
        kind = "perception_brush",
        hint = "PerceptionBrush7",
    },
    {
        mechanism_id = 900452,
        event_id = 30452,
        source_object_index = 452,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush8",
        kind = "perception_brush",
        hint = "PerceptionBrush8",
    },
    {
        mechanism_id = 900477,
        event_id = 30477,
        source_object_index = 477,
        source_class = "RotatingDoor",
        source_name = "target1",
        kind = "rotating_door",
        hint = "target1",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open01.wav",
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
                name = "Events/metalgearworks.wav",
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
        mechanism_id = 900478,
        event_id = 30478,
        source_object_index = 478,
        source_class = "RotatingDoor",
        source_name = "target2",
        kind = "rotating_door",
        hint = "target2",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open01.wav",
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
                name = "Events/metalgearworks.wav",
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
        mechanism_id = 900479,
        event_id = 30479,
        source_object_index = 479,
        source_class = "RotatingDoor",
        source_name = "target3",
        kind = "rotating_door",
        hint = "target3",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open01.wav",
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
                name = "Events/metalgearworks.wav",
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
        mechanism_id = 900480,
        event_id = 30480,
        source_object_index = 480,
        source_class = "RotatingDoor",
        source_name = "target4",
        kind = "rotating_door",
        hint = "target4",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open01.wav",
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
                name = "Events/metalgearworks.wav",
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
        mechanism_id = 900481,
        event_id = 30481,
        source_object_index = 481,
        source_class = "ScriptObject",
        source_name = "TargetMgr",
        kind = "script_object",
        hint = "TargetMgr",
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
    [30000] = { kind = "open_door", source = "mm9_mechanism", targetName = "drop" },
    [30033] = { kind = "open_door", source = "mm9_mechanism", targetName = "resetlever1" },
    [30034] = { kind = "open_door", source = "mm9_mechanism", targetName = "resetlever2" },
    [30035] = { kind = "open_door", source = "mm9_mechanism", targetName = "resetlever3" },
    [30036] = { kind = "open_door", source = "mm9_mechanism", targetName = "resetlever4" },
    [30052] = { kind = "open_door", source = "mm9_mechanism", targetName = "dummy2door" },
    [30056] = { kind = "generic_event", source = "mm9_mechanism", targetName = "d2w4" },
    [30057] = { kind = "generic_event", source = "mm9_mechanism", targetName = "d2w3" },
    [30058] = { kind = "generic_event", source = "mm9_mechanism", targetName = "d2w2" },
    [30059] = { kind = "generic_event", source = "mm9_mechanism", targetName = "d2w1" },
    [30060] = { kind = "open_door", source = "mm9_mechanism", targetName = "dummy4door" },
    [30063] = { kind = "open_door", source = "mm9_mechanism", targetName = "dummy4guide" },
    [30065] = { kind = "generic_event", source = "mm9_mechanism", targetName = "d4w1" },
    [30066] = { kind = "generic_event", source = "mm9_mechanism", targetName = "d4w2" },
    [30067] = { kind = "generic_event", source = "mm9_mechanism", targetName = "d4w3" },
    [30068] = { kind = "generic_event", source = "mm9_mechanism", targetName = "d4w4" },
    [30226] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor2" },
    [30227] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0" },
    [30228] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor3" },
    [30229] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor1" },
    [30420] = { kind = "open_door", source = "mm9_mechanism", targetName = "dragonroomdoorR" },
    [30424] = { kind = "open_door", source = "mm9_mechanism", targetName = "dragonroomdoorL" },
    [30438] = { kind = "open_door", source = "mm9_mechanism", targetName = "Pusher0" },
    [30439] = { kind = "open_door", source = "mm9_mechanism", targetName = "Pusher1" },
    [30440] = { kind = "open_door", source = "mm9_mechanism", targetName = "Pusher2" },
    [30477] = { kind = "open_door", source = "mm9_mechanism", targetName = "target1" },
    [30478] = { kind = "open_door", source = "mm9_mechanism", targetName = "target2" },
    [30479] = { kind = "open_door", source = "mm9_mechanism", targetName = "target3" },
    [30480] = { kind = "open_door", source = "mm9_mechanism", targetName = "target4" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30000, "drop", function()
    map.triggerMechanism(0, 2)
end, "drop")

RegisterEvent(30033, "resetlever1", function()
    map.triggerMechanism(33, 2)
end, "resetlever1")

RegisterEvent(30034, "resetlever2", function()
    map.triggerMechanism(34, 2)
end, "resetlever2")

RegisterEvent(30035, "resetlever3", function()
    map.triggerMechanism(35, 2)
end, "resetlever3")

RegisterEvent(30036, "resetlever4", function()
    map.triggerMechanism(36, 2)
end, "resetlever4")

RegisterEvent(30052, "dummy2door", function()
    map.triggerMechanism(52, 2)
end, "dummy2door")

RegisterEvent(30056, "d2w4", function()
    map.triggerMechanism(56, 2)
end, "d2w4")

RegisterEvent(30057, "d2w3", function()
    map.triggerMechanism(57, 2)
end, "d2w3")

RegisterEvent(30058, "d2w2", function()
    map.triggerMechanism(58, 2)
end, "d2w2")

RegisterEvent(30059, "d2w1", function()
    map.triggerMechanism(59, 2)
end, "d2w1")

RegisterEvent(30060, "dummy4door", function()
    map.triggerMechanism(60, 2)
end, "dummy4door")

RegisterEvent(30063, "dummy4guide", function()
    map.triggerMechanism(63, 2)
end, "dummy4guide")

RegisterEvent(30065, "d4w1", function()
    map.triggerMechanism(65, 2)
end, "d4w1")

RegisterEvent(30066, "d4w2", function()
    map.triggerMechanism(66, 2)
end, "d4w2")

RegisterEvent(30067, "d4w3", function()
    map.triggerMechanism(67, 2)
end, "d4w3")

RegisterEvent(30068, "d4w4", function()
    map.triggerMechanism(68, 2)
end, "d4w4")

RegisterEvent(30226, "RotatingDoor2", function()
    map.triggerMechanism(226, 2)
end, "RotatingDoor2")

RegisterEvent(30227, "RotatingDoor0", function()
    map.triggerMechanism(227, 2)
end, "RotatingDoor0")

RegisterEvent(30228, "RotatingDoor3", function()
    map.triggerMechanism(228, 2)
end, "RotatingDoor3")

RegisterEvent(30229, "RotatingDoor1", function()
    map.triggerMechanism(229, 2)
end, "RotatingDoor1")

RegisterEvent(30420, "dragonroomdoorR", function()
    map.triggerMechanism(420, 2)
end, "dragonroomdoorR")

RegisterEvent(30424, "dragonroomdoorL", function()
    map.triggerMechanism(424, 2)
end, "dragonroomdoorL")

RegisterEvent(30438, "Pusher0", function()
    map.triggerMechanism(438, 2)
end, "Pusher0")

RegisterEvent(30439, "Pusher1", function()
    map.triggerMechanism(439, 2)
end, "Pusher1")

RegisterEvent(30440, "Pusher2", function()
    map.triggerMechanism(440, 2)
end, "Pusher2")

RegisterEvent(30477, "target1", function()
    map.triggerMechanism(477, 2)
end, "target1")

RegisterEvent(30478, "target2", function()
    map.triggerMechanism(478, 2)
end, "target2")

RegisterEvent(30479, "target3", function()
    map.triggerMechanism(479, 2)
end, "target3")

RegisterEvent(30480, "target4", function()
    map.triggerMechanism(480, 2)
end, "target4")

map.scripts["th_jousttrellborg.scr"] = {
    source = "TH_JOUSTTRELLBORG.scr",
    registered_triggers = {
        { line = 66, message = "Go", callback = "Start" },
        { line = 67, message = "Stop", callback = "TurnOff" },
        { line = 68, message = "BackPos", callback = "StartAnimations" },
    },
    movement_commands = {
    },
}
map.scripts["th_lobbyghouls.scr"] = {
    source = "TH_LOBBYGHOULS.scr",
    registered_triggers = {
        { line = 86, message = "Go", callback = "RunUpStairs" },
        { line = 87, message = "Drop", callback = "DropGhouls" },
    },
    movement_commands = {
        { line = 57, command = "SetPos", arguments = "hMyObject, nNumX, nNumY, nNumZ" },
    },
}
map.scripts["th_lookouttrellborg.scr"] = {
    source = "TH_LOOKOUTTRELLBORG.scr",
    registered_triggers = {
        { line = 88, message = "Go", callback = "Start" },
        { line = 89, message = "Stop", callback = "TurnOff" },
    },
    movement_commands = {
    },
}
map.scripts["th_meantrellborg.scr"] = {
    source = "TH_MEANTRELLBORG.scr",
    registered_triggers = {
        { line = 86, message = "Go", callback = "Start" },
        { line = 87, message = "Stop", callback = "TurnOff" },
        { line = 88, message = "Switch", callback = "ResetSwitch" },
        { line = 89, message = "Throw", callback = "CheckStart" },
    },
    movement_commands = {
    },
}
map.scripts["th_orcsgossip.scr"] = {
    source = "TH_ORCSGOSSIP.scr",
    registered_triggers = {
        { line = 67, message = "Go", callback = "Start" },
        { line = 68, message = "Stop", callback = "TurnOff" },
    },
    movement_commands = {
    },
}
map.scripts["th_targetmgr.scr"] = {
    source = "TH_TARGETMGR.scr",
    registered_triggers = {
        { line = 29, message = "hit", callback = "OnTargetHit" },
        { line = 31, message = "openall", callback = "RaiseTargets" },
        { line = 32, message = "closeall", callback = "LowerTargets" },
    },
    movement_commands = {
    },
}
map.scripts["th_targetring.scr"] = {
    source = "TH_TARGETRING.scr",
    registered_triggers = {
        { line = 27, message = "on", callback = "TurnOn" },
        { line = 28, message = "off", callback = "TurnOff" },
    },
    movement_commands = {
    },
}
map.scripts["th_trainingorccommander.scr"] = {
    source = "TH_TRAININGORCCOMMANDER.scr",
    registered_triggers = {
        { line = 55, message = "Train", callback = "Start" },
        { line = 56, message = "Stop", callback = "TurnOff" },
    },
    movement_commands = {
    },
}
map.scripts["th_trainingorcobserver.scr"] = {
    source = "TH_TRAININGORCOBSERVER.scr",
    registered_triggers = {
        { line = 71, message = "Train", callback = "Start" },
        { line = 72, message = "Stop", callback = "TurnOff" },
    },
    movement_commands = {
    },
}
map.scripts["th_trainingorcs.scr"] = {
    source = "TH_TRAININGORCS.scr",
    registered_triggers = {
        { line = 67, message = "Train", callback = "Start" },
        { line = 68, message = "Stop", callback = "TurnOff" },
    },
    movement_commands = {
    },
}
map.scripts["trainingenter.scr"] = {
    source = "TRAININGENTER.scr",
    registered_triggers = {
        { line = 60, message = "Break", callback = "OnBreak" },
    },
    movement_commands = {
    },
}
map.scripts["traininghallexit.scr"] = {
    source = "TRAININGHALLEXIT.scr",
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
