-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "isleofashes"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 474,
        source_name = "VRStartPoint",
        x = -5908,
        y = 4124,
        z = 1659,
        direction_yaw_units = 2004,
        move_player_to_floor = true,
    },
    {
        start_index = 1,
        source_object_index = 478,
        source_name = "StartPoint0",
        x = -18984,
        y = 492,
        z = 492,
        direction_yaw_units = 0,
        move_player_to_floor = true,
    },
    {
        start_index = 2,
        source_object_index = 501,
        source_name = "StartPoint1",
        x = -3809,
        y = 5007,
        z = 348,
        direction_yaw_units = 858,
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
        mechanism_id = 900006,
        event_id = 30006,
        source_object_index = 6,
        source_class = "Door",
        source_name = "Terrain3",
        kind = "linear_door",
        hint = "Terrain3",
    },
    {
        mechanism_id = 900007,
        event_id = 30007,
        source_object_index = 7,
        source_class = "DestructableBrush",
        source_name = "FortWall0",
        kind = "destructible_brush",
        hint = "FortWall0",
    },
    {
        mechanism_id = 900187,
        event_id = 30187,
        source_object_index = 187,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900188,
        event_id = 30188,
        source_object_index = 188,
        source_class = "AIBarrier",
        source_name = "AIBarrier4",
        kind = "ai_barrier",
        hint = "AIBarrier4",
    },
    {
        mechanism_id = 900189,
        event_id = 30189,
        source_object_index = 189,
        source_class = "AIBarrier",
        source_name = "AIBarrier5",
        kind = "ai_barrier",
        hint = "AIBarrier5",
    },
    {
        mechanism_id = 900190,
        event_id = 30190,
        source_object_index = 190,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 900191,
        event_id = 30191,
        source_object_index = 191,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900192,
        event_id = 30192,
        source_object_index = 192,
        source_class = "AIBarrier",
        source_name = "AIBarrier3",
        kind = "ai_barrier",
        hint = "AIBarrier3",
    },
    {
        mechanism_id = 900193,
        event_id = 30193,
        source_object_index = 193,
        source_class = "AIBarrier",
        source_name = "AIBarrier2",
        kind = "ai_barrier",
        hint = "AIBarrier2",
    },
    {
        mechanism_id = 900206,
        event_id = 30206,
        source_object_index = 206,
        source_class = "AIBarrier",
        source_name = "AIBarrier7",
        kind = "ai_barrier",
        hint = "AIBarrier7",
    },
    {
        mechanism_id = 900207,
        event_id = 30207,
        source_object_index = 207,
        source_class = "AIBarrier",
        source_name = "AIBarrier8",
        kind = "ai_barrier",
        hint = "AIBarrier8",
    },
    {
        mechanism_id = 900208,
        event_id = 30208,
        source_object_index = 208,
        source_class = "AIBarrier",
        source_name = "AIBarrier9",
        kind = "ai_barrier",
        hint = "AIBarrier9",
    },
    {
        mechanism_id = 900209,
        event_id = 30209,
        source_object_index = 209,
        source_class = "AIBarrier",
        source_name = "AIBarrier10",
        kind = "ai_barrier",
        hint = "AIBarrier10",
    },
    {
        mechanism_id = 900210,
        event_id = 30210,
        source_object_index = 210,
        source_class = "AIBarrier",
        source_name = "AIBarrier12",
        kind = "ai_barrier",
        hint = "AIBarrier12",
    },
    {
        mechanism_id = 900211,
        event_id = 30211,
        source_object_index = 211,
        source_class = "AIBarrier",
        source_name = "AIBarrier13",
        kind = "ai_barrier",
        hint = "AIBarrier13",
    },
    {
        mechanism_id = 900212,
        event_id = 30212,
        source_object_index = 212,
        source_class = "AIBarrier",
        source_name = "AIBarrier11",
        kind = "ai_barrier",
        hint = "AIBarrier11",
    },
    {
        mechanism_id = 900263,
        event_id = 30263,
        source_object_index = 263,
        source_class = "AIBarrier",
        source_name = "AIBarrier14",
        kind = "ai_barrier",
        hint = "AIBarrier14",
    },
    {
        mechanism_id = 900337,
        event_id = 30337,
        source_object_index = 337,
        source_class = "AIBarrier",
        source_name = "AIBarrier15",
        kind = "ai_barrier",
        hint = "AIBarrier15",
    },
    {
        mechanism_id = 900338,
        event_id = 30338,
        source_object_index = 338,
        source_class = "AIBarrier",
        source_name = "AIBarrier16",
        kind = "ai_barrier",
        hint = "AIBarrier16",
    },
    {
        mechanism_id = 900339,
        event_id = 30339,
        source_object_index = 339,
        source_class = "AIBarrier",
        source_name = "AIBarrier17",
        kind = "ai_barrier",
        hint = "AIBarrier17",
    },
    {
        mechanism_id = 900340,
        event_id = 30340,
        source_object_index = 340,
        source_class = "AIBarrier",
        source_name = "AIBarrier18",
        kind = "ai_barrier",
        hint = "AIBarrier18",
    },
    {
        mechanism_id = 900341,
        event_id = 30341,
        source_object_index = 341,
        source_class = "AIBarrier",
        source_name = "AIBarrier19",
        kind = "ai_barrier",
        hint = "AIBarrier19",
    },
    {
        mechanism_id = 900342,
        event_id = 30342,
        source_object_index = 342,
        source_class = "AIBarrier",
        source_name = "AIBarrier20",
        kind = "ai_barrier",
        hint = "AIBarrier20",
    },
    {
        mechanism_id = 900353,
        event_id = 30353,
        source_object_index = 353,
        source_class = "AIBarrier",
        source_name = "AIBarrier21",
        kind = "ai_barrier",
        hint = "AIBarrier21",
    },
    {
        mechanism_id = 900354,
        event_id = 30354,
        source_object_index = 354,
        source_class = "AIBarrier",
        source_name = "AIBarrier22",
        kind = "ai_barrier",
        hint = "AIBarrier22",
    },
    {
        mechanism_id = 900355,
        event_id = 30355,
        source_object_index = 355,
        source_class = "AIBarrier",
        source_name = "AIBarrier23",
        kind = "ai_barrier",
        hint = "AIBarrier23",
    },
    {
        mechanism_id = 900356,
        event_id = 30356,
        source_object_index = 356,
        source_class = "AIBarrier",
        source_name = "AIBarrier24",
        kind = "ai_barrier",
        hint = "AIBarrier24",
    },
    {
        mechanism_id = 900357,
        event_id = 30357,
        source_object_index = 357,
        source_class = "AIBarrier",
        source_name = "AIBarrier25",
        kind = "ai_barrier",
        hint = "AIBarrier25",
    },
    {
        mechanism_id = 900358,
        event_id = 30358,
        source_object_index = 358,
        source_class = "AIBarrier",
        source_name = "AIBarrier26",
        kind = "ai_barrier",
        hint = "AIBarrier26",
    },
    {
        mechanism_id = 900359,
        event_id = 30359,
        source_object_index = 359,
        source_class = "AIBarrier",
        source_name = "AIBarrier27",
        kind = "ai_barrier",
        hint = "AIBarrier27",
    },
    {
        mechanism_id = 900360,
        event_id = 30360,
        source_object_index = 360,
        source_class = "AIBarrier",
        source_name = "AIBarrier28",
        kind = "ai_barrier",
        hint = "AIBarrier28",
    },
    {
        mechanism_id = 900361,
        event_id = 30361,
        source_object_index = 361,
        source_class = "AIBarrier",
        source_name = "AIBarrier29",
        kind = "ai_barrier",
        hint = "AIBarrier29",
    },
    {
        mechanism_id = 900362,
        event_id = 30362,
        source_object_index = 362,
        source_class = "AIBarrier",
        source_name = "AIBarrier30",
        kind = "ai_barrier",
        hint = "AIBarrier30",
    },
    {
        mechanism_id = 900363,
        event_id = 30363,
        source_object_index = 363,
        source_class = "AIBarrier",
        source_name = "AIBarrier31",
        kind = "ai_barrier",
        hint = "AIBarrier31",
    },
    {
        mechanism_id = 900364,
        event_id = 30364,
        source_object_index = 364,
        source_class = "AIBarrier",
        source_name = "AIBarrier32",
        kind = "ai_barrier",
        hint = "AIBarrier32",
    },
    {
        mechanism_id = 900365,
        event_id = 30365,
        source_object_index = 365,
        source_class = "AIBarrier",
        source_name = "AIBarrier33",
        kind = "ai_barrier",
        hint = "AIBarrier33",
    },
    {
        mechanism_id = 900366,
        event_id = 30366,
        source_object_index = 366,
        source_class = "AIBarrier",
        source_name = "AIBarrier34",
        kind = "ai_barrier",
        hint = "AIBarrier34",
    },
    {
        mechanism_id = 900385,
        event_id = 30385,
        source_object_index = 385,
        source_class = "AIBarrier",
        source_name = "AIBarrier35",
        kind = "ai_barrier",
        hint = "AIBarrier35",
    },
    {
        mechanism_id = 900386,
        event_id = 30386,
        source_object_index = 386,
        source_class = "AIBarrier",
        source_name = "AIBarrier36",
        kind = "ai_barrier",
        hint = "AIBarrier36",
    },
    {
        mechanism_id = 900387,
        event_id = 30387,
        source_object_index = 387,
        source_class = "AIBarrier",
        source_name = "AIBarrier37",
        kind = "ai_barrier",
        hint = "AIBarrier37",
    },
    {
        mechanism_id = 900388,
        event_id = 30388,
        source_object_index = 388,
        source_class = "AIBarrier",
        source_name = "AIBarrier38",
        kind = "ai_barrier",
        hint = "AIBarrier38",
    },
    {
        mechanism_id = 900389,
        event_id = 30389,
        source_object_index = 389,
        source_class = "AIBarrier",
        source_name = "AIBarrier39",
        kind = "ai_barrier",
        hint = "AIBarrier39",
    },
    {
        mechanism_id = 900390,
        event_id = 30390,
        source_object_index = 390,
        source_class = "AIBarrier",
        source_name = "AIBarrier40",
        kind = "ai_barrier",
        hint = "AIBarrier40",
    },
    {
        mechanism_id = 900391,
        event_id = 30391,
        source_object_index = 391,
        source_class = "AIBarrier",
        source_name = "AIBarrier41",
        kind = "ai_barrier",
        hint = "AIBarrier41",
    },
    {
        mechanism_id = 900392,
        event_id = 30392,
        source_object_index = 392,
        source_class = "AIBarrier",
        source_name = "AIBarrier42",
        kind = "ai_barrier",
        hint = "AIBarrier42",
    },
    {
        mechanism_id = 900393,
        event_id = 30393,
        source_object_index = 393,
        source_class = "AIBarrier",
        source_name = "AIBarrier43",
        kind = "ai_barrier",
        hint = "AIBarrier43",
    },
    {
        mechanism_id = 900394,
        event_id = 30394,
        source_object_index = 394,
        source_class = "AIBarrier",
        source_name = "AIBarrier44",
        kind = "ai_barrier",
        hint = "AIBarrier44",
    },
    {
        mechanism_id = 900395,
        event_id = 30395,
        source_object_index = 395,
        source_class = "AIBarrier",
        source_name = "AIBarrier45",
        kind = "ai_barrier",
        hint = "AIBarrier45",
    },
    {
        mechanism_id = 900396,
        event_id = 30396,
        source_object_index = 396,
        source_class = "AIBarrier",
        source_name = "AIBarrier46",
        kind = "ai_barrier",
        hint = "AIBarrier46",
    },
    {
        mechanism_id = 900397,
        event_id = 30397,
        source_object_index = 397,
        source_class = "AIBarrier",
        source_name = "AIBarrier47",
        kind = "ai_barrier",
        hint = "AIBarrier47",
    },
    {
        mechanism_id = 900398,
        event_id = 30398,
        source_object_index = 398,
        source_class = "AIBarrier",
        source_name = "AIBarrier62",
        kind = "ai_barrier",
        hint = "AIBarrier62",
    },
    {
        mechanism_id = 900399,
        event_id = 30399,
        source_object_index = 399,
        source_class = "AIBarrier",
        source_name = "AIBarrier61",
        kind = "ai_barrier",
        hint = "AIBarrier61",
    },
    {
        mechanism_id = 900400,
        event_id = 30400,
        source_object_index = 400,
        source_class = "AIBarrier",
        source_name = "AIBarrier59",
        kind = "ai_barrier",
        hint = "AIBarrier59",
    },
    {
        mechanism_id = 900401,
        event_id = 30401,
        source_object_index = 401,
        source_class = "AIBarrier",
        source_name = "AIBarrier60",
        kind = "ai_barrier",
        hint = "AIBarrier60",
    },
    {
        mechanism_id = 900402,
        event_id = 30402,
        source_object_index = 402,
        source_class = "AIBarrier",
        source_name = "AIBarrier58",
        kind = "ai_barrier",
        hint = "AIBarrier58",
    },
    {
        mechanism_id = 900403,
        event_id = 30403,
        source_object_index = 403,
        source_class = "AIBarrier",
        source_name = "AIBarrier57",
        kind = "ai_barrier",
        hint = "AIBarrier57",
    },
    {
        mechanism_id = 900404,
        event_id = 30404,
        source_object_index = 404,
        source_class = "AIBarrier",
        source_name = "AIBarrier56",
        kind = "ai_barrier",
        hint = "AIBarrier56",
    },
    {
        mechanism_id = 900405,
        event_id = 30405,
        source_object_index = 405,
        source_class = "AIBarrier",
        source_name = "AIBarrier55",
        kind = "ai_barrier",
        hint = "AIBarrier55",
    },
    {
        mechanism_id = 900406,
        event_id = 30406,
        source_object_index = 406,
        source_class = "AIBarrier",
        source_name = "AIBarrier54",
        kind = "ai_barrier",
        hint = "AIBarrier54",
    },
    {
        mechanism_id = 900407,
        event_id = 30407,
        source_object_index = 407,
        source_class = "AIBarrier",
        source_name = "AIBarrier53",
        kind = "ai_barrier",
        hint = "AIBarrier53",
    },
    {
        mechanism_id = 900408,
        event_id = 30408,
        source_object_index = 408,
        source_class = "AIBarrier",
        source_name = "AIBarrier52",
        kind = "ai_barrier",
        hint = "AIBarrier52",
    },
    {
        mechanism_id = 900409,
        event_id = 30409,
        source_object_index = 409,
        source_class = "AIBarrier",
        source_name = "AIBarrier51",
        kind = "ai_barrier",
        hint = "AIBarrier51",
    },
    {
        mechanism_id = 900410,
        event_id = 30410,
        source_object_index = 410,
        source_class = "AIBarrier",
        source_name = "AIBarrier50",
        kind = "ai_barrier",
        hint = "AIBarrier50",
    },
    {
        mechanism_id = 900411,
        event_id = 30411,
        source_object_index = 411,
        source_class = "AIBarrier",
        source_name = "AIBarrier49",
        kind = "ai_barrier",
        hint = "AIBarrier49",
    },
    {
        mechanism_id = 900412,
        event_id = 30412,
        source_object_index = 412,
        source_class = "AIBarrier",
        source_name = "AIBarrier48",
        kind = "ai_barrier",
        hint = "AIBarrier48",
    },
    {
        mechanism_id = 900479,
        event_id = 30479,
        source_object_index = 479,
        source_class = "Shooter",
        source_name = "Shooter0",
        kind = "shooter",
        hint = "Shooter0",
    },
    {
        mechanism_id = 900480,
        event_id = 30480,
        source_object_index = 480,
        source_class = "Shooter",
        source_name = "Shooter",
        kind = "shooter",
        hint = "Shooter",
    },
    {
        mechanism_id = 900483,
        event_id = 30483,
        source_object_index = 483,
        source_class = "ScriptObject",
        source_name = "KillControl",
        kind = "script_object",
        hint = "KillControl",
    },
    {
        mechanism_id = 900494,
        event_id = 30494,
        source_object_index = 494,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 900497,
        event_id = 30497,
        source_object_index = 497,
        source_class = "ScriptObject",
        source_name = "ScriptObject0",
        kind = "script_object",
        hint = "ScriptObject0",
    },
    {
        mechanism_id = 900498,
        event_id = 30498,
        source_object_index = 498,
        source_class = "RotatingDoor",
        source_name = "BunkerDoor1",
        kind = "rotating_door",
        hint = "BunkerDoor1",
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
        mechanism_id = 900499,
        event_id = 30499,
        source_object_index = 499,
        source_class = "RotatingDoor",
        source_name = "BunkerDoor2",
        kind = "rotating_door",
        hint = "BunkerDoor2",
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
        mechanism_id = 900520,
        event_id = 30520,
        source_object_index = 520,
        source_class = "DestructableBrush",
        source_name = "FortWall",
        kind = "destructible_brush",
        hint = "FortWall",
    },
    {
        mechanism_id = 900551,
        event_id = 30551,
        source_object_index = 551,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 900552,
        event_id = 30552,
        source_object_index = 552,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 900553,
        event_id = 30553,
        source_object_index = 553,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 900554,
        event_id = 30554,
        source_object_index = 554,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900557,
        event_id = 30557,
        source_object_index = 557,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 900558,
        event_id = 30558,
        source_object_index = 558,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 900559,
        event_id = 30559,
        source_object_index = 559,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 900560,
        event_id = 30560,
        source_object_index = 560,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 900568,
        event_id = 30568,
        source_object_index = 568,
        source_class = "ScriptObject",
        source_name = "ExplosionEffect0",
        kind = "script_object",
        hint = "ExplosionEffect0",
    },
    {
        mechanism_id = 900569,
        event_id = 30569,
        source_object_index = 569,
        source_class = "ScriptObject",
        source_name = "ExplosionEffect2",
        kind = "script_object",
        hint = "ExplosionEffect2",
    },
    {
        mechanism_id = 900570,
        event_id = 30570,
        source_object_index = 570,
        source_class = "ScriptObject",
        source_name = "ExplosionEffect1",
        kind = "script_object",
        hint = "ExplosionEffect1",
    },
    {
        mechanism_id = 900571,
        event_id = 30571,
        source_object_index = 571,
        source_class = "ScriptObject",
        source_name = "ExplosionEffect3",
        kind = "script_object",
        hint = "ExplosionEffect3",
    },
    {
        mechanism_id = 900572,
        event_id = 30572,
        source_object_index = 572,
        source_class = "ScriptObject",
        source_name = "ExplosionEffect4",
        kind = "script_object",
        hint = "ExplosionEffect4",
    },
    {
        mechanism_id = 900749,
        event_id = 30749,
        source_object_index = 749,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush6",
        kind = "collision_volume",
        hint = "InvisibleBrush6",
    },
    {
        mechanism_id = 900750,
        event_id = 30750,
        source_object_index = 750,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush7",
        kind = "collision_volume",
        hint = "InvisibleBrush7",
    },
    {
        mechanism_id = 900751,
        event_id = 30751,
        source_object_index = 751,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush8",
        kind = "collision_volume",
        hint = "InvisibleBrush8",
    },
    {
        mechanism_id = 900752,
        event_id = 30752,
        source_object_index = 752,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush9",
        kind = "collision_volume",
        hint = "InvisibleBrush9",
    },
    {
        mechanism_id = 900753,
        event_id = 30753,
        source_object_index = 753,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush10",
        kind = "collision_volume",
        hint = "InvisibleBrush10",
    },
    {
        mechanism_id = 900754,
        event_id = 30754,
        source_object_index = 754,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush11",
        kind = "collision_volume",
        hint = "InvisibleBrush11",
    },
    {
        mechanism_id = 900755,
        event_id = 30755,
        source_object_index = 755,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush12",
        kind = "collision_volume",
        hint = "InvisibleBrush12",
    },
    {
        mechanism_id = 900756,
        event_id = 30756,
        source_object_index = 756,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush13",
        kind = "collision_volume",
        hint = "InvisibleBrush13",
    },
    {
        mechanism_id = 900769,
        event_id = 30769,
        source_object_index = 769,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor8",
        kind = "rotating_door",
        hint = "RotatingDoor8",
    },
    {
        mechanism_id = 900771,
        event_id = 30771,
        source_object_index = 771,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush16",
        kind = "collision_volume",
        hint = "InvisibleBrush16",
    },
    {
        mechanism_id = 900774,
        event_id = 30774,
        source_object_index = 774,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush17",
        kind = "collision_volume",
        hint = "InvisibleBrush17",
    },
    {
        mechanism_id = 900775,
        event_id = 30775,
        source_object_index = 775,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush18",
        kind = "collision_volume",
        hint = "InvisibleBrush18",
    },
    {
        mechanism_id = 900776,
        event_id = 30776,
        source_object_index = 776,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush15",
        kind = "collision_volume",
        hint = "InvisibleBrush15",
    },
    {
        mechanism_id = 900777,
        event_id = 30777,
        source_object_index = 777,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush14",
        kind = "collision_volume",
        hint = "InvisibleBrush14",
    },
    {
        mechanism_id = 900778,
        event_id = 30778,
        source_object_index = 778,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush19",
        kind = "collision_volume",
        hint = "InvisibleBrush19",
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
    [30006] = { kind = "open_door", source = "mm9_mechanism", targetName = "Terrain3" },
    [30498] = { kind = "open_door", source = "mm9_mechanism", targetName = "BunkerDoor1" },
    [30499] = { kind = "open_door", source = "mm9_mechanism", targetName = "BunkerDoor2" },
    [30769] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor8" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30006, "Terrain3", function()
    map.triggerMechanism(6, 2)
end, "Terrain3")

RegisterEvent(30498, "BunkerDoor1", function()
    map.triggerMechanism(498, 2)
end, "BunkerDoor1")

RegisterEvent(30499, "BunkerDoor2", function()
    map.triggerMechanism(499, 2)
end, "BunkerDoor2")

RegisterEvent(30769, "RotatingDoor8", function()
    map.triggerMechanism(769, 2)
end, "RotatingDoor8")

map.scripts["autoresurrect.scr"] = {
    source = "AUTORESURRECT.scr",
    registered_triggers = {
        { line = 83, message = "TMSG_RESURRECT", callback = "OnResurrect" },
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
map.scripts["forad.scr"] = {
    source = "FORAD.scr",
    registered_triggers = {
        { line = 176, message = "Use", callback = "OnUse" },
        { line = 177, message = "Appear", callback = "OnAppear" },
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
map.scripts["ia_camera2.scr"] = {
    source = "IA_CAMERA2.scr",
    registered_triggers = {
        { line = 57, message = "Pan", callback = "OnPlay" },
    },
    movement_commands = {
        { line = 35, command = "MoveToPos", arguments = "xpos Xpos Zpos 100 DoNothing" },
    },
}
map.scripts["ia_island.scr"] = {
    source = "IA_ISLAND.scr",
    registered_triggers = {
        { line = 29, message = "SinkSpeed", callback = "OnSinkSpeed" },
    },
    movement_commands = {
    },
}
map.scripts["is_boat.scr"] = {
    source = "IS_BOAT.scr",
    registered_triggers = {
        { line = 62, message = "Move", callback = "OnMove" },
    },
    movement_commands = {
        { line = 42, command = "MoveToPos", arguments = "xpos MyY Zpos 100 DoNothing" },
    },
}
map.scripts["isle_islandexplosion.scr"] = {
    source = "ISLE_ISLANDEXPLOSION.scr",
    registered_triggers = {
        { line = 23, message = "explode", callback = "CreateExplosion" },
    },
    movement_commands = {
    },
}
map.scripts["isle_seamon.scr"] = {
    source = "ISLE_SEAMON.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["isle_skull.scr"] = {
    source = "ISLE_SKULL.scr",
    registered_triggers = {
    },
    movement_commands = {
    },
}
map.scripts["isle_summoner.scr"] = {
    source = "ISLE_SUMMONER.scr",
    registered_triggers = {
        { line = 54, message = "spawn", callback = "SpawnCreature" },
    },
    movement_commands = {
    },
}
map.scripts["isleashesbook.scr"] = {
    source = "ISLEASHESBOOK.scr",
    registered_triggers = {
        { line = 252, message = "Crane", callback = "OnCrane2" },
        { line = 253, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["isleofashesactor.scr"] = {
    source = "ISLEOFASHESACTOR.scr",
    registered_triggers = {
        { line = 317, message = "RunNormalScript", callback = "RunNormalScript" },
        { line = 325, message = "MacRunAway", callback = "OnMacFoundPlayer" },
        { line = 326, message = "GoAfterPlayer", callback = "GoAfterPlayer" },
        { line = 331, message = "GoThrowBones", callback = "GoThrowBones" },
    },
    movement_commands = {
        { line = 73, command = "SetPos", arguments = "g_hObject,g_posX,g_posY,g_posZ" },
        { line = 166, command = "SetPos", arguments = "g_hMyObject,g_posX,g_posY,g_posZ" },
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
map.scripts["tm_hardrock.scr"] = {
    source = "TM_HARDROCK.scr",
    registered_triggers = {
        { line = 65, message = "OneDown", callback = "OneDown" },
    },
    movement_commands = {
    },
}
map.scripts["yrsa.scr"] = {
    source = "YRSA.scr",
    registered_triggers = {
        { line = 135, message = "Use", callback = "OnUse" },
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
