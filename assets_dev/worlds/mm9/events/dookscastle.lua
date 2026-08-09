-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "dookscastle"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 383,
        source_name = "StartPoint0",
        x = 0,
        y = 1393,
        z = 154,
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
        mechanism_id = 900241,
        event_id = 30241,
        source_object_index = 241,
        source_class = "Door",
        source_name = "doorslide",
        kind = "linear_door",
        hint = "doorslide",
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
                name = "Events/slam.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900242,
        event_id = 30242,
        source_object_index = 242,
        source_class = "RotatingDoor",
        source_name = "Tempbutton",
        kind = "rotating_door",
        hint = "Tempbutton",
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
        mechanism_id = 900243,
        event_id = 30243,
        source_object_index = 243,
        source_class = "RotatingDoor",
        source_name = "double door left 01",
        kind = "rotating_door",
        hint = "double door left 01",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
        mechanism_id = 900244,
        event_id = 30244,
        source_object_index = 244,
        source_class = "RotatingDoor",
        source_name = "double door right 01",
        kind = "rotating_door",
        hint = "double door right 01",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
        mechanism_id = 900245,
        event_id = 30245,
        source_object_index = 245,
        source_class = "RotatingDoor",
        source_name = "double door left 02",
        kind = "rotating_door",
        hint = "double door left 02",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
        mechanism_id = 900246,
        event_id = 30246,
        source_object_index = 246,
        source_class = "RotatingDoor",
        source_name = "double door right 02",
        kind = "rotating_door",
        hint = "double door right 02",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
        mechanism_id = 900247,
        event_id = 30247,
        source_object_index = 247,
        source_class = "RotatingDoor",
        source_name = "double door left 03",
        kind = "rotating_door",
        hint = "double door left 03",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
        mechanism_id = 900248,
        event_id = 30248,
        source_object_index = 248,
        source_class = "RotatingDoor",
        source_name = "double door right 03",
        kind = "rotating_door",
        hint = "double door right 03",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
        mechanism_id = 900249,
        event_id = 30249,
        source_object_index = 249,
        source_class = "RotatingDoor",
        source_name = "double door left 04",
        kind = "rotating_door",
        hint = "double door left 04",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
        mechanism_id = 900250,
        event_id = 30250,
        source_object_index = 250,
        source_class = "RotatingDoor",
        source_name = "double door right 04",
        kind = "rotating_door",
        hint = "double door right 04",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
        mechanism_id = 900251,
        event_id = 30251,
        source_object_index = 251,
        source_class = "RotatingDoor",
        source_name = "double door left 05",
        kind = "rotating_door",
        hint = "double door left 05",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
        mechanism_id = 900252,
        event_id = 30252,
        source_object_index = 252,
        source_class = "RotatingDoor",
        source_name = "double door right 05",
        kind = "rotating_door",
        hint = "double door right 05",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
        mechanism_id = 900253,
        event_id = 30253,
        source_object_index = 253,
        source_class = "RotatingDoor",
        source_name = "double door left 06",
        kind = "rotating_door",
        hint = "double door left 06",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
        mechanism_id = 900254,
        event_id = 30254,
        source_object_index = 254,
        source_class = "RotatingDoor",
        source_name = "double door right 06",
        kind = "rotating_door",
        hint = "double door right 06",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
        mechanism_id = 900255,
        event_id = 30255,
        source_object_index = 255,
        source_class = "RotatingDoor",
        source_name = "double door left 07",
        kind = "rotating_door",
        hint = "double door left 07",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
        mechanism_id = 900256,
        event_id = 30256,
        source_object_index = 256,
        source_class = "RotatingDoor",
        source_name = "double door right 07",
        kind = "rotating_door",
        hint = "double door right 07",
        sounds = {
            ["open_start"] = {
                name = "Door/doormetal_open02.wav",
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
        mechanism_id = 900388,
        event_id = 30388,
        source_object_index = 388,
        source_class = "Ladder",
        source_name = "Ladder0",
        kind = "ladder_volume",
        hint = "Ladder0",
    },
    {
        mechanism_id = 900444,
        event_id = 30444,
        source_object_index = 444,
        source_class = "ScriptObject",
        source_name = "DOOK_HOSTILITY",
        kind = "script_object",
        hint = "DOOK_HOSTILITY",
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
    [30241] = { kind = "open_door", source = "mm9_mechanism", targetName = "doorslide" },
    [30242] = { kind = "open_door", source = "mm9_mechanism", targetName = "Tempbutton" },
    [30243] = { kind = "open_door", source = "mm9_mechanism", targetName = "double door left 01" },
    [30244] = { kind = "open_door", source = "mm9_mechanism", targetName = "double door right 01" },
    [30245] = { kind = "open_door", source = "mm9_mechanism", targetName = "double door left 02" },
    [30246] = { kind = "open_door", source = "mm9_mechanism", targetName = "double door right 02" },
    [30247] = { kind = "open_door", source = "mm9_mechanism", targetName = "double door left 03" },
    [30248] = { kind = "open_door", source = "mm9_mechanism", targetName = "double door right 03" },
    [30249] = { kind = "open_door", source = "mm9_mechanism", targetName = "double door left 04" },
    [30250] = { kind = "open_door", source = "mm9_mechanism", targetName = "double door right 04" },
    [30251] = { kind = "open_door", source = "mm9_mechanism", targetName = "double door left 05" },
    [30252] = { kind = "open_door", source = "mm9_mechanism", targetName = "double door right 05" },
    [30253] = { kind = "open_door", source = "mm9_mechanism", targetName = "double door left 06" },
    [30254] = { kind = "open_door", source = "mm9_mechanism", targetName = "double door right 06" },
    [30255] = { kind = "open_door", source = "mm9_mechanism", targetName = "double door left 07" },
    [30256] = { kind = "open_door", source = "mm9_mechanism", targetName = "double door right 07" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30241, "doorslide", function()
    map.triggerMechanism(241, 2)
end, "doorslide")

RegisterEvent(30242, "Tempbutton", function()
    map.triggerMechanism(242, 2)
end, "Tempbutton")

RegisterEvent(30243, "double door left 01", function()
    map.triggerMechanism(243, 2)
end, "double door left 01")

RegisterEvent(30244, "double door right 01", function()
    map.triggerMechanism(244, 2)
end, "double door right 01")

RegisterEvent(30245, "double door left 02", function()
    map.triggerMechanism(245, 2)
end, "double door left 02")

RegisterEvent(30246, "double door right 02", function()
    map.triggerMechanism(246, 2)
end, "double door right 02")

RegisterEvent(30247, "double door left 03", function()
    map.triggerMechanism(247, 2)
end, "double door left 03")

RegisterEvent(30248, "double door right 03", function()
    map.triggerMechanism(248, 2)
end, "double door right 03")

RegisterEvent(30249, "double door left 04", function()
    map.triggerMechanism(249, 2)
end, "double door left 04")

RegisterEvent(30250, "double door right 04", function()
    map.triggerMechanism(250, 2)
end, "double door right 04")

RegisterEvent(30251, "double door left 05", function()
    map.triggerMechanism(251, 2)
end, "double door left 05")

RegisterEvent(30252, "double door right 05", function()
    map.triggerMechanism(252, 2)
end, "double door right 05")

RegisterEvent(30253, "double door left 06", function()
    map.triggerMechanism(253, 2)
end, "double door left 06")

RegisterEvent(30254, "double door right 06", function()
    map.triggerMechanism(254, 2)
end, "double door right 06")

RegisterEvent(30255, "double door left 07", function()
    map.triggerMechanism(255, 2)
end, "double door left 07")

RegisterEvent(30256, "double door right 07", function()
    map.triggerMechanism(256, 2)
end, "double door right 07")

map.scripts["bookletter.scr"] = {
    source = "BOOKLETTER.scr",
    registered_triggers = {
        { line = 74, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["dc_sargent.scr"] = {
    source = "DC_SARGENT.scr",
    registered_triggers = {
        { line = 122, message = "StartUp", callback = "StartUp" },
    },
    movement_commands = {
    },
}
map.scripts["dookguardbasic.scr"] = {
    source = "DOOKGUARDBASIC.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["dooksleepgaurd.scr"] = {
    source = "DOOKSLEEPGAURD.scr",
    registered_triggers = {
        { line = 114, message = "WakeUp", callback = "WakeUp" },
    },
    movement_commands = {
    },
}
map.scripts["npc415.scr"] = {
    source = "NPC415.scr",
    registered_triggers = {
        { line = 84, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["scurrycreature.scr"] = {
    source = "SCURRYCREATURE.scr",
    registered_triggers = {
        { line = 38, message = "Hide", callback = "GoHide" },
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
