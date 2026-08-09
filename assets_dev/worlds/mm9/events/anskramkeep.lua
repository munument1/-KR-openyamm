-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "anskramkeep"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 748,
        source_name = "Anskramkeepback",
        x = 0,
        y = 41,
        z = -266,
        direction_yaw_units = 0,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 989,
        source_name = "Anskramkeepfront",
        x = 0,
        y = 15647,
        z = -369,
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
        source_name = "ExitStairs",
        kind = "linear_door",
        hint = "ExitStairs",
        sounds = {
            ["open_busy"] = {
                name = "events/drawbridge02.wav",
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
        },
    },
    {
        mechanism_id = 900001,
        event_id = 30001,
        source_object_index = 1,
        source_class = "Shooter",
        source_name = "Shooter8",
        kind = "shooter",
        hint = "Shooter8",
    },
    {
        mechanism_id = 900002,
        event_id = 30002,
        source_object_index = 2,
        source_class = "Shooter",
        source_name = "Shooter7",
        kind = "shooter",
        hint = "Shooter7",
    },
    {
        mechanism_id = 900003,
        event_id = 30003,
        source_object_index = 3,
        source_class = "Shooter",
        source_name = "Shooter6",
        kind = "shooter",
        hint = "Shooter6",
    },
    {
        mechanism_id = 900004,
        event_id = 30004,
        source_object_index = 4,
        source_class = "Shooter",
        source_name = "Shooter5",
        kind = "shooter",
        hint = "Shooter5",
    },
    {
        mechanism_id = 900005,
        event_id = 30005,
        source_object_index = 5,
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
        mechanism_id = 900007,
        event_id = 30007,
        source_object_index = 7,
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
        mechanism_id = 900009,
        event_id = 30009,
        source_object_index = 9,
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
        mechanism_id = 900011,
        event_id = 30011,
        source_object_index = 11,
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
        mechanism_id = 900013,
        event_id = 30013,
        source_object_index = 13,
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
        mechanism_id = 900014,
        event_id = 30014,
        source_object_index = 14,
        source_class = "Shooter",
        source_name = "CeilingShooter1",
        kind = "shooter",
        hint = "CeilingShooter1",
    },
    {
        mechanism_id = 900016,
        event_id = 30016,
        source_object_index = 16,
        source_class = "Shooter",
        source_name = "CeilingShooter0",
        kind = "shooter",
        hint = "CeilingShooter0",
    },
    {
        mechanism_id = 900017,
        event_id = 30017,
        source_object_index = 17,
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
        mechanism_id = 900021,
        event_id = 30021,
        source_object_index = 21,
        source_class = "Door",
        source_name = "CeilingCrush3",
        kind = "linear_door",
        hint = "CeilingCrush3",
        sounds = {
            ["open_busy"] = {
                name = "Door/stonedoorslide02.wav",
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
                name = "Door/stonedoorslide03.wav",
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
        mechanism_id = 900022,
        event_id = 30022,
        source_object_index = 22,
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
        mechanism_id = 900024,
        event_id = 30024,
        source_object_index = 24,
        source_class = "Door",
        source_name = "CeilingCrush2",
        kind = "linear_door",
        hint = "CeilingCrush2",
        sounds = {
            ["open_busy"] = {
                name = "Door/stonedoorslide02.wav",
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
                name = "Door/stonedoorslide03.wav",
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
        mechanism_id = 900025,
        event_id = 30025,
        source_object_index = 25,
        source_class = "Door",
        source_name = "CeilingCrushPlate2",
        kind = "linear_door",
        hint = "CeilingCrushPlate2",
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
        mechanism_id = 900027,
        event_id = 30027,
        source_object_index = 27,
        source_class = "Door",
        source_name = "CeilingCrush1",
        kind = "linear_door",
        hint = "CeilingCrush1",
        sounds = {
            ["open_busy"] = {
                name = "Door/stonedoorslide02.wav",
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
                name = "Door/stonedoorslide03.wav",
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
        mechanism_id = 900028,
        event_id = 30028,
        source_object_index = 28,
        source_class = "Door",
        source_name = "CeilingCrushPlate1",
        kind = "linear_door",
        hint = "CeilingCrushPlate1",
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
        mechanism_id = 900029,
        event_id = 30029,
        source_object_index = 29,
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
        mechanism_id = 900032,
        event_id = 30032,
        source_object_index = 32,
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
        mechanism_id = 900033,
        event_id = 30033,
        source_object_index = 33,
        source_class = "Ladder",
        source_name = "Ladder4",
        kind = "ladder_volume",
        hint = "Ladder4",
    },
    {
        mechanism_id = 900035,
        event_id = 30035,
        source_object_index = 35,
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
        mechanism_id = 900036,
        event_id = 30036,
        source_object_index = 36,
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
        mechanism_id = 900038,
        event_id = 30038,
        source_object_index = 38,
        source_class = "RotatingDoor",
        source_name = "PivotWallTrap2",
        kind = "rotating_door",
        hint = "PivotWallTrap2",
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
        mechanism_id = 900041,
        event_id = 30041,
        source_object_index = 41,
        source_class = "RotatingDoor",
        source_name = "TrapExitDoor2",
        kind = "rotating_door",
        hint = "TrapExitDoor2",
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
        mechanism_id = 900042,
        event_id = 30042,
        source_object_index = 42,
        source_class = "Ladder",
        source_name = "Ladder5",
        kind = "ladder_volume",
        hint = "Ladder5",
    },
    {
        mechanism_id = 900044,
        event_id = 30044,
        source_object_index = 44,
        source_class = "Door",
        source_name = "PivotButton2",
        kind = "linear_door",
        hint = "PivotButton2",
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
        mechanism_id = 900045,
        event_id = 30045,
        source_object_index = 45,
        source_class = "RotatingDoor",
        source_name = "PivotWallTrap3",
        kind = "rotating_door",
        hint = "PivotWallTrap3",
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
        mechanism_id = 900047,
        event_id = 30047,
        source_object_index = 47,
        source_class = "RotatingDoor",
        source_name = "TrapExitDoor3",
        kind = "rotating_door",
        hint = "TrapExitDoor3",
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
        mechanism_id = 900048,
        event_id = 30048,
        source_object_index = 48,
        source_class = "Ladder",
        source_name = "Ladder6",
        kind = "ladder_volume",
        hint = "Ladder6",
    },
    {
        mechanism_id = 900050,
        event_id = 30050,
        source_object_index = 50,
        source_class = "Door",
        source_name = "PivotButton3",
        kind = "linear_door",
        hint = "PivotButton3",
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
        mechanism_id = 900674,
        event_id = 30674,
        source_object_index = 674,
        source_class = "Door",
        source_name = "RoundDoorRight2",
        kind = "linear_door",
        hint = "RoundDoorRight2",
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
        mechanism_id = 900675,
        event_id = 30675,
        source_object_index = 675,
        source_class = "Door",
        source_name = "RoundDoorLeft2",
        kind = "linear_door",
        hint = "RoundDoorLeft2",
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
        mechanism_id = 900676,
        event_id = 30676,
        source_object_index = 676,
        source_class = "Door",
        source_name = "RoundDoorRight1",
        kind = "linear_door",
        hint = "RoundDoorRight1",
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
        mechanism_id = 900677,
        event_id = 30677,
        source_object_index = 677,
        source_class = "Door",
        source_name = "RoundDoorLeft1",
        kind = "linear_door",
        hint = "RoundDoorLeft1",
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
        mechanism_id = 900678,
        event_id = 30678,
        source_object_index = 678,
        source_class = "Door",
        source_name = "RoundDoorRight0",
        kind = "linear_door",
        hint = "RoundDoorRight0",
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
        mechanism_id = 900679,
        event_id = 30679,
        source_object_index = 679,
        source_class = "Door",
        source_name = "RoundDoorLeft0",
        kind = "linear_door",
        hint = "RoundDoorLeft0",
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
        mechanism_id = 900680,
        event_id = 30680,
        source_object_index = 680,
        source_class = "Door",
        source_name = "RoundDoorRight3",
        kind = "linear_door",
        hint = "RoundDoorRight3",
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
        mechanism_id = 900681,
        event_id = 30681,
        source_object_index = 681,
        source_class = "Door",
        source_name = "RoundDoorLeft3",
        kind = "linear_door",
        hint = "RoundDoorLeft3",
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
        mechanism_id = 900682,
        event_id = 30682,
        source_object_index = 682,
        source_class = "Door",
        source_name = "LeverPanel",
        kind = "linear_door",
        hint = "LeverPanel",
        sounds = {
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900683,
        event_id = 30683,
        source_object_index = 683,
        source_class = "Door",
        source_name = "Innerdoor0",
        kind = "linear_door",
        hint = "Innerdoor0",
        sounds = {
            ["open_busy"] = {
                name = "Events/stonestonescrape02.wav",
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
                name = "Events/stonestonescrape01.wav",
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
        mechanism_id = 900684,
        event_id = 30684,
        source_object_index = 684,
        source_class = "Door",
        source_name = "Innerdoor1",
        kind = "linear_door",
        hint = "Innerdoor1",
        sounds = {
            ["open_busy"] = {
                name = "Events/stonestonescrape02.wav",
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
                name = "Events/stonestonescrape01.wav",
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
        mechanism_id = 900685,
        event_id = 30685,
        source_object_index = 685,
        source_class = "Door",
        source_name = "Outerdoor0",
        kind = "linear_door",
        hint = "Outerdoor0",
        sounds = {
            ["open_busy"] = {
                name = "Events/stonestonescrape02.wav",
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
                name = "Events/stonestonescrape01.wav",
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
        mechanism_id = 900686,
        event_id = 30686,
        source_object_index = 686,
        source_class = "Door",
        source_name = "Outerdoor1",
        kind = "linear_door",
        hint = "Outerdoor1",
        sounds = {
            ["open_busy"] = {
                name = "Events/stonestonescrape02.wav",
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
                name = "Events/stonestonescrape01.wav",
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
        mechanism_id = 900687,
        event_id = 30687,
        source_object_index = 687,
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
        mechanism_id = 900688,
        event_id = 30688,
        source_object_index = 688,
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
        mechanism_id = 900689,
        event_id = 30689,
        source_object_index = 689,
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
        mechanism_id = 900690,
        event_id = 30690,
        source_object_index = 690,
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
        mechanism_id = 900691,
        event_id = 30691,
        source_object_index = 691,
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
        mechanism_id = 900692,
        event_id = 30692,
        source_object_index = 692,
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
        mechanism_id = 900693,
        event_id = 30693,
        source_object_index = 693,
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
        mechanism_id = 900694,
        event_id = 30694,
        source_object_index = 694,
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
        mechanism_id = 900695,
        event_id = 30695,
        source_object_index = 695,
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
        mechanism_id = 900696,
        event_id = 30696,
        source_object_index = 696,
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
        mechanism_id = 900697,
        event_id = 30697,
        source_object_index = 697,
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
        mechanism_id = 900698,
        event_id = 30698,
        source_object_index = 698,
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
        mechanism_id = 900699,
        event_id = 30699,
        source_object_index = 699,
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
        mechanism_id = 900700,
        event_id = 30700,
        source_object_index = 700,
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
        mechanism_id = 900701,
        event_id = 30701,
        source_object_index = 701,
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
        mechanism_id = 900702,
        event_id = 30702,
        source_object_index = 702,
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
        mechanism_id = 900703,
        event_id = 30703,
        source_object_index = 703,
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
        mechanism_id = 900704,
        event_id = 30704,
        source_object_index = 704,
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
        mechanism_id = 900705,
        event_id = 30705,
        source_object_index = 705,
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
        mechanism_id = 900706,
        event_id = 30706,
        source_object_index = 706,
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
        mechanism_id = 900707,
        event_id = 30707,
        source_object_index = 707,
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
        mechanism_id = 900708,
        event_id = 30708,
        source_object_index = 708,
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
        mechanism_id = 900709,
        event_id = 30709,
        source_object_index = 709,
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
        mechanism_id = 900710,
        event_id = 30710,
        source_object_index = 710,
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
        mechanism_id = 900711,
        event_id = 30711,
        source_object_index = 711,
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
        mechanism_id = 900712,
        event_id = 30712,
        source_object_index = 712,
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
        mechanism_id = 900713,
        event_id = 30713,
        source_object_index = 713,
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
        mechanism_id = 900714,
        event_id = 30714,
        source_object_index = 714,
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
        mechanism_id = 900715,
        event_id = 30715,
        source_object_index = 715,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL15",
        kind = "rotating_door",
        hint = "DoubleDoorL15",
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
        mechanism_id = 900716,
        event_id = 30716,
        source_object_index = 716,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR15",
        kind = "rotating_door",
        hint = "DoubleDoorR15",
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
        mechanism_id = 900717,
        event_id = 30717,
        source_object_index = 717,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL16",
        kind = "rotating_door",
        hint = "DoubleDoorL16",
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
        mechanism_id = 900718,
        event_id = 30718,
        source_object_index = 718,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR16",
        kind = "rotating_door",
        hint = "DoubleDoorR16",
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
        mechanism_id = 900719,
        event_id = 30719,
        source_object_index = 719,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL17",
        kind = "rotating_door",
        hint = "DoubleDoorL17",
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
        mechanism_id = 900720,
        event_id = 30720,
        source_object_index = 720,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR17",
        kind = "rotating_door",
        hint = "DoubleDoorR17",
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
        mechanism_id = 900721,
        event_id = 30721,
        source_object_index = 721,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL18",
        kind = "rotating_door",
        hint = "DoubleDoorL18",
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
        mechanism_id = 900722,
        event_id = 30722,
        source_object_index = 722,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR18",
        kind = "rotating_door",
        hint = "DoubleDoorR18",
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
        mechanism_id = 900723,
        event_id = 30723,
        source_object_index = 723,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL19",
        kind = "rotating_door",
        hint = "DoubleDoorL19",
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
        mechanism_id = 900724,
        event_id = 30724,
        source_object_index = 724,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR19",
        kind = "rotating_door",
        hint = "DoubleDoorR19",
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
        mechanism_id = 900725,
        event_id = 30725,
        source_object_index = 725,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL20",
        kind = "rotating_door",
        hint = "DoubleDoorL20",
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
        mechanism_id = 900726,
        event_id = 30726,
        source_object_index = 726,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR20",
        kind = "rotating_door",
        hint = "DoubleDoorR20",
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
        mechanism_id = 900727,
        event_id = 30727,
        source_object_index = 727,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL21",
        kind = "rotating_door",
        hint = "DoubleDoorL21",
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
        mechanism_id = 900728,
        event_id = 30728,
        source_object_index = 728,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR21",
        kind = "rotating_door",
        hint = "DoubleDoorR21",
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
        mechanism_id = 900729,
        event_id = 30729,
        source_object_index = 729,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL22",
        kind = "rotating_door",
        hint = "DoubleDoorL22",
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
        mechanism_id = 900730,
        event_id = 30730,
        source_object_index = 730,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR22",
        kind = "rotating_door",
        hint = "DoubleDoorR22",
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
        mechanism_id = 900731,
        event_id = 30731,
        source_object_index = 731,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL23",
        kind = "rotating_door",
        hint = "DoubleDoorL23",
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
        mechanism_id = 900732,
        event_id = 30732,
        source_object_index = 732,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR23",
        kind = "rotating_door",
        hint = "DoubleDoorR23",
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
        mechanism_id = 900733,
        event_id = 30733,
        source_object_index = 733,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL24",
        kind = "rotating_door",
        hint = "DoubleDoorL24",
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
        mechanism_id = 900734,
        event_id = 30734,
        source_object_index = 734,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR24",
        kind = "rotating_door",
        hint = "DoubleDoorR24",
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
        mechanism_id = 900735,
        event_id = 30735,
        source_object_index = 735,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL25",
        kind = "rotating_door",
        hint = "DoubleDoorL25",
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
        mechanism_id = 900736,
        event_id = 30736,
        source_object_index = 736,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR25",
        kind = "rotating_door",
        hint = "DoubleDoorR25",
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
        mechanism_id = 900737,
        event_id = 30737,
        source_object_index = 737,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL26",
        kind = "rotating_door",
        hint = "DoubleDoorL26",
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
        mechanism_id = 900738,
        event_id = 30738,
        source_object_index = 738,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR26",
        kind = "rotating_door",
        hint = "DoubleDoorR26",
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
        mechanism_id = 900739,
        event_id = 30739,
        source_object_index = 739,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL27",
        kind = "rotating_door",
        hint = "DoubleDoorL27",
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
        mechanism_id = 900740,
        event_id = 30740,
        source_object_index = 740,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR27",
        kind = "rotating_door",
        hint = "DoubleDoorR27",
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
        mechanism_id = 900741,
        event_id = 30741,
        source_object_index = 741,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL28",
        kind = "rotating_door",
        hint = "DoubleDoorL28",
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
        mechanism_id = 900742,
        event_id = 30742,
        source_object_index = 742,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR28",
        kind = "rotating_door",
        hint = "DoubleDoorR28",
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
        mechanism_id = 900743,
        event_id = 30743,
        source_object_index = 743,
        source_class = "DestructableBrush",
        source_name = "Floordoor2",
        kind = "destructible_brush",
        hint = "Floordoor2",
    },
    {
        mechanism_id = 900744,
        event_id = 30744,
        source_object_index = 744,
        source_class = "DestructableBrush",
        source_name = "Floordoor3",
        kind = "destructible_brush",
        hint = "Floordoor3",
    },
    {
        mechanism_id = 900745,
        event_id = 30745,
        source_object_index = 745,
        source_class = "DestructableBrush",
        source_name = "Floordoor1",
        kind = "destructible_brush",
        hint = "Floordoor1",
    },
    {
        mechanism_id = 900746,
        event_id = 30746,
        source_object_index = 746,
        source_class = "DestructableBrush",
        source_name = "Floordoor4",
        kind = "destructible_brush",
        hint = "Floordoor4",
    },
    {
        mechanism_id = 900750,
        event_id = 30750,
        source_object_index = 750,
        source_class = "RotatingDoor",
        source_name = "SwitchLever0",
        kind = "rotating_door",
        hint = "SwitchLever0",
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
        mechanism_id = 900751,
        event_id = 30751,
        source_object_index = 751,
        source_class = "RotatingDoor",
        source_name = "PanelLever",
        kind = "rotating_door",
        hint = "PanelLever",
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
        mechanism_id = 900752,
        event_id = 30752,
        source_object_index = 752,
        source_class = "RotatingDoor",
        source_name = "Switch0",
        kind = "rotating_door",
        hint = "Switch0",
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
            ["jiggle"] = {
                name = "Door/doorlock01.wav",
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
        source_name = "Switch1",
        kind = "rotating_door",
        hint = "Switch1",
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
            ["jiggle"] = {
                name = "Door/doorlock01.wav",
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
        source_class = "Door",
        source_name = "LeverPanel0",
        kind = "linear_door",
        hint = "LeverPanel0",
        sounds = {
            ["open_stop"] = {
                name = "Door/doorlatch02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900986,
        event_id = 30986,
        source_object_index = 986,
        source_class = "ScriptObject",
        source_name = "Killed",
        kind = "script_object",
        hint = "Killed",
    },
    {
        mechanism_id = 900990,
        event_id = 30990,
        source_object_index = 990,
        source_class = "ScriptObject",
        source_name = "DungeonJukebox",
        kind = "script_object",
        hint = "DungeonJukebox",
    },
    {
        mechanism_id = 901004,
        event_id = 31004,
        source_object_index = 1004,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 901005,
        event_id = 31005,
        source_object_index = 1005,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 901006,
        event_id = 31006,
        source_object_index = 1006,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 901007,
        event_id = 31007,
        source_object_index = 1007,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 901008,
        event_id = 31008,
        source_object_index = 1008,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 901009,
        event_id = 31009,
        source_object_index = 1009,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 901010,
        event_id = 31010,
        source_object_index = 1010,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush6",
        kind = "collision_volume",
        hint = "InvisibleBrush6",
    },
    {
        mechanism_id = 901011,
        event_id = 31011,
        source_object_index = 1011,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush7",
        kind = "collision_volume",
        hint = "InvisibleBrush7",
    },
    {
        mechanism_id = 901032,
        event_id = 31032,
        source_object_index = 1032,
        source_class = "DestructableBrush",
        source_name = "CritterBreakOut0",
        kind = "destructible_brush",
        hint = "CritterBreakOut0",
    },
    {
        mechanism_id = 901036,
        event_id = 31036,
        source_object_index = 1036,
        source_class = "DestructableBrush",
        source_name = "CritterBreakOut1",
        kind = "destructible_brush",
        hint = "CritterBreakOut1",
    },
    {
        mechanism_id = 901177,
        event_id = 31177,
        source_object_index = 1177,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 901178,
        event_id = 31178,
        source_object_index = 1178,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 901179,
        event_id = 31179,
        source_object_index = 1179,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 901180,
        event_id = 31180,
        source_object_index = 1180,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 901181,
        event_id = 31181,
        source_object_index = 1181,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 901182,
        event_id = 31182,
        source_object_index = 1182,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 901183,
        event_id = 31183,
        source_object_index = 1183,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 901184,
        event_id = 31184,
        source_object_index = 1184,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush7",
        kind = "perception_brush",
        hint = "PerceptionBrush7",
    },
    {
        mechanism_id = 901185,
        event_id = 31185,
        source_object_index = 1185,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush8",
        kind = "perception_brush",
        hint = "PerceptionBrush8",
    },
    {
        mechanism_id = 901186,
        event_id = 31186,
        source_object_index = 1186,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush9",
        kind = "perception_brush",
        hint = "PerceptionBrush9",
    },
    {
        mechanism_id = 901187,
        event_id = 31187,
        source_object_index = 1187,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush10",
        kind = "perception_brush",
        hint = "PerceptionBrush10",
    },
    {
        mechanism_id = 901188,
        event_id = 31188,
        source_object_index = 1188,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush11",
        kind = "perception_brush",
        hint = "PerceptionBrush11",
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
    [30000] = { kind = "open_door", source = "mm9_mechanism", targetName = "ExitStairs" },
    [30005] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate8" },
    [30007] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate7" },
    [30009] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate6" },
    [30011] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate5" },
    [30013] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate9" },
    [30017] = { kind = "open_door", source = "mm9_mechanism", targetName = "ShooterPlate10" },
    [30021] = { kind = "open_door", source = "mm9_mechanism", targetName = "CeilingCrush3" },
    [30022] = { kind = "open_door", source = "mm9_mechanism", targetName = "CeilingCrushPlate3" },
    [30024] = { kind = "open_door", source = "mm9_mechanism", targetName = "CeilingCrush2" },
    [30025] = { kind = "open_door", source = "mm9_mechanism", targetName = "CeilingCrushPlate2" },
    [30027] = { kind = "open_door", source = "mm9_mechanism", targetName = "CeilingCrush1" },
    [30028] = { kind = "open_door", source = "mm9_mechanism", targetName = "CeilingCrushPlate1" },
    [30029] = { kind = "open_door", source = "mm9_mechanism", targetName = "PivotWallTrap1" },
    [30032] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrapExitDoor1" },
    [30035] = { kind = "open_door", source = "mm9_mechanism", targetName = "PivotButton1" },
    [30036] = { kind = "open_door", source = "mm9_mechanism", targetName = "PivotTreasurePanel1" },
    [30038] = { kind = "open_door", source = "mm9_mechanism", targetName = "PivotWallTrap2" },
    [30041] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrapExitDoor2" },
    [30044] = { kind = "open_door", source = "mm9_mechanism", targetName = "PivotButton2" },
    [30045] = { kind = "open_door", source = "mm9_mechanism", targetName = "PivotWallTrap3" },
    [30047] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrapExitDoor3" },
    [30050] = { kind = "open_door", source = "mm9_mechanism", targetName = "PivotButton3" },
    [30674] = { kind = "open_door", source = "mm9_mechanism", targetName = "RoundDoorRight2" },
    [30675] = { kind = "open_door", source = "mm9_mechanism", targetName = "RoundDoorLeft2" },
    [30676] = { kind = "open_door", source = "mm9_mechanism", targetName = "RoundDoorRight1" },
    [30677] = { kind = "open_door", source = "mm9_mechanism", targetName = "RoundDoorLeft1" },
    [30678] = { kind = "open_door", source = "mm9_mechanism", targetName = "RoundDoorRight0" },
    [30679] = { kind = "open_door", source = "mm9_mechanism", targetName = "RoundDoorLeft0" },
    [30680] = { kind = "open_door", source = "mm9_mechanism", targetName = "RoundDoorRight3" },
    [30681] = { kind = "open_door", source = "mm9_mechanism", targetName = "RoundDoorLeft3" },
    [30682] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeverPanel" },
    [30683] = { kind = "open_door", source = "mm9_mechanism", targetName = "Innerdoor0" },
    [30684] = { kind = "open_door", source = "mm9_mechanism", targetName = "Innerdoor1" },
    [30685] = { kind = "open_door", source = "mm9_mechanism", targetName = "Outerdoor0" },
    [30686] = { kind = "open_door", source = "mm9_mechanism", targetName = "Outerdoor1" },
    [30687] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL1" },
    [30688] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR1" },
    [30689] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL2" },
    [30690] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR2" },
    [30691] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL3" },
    [30692] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR3" },
    [30693] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL4" },
    [30694] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR4" },
    [30695] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL5" },
    [30696] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR5" },
    [30697] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL6" },
    [30698] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR6" },
    [30699] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL7" },
    [30700] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR7" },
    [30701] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL8" },
    [30702] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR8" },
    [30703] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL9" },
    [30704] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR9" },
    [30705] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL10" },
    [30706] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR10" },
    [30707] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL11" },
    [30708] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR11" },
    [30709] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL12" },
    [30710] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR12" },
    [30711] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL13" },
    [30712] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR13" },
    [30713] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL14" },
    [30714] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR14" },
    [30715] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL15" },
    [30716] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR15" },
    [30717] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL16" },
    [30718] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR16" },
    [30719] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL17" },
    [30720] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR17" },
    [30721] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL18" },
    [30722] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR18" },
    [30723] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL19" },
    [30724] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR19" },
    [30725] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL20" },
    [30726] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR20" },
    [30727] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL21" },
    [30728] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR21" },
    [30729] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL22" },
    [30730] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR22" },
    [30731] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL23" },
    [30732] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR23" },
    [30733] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL24" },
    [30734] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR24" },
    [30735] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL25" },
    [30736] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR25" },
    [30737] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL26" },
    [30738] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR26" },
    [30739] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL27" },
    [30740] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR27" },
    [30741] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL28" },
    [30742] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR28" },
    [30750] = { kind = "open_door", source = "mm9_mechanism", targetName = "SwitchLever0" },
    [30751] = { kind = "open_door", source = "mm9_mechanism", targetName = "PanelLever" },
    [30752] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch0" },
    [30753] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch1" },
    [30754] = { kind = "open_door", source = "mm9_mechanism", targetName = "LeverPanel0" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30000, "ExitStairs", function()
    map.triggerMechanism(0, 2)
end, "ExitStairs")

RegisterEvent(30005, "ShooterPlate8", function()
    map.triggerMechanism(5, 2)
end, "ShooterPlate8")

RegisterEvent(30007, "ShooterPlate7", function()
    map.triggerMechanism(7, 2)
end, "ShooterPlate7")

RegisterEvent(30009, "ShooterPlate6", function()
    map.triggerMechanism(9, 2)
end, "ShooterPlate6")

RegisterEvent(30011, "ShooterPlate5", function()
    map.triggerMechanism(11, 2)
end, "ShooterPlate5")

RegisterEvent(30013, "ShooterPlate9", function()
    map.triggerMechanism(13, 2)
end, "ShooterPlate9")

RegisterEvent(30017, "ShooterPlate10", function()
    map.triggerMechanism(17, 2)
end, "ShooterPlate10")

RegisterEvent(30021, "CeilingCrush3", function()
    map.triggerMechanism(21, 2)
end, "CeilingCrush3")

RegisterEvent(30022, "CeilingCrushPlate3", function()
    map.triggerMechanism(22, 2)
end, "CeilingCrushPlate3")

RegisterEvent(30024, "CeilingCrush2", function()
    map.triggerMechanism(24, 2)
end, "CeilingCrush2")

RegisterEvent(30025, "CeilingCrushPlate2", function()
    map.triggerMechanism(25, 2)
end, "CeilingCrushPlate2")

RegisterEvent(30027, "CeilingCrush1", function()
    map.triggerMechanism(27, 2)
end, "CeilingCrush1")

RegisterEvent(30028, "CeilingCrushPlate1", function()
    map.triggerMechanism(28, 2)
end, "CeilingCrushPlate1")

RegisterEvent(30029, "PivotWallTrap1", function()
    map.triggerMechanism(29, 2)
end, "PivotWallTrap1")

RegisterEvent(30032, "TrapExitDoor1", function()
    map.triggerMechanism(32, 2)
end, "TrapExitDoor1")

RegisterEvent(30035, "PivotButton1", function()
    map.triggerMechanism(35, 2)
end, "PivotButton1")

RegisterEvent(30036, "PivotTreasurePanel1", function()
    map.triggerMechanism(36, 2)
end, "PivotTreasurePanel1")

RegisterEvent(30038, "PivotWallTrap2", function()
    map.triggerMechanism(38, 2)
end, "PivotWallTrap2")

RegisterEvent(30041, "TrapExitDoor2", function()
    map.triggerMechanism(41, 2)
end, "TrapExitDoor2")

RegisterEvent(30044, "PivotButton2", function()
    map.triggerMechanism(44, 2)
end, "PivotButton2")

RegisterEvent(30045, "PivotWallTrap3", function()
    map.triggerMechanism(45, 2)
end, "PivotWallTrap3")

RegisterEvent(30047, "TrapExitDoor3", function()
    map.triggerMechanism(47, 2)
end, "TrapExitDoor3")

RegisterEvent(30050, "PivotButton3", function()
    map.triggerMechanism(50, 2)
end, "PivotButton3")

RegisterEvent(30674, "RoundDoorRight2", function()
    map.triggerMechanism(674, 2)
end, "RoundDoorRight2")

RegisterEvent(30675, "RoundDoorLeft2", function()
    map.triggerMechanism(675, 2)
end, "RoundDoorLeft2")

RegisterEvent(30676, "RoundDoorRight1", function()
    map.triggerMechanism(676, 2)
end, "RoundDoorRight1")

RegisterEvent(30677, "RoundDoorLeft1", function()
    map.triggerMechanism(677, 2)
end, "RoundDoorLeft1")

RegisterEvent(30678, "RoundDoorRight0", function()
    map.triggerMechanism(678, 2)
end, "RoundDoorRight0")

RegisterEvent(30679, "RoundDoorLeft0", function()
    map.triggerMechanism(679, 2)
end, "RoundDoorLeft0")

RegisterEvent(30680, "RoundDoorRight3", function()
    map.triggerMechanism(680, 2)
end, "RoundDoorRight3")

RegisterEvent(30681, "RoundDoorLeft3", function()
    map.triggerMechanism(681, 2)
end, "RoundDoorLeft3")

RegisterEvent(30682, "LeverPanel", function()
    map.triggerMechanism(682, 2)
end, "LeverPanel")

RegisterEvent(30683, "Innerdoor0", function()
    map.triggerMechanism(683, 2)
end, "Innerdoor0")

RegisterEvent(30684, "Innerdoor1", function()
    map.triggerMechanism(684, 2)
end, "Innerdoor1")

RegisterEvent(30685, "Outerdoor0", function()
    map.triggerMechanism(685, 2)
end, "Outerdoor0")

RegisterEvent(30686, "Outerdoor1", function()
    map.triggerMechanism(686, 2)
end, "Outerdoor1")

RegisterEvent(30687, "DoubleDoorL1", function()
    map.triggerMechanism(687, 2)
end, "DoubleDoorL1")

RegisterEvent(30688, "DoubleDoorR1", function()
    map.triggerMechanism(688, 2)
end, "DoubleDoorR1")

RegisterEvent(30689, "DoubleDoorL2", function()
    map.triggerMechanism(689, 2)
end, "DoubleDoorL2")

RegisterEvent(30690, "DoubleDoorR2", function()
    map.triggerMechanism(690, 2)
end, "DoubleDoorR2")

RegisterEvent(30691, "DoubleDoorL3", function()
    map.triggerMechanism(691, 2)
end, "DoubleDoorL3")

RegisterEvent(30692, "DoubleDoorR3", function()
    map.triggerMechanism(692, 2)
end, "DoubleDoorR3")

RegisterEvent(30693, "DoubleDoorL4", function()
    map.triggerMechanism(693, 2)
end, "DoubleDoorL4")

RegisterEvent(30694, "DoubleDoorR4", function()
    map.triggerMechanism(694, 2)
end, "DoubleDoorR4")

RegisterEvent(30695, "DoubleDoorL5", function()
    map.triggerMechanism(695, 2)
end, "DoubleDoorL5")

RegisterEvent(30696, "DoubleDoorR5", function()
    map.triggerMechanism(696, 2)
end, "DoubleDoorR5")

RegisterEvent(30697, "DoubleDoorL6", function()
    map.triggerMechanism(697, 2)
end, "DoubleDoorL6")

RegisterEvent(30698, "DoubleDoorR6", function()
    map.triggerMechanism(698, 2)
end, "DoubleDoorR6")

RegisterEvent(30699, "DoubleDoorL7", function()
    map.triggerMechanism(699, 2)
end, "DoubleDoorL7")

RegisterEvent(30700, "DoubleDoorR7", function()
    map.triggerMechanism(700, 2)
end, "DoubleDoorR7")

RegisterEvent(30701, "DoubleDoorL8", function()
    map.triggerMechanism(701, 2)
end, "DoubleDoorL8")

RegisterEvent(30702, "DoubleDoorR8", function()
    map.triggerMechanism(702, 2)
end, "DoubleDoorR8")

RegisterEvent(30703, "DoubleDoorL9", function()
    map.triggerMechanism(703, 2)
end, "DoubleDoorL9")

RegisterEvent(30704, "DoubleDoorR9", function()
    map.triggerMechanism(704, 2)
end, "DoubleDoorR9")

RegisterEvent(30705, "DoubleDoorL10", function()
    map.triggerMechanism(705, 2)
end, "DoubleDoorL10")

RegisterEvent(30706, "DoubleDoorR10", function()
    map.triggerMechanism(706, 2)
end, "DoubleDoorR10")

RegisterEvent(30707, "DoubleDoorL11", function()
    map.triggerMechanism(707, 2)
end, "DoubleDoorL11")

RegisterEvent(30708, "DoubleDoorR11", function()
    map.triggerMechanism(708, 2)
end, "DoubleDoorR11")

RegisterEvent(30709, "DoubleDoorL12", function()
    map.triggerMechanism(709, 2)
end, "DoubleDoorL12")

RegisterEvent(30710, "DoubleDoorR12", function()
    map.triggerMechanism(710, 2)
end, "DoubleDoorR12")

RegisterEvent(30711, "DoubleDoorL13", function()
    map.triggerMechanism(711, 2)
end, "DoubleDoorL13")

RegisterEvent(30712, "DoubleDoorR13", function()
    map.triggerMechanism(712, 2)
end, "DoubleDoorR13")

RegisterEvent(30713, "DoubleDoorL14", function()
    map.triggerMechanism(713, 2)
end, "DoubleDoorL14")

RegisterEvent(30714, "DoubleDoorR14", function()
    map.triggerMechanism(714, 2)
end, "DoubleDoorR14")

RegisterEvent(30715, "DoubleDoorL15", function()
    map.triggerMechanism(715, 2)
end, "DoubleDoorL15")

RegisterEvent(30716, "DoubleDoorR15", function()
    map.triggerMechanism(716, 2)
end, "DoubleDoorR15")

RegisterEvent(30717, "DoubleDoorL16", function()
    map.triggerMechanism(717, 2)
end, "DoubleDoorL16")

RegisterEvent(30718, "DoubleDoorR16", function()
    map.triggerMechanism(718, 2)
end, "DoubleDoorR16")

RegisterEvent(30719, "DoubleDoorL17", function()
    map.triggerMechanism(719, 2)
end, "DoubleDoorL17")

RegisterEvent(30720, "DoubleDoorR17", function()
    map.triggerMechanism(720, 2)
end, "DoubleDoorR17")

RegisterEvent(30721, "DoubleDoorL18", function()
    map.triggerMechanism(721, 2)
end, "DoubleDoorL18")

RegisterEvent(30722, "DoubleDoorR18", function()
    map.triggerMechanism(722, 2)
end, "DoubleDoorR18")

RegisterEvent(30723, "DoubleDoorL19", function()
    map.triggerMechanism(723, 2)
end, "DoubleDoorL19")

RegisterEvent(30724, "DoubleDoorR19", function()
    map.triggerMechanism(724, 2)
end, "DoubleDoorR19")

RegisterEvent(30725, "DoubleDoorL20", function()
    map.triggerMechanism(725, 2)
end, "DoubleDoorL20")

RegisterEvent(30726, "DoubleDoorR20", function()
    map.triggerMechanism(726, 2)
end, "DoubleDoorR20")

RegisterEvent(30727, "DoubleDoorL21", function()
    map.triggerMechanism(727, 2)
end, "DoubleDoorL21")

RegisterEvent(30728, "DoubleDoorR21", function()
    map.triggerMechanism(728, 2)
end, "DoubleDoorR21")

RegisterEvent(30729, "DoubleDoorL22", function()
    map.triggerMechanism(729, 2)
end, "DoubleDoorL22")

RegisterEvent(30730, "DoubleDoorR22", function()
    map.triggerMechanism(730, 2)
end, "DoubleDoorR22")

RegisterEvent(30731, "DoubleDoorL23", function()
    map.triggerMechanism(731, 2)
end, "DoubleDoorL23")

RegisterEvent(30732, "DoubleDoorR23", function()
    map.triggerMechanism(732, 2)
end, "DoubleDoorR23")

RegisterEvent(30733, "DoubleDoorL24", function()
    map.triggerMechanism(733, 2)
end, "DoubleDoorL24")

RegisterEvent(30734, "DoubleDoorR24", function()
    map.triggerMechanism(734, 2)
end, "DoubleDoorR24")

RegisterEvent(30735, "DoubleDoorL25", function()
    map.triggerMechanism(735, 2)
end, "DoubleDoorL25")

RegisterEvent(30736, "DoubleDoorR25", function()
    map.triggerMechanism(736, 2)
end, "DoubleDoorR25")

RegisterEvent(30737, "DoubleDoorL26", function()
    map.triggerMechanism(737, 2)
end, "DoubleDoorL26")

RegisterEvent(30738, "DoubleDoorR26", function()
    map.triggerMechanism(738, 2)
end, "DoubleDoorR26")

RegisterEvent(30739, "DoubleDoorL27", function()
    map.triggerMechanism(739, 2)
end, "DoubleDoorL27")

RegisterEvent(30740, "DoubleDoorR27", function()
    map.triggerMechanism(740, 2)
end, "DoubleDoorR27")

RegisterEvent(30741, "DoubleDoorL28", function()
    map.triggerMechanism(741, 2)
end, "DoubleDoorL28")

RegisterEvent(30742, "DoubleDoorR28", function()
    map.triggerMechanism(742, 2)
end, "DoubleDoorR28")

RegisterEvent(30750, "SwitchLever0", function()
    map.triggerMechanism(750, 2)
end, "SwitchLever0")

RegisterEvent(30751, "PanelLever", function()
    map.triggerMechanism(751, 2)
end, "PanelLever")

RegisterEvent(30752, "Switch0", function()
    map.triggerMechanism(752, 2)
end, "Switch0")

RegisterEvent(30753, "Switch1", function()
    map.triggerMechanism(753, 2)
end, "Switch1")

RegisterEvent(30754, "LeverPanel0", function()
    map.triggerMechanism(754, 2)
end, "LeverPanel0")

map.scripts["ak_giantimp.scr"] = {
    source = "AK_GIANTIMP.scr",
    registered_triggers = {
        { line = 22, message = "appear", callback = "Appear" },
    },
    movement_commands = {
    },
}
map.scripts["ak_giantimpguard.scr"] = {
    source = "AK_GIANTIMPGUARD.scr",
    registered_triggers = {
        { line = 21, message = "appear", callback = "Appear" },
    },
    movement_commands = {
    },
}
map.scripts["ak_impgate.scr"] = {
    source = "AK_IMPGATE.scr",
    registered_triggers = {
        { line = 179, message = "spawn", callback = "Spawn" },
    },
    movement_commands = {
    },
}
map.scripts["anskrammainline.scr"] = {
    source = "ANSKRAMMAINLINE.scr",
    registered_triggers = {
        { line = 37, message = "Use", callback = "Onuse" },
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
map.scripts["dungeonjukebox.scr"] = {
    source = "DUNGEONJUKEBOX.scr",
    registered_triggers = {
        { line = 61, message = "Play", callback = "PlaySound" },
        { line = 62, message = "RandomOff", callback = "TurnRandomOff" },
        { line = 63, message = "RandomOn", callback = "TurnRandomOn" },
        { line = 64, message = "On", callback = "TurnOn" },
        { line = 65, message = "Off", callback = "TurnOff" },
    },
    movement_commands = {
        { line = 110, command = "SetPOS", arguments = "hMe, x,y,z" },
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
map.scripts["propanim.scr"] = {
    source = "PROPANIM.scr",
    registered_triggers = {
        { line = 42, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["spawncreature.scr"] = {
    source = "SPAWNCREATURE.scr",
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
