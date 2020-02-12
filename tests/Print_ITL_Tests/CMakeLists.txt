project(PrintITL_Test_Run C CXX)
cmake_minimum_required(VERSION 2.8)

add_executable(PrintITL_Test_Run tests.cpp)
target_link_libraries(PrintITL_Test_Run parser)
target_link_libraries(PrintITL_Test_Run ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgtest_main.a pthread)

