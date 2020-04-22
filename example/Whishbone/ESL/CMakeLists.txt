cmake_minimum_required(VERSION 2.8)
project(Whisbone_SIM C CXX)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")
set (CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib   -rt -dl -tinfo -pthread -z")


include_directories(${CMAKE_SOURCE_DIR}/include)
link_directories(${CMAKE_SOURCE_DIR}/lib)
include_directories(${CMAKE_SOURCE_DIR}/example/Interfaces/)

add_subdirectory(env)
include_directories(to_delete)
get_directory_property(ENV_SRC DIRECTORY env/ DEFINITION ENV_SRC)
#FILE(GLOB R_SRC *.cpp *.hpp *.h)
#list(APPEND R_SRC ${ENV_SRC})


add_executable(Whishbone_Simulation ${ENV_SRC}
        ${CMAKE_SOURCE_DIR}/example/Interfaces/Interfaces.h
        to_delete/MasterAgent_old.h to_delete/SlaveAgent_old.h to_delete/Interconnect_old.h env/MasterDummy.h env/SlaveDummy.h)

#add_executable(Whisbone ${R_SRC}
#        ${CMAKE_SOURCE_DIR}/example/Interfaces/Interfaces.h
#        MasterAgent.h SlaveAgent.h Interconnect.h env/MasterDummy.h env/SlaveDummy.h)

target_link_libraries(Whishbone_Simulation systemc)
