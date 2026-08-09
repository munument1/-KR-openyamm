-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "guberland"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 4,
        source_name = "StartPoint0",
        x = 10604,
        y = 4777,
        z = 1989,
        direction_yaw_units = 511,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 19,
        source_name = "GuberlandCityExit",
        x = -5248,
        y = -10140,
        z = 1761,
        direction_yaw_units = 1024,
        move_player_to_floor = true,
    },
    {
        start_index = 2,
        source_object_index = 24,
        source_name = "DooksCastleExit",
        x = -24740,
        y = 17039,
        z = 328,
        direction_yaw_units = 1399,
        move_player_to_floor = true,
    },
    {
        start_index = 3,
        source_object_index = 41,
        source_name = "TempleOfHonkExit",
        x = -30966,
        y = -18514,
        z = 328,
        direction_yaw_units = 1023,
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
        mechanism_id = 900023,
        event_id = 30023,
        source_object_index = 23,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 900058,
        event_id = 30058,
        source_object_index = 58,
        source_class = "ScriptObject",
        source_name = "ScriptObject0",
        kind = "script_object",
        hint = "ScriptObject0",
    },
    {
        mechanism_id = 900074,
        event_id = 30074,
        source_object_index = 74,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900075,
        event_id = 30075,
        source_object_index = 75,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900076,
        event_id = 30076,
        source_object_index = 76,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 900077,
        event_id = 30077,
        source_object_index = 77,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900079,
        event_id = 30079,
        source_object_index = 79,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900266,
        event_id = 30266,
        source_object_index = 266,
        source_class = "ScriptObject",
        source_name = "TronMgr",
        kind = "script_object",
        hint = "TronMgr",
    },
    {
        mechanism_id = 900306,
        event_id = 30306,
        source_object_index = 306,
        source_class = "Door",
        source_name = "Switch",
        kind = "linear_door",
        hint = "Switch",
    },
    {
        mechanism_id = 900320,
        event_id = 30320,
        source_object_index = 320,
        source_class = "ScriptObject",
        source_name = "Mastermind",
        kind = "script_object",
        hint = "Mastermind",
    },
    {
        mechanism_id = 900321,
        event_id = 30321,
        source_object_index = 321,
        source_class = "Door",
        source_name = "Strikeplate1",
        kind = "linear_door",
        hint = "Strikeplate1",
    },
    {
        mechanism_id = 900322,
        event_id = 30322,
        source_object_index = 322,
        source_class = "Door",
        source_name = "Riser1",
        kind = "linear_door",
        hint = "Riser1",
    },
    {
        mechanism_id = 900336,
        event_id = 30336,
        source_object_index = 336,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
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
    [30306] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch" },
    [30321] = { kind = "open_door", source = "mm9_mechanism", targetName = "Strikeplate1" },
    [30322] = { kind = "open_door", source = "mm9_mechanism", targetName = "Riser1" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30306, "Switch", function()
    map.triggerMechanism(306, 2)
end, "Switch")

RegisterEvent(30321, "Strikeplate1", function()
    map.triggerMechanism(321, 2)
end, "Strikeplate1")

RegisterEvent(30322, "Riser1", function()
    map.triggerMechanism(322, 2)
end, "Riser1")

map.scripts["armwrestle.scr"] = {
    source = "ARMWRESTLE.scr",
    registered_triggers = {
        { line = 19, message = "use", callback = "OnUse" },
        { line = 97, message = "use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["atlipromo.scr"] = {
    source = "ATLIPROMO.scr",
    registered_triggers = {
        { line = 81, message = "Return", callback = "OnReturn" },
    },
    movement_commands = {
    },
}
map.scripts["atliwagon.scr"] = {
    source = "ATLIWAGON.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["bellweight.scr"] = {
    source = "BELLWEIGHT.scr",
    registered_triggers = {
        { line = 16, message = "open", callback = "AdjustHeight" },
    },
    movement_commands = {
    },
}
map.scripts["dingthebell.scr"] = {
    source = "DINGTHEBELL.scr",
    registered_triggers = {
        { line = 17, message = "use", callback = "HitBell" },
        { line = 18, message = "ring", callback = "CheckWin" },
        { line = 35, message = "use", callback = "BlockUse" },
        { line = 70, message = "use", callback = "HitBell" },
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
map.scripts["givetake.scr"] = {
    source = "GIVETAKE.scr",
    registered_triggers = {
        { line = 70, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["huckstermod.scr"] = {
    source = "HUCKSTERMOD.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["mastermind.scr"] = {
    source = "MASTERMIND.scr",
    registered_triggers = {
        { line = 65, message = "check", callback = "CompareColors" },
        { line = 66, message = "reset", callback = "GenerateColors" },
        { line = 67, message = "update", callback = "ColorChosen" },
        { line = 172, message = "check", callback = "CompareColors" },
    },
    movement_commands = {
    },
}
map.scripts["mastermindcolor.scr"] = {
    source = "MASTERMINDCOLOR.scr",
    registered_triggers = {
        { line = 20, message = "use", callback = "ChangeColor" },
    },
    movement_commands = {
    },
}
map.scripts["mastermindspace.scr"] = {
    source = "MASTERMINDSPACE.scr",
    registered_triggers = {
        { line = 36, message = "use", callback = "UpdateColor" },
    },
    movement_commands = {
    },
}
map.scripts["npc130.scr"] = {
    source = "NPC130.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["npc132.scr"] = {
    source = "NPC132.scr",
    registered_triggers = {
        { line = 89, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc133.scr"] = {
    source = "NPC133.scr",
    registered_triggers = {
        { line = 163, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc150.scr"] = {
    source = "NPC150.scr",
    registered_triggers = {
        { line = 188, message = "Start", callback = "OnStart" },
        { line = 189, message = "Speak3", callback = "OnSpeak3" },
        { line = 190, message = "Speak5", callback = "OnSpeak5" },
        { line = 191, message = "Speak7", callback = "OnSpeak7" },
        { line = 192, message = "Speak9", callback = "OnSpeak9" },
        { line = 193, message = "Speak11", callback = "OnSpeak11" },
    },
    movement_commands = {
    },
}
map.scripts["npc151.scr"] = {
    source = "NPC151.scr",
    registered_triggers = {
        { line = 160, message = "Speak2", callback = "OnSpeak2" },
        { line = 161, message = "Speak4", callback = "OnSpeak4" },
        { line = 162, message = "Speak6", callback = "OnSpeak6" },
        { line = 163, message = "Speak8", callback = "OnSpeak8" },
        { line = 164, message = "Speak10", callback = "OnSpeak10" },
        { line = 165, message = "Speak12", callback = "OnWalkAway" },
        { line = 166, message = "Target", callback = "OnTarget" },
    },
    movement_commands = {
    },
}
map.scripts["npc186.scr"] = {
    source = "NPC186.scr",
    registered_triggers = {
        { line = 191, message = "Summon", callback = "OnSummon" },
        { line = 192, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc187.scr"] = {
    source = "NPC187.scr",
    registered_triggers = {
        { line = 97, message = "Use", callback = "OnUse" },
        { line = 98, message = "Return", callback = "OnReturn" },
    },
    movement_commands = {
    },
}
map.scripts["npc414.scr"] = {
    source = "NPC414.scr",
    registered_triggers = {
        { line = 98, message = "Use", callback = "OnUse" },
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
map.scripts["proptrigger.scr"] = {
    source = "PROPTRIGGER.scr",
    registered_triggers = {
        { line = 64, message = "Use", callback = "OnUse" },
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
map.scripts["stonesgame.scr"] = {
    source = "STONESGAME.scr",
    registered_triggers = {
        { line = 54, message = "move", callback = "CheckMove" },
        { line = 110, message = "move", callback = "CheckMove" },
    },
    movement_commands = {
    },
}
map.scripts["stonespiece.scr"] = {
    source = "STONESPIECE.scr",
    registered_triggers = {
        { line = 11, message = "white", callback = "TurnWhite" },
        { line = 12, message = "black", callback = "TurnBlack" },
    },
    movement_commands = {
    },
}
map.scripts["stonesplayer.scr"] = {
    source = "STONESPLAYER.scr",
    registered_triggers = {
        { line = 28, message = "play", callback = "PlacePiece" },
        { line = 30, message = "use", callback = "OnRudeEnter" },
    },
    movement_commands = {
    },
}
map.scripts["stonessquare.scr"] = {
    source = "STONESSQUARE.scr",
    registered_triggers = {
        { line = 37, message = "use", callback = "RequestMove" },
        { line = 38, message = "white", callback = "TurnPieceWhite" },
        { line = 39, message = "black", callback = "TurnPieceBlack" },
        { line = 40, message = "clear", callback = "TurnPieceClear" },
    },
    movement_commands = {
    },
}
map.scripts["thjorgardspectator.scr"] = {
    source = "THJORGARDSPECTATOR.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["whack-a-honky.scr"] = {
    source = "WHACK-A-HONKY.scr",
    registered_triggers = {
        { line = 34, message = "start", callback = "StartGame" },
        { line = 35, message = "popup", callback = "ReceivePopup" },
        { line = 36, message = "reset", callback = "ResetPOS" },
        { line = 104, message = "use", callback = "OnDamage" },
        { line = 182, message = "start", callback = "StartGame" },
    },
    movement_commands = {
        { line = 108, command = "MoveDir", arguments = "0,1,0, 20, 100, OnFinishedRaise" },
        { line = 142, command = "MoveToPOS", arguments = "xMe,yMe,zMe, 100, OnFinishedLower" },
        { line = 189, command = "SetPOS", arguments = "hMe, xMe,yMe,zMe" },
    },
}

function map.register(ctx)
    if ctx == nil or ctx.registerMm9MapEvents == nil then
        return
    end
    ctx:registerMm9MapEvents(map)
end

return map
