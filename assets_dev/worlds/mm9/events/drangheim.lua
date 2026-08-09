-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "drangheim"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 2,
        source_name = "StartPoint0",
        x = 12790,
        y = 3453,
        z = 579,
        direction_yaw_units = 1009,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 9,
        source_name = "DrangheimCityExit",
        x = 8929,
        y = -4137,
        z = 1106,
        direction_yaw_units = 449,
        move_player_to_floor = true,
    },
    {
        start_index = 2,
        source_object_index = 11,
        source_name = "FTDrangheim",
        x = -18268,
        y = -21217,
        z = 2939,
        direction_yaw_units = 521,
        move_player_to_floor = true,
    },
    {
        start_index = 3,
        source_object_index = 38,
        source_name = "DPSecretExit",
        x = -6697,
        y = 1270,
        z = 2542,
        direction_yaw_units = 1204,
        move_player_to_floor = true,
    },
    {
        start_index = 4,
        source_object_index = 39,
        source_name = "DrangheimPrisonExit",
        x = -10888,
        y = -16105,
        z = 2092,
        direction_yaw_units = 0,
        move_player_to_floor = true,
    },
    {
        start_index = 5,
        source_object_index = 64,
        source_name = "ChasmOfTheDeadExit",
        x = -379,
        y = -21617,
        z = 2708,
        direction_yaw_units = 822,
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
        mechanism_id = 900033,
        event_id = 30033,
        source_object_index = 33,
        source_class = "ScriptObject",
        source_name = "YobboeMan",
        kind = "script_object",
        hint = "YobboeMan",
    },
    {
        mechanism_id = 900034,
        event_id = 30034,
        source_object_index = 34,
        source_class = "BlueWater",
        source_name = "Well water",
        kind = "water_volume",
        hint = "Well water",
    },
    {
        mechanism_id = 900035,
        event_id = 30035,
        source_object_index = 35,
        source_class = "Ladder",
        source_name = "Ladder5",
        kind = "ladder_volume",
        hint = "Ladder5",
    },
    {
        mechanism_id = 900041,
        event_id = 30041,
        source_object_index = 41,
        source_class = "RotatingDoor",
        source_name = "cottage door",
        kind = "rotating_door",
        hint = "cottage door",
    },
    {
        mechanism_id = 900053,
        event_id = 30053,
        source_object_index = 53,
        source_class = "Door",
        source_name = "Door0",
        kind = "linear_door",
        hint = "Door0",
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
        mechanism_id = 900054,
        event_id = 30054,
        source_object_index = 54,
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
            ["jiggle"] = {
                name = "Door/locked_door02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900057,
        event_id = 30057,
        source_object_index = 57,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush0",
        kind = "destructible_brush",
        hint = "DestructableBrush0",
    },
    {
        mechanism_id = 900115,
        event_id = 30115,
        source_object_index = 115,
        source_class = "ScriptObject",
        source_name = "ScriptObject0",
        kind = "script_object",
        hint = "ScriptObject0",
    },
    {
        mechanism_id = 900125,
        event_id = 30125,
        source_object_index = 125,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 900126,
        event_id = 30126,
        source_object_index = 126,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900127,
        event_id = 30127,
        source_object_index = 127,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900128,
        event_id = 30128,
        source_object_index = 128,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900129,
        event_id = 30129,
        source_object_index = 129,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900130,
        event_id = 30130,
        source_object_index = 130,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 900151,
        event_id = 30151,
        source_object_index = 151,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900152,
        event_id = 30152,
        source_object_index = 152,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900153,
        event_id = 30153,
        source_object_index = 153,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900154,
        event_id = 30154,
        source_object_index = 154,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 900155,
        event_id = 30155,
        source_object_index = 155,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 900156,
        event_id = 30156,
        source_object_index = 156,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 900157,
        event_id = 30157,
        source_object_index = 157,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush6",
        kind = "collision_volume",
        hint = "InvisibleBrush6",
    },
    {
        mechanism_id = 900158,
        event_id = 30158,
        source_object_index = 158,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush7",
        kind = "collision_volume",
        hint = "InvisibleBrush7",
    },
    {
        mechanism_id = 900183,
        event_id = 30183,
        source_object_index = 183,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900184,
        event_id = 30184,
        source_object_index = 184,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 900185,
        event_id = 30185,
        source_object_index = 185,
        source_class = "AIBarrier",
        source_name = "AIBarrier2",
        kind = "ai_barrier",
        hint = "AIBarrier2",
    },
    {
        mechanism_id = 900186,
        event_id = 30186,
        source_object_index = 186,
        source_class = "AIBarrier",
        source_name = "AIBarrier3",
        kind = "ai_barrier",
        hint = "AIBarrier3",
    },
    {
        mechanism_id = 900187,
        event_id = 30187,
        source_object_index = 187,
        source_class = "AIBarrier",
        source_name = "AIBarrier4",
        kind = "ai_barrier",
        hint = "AIBarrier4",
    },
    {
        mechanism_id = 900188,
        event_id = 30188,
        source_object_index = 188,
        source_class = "AIBarrier",
        source_name = "AIBarrier5",
        kind = "ai_barrier",
        hint = "AIBarrier5",
    },
    {
        mechanism_id = 900189,
        event_id = 30189,
        source_object_index = 189,
        source_class = "AIBarrier",
        source_name = "AIBarrier6",
        kind = "ai_barrier",
        hint = "AIBarrier6",
    },
    {
        mechanism_id = 900196,
        event_id = 30196,
        source_object_index = 196,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
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
    [30041] = { kind = "open_door", source = "mm9_mechanism", targetName = "cottage door" },
    [30053] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door0" },
    [30054] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30041, "cottage door", function()
    map.triggerMechanism(41, 2)
end, "cottage door")

RegisterEvent(30053, "Door0", function()
    map.triggerMechanism(53, 2)
end, "Door0")

RegisterEvent(30054, "RotatingDoor0", function()
    map.triggerMechanism(54, 2)
end, "RotatingDoor0")

map.scripts["dolly.scr"] = {
    source = "DOLLY.scr",
    registered_triggers = {
        { line = 75, message = "Use", callback = "Onuse" },
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
map.scripts["herbs.scr"] = {
    source = "HERBS.scr",
    registered_triggers = {
        { line = 76, message = "Use", callback = "Onuse" },
    },
    movement_commands = {
    },
}
map.scripts["npc90.scr"] = {
    source = "NPC90.scr",
    registered_triggers = {
        { line = 274, message = "Use", callback = "OnUse" },
        { line = 275, message = "Stop", callback = "OnSTop" },
    },
    movement_commands = {
        { line = 78, command = "setpos", arguments = "g_hMyObject -2525 948 397" },
        { line = 84, command = "setpos", arguments = "g_hMyObject -4253 817 -6191" },
        { line = 227, command = "setpos", arguments = "g_hmyobject xPos yPos zPos" },
    },
}
map.scripts["npc91.scr"] = {
    source = "NPC91.scr",
    registered_triggers = {
        { line = 97, message = "Use", callback = "Onuse" },
    },
    movement_commands = {
    },
}
map.scripts["npc92.scr"] = {
    source = "NPC92.scr",
    registered_triggers = {
        { line = 88, message = "Use", callback = "Onuse" },
    },
    movement_commands = {
    },
}
map.scripts["npc93.scr"] = {
    source = "NPC93.scr",
    registered_triggers = {
        { line = 87, message = "Use", callback = "Onuse" },
    },
    movement_commands = {
    },
}
map.scripts["plow.scr"] = {
    source = "PLOW.scr",
    registered_triggers = {
        { line = 75, message = "Use", callback = "Onuse" },
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
map.scripts["realbook.scr"] = {
    source = "REALBOOK.scr",
    registered_triggers = {
        { line = 68, message = "Use", callback = "Onuse" },
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
map.scripts["tm_hardrock.scr"] = {
    source = "TM_HARDROCK.scr",
    registered_triggers = {
        { line = 65, message = "OneDown", callback = "OneDown" },
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
