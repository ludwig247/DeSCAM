cmake_minimum_required(VERSION 2.8)
project(Interface_Examples C CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} -fpermissive ")
set(CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib -rt -dl -tinfo -pthread -z")

#Define location systemc header&libs
include_directories(${CMAKE_SOURCE_DIR}/include)
link_directories(${CMAKE_SOURCE_DIR}/lib)

FILE(GLOB R_SRC *.cpp *.hpp *.h)
add_executable(Interface_Blocking_n ${R_SRC})
target_link_libraries(Interface_Blocking_n systemc)
