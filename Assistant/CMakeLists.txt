cmake_minimum_required(VERSION 3.8)

set(VAR_PROJECT_NAME "Scaffold-Assistant")
project(${VAR_PROJECT_NAME})

# Globals
set(SCAF_ROOT_DIR "${CMAKE_SOURCE_DIR}/..") # 템플릿에서는 동적으로 입력 해 줘야 할 것
set(SCAF_OUTPUT_DIR "${SCAF_ROOT_DIR}/Output")

# Debug
set(CMAKE_CXX_FLAGS_DEBUG ${CMAKE_CXX_FLAGS_DEBUG})
set(CMAKE_EXE_LINKER_FLAGS_DEBUG ${CMAKE_EXE_LINKER_FLAGS_DEBUG})
set(CMAKE_SHARED_LINKER_FLAGS_DEBUG ${CMAKE_SHARED_LINKER_FLAGS_DEBUG})
add_compile_definitions("$<$<CONFIG:Debug>:DEBUG=1>")

# Release
set(CMAKE_CXX_FLAGS_RELEASE ${CMAKE_CXX_FLAGS_RELEASE})
set(CMAKE_EXE_LINKER_FLAGS_RELEASE ${CMAKE_EXE_LINKER_FLAGS_RELEASE})
set(CMAKE_SHARED_LINKER_FLAGS_RELEASE ${CMAKE_SHARED_LINKER_FLAGS_RELEASE})
add_compile_definitions("$<$<CONFIG:Release>:RELEASE=2>")

# CMake In-Built modules
include(ExternalProject)
include(FetchContent)

# Scaffold utilities, externals
include("${SCAF_ROOT_DIR}/CMakeUtilities/CMakeLists.txt")
include("${SCAF_ROOT_DIR}/CMakeExternals/CMakeLists.txt")

set(VAR_SOURCES
    Src/main.cpp
    Src/TestClass.cpp
    Src/TestClass.h
)

add_executable(${VAR_PROJECT_NAME} ${VAR_SOURCES})
set_target_properties(${VAR_PROJECT_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY    "${SCAF_OUTPUT_DIR}/${VAR_PROJECT_NAME}/$<CONFIG>"
    LINKER_LANGUAGE             CXX
    CXX_STANDARD                20
)

SCAF_EM_FUNC_ADD_CXXOPT(${VAR_PROJECT_NAME})
SCAF_EM_FUNC_ADD_GLFW(${VAR_PROJECT_NAME})