project(Logger_Tests CXX)
cmake_minimum_required(VERSION 3.0)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")


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

add_executable(Logger_Tests ${SOURCE_FILES} ${GLOBAL_FILES} Logger_test.cpp)

target_link_libraries(Logger_Tests PRIVATE parser)
target_link_libraries(Logger_Tests PRIVATE ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgmock_main.a pthread)