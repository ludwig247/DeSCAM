cmake_minimum_required(VERSION 3.0)
project(RISC-V-TESTING-FRAMEWORK C CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${LLVM_CXX_FLAGS} -fpermissive ")
set(CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib -rt -dl -tinfo -pthread -z")

include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${CMAKE_SOURCE_DIR}/example/Interfaces)
include_directories(${CMAKE_SOURCE_DIR}/example/RISCV_commons)
include_directories(${CMAKE_SOURCE_DIR}/example/RISCV_Test_ELF/ESL/Core_include)

link_directories(${CMAKE_SOURCE_DIR}/lib)

find_package( Boost REQUIRED COMPONENTS iostreams program_options )

# add executables
add_executable(RISCV_elf_test sc_main_test.cpp)

# link libraries
target_link_libraries(RISCV_elf_test systemc)
target_link_libraries(RISCV_elf_test scv)
target_link_libraries(RISCV_elf_test ${Boost_LIBRARIES} pthread)

# add macros
target_compile_definitions(RISCV_elf_test PRIVATE SC_SIMULATE)
