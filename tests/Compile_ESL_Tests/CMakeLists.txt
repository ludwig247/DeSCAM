project(Compile_ESL_Test_Run C CXX)
cmake_minimum_required(VERSION 3.0)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 ${LLVM_CXX_FLAGS} ")

get_directory_property(EXAMPLE_H DIRECTORY ${CMAKE_SOURCE_DIR}/example/ DEFINITION EXAMPLE_H_LIST)

foreach(EXAMPLE_H_FILE ${EXAMPLE_H})
    #    get_filename_component(EXAMPLE_H_FILE_NAME ${EXAMPLE_H_FILE} NAME)
    set(INCLUDE_HEADER "${INCLUDE_HEADER}#include \"${EXAMPLE_H_FILE}\" \n")
endforeach()

configure_file (
        "${CMAKE_SOURCE_DIR}/example/tests.h.in"
        "${CMAKE_CURRENT_SOURCE_DIR}/TestCases/tests.h"
)
