project(OperationOptimizations C CXX)
cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")


#DIRECTORIES
set(GLOBAL_FILES tests.cpp)

link_directories(${CMAKE_SOURCE_DIR}/lib/)
FILE(GLOB LOGGER_SRC "${CMAKE_SOURCE_DIR}/src/global/Logger/*.cpp" "${CMAKE_SOURCE_DIR}/src/Model/LocationInfo.cpp")


set(GLOBAL_FILES
        ${CMAKE_SOURCE_DIR}/src/global/DataTypes.cpp
        ${CMAKE_SOURCE_DIR}/src/global/PrintStmt.cpp
        ${CMAKE_SOURCE_DIR}/src/global/ExprTranslator.cpp
        ${CMAKE_SOURCE_DIR}/src/global/ExprVisitor.cpp
        ${CMAKE_SOURCE_DIR}/src/global/SimplifyVisitor.cpp
        ${CMAKE_SOURCE_DIR}/src/global/StmtNodeAlloc.cpp
        ${CMAKE_SOURCE_DIR}/src/global/NodePeekVisitor.cpp
        ${CMAKE_SOURCE_DIR}/src/global/RecursiveVisitor.cpp
        ${LOGGER_SRC}
        )

add_executable(TernaryOptimizerTest ${SOURCE_FILES} ${GLOBAL_FILES} t_TernaryOptimizer.cpp
        ${CMAKE_SOURCE_DIR}/src/operationFactory/OperationOptimizations/TernaryOptimizer.cpp
        ${CMAKE_SOURCE_DIR}/src/operationFactory/OperationOptimizations/ConditionOptimizer2.cpp)
target_link_libraries(TernaryOptimizerTest z3)
target_link_libraries(TernaryOptimizerTest Stmts)
target_link_libraries(TernaryOptimizerTest Model)

target_link_libraries(TernaryOptimizerTest ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgmock_main.a pthread)


