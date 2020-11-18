project(PrintSVA_Test_Run CXX)
cmake_minimum_required(VERSION 3.0)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

add_executable(PrintSVA_Test_Run tests.cpp)
target_compile_options(PrintSVA_Test_Run PRIVATE -fPIC -O2)

target_link_libraries(PrintSVA_Test_Run PRIVATE parser)
target_link_libraries(PrintSVA_Test_Run PRIVATE ${CMAKE_SOURCE_DIR}/lib/libgtest.a ${CMAKE_SOURCE_DIR}/lib/libgtest_main.a pthread)

file(GLOB FUNC_TESTS "${CMAKE_SOURCE_DIR}/tests/TestCases/ModuleArrays/*.h"
                     "${CMAKE_SOURCE_DIR}/tests/TestCases/ModuleFunctions/*.h"
                     "${CMAKE_SOURCE_DIR}/tests/TestCases/ModulesBasic/*.h"
                     "${CMAKE_SOURCE_DIR}/tests/TestCases/ModulesGlobal/*.h"
                     "${CMAKE_SOURCE_DIR}/tests/TestCases/ModulesMasterSlave/*.h"
                     "${CMAKE_SOURCE_DIR}/tests/TestCases/ModuleStateNames/*.h"
                     "${CMAKE_SOURCE_DIR}/tests/TestCases/ModulesTernary/*.h"
        )
string(REPLACE ";" "\n" FUNC_TESTS "${FUNC_TESTS}")
file(WRITE functionality_tests.list "${FUNC_TESTS}")
