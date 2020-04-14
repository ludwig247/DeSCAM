project(Compile_ESL_Test_Run C CXX)
cmake_minimum_required(VERSION 3.0)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 ${LLVM_CXX_FLAGS} ")

add_custom_target(Compile_ESL_Test_Run ${CMAKE_CURRENT_SOURCE_DIR}/testshell.sh WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} VERBATIM)
#add_custom_command(OUTPUT JSON_file.json

#get_directory_property(EXAMPLE_H DIRECTORY ${CMAKE_SOURCE_DIR}/example/ DEFINITION EXAMPLE_H_LIST)
get_directory_property(EXAMPLE_NAMES DIRECTORY ${CMAKE_SOURCE_DIR}/example/ DEFINITION EXAMPLE_NAMES_LIST)

#message(STATUS "${EXAMPLE_NAMES}")
#foreach(EXAMPLE_H_FILE ${EXAMPLE_H})
#    #    get_filename_component(EXAMPLE_H_FILE_NAME ${EXAMPLE_H_FILE} NAME)
#    set(INCLUDE_HEADER "${INCLUDE_HEADER}#include \"${EXAMPLE_H_FILE}\" \n")
#endforeach()

foreach(EXAMPLE_NAMES_FILE ${EXAMPLE_NAMES})
    set(INCLUDE_NAMES "${INCLUDE_NAMES}${EXAMPLE_NAMES_FILE}\n")
endforeach()

#configure_file (
#        "${CMAKE_CURRENT_SOURCE_DIR}/tests.txt.in"
#        "${CMAKE_CURRENT_SOURCE_DIR}/tests.txt"
#)
