cmake_minimum_required(VERSION 3.0)
project(wrapper CXX)


add_subdirectory(pybind)
set(CMAKE_POSITION_INDEPENDENT_CODE OFF)

pybind11_add_module(wrapper MODULE wrappercode.cpp)
target_compile_options(wrapper PRIVATE -fPIC -O2 )
target_link_libraries(wrapper PRIVATE parser)

configure_file(wrapper.py ${CMAKE_SOURCE_DIR}/bin/wrapper/wrapper.py COPYONLY)
#file(COPY ${CMAKE_SOURCE_DIR}/lib/ DESTINATION ${CMAKE_SOURCE_DIR}/bin/wrapper/)






