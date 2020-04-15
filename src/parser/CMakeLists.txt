cmake_minimum_required(VERSION 3.0)
project(DESCAM CXX)

add_subdirectory(CLI)

add_executable(DESCAM main.cpp)

target_compile_options(DESCAM PRIVATE -O2)

include(ParserLib.cmake)

add_dependencies(DESCAM SYSTEMC)
add_dependencies(DESCAM GTEST)
add_dependencies(DESCAM Z3)
add_dependencies(DESCAM LLVM)

target_link_libraries(DESCAM parser)

add_custom_command(TARGET parser
        PRE_LINK
        #COMMAND echo "TRIAL IS WORKING"
        COMMAND cmake --build ${CMAKE_SOURCE_DIR}/build/ --target SYSTEMC -j &&
        cmake --build ${CMAKE_SOURCE_DIR}/build/ --target GTEST -j &&
        cmake --build ${CMAKE_SOURCE_DIR}/build/ --target Z3 -j &&
        cmake --build ${CMAKE_SOURCE_DIR}/build/ --target LLVM -j
        COMMENT "Building Dependencies ...")



