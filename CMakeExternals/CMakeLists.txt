# CMakeExternals

# 현재 디랙토리의 모든 *.cmake를 include
file(GLOB CMAKE_IN_CURRENT_DIR ${CMAKE_CURRENT_LIST_DIR}/*.cmake)
foreach(CMAKE_FILE ${CMAKE_IN_CURRENT_DIR})
    include(${CMAKE_FILE})
endforeach()
