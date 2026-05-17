include_guard(GLOBAL)

function(openyamm_bgfx_shader_platform outputVariable)
    if (ANDROID)
        set(shaderPlatform "android")
    elseif (WIN32)
        set(shaderPlatform "windows")
    elseif (APPLE)
        set(shaderPlatform "osx")
    else()
        set(shaderPlatform "linux")
    endif()

    set(${outputVariable} "${shaderPlatform}" PARENT_SCOPE)
endfunction()

function(openyamm_bgfx_shader_profile outputVariable)
    if (ANDROID)
        set(shaderProfile "100_es")
    else()
        set(shaderProfile "120")
    endif()

    set(${outputVariable} "${shaderProfile}" PARENT_SCOPE)
endfunction()

function(openyamm_bgfx_shader_directory outputVariable)
    if (ANDROID)
        set(shaderDirectory "essl")
    else()
        set(shaderDirectory "glsl")
    endif()

    set(${outputVariable} "${shaderDirectory}" PARENT_SCOPE)
endfunction()

function(openyamm_copy_runtime_shader sourcePath outputName)
    openyamm_bgfx_shader_directory(shaderDirectory)

    add_custom_command(
        OUTPUT "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/${outputName}"
        COMMAND ${CMAKE_COMMAND} -E make_directory "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${sourcePath}"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/${outputName}"
        DEPENDS "${sourcePath}"
        VERBATIM
    )
endfunction()

function(openyamm_compile_bgfx_shader sourcePath shaderType outputName)
    openyamm_bgfx_shader_platform(shaderPlatform)
    openyamm_bgfx_shader_profile(shaderProfile)
    openyamm_bgfx_shader_directory(shaderDirectory)

    if (NOT TARGET openyamm_shaderc)
        message(FATAL_ERROR "openyamm_shaderc target is unavailable; set OPENYAMM_HOST_SHADERC when cross-compiling.")
    endif()

    add_custom_command(
        OUTPUT "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/${outputName}"
        COMMAND ${CMAKE_COMMAND} -E make_directory "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}"
        COMMAND "$<TARGET_FILE:openyamm_shaderc>"
            --platform "${shaderPlatform}"
            -p "${shaderProfile}"
            --type "${shaderType}"
            --varyingdef "${CMAKE_SOURCE_DIR}/game/shaders/varying.def.sc"
            -i "${CMAKE_SOURCE_DIR}/game/shaders"
            -i "${OPENYAMM_BGFX_SOURCE_DIR}/src"
            -i "${OPENYAMM_BGFX_SOURCE_DIR}/examples/common"
            -f "${sourcePath}"
            -o "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/${outputName}"
        DEPENDS
            "${sourcePath}"
            "${CMAKE_SOURCE_DIR}/game/shaders/varying.def.sc"
            "${OPENYAMM_BGFX_SOURCE_DIR}/examples/common/common.sh"
            openyamm_shaderc
        VERBATIM
    )
endfunction()

function(openyamm_configure_bgfx_runtime)
    file(GLOB openyammAstcEncoderSources "${OPENYAMM_BIMG_SOURCE_DIR}/3rdparty/astc-encoder/source/*.cpp")
    set(openyammBxSources
        ${OPENYAMM_BX_SOURCE_DIR}/src/allocator.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/bounds.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/bx.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/commandline.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/crtnone.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/debug.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/dtoa.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/easing.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/file.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/filepath.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/hash.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/math.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/mutex.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/os.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/process.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/semaphore.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/settings.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/sort.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/string.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/thread.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/timer.cpp
        ${OPENYAMM_BX_SOURCE_DIR}/src/url.cpp
    )

    if (NOT TARGET openyamm_bgfx)
        find_package(Threads REQUIRED)

        if (NOT ANDROID)
            find_package(OpenGL REQUIRED)
        endif()

        if (UNIX AND NOT APPLE AND NOT ANDROID)
            find_package(X11 REQUIRED)
        endif()

        add_library(openyamm_bgfx STATIC
            ${OPENYAMM_BGFX_SOURCE_DIR}/src/bgfx.cpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/src/debug_renderdoc.cpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/src/glcontext_egl.cpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/src/glcontext_wgl.cpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/src/renderer_agc.cpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/src/renderer_d3d11.cpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/src/renderer_d3d12.cpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/src/renderer_gl.cpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/src/renderer_gnm.cpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/src/renderer_noop.cpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/src/renderer_nvn.cpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/src/renderer_vk.cpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/src/renderer_webgpu.cpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/src/shader.cpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/src/shader_spirv.cpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/src/topology.cpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/src/vertexlayout.cpp
            ${openyammBxSources}
            ${OPENYAMM_BIMG_SOURCE_DIR}/src/image.cpp
            ${OPENYAMM_BIMG_SOURCE_DIR}/src/image_cubemap_filter.cpp
            ${OPENYAMM_BIMG_SOURCE_DIR}/src/image_decode.cpp
            ${OPENYAMM_BIMG_SOURCE_DIR}/src/image_encode.cpp
            ${OPENYAMM_BIMG_SOURCE_DIR}/src/image_gnf.cpp
            ${openyammAstcEncoderSources}
        )

        target_include_directories(openyamm_bgfx
            PUBLIC
                ${OPENYAMM_BGFX_SOURCE_DIR}/include
                ${OPENYAMM_BX_SOURCE_DIR}/include
                ${OPENYAMM_BIMG_SOURCE_DIR}/include
            PRIVATE
                ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty
                ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/khronos
                ${OPENYAMM_BIMG_SOURCE_DIR}/3rdparty
                ${OPENYAMM_BIMG_SOURCE_DIR}/3rdparty/astc-encoder/include
                ${OPENYAMM_BIMG_SOURCE_DIR}/3rdparty/iqa/include
                ${OPENYAMM_BIMG_SOURCE_DIR}/3rdparty/tinyexr/deps
                ${OPENYAMM_BX_SOURCE_DIR}/3rdparty
        )

        target_compile_features(openyamm_bgfx PUBLIC cxx_std_20)
        if (ANDROID)
            set(openyammBgfxOpenGlVersion 0)
            set(openyammBgfxOpenGlesVersion 30)
            set(openyammBgfxDebug 0)
        else()
            set(openyammBgfxOpenGlVersion 33)
            set(openyammBgfxOpenGlesVersion 0)
            set(openyammBgfxDebug "$<IF:$<CONFIG:Debug>,1,0>")
        endif()

        target_compile_definitions(openyamm_bgfx
            PUBLIC
                BX_CONFIG_DEBUG=${openyammBgfxDebug}
            PRIVATE
                BGFX_CONFIG_RENDERER_DIRECT3D11=0
                BGFX_CONFIG_RENDERER_DIRECT3D12=0
                BGFX_CONFIG_RENDERER_METAL=0
                BGFX_CONFIG_RENDERER_VULKAN=0
                BGFX_CONFIG_RENDERER_WEBGPU=0
                BGFX_CONFIG_RENDERER_OPENGL=${openyammBgfxOpenGlVersion}
                BGFX_CONFIG_RENDERER_OPENGLES=${openyammBgfxOpenGlesVersion}
        )
        target_link_libraries(openyamm_bgfx PUBLIC Threads::Threads ${CMAKE_DL_LIBS})

        if (ANDROID)
            target_link_libraries(openyamm_bgfx PUBLIC EGL GLESv3 android log)
        else()
            target_link_libraries(openyamm_bgfx PUBLIC OpenGL::GL)
        endif()

        if (UNIX AND NOT APPLE AND NOT ANDROID)
            target_link_libraries(openyamm_bgfx PUBLIC X11::X11 X11::Xext)
        endif()
    endif()

    if (NOT TARGET openyamm_fcpp)
        add_library(openyamm_fcpp STATIC
            ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/fcpp/cpp1.c
            ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/fcpp/cpp2.c
            ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/fcpp/cpp3.c
            ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/fcpp/cpp4.c
            ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/fcpp/cpp5.c
            ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/fcpp/cpp6.c
        )

        target_include_directories(openyamm_fcpp PUBLIC ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/fcpp)
        target_compile_definitions(openyamm_fcpp PRIVATE
            NINCLUDE=64
            NWORK=65536
            NBUFF=65536
            OLD_PREPROCESSOR=0
        )

        if (UNIX AND NOT APPLE)
            target_compile_options(openyamm_fcpp PRIVATE
                -Wno-implicit-fallthrough
                -Wno-incompatible-pointer-types
                -Wno-parentheses-equality
            )
        endif()
    endif()

    if (NOT TARGET openyamm_glsl_optimizer)
        file(GLOB_RECURSE openyammGlslOptimizerSources
            "${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/glsl-optimizer/src/*.c"
            "${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/glsl-optimizer/src/*.cpp"
        )
        list(FILTER openyammGlslOptimizerSources EXCLUDE REGEX "/src/node/")
        list(REMOVE_ITEM openyammGlslOptimizerSources
            "${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/glsl-optimizer/src/glsl/glcpp/glcpp.c"
            "${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/glsl-optimizer/src/glsl/main.cpp"
            "${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/glsl-optimizer/src/glsl/builtin_stubs.cpp"
            "${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/glsl-optimizer/src/glsl/ir_set_program_inouts.cpp"
        )

        add_library(openyamm_glsl_optimizer STATIC ${openyammGlslOptimizerSources})
        target_include_directories(openyamm_glsl_optimizer
            PUBLIC
                ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/glsl-optimizer/include
            PRIVATE
                ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/glsl-optimizer/src
                ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/glsl-optimizer/src/glsl
                ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/glsl-optimizer/src/mesa
                ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/glsl-optimizer/src/mesa/main
                ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/glsl-optimizer/src/mesa/program
                ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/glsl-optimizer/src/mapi
                ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/glsl-optimizer/src/util
        )

        if (MINGW)
            target_compile_options(openyamm_glsl_optimizer PRIVATE -O1)
        endif()

        if (UNIX AND NOT APPLE)
            target_compile_options(openyamm_glsl_optimizer PRIVATE
                -fno-strict-aliasing
                -Wno-implicit-fallthrough
                -Wno-parentheses
                -Wno-sign-compare
                -Wno-unused-function
                -Wno-unused-parameter
                -Wno-misleading-indentation
            )
        endif()
    endif()

    set(OPENYAMM_HOST_SHADERC "" CACHE FILEPATH "Host bgfx shaderc executable used while cross-compiling.")

    if (NOT TARGET openyamm_shaderc AND ANDROID)
        if (OPENYAMM_HOST_SHADERC STREQUAL "")
            message(FATAL_ERROR "Set OPENYAMM_HOST_SHADERC to a host bgfx shaderc executable for Android builds.")
        endif()

        if (NOT EXISTS "${OPENYAMM_HOST_SHADERC}")
            message(FATAL_ERROR "OPENYAMM_HOST_SHADERC does not exist: ${OPENYAMM_HOST_SHADERC}")
        endif()

        add_executable(openyamm_shaderc IMPORTED GLOBAL)
        set_target_properties(openyamm_shaderc PROPERTIES IMPORTED_LOCATION "${OPENYAMM_HOST_SHADERC}")
    elseif (NOT TARGET openyamm_shaderc)
        add_executable(openyamm_shaderc
            ${OPENYAMM_BGFX_SOURCE_DIR}/tools/shaderc/shaderc.cpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/tools/shaderc/shaderc_glsl.cpp
            ${CMAKE_SOURCE_DIR}/tools/openyamm_shaderc_stubs.cpp
        )
        target_include_directories(openyamm_shaderc PRIVATE
            ${OPENYAMM_BIMG_SOURCE_DIR}/include
            ${OPENYAMM_BGFX_SOURCE_DIR}/include
            ${OPENYAMM_BGFX_SOURCE_DIR}/tools/shaderc
            ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/directx-headers/include/directx
            ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/fcpp
            ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/glsl-optimizer/include
            ${OPENYAMM_BGFX_SOURCE_DIR}/3rdparty/glsl-optimizer/src/glsl
        )
        target_link_libraries(openyamm_shaderc PRIVATE openyamm_bgfx openyamm_fcpp openyamm_glsl_optimizer)
    endif()
endfunction()

function(openyamm_configure_runtime_shaders)
    if (TARGET openyamm_runtime_shaders)
        return()
    endif()

    openyamm_bgfx_shader_directory(shaderDirectory)
    set(bgfxExampleShaderDir "${OPENYAMM_BGFX_SOURCE_DIR}/examples/runtime/shaders/${shaderDirectory}")

    openyamm_copy_runtime_shader(
        "${bgfxExampleShaderDir}/vs_cubes.bin"
        "vs_cubes.bin")
    openyamm_copy_runtime_shader(
        "${bgfxExampleShaderDir}/fs_cubes.bin"
        "fs_cubes.bin")
    openyamm_copy_runtime_shader(
        "${bgfxExampleShaderDir}/vs_shadowmaps_texture.bin"
        "vs_shadowmaps_texture.bin")
    openyamm_copy_runtime_shader(
        "${bgfxExampleShaderDir}/fs_shadowmaps_texture.bin"
        "fs_shadowmaps_texture.bin")
    openyamm_compile_bgfx_shader(
        "${CMAKE_SOURCE_DIR}/game/shaders/vs_outdoor_textured_fog.sc"
        "vertex"
        "vs_outdoor_textured_fog.bin")
    openyamm_compile_bgfx_shader(
        "${CMAKE_SOURCE_DIR}/game/shaders/vs_outdoor_billboard_lit.sc"
        "vertex"
        "vs_outdoor_billboard_lit.bin")
    openyamm_compile_bgfx_shader(
        "${CMAKE_SOURCE_DIR}/game/shaders/fs_outdoor_textured_fog.sc"
        "fragment"
        "fs_outdoor_textured_fog.bin")
    openyamm_compile_bgfx_shader(
        "${CMAKE_SOURCE_DIR}/game/shaders/fs_outdoor_billboard_lit.sc"
        "fragment"
        "fs_outdoor_billboard_lit.bin")
    openyamm_compile_bgfx_shader(
        "${CMAKE_SOURCE_DIR}/game/shaders/vs_indoor_textured_lit.sc"
        "vertex"
        "vs_indoor_textured_lit.bin")
    openyamm_compile_bgfx_shader(
        "${CMAKE_SOURCE_DIR}/game/shaders/fs_indoor_textured_lit.sc"
        "fragment"
        "fs_indoor_textured_lit.bin")
    openyamm_compile_bgfx_shader(
        "${CMAKE_SOURCE_DIR}/game/shaders/vs_outdoor_force_perspective.sc"
        "vertex"
        "vs_outdoor_force_perspective.bin")
    openyamm_compile_bgfx_shader(
        "${CMAKE_SOURCE_DIR}/game/shaders/fs_outdoor_force_perspective.sc"
        "fragment"
        "fs_outdoor_force_perspective.bin")
    openyamm_compile_bgfx_shader(
        "${CMAKE_SOURCE_DIR}/game/shaders/vs_particle.sc"
        "vertex"
        "vs_particle.bin")
    openyamm_compile_bgfx_shader(
        "${CMAKE_SOURCE_DIR}/game/shaders/fs_particle.sc"
        "fragment"
        "fs_particle.bin")
    openyamm_compile_bgfx_shader(
        "${CMAKE_SOURCE_DIR}/game/shaders/vs_spell_area_preview.sc"
        "vertex"
        "vs_spell_area_preview.bin")
    openyamm_compile_bgfx_shader(
        "${CMAKE_SOURCE_DIR}/game/shaders/fs_spell_area_preview.sc"
        "fragment"
        "fs_spell_area_preview.bin")
    openyamm_compile_bgfx_shader(
        "${CMAKE_SOURCE_DIR}/game/shaders/vs_editor_preview_material.sc"
        "vertex"
        "vs_editor_preview_material.bin")
    openyamm_compile_bgfx_shader(
        "${CMAKE_SOURCE_DIR}/game/shaders/fs_editor_preview_material.sc"
        "fragment"
        "fs_editor_preview_material.bin")

    add_custom_target(openyamm_runtime_shaders ALL
        DEPENDS
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/vs_cubes.bin"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/fs_cubes.bin"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/vs_shadowmaps_texture.bin"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/fs_shadowmaps_texture.bin"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/vs_outdoor_textured_fog.bin"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/vs_outdoor_billboard_lit.bin"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/fs_outdoor_textured_fog.bin"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/fs_outdoor_billboard_lit.bin"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/vs_indoor_textured_lit.bin"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/fs_indoor_textured_lit.bin"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/vs_outdoor_force_perspective.bin"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/fs_outdoor_force_perspective.bin"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/vs_particle.bin"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/fs_particle.bin"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/vs_spell_area_preview.bin"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/fs_spell_area_preview.bin"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/vs_editor_preview_material.bin"
            "${OPENYAMM_RUNTIME_SHADER_DIR}/${shaderDirectory}/fs_editor_preview_material.bin"
    )
endfunction()
