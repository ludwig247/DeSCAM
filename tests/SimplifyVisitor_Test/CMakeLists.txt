project(SimplifyVisitor_Test C CXX)
cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")


#DIRECTORIES
set(SOURCE_FILES tests.cpp SimplifyVisitor_Test.h
       )

link_directories(${CMAKE_SOURCE_DIR}/lib/)

set(GLOBAL_FILES
        ${CMAKE_SOURCE_DIR}/src/global/DataTypes.cpp
        ${CMAKE_SOURCE_DIR}/src/global/PrintStmt.cpp
        ${CMAKE_SOURCE_DIR}/src/global/ExprVisitor.cpp
        ${CMAKE_SOURCE_DIR}/src/global/SimplifyVisitor.cpp
        ${CMAKE_SOURCE_DIR}/src/global/StmtNodeAlloc.cpp
        ${CMAKE_SOURCE_DIR}/src/global/NodePeekVisitor.cpp)

add_executable(SimplifyVisitor_Test ${SOURCE_FILES} ${GLOBAL_FILES})
target_link_libraries(SimplifyVisitor_Test Stmts)
target_link_libraries(SimplifyVisitor_Test Model)
target_link_libraries(SimplifyVisitor_Test ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgmock_main.a pthread)
