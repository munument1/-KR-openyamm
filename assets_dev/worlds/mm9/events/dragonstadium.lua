-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "dragonstadium"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 0,
        source_name = "StartPoint0",
        x = 1802,
        y = -5734,
        z = 82,
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
        mechanism_id = 900001,
        event_id = 30001,
        source_object_index = 1,
        source_class = "DestructableBrush",
        source_name = "p1 level 1",
        kind = "destructible_brush",
        hint = "p1 level 1",
    },
    {
        mechanism_id = 900002,
        event_id = 30002,
        source_object_index = 2,
        source_class = "DestructableBrush",
        source_name = "p1 level 2",
        kind = "destructible_brush",
        hint = "p1 level 2",
    },
    {
        mechanism_id = 900003,
        event_id = 30003,
        source_object_index = 3,
        source_class = "DestructableBrush",
        source_name = "p1 level 3",
        kind = "destructible_brush",
        hint = "p1 level 3",
    },
    {
        mechanism_id = 900004,
        event_id = 30004,
        source_object_index = 4,
        source_class = "DestructableBrush",
        source_name = "p1 level 4",
        kind = "destructible_brush",
        hint = "p1 level 4",
    },
    {
        mechanism_id = 900005,
        event_id = 30005,
        source_object_index = 5,
        source_class = "DestructableBrush",
        source_name = "p1 level 5",
        kind = "destructible_brush",
        hint = "p1 level 5",
    },
    {
        mechanism_id = 900006,
        event_id = 30006,
        source_object_index = 6,
        source_class = "DestructableBrush",
        source_name = "p1 level 6",
        kind = "destructible_brush",
        hint = "p1 level 6",
    },
    {
        mechanism_id = 900007,
        event_id = 30007,
        source_object_index = 7,
        source_class = "DestructableBrush",
        source_name = "p1 level 7",
        kind = "destructible_brush",
        hint = "p1 level 7",
    },
    {
        mechanism_id = 900008,
        event_id = 30008,
        source_object_index = 8,
        source_class = "DestructableBrush",
        source_name = "p2 level 1",
        kind = "destructible_brush",
        hint = "p2 level 1",
    },
    {
        mechanism_id = 900009,
        event_id = 30009,
        source_object_index = 9,
        source_class = "DestructableBrush",
        source_name = "p2 level 2",
        kind = "destructible_brush",
        hint = "p2 level 2",
    },
    {
        mechanism_id = 900010,
        event_id = 30010,
        source_object_index = 10,
        source_class = "DestructableBrush",
        source_name = "p2 level 3",
        kind = "destructible_brush",
        hint = "p2 level 3",
    },
    {
        mechanism_id = 900011,
        event_id = 30011,
        source_object_index = 11,
        source_class = "DestructableBrush",
        source_name = "p2 level 4",
        kind = "destructible_brush",
        hint = "p2 level 4",
    },
    {
        mechanism_id = 900012,
        event_id = 30012,
        source_object_index = 12,
        source_class = "DestructableBrush",
        source_name = "p2 level 5",
        kind = "destructible_brush",
        hint = "p2 level 5",
    },
    {
        mechanism_id = 900013,
        event_id = 30013,
        source_object_index = 13,
        source_class = "DestructableBrush",
        source_name = "p2 level 6",
        kind = "destructible_brush",
        hint = "p2 level 6",
    },
    {
        mechanism_id = 900014,
        event_id = 30014,
        source_object_index = 14,
        source_class = "DestructableBrush",
        source_name = "p2 level 7",
        kind = "destructible_brush",
        hint = "p2 level 7",
    },
    {
        mechanism_id = 900015,
        event_id = 30015,
        source_object_index = 15,
        source_class = "DestructableBrush",
        source_name = "p3 level 1",
        kind = "destructible_brush",
        hint = "p3 level 1",
    },
    {
        mechanism_id = 900016,
        event_id = 30016,
        source_object_index = 16,
        source_class = "DestructableBrush",
        source_name = "p3 level 2",
        kind = "destructible_brush",
        hint = "p3 level 2",
    },
    {
        mechanism_id = 900017,
        event_id = 30017,
        source_object_index = 17,
        source_class = "DestructableBrush",
        source_name = "p3 level 3",
        kind = "destructible_brush",
        hint = "p3 level 3",
    },
    {
        mechanism_id = 900018,
        event_id = 30018,
        source_object_index = 18,
        source_class = "DestructableBrush",
        source_name = "p3 level 4",
        kind = "destructible_brush",
        hint = "p3 level 4",
    },
    {
        mechanism_id = 900019,
        event_id = 30019,
        source_object_index = 19,
        source_class = "DestructableBrush",
        source_name = "p3 level 6",
        kind = "destructible_brush",
        hint = "p3 level 6",
    },
    {
        mechanism_id = 900020,
        event_id = 30020,
        source_object_index = 20,
        source_class = "DestructableBrush",
        source_name = "p3 level 5",
        kind = "destructible_brush",
        hint = "p3 level 5",
    },
    {
        mechanism_id = 900021,
        event_id = 30021,
        source_object_index = 21,
        source_class = "DestructableBrush",
        source_name = "p3 level 7",
        kind = "destructible_brush",
        hint = "p3 level 7",
    },
    {
        mechanism_id = 900032,
        event_id = 30032,
        source_object_index = 32,
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
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})


function map.register(ctx)
    if ctx == nil or ctx.registerMm9MapEvents == nil then
        return
    end
    ctx:registerMm9MapEvents(map)
end

return map
