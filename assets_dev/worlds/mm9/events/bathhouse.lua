-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "bathhouse"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 0,
        source_name = "StartPoint0",
        x = -983,
        y = -901,
        z = -34,
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
        mechanism_id = 900002,
        event_id = 30002,
        source_object_index = 2,
        source_class = "Ladder",
        source_name = "Ladder0",
        kind = "ladder_volume",
        hint = "Ladder0",
    },
    {
        mechanism_id = 900003,
        event_id = 30003,
        source_object_index = 3,
        source_class = "BlueWater",
        source_name = "Deathwater2",
        kind = "water_volume",
        hint = "Deathwater2",
    },
    {
        mechanism_id = 900004,
        event_id = 30004,
        source_object_index = 4,
        source_class = "Door",
        source_name = "DragonDoor1",
        kind = "linear_door",
        hint = "DragonDoor1",
    },
    {
        mechanism_id = 900008,
        event_id = 30008,
        source_object_index = 8,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 900009,
        event_id = 30009,
        source_object_index = 9,
        source_class = "BlueWater",
        source_name = "BlueWater1",
        kind = "water_volume",
        hint = "BlueWater1",
    },
    {
        mechanism_id = 900010,
        event_id = 30010,
        source_object_index = 10,
        source_class = "BlueWater",
        source_name = "BlueWater10",
        kind = "water_volume",
        hint = "BlueWater10",
    },
    {
        mechanism_id = 900011,
        event_id = 30011,
        source_object_index = 11,
        source_class = "BlueWater",
        source_name = "BlueWater14",
        kind = "water_volume",
        hint = "BlueWater14",
    },
    {
        mechanism_id = 900012,
        event_id = 30012,
        source_object_index = 12,
        source_class = "BlueWater",
        source_name = "WaterthatBoilsB",
        kind = "water_volume",
        hint = "WaterthatBoilsB",
    },
    {
        mechanism_id = 900013,
        event_id = 30013,
        source_object_index = 13,
        source_class = "BlueWater",
        source_name = "BlueWater4",
        kind = "water_volume",
        hint = "BlueWater4",
    },
    {
        mechanism_id = 900014,
        event_id = 30014,
        source_object_index = 14,
        source_class = "BlueWater",
        source_name = "WaterthatBoilsA",
        kind = "water_volume",
        hint = "WaterthatBoilsA",
    },
    {
        mechanism_id = 900015,
        event_id = 30015,
        source_object_index = 15,
        source_class = "BlueWater",
        source_name = "BlueWater6",
        kind = "water_volume",
        hint = "BlueWater6",
    },
    {
        mechanism_id = 900016,
        event_id = 30016,
        source_object_index = 16,
        source_class = "BlueWater",
        source_name = "BlueWater8",
        kind = "water_volume",
        hint = "BlueWater8",
    },
    {
        mechanism_id = 900017,
        event_id = 30017,
        source_object_index = 17,
        source_class = "BlueWater",
        source_name = "BlueWater7",
        kind = "water_volume",
        hint = "BlueWater7",
    },
    {
        mechanism_id = 900018,
        event_id = 30018,
        source_object_index = 18,
        source_class = "BlueWater",
        source_name = "BlueWater9",
        kind = "water_volume",
        hint = "BlueWater9",
    },
    {
        mechanism_id = 900022,
        event_id = 30022,
        source_object_index = 22,
        source_class = "Door",
        source_name = "Door5",
        kind = "linear_door",
        hint = "Door5",
    },
    {
        mechanism_id = 900023,
        event_id = 30023,
        source_object_index = 23,
        source_class = "Door",
        source_name = "Door4",
        kind = "linear_door",
        hint = "Door4",
    },
    {
        mechanism_id = 900024,
        event_id = 30024,
        source_object_index = 24,
        source_class = "Door",
        source_name = "Door3",
        kind = "linear_door",
        hint = "Door3",
    },
    {
        mechanism_id = 900025,
        event_id = 30025,
        source_object_index = 25,
        source_class = "Door",
        source_name = "Door2",
        kind = "linear_door",
        hint = "Door2",
    },
    {
        mechanism_id = 900026,
        event_id = 30026,
        source_object_index = 26,
        source_class = "Door",
        source_name = "Door1",
        kind = "linear_door",
        hint = "Door1",
    },
    {
        mechanism_id = 900027,
        event_id = 30027,
        source_object_index = 27,
        source_class = "Door",
        source_name = "Door0",
        kind = "linear_door",
        hint = "Door0",
    },
    {
        mechanism_id = 900032,
        event_id = 30032,
        source_object_index = 32,
        source_class = "Door",
        source_name = "Door8",
        kind = "linear_door",
        hint = "Door8",
    },
    {
        mechanism_id = 900033,
        event_id = 30033,
        source_object_index = 33,
        source_class = "Door",
        source_name = "Door9",
        kind = "linear_door",
        hint = "Door9",
    },
    {
        mechanism_id = 900139,
        event_id = 30139,
        source_object_index = 139,
        source_class = "RotatingDoor",
        source_name = "GasRelease0",
        kind = "rotating_door",
        hint = "GasRelease0",
        sounds = {
            ["open_start"] = {
                name = "Door/metaldoorslide01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Door/metaldoorslide01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Door/metaldoorslide01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Door/metaldoorslide01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900140,
        event_id = 30140,
        source_object_index = 140,
        source_class = "Door",
        source_name = "Door6",
        kind = "linear_door",
        hint = "Door6",
    },
    {
        mechanism_id = 900141,
        event_id = 30141,
        source_object_index = 141,
        source_class = "Door",
        source_name = "Door7",
        kind = "linear_door",
        hint = "Door7",
    },
    {
        mechanism_id = 900143,
        event_id = 30143,
        source_object_index = 143,
        source_class = "RotatingDoor",
        source_name = "WaterProp",
        kind = "rotating_door",
        hint = "WaterProp",
        sounds = {
            ["open_busy"] = {
                name = "Ambient/machinery03.wav",
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
        source_class = "Door",
        source_name = "PistonDown0",
        kind = "linear_door",
        hint = "PistonDown0",
    },
    {
        mechanism_id = 900145,
        event_id = 30145,
        source_object_index = 145,
        source_class = "Door",
        source_name = "PistonUp1",
        kind = "linear_door",
        hint = "PistonUp1",
    },
    {
        mechanism_id = 900146,
        event_id = 30146,
        source_object_index = 146,
        source_class = "Door",
        source_name = "PistonUp0",
        kind = "linear_door",
        hint = "PistonUp0",
    },
    {
        mechanism_id = 900147,
        event_id = 30147,
        source_object_index = 147,
        source_class = "Door",
        source_name = "PistonDown1",
        kind = "linear_door",
        hint = "PistonDown1",
    },
    {
        mechanism_id = 900149,
        event_id = 30149,
        source_object_index = 149,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor0",
        kind = "rotating_door",
        hint = "RotatingDoor0",
        sounds = {
            ["open_start"] = {
                name = "Ambient/metalcreak02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Ambient/metalcreak02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900155,
        event_id = 30155,
        source_object_index = 155,
        source_class = "BlueWater",
        source_name = "BlueWater2",
        kind = "water_volume",
        hint = "BlueWater2",
    },
    {
        mechanism_id = 900180,
        event_id = 30180,
        source_object_index = 180,
        source_class = "ScriptObject",
        source_name = "SpawnMgr",
        kind = "script_object",
        hint = "SpawnMgr",
    },
    {
        mechanism_id = 900184,
        event_id = 30184,
        source_object_index = 184,
        source_class = "ScriptObject",
        source_name = "SpawnLoc1",
        kind = "script_object",
        hint = "SpawnLoc1",
    },
    {
        mechanism_id = 900185,
        event_id = 30185,
        source_object_index = 185,
        source_class = "ScriptObject",
        source_name = "SpawnLoc0",
        kind = "script_object",
        hint = "SpawnLoc0",
    },
    {
        mechanism_id = 900224,
        event_id = 30224,
        source_object_index = 224,
        source_class = "DestructableProp",
        source_name = "Urn0",
        kind = "destructible_prop",
        hint = "Urn0",
    },
    {
        mechanism_id = 900225,
        event_id = 30225,
        source_object_index = 225,
        source_class = "DestructableProp",
        source_name = "Urn1",
        kind = "destructible_prop",
        hint = "Urn1",
    },
    {
        mechanism_id = 900226,
        event_id = 30226,
        source_object_index = 226,
        source_class = "DestructableProp",
        source_name = "Urn2",
        kind = "destructible_prop",
        hint = "Urn2",
    },
    {
        mechanism_id = 900227,
        event_id = 30227,
        source_object_index = 227,
        source_class = "DestructableProp",
        source_name = "Urn3",
        kind = "destructible_prop",
        hint = "Urn3",
    },
    {
        mechanism_id = 900228,
        event_id = 30228,
        source_object_index = 228,
        source_class = "DestructableProp",
        source_name = "Urn4",
        kind = "destructible_prop",
        hint = "Urn4",
    },
    {
        mechanism_id = 900229,
        event_id = 30229,
        source_object_index = 229,
        source_class = "DestructableProp",
        source_name = "Urn5",
        kind = "destructible_prop",
        hint = "Urn5",
    },
    {
        mechanism_id = 900230,
        event_id = 30230,
        source_object_index = 230,
        source_class = "DestructableProp",
        source_name = "Urn6",
        kind = "destructible_prop",
        hint = "Urn6",
    },
    {
        mechanism_id = 900231,
        event_id = 30231,
        source_object_index = 231,
        source_class = "DestructableProp",
        source_name = "Urn7",
        kind = "destructible_prop",
        hint = "Urn7",
    },
    {
        mechanism_id = 900232,
        event_id = 30232,
        source_object_index = 232,
        source_class = "DestructableProp",
        source_name = "Urn8",
        kind = "destructible_prop",
        hint = "Urn8",
    },
    {
        mechanism_id = 900233,
        event_id = 30233,
        source_object_index = 233,
        source_class = "DestructableProp",
        source_name = "Urn9",
        kind = "destructible_prop",
        hint = "Urn9",
    },
    {
        mechanism_id = 900234,
        event_id = 30234,
        source_object_index = 234,
        source_class = "DestructableProp",
        source_name = "Urn10",
        kind = "destructible_prop",
        hint = "Urn10",
    },
    {
        mechanism_id = 900235,
        event_id = 30235,
        source_object_index = 235,
        source_class = "DestructableProp",
        source_name = "Urn11",
        kind = "destructible_prop",
        hint = "Urn11",
    },
    {
        mechanism_id = 900236,
        event_id = 30236,
        source_object_index = 236,
        source_class = "DestructableProp",
        source_name = "Urn12",
        kind = "destructible_prop",
        hint = "Urn12",
    },
    {
        mechanism_id = 900237,
        event_id = 30237,
        source_object_index = 237,
        source_class = "DestructableProp",
        source_name = "Urn13",
        kind = "destructible_prop",
        hint = "Urn13",
    },
    {
        mechanism_id = 900238,
        event_id = 30238,
        source_object_index = 238,
        source_class = "DestructableProp",
        source_name = "Urn14",
        kind = "destructible_prop",
        hint = "Urn14",
    },
    {
        mechanism_id = 900239,
        event_id = 30239,
        source_object_index = 239,
        source_class = "DestructableProp",
        source_name = "Urn15",
        kind = "destructible_prop",
        hint = "Urn15",
    },
    {
        mechanism_id = 900240,
        event_id = 30240,
        source_object_index = 240,
        source_class = "DestructableProp",
        source_name = "Urn16",
        kind = "destructible_prop",
        hint = "Urn16",
    },
    {
        mechanism_id = 900241,
        event_id = 30241,
        source_object_index = 241,
        source_class = "DestructableProp",
        source_name = "Urn17",
        kind = "destructible_prop",
        hint = "Urn17",
    },
    {
        mechanism_id = 900242,
        event_id = 30242,
        source_object_index = 242,
        source_class = "DestructableProp",
        source_name = "Urn18",
        kind = "destructible_prop",
        hint = "Urn18",
    },
    {
        mechanism_id = 900243,
        event_id = 30243,
        source_object_index = 243,
        source_class = "DestructableProp",
        source_name = "Urn19",
        kind = "destructible_prop",
        hint = "Urn19",
    },
    {
        mechanism_id = 900244,
        event_id = 30244,
        source_object_index = 244,
        source_class = "DestructableProp",
        source_name = "Urn20",
        kind = "destructible_prop",
        hint = "Urn20",
    },
    {
        mechanism_id = 900263,
        event_id = 30263,
        source_object_index = 263,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
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
    [30004] = { kind = "open_door", source = "mm9_mechanism", targetName = "DragonDoor1" },
    [30022] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door5" },
    [30023] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door4" },
    [30024] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door3" },
    [30025] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door2" },
    [30026] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1" },
    [30027] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door0" },
    [30032] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door8" },
    [30033] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door9" },
    [30139] = { kind = "open_door", source = "mm9_mechanism", targetName = "GasRelease0" },
    [30140] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door6" },
    [30141] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door7" },
    [30143] = { kind = "open_door", source = "mm9_mechanism", targetName = "WaterProp" },
    [30144] = { kind = "open_door", source = "mm9_mechanism", targetName = "PistonDown0" },
    [30145] = { kind = "open_door", source = "mm9_mechanism", targetName = "PistonUp1" },
    [30146] = { kind = "open_door", source = "mm9_mechanism", targetName = "PistonUp0" },
    [30147] = { kind = "open_door", source = "mm9_mechanism", targetName = "PistonDown1" },
    [30149] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30004, "DragonDoor1", function()
    map.triggerMechanism(4, 2)
end, "DragonDoor1")

RegisterEvent(30022, "Door5", function()
    map.triggerMechanism(22, 2)
end, "Door5")

RegisterEvent(30023, "Door4", function()
    map.triggerMechanism(23, 2)
end, "Door4")

RegisterEvent(30024, "Door3", function()
    map.triggerMechanism(24, 2)
end, "Door3")

RegisterEvent(30025, "Door2", function()
    map.triggerMechanism(25, 2)
end, "Door2")

RegisterEvent(30026, "Door1", function()
    map.triggerMechanism(26, 2)
end, "Door1")

RegisterEvent(30027, "Door0", function()
    map.triggerMechanism(27, 2)
end, "Door0")

RegisterEvent(30032, "Door8", function()
    map.triggerMechanism(32, 2)
end, "Door8")

RegisterEvent(30033, "Door9", function()
    map.triggerMechanism(33, 2)
end, "Door9")

RegisterEvent(30139, "GasRelease0", function()
    map.triggerMechanism(139, 2)
end, "GasRelease0")

RegisterEvent(30140, "Door6", function()
    map.triggerMechanism(140, 2)
end, "Door6")

RegisterEvent(30141, "Door7", function()
    map.triggerMechanism(141, 2)
end, "Door7")

RegisterEvent(30143, "WaterProp", function()
    map.triggerMechanism(143, 2)
end, "WaterProp")

RegisterEvent(30144, "PistonDown0", function()
    map.triggerMechanism(144, 2)
end, "PistonDown0")

RegisterEvent(30145, "PistonUp1", function()
    map.triggerMechanism(145, 2)
end, "PistonUp1")

RegisterEvent(30146, "PistonUp0", function()
    map.triggerMechanism(146, 2)
end, "PistonUp0")

RegisterEvent(30147, "PistonDown1", function()
    map.triggerMechanism(147, 2)
end, "PistonDown1")

RegisterEvent(30149, "RotatingDoor0", function()
    map.triggerMechanism(149, 2)
end, "RotatingDoor0")

map.scripts["bathfurnace.scr"] = {
    source = "BATHFURNACE.scr",
    registered_triggers = {
        { line = 112, message = "turnon", callback = "turnon" },
        { line = 113, message = "turnoff", callback = "turnoff" },
        { line = 114, message = "repeat0", callback = "repeat0" },
        { line = 115, message = "repeat1", callback = "repeat1" },
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
map.scripts["dp2steam.scr"] = {
    source = "DP2STEAM.scr",
    registered_triggers = {
        { line = 36, message = "FireOn", callback = "FireOn" },
        { line = 37, message = "FireOff", callback = "FireOff" },
    },
    movement_commands = {
    },
}
map.scripts["dp2waterdamage.scr"] = {
    source = "DP2WATERDAMAGE.scr",
    registered_triggers = {
        { line = 38, message = "DamageOn", callback = "DamageOn" },
        { line = 39, message = "DamageOff", callback = "DamageOff" },
    },
    movement_commands = {
    },
}
map.scripts["drainwater.scr"] = {
    source = "DRAINWATER.scr",
    registered_triggers = {
        { line = 50, message = "drain", callback = "DrainWater" },
        { line = 51, message = "fill", callback = "FillWater" },
        { line = 66, message = "drain", callback = "DrainWater" },
        { line = 78, message = "fill", callback = "FillWater" },
    },
    movement_commands = {
        { line = 70, command = "MoveToPOS", arguments = "xMe,yMe,zMe, 10, OnFillWater" },
        { line = 82, command = "MoveToPOS", arguments = "xMe,yMe,zMe, 10, OnDrainWater" },
    },
}
map.scripts["eborabath.scr"] = {
    source = "EBORABATH.scr",
    registered_triggers = {
        { line = 209, message = "OnGossip", callback = "OnGossip" },
        { line = 210, message = "DeadConcubine", callback = "DeadConcubine" },
        { line = 211, message = "DeadPal", callback = "DeadPal" },
    },
    movement_commands = {
    },
}
map.scripts["eboracam1.scr"] = {
    source = "EBORACAM1.scr",
    registered_triggers = {
        { line = 25, message = "on", callback = "CameraOn" },
    },
    movement_commands = {
    },
}
map.scripts["eboraconcubine.scr"] = {
    source = "EBORACONCUBINE.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["effectsmgr.scr"] = {
    source = "EFFECTSMGR.scr",
    registered_triggers = {
        { line = 55, message = "StartScene", callback = "DoScene" },
        { line = 133, message = "QuakeOn", callback = "TurnQuakeOn" },
        { line = 134, message = "QuakeOff", callback = "TurnQuakeOff" },
        { line = 135, message = "TextOn", callback = "TurnTextOn" },
        { line = 136, message = "TextOff", callback = "TurnTextOff" },
        { line = 137, message = "BoxOn", callback = "TurnBoxOn" },
        { line = 138, message = "BoxOff", callback = "TurnBoxOff" },
        { line = 140, message = "DurationLong", callback = "SetDurationLong" },
        { line = 141, message = "DurationShort", callback = "SetDurationShort" },
        { line = 142, message = "DurationInstant", callback = "SetDurationInstant" },
        { line = 144, message = "QuakeStrong", callback = "SetQuakeHigh" },
        { line = 145, message = "QuakeWeak", callback = "SetQuakeMed" },
    },
    movement_commands = {
        { line = 126, command = "SetPOS", arguments = "hMe, x,y,z" },
    },
}
map.scripts["fatc.scr"] = {
    source = "FATC.scr",
    registered_triggers = {
        { line = 60, message = "Die", callback = "OnDie" },
        { line = 61, message = "MoveIt", callback = "OnMoveIt" },
        { line = 62, message = "EboraArrive", callback = "OnEboraArrive" },
    },
    movement_commands = {
        { line = 20, command = "MoveToPos", arguments = "1808, 44, g_posZ, g_velX, Arrived" },
    },
}
map.scripts["furnacewarning.scr"] = {
    source = "FURNACEWARNING.scr",
    registered_triggers = {
        { line = 32, message = "use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["imphenchman.scr"] = {
    source = "IMPHENCHMAN.scr",
    registered_triggers = {
        { line = 21, message = "Help", callback = "DefendImp" },
    },
    movement_commands = {
    },
}
map.scripts["spawnloc.scr"] = {
    source = "SPAWNLOC.scr",
    registered_triggers = {
        { line = 30, message = "On", callback = "TurnOn" },
        { line = 61, message = "spawn", callback = "RequestSpawn" },
        { line = 62, message = "focus", callback = "RequestFocus" },
        { line = 63, message = "off", callback = "TurnOff" },
    },
    movement_commands = {
    },
}
map.scripts["spawnmgr.scr"] = {
    source = "SPAWNMGR.scr",
    registered_triggers = {
        { line = 73, message = "SetLocation", callback = "SetLocation" },
        { line = 74, message = "Respawn", callback = "OnCreatureDied" },
        { line = 75, message = "ForceSpawn", callback = "SpawnCreature" },
        { line = 76, message = "Off", callback = "TurnOff" },
        { line = 77, message = "On", callback = "TurnOn" },
        { line = 153, message = "Respawn", callback = "OnCreatureDied" },
        { line = 164, message = "Respawn", callback = "AdjustTotals" },
    },
    movement_commands = {
    },
}
map.scripts["steamvent.scr"] = {
    source = "STEAMVENT.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["steamventdb.scr"] = {
    source = "STEAMVENTDB.scr",
    registered_triggers = {
        { line = 66, message = "turnon", callback = "turnon" },
        { line = 67, message = "turnoff", callback = "turnoff" },
    },
    movement_commands = {
        { line = 37, command = "movetopos", arguments = "ax ay az 1000 dn" },
        { line = 45, command = "movetopos", arguments = "bx by bz 1000 dn" },
    },
}

function map.register(ctx)
    if ctx == nil or ctx.registerMm9MapEvents == nil then
        return
    end
    ctx:registerMm9MapEvents(map)
end

return map
