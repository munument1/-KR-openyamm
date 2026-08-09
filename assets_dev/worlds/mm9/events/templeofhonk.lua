-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "templeofhonk"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 280,
        source_name = "StartPoint0",
        x = -3011,
        y = 7670,
        z = -328,
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
        mechanism_id = 900057,
        event_id = 30057,
        source_object_index = 57,
        source_class = "ScriptObject",
        source_name = "DoorTrigger",
        kind = "script_object",
        hint = "DoorTrigger",
    },
    {
        mechanism_id = 900066,
        event_id = 30066,
        source_object_index = 66,
        source_class = "Door",
        source_name = "NCornerStone",
        kind = "linear_door",
        hint = "NCornerStone",
        sounds = {
            ["open_busy"] = {
                name = "Door/stonedoorslide02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900067,
        event_id = 30067,
        source_object_index = 67,
        source_class = "Door",
        source_name = "OCornerStone",
        kind = "linear_door",
        hint = "OCornerStone",
        sounds = {
            ["open_busy"] = {
                name = "Door/stonedoorslide02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900068,
        event_id = 30068,
        source_object_index = 68,
        source_class = "Door",
        source_name = "HCornerStone",
        kind = "linear_door",
        hint = "HCornerStone",
        sounds = {
            ["open_busy"] = {
                name = "Door/stonedoorslide02.wav",
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
        source_class = "Door",
        source_name = "KButton",
        kind = "linear_door",
        hint = "KButton",
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
        mechanism_id = 900070,
        event_id = 30070,
        source_object_index = 70,
        source_class = "Door",
        source_name = "NButton",
        kind = "linear_door",
        hint = "NButton",
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
        mechanism_id = 900071,
        event_id = 30071,
        source_object_index = 71,
        source_class = "Door",
        source_name = "OButton",
        kind = "linear_door",
        hint = "OButton",
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
        mechanism_id = 900072,
        event_id = 30072,
        source_object_index = 72,
        source_class = "Door",
        source_name = "HButton",
        kind = "linear_door",
        hint = "HButton",
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
        mechanism_id = 900073,
        event_id = 30073,
        source_object_index = 73,
        source_class = "Door",
        source_name = "KCornerStone",
        kind = "linear_door",
        hint = "KCornerStone",
        sounds = {
            ["open_busy"] = {
                name = "Door/stonedoorslide02.wav",
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
        source_class = "ScriptObject",
        source_name = "HONK_CEREMONY",
        kind = "script_object",
        hint = "HONK_CEREMONY",
    },
    {
        mechanism_id = 900075,
        event_id = 30075,
        source_object_index = 75,
        source_class = "ScriptObject",
        source_name = "HONK_FRIENDLY",
        kind = "script_object",
        hint = "HONK_FRIENDLY",
    },
    {
        mechanism_id = 900082,
        event_id = 30082,
        source_object_index = 82,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL14",
        kind = "rotating_door",
        hint = "DoubleDoorL14",
    },
    {
        mechanism_id = 900083,
        event_id = 30083,
        source_object_index = 83,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR14",
        kind = "rotating_door",
        hint = "DoubleDoorR14",
    },
    {
        mechanism_id = 900454,
        event_id = 30454,
        source_object_index = 454,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 900455,
        event_id = 30455,
        source_object_index = 455,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL12",
        kind = "rotating_door",
        hint = "DoubleDoorL12",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900456,
        event_id = 30456,
        source_object_index = 456,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR12",
        kind = "rotating_door",
        hint = "DoubleDoorR12",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900457,
        event_id = 30457,
        source_object_index = 457,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL11",
        kind = "rotating_door",
        hint = "DoubleDoorL11",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900458,
        event_id = 30458,
        source_object_index = 458,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR11",
        kind = "rotating_door",
        hint = "DoubleDoorR11",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900459,
        event_id = 30459,
        source_object_index = 459,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL10",
        kind = "rotating_door",
        hint = "DoubleDoorL10",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900460,
        event_id = 30460,
        source_object_index = 460,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR10",
        kind = "rotating_door",
        hint = "DoubleDoorR10",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900461,
        event_id = 30461,
        source_object_index = 461,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL9",
        kind = "rotating_door",
        hint = "DoubleDoorL9",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900462,
        event_id = 30462,
        source_object_index = 462,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR9",
        kind = "rotating_door",
        hint = "DoubleDoorR9",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900463,
        event_id = 30463,
        source_object_index = 463,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL7",
        kind = "rotating_door",
        hint = "DoubleDoorL7",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900464,
        event_id = 30464,
        source_object_index = 464,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR7",
        kind = "rotating_door",
        hint = "DoubleDoorR7",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900465,
        event_id = 30465,
        source_object_index = 465,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL6",
        kind = "rotating_door",
        hint = "DoubleDoorL6",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900466,
        event_id = 30466,
        source_object_index = 466,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR6",
        kind = "rotating_door",
        hint = "DoubleDoorR6",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900467,
        event_id = 30467,
        source_object_index = 467,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL5",
        kind = "rotating_door",
        hint = "DoubleDoorL5",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900468,
        event_id = 30468,
        source_object_index = 468,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR5",
        kind = "rotating_door",
        hint = "DoubleDoorR5",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900469,
        event_id = 30469,
        source_object_index = 469,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL4",
        kind = "rotating_door",
        hint = "DoubleDoorL4",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900470,
        event_id = 30470,
        source_object_index = 470,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR4",
        kind = "rotating_door",
        hint = "DoubleDoorR4",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900471,
        event_id = 30471,
        source_object_index = 471,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL3",
        kind = "rotating_door",
        hint = "DoubleDoorL3",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900472,
        event_id = 30472,
        source_object_index = 472,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR3",
        kind = "rotating_door",
        hint = "DoubleDoorR3",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900473,
        event_id = 30473,
        source_object_index = 473,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL2",
        kind = "rotating_door",
        hint = "DoubleDoorL2",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900474,
        event_id = 30474,
        source_object_index = 474,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR2",
        kind = "rotating_door",
        hint = "DoubleDoorR2",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900475,
        event_id = 30475,
        source_object_index = 475,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL1",
        kind = "rotating_door",
        hint = "DoubleDoorL1",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900476,
        event_id = 30476,
        source_object_index = 476,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR1",
        kind = "rotating_door",
        hint = "DoubleDoorR1",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900477,
        event_id = 30477,
        source_object_index = 477,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorL13",
        kind = "rotating_door",
        hint = "DoubleDoorL13",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900478,
        event_id = 30478,
        source_object_index = 478,
        source_class = "RotatingDoor",
        source_name = "DoubleDoorR13",
        kind = "rotating_door",
        hint = "DoubleDoorR13",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
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
        mechanism_id = 900479,
        event_id = 30479,
        source_object_index = 479,
        source_class = "Door",
        source_name = "SecretDoor",
        kind = "linear_door",
        hint = "SecretDoor",
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
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
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
        source_class = "Door",
        source_name = "SecretDoorMover",
        kind = "linear_door",
        hint = "SecretDoorMover",
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
        },
    },
    {
        mechanism_id = 900591,
        event_id = 30591,
        source_object_index = 591,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
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
    [30066] = { kind = "open_door", source = "mm9_mechanism", targetName = "NCornerStone" },
    [30067] = { kind = "open_door", source = "mm9_mechanism", targetName = "OCornerStone" },
    [30068] = { kind = "open_door", source = "mm9_mechanism", targetName = "HCornerStone" },
    [30069] = { kind = "open_door", source = "mm9_mechanism", targetName = "KButton" },
    [30070] = { kind = "open_door", source = "mm9_mechanism", targetName = "NButton" },
    [30071] = { kind = "open_door", source = "mm9_mechanism", targetName = "OButton" },
    [30072] = { kind = "open_door", source = "mm9_mechanism", targetName = "HButton" },
    [30073] = { kind = "open_door", source = "mm9_mechanism", targetName = "KCornerStone" },
    [30082] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL14" },
    [30083] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR14" },
    [30455] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL12" },
    [30456] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR12" },
    [30457] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL11" },
    [30458] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR11" },
    [30459] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL10" },
    [30460] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR10" },
    [30461] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL9" },
    [30462] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR9" },
    [30463] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL7" },
    [30464] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR7" },
    [30465] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL6" },
    [30466] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR6" },
    [30467] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL5" },
    [30468] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR5" },
    [30469] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL4" },
    [30470] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR4" },
    [30471] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL3" },
    [30472] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR3" },
    [30473] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL2" },
    [30474] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR2" },
    [30475] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL1" },
    [30476] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR1" },
    [30477] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorL13" },
    [30478] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoubleDoorR13" },
    [30479] = { kind = "open_door", source = "mm9_mechanism", targetName = "SecretDoor" },
    [30480] = { kind = "open_door", source = "mm9_mechanism", targetName = "SecretDoorMover" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30066, "NCornerStone", function()
    map.triggerMechanism(66, 2)
end, "NCornerStone")

RegisterEvent(30067, "OCornerStone", function()
    map.triggerMechanism(67, 2)
end, "OCornerStone")

RegisterEvent(30068, "HCornerStone", function()
    map.triggerMechanism(68, 2)
end, "HCornerStone")

RegisterEvent(30069, "KButton", function()
    map.triggerMechanism(69, 2)
end, "KButton")

RegisterEvent(30070, "NButton", function()
    map.triggerMechanism(70, 2)
end, "NButton")

RegisterEvent(30071, "OButton", function()
    map.triggerMechanism(71, 2)
end, "OButton")

RegisterEvent(30072, "HButton", function()
    map.triggerMechanism(72, 2)
end, "HButton")

RegisterEvent(30073, "KCornerStone", function()
    map.triggerMechanism(73, 2)
end, "KCornerStone")

RegisterEvent(30082, "DoubleDoorL14", function()
    map.triggerMechanism(82, 2)
end, "DoubleDoorL14")

RegisterEvent(30083, "DoubleDoorR14", function()
    map.triggerMechanism(83, 2)
end, "DoubleDoorR14")

RegisterEvent(30455, "DoubleDoorL12", function()
    map.triggerMechanism(455, 2)
end, "DoubleDoorL12")

RegisterEvent(30456, "DoubleDoorR12", function()
    map.triggerMechanism(456, 2)
end, "DoubleDoorR12")

RegisterEvent(30457, "DoubleDoorL11", function()
    map.triggerMechanism(457, 2)
end, "DoubleDoorL11")

RegisterEvent(30458, "DoubleDoorR11", function()
    map.triggerMechanism(458, 2)
end, "DoubleDoorR11")

RegisterEvent(30459, "DoubleDoorL10", function()
    map.triggerMechanism(459, 2)
end, "DoubleDoorL10")

RegisterEvent(30460, "DoubleDoorR10", function()
    map.triggerMechanism(460, 2)
end, "DoubleDoorR10")

RegisterEvent(30461, "DoubleDoorL9", function()
    map.triggerMechanism(461, 2)
end, "DoubleDoorL9")

RegisterEvent(30462, "DoubleDoorR9", function()
    map.triggerMechanism(462, 2)
end, "DoubleDoorR9")

RegisterEvent(30463, "DoubleDoorL7", function()
    map.triggerMechanism(463, 2)
end, "DoubleDoorL7")

RegisterEvent(30464, "DoubleDoorR7", function()
    map.triggerMechanism(464, 2)
end, "DoubleDoorR7")

RegisterEvent(30465, "DoubleDoorL6", function()
    map.triggerMechanism(465, 2)
end, "DoubleDoorL6")

RegisterEvent(30466, "DoubleDoorR6", function()
    map.triggerMechanism(466, 2)
end, "DoubleDoorR6")

RegisterEvent(30467, "DoubleDoorL5", function()
    map.triggerMechanism(467, 2)
end, "DoubleDoorL5")

RegisterEvent(30468, "DoubleDoorR5", function()
    map.triggerMechanism(468, 2)
end, "DoubleDoorR5")

RegisterEvent(30469, "DoubleDoorL4", function()
    map.triggerMechanism(469, 2)
end, "DoubleDoorL4")

RegisterEvent(30470, "DoubleDoorR4", function()
    map.triggerMechanism(470, 2)
end, "DoubleDoorR4")

RegisterEvent(30471, "DoubleDoorL3", function()
    map.triggerMechanism(471, 2)
end, "DoubleDoorL3")

RegisterEvent(30472, "DoubleDoorR3", function()
    map.triggerMechanism(472, 2)
end, "DoubleDoorR3")

RegisterEvent(30473, "DoubleDoorL2", function()
    map.triggerMechanism(473, 2)
end, "DoubleDoorL2")

RegisterEvent(30474, "DoubleDoorR2", function()
    map.triggerMechanism(474, 2)
end, "DoubleDoorR2")

RegisterEvent(30475, "DoubleDoorL1", function()
    map.triggerMechanism(475, 2)
end, "DoubleDoorL1")

RegisterEvent(30476, "DoubleDoorR1", function()
    map.triggerMechanism(476, 2)
end, "DoubleDoorR1")

RegisterEvent(30477, "DoubleDoorL13", function()
    map.triggerMechanism(477, 2)
end, "DoubleDoorL13")

RegisterEvent(30478, "DoubleDoorR13", function()
    map.triggerMechanism(478, 2)
end, "DoubleDoorR13")

RegisterEvent(30479, "SecretDoor", function()
    map.triggerMechanism(479, 2)
end, "SecretDoor")

RegisterEvent(30480, "SecretDoorMover", function()
    map.triggerMechanism(480, 2)
end, "SecretDoorMover")

map.scripts["dumbgoose.scr"] = {
    source = "DUMBGOOSE.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["dumbgoose2.scr"] = {
    source = "DUMBGOOSE2.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["honk.scr"] = {
    source = "HONK.scr",
    registered_triggers = {
        { line = 94, message = "Use", callback = "Onuse" },
    },
    movement_commands = {
    },
}
map.scripts["honkaccountant.scr"] = {
    source = "HONKACCOUNTANT.scr",
    registered_triggers = {
        { line = 55, message = "stolen", callback = "KeyWasStolen" },
    },
    movement_commands = {
    },
}
map.scripts["honkfollower.scr"] = {
    source = "HONKFOLLOWER.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["honkfollowgoose.scr"] = {
    source = "HONKFOLLOWGOOSE.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["honkfollowgoose2.scr"] = {
    source = "HONKFOLLOWGOOSE2.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["honkkey.scr"] = {
    source = "HONKKEY.scr",
    registered_triggers = {
        { line = 54, message = "use", callback = "GivePlayerKey" },
        { line = 55, message = "getkey", callback = "RemoveKey" },
        { line = 56, message = "putkey", callback = "ReplaceKey" },
        { line = 97, message = "use", callback = "GivePlayerKey" },
    },
    movement_commands = {
    },
}
map.scripts["honkleader.scr"] = {
    source = "HONKLEADER.scr",
    registered_triggers = {
        { line = 52, message = "FollowerReady", callback = "StartCeremony" },
    },
    movement_commands = {
    },
}
map.scripts["honksecretdoor.scr"] = {
    source = "HONKSECRETDOOR.scr",
    registered_triggers = {
        { line = 170, message = "reset", callback = "resetButtons" },
        { line = 172, message = "UnlockButtons", callback = "UnlockButtons" },
        { line = 173, message = "hPressed", callback = "hPressed" },
        { line = 174, message = "oPressed", callback = "oPressed" },
        { line = 175, message = "nPressed", callback = "nPressed" },
        { line = 176, message = "kPressed", callback = "kPressed" },
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

function map.register(ctx)
    if ctx == nil or ctx.registerMm9MapEvents == nil then
        return
    end
    ctx:registerMm9MapEvents(map)
end

return map
