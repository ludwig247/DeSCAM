cmake_minimum_required(VERSION 3.0)
project(DESCAM CXX)

add_subdirectory(CLI)

add_executable(DESCAM main.cpp CommandLineProcess.cpp CommandLineParameter.cpp CommandLineParametersConfig.cpp)

target_compile_options(DESCAM PRIVATE -O2)

include(ParserLib.cmake)
target_link_libraries(DESCAM parser)








