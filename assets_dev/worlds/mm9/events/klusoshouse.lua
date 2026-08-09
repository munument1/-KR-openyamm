-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "klusoshouse"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 48,
        source_name = "WindowStartPoint",
        x = -1597,
        y = -758,
        z = 609,
        direction_yaw_units = 1764,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 50,
        source_name = "StartPoint0",
        x = 750,
        y = 842,
        z = 205,
        direction_yaw_units = 512,
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
        source_class = "RotatingDoor",
        source_name = "RDoor9a",
        kind = "rotating_door",
        hint = "RDoor9a",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_name = "RDoor9b",
        kind = "rotating_door",
        hint = "RDoor9b",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_name = "RDoor10a",
        kind = "rotating_door",
        hint = "RDoor10a",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_name = "RDoor10b",
        kind = "rotating_door",
        hint = "RDoor10b",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_name = "RDoor12a",
        kind = "rotating_door",
        hint = "RDoor12a",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_name = "RDoor12b",
        kind = "rotating_door",
        hint = "RDoor12b",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_class = "RotatingDoor",
        source_name = "RDoor13a",
        kind = "rotating_door",
        hint = "RDoor13a",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_name = "RDoor13b",
        kind = "rotating_door",
        hint = "RDoor13b",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_name = "RDoor14a",
        kind = "rotating_door",
        hint = "RDoor14a",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_name = "RDoor14b",
        kind = "rotating_door",
        hint = "RDoor14b",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_class = "RotatingDoor",
        source_name = "RDoor15a",
        kind = "rotating_door",
        hint = "RDoor15a",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_class = "RotatingDoor",
        source_name = "RDoor15b",
        kind = "rotating_door",
        hint = "RDoor15b",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_class = "RotatingDoor",
        source_name = "RDoor16a",
        kind = "rotating_door",
        hint = "RDoor16a",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_name = "RDoor16b",
        kind = "rotating_door",
        hint = "RDoor16b",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_class = "RotatingDoor",
        source_name = "RDoor11a",
        kind = "rotating_door",
        hint = "RDoor11a",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_class = "RotatingDoor",
        source_name = "RDoor11b",
        kind = "rotating_door",
        hint = "RDoor11b",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_class = "RotatingDoor",
        source_name = "RotatingDoor7",
        kind = "rotating_door",
        hint = "RotatingDoor7",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_class = "RotatingDoor",
        source_name = "RotatingDoor8",
        kind = "rotating_door",
        hint = "RotatingDoor8",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_name = "RotatingDoor0a",
        kind = "rotating_door",
        hint = "RotatingDoor0a",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_name = "RotatingDoor0b",
        kind = "rotating_door",
        hint = "RotatingDoor0b",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_name = "RDoor2",
        kind = "rotating_door",
        hint = "RDoor2",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_class = "RotatingDoor",
        source_name = "RDoor6",
        kind = "rotating_door",
        hint = "RDoor6",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_class = "RotatingDoor",
        source_name = "RDoor4",
        kind = "rotating_door",
        hint = "RDoor4",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_class = "RotatingDoor",
        source_name = "RDoor5",
        kind = "rotating_door",
        hint = "RDoor5",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_class = "RotatingDoor",
        source_name = "RotatingDoor3a",
        kind = "rotating_door",
        hint = "RotatingDoor3a",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_class = "RotatingDoor",
        source_name = "RotatingDoor3b",
        kind = "rotating_door",
        hint = "RotatingDoor3b",
        sounds = {
            ["open_start"] = {
                name = "Door/door04open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door04close.wav",
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
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900055,
        event_id = 30055,
        source_object_index = 55,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 900056,
        event_id = 30056,
        source_object_index = 56,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900057,
        event_id = 30057,
        source_object_index = 57,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900058,
        event_id = 30058,
        source_object_index = 58,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
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
    [30003] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor9a" },
    [30004] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor9b" },
    [30005] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor10a" },
    [30006] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor10b" },
    [30007] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor12a" },
    [30008] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor12b" },
    [30009] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor13a" },
    [30010] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor13b" },
    [30011] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor14a" },
    [30012] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor14b" },
    [30013] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor15a" },
    [30014] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor15b" },
    [30015] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor16a" },
    [30016] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor16b" },
    [30017] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor11a" },
    [30018] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor11b" },
    [30019] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor7" },
    [30020] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor8" },
    [30021] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0a" },
    [30022] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0b" },
    [30023] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor2" },
    [30024] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor6" },
    [30025] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor4" },
    [30026] = { kind = "open_door", source = "mm9_mechanism", targetName = "RDoor5" },
    [30027] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor3a" },
    [30028] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor3b" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30003, "RDoor9a", function()
    map.triggerMechanism(3, 2)
end, "RDoor9a")

RegisterEvent(30004, "RDoor9b", function()
    map.triggerMechanism(4, 2)
end, "RDoor9b")

RegisterEvent(30005, "RDoor10a", function()
    map.triggerMechanism(5, 2)
end, "RDoor10a")

RegisterEvent(30006, "RDoor10b", function()
    map.triggerMechanism(6, 2)
end, "RDoor10b")

RegisterEvent(30007, "RDoor12a", function()
    map.triggerMechanism(7, 2)
end, "RDoor12a")

RegisterEvent(30008, "RDoor12b", function()
    map.triggerMechanism(8, 2)
end, "RDoor12b")

RegisterEvent(30009, "RDoor13a", function()
    map.triggerMechanism(9, 2)
end, "RDoor13a")

RegisterEvent(30010, "RDoor13b", function()
    map.triggerMechanism(10, 2)
end, "RDoor13b")

RegisterEvent(30011, "RDoor14a", function()
    map.triggerMechanism(11, 2)
end, "RDoor14a")

RegisterEvent(30012, "RDoor14b", function()
    map.triggerMechanism(12, 2)
end, "RDoor14b")

RegisterEvent(30013, "RDoor15a", function()
    map.triggerMechanism(13, 2)
end, "RDoor15a")

RegisterEvent(30014, "RDoor15b", function()
    map.triggerMechanism(14, 2)
end, "RDoor15b")

RegisterEvent(30015, "RDoor16a", function()
    map.triggerMechanism(15, 2)
end, "RDoor16a")

RegisterEvent(30016, "RDoor16b", function()
    map.triggerMechanism(16, 2)
end, "RDoor16b")

RegisterEvent(30017, "RDoor11a", function()
    map.triggerMechanism(17, 2)
end, "RDoor11a")

RegisterEvent(30018, "RDoor11b", function()
    map.triggerMechanism(18, 2)
end, "RDoor11b")

RegisterEvent(30019, "RotatingDoor7", function()
    map.triggerMechanism(19, 2)
end, "RotatingDoor7")

RegisterEvent(30020, "RotatingDoor8", function()
    map.triggerMechanism(20, 2)
end, "RotatingDoor8")

RegisterEvent(30021, "RotatingDoor0a", function()
    map.triggerMechanism(21, 2)
end, "RotatingDoor0a")

RegisterEvent(30022, "RotatingDoor0b", function()
    map.triggerMechanism(22, 2)
end, "RotatingDoor0b")

RegisterEvent(30023, "RDoor2", function()
    map.triggerMechanism(23, 2)
end, "RDoor2")

RegisterEvent(30024, "RDoor6", function()
    map.triggerMechanism(24, 2)
end, "RDoor6")

RegisterEvent(30025, "RDoor4", function()
    map.triggerMechanism(25, 2)
end, "RDoor4")

RegisterEvent(30026, "RDoor5", function()
    map.triggerMechanism(26, 2)
end, "RDoor5")

RegisterEvent(30027, "RotatingDoor3a", function()
    map.triggerMechanism(27, 2)
end, "RotatingDoor3a")

RegisterEvent(30028, "RotatingDoor3b", function()
    map.triggerMechanism(28, 2)
end, "RotatingDoor3b")

map.scripts["blackheart.scr"] = {
    source = "BLACKHEART.scr",
    registered_triggers = {
        { line = 77, message = "Use", callback = "OnUse" },
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
map.scripts["klusoshidden.scr"] = {
    source = "KLUSOSHIDDEN.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["klusospatrol.scr"] = {
    source = "KLUSOSPATROL.scr",
    registered_triggers = {
        { line = 54, message = "start", callback = "TraverseBegin" },
        { line = 55, message = "charge", callback = "HuntPlayer" },
    },
    movement_commands = {
    },
}
map.scripts["klusossleeper.scr"] = {
    source = "KLUSOSSLEEPER.scr",
    registered_triggers = {
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
