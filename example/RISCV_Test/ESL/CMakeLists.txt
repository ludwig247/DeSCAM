cmake_minimum_required(VERSION 2.8)
project(RISC-V-TESTING-FRAMEWORK C CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} -fpermissive ")
set(CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib -rt -dl -tinfo -pthread -z")

include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${CMAKE_SOURCE_DIR}/../Interfaces)
include_directories(${CMAKE_SOURCE_DIR}/example/RISCV_commons)

link_directories(${CMAKE_SOURCE_DIR}/lib)

# add executables
add_executable(RISCV_regression_test sc_main_test.cpp Core_test.h Memory.h TLM/TLM_bridge.h TLM/Memory_tlm.h)

# link libraries
target_link_libraries(RISCV_regression_test systemc)

# add macros
target_compile_definitions(RISCV_regression_test PRIVATE )

#Print results to logfiles
#target_compile_definitions(RISCV_regression_test PRIVATE LOGTOFILE)