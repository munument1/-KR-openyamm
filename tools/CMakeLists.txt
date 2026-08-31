add_executable(openyamm_event_asset_export
    event_asset_export_main.cpp
    EventIr.cpp
    EventIrLegacyImport.cpp
    LegacyLuaExport.cpp
    legacy_events/EvtProgram.cpp
    ../game/indoor/IndoorMapData.cpp
    ../game/items/ItemEnchantTables.cpp
    ../game/maps/MapIdentity.cpp
    ../game/party/SkillData.cpp
    ../game/tables/HouseTable.cpp
    ../game/tables/ItemTable.cpp
    ../game/tables/MapStats.cpp
    ../game/tables/MergedBaseTables.cpp
    legacy_events/StrTable.cpp
)

target_include_directories(openyamm_event_asset_export
    PRIVATE
        ${CMAKE_SOURCE_DIR}
)

target_link_libraries(openyamm_event_asset_export
    PRIVATE
        openyamm_engine
        yaml-cpp::yaml-cpp
)

target_compile_features(openyamm_event_asset_export PRIVATE cxx_std_20)

FetchContent_GetProperties(bgfx SOURCE_DIR OPENYAMM_BGFX_FETCH_SOURCE_DIR)

add_executable(mm9_compile_indoor_source
    mm9_compile_indoor_source_main.cpp
    ../editor/document/IndoorGeometryMetadata.cpp
    ../editor/import/IndoorSourceGeometryCompiler.cpp
    ../editor/import/ObjModelImport.cpp
    ../game/indoor/IndoorGeometryUtils.cpp
    ../game/indoor/IndoorMapData.cpp
    ../game/indoor/IndoorPortalGraph.cpp
    ../game/maps/MapDeltaData.cpp
)

target_include_directories(mm9_compile_indoor_source
    PRIVATE
        ${CMAKE_SOURCE_DIR}
        ${OPENYAMM_BGFX_FETCH_SOURCE_DIR}/3rdparty
)

target_link_libraries(mm9_compile_indoor_source
    PRIVATE
        openyamm_engine
        yaml-cpp::yaml-cpp
)

target_compile_features(mm9_compile_indoor_source PRIVATE cxx_std_20)
