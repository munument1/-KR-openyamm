get_filename_component(OPENYAMM_REPO_ROOT "${CMAKE_CURRENT_LIST_DIR}/../../../../.." ABSOLUTE)

add_library(main SHARED
    openyamm_android_entry.cpp
)

target_include_directories(main
    PRIVATE
        "${OPENYAMM_REPO_ROOT}"
)

target_compile_features(main PRIVATE cxx_std_20)
target_link_libraries(main PRIVATE openyamm_game SDL3::SDL3 log)
