# Vulkan
# Official website : https://www.vulkan.org/
# CMake-Package

function(SCAF_EM_FUNC_ADD_VULKAN 
    TARGET_MODULE)

    set(VAR_EXTERNAL_NAME "Vulkan")

    if (NOT CMAKE_VERSION VERSION_LESS 3.7.0)
        find_package(${VAR_EXTERNAL_NAME} QUIET)

        if ("${${VAR_EXTERNAL_NAME}_FOUND}")
            target_link_libraries(${TARGET_MODULE} PRIVATE "${${VAR_EXTERNAL_NAME}_LIBRARIES}")
            include_directories("${${VAR_EXTERNAL_NAME}_INCLUDE_DIRS}")
        else ()
            message(FATAL_ERROR "Not found ${VAR_EXTERNAL_NAME}")
        endif ()

    elseif ()
        message(FATAL_ERROR "Can not use ${VAR_EXTERNAL_NAME} CMake package. Upgrade CMake version to above 3.7.0")
    endif ()

    message (STATUS "Add '${VAR_EXTERNAL_NAME}' external dependency to '${TARGET_MODULE}'")    

endfunction()
