-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "lindisfarne"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 4,
        source_name = "StartPoint0",
        x = -32182,
        y = -310,
        z = 783,
        direction_yaw_units = 1536,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 22,
        source_name = "LindisfarneExit",
        x = -19968,
        y = -21036,
        z = 2747,
        direction_yaw_units = 1630,
        move_player_to_floor = true,
    },
    {
        start_index = 2,
        source_object_index = 25,
        source_name = "TasarExit",
        x = 3482,
        y = 21955,
        z = 3932,
        direction_yaw_units = 509,
        move_player_to_floor = true,
    },
    {
        start_index = 3,
        source_object_index = 124,
        source_name = "DragonStatiumExit",
        x = 6267,
        y = -15852,
        z = 594,
        direction_yaw_units = 1711,
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
        mechanism_id = 900007,
        event_id = 30007,
        source_object_index = 7,
        source_class = "BlueWater",
        source_name = "BlueWater1",
        kind = "water_volume",
        hint = "BlueWater1",
    },
    {
        mechanism_id = 900008,
        event_id = 30008,
        source_object_index = 8,
        source_class = "BlueWater",
        source_name = "BlueWater3",
        kind = "water_volume",
        hint = "BlueWater3",
    },
    {
        mechanism_id = 900026,
        event_id = 30026,
        source_object_index = 26,
        source_class = "ScriptObject",
        source_name = "ScriptObject0",
        kind = "script_object",
        hint = "ScriptObject0",
    },
    {
        mechanism_id = 900027,
        event_id = 30027,
        source_object_index = 27,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900028,
        event_id = 30028,
        source_object_index = 28,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 900029,
        event_id = 30029,
        source_object_index = 29,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 900030,
        event_id = 30030,
        source_object_index = 30,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush8",
        kind = "perception_brush",
        hint = "PerceptionBrush8",
    },
    {
        mechanism_id = 900031,
        event_id = 30031,
        source_object_index = 31,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush9",
        kind = "perception_brush",
        hint = "PerceptionBrush9",
    },
    {
        mechanism_id = 900032,
        event_id = 30032,
        source_object_index = 32,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush11",
        kind = "perception_brush",
        hint = "PerceptionBrush11",
    },
    {
        mechanism_id = 900033,
        event_id = 30033,
        source_object_index = 33,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900034,
        event_id = 30034,
        source_object_index = 34,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900035,
        event_id = 30035,
        source_object_index = 35,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush12",
        kind = "perception_brush",
        hint = "PerceptionBrush12",
    },
    {
        mechanism_id = 900036,
        event_id = 30036,
        source_object_index = 36,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush13",
        kind = "perception_brush",
        hint = "PerceptionBrush13",
    },
    {
        mechanism_id = 900126,
        event_id = 30126,
        source_object_index = 126,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900136,
        event_id = 30136,
        source_object_index = 136,
        source_class = "RotatingDoor",
        source_name = "BlacksmithDoor1",
        kind = "rotating_door",
        hint = "BlacksmithDoor1",
        sounds = {
            ["jiggle"] = {
                name = "Door/locked_door01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900137,
        event_id = 30137,
        source_object_index = 137,
        source_class = "RotatingDoor",
        source_name = "BlacksmithDoor2",
        kind = "rotating_door",
        hint = "BlacksmithDoor2",
        sounds = {
            ["jiggle"] = {
                name = "Door/locked_door01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900138,
        event_id = 30138,
        source_object_index = 138,
        source_class = "Ladder",
        source_name = "Ladder0",
        kind = "ladder_volume",
        hint = "Ladder0",
    },
    {
        mechanism_id = 900139,
        event_id = 30139,
        source_object_index = 139,
        source_class = "Ladder",
        source_name = "Ladder1",
        kind = "ladder_volume",
        hint = "Ladder1",
    },
    {
        mechanism_id = 900142,
        event_id = 30142,
        source_object_index = 142,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900143,
        event_id = 30143,
        source_object_index = 143,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900144,
        event_id = 30144,
        source_object_index = 144,
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
            ["close_stop"] = {
                name = "Door/door01close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900145,
        event_id = 30145,
        source_object_index = 145,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor3",
        kind = "rotating_door",
        hint = "RotatingDoor3",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 900146,
        event_id = 30146,
        source_object_index = 146,
        source_class = "RotatingDoor",
        source_name = "InnDoor1",
        kind = "rotating_door",
        hint = "InnDoor1",
        sounds = {
            ["jiggle"] = {
                name = "Door/locked_door01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900253,
        event_id = 30253,
        source_object_index = 253,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor8",
        kind = "rotating_door",
        hint = "RotatingDoor8",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 900254,
        event_id = 30254,
        source_object_index = 254,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor9",
        kind = "rotating_door",
        hint = "RotatingDoor9",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 900255,
        event_id = 30255,
        source_object_index = 255,
        source_class = "RotatingDoor",
        source_name = "TempleDoubleDoor2",
        kind = "rotating_door",
        hint = "TempleDoubleDoor2",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 900256,
        event_id = 30256,
        source_object_index = 256,
        source_class = "RotatingDoor",
        source_name = "TempleDoubleDoor1",
        kind = "rotating_door",
        hint = "TempleDoubleDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 900285,
        event_id = 30285,
        source_object_index = 285,
        source_class = "RotatingDoor",
        source_name = "OutfitterDoor1",
        kind = "rotating_door",
        hint = "OutfitterDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 900286,
        event_id = 30286,
        source_object_index = 286,
        source_class = "RotatingDoor",
        source_name = "OutfitterDoor2",
        kind = "rotating_door",
        hint = "OutfitterDoor2",
        sounds = {
            ["open_start"] = {
                name = "Door/door01open.wav",
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
        mechanism_id = 900309,
        event_id = 30309,
        source_object_index = 309,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900310,
        event_id = 30310,
        source_object_index = 310,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900311,
        event_id = 30311,
        source_object_index = 311,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 900312,
        event_id = 30312,
        source_object_index = 312,
        source_class = "AIBarrier",
        source_name = "AIBarrier2",
        kind = "ai_barrier",
        hint = "AIBarrier2",
    },
    {
        mechanism_id = 900313,
        event_id = 30313,
        source_object_index = 313,
        source_class = "AIBarrier",
        source_name = "AIBarrier3",
        kind = "ai_barrier",
        hint = "AIBarrier3",
    },
    {
        mechanism_id = 900314,
        event_id = 30314,
        source_object_index = 314,
        source_class = "AIBarrier",
        source_name = "AIBarrier4",
        kind = "ai_barrier",
        hint = "AIBarrier4",
    },
    {
        mechanism_id = 900315,
        event_id = 30315,
        source_object_index = 315,
        source_class = "AIBarrier",
        source_name = "AIBarrier5",
        kind = "ai_barrier",
        hint = "AIBarrier5",
    },
    {
        mechanism_id = 900316,
        event_id = 30316,
        source_object_index = 316,
        source_class = "AIBarrier",
        source_name = "AIBarrier6",
        kind = "ai_barrier",
        hint = "AIBarrier6",
    },
    {
        mechanism_id = 900317,
        event_id = 30317,
        source_object_index = 317,
        source_class = "AIBarrier",
        source_name = "AIBarrier7",
        kind = "ai_barrier",
        hint = "AIBarrier7",
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
    [30136] = { kind = "open_door", source = "mm9_mechanism", targetName = "BlacksmithDoor1" },
    [30137] = { kind = "open_door", source = "mm9_mechanism", targetName = "BlacksmithDoor2" },
    [30142] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0" },
    [30143] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor1" },
    [30144] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor2" },
    [30145] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor3" },
    [30146] = { kind = "open_door", source = "mm9_mechanism", targetName = "InnDoor1" },
    [30253] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor8" },
    [30254] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor9" },
    [30255] = { kind = "open_door", source = "mm9_mechanism", targetName = "TempleDoubleDoor2" },
    [30256] = { kind = "open_door", source = "mm9_mechanism", targetName = "TempleDoubleDoor1" },
    [30285] = { kind = "open_door", source = "mm9_mechanism", targetName = "OutfitterDoor1" },
    [30286] = { kind = "open_door", source = "mm9_mechanism", targetName = "OutfitterDoor2" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30136, "BlacksmithDoor1", function()
    map.triggerMechanism(136, 2)
end, "BlacksmithDoor1")

RegisterEvent(30137, "BlacksmithDoor2", function()
    map.triggerMechanism(137, 2)
end, "BlacksmithDoor2")

RegisterEvent(30142, "RotatingDoor0", function()
    map.triggerMechanism(142, 2)
end, "RotatingDoor0")

RegisterEvent(30143, "RotatingDoor1", function()
    map.triggerMechanism(143, 2)
end, "RotatingDoor1")

RegisterEvent(30144, "RotatingDoor2", function()
    map.triggerMechanism(144, 2)
end, "RotatingDoor2")

RegisterEvent(30145, "RotatingDoor3", function()
    map.triggerMechanism(145, 2)
end, "RotatingDoor3")

RegisterEvent(30146, "InnDoor1", function()
    map.triggerMechanism(146, 2)
end, "InnDoor1")

RegisterEvent(30253, "RotatingDoor8", function()
    map.triggerMechanism(253, 2)
end, "RotatingDoor8")

RegisterEvent(30254, "RotatingDoor9", function()
    map.triggerMechanism(254, 2)
end, "RotatingDoor9")

RegisterEvent(30255, "TempleDoubleDoor2", function()
    map.triggerMechanism(255, 2)
end, "TempleDoubleDoor2")

RegisterEvent(30256, "TempleDoubleDoor1", function()
    map.triggerMechanism(256, 2)
end, "TempleDoubleDoor1")

RegisterEvent(30285, "OutfitterDoor1", function()
    map.triggerMechanism(285, 2)
end, "OutfitterDoor1")

RegisterEvent(30286, "OutfitterDoor2", function()
    map.triggerMechanism(286, 2)
end, "OutfitterDoor2")

map.scripts["book.scr"] = {
    source = "BOOK.scr",
    registered_triggers = {
        { line = 50, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["dorude.scr"] = {
    source = "DORUDE.scr",
    registered_triggers = {
        { line = 71, message = "Use", callback = "Onuse" },
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

function map.register(ctx)
    if ctx == nil or ctx.registerMm9MapEvents == nil then
        return
    end
    ctx:registerMm9MapEvents(map)
end

return map
