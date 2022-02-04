# cxxopts
# Lightweight C++ option parser library, supporting the standard GNU style syntax for options.
# repo : https://github.com/jarro2783/cxxopts
# Header-Only

function(SCAF_EM_FUNC_ADD_CXXOPT 
    TARGET_MODULE)

    set(VAR_EXTERNAL_NAME           "cxxopt")
    set(VAR_EXTERNAL_GIT_REPO_URL   "https://github.com/jarro2783/cxxopts.git")
    set(VAR_EXTERNAL_GIT_TAG        "v2.2.1")

    FetchContent_Declare(${VAR_EXTERNAL_NAME}
        GIT_REPOSITORY ${VAR_EXTERNAL_GIT_REPO_URL}
        GIT_TAG ${VAR_EXTERNAL_GIT_TAG}
    )

    FetchContent_GetProperties(${VAR_EXTERNAL_NAME})
    if (NOT "${${VAR_EXTERNAL_NAME}_POPULATED}")
        message(STATUS "Clone '${VAR_EXTERNAL_NAME}' from '${VAR_EXTERNAL_GIT_REPO_URL}'")
        FetchContent_Populate(${VAR_EXTERNAL_NAME})
        message(STATUS "Clone '${VAR_EXTERNAL_NAME}' Done")
        
        if (EXISTS "${FETCHCONTENT_BASE_DIR}/${VAR_EXTERNAL_NAME}")
            file(REMOVE "${FETCHCONTENT_BASE_DIR}/${VAR_EXTERNAL_NAME}")
        endif ()

        # tymmkang@gmail.com 2022-02-04
        # NOTE : 리포지토리 별로 디렉토리 구조가 다르기 때문에 신경 써 줘야 합니다.
        file(GLOB VAR_FILES 
            "${${VAR_EXTERNAL_NAME}_SOURCE_DIR}/include/*")
        file(COPY "${VAR_FILES}" 
            DESTINATION "${SCAF_VAR_EXTERNAL_MODULE_PREFIX_DIR}/${VAR_EXTERNAL_NAME}/include/${VAR_EXTERNAL_NAME}")
    endif ()

    message(STATUS "Add '${VAR_EXTERNAL_NAME}' external dependency to '${TARGET_MODULE}'") 
    target_include_directories(${TARGET_MODULE} PRIVATE "${SCAF_VAR_EXTERNAL_MODULE_PREFIX_DIR}/${VAR_EXTERNAL_NAME}/include")
endfunction()
