cmake_minimum_required(VERSION 3.0)

set( CMAKE_RUNTIME_OUTPUT_DIRECTORY  ${CMAKE_HOME_DIRECTORY}/bin)

# TODO: project name and supported languages
project(SCAM CXX)
# project version
set(VERSION_MAJOR 1)
set(VERSION_MINOR 0)
set(VERSION_PATCH 0)

############################################################################
# TODO: Safeguards
#if(NOT CMAKE_BUILD_TYPE)
#    set(CMAKE_BUILD_TYPE "Release")
#endif()
#
#if(${PROJECT_SOURCE_DIR} STREQUAL ${PROJECT_BINARY_DIR})
#    message(FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there.")
#endif()
#
#string(TOLOWER "${CMAKE_BUILD_TYPE}" cmake_build_type_tolower)
#string(TOUPPER "${CMAKE_BUILD_TYPE}" cmake_build_type_toupper)
#
#if(NOT cmake_build_type_tolower STREQUAL "debug" AND
#        NOT cmake_build_type_tolower STREQUAL "release" AND
#        NOT cmake_build_type_tolower STREQUAL "minsizerel" AND
#        NOT cmake_build_type_tolower STREQUAL "relwithdebinfo")
#    message(FATAL_ERROR "Unknown build type \"${CMAKE_BUILD_TYPE}\". Allowed values are Debug, Release, RelWithDebInfo, and MinSizeRel (case-insensitive).")
#endif()
##############################################################################


# TODO: detect operating system and host processor
message(STATUS "We are on a ${CMAKE_SYSTEM_NAME} system")
message(STATUS "The host processor is ${CMAKE_HOST_SYSTEM_PROCESSOR}")

# TODO: get rid of CMAKE_CXX_STANDARD
set(CMAKE_CXX_STANDARD 14) # C++14...
set(CMAKE_CXX_STANDARD_REQUIRED ON) #...is required...
set(CMAKE_CXX_EXTENSIONS OFF) #...without compiler extensions like gnu++11
# TODO: this instead
## example how to set c++ compiler flags for GNU
#if(CMAKE_CXX_COMPILER_ID MATCHES GNU)
#    set(CMAKE_CXX_FLAGS         "${CMAKE_CXX_FLAGS} -Wall -Wno-unknown-pragmas -Wno-sign-compare -Woverloaded-virtual -Wwrite-strings -Wno-unused")
#    set(CMAKE_CXX_FLAGS_DEBUG   "-O0 -g3")
#    set(CMAKE_CXX_FLAGS_RELEASE "-O3")
#    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fprofile-arcs -ftest-coverage")
#endif()

# TODO: not sure if I need this
## place binaries and libraries according to GNU standards
#include(GNUInstallDirs)
#set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
#set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
#set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})

# TODO: configuring varialbes for C++ (also not sure)
##define VERSION_MAJOR @VERSION_MAJOR@
##define VERSION_MINOR @VERSION_MINOR@
##define VERSION_PATCH @VERSION_PATCH@
#
#const char *GIT_REVISION = "@GIT_REVISION@";

# IMPORTANT Cross compilation requirenments
#CMAKE_SYSTEM_NAME (mandatory), e.g., "Linux", "Windows", "Darwin"
#CMAKE_SYSTEM_VERSION (optional)
#CMAKE_SYSTEM_PROCESSOR (optional), e.g., "i386", "x86_64", "ppc", "ppc64"
#CMAKE_C_COMPILER (mandatory), name of C compiler executable
#CMAKE_CXX_COMPILER (mandatory), name of C compiler executable
#CMAKE_FIND_ROOT_PATH (optional), root to target include and library directories
#CMAKE_FIND_ROOT_PATH_MODE_PROGRAM, either "NEVER", "ONLY", or "BOTH" (default)
#CMAKE_FIND_ROOT_PATH_MODE_LIBRARY, either "NEVER", "ONLY", or "BOTH" (default)
#CMAKE_FIND_ROOT_PATH_MODE_INCLUDE, either "NEVER", "ONLY", or "BOTH" (default)






# 4 libraries
## Z3 - Cmake, repo (https://github.com/Z3Prover/z3 commit: e518d4a5fe3b824d5e9deb3d16eb1faa248a52d8)
## Gtest - Cmake, repo (https://github.com/google/googletest commit: 0fe96607d85cf3a25ac40da369db62bbee2939a5)
## SystemC - Cmake, repo (https://github.com/accellera-official/systemc.git commit: 925838a21a90d4b98bde44a7cd5120361bd699a3
## llvm - Cmake, repo (https://github.com/llvm/llvm-project) tag: release/3.4.x | path: llvm-project/llvm/






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
execute_process(
        COMMAND unzip -n ${CMAKE_CURRENT_SOURCE_DIR}/install/install_new.zip -d ${CMAKE_CURRENT_SOURCE_DIR}/install/tmp
)


# Detele std::gets line from systemc because it is not supported in c++11 and newer
execute_process(
        COMMAND sed -i "s@using\ std::gets;@//using\ //std::gets;@g" ${CMAKE_CURRENT_SOURCE_DIR}/install/tmp/systemc-2.3.1/src/systemc.h
)

# Create the file with the location of the home folder
execute_process(
        COMMAND echo "#ifndef SCAM_CONFIG_HOME_H\n#define SCAM_CONFIG_HOME_H\n#define SCAM_HOME \"${PROJECT_SOURCE_DIR}\"\n#endif"
        OUTPUT_FILE ${PROJECT_SOURCE_DIR}/src/global/Config.h
)




### Z3 - Cmake, repo (https://github.com/Z3Prover/z3 commit: e518d4a5fe3b824d5e9deb3d16eb1faa248a52d8)
### Z3 version 4.4.2.1
### Z3 date 30 Jun 2016
### Z3 starting from 4.6.0 does not need pythong for the installation
#################################
## Z3
#################################
# Do not use system's z3
set(USE_SYSTEM_Z3 OFF CACHE BOOL "Use system z3")

# Include the ExternalProject compilation
include(${PROJECT_SOURCE_DIR}/install/install_z3.make)

# Include compiled binaries
#include_directories( ${Z3_INCLUDES} )



#################################
## GTest
#################################
# Do not use system GoogleTest
set(USE_SYSTEM_GTEST OFF CACHE BOOL "Use system googletest")

# Include the ExternalProject compilation
include(${PROJECT_SOURCE_DIR}/install/install_gtest.make)

# Include the binary
#include_directories( ${GTEST_INCLUDES} )





## SystemC - Cmake, repo (https://github.com/accellera-official/systemc.git commit: 925838a21a90d4b98bde44a7cd5120361bd699a3
################################
# SystemC
################################
# Do not use system SystemC
set(USE_SYSTEM_SYSTEMC OFF CACHE BOOL "Use system SystemC")

# Include the ExternalProject compilation
include(${PROJECT_SOURCE_DIR}/install/install_systemc.make)

# Include the binary
#include_directories( ${SYSTEMC_INCLUDES} )





## llvm - Cmake, repo (https://github.com/llvm/llvm-project.git) tag: release/3.4.x | path: llvm-project/llvm/
################################
# llvm
################################
# Do not use system LLVM
set(USE_SYSTEM_LLVM OFF CACHE BOOL "Use system LLVM")

# Include the ExternalProject compilation
include(${PROJECT_SOURCE_DIR}/install/install_llvm.make)

# Include the binary
#include_directories( ${LLVM_INCLUDES} )



# TODO: forget commands like add_compile_options, include_directories, link_directories, link_libraries
include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${CMAKE_SOURCE_DIR}/example/Interfaces)
include_directories(${CMAKE_SOURCE_DIR}/src/plugin)
include_directories(${CMAKE_SOURCE_DIR}/src/ParseAML)
include_directories(${CMAKE_SOURCE_DIR}/src/global/)
include_directories(${CMAKE_SOURCE_DIR}/src/propertyFactory/)
include_directories(${CMAKE_SOURCE_DIR}/src/propertyFactory/operationGraph)#do include this directory? its files already included in propertyFactory library
include_directories(${CMAKE_SOURCE_DIR}/src/propertySuite/)
include_directories(${CMAKE_SOURCE_DIR}/src/model/)
include_directories(${CMAKE_SOURCE_DIR}/src/model/Stmts)#do include this directory? its files already included in model library
include_directories(${CMAKE_SOURCE_DIR}/src/modelFactory)
include_directories(${CMAKE_SOURCE_DIR}/src/modelFactory/CFG)#why include this directory?
include_directories(${CMAKE_SOURCE_DIR}/tests/)

add_subdirectory(src)
add_subdirectory(example)
add_subdirectory(tests)
add_subdirectory(doc)

# TODO: cpack generates installer
#include(InstallRequiredSystemLibraries)
#set(CPACK_PACKAGE_CONTACT "Kilgore Trout")
#include(CPack)

# Notes: for library linking
#target_link_libraries(cmake_example ${FFTW_LIBRARIES} ${SYSTEMC_LIBRARIES} m)