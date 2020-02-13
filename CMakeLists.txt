cmake_minimum_required(VERSION 3.0)
project(DeSCAM)
set( CMAKE_RUNTIME_OUTPUT_DIRECTORY  ${CMAKE_HOME_DIRECTORY}/bin)


#set (TEST_DESCRIPTIONS "")
#set (TEST_DIRECTORIES "")
#set (OPTION_NAMES "")
#set (OPTION_DESCRIPTIONS "")
#set (OPTIMIZE_OPTIONS, "")
#set (OPTIMIZE_OPTIONS_DESCRIPTIONS, "")
set(CMAKE_CXX_STANDARD 14) # C++14...
set(CMAKE_CXX_STANDARD_REQUIRED ON) #...is required...
set(CMAKE_CXX_EXTENSIONS OFF) #...without compiler extensions like gnu++11
set (TEST_NAMES "")

include(AddTest.cmake)

message(STATUS "${TEST_NAMES}")
include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${CMAKE_SOURCE_DIR}/example/Interfaces)
include_directories(${CMAKE_SOURCE_DIR}/src/plugin)
include_directories(${CMAKE_SOURCE_DIR}/src/ParseAML)
include_directories(${CMAKE_SOURCE_DIR}/src/global/)
include_directories(${CMAKE_SOURCE_DIR}/src/operationFactory/)
include_directories(${CMAKE_SOURCE_DIR}/src/cfgFactory/)
include_directories(${CMAKE_SOURCE_DIR}/src/functionFactory/)
include_directories(${CMAKE_SOURCE_DIR}/src/propertyFactory/)
include_directories(${CMAKE_SOURCE_DIR}/src/propertyFactory/operationGraph)#do include this directory? its files already included in propertyFactory library
include_directories(${CMAKE_SOURCE_DIR}/src/propertySuite/)
include_directories(${CMAKE_SOURCE_DIR}/src/model/)
include_directories(${CMAKE_SOURCE_DIR}/src/model/Stmts)#do include this directory? its files already included in model library
include_directories(${CMAKE_SOURCE_DIR}/src/modelFactory)
include_directories(${CMAKE_SOURCE_DIR}/src/modelFactory/CFG)#why include this directory?
include_directories(${CMAKE_SOURCE_DIR}/src/modelFactory/CFG/new)#why include this directory?
include_directories(${CMAKE_SOURCE_DIR}/tests/)

add_subdirectory(src)
add_subdirectory(example)
add_subdirectory(tests)
add_subdirectory(doc)



# add Backend directory first in order to get all added plugins and options by the users
#add_subdirectory(example)
get_directory_property(TEST_NAMES DIRECTORY ${CMAKE_SOURCE_DIR}/example/ DEFINITION TEST_NAMES)
get_directory_property(TEST_DESCRIPTIONS DIRECTORY ${CMAKE_SOURCE_DIR}/example/ DEFINITION TEST_DESCRIPTIONS)
#get_directory_property(TEST_DIRECTORIES DIRECTORY ${CMAKE_SOURCE_DIR}/example/ DEFINITION TEST_DIRECTORIES)
##get_directory_property(OPTION_NAMES DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION OPTION_NAMES)
##get_directory_property(OPTION_DESCRIPTIONS DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION OPTION_DESCRIPTIONS)
##get_directory_property(OPTIMIZE_OPTIONS DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION OPTIMIZE_OPTIONS)
##get_directory_property(OPTIMIZE_OPTIONS_DESCRIPTIONS DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION OPTIMIZE_OPTIONS_DESCRIPTIONS)

# configure a header file to pass plugins and options of the CMake settings to the source code
configure_file (
        "${PROJECT_SOURCE_DIR}/tests/testheaders.h.in"
        "${PROJECT_SOURCE_DIR}/tests/testheaders.h"
)




#list(REMOVE_DUPLICATES  TEST_DIRECTORIES)
#foreach (tests_dir ${TEST_DIRECTORIES})
#    #        MESSAGE(STATUS "adding ${plugin_dir}")
#    add_subdirectory(${CMAKE_SOURCE_DIR}/example/${tests_dir})
#endforeach ()

#message(STATUS "${TEST_NAMES}" )
#message( ${CMAKE_CURRENT_SOURCE_DIR} )
