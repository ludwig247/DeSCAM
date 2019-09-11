project(DataType_Test C CXX)
cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")


#DIRECTORIES
set(SOURCE_FILES tests.cpp
        Unsigned.h)

set(GLOBAL_FILES
        ${CMAKE_SOURCE_DIR}/src/global/DataTypes.cpp
        ${CMAKE_SOURCE_DIR}/src/global/PrintStmt.cpp
        ${CMAKE_SOURCE_DIR}/src/global/ExprVisitor.cpp
        ${CMAKE_SOURCE_DIR}/src/global/SimplifyVisitor.cpp
        ${CMAKE_SOURCE_DIR}/src/global/StmtNodeAlloc.cpp
        ${CMAKE_SOURCE_DIR}/src/global/NodePeekVisitor.cpp
        ../Module_Test/Module_Test.h
        ../Model_Test/Variable_Test.h
        ../Stmts_Test/Stmt_Compare_Tests.h )

add_executable(DataType_Test ${SOURCE_FILES} ${GLOBAL_FILES})
target_link_libraries(DataType_Test Stmts)
target_link_libraries(DataType_Test Model)
target_link_libraries(DataType_Test ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgtest_main.a pthread)
