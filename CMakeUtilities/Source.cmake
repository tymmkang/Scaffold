# Source

# 특정 경로에 포함된 특정 확장자(들)을 가진 파일들의 상대 경로를 반환하는 함수
# IN_TARGET_DIRECTORY[in]                   파일들의 상대경로를 취득 할 부모 디렉토리
# IN_FILE_EXTENSIONS[in]                    취득 할 파일들의 확장자 ex) *.cmake *.cpp *.h
# OUT_RESULT_RELATIVE_FILE_PATH_LIST[out]   파일 경로 반환 파라미터
function(SCAF_UTILITY_FUNC_GET_FILES_IN_DIRECTORY
    IN_TARGET_DIRECTORY
    IN_FILE_EXTENSIONS
    OUT_RESULT_RELATIVE_FILE_PATH_LIST)

    set(ABSOLUTE_TARGET_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/${IN_TARGET_DIRECTORY})
    set(FILE_PATH_LIST)

    foreach(FILE_EXTENSION ${IN_FILE_EXTENSIONS})
        file(GLOB FILES RELATIVE ${ABSOLUTE_TARGET_DIRECTORY} ${ABSOLUTE_TARGET_DIRECTORY}/${FILE_EXTENSION})
        foreach(FILE ${FILES})
            set(RELATIVE_FILE_PATH ${IN_TARGET_DIRECTORY}/${FILE})

            if(NOT IS_DIRECTORY ${RELATIVE_FILE_PATH})
                set(FILE_PATH_LIST ${FILE_PATH_LIST} ${RELATIVE_FILE_PATH}) # Append list
            endif()
        endforeach()
    endforeach()

    set(${OUT_RESULT_RELATIVE_FILE_PATH_LIST} ${FILE_PATH_LIST} PARENT_SCOPE)
endfunction()

function(SCAF_UTILITY_FUNC_GET_FILES_IN_DIRECTORY_RECURSIVE
    IN_TARGET_DIRECTORY
    IN_FILE_EXTENSIONS
    OUT_RESULT_RELATIVE_FILE_PATH_LIST)

    set(ABSOLUTE_TARGET_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/${IN_TARGET_DIRECTORY})
    set(FILE_PATH_LIST)

    SCAF_UTILITY_FUNC_GET_FILES_IN_DIRECTORY(
        ${IN_TARGET_DIRECTORY} 
        "${IN_FILE_EXTENSIONS}"
        FILE_PATH_LIST_IN_DIRECTORY)

    set(FILE_PATH_LIST ${FILE_PATH_LIST} ${FILE_PATH_LIST_IN_DIRECTORY}) # Append list

    SCAF_UTILITY_FUNC_GET_SUBDIRECTORIES(${ABSOLUTE_TARGET_DIRECTORY} SUBDIRECTORIES)

    foreach(SUBDIRECTORY ${SUBDIRECTORIES})
        # Recursive
        SCAF_UTILITY_FUNC_GET_FILES_IN_DIRECTORY(
            ${IN_TARGET_DIRECTORY}/${SUBDIRECTORY}
            "${IN_FILE_EXTENSIONS}"
            FILE_PATH_LIST_IN_DIRECTORY)

        set(FILE_PATH_LIST ${FILE_PATH_LIST} ${FILE_PATH_LIST_IN_DIRECTORY}) # Append list
    endforeach()

    set(${OUT_RESULT_RELATIVE_FILE_PATH_LIST} ${FILE_PATH_LIST} PARENT_SCOPE)
endfunction()
