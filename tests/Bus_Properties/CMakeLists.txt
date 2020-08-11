#project(Operation_Test C CXX)
#cmake_minimum_required(VERSION 3.0)
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")
#
#
##DIRECTORIES
#set(SOURCE_FILES tests.cpp)
#
#add_executable(OperationGraphTest ${SOURCE_FILES} OperationGraphTest.h)
#target_link_libraries(OperationGraphTest PRIVATE parser)
#target_link_libraries(OperationGraphTest PRIVATE ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgmock_main.a pthread)

project(Bus_Properties C CXX)
cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")

add_executable(BusProperties tests.cpp
        ${CMAKE_SOURCE_DIR}/src/modelFactory/Optimizer/Utilities/OptUtilities.cpp
        ${CMAKE_SOURCE_DIR}/src/modelFactory/FindDataFlow.cpp
        ${CMAKE_SOURCE_DIR}/src/modelFactory/Optimizer/Optimizer.cpp
        ${CMAKE_SOURCE_DIR}/src/parser/CommandLineParameter.cpp
        OperationGraphTest.h )
target_compile_options(BusProperties PRIVATE -fPIC -O2 )

#TODO: factory should not be included
target_link_libraries(BusProperties PRIVATE parser)

target_link_libraries(BusProperties PRIVATE ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgtest_main.a pthread)




