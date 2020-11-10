project(GMock_Tests CXX)
cmake_minimum_required(VERSION 3.0)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

#find_package(GTest REQUIRED)
set (GTEST_LIBRARY ${CMAKE_SOURCE_DIR}/lib/libgtest.a)
set (GTEST_LIBRARY_MAIN ${CMAKE_SOURCE_DIR}/lib/libgtest.a)
#find_package(GMock REQUIRED)
set (GMOCK_LIBRARY ${CMAKE_SOURCE_DIR}/lib/libgmock.a)
set (GMOCK_LIBRARY_MAIN ${CMAKE_SOURCE_DIR}/lib/libgmock_main.a)

#TODO main should not need a main. The _main libraries from GTest/Mock should suffice.
add_executable(GMock_Tests main.cpp)
target_compile_options(GMock_Tests PRIVATE -fPIC -O2 )

target_include_directories(GMock_Tests PUBLIC ${CMAKE_SOURCE_DIR}/mocks/)

#TODO: factory should not be included
target_link_libraries(GMock_Tests PRIVATE parser)

target_link_libraries(GMock_Tests PRIVATE ${GTEST_LIBRARY} ${GTEST_LIBRARY_MAIN} ${GMOCK_LIBRARY} ${GMOCK_LIBRARY_MAIN} pthread)
