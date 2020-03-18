cmake_minimum_required(VERSION 3.0)
project(wrapper CXX)

add_subdirectory(pybind)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

pybind11_add_module(wrapper MODULE descamCheck.cpp)
target_compile_options(wrapper PRIVATE -fPIC -O2 )
target_link_libraries(wrapper PRIVATE parser)

configure_file(wrapper.py ${CMAKE_SOURCE_DIR}/bin/wrapper/wrapper.py COPYONLY)

file(GLOB LIB_FILES ${CMAKE_SOURCE_DIR}/bin/lib/*.so)
foreach(LibFile IN LISTS LIB_FILES)
    get_filename_component(filename ${LibFile} NAME)
    configure_file(${LibFile} ${CMAKE_SOURCE_DIR}/bin/wrapper/${filename} COPYONLY)
endforeach()

