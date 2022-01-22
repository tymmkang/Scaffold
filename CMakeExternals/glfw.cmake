# GLFW
# Official website : https://www.glfw.org/
# Git repository : https://github.com/glfw/glfw

function(SCAF_EM_FUNC_ADD_GLFW 
    TARGET_MODULE)

    set(VAR_EXTERNAL_NAME           "glfw")
    set(VAR_EXTERNAL_GIT_REPO_URL   "https://github.com/glfw/glfw.git")
    set(VAR_EXTERNAL_GIT_TAG        "3.3.6")
    # set(VAR_EXTERNAL_SHARED         FALSE)

    ExternalProject_Add(${VAR_EXTERNAL_NAME} 
        GIT_REPOSITORY ${VAR_EXTERNAL_GIT_REPO_URL}
        GIT_TAG ${VAR_EXTERNAL_GIT_TAG}

        PREFIX ${SCAF_VAR_EXTERNAL_MODULE_PREFIX_DIR}/${VAR_EXTERNAL_NAME}
        INSTALL_DIR ${FETCHCONTENT_BASE_DIR}/${VAR_EXTERNAL_NAME}
    
        BUILD_COMMAND ""
    
        CMAKE_ARGS
            "-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>"
            "-DCMAKE_BUILD_TYPE=$<$<CONFIG:Release>:Release>$<$<CONFIG:Debug>:Debug>"
            "-DCMAKE_CONFIGURATION_TYPES=$<$<CONFIG:Release>:Release>$<$<CONFIG:Debug>:Debug>"
            "-DGLFW_BUILD_EXAMPLES=OFF"
            "-DGLFW_BUILD_TESTS=OFF"
            "-DGLFW_BUILD_DOCS=OFF"
    
        INSTALL_COMMAND
            ${CMAKE_COMMAND}
            --build .
            --target install
            --config $<$<CONFIG:Release>:Release>$<$<CONFIG:Debug>:Debug>

        # BUILD_BYPRODUCTS "${INSTALL_DIR}/lib/glfw3.lib"
        
        LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
    )

    message(STATUS "Add '${VAR_EXTERNAL_NAME}' external dependency to '${TARGET_MODULE}'")    

    ExternalProject_Get_property(${VAR_EXTERNAL_NAME} INSTALL_DIR)
    add_dependencies(${TARGET_MODULE} ${VAR_EXTERNAL_NAME})
    target_include_directories(${TARGET_MODULE} PRIVATE "${INSTALL_DIR}/include")
    target_link_libraries(${TARGET_MODULE} PRIVATE "${INSTALL_DIR}/lib/glfw3.lib")

    # if (${VAR_EXTERNAL_SHARED})
    #     # TODO : Copy shared library to project output
    # endif()

    set_target_properties(${VAR_EXTERNAL_NAME} PROPERTIES FOLDER ${SCAF_VAR_EXTERNAL_MODULE_RELATIVE_DIR})
endfunction()