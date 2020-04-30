cmake_minimum_required(VERSION 2.8)
project(Bus_Simulation C CXX)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")
set (CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib   -rt -dl -tinfo -pthread -z")


include_directories(${CMAKE_SOURCE_DIR}/include)
link_directories(${CMAKE_SOURCE_DIR}/lib)
include_directories(${CMAKE_SOURCE_DIR}/example/Interfaces/)

add_subdirectory(env)
get_directory_property(ENV_SRC DIRECTORY env/ DEFINITION ENV_SRC)
file(GLOB R_SRC *.cpp *.hpp *.h)
list(APPEND R_SRC ${ENV_SRC})

add_executable(Bus_Simulation ${R_SRC}
        ${CMAKE_SOURCE_DIR}/example/Interfaces/Interfaces.h
        env/MasterDummy.h env/SlaveDummy.h)

target_link_libraries(Bus_Simulation systemc)
