project(GMock_Test CXX)
cmake_minimum_required(VERSION 3.0)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

add_executable(GMock_Test main.cpp TestCase1.h)
target_compile_options(GMock_Test PRIVATE -fPIC -O2 )

#TODO: factory should not be included
target_link_libraries(GMock_Test PRIVATE propertyFactory)
target_link_libraries(GMock_Test PRIVATE modelFactory)
target_link_libraries(GMock_Test PRIVATE optimizer)
target_link_libraries(GMock_Test PRIVATE parser)

target_link_libraries(GMock_Test PRIVATE ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgtest_main.a pthread)

