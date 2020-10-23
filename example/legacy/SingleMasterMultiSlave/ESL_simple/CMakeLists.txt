

cmake_minimum_required(VERSION 2.8)
project(TCAD_simple C CXX)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")
set (CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib   -rt -dl -tinfo -pthread -z")


include_directories(/usr/local/systemc/include)
link_directories(/usr/local/systemc/lib-linux64)
include_directories(${CMAKE_SOURCE_DIR}/example/Interfaces/)

include_directories(Interfaces)

FILE(GLOB R_SRC *.cpp *.hpp *.h)

add_executable(TCAD_simple ${R_SRC} Compound.h Temp_detector.h Timer.h uProcessor.h ${CMAKE_SOURCE_DIR}/example/Interfaces/Interfaces.h)
target_link_libraries(TCAD_simple systemc)
