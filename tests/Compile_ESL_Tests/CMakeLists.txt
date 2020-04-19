project(Compile_ESL_Test_Run C CXX)
cmake_minimum_required(VERSION 3.0)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 ${LLVM_CXX_FLAGS} ")

set(EXAMPLE_NAMES "")



#add_custom_target(Compile_ESL_Test_Run ${CMAKE_CURRENT_SOURCE_DIR}/testshell.sh WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} VERBATIM)
add_custom_target(Compile_ESL_Test_Run ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_SOURCE_DIR}/JSON.cmake WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} VERBATIM)

#add_custom_command(TARGET Compile_ESL_Test_Run POST_BUILD COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_SOURCE_DIR}/JSON.cmake )

get_directory_property(EXAMPLE_NAMES DIRECTORY ${CMAKE_SOURCE_DIR}/example/ DEFINITION EXAMPLE_NAMES_LIST)
foreach(EXAMPLE_NAME ${EXAMPLE_NAMES})
    set(EXAMPLE_NAME "${EXAMPLE_NAME}_Simulation")
    set(INCLUDE_NAMES "${INCLUDE_NAMES}${EXAMPLE_NAME}\n")
endforeach()

configure_file (
        "${CMAKE_CURRENT_SOURCE_DIR}/JSON.cmake.in"
        "${CMAKE_CURRENT_SOURCE_DIR}/JSON.cmake" @ONLY)
configure_file (
        "${CMAKE_CURRENT_SOURCE_DIR}/tests.txt.in"
        "${CMAKE_CURRENT_SOURCE_DIR}/tests.txt" @ONLY)
