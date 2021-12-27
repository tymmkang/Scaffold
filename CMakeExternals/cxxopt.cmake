# cxxopts
# Lightweight C++ option parser library, supporting the standard GNU style syntax for options.
# repo : https://github.com/jarro2783/cxxopts
# Header-Only

# 외부 CMake 프로젝트를 특정 프로젝트에 추가합니다.
# TARGET_MODULE [IN]   외부 프로젝트에 의존 할 모듈
function(SCAF_EM_FUNC_ADD_CXXOPT 
    TARGET_MODULE)

    set(VAR_EXTERNAL_NAME       "cxxopt")
    set(VAR_EXTERNAL_GIT_REPO   "https://github.com/jarro2783/cxxopts.git")
    set(VAR_EXTERNAL_GIT_TAG    "v2.2.1")

    FetchContent_Declare(${VAR_EXTERNAL_NAME}
        GIT_REPOSITORY ${VAR_EXTERNAL_GIT_REPO}
        GIT_TAG ${VAR_EXTERNAL_GIT_TAG}
    )

    # FetchContent_MakeAvailable(${VAR_EXTERNAL_NAME})
    FetchContent_GetProperties(${VAR_EXTERNAL_NAME} POPULATED VAR_POPULATED)
    
    if(NOT ${VAR_POPULATED})
        message(STATUS "Fetch '${VAR_EXTERNAL_NAME}' from '${VAR_EXTERNAL_GIT_REPO}' (${VAR_EXTERNAL_GIT_TAG})")
        
        FetchContent_Populate(${VAR_EXTERNAL_NAME})
        FetchContent_GetProperties(${VAR_EXTERNAL_NAME}
            SOURCE_DIR VAR_SOURCE_DIR
            BINARY_DIR VAR_BINARY_DIR
        )

        if(EXISTS "${SCAF_EM_OUTPUT_DIR}/${VAR_EXTERNAL_NAME}")
            file(REMOVE "${SCAF_EM_OUTPUT_DIR}/${VAR_EXTERNAL_NAME}")
        endif()

        file(GLOB VAR_SOURCES 
            "${VAR_SOURCE_DIR}/include/*h"
            "${VAR_SOURCE_DIR}/include/*hpp")

        file(COPY "${VAR_SOURCES}" 
            DESTINATION "${SCAF_EM_OUTPUT_DIR}/${VAR_EXTERNAL_NAME}/include/${VAR_EXTERNAL_NAME}")

        message(STATUS "Fetch '${VAR_EXTERNAL_NAME}' Done")
    endif()

    target_include_directories(${TARGET_MODULE} PRIVATE "${SCAF_EM_OUTPUT_DIR}/${VAR_EXTERNAL_NAME}/include")
    message(STATUS "Add '${VAR_EXTERNAL_NAME}' to '${TARGET_MODULE}'")
endfunction()
