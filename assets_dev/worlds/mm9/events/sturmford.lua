-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "sturmford"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 0,
        source_name = "StartPoint0",
        x = 4992,
        y = -17546,
        z = 678,
        direction_yaw_units = 512,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 19,
        source_name = "SturmfordDocks",
        x = -1516,
        y = -13066,
        z = 543,
        direction_yaw_units = 1026,
        move_player_to_floor = true,
    },
    {
        start_index = 2,
        source_object_index = 22,
        source_name = "Sturmfordcityexit",
        x = 5571,
        y = -3277,
        z = 543,
        direction_yaw_units = 1284,
        move_player_to_floor = true,
    },
    {
        start_index = 3,
        source_object_index = 26,
        source_name = "FTSturmford",
        x = -5916,
        y = 20644,
        z = 1247,
        direction_yaw_units = 973,
        move_player_to_floor = true,
    },
    {
        start_index = 4,
        source_object_index = 196,
        source_name = "Abandonedfortfront",
        x = 12616,
        y = 16712,
        z = 1270,
        direction_yaw_units = 512,
        move_player_to_floor = true,
    },
    {
        start_index = 5,
        source_object_index = 197,
        source_name = "Abandonedfortback",
        x = 15729,
        y = 16712,
        z = 2212,
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
        mechanism_id = 900024,
        event_id = 30024,
        source_object_index = 24,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900028,
        event_id = 30028,
        source_object_index = 28,
        source_class = "ScriptObject",
        source_name = "ScriptObject0",
        kind = "script_object",
        hint = "ScriptObject0",
    },
    {
        mechanism_id = 900029,
        event_id = 30029,
        source_object_index = 29,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 900093,
        event_id = 30093,
        source_object_index = 93,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900183,
        event_id = 30183,
        source_object_index = 183,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900184,
        event_id = 30184,
        source_object_index = 184,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900185,
        event_id = 30185,
        source_object_index = 185,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900188,
        event_id = 30188,
        source_object_index = 188,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900189,
        event_id = 30189,
        source_object_index = 189,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900190,
        event_id = 30190,
        source_object_index = 190,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 900199,
        event_id = 30199,
        source_object_index = 199,
        source_class = "DestructableBrush",
        source_name = "Weakwall",
        kind = "destructible_brush",
        hint = "Weakwall",
    },
    {
        mechanism_id = 900200,
        event_id = 30200,
        source_object_index = 200,
        source_class = "PerceptionBrush",
        source_name = "Weakwallperc",
        kind = "perception_brush",
        hint = "Weakwallperc",
    },
    {
        mechanism_id = 900201,
        event_id = 30201,
        source_object_index = 201,
        source_class = "PerceptionBrush",
        source_name = "Portchainperc",
        kind = "perception_brush",
        hint = "Portchainperc",
    },
    {
        mechanism_id = 900202,
        event_id = 30202,
        source_object_index = 202,
        source_class = "PerceptionBrush",
        source_name = "Drawchainperc",
        kind = "perception_brush",
        hint = "Drawchainperc",
    },
    {
        mechanism_id = 900203,
        event_id = 30203,
        source_object_index = 203,
        source_class = "ScriptObject",
        source_name = "defense",
        kind = "script_object",
        hint = "defense",
    },
    {
        mechanism_id = 900251,
        event_id = 30251,
        source_object_index = 251,
        source_class = "Door",
        source_name = "DoorChain4",
        kind = "linear_door",
        hint = "DoorChain4",
    },
    {
        mechanism_id = 900260,
        event_id = 30260,
        source_object_index = 260,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 900261,
        event_id = 30261,
        source_object_index = 261,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 900262,
        event_id = 30262,
        source_object_index = 262,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush6",
        kind = "collision_volume",
        hint = "InvisibleBrush6",
    },
    {
        mechanism_id = 900299,
        event_id = 30299,
        source_object_index = 299,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor16",
        kind = "rotating_door",
        hint = "RotatingDoor16",
    },
    {
        mechanism_id = 900300,
        event_id = 30300,
        source_object_index = 300,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor15",
        kind = "rotating_door",
        hint = "RotatingDoor15",
    },
    {
        mechanism_id = 900301,
        event_id = 30301,
        source_object_index = 301,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor13",
        kind = "rotating_door",
        hint = "RotatingDoor13",
    },
    {
        mechanism_id = 900302,
        event_id = 30302,
        source_object_index = 302,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor14",
        kind = "rotating_door",
        hint = "RotatingDoor14",
    },
    {
        mechanism_id = 900303,
        event_id = 30303,
        source_object_index = 303,
        source_class = "Door",
        source_name = "Portcullis",
        kind = "linear_door",
        hint = "Portcullis",
        sounds = {
            ["open_busy"] = {
                name = "Events/drawbridge02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900304,
        event_id = 30304,
        source_object_index = 304,
        source_class = "Ladder",
        source_name = "Ladder1",
        kind = "ladder_volume",
        hint = "Ladder1",
    },
    {
        mechanism_id = 900307,
        event_id = 30307,
        source_object_index = 307,
        source_class = "Ladder",
        source_name = "Ladder0",
        kind = "ladder_volume",
        hint = "Ladder0",
    },
    {
        mechanism_id = 900310,
        event_id = 30310,
        source_object_index = 310,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor7",
        kind = "rotating_door",
        hint = "RotatingDoor7",
        sounds = {
            ["jiggle"] = {
                name = "Door/knock.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900311,
        event_id = 30311,
        source_object_index = 311,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor8",
        kind = "rotating_door",
        hint = "RotatingDoor8",
        sounds = {
            ["jiggle"] = {
                name = "Door/knock.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900312,
        event_id = 30312,
        source_object_index = 312,
        source_class = "RotatingDoor",
        source_name = "Hatch2",
        kind = "rotating_door",
        hint = "Hatch2",
        sounds = {
            ["jiggle"] = {
                name = "Door/locked_door02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900313,
        event_id = 30313,
        source_object_index = 313,
        source_class = "RotatingDoor",
        source_name = "Hatch1",
        kind = "rotating_door",
        hint = "Hatch1",
        sounds = {
            ["jiggle"] = {
                name = "Door/locked_door02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900314,
        event_id = 30314,
        source_object_index = 314,
        source_class = "RotatingDoor",
        source_name = "drawbridge",
        kind = "rotating_door",
        hint = "drawbridge",
        sounds = {
            ["open_start"] = {
                name = "Events/WoodCreak1.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/stonedoorslam.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900315,
        event_id = 30315,
        source_object_index = 315,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush0",
        kind = "destructible_brush",
        hint = "DestructableBrush0",
    },
    {
        mechanism_id = 900316,
        event_id = 30316,
        source_object_index = 316,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush1",
        kind = "destructible_brush",
        hint = "DestructableBrush1",
    },
    {
        mechanism_id = 900317,
        event_id = 30317,
        source_object_index = 317,
        source_class = "DestructableBrush",
        source_name = "Drawbridgechain",
        kind = "destructible_brush",
        hint = "Drawbridgechain",
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
    [30251] = { kind = "open_door", source = "mm9_mechanism", targetName = "DoorChain4" },
    [30299] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor16" },
    [30300] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor15" },
    [30301] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor13" },
    [30302] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor14" },
    [30303] = { kind = "open_door", source = "mm9_mechanism", targetName = "Portcullis" },
    [30310] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor7" },
    [30311] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor8" },
    [30312] = { kind = "open_door", source = "mm9_mechanism", targetName = "Hatch2" },
    [30313] = { kind = "open_door", source = "mm9_mechanism", targetName = "Hatch1" },
    [30314] = { kind = "open_door", source = "mm9_mechanism", targetName = "drawbridge" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30251, "DoorChain4", function()
    map.triggerMechanism(251, 2)
end, "DoorChain4")

RegisterEvent(30299, "RotatingDoor16", function()
    map.triggerMechanism(299, 2)
end, "RotatingDoor16")

RegisterEvent(30300, "RotatingDoor15", function()
    map.triggerMechanism(300, 2)
end, "RotatingDoor15")

RegisterEvent(30301, "RotatingDoor13", function()
    map.triggerMechanism(301, 2)
end, "RotatingDoor13")

RegisterEvent(30302, "RotatingDoor14", function()
    map.triggerMechanism(302, 2)
end, "RotatingDoor14")

RegisterEvent(30303, "Portcullis", function()
    map.triggerMechanism(303, 2)
end, "Portcullis")

RegisterEvent(30310, "RotatingDoor7", function()
    map.triggerMechanism(310, 2)
end, "RotatingDoor7")

RegisterEvent(30311, "RotatingDoor8", function()
    map.triggerMechanism(311, 2)
end, "RotatingDoor8")

RegisterEvent(30312, "Hatch2", function()
    map.triggerMechanism(312, 2)
end, "Hatch2")

RegisterEvent(30313, "Hatch1", function()
    map.triggerMechanism(313, 2)
end, "Hatch1")

RegisterEvent(30314, "drawbridge", function()
    map.triggerMechanism(314, 2)
end, "drawbridge")

map.scripts["ak_disable.scr"] = {
    source = "AK_DISABLE.scr",
    registered_triggers = {
        { line = 132, message = "Drawbridge", callback = "OnDraw" },
        { line = 133, message = "Portcullis", callback = "ONPortcullis" },
    },
    movement_commands = {
    },
}
map.scripts["destructon.scr"] = {
    source = "DESTRUCTON.scr",
    registered_triggers = {
        { line = 37, message = "DamageOn", callback = "OnDamageOn" },
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
map.scripts["foradworld.scr"] = {
    source = "FORADWORLD.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["npcshopkeeper.scr"] = {
    source = "NPCSHOPKEEPER.scr",
    registered_triggers = {
        { line = 47, message = "Use", callback = "OnUse" },
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
