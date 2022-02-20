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

# 라이브러리에서 노출될 API 함수들의 정의에 사용할 매크로가 포함된 소스를 생성합니다.
# IN_TARGET_NAME[in]                라이브러리 이름
# IN_IS_SHARED[in]                  동적 라이브러리 여부
# IN_DEST_RELATIVE_DIRECTORY[in]    생성한 소스를 출력할 상대경로
function(GENERATE_LIBRARY_API_HEADER
    IN_TARGET_NAME
    IN_IS_SHARED
    IN_DEST_RELATIVE_DERECTORY)

    set(VAR_TEMPLATE_FILE_NAME "LibraryAPI.h")
    set(VAR_GENERATED_FILE_NAME "${IN_TARGET_NAME}API.gen.h")

    set(VAR_TEMPLATE_FILE_PATH "${SCAF_VAR_SCAFFOLD_TEMPLATE_DIR}/${VAR_TEMPLATE_FILE_NAME}")
    set(VAR_GENERATED_FILE_PATH "${CMAKE_CURRENT_LIST_DIR}/${IN_DEST_RELATIVE_DERECTORY}/${VAR_GENERATED_FILE_NAME}")

    string(REGEX REPLACE "([a-z])([A-Z])" "\\1_\\2" VAR_TARGET_NAME_WITH_UNDERBAR ${IN_TARGET_NAME})
    string(TOUPPER ${VAR_TARGET_NAME_WITH_UNDERBAR} VAR_UPPER_PASCAL_CASE_TARGET_NAME)

    string(TOUPPER ${VAR_UPPER_PASCAL_CASE_TARGET_NAME} VAR_UPPERCASE_TARGET_NAME)
    if (${IN_IS_SHARED})
        set(VAR_IS_SHARED_VALUE 1)
    else ()
        set(VAR_IS_SHARED_VALUE 0)
    endif()

    # Configuration variables
    set(CONF_TARGET_NAME ${VAR_UPPERCASE_TARGET_NAME})
    set(CONF_IS_SHARED ${VAR_IS_SHARED_VALUE})

    configure_file(${VAR_TEMPLATE_FILE_PATH} ${VAR_GENERATED_FILE_PATH})

endfunction()
