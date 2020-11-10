project(Compile_ESL_Tests C CXX)
cmake_minimum_required(VERSION 3.0)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 ${LLVM_CXX_FLAGS} ")
file(MAKE_DIRECTORY ./json_output_files/ ./error_files/)

get_directory_property(EXAMPLE_NAMES DIRECTORY ${CMAKE_SOURCE_DIR}/example/
                        DEFINITION EXAMPLE_NAMES_LIST)

configure_file (
        "${CMAKE_CURRENT_SOURCE_DIR}/JSON.cmake.in"
        "${CMAKE_CURRENT_SOURCE_DIR}/JSON.cmake" @ONLY)

add_executable(Compile_ESL_tests tests.cpp)
target_compile_options(Compile_ESL_tests PRIVATE -fPIC -O2 )
target_link_libraries(Compile_ESL_tests PRIVATE ${CMAKE_SOURCE_DIR}/lib/libgtest.a
                        ${CMAKE_SOURCE_DIR}/lib/libgtest_main.a pthread)


add_dependencies(Compile_ESL_tests Compile_ESL_Test_Run)
add_custom_target(Compile_ESL_Test_Run
        ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_SOURCE_DIR}/JSON.cmake
                    DEPENDS add_subdirectories
                            ${CMAKE_SOURCE_DIR}/example/add_subdirectory.cmake
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                    VERBATIM)

add_custom_command(OUTPUT add_subdirectories #Reruns CMake to include newly added examples
        COMMAND make rebuild_cache
        COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_SOURCE_DIR}/JSON.cmake
        )



