cmake_minimum_required(VERSION 3.0)
project(DeSCAM CXX)


add_subdirectory(CLI)

add_executable(DeSCAM main.cpp)

target_compile_options(DeSCAM PRIVATE -O2)


# get the list of all added plugins in order to link them to SCAM
get_directory_property(PLUGIN_NAMES DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION PLUGIN_NAMES)
foreach (plugin_lib ${PLUGIN_NAMES})
#			MESSAGE(STATUS "linking ${plugin_lib}")
	target_link_libraries(DeSCAM ${plugin_lib})
endforeach ()


# trigger the maker of the PluginFactory.cpp
target_link_libraries(DeSCAM PluginFactory)
target_link_libraries(DeSCAM tinyXML)
target_link_libraries(DeSCAM modelFactory)
target_link_libraries(DeSCAM propertyFactory)
target_link_libraries(DeSCAM Model)
target_link_libraries(DeSCAM Stmts)
target_link_libraries(DeSCAM global)


#include LLVM,z3,SystemC CLANG
include(DefineLibs.cmake)
foreach (clang_lib ${CLANG_LIBS})
	target_link_libraries(DeSCAM ${CMAKE_SOURCE_DIR}/lib/lib${clang_lib}.a)
endforeach ()

foreach (llvm_lib ${LLVM_LIBS})
	target_link_libraries(DeSCAM ${CMAKE_SOURCE_DIR}/lib/lib${llvm_lib}.a)
endforeach ()

foreach (other ${OTHERS})
	target_link_libraries(DeSCAM ${other})
endforeach ()






