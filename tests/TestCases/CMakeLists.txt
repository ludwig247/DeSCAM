get_directory_property(EXAMPLE_H DIRECTORY ${CMAKE_SOURCE_DIR}/example DEFINITION EXAMPLE_H_LIST)

foreach(EXAMPLE_H_FILE ${EXAMPLE_H})
    #    get_filename_component(EXAMPLE_H_FILE_NAME ${EXAMPLE_H_FILE} NAME)
    #    set(INCLUDE_HEADER "${INCLUDE_HEADER}#include \"${EXAMPLE_H_FILE}\" \n")
    list(APPEND INCLUDE_HEADER "${EXAMPLE_H_FILE}\n")
endforeach()

string(REGEX REPLACE "^;" "" INCLUDE_HEADER ${INCLUDE_HEADER})
configure_file (
        "${CMAKE_SOURCE_DIR}/example/add_example/templates/tests.h.in"
        "${CMAKE_SOURCE_DIR}/tests/TestCases/tests.list"
)

file(GLOB FUNC_TESTS "${CMAKE_SOURCE_DIR}/tests/TestCases/ModulesTernary/*.h"
        "${CMAKE_SOURCE_DIR}/tests/TestCases/ModuleArrays/*.h"
        "${CMAKE_SOURCE_DIR}/tests/TestCases/ModuleStateNames/*.h"
        "${CMAKE_SOURCE_DIR}/tests/TestCases/ModulesBasic/*.h"
        "${CMAKE_SOURCE_DIR}/tests/TestCases/ModulesMasterSlave/*.h"
        "${CMAKE_SOURCE_DIR}/tests/TestCases/ModulesGlobal/*.h"
        )
#message(STATUS "${INCLUDE_HEADER}")
list(REMOVE_ITEM FUNC_TESTS ${CMAKE_SOURCE_DIR}/tests/TestCases/Types.h)
string(REPLACE ";" "\n" FUNC_TESTS "${FUNC_TESTS}")
file(WRITE ${CMAKE_SOURCE_DIR}/tests/TestCases/functionality_tests.list "${FUNC_TESTS}")