-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "hallofthegods"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 146,
        source_name = "StartPoint0",
        x = -7281,
        y = 2952,
        z = 563,
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
        mechanism_id = 900164,
        event_id = 30164,
        source_object_index = 164,
        source_class = "ScriptObject",
        source_name = "WinMan",
        kind = "script_object",
        hint = "WinMan",
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
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

map.scripts["bookletter.scr"] = {
    source = "BOOKLETTER.scr",
    registered_triggers = {
        { line = 74, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc335.scr"] = {
    source = "NPC335.scr",
    registered_triggers = {
        { line = 106, message = "Start", callback = "OnStart" },
        { line = 107, message = "Stop", callback = "Loop" },
    },
    movement_commands = {
    },
}
map.scripts["npc336.scr"] = {
    source = "NPC336.scr",
    registered_triggers = {
        { line = 321, message = "use", callback = "OnUse" },
        { line = 326, message = "Reborn", callback = "OnReborn" },
        { line = 327, message = "Done", callback = "OnDone" },
    },
    movement_commands = {
    },
}
map.scripts["npc337.scr"] = {
    source = "NPC337.scr",
    registered_triggers = {
        { line = 72, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc377.scr"] = {
    source = "NPC377.scr",
    registered_triggers = {
        { line = 31, message = "Use", callback = "OnUse" },
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
map.scripts["wg_npc334.scr"] = {
    source = "WG_NPC334.scr",
    registered_triggers = {
        { line = 267, message = "Start", callback = "OnStart" },
        { line = 268, message = "Stop", callback = "Loop" },
        { line = 269, message = "Action", callback = "OnAction" },
        { line = 270, message = "Hanndl1", callback = "OnHanndl1" },
        { line = 271, message = "Hanndl2", callback = "OnHanndl2" },
        { line = 272, message = "Hanndl3", callback = "OnHanndl3" },
        { line = 273, message = "Hanndl4", callback = "OnHanndl4" },
        { line = 274, message = "Hanndl5", callback = "OnHanndl5" },
        { line = 275, message = "Hanndl6", callback = "OnHanndl6" },
    },
    movement_commands = {
    },
}
map.scripts["wg_npc335.scr"] = {
    source = "WG_NPC335.scr",
    registered_triggers = {
        { line = 272, message = "Arrive", callback = "OnArrive" },
        { line = 273, message = "Start", callback = "OnStart" },
        { line = 274, message = "Stop", callback = "Loop" },
        { line = 275, message = "krohn1", callback = "OnKrohn1" },
        { line = 276, message = "Krohn2", callback = "OnKrohn2" },
        { line = 277, message = "krohn3", callback = "OnKrohn3" },
        { line = 278, message = "Krohn4", callback = "OnKrohn4" },
        { line = 279, message = "krohn5", callback = "OnKrohn5" },
        { line = 280, message = "Krohn6", callback = "OnKrohn6" },
        { line = 281, message = "krohn7", callback = "OnKrohn7" },
    },
    movement_commands = {
    },
}
map.scripts["wg_npc336.scr"] = {
    source = "WG_NPC336.scr",
    registered_triggers = {
        { line = 53, message = "Start", callback = "OnStart" },
        { line = 55, message = "Stop", callback = "Loop" },
    },
    movement_commands = {
    },
}
map.scripts["wg_scene7cam1.scr"] = {
    source = "WG_SCENE7CAM1.scr",
    registered_triggers = {
        { line = 70, message = "Play", callback = "OnPlay" },
    },
    movement_commands = {
        { line = 50, command = "MoveToPos", arguments = "xpos Ypos Zpos 150 OnArrive" },
    },
}
map.scripts["winman.scr"] = {
    source = "WINMAN.scr",
    registered_triggers = {
        { line = 611, message = "Use", callback = "OnUse" },
        { line = 612, message = "NjamCamDone", callback = "OnNjamCamDone" },
        { line = 613, message = "HandDone", callback = "ONHandDone" },
        { line = 614, message = "BallStart", callback = "OnBallStart" },
        { line = 615, message = "CameraSwitch", callback = "OnCameraSwitch" },
        { line = 616, message = "CameraSwitch2", callback = "OnCameraSwitch2" },
        { line = 617, message = "Frozen", callback = "OnFrozen" },
        { line = 618, message = "Panup", callback = "OnPanUp" },
        { line = 619, message = "CutTo", callback = "OnCutTo" },
        { line = 620, message = "Krohn", callback = "OnKrohn" },
        { line = 622, message = "CutToKrohn", callback = "OnKrohnCut" },
        { line = 624, message = "krohn1", callback = "OnKrohn1" },
        { line = 625, message = "Krohn2", callback = "OnKrohn2" },
        { line = 626, message = "krohn3", callback = "OnKrohn3" },
        { line = 627, message = "Krohn4", callback = "OnKrohn4" },
        { line = 628, message = "krohn5", callback = "OnKrohn5" },
        { line = 629, message = "Krohn6", callback = "OnKrohn6" },
        { line = 630, message = "krohn7", callback = "OnKrohn7" },
        { line = 631, message = "krohnClose", callback = "OnKrohnClose" },
        { line = 632, message = "Ever", callback = "OnEver" },
        { line = 636, message = "Hanndl1", callback = "OnHanndl1" },
        { line = 637, message = "Hanndl2", callback = "OnHanndl2" },
        { line = 638, message = "Hanndl3", callback = "OnHanndl3" },
        { line = 639, message = "Hanndl4", callback = "OnHanndl4" },
        { line = 640, message = "Hanndl5", callback = "OnHanndl5" },
        { line = 641, message = "Hanndl6", callback = "OnHanndl6" },
        { line = 642, message = "HanndlClose", callback = "OnHanndlClose" },
        { line = 644, message = "switch", callback = "onSwitch" },
        { line = 646, message = "End", callback = "End" },
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
