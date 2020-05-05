cmake_minimum_required(VERSION 2.8)
project(Bus C CXX)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")
set (CMAKE_MODULE_LINKER_FLAGS "-L/usr/lib -L/usr/local/lib   -rt -dl -tinfo -pthread -z")

#SYSTEMC-LIBS
set(DESCAM_HOME /home/tobias/DeSCAM/) #change to location of DeSCAM installation
include_directories(${DESCAM_HOME}/include)
link_directories(${DESCAM_HOME}/lib)

FILE(GLOB R_SRC *.cpp *.hpp *.h)

add_executable(GettingStarted ${R_SRC}
        MasterDummy.h SlaveDummy.h)

target_link_libraries(GettingStarted systemc)

