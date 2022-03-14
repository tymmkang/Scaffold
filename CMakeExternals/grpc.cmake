# gRPC
# Official website : https://grpc.io/
# Git repository : https://github.com/grpc/grpc

# tymmkang@gmail.com 2022-03-15
# NOTE : 정적 라이브러리만 지원하고 있습니다.

function(SCAF_EM_FUNC_ADD_GRPC 
    TARGET_MODULE)

    set(VAR_EXTERNAL_NAME           "grpc")
    set(VAR_EXTERNAL_GIT_REPO_URL   "https://github.com/grpc/grpc.git")
    set(VAR_EXTERNAL_GIT_TAG        "v1.44.0")
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
                "-DINSTALL_BIN_DIR=<INSTALL_DIR>/bin"
                "-DINSTALL_INC_DIR=<INSTALL_DIR>/include"
                "-DINSTALL_LIB_DIR=<INSTALL_DIR>/lib"
                "-DINSTALL_MAN_DIR=<INSTALL_DIR>/share/man"
                "-DINSTALL_PKGCONFIG_DIR=<INSTALL_DIR>/share/pkgconfig"
                "-DCMAKE_BUILD_TYPE=$<$<CONFIG:Release>:Release>$<$<CONFIG:Debug>:Debug>"
                "-DCMAKE_CONFIGURATION_TYPES=$<$<CONFIG:Release>:Release>$<$<CONFIG:Debug>:Debug>"
                "-DBUILD_SHARED_LIBS=${VAR_EXTERNAL_SHARED}"
        
            INSTALL_COMMAND
                ${CMAKE_COMMAND}
                --build .
                --target install
                --config $<$<CONFIG:Release>:Release>$<$<CONFIG:Debug>:Debug>

            LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
        )

        set_target_properties(${VAR_EXTERNAL_NAME} PROPERTIES FOLDER ${SCAF_VAR_EXTERNAL_MODULE_RELATIVE_DIR})

        # if (${VAR_EXTERNAL_SHARED})
        #     # TODO : Copy shared library to project output
        # endif ()
    endif ()

    message(STATUS "Add '${VAR_EXTERNAL_NAME}' external dependency to '${TARGET_MODULE}'") 

    ExternalProject_Get_property(${VAR_EXTERNAL_NAME} INSTALL_DIR)
    add_dependencies(${TARGET_MODULE} ${VAR_EXTERNAL_NAME})
    target_include_directories(${TARGET_MODULE} PRIVATE "${INSTALL_DIR}/include")
    target_link_libraries(${TARGET_MODULE} PRIVATE "${INSTALL_DIR}/lib/*${CMAKE_STATIC_LIBRARY_SUFFIX}")

endfunction()