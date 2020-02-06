cmake_minimum_required(VERSION 3.0)
project(wrapper CXX)


add_subdirectory(pybind11)


#add_executable(DESCAM main.cpp)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)

pybind11_add_module(wrapper MODULE wrappercode.cpp)
target_compile_options(wrapper PRIVATE -fPIC -O2 )
target_link_libraries(wrapper PRIVATE parser)




