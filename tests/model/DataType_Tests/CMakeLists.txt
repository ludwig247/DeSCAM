project(DataType_Test C CXX)
cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")

#find_package(GTest REQUIRED)
set (GTEST_LIBRARY ${CMAKE_SOURCE_DIR}/lib/libgtest.a)
set (GTEST_LIBRARY_MAIN ${CMAKE_SOURCE_DIR}/lib/libgtest.a)
#find_package(GMock REQUIRED)
set (GMOCK_LIBRARY ${CMAKE_SOURCE_DIR}/lib/libgmock.a)
set (GMOCK_LIBRARY_MAIN ${CMAKE_SOURCE_DIR}/lib/libgmock_main.a)

set(GLOBAL_FILES
        ${CMAKE_SOURCE_DIR}/src/global/DataTypes.cpp
        ${CMAKE_SOURCE_DIR}/src/global/PrintStmt.cpp
        ${CMAKE_SOURCE_DIR}/src/global/ExprVisitor.cpp
        ${CMAKE_SOURCE_DIR}/src/global/SimplifyVisitor.cpp
        ${CMAKE_SOURCE_DIR}/src/global/StmtNodeAlloc.cpp
        ${CMAKE_SOURCE_DIR}/src/global/NodePeekVisitor.cpp
        /home/tobias/install_test/src/global/Logger/Logger.cpp
        /home/tobias/install_test/src/global/Logger/LoggerMsg.cpp
        /home/tobias/install_test/src/global/Logger/LoggerFormatter.cpp
        /home/tobias/install_test/src/global/Logger/FileSink.cpp
        /home/tobias/install_test/src/global/Logger/ConsoleSink.cpp)


add_executable(DataType_Tests tests.cpp ${GLOBAL_FILES} )
target_link_libraries(DataType_Tests PRIVATE parser)
target_link_libraries(DataType_Tests PRIVATE ${GTEST_LIBRARY} ${GTEST_LIBRARY_MAIN} ${GMOCK_LIBRARY} ${GMOCK_LIBRARY_MAIN} pthread)
