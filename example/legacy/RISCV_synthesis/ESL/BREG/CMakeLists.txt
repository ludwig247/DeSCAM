cmake_minimum_required(VERSION 3.0)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY  ${CMAKE_HOME_DIRECTORY}/work/bin)
set(SCAM_HOME $ENV{SCAM_HOME})

set(CMAKE_CXX_STANDARD 11) # C++11...
set(CMAKE_CXX_STANDARD_REQUIRED ON) #...is required...
set(CMAKE_CXX_EXTENSIONS OFF) #...without compiler extensions like gnu++11

include_directories(${SCAM_HOME}/include)
include_directories(${SCAM_HOME}/example/Interfaces)
include_directories(${SCAM_HOME}/example/RISCV_commons)

link_directories(${SCAM_HOME}/lib)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} -fpermissive ")
set(CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib -rt -dl -tinfo -pthread -z")

find_package(Boost REQUIRED COMPONENTS iostreams program_options)


# add executables
add_executable(RISCV_elf_test ${SCAM_HOME}/example/RISCV_Test_ELF/ESL/sc_main_test.cpp)

# link libraries
target_link_libraries(RISCV_elf_test systemc)
target_link_libraries(RISCV_elf_test ${Boost_LIBRARIES} pthread)	

# add macros
target_compile_definitions(RISCV_elf_test PRIVATE SC_SIMULATE TLM=0 USE_ELF=1)
