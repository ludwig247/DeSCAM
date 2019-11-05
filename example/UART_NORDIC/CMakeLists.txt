cmake_minimum_required(VERSION 2.8)
project(UART_NORDIC C CXX)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")
set (CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib   -rt -dl -tinfo -pthread -z")


include_directories(${CMAKE_SOURCE_DIR}/include)
link_directories(${CMAKE_SOURCE_DIR}/lib)
include_directories(${CMAKE_SOURCE_DIR}/example/Interfaces/)

include_directories(Interfaces)

FILE(GLOB R_SRC *.cpp *.hpp *.h)

add_executable(UART_NORDIC ${R_SRC}
        ${CMAKE_SOURCE_DIR}/example/Interfaces/Interfaces.h
        sc_main.cpp)
target_link_libraries(UART_NORDIC systemc)