project(GMock_Test CXX)
cmake_minimum_required(VERSION 3.0)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

#find_package(GTest REQUIRED)
set (GTEST_LIBRARY libgtest.a)
set (GTEST_LIBRARY_MAIN libgtest.a)
#find_package(GMock REQUIRED)
set (GMOCK_LIBRARY libgmock.a)
set (GMOCK_LIBRARY_MAIN libgmock_main.a)

add_executable(GMock_Test main.cpp)
target_compile_options(GMock_Test PRIVATE -fPIC -O2 )

#TODO: factory should not be included
target_link_libraries(GMock_Test PRIVATE parser)


target_link_libraries(GMock_Test PRIVATE ${GTEST_LIBRARY} ${GTEST_LIBRARY_MAIN} ${GMOCK_LIBRARY} ${GMOCK_LIBRARY_MAIN} pthread)

include_directories(tests/mocks/modelFactory)