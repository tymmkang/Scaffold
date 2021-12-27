# GLFW
# Official website : https://www.glfw.org/
# Git repository : https://github.com/glfw/glfw

function(SCAF_EM_FUNC_ADD_GLFW 
    TARGET_MODULE)

    set(VAR_EXTERNAL_NAME           "glfw")
    set(VAR_EXTERNAL_GIT_REPO_URL   "https://github.com/glfw/glfw.git")
    set(VAR_EXTERNAL_GIT_TAG        "3.3.6")

    ExternalProject_Add(${VAR_EXTERNAL_NAME} PREFIX ${VAR_EXTERNAL_NAME}
        GIT_REPOSITORY ${VAR_EXTERNAL_GIT_REPO_URL}
        GIT_TAG ${VAR_EXTERNAL_GIT_TAG}

        INSTALL_DIR "${FETCHCONTENT_BASE_DIR}/${VAR_EXTERNAL_NAME}"
    
        # Skip build command.
        BUILD_COMMAND ""    
    
        CMAKE_ARGS
            "-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>"
            "-DCMAKE_BUILD_TYPE=Release"
            "-DCMAKE_CONFIGURATION_TYPES=Release"
            "-DGLFW_BUILD_EXAMPLES=OFF"
            "-DGLFW_BUILD_TESTS=OFF"
            "-DGLFW_BUILD_DOCS=OFF"
            "-DBUILD_SHARED_LIBS=${CDEF_EXMOD_GLFW_CMAKE_ARGS_SHARED_LIBS}"
    
        INSTALL_COMMAND
            ${CMAKE_COMMAND}
            --build .
            --target install
            --config Release
        
        BUILD_BYPRODUCTS "<INSTALL_DIR>/lib/${CDEF_EXMOD_GLFW_STATIC_LIB}"
    
        LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
    )

    add_dependencies(${TARGET_MODULE} ${VAR_EXTERNAL_NAME})
endfunction()