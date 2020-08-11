cmake_minimum_required(VERSION 3.12)
project(ahb_bus C CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} -fpermissive ")
set(CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib -rt -dl -tinfo -pthread -z")


include_directories(/home/ovsthus/SCAM/)
include_directories(/home/ovsthus/SCAM/include)
include_directories(/home/ovsthus/SCAM/example/Interfaces)
include_directories(/home/ovsthus/SCAM/example/RISCV_commons)


link_directories(/home/ovsthus/SCAM/lib)


add_executable(ahb_bus main.cpp ahb_bus.h compound.h)

target_link_libraries(ahb_bus systemc)