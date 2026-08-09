-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "yanmirsfort"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 0,
        source_name = "StartPoint0",
        x = -8197,
        y = -2458,
        z = 369,
        direction_yaw_units = 1536,
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
        mechanism_id = 900003,
        event_id = 30003,
        source_object_index = 3,
        source_class = "DestructableProp",
        source_name = "Table19",
        kind = "destructible_prop",
        hint = "Table19",
    },
    {
        mechanism_id = 900004,
        event_id = 30004,
        source_object_index = 4,
        source_class = "DestructableProp",
        source_name = "Table18",
        kind = "destructible_prop",
        hint = "Table18",
    },
    {
        mechanism_id = 900005,
        event_id = 30005,
        source_object_index = 5,
        source_class = "DestructableProp",
        source_name = "Table9",
        kind = "destructible_prop",
        hint = "Table9",
    },
    {
        mechanism_id = 900006,
        event_id = 30006,
        source_object_index = 6,
        source_class = "DestructableProp",
        source_name = "Table8",
        kind = "destructible_prop",
        hint = "Table8",
    },
    {
        mechanism_id = 900007,
        event_id = 30007,
        source_object_index = 7,
        source_class = "DestructableProp",
        source_name = "Table14",
        kind = "destructible_prop",
        hint = "Table14",
    },
    {
        mechanism_id = 900008,
        event_id = 30008,
        source_object_index = 8,
        source_class = "DestructableProp",
        source_name = "Table3",
        kind = "destructible_prop",
        hint = "Table3",
    },
    {
        mechanism_id = 900009,
        event_id = 30009,
        source_object_index = 9,
        source_class = "DestructableProp",
        source_name = "Table2",
        kind = "destructible_prop",
        hint = "Table2",
    },
    {
        mechanism_id = 900010,
        event_id = 30010,
        source_object_index = 10,
        source_class = "DestructableProp",
        source_name = "Table4",
        kind = "destructible_prop",
        hint = "Table4",
    },
    {
        mechanism_id = 900011,
        event_id = 30011,
        source_object_index = 11,
        source_class = "DestructableProp",
        source_name = "Table13",
        kind = "destructible_prop",
        hint = "Table13",
    },
    {
        mechanism_id = 900128,
        event_id = 30128,
        source_object_index = 128,
        source_class = "DestructableProp",
        source_name = "Crate",
        kind = "destructible_prop",
        hint = "Crate",
    },
    {
        mechanism_id = 900129,
        event_id = 30129,
        source_object_index = 129,
        source_class = "DestructableProp",
        source_name = "Crate0",
        kind = "destructible_prop",
        hint = "Crate0",
    },
    {
        mechanism_id = 900130,
        event_id = 30130,
        source_object_index = 130,
        source_class = "DestructableProp",
        source_name = "Crate1",
        kind = "destructible_prop",
        hint = "Crate1",
    },
    {
        mechanism_id = 900131,
        event_id = 30131,
        source_object_index = 131,
        source_class = "DestructableProp",
        source_name = "Crate2",
        kind = "destructible_prop",
        hint = "Crate2",
    },
    {
        mechanism_id = 900132,
        event_id = 30132,
        source_object_index = 132,
        source_class = "DestructableProp",
        source_name = "Crate3",
        kind = "destructible_prop",
        hint = "Crate3",
    },
    {
        mechanism_id = 900133,
        event_id = 30133,
        source_object_index = 133,
        source_class = "DestructableProp",
        source_name = "Crate4",
        kind = "destructible_prop",
        hint = "Crate4",
    },
    {
        mechanism_id = 900134,
        event_id = 30134,
        source_object_index = 134,
        source_class = "DestructableProp",
        source_name = "Crate5",
        kind = "destructible_prop",
        hint = "Crate5",
    },
    {
        mechanism_id = 900135,
        event_id = 30135,
        source_object_index = 135,
        source_class = "DestructableProp",
        source_name = "Crate6",
        kind = "destructible_prop",
        hint = "Crate6",
    },
    {
        mechanism_id = 900136,
        event_id = 30136,
        source_object_index = 136,
        source_class = "DestructableProp",
        source_name = "Crate7",
        kind = "destructible_prop",
        hint = "Crate7",
    },
    {
        mechanism_id = 900137,
        event_id = 30137,
        source_object_index = 137,
        source_class = "DestructableProp",
        source_name = "Crate8",
        kind = "destructible_prop",
        hint = "Crate8",
    },
    {
        mechanism_id = 900138,
        event_id = 30138,
        source_object_index = 138,
        source_class = "DestructableProp",
        source_name = "Crate9",
        kind = "destructible_prop",
        hint = "Crate9",
    },
    {
        mechanism_id = 900139,
        event_id = 30139,
        source_object_index = 139,
        source_class = "DestructableProp",
        source_name = "Crate10",
        kind = "destructible_prop",
        hint = "Crate10",
    },
    {
        mechanism_id = 900147,
        event_id = 30147,
        source_object_index = 147,
        source_class = "DestructableProp",
        source_name = "Barrel11",
        kind = "destructible_prop",
        hint = "Barrel11",
    },
    {
        mechanism_id = 900149,
        event_id = 30149,
        source_object_index = 149,
        source_class = "DestructableProp",
        source_name = "Barrel12",
        kind = "destructible_prop",
        hint = "Barrel12",
    },
    {
        mechanism_id = 900151,
        event_id = 30151,
        source_object_index = 151,
        source_class = "DestructableProp",
        source_name = "Barrel13",
        kind = "destructible_prop",
        hint = "Barrel13",
    },
    {
        mechanism_id = 900153,
        event_id = 30153,
        source_object_index = 153,
        source_class = "DestructableProp",
        source_name = "Crate12",
        kind = "destructible_prop",
        hint = "Crate12",
    },
    {
        mechanism_id = 900160,
        event_id = 30160,
        source_object_index = 160,
        source_class = "DestructableProp",
        source_name = "Barrel",
        kind = "destructible_prop",
        hint = "Barrel",
    },
    {
        mechanism_id = 900167,
        event_id = 30167,
        source_object_index = 167,
        source_class = "DestructableProp",
        source_name = "Barrel1",
        kind = "destructible_prop",
        hint = "Barrel1",
    },
    {
        mechanism_id = 900171,
        event_id = 30171,
        source_object_index = 171,
        source_class = "DestructableProp",
        source_name = "Barrel5",
        kind = "destructible_prop",
        hint = "Barrel5",
    },
    {
        mechanism_id = 900172,
        event_id = 30172,
        source_object_index = 172,
        source_class = "DestructableProp",
        source_name = "Barrel4",
        kind = "destructible_prop",
        hint = "Barrel4",
    },
    {
        mechanism_id = 900176,
        event_id = 30176,
        source_object_index = 176,
        source_class = "DestructableProp",
        source_name = "Barrel7",
        kind = "destructible_prop",
        hint = "Barrel7",
    },
    {
        mechanism_id = 900177,
        event_id = 30177,
        source_object_index = 177,
        source_class = "DestructableProp",
        source_name = "Barrel8",
        kind = "destructible_prop",
        hint = "Barrel8",
    },
    {
        mechanism_id = 900180,
        event_id = 30180,
        source_object_index = 180,
        source_class = "DestructableProp",
        source_name = "Barrel6",
        kind = "destructible_prop",
        hint = "Barrel6",
    },
    {
        mechanism_id = 900506,
        event_id = 30506,
        source_object_index = 506,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900507,
        event_id = 30507,
        source_object_index = 507,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900508,
        event_id = 30508,
        source_object_index = 508,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 900509,
        event_id = 30509,
        source_object_index = 509,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 900510,
        event_id = 30510,
        source_object_index = 510,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 900511,
        event_id = 30511,
        source_object_index = 511,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush6",
        kind = "collision_volume",
        hint = "InvisibleBrush6",
    },
    {
        mechanism_id = 900512,
        event_id = 30512,
        source_object_index = 512,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush7",
        kind = "collision_volume",
        hint = "InvisibleBrush7",
    },
    {
        mechanism_id = 900513,
        event_id = 30513,
        source_object_index = 513,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush8",
        kind = "collision_volume",
        hint = "InvisibleBrush8",
    },
    {
        mechanism_id = 900514,
        event_id = 30514,
        source_object_index = 514,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush9",
        kind = "collision_volume",
        hint = "InvisibleBrush9",
    },
    {
        mechanism_id = 900515,
        event_id = 30515,
        source_object_index = 515,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush10",
        kind = "collision_volume",
        hint = "InvisibleBrush10",
    },
    {
        mechanism_id = 900516,
        event_id = 30516,
        source_object_index = 516,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush11",
        kind = "collision_volume",
        hint = "InvisibleBrush11",
    },
    {
        mechanism_id = 900517,
        event_id = 30517,
        source_object_index = 517,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush12",
        kind = "collision_volume",
        hint = "InvisibleBrush12",
    },
    {
        mechanism_id = 900518,
        event_id = 30518,
        source_object_index = 518,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush13",
        kind = "collision_volume",
        hint = "InvisibleBrush13",
    },
    {
        mechanism_id = 900519,
        event_id = 30519,
        source_object_index = 519,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush14",
        kind = "collision_volume",
        hint = "InvisibleBrush14",
    },
    {
        mechanism_id = 900520,
        event_id = 30520,
        source_object_index = 520,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush15",
        kind = "collision_volume",
        hint = "InvisibleBrush15",
    },
    {
        mechanism_id = 900521,
        event_id = 30521,
        source_object_index = 521,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900522,
        event_id = 30522,
        source_object_index = 522,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 900523,
        event_id = 30523,
        source_object_index = 523,
        source_class = "AIBarrier",
        source_name = "AIBarrier2",
        kind = "ai_barrier",
        hint = "AIBarrier2",
    },
    {
        mechanism_id = 900524,
        event_id = 30524,
        source_object_index = 524,
        source_class = "AIBarrier",
        source_name = "AIBarrier3",
        kind = "ai_barrier",
        hint = "AIBarrier3",
    },
    {
        mechanism_id = 900525,
        event_id = 30525,
        source_object_index = 525,
        source_class = "AIBarrier",
        source_name = "AIBarrier4",
        kind = "ai_barrier",
        hint = "AIBarrier4",
    },
    {
        mechanism_id = 900526,
        event_id = 30526,
        source_object_index = 526,
        source_class = "AIBarrier",
        source_name = "AIBarrier5",
        kind = "ai_barrier",
        hint = "AIBarrier5",
    },
    {
        mechanism_id = 900527,
        event_id = 30527,
        source_object_index = 527,
        source_class = "AIBarrier",
        source_name = "AIBarrier6",
        kind = "ai_barrier",
        hint = "AIBarrier6",
    },
    {
        mechanism_id = 900528,
        event_id = 30528,
        source_object_index = 528,
        source_class = "AIBarrier",
        source_name = "AIBarrier7",
        kind = "ai_barrier",
        hint = "AIBarrier7",
    },
    {
        mechanism_id = 900529,
        event_id = 30529,
        source_object_index = 529,
        source_class = "AIBarrier",
        source_name = "AIBarrier8",
        kind = "ai_barrier",
        hint = "AIBarrier8",
    },
    {
        mechanism_id = 900530,
        event_id = 30530,
        source_object_index = 530,
        source_class = "AIBarrier",
        source_name = "AIBarrier9",
        kind = "ai_barrier",
        hint = "AIBarrier9",
    },
    {
        mechanism_id = 900531,
        event_id = 30531,
        source_object_index = 531,
        source_class = "AIBarrier",
        source_name = "AIBarrier10",
        kind = "ai_barrier",
        hint = "AIBarrier10",
    },
    {
        mechanism_id = 900532,
        event_id = 30532,
        source_object_index = 532,
        source_class = "AIBarrier",
        source_name = "AIBarrier11",
        kind = "ai_barrier",
        hint = "AIBarrier11",
    },
    {
        mechanism_id = 900533,
        event_id = 30533,
        source_object_index = 533,
        source_class = "AIBarrier",
        source_name = "AIBarrier12",
        kind = "ai_barrier",
        hint = "AIBarrier12",
    },
    {
        mechanism_id = 900534,
        event_id = 30534,
        source_object_index = 534,
        source_class = "AIBarrier",
        source_name = "AIBarrier13",
        kind = "ai_barrier",
        hint = "AIBarrier13",
    },
    {
        mechanism_id = 900535,
        event_id = 30535,
        source_object_index = 535,
        source_class = "AIBarrier",
        source_name = "AIBarrier14",
        kind = "ai_barrier",
        hint = "AIBarrier14",
    },
    {
        mechanism_id = 900536,
        event_id = 30536,
        source_object_index = 536,
        source_class = "AIBarrier",
        source_name = "AIBarrier15",
        kind = "ai_barrier",
        hint = "AIBarrier15",
    },
    {
        mechanism_id = 900537,
        event_id = 30537,
        source_object_index = 537,
        source_class = "AIBarrier",
        source_name = "AIBarrier16",
        kind = "ai_barrier",
        hint = "AIBarrier16",
    },
    {
        mechanism_id = 900538,
        event_id = 30538,
        source_object_index = 538,
        source_class = "AIBarrier",
        source_name = "AIBarrier17",
        kind = "ai_barrier",
        hint = "AIBarrier17",
    },
    {
        mechanism_id = 900539,
        event_id = 30539,
        source_object_index = 539,
        source_class = "AIBarrier",
        source_name = "AIBarrier18",
        kind = "ai_barrier",
        hint = "AIBarrier18",
    },
    {
        mechanism_id = 900540,
        event_id = 30540,
        source_object_index = 540,
        source_class = "AIBarrier",
        source_name = "AIBarrier19",
        kind = "ai_barrier",
        hint = "AIBarrier19",
    },
    {
        mechanism_id = 900559,
        event_id = 30559,
        source_object_index = 559,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 900605,
        event_id = 30605,
        source_object_index = 605,
        source_class = "ScriptObject",
        source_name = "Respawn0",
        kind = "script_object",
        hint = "Respawn0",
    },
    {
        mechanism_id = 900606,
        event_id = 30606,
        source_object_index = 606,
        source_class = "ScriptObject",
        source_name = "Respawn1",
        kind = "script_object",
        hint = "Respawn1",
    },
    {
        mechanism_id = 900608,
        event_id = 30608,
        source_object_index = 608,
        source_class = "ScriptObject",
        source_name = "Respawn2",
        kind = "script_object",
        hint = "Respawn2",
    },
    {
        mechanism_id = 900610,
        event_id = 30610,
        source_object_index = 610,
        source_class = "ScriptObject",
        source_name = "Respawn3",
        kind = "script_object",
        hint = "Respawn3",
    },
    {
        mechanism_id = 900614,
        event_id = 30614,
        source_object_index = 614,
        source_class = "ScriptObject",
        source_name = "YanmirTrap",
        kind = "script_object",
        hint = "YanmirTrap",
    },
    {
        mechanism_id = 900680,
        event_id = 30680,
        source_object_index = 680,
        source_class = "DestructableBrush",
        source_name = "YanDstruct0",
        kind = "destructible_brush",
        hint = "YanDstruct0",
    },
    {
        mechanism_id = 900681,
        event_id = 30681,
        source_object_index = 681,
        source_class = "DestructableBrush",
        source_name = "FallingFloor0",
        kind = "destructible_brush",
        hint = "FallingFloor0",
    },
    {
        mechanism_id = 900689,
        event_id = 30689,
        source_object_index = 689,
        source_class = "RotatingDoor",
        source_name = "Door1b27",
        kind = "rotating_door",
        hint = "Door1b27",
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
        mechanism_id = 900690,
        event_id = 30690,
        source_object_index = 690,
        source_class = "RotatingDoor",
        source_name = "Door1a27",
        kind = "rotating_door",
        hint = "Door1a27",
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
        mechanism_id = 900691,
        event_id = 30691,
        source_object_index = 691,
        source_class = "RotatingDoor",
        source_name = "Door1b29",
        kind = "rotating_door",
        hint = "Door1b29",
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
        mechanism_id = 900692,
        event_id = 30692,
        source_object_index = 692,
        source_class = "RotatingDoor",
        source_name = "Door1a29",
        kind = "rotating_door",
        hint = "Door1a29",
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
        mechanism_id = 900693,
        event_id = 30693,
        source_object_index = 693,
        source_class = "RotatingDoor",
        source_name = "Door1b30",
        kind = "rotating_door",
        hint = "Door1b30",
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
        mechanism_id = 900694,
        event_id = 30694,
        source_object_index = 694,
        source_class = "RotatingDoor",
        source_name = "Door1a30",
        kind = "rotating_door",
        hint = "Door1a30",
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
        mechanism_id = 900695,
        event_id = 30695,
        source_object_index = 695,
        source_class = "RotatingDoor",
        source_name = "Door1b31",
        kind = "rotating_door",
        hint = "Door1b31",
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
        mechanism_id = 900696,
        event_id = 30696,
        source_object_index = 696,
        source_class = "RotatingDoor",
        source_name = "Door1a31",
        kind = "rotating_door",
        hint = "Door1a31",
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
        mechanism_id = 900697,
        event_id = 30697,
        source_object_index = 697,
        source_class = "RotatingDoor",
        source_name = "Door1b35",
        kind = "rotating_door",
        hint = "Door1b35",
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
        mechanism_id = 900698,
        event_id = 30698,
        source_object_index = 698,
        source_class = "RotatingDoor",
        source_name = "Door1a35",
        kind = "rotating_door",
        hint = "Door1a35",
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
        mechanism_id = 900699,
        event_id = 30699,
        source_object_index = 699,
        source_class = "RotatingDoor",
        source_name = "Door1b36",
        kind = "rotating_door",
        hint = "Door1b36",
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
        mechanism_id = 900700,
        event_id = 30700,
        source_object_index = 700,
        source_class = "RotatingDoor",
        source_name = "Door1a36",
        kind = "rotating_door",
        hint = "Door1a36",
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
        mechanism_id = 900701,
        event_id = 30701,
        source_object_index = 701,
        source_class = "RotatingDoor",
        source_name = "DoorTeleportRight",
        kind = "rotating_door",
        hint = "DoorTeleportRight",
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
        mechanism_id = 900702,
        event_id = 30702,
        source_object_index = 702,
        source_class = "RotatingDoor",
        source_name = "DoorTeleportLeft",
        kind = "rotating_door",
        hint = "DoorTeleportLeft",
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
        mechanism_id = 900703,
        event_id = 30703,
        source_object_index = 703,
        source_class = "RotatingDoor",
        source_name = "Door1",
        kind = "rotating_door",
        hint = "Door1",
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
        mechanism_id = 900704,
        event_id = 30704,
        source_object_index = 704,
        source_class = "RotatingDoor",
        source_name = "Door2",
        kind = "rotating_door",
        hint = "Door2",
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
        mechanism_id = 900705,
        event_id = 30705,
        source_object_index = 705,
        source_class = "RotatingDoor",
        source_name = "Door3",
        kind = "rotating_door",
        hint = "Door3",
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
        mechanism_id = 900706,
        event_id = 30706,
        source_object_index = 706,
        source_class = "RotatingDoor",
        source_name = "Door4",
        kind = "rotating_door",
        hint = "Door4",
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
        mechanism_id = 900707,
        event_id = 30707,
        source_object_index = 707,
        source_class = "RotatingDoor",
        source_name = "Door5",
        kind = "rotating_door",
        hint = "Door5",
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
        mechanism_id = 900708,
        event_id = 30708,
        source_object_index = 708,
        source_class = "RotatingDoor",
        source_name = "Door6",
        kind = "rotating_door",
        hint = "Door6",
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
        mechanism_id = 900709,
        event_id = 30709,
        source_object_index = 709,
        source_class = "RotatingDoor",
        source_name = "Door7",
        kind = "rotating_door",
        hint = "Door7",
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
        mechanism_id = 900710,
        event_id = 30710,
        source_object_index = 710,
        source_class = "RotatingDoor",
        source_name = "Door8",
        kind = "rotating_door",
        hint = "Door8",
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
        mechanism_id = 900711,
        event_id = 30711,
        source_object_index = 711,
        source_class = "RotatingDoor",
        source_name = "Door9",
        kind = "rotating_door",
        hint = "Door9",
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
        mechanism_id = 900712,
        event_id = 30712,
        source_object_index = 712,
        source_class = "RotatingDoor",
        source_name = "Door10",
        kind = "rotating_door",
        hint = "Door10",
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
        mechanism_id = 900713,
        event_id = 30713,
        source_object_index = 713,
        source_class = "RotatingDoor",
        source_name = "Door11",
        kind = "rotating_door",
        hint = "Door11",
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
        mechanism_id = 900714,
        event_id = 30714,
        source_object_index = 714,
        source_class = "RotatingDoor",
        source_name = "Door12",
        kind = "rotating_door",
        hint = "Door12",
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
        mechanism_id = 900715,
        event_id = 30715,
        source_object_index = 715,
        source_class = "RotatingDoor",
        source_name = "Secretdoor",
        kind = "rotating_door",
        hint = "Secretdoor",
        sounds = {
            ["open_start"] = {
                name = "Door/doorslideopen.wav",
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
        },
    },
    {
        mechanism_id = 900717,
        event_id = 30717,
        source_object_index = 717,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor66",
        kind = "rotating_door",
        hint = "RotatingDoor66",
    },
    {
        mechanism_id = 900718,
        event_id = 30718,
        source_object_index = 718,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor67",
        kind = "rotating_door",
        hint = "RotatingDoor67",
    },
    {
        mechanism_id = 900719,
        event_id = 30719,
        source_object_index = 719,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor65",
        kind = "rotating_door",
        hint = "RotatingDoor65",
    },
    {
        mechanism_id = 900720,
        event_id = 30720,
        source_object_index = 720,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor64",
        kind = "rotating_door",
        hint = "RotatingDoor64",
    },
    {
        mechanism_id = 900721,
        event_id = 30721,
        source_object_index = 721,
        source_class = "RotatingDoor",
        source_name = "Door1a0",
        kind = "rotating_door",
        hint = "Door1a0",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900722,
        event_id = 30722,
        source_object_index = 722,
        source_class = "RotatingDoor",
        source_name = "Door1b0",
        kind = "rotating_door",
        hint = "Door1b0",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900723,
        event_id = 30723,
        source_object_index = 723,
        source_class = "RotatingDoor",
        source_name = "Door1a",
        kind = "rotating_door",
        hint = "Door1a",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900724,
        event_id = 30724,
        source_object_index = 724,
        source_class = "RotatingDoor",
        source_name = "Door1b",
        kind = "rotating_door",
        hint = "Door1b",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900725,
        event_id = 30725,
        source_object_index = 725,
        source_class = "RotatingDoor",
        source_name = "Door1a10",
        kind = "rotating_door",
        hint = "Door1a10",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900726,
        event_id = 30726,
        source_object_index = 726,
        source_class = "RotatingDoor",
        source_name = "Door1b10",
        kind = "rotating_door",
        hint = "Door1b10",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900727,
        event_id = 30727,
        source_object_index = 727,
        source_class = "RotatingDoor",
        source_name = "Door1a1",
        kind = "rotating_door",
        hint = "Door1a1",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900728,
        event_id = 30728,
        source_object_index = 728,
        source_class = "RotatingDoor",
        source_name = "Door1b1",
        kind = "rotating_door",
        hint = "Door1b1",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900729,
        event_id = 30729,
        source_object_index = 729,
        source_class = "RotatingDoor",
        source_name = "Door1a2",
        kind = "rotating_door",
        hint = "Door1a2",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900730,
        event_id = 30730,
        source_object_index = 730,
        source_class = "RotatingDoor",
        source_name = "Door1b2",
        kind = "rotating_door",
        hint = "Door1b2",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900731,
        event_id = 30731,
        source_object_index = 731,
        source_class = "RotatingDoor",
        source_name = "Door1a3",
        kind = "rotating_door",
        hint = "Door1a3",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900732,
        event_id = 30732,
        source_object_index = 732,
        source_class = "RotatingDoor",
        source_name = "Door1b3",
        kind = "rotating_door",
        hint = "Door1b3",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900733,
        event_id = 30733,
        source_object_index = 733,
        source_class = "RotatingDoor",
        source_name = "Door1a4",
        kind = "rotating_door",
        hint = "Door1a4",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900734,
        event_id = 30734,
        source_object_index = 734,
        source_class = "RotatingDoor",
        source_name = "Door1b4",
        kind = "rotating_door",
        hint = "Door1b4",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900735,
        event_id = 30735,
        source_object_index = 735,
        source_class = "RotatingDoor",
        source_name = "Door1a5",
        kind = "rotating_door",
        hint = "Door1a5",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900736,
        event_id = 30736,
        source_object_index = 736,
        source_class = "RotatingDoor",
        source_name = "Door1b5",
        kind = "rotating_door",
        hint = "Door1b5",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900737,
        event_id = 30737,
        source_object_index = 737,
        source_class = "RotatingDoor",
        source_name = "Door1a6",
        kind = "rotating_door",
        hint = "Door1a6",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900738,
        event_id = 30738,
        source_object_index = 738,
        source_class = "RotatingDoor",
        source_name = "Door1b6",
        kind = "rotating_door",
        hint = "Door1b6",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900739,
        event_id = 30739,
        source_object_index = 739,
        source_class = "RotatingDoor",
        source_name = "Door1a7",
        kind = "rotating_door",
        hint = "Door1a7",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900740,
        event_id = 30740,
        source_object_index = 740,
        source_class = "RotatingDoor",
        source_name = "Door1b7",
        kind = "rotating_door",
        hint = "Door1b7",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900741,
        event_id = 30741,
        source_object_index = 741,
        source_class = "RotatingDoor",
        source_name = "Door1a8",
        kind = "rotating_door",
        hint = "Door1a8",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900742,
        event_id = 30742,
        source_object_index = 742,
        source_class = "RotatingDoor",
        source_name = "Door1b8",
        kind = "rotating_door",
        hint = "Door1b8",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900743,
        event_id = 30743,
        source_object_index = 743,
        source_class = "RotatingDoor",
        source_name = "Door1a9",
        kind = "rotating_door",
        hint = "Door1a9",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900744,
        event_id = 30744,
        source_object_index = 744,
        source_class = "RotatingDoor",
        source_name = "Door1b9",
        kind = "rotating_door",
        hint = "Door1b9",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900745,
        event_id = 30745,
        source_object_index = 745,
        source_class = "RotatingDoor",
        source_name = "Door1a20",
        kind = "rotating_door",
        hint = "Door1a20",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900746,
        event_id = 30746,
        source_object_index = 746,
        source_class = "RotatingDoor",
        source_name = "Door1b20",
        kind = "rotating_door",
        hint = "Door1b20",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900747,
        event_id = 30747,
        source_object_index = 747,
        source_class = "RotatingDoor",
        source_name = "Door1a21",
        kind = "rotating_door",
        hint = "Door1a21",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900748,
        event_id = 30748,
        source_object_index = 748,
        source_class = "RotatingDoor",
        source_name = "Door1b21",
        kind = "rotating_door",
        hint = "Door1b21",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900749,
        event_id = 30749,
        source_object_index = 749,
        source_class = "RotatingDoor",
        source_name = "Door1a22",
        kind = "rotating_door",
        hint = "Door1a22",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900750,
        event_id = 30750,
        source_object_index = 750,
        source_class = "RotatingDoor",
        source_name = "Door1b22",
        kind = "rotating_door",
        hint = "Door1b22",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900751,
        event_id = 30751,
        source_object_index = 751,
        source_class = "RotatingDoor",
        source_name = "Door1a23",
        kind = "rotating_door",
        hint = "Door1a23",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900752,
        event_id = 30752,
        source_object_index = 752,
        source_class = "RotatingDoor",
        source_name = "Door1b23",
        kind = "rotating_door",
        hint = "Door1b23",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900753,
        event_id = 30753,
        source_object_index = 753,
        source_class = "RotatingDoor",
        source_name = "Door1a24",
        kind = "rotating_door",
        hint = "Door1a24",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900754,
        event_id = 30754,
        source_object_index = 754,
        source_class = "RotatingDoor",
        source_name = "Door1b24",
        kind = "rotating_door",
        hint = "Door1b24",
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
                name = "Door/doorslammetal03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900755,
        event_id = 30755,
        source_object_index = 755,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor61",
        kind = "rotating_door",
        hint = "RotatingDoor61",
    },
    {
        mechanism_id = 900756,
        event_id = 30756,
        source_object_index = 756,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor62",
        kind = "rotating_door",
        hint = "RotatingDoor62",
    },
    {
        mechanism_id = 900757,
        event_id = 30757,
        source_object_index = 757,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor63",
        kind = "rotating_door",
        hint = "RotatingDoor63",
    },
    {
        mechanism_id = 900758,
        event_id = 30758,
        source_object_index = 758,
        source_class = "DestructableBrush",
        source_name = "Xbeams0",
        kind = "destructible_brush",
        hint = "Xbeams0",
    },
    {
        mechanism_id = 900759,
        event_id = 30759,
        source_object_index = 759,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush0",
        kind = "destructible_brush",
        hint = "DestructableBrush0",
    },
    {
        mechanism_id = 900760,
        event_id = 30760,
        source_object_index = 760,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush1",
        kind = "destructible_brush",
        hint = "DestructableBrush1",
    },
    {
        mechanism_id = 900761,
        event_id = 30761,
        source_object_index = 761,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush2",
        kind = "destructible_brush",
        hint = "DestructableBrush2",
    },
    {
        mechanism_id = 900762,
        event_id = 30762,
        source_object_index = 762,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush3",
        kind = "destructible_brush",
        hint = "DestructableBrush3",
    },
    {
        mechanism_id = 900763,
        event_id = 30763,
        source_object_index = 763,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush4",
        kind = "destructible_brush",
        hint = "DestructableBrush4",
    },
    {
        mechanism_id = 900764,
        event_id = 30764,
        source_object_index = 764,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush5",
        kind = "destructible_brush",
        hint = "DestructableBrush5",
    },
    {
        mechanism_id = 900765,
        event_id = 30765,
        source_object_index = 765,
        source_class = "DestructableBrush",
        source_name = "Planks0",
        kind = "destructible_brush",
        hint = "Planks0",
    },
    {
        mechanism_id = 900772,
        event_id = 30772,
        source_object_index = 772,
        source_class = "ScriptObject",
        source_name = "Givekey",
        kind = "script_object",
        hint = "Givekey",
    },
    {
        mechanism_id = 900780,
        event_id = 30780,
        source_object_index = 780,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900781,
        event_id = 30781,
        source_object_index = 781,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900782,
        event_id = 30782,
        source_object_index = 782,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900783,
        event_id = 30783,
        source_object_index = 783,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900784,
        event_id = 30784,
        source_object_index = 784,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 900785,
        event_id = 30785,
        source_object_index = 785,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 900786,
        event_id = 30786,
        source_object_index = 786,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 900787,
        event_id = 30787,
        source_object_index = 787,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush7",
        kind = "perception_brush",
        hint = "PerceptionBrush7",
    },
    {
        mechanism_id = 900807,
        event_id = 30807,
        source_object_index = 807,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900808,
        event_id = 30808,
        source_object_index = 808,
        source_class = "DestructableProp",
        source_name = "Crate11",
        kind = "destructible_prop",
        hint = "Crate11",
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
    [30689] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b27" },
    [30690] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a27" },
    [30691] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b29" },
    [30692] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a29" },
    [30693] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b30" },
    [30694] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a30" },
    [30695] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b31" },
    [30696] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a31" },
    [30697] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b35" },
    [30698] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a35" },
    [30699] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b36" },
    [30700] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a36" },
    [30701] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoorTeleportRight" },
    [30702] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoorTeleportLeft" },
    [30703] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1" },
    [30704] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door2" },
    [30705] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door3" },
    [30706] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door4" },
    [30707] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door5" },
    [30708] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door6" },
    [30709] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door7" },
    [30710] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door8" },
    [30711] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door9" },
    [30712] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door10" },
    [30713] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door11" },
    [30714] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door12" },
    [30715] = { kind = "open_door", source = "mm9_mechanism", targetName = "Secretdoor" },
    [30717] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor66" },
    [30718] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor67" },
    [30719] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor65" },
    [30720] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor64" },
    [30721] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a0" },
    [30722] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b0" },
    [30723] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a" },
    [30724] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b" },
    [30725] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a10" },
    [30726] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b10" },
    [30727] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a1" },
    [30728] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b1" },
    [30729] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a2" },
    [30730] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b2" },
    [30731] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a3" },
    [30732] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b3" },
    [30733] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a4" },
    [30734] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b4" },
    [30735] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a5" },
    [30736] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b5" },
    [30737] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a6" },
    [30738] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b6" },
    [30739] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a7" },
    [30740] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b7" },
    [30741] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a8" },
    [30742] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b8" },
    [30743] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a9" },
    [30744] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b9" },
    [30745] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a20" },
    [30746] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b20" },
    [30747] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a21" },
    [30748] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b21" },
    [30749] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a22" },
    [30750] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b22" },
    [30751] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a23" },
    [30752] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b23" },
    [30753] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1a24" },
    [30754] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1b24" },
    [30755] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor61" },
    [30756] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor62" },
    [30757] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor63" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30689, "Door1b27", function()
    map.triggerMechanism(689, 2)
end, "Door1b27")

RegisterEvent(30690, "Door1a27", function()
    map.triggerMechanism(690, 2)
end, "Door1a27")

RegisterEvent(30691, "Door1b29", function()
    map.triggerMechanism(691, 2)
end, "Door1b29")

RegisterEvent(30692, "Door1a29", function()
    map.triggerMechanism(692, 2)
end, "Door1a29")

RegisterEvent(30693, "Door1b30", function()
    map.triggerMechanism(693, 2)
end, "Door1b30")

RegisterEvent(30694, "Door1a30", function()
    map.triggerMechanism(694, 2)
end, "Door1a30")

RegisterEvent(30695, "Door1b31", function()
    map.triggerMechanism(695, 2)
end, "Door1b31")

RegisterEvent(30696, "Door1a31", function()
    map.triggerMechanism(696, 2)
end, "Door1a31")

RegisterEvent(30697, "Door1b35", function()
    map.triggerMechanism(697, 2)
end, "Door1b35")

RegisterEvent(30698, "Door1a35", function()
    map.triggerMechanism(698, 2)
end, "Door1a35")

RegisterEvent(30699, "Door1b36", function()
    map.triggerMechanism(699, 2)
end, "Door1b36")

RegisterEvent(30700, "Door1a36", function()
    map.triggerMechanism(700, 2)
end, "Door1a36")

RegisterEvent(30701, "DoorTeleportRight", function()
    map.triggerMechanism(701, 2)
end, "DoorTeleportRight")

RegisterEvent(30702, "DoorTeleportLeft", function()
    map.triggerMechanism(702, 2)
end, "DoorTeleportLeft")

RegisterEvent(30703, "Door1", function()
    map.triggerMechanism(703, 2)
end, "Door1")

RegisterEvent(30704, "Door2", function()
    map.triggerMechanism(704, 2)
end, "Door2")

RegisterEvent(30705, "Door3", function()
    map.triggerMechanism(705, 2)
end, "Door3")

RegisterEvent(30706, "Door4", function()
    map.triggerMechanism(706, 2)
end, "Door4")

RegisterEvent(30707, "Door5", function()
    map.triggerMechanism(707, 2)
end, "Door5")

RegisterEvent(30708, "Door6", function()
    map.triggerMechanism(708, 2)
end, "Door6")

RegisterEvent(30709, "Door7", function()
    map.triggerMechanism(709, 2)
end, "Door7")

RegisterEvent(30710, "Door8", function()
    map.triggerMechanism(710, 2)
end, "Door8")

RegisterEvent(30711, "Door9", function()
    map.triggerMechanism(711, 2)
end, "Door9")

RegisterEvent(30712, "Door10", function()
    map.triggerMechanism(712, 2)
end, "Door10")

RegisterEvent(30713, "Door11", function()
    map.triggerMechanism(713, 2)
end, "Door11")

RegisterEvent(30714, "Door12", function()
    map.triggerMechanism(714, 2)
end, "Door12")

RegisterEvent(30715, "Secretdoor", function()
    map.triggerMechanism(715, 2)
end, "Secretdoor")

RegisterEvent(30717, "RotatingDoor66", function()
    map.triggerMechanism(717, 2)
end, "RotatingDoor66")

RegisterEvent(30718, "RotatingDoor67", function()
    map.triggerMechanism(718, 2)
end, "RotatingDoor67")

RegisterEvent(30719, "RotatingDoor65", function()
    map.triggerMechanism(719, 2)
end, "RotatingDoor65")

RegisterEvent(30720, "RotatingDoor64", function()
    map.triggerMechanism(720, 2)
end, "RotatingDoor64")

RegisterEvent(30721, "Door1a0", function()
    map.triggerMechanism(721, 2)
end, "Door1a0")

RegisterEvent(30722, "Door1b0", function()
    map.triggerMechanism(722, 2)
end, "Door1b0")

RegisterEvent(30723, "Door1a", function()
    map.triggerMechanism(723, 2)
end, "Door1a")

RegisterEvent(30724, "Door1b", function()
    map.triggerMechanism(724, 2)
end, "Door1b")

RegisterEvent(30725, "Door1a10", function()
    map.triggerMechanism(725, 2)
end, "Door1a10")

RegisterEvent(30726, "Door1b10", function()
    map.triggerMechanism(726, 2)
end, "Door1b10")

RegisterEvent(30727, "Door1a1", function()
    map.triggerMechanism(727, 2)
end, "Door1a1")

RegisterEvent(30728, "Door1b1", function()
    map.triggerMechanism(728, 2)
end, "Door1b1")

RegisterEvent(30729, "Door1a2", function()
    map.triggerMechanism(729, 2)
end, "Door1a2")

RegisterEvent(30730, "Door1b2", function()
    map.triggerMechanism(730, 2)
end, "Door1b2")

RegisterEvent(30731, "Door1a3", function()
    map.triggerMechanism(731, 2)
end, "Door1a3")

RegisterEvent(30732, "Door1b3", function()
    map.triggerMechanism(732, 2)
end, "Door1b3")

RegisterEvent(30733, "Door1a4", function()
    map.triggerMechanism(733, 2)
end, "Door1a4")

RegisterEvent(30734, "Door1b4", function()
    map.triggerMechanism(734, 2)
end, "Door1b4")

RegisterEvent(30735, "Door1a5", function()
    map.triggerMechanism(735, 2)
end, "Door1a5")

RegisterEvent(30736, "Door1b5", function()
    map.triggerMechanism(736, 2)
end, "Door1b5")

RegisterEvent(30737, "Door1a6", function()
    map.triggerMechanism(737, 2)
end, "Door1a6")

RegisterEvent(30738, "Door1b6", function()
    map.triggerMechanism(738, 2)
end, "Door1b6")

RegisterEvent(30739, "Door1a7", function()
    map.triggerMechanism(739, 2)
end, "Door1a7")

RegisterEvent(30740, "Door1b7", function()
    map.triggerMechanism(740, 2)
end, "Door1b7")

RegisterEvent(30741, "Door1a8", function()
    map.triggerMechanism(741, 2)
end, "Door1a8")

RegisterEvent(30742, "Door1b8", function()
    map.triggerMechanism(742, 2)
end, "Door1b8")

RegisterEvent(30743, "Door1a9", function()
    map.triggerMechanism(743, 2)
end, "Door1a9")

RegisterEvent(30744, "Door1b9", function()
    map.triggerMechanism(744, 2)
end, "Door1b9")

RegisterEvent(30745, "Door1a20", function()
    map.triggerMechanism(745, 2)
end, "Door1a20")

RegisterEvent(30746, "Door1b20", function()
    map.triggerMechanism(746, 2)
end, "Door1b20")

RegisterEvent(30747, "Door1a21", function()
    map.triggerMechanism(747, 2)
end, "Door1a21")

RegisterEvent(30748, "Door1b21", function()
    map.triggerMechanism(748, 2)
end, "Door1b21")

RegisterEvent(30749, "Door1a22", function()
    map.triggerMechanism(749, 2)
end, "Door1a22")

RegisterEvent(30750, "Door1b22", function()
    map.triggerMechanism(750, 2)
end, "Door1b22")

RegisterEvent(30751, "Door1a23", function()
    map.triggerMechanism(751, 2)
end, "Door1a23")

RegisterEvent(30752, "Door1b23", function()
    map.triggerMechanism(752, 2)
end, "Door1b23")

RegisterEvent(30753, "Door1a24", function()
    map.triggerMechanism(753, 2)
end, "Door1a24")

RegisterEvent(30754, "Door1b24", function()
    map.triggerMechanism(754, 2)
end, "Door1b24")

RegisterEvent(30755, "RotatingDoor61", function()
    map.triggerMechanism(755, 2)
end, "RotatingDoor61")

RegisterEvent(30756, "RotatingDoor62", function()
    map.triggerMechanism(756, 2)
end, "RotatingDoor62")

RegisterEvent(30757, "RotatingDoor63", function()
    map.triggerMechanism(757, 2)
end, "RotatingDoor63")

map.scripts["propanim.scr"] = {
    source = "PROPANIM.scr",
    registered_triggers = {
        { line = 42, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["writ.scr"] = {
    source = "WRIT.scr",
    registered_triggers = {
        { line = 71, message = "Use", callback = "Onuse" },
        { line = 81, message = "init", callback = "OnInit" },
    },
    movement_commands = {
    },
}
map.scripts["yanmir.scr"] = {
    source = "YANMIR.scr",
    registered_triggers = {
        { line = 51, message = "Use", callback = "DoNothing" },
        { line = 52, message = "Trigger", callback = "DoNothing" },
    },
    movement_commands = {
    },
}
map.scripts["yanmir_camera.scr"] = {
    source = "YANMIR_CAMERA.scr",
    registered_triggers = {
        { line = 63, message = "ON", callback = "TurnOn" },
        { line = 64, message = "OFF", callback = "OnTurnOff" },
    },
    movement_commands = {
    },
}
map.scripts["yanmir_endofworld.scr"] = {
    source = "YANMIR_ENDOFWORLD.scr",
    registered_triggers = {
        { line = 76, message = "OutOfWorld", callback = "OnOutOfWorld" },
    },
    movement_commands = {
    },
}
map.scripts["yanmirbase.scr"] = {
    source = "YANMIRBASE.scr",
    registered_triggers = {
        { line = 526, message = "Squish", callback = "Begin" },
        { line = 527, message = "PlayerRanAway", callback = "OnPlayerRanAway" },
        { line = 528, message = "TimeToDie", callback = "OnTimeToDie" },
        { line = 529, message = "DestroyFloor", callback = "DestroyFloor" },
    },
    movement_commands = {
        { line = 144, command = "SetPos", arguments = "hDust,g_posX,g_posY,g_posZ" },
    },
}
map.scripts["yanmirchild.scr"] = {
    source = "YANMIRCHILD.scr",
    registered_triggers = {
        { line = 32, message = "use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["yanmirfort_bugspawn.scr"] = {
    source = "YANMIRFORT_BUGSPAWN.scr",
    registered_triggers = {
        { line = 87, message = "RespawnMe", callback = "OnRespawnMe" },
    },
    movement_commands = {
    },
}
map.scripts["yanmirhidden.scr"] = {
    source = "YANMIRHIDDEN.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["yanmirkey.scr"] = {
    source = "YANMIRKEY.scr",
    registered_triggers = {
        { line = 21, message = "use", callback = "GiveKeyToPlayer" },
    },
    movement_commands = {
    },
}
map.scripts["yanmirtrap.scr"] = {
    source = "YANMIRTRAP.scr",
    registered_triggers = {
        { line = 24, message = "SupportBroken", callback = "CheckCount" },
    },
    movement_commands = {
    },
}
map.scripts["yf_explodingfloor.scr"] = {
    source = "YF_EXPLODINGFLOOR.scr",
    registered_triggers = {
        { line = 48, message = "Fall", callback = "DelayAction" },
    },
    movement_commands = {
    },
}
map.scripts["yf_fallingfloor.scr"] = {
    source = "YF_FALLINGFLOOR.scr",
    registered_triggers = {
        { line = 95, message = "Disappear", callback = "DelayAction" },
    },
    movement_commands = {
        { line = 75, command = "MoveToPos", arguments = "nVarX, nVarY, nVarZ, 1000, StopHere" },
    },
}

function map.register(ctx)
    if ctx == nil or ctx.registerMm9MapEvents == nil then
        return
    end
    ctx:registerMm9MapEvents(map)
end

return map
