cmake_minimum_required(VERSION 3.10)
project(BubbleSort_ESL)

#set(CMAKE_SOURCE_DIR /import/lab/users/jauch/CLionProjects/DeSCAM)

#set(CMAKE_CXX_STANDARD ${SystemC_CXX_STANDARD})

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")
set(CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib -rt -dl -tinfo -pthread -z")

#set(CMAKE_CXX_STANDARD 14)

include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${CMAKE_SOURCE_DIR}/exampe/interfaces)
link_directories(${CMAKE_SOURCE_DIR}/lib)


add_executable(BubbleSort_ESL
        sc_main.cpp Testbench.h BubbleSort_Step-1.h BubbleSort_Step-2_ternary.h DataTypes.h)
target_link_libraries(BubbleSort_ESL systemc)
