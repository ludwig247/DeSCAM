cmake_minimum_required(VERSION 2.8)
#project(I2C_Simulation C CXX)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")
set (CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib   -rt -dl -tinfo -pthread -z")


include_directories(${CMAKE_SOURCE_DIR}include)
link_directories(${CMAKE_SOURCE_DIR}/lib)
include_directories(${CMAKE_SOURCE_DIR}/example/Interfaces/)

include_directories(Interfaces)


add_executable(I2C_Simulation
        env/sc_main.cpp
        Slave.h
        Master.h
        ${CMAKE_SOURCE_DIR}/example/Interfaces/Interfaces.h)

target_link_libraries(I2C_Simulation systemc)
