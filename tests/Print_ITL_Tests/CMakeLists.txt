project(PrintITL_Test_Run CXX)
cmake_minimum_required(VERSION 3.0)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

add_executable(PrintITL_Test_Run tests.cpp TestCases/ModulesTernary.h)
target_compile_options(PrintITL_Test_Run PRIVATE -fPIC -O2 )

#TODO: factory should not be included
target_link_libraries(PrintITL_Test_Run PRIVATE propertyFactory)
target_link_libraries(PrintITL_Test_Run PRIVATE modelFactory)
target_link_libraries(PrintITL_Test_Run PRIVATE optimizer)
target_link_libraries(PrintITL_Test_Run PRIVATE parser)

target_link_libraries(PrintITL_Test_Run PRIVATE ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgtest_main.a pthread)

