cmake_minimum_required(VERSION 3.0)
set( CMAKE_RUNTIME_OUTPUT_DIRECTORY  ${CMAKE_HOME_DIRECTORY}/bin)

set(CMAKE_CXX_STANDARD 11) # C++11...
set(CMAKE_CXX_STANDARD_REQUIRED ON) #...is required...
set(CMAKE_CXX_EXTENSIONS OFF) #...without compiler extensions like gnu++11



include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${CMAKE_SOURCE_DIR}/example/Interfaces)
include_directories(${CMAKE_SOURCE_DIR}/src/plugin)
include_directories(${CMAKE_SOURCE_DIR}/src/ParseAML)
include_directories(${CMAKE_SOURCE_DIR}/src/global/)
include_directories(${CMAKE_SOURCE_DIR}/src/propertyFactory/)
include_directories(${CMAKE_SOURCE_DIR}/src/propertyFactory/operationGraph)#do include this directory? its files already included in propertyFactory library
include_directories(${CMAKE_SOURCE_DIR}/src/model/)
include_directories(${CMAKE_SOURCE_DIR}/src/model/Stmts)#do include this directory? its files already included in model library
include_directories(${CMAKE_SOURCE_DIR}/src/modelFactory)
include_directories(${CMAKE_SOURCE_DIR}/src/modelFactory/CFG)#why include this directory?
include_directories(${CMAKE_SOURCE_DIR}/tests/)

add_subdirectory(src)
add_subdirectory(example)
add_subdirectory(tests)
add_subdirectory(doc)
