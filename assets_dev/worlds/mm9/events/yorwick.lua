-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "yorwick"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 1,
        source_name = "StartPoint0",
        x = -26220,
        y = -13164,
        z = 1334,
        direction_yaw_units = 0,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 8,
        source_name = "WizardLabExit",
        x = -8643,
        y = 17777,
        z = 1213,
        direction_yaw_units = 1524,
        move_player_to_floor = true,
    },
    {
        start_index = 2,
        source_object_index = 10,
        source_name = "LichLabExit",
        x = 13814,
        y = -20224,
        z = 1213,
        direction_yaw_units = 1790,
        move_player_to_floor = true,
    },
    {
        start_index = 3,
        source_object_index = 14,
        source_name = "YorwickExit1",
        x = -26286,
        y = -13532,
        z = 1213,
        direction_yaw_units = 0,
        move_player_to_floor = true,
    },
    {
        start_index = 4,
        source_object_index = 25,
        source_name = "YorwickExit2",
        x = -25344,
        y = -21125,
        z = 1213,
        direction_yaw_units = 1533,
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
        mechanism_id = 900005,
        event_id = 30005,
        source_object_index = 5,
        source_class = "BlueWater",
        source_name = "BlueWater1",
        kind = "water_volume",
        hint = "BlueWater1",
    },
    {
        mechanism_id = 900017,
        event_id = 30017,
        source_object_index = 17,
        source_class = "RotatingDoor",
        source_name = "CTgate",
        kind = "rotating_door",
        hint = "CTgate",
    },
    {
        mechanism_id = 900018,
        event_id = 30018,
        source_object_index = 18,
        source_class = "DestructableBrush",
        source_name = "board0",
        kind = "destructible_brush",
        hint = "board0",
    },
    {
        mechanism_id = 900019,
        event_id = 30019,
        source_object_index = 19,
        source_class = "DestructableBrush",
        source_name = "board1",
        kind = "destructible_brush",
        hint = "board1",
    },
    {
        mechanism_id = 900020,
        event_id = 30020,
        source_object_index = 20,
        source_class = "DestructableBrush",
        source_name = "board2",
        kind = "destructible_brush",
        hint = "board2",
    },
    {
        mechanism_id = 900021,
        event_id = 30021,
        source_object_index = 21,
        source_class = "DestructableBrush",
        source_name = "board3",
        kind = "destructible_brush",
        hint = "board3",
    },
    {
        mechanism_id = 900022,
        event_id = 30022,
        source_object_index = 22,
        source_class = "DestructableBrush",
        source_name = "board4",
        kind = "destructible_brush",
        hint = "board4",
    },
    {
        mechanism_id = 900023,
        event_id = 30023,
        source_object_index = 23,
        source_class = "DestructableBrush",
        source_name = "gateboard",
        kind = "destructible_brush",
        hint = "gateboard",
    },
    {
        mechanism_id = 900211,
        event_id = 30211,
        source_object_index = 211,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900212,
        event_id = 30212,
        source_object_index = 212,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900213,
        event_id = 30213,
        source_object_index = 213,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900214,
        event_id = 30214,
        source_object_index = 214,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900215,
        event_id = 30215,
        source_object_index = 215,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 900216,
        event_id = 30216,
        source_object_index = 216,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 900217,
        event_id = 30217,
        source_object_index = 217,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 900218,
        event_id = 30218,
        source_object_index = 218,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush7",
        kind = "perception_brush",
        hint = "PerceptionBrush7",
    },
    {
        mechanism_id = 900219,
        event_id = 30219,
        source_object_index = 219,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush8",
        kind = "perception_brush",
        hint = "PerceptionBrush8",
    },
    {
        mechanism_id = 900250,
        event_id = 30250,
        source_object_index = 250,
        source_class = "ScriptObject",
        source_name = "ScriptObject0",
        kind = "script_object",
        hint = "ScriptObject0",
    },
    {
        mechanism_id = 900405,
        event_id = 30405,
        source_object_index = 405,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor0",
        kind = "rotating_door",
        hint = "RotatingDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/door02open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door02close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900406,
        event_id = 30406,
        source_object_index = 406,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor1",
        kind = "rotating_door",
        hint = "RotatingDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door02open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door02close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900407,
        event_id = 30407,
        source_object_index = 407,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor2",
        kind = "rotating_door",
        hint = "RotatingDoor2",
        sounds = {
            ["open_start"] = {
                name = "Door/door02open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door02close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900408,
        event_id = 30408,
        source_object_index = 408,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor3",
        kind = "rotating_door",
        hint = "RotatingDoor3",
        sounds = {
            ["open_start"] = {
                name = "Door/door02open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door02close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900410,
        event_id = 30410,
        source_object_index = 410,
        source_class = "RotatingDoor",
        source_name = "StoreFrontDoor",
        kind = "rotating_door",
        hint = "StoreFrontDoor",
        sounds = {
            ["open_start"] = {
                name = "Door/door02open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door02close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/locked_door01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900411,
        event_id = 30411,
        source_object_index = 411,
        source_class = "RotatingDoor",
        source_name = "OutfitterDoor1",
        kind = "rotating_door",
        hint = "OutfitterDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door06close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900412,
        event_id = 30412,
        source_object_index = 412,
        source_class = "RotatingDoor",
        source_name = "OutfitterDoor2",
        kind = "rotating_door",
        hint = "OutfitterDoor2",
        sounds = {
            ["open_start"] = {
                name = "Door/door06open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door06close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900417,
        event_id = 30417,
        source_object_index = 417,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900418,
        event_id = 30418,
        source_object_index = 418,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900502,
        event_id = 30502,
        source_object_index = 502,
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
    [30017] = { kind = "open_door", source = "mm9_mechanism", targetName = "CTgate" },
    [30405] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0" },
    [30406] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor1" },
    [30407] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor2" },
    [30408] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor3" },
    [30410] = { kind = "open_door", source = "mm9_mechanism", targetName = "StoreFrontDoor" },
    [30411] = { kind = "open_door", source = "mm9_mechanism", targetName = "OutfitterDoor1" },
    [30412] = { kind = "open_door", source = "mm9_mechanism", targetName = "OutfitterDoor2" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30017, "CTgate", function()
    map.triggerMechanism(17, 2)
end, "CTgate")

RegisterEvent(30405, "RotatingDoor0", function()
    map.triggerMechanism(405, 2)
end, "RotatingDoor0")

RegisterEvent(30406, "RotatingDoor1", function()
    map.triggerMechanism(406, 2)
end, "RotatingDoor1")

RegisterEvent(30407, "RotatingDoor2", function()
    map.triggerMechanism(407, 2)
end, "RotatingDoor2")

RegisterEvent(30408, "RotatingDoor3", function()
    map.triggerMechanism(408, 2)
end, "RotatingDoor3")

RegisterEvent(30410, "StoreFrontDoor", function()
    map.triggerMechanism(410, 2)
end, "StoreFrontDoor")

RegisterEvent(30411, "OutfitterDoor1", function()
    map.triggerMechanism(411, 2)
end, "OutfitterDoor1")

RegisterEvent(30412, "OutfitterDoor2", function()
    map.triggerMechanism(412, 2)
end, "OutfitterDoor2")

map.scripts["battlecam1.scr"] = {
    source = "BATTLECAM1.scr",
    registered_triggers = {
        { line = 47, message = "Play", callback = "OnPlay" },
    },
    movement_commands = {
        { line = 31, command = "MoveToPos", arguments = "xpos Ypos Zpos nSpeed OnArrive" },
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
map.scripts["foradworld.scr"] = {
    source = "FORADWORLD.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["hidemodel.scr"] = {
    source = "HIDEMODEL.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["marysheep.scr"] = {
    source = "MARYSHEEP.scr",
    registered_triggers = {
        { line = 52, message = "RuntoMe", callback = "OnRun" },
        { line = 53, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc312.scr"] = {
    source = "NPC312.scr",
    registered_triggers = {
        { line = 81, message = "Use", callback = "OnUse" },
        { line = 82, message = "Target", callback = "ONTarget" },
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
map.scripts["shopkeeper.scr"] = {
    source = "SHOPKEEPER.scr",
    registered_triggers = {
        { line = 50, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
        { line = 70, command = "SetPos", arguments = "g_hMyObject -6415 544 4768" },
    },
}
map.scripts["svenspeech.scr"] = {
    source = "SVENSPEECH.scr",
    registered_triggers = {
        { line = 312, message = "Done", callback = "OnDone" },
        { line = 313, message = "Start", callback = "OnStart" },
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
