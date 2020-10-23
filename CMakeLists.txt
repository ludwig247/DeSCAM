cmake_minimum_required(VERSION 3.0)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_HOME_DIRECTORY}/bin)

# TODO: project name and supported languages
project(SCAM CXX)
# project version
set(VERSION_MAJOR 1)
set(VERSION_MINOR 0)
set(VERSION_PATCH 0)
# TODO: detect operating system and host processor
message(STATUS "We are on a ${CMAKE_SYSTEM_NAME} system")
message(STATUS "The host processor is ${CMAKE_HOST_SYSTEM_PROCESSOR}")

# TODO: get rid of CMAKE_CXX_STANDARD
set(CMAKE_CXX_STANDARD 14) # C++14...
set(CMAKE_CXX_STANDARD_REQUIRED ON) #...is required...
set(CMAKE_CXX_EXTENSIONS OFF) #...without compiler extensions like gnu++11
set(CMAKE_BUILD_TYPE Debug)

################################
# Debugging cmake
################################
message(STATUS "Current binary dir: ${CMAKE_CURRENT_BINARY_DIR}")
message(STATUS "Cmake generator: ${CMAKE_GENERATOR}")
message(STATUS "Project source dir: ${PROJECT_SOURCE_DIR}")
message(STATUS "Project binary dir: ${PROJECT_BINARY_DIR}")
message(STATUS "Cmake command: ${CMAKE_COMMAND}")

################################
# Unzip the files
################################
#execute_process(
#        COMMAND unzip -n ${CMAKE_CURRENT_SOURCE_DIR}/install/install_new.zip -d ${CMAKE_CURRENT_SOURCE_DIR}/install/tmp
#)
#
#
## Delete std::gets line from systemc because it is not supported in c++11 and newer
#execute_process(
#        COMMAND sed -i "s@using\ std::gets;@//using\ //std::gets;@g" ${CMAKE_CURRENT_SOURCE_DIR}/install/tmp/systemc-2.3.1/src/systemc.h
#)
#
## Create the file with the location of the home folder
#execute_process(
#        COMMAND echo "#ifndef SCAM_CONFIG_HOME_H\n#define SCAM_CONFIG_HOME_H\n#define SCAM_HOME \"${PROJECT_SOURCE_DIR}\"\n#endif"
#        OUTPUT_FILE ${PROJECT_SOURCE_DIR}/src/global/Config.h
#)

set(CMAKE_EXTERNAL_PROJECT_DIR ${SCAM_SOURCE_DIR}/3rdParty)
file(MAKE_DIRECTORY ${CMAKE_EXTERNAL_PROJECT_DIR})

#################################
## Z3
#################################
# Do not use system's z3
set(USE_SYSTEM_Z3 OFF CACHE BOOL "Use system z3")
set(Z3_STABLE 4.8.6)
set(Z3_DEV 4.8.6)
set(Z3_VERSIONS ${Z3_STABLE})
# Include the ExternalProject compilation
include(${PROJECT_SOURCE_DIR}/install/install_z3.cmake)

#################################
## GTest
#################################
# Do not use system GoogleTest
set(USE_SYSTEM_GTEST OFF CACHE BOOL "Use system googletest")
# Set the Version you want
set(GTEST_STABLE 1.10.0)
set(GTEST_DEV 1.10.0)
set(GTEST_VERSIONS ${GTEST_STABLE})
# Include the ExternalProject compilation
include(${PROJECT_SOURCE_DIR}/install/install_gtest.cmake)

################################
# SystemC
################################
# Do not use system SystemC
set(USE_SYSTEM_SYSTEMC OFF CACHE BOOL "Use system SystemC")

set(SYSTEMC_STABLE 2.3.1a)
set(SYSTEMC_DEV 2.3.1a)
set(SYSTEMC_VERSIONS ${SYSTEMC_STABLE})
# Include the ExternalProject compilation
include(${PROJECT_SOURCE_DIR}/install/install_systemc.cmake)


################################
# llvm
################################
# Do not use system LLVM
set(LLVM_STABLE 3.4.2)
set(LLVM_DEV 11.0.0)
set(LLVM_VERSIONS ${LLVM_STABLE} ${LLVM_DEV})
set(USE_SYSTEM_LLVM OFF CACHE BOOL "Use system LLVM")

# Include the ExternalProject compilation
include(${PROJECT_SOURCE_DIR}/install/install_llvm.cmake)

# Include the binary
include_directories(${LLVM_INCLUDES})


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


include(${PROJECT_SOURCE_DIR}/install/utils.cmake)
blue_green_deployment(
        DESCAM
        GMock_Test
        PrintITL_Test_Run
        PrintSkeleton_Test_Run
)