cmake_minimum_required(VERSION 3.0)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_HOME_DIRECTORY}/bin)

# TODO: project name and supported languages
project(SCAM CXX)
# project version
set(VERSION_MAJOR 1)
set(VERSION_MINOR 0)
set(VERSION_PATCH 0)
# TODO: detect operating system and host processor
file(READ /etc/os-release OS)
string(REGEX MATCH "NAME=\"([A-z]+)+" _ ${OS})
set(OS_NAME ${CMAKE_MATCH_1})
string(REGEX MATCH "VERSION_ID=\"(([0-9]+.)?([0-9]+.)?([0-9]+))" _ ${OS})
set(OS_VERSION ${CMAKE_MATCH_1})
message(STATUS "We are on ${OS_NAME} ${OS_VERSION}  / ${CMAKE_SYSTEM_NAME} ${CMAKE_SYSTEM_VERSION}")

message(STATUS "The host processor is ${CMAKE_HOST_SYSTEM_PROCESSOR}")

# TODO: get rid of CMAKE_CXX_STANDARD
set(CMAKE_CXX_STANDARD 14) # C++14...
set(CMAKE_CXX_STANDARD_REQUIRED ON) #...is required...
set(CMAKE_CXX_EXTENSIONS OFF) #...without compiler extensions like gnu++11
set(CMAKE_BUILD_TYPE DEBUG)

set(SYSTEMC_VERSION 2.3.1a)
set(LLVM_VERSION 11.0.0)
set(GTEST_VERSION 1.10.0)
set(Z3_VERSION 4.8.6)

file(MAKE_DIRECTORY lib)
file(MAKE_DIRECTORY include)

set(CMAKE_EXTERNAL_PROJECT_DIR ${SCAM_SOURCE_DIR}/3rdParty)
file(MAKE_DIRECTORY ${CMAKE_EXTERNAL_PROJECT_DIR})


################################
# Debugging cmake
################################
message(STATUS "Current binary dir: ${CMAKE_CURRENT_BINARY_DIR}")
message(STATUS "Cmake generator: ${CMAKE_GENERATOR}")
message(STATUS "Project source dir: ${PROJECT_SOURCE_DIR}")
message(STATUS "Project binary dir: ${PROJECT_BINARY_DIR}")
message(STATUS "Cmake command: ${CMAKE_COMMAND}")

#################################
## ZLIB
#################################
# Do not use system's z3
set(USE_SYSTEM_ZLIB OFF CACHE BOOL "Use system zlib")
# Include the ExternalProject compilation
include(${PROJECT_SOURCE_DIR}/install/install_zlib.cmake)
message(STATUS "zlib library dir ${ZLIB_LIB_DIR}")
message(STATUS "zlib include dir ${ZLIB_INCLUDE_DIR}")
include_directories(${ZLIB_INCLUDE_DIR})

#################################
## Z3
#################################
# Do not use system's z3
set(USE_SYSTEM_Z3 OFF CACHE BOOL "Use system z3")
# Include the ExternalProject compilation
include(${PROJECT_SOURCE_DIR}/install/install_z3.cmake)
message(STATUS "z3 library dir ${Z3_LIB_DIR}")
message(STATUS "z3 include dir ${Z3_INCLUDE_DIR}")
include_directories(${Z3_INCLUDE_DIR})

#################################
## GTest
#################################
message(STATUS "Building with GTEST ${GTEST_VERSION}")
# Do not use system GoogleTest
set(USE_SYSTEM_GTEST OFF CACHE BOOL "Use system googletest")
set(SYSTEMC_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include)
# Include the ExternalProject compilation
include(${PROJECT_SOURCE_DIR}/install/install_gtest.cmake)
include_directories(${SYSTEMC_INCLUDE_DIR})

################################
# SystemC
################################

message(STATUS "Building with SYSTEMC ${SYSTEMC_VERSION}")
# Do not use system SystemC
set(USE_SYSTEM_SYSTEMC OFF CACHE BOOL "Use system SystemC")
set(SYSTEMC_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include)
# Include the ExternalProject compilation
include(${PROJECT_SOURCE_DIR}/install/install_systemc.cmake)
message(STATUS "SYSTEMC include dir: ${SYSTEMC_INCLUDE_DIR}")
include_directories(SYSTEMC_INCLUDE_DIR)

################################
# llvm
################################
# Do not use system LLVM
set(USE_SYSTEM_LLVM OFF CACHE BOOL "Use system LLVM")
message(STATUS "Building with LLVM ${LLVM_VERSION}")
# Include the ExternalProject compilation
include(${PROJECT_SOURCE_DIR}/install/install_llvm.cmake)
message(STATUS "LLVM include dir: ${LLVM_INCLUDE_DIR}")
message(STATUS "LLVM binary dir: ${LLVM_BINARY_DIR}")
message(STATUS "LLVM library dir: ${LLVM_LIB_DIR}")
include_directories(${LLVM_INCLUDE_DIR})

################################
# DESCAM
################################

# Create the file with the location of the home folder
execute_process(
COMMAND echo "#ifndef SCAM_CONFIG_HOME_H
#define SCAM_CONFIG_HOME_H\n
#define SCAM_HOME \"${PROJECT_SOURCE_DIR}\"
#define LLVM_BINARY_DIR \"${LLVM_BINARY_DIR}\"
#define LLVM_INCLUDE_DIR \"${LLVM_INCLUDE_DIR}\"
#define SYSTEMC_INCLUDE_DIR \"${SYSTEMC_INCLUDE_DIR}\"
\n#endif //SCAM_CONFIG_HOME_H"
OUTPUT_FILE ${PROJECT_SOURCE_DIR}/src/global/Config.h
)

# TODO: forget commands like add_compile_options, include_directories, link_directories, link_libraries
include_directories(${CMAKE_SOURCE_DIR}/include)

include_directories(${CMAKE_SOURCE_DIR}/example/Interfaces)
include_directories(${CMAKE_SOURCE_DIR}/src/plugin)
include_directories(${CMAKE_SOURCE_DIR}/src/parser)
include_directories(${CMAKE_SOURCE_DIR}/src/cfgFactory)
include_directories(${CMAKE_SOURCE_DIR}/src/ParseAML)
include_directories(${CMAKE_SOURCE_DIR}/src/global/)
include_directories(${CMAKE_SOURCE_DIR}/src/propertyFactory/)
include_directories(${CMAKE_SOURCE_DIR}/src/functionFactory)
include_directories(${CMAKE_SOURCE_DIR}/src/operationFactory/)
include_directories(${CMAKE_SOURCE_DIR}/src/propertyFactory/operationGraph)#do include this directory? its files already included in propertyFactory library
include_directories(${CMAKE_SOURCE_DIR}/src/propertySuite/)
include_directories(${CMAKE_SOURCE_DIR}/src/model/)
include_directories(${CMAKE_SOURCE_DIR}/src/model/Behavior)
include_directories(${CMAKE_SOURCE_DIR}/src/model/Stmts)#do include this directory? its files already included in model library
include_directories(${CMAKE_SOURCE_DIR}/src/model/propertySuite)
include_directories(${CMAKE_SOURCE_DIR}/src/modelFactory)
include_directories(${CMAKE_SOURCE_DIR}/src/modelFactory/CFG)#why include this directory?
include_directories(${CMAKE_SOURCE_DIR}/tests/)
include_directories(${CMAKE_SOURCE_DIR}/tests/GMock_Test/tests/mocks/modelFactory)

add_subdirectory(src)
add_subdirectory(example)
add_subdirectory(tests)
add_subdirectory(doc)

add_custom_target(SCAM DEPENDS SYSTEMC GTEST Z3 LLVM ZLIB)
add_custom_command(TARGET SCAM
        POST_BUILD
        COMMAND cmake --build ${PROJECT_BINARY_DIR}/ --target DESCAM -- -j 4)

include(${PROJECT_SOURCE_DIR}/install/create_dependency_graph.cmake)
# TODO maybe for safety erase build folder each time LIBS is build?
