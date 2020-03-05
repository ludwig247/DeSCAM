project(PrintITL_Test_Run CXX)
cmake_minimum_required(VERSION 3.0)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

add_executable(PrintITL_Test_Run tests.cpp)
target_compile_options(PrintITL_Test_Run PRIVATE -fPIC -O2 )

#TODO: factory should not be included
target_link_libraries(PrintITL_Test_Run PRIVATE propertyFactory)
target_link_libraries(PrintITL_Test_Run PRIVATE modelFactory)
target_link_libraries(PrintITL_Test_Run PRIVATE optimizer)
target_link_libraries(PrintITL_Test_Run PRIVATE parser)

target_link_libraries(PrintITL_Test_Run PRIVATE ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgtest_main.a pthread)

#if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${third_arg}/ESL")
#    file(GLOB EXAMPLE_H "${third_arg}/ESL/*.h")
#    #        message(STATUS "${EXAMPLE_H}")
#else()
#    file(GLOB EXAMPLE_H "${third_arg}/*.h")
#    #        message(STATUS "${EXAMPLE_H}")
#endif()
#foreach(EXAMPLE_H_FILE ${EXAMPLE_H})
#    #            get_filename_component(EXAMPLE_H_FILE_NAME ${EXAMPLE_H_FILE} NAME)
#    set(INCLUDE_HEADER "${INCLUDE_HEADER}#include \"${EXAMPLE_H_FILE}\" \n")
#endforeach()
#foreach(TEST_DIRS ${TESTS})
#    configure_file (
#            "tests.h.in"
#            "${PROJECT_SOURCE_DIR}/tests/${TEST_DIRS}/TestCases/tests.h"
#    )
#endforeach()