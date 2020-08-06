cmake_minimum_required(VERSION 3.0)
project(RISC_privilege_framework C CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} -fpermissive ")
set(CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib -rt -dl -tinfo -pthread -z")

include_directories(/import/lab/users/ovsthus/SCAM/include)
include_directories(/import/lab/users/ovsthus/SCAM/example/Interfaces)
include_directories(/import/lab/users/ovsthus/SCAM/example/RISCV_commons)


link_directories(/import/lab/users/ovsthus/SCAM/lib)

find_package( Boost REQUIRED COMPONENTS iostreams program_options )

# add executables
add_executable(RISCV_privilege sc_main_test.cpp)

# link libraries
target_link_libraries(RISCV_privilege systemc)

target_link_libraries(RISCV_privilege ${Boost_LIBRARIES} pthread)

# add macros
target_compile_definitions(RISCV_privilege PRIVATE SC_SIMULATE)
