-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "thjorgard"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 115,
        source_name = "FTThjorgardStart",
        x = -16540,
        y = -19960,
        z = 3502,
        direction_yaw_units = 511,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 123,
        source_name = "MountainPassExit",
        x = -1800,
        y = -13821,
        z = 3579,
        direction_yaw_units = 0,
        move_player_to_floor = true,
    },
    {
        start_index = 2,
        source_object_index = 127,
        source_name = "StartPoint0",
        x = -15375,
        y = 16727,
        z = 1498,
        direction_yaw_units = 1024,
        move_player_to_floor = true,
    },
    {
        start_index = 3,
        source_object_index = 128,
        source_name = "ThjoradMineExit",
        x = -20603,
        y = 12452,
        z = 4608,
        direction_yaw_units = 796,
        move_player_to_floor = true,
    },
    {
        start_index = 4,
        source_object_index = 129,
        source_name = "ThjorgardCityDockExit",
        x = -13046,
        y = 4413,
        z = 1951,
        direction_yaw_units = 512,
        move_player_to_floor = true,
    },
    {
        start_index = 5,
        source_object_index = 130,
        source_name = "ThjorgardCityTerrainExit",
        x = -4506,
        y = 10127,
        z = 1951,
        direction_yaw_units = 1650,
        move_player_to_floor = true,
    },
    {
        start_index = 6,
        source_object_index = 131,
        source_name = "TrainingHallDoorExit",
        x = -8868,
        y = -16036,
        z = 3359,
        direction_yaw_units = 0,
        move_player_to_floor = true,
    },
    {
        start_index = 7,
        source_object_index = 487,
        source_name = "TrainingHallExit",
        x = -9400,
        y = -18432,
        z = 4239,
        direction_yaw_units = 511,
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
        mechanism_id = 900050,
        event_id = 30050,
        source_object_index = 50,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900051,
        event_id = 30051,
        source_object_index = 51,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900052,
        event_id = 30052,
        source_object_index = 52,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 900053,
        event_id = 30053,
        source_object_index = 53,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900054,
        event_id = 30054,
        source_object_index = 54,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 900055,
        event_id = 30055,
        source_object_index = 55,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 900056,
        event_id = 30056,
        source_object_index = 56,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 900057,
        event_id = 30057,
        source_object_index = 57,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush7",
        kind = "perception_brush",
        hint = "PerceptionBrush7",
    },
    {
        mechanism_id = 900058,
        event_id = 30058,
        source_object_index = 58,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush8",
        kind = "perception_brush",
        hint = "PerceptionBrush8",
    },
    {
        mechanism_id = 900059,
        event_id = 30059,
        source_object_index = 59,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush9",
        kind = "perception_brush",
        hint = "PerceptionBrush9",
    },
    {
        mechanism_id = 900060,
        event_id = 30060,
        source_object_index = 60,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush10",
        kind = "perception_brush",
        hint = "PerceptionBrush10",
    },
    {
        mechanism_id = 900061,
        event_id = 30061,
        source_object_index = 61,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush11",
        kind = "perception_brush",
        hint = "PerceptionBrush11",
    },
    {
        mechanism_id = 900105,
        event_id = 30105,
        source_object_index = 105,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 900106,
        event_id = 30106,
        source_object_index = 106,
        source_class = "BlueWater",
        source_name = "BlueWater1",
        kind = "water_volume",
        hint = "BlueWater1",
    },
    {
        mechanism_id = 900107,
        event_id = 30107,
        source_object_index = 107,
        source_class = "BlueWater",
        source_name = "BlueWater3",
        kind = "water_volume",
        hint = "BlueWater3",
    },
    {
        mechanism_id = 900118,
        event_id = 30118,
        source_object_index = 118,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900119,
        event_id = 30119,
        source_object_index = 119,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900120,
        event_id = 30120,
        source_object_index = 120,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 900125,
        event_id = 30125,
        source_object_index = 125,
        source_class = "ScriptObject",
        source_name = "ScriptObject0",
        kind = "script_object",
        hint = "ScriptObject0",
    },
    {
        mechanism_id = 900165,
        event_id = 30165,
        source_object_index = 165,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900166,
        event_id = 30166,
        source_object_index = 166,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 900167,
        event_id = 30167,
        source_object_index = 167,
        source_class = "AIBarrier",
        source_name = "AIBarrier5",
        kind = "ai_barrier",
        hint = "AIBarrier5",
    },
    {
        mechanism_id = 900168,
        event_id = 30168,
        source_object_index = 168,
        source_class = "AIBarrier",
        source_name = "AIBarrier6",
        kind = "ai_barrier",
        hint = "AIBarrier6",
    },
    {
        mechanism_id = 900170,
        event_id = 30170,
        source_object_index = 170,
        source_class = "AIBarrier",
        source_name = "AIBarrier2",
        kind = "ai_barrier",
        hint = "AIBarrier2",
    },
    {
        mechanism_id = 900171,
        event_id = 30171,
        source_object_index = 171,
        source_class = "AIBarrier",
        source_name = "AIBarrier3",
        kind = "ai_barrier",
        hint = "AIBarrier3",
    },
    {
        mechanism_id = 900172,
        event_id = 30172,
        source_object_index = 172,
        source_class = "AIBarrier",
        source_name = "AIBarrier4",
        kind = "ai_barrier",
        hint = "AIBarrier4",
    },
    {
        mechanism_id = 900173,
        event_id = 30173,
        source_object_index = 173,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 900180,
        event_id = 30180,
        source_object_index = 180,
        source_class = "AIBarrier",
        source_name = "AIBarrier7",
        kind = "ai_barrier",
        hint = "AIBarrier7",
    },
    {
        mechanism_id = 900181,
        event_id = 30181,
        source_object_index = 181,
        source_class = "AIBarrier",
        source_name = "AIBarrier8",
        kind = "ai_barrier",
        hint = "AIBarrier8",
    },
    {
        mechanism_id = 900239,
        event_id = 30239,
        source_object_index = 239,
        source_class = "AIBarrier",
        source_name = "AIBarrier9",
        kind = "ai_barrier",
        hint = "AIBarrier9",
    },
    {
        mechanism_id = 900240,
        event_id = 30240,
        source_object_index = 240,
        source_class = "AIBarrier",
        source_name = "AIBarrier10",
        kind = "ai_barrier",
        hint = "AIBarrier10",
    },
    {
        mechanism_id = 900241,
        event_id = 30241,
        source_object_index = 241,
        source_class = "AIBarrier",
        source_name = "AIBarrier11",
        kind = "ai_barrier",
        hint = "AIBarrier11",
    },
    {
        mechanism_id = 900242,
        event_id = 30242,
        source_object_index = 242,
        source_class = "AIBarrier",
        source_name = "AIBarrier12",
        kind = "ai_barrier",
        hint = "AIBarrier12",
    },
    {
        mechanism_id = 900243,
        event_id = 30243,
        source_object_index = 243,
        source_class = "AIBarrier",
        source_name = "AIBarrier14",
        kind = "ai_barrier",
        hint = "AIBarrier14",
    },
    {
        mechanism_id = 900244,
        event_id = 30244,
        source_object_index = 244,
        source_class = "AIBarrier",
        source_name = "AIBarrier15",
        kind = "ai_barrier",
        hint = "AIBarrier15",
    },
    {
        mechanism_id = 900245,
        event_id = 30245,
        source_object_index = 245,
        source_class = "AIBarrier",
        source_name = "AIBarrier16",
        kind = "ai_barrier",
        hint = "AIBarrier16",
    },
    {
        mechanism_id = 900246,
        event_id = 30246,
        source_object_index = 246,
        source_class = "AIBarrier",
        source_name = "AIBarrier17",
        kind = "ai_barrier",
        hint = "AIBarrier17",
    },
    {
        mechanism_id = 900247,
        event_id = 30247,
        source_object_index = 247,
        source_class = "AIBarrier",
        source_name = "AIBarrier18",
        kind = "ai_barrier",
        hint = "AIBarrier18",
    },
    {
        mechanism_id = 900248,
        event_id = 30248,
        source_object_index = 248,
        source_class = "AIBarrier",
        source_name = "AIBarrier19",
        kind = "ai_barrier",
        hint = "AIBarrier19",
    },
    {
        mechanism_id = 900249,
        event_id = 30249,
        source_object_index = 249,
        source_class = "AIBarrier",
        source_name = "AIBarrier20",
        kind = "ai_barrier",
        hint = "AIBarrier20",
    },
    {
        mechanism_id = 900340,
        event_id = 30340,
        source_object_index = 340,
        source_class = "AIBarrier",
        source_name = "AIBarrier13",
        kind = "ai_barrier",
        hint = "AIBarrier13",
    },
    {
        mechanism_id = 900386,
        event_id = 30386,
        source_object_index = 386,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 900391,
        event_id = 30391,
        source_object_index = 391,
        source_class = "RotatingDoor",
        source_name = "mine cart door left",
        kind = "rotating_door",
        hint = "mine cart door left",
    },
    {
        mechanism_id = 900392,
        event_id = 30392,
        source_object_index = 392,
        source_class = "RotatingDoor",
        source_name = "mine cart door right",
        kind = "rotating_door",
        hint = "mine cart door right",
    },
    {
        mechanism_id = 900399,
        event_id = 30399,
        source_object_index = 399,
        source_class = "RotatingDoor",
        source_name = "cottage door",
        kind = "rotating_door",
        hint = "cottage door",
        sounds = {
            ["open_start"] = {
                name = "Door/door02open.wav",
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
                name = "Door/door02close.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900478,
        event_id = 30478,
        source_object_index = 478,
        source_class = "BlueWater",
        source_name = "BlueWater2",
        kind = "water_volume",
        hint = "BlueWater2",
    },
    {
        mechanism_id = 900479,
        event_id = 30479,
        source_object_index = 479,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush7",
        kind = "destructible_brush",
        hint = "DestructableBrush7",
    },
    {
        mechanism_id = 900480,
        event_id = 30480,
        source_object_index = 480,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush8",
        kind = "destructible_brush",
        hint = "DestructableBrush8",
    },
    {
        mechanism_id = 900481,
        event_id = 30481,
        source_object_index = 481,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush9",
        kind = "destructible_brush",
        hint = "DestructableBrush9",
    },
    {
        mechanism_id = 900482,
        event_id = 30482,
        source_object_index = 482,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush10",
        kind = "destructible_brush",
        hint = "DestructableBrush10",
    },
    {
        mechanism_id = 900483,
        event_id = 30483,
        source_object_index = 483,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush11",
        kind = "destructible_brush",
        hint = "DestructableBrush11",
    },
    {
        mechanism_id = 900484,
        event_id = 30484,
        source_object_index = 484,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush12",
        kind = "destructible_brush",
        hint = "DestructableBrush12",
    },
    {
        mechanism_id = 900485,
        event_id = 30485,
        source_object_index = 485,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush13",
        kind = "destructible_brush",
        hint = "DestructableBrush13",
    },
    {
        mechanism_id = 900488,
        event_id = 30488,
        source_object_index = 488,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900551,
        event_id = 30551,
        source_object_index = 551,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush10",
        kind = "collision_volume",
        hint = "InvisibleBrush10",
    },
    {
        mechanism_id = 900552,
        event_id = 30552,
        source_object_index = 552,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush6",
        kind = "collision_volume",
        hint = "InvisibleBrush6",
    },
    {
        mechanism_id = 900553,
        event_id = 30553,
        source_object_index = 553,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush7",
        kind = "collision_volume",
        hint = "InvisibleBrush7",
    },
    {
        mechanism_id = 900554,
        event_id = 30554,
        source_object_index = 554,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush8",
        kind = "collision_volume",
        hint = "InvisibleBrush8",
    },
    {
        mechanism_id = 900555,
        event_id = 30555,
        source_object_index = 555,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush9",
        kind = "collision_volume",
        hint = "InvisibleBrush9",
    },
    {
        mechanism_id = 900592,
        event_id = 30592,
        source_object_index = 592,
        source_class = "ScriptObject",
        source_name = "TronMgr",
        kind = "script_object",
        hint = "TronMgr",
    },
    {
        mechanism_id = 900632,
        event_id = 30632,
        source_object_index = 632,
        source_class = "Door",
        source_name = "Switch",
        kind = "linear_door",
        hint = "Switch",
    },
    {
        mechanism_id = 900646,
        event_id = 30646,
        source_object_index = 646,
        source_class = "ScriptObject",
        source_name = "Mastermind",
        kind = "script_object",
        hint = "Mastermind",
    },
    {
        mechanism_id = 900670,
        event_id = 30670,
        source_object_index = 670,
        source_class = "Door",
        source_name = "Strikeplate1",
        kind = "linear_door",
        hint = "Strikeplate1",
    },
    {
        mechanism_id = 900671,
        event_id = 30671,
        source_object_index = 671,
        source_class = "Door",
        source_name = "Riser1",
        kind = "linear_door",
        hint = "Riser1",
    },
    {
        mechanism_id = 900702,
        event_id = 30702,
        source_object_index = 702,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush11",
        kind = "collision_volume",
        hint = "InvisibleBrush11",
    },
    {
        mechanism_id = 900703,
        event_id = 30703,
        source_object_index = 703,
        source_class = "ScriptObject",
        source_name = "ScriptObject1",
        kind = "script_object",
        hint = "ScriptObject1",
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
    [30391] = { kind = "open_door", source = "mm9_mechanism", targetName = "mine cart door left" },
    [30392] = { kind = "open_door", source = "mm9_mechanism", targetName = "mine cart door right" },
    [30399] = { kind = "open_door", source = "mm9_mechanism", targetName = "cottage door" },
    [30632] = { kind = "open_door", source = "mm9_mechanism", targetName = "Switch" },
    [30670] = { kind = "open_door", source = "mm9_mechanism", targetName = "Strikeplate1" },
    [30671] = { kind = "open_door", source = "mm9_mechanism", targetName = "Riser1" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30391, "mine cart door left", function()
    map.triggerMechanism(391, 2)
end, "mine cart door left")

RegisterEvent(30392, "mine cart door right", function()
    map.triggerMechanism(392, 2)
end, "mine cart door right")

RegisterEvent(30399, "cottage door", function()
    map.triggerMechanism(399, 2)
end, "cottage door")

RegisterEvent(30632, "Switch", function()
    map.triggerMechanism(632, 2)
end, "Switch")

RegisterEvent(30670, "Strikeplate1", function()
    map.triggerMechanism(670, 2)
end, "Strikeplate1")

RegisterEvent(30671, "Riser1", function()
    map.triggerMechanism(671, 2)
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
map.scripts["bellweight.scr"] = {
    source = "BELLWEIGHT.scr",
    registered_triggers = {
        { line = 16, message = "open", callback = "AdjustHeight" },
    },
    movement_commands = {
    },
}
map.scripts["boatjudge.scr"] = {
    source = "BOATJUDGE.scr",
    registered_triggers = {
        { line = 31, message = "use", callback = "OnUse" },
        { line = 60, message = "CPUArrival", callback = "AIWon" },
        { line = 61, message = "PlayerArrival", callback = "PlayerWon" },
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
map.scripts["npc7.scr"] = {
    source = "NPC7.scr",
    registered_triggers = {
        { line = 450, message = "Use", callback = "OnUse" },
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
map.scripts["racingboat.scr"] = {
    source = "RACINGBOAT.scr",
    registered_triggers = {
        { line = 48, message = "on", callback = "TurnOn" },
        { line = 50, message = "off", callback = "TurnOff" },
        { line = 51, message = "submerge", callback = "Submerge" },
    },
    movement_commands = {
        { line = 101, command = "SetPOS", arguments = "hMe, xMe,yMe,zMe" },
        { line = 120, command = "MoveDir", arguments = "dx,0,dz, nDist, nDist, Ready" },
        { line = 138, command = "MoveDir", arguments = "dx,0,dz, nDist, nSpeed, StartMoveLoop" },
        { line = 169, command = "MoveDir", arguments = "0,-1,0, 64, 64, ReturnToStart" },
        { line = 177, command = "SetPOS", arguments = "hMe, xMe,nTemp,zMe" },
        { line = 185, command = "MoveDir", arguments = "0,1,0, 64, 64, TurnOff" },
    },
}
map.scripts["scholarpromo.scr"] = {
    source = "SCHOLARPROMO.scr",
    registered_triggers = {
        { line = 69, message = "use", callback = "Init" },
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
map.scripts["thorgard_actor.scr"] = {
    source = "THORGARD_ACTOR.scr",
    registered_triggers = {
        { line = 178, message = "RobPlayer", callback = "OnRobPlayer" },
        { line = 336, message = "Attack", callback = "OnMagreebAttack" },
        { line = 399, message = "RunJimRun", callback = "RunJimRun" },
        { line = 438, message = "ComeGetMe", callback = "DeanGetHim" },
        { line = 454, message = "ComeGetMe", callback = "WalterGetHim" },
    },
    movement_commands = {
        { line = 279, command = "SetPos", arguments = "g_hMyObject,startX,startY,startZ" },
    },
}
map.scripts["trainingenter.scr"] = {
    source = "TRAININGENTER.scr",
    registered_triggers = {
        { line = 60, message = "Break", callback = "OnBreak" },
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
