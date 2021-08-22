cmake_minimum_required(VERSION 3.10)

project(object_manager)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED OFF)

file(
    GLOB_RECURSE source_list
        "dev/src/*.h"
        "dev/src/*.cpp"
)

add_executable(${PROJECT_NAME} ${source_list})
source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}/dev" FILES ${source_list})
target_include_directories(${PROJECT_NAME} PRIVATE "dev/src")

set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX "_dbg")
set(build_dir ${CMAKE_SOURCE_DIR}/build)

# Definuji jmeno adresare pro vysledek kompilace
set(output_subdir "undefined")
if (CMAKE_SIZEOF_VOID_P MATCHES 4)
    set(output_subdir ${build_dir}/win32)
elseif (CMAKE_SIZEOF_VOID_P MATCHES 8)
    set(output_subdir ${build_dir}/x64)
endif()

add_custom_command(TARGET ${PROJECT_NAME} PRE_BUILD COMMAND ${CMAKE_COMMAND} -E make_directory ${output_subdir})

# Nastavim jmeno adresare pro vysledek kompilace
set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${output_subdir})
set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${output_subdir})
set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${output_subdir})
set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL ${output_subdir})
set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO ${output_subdir})

if (${CMAKE_CXX_COMPILER_ID} STREQUAL MSVC)
    set_property(DIRECTORY PROPERTY VS_STARTUP_PROJECT ${PROJECT_NAME})
endif()

set(subsystem_type CONSOLE)
