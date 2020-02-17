cmake_minimum_required(VERSION 2.8)
project(Testing C CXX)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")
set (CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib   -rt -dl -tinfo -pthread -z")


include_directories(/usr/local/systemc/include)
link_directories(/usr/local/systemc/lib-linux64)

FILE(GLOB R_SRC *.cpp *.hpp *.h)

add_executable(Testing ${R_SRC} SlaveDaveBave.h BugTest.h main.cpp foobar.h ahb_bus.h)
target_link_libraries(Testing systemc)
