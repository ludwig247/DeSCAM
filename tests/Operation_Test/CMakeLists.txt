project(Operation_Test C CXX)
cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")


#DIRECTORIES
set(SOURCE_FILES tests.cpp)

add_executable(OperationGraphTest ${SOURCE_FILES} OperationGraphTest.h)
target_link_libraries(OperationGraphTest parser)
target_link_libraries(OperationGraphTest ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgmock_main.a pthread)


