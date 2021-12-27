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

    FetchContent_GetProperties(${VAR_EXTERNAL_NAME})

    if(NOT ${VAR_EXTERNAL_NAME}_POPULATED)
        message(STATUS "Fetch '${VAR_EXTERNAL_NAME}' from '${VAR_EXTERNAL_GIT_REPO}' (${VAR_EXTERNAL_GIT_TAG})")
        FetchContent_Populate(${VAR_EXTERNAL_NAME})
        message(STATUS "Fetch '${VAR_EXTERNAL_NAME}' Done")
    endif()

    

endfunction()