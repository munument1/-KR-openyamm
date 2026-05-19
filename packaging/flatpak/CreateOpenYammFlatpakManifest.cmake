if (NOT DEFINED OPENYAMM_FLATPAK_MANIFEST_TEMPLATE OR OPENYAMM_FLATPAK_MANIFEST_TEMPLATE STREQUAL "")
    message(FATAL_ERROR "OPENYAMM_FLATPAK_MANIFEST_TEMPLATE is required")
endif()

if (NOT DEFINED OPENYAMM_FLATPAK_MANIFEST_OUTPUT OR OPENYAMM_FLATPAK_MANIFEST_OUTPUT STREQUAL "")
    message(FATAL_ERROR "OPENYAMM_FLATPAK_MANIFEST_OUTPUT is required")
endif()

if (NOT DEFINED OPENYAMM_FLATPAK_SOURCE_DIR OR OPENYAMM_FLATPAK_SOURCE_DIR STREQUAL "")
    message(FATAL_ERROR "OPENYAMM_FLATPAK_SOURCE_DIR is required")
endif()

file(READ "${OPENYAMM_FLATPAK_MANIFEST_TEMPLATE}" openyammFlatpakManifest)
file(TO_CMAKE_PATH "${OPENYAMM_FLATPAK_SOURCE_DIR}" openyammFlatpakSourceDir)
string(REPLACE "\\" "\\\\" openyammFlatpakSourceDir "${openyammFlatpakSourceDir}")
string(REPLACE "path: ../../build/flatpak/source" "path: ${openyammFlatpakSourceDir}" openyammFlatpakManifest
    "${openyammFlatpakManifest}")

get_filename_component(openyammFlatpakManifestOutputDir "${OPENYAMM_FLATPAK_MANIFEST_OUTPUT}" DIRECTORY)
file(MAKE_DIRECTORY "${openyammFlatpakManifestOutputDir}")
file(WRITE "${OPENYAMM_FLATPAK_MANIFEST_OUTPUT}" "${openyammFlatpakManifest}")
