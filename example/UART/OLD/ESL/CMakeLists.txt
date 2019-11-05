cmake_minimum_required(VERSION 3.0)
project(UART C CXX)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")
set (CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib   -rt -dl -tinfo -pthread -z")



include_directories(${CMAKE_SOURCE_DIR}/)
include_directories(/import/lab/users/ovsthus/SCAM/example/Interfaces)
include_directories(/import/lab/users/ovsthus/SCAM/example/RISCV_commons)

#Adjust this to where your system-c is installed
include_directories(/import/lab/users/ovsthus/SCAM/include/)
link_directories(/import/lab/users/ovsthus/SCAM/lib/)


#FILE(GLOB R_SRC *.cpp *.hpp *.h)
#
#add_executable(UART ${R_SRC}
#        ${CMAKE_SOURCE_DIR}/Interfaces/Interfaces.h
#        MasterDummy.h Bus.h UART.h)
add_executable(UART main.cpp Memory_manager.h)
target_link_libraries(UART systemc)

