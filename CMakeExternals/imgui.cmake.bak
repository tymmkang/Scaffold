# imgui
# Git repository : https://github.com/ocornut/imgui
# Raw-Source

function(SCAF_RM_FUNC_ADD_RAW_SOURCE_IMGUI
    TARGET_MODULE
    RELATIVE_DESTINATION
    BACKENDS)

    set(VAR_EXTERNAL_NAME           "imgui")
    set(VAR_EXTERNAL_GIT_REPO_URL   "https://github.com/ocornut/imgui")
    set(VAR_EXTERNAL_GIT_TAG        "v1.86")
    # set(VAR_EXTERNAL_GIT_TAG        "docking")
    
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

    # tymmkang@gmail.com 2022-02-04
    # NOTE : 리포지토리 별로 디렉토리 구조가 다르기 때문에 신경 써 줘야 합니다.
    set(VAR_ABSOLUTE_DESTINATION "${CMAKE_CURRENT_LIST_DIR}/${RELATIVE_DESTINATION}")

    if (EXISTS "${VAR_ABSOLUTE_DESTINATION}")
        file(REMOVE "${VAR_ABSOLUTE_DESTINATION}")
    endif ()

    file(GLOB VAR_IMGUI_SOURCE
        "${${VAR_EXTERNAL_NAME}_SOURCE_DIR}/*.h"
        "${${VAR_EXTERNAL_NAME}_SOURCE_DIR}/*.cpp")

    foreach( VAR_SOURCE ${VAR_IMGUI_SOURCE})
        file(COPY "${VAR_SOURCE}" DESTINATION "${VAR_ABSOLUTE_DESTINATION}")
    endforeach()

    foreach( VAR_BACKEND ${BACKENDS})
        file(GLOB VAR_BACKEND_SOURCES
            "${${VAR_EXTERNAL_NAME}_SOURCE_DIR}/backends/imgui_impl_${VAR_BACKEND}.*")

        foreach( VAR_BACKEND_SOURCE ${VAR_BACKEND_SOURCES})
            file(COPY "${VAR_BACKEND_SOURCE}" DESTINATION "${VAR_ABSOLUTE_DESTINATION}")
        endforeach()
    endforeach()

    message(STATUS "Add '${VAR_EXTERNAL_NAME}' external dependency to '${TARGET_MODULE}'") 
endfunction()
