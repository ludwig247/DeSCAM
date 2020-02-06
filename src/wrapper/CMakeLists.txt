cmake_minimum_required(VERSION 3.0)
project(wrapper CXX)


add_subdirectory(pybind11)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

pybind11_add_module(wrapper MODULE wrappercode.cpp)
target_compile_options(wrapper PRIVATE -fPIC -O2 )
target_link_libraries(wrapper PRIVATE parser)

configure_file(wrapper.py ${CMAKE_SOURCE_DIR}/bin/wrapper/wrapper.py COPYONLY)
file(COPY ${CMAKE_SOURCE_DIR}/bin/lib/ DESTINATION ${CMAKE_SOURCE_DIR}/bin/wrapper/)




