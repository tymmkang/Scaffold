# CURL
# Official website : https://curl.se/
# Git repository : https://github.com/curl/curl

# tymmkang@gmail.com 2022-02-04
# NOTE : 정적 라이브러리만 지원하고 있습니다.

function(SCAF_EM_FUNC_ADD_CURL 
    TARGET_MODULE)

    set(VAR_EXTERNAL_NAME           "curl")
    set(VAR_EXTERNAL_GIT_REPO_URL   "https://github.com/curl/curl.git")
    set(VAR_EXTERNAL_GIT_TAG        "curl-7_81_0")
    set(VAR_EXTERNAL_SHARED         OFF)

    if (NOT TARGET ${VAR_EXTERNAL_NAME})

        ExternalProject_Add(${VAR_EXTERNAL_NAME} 
            GIT_REPOSITORY ${VAR_EXTERNAL_GIT_REPO_URL}
            GIT_TAG ${VAR_EXTERNAL_GIT_TAG}

            PREFIX ${FETCHCONTENT_BASE_DIR}/${VAR_EXTERNAL_NAME}
            INSTALL_DIR ${SCAF_VAR_EXTERNAL_MODULE_PREFIX_DIR}/${VAR_EXTERNAL_NAME}

            BUILD_COMMAND ""

            CMAKE_ARGS
            "-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>"
            "-DCMAKE_BUILD_TYPE=$<$<CONFIG:Release>:Release>$<$<CONFIG:Debug>:Debug>"
            "-DCMAKE_CONFIGURATION_TYPES=$<$<CONFIG:Release>:Release>$<$<CONFIG:Debug>:Debug>"
            "-DBUILD_SHARED_LIBS=${VAR_EXTERNAL_SHARED}"
            "-DBUILD_CURL_EXE=OFF"
            # 이 외에도 옵션이 많은데, 잘 모르겠어서 건드리지 않고 있습니다.

            INSTALL_COMMAND
                ${CMAKE_COMMAND}
                --build .
                --target install
                --config $<$<CONFIG:Release>:Release>$<$<CONFIG:Debug>:Debug>

            LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
        )

        set_target_properties(${VAR_EXTERNAL_NAME} PROPERTIES FOLDER ${SCAF_VAR_EXTERNAL_MODULE_RELATIVE_DIR})

        if (${VAR_EXTERNAL_SHARED})
            # TODO : Copy shared library to project output
        endif ()
    endif ()

    message(STATUS "Add '${VAR_EXTERNAL_NAME}' external dependency to '${TARGET_MODULE}'") 

    ExternalProject_Get_property(${VAR_EXTERNAL_NAME} INSTALL_DIR)
    add_dependencies(${TARGET_MODULE} ${VAR_EXTERNAL_NAME})
    target_include_directories(${TARGET_MODULE} PRIVATE "${INSTALL_DIR}/include")
    target_link_libraries(${TARGET_MODULE} PRIVATE "${INSTALL_DIR}/lib/$<$<CONFIG:Release>:libcurl>$<$<CONFIG:Debug>:libcurl-d>${CMAKE_STATIC_LIBRARY_SUFFIX}")

    if (NOT ${VAR_EXTERNAL_SHARED})
        target_compile_definitions(${TARGET_MODULE} PRIVATE "CURL_STATICLIB")
    endif ()

endfunction()
