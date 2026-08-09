-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "greatgate"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 0,
        source_name = "StartPoint0",
        x = 0,
        y = 246,
        z = 246,
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
        mechanism_id = 900013,
        event_id = 30013,
        source_object_index = 13,
        source_class = "Door",
        source_name = "Door0",
        kind = "linear_door",
        hint = "Door0",
    },
    {
        mechanism_id = 900014,
        event_id = 30014,
        source_object_index = 14,
        source_class = "ScriptObject",
        source_name = "Loseman",
        kind = "script_object",
        hint = "Loseman",
    },
    {
        mechanism_id = 900015,
        event_id = 30015,
        source_object_index = 15,
        source_class = "ScriptObject",
        source_name = "Fateman",
        kind = "script_object",
        hint = "Fateman",
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
    [30013] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door0" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30013, "Door0", function()
    map.triggerMechanism(13, 2)
end, "Door0")

map.scripts["fateman.scr"] = {
    source = "FATEMAN.scr",
    registered_triggers = {
        { line = 452, message = "Lose", callback = "OnLose" },
        { line = 453, message = "Cam2", callback = "OnCam2" },
        { line = 454, message = "cam3", callback = "OnCam3" },
        { line = 455, message = "FadeOut", callback = "Close" },
        { line = 456, message = "Done", callback = "OnDone" },
    },
    movement_commands = {
    },
}
map.scripts["hanndl.scr"] = {
    source = "HANNDL.scr",
    registered_triggers = {
        { line = 238, message = "Speak", callback = "Speak1" },
        { line = 239, message = "Speak9", callback = "OnSpeak9" },
        { line = 240, message = "Speak10", callback = "OnSpeak10" },
        { line = 241, message = "Speak11", callback = "OnSpeak11" },
        { line = 242, message = "Speak12", callback = "OnSpeak12" },
        { line = 243, message = "Speak13", callback = "OnSpeak13" },
        { line = 244, message = "Speak14", callback = "OnSpeak14" },
        { line = 245, message = "Speak15", callback = "OnSpeak15" },
        { line = 246, message = "Speak16", callback = "OnSpeak16" },
        { line = 247, message = "Speak17", callback = "OnSpeak17" },
    },
    movement_commands = {
    },
}
map.scripts["losecam1.scr"] = {
    source = "LOSECAM1.scr",
    registered_triggers = {
        { line = 73, message = "Play", callback = "OnPlay" },
    },
    movement_commands = {
        { line = 48, command = "MoveToPos", arguments = "xpos Ypos Zpos 100 OnArrive1" },
        { line = 64, command = "SetPos", arguments = "g_hmyobject MyX MyY MyZ DoNothing" },
    },
}
map.scripts["losecam2.scr"] = {
    source = "LOSECAM2.scr",
    registered_triggers = {
        { line = 70, message = "Play", callback = "OnPlay" },
    },
    movement_commands = {
        { line = 45, command = "MoveToPos", arguments = "xpos Ypos Zpos 150 OnArrive1" },
        { line = 61, command = "SetPos", arguments = "g_hmyobject MyX MyY MyZ DoNothing" },
    },
}
map.scripts["loseman.scr"] = {
    source = "LOSEMAN.scr",
    registered_triggers = {
        { line = 113, message = "Lose", callback = "OnLose" },
        { line = 114, message = "Cam2", callback = "OnCam2" },
        { line = 115, message = "cam3", callback = "OnCam3" },
        { line = 116, message = "FadeOut", callback = "Close" },
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
