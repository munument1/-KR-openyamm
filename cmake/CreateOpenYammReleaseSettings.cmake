if (NOT DEFINED OPENYAMM_SETTINGS_TEMPLATE OR OPENYAMM_SETTINGS_TEMPLATE STREQUAL "")
    message(FATAL_ERROR "OPENYAMM_SETTINGS_TEMPLATE is required")
endif()

if (NOT DEFINED OPENYAMM_SETTINGS_OUTPUT OR OPENYAMM_SETTINGS_OUTPUT STREQUAL "")
    message(FATAL_ERROR "OPENYAMM_SETTINGS_OUTPUT is required")
endif()

if (NOT DEFINED OPENYAMM_SETTINGS_ASSET_ROOT)
    message(FATAL_ERROR "OPENYAMM_SETTINGS_ASSET_ROOT is required")
endif()

if (NOT EXISTS "${OPENYAMM_SETTINGS_TEMPLATE}")
    message(FATAL_ERROR "Release settings template does not exist: ${OPENYAMM_SETTINGS_TEMPLATE}")
endif()

file(READ "${OPENYAMM_SETTINGS_TEMPLATE}" openyammSettingsTemplate)
string(REPLACE "\r\n" "\n" openyammSettingsTemplate "${openyammSettingsTemplate}")
string(REPLACE "\r" "\n" openyammSettingsTemplate "${openyammSettingsTemplate}")
string(REPLACE ";" "\\;" openyammSettingsTemplateForList "${openyammSettingsTemplate}")
string(REPLACE "\n" ";" openyammSettingsLines "${openyammSettingsTemplateForList}")

set(openyammSettingsOutput "")
set(openyammSettingsInAssetsSection FALSE)
set(openyammSettingsSawAssetsSection FALSE)
set(openyammSettingsWroteAssetRoot FALSE)

foreach(openyammSettingsLine IN LISTS openyammSettingsLines)
    set(openyammSettingsOutputLine "${openyammSettingsLine}")
    string(STRIP "${openyammSettingsLine}" openyammSettingsStrippedLine)

    if (openyammSettingsStrippedLine MATCHES "^\\[[^]]+\\]$")
        if (openyammSettingsInAssetsSection AND NOT openyammSettingsWroteAssetRoot)
            string(APPEND openyammSettingsOutput "root=${OPENYAMM_SETTINGS_ASSET_ROOT}\n")
            set(openyammSettingsWroteAssetRoot TRUE)
        endif()

        set(openyammSettingsInAssetsSection FALSE)

        if (openyammSettingsStrippedLine STREQUAL "[assets]")
            set(openyammSettingsInAssetsSection TRUE)
            set(openyammSettingsSawAssetsSection TRUE)
        endif()
    elseif (openyammSettingsInAssetsSection AND openyammSettingsStrippedLine MATCHES "^root[ \t]*=")
        set(openyammSettingsOutputLine "root=${OPENYAMM_SETTINGS_ASSET_ROOT}")
        set(openyammSettingsWroteAssetRoot TRUE)
    endif()

    string(APPEND openyammSettingsOutput "${openyammSettingsOutputLine}\n")
endforeach()

if (openyammSettingsInAssetsSection AND NOT openyammSettingsWroteAssetRoot)
    string(APPEND openyammSettingsOutput "root=${OPENYAMM_SETTINGS_ASSET_ROOT}\n")
    set(openyammSettingsWroteAssetRoot TRUE)
endif()

if (NOT openyammSettingsSawAssetsSection)
    string(APPEND openyammSettingsOutput "\n[assets]\nroot=${OPENYAMM_SETTINGS_ASSET_ROOT}\n")
endif()

get_filename_component(openyammSettingsOutputDir "${OPENYAMM_SETTINGS_OUTPUT}" DIRECTORY)
file(MAKE_DIRECTORY "${openyammSettingsOutputDir}")
file(WRITE "${OPENYAMM_SETTINGS_OUTPUT}" "${openyammSettingsOutput}")
