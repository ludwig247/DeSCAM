cmake_minimum_required(VERSION 2.8)
project(WB_bus_new C CXX)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} -fpermissive")
set (CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib   -rt -dl -tinfo -pthread -z")


include_directories(${CMAKE_SOURCE_DIR}/include)
link_directories(${CMAKE_SOURCE_DIR}/lib)
include_directories(${CMAKE_SOURCE_DIR}/example/Interfaces_new/)

FILE(GLOB R_SRC *.cpp *.hpp *.h)

add_executable(Whisbone_new ${R_SRC}
        MasterAgent.h SlaveAgent.h Interconnect.h MasterDummy.h SlaveDummy.h Clk.h)
target_link_libraries(Whisbone_new systemc)
