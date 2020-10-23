cmake_minimum_required(VERSION 3.12)
project(UART C CXX)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")
set (CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib   -rt -dl -tinfo -pthread -z")

include_directories(/import/lab/users/ovsthus/SCAM/)
include_directories(/import/lab/users/ovsthus/SCAM/example/Interfaces)
include_directories(/import/lab/users/ovsthus/SCAM/example/RISCV_commons)

include_directories(/import/lab/users/ovsthus/SCAM/include/)
link_directories(/import/lab/users/ovsthus/SCAM/lib/)

add_executable(UART_Simulation main.cpp)
target_link_libraries(UART systemc)