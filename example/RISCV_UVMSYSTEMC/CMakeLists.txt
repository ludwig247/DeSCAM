cmake_minimum_required(VERSION 2.8)
project(RISC-V C CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${LLVM_CXX_FLAGS} -fpermissive ")
set(CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib -rt -dl -tinfo -pthread -z")

include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${CMAKE_SOURCE_DIR}/../../Interfaces)
include_directories(${CMAKE_SOURCE_DIR}/example/RISCV_interrupts/ESL)
include_directories(${CMAKE_SOURCE_DIR}/example/RISCV_commons)
link_directories(${CMAKE_SOURCE_DIR}/lib)

# add executables
FILE(GLOB RISCV_UVMSYSTEMC vip_components/subscriber_fromMemory.cpp
                            vip_components/subscriber_toMemory.cpp
                            *.cpp *.hpp *.h)
add_executable(RISCV_UVMSYSTEMC_test ${RISCV_UVMSYSTEMC})

# link libraries
target_link_libraries(RISCV_UVMSYSTEMC_test systemc)
target_link_libraries(RISCV_UVMSYSTEMC_test uvm-systemc)
target_link_libraries(RISCV_UVMSYSTEMC_test scv)

# add macros
target_compile_definitions(RISCV_UVMSYSTEMC_test PRIVATE TEST=1)
