# Library

# 특정 타겟에 라이브러리를 추가합니다.
# IN_TARGET_NAME[in]    라이브러리를 사용할 타겟 이름
# IN_LIBRARY_NAME[in]   추가할 라이브러리 이름
function(ADD_LIBRARY_DEPENDENCY
    IN_TARGET_NAME 
    IN_LIBRARY_NAME)

    if (NOT TARGET ${IN_TARGET_NAME})
        message(FATAL_ERROR "Not found target : ${IN_TARGET_NAME}")
    endif()

    if (NOT TARGET ${IN_LIBRARY_NAME})
        message(FATAL_ERROR "Not found library : ${IN_LIBRARY_NAME}")
    endif()

    get_target_property(VAR_ARCHIVE_OUTPUT_DIRECTORY ${IN_LIBRARY_NAME} ARCHIVE_OUTPUT_DIRECTORY)
    get_target_property(VAR_INCLUDE_DIRECTORY ${IN_LIBRARY_NAME} SCAF_INCLUDE_DIRECTORY)

    add_dependencies(${IN_TARGET_NAME} ${IN_LIBRARY_NAME})
    target_link_libraries(${IN_TARGET_NAME} PRIVATE ${IN_LIBRARY_NAME})
    target_include_directories(${IN_TARGET_NAME} PRIVATE ${VAR_INCLUDE_DIRECTORY})
endfunction()