# gRPC
# Official website : https://grpc.io/
# Git repository : https://github.com/grpc/grpc

# tymmkang@gmail.com 2022-03-15
# NOTE : 정적 라이브러리만 지원하고 있습니다.

function(SCAF_EM_FUNC_ADD_GRPC 
    TARGET_MODULE)

    get_target_property(VAR_TARGET_MODULE_TYPE ${TARGET_MODULE} TYPE)

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

    if (NOT ${VAR_TARGET_MODULE_TYPE} STREQUAL "UTILITY")
        target_include_directories(${TARGET_MODULE} PRIVATE "${INSTALL_DIR}/include")
        target_link_libraries(${TARGET_MODULE} PRIVATE "${INSTALL_DIR}/lib/*${CMAKE_STATIC_LIBRARY_SUFFIX}")
    endif ()

endfunction()

# 코드젠을 수행하는 protoc의 경로를 반환합니다.
# OUT_PROTOC_ABSOLUTE_PATH[out]     protoc의 절대경로
function(SCAF_EM_FUNC__GRPC_GET_PROTOC_ABSOLUTE_PATH
    OUT_PROTOC_ABSOLUTE_PATH)

    set(VAR_EXTERNAL_NAME "grpc")
    ExternalProject_Get_property(${VAR_EXTERNAL_NAME} INSTALL_DIR)

    if (WIN32)
        set(${OUT_PROTOC_ABSOLUTE_PATH} "${INSTALL_DIR}/bin/protoc.exe" PARENT_SCOPE)
    else ()
        set(${OUT_PROTOC_ABSOLUTE_PATH} "${INSTALL_DIR}/bin/protoc" PARENT_SCOPE)
    endif ()
endfunction()

# protoc의 인자로 전달하는 플러그인의 경로를 반환합니다.
# OUT_GRPC_CPP_PLUGIN_ABSOLUTE_PATH[out]     grpc_cpp_plugin의 절대경로
function(SCAF_EM_FUNC__GRPC_GET_GRPC_CPP_PLUGIN_ABSOLUTE_PATH
    OUT_GRPC_CPP_PLUGIN_ABSOLUTE_PATH)

    set(VAR_EXTERNAL_NAME "grpc")
    ExternalProject_Get_property(${VAR_EXTERNAL_NAME} INSTALL_DIR)

    if (WIN32)
        set(${OUT_GRPC_CPP_PLUGIN_ABSOLUTE_PATH} "${INSTALL_DIR}/bin/grpc_cpp_plugin.exe" PARENT_SCOPE)
    else ()
        set(${OUT_GRPC_CPP_PLUGIN_ABSOLUTE_PATH} "${INSTALL_DIR}/bin/grpc_cpp_plugin" PARENT_SCOPE)
    endif ()
endfunction()

# 임의의 타겟에 gRPC 코드생성 커맨드를 등록하는 함수를 간편하게 정의하기위한 매크로입니다.
# IN_PROTO_TARGET_NAME[in]      *.proto 정의가 포함된 타겟 이름으로, 이 이름에 따라 정의되는 함수명이 결정됩니다.
# IN_PROTO_ABSOLUTE_DIR[in]     *.proto 파일이 포함된 절대경로
# IN_PROTO_FILENAME_LIST[in]    IN_PROTO_ABSOLUTE_DIR에 포함된 *.proto 파일이름 리스트. 확장자가 포함되지 않습니다.
macro(SCAF_EM_MACRO__GRPC_GEN_RESERVE_FUNCTION_DEFINE
    IN_PROTO_TARGET_NAME
    IN_PROTO_ABSOLUTE_DIR
    IN_PROTO_FILENAME_LIST)

    # 코드젠 출력 결과물 파일이름 리스트를 반환합니다. 이름에는 확장자가 포함됩니다.
    # OUT_GENERATED_SOURCE_FILE_NAME_LIST[out]      
    function(SCAF_EM_FUNC__GRPC_GET_CODEGEN_FILENAME_LIST_${IN_PROTO_TARGET_NAME}
        OUT_GENERATED_SOURCE_FILE_NAME_LIST)

        set(VAR_GENERATED_SOURCE_FILE_NAME_LIST)
        foreach(VAR_PROTO_FILE_NAME ${IN_PROTO_FILENAME_LIST})
            # List append
            set(VAR_GENERATED_SOURCE_FILE_NAME_LIST ${VAR_GENERATED_SOURCE_FILE_NAME_LIST} 
                "${VAR_PROTO_FILE_NAME}.pb.h"
                "${VAR_PROTO_FILE_NAME}.pb.cc"
                "${VAR_PROTO_FILE_NAME}.grpc.pb.h"
                "${VAR_PROTO_FILE_NAME}.grpc.pb.cc")
        endforeach()

        set(${OUT_GENERATED_SOURCE_FILE_NAME_LIST} ${VAR_GENERATED_SOURCE_FILE_NAME_LIST} PARENT_SCOPE)
    endfunction()

    # 코드젠 생성을 수행하는 커멘드를 임의의 타겟에 추가합니다.
    # IN_CODEGEN_TRIGGER_TARGET_NAME[in]
    # IN_CODEGEN_OUTPUT_ABSOLUTE_DIR[in]
    function(SCAF_EM_FUNC__GRPC_RESERVE_CODEGEN_${IN_PROTO_TARGET_NAME}
        IN_CODEGEN_TRIGGER_TARGET_NAME
        IN_CODEGEN_OUTPUT_ABSOLUTE_DIR)

        add_dependencies(${IN_CODEGEN_TRIGGER_TARGET_NAME} ${IN_PROTO_TARGET_NAME})

        SCAF_EM_FUNC__GRPC_GET_PROTOC_ABSOLUTE_PATH(VAR_PROTOC_EXEC)
        SCAF_EM_FUNC__GRPC_GET_GRPC_CPP_PLUGIN_ABSOLUTE_PATH(VAR_GRPC_CPP_PLUGIN_EXEC)

        set(VAR_GENERATED_SOURCE_FILE_NAME_LIST)
        foreach(VAR_PROTO_FILE_NAME ${IN_PROTO_FILENAME_LIST})
            # List append
            set(VAR_GENERATED_SOURCE_FILE_NAME_LIST ${VAR_GENERATED_SOURCE_FILE_NAME_LIST} 
                "${VAR_PROTO_FILE_NAME}.pb.h"
                "${VAR_PROTO_FILE_NAME}.pb.cc"
                "${VAR_PROTO_FILE_NAME}.grpc.pb.h"
                "${VAR_PROTO_FILE_NAME}.grpc.pb.cc")
        endforeach()

        SCAF_UTILITY_FUNC__INSERT_STRING_FORWARD("${VAR_GENERATED_SOURCE_FILE_NAME_LIST}"
            "${IN_CODEGEN_OUTPUT_ABSOLUTE_DIR}/"
            VAR_GRPC_ABSOLUTE_FILE_PATH_LIST)

        SCAF_UTILITY_FUNC__APPEND_STRING_BACKWARD("${IN_PROTO_FILENAME_LIST}" ".proto" VAR_PROTO_FILENAME_WITH_EXTENSION_LIST)

        set(VAR_PROTO_LIST)
        foreach(VAR_PROTO ${VAR_PROTO_FILENAME_WITH_EXTENSION_LIST})
            set(VAR_PROTO_LIST ${VAR_PROTO_LIST} ${VAR_PROTO})
        endforeach()
        
        # 여기서 이벤트 등록
        add_custom_command(TARGET ${IN_CODEGEN_TRIGGER_TARGET_NAME}
            PRE_BUILD
            COMMAND ${CMAKE_COMMAND} -E rm -rf ${IN_CODEGEN_OUTPUT_ABSOLUTE_DIR}
            COMMAND ${CMAKE_COMMAND} -E make_directory ${IN_CODEGEN_OUTPUT_ABSOLUTE_DIR}
            COMMAND ${VAR_PROTOC_EXEC} --proto_path="${IN_PROTO_ABSOLUTE_DIR}" 
                                       --grpc_out="${IN_CODEGEN_OUTPUT_ABSOLUTE_DIR}" 
                                       --plugin=protoc-gen-grpc="${VAR_GRPC_CPP_PLUGIN_EXEC}" 
                                       ${VAR_PROTO_LIST}
            COMMAND ${VAR_PROTOC_EXEC} --proto_path="${IN_PROTO_ABSOLUTE_DIR}" 
                                       --cpp_out="${IN_CODEGEN_OUTPUT_ABSOLUTE_DIR}" 
                                       ${VAR_PROTO_LIST}
            BYPRODUCTS ${VAR_GRPC_ABSOLUTE_FILE_PATH_LIST})
    endfunction()

endmacro()
