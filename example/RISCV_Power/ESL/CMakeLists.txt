cmake_minimum_required(VERSION 2.8)
project(RISC-V C CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} -fpermissive ")
set(CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib -rt -dl -tinfo -pthread -z")

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../../Interfaces)

include_directories(${CMAKE_SOURCE_DIR}/include)
link_directories(${CMAKE_SOURCE_DIR}/lib)

add_executable(RISCV sc_main.cpp Decoder.h CPU_Interfaces.h ALU.h cpath.h regs.h Utilities.h Memory.h Progam_tests.h)

target_link_libraries(RISCV systemc pthread)

