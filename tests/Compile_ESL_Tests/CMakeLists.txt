project(Compile_ESL_Test_Run C CXX)
cmake_minimum_required(VERSION 3.0)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 ${LLVM_CXX_FLAGS} ")

set(EXAMPLE_NAMES "")

file(MAKE_DIRECTORY ./json_output_files/ ./error_files/)
add_custom_target(Compile_ESL_Test_Run ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_SOURCE_DIR}/JSON.cmake
                    DEPENDS ${CMAKE_SOURCE_DIR}/example/CMakeLists.txt WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} VERBATIM)
#add_custom_command(TARGET Compile_ESL_Test_Run PRE_BUILD COMMAND ${CMAKE_COMMAND} "${CMAKE_SOURCE_DIR}/cmake-build-debug" COMMENT "Is run")
#add_dependencies(Compile_ESL_Test_Run ${CMAKE_SOURCE_DIR}/example/CMakeLists.txt)

get_directory_property(EXAMPLE_NAMES DIRECTORY ${CMAKE_SOURCE_DIR}/example/ DEFINITION EXAMPLE_NAMES_LIST)


configure_file (
        "${CMAKE_CURRENT_SOURCE_DIR}/JSON.cmake.in"
        "${CMAKE_CURRENT_SOURCE_DIR}/JSON.cmake" @ONLY)

add_executable(Compile_ESL_tests tests.cpp)
target_compile_options(Compile_ESL_tests PRIVATE -fPIC -O2 )
target_link_libraries(Compile_ESL_tests PRIVATE ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgtest_main.a pthread)
