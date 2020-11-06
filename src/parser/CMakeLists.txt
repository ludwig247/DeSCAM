cmake_minimum_required(VERSION 3.0)
project(DESCAM CXX)

include(ParserLib.cmake)

add_subdirectory(CLI)

add_executable(DESCAM main.cpp)

target_compile_options(DESCAM PRIVATE -fPIC -O2)

target_link_libraries(DESCAM parser)

if (NOT MACOSX)
    set(CMAKE_EXE_LINKER_FLAGS "-Wl,-Map=output.map")
endif ()
