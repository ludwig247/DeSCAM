project(PrintITL_Test_Run C CXX)
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

get_directory_property(EXAMPLE_H DIRECTORY ${CMAKE_SOURCE_DIR}/example/ DEFINITION EXAMPLE_H_LIST)

foreach(EXAMPLE_H_FILE ${EXAMPLE_H})
#    get_filename_component(EXAMPLE_H_FILE_NAME ${EXAMPLE_H_FILE} NAME)
#    set(INCLUDE_HEADER "${INCLUDE_HEADER}#include \"${EXAMPLE_H_FILE}\" \n")
    list(APPEND INCLUDE_HEADER "${EXAMPLE_H_FILE}\n")
endforeach()

configure_file (
        "${CMAKE_SOURCE_DIR}/example/add_example/tests.h.in"
        "tests.h"
)

file(GLOB FUNC_TESTS "${CMAKE_CURRENT_SOURCE_DIR}/TestCases/*.h")
#message(STATUS ${CMAKE_CURRENT_SOURCE_DIR}/TestCases/Types.h)
list(REMOVE_ITEM FUNC_TESTS ${CMAKE_CURRENT_SOURCE_DIR}/TestCases/Types.h)
string(REPLACE ";" "\n" FUNC_TESTS "${FUNC_TESTS}")
file(WRITE functionality_tests.h "${FUNC_TESTS}")
