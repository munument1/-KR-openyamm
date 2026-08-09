-- generated from MM9 event sidecars; do not edit by hand
local map = {}
map.map_id = "lichlab"
map.scripts = {}

map.start_points = {
    {
        start_index = 0,
        source_object_index = 529,
        source_name = "StartPoint0",
        x = -1311,
        y = -4362,
        z = 1475,
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
        mechanism_id = 900613,
        event_id = 30613,
        source_object_index = 613,
        source_class = "AIBarrier",
        source_name = "AIBarrier0",
        kind = "ai_barrier",
        hint = "AIBarrier0",
    },
    {
        mechanism_id = 900996,
        event_id = 30996,
        source_object_index = 996,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush0",
        kind = "collision_volume",
        hint = "InvisibleBrush0",
    },
    {
        mechanism_id = 900997,
        event_id = 30997,
        source_object_index = 997,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush1",
        kind = "collision_volume",
        hint = "InvisibleBrush1",
    },
    {
        mechanism_id = 901035,
        event_id = 31035,
        source_object_index = 1035,
        source_class = "AIBarrier",
        source_name = "AIBarrier1",
        kind = "ai_barrier",
        hint = "AIBarrier1",
    },
    {
        mechanism_id = 901036,
        event_id = 31036,
        source_object_index = 1036,
        source_class = "AIBarrier",
        source_name = "AIBarrier10",
        kind = "ai_barrier",
        hint = "AIBarrier10",
    },
    {
        mechanism_id = 901037,
        event_id = 31037,
        source_object_index = 1037,
        source_class = "AIBarrier",
        source_name = "AIBarrier11",
        kind = "ai_barrier",
        hint = "AIBarrier11",
    },
    {
        mechanism_id = 901038,
        event_id = 31038,
        source_object_index = 1038,
        source_class = "AIBarrier",
        source_name = "AIBarrier12",
        kind = "ai_barrier",
        hint = "AIBarrier12",
    },
    {
        mechanism_id = 901039,
        event_id = 31039,
        source_object_index = 1039,
        source_class = "AIBarrier",
        source_name = "AIBarrier2",
        kind = "ai_barrier",
        hint = "AIBarrier2",
    },
    {
        mechanism_id = 901040,
        event_id = 31040,
        source_object_index = 1040,
        source_class = "AIBarrier",
        source_name = "AIBarrier3",
        kind = "ai_barrier",
        hint = "AIBarrier3",
    },
    {
        mechanism_id = 901041,
        event_id = 31041,
        source_object_index = 1041,
        source_class = "AIBarrier",
        source_name = "AIBarrier4",
        kind = "ai_barrier",
        hint = "AIBarrier4",
    },
    {
        mechanism_id = 901042,
        event_id = 31042,
        source_object_index = 1042,
        source_class = "AIBarrier",
        source_name = "AIBarrier5",
        kind = "ai_barrier",
        hint = "AIBarrier5",
    },
    {
        mechanism_id = 901043,
        event_id = 31043,
        source_object_index = 1043,
        source_class = "AIBarrier",
        source_name = "AIBarrier6",
        kind = "ai_barrier",
        hint = "AIBarrier6",
    },
    {
        mechanism_id = 901044,
        event_id = 31044,
        source_object_index = 1044,
        source_class = "AIBarrier",
        source_name = "AIBarrier7",
        kind = "ai_barrier",
        hint = "AIBarrier7",
    },
    {
        mechanism_id = 901045,
        event_id = 31045,
        source_object_index = 1045,
        source_class = "AIBarrier",
        source_name = "AIBarrier8",
        kind = "ai_barrier",
        hint = "AIBarrier8",
    },
    {
        mechanism_id = 901046,
        event_id = 31046,
        source_object_index = 1046,
        source_class = "AIBarrier",
        source_name = "AIBarrier9",
        kind = "ai_barrier",
        hint = "AIBarrier9",
    },
    {
        mechanism_id = 901047,
        event_id = 31047,
        source_object_index = 1047,
        source_class = "AIBarrier",
        source_name = "AIBarrier13",
        kind = "ai_barrier",
        hint = "AIBarrier13",
    },
    {
        mechanism_id = 901048,
        event_id = 31048,
        source_object_index = 1048,
        source_class = "AIBarrier",
        source_name = "AIBarrier14",
        kind = "ai_barrier",
        hint = "AIBarrier14",
    },
    {
        mechanism_id = 901049,
        event_id = 31049,
        source_object_index = 1049,
        source_class = "AIBarrier",
        source_name = "AIBarrier15",
        kind = "ai_barrier",
        hint = "AIBarrier15",
    },
    {
        mechanism_id = 901050,
        event_id = 31050,
        source_object_index = 1050,
        source_class = "AIBarrier",
        source_name = "AIBarrier16",
        kind = "ai_barrier",
        hint = "AIBarrier16",
    },
    {
        mechanism_id = 901088,
        event_id = 31088,
        source_object_index = 1088,
        source_class = "ScriptObject",
        source_name = "PromoTrigger",
        kind = "script_object",
        hint = "PromoTrigger",
    },
    {
        mechanism_id = 901204,
        event_id = 31204,
        source_object_index = 1204,
        source_class = "Shooter",
        source_name = "fireball1",
        kind = "shooter",
        hint = "fireball1",
    },
    {
        mechanism_id = 901206,
        event_id = 31206,
        source_object_index = 1206,
        source_class = "Shooter",
        source_name = "fireball2",
        kind = "shooter",
        hint = "fireball2",
    },
    {
        mechanism_id = 901208,
        event_id = 31208,
        source_object_index = 1208,
        source_class = "Shooter",
        source_name = "shootfire1",
        kind = "shooter",
        hint = "shootfire1",
    },
    {
        mechanism_id = 901209,
        event_id = 31209,
        source_object_index = 1209,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush19",
        kind = "destructible_brush",
        hint = "DestructableBrush19",
    },
    {
        mechanism_id = 901210,
        event_id = 31210,
        source_object_index = 1210,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush16",
        kind = "destructible_brush",
        hint = "DestructableBrush16",
    },
    {
        mechanism_id = 901211,
        event_id = 31211,
        source_object_index = 1211,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush6",
        kind = "destructible_brush",
        hint = "DestructableBrush6",
    },
    {
        mechanism_id = 901212,
        event_id = 31212,
        source_object_index = 1212,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush52",
        kind = "collision_volume",
        hint = "InvisibleBrush52",
    },
    {
        mechanism_id = 901213,
        event_id = 31213,
        source_object_index = 1213,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush53",
        kind = "collision_volume",
        hint = "InvisibleBrush53",
    },
    {
        mechanism_id = 901214,
        event_id = 31214,
        source_object_index = 1214,
        source_class = "AIBarrier",
        source_name = "AIBarrier39",
        kind = "ai_barrier",
        hint = "AIBarrier39",
    },
    {
        mechanism_id = 901215,
        event_id = 31215,
        source_object_index = 1215,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush46",
        kind = "collision_volume",
        hint = "InvisibleBrush46",
    },
    {
        mechanism_id = 901216,
        event_id = 31216,
        source_object_index = 1216,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush47",
        kind = "collision_volume",
        hint = "InvisibleBrush47",
    },
    {
        mechanism_id = 901217,
        event_id = 31217,
        source_object_index = 1217,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush44",
        kind = "collision_volume",
        hint = "InvisibleBrush44",
    },
    {
        mechanism_id = 901218,
        event_id = 31218,
        source_object_index = 1218,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush45",
        kind = "collision_volume",
        hint = "InvisibleBrush45",
    },
    {
        mechanism_id = 901219,
        event_id = 31219,
        source_object_index = 1219,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush50",
        kind = "collision_volume",
        hint = "InvisibleBrush50",
    },
    {
        mechanism_id = 901220,
        event_id = 31220,
        source_object_index = 1220,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush51",
        kind = "collision_volume",
        hint = "InvisibleBrush51",
    },
    {
        mechanism_id = 901221,
        event_id = 31221,
        source_object_index = 1221,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush34",
        kind = "collision_volume",
        hint = "InvisibleBrush34",
    },
    {
        mechanism_id = 901222,
        event_id = 31222,
        source_object_index = 1222,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush35",
        kind = "collision_volume",
        hint = "InvisibleBrush35",
    },
    {
        mechanism_id = 901223,
        event_id = 31223,
        source_object_index = 1223,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush42",
        kind = "collision_volume",
        hint = "InvisibleBrush42",
    },
    {
        mechanism_id = 901224,
        event_id = 31224,
        source_object_index = 1224,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush43",
        kind = "collision_volume",
        hint = "InvisibleBrush43",
    },
    {
        mechanism_id = 901225,
        event_id = 31225,
        source_object_index = 1225,
        source_class = "AIBarrier",
        source_name = "AIBarrier40",
        kind = "ai_barrier",
        hint = "AIBarrier40",
    },
    {
        mechanism_id = 901226,
        event_id = 31226,
        source_object_index = 1226,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush48",
        kind = "collision_volume",
        hint = "InvisibleBrush48",
    },
    {
        mechanism_id = 901227,
        event_id = 31227,
        source_object_index = 1227,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush49",
        kind = "collision_volume",
        hint = "InvisibleBrush49",
    },
    {
        mechanism_id = 901228,
        event_id = 31228,
        source_object_index = 1228,
        source_class = "AIBarrier",
        source_name = "AIBarrier35",
        kind = "ai_barrier",
        hint = "AIBarrier35",
    },
    {
        mechanism_id = 901229,
        event_id = 31229,
        source_object_index = 1229,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush38",
        kind = "collision_volume",
        hint = "InvisibleBrush38",
    },
    {
        mechanism_id = 901230,
        event_id = 31230,
        source_object_index = 1230,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush39",
        kind = "collision_volume",
        hint = "InvisibleBrush39",
    },
    {
        mechanism_id = 901231,
        event_id = 31231,
        source_object_index = 1231,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush40",
        kind = "collision_volume",
        hint = "InvisibleBrush40",
    },
    {
        mechanism_id = 901232,
        event_id = 31232,
        source_object_index = 1232,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush41",
        kind = "collision_volume",
        hint = "InvisibleBrush41",
    },
    {
        mechanism_id = 901233,
        event_id = 31233,
        source_object_index = 1233,
        source_class = "AIBarrier",
        source_name = "AIBarrier34",
        kind = "ai_barrier",
        hint = "AIBarrier34",
    },
    {
        mechanism_id = 901234,
        event_id = 31234,
        source_object_index = 1234,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush36",
        kind = "collision_volume",
        hint = "InvisibleBrush36",
    },
    {
        mechanism_id = 901235,
        event_id = 31235,
        source_object_index = 1235,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush37",
        kind = "collision_volume",
        hint = "InvisibleBrush37",
    },
    {
        mechanism_id = 901236,
        event_id = 31236,
        source_object_index = 1236,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush32",
        kind = "collision_volume",
        hint = "InvisibleBrush32",
    },
    {
        mechanism_id = 901237,
        event_id = 31237,
        source_object_index = 1237,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush33",
        kind = "collision_volume",
        hint = "InvisibleBrush33",
    },
    {
        mechanism_id = 901238,
        event_id = 31238,
        source_object_index = 1238,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush30",
        kind = "collision_volume",
        hint = "InvisibleBrush30",
    },
    {
        mechanism_id = 901239,
        event_id = 31239,
        source_object_index = 1239,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush31",
        kind = "collision_volume",
        hint = "InvisibleBrush31",
    },
    {
        mechanism_id = 901240,
        event_id = 31240,
        source_object_index = 1240,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush28",
        kind = "collision_volume",
        hint = "InvisibleBrush28",
    },
    {
        mechanism_id = 901241,
        event_id = 31241,
        source_object_index = 1241,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush29",
        kind = "collision_volume",
        hint = "InvisibleBrush29",
    },
    {
        mechanism_id = 901242,
        event_id = 31242,
        source_object_index = 1242,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush26",
        kind = "collision_volume",
        hint = "InvisibleBrush26",
    },
    {
        mechanism_id = 901243,
        event_id = 31243,
        source_object_index = 1243,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush27",
        kind = "collision_volume",
        hint = "InvisibleBrush27",
    },
    {
        mechanism_id = 901244,
        event_id = 31244,
        source_object_index = 1244,
        source_class = "AIBarrier",
        source_name = "AIBarrier28",
        kind = "ai_barrier",
        hint = "AIBarrier28",
    },
    {
        mechanism_id = 901245,
        event_id = 31245,
        source_object_index = 1245,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush24",
        kind = "collision_volume",
        hint = "InvisibleBrush24",
    },
    {
        mechanism_id = 901246,
        event_id = 31246,
        source_object_index = 1246,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush25",
        kind = "collision_volume",
        hint = "InvisibleBrush25",
    },
    {
        mechanism_id = 901247,
        event_id = 31247,
        source_object_index = 1247,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush22",
        kind = "collision_volume",
        hint = "InvisibleBrush22",
    },
    {
        mechanism_id = 901248,
        event_id = 31248,
        source_object_index = 1248,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush23",
        kind = "collision_volume",
        hint = "InvisibleBrush23",
    },
    {
        mechanism_id = 901249,
        event_id = 31249,
        source_object_index = 1249,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush20",
        kind = "collision_volume",
        hint = "InvisibleBrush20",
    },
    {
        mechanism_id = 901250,
        event_id = 31250,
        source_object_index = 1250,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush21",
        kind = "collision_volume",
        hint = "InvisibleBrush21",
    },
    {
        mechanism_id = 901251,
        event_id = 31251,
        source_object_index = 1251,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush18",
        kind = "collision_volume",
        hint = "InvisibleBrush18",
    },
    {
        mechanism_id = 901252,
        event_id = 31252,
        source_object_index = 1252,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush19",
        kind = "collision_volume",
        hint = "InvisibleBrush19",
    },
    {
        mechanism_id = 901253,
        event_id = 31253,
        source_object_index = 1253,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush16",
        kind = "collision_volume",
        hint = "InvisibleBrush16",
    },
    {
        mechanism_id = 901254,
        event_id = 31254,
        source_object_index = 1254,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush17",
        kind = "collision_volume",
        hint = "InvisibleBrush17",
    },
    {
        mechanism_id = 901255,
        event_id = 31255,
        source_object_index = 1255,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush15",
        kind = "collision_volume",
        hint = "InvisibleBrush15",
    },
    {
        mechanism_id = 901256,
        event_id = 31256,
        source_object_index = 1256,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush14",
        kind = "collision_volume",
        hint = "InvisibleBrush14",
    },
    {
        mechanism_id = 901257,
        event_id = 31257,
        source_object_index = 1257,
        source_class = "AIBarrier",
        source_name = "AIBarrier22",
        kind = "ai_barrier",
        hint = "AIBarrier22",
    },
    {
        mechanism_id = 901258,
        event_id = 31258,
        source_object_index = 1258,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush12",
        kind = "collision_volume",
        hint = "InvisibleBrush12",
    },
    {
        mechanism_id = 901259,
        event_id = 31259,
        source_object_index = 1259,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush13",
        kind = "collision_volume",
        hint = "InvisibleBrush13",
    },
    {
        mechanism_id = 901260,
        event_id = 31260,
        source_object_index = 1260,
        source_class = "AIBarrier",
        source_name = "AIBarrier21",
        kind = "ai_barrier",
        hint = "AIBarrier21",
    },
    {
        mechanism_id = 901261,
        event_id = 31261,
        source_object_index = 1261,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush10",
        kind = "collision_volume",
        hint = "InvisibleBrush10",
    },
    {
        mechanism_id = 901262,
        event_id = 31262,
        source_object_index = 1262,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush11",
        kind = "collision_volume",
        hint = "InvisibleBrush11",
    },
    {
        mechanism_id = 901263,
        event_id = 31263,
        source_object_index = 1263,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush9",
        kind = "collision_volume",
        hint = "InvisibleBrush9",
    },
    {
        mechanism_id = 901264,
        event_id = 31264,
        source_object_index = 1264,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush8",
        kind = "collision_volume",
        hint = "InvisibleBrush8",
    },
    {
        mechanism_id = 901265,
        event_id = 31265,
        source_object_index = 1265,
        source_class = "AIBarrier",
        source_name = "AIBarrier20",
        kind = "ai_barrier",
        hint = "AIBarrier20",
    },
    {
        mechanism_id = 901266,
        event_id = 31266,
        source_object_index = 1266,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush6",
        kind = "collision_volume",
        hint = "InvisibleBrush6",
    },
    {
        mechanism_id = 901267,
        event_id = 31267,
        source_object_index = 1267,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush7",
        kind = "collision_volume",
        hint = "InvisibleBrush7",
    },
    {
        mechanism_id = 901268,
        event_id = 31268,
        source_object_index = 1268,
        source_class = "AIBarrier",
        source_name = "AIBarrier18",
        kind = "ai_barrier",
        hint = "AIBarrier18",
    },
    {
        mechanism_id = 901269,
        event_id = 31269,
        source_object_index = 1269,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush4",
        kind = "collision_volume",
        hint = "InvisibleBrush4",
    },
    {
        mechanism_id = 901270,
        event_id = 31270,
        source_object_index = 1270,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush5",
        kind = "collision_volume",
        hint = "InvisibleBrush5",
    },
    {
        mechanism_id = 901271,
        event_id = 31271,
        source_object_index = 1271,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush3",
        kind = "collision_volume",
        hint = "InvisibleBrush3",
    },
    {
        mechanism_id = 901272,
        event_id = 31272,
        source_object_index = 1272,
        source_class = "InvisibleBrush",
        source_name = "InvisibleBrush2",
        kind = "collision_volume",
        hint = "InvisibleBrush2",
    },
    {
        mechanism_id = 901273,
        event_id = 31273,
        source_object_index = 1273,
        source_class = "AIBarrier",
        source_name = "AIBarrier17",
        kind = "ai_barrier",
        hint = "AIBarrier17",
    },
    {
        mechanism_id = 901275,
        event_id = 31275,
        source_object_index = 1275,
        source_class = "DestructableBrush",
        source_name = "DB2",
        kind = "destructible_brush",
        hint = "DB2",
    },
    {
        mechanism_id = 901276,
        event_id = 31276,
        source_object_index = 1276,
        source_class = "DestructableBrush",
        source_name = "breakwindow2",
        kind = "destructible_brush",
        hint = "breakwindow2",
    },
    {
        mechanism_id = 901277,
        event_id = 31277,
        source_object_index = 1277,
        source_class = "DestructableBrush",
        source_name = "DB1",
        kind = "destructible_brush",
        hint = "DB1",
    },
    {
        mechanism_id = 901278,
        event_id = 31278,
        source_object_index = 1278,
        source_class = "DestructableBrush",
        source_name = "breakwindow1",
        kind = "destructible_brush",
        hint = "breakwindow1",
    },
    {
        mechanism_id = 901287,
        event_id = 31287,
        source_object_index = 1287,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor0",
        kind = "rotating_door",
        hint = "RotatingDoor0",
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
        mechanism_id = 901288,
        event_id = 31288,
        source_object_index = 1288,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor146",
        kind = "rotating_door",
        hint = "RotatingDoor146",
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
        mechanism_id = 901289,
        event_id = 31289,
        source_object_index = 1289,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor131",
        kind = "rotating_door",
        hint = "RotatingDoor131",
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
        mechanism_id = 901290,
        event_id = 31290,
        source_object_index = 1290,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor130",
        kind = "rotating_door",
        hint = "RotatingDoor130",
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
        mechanism_id = 901291,
        event_id = 31291,
        source_object_index = 1291,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor166",
        kind = "rotating_door",
        hint = "RotatingDoor166",
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
        mechanism_id = 901292,
        event_id = 31292,
        source_object_index = 1292,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor165",
        kind = "rotating_door",
        hint = "RotatingDoor165",
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
        mechanism_id = 901293,
        event_id = 31293,
        source_object_index = 1293,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor189",
        kind = "rotating_door",
        hint = "RotatingDoor189",
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
        mechanism_id = 901294,
        event_id = 31294,
        source_object_index = 1294,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor188",
        kind = "rotating_door",
        hint = "RotatingDoor188",
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
        mechanism_id = 901295,
        event_id = 31295,
        source_object_index = 1295,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor136",
        kind = "rotating_door",
        hint = "RotatingDoor136",
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
        mechanism_id = 901296,
        event_id = 31296,
        source_object_index = 1296,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor137",
        kind = "rotating_door",
        hint = "RotatingDoor137",
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
        mechanism_id = 901297,
        event_id = 31297,
        source_object_index = 1297,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor135",
        kind = "rotating_door",
        hint = "RotatingDoor135",
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
        mechanism_id = 901298,
        event_id = 31298,
        source_object_index = 1298,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor134",
        kind = "rotating_door",
        hint = "RotatingDoor134",
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
        mechanism_id = 901299,
        event_id = 31299,
        source_object_index = 1299,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor152",
        kind = "rotating_door",
        hint = "RotatingDoor152",
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
        mechanism_id = 901300,
        event_id = 31300,
        source_object_index = 1300,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor151",
        kind = "rotating_door",
        hint = "RotatingDoor151",
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
        mechanism_id = 901301,
        event_id = 31301,
        source_object_index = 1301,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor154",
        kind = "rotating_door",
        hint = "RotatingDoor154",
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
        mechanism_id = 901302,
        event_id = 31302,
        source_object_index = 1302,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor153",
        kind = "rotating_door",
        hint = "RotatingDoor153",
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
        mechanism_id = 901303,
        event_id = 31303,
        source_object_index = 1303,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor173",
        kind = "rotating_door",
        hint = "RotatingDoor173",
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
        mechanism_id = 901304,
        event_id = 31304,
        source_object_index = 1304,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor174",
        kind = "rotating_door",
        hint = "RotatingDoor174",
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
        mechanism_id = 901305,
        event_id = 31305,
        source_object_index = 1305,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor156",
        kind = "rotating_door",
        hint = "RotatingDoor156",
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
        mechanism_id = 901306,
        event_id = 31306,
        source_object_index = 1306,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor155",
        kind = "rotating_door",
        hint = "RotatingDoor155",
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
        mechanism_id = 901307,
        event_id = 31307,
        source_object_index = 1307,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor148",
        kind = "rotating_door",
        hint = "RotatingDoor148",
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
        mechanism_id = 901308,
        event_id = 31308,
        source_object_index = 1308,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor147",
        kind = "rotating_door",
        hint = "RotatingDoor147",
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
        mechanism_id = 901309,
        event_id = 31309,
        source_object_index = 1309,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor195",
        kind = "rotating_door",
        hint = "RotatingDoor195",
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
        mechanism_id = 901310,
        event_id = 31310,
        source_object_index = 1310,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor191",
        kind = "rotating_door",
        hint = "RotatingDoor191",
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
        mechanism_id = 901311,
        event_id = 31311,
        source_object_index = 1311,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor190",
        kind = "rotating_door",
        hint = "RotatingDoor190",
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
        mechanism_id = 901312,
        event_id = 31312,
        source_object_index = 1312,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor162",
        kind = "rotating_door",
        hint = "RotatingDoor162",
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
        mechanism_id = 901313,
        event_id = 31313,
        source_object_index = 1313,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor161",
        kind = "rotating_door",
        hint = "RotatingDoor161",
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
        mechanism_id = 901314,
        event_id = 31314,
        source_object_index = 1314,
        source_class = "DestructableBrush",
        source_name = "RotatingDoor168",
        kind = "destructible_brush",
        hint = "RotatingDoor168",
    },
    {
        mechanism_id = 901315,
        event_id = 31315,
        source_object_index = 1315,
        source_class = "DestructableBrush",
        source_name = "RotatingDoor167",
        kind = "destructible_brush",
        hint = "RotatingDoor167",
    },
    {
        mechanism_id = 901316,
        event_id = 31316,
        source_object_index = 1316,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor163",
        kind = "rotating_door",
        hint = "RotatingDoor163",
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
        mechanism_id = 901317,
        event_id = 31317,
        source_object_index = 1317,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor164",
        kind = "rotating_door",
        hint = "RotatingDoor164",
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
        mechanism_id = 901318,
        event_id = 31318,
        source_object_index = 1318,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor203",
        kind = "rotating_door",
        hint = "RotatingDoor203",
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
        mechanism_id = 901319,
        event_id = 31319,
        source_object_index = 1319,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor202",
        kind = "rotating_door",
        hint = "RotatingDoor202",
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
        mechanism_id = 901320,
        event_id = 31320,
        source_object_index = 1320,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor194",
        kind = "rotating_door",
        hint = "RotatingDoor194",
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
        mechanism_id = 901321,
        event_id = 31321,
        source_object_index = 1321,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor187",
        kind = "rotating_door",
        hint = "RotatingDoor187",
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
        mechanism_id = 901322,
        event_id = 31322,
        source_object_index = 1322,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor192",
        kind = "rotating_door",
        hint = "RotatingDoor192",
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
        mechanism_id = 901323,
        event_id = 31323,
        source_object_index = 1323,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor177",
        kind = "rotating_door",
        hint = "RotatingDoor177",
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
        mechanism_id = 901324,
        event_id = 31324,
        source_object_index = 1324,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor175",
        kind = "rotating_door",
        hint = "RotatingDoor175",
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
        mechanism_id = 901325,
        event_id = 31325,
        source_object_index = 1325,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor185",
        kind = "rotating_door",
        hint = "RotatingDoor185",
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
        mechanism_id = 901326,
        event_id = 31326,
        source_object_index = 1326,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor149",
        kind = "rotating_door",
        hint = "RotatingDoor149",
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
        mechanism_id = 901327,
        event_id = 31327,
        source_object_index = 1327,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor150",
        kind = "rotating_door",
        hint = "RotatingDoor150",
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
        mechanism_id = 901328,
        event_id = 31328,
        source_object_index = 1328,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor182",
        kind = "rotating_door",
        hint = "RotatingDoor182",
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
        mechanism_id = 901329,
        event_id = 31329,
        source_object_index = 1329,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor184",
        kind = "rotating_door",
        hint = "RotatingDoor184",
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
        mechanism_id = 901330,
        event_id = 31330,
        source_object_index = 1330,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor183",
        kind = "rotating_door",
        hint = "RotatingDoor183",
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
        mechanism_id = 901331,
        event_id = 31331,
        source_object_index = 1331,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor193",
        kind = "rotating_door",
        hint = "RotatingDoor193",
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
        mechanism_id = 901332,
        event_id = 31332,
        source_object_index = 1332,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor172",
        kind = "rotating_door",
        hint = "RotatingDoor172",
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
        mechanism_id = 901333,
        event_id = 31333,
        source_object_index = 1333,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor171",
        kind = "rotating_door",
        hint = "RotatingDoor171",
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
        mechanism_id = 901334,
        event_id = 31334,
        source_object_index = 1334,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor170",
        kind = "rotating_door",
        hint = "RotatingDoor170",
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
        mechanism_id = 901335,
        event_id = 31335,
        source_object_index = 1335,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor169",
        kind = "rotating_door",
        hint = "RotatingDoor169",
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
        mechanism_id = 901336,
        event_id = 31336,
        source_object_index = 1336,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor176",
        kind = "rotating_door",
        hint = "RotatingDoor176",
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
        mechanism_id = 901337,
        event_id = 31337,
        source_object_index = 1337,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor138",
        kind = "rotating_door",
        hint = "RotatingDoor138",
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
        mechanism_id = 901338,
        event_id = 31338,
        source_object_index = 1338,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor139",
        kind = "rotating_door",
        hint = "RotatingDoor139",
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
        mechanism_id = 901339,
        event_id = 31339,
        source_object_index = 1339,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor186",
        kind = "rotating_door",
        hint = "RotatingDoor186",
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
        mechanism_id = 901340,
        event_id = 31340,
        source_object_index = 1340,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor200",
        kind = "rotating_door",
        hint = "RotatingDoor200",
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
        mechanism_id = 901341,
        event_id = 31341,
        source_object_index = 1341,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor201",
        kind = "rotating_door",
        hint = "RotatingDoor201",
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
        mechanism_id = 901342,
        event_id = 31342,
        source_object_index = 1342,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor199",
        kind = "rotating_door",
        hint = "RotatingDoor199",
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
        mechanism_id = 901343,
        event_id = 31343,
        source_object_index = 1343,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor198",
        kind = "rotating_door",
        hint = "RotatingDoor198",
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
        mechanism_id = 901344,
        event_id = 31344,
        source_object_index = 1344,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor179",
        kind = "rotating_door",
        hint = "RotatingDoor179",
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
        mechanism_id = 901345,
        event_id = 31345,
        source_object_index = 1345,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor178",
        kind = "rotating_door",
        hint = "RotatingDoor178",
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
        mechanism_id = 901346,
        event_id = 31346,
        source_object_index = 1346,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor181",
        kind = "rotating_door",
        hint = "RotatingDoor181",
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
        mechanism_id = 901347,
        event_id = 31347,
        source_object_index = 1347,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor180",
        kind = "rotating_door",
        hint = "RotatingDoor180",
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
        mechanism_id = 901348,
        event_id = 31348,
        source_object_index = 1348,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor197",
        kind = "rotating_door",
        hint = "RotatingDoor197",
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
        mechanism_id = 901349,
        event_id = 31349,
        source_object_index = 1349,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor196",
        kind = "rotating_door",
        hint = "RotatingDoor196",
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
        mechanism_id = 901350,
        event_id = 31350,
        source_object_index = 1350,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor157",
        kind = "rotating_door",
        hint = "RotatingDoor157",
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
        mechanism_id = 901351,
        event_id = 31351,
        source_object_index = 1351,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor158",
        kind = "rotating_door",
        hint = "RotatingDoor158",
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
        mechanism_id = 901352,
        event_id = 31352,
        source_object_index = 1352,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor128",
        kind = "rotating_door",
        hint = "RotatingDoor128",
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
        mechanism_id = 901353,
        event_id = 31353,
        source_object_index = 1353,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor129",
        kind = "rotating_door",
        hint = "RotatingDoor129",
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
        mechanism_id = 901354,
        event_id = 31354,
        source_object_index = 1354,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor160",
        kind = "rotating_door",
        hint = "RotatingDoor160",
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
        mechanism_id = 901355,
        event_id = 31355,
        source_object_index = 1355,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor159",
        kind = "rotating_door",
        hint = "RotatingDoor159",
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
        mechanism_id = 901357,
        event_id = 31357,
        source_object_index = 1357,
        source_class = "BlueWater",
        source_name = "BlueWater0",
        kind = "water_volume",
        hint = "BlueWater0",
    },
    {
        mechanism_id = 901358,
        event_id = 31358,
        source_object_index = 1358,
        source_class = "BlueWater",
        source_name = "BlueWater2",
        kind = "water_volume",
        hint = "BlueWater2",
    },
    {
        mechanism_id = 901359,
        event_id = 31359,
        source_object_index = 1359,
        source_class = "BlueWater",
        source_name = "BlueWater3",
        kind = "water_volume",
        hint = "BlueWater3",
    },
    {
        mechanism_id = 901360,
        event_id = 31360,
        source_object_index = 1360,
        source_class = "BlueWater",
        source_name = "BlueWater1",
        kind = "water_volume",
        hint = "BlueWater1",
    },
    {
        mechanism_id = 901361,
        event_id = 31361,
        source_object_index = 1361,
        source_class = "Door",
        source_name = "Enginedoor2",
        kind = "linear_door",
        hint = "Enginedoor2",
    },
    {
        mechanism_id = 901362,
        event_id = 31362,
        source_object_index = 1362,
        source_class = "Door",
        source_name = "Enginedoor3",
        kind = "linear_door",
        hint = "Enginedoor3",
    },
    {
        mechanism_id = 901363,
        event_id = 31363,
        source_object_index = 1363,
        source_class = "Door",
        source_name = "Enginedoor4",
        kind = "linear_door",
        hint = "Enginedoor4",
    },
    {
        mechanism_id = 901364,
        event_id = 31364,
        source_object_index = 1364,
        source_class = "Door",
        source_name = "Engineglass2",
        kind = "linear_door",
        hint = "Engineglass2",
    },
    {
        mechanism_id = 901365,
        event_id = 31365,
        source_object_index = 1365,
        source_class = "Door",
        source_name = "Engineglass3",
        kind = "linear_door",
        hint = "Engineglass3",
    },
    {
        mechanism_id = 901366,
        event_id = 31366,
        source_object_index = 1366,
        source_class = "Door",
        source_name = "Engineglass4",
        kind = "linear_door",
        hint = "Engineglass4",
    },
    {
        mechanism_id = 901367,
        event_id = 31367,
        source_object_index = 1367,
        source_class = "Door",
        source_name = "Enginedoor1",
        kind = "linear_door",
        hint = "Enginedoor1",
        sounds = {
            ["open_start"] = {
                name = "Events/steam_burst02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Events/drawbridge02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/steam_burst03.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/steam_burst02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_busy"] = {
                name = "Events/drawbridge02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_stop"] = {
                name = "Events/steam_burst04.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901368,
        event_id = 31368,
        source_object_index = 1368,
        source_class = "Door",
        source_name = "Engineglass1",
        kind = "linear_door",
        hint = "Engineglass1",
        sounds = {
            ["close_stop"] = {
                name = "Events/steam_burst04.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901371,
        event_id = 31371,
        source_object_index = 1371,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor1",
        kind = "rotating_door",
        hint = "RotatingDoor1",
    },
    {
        mechanism_id = 901645,
        event_id = 31645,
        source_object_index = 1645,
        source_class = "ScriptObject",
        source_name = "GhostPool0",
        kind = "script_object",
        hint = "GhostPool0",
    },
    {
        mechanism_id = 901646,
        event_id = 31646,
        source_object_index = 1646,
        source_class = "ScriptObject",
        source_name = "GhostPool1",
        kind = "script_object",
        hint = "GhostPool1",
    },
    {
        mechanism_id = 901647,
        event_id = 31647,
        source_object_index = 1647,
        source_class = "ScriptObject",
        source_name = "GhostPool2",
        kind = "script_object",
        hint = "GhostPool2",
    },
    {
        mechanism_id = 901648,
        event_id = 31648,
        source_object_index = 1648,
        source_class = "ScriptObject",
        source_name = "GhostPool3",
        kind = "script_object",
        hint = "GhostPool3",
    },
    {
        mechanism_id = 901649,
        event_id = 31649,
        source_object_index = 1649,
        source_class = "ScriptObject",
        source_name = "SpawnMgr",
        kind = "script_object",
        hint = "SpawnMgr",
    },
    {
        mechanism_id = 901652,
        event_id = 31652,
        source_object_index = 1652,
        source_class = "ScriptObject",
        source_name = "SkeletonTransformer",
        kind = "script_object",
        hint = "SkeletonTransformer",
    },
    {
        mechanism_id = 901656,
        event_id = 31656,
        source_object_index = 1656,
        source_class = "Shooter",
        source_name = "ShooterTransform0",
        kind = "shooter",
        hint = "ShooterTransform0",
    },
    {
        mechanism_id = 901657,
        event_id = 31657,
        source_object_index = 1657,
        source_class = "Shooter",
        source_name = "ShooterTransform1",
        kind = "shooter",
        hint = "ShooterTransform1",
    },
    {
        mechanism_id = 901658,
        event_id = 31658,
        source_object_index = 1658,
        source_class = "Shooter",
        source_name = "ShooterTransform2",
        kind = "shooter",
        hint = "ShooterTransform2",
    },
    {
        mechanism_id = 901659,
        event_id = 31659,
        source_object_index = 1659,
        source_class = "Door",
        source_name = "skeletondoora",
        kind = "linear_door",
        hint = "skeletondoora",
        sounds = {
            ["open_start"] = {
                name = "Events/gears02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/slam.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/gears02.wav",
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
            ["close_stop"] = {
                name = "Events/slam.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901662,
        event_id = 31662,
        source_object_index = 1662,
        source_class = "RotatingDoor",
        source_name = "peasant door",
        kind = "rotating_door",
        hint = "peasant door",
    },
    {
        mechanism_id = 901680,
        event_id = 31680,
        source_object_index = 1680,
        source_class = "Door",
        source_name = "skeletondoora0",
        kind = "linear_door",
        hint = "skeletondoora0",
        sounds = {
            ["open_start"] = {
                name = "Events/gears02.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_busy"] = {
                name = "Events/boulderroll.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["open_stop"] = {
                name = "Events/slam.wav",
                x = 0,
                y = 0,
                z = 0,
            },
            ["close_start"] = {
                name = "Events/gears02.wav",
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
            ["close_stop"] = {
                name = "Events/slam.wav",
                x = 0,
                y = 0,
                z = 0,
            },
        },
    },
    {
        mechanism_id = 901683,
        event_id = 31683,
        source_object_index = 1683,
        source_class = "Shooter",
        source_name = "ShooterTransform3",
        kind = "shooter",
        hint = "ShooterTransform3",
    },
    {
        mechanism_id = 901684,
        event_id = 31684,
        source_object_index = 1684,
        source_class = "Shooter",
        source_name = "ShooterTransform4",
        kind = "shooter",
        hint = "ShooterTransform4",
    },
    {
        mechanism_id = 901685,
        event_id = 31685,
        source_object_index = 1685,
        source_class = "Shooter",
        source_name = "ShooterTransform5",
        kind = "shooter",
        hint = "ShooterTransform5",
    },
    {
        mechanism_id = 901687,
        event_id = 31687,
        source_object_index = 1687,
        source_class = "ScriptObject",
        source_name = "SkeletonTransformer0",
        kind = "script_object",
        hint = "SkeletonTransformer0",
    },
    {
        mechanism_id = 901689,
        event_id = 31689,
        source_object_index = 1689,
        source_class = "DestructableBrush",
        source_name = "DestructableBrush1",
        kind = "destructible_brush",
        hint = "DestructableBrush1",
    },
    {
        mechanism_id = 901691,
        event_id = 31691,
        source_object_index = 1691,
        source_class = "RotatingDoor",
        source_name = "peasant door0",
        kind = "rotating_door",
        hint = "peasant door0",
    },
    {
        mechanism_id = 901692,
        event_id = 31692,
        source_object_index = 1692,
        source_class = "RotatingDoor",
        source_name = "RotatingDoor58",
        kind = "rotating_door",
        hint = "RotatingDoor58",
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
    [31287] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor0" },
    [31288] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor146" },
    [31289] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor131" },
    [31290] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor130" },
    [31291] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor166" },
    [31292] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor165" },
    [31293] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor189" },
    [31294] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor188" },
    [31295] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor136" },
    [31296] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor137" },
    [31297] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor135" },
    [31298] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor134" },
    [31299] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor152" },
    [31300] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor151" },
    [31301] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor154" },
    [31302] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor153" },
    [31303] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor173" },
    [31304] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor174" },
    [31305] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor156" },
    [31306] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor155" },
    [31307] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor148" },
    [31308] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor147" },
    [31309] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor195" },
    [31310] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor191" },
    [31311] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor190" },
    [31312] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor162" },
    [31313] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor161" },
    [31316] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor163" },
    [31317] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor164" },
    [31318] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor203" },
    [31319] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor202" },
    [31320] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor194" },
    [31321] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor187" },
    [31322] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor192" },
    [31323] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor177" },
    [31324] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor175" },
    [31325] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor185" },
    [31326] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor149" },
    [31327] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor150" },
    [31328] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor182" },
    [31329] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor184" },
    [31330] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor183" },
    [31331] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor193" },
    [31332] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor172" },
    [31333] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor171" },
    [31334] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor170" },
    [31335] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor169" },
    [31336] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor176" },
    [31337] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor138" },
    [31338] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor139" },
    [31339] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor186" },
    [31340] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor200" },
    [31341] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor201" },
    [31342] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor199" },
    [31343] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor198" },
    [31344] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor179" },
    [31345] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor178" },
    [31346] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor181" },
    [31347] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor180" },
    [31348] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor197" },
    [31349] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor196" },
    [31350] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor157" },
    [31351] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor158" },
    [31352] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor128" },
    [31353] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor129" },
    [31354] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor160" },
    [31355] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor159" },
    [31361] = { kind = "open_door", source = "mm9_mechanism", targetName = "Enginedoor2" },
    [31362] = { kind = "open_door", source = "mm9_mechanism", targetName = "Enginedoor3" },
    [31363] = { kind = "open_door", source = "mm9_mechanism", targetName = "Enginedoor4" },
    [31364] = { kind = "open_door", source = "mm9_mechanism", targetName = "Engineglass2" },
    [31365] = { kind = "open_door", source = "mm9_mechanism", targetName = "Engineglass3" },
    [31366] = { kind = "open_door", source = "mm9_mechanism", targetName = "Engineglass4" },
    [31367] = { kind = "open_door", source = "mm9_mechanism", targetName = "Enginedoor1" },
    [31368] = { kind = "open_door", source = "mm9_mechanism", targetName = "Engineglass1" },
    [31371] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor1" },
    [31659] = { kind = "open_door", source = "mm9_mechanism", targetName = "skeletondoora" },
    [31662] = { kind = "open_door", source = "mm9_mechanism", targetName = "peasant door" },
    [31680] = { kind = "open_door", source = "mm9_mechanism", targetName = "skeletondoora0" },
    [31691] = { kind = "open_door", source = "mm9_mechanism", targetName = "peasant door0" },
    [31692] = { kind = "open_door", source = "mm9_mechanism", targetName = "RotatingDoor58" },
    },
    textureNames = {},
    spriteNames = {},
    castSpellIds = {},
    timers = {},
})

RegisterEvent(31287, "RotatingDoor0", function()
    map.triggerMechanism(1287, 2)
end, "RotatingDoor0")

RegisterEvent(31288, "RotatingDoor146", function()
    map.triggerMechanism(1288, 2)
end, "RotatingDoor146")

RegisterEvent(31289, "RotatingDoor131", function()
    map.triggerMechanism(1289, 2)
end, "RotatingDoor131")

RegisterEvent(31290, "RotatingDoor130", function()
    map.triggerMechanism(1290, 2)
end, "RotatingDoor130")

RegisterEvent(31291, "RotatingDoor166", function()
    map.triggerMechanism(1291, 2)
end, "RotatingDoor166")

RegisterEvent(31292, "RotatingDoor165", function()
    map.triggerMechanism(1292, 2)
end, "RotatingDoor165")

RegisterEvent(31293, "RotatingDoor189", function()
    map.triggerMechanism(1293, 2)
end, "RotatingDoor189")

RegisterEvent(31294, "RotatingDoor188", function()
    map.triggerMechanism(1294, 2)
end, "RotatingDoor188")

RegisterEvent(31295, "RotatingDoor136", function()
    map.triggerMechanism(1295, 2)
end, "RotatingDoor136")

RegisterEvent(31296, "RotatingDoor137", function()
    map.triggerMechanism(1296, 2)
end, "RotatingDoor137")

RegisterEvent(31297, "RotatingDoor135", function()
    map.triggerMechanism(1297, 2)
end, "RotatingDoor135")

RegisterEvent(31298, "RotatingDoor134", function()
    map.triggerMechanism(1298, 2)
end, "RotatingDoor134")

RegisterEvent(31299, "RotatingDoor152", function()
    map.triggerMechanism(1299, 2)
end, "RotatingDoor152")

RegisterEvent(31300, "RotatingDoor151", function()
    map.triggerMechanism(1300, 2)
end, "RotatingDoor151")

RegisterEvent(31301, "RotatingDoor154", function()
    map.triggerMechanism(1301, 2)
end, "RotatingDoor154")

RegisterEvent(31302, "RotatingDoor153", function()
    map.triggerMechanism(1302, 2)
end, "RotatingDoor153")

RegisterEvent(31303, "RotatingDoor173", function()
    map.triggerMechanism(1303, 2)
end, "RotatingDoor173")

RegisterEvent(31304, "RotatingDoor174", function()
    map.triggerMechanism(1304, 2)
end, "RotatingDoor174")

RegisterEvent(31305, "RotatingDoor156", function()
    map.triggerMechanism(1305, 2)
end, "RotatingDoor156")

RegisterEvent(31306, "RotatingDoor155", function()
    map.triggerMechanism(1306, 2)
end, "RotatingDoor155")

RegisterEvent(31307, "RotatingDoor148", function()
    map.triggerMechanism(1307, 2)
end, "RotatingDoor148")

RegisterEvent(31308, "RotatingDoor147", function()
    map.triggerMechanism(1308, 2)
end, "RotatingDoor147")

RegisterEvent(31309, "RotatingDoor195", function()
    map.triggerMechanism(1309, 2)
end, "RotatingDoor195")

RegisterEvent(31310, "RotatingDoor191", function()
    map.triggerMechanism(1310, 2)
end, "RotatingDoor191")

RegisterEvent(31311, "RotatingDoor190", function()
    map.triggerMechanism(1311, 2)
end, "RotatingDoor190")

RegisterEvent(31312, "RotatingDoor162", function()
    map.triggerMechanism(1312, 2)
end, "RotatingDoor162")

RegisterEvent(31313, "RotatingDoor161", function()
    map.triggerMechanism(1313, 2)
end, "RotatingDoor161")

RegisterEvent(31316, "RotatingDoor163", function()
    map.triggerMechanism(1316, 2)
end, "RotatingDoor163")

RegisterEvent(31317, "RotatingDoor164", function()
    map.triggerMechanism(1317, 2)
end, "RotatingDoor164")

RegisterEvent(31318, "RotatingDoor203", function()
    map.triggerMechanism(1318, 2)
end, "RotatingDoor203")

RegisterEvent(31319, "RotatingDoor202", function()
    map.triggerMechanism(1319, 2)
end, "RotatingDoor202")

RegisterEvent(31320, "RotatingDoor194", function()
    map.triggerMechanism(1320, 2)
end, "RotatingDoor194")

RegisterEvent(31321, "RotatingDoor187", function()
    map.triggerMechanism(1321, 2)
end, "RotatingDoor187")

RegisterEvent(31322, "RotatingDoor192", function()
    map.triggerMechanism(1322, 2)
end, "RotatingDoor192")

RegisterEvent(31323, "RotatingDoor177", function()
    map.triggerMechanism(1323, 2)
end, "RotatingDoor177")

RegisterEvent(31324, "RotatingDoor175", function()
    map.triggerMechanism(1324, 2)
end, "RotatingDoor175")

RegisterEvent(31325, "RotatingDoor185", function()
    map.triggerMechanism(1325, 2)
end, "RotatingDoor185")

RegisterEvent(31326, "RotatingDoor149", function()
    map.triggerMechanism(1326, 2)
end, "RotatingDoor149")

RegisterEvent(31327, "RotatingDoor150", function()
    map.triggerMechanism(1327, 2)
end, "RotatingDoor150")

RegisterEvent(31328, "RotatingDoor182", function()
    map.triggerMechanism(1328, 2)
end, "RotatingDoor182")

RegisterEvent(31329, "RotatingDoor184", function()
    map.triggerMechanism(1329, 2)
end, "RotatingDoor184")

RegisterEvent(31330, "RotatingDoor183", function()
    map.triggerMechanism(1330, 2)
end, "RotatingDoor183")

RegisterEvent(31331, "RotatingDoor193", function()
    map.triggerMechanism(1331, 2)
end, "RotatingDoor193")

RegisterEvent(31332, "RotatingDoor172", function()
    map.triggerMechanism(1332, 2)
end, "RotatingDoor172")

RegisterEvent(31333, "RotatingDoor171", function()
    map.triggerMechanism(1333, 2)
end, "RotatingDoor171")

RegisterEvent(31334, "RotatingDoor170", function()
    map.triggerMechanism(1334, 2)
end, "RotatingDoor170")

RegisterEvent(31335, "RotatingDoor169", function()
    map.triggerMechanism(1335, 2)
end, "RotatingDoor169")

RegisterEvent(31336, "RotatingDoor176", function()
    map.triggerMechanism(1336, 2)
end, "RotatingDoor176")

RegisterEvent(31337, "RotatingDoor138", function()
    map.triggerMechanism(1337, 2)
end, "RotatingDoor138")

RegisterEvent(31338, "RotatingDoor139", function()
    map.triggerMechanism(1338, 2)
end, "RotatingDoor139")

RegisterEvent(31339, "RotatingDoor186", function()
    map.triggerMechanism(1339, 2)
end, "RotatingDoor186")

RegisterEvent(31340, "RotatingDoor200", function()
    map.triggerMechanism(1340, 2)
end, "RotatingDoor200")

RegisterEvent(31341, "RotatingDoor201", function()
    map.triggerMechanism(1341, 2)
end, "RotatingDoor201")

RegisterEvent(31342, "RotatingDoor199", function()
    map.triggerMechanism(1342, 2)
end, "RotatingDoor199")

RegisterEvent(31343, "RotatingDoor198", function()
    map.triggerMechanism(1343, 2)
end, "RotatingDoor198")

RegisterEvent(31344, "RotatingDoor179", function()
    map.triggerMechanism(1344, 2)
end, "RotatingDoor179")

RegisterEvent(31345, "RotatingDoor178", function()
    map.triggerMechanism(1345, 2)
end, "RotatingDoor178")

RegisterEvent(31346, "RotatingDoor181", function()
    map.triggerMechanism(1346, 2)
end, "RotatingDoor181")

RegisterEvent(31347, "RotatingDoor180", function()
    map.triggerMechanism(1347, 2)
end, "RotatingDoor180")

RegisterEvent(31348, "RotatingDoor197", function()
    map.triggerMechanism(1348, 2)
end, "RotatingDoor197")

RegisterEvent(31349, "RotatingDoor196", function()
    map.triggerMechanism(1349, 2)
end, "RotatingDoor196")

RegisterEvent(31350, "RotatingDoor157", function()
    map.triggerMechanism(1350, 2)
end, "RotatingDoor157")

RegisterEvent(31351, "RotatingDoor158", function()
    map.triggerMechanism(1351, 2)
end, "RotatingDoor158")

RegisterEvent(31352, "RotatingDoor128", function()
    map.triggerMechanism(1352, 2)
end, "RotatingDoor128")

RegisterEvent(31353, "RotatingDoor129", function()
    map.triggerMechanism(1353, 2)
end, "RotatingDoor129")

RegisterEvent(31354, "RotatingDoor160", function()
    map.triggerMechanism(1354, 2)
end, "RotatingDoor160")

RegisterEvent(31355, "RotatingDoor159", function()
    map.triggerMechanism(1355, 2)
end, "RotatingDoor159")

RegisterEvent(31361, "Enginedoor2", function()
    map.triggerMechanism(1361, 2)
end, "Enginedoor2")

RegisterEvent(31362, "Enginedoor3", function()
    map.triggerMechanism(1362, 2)
end, "Enginedoor3")

RegisterEvent(31363, "Enginedoor4", function()
    map.triggerMechanism(1363, 2)
end, "Enginedoor4")

RegisterEvent(31364, "Engineglass2", function()
    map.triggerMechanism(1364, 2)
end, "Engineglass2")

RegisterEvent(31365, "Engineglass3", function()
    map.triggerMechanism(1365, 2)
end, "Engineglass3")

RegisterEvent(31366, "Engineglass4", function()
    map.triggerMechanism(1366, 2)
end, "Engineglass4")

RegisterEvent(31367, "Enginedoor1", function()
    map.triggerMechanism(1367, 2)
end, "Enginedoor1")

RegisterEvent(31368, "Engineglass1", function()
    map.triggerMechanism(1368, 2)
end, "Engineglass1")

RegisterEvent(31371, "RotatingDoor1", function()
    map.triggerMechanism(1371, 2)
end, "RotatingDoor1")

RegisterEvent(31659, "skeletondoora", function()
    map.triggerMechanism(1659, 2)
end, "skeletondoora")

RegisterEvent(31662, "peasant door", function()
    map.triggerMechanism(1662, 2)
end, "peasant door")

RegisterEvent(31680, "skeletondoora0", function()
    map.triggerMechanism(1680, 2)
end, "skeletondoora0")

RegisterEvent(31691, "peasant door0", function()
    map.triggerMechanism(1691, 2)
end, "peasant door0")

RegisterEvent(31692, "RotatingDoor58", function()
    map.triggerMechanism(1692, 2)
end, "RotatingDoor58")

map.scripts["autoresurrect.scr"] = {
    source = "AUTORESURRECT.scr",
    registered_triggers = {
        { line = 83, message = "TMSG_RESURRECT", callback = "OnResurrect" },
    },
    movement_commands = {
    },
}
map.scripts["book.scr"] = {
    source = "BOOK.scr",
    registered_triggers = {
        { line = 50, message = "Use", callback = "OnUse" },
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
map.scripts["converter.scr"] = {
    source = "CONVERTER.scr",
    registered_triggers = {
        { line = 59, message = "create", callback = "SpawnCreature" },
        { line = 60, message = "convert", callback = "TransformCreature" },
        { line = 105, message = "create", callback = "SpawnCreature" },
    },
    movement_commands = {
    },
}
map.scripts["elixircook.scr"] = {
    source = "ELIXIRCOOK.scr",
    registered_triggers = {
        { line = 45, message = "Use", callback = "OnUse" },
    },
    movement_commands = {
    },
}
map.scripts["giveelixir.scr"] = {
    source = "GIVEELIXIR.scr",
    registered_triggers = {
        { line = 48, message = "Use", callback = "OnUse" },
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
map.scripts["ilshealerroom.scr"] = {
    source = "ILSHEALERROOM.scr",
    registered_triggers = {
        { line = 206, message = "open", callback = "Onopen" },
        { line = 207, message = "close", callback = "Onclose" },
        { line = 208, message = "Fix", callback = "OnFix" },
    },
    movement_commands = {
    },
}
map.scripts["ilsshootingbook.scr"] = {
    source = "ILSSHOOTINGBOOK.scr",
    registered_triggers = {
        { line = 69, message = "Use", callback = "OnUse" },
        { line = 70, message = "Done", callback = "OnDone" },
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
map.scripts["lichengineprop.scr"] = {
    source = "LICHENGINEPROP.scr",
    registered_triggers = {
        { line = 11, message = "start", callback = "PowerUp" },
        { line = 29, message = "finish", callback = "PowerDown" },
        { line = 47, message = "start", callback = "PowerUp" },
    },
    movement_commands = {
    },
}
map.scripts["ll_flyingcreature.scr"] = {
    source = "LL_FLYINGCREATURE.scr",
    registered_triggers = {
        { line = 89, message = "Go", callback = "Triggered" },
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
map.scripts["summoner.scr"] = {
    source = "SUMMONER.scr",
    registered_triggers = {
        { line = 53, message = "trigger", callback = "OnMinionDied" },
        { line = 54, message = "startup", callback = "SummonStarters" },
    },
    movement_commands = {
    },
}
map.scripts["switch.scr"] = {
    source = "SWITCH.scr",
    registered_triggers = {
        { line = 44, message = "Use", callback = "Onuse" },
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
