-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "thearena"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 8,
        source_name = "StartPoint0",
        x = 0,
        y = -3686,
        z = 123,
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
        mechanism_id = 900001,
        event_id = 30001,
        source_object_index = 1,
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
        mechanism_id = 900002,
        event_id = 30002,
        source_object_index = 2,
        source_class = "Door",
        source_name = "RotatingDoor2",
        kind = "linear_door",
        hint = "RotatingDoor2",
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
        mechanism_id = 900003,
        event_id = 30003,
        source_object_index = 3,
        source_class = "Door",
        source_name = "RotatingDoor3",
        kind = "linear_door",
        hint = "RotatingDoor3",
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
        mechanism_id = 900004,
        event_id = 30004,
        source_object_index = 4,
        source_class = "Door",
        source_name = "RotatingDoor4",
        kind = "linear_door",
        hint = "RotatingDoor4",
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
        mechanism_id = 900005,
        event_id = 30005,
        source_object_index = 5,
        source_class = "Door",
        source_name = "RotatingDoor5",
        kind = "linear_door",
        hint = "RotatingDoor5",
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
        mechanism_id = 900019,
        event_id = 30019,
        source_object_index = 19,
        source_class = "ScriptObject",
        source_name = "ArenaFight",
        kind = "script_object",
        hint = "ArenaFight",
    },
    {
        mechanism_id = 900028,
        event_id = 30028,
        source_object_index = 28,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900030,
        event_id = 30030,
        source_object_index = 30,
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
    [30000] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0" },
    [30001] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor1" },
    [30002] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor2" },
    [30003] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor3" },
    [30004] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor4" },
    [30005] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor5" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30000, "RotatingDoor0", function()
    map.triggerMechanism(0, 2)
end, "RotatingDoor0")

RegisterEvent(30001, "RotatingDoor1", function()
    map.triggerMechanism(1, 2)
end, "RotatingDoor1")

RegisterEvent(30002, "RotatingDoor2", function()
    map.triggerMechanism(2, 2)
end, "RotatingDoor2")

RegisterEvent(30003, "RotatingDoor3", function()
    map.triggerMechanism(3, 2)
end, "RotatingDoor3")

RegisterEvent(30004, "RotatingDoor4", function()
    map.triggerMechanism(4, 2)
end, "RotatingDoor4")

RegisterEvent(30005, "RotatingDoor5", function()
    map.triggerMechanism(5, 2)
end, "RotatingDoor5")

map.scripts["arena.scr"] = {
    source = "ARENA.scr",
    registered_triggers = {
        { line = 621, message = "Arrive", callback = "OnArrive" },
        { line = 622, message = "Pick", callback = "Init" },
        { line = 623, message = "MonsterA", callback = "OnMonsterA" },
        { line = 624, message = "MonsterB", callback = "OnMonsterB" },
        { line = 625, message = "WinMonsterA", callback = "OnMonsterAWin" },
        { line = 626, message = "WinMonsterB", callback = "OnMonsterBWin" },
        { line = 627, message = "Fight", callback = "OnWatch" },
        { line = 628, message = "Lord", callback = "OnLord" },
        { line = 629, message = "IDied", callback = "OnMonsterDead" },
    },
    movement_commands = {
    },
}
map.scripts["arenafight.scr"] = {
    source = "ARENAFIGHT.scr",
    registered_triggers = {
        { line = 556, message = "Dead", callback = "OnDead" },
        { line = 557, message = "Hello", callback = "OnHello" },
        { line = 558, message = "Page", callback = "OnPage" },
        { line = 559, message = "Squire", callback = "OnSquire" },
        { line = 560, message = "Knight", callback = "OnKnight" },
        { line = 561, message = "Lord", callback = "OnLord" },
        { line = 562, message = "PlayerInTheHouse", callback = "OnPlayerInTheHouse" },
    },
    movement_commands = {
    },
}
map.scripts["npc245.scr"] = {
    source = "NPC245.scr",
    registered_triggers = {
        { line = 88, message = "Use", callback = "OnUse" },
        { line = 89, message = "Enter", callback = "OnEnter" },
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
map.scripts["svenarena.scr"] = {
    source = "SVENARENA.scr",
    registered_triggers = {
        { line = 150, message = "Walk", callback = "OnWalk" },
        { line = 151, message = "use", callback = "OnUse" },
        { line = 152, message = "Guard", callback = "OnGuard" },
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
