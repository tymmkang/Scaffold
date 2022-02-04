# Khronos EGL-Registry
# Git repository : https://github.com/KhronosGroup/EGL-Registry
# Header-Only

function(SCAF_EM_FUNC_ADD_EGL_REGISTRY_API
    TARGET_MODULE
    API)

    set(VAR_EXTERNAL_NAME           "egl-registry")
    set(VAR_EXTERNAL_GIT_REPO_URL   "https://github.com/KhronosGroup/EGL-Registry")
    set(VAR_EXTERNAL_GIT_TAG        "main")

    FetchContent_Declare(${VAR_EXTERNAL_NAME}
        GIT_REPOSITORY ${VAR_EXTERNAL_GIT_REPO_URL}
        GIT_TAG ${VAR_EXTERNAL_GIT_TAG}
    )

    FetchContent_GetProperties(${VAR_EXTERNAL_NAME})
    if (NOT "${${VAR_EXTERNAL_NAME}_POPULATED}")
        message(STATUS "Clone '${VAR_EXTERNAL_NAME}' from '${VAR_EXTERNAL_GIT_REPO_URL}'")
        FetchContent_Populate(${VAR_EXTERNAL_NAME})
        message(STATUS "Clone '${VAR_EXTERNAL_NAME}' Done")
    endif ()
    
    if (EXISTS "${${VAR_EXTERNAL_NAME}_SOURCE_DIR}/api/${API}")
        file(REMOVE "${${VAR_EXTERNAL_NAME}_SOURCE_DIR}/api/${API}")
    endif ()

    file(COPY "${${VAR_EXTERNAL_NAME}_SOURCE_DIR}/api/${API}" 
        DESTINATION "${SCAF_VAR_EXTERNAL_MODULE_PREFIX_DIR}/${API}/include")

    message(STATUS "Add '${VAR_EXTERNAL_NAME} (${API})' external dependency to '${TARGET_MODULE}'") 
    target_include_directories(${TARGET_MODULE} PRIVATE "${SCAF_VAR_EXTERNAL_MODULE_PREFIX_DIR}/${API}/include")
endfunction()
