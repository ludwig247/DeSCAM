cmake_minimum_required(VERSION 3.0)
project(SDRAM_CONTROLLER)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")
set(CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib -rt -dl -tinfo -pthread -z")

#set(CMAKE_CXX_STANDARD 14)

include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${CMAKE_SOURCE_DIR}/include/sysc/datatypes/fx/)
include_directories(${CMAKE_SOURCE_DIR}/example/interfaces)
link_directories(${CMAKE_SOURCE_DIR}/lib)


add_executable(SDRAM_CONTROLLER
        sc_main.cpp Testbench.h SDRAM-Controller.h DataTypes.h)
target_link_libraries(SDRAM_CONTROLLER systemc)
