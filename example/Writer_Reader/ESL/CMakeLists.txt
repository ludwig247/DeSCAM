cmake_minimum_required(VERSION 3.10)
#project(Writer_SIM C CXX)

set(CMAKE_SOURCE_DIR /import/lab/users/schmitz/DeSCAM)
set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")
set (CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib   -rt -dl -tinfo -pthread -z")


include_directories(${CMAKE_SOURCE_DIR}/include)
link_directories(${CMAKE_SOURCE_DIR}/lib)
include_directories(${CMAKE_SOURCE_DIR}/example/Interfaces/)

include_directories(Interfaces)

FILE(GLOB R_SRC *.cpp *.hpp *.h)

add_executable(Writer ${R_SRC}
        ${CMAKE_SOURCE_DIR}/example/Interfaces/Interfaces.h
        Component1.h Component2.h)
target_link_libraries(Writer systemc)
