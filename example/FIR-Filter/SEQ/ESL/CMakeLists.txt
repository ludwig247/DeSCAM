cmake_minimum_required(VERSION 3.10)
project(FIR_ESL)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")
set(CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib -rt -dl -tinfo -pthread -z")

#set(CMAKE_CXX_STANDARD 14)

include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${CMAKE_SOURCE_DIR}/include/sysc/datatypes/fx/)
include_directories(${CMAKE_SOURCE_DIR}/exampe/interfaces)
link_directories(${CMAKE_SOURCE_DIR}/lib)


add_executable(FIR_ESL
        sc_main.cpp Testbench.h FIR-Filter.h DataTypes.h)
target_link_libraries(FIR_ESL systemc)
