cmake_minimum_required(VERSION 3.0)
project(DESCAM CXX)

add_subdirectory(CLI)

add_executable(DESCAM main.cpp)

target_compile_options(DESCAM PRIVATE -O2)

include(ParserLib.cmake)

target_link_libraries(DESCAM parser)

set(CMAKE_EXE_LINKER_FLAGS "-Wl,-Map=output.map")
