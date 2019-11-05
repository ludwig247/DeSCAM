cmake_minimum_required(VERSION 2.8)
project(Example3 C CXX)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")
set (CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib   -rt -dl -tinfo -pthread -z")

#Define location systemc header&libs
include_directories(${CMAKE_SOURCE_DIR}/include)
link_directories(${CMAKE_SOURCE_DIR}/lib)

include_directories(${CMAKE_SOURCE_DIR}/example/Interfaces/)

FILE(GLOB R_SRC *.cpp *.hpp *.h)
add_executable(Example3 ${R_SRC})
target_link_libraries(Example3 systemc)
