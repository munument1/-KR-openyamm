-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "bootcamp"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 208,
        source_name = "StartPoint1",
        x = 25969,
        y = -6717,
        z = 1413,
        direction_yaw_units = 1021,
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
        source_class = "RotatingDoor",
        source_name = "MonsterDoor1",
        kind = "rotating_door",
        hint = "MonsterDoor1",
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
        mechanism_id = 900006,
        event_id = 30006,
        source_object_index = 6,
        source_class = "RotatingDoor",
        source_name = "MonsterDoor2",
        kind = "rotating_door",
        hint = "MonsterDoor2",
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
        mechanism_id = 900007,
        event_id = 30007,
        source_object_index = 7,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900050,
        event_id = 30050,
        source_object_index = 50,
        source_class = "RotatingDoor",
        source_name = "barflap1",
        kind = "rotating_door",
        hint = "barflap1",
    },
    {
        mechanism_id = 900051,
        event_id = 30051,
        source_object_index = 51,
        source_class = "RotatingDoor",
        source_name = "barflap2",
        kind = "rotating_door",
        hint = "barflap2",
    },
    {
        mechanism_id = 900052,
        event_id = 30052,
        source_object_index = 52,
        source_class = "Ladder",
        source_name = "Ladder5",
        kind = "ladder_volume",
        hint = "Ladder5",
    },
    {
        mechanism_id = 900054,
        event_id = 30054,
        source_object_index = 54,
        source_class = "Ladder",
        source_name = "Ladder4",
        kind = "ladder_volume",
        hint = "Ladder4",
    },
    {
        mechanism_id = 900056,
        event_id = 30056,
        source_object_index = 56,
        source_class = "Ladder",
        source_name = "Ladder3",
        kind = "ladder_volume",
        hint = "Ladder3",
    },
    {
        mechanism_id = 900063,
        event_id = 30063,
        source_object_index = 63,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 900064,
        event_id = 30064,
        source_object_index = 64,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900065,
        event_id = 30065,
        source_object_index = 65,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900066,
        event_id = 30066,
        source_object_index = 66,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor0",
        kind = "rotating_door",
        hint = "RotatingDoor0",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900067,
        event_id = 30067,
        source_object_index = 67,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor1",
        kind = "rotating_door",
        hint = "RotatingDoor1",
        sounds = {
            ["open_start"] = {
                name = "Door/door03open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/door03close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900167,
        event_id = 30167,
        source_object_index = 167,
        source_class = "RotatingDoor",
        source_name = "NewHouseDoor1",
        kind = "rotating_door",
        hint = "NewHouseDoor1",
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
        mechanism_id = 900168,
        event_id = 30168,
        source_object_index = 168,
        source_class = "RotatingDoor",
        source_name = "NewHouseDoor0",
        kind = "rotating_door",
        hint = "NewHouseDoor0",
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
        mechanism_id = 900178,
        event_id = 30178,
        source_object_index = 178,
        source_class = "RotatingDoor",
        source_name = "TrainingDoor1",
        kind = "rotating_door",
        hint = "TrainingDoor1",
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
        mechanism_id = 900179,
        event_id = 30179,
        source_object_index = 179,
        source_class = "RotatingDoor",
        source_name = "TrainingDoor0",
        kind = "rotating_door",
        hint = "TrainingDoor0",
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
        mechanism_id = 900180,
        event_id = 30180,
        source_object_index = 180,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor2",
        kind = "rotating_door",
        hint = "RotatingDoor2",
    },
    {
        mechanism_id = 900234,
        event_id = 30234,
        source_object_index = 234,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900235,
        event_id = 30235,
        source_object_index = 235,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 900236,
        event_id = 30236,
        source_object_index = 236,
        source_class = "AIBarrier",
        source_name = "AIBarrier2",
        kind = "ai_barrier",
        hint = "AIBarrier2",
    },
    {
        mechanism_id = 900306,
        event_id = 30306,
        source_object_index = 306,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900307,
        event_id = 30307,
        source_object_index = 307,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900308,
        event_id = 30308,
        source_object_index = 308,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900309,
        event_id = 30309,
        source_object_index = 309,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 900310,
        event_id = 30310,
        source_object_index = 310,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 900311,
        event_id = 30311,
        source_object_index = 311,
        source_class = "BlueWater",
        source_name = "BlueWater1",
        kind = "water_volume",
        hint = "BlueWater1",
    },
    {
        mechanism_id = 900312,
        event_id = 30312,
        source_object_index = 312,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 900543,
        event_id = 30543,
        source_object_index = 543,
        source_class = "ScriptObject",
        source_name = "BC_Manager",
        kind = "script_object",
        hint = "BC_Manager",
    },
    {
        mechanism_id = 900563,
        event_id = 30563,
        source_object_index = 563,
        source_class = "Door",
        source_name = "Switch0",
        kind = "linear_door",
        hint = "Switch0",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        },
    },
    {
        mechanism_id = 900564,
        event_id = 30564,
        source_object_index = 564,
        source_class = "Door",
        source_name = "Switch1",
        kind = "linear_door",
        hint = "Switch1",
        sounds = {
            ["open_busy"] = {
                name = "Door/DoorSlideStone.wav",
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
        },
    },
    {
        mechanism_id = 900565,
        event_id = 30565,
        source_object_index = 565,
        source_class = "Door",
        source_name = "Door0",
        kind = "linear_door",
        hint = "Door0",
    },
    {
        mechanism_id = 900566,
        event_id = 30566,
        source_object_index = 566,
        source_class = "Door",
        source_name = "Door1",
        kind = "linear_door",
        hint = "Door1",
    },
    {
        mechanism_id = 900567,
        event_id = 30567,
        source_object_index = 567,
        source_class = "Door",
        source_name = "Door2",
        kind = "linear_door",
        hint = "Door2",
    },
    {
        mechanism_id = 900568,
        event_id = 30568,
        source_object_index = 568,
        source_class = "Door",
        source_name = "Door3",
        kind = "linear_door",
        hint = "Door3",
    },
    {
        mechanism_id = 900569,
        event_id = 30569,
        source_object_index = 569,
        source_class = "RotatingDoor",
        source_name = "MuseumDoor2",
        kind = "rotating_door",
        hint = "MuseumDoor2",
    },
    {
        mechanism_id = 900570,
        event_id = 30570,
        source_object_index = 570,
        source_class = "RotatingDoor",
        source_name = "MuseumDoor3",
        kind = "rotating_door",
        hint = "MuseumDoor3",
    },
    {
        mechanism_id = 900571,
        event_id = 30571,
        source_object_index = 571,
        source_class = "RotatingDoor",
        source_name = "MuseumDoor0",
        kind = "rotating_door",
        hint = "MuseumDoor0",
    },
    {
        mechanism_id = 900572,
        event_id = 30572,
        source_object_index = 572,
        source_class = "RotatingDoor",
        source_name = "MuseumDoor1",
        kind = "rotating_door",
        hint = "MuseumDoor1",
    },
    {
        mechanism_id = 900580,
        event_id = 30580,
        source_object_index = 580,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 900581,
        event_id = 30581,
        source_object_index = 581,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 900586,
        event_id = 30586,
        source_object_index = 586,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 900587,
        event_id = 30587,
        source_object_index = 587,
        source_class = "RotatingDoor",
        source_name = "StoreDoorLeft",
        kind = "rotating_door",
        hint = "StoreDoorLeft",
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
        mechanism_id = 900589,
        event_id = 30589,
        source_object_index = 589,
        source_class = "RotatingDoor",
        source_name = "StoreDoorRight",
        kind = "rotating_door",
        hint = "StoreDoorRight",
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
    [30005] = { kind = "open_door", source = "mm9_mechanism", targetName = "MonsterDoor1" },
    [30006] = { kind = "open_door", source = "mm9_mechanism", targetName = "MonsterDoor2" },
    [30050] = { kind = "open_door", source = "mm9_mechanism", targetName = "barflap1" },
    [30051] = { kind = "open_door", source = "mm9_mechanism", targetName = "barflap2" },
    [30066] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0" },
    [30067] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor1" },
    [30167] = { kind = "open_door", source = "mm9_mechanism", targetName = "NewHouseDoor1" },
    [30168] = { kind = "open_door", source = "mm9_mechanism", targetName = "NewHouseDoor0" },
    [30178] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrainingDoor1" },
    [30179] = { kind = "open_door", source = "mm9_mechanism", targetName = "TrainingDoor0" },
    [30180] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor2" },
    [30563] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch0" },
    [30564] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch1" },
    [30565] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door0" },
    [30566] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1" },
    [30567] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door2" },
    [30568] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door3" },
    [30569] = { kind = "open_door", source = "mm9_mechanism", targetName = "MuseumDoor2" },
    [30570] = { kind = "open_door", source = "mm9_mechanism", targetName = "MuseumDoor3" },
    [30571] = { kind = "open_door", source = "mm9_mechanism", targetName = "MuseumDoor0" },
    [30572] = { kind = "open_door", source = "mm9_mechanism", targetName = "MuseumDoor1" },
    [30587] = { kind = "open_door", source = "mm9_mechanism", targetName = "StoreDoorLeft" },
    [30589] = { kind = "open_door", source = "mm9_mechanism", targetName = "StoreDoorRight" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30005, "MonsterDoor1", function()
    map.triggerMechanism(5, 2)
end, "MonsterDoor1")

RegisterEvent(30006, "MonsterDoor2", function()
    map.triggerMechanism(6, 2)
end, "MonsterDoor2")

RegisterEvent(30050, "barflap1", function()
    map.triggerMechanism(50, 2)
end, "barflap1")

RegisterEvent(30051, "barflap2", function()
    map.triggerMechanism(51, 2)
end, "barflap2")

RegisterEvent(30066, "RotatingDoor0", function()
    map.triggerMechanism(66, 2)
end, "RotatingDoor0")

RegisterEvent(30067, "RotatingDoor1", function()
    map.triggerMechanism(67, 2)
end, "RotatingDoor1")

RegisterEvent(30167, "NewHouseDoor1", function()
    map.triggerMechanism(167, 2)
end, "NewHouseDoor1")

RegisterEvent(30168, "NewHouseDoor0", function()
    map.triggerMechanism(168, 2)
end, "NewHouseDoor0")

RegisterEvent(30178, "TrainingDoor1", function()
    map.triggerMechanism(178, 2)
end, "TrainingDoor1")

RegisterEvent(30179, "TrainingDoor0", function()
    map.triggerMechanism(179, 2)
end, "TrainingDoor0")

RegisterEvent(30180, "RotatingDoor2", function()
    map.triggerMechanism(180, 2)
end, "RotatingDoor2")

RegisterEvent(30563, "Switch0", function()
    map.triggerMechanism(563, 2)
end, "Switch0")

RegisterEvent(30564, "Switch1", function()
    map.triggerMechanism(564, 2)
end, "Switch1")

RegisterEvent(30565, "Door0", function()
    map.triggerMechanism(565, 2)
end, "Door0")

RegisterEvent(30566, "Door1", function()
    map.triggerMechanism(566, 2)
end, "Door1")

RegisterEvent(30567, "Door2", function()
    map.triggerMechanism(567, 2)
end, "Door2")

RegisterEvent(30568, "Door3", function()
    map.triggerMechanism(568, 2)
end, "Door3")

RegisterEvent(30569, "MuseumDoor2", function()
    map.triggerMechanism(569, 2)
end, "MuseumDoor2")

RegisterEvent(30570, "MuseumDoor3", function()
    map.triggerMechanism(570, 2)
end, "MuseumDoor3")

RegisterEvent(30571, "MuseumDoor0", function()
    map.triggerMechanism(571, 2)
end, "MuseumDoor0")

RegisterEvent(30572, "MuseumDoor1", function()
    map.triggerMechanism(572, 2)
end, "MuseumDoor1")

RegisterEvent(30587, "StoreDoorLeft", function()
    map.triggerMechanism(587, 2)
end, "StoreDoorLeft")

RegisterEvent(30589, "StoreDoorRight", function()
    map.triggerMechanism(589, 2)
end, "StoreDoorRight")

map.scripts["bc_manager.scr"] = {
    source = "BC_MANAGER.scr",
    registered_triggers = {
        { line = 63, message = "fight", callback = "StartFight" },
        { line = 64, message = "open", callback = "StartOpen" },
        { line = 132, message = "open", callback = "StartOpen" },
        { line = 152, message = "fight", callback = "StartFight" },
        { line = 169, message = "fight", callback = "StartFight" },
    },
    movement_commands = {
    },
}
map.scripts["bc_treasurechest.scr"] = {
    source = "BC_TREASURECHEST.scr",
    registered_triggers = {
        { line = 19, message = "open", callback = "PlayOpenAnim" },
    },
    movement_commands = {
    },
}
map.scripts["bootgive.scr"] = {
    source = "BOOTGIVE.scr",
    registered_triggers = {
        { line = 70, message = "Use", callback = "OnUse" },
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
map.scripts["npc436.scr"] = {
    source = "NPC436.scr",
    registered_triggers = {
        { line = 85, message = "Leave", callback = "OnLeave" },
        { line = 86, message = "Use", callback = "OnUse" },
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
