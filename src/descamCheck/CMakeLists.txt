cmake_minimum_required(VERSION 3.0)
project(descamCheck CXX)

add_subdirectory(pybind)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

pybind11_add_module(descamCheck MODULE checkFile.cpp)
target_compile_options(descamCheck PRIVATE -fPIC -O2 )
target_link_libraries(descamCheck PRIVATE parser)

configure_file(descam_check.py ${CMAKE_SOURCE_DIR}/bin/descam_check/descam_check.py COPYONLY)

file(GLOB LIB_FILES ${CMAKE_SOURCE_DIR}/bin/lib/*.so)
foreach(LibFile IN LISTS LIB_FILES)
    get_filename_component(filename ${LibFile} NAME)
    configure_file(${LibFile} ${CMAKE_SOURCE_DIR}/bin/descam_check/${filename} COPYONLY)
endforeach()

