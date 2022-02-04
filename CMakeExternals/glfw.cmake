# GLFW
# Official website : https://www.glfw.org/
# Git repository : https://github.com/glfw/glfw

# tymmkang@gmail.com 2022-02-04
# NOTE : 정적 라이브러리만 지원하고 있습니다.

function(SCAF_EM_FUNC_ADD_GLFW 
    TARGET_MODULE)

    set(VAR_EXTERNAL_NAME           "glfw")
    set(VAR_EXTERNAL_GIT_REPO_URL   "https://github.com/glfw/glfw.git")
    set(VAR_EXTERNAL_GIT_TAG        "3.3.6")
    set(VAR_EXTERNAL_SHARED         OFF)

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
            "-DGLFW_BUILD_EXAMPLES=OFF"
            "-DGLFW_BUILD_TESTS=OFF"
            "-DGLFW_BUILD_DOCS=OFF"
    
        INSTALL_COMMAND
            ${CMAKE_COMMAND}
            --build .
            --target install
            --config $<$<CONFIG:Release>:Release>$<$<CONFIG:Debug>:Debug>

        # tymmkang@gmail.com 2022-02-04
        # NOTE : 개인 리포지토리에서 마이그레이션 할 때 이런 인자를 사용했었습니다.
        # 어렴풋이 기억나는 이유는 VSCode 개발환경에서 Ninja 제너레이터를 사용하는 것과 관련이 있었던 것 같기도...   
        # BUILD_BYPRODUCTS "${INSTALL_DIR}/lib/glfw3.lib"
        
        LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
    )

    message(STATUS "Add '${VAR_EXTERNAL_NAME}' external dependency to '${TARGET_MODULE}'") 

    ExternalProject_Get_property(${VAR_EXTERNAL_NAME} INSTALL_DIR)
    add_dependencies(${TARGET_MODULE} ${VAR_EXTERNAL_NAME})
    target_include_directories(${TARGET_MODULE} PRIVATE "${INSTALL_DIR}/include")
    target_link_libraries(${TARGET_MODULE} PRIVATE "${INSTALL_DIR}/lib/glfw3${CMAKE_STATIC_LIBRARY_SUFFIX}")

    # if (${VAR_EXTERNAL_SHARED})
    #     # TODO : Copy shared library to project output
    # endif ()

    set_target_properties(${VAR_EXTERNAL_NAME} PROPERTIES FOLDER ${SCAF_VAR_EXTERNAL_MODULE_RELATIVE_DIR})
endfunction()