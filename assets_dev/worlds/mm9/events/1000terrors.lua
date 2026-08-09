-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "1000terrors"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 443,
        source_name = "StartPoint0",
        x = 5202,
        y = -16630,
        z = 49,
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
        mechanism_id = 900145,
        event_id = 30145,
        source_object_index = 145,
        source_class = "DestructableBrush",
        source_name = "KnightObject0",
        kind = "destructible_brush",
        hint = "KnightObject0",
    },
    {
        mechanism_id = 900146,
        event_id = 30146,
        source_object_index = 146,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900147,
        event_id = 30147,
        source_object_index = 147,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900150,
        event_id = 30150,
        source_object_index = 150,
        source_class = "DestructableBrush",
        source_name = "SpawnPiece1",
        kind = "destructible_brush",
        hint = "SpawnPiece1",
    },
    {
        mechanism_id = 900155,
        event_id = 30155,
        source_object_index = 155,
        source_class = "DestructableBrush",
        source_name = "SpawnPiece0",
        kind = "destructible_brush",
        hint = "SpawnPiece0",
    },
    {
        mechanism_id = 900156,
        event_id = 30156,
        source_object_index = 156,
        source_class = "DestructableBrush",
        source_name = "SpawnPiece2",
        kind = "destructible_brush",
        hint = "SpawnPiece2",
    },
    {
        mechanism_id = 900157,
        event_id = 30157,
        source_object_index = 157,
        source_class = "DestructableBrush",
        source_name = "SpawnPiece3",
        kind = "destructible_brush",
        hint = "SpawnPiece3",
    },
    {
        mechanism_id = 900158,
        event_id = 30158,
        source_object_index = 158,
        source_class = "ScriptObject",
        source_name = "SpawnMgr",
        kind = "script_object",
        hint = "SpawnMgr",
    },
    {
        mechanism_id = 900163,
        event_id = 30163,
        source_object_index = 163,
        source_class = "ScriptObject",
        source_name = "SpawnLoc0",
        kind = "script_object",
        hint = "SpawnLoc0",
    },
    {
        mechanism_id = 900164,
        event_id = 30164,
        source_object_index = 164,
        source_class = "ScriptObject",
        source_name = "SpawnLoc1",
        kind = "script_object",
        hint = "SpawnLoc1",
    },
    {
        mechanism_id = 900165,
        event_id = 30165,
        source_object_index = 165,
        source_class = "ScriptObject",
        source_name = "SpawnLoc2",
        kind = "script_object",
        hint = "SpawnLoc2",
    },
    {
        mechanism_id = 900166,
        event_id = 30166,
        source_object_index = 166,
        source_class = "ScriptObject",
        source_name = "SpawnLoc3",
        kind = "script_object",
        hint = "SpawnLoc3",
    },
    {
        mechanism_id = 900188,
        event_id = 30188,
        source_object_index = 188,
        source_class = "Shooter",
        source_name = "Sorc0Shooter",
        kind = "shooter",
        hint = "Sorc0Shooter",
    },
    {
        mechanism_id = 900189,
        event_id = 30189,
        source_object_index = 189,
        source_class = "Shooter",
        source_name = "Sorc1Shooter",
        kind = "shooter",
        hint = "Sorc1Shooter",
    },
    {
        mechanism_id = 900204,
        event_id = 30204,
        source_object_index = 204,
        source_class = "RotatingDoor",
        source_name = "TrapTrigger0",
        kind = "rotating_door",
        hint = "TrapTrigger0",
        sounds = {
            ["open_start"] = {
                name = "Events/PendulumSwing.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Events/metalmetalscrape01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/PendulumSwing.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/metalmetalscrape01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900205,
        event_id = 30205,
        source_object_index = 205,
        source_class = "RotatingDoor",
        source_name = "TrapTrigger1",
        kind = "rotating_door",
        hint = "TrapTrigger1",
        sounds = {
            ["open_start"] = {
                name = "Events/PendulumSwing.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Events/metalmetalscrape01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/PendulumSwing.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/metalmetalscrape01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900216,
        event_id = 30216,
        source_object_index = 216,
        source_class = "Shooter",
        source_name = "Sorc0Shooter0",
        kind = "shooter",
        hint = "Sorc0Shooter0",
    },
    {
        mechanism_id = 900217,
        event_id = 30217,
        source_object_index = 217,
        source_class = "Shooter",
        source_name = "Sorc1Shooter0",
        kind = "shooter",
        hint = "Sorc1Shooter0",
    },
    {
        mechanism_id = 900224,
        event_id = 30224,
        source_object_index = 224,
        source_class = "RotatingDoor",
        source_name = "TrapTrigger2",
        kind = "rotating_door",
        hint = "TrapTrigger2",
        sounds = {
            ["open_start"] = {
                name = "Events/PendulumSwing.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Events/metalmetalscrape01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/PendulumSwing.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/metalmetalscrape01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900225,
        event_id = 30225,
        source_object_index = 225,
        source_class = "RotatingDoor",
        source_name = "TrapTrigger3",
        kind = "rotating_door",
        hint = "TrapTrigger3",
        sounds = {
            ["open_start"] = {
                name = "Events/PendulumSwing.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Events/metalmetalscrape01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/PendulumSwing.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/metalmetalscrape01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900226,
        event_id = 30226,
        source_object_index = 226,
        source_class = "Shooter",
        source_name = "Sorc1Shooter1",
        kind = "shooter",
        hint = "Sorc1Shooter1",
    },
    {
        mechanism_id = 900231,
        event_id = 30231,
        source_object_index = 231,
        source_class = "Shooter",
        source_name = "Sorc1Shooter2",
        kind = "shooter",
        hint = "Sorc1Shooter2",
    },
    {
        mechanism_id = 900246,
        event_id = 30246,
        source_object_index = 246,
        source_class = "RotatingDoor",
        source_name = "TrapTrigger4",
        kind = "rotating_door",
        hint = "TrapTrigger4",
        sounds = {
            ["open_start"] = {
                name = "Events/PendulumSwing.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Events/metalmetalscrape01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/PendulumSwing.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/metalmetalscrape01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900247,
        event_id = 30247,
        source_object_index = 247,
        source_class = "RotatingDoor",
        source_name = "TrapTrigger5",
        kind = "rotating_door",
        hint = "TrapTrigger5",
        sounds = {
            ["open_start"] = {
                name = "Events/PendulumSwing.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Events/metalmetalscrape01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/PendulumSwing.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/metalmetalscrape01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900252,
        event_id = 30252,
        source_object_index = 252,
        source_class = "Shooter",
        source_name = "SkelHeadShooter1",
        kind = "shooter",
        hint = "SkelHeadShooter1",
    },
    {
        mechanism_id = 900253,
        event_id = 30253,
        source_object_index = 253,
        source_class = "Shooter",
        source_name = "SkelHeadShooter0",
        kind = "shooter",
        hint = "SkelHeadShooter0",
    },
    {
        mechanism_id = 900254,
        event_id = 30254,
        source_object_index = 254,
        source_class = "Shooter",
        source_name = "SkelHeadShooter2",
        kind = "shooter",
        hint = "SkelHeadShooter2",
    },
    {
        mechanism_id = 900255,
        event_id = 30255,
        source_object_index = 255,
        source_class = "Shooter",
        source_name = "SkelHeadShooter3",
        kind = "shooter",
        hint = "SkelHeadShooter3",
    },
    {
        mechanism_id = 900262,
        event_id = 30262,
        source_object_index = 262,
        source_class = "Shooter",
        source_name = "Sorc0Shooter1",
        kind = "shooter",
        hint = "Sorc0Shooter1",
    },
    {
        mechanism_id = 900263,
        event_id = 30263,
        source_object_index = 263,
        source_class = "Shooter",
        source_name = "Sorc1Shooter3",
        kind = "shooter",
        hint = "Sorc1Shooter3",
    },
    {
        mechanism_id = 900371,
        event_id = 30371,
        source_object_index = 371,
        source_class = "ScriptObject",
        source_name = "TP4",
        kind = "script_object",
        hint = "TP4",
    },
    {
        mechanism_id = 900372,
        event_id = 30372,
        source_object_index = 372,
        source_class = "ScriptObject",
        source_name = "TP5",
        kind = "script_object",
        hint = "TP5",
    },
    {
        mechanism_id = 900389,
        event_id = 30389,
        source_object_index = 389,
        source_class = "ScriptObject",
        source_name = "TP0",
        kind = "script_object",
        hint = "TP0",
    },
    {
        mechanism_id = 900393,
        event_id = 30393,
        source_object_index = 393,
        source_class = "ScriptObject",
        source_name = "TP1",
        kind = "script_object",
        hint = "TP1",
    },
    {
        mechanism_id = 900394,
        event_id = 30394,
        source_object_index = 394,
        source_class = "ScriptObject",
        source_name = "TP2",
        kind = "script_object",
        hint = "TP2",
    },
    {
        mechanism_id = 900395,
        event_id = 30395,
        source_object_index = 395,
        source_class = "ScriptObject",
        source_name = "TP3",
        kind = "script_object",
        hint = "TP3",
    },
    {
        mechanism_id = 900435,
        event_id = 30435,
        source_object_index = 435,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900436,
        event_id = 30436,
        source_object_index = 436,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900437,
        event_id = 30437,
        source_object_index = 437,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900438,
        event_id = 30438,
        source_object_index = 438,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900439,
        event_id = 30439,
        source_object_index = 439,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 900440,
        event_id = 30440,
        source_object_index = 440,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 900441,
        event_id = 30441,
        source_object_index = 441,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 900446,
        event_id = 30446,
        source_object_index = 446,
        source_class = "ScriptObject",
        source_name = "NjamSpawnMarker0",
        kind = "script_object",
        hint = "NjamSpawnMarker0",
    },
    {
        mechanism_id = 900448,
        event_id = 30448,
        source_object_index = 448,
        source_class = "ScriptObject",
        source_name = "NjamSpawnMarker1",
        kind = "script_object",
        hint = "NjamSpawnMarker1",
    },
    {
        mechanism_id = 900450,
        event_id = 30450,
        source_object_index = 450,
        source_class = "ScriptObject",
        source_name = "NjamSpawnMarker2",
        kind = "script_object",
        hint = "NjamSpawnMarker2",
    },
    {
        mechanism_id = 900452,
        event_id = 30452,
        source_object_index = 452,
        source_class = "ScriptObject",
        source_name = "NjamSpawnMarker4",
        kind = "script_object",
        hint = "NjamSpawnMarker4",
    },
    {
        mechanism_id = 900453,
        event_id = 30453,
        source_object_index = 453,
        source_class = "ScriptObject",
        source_name = "NjamSpawnMarker5",
        kind = "script_object",
        hint = "NjamSpawnMarker5",
    },
    {
        mechanism_id = 900455,
        event_id = 30455,
        source_object_index = 455,
        source_class = "ScriptObject",
        source_name = "NjamSpawnMarker6",
        kind = "script_object",
        hint = "NjamSpawnMarker6",
    },
    {
        mechanism_id = 900457,
        event_id = 30457,
        source_object_index = 457,
        source_class = "ScriptObject",
        source_name = "NjamSpawnMarker7",
        kind = "script_object",
        hint = "NjamSpawnMarker7",
    },
    {
        mechanism_id = 900614,
        event_id = 30614,
        source_object_index = 614,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900615,
        event_id = 30615,
        source_object_index = 615,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 900758,
        event_id = 30758,
        source_object_index = 758,
        source_class = "AIBarrier",
        source_name = "AIBarrier2",
        kind = "ai_barrier",
        hint = "AIBarrier2",
    },
    {
        mechanism_id = 900759,
        event_id = 30759,
        source_object_index = 759,
        source_class = "AIBarrier",
        source_name = "AIBarrier3",
        kind = "ai_barrier",
        hint = "AIBarrier3",
    },
    {
        mechanism_id = 900825,
        event_id = 30825,
        source_object_index = 825,
        source_class = "AIBarrier",
        source_name = "AIBarrier4",
        kind = "ai_barrier",
        hint = "AIBarrier4",
    },
    {
        mechanism_id = 901743,
        event_id = 31743,
        source_object_index = 1743,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 901745,
        event_id = 31745,
        source_object_index = 1745,
        source_class = "BlueWater",
        source_name = "BlueWater2",
        kind = "water_volume",
        hint = "BlueWater2",
    },
    {
        mechanism_id = 901747,
        event_id = 31747,
        source_object_index = 1747,
        source_class = "BlueWater",
        source_name = "BlueWater6",
        kind = "water_volume",
        hint = "BlueWater6",
    },
    {
        mechanism_id = 901748,
        event_id = 31748,
        source_object_index = 1748,
        source_class = "BlueWater",
        source_name = "BlueWater5",
        kind = "water_volume",
        hint = "BlueWater5",
    },
    {
        mechanism_id = 901749,
        event_id = 31749,
        source_object_index = 1749,
        source_class = "BlueWater",
        source_name = "BlueWater4",
        kind = "water_volume",
        hint = "BlueWater4",
    },
    {
        mechanism_id = 901750,
        event_id = 31750,
        source_object_index = 1750,
        source_class = "BlueWater",
        source_name = "BlueWater1",
        kind = "water_volume",
        hint = "BlueWater1",
    },
    {
        mechanism_id = 901751,
        event_id = 31751,
        source_object_index = 1751,
        source_class = "RotatingDoor",
        source_name = "MiddleDoor5",
        kind = "rotating_door",
        hint = "MiddleDoor5",
    },
    {
        mechanism_id = 901752,
        event_id = 31752,
        source_object_index = 1752,
        source_class = "RotatingDoor",
        source_name = "MiddleDoor4",
        kind = "rotating_door",
        hint = "MiddleDoor4",
    },
    {
        mechanism_id = 901753,
        event_id = 31753,
        source_object_index = 1753,
        source_class = "RotatingDoor",
        source_name = "SecretDoor2",
        kind = "rotating_door",
        hint = "SecretDoor2",
    },
    {
        mechanism_id = 901755,
        event_id = 31755,
        source_object_index = 1755,
        source_class = "RotatingDoor",
        source_name = "TreasureDoor",
        kind = "rotating_door",
        hint = "TreasureDoor",
    },
    {
        mechanism_id = 901756,
        event_id = 31756,
        source_object_index = 1756,
        source_class = "RotatingDoor",
        source_name = "TreasureDoor0",
        kind = "rotating_door",
        hint = "TreasureDoor0",
    },
    {
        mechanism_id = 901757,
        event_id = 31757,
        source_object_index = 1757,
        source_class = "Door",
        source_name = "SBrick0",
        kind = "linear_door",
        hint = "SBrick0",
    },
    {
        mechanism_id = 901758,
        event_id = 31758,
        source_object_index = 1758,
        source_class = "Door",
        source_name = "SBrick1",
        kind = "linear_door",
        hint = "SBrick1",
    },
    {
        mechanism_id = 901759,
        event_id = 31759,
        source_object_index = 1759,
        source_class = "WeightedLift",
        source_name = "WeightedLift0",
        kind = "weighted_lift",
        hint = "WeightedLift0",
        sounds = {
            ["open_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/elestop.wav",
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
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/elestop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901760,
        event_id = 31760,
        source_object_index = 1760,
        source_class = "WeightedLift",
        source_name = "WeightedLift1",
        kind = "weighted_lift",
        hint = "WeightedLift1",
        sounds = {
            ["open_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/elestop.wav",
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
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/elestop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901761,
        event_id = 31761,
        source_object_index = 1761,
        source_class = "WeightedLift",
        source_name = "WeightedLift3",
        kind = "weighted_lift",
        hint = "WeightedLift3",
        sounds = {
            ["open_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/elestop.wav",
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
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/elestop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901762,
        event_id = 31762,
        source_object_index = 1762,
        source_class = "WeightedLift",
        source_name = "WeightedLift5",
        kind = "weighted_lift",
        hint = "WeightedLift5",
        sounds = {
            ["open_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/elestop.wav",
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
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/elestop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901763,
        event_id = 31763,
        source_object_index = 1763,
        source_class = "WeightedLift",
        source_name = "WeightedLift7",
        kind = "weighted_lift",
        hint = "WeightedLift7",
        sounds = {
            ["open_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/elestop.wav",
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
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/elestop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901764,
        event_id = 31764,
        source_object_index = 1764,
        source_class = "WeightedLift",
        source_name = "WeightedLift8",
        kind = "weighted_lift",
        hint = "WeightedLift8",
        sounds = {
            ["open_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/elestop.wav",
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
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/elestop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901765,
        event_id = 31765,
        source_object_index = 1765,
        source_class = "WeightedLift",
        source_name = "WeightedLift11",
        kind = "weighted_lift",
        hint = "WeightedLift11",
        sounds = {
            ["open_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/elestop.wav",
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
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/elestop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901766,
        event_id = 31766,
        source_object_index = 1766,
        source_class = "WeightedLift",
        source_name = "WeightedLift13",
        kind = "weighted_lift",
        hint = "WeightedLift13",
        sounds = {
            ["open_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/elestop.wav",
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
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/elestop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901767,
        event_id = 31767,
        source_object_index = 1767,
        source_class = "WeightedLift",
        source_name = "WeightedLift14",
        kind = "weighted_lift",
        hint = "WeightedLift14",
        sounds = {
            ["open_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/elestop.wav",
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
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/elestop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901768,
        event_id = 31768,
        source_object_index = 1768,
        source_class = "WeightedLift",
        source_name = "WeightedLift9",
        kind = "weighted_lift",
        hint = "WeightedLift9",
        sounds = {
            ["open_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/elestop.wav",
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
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/elestop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901769,
        event_id = 31769,
        source_object_index = 1769,
        source_class = "WeightedLift",
        source_name = "WeightedLift6",
        kind = "weighted_lift",
        hint = "WeightedLift6",
        sounds = {
            ["open_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/elestop.wav",
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
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/elestop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901770,
        event_id = 31770,
        source_object_index = 1770,
        source_class = "WeightedLift",
        source_name = "WeightedLift4",
        kind = "weighted_lift",
        hint = "WeightedLift4",
        sounds = {
            ["open_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/elestop.wav",
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
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/elestop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901771,
        event_id = 31771,
        source_object_index = 1771,
        source_class = "WeightedLift",
        source_name = "WeightedLift10",
        kind = "weighted_lift",
        hint = "WeightedLift10",
        sounds = {
            ["open_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/elestop.wav",
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
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/elestop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901772,
        event_id = 31772,
        source_object_index = 1772,
        source_class = "WeightedLift",
        source_name = "WeightedLift15",
        kind = "weighted_lift",
        hint = "WeightedLift15",
        sounds = {
            ["open_start"] = {
                name = "Door/elestart.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/elestop.wav",
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
                name = "Door/eleloop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/elestop.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901773,
        event_id = 31773,
        source_object_index = 1773,
        source_class = "Door",
        source_name = "CoffinGate1",
        kind = "linear_door",
        hint = "CoffinGate1",
    },
    {
        mechanism_id = 901774,
        event_id = 31774,
        source_object_index = 1774,
        source_class = "Door",
        source_name = "CoffinGate2",
        kind = "linear_door",
        hint = "CoffinGate2",
    },
    {
        mechanism_id = 901775,
        event_id = 31775,
        source_object_index = 1775,
        source_class = "Door",
        source_name = "ToWindMazeGate",
        kind = "linear_door",
        hint = "ToWindMazeGate",
    },
    {
        mechanism_id = 901776,
        event_id = 31776,
        source_object_index = 1776,
        source_class = "Door",
        source_name = "StairGate",
        kind = "linear_door",
        hint = "StairGate",
        sounds = {
            ["open_busy"] = {
                name = "Ambient/metalcreak01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901777,
        event_id = 31777,
        source_object_index = 1777,
        source_class = "Door",
        source_name = "StairGate0",
        kind = "linear_door",
        hint = "StairGate0",
    },
    {
        mechanism_id = 901778,
        event_id = 31778,
        source_object_index = 1778,
        source_class = "Door",
        source_name = "WaterGate0",
        kind = "linear_door",
        hint = "WaterGate0",
        sounds = {
            ["open_start"] = {
                name = "Ambient/metalcreak01.wav",
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
        mechanism_id = 901779,
        event_id = 31779,
        source_object_index = 1779,
        source_class = "Door",
        source_name = "WaterGate1",
        kind = "linear_door",
        hint = "WaterGate1",
        sounds = {
            ["open_start"] = {
                name = "Ambient/metalcreak01.wav",
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
        mechanism_id = 901780,
        event_id = 31780,
        source_object_index = 1780,
        source_class = "Door",
        source_name = "WaterGate2",
        kind = "linear_door",
        hint = "WaterGate2",
        sounds = {
            ["open_start"] = {
                name = "Ambient/metalcreak01.wav",
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
        mechanism_id = 901781,
        event_id = 31781,
        source_object_index = 1781,
        source_class = "Door",
        source_name = "Pull1",
        kind = "linear_door",
        hint = "Pull1",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901782,
        event_id = 31782,
        source_object_index = 1782,
        source_class = "ScriptObject",
        source_name = "ButtonTrigger",
        kind = "script_object",
        hint = "ButtonTrigger",
    },
    {
        mechanism_id = 901784,
        event_id = 31784,
        source_object_index = 1784,
        source_class = "Door",
        source_name = "PuzzleDoor0",
        kind = "linear_door",
        hint = "PuzzleDoor0",
    },
    {
        mechanism_id = 901785,
        event_id = 31785,
        source_object_index = 1785,
        source_class = "Door",
        source_name = "PuzzleDoor1",
        kind = "linear_door",
        hint = "PuzzleDoor1",
    },
    {
        mechanism_id = 901786,
        event_id = 31786,
        source_object_index = 1786,
        source_class = "Door",
        source_name = "PuzzleDoor10",
        kind = "linear_door",
        hint = "PuzzleDoor10",
    },
    {
        mechanism_id = 901787,
        event_id = 31787,
        source_object_index = 1787,
        source_class = "Door",
        source_name = "PuzzleDoor11",
        kind = "linear_door",
        hint = "PuzzleDoor11",
    },
    {
        mechanism_id = 901788,
        event_id = 31788,
        source_object_index = 1788,
        source_class = "Door",
        source_name = "PuzzleDoor12",
        kind = "linear_door",
        hint = "PuzzleDoor12",
    },
    {
        mechanism_id = 901789,
        event_id = 31789,
        source_object_index = 1789,
        source_class = "Door",
        source_name = "PuzzleDoor13",
        kind = "linear_door",
        hint = "PuzzleDoor13",
    },
    {
        mechanism_id = 901790,
        event_id = 31790,
        source_object_index = 1790,
        source_class = "Door",
        source_name = "PuzzleDoor14",
        kind = "linear_door",
        hint = "PuzzleDoor14",
    },
    {
        mechanism_id = 901791,
        event_id = 31791,
        source_object_index = 1791,
        source_class = "Door",
        source_name = "PuzzleDoor15",
        kind = "linear_door",
        hint = "PuzzleDoor15",
    },
    {
        mechanism_id = 901792,
        event_id = 31792,
        source_object_index = 1792,
        source_class = "Door",
        source_name = "PuzzleDoor2",
        kind = "linear_door",
        hint = "PuzzleDoor2",
    },
    {
        mechanism_id = 901793,
        event_id = 31793,
        source_object_index = 1793,
        source_class = "Door",
        source_name = "PuzzleDoor3",
        kind = "linear_door",
        hint = "PuzzleDoor3",
    },
    {
        mechanism_id = 901794,
        event_id = 31794,
        source_object_index = 1794,
        source_class = "Door",
        source_name = "PuzzleDoor4",
        kind = "linear_door",
        hint = "PuzzleDoor4",
    },
    {
        mechanism_id = 901795,
        event_id = 31795,
        source_object_index = 1795,
        source_class = "Door",
        source_name = "PuzzleDoor5",
        kind = "linear_door",
        hint = "PuzzleDoor5",
    },
    {
        mechanism_id = 901796,
        event_id = 31796,
        source_object_index = 1796,
        source_class = "Door",
        source_name = "PuzzleDoor6",
        kind = "linear_door",
        hint = "PuzzleDoor6",
    },
    {
        mechanism_id = 901797,
        event_id = 31797,
        source_object_index = 1797,
        source_class = "Door",
        source_name = "PuzzleDoor7",
        kind = "linear_door",
        hint = "PuzzleDoor7",
    },
    {
        mechanism_id = 901798,
        event_id = 31798,
        source_object_index = 1798,
        source_class = "Door",
        source_name = "PuzzleDoor8",
        kind = "linear_door",
        hint = "PuzzleDoor8",
    },
    {
        mechanism_id = 901799,
        event_id = 31799,
        source_object_index = 1799,
        source_class = "Door",
        source_name = "PuzzleDoor9",
        kind = "linear_door",
        hint = "PuzzleDoor9",
    },
    {
        mechanism_id = 901800,
        event_id = 31800,
        source_object_index = 1800,
        source_class = "Door",
        source_name = "PuzzleDoorB0",
        kind = "linear_door",
        hint = "PuzzleDoorB0",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901801,
        event_id = 31801,
        source_object_index = 1801,
        source_class = "Door",
        source_name = "PuzzleDoorB1",
        kind = "linear_door",
        hint = "PuzzleDoorB1",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901802,
        event_id = 31802,
        source_object_index = 1802,
        source_class = "Door",
        source_name = "PuzzleDoorB10",
        kind = "linear_door",
        hint = "PuzzleDoorB10",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901803,
        event_id = 31803,
        source_object_index = 1803,
        source_class = "Door",
        source_name = "PuzzleDoorB11",
        kind = "linear_door",
        hint = "PuzzleDoorB11",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901804,
        event_id = 31804,
        source_object_index = 1804,
        source_class = "Door",
        source_name = "PuzzleDoorB12",
        kind = "linear_door",
        hint = "PuzzleDoorB12",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901805,
        event_id = 31805,
        source_object_index = 1805,
        source_class = "Door",
        source_name = "PuzzleDoorB13",
        kind = "linear_door",
        hint = "PuzzleDoorB13",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901806,
        event_id = 31806,
        source_object_index = 1806,
        source_class = "Door",
        source_name = "PuzzleDoorB14",
        kind = "linear_door",
        hint = "PuzzleDoorB14",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901807,
        event_id = 31807,
        source_object_index = 1807,
        source_class = "Door",
        source_name = "PuzzleDoorB15",
        kind = "linear_door",
        hint = "PuzzleDoorB15",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901808,
        event_id = 31808,
        source_object_index = 1808,
        source_class = "Door",
        source_name = "PuzzleDoorB2",
        kind = "linear_door",
        hint = "PuzzleDoorB2",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901809,
        event_id = 31809,
        source_object_index = 1809,
        source_class = "Door",
        source_name = "PuzzleDoorB3",
        kind = "linear_door",
        hint = "PuzzleDoorB3",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901810,
        event_id = 31810,
        source_object_index = 1810,
        source_class = "Door",
        source_name = "PuzzleDoorB4",
        kind = "linear_door",
        hint = "PuzzleDoorB4",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901811,
        event_id = 31811,
        source_object_index = 1811,
        source_class = "Door",
        source_name = "PuzzleDoorB5",
        kind = "linear_door",
        hint = "PuzzleDoorB5",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901812,
        event_id = 31812,
        source_object_index = 1812,
        source_class = "Door",
        source_name = "PuzzleDoorB6",
        kind = "linear_door",
        hint = "PuzzleDoorB6",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901813,
        event_id = 31813,
        source_object_index = 1813,
        source_class = "Door",
        source_name = "PuzzleDoorB7",
        kind = "linear_door",
        hint = "PuzzleDoorB7",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901814,
        event_id = 31814,
        source_object_index = 1814,
        source_class = "Door",
        source_name = "PuzzleDoorB8",
        kind = "linear_door",
        hint = "PuzzleDoorB8",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901815,
        event_id = 31815,
        source_object_index = 1815,
        source_class = "Door",
        source_name = "PuzzleDoorB9",
        kind = "linear_door",
        hint = "PuzzleDoorB9",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901816,
        event_id = 31816,
        source_object_index = 1816,
        source_class = "Door",
        source_name = "Pull2",
        kind = "linear_door",
        hint = "Pull2",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901818,
        event_id = 31818,
        source_object_index = 1818,
        source_class = "ScriptObject",
        source_name = "ButtonTrigger0",
        kind = "script_object",
        hint = "ButtonTrigger0",
    },
    {
        mechanism_id = 901819,
        event_id = 31819,
        source_object_index = 1819,
        source_class = "Door",
        source_name = "Pull3",
        kind = "linear_door",
        hint = "Pull3",
        sounds = {
            ["open_start"] = {
                name = "Door/doorlatch01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901821,
        event_id = 31821,
        source_object_index = 1821,
        source_class = "Door",
        source_name = "PuzzleDoorC0",
        kind = "linear_door",
        hint = "PuzzleDoorC0",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901822,
        event_id = 31822,
        source_object_index = 1822,
        source_class = "Door",
        source_name = "PuzzleDoorC1",
        kind = "linear_door",
        hint = "PuzzleDoorC1",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901823,
        event_id = 31823,
        source_object_index = 1823,
        source_class = "Door",
        source_name = "PuzzleDoorC10",
        kind = "linear_door",
        hint = "PuzzleDoorC10",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901824,
        event_id = 31824,
        source_object_index = 1824,
        source_class = "Door",
        source_name = "PuzzleDoorC11",
        kind = "linear_door",
        hint = "PuzzleDoorC11",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901825,
        event_id = 31825,
        source_object_index = 1825,
        source_class = "Door",
        source_name = "PuzzleDoorC12",
        kind = "linear_door",
        hint = "PuzzleDoorC12",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901826,
        event_id = 31826,
        source_object_index = 1826,
        source_class = "Door",
        source_name = "PuzzleDoorC13",
        kind = "linear_door",
        hint = "PuzzleDoorC13",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901827,
        event_id = 31827,
        source_object_index = 1827,
        source_class = "Door",
        source_name = "PuzzleDoorC14",
        kind = "linear_door",
        hint = "PuzzleDoorC14",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901828,
        event_id = 31828,
        source_object_index = 1828,
        source_class = "Door",
        source_name = "PuzzleDoorC15",
        kind = "linear_door",
        hint = "PuzzleDoorC15",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901829,
        event_id = 31829,
        source_object_index = 1829,
        source_class = "Door",
        source_name = "PuzzleDoorC2",
        kind = "linear_door",
        hint = "PuzzleDoorC2",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901830,
        event_id = 31830,
        source_object_index = 1830,
        source_class = "Door",
        source_name = "PuzzleDoorC3",
        kind = "linear_door",
        hint = "PuzzleDoorC3",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901831,
        event_id = 31831,
        source_object_index = 1831,
        source_class = "Door",
        source_name = "PuzzleDoorC4",
        kind = "linear_door",
        hint = "PuzzleDoorC4",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901832,
        event_id = 31832,
        source_object_index = 1832,
        source_class = "Door",
        source_name = "PuzzleDoorC5",
        kind = "linear_door",
        hint = "PuzzleDoorC5",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901833,
        event_id = 31833,
        source_object_index = 1833,
        source_class = "Door",
        source_name = "PuzzleDoorC6",
        kind = "linear_door",
        hint = "PuzzleDoorC6",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901834,
        event_id = 31834,
        source_object_index = 1834,
        source_class = "Door",
        source_name = "PuzzleDoorC7",
        kind = "linear_door",
        hint = "PuzzleDoorC7",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901835,
        event_id = 31835,
        source_object_index = 1835,
        source_class = "Door",
        source_name = "PuzzleDoorC8",
        kind = "linear_door",
        hint = "PuzzleDoorC8",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901836,
        event_id = 31836,
        source_object_index = 1836,
        source_class = "Door",
        source_name = "PuzzleDoorC9",
        kind = "linear_door",
        hint = "PuzzleDoorC9",
        sounds = {
            ["open_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "PickUpItems/dropcloth.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901837,
        event_id = 31837,
        source_object_index = 1837,
        source_class = "ScriptObject",
        source_name = "ButtonTrigger1",
        kind = "script_object",
        hint = "ButtonTrigger1",
    },
    {
        mechanism_id = 901838,
        event_id = 31838,
        source_object_index = 1838,
        source_class = "RotatingDoor",
        source_name = "LowerDoor3",
        kind = "rotating_door",
        hint = "LowerDoor3",
    },
    {
        mechanism_id = 901839,
        event_id = 31839,
        source_object_index = 1839,
        source_class = "RotatingDoor",
        source_name = "LowerDoor4",
        kind = "rotating_door",
        hint = "LowerDoor4",
    },
    {
        mechanism_id = 901840,
        event_id = 31840,
        source_object_index = 1840,
        source_class = "RotatingDoor",
        source_name = "LowerDoor5",
        kind = "rotating_door",
        hint = "LowerDoor5",
    },
    {
        mechanism_id = 901841,
        event_id = 31841,
        source_object_index = 1841,
        source_class = "RotatingDoor",
        source_name = "LowerDoor6",
        kind = "rotating_door",
        hint = "LowerDoor6",
    },
    {
        mechanism_id = 901842,
        event_id = 31842,
        source_object_index = 1842,
        source_class = "RotatingDoor",
        source_name = "LowerDoor7",
        kind = "rotating_door",
        hint = "LowerDoor7",
    },
    {
        mechanism_id = 901843,
        event_id = 31843,
        source_object_index = 1843,
        source_class = "RotatingDoor",
        source_name = "LowerDoor8",
        kind = "rotating_door",
        hint = "LowerDoor8",
    },
    {
        mechanism_id = 901844,
        event_id = 31844,
        source_object_index = 1844,
        source_class = "RotatingDoor",
        source_name = "LowerDoor9",
        kind = "rotating_door",
        hint = "LowerDoor9",
    },
    {
        mechanism_id = 901845,
        event_id = 31845,
        source_object_index = 1845,
        source_class = "RotatingDoor",
        source_name = "LowerDoor10",
        kind = "rotating_door",
        hint = "LowerDoor10",
    },
    {
        mechanism_id = 901846,
        event_id = 31846,
        source_object_index = 1846,
        source_class = "RotatingDoor",
        source_name = "LowerDoor13",
        kind = "rotating_door",
        hint = "LowerDoor13",
    },
    {
        mechanism_id = 901847,
        event_id = 31847,
        source_object_index = 1847,
        source_class = "RotatingDoor",
        source_name = "LowerDoor14",
        kind = "rotating_door",
        hint = "LowerDoor14",
    },
    {
        mechanism_id = 901848,
        event_id = 31848,
        source_object_index = 1848,
        source_class = "RotatingDoor",
        source_name = "LowerDoor15",
        kind = "rotating_door",
        hint = "LowerDoor15",
    },
    {
        mechanism_id = 901849,
        event_id = 31849,
        source_object_index = 1849,
        source_class = "RotatingDoor",
        source_name = "LowerDoor16",
        kind = "rotating_door",
        hint = "LowerDoor16",
    },
    {
        mechanism_id = 901850,
        event_id = 31850,
        source_object_index = 1850,
        source_class = "RotatingDoor",
        source_name = "LowerDoor17",
        kind = "rotating_door",
        hint = "LowerDoor17",
    },
    {
        mechanism_id = 901851,
        event_id = 31851,
        source_object_index = 1851,
        source_class = "RotatingDoor",
        source_name = "LowerDoor18",
        kind = "rotating_door",
        hint = "LowerDoor18",
    },
    {
        mechanism_id = 901852,
        event_id = 31852,
        source_object_index = 1852,
        source_class = "Door",
        source_name = "IronDoor0",
        kind = "linear_door",
        hint = "IronDoor0",
    },
    {
        mechanism_id = 901853,
        event_id = 31853,
        source_object_index = 1853,
        source_class = "Door",
        source_name = "ToLowerTombGate",
        kind = "linear_door",
        hint = "ToLowerTombGate",
        sounds = {
            ["open_start"] = {
                name = "Ambient/metalcreak01.wav",
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
        mechanism_id = 902036,
        event_id = 32036,
        source_object_index = 2036,
        source_class = "ScriptObject",
        source_name = "NjamSpawnMarker3",
        kind = "script_object",
        hint = "NjamSpawnMarker3",
    },
    {
        mechanism_id = 902038,
        event_id = 32038,
        source_object_index = 2038,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor0",
        kind = "rotating_door",
        hint = "RotatingDoor0",
    },
    {
        mechanism_id = 902039,
        event_id = 32039,
        source_object_index = 2039,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor1",
        kind = "rotating_door",
        hint = "RotatingDoor1",
    },
    {
        mechanism_id = 902040,
        event_id = 32040,
        source_object_index = 2040,
        source_class = "RotatingDoor",
        source_name = "Rotating Lever 17",
        kind = "rotating_door",
        hint = "Rotating Lever 17",
    },
    {
        mechanism_id = 902041,
        event_id = 32041,
        source_object_index = 2041,
        source_class = "RotatingDoor",
        source_name = "Rotating Lever 16",
        kind = "rotating_door",
        hint = "Rotating Lever 16",
    },
    {
        mechanism_id = 902042,
        event_id = 32042,
        source_object_index = 2042,
        source_class = "RotatingDoor",
        source_name = "Rotating Lever 18",
        kind = "rotating_door",
        hint = "Rotating Lever 18",
    },
    {
        mechanism_id = 902043,
        event_id = 32043,
        source_object_index = 2043,
        source_class = "RotatingDoor",
        source_name = "TrapDoor2",
        kind = "rotating_door",
        hint = "TrapDoor2",
    },
    {
        mechanism_id = 902044,
        event_id = 32044,
        source_object_index = 2044,
        source_class = "RotatingDoor",
        source_name = "TrapDoor1",
        kind = "rotating_door",
        hint = "TrapDoor1",
    },
    {
        mechanism_id = 902045,
        event_id = 32045,
        source_object_index = 2045,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush0",
        kind = "destructible_brush",
        hint = "DestructableBrush0",
    },
    {
        mechanism_id = 902046,
        event_id = 32046,
        source_object_index = 2046,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush1",
        kind = "destructible_brush",
        hint = "DestructableBrush1",
    },
    {
        mechanism_id = 902047,
        event_id = 32047,
        source_object_index = 2047,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush2",
        kind = "destructible_brush",
        hint = "DestructableBrush2",
    },
    {
        mechanism_id = 902048,
        event_id = 32048,
        source_object_index = 2048,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush3",
        kind = "destructible_brush",
        hint = "DestructableBrush3",
    },
    {
        mechanism_id = 902049,
        event_id = 32049,
        source_object_index = 2049,
        source_class = "Shooter",
        source_name = "Shooter6",
        kind = "shooter",
        hint = "Shooter6",
    },
    {
        mechanism_id = 902050,
        event_id = 32050,
        source_object_index = 2050,
        source_class = "Shooter",
        source_name = "Shooter5",
        kind = "shooter",
        hint = "Shooter5",
    },
    {
        mechanism_id = 902051,
        event_id = 32051,
        source_object_index = 2051,
        source_class = "Shooter",
        source_name = "Shooter4",
        kind = "shooter",
        hint = "Shooter4",
    },
    {
        mechanism_id = 902052,
        event_id = 32052,
        source_object_index = 2052,
        source_class = "Shooter",
        source_name = "Shooter3",
        kind = "shooter",
        hint = "Shooter3",
    },
    {
        mechanism_id = 902053,
        event_id = 32053,
        source_object_index = 2053,
        source_class = "Shooter",
        source_name = "Shooter2",
        kind = "shooter",
        hint = "Shooter2",
    },
    {
        mechanism_id = 902054,
        event_id = 32054,
        source_object_index = 2054,
        source_class = "Shooter",
        source_name = "Shooter1",
        kind = "shooter",
        hint = "Shooter1",
    },
    {
        mechanism_id = 902079,
        event_id = 32079,
        source_object_index = 2079,
        source_class = "Door",
        source_name = "ShooterPlate1",
        kind = "linear_door",
        hint = "ShooterPlate1",
    },
    {
        mechanism_id = 902082,
        event_id = 32082,
        source_object_index = 2082,
        source_class = "Door",
        source_name = "ShooterPlate2",
        kind = "linear_door",
        hint = "ShooterPlate2",
    },
    {
        mechanism_id = 902084,
        event_id = 32084,
        source_object_index = 2084,
        source_class = "Door",
        source_name = "ShooterPlate3",
        kind = "linear_door",
        hint = "ShooterPlate3",
    },
    {
        mechanism_id = 902086,
        event_id = 32086,
        source_object_index = 2086,
        source_class = "Door",
        source_name = "ShooterPlate4",
        kind = "linear_door",
        hint = "ShooterPlate4",
    },
    {
        mechanism_id = 902088,
        event_id = 32088,
        source_object_index = 2088,
        source_class = "Door",
        source_name = "ShooterPlate5",
        kind = "linear_door",
        hint = "ShooterPlate5",
    },
    {
        mechanism_id = 902090,
        event_id = 32090,
        source_object_index = 2090,
        source_class = "Door",
        source_name = "ShooterPlate6",
        kind = "linear_door",
        hint = "ShooterPlate6",
    },
    {
        mechanism_id = 902092,
        event_id = 32092,
        source_object_index = 2092,
        source_class = "Door",
        source_name = "ShooterPlate7",
        kind = "linear_door",
        hint = "ShooterPlate7",
    },
    {
        mechanism_id = 902094,
        event_id = 32094,
        source_object_index = 2094,
        source_class = "Door",
        source_name = "ShooterPlate8",
        kind = "linear_door",
        hint = "ShooterPlate8",
    },
    {
        mechanism_id = 902096,
        event_id = 32096,
        source_object_index = 2096,
        source_class = "Door",
        source_name = "ShooterPlate9",
        kind = "linear_door",
        hint = "ShooterPlate9",
    },
    {
        mechanism_id = 902098,
        event_id = 32098,
        source_object_index = 2098,
        source_class = "Door",
        source_name = "ShooterPlate10",
        kind = "linear_door",
        hint = "ShooterPlate10",
    },
    {
        mechanism_id = 902100,
        event_id = 32100,
        source_object_index = 2100,
        source_class = "Door",
        source_name = "ShooterPlate11",
        kind = "linear_door",
        hint = "ShooterPlate11",
    },
    {
        mechanism_id = 902102,
        event_id = 32102,
        source_object_index = 2102,
        source_class = "Door",
        source_name = "ShooterPlate12",
        kind = "linear_door",
        hint = "ShooterPlate12",
    },
    {
        mechanism_id = 902104,
        event_id = 32104,
        source_object_index = 2104,
        source_class = "Door",
        source_name = "ShooterPlate14",
        kind = "linear_door",
        hint = "ShooterPlate14",
    },
    {
        mechanism_id = 902105,
        event_id = 32105,
        source_object_index = 2105,
        source_class = "Shooter",
        source_name = "Shooter18",
        kind = "shooter",
        hint = "Shooter18",
    },
    {
        mechanism_id = 902106,
        event_id = 32106,
        source_object_index = 2106,
        source_class = "Shooter",
        source_name = "Shooter19",
        kind = "shooter",
        hint = "Shooter19",
    },
    {
        mechanism_id = 902107,
        event_id = 32107,
        source_object_index = 2107,
        source_class = "Shooter",
        source_name = "Shooter20",
        kind = "shooter",
        hint = "Shooter20",
    },
    {
        mechanism_id = 902133,
        event_id = 32133,
        source_object_index = 2133,
        source_class = "Door",
        source_name = "FireballPlate",
        kind = "linear_door",
        hint = "FireballPlate",
    },
    {
        mechanism_id = 902134,
        event_id = 32134,
        source_object_index = 2134,
        source_class = "Shooter",
        source_name = "Shooter21",
        kind = "shooter",
        hint = "Shooter21",
    },
    {
        mechanism_id = 902135,
        event_id = 32135,
        source_object_index = 2135,
        source_class = "Shooter",
        source_name = "Shooter22",
        kind = "shooter",
        hint = "Shooter22",
    },
    {
        mechanism_id = 902136,
        event_id = 32136,
        source_object_index = 2136,
        source_class = "Shooter",
        source_name = "Shooter23",
        kind = "shooter",
        hint = "Shooter23",
    },
    {
        mechanism_id = 902137,
        event_id = 32137,
        source_object_index = 2137,
        source_class = "Door",
        source_name = "FireballPlate2",
        kind = "linear_door",
        hint = "FireballPlate2",
    },
    {
        mechanism_id = 902139,
        event_id = 32139,
        source_object_index = 2139,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush4",
        kind = "destructible_brush",
        hint = "DestructableBrush4",
    },
    {
        mechanism_id = 902140,
        event_id = 32140,
        source_object_index = 2140,
        source_class = "Door",
        source_name = "Door1",
        kind = "linear_door",
        hint = "Door1",
        sounds = {
            ["open_start"] = {
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
        },
    },
    {
        mechanism_id = 902141,
        event_id = 32141,
        source_object_index = 2141,
        source_class = "Door",
        source_name = "Door0",
        kind = "linear_door",
        hint = "Door0",
        sounds = {
            ["open_start"] = {
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
        },
    },
    {
        mechanism_id = 902142,
        event_id = 32142,
        source_object_index = 2142,
        source_class = "RotatingDoor",
        source_name = "FoyerDoorSouth1",
        kind = "rotating_door",
        hint = "FoyerDoorSouth1",
    },
    {
        mechanism_id = 902143,
        event_id = 32143,
        source_object_index = 2143,
        source_class = "RotatingDoor",
        source_name = "FoyerDoorSouth2",
        kind = "rotating_door",
        hint = "FoyerDoorSouth2",
    },
    {
        mechanism_id = 902145,
        event_id = 32145,
        source_object_index = 2145,
        source_class = "Door",
        source_name = "FoyerShooterPlate",
        kind = "linear_door",
        hint = "FoyerShooterPlate",
    },
    {
        mechanism_id = 902147,
        event_id = 32147,
        source_object_index = 2147,
        source_class = "Shooter",
        source_name = "FoyerShooter5",
        kind = "shooter",
        hint = "FoyerShooter5",
    },
    {
        mechanism_id = 902148,
        event_id = 32148,
        source_object_index = 2148,
        source_class = "Shooter",
        source_name = "FoyerShooter4",
        kind = "shooter",
        hint = "FoyerShooter4",
    },
    {
        mechanism_id = 902149,
        event_id = 32149,
        source_object_index = 2149,
        source_class = "Shooter",
        source_name = "FoyerShooter3",
        kind = "shooter",
        hint = "FoyerShooter3",
    },
    {
        mechanism_id = 902150,
        event_id = 32150,
        source_object_index = 2150,
        source_class = "Shooter",
        source_name = "FoyerShooter2",
        kind = "shooter",
        hint = "FoyerShooter2",
    },
    {
        mechanism_id = 902151,
        event_id = 32151,
        source_object_index = 2151,
        source_class = "Shooter",
        source_name = "FoyerShooter1",
        kind = "shooter",
        hint = "FoyerShooter1",
    },
    {
        mechanism_id = 902172,
        event_id = 32172,
        source_object_index = 2172,
        source_class = "RotatingDoor",
        source_name = "EDoor3",
        kind = "rotating_door",
        hint = "EDoor3",
    },
    {
        mechanism_id = 902173,
        event_id = 32173,
        source_object_index = 2173,
        source_class = "RotatingDoor",
        source_name = "EDoor4",
        kind = "rotating_door",
        hint = "EDoor4",
    },
    {
        mechanism_id = 902174,
        event_id = 32174,
        source_object_index = 2174,
        source_class = "RotatingDoor",
        source_name = "LowerLever",
        kind = "rotating_door",
        hint = "LowerLever",
    },
    {
        mechanism_id = 902175,
        event_id = 32175,
        source_object_index = 2175,
        source_class = "RotatingDoor",
        source_name = "LowerLever0",
        kind = "rotating_door",
        hint = "LowerLever0",
    },
    {
        mechanism_id = 902176,
        event_id = 32176,
        source_object_index = 2176,
        source_class = "RotatingBrush",
        source_name = "ElevatorGear1",
        kind = "rotating_brush",
        hint = "ElevatorGear1",
    },
    {
        mechanism_id = 902177,
        event_id = 32177,
        source_object_index = 2177,
        source_class = "RotatingBrush",
        source_name = "ElevatorGear2",
        kind = "rotating_brush",
        hint = "ElevatorGear2",
    },
    {
        mechanism_id = 902182,
        event_id = 32182,
        source_object_index = 2182,
        source_class = "Ladder",
        source_name = "Ladder7",
        kind = "ladder_volume",
        hint = "Ladder7",
    },
    {
        mechanism_id = 902183,
        event_id = 32183,
        source_object_index = 2183,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 902184,
        event_id = 32184,
        source_object_index = 2184,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 902185,
        event_id = 32185,
        source_object_index = 2185,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 902186,
        event_id = 32186,
        source_object_index = 2186,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 902187,
        event_id = 32187,
        source_object_index = 2187,
        source_class = "BlueWater",
        source_name = "BlueWater3",
        kind = "water_volume",
        hint = "BlueWater3",
    },
    {
        mechanism_id = 902192,
        event_id = 32192,
        source_object_index = 2192,
        source_class = "ScriptObject",
        source_name = "TauntMan",
        kind = "script_object",
        hint = "TauntMan",
    },
    {
        mechanism_id = 902197,
        event_id = 32197,
        source_object_index = 2197,
        source_class = "ScriptObject",
        source_name = "EndCount",
        kind = "script_object",
        hint = "EndCount",
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
    [30204] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrapTrigger0" },
    [30205] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrapTrigger1" },
    [30224] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrapTrigger2" },
    [30225] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrapTrigger3" },
    [30246] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrapTrigger4" },
    [30247] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrapTrigger5" },
    [31751] = { kind = "open_door", source = "mm9_mechanism", targetName = "MiddleDoor5" },
    [31752] = { kind = "open_door", source = "mm9_mechanism", targetName = "MiddleDoor4" },
    [31753] = { kind = "open_door", source = "mm9_mechanism", targetName = "SecretDoor2" },
    [31755] = { kind = "open_door", source = "mm9_mechanism", targetName = "TreasureDoor" },
    [31756] = { kind = "open_door", source = "mm9_mechanism", targetName = "TreasureDoor0" },
    [31757] = { kind = "open_door", source = "mm9_mechanism", targetName = "SBrick0" },
    [31758] = { kind = "open_door", source = "mm9_mechanism", targetName = "SBrick1" },
    [31759] = { kind = "generic_event", source = "mm9_mechanism", targetName = "WeightedLift0" },
    [31760] = { kind = "generic_event", source = "mm9_mechanism", targetName = "WeightedLift1" },
    [31761] = { kind = "generic_event", source = "mm9_mechanism", targetName = "WeightedLift3" },
    [31762] = { kind = "generic_event", source = "mm9_mechanism", targetName = "WeightedLift5" },
    [31763] = { kind = "generic_event", source = "mm9_mechanism", targetName = "WeightedLift7" },
    [31764] = { kind = "generic_event", source = "mm9_mechanism", targetName = "WeightedLift8" },
    [31765] = { kind = "generic_event", source = "mm9_mechanism", targetName = "WeightedLift11" },
    [31766] = { kind = "generic_event", source = "mm9_mechanism", targetName = "WeightedLift13" },
    [31767] = { kind = "generic_event", source = "mm9_mechanism", targetName = "WeightedLift14" },
    [31768] = { kind = "generic_event", source = "mm9_mechanism", targetName = "WeightedLift9" },
    [31769] = { kind = "generic_event", source = "mm9_mechanism", targetName = "WeightedLift6" },
    [31770] = { kind = "generic_event", source = "mm9_mechanism", targetName = "WeightedLift4" },
    [31771] = { kind = "generic_event", source = "mm9_mechanism", targetName = "WeightedLift10" },
    [31772] = { kind = "generic_event", source = "mm9_mechanism", targetName = "WeightedLift15" },
    [31773] = { kind = "open_door", source = "mm9_mechanism", targetName = "CoffinGate1" },
    [31774] = { kind = "open_door", source = "mm9_mechanism", targetName = "CoffinGate2" },
    [31775] = { kind = "open_door", source = "mm9_mechanism", targetName = "ToWindMazeGate" },
    [31776] = { kind = "open_door", source = "mm9_mechanism", targetName = "StairGate" },
    [31777] = { kind = "open_door", source = "mm9_mechanism", targetName = "StairGate0" },
    [31778] = { kind = "open_door", source = "mm9_mechanism", targetName = "WaterGate0" },
    [31779] = { kind = "open_door", source = "mm9_mechanism", targetName = "WaterGate1" },
    [31780] = { kind = "open_door", source = "mm9_mechanism", targetName = "WaterGate2" },
    [31781] = { kind = "open_door", source = "mm9_mechanism", targetName = "Pull1" },
    [31784] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoor0" },
    [31785] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoor1" },
    [31786] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoor10" },
    [31787] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoor11" },
    [31788] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoor12" },
    [31789] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoor13" },
    [31790] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoor14" },
    [31791] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoor15" },
    [31792] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoor2" },
    [31793] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoor3" },
    [31794] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoor4" },
    [31795] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoor5" },
    [31796] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoor6" },
    [31797] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoor7" },
    [31798] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoor8" },
    [31799] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoor9" },
    [31800] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorB0" },
    [31801] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorB1" },
    [31802] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorB10" },
    [31803] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorB11" },
    [31804] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorB12" },
    [31805] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorB13" },
    [31806] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorB14" },
    [31807] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorB15" },
    [31808] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorB2" },
    [31809] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorB3" },
    [31810] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorB4" },
    [31811] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorB5" },
    [31812] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorB6" },
    [31813] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorB7" },
    [31814] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorB8" },
    [31815] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorB9" },
    [31816] = { kind = "open_door", source = "mm9_mechanism", targetName = "Pull2" },
    [31819] = { kind = "open_door", source = "mm9_mechanism", targetName = "Pull3" },
    [31821] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorC0" },
    [31822] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorC1" },
    [31823] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorC10" },
    [31824] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorC11" },
    [31825] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorC12" },
    [31826] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorC13" },
    [31827] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorC14" },
    [31828] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorC15" },
    [31829] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorC2" },
    [31830] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorC3" },
    [31831] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorC4" },
    [31832] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorC5" },
    [31833] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorC6" },
    [31834] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorC7" },
    [31835] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorC8" },
    [31836] = { kind = "open_door", source = "mm9_mechanism", targetName = "PuzzleDoorC9" },
    [31838] = { kind = "open_door", source = "mm9_mechanism", targetName = "LowerDoor3" },
    [31839] = { kind = "open_door", source = "mm9_mechanism", targetName = "LowerDoor4" },
    [31840] = { kind = "open_door", source = "mm9_mechanism", targetName = "LowerDoor5" },
    [31841] = { kind = "open_door", source = "mm9_mechanism", targetName = "LowerDoor6" },
    [31842] = { kind = "open_door", source = "mm9_mechanism", targetName = "LowerDoor7" },
    [31843] = { kind = "open_door", source = "mm9_mechanism", targetName = "LowerDoor8" },
    [31844] = { kind = "open_door", source = "mm9_mechanism", targetName = "LowerDoor9" },
    [31845] = { kind = "open_door", source = "mm9_mechanism", targetName = "LowerDoor10" },
    [31846] = { kind = "open_door", source = "mm9_mechanism", targetName = "LowerDoor13" },
    [31847] = { kind = "open_door", source = "mm9_mechanism", targetName = "LowerDoor14" },
    [31848] = { kind = "open_door", source = "mm9_mechanism", targetName = "LowerDoor15" },
    [31849] = { kind = "open_door", source = "mm9_mechanism", targetName = "LowerDoor16" },
    [31850] = { kind = "open_door", source = "mm9_mechanism", targetName = "LowerDoor17" },
    [31851] = { kind = "open_door", source = "mm9_mechanism", targetName = "LowerDoor18" },
    [31852] = { kind = "open_door", source = "mm9_mechanism", targetName = "IronDoor0" },
    [31853] = { kind = "open_door", source = "mm9_mechanism", targetName = "ToLowerTombGate" },
    [32038] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0" },
    [32039] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor1" },
    [32040] = { kind = "open_door", source = "mm9_mechanism", targetName = "Rotating Lever 17" },
    [32041] = { kind = "open_door", source = "mm9_mechanism", targetName = "Rotating Lever 16" },
    [32042] = { kind = "open_door", source = "mm9_mechanism", targetName = "Rotating Lever 18" },
    [32043] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrapDoor2" },
    [32044] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrapDoor1" },
    [32079] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate1" },
    [32082] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate2" },
    [32084] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate3" },
    [32086] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate4" },
    [32088] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate5" },
    [32090] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate6" },
    [32092] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate7" },
    [32094] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate8" },
    [32096] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate9" },
    [32098] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate10" },
    [32100] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate11" },
    [32102] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate12" },
    [32104] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate14" },
    [32133] = { kind = "open_door", source = "mm9_mechanism", targetName = "FireballPlate" },
    [32137] = { kind = "open_door", source = "mm9_mechanism", targetName = "FireballPlate2" },
    [32140] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1" },
    [32141] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door0" },
    [32142] = { kind = "open_door", source = "mm9_mechanism", targetName = "FoyerDoorSouth1" },
    [32143] = { kind = "open_door", source = "mm9_mechanism", targetName = "FoyerDoorSouth2" },
    [32145] = { kind = "open_door", source = "mm9_mechanism", targetName = "FoyerShooterPlate" },
    [32172] = { kind = "open_door", source = "mm9_mechanism", targetName = "EDoor3" },
    [32173] = { kind = "open_door", source = "mm9_mechanism", targetName = "EDoor4" },
    [32174] = { kind = "open_door", source = "mm9_mechanism", targetName = "LowerLever" },
    [32175] = { kind = "open_door", source = "mm9_mechanism", targetName = "LowerLever0" },
    [32176] = { kind = "generic_event", source = "mm9_mechanism", targetName = "ElevatorGear1" },
    [32177] = { kind = "generic_event", source = "mm9_mechanism", targetName = "ElevatorGear2" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30204, "TrapTrigger0", function()
    map.triggerMechanism(204, 2)
end, "TrapTrigger0")

RegisterEvent(30205, "TrapTrigger1", function()
    map.triggerMechanism(205, 2)
end, "TrapTrigger1")

RegisterEvent(30224, "TrapTrigger2", function()
    map.triggerMechanism(224, 2)
end, "TrapTrigger2")

RegisterEvent(30225, "TrapTrigger3", function()
    map.triggerMechanism(225, 2)
end, "TrapTrigger3")

RegisterEvent(30246, "TrapTrigger4", function()
    map.triggerMechanism(246, 2)
end, "TrapTrigger4")

RegisterEvent(30247, "TrapTrigger5", function()
    map.triggerMechanism(247, 2)
end, "TrapTrigger5")

RegisterEvent(31751, "MiddleDoor5", function()
    map.triggerMechanism(1751, 2)
end, "MiddleDoor5")

RegisterEvent(31752, "MiddleDoor4", function()
    map.triggerMechanism(1752, 2)
end, "MiddleDoor4")

RegisterEvent(31753, "SecretDoor2", function()
    map.triggerMechanism(1753, 2)
end, "SecretDoor2")

RegisterEvent(31755, "TreasureDoor", function()
    map.triggerMechanism(1755, 2)
end, "TreasureDoor")

RegisterEvent(31756, "TreasureDoor0", function()
    map.triggerMechanism(1756, 2)
end, "TreasureDoor0")

RegisterEvent(31757, "SBrick0", function()
    map.triggerMechanism(1757, 2)
end, "SBrick0")

RegisterEvent(31758, "SBrick1", function()
    map.triggerMechanism(1758, 2)
end, "SBrick1")

RegisterEvent(31759, "WeightedLift0", function()
    map.triggerMechanism(1759, 2)
end, "WeightedLift0")

RegisterEvent(31760, "WeightedLift1", function()
    map.triggerMechanism(1760, 2)
end, "WeightedLift1")

RegisterEvent(31761, "WeightedLift3", function()
    map.triggerMechanism(1761, 2)
end, "WeightedLift3")

RegisterEvent(31762, "WeightedLift5", function()
    map.triggerMechanism(1762, 2)
end, "WeightedLift5")

RegisterEvent(31763, "WeightedLift7", function()
    map.triggerMechanism(1763, 2)
end, "WeightedLift7")

RegisterEvent(31764, "WeightedLift8", function()
    map.triggerMechanism(1764, 2)
end, "WeightedLift8")

RegisterEvent(31765, "WeightedLift11", function()
    map.triggerMechanism(1765, 2)
end, "WeightedLift11")

RegisterEvent(31766, "WeightedLift13", function()
    map.triggerMechanism(1766, 2)
end, "WeightedLift13")

RegisterEvent(31767, "WeightedLift14", function()
    map.triggerMechanism(1767, 2)
end, "WeightedLift14")

RegisterEvent(31768, "WeightedLift9", function()
    map.triggerMechanism(1768, 2)
end, "WeightedLift9")

RegisterEvent(31769, "WeightedLift6", function()
    map.triggerMechanism(1769, 2)
end, "WeightedLift6")

RegisterEvent(31770, "WeightedLift4", function()
    map.triggerMechanism(1770, 2)
end, "WeightedLift4")

RegisterEvent(31771, "WeightedLift10", function()
    map.triggerMechanism(1771, 2)
end, "WeightedLift10")

RegisterEvent(31772, "WeightedLift15", function()
    map.triggerMechanism(1772, 2)
end, "WeightedLift15")

RegisterEvent(31773, "CoffinGate1", function()
    map.triggerMechanism(1773, 2)
end, "CoffinGate1")

RegisterEvent(31774, "CoffinGate2", function()
    map.triggerMechanism(1774, 2)
end, "CoffinGate2")

RegisterEvent(31775, "ToWindMazeGate", function()
    map.triggerMechanism(1775, 2)
end, "ToWindMazeGate")

RegisterEvent(31776, "StairGate", function()
    map.triggerMechanism(1776, 2)
end, "StairGate")

RegisterEvent(31777, "StairGate0", function()
    map.triggerMechanism(1777, 2)
end, "StairGate0")

RegisterEvent(31778, "WaterGate0", function()
    map.triggerMechanism(1778, 2)
end, "WaterGate0")

RegisterEvent(31779, "WaterGate1", function()
    map.triggerMechanism(1779, 2)
end, "WaterGate1")

RegisterEvent(31780, "WaterGate2", function()
    map.triggerMechanism(1780, 2)
end, "WaterGate2")

RegisterEvent(31781, "Pull1", function()
    map.triggerMechanism(1781, 2)
end, "Pull1")

RegisterEvent(31784, "PuzzleDoor0", function()
    map.triggerMechanism(1784, 2)
end, "PuzzleDoor0")

RegisterEvent(31785, "PuzzleDoor1", function()
    map.triggerMechanism(1785, 2)
end, "PuzzleDoor1")

RegisterEvent(31786, "PuzzleDoor10", function()
    map.triggerMechanism(1786, 2)
end, "PuzzleDoor10")

RegisterEvent(31787, "PuzzleDoor11", function()
    map.triggerMechanism(1787, 2)
end, "PuzzleDoor11")

RegisterEvent(31788, "PuzzleDoor12", function()
    map.triggerMechanism(1788, 2)
end, "PuzzleDoor12")

RegisterEvent(31789, "PuzzleDoor13", function()
    map.triggerMechanism(1789, 2)
end, "PuzzleDoor13")

RegisterEvent(31790, "PuzzleDoor14", function()
    map.triggerMechanism(1790, 2)
end, "PuzzleDoor14")

RegisterEvent(31791, "PuzzleDoor15", function()
    map.triggerMechanism(1791, 2)
end, "PuzzleDoor15")

RegisterEvent(31792, "PuzzleDoor2", function()
    map.triggerMechanism(1792, 2)
end, "PuzzleDoor2")

RegisterEvent(31793, "PuzzleDoor3", function()
    map.triggerMechanism(1793, 2)
end, "PuzzleDoor3")

RegisterEvent(31794, "PuzzleDoor4", function()
    map.triggerMechanism(1794, 2)
end, "PuzzleDoor4")

RegisterEvent(31795, "PuzzleDoor5", function()
    map.triggerMechanism(1795, 2)
end, "PuzzleDoor5")

RegisterEvent(31796, "PuzzleDoor6", function()
    map.triggerMechanism(1796, 2)
end, "PuzzleDoor6")

RegisterEvent(31797, "PuzzleDoor7", function()
    map.triggerMechanism(1797, 2)
end, "PuzzleDoor7")

RegisterEvent(31798, "PuzzleDoor8", function()
    map.triggerMechanism(1798, 2)
end, "PuzzleDoor8")

RegisterEvent(31799, "PuzzleDoor9", function()
    map.triggerMechanism(1799, 2)
end, "PuzzleDoor9")

RegisterEvent(31800, "PuzzleDoorB0", function()
    map.triggerMechanism(1800, 2)
end, "PuzzleDoorB0")

RegisterEvent(31801, "PuzzleDoorB1", function()
    map.triggerMechanism(1801, 2)
end, "PuzzleDoorB1")

RegisterEvent(31802, "PuzzleDoorB10", function()
    map.triggerMechanism(1802, 2)
end, "PuzzleDoorB10")

RegisterEvent(31803, "PuzzleDoorB11", function()
    map.triggerMechanism(1803, 2)
end, "PuzzleDoorB11")

RegisterEvent(31804, "PuzzleDoorB12", function()
    map.triggerMechanism(1804, 2)
end, "PuzzleDoorB12")

RegisterEvent(31805, "PuzzleDoorB13", function()
    map.triggerMechanism(1805, 2)
end, "PuzzleDoorB13")

RegisterEvent(31806, "PuzzleDoorB14", function()
    map.triggerMechanism(1806, 2)
end, "PuzzleDoorB14")

RegisterEvent(31807, "PuzzleDoorB15", function()
    map.triggerMechanism(1807, 2)
end, "PuzzleDoorB15")

RegisterEvent(31808, "PuzzleDoorB2", function()
    map.triggerMechanism(1808, 2)
end, "PuzzleDoorB2")

RegisterEvent(31809, "PuzzleDoorB3", function()
    map.triggerMechanism(1809, 2)
end, "PuzzleDoorB3")

RegisterEvent(31810, "PuzzleDoorB4", function()
    map.triggerMechanism(1810, 2)
end, "PuzzleDoorB4")

RegisterEvent(31811, "PuzzleDoorB5", function()
    map.triggerMechanism(1811, 2)
end, "PuzzleDoorB5")

RegisterEvent(31812, "PuzzleDoorB6", function()
    map.triggerMechanism(1812, 2)
end, "PuzzleDoorB6")

RegisterEvent(31813, "PuzzleDoorB7", function()
    map.triggerMechanism(1813, 2)
end, "PuzzleDoorB7")

RegisterEvent(31814, "PuzzleDoorB8", function()
    map.triggerMechanism(1814, 2)
end, "PuzzleDoorB8")

RegisterEvent(31815, "PuzzleDoorB9", function()
    map.triggerMechanism(1815, 2)
end, "PuzzleDoorB9")

RegisterEvent(31816, "Pull2", function()
    map.triggerMechanism(1816, 2)
end, "Pull2")

RegisterEvent(31819, "Pull3", function()
    map.triggerMechanism(1819, 2)
end, "Pull3")

RegisterEvent(31821, "PuzzleDoorC0", function()
    map.triggerMechanism(1821, 2)
end, "PuzzleDoorC0")

RegisterEvent(31822, "PuzzleDoorC1", function()
    map.triggerMechanism(1822, 2)
end, "PuzzleDoorC1")

RegisterEvent(31823, "PuzzleDoorC10", function()
    map.triggerMechanism(1823, 2)
end, "PuzzleDoorC10")

RegisterEvent(31824, "PuzzleDoorC11", function()
    map.triggerMechanism(1824, 2)
end, "PuzzleDoorC11")

RegisterEvent(31825, "PuzzleDoorC12", function()
    map.triggerMechanism(1825, 2)
end, "PuzzleDoorC12")

RegisterEvent(31826, "PuzzleDoorC13", function()
    map.triggerMechanism(1826, 2)
end, "PuzzleDoorC13")

RegisterEvent(31827, "PuzzleDoorC14", function()
    map.triggerMechanism(1827, 2)
end, "PuzzleDoorC14")

RegisterEvent(31828, "PuzzleDoorC15", function()
    map.triggerMechanism(1828, 2)
end, "PuzzleDoorC15")

RegisterEvent(31829, "PuzzleDoorC2", function()
    map.triggerMechanism(1829, 2)
end, "PuzzleDoorC2")

RegisterEvent(31830, "PuzzleDoorC3", function()
    map.triggerMechanism(1830, 2)
end, "PuzzleDoorC3")

RegisterEvent(31831, "PuzzleDoorC4", function()
    map.triggerMechanism(1831, 2)
end, "PuzzleDoorC4")

RegisterEvent(31832, "PuzzleDoorC5", function()
    map.triggerMechanism(1832, 2)
end, "PuzzleDoorC5")

RegisterEvent(31833, "PuzzleDoorC6", function()
    map.triggerMechanism(1833, 2)
end, "PuzzleDoorC6")

RegisterEvent(31834, "PuzzleDoorC7", function()
    map.triggerMechanism(1834, 2)
end, "PuzzleDoorC7")

RegisterEvent(31835, "PuzzleDoorC8", function()
    map.triggerMechanism(1835, 2)
end, "PuzzleDoorC8")

RegisterEvent(31836, "PuzzleDoorC9", function()
    map.triggerMechanism(1836, 2)
end, "PuzzleDoorC9")

RegisterEvent(31838, "LowerDoor3", function()
    map.triggerMechanism(1838, 2)
end, "LowerDoor3")

RegisterEvent(31839, "LowerDoor4", function()
    map.triggerMechanism(1839, 2)
end, "LowerDoor4")

RegisterEvent(31840, "LowerDoor5", function()
    map.triggerMechanism(1840, 2)
end, "LowerDoor5")

RegisterEvent(31841, "LowerDoor6", function()
    map.triggerMechanism(1841, 2)
end, "LowerDoor6")

RegisterEvent(31842, "LowerDoor7", function()
    map.triggerMechanism(1842, 2)
end, "LowerDoor7")

RegisterEvent(31843, "LowerDoor8", function()
    map.triggerMechanism(1843, 2)
end, "LowerDoor8")

RegisterEvent(31844, "LowerDoor9", function()
    map.triggerMechanism(1844, 2)
end, "LowerDoor9")

RegisterEvent(31845, "LowerDoor10", function()
    map.triggerMechanism(1845, 2)
end, "LowerDoor10")

RegisterEvent(31846, "LowerDoor13", function()
    map.triggerMechanism(1846, 2)
end, "LowerDoor13")

RegisterEvent(31847, "LowerDoor14", function()
    map.triggerMechanism(1847, 2)
end, "LowerDoor14")

RegisterEvent(31848, "LowerDoor15", function()
    map.triggerMechanism(1848, 2)
end, "LowerDoor15")

RegisterEvent(31849, "LowerDoor16", function()
    map.triggerMechanism(1849, 2)
end, "LowerDoor16")

RegisterEvent(31850, "LowerDoor17", function()
    map.triggerMechanism(1850, 2)
end, "LowerDoor17")

RegisterEvent(31851, "LowerDoor18", function()
    map.triggerMechanism(1851, 2)
end, "LowerDoor18")

RegisterEvent(31852, "IronDoor0", function()
    map.triggerMechanism(1852, 2)
end, "IronDoor0")

RegisterEvent(31853, "ToLowerTombGate", function()
    map.triggerMechanism(1853, 2)
end, "ToLowerTombGate")

RegisterEvent(32038, "RotatingDoor0", function()
    map.triggerMechanism(2038, 2)
end, "RotatingDoor0")

RegisterEvent(32039, "RotatingDoor1", function()
    map.triggerMechanism(2039, 2)
end, "RotatingDoor1")

RegisterEvent(32040, "Rotating Lever 17", function()
    map.triggerMechanism(2040, 2)
end, "Rotating Lever 17")

RegisterEvent(32041, "Rotating Lever 16", function()
    map.triggerMechanism(2041, 2)
end, "Rotating Lever 16")

RegisterEvent(32042, "Rotating Lever 18", function()
    map.triggerMechanism(2042, 2)
end, "Rotating Lever 18")

RegisterEvent(32043, "TrapDoor2", function()
    map.triggerMechanism(2043, 2)
end, "TrapDoor2")

RegisterEvent(32044, "TrapDoor1", function()
    map.triggerMechanism(2044, 2)
end, "TrapDoor1")

RegisterEvent(32079, "ShooterPlate1", function()
    map.triggerMechanism(2079, 2)
end, "ShooterPlate1")

RegisterEvent(32082, "ShooterPlate2", function()
    map.triggerMechanism(2082, 2)
end, "ShooterPlate2")

RegisterEvent(32084, "ShooterPlate3", function()
    map.triggerMechanism(2084, 2)
end, "ShooterPlate3")

RegisterEvent(32086, "ShooterPlate4", function()
    map.triggerMechanism(2086, 2)
end, "ShooterPlate4")

RegisterEvent(32088, "ShooterPlate5", function()
    map.triggerMechanism(2088, 2)
end, "ShooterPlate5")

RegisterEvent(32090, "ShooterPlate6", function()
    map.triggerMechanism(2090, 2)
end, "ShooterPlate6")

RegisterEvent(32092, "ShooterPlate7", function()
    map.triggerMechanism(2092, 2)
end, "ShooterPlate7")

RegisterEvent(32094, "ShooterPlate8", function()
    map.triggerMechanism(2094, 2)
end, "ShooterPlate8")

RegisterEvent(32096, "ShooterPlate9", function()
    map.triggerMechanism(2096, 2)
end, "ShooterPlate9")

RegisterEvent(32098, "ShooterPlate10", function()
    map.triggerMechanism(2098, 2)
end, "ShooterPlate10")

RegisterEvent(32100, "ShooterPlate11", function()
    map.triggerMechanism(2100, 2)
end, "ShooterPlate11")

RegisterEvent(32102, "ShooterPlate12", function()
    map.triggerMechanism(2102, 2)
end, "ShooterPlate12")

RegisterEvent(32104, "ShooterPlate14", function()
    map.triggerMechanism(2104, 2)
end, "ShooterPlate14")

RegisterEvent(32133, "FireballPlate", function()
    map.triggerMechanism(2133, 2)
end, "FireballPlate")

RegisterEvent(32137, "FireballPlate2", function()
    map.triggerMechanism(2137, 2)
end, "FireballPlate2")

RegisterEvent(32140, "Door1", function()
    map.triggerMechanism(2140, 2)
end, "Door1")

RegisterEvent(32141, "Door0", function()
    map.triggerMechanism(2141, 2)
end, "Door0")

RegisterEvent(32142, "FoyerDoorSouth1", function()
    map.triggerMechanism(2142, 2)
end, "FoyerDoorSouth1")

RegisterEvent(32143, "FoyerDoorSouth2", function()
    map.triggerMechanism(2143, 2)
end, "FoyerDoorSouth2")

RegisterEvent(32145, "FoyerShooterPlate", function()
    map.triggerMechanism(2145, 2)
end, "FoyerShooterPlate")

RegisterEvent(32172, "EDoor3", function()
    map.triggerMechanism(2172, 2)
end, "EDoor3")

RegisterEvent(32173, "EDoor4", function()
    map.triggerMechanism(2173, 2)
end, "EDoor4")

RegisterEvent(32174, "LowerLever", function()
    map.triggerMechanism(2174, 2)
end, "LowerLever")

RegisterEvent(32175, "LowerLever0", function()
    map.triggerMechanism(2175, 2)
end, "LowerLever0")

RegisterEvent(32176, "ElevatorGear1", function()
    map.triggerMechanism(2176, 2)
end, "ElevatorGear1")

RegisterEvent(32177, "ElevatorGear2", function()
    map.triggerMechanism(2177, 2)
end, "ElevatorGear2")

map.scripts["1000t_circleshooter.scr"] = {
    source = "1000T_CIRCLESHOOTER.scr",
    registered_triggers = {
        { line = 54, message = "go", callback = "StartShooting" },
    },
    movement_commands = {
        { line = 90, command = "MoveToPos", arguments = "xMe,yMe,zMe, 500, UpdatePOS" },
    },
}
map.scripts["1000t_flyingcreature_.scr"] = {
    source = "1000T_FLYINGCREATURE_.scr",
    registered_triggers = {
        { line = 39, message = "go", callback = "TraverseBegin" },
    },
    movement_commands = {
    },
}
map.scripts["1000t_lightningshooter.scr"] = {
    source = "1000T_LIGHTNINGSHOOTER.scr",
    registered_triggers = {
        { line = 39, message = "Go", callback = "StartShooting" },
        { line = 40, message = "Stop", callback = "TurnOff" },
    },
    movement_commands = {
    },
}
map.scripts["1000t_skeletonhead.scr"] = {
    source = "1000T_SKELETONHEAD.scr",
    registered_triggers = {
        { line = 52, message = "Go", callback = "Start" },
        { line = 53, message = "Stop", callback = "TurnOff" },
    },
    movement_commands = {
        { line = 34, command = "Rotate", arguments = "0, 1, 0, 180, 180, TurnOff" },
    },
}
map.scripts["1000t_skheadshooter.scr"] = {
    source = "1000T_SKHEADSHOOTER.scr",
    registered_triggers = {
        { line = 52, message = "Go", callback = "StartShooting" },
    },
    movement_commands = {
    },
}
map.scripts["1000t_sorcstatues.scr"] = {
    source = "1000T_SORCSTATUES.scr",
    registered_triggers = {
        { line = 65, message = "Go", callback = "Start" },
        { line = 66, message = "Stop", callback = "TurnOff" },
    },
    movement_commands = {
    },
}
map.scripts["bootgive.scr"] = {
    source = "BOOTGIVE.scr",
    registered_triggers = {
        { line = 70, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["buttonpad.scr"] = {
    source = "BUTTONPAD.scr",
    registered_triggers = {
        { line = 548, message = "Button0", callback = "Button0" },
        { line = 549, message = "Button1", callback = "Button1" },
        { line = 550, message = "Button2", callback = "Button2" },
        { line = 551, message = "Button3", callback = "Button3" },
        { line = 552, message = "Button4", callback = "Button4" },
        { line = 553, message = "Button5", callback = "Button5" },
        { line = 554, message = "Button6", callback = "Button6" },
        { line = 555, message = "Button7", callback = "Button7" },
        { line = 556, message = "Button8", callback = "Button8" },
        { line = 557, message = "Button9", callback = "Button9" },
        { line = 558, message = "Button10", callback = "Button10" },
        { line = 559, message = "Button11", callback = "Button11" },
        { line = 560, message = "Button12", callback = "Button12" },
        { line = 561, message = "Button13", callback = "Button13" },
        { line = 562, message = "Button14", callback = "Button14" },
        { line = 563, message = "Button15", callback = "Button15" },
        { line = 564, message = "Reset", callback = "Reset" },
        { line = 565, message = "SetTrap", callback = "SetTrap" },
    },
    movement_commands = {
    },
}
map.scripts["buttonpuzzle.scr"] = {
    source = "BUTTONPUZZLE.scr",
    registered_triggers = {
        { line = 92, message = "Use", callback = "UseMe" },
        { line = 152, message = "TriggerMe", callback = "TriggerMe" },
        { line = 153, message = "MoveDoor", callback = "MoveDoor" },
        { line = 154, message = "TriggerTrap", callback = "TriggerTrap" },
        { line = 155, message = "UseStart", callback = "UseStart" },
    },
    movement_commands = {
        { line = 57, command = "MoveDir", arguments = "0, nMoveDir2, 0, nMoveDistA, 300, DoNothing" },
        { line = 117, command = "MoveDir", arguments = "0, nMoveDir, 0, nMoveDistB, nMoveSpeed, EndScript" },
        { line = 134, command = "MoveDir", arguments = "0, nMoveDir, 0, nMoveDistA, 0, DoNothing" },
    },
}
map.scripts["chessbishop.scr"] = {
    source = "CHESSBISHOP.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["chesscamera.scr"] = {
    source = "CHESSCAMERA.scr",
    registered_triggers = {
        { line = 23, message = "Look", callback = "ViewChessPiece" },
        { line = 24, message = "TurnOff", callback = "CameraOff" },
    },
    movement_commands = {
        { line = 45, command = "SetPos", arguments = "hPlayer,x,y,z" },
        { line = 74, command = "SetPOS", arguments = "hMe, x,y,z" },
    },
}
map.scripts["chessknight.scr"] = {
    source = "CHESSKNIGHT.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["chesspawn.scr"] = {
    source = "CHESSPAWN.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["chesssquare.scr"] = {
    source = "CHESSSQUARE.scr",
    registered_triggers = {
        { line = 33, message = "off", callback = "TurnOff" },
        { line = 34, message = "on", callback = "TurnOn" },
    },
    movement_commands = {
    },
}
map.scripts["doorlock.scr"] = {
    source = "DOORLOCK.scr",
    registered_triggers = {
        { line = 57, message = "use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["endcount.scr"] = {
    source = "ENDCOUNT.scr",
    registered_triggers = {
        { line = 64, message = "Spawned", callback = "OnSpawn" },
        { line = 65, message = "ForceSpawn", callback = "SpawnDemon" },
    },
    movement_commands = {
    },
}
map.scripts["endcounttrigger.scr"] = {
    source = "ENDCOUNTTRIGGER.scr",
    registered_triggers = {
        { line = 33, message = "default", callback = "OnSpawn" },
        { line = 34, message = "Count", callback = "OnSpawn" },
    },
    movement_commands = {
    },
}
map.scripts["flyrange.scr"] = {
    source = "FLYRANGE.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["giverandom.scr"] = {
    source = "GIVERANDOM.scr",
    registered_triggers = {
        { line = 52, message = "use", callback = "ProduceRandomEffect" },
    },
    movement_commands = {
    },
}
map.scripts["njamfreeze.scr"] = {
    source = "NJAMFREEZE.scr",
    registered_triggers = {
        { line = 229, message = "Chase", callback = "OnChase" },
        { line = 230, message = "Panic", callback = "OnPanic" },
        { line = 237, message = "Freeze", callback = "OnFreezeskin" },
    },
    movement_commands = {
    },
}
map.scripts["njamtaunt.scr"] = {
    source = "NJAMTAUNT.scr",
    registered_triggers = {
        { line = 111, message = "Start", callback = "OnStart" },
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
map.scripts["spawngeneric.scr"] = {
    source = "SPAWNGENERIC.scr",
    registered_triggers = {
        { line = 77, message = "Spawn", callback = "Onspawn" },
    },
    movement_commands = {
    },
}
map.scripts["spawnloc.scr"] = {
    source = "SPAWNLOC.scr",
    registered_triggers = {
        { line = 30, message = "On", callback = "TurnOn" },
        { line = 61, message = "spawn", callback = "RequestSpawn" },
        { line = 62, message = "focus", callback = "RequestFocus" },
        { line = 63, message = "off", callback = "TurnOff" },
    },
    movement_commands = {
    },
}
map.scripts["spawnmgr.scr"] = {
    source = "SPAWNMGR.scr",
    registered_triggers = {
        { line = 73, message = "SetLocation", callback = "SetLocation" },
        { line = 74, message = "Respawn", callback = "OnCreatureDied" },
        { line = 75, message = "ForceSpawn", callback = "SpawnCreature" },
        { line = 76, message = "Off", callback = "TurnOff" },
        { line = 77, message = "On", callback = "TurnOn" },
        { line = 153, message = "Respawn", callback = "OnCreatureDied" },
        { line = 164, message = "Respawn", callback = "AdjustTotals" },
    },
    movement_commands = {
    },
}
map.scripts["spawnnjam.scr"] = {
    source = "SPAWNNJAM.scr",
    registered_triggers = {
        { line = 180, message = "Spawn", callback = "Onspawn" },
        { line = 181, message = "KillNjam", callback = "Vanish2c" },
    },
    movement_commands = {
    },
}
map.scripts["tauntman.scr"] = {
    source = "TAUNTMAN.scr",
    registered_triggers = {
        { line = 112, message = "Start", callback = "OnStart" },
        { line = 113, message = "Arrive", callback = "OnCloseUp" },
        { line = 114, message = "VanishStart", callback = "OnFarCam" },
        { line = 115, message = "VanishDone", callback = "OnFadeOut" },
    },
    movement_commands = {
    },
}
map.scripts["wg_hand.scr"] = {
    source = "WG_HAND.scr",
    registered_triggers = {
        { line = 60, message = "Play", callback = "OnPlay" },
    },
    movement_commands = {
    },
}
map.scripts["wg_njamcam.scr"] = {
    source = "WG_NJAMCAM.scr",
    registered_triggers = {
        { line = 91, message = "Play", callback = "OnPlay" },
    },
    movement_commands = {
        { line = 40, command = "MoveToPos", arguments = "xpos Ypos Zpos 100 OnArrive1" },
        { line = 52, command = "MoveToPos", arguments = "xpos Ypos Zpos 130 OnArrive2" },
    },
}
map.scripts["wg_shot2cam.scr"] = {
    source = "WG_SHOT2CAM.scr",
    registered_triggers = {
        { line = 48, message = "Play", callback = "OnPlay" },
    },
    movement_commands = {
    },
}
map.scripts["wg_shot5cam.scr"] = {
    source = "WG_SHOT5CAM.scr",
    registered_triggers = {
        { line = 70, message = "Play", callback = "OnPlay" },
    },
    movement_commands = {
        { line = 45, command = "MoveToPos", arguments = "xpos Ypos Zpos 100 OnPanUp" },
    },
}
map.scripts["wg_shot7cam.scr"] = {
    source = "WG_SHOT7CAM.scr",
    registered_triggers = {
        { line = 99, message = "Play", callback = "OnPlay" },
    },
    movement_commands = {
        { line = 53, command = "MoveToPos", arguments = "xpos Ypos Zpos 75 OnArrive1" },
        { line = 63, command = "MoveToPos", arguments = "xpos Ypos Zpos 75 OnArrive2" },
        { line = 72, command = "MoveToPos", arguments = "xpos Ypos Zpos 75 OnArrive3" },
        { line = 81, command = "MoveToPos", arguments = "xpos Ypos Zpos 75 CutTo" },
    },
}
map.scripts["winman.scr"] = {
    source = "WINMAN.scr",
    registered_triggers = {
        { line = 611, message = "Use", callback = "OnUse" },
        { line = 612, message = "NjamCamDone", callback = "OnNjamCamDone" },
        { line = 613, message = "HandDone", callback = "ONHandDone" },
        { line = 614, message = "BallStart", callback = "OnBallStart" },
        { line = 615, message = "CameraSwitch", callback = "OnCameraSwitch" },
        { line = 616, message = "CameraSwitch2", callback = "OnCameraSwitch2" },
        { line = 617, message = "Frozen", callback = "OnFrozen" },
        { line = 618, message = "Panup", callback = "OnPanUp" },
        { line = 619, message = "CutTo", callback = "OnCutTo" },
        { line = 620, message = "Krohn", callback = "OnKrohn" },
        { line = 622, message = "CutToKrohn", callback = "OnKrohnCut" },
        { line = 624, message = "krohn1", callback = "OnKrohn1" },
        { line = 625, message = "Krohn2", callback = "OnKrohn2" },
        { line = 626, message = "krohn3", callback = "OnKrohn3" },
        { line = 627, message = "Krohn4", callback = "OnKrohn4" },
        { line = 628, message = "krohn5", callback = "OnKrohn5" },
        { line = 629, message = "Krohn6", callback = "OnKrohn6" },
        { line = 630, message = "krohn7", callback = "OnKrohn7" },
        { line = 631, message = "krohnClose", callback = "OnKrohnClose" },
        { line = 632, message = "Ever", callback = "OnEver" },
        { line = 636, message = "Hanndl1", callback = "OnHanndl1" },
        { line = 637, message = "Hanndl2", callback = "OnHanndl2" },
        { line = 638, message = "Hanndl3", callback = "OnHanndl3" },
        { line = 639, message = "Hanndl4", callback = "OnHanndl4" },
        { line = 640, message = "Hanndl5", callback = "OnHanndl5" },
        { line = 641, message = "Hanndl6", callback = "OnHanndl6" },
        { line = 642, message = "HanndlClose", callback = "OnHanndlClose" },
        { line = 644, message = "switch", callback = "onSwitch" },
        { line = 646, message = "End", callback = "End" },
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
