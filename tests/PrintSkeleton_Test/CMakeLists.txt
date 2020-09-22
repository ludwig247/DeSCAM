project(PrintSkeleton_Test_Run C CXX)
cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 ${LLVM_CXX_FLAGS} ")
set(CMAKE_POSITION_INDEPENDENT_CODE ON)


#DIRECTORIES
#include_directories(${CMAKE_SOURCE_DIR}/example)

set(SOURCE_FILES tests.cpp)

set(GLOBAL_FILES
        ${CMAKE_SOURCE_DIR}/src/plugin/PrintITL/DatapathVisitor.cpp
        ${CMAKE_SOURCE_DIR}/src/plugin/PrintITL/ConditionVisitor.cpp)

add_executable(PrintSkeleton_Test_Run ${SOURCE_FILES} ${GLOBAL_FILES})
target_link_libraries(PrintSkeleton_Test_Run parser)
target_link_libraries(PrintSkeleton_Test_Run ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgtest_main.a pthread)

get_directory_property(EXAMPLE_H DIRECTORY ${CMAKE_SOURCE_DIR}/example/ DEFINITION EXAMPLE_H_LIST)

foreach(EXAMPLE_H_FILE ${EXAMPLE_H})
    set(INCLUDE_HEADER "${INCLUDE_HEADER}#include \"${EXAMPLE_H_FILE}\" \n")
endforeach()

#configure_file (
#        "${CMAKE_SOURCE_DIR}/example/add_example/templates/tests.h.in"
#        "${CMAKE_CURRENT_SOURCE_DIR}/TestCases/tests.h"
#)