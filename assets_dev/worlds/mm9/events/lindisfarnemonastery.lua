-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "lindisfarnemonastery"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 406,
        source_name = "StartPoint0",
        x = -327,
        y = -935,
        z = 732,
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
        mechanism_id = 900412,
        event_id = 30412,
        source_object_index = 412,
        source_class = "RotatingDoor",
        source_name = "bnavedoor1",
        kind = "rotating_door",
        hint = "bnavedoor1",
    },
    {
        mechanism_id = 900413,
        event_id = 30413,
        source_object_index = 413,
        source_class = "RotatingDoor",
        source_name = "anavedoor1",
        kind = "rotating_door",
        hint = "anavedoor1",
    },
    {
        mechanism_id = 900414,
        event_id = 30414,
        source_object_index = 414,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor2",
        kind = "rotating_door",
        hint = "RotatingDoor2",
    },
    {
        mechanism_id = 900415,
        event_id = 30415,
        source_object_index = 415,
        source_class = "RotatingDoor",
        source_name = "bnavedoor2",
        kind = "rotating_door",
        hint = "bnavedoor2",
    },
    {
        mechanism_id = 900416,
        event_id = 30416,
        source_object_index = 416,
        source_class = "RotatingDoor",
        source_name = "anavedoor2",
        kind = "rotating_door",
        hint = "anavedoor2",
    },
    {
        mechanism_id = 900417,
        event_id = 30417,
        source_object_index = 417,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor0",
        kind = "rotating_door",
        hint = "RotatingDoor0",
    },
    {
        mechanism_id = 900418,
        event_id = 30418,
        source_object_index = 418,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor1",
        kind = "rotating_door",
        hint = "RotatingDoor1",
    },
    {
        mechanism_id = 900419,
        event_id = 30419,
        source_object_index = 419,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor3",
        kind = "rotating_door",
        hint = "RotatingDoor3",
    },
    {
        mechanism_id = 900420,
        event_id = 30420,
        source_object_index = 420,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor4",
        kind = "rotating_door",
        hint = "RotatingDoor4",
    },
    {
        mechanism_id = 900421,
        event_id = 30421,
        source_object_index = 421,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor5",
        kind = "rotating_door",
        hint = "RotatingDoor5",
    },
    {
        mechanism_id = 900422,
        event_id = 30422,
        source_object_index = 422,
        source_class = "Ladder",
        source_name = "Ladder3",
        kind = "ladder_volume",
        hint = "Ladder3",
    },
    {
        mechanism_id = 900425,
        event_id = 30425,
        source_object_index = 425,
        source_class = "Ladder",
        source_name = "Ladder4",
        kind = "ladder_volume",
        hint = "Ladder4",
    },
    {
        mechanism_id = 900426,
        event_id = 30426,
        source_object_index = 426,
        source_class = "Ladder",
        source_name = "Ladder1",
        kind = "ladder_volume",
        hint = "Ladder1",
    },
    {
        mechanism_id = 900428,
        event_id = 30428,
        source_object_index = 428,
        source_class = "Ladder",
        source_name = "Ladder2",
        kind = "ladder_volume",
        hint = "Ladder2",
    },
    {
        mechanism_id = 900431,
        event_id = 30431,
        source_object_index = 431,
        source_class = "Ladder",
        source_name = "Ladder5",
        kind = "ladder_volume",
        hint = "Ladder5",
    },
    {
        mechanism_id = 900432,
        event_id = 30432,
        source_object_index = 432,
        source_class = "Ladder",
        source_name = "Ladder0",
        kind = "ladder_volume",
        hint = "Ladder0",
    },
    {
        mechanism_id = 900435,
        event_id = 30435,
        source_object_index = 435,
        source_class = "Ladder",
        source_name = "Ladder10",
        kind = "ladder_volume",
        hint = "Ladder10",
    },
    {
        mechanism_id = 900455,
        event_id = 30455,
        source_object_index = 455,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900467,
        event_id = 30467,
        source_object_index = 467,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900492,
        event_id = 30492,
        source_object_index = 492,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900493,
        event_id = 30493,
        source_object_index = 493,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 900527,
        event_id = 30527,
        source_object_index = 527,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 900604,
        event_id = 30604,
        source_object_index = 604,
        source_class = "Door",
        source_name = "C#1",
        kind = "linear_door",
        hint = "C#1",
        sounds = {
            ["open_start"] = {
                name = "music/c#1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900605,
        event_id = 30605,
        source_object_index = 605,
        source_class = "Door",
        source_name = "E1",
        kind = "linear_door",
        hint = "E1",
        sounds = {
            ["open_start"] = {
                name = "Music/e1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900606,
        event_id = 30606,
        source_object_index = 606,
        source_class = "Door",
        source_name = "A1",
        kind = "linear_door",
        hint = "A1",
        sounds = {
            ["open_start"] = {
                name = "music/a1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900607,
        event_id = 30607,
        source_object_index = 607,
        source_class = "Door",
        source_name = "B1",
        kind = "linear_door",
        hint = "B1",
        sounds = {
            ["open_start"] = {
                name = "music/b1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900608,
        event_id = 30608,
        source_object_index = 608,
        source_class = "Door",
        source_name = "C1",
        kind = "linear_door",
        hint = "C1",
        sounds = {
            ["open_start"] = {
                name = "music/c1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900609,
        event_id = 30609,
        source_object_index = 609,
        source_class = "Door",
        source_name = "D1",
        kind = "linear_door",
        hint = "D1",
        sounds = {
            ["open_start"] = {
                name = "music/d1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900610,
        event_id = 30610,
        source_object_index = 610,
        source_class = "Door",
        source_name = "E2",
        kind = "linear_door",
        hint = "E2",
        sounds = {
            ["open_start"] = {
                name = "music/e2.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900611,
        event_id = 30611,
        source_object_index = 611,
        source_class = "Door",
        source_name = "F2",
        kind = "linear_door",
        hint = "F2",
        sounds = {
            ["open_start"] = {
                name = "music/f2.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900612,
        event_id = 30612,
        source_object_index = 612,
        source_class = "Door",
        source_name = "F1",
        kind = "linear_door",
        hint = "F1",
        sounds = {
            ["open_start"] = {
                name = "Music/f1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900613,
        event_id = 30613,
        source_object_index = 613,
        source_class = "Door",
        source_name = "G1",
        kind = "linear_door",
        hint = "G1",
        sounds = {
            ["open_start"] = {
                name = "music/g1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900614,
        event_id = 30614,
        source_object_index = 614,
        source_class = "Door",
        source_name = "G2",
        kind = "linear_door",
        hint = "G2",
        sounds = {
            ["open_start"] = {
                name = "music/g2.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900615,
        event_id = 30615,
        source_object_index = 615,
        source_class = "Door",
        source_name = "A2",
        kind = "linear_door",
        hint = "A2",
        sounds = {
            ["open_start"] = {
                name = "music/a2.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900616,
        event_id = 30616,
        source_object_index = 616,
        source_class = "Door",
        source_name = "B2",
        kind = "linear_door",
        hint = "B2",
        sounds = {
            ["open_start"] = {
                name = "music/b2.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900617,
        event_id = 30617,
        source_object_index = 617,
        source_class = "Door",
        source_name = "C2",
        kind = "linear_door",
        hint = "C2",
        sounds = {
            ["open_start"] = {
                name = "music/c2.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900618,
        event_id = 30618,
        source_object_index = 618,
        source_class = "Door",
        source_name = "D2",
        kind = "linear_door",
        hint = "D2",
        sounds = {
            ["open_start"] = {
                name = "music/d2.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900619,
        event_id = 30619,
        source_object_index = 619,
        source_class = "Door",
        source_name = "E3",
        kind = "linear_door",
        hint = "E3",
        sounds = {
            ["open_start"] = {
                name = "music/e3.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900620,
        event_id = 30620,
        source_object_index = 620,
        source_class = "Door",
        source_name = "C#2",
        kind = "linear_door",
        hint = "C#2",
        sounds = {
            ["open_start"] = {
                name = "music/c#2.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900621,
        event_id = 30621,
        source_object_index = 621,
        source_class = "Door",
        source_name = "A#2",
        kind = "linear_door",
        hint = "A#2",
        sounds = {
            ["open_start"] = {
                name = "music/a#2.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900622,
        event_id = 30622,
        source_object_index = 622,
        source_class = "Door",
        source_name = "G#2",
        kind = "linear_door",
        hint = "G#2",
        sounds = {
            ["open_start"] = {
                name = "music/g#2.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900623,
        event_id = 30623,
        source_object_index = 623,
        source_class = "Door",
        source_name = "F#2",
        kind = "linear_door",
        hint = "F#2",
        sounds = {
            ["open_start"] = {
                name = "music/f#2.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900624,
        event_id = 30624,
        source_object_index = 624,
        source_class = "Door",
        source_name = "D#2",
        kind = "linear_door",
        hint = "D#2",
        sounds = {
            ["open_start"] = {
                name = "music/d#1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900625,
        event_id = 30625,
        source_object_index = 625,
        source_class = "Door",
        source_name = "A#1",
        kind = "linear_door",
        hint = "A#1",
        sounds = {
            ["open_start"] = {
                name = "music/a#1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900626,
        event_id = 30626,
        source_object_index = 626,
        source_class = "Door",
        source_name = "G#1",
        kind = "linear_door",
        hint = "G#1",
        sounds = {
            ["open_start"] = {
                name = "music/g#1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900627,
        event_id = 30627,
        source_object_index = 627,
        source_class = "Door",
        source_name = "D#1",
        kind = "linear_door",
        hint = "D#1",
        sounds = {
            ["open_start"] = {
                name = "music/d#2.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900628,
        event_id = 30628,
        source_object_index = 628,
        source_class = "Door",
        source_name = "F#1",
        kind = "linear_door",
        hint = "F#1",
        sounds = {
            ["open_start"] = {
                name = "music/f#1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900630,
        event_id = 30630,
        source_object_index = 630,
        source_class = "ScriptObject",
        source_name = "BellControl",
        kind = "script_object",
        hint = "BellControl",
    },
    {
        mechanism_id = 900646,
        event_id = 30646,
        source_object_index = 646,
        source_class = "Door",
        source_name = "Rope5",
        kind = "linear_door",
        hint = "Rope5",
    },
    {
        mechanism_id = 900647,
        event_id = 30647,
        source_object_index = 647,
        source_class = "Door",
        source_name = "Rope4",
        kind = "linear_door",
        hint = "Rope4",
    },
    {
        mechanism_id = 900648,
        event_id = 30648,
        source_object_index = 648,
        source_class = "Door",
        source_name = "Rope3",
        kind = "linear_door",
        hint = "Rope3",
    },
    {
        mechanism_id = 900649,
        event_id = 30649,
        source_object_index = 649,
        source_class = "Door",
        source_name = "Rope2",
        kind = "linear_door",
        hint = "Rope2",
    },
    {
        mechanism_id = 900650,
        event_id = 30650,
        source_object_index = 650,
        source_class = "Door",
        source_name = "Rope1",
        kind = "linear_door",
        hint = "Rope1",
    },
    {
        mechanism_id = 900651,
        event_id = 30651,
        source_object_index = 651,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 900767,
        event_id = 30767,
        source_object_index = 767,
        source_class = "ScriptObject",
        source_name = "MONK_HOSTILITY",
        kind = "script_object",
        hint = "MONK_HOSTILITY",
    },
    {
        mechanism_id = 900768,
        event_id = 30768,
        source_object_index = 768,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush6",
        kind = "collision_volume",
        hint = "InvisibleBrush6",
    },
    {
        mechanism_id = 900769,
        event_id = 30769,
        source_object_index = 769,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush7",
        kind = "collision_volume",
        hint = "InvisibleBrush7",
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
    [30412] = { kind = "open_door", source = "mm9_mechanism", targetName = "bnavedoor1" },
    [30413] = { kind = "open_door", source = "mm9_mechanism", targetName = "anavedoor1" },
    [30414] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor2" },
    [30415] = { kind = "open_door", source = "mm9_mechanism", targetName = "bnavedoor2" },
    [30416] = { kind = "open_door", source = "mm9_mechanism", targetName = "anavedoor2" },
    [30417] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0" },
    [30418] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor1" },
    [30419] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor3" },
    [30420] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor4" },
    [30421] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor5" },
    [30604] = { kind = "open_door", source = "mm9_mechanism", targetName = "C#1" },
    [30605] = { kind = "open_door", source = "mm9_mechanism", targetName = "E1" },
    [30606] = { kind = "open_door", source = "mm9_mechanism", targetName = "A1" },
    [30607] = { kind = "open_door", source = "mm9_mechanism", targetName = "B1" },
    [30608] = { kind = "open_door", source = "mm9_mechanism", targetName = "C1" },
    [30609] = { kind = "open_door", source = "mm9_mechanism", targetName = "D1" },
    [30610] = { kind = "open_door", source = "mm9_mechanism", targetName = "E2" },
    [30611] = { kind = "open_door", source = "mm9_mechanism", targetName = "F2" },
    [30612] = { kind = "open_door", source = "mm9_mechanism", targetName = "F1" },
    [30613] = { kind = "open_door", source = "mm9_mechanism", targetName = "G1" },
    [30614] = { kind = "open_door", source = "mm9_mechanism", targetName = "G2" },
    [30615] = { kind = "open_door", source = "mm9_mechanism", targetName = "A2" },
    [30616] = { kind = "open_door", source = "mm9_mechanism", targetName = "B2" },
    [30617] = { kind = "open_door", source = "mm9_mechanism", targetName = "C2" },
    [30618] = { kind = "open_door", source = "mm9_mechanism", targetName = "D2" },
    [30619] = { kind = "open_door", source = "mm9_mechanism", targetName = "E3" },
    [30620] = { kind = "open_door", source = "mm9_mechanism", targetName = "C#2" },
    [30621] = { kind = "open_door", source = "mm9_mechanism", targetName = "A#2" },
    [30622] = { kind = "open_door", source = "mm9_mechanism", targetName = "G#2" },
    [30623] = { kind = "open_door", source = "mm9_mechanism", targetName = "F#2" },
    [30624] = { kind = "open_door", source = "mm9_mechanism", targetName = "D#2" },
    [30625] = { kind = "open_door", source = "mm9_mechanism", targetName = "A#1" },
    [30626] = { kind = "open_door", source = "mm9_mechanism", targetName = "G#1" },
    [30627] = { kind = "open_door", source = "mm9_mechanism", targetName = "D#1" },
    [30628] = { kind = "open_door", source = "mm9_mechanism", targetName = "F#1" },
    [30646] = { kind = "open_door", source = "mm9_mechanism", targetName = "Rope5" },
    [30647] = { kind = "open_door", source = "mm9_mechanism", targetName = "Rope4" },
    [30648] = { kind = "open_door", source = "mm9_mechanism", targetName = "Rope3" },
    [30649] = { kind = "open_door", source = "mm9_mechanism", targetName = "Rope2" },
    [30650] = { kind = "open_door", source = "mm9_mechanism", targetName = "Rope1" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30412, "bnavedoor1", function()
    map.triggerMechanism(412, 2)
end, "bnavedoor1")

RegisterEvent(30413, "anavedoor1", function()
    map.triggerMechanism(413, 2)
end, "anavedoor1")

RegisterEvent(30414, "RotatingDoor2", function()
    map.triggerMechanism(414, 2)
end, "RotatingDoor2")

RegisterEvent(30415, "bnavedoor2", function()
    map.triggerMechanism(415, 2)
end, "bnavedoor2")

RegisterEvent(30416, "anavedoor2", function()
    map.triggerMechanism(416, 2)
end, "anavedoor2")

RegisterEvent(30417, "RotatingDoor0", function()
    map.triggerMechanism(417, 2)
end, "RotatingDoor0")

RegisterEvent(30418, "RotatingDoor1", function()
    map.triggerMechanism(418, 2)
end, "RotatingDoor1")

RegisterEvent(30419, "RotatingDoor3", function()
    map.triggerMechanism(419, 2)
end, "RotatingDoor3")

RegisterEvent(30420, "RotatingDoor4", function()
    map.triggerMechanism(420, 2)
end, "RotatingDoor4")

RegisterEvent(30421, "RotatingDoor5", function()
    map.triggerMechanism(421, 2)
end, "RotatingDoor5")

RegisterEvent(30604, "C#1", function()
    map.triggerMechanism(604, 2)
end, "C#1")

RegisterEvent(30605, "E1", function()
    map.triggerMechanism(605, 2)
end, "E1")

RegisterEvent(30606, "A1", function()
    map.triggerMechanism(606, 2)
end, "A1")

RegisterEvent(30607, "B1", function()
    map.triggerMechanism(607, 2)
end, "B1")

RegisterEvent(30608, "C1", function()
    map.triggerMechanism(608, 2)
end, "C1")

RegisterEvent(30609, "D1", function()
    map.triggerMechanism(609, 2)
end, "D1")

RegisterEvent(30610, "E2", function()
    map.triggerMechanism(610, 2)
end, "E2")

RegisterEvent(30611, "F2", function()
    map.triggerMechanism(611, 2)
end, "F2")

RegisterEvent(30612, "F1", function()
    map.triggerMechanism(612, 2)
end, "F1")

RegisterEvent(30613, "G1", function()
    map.triggerMechanism(613, 2)
end, "G1")

RegisterEvent(30614, "G2", function()
    map.triggerMechanism(614, 2)
end, "G2")

RegisterEvent(30615, "A2", function()
    map.triggerMechanism(615, 2)
end, "A2")

RegisterEvent(30616, "B2", function()
    map.triggerMechanism(616, 2)
end, "B2")

RegisterEvent(30617, "C2", function()
    map.triggerMechanism(617, 2)
end, "C2")

RegisterEvent(30618, "D2", function()
    map.triggerMechanism(618, 2)
end, "D2")

RegisterEvent(30619, "E3", function()
    map.triggerMechanism(619, 2)
end, "E3")

RegisterEvent(30620, "C#2", function()
    map.triggerMechanism(620, 2)
end, "C#2")

RegisterEvent(30621, "A#2", function()
    map.triggerMechanism(621, 2)
end, "A#2")

RegisterEvent(30622, "G#2", function()
    map.triggerMechanism(622, 2)
end, "G#2")

RegisterEvent(30623, "F#2", function()
    map.triggerMechanism(623, 2)
end, "F#2")

RegisterEvent(30624, "D#2", function()
    map.triggerMechanism(624, 2)
end, "D#2")

RegisterEvent(30625, "A#1", function()
    map.triggerMechanism(625, 2)
end, "A#1")

RegisterEvent(30626, "G#1", function()
    map.triggerMechanism(626, 2)
end, "G#1")

RegisterEvent(30627, "D#1", function()
    map.triggerMechanism(627, 2)
end, "D#1")

RegisterEvent(30628, "F#1", function()
    map.triggerMechanism(628, 2)
end, "F#1")

RegisterEvent(30646, "Rope5", function()
    map.triggerMechanism(646, 2)
end, "Rope5")

RegisterEvent(30647, "Rope4", function()
    map.triggerMechanism(647, 2)
end, "Rope4")

RegisterEvent(30648, "Rope3", function()
    map.triggerMechanism(648, 2)
end, "Rope3")

RegisterEvent(30649, "Rope2", function()
    map.triggerMechanism(649, 2)
end, "Rope2")

RegisterEvent(30650, "Rope1", function()
    map.triggerMechanism(650, 2)
end, "Rope1")

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
map.scripts["lindisfarnebell.scr"] = {
    source = "LINDISFARNEBELL.scr",
    registered_triggers = {
        { line = 129, message = "Use", callback = "Onuse" },
    },
    movement_commands = {
    },
}
map.scripts["lindisfarnebellcontroller.scr"] = {
    source = "LINDISFARNEBELLCONTROLLER.scr",
    registered_triggers = {
        { line = 172, message = "Bell1", callback = "OnBell1" },
        { line = 173, message = "Bell2", callback = "OnBell2" },
        { line = 174, message = "Bell3", callback = "OnBell3" },
        { line = 175, message = "Bell4", callback = "OnBell4" },
        { line = 176, message = "Bell5", callback = "OnBell5" },
    },
    movement_commands = {
    },
}
map.scripts["monkguardbasic.scr"] = {
    source = "MONKGUARDBASIC.scr",
    registered_triggers = {
        { line = 46, message = "use", callback = "OnRudeEnter" },
        { line = 63, message = "gotopray", callback = "StartPrayer" },
    },
    movement_commands = {
    },
}
map.scripts["npc282.scr"] = {
    source = "NPC282.scr",
    registered_triggers = {
        { line = 148, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc283.scr"] = {
    source = "NPC283.scr",
    registered_triggers = {
        { line = 86, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc284.scr"] = {
    source = "NPC284.scr",
    registered_triggers = {
        { line = 94, message = "Use", callback = "OnUse" },
        { line = 95, message = "Appear", callback = "Appear" },
    },
    movement_commands = {
    },
}
map.scripts["npc420.scr"] = {
    source = "NPC420.scr",
    registered_triggers = {
        { line = 121, message = "Play", callback = "PlayAnim" },
        { line = 122, message = "Use", callback = "OnUse" },
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
map.scripts["thjorad.scr"] = {
    source = "THJORAD.scr",
    registered_triggers = {
        { line = 100, message = "Use", callback = "Onuse" },
        { line = 101, message = "TurnOn", callback = "OnTurnOn" },
    },
    movement_commands = {
    },
}
map.scripts["thjoradmonk.scr"] = {
    source = "THJORADMONK.scr",
    registered_triggers = {
        { line = 116, message = "GoToPray", callback = "OnGoToPray" },
        { line = 117, message = "Use", callback = "Onuse" },
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
