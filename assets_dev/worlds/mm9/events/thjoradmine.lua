-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "thjoradmine"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 13,
        source_name = "StartPoint0",
        x = 2785,
        y = -2785,
        z = -737,
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
        mechanism_id = 900000,
        event_id = 30000,
        source_object_index = 0,
        source_class = "DestructableBrush",
        source_name = "db12",
        kind = "destructible_brush",
        hint = "db12",
    },
    {
        mechanism_id = 900001,
        event_id = 30001,
        source_object_index = 1,
        source_class = "DestructableBrush",
        source_name = "db13",
        kind = "destructible_brush",
        hint = "db13",
    },
    {
        mechanism_id = 900002,
        event_id = 30002,
        source_object_index = 2,
        source_class = "DestructableBrush",
        source_name = "db14",
        kind = "destructible_brush",
        hint = "db14",
    },
    {
        mechanism_id = 900003,
        event_id = 30003,
        source_object_index = 3,
        source_class = "DestructableBrush",
        source_name = "db15",
        kind = "destructible_brush",
        hint = "db15",
    },
    {
        mechanism_id = 900004,
        event_id = 30004,
        source_object_index = 4,
        source_class = "DestructableBrush",
        source_name = "db16",
        kind = "destructible_brush",
        hint = "db16",
    },
    {
        mechanism_id = 900005,
        event_id = 30005,
        source_object_index = 5,
        source_class = "DestructableBrush",
        source_name = "db17",
        kind = "destructible_brush",
        hint = "db17",
    },
    {
        mechanism_id = 900006,
        event_id = 30006,
        source_object_index = 6,
        source_class = "DestructableBrush",
        source_name = "db18",
        kind = "destructible_brush",
        hint = "db18",
    },
    {
        mechanism_id = 900007,
        event_id = 30007,
        source_object_index = 7,
        source_class = "DestructableBrush",
        source_name = "db19",
        kind = "destructible_brush",
        hint = "db19",
    },
    {
        mechanism_id = 900008,
        event_id = 30008,
        source_object_index = 8,
        source_class = "DestructableBrush",
        source_name = "db20",
        kind = "destructible_brush",
        hint = "db20",
    },
    {
        mechanism_id = 900009,
        event_id = 30009,
        source_object_index = 9,
        source_class = "DestructableBrush",
        source_name = "db21",
        kind = "destructible_brush",
        hint = "db21",
    },
    {
        mechanism_id = 900010,
        event_id = 30010,
        source_object_index = 10,
        source_class = "DestructableBrush",
        source_name = "db22",
        kind = "destructible_brush",
        hint = "db22",
    },
    {
        mechanism_id = 900011,
        event_id = 30011,
        source_object_index = 11,
        source_class = "DestructableBrush",
        source_name = "db23",
        kind = "destructible_brush",
        hint = "db23",
    },
    {
        mechanism_id = 900019,
        event_id = 30019,
        source_object_index = 19,
        source_class = "DestructableProp",
        source_name = "Crate0",
        kind = "destructible_prop",
        hint = "Crate0",
    },
    {
        mechanism_id = 900020,
        event_id = 30020,
        source_object_index = 20,
        source_class = "DestructableProp",
        source_name = "Crate1",
        kind = "destructible_prop",
        hint = "Crate1",
    },
    {
        mechanism_id = 900021,
        event_id = 30021,
        source_object_index = 21,
        source_class = "DestructableProp",
        source_name = "Crate4",
        kind = "destructible_prop",
        hint = "Crate4",
    },
    {
        mechanism_id = 900022,
        event_id = 30022,
        source_object_index = 22,
        source_class = "DestructableProp",
        source_name = "Crate5",
        kind = "destructible_prop",
        hint = "Crate5",
    },
    {
        mechanism_id = 900027,
        event_id = 30027,
        source_object_index = 27,
        source_class = "DestructableBrush",
        source_name = "CaveWall0",
        kind = "destructible_brush",
        hint = "CaveWall0",
    },
    {
        mechanism_id = 900045,
        event_id = 30045,
        source_object_index = 45,
        source_class = "DestructableProp",
        source_name = "Crate9",
        kind = "destructible_prop",
        hint = "Crate9",
    },
    {
        mechanism_id = 900046,
        event_id = 30046,
        source_object_index = 46,
        source_class = "DestructableProp",
        source_name = "Crate10",
        kind = "destructible_prop",
        hint = "Crate10",
    },
    {
        mechanism_id = 900047,
        event_id = 30047,
        source_object_index = 47,
        source_class = "DestructableProp",
        source_name = "Crate11",
        kind = "destructible_prop",
        hint = "Crate11",
    },
    {
        mechanism_id = 900048,
        event_id = 30048,
        source_object_index = 48,
        source_class = "DestructableProp",
        source_name = "Crate6",
        kind = "destructible_prop",
        hint = "Crate6",
    },
    {
        mechanism_id = 900049,
        event_id = 30049,
        source_object_index = 49,
        source_class = "DestructableProp",
        source_name = "Crate7",
        kind = "destructible_prop",
        hint = "Crate7",
    },
    {
        mechanism_id = 900050,
        event_id = 30050,
        source_object_index = 50,
        source_class = "DestructableProp",
        source_name = "Crate8",
        kind = "destructible_prop",
        hint = "Crate8",
    },
    {
        mechanism_id = 900056,
        event_id = 30056,
        source_object_index = 56,
        source_class = "DestructableProp",
        source_name = "Stool1",
        kind = "destructible_prop",
        hint = "Stool1",
    },
    {
        mechanism_id = 900057,
        event_id = 30057,
        source_object_index = 57,
        source_class = "DestructableProp",
        source_name = "Stool2",
        kind = "destructible_prop",
        hint = "Stool2",
    },
    {
        mechanism_id = 900080,
        event_id = 30080,
        source_object_index = 80,
        source_class = "DestructableProp",
        source_name = "Stool3",
        kind = "destructible_prop",
        hint = "Stool3",
    },
    {
        mechanism_id = 900081,
        event_id = 30081,
        source_object_index = 81,
        source_class = "DestructableProp",
        source_name = "Stool4",
        kind = "destructible_prop",
        hint = "Stool4",
    },
    {
        mechanism_id = 900086,
        event_id = 30086,
        source_object_index = 86,
        source_class = "BlueWater",
        source_name = "DirtyWater1",
        kind = "water_volume",
        hint = "DirtyWater1",
    },
    {
        mechanism_id = 900443,
        event_id = 30443,
        source_object_index = 443,
        source_class = "DestructableProp",
        source_name = "Barrel1",
        kind = "destructible_prop",
        hint = "Barrel1",
    },
    {
        mechanism_id = 900444,
        event_id = 30444,
        source_object_index = 444,
        source_class = "DestructableProp",
        source_name = "Barrel0",
        kind = "destructible_prop",
        hint = "Barrel0",
    },
    {
        mechanism_id = 900445,
        event_id = 30445,
        source_object_index = 445,
        source_class = "DestructableProp",
        source_name = "Barrel40",
        kind = "destructible_prop",
        hint = "Barrel40",
    },
    {
        mechanism_id = 900446,
        event_id = 30446,
        source_object_index = 446,
        source_class = "DestructableProp",
        source_name = "Barrel39",
        kind = "destructible_prop",
        hint = "Barrel39",
    },
    {
        mechanism_id = 900447,
        event_id = 30447,
        source_object_index = 447,
        source_class = "DestructableProp",
        source_name = "Barrel17",
        kind = "destructible_prop",
        hint = "Barrel17",
    },
    {
        mechanism_id = 900448,
        event_id = 30448,
        source_object_index = 448,
        source_class = "DestructableProp",
        source_name = "Barrel18",
        kind = "destructible_prop",
        hint = "Barrel18",
    },
    {
        mechanism_id = 900449,
        event_id = 30449,
        source_object_index = 449,
        source_class = "DestructableProp",
        source_name = "Barrel19",
        kind = "destructible_prop",
        hint = "Barrel19",
    },
    {
        mechanism_id = 900450,
        event_id = 30450,
        source_object_index = 450,
        source_class = "DestructableProp",
        source_name = "Barrel20",
        kind = "destructible_prop",
        hint = "Barrel20",
    },
    {
        mechanism_id = 900451,
        event_id = 30451,
        source_object_index = 451,
        source_class = "DestructableProp",
        source_name = "Barrel21",
        kind = "destructible_prop",
        hint = "Barrel21",
    },
    {
        mechanism_id = 900452,
        event_id = 30452,
        source_object_index = 452,
        source_class = "DestructableProp",
        source_name = "Barrel22",
        kind = "destructible_prop",
        hint = "Barrel22",
    },
    {
        mechanism_id = 900453,
        event_id = 30453,
        source_object_index = 453,
        source_class = "DestructableProp",
        source_name = "Barrel23",
        kind = "destructible_prop",
        hint = "Barrel23",
    },
    {
        mechanism_id = 900454,
        event_id = 30454,
        source_object_index = 454,
        source_class = "DestructableProp",
        source_name = "Barrel24",
        kind = "destructible_prop",
        hint = "Barrel24",
    },
    {
        mechanism_id = 900455,
        event_id = 30455,
        source_object_index = 455,
        source_class = "DestructableProp",
        source_name = "Barrel25",
        kind = "destructible_prop",
        hint = "Barrel25",
    },
    {
        mechanism_id = 900456,
        event_id = 30456,
        source_object_index = 456,
        source_class = "DestructableProp",
        source_name = "Barrel27",
        kind = "destructible_prop",
        hint = "Barrel27",
    },
    {
        mechanism_id = 900457,
        event_id = 30457,
        source_object_index = 457,
        source_class = "DestructableProp",
        source_name = "Barrel28",
        kind = "destructible_prop",
        hint = "Barrel28",
    },
    {
        mechanism_id = 900458,
        event_id = 30458,
        source_object_index = 458,
        source_class = "DestructableProp",
        source_name = "Barrel29",
        kind = "destructible_prop",
        hint = "Barrel29",
    },
    {
        mechanism_id = 900459,
        event_id = 30459,
        source_object_index = 459,
        source_class = "DestructableProp",
        source_name = "Barrel30",
        kind = "destructible_prop",
        hint = "Barrel30",
    },
    {
        mechanism_id = 900460,
        event_id = 30460,
        source_object_index = 460,
        source_class = "DestructableProp",
        source_name = "Barrel31",
        kind = "destructible_prop",
        hint = "Barrel31",
    },
    {
        mechanism_id = 900461,
        event_id = 30461,
        source_object_index = 461,
        source_class = "DestructableProp",
        source_name = "Barrel32",
        kind = "destructible_prop",
        hint = "Barrel32",
    },
    {
        mechanism_id = 900462,
        event_id = 30462,
        source_object_index = 462,
        source_class = "DestructableProp",
        source_name = "Barrel33",
        kind = "destructible_prop",
        hint = "Barrel33",
    },
    {
        mechanism_id = 900463,
        event_id = 30463,
        source_object_index = 463,
        source_class = "DestructableProp",
        source_name = "Barrel34",
        kind = "destructible_prop",
        hint = "Barrel34",
    },
    {
        mechanism_id = 900464,
        event_id = 30464,
        source_object_index = 464,
        source_class = "DestructableProp",
        source_name = "Barrel35",
        kind = "destructible_prop",
        hint = "Barrel35",
    },
    {
        mechanism_id = 900465,
        event_id = 30465,
        source_object_index = 465,
        source_class = "DestructableProp",
        source_name = "Barrel13",
        kind = "destructible_prop",
        hint = "Barrel13",
    },
    {
        mechanism_id = 900466,
        event_id = 30466,
        source_object_index = 466,
        source_class = "DestructableProp",
        source_name = "Barrel14",
        kind = "destructible_prop",
        hint = "Barrel14",
    },
    {
        mechanism_id = 900467,
        event_id = 30467,
        source_object_index = 467,
        source_class = "DestructableProp",
        source_name = "Barrel15",
        kind = "destructible_prop",
        hint = "Barrel15",
    },
    {
        mechanism_id = 900468,
        event_id = 30468,
        source_object_index = 468,
        source_class = "DestructableProp",
        source_name = "Barrel16",
        kind = "destructible_prop",
        hint = "Barrel16",
    },
    {
        mechanism_id = 900469,
        event_id = 30469,
        source_object_index = 469,
        source_class = "DestructableProp",
        source_name = "Barrel26",
        kind = "destructible_prop",
        hint = "Barrel26",
    },
    {
        mechanism_id = 900470,
        event_id = 30470,
        source_object_index = 470,
        source_class = "DestructableProp",
        source_name = "Barrel38",
        kind = "destructible_prop",
        hint = "Barrel38",
    },
    {
        mechanism_id = 900471,
        event_id = 30471,
        source_object_index = 471,
        source_class = "DestructableProp",
        source_name = "Barrel11",
        kind = "destructible_prop",
        hint = "Barrel11",
    },
    {
        mechanism_id = 900472,
        event_id = 30472,
        source_object_index = 472,
        source_class = "DestructableProp",
        source_name = "Barrel8",
        kind = "destructible_prop",
        hint = "Barrel8",
    },
    {
        mechanism_id = 900473,
        event_id = 30473,
        source_object_index = 473,
        source_class = "DestructableProp",
        source_name = "Barrel10",
        kind = "destructible_prop",
        hint = "Barrel10",
    },
    {
        mechanism_id = 900474,
        event_id = 30474,
        source_object_index = 474,
        source_class = "DestructableProp",
        source_name = "Barrel12",
        kind = "destructible_prop",
        hint = "Barrel12",
    },
    {
        mechanism_id = 900475,
        event_id = 30475,
        source_object_index = 475,
        source_class = "DestructableProp",
        source_name = "Barrel6",
        kind = "destructible_prop",
        hint = "Barrel6",
    },
    {
        mechanism_id = 900476,
        event_id = 30476,
        source_object_index = 476,
        source_class = "DestructableProp",
        source_name = "Barrel2",
        kind = "destructible_prop",
        hint = "Barrel2",
    },
    {
        mechanism_id = 900477,
        event_id = 30477,
        source_object_index = 477,
        source_class = "DestructableProp",
        source_name = "Barrel4",
        kind = "destructible_prop",
        hint = "Barrel4",
    },
    {
        mechanism_id = 900478,
        event_id = 30478,
        source_object_index = 478,
        source_class = "DestructableProp",
        source_name = "Barrel7",
        kind = "destructible_prop",
        hint = "Barrel7",
    },
    {
        mechanism_id = 900479,
        event_id = 30479,
        source_object_index = 479,
        source_class = "DestructableProp",
        source_name = "Barrel42",
        kind = "destructible_prop",
        hint = "Barrel42",
    },
    {
        mechanism_id = 900480,
        event_id = 30480,
        source_object_index = 480,
        source_class = "DestructableProp",
        source_name = "Barrel43",
        kind = "destructible_prop",
        hint = "Barrel43",
    },
    {
        mechanism_id = 900481,
        event_id = 30481,
        source_object_index = 481,
        source_class = "DestructableProp",
        source_name = "Barrel46",
        kind = "destructible_prop",
        hint = "Barrel46",
    },
    {
        mechanism_id = 900482,
        event_id = 30482,
        source_object_index = 482,
        source_class = "DestructableProp",
        source_name = "Barrel48",
        kind = "destructible_prop",
        hint = "Barrel48",
    },
    {
        mechanism_id = 900483,
        event_id = 30483,
        source_object_index = 483,
        source_class = "DestructableProp",
        source_name = "Barrel50",
        kind = "destructible_prop",
        hint = "Barrel50",
    },
    {
        mechanism_id = 900484,
        event_id = 30484,
        source_object_index = 484,
        source_class = "DestructableProp",
        source_name = "Barrel51",
        kind = "destructible_prop",
        hint = "Barrel51",
    },
    {
        mechanism_id = 900485,
        event_id = 30485,
        source_object_index = 485,
        source_class = "DestructableProp",
        source_name = "Barrel52",
        kind = "destructible_prop",
        hint = "Barrel52",
    },
    {
        mechanism_id = 900486,
        event_id = 30486,
        source_object_index = 486,
        source_class = "DestructableProp",
        source_name = "Barrel53",
        kind = "destructible_prop",
        hint = "Barrel53",
    },
    {
        mechanism_id = 900487,
        event_id = 30487,
        source_object_index = 487,
        source_class = "DestructableProp",
        source_name = "Barrel56",
        kind = "destructible_prop",
        hint = "Barrel56",
    },
    {
        mechanism_id = 900562,
        event_id = 30562,
        source_object_index = 562,
        source_class = "DestructableProp",
        source_name = "MineCar10",
        kind = "destructible_prop",
        hint = "MineCar10",
    },
    {
        mechanism_id = 900563,
        event_id = 30563,
        source_object_index = 563,
        source_class = "DestructableProp",
        source_name = "MineCar11",
        kind = "destructible_prop",
        hint = "MineCar11",
    },
    {
        mechanism_id = 900564,
        event_id = 30564,
        source_object_index = 564,
        source_class = "DestructableProp",
        source_name = "MineCar15",
        kind = "destructible_prop",
        hint = "MineCar15",
    },
    {
        mechanism_id = 900565,
        event_id = 30565,
        source_object_index = 565,
        source_class = "DestructableProp",
        source_name = "MineCar17",
        kind = "destructible_prop",
        hint = "MineCar17",
    },
    {
        mechanism_id = 900566,
        event_id = 30566,
        source_object_index = 566,
        source_class = "DestructableProp",
        source_name = "MineCar18",
        kind = "destructible_prop",
        hint = "MineCar18",
    },
    {
        mechanism_id = 900567,
        event_id = 30567,
        source_object_index = 567,
        source_class = "DestructableProp",
        source_name = "MineCar19",
        kind = "destructible_prop",
        hint = "MineCar19",
    },
    {
        mechanism_id = 900568,
        event_id = 30568,
        source_object_index = 568,
        source_class = "DestructableProp",
        source_name = "MineCar2",
        kind = "destructible_prop",
        hint = "MineCar2",
    },
    {
        mechanism_id = 900569,
        event_id = 30569,
        source_object_index = 569,
        source_class = "DestructableProp",
        source_name = "MineCar3",
        kind = "destructible_prop",
        hint = "MineCar3",
    },
    {
        mechanism_id = 900570,
        event_id = 30570,
        source_object_index = 570,
        source_class = "DestructableProp",
        source_name = "MineCar6",
        kind = "destructible_prop",
        hint = "MineCar6",
    },
    {
        mechanism_id = 900571,
        event_id = 30571,
        source_object_index = 571,
        source_class = "DestructableProp",
        source_name = "MineCar8",
        kind = "destructible_prop",
        hint = "MineCar8",
    },
    {
        mechanism_id = 900572,
        event_id = 30572,
        source_object_index = 572,
        source_class = "RotatingDoor",
        source_name = "BarWall1",
        kind = "rotating_door",
        hint = "BarWall1",
        sounds = {
            ["open_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/door05open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900573,
        event_id = 30573,
        source_object_index = 573,
        source_class = "RotatingDoor",
        source_name = "BarWall0",
        kind = "rotating_door",
        hint = "BarWall0",
        sounds = {
            ["open_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/door07open.WAV",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900574,
        event_id = 30574,
        source_object_index = 574,
        source_class = "DestructableProp",
        source_name = "Stool",
        kind = "destructible_prop",
        hint = "Stool",
    },
    {
        mechanism_id = 900578,
        event_id = 30578,
        source_object_index = 578,
        source_class = "Door",
        source_name = "deadboltbottom05",
        kind = "linear_door",
        hint = "deadboltbottom05",
    },
    {
        mechanism_id = 900579,
        event_id = 30579,
        source_object_index = 579,
        source_class = "Door",
        source_name = "slidingdoor05",
        kind = "linear_door",
        hint = "slidingdoor05",
        sounds = {
            ["open_busy"] = {
                name = "Events/stonestonescrape03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/stonestonescrape03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900580,
        event_id = 30580,
        source_object_index = 580,
        source_class = "Door",
        source_name = "deadbolttop05",
        kind = "linear_door",
        hint = "deadbolttop05",
    },
    {
        mechanism_id = 900581,
        event_id = 30581,
        source_object_index = 581,
        source_class = "RotatingDoor",
        source_name = "switch05",
        kind = "rotating_door",
        hint = "switch05",
        sounds = {
            ["open_start"] = {
                name = "Events/metalbreak02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/metalbreak02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/lock03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900582,
        event_id = 30582,
        source_object_index = 582,
        source_class = "Door",
        source_name = "handletrigger05",
        kind = "linear_door",
        hint = "handletrigger05",
    },
    {
        mechanism_id = 900584,
        event_id = 30584,
        source_object_index = 584,
        source_class = "Door",
        source_name = "Door0",
        kind = "linear_door",
        hint = "Door0",
        sounds = {
            ["open_start"] = {
                name = "Ambient/metalcreak01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900587,
        event_id = 30587,
        source_object_index = 587,
        source_class = "Door",
        source_name = "Door1",
        kind = "linear_door",
        hint = "Door1",
        sounds = {
            ["open_start"] = {
                name = "Ambient/metalcreak01.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Door/doorslammetal02.wav",
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
        source_name = "Door2",
        kind = "rotating_door",
        hint = "Door2",
        sounds = {
            ["jiggle"] = {
                name = "Door/doorlock02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900590,
        event_id = 30590,
        source_object_index = 590,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor63",
        kind = "rotating_door",
        hint = "RotatingDoor63",
    },
    {
        mechanism_id = 900591,
        event_id = 30591,
        source_object_index = 591,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor62",
        kind = "rotating_door",
        hint = "RotatingDoor62",
    },
    {
        mechanism_id = 900592,
        event_id = 30592,
        source_object_index = 592,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor61",
        kind = "rotating_door",
        hint = "RotatingDoor61",
    },
    {
        mechanism_id = 900593,
        event_id = 30593,
        source_object_index = 593,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900594,
        event_id = 30594,
        source_object_index = 594,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 900595,
        event_id = 30595,
        source_object_index = 595,
        source_class = "DestructableBrush",
        source_name = "CaveIn",
        kind = "destructible_brush",
        hint = "CaveIn",
    },
    {
        mechanism_id = 900596,
        event_id = 30596,
        source_object_index = 596,
        source_class = "ScriptObject",
        source_name = "CaveInControl",
        kind = "script_object",
        hint = "CaveInControl",
    },
    {
        mechanism_id = 900602,
        event_id = 30602,
        source_object_index = 602,
        source_class = "DestructableBrush",
        source_name = "ABMineBoards0",
        kind = "destructible_brush",
        hint = "ABMineBoards0",
    },
    {
        mechanism_id = 900603,
        event_id = 30603,
        source_object_index = 603,
        source_class = "DestructableBrush",
        source_name = "MCarBlocker1",
        kind = "destructible_brush",
        hint = "MCarBlocker1",
    },
    {
        mechanism_id = 900604,
        event_id = 30604,
        source_object_index = 604,
        source_class = "DestructableBrush",
        source_name = "ABMineBoards1",
        kind = "destructible_brush",
        hint = "ABMineBoards1",
    },
    {
        mechanism_id = 900610,
        event_id = 30610,
        source_object_index = 610,
        source_class = "RotatingDoor",
        source_name = "ABDoorBoards0",
        kind = "rotating_door",
        hint = "ABDoorBoards0",
        sounds = {
            ["open_start"] = {
                name = "Door/door01creak.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Door/doorslammetal02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["jiggle"] = {
                name = "Door/door05open.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900611,
        event_id = 30611,
        source_object_index = 611,
        source_class = "RotatingDoor",
        source_name = "FallingBoard0",
        kind = "rotating_door",
        hint = "FallingBoard0",
        sounds = {
            ["open_stop"] = {
                name = "Door/LArgeDoorClose.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 900626,
        event_id = 30626,
        source_object_index = 626,
        source_class = "RotatingDoor",
        source_name = "SteamValve0",
        kind = "rotating_door",
        hint = "SteamValve0",
    },
    {
        mechanism_id = 900637,
        event_id = 30637,
        source_object_index = 637,
        source_class = "DestructableBrush",
        source_name = "TorchHolder0",
        kind = "destructible_brush",
        hint = "TorchHolder0",
    },
    {
        mechanism_id = 900654,
        event_id = 30654,
        source_object_index = 654,
        source_class = "DestructableBrush",
        source_name = "ABMineBoards2",
        kind = "destructible_brush",
        hint = "ABMineBoards2",
    },
    {
        mechanism_id = 900655,
        event_id = 30655,
        source_object_index = 655,
        source_class = "DestructableBrush",
        source_name = "ABMineBoards3",
        kind = "destructible_brush",
        hint = "ABMineBoards3",
    },
    {
        mechanism_id = 900658,
        event_id = 30658,
        source_object_index = 658,
        source_class = "DestructableProp",
        source_name = "DB_Barrel8",
        kind = "destructible_prop",
        hint = "DB_Barrel8",
    },
    {
        mechanism_id = 900659,
        event_id = 30659,
        source_object_index = 659,
        source_class = "DestructableProp",
        source_name = "DB_Barrel9",
        kind = "destructible_prop",
        hint = "DB_Barrel9",
    },
    {
        mechanism_id = 900660,
        event_id = 30660,
        source_object_index = 660,
        source_class = "DestructableProp",
        source_name = "DB_Barrel7",
        kind = "destructible_prop",
        hint = "DB_Barrel7",
    },
    {
        mechanism_id = 900661,
        event_id = 30661,
        source_object_index = 661,
        source_class = "DestructableProp",
        source_name = "DB_Barrel6",
        kind = "destructible_prop",
        hint = "DB_Barrel6",
    },
    {
        mechanism_id = 900662,
        event_id = 30662,
        source_object_index = 662,
        source_class = "DestructableProp",
        source_name = "DB_Barrel5",
        kind = "destructible_prop",
        hint = "DB_Barrel5",
    },
    {
        mechanism_id = 900663,
        event_id = 30663,
        source_object_index = 663,
        source_class = "DestructableProp",
        source_name = "DB_Barrel4",
        kind = "destructible_prop",
        hint = "DB_Barrel4",
    },
    {
        mechanism_id = 900664,
        event_id = 30664,
        source_object_index = 664,
        source_class = "DestructableProp",
        source_name = "DB_Barrel3",
        kind = "destructible_prop",
        hint = "DB_Barrel3",
    },
    {
        mechanism_id = 900665,
        event_id = 30665,
        source_object_index = 665,
        source_class = "DestructableProp",
        source_name = "DB_Barrel0",
        kind = "destructible_prop",
        hint = "DB_Barrel0",
    },
    {
        mechanism_id = 900666,
        event_id = 30666,
        source_object_index = 666,
        source_class = "DestructableProp",
        source_name = "DB_Barrel1",
        kind = "destructible_prop",
        hint = "DB_Barrel1",
    },
    {
        mechanism_id = 900667,
        event_id = 30667,
        source_object_index = 667,
        source_class = "DestructableProp",
        source_name = "DB_Barrel2",
        kind = "destructible_prop",
        hint = "DB_Barrel2",
    },
    {
        mechanism_id = 900675,
        event_id = 30675,
        source_object_index = 675,
        source_class = "DestructableBrush",
        source_name = "TorchHolder1",
        kind = "destructible_brush",
        hint = "TorchHolder1",
    },
    {
        mechanism_id = 900716,
        event_id = 30716,
        source_object_index = 716,
        source_class = "DestructableBrush",
        source_name = "BustOutBrush1",
        kind = "destructible_brush",
        hint = "BustOutBrush1",
    },
    {
        mechanism_id = 900717,
        event_id = 30717,
        source_object_index = 717,
        source_class = "DestructableBrush",
        source_name = "BustOutBrush2",
        kind = "destructible_brush",
        hint = "BustOutBrush2",
    },
    {
        mechanism_id = 900718,
        event_id = 30718,
        source_object_index = 718,
        source_class = "DestructableBrush",
        source_name = "BustOutBrush0",
        kind = "destructible_brush",
        hint = "BustOutBrush0",
    },
    {
        mechanism_id = 900719,
        event_id = 30719,
        source_object_index = 719,
        source_class = "ScriptObject",
        source_name = "SpawnMgr",
        kind = "script_object",
        hint = "SpawnMgr",
    },
    {
        mechanism_id = 900720,
        event_id = 30720,
        source_object_index = 720,
        source_class = "ScriptObject",
        source_name = "SpawnMarker0",
        kind = "script_object",
        hint = "SpawnMarker0",
    },
    {
        mechanism_id = 900721,
        event_id = 30721,
        source_object_index = 721,
        source_class = "ScriptObject",
        source_name = "SpawnMarker1",
        kind = "script_object",
        hint = "SpawnMarker1",
    },
    {
        mechanism_id = 900722,
        event_id = 30722,
        source_object_index = 722,
        source_class = "ScriptObject",
        source_name = "SpawnMarker2",
        kind = "script_object",
        hint = "SpawnMarker2",
    },
    {
        mechanism_id = 900723,
        event_id = 30723,
        source_object_index = 723,
        source_class = "ScriptObject",
        source_name = "SpawnMarker3",
        kind = "script_object",
        hint = "SpawnMarker3",
    },
    {
        mechanism_id = 900724,
        event_id = 30724,
        source_object_index = 724,
        source_class = "ScriptObject",
        source_name = "SpawnMarker4",
        kind = "script_object",
        hint = "SpawnMarker4",
    },
    {
        mechanism_id = 900725,
        event_id = 30725,
        source_object_index = 725,
        source_class = "ScriptObject",
        source_name = "SpawnMarker5",
        kind = "script_object",
        hint = "SpawnMarker5",
    },
    {
        mechanism_id = 900727,
        event_id = 30727,
        source_object_index = 727,
        source_class = "ScriptObject",
        source_name = "SpawnMarker6",
        kind = "script_object",
        hint = "SpawnMarker6",
    },
    {
        mechanism_id = 900755,
        event_id = 30755,
        source_object_index = 755,
        source_class = "ScriptObject",
        source_name = "DWARF_FRIENDLY",
        kind = "script_object",
        hint = "DWARF_FRIENDLY",
    },
    {
        mechanism_id = 900760,
        event_id = 30760,
        source_object_index = 760,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor0",
        kind = "rotating_door",
        hint = "RotatingDoor0",
    },
    {
        mechanism_id = 900761,
        event_id = 30761,
        source_object_index = 761,
        source_class = "ScriptObject",
        source_name = "dw",
        kind = "script_object",
        hint = "dw",
    },
    {
        mechanism_id = 901105,
        event_id = 31105,
        source_object_index = 1105,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 901106,
        event_id = 31106,
        source_object_index = 1106,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 901345,
        event_id = 31345,
        source_object_index = 1345,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush0",
        kind = "destructible_brush",
        hint = "DestructableBrush0",
    },
    {
        mechanism_id = 901346,
        event_id = 31346,
        source_object_index = 1346,
        source_class = "Door",
        source_name = "Stalagtite",
        kind = "linear_door",
        hint = "Stalagtite",
    },
    {
        mechanism_id = 901347,
        event_id = 31347,
        source_object_index = 1347,
        source_class = "DestructableBrush",
        source_name = "CaveWall1",
        kind = "destructible_brush",
        hint = "CaveWall1",
    },
    {
        mechanism_id = 901348,
        event_id = 31348,
        source_object_index = 1348,
        source_class = "DestructableBrush",
        source_name = "CaveWall2",
        kind = "destructible_brush",
        hint = "CaveWall2",
    },
    {
        mechanism_id = 901349,
        event_id = 31349,
        source_object_index = 1349,
        source_class = "DestructableBrush",
        source_name = "CaveWall3",
        kind = "destructible_brush",
        hint = "CaveWall3",
    },
    {
        mechanism_id = 901350,
        event_id = 31350,
        source_object_index = 1350,
        source_class = "DestructableBrush",
        source_name = "CaveWall4",
        kind = "destructible_brush",
        hint = "CaveWall4",
    },
    {
        mechanism_id = 901352,
        event_id = 31352,
        source_object_index = 1352,
        source_class = "DestructableProp",
        source_name = "Crate2",
        kind = "destructible_prop",
        hint = "Crate2",
    },
    {
        mechanism_id = 901353,
        event_id = 31353,
        source_object_index = 1353,
        source_class = "DestructableProp",
        source_name = "Crate3",
        kind = "destructible_prop",
        hint = "Crate3",
    },
    {
        mechanism_id = 901355,
        event_id = 31355,
        source_object_index = 1355,
        source_class = "DestructableProp",
        source_name = "Crate12",
        kind = "destructible_prop",
        hint = "Crate12",
    },
    {
        mechanism_id = 901356,
        event_id = 31356,
        source_object_index = 1356,
        source_class = "DestructableProp",
        source_name = "Crate13",
        kind = "destructible_prop",
        hint = "Crate13",
    },
    {
        mechanism_id = 901357,
        event_id = 31357,
        source_object_index = 1357,
        source_class = "DestructableProp",
        source_name = "Crate14",
        kind = "destructible_prop",
        hint = "Crate14",
    },
    {
        mechanism_id = 901358,
        event_id = 31358,
        source_object_index = 1358,
        source_class = "DestructableProp",
        source_name = "Crate15",
        kind = "destructible_prop",
        hint = "Crate15",
    },
    {
        mechanism_id = 901359,
        event_id = 31359,
        source_object_index = 1359,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 901436,
        event_id = 31436,
        source_object_index = 1436,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush0",
        kind = "perception_brush",
        hint = "PerceptionBrush0",
    },
    {
        mechanism_id = 901437,
        event_id = 31437,
        source_object_index = 1437,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush1",
        kind = "perception_brush",
        hint = "PerceptionBrush1",
    },
    {
        mechanism_id = 901438,
        event_id = 31438,
        source_object_index = 1438,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush10",
        kind = "perception_brush",
        hint = "PerceptionBrush10",
    },
    {
        mechanism_id = 901439,
        event_id = 31439,
        source_object_index = 1439,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush11",
        kind = "perception_brush",
        hint = "PerceptionBrush11",
    },
    {
        mechanism_id = 901440,
        event_id = 31440,
        source_object_index = 1440,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush12",
        kind = "perception_brush",
        hint = "PerceptionBrush12",
    },
    {
        mechanism_id = 901441,
        event_id = 31441,
        source_object_index = 1441,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush2",
        kind = "perception_brush",
        hint = "PerceptionBrush2",
    },
    {
        mechanism_id = 901442,
        event_id = 31442,
        source_object_index = 1442,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush3",
        kind = "perception_brush",
        hint = "PerceptionBrush3",
    },
    {
        mechanism_id = 901443,
        event_id = 31443,
        source_object_index = 1443,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush4",
        kind = "perception_brush",
        hint = "PerceptionBrush4",
    },
    {
        mechanism_id = 901444,
        event_id = 31444,
        source_object_index = 1444,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush5",
        kind = "perception_brush",
        hint = "PerceptionBrush5",
    },
    {
        mechanism_id = 901445,
        event_id = 31445,
        source_object_index = 1445,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush6",
        kind = "perception_brush",
        hint = "PerceptionBrush6",
    },
    {
        mechanism_id = 901446,
        event_id = 31446,
        source_object_index = 1446,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush7",
        kind = "perception_brush",
        hint = "PerceptionBrush7",
    },
    {
        mechanism_id = 901447,
        event_id = 31447,
        source_object_index = 1447,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush8",
        kind = "perception_brush",
        hint = "PerceptionBrush8",
    },
    {
        mechanism_id = 901448,
        event_id = 31448,
        source_object_index = 1448,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush9",
        kind = "perception_brush",
        hint = "PerceptionBrush9",
    },
    {
        mechanism_id = 901449,
        event_id = 31449,
        source_object_index = 1449,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush13",
        kind = "perception_brush",
        hint = "PerceptionBrush13",
    },
    {
        mechanism_id = 901450,
        event_id = 31450,
        source_object_index = 1450,
        source_class = "PerceptionBrush",
        source_name = "PerceptionBrush14",
        kind = "perception_brush",
        hint = "PerceptionBrush14",
    },
    {
        mechanism_id = 901456,
        event_id = 31456,
        source_object_index = 1456,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
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
    [30572] = { kind = "open_door", source = "mm9_mechanism", targetName = "BarWall1" },
    [30573] = { kind = "open_door", source = "mm9_mechanism", targetName = "BarWall0" },
    [30578] = { kind = "open_door", source = "mm9_mechanism", targetName = "deadboltbottom05" },
    [30579] = { kind = "open_door", source = "mm9_mechanism", targetName = "slidingdoor05" },
    [30580] = { kind = "open_door", source = "mm9_mechanism", targetName = "deadbolttop05" },
    [30581] = { kind = "open_door", source = "mm9_mechanism", targetName = "switch05" },
    [30582] = { kind = "open_door", source = "mm9_mechanism", targetName = "handletrigger05" },
    [30584] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door0" },
    [30587] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door1" },
    [30589] = { kind = "open_door", source = "mm9_mechanism", targetName = "Door2" },
    [30590] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor63" },
    [30591] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor62" },
    [30592] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor61" },
    [30610] = { kind = "open_door", source = "mm9_mechanism", targetName = "ABDoorBoards0" },
    [30611] = { kind = "open_door", source = "mm9_mechanism", targetName = "FallingBoard0" },
    [30626] = { kind = "open_door", source = "mm9_mechanism", targetName = "SteamValve0" },
    [30760] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0" },
    [31346] = { kind = "open_door", source = "mm9_mechanism", targetName = "Stalagtite" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(30572, "BarWall1", function()
    map.triggerMechanism(572, 2)
end, "BarWall1")

RegisterEvent(30573, "BarWall0", function()
    map.triggerMechanism(573, 2)
end, "BarWall0")

RegisterEvent(30578, "deadboltbottom05", function()
    map.triggerMechanism(578, 2)
end, "deadboltbottom05")

RegisterEvent(30579, "slidingdoor05", function()
    map.triggerMechanism(579, 2)
end, "slidingdoor05")

RegisterEvent(30580, "deadbolttop05", function()
    map.triggerMechanism(580, 2)
end, "deadbolttop05")

RegisterEvent(30581, "switch05", function()
    map.triggerMechanism(581, 2)
end, "switch05")

RegisterEvent(30582, "handletrigger05", function()
    map.triggerMechanism(582, 2)
end, "handletrigger05")

RegisterEvent(30584, "Door0", function()
    map.triggerMechanism(584, 2)
end, "Door0")

RegisterEvent(30587, "Door1", function()
    map.triggerMechanism(587, 2)
end, "Door1")

RegisterEvent(30589, "Door2", function()
    map.triggerMechanism(589, 2)
end, "Door2")

RegisterEvent(30590, "RotatingDoor63", function()
    map.triggerMechanism(590, 2)
end, "RotatingDoor63")

RegisterEvent(30591, "RotatingDoor62", function()
    map.triggerMechanism(591, 2)
end, "RotatingDoor62")

RegisterEvent(30592, "RotatingDoor61", function()
    map.triggerMechanism(592, 2)
end, "RotatingDoor61")

RegisterEvent(30610, "ABDoorBoards0", function()
    map.triggerMechanism(610, 2)
end, "ABDoorBoards0")

RegisterEvent(30611, "FallingBoard0", function()
    map.triggerMechanism(611, 2)
end, "FallingBoard0")

RegisterEvent(30626, "SteamValve0", function()
    map.triggerMechanism(626, 2)
end, "SteamValve0")

RegisterEvent(30760, "RotatingDoor0", function()
    map.triggerMechanism(760, 2)
end, "RotatingDoor0")

RegisterEvent(31346, "Stalagtite", function()
    map.triggerMechanism(1346, 2)
end, "Stalagtite")

map.scripts["blowuptheboards.scr"] = {
    source = "BLOWUPTHEBOARDS.scr",
    registered_triggers = {
        { line = 37, message = "HitMe", callback = "DoTheDamage" },
    },
    movement_commands = {
    },
}
map.scripts["boardspike.scr"] = {
    source = "BOARDSPIKE.scr",
    registered_triggers = {
        { line = 56, message = "Use", callback = "OnUse" },
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
map.scripts["destructon.scr"] = {
    source = "DESTRUCTON.scr",
    registered_triggers = {
        { line = 37, message = "DamageOn", callback = "OnDamageOn" },
    },
    movement_commands = {
    },
}
map.scripts["dwarvenminer.scr"] = {
    source = "DWARVENMINER.scr",
    registered_triggers = {
        { line = 62, message = "use", callback = "OnRudeEnter" },
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
map.scripts["eboramines.scr"] = {
    source = "EBORAMINES.scr",
    registered_triggers = {
        { line = 98, message = "FreeAtLast", callback = "FreeAtLast" },
    },
    movement_commands = {
    },
}
map.scripts["kingkong.scr"] = {
    source = "KINGKONG.scr",
    registered_triggers = {
        { line = 41, message = "ForceBreak", callback = "RushCage" },
        { line = 42, message = "ForceFall", callback = "FallThrough" },
        { line = 43, message = "ForceAttack", callback = "TurnOff" },
    },
    movement_commands = {
    },
}
map.scripts["mine.scr"] = {
    source = "MINE.scr",
    registered_triggers = {
        { line = 45, message = "Use", callback = "Onuse" },
        { line = 46, message = "destroy", callback = "Onuse" },
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
map.scripts["npc8.scr"] = {
    source = "NPC8.scr",
    registered_triggers = {
        { line = 144, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["npc9.scr"] = {
    source = "NPC9.scr",
    registered_triggers = {
        { line = 126, message = "Use", callback = "OnUse" },
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
map.scripts["shopkeeper.scr"] = {
    source = "SHOPKEEPER.scr",
    registered_triggers = {
        { line = 50, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
        { line = 70, command = "SetPos", arguments = "g_hMyObject -6415 544 4768" },
    },
}
map.scripts["slagbase.scr"] = {
    source = "SLAGBASE.scr",
    registered_triggers = {
        { line = 39, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["slagextractor.scr"] = {
    source = "SLAGEXTRACTOR.scr",
    registered_triggers = {
        { line = 107, message = "Use", callback = "OnUse" },
        { line = 108, message = "Show", callback = "OnShow" },
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
map.scripts["spikedoora.scr"] = {
    source = "SPIKEDOORA.scr",
    registered_triggers = {
        { line = 38, message = "OnePulled", callback = "OnePulled" },
    },
    movement_commands = {
    },
}
map.scripts["spikedoorb.scr"] = {
    source = "SPIKEDOORB.scr",
    registered_triggers = {
        { line = 38, message = "OnePulled", callback = "OnePulled" },
    },
    movement_commands = {
    },
}
map.scripts["spikedooropen.scr"] = {
    source = "SPIKEDOOROPEN.scr",
    registered_triggers = {
        { line = 36, message = "OnePulled", callback = "OnePulled" },
    },
    movement_commands = {
    },
}
map.scripts["thjoradquake.scr"] = {
    source = "THJORADQUAKE.scr",
    registered_triggers = {
    },
    movement_commands = {
        { line = 66, command = "SetPOS", arguments = "hMe, xMe, yMe, zMe" },
    },
}
map.scripts["tm_fallingtorch.scr"] = {
    source = "TM_FALLINGTORCH.scr",
    registered_triggers = {
        { line = 45, message = "Hit", callback = "MoveToMarker" },
    },
    movement_commands = {
        { line = 31, command = "Rotate", arguments = "0, 0, 1, -90, 90, DoNothing" },
        { line = 32, command = "MoveToPos", arguments = "nVarX, nVarY, nVarZ, 180, StopHere" },
    },
}
map.scripts["tm_firstfallingflame.scr"] = {
    source = "TM_FIRSTFALLINGFLAME.scr",
    registered_triggers = {
        { line = 66, message = "Fall", callback = "MoveToMarker" },
    },
    movement_commands = {
        { line = 59, command = "MoveToPos", arguments = "nVarX, nVarY, nVarZ, 250, StopHere" },
    },
}
map.scripts["tm_firstfallingtorch.scr"] = {
    source = "TM_FIRSTFALLINGTORCH.scr",
    registered_triggers = {
        { line = 57, message = "KnockedLoose", callback = "ShortDelay" },
    },
    movement_commands = {
        { line = 43, command = "Rotate", arguments = "0, 0, 1, -90, 90, DoNothing" },
        { line = 44, command = "MoveToPos", arguments = "nVarX, nVarY, nVarZ, 180, StopHere" },
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
map.scripts["tm_minecara.scr"] = {
    source = "TM_MINECARA.scr",
    registered_triggers = {
    },
    movement_commands = {
        { line = 54, command = "MoveToPos", arguments = "nVarX, nVarY, nVarZ, 100, StopHere" },
    },
}
map.scripts["tm_steamwater.scr"] = {
    source = "TM_STEAMWATER.scr",
    registered_triggers = {
        { line = 43, message = "MoveWater", callback = "MoveToMarker" },
        { line = 44, message = "ReturnWater", callback = "MoveBack" },
    },
    movement_commands = {
        { line = 31, command = "MoveToPos", arguments = "nVarX, nVarY, nVarZ, 1500, StopHere" },
        { line = 38, command = "MoveToPos", arguments = "nVarX, nVarY, nVarZ, 2000, DoNothing" },
    },
}
map.scripts["tm_torchflame.scr"] = {
    source = "TM_TORCHFLAME.scr",
    registered_triggers = {
        { line = 170, message = "Fall", callback = "MoveToMarker" },
    },
    movement_commands = {
        { line = 163, command = "MoveToPos", arguments = "nVarX, nVarY, nVarZ, 250, StopHere" },
    },
}

function map.register(ctx)
    if ctx == nil or ctx.registerMm9MapEvents == nil then
        return
    end
    ctx:registerMm9MapEvents(map)
end

return map
