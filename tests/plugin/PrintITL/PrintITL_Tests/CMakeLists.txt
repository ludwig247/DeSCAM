project(PrintITL_Tests CXX)
cmake_minimum_required(VERSION 3.0)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

add_executable(PrintITL_Tests tests.cpp)
target_include_directories(GMock_Tests PUBLIC ${CMAKE_SOURCE_DIR}/mocks/)

target_compile_options(PrintITL_Tests PRIVATE -fPIC -O2 )

#TODO: factory should not be included
target_link_libraries(PrintITL_Tests PRIVATE propertyFactory)
target_link_libraries(PrintITL_Tests PRIVATE modelFactory)
target_link_libraries(PrintITL_Tests PRIVATE optimizer)
target_link_libraries(PrintITL_Tests PRIVATE parser)

target_link_libraries(PrintITL_Tests PRIVATE ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgtest_main.a pthread)


