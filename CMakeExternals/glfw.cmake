# GLFW
# Official website : https://www.glfw.org/
# Git repository : https://github.com/glfw/glfw

# GLFW 외부 라이브러리를 CMake 설정 시점에 빌드하고, 임의의 타겟에 추가합니다.
# IN_TARGET_MODULE[in]      외부 라이브러리를 추가될 대상
# IN_GIT_TAG[in]            사용할 외부 라이브러리의 버전 (git 태그)
# IN_SHARED[in]             동적 라이브러리 여부
#
# NOTE :
# - 정적/동적 라이브러리 빌드에 따라 정적 라이브러리 파일의 이름이 다른것에 주의 (glfw, glfwdll)
#
function(SCAF_EM_FUNC_ADD_GLFW 
    IN_TARGET_MODULE
    IN_GIT_TAG
    IN_SHARED)

    set(VAR_EXTERNAL_NAME           "glfw")
    set(VAR_EXTERNAL_GIT_REPO_URL   "https://github.com/glfw/glfw.git")
    set(VAR_FETCH_CONTENT_NAME      "${VAR_EXTERNAL_NAME}-${IN_GIT_TAG}")
    set (VAR_CONFIG_LIST "Release" "Debug")

    if (NOT ${CMAKE_GENERATOR_PLATFORM} STREQUAL "")
        set(VAR_FETCH_CONTENT_NAME  "${VAR_FETCH_CONTENT_NAME}-${CMAKE_GENERATOR_PLATFORM}")
    endif()
    if (${IN_SHARED})
        set(VAR_FETCH_CONTENT_NAME  "${VAR_FETCH_CONTENT_NAME}-shared")
    endif ()
    string(TOLOWER ${VAR_FETCH_CONTENT_NAME} VAR_FETCH_CONTENT_NAME)
    
    message(STATUS "Make dependency on '${IN_TARGET_MODULE}' to '${VAR_FETCH_CONTENT_NAME}'")

    if (NOT EXISTS ${FETCHCONTENT_BASE_DIR}/${VAR_FETCH_CONTENT_NAME})
    
        FetchContent_Declare(${VAR_FETCH_CONTENT_NAME}
            GIT_REPOSITORY ${VAR_EXTERNAL_GIT_REPO_URL}
            GIT_TAG ${IN_GIT_TAG}
        )

        FetchContent_GetProperties(${VAR_FETCH_CONTENT_NAME})
        if (NOT "${${VAR_FETCH_CONTENT_NAME}_POPULATED}")
            message(STATUS "\tClone '${VAR_FETCH_CONTENT_NAME}' from '${VAR_EXTERNAL_GIT_REPO_URL}'")

            FetchContent_Populate(${VAR_FETCH_CONTENT_NAME})

            # Hide FetchContent related options from CMake gui (HACK)
            string(TOUPPER ${VAR_FETCH_CONTENT_NAME} VAR_FETCH_CONTENT_NAME_UPPER)
            unset("FETCHCONTENT_SOURCE_DIR_${VAR_FETCH_CONTENT_NAME_UPPER}" CACHE)
            unset("FETCHCONTENT_UPDATES_DISCONNECTED_${VAR_FETCH_CONTENT_NAME_UPPER}" CACHE)

            message(STATUS "\tClone '${VAR_FETCH_CONTENT_NAME}' from '${VAR_EXTERNAL_GIT_REPO_URL}' - Done")
        endif ()

        set(VAR_SRC_DIR "${${VAR_FETCH_CONTENT_NAME}_SOURCE_DIR}")
        foreach(VAR_CONFIG ${VAR_CONFIG_LIST})
            message(STATUS "\tBuild '${VAR_FETCH_CONTENT_NAME}'(${VAR_CONFIG})")

            set (CMAKE_ARGS
                "-DCMAKE_INSTALL_PREFIX=${FETCHCONTENT_BASE_DIR}/${VAR_FETCH_CONTENT_NAME}/${VAR_CONFIG}"
                "-DCMAKE_BUILD_TYPE=${VAR_CONFIG}"
                "-DCMAKE_CONFIGURATION_TYPES=${VAR_CONFIG}"
                "-DBUILD_SHARED_LIBS=${IN_SHARED}"
                "-DGLFW_BUILD_EXAMPLES=OFF"
                "-DGLFW_BUILD_TESTS=OFF"
                "-DGLFW_BUILD_DOCS=OFF"
            )

            set (BUILD_COMMAND_ARGS
                "-S ${VAR_SRC_DIR}" 
                "-B ${VAR_SRC_DIR}/CMakeBuild"
                "-G ${CMAKE_GENERATOR}")

            if (NOT ${CMAKE_GENERATOR_PLATFORM} STREQUAL "")
                set (BUILD_COMMAND_ARGS ${BUILD_COMMAND_ARGS} "-A ${CMAKE_GENERATOR_PLATFORM}")
            endif()

            execute_process(COMMAND ${CMAKE_COMMAND} ${BUILD_COMMAND_ARGS} ${CMAKE_ARGS} OUTPUT_QUIET ERROR_QUIET)
            execute_process(COMMAND ${CMAKE_COMMAND} --build ${VAR_SRC_DIR}/CMakeBuild/. --target install --config ${VAR_CONFIG} OUTPUT_QUIET ERROR_QUIET)
            
            message(STATUS "\tBuild '${VAR_FETCH_CONTENT_NAME}'(${VAR_CONFIG}) - Done")
        endforeach()
    endif ()

    foreach (VAR_CONFIG ${VAR_CONFIG_LIST})
        file (GLOB VAR_SHARED_LIST "${FETCHCONTENT_BASE_DIR}/${VAR_FETCH_CONTENT_NAME}/${VAR_CONFIG}/bin/*${CMAKE_SHARED_LIBRARY_SUFFIX}")
        foreach (VAR_SHARED_FILE_PATH ${VAR_SHARED_LIST})
            get_filename_component(VAR_SHARED_FILE_NAME ${VAR_SHARED_FILE_PATH} NAME)

            set(VAR_COPY_DST_DIR "${SCAF_CONFIG_OUTPUT_DIR}/${VAR_CONFIG}")
            if (NOT ${CMAKE_GENERATOR_PLATFORM} STREQUAL "")
                set(VAR_COPY_DST_DIR "${VAR_COPY_DST_DIR}-${CMAKE_GENERATOR_PLATFORM}")
            endif()

            if (NOT EXISTS "${VAR_COPY_DST_DIR}/${VAR_SHARED_FILE_NAME}")
                file(COPY ${VAR_SHARED_FILE_PATH} DESTINATION "${VAR_COPY_DST_DIR}")
            endif ()
        endforeach ()
    endforeach ()

    set(VAR_CONFIG_EXPGEN "$<$<CONFIG:Release>:Release>$<$<CONFIG:Debug>:Debug>")
    target_include_directories(${IN_TARGET_MODULE} PRIVATE "${FETCHCONTENT_BASE_DIR}/${VAR_FETCH_CONTENT_NAME}/${VAR_CONFIG_EXPGEN}/include")
    
    file(GLOB VAR_STATIC_RELEASE_LIST "${FETCHCONTENT_BASE_DIR}/${VAR_FETCH_CONTENT_NAME}/Release/lib/*${CMAKE_STATIC_LIBRARY_SUFFIX}")
    file(GLOB VAR_STATIC_DEBUG_LIST "${FETCHCONTENT_BASE_DIR}/${VAR_FETCH_CONTENT_NAME}/Debug/lib/*${CMAKE_STATIC_LIBRARY_SUFFIX}")
    target_link_libraries(${IN_TARGET_MODULE} PRIVATE "$<$<CONFIG:Release>:${VAR_STATIC_RELEASE_LIST}>$<$<CONFIG:Debug>:${VAR_STATIC_DEBUG_LIST}>")

    message(STATUS "Make dependency on '${IN_TARGET_MODULE}' to '${VAR_FETCH_CONTENT_NAME}' - DONE")
endfunction()
