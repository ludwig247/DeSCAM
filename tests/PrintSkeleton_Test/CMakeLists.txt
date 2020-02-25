project(PrintSkeleton_Test_Run C CXX)
cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 ${LLVM_CXX_FLAGS} ")


#DIRECTORIES
#include_directories(${CMAKE_SOURCE_DIR}/example)

set(SOURCE_FILES tests.cpp)

set(GLOBAL_FILES
        ${CMAKE_SOURCE_DIR}/src/plugin/PrintITL/DatapathVisitor.cpp
        ${CMAKE_SOURCE_DIR}/src/plugin/PrintITL/ConditionVisitor.cpp)

add_executable(PrintSkeleton_Test_Run ${SOURCE_FILES} ${GLOBAL_FILES})
target_link_libraries(PrintSkeleton_Test_Run parser)
target_link_libraries(PrintSkeleton_Test_Run ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgtest_main.a pthread)
