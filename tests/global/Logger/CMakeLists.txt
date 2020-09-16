project(Logger_Test C CXX)
cmake_minimum_required(VERSION 3.0)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")

link_directories(${CMAKE_SOURCE_DIR}/lib/)
set(SOURCE_FILES tests.cpp)
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
        ${CMAKE_SOURCE_DIR}/src/global/Config.h
        ${LOGGER_SRC}
        )

add_executable(Logger_Test ${SOURCE_FILES} ${GLOBAL_FILES} Logger_test.cpp)
target_link_libraries(Logger_Test z3)
target_link_libraries(Logger_Test Stmts)
target_link_libraries(Logger_Test Model)
target_link_libraries(Logger_Test ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgmock_main.a pthread)