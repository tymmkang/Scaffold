# Vulkan
# Official website : https://www.vulkan.org/

function(SCAF_EM_FUNC_ADD_VULKAN 
    TARGET_MODULE)

    if (NOT CMAKE_VERSION VERSION_LESS 3.7.0)
        find_package(Vulkan QUIET)

        if(${Vulkan_FOUND})
            target_link_libraries(${TARGET_MODULE} PUBLIC ${Vulkan_LIBRARIES})
            include_directories(${Vulkan_INCLUDE_DIRS})
        else()
            message(FATAL_ERROR "Not found Vulkan SDK")
        endif()

    elseif()
        message(FATAL_ERROR "Can not use Vulkan CMake package. Upgrade CMake version to above 3.7.0")
    endif()

    message(STATUS "Add 'Vulkan' external dependency to '${TARGET_MODULE}'")    

endfunction()
