cmake_minimum_required(VERSION 3.0)
project(DESCAM CXX)


add_subdirectory(CLI)

add_executable(DESCAM main.cpp)

add_dependencies(DESCAM SYSTEMC GTEST Z3 LLVM)

target_compile_options(DESCAM PRIVATE -O2)


# get the list of all added plugins in order to link them to DESCAM
get_directory_property(PLUGIN_NAMES DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION PLUGIN_NAMES)
foreach (plugin_lib ${PLUGIN_NAMES})
    #			MESSAGE(STATUS "linking ${plugin_lib}")
    target_link_libraries(DESCAM ${plugin_lib})
endforeach ()


target_link_libraries(DESCAM PluginFactory)
target_link_libraries(DESCAM tinyXML)
target_link_libraries(DESCAM modelFactory)
target_link_libraries(DESCAM operationFactory)
target_link_libraries(DESCAM optimizer)
target_link_libraries(DESCAM global)
target_link_libraries(DESCAM Model)
target_link_libraries(DESCAM pthread)


#include LLVM,z3,SystemC CLANG
include(DefineLibs.cmake)
foreach (clang_lib ${CLANG_LIBS})
    target_link_libraries(DESCAM ${CMAKE_SOURCE_DIR}/lib/lib${clang_lib}.a)
endforeach ()

foreach (llvm_lib ${LLVM_LIBS})
    target_link_libraries(DESCAM ${CMAKE_SOURCE_DIR}/lib/lib${llvm_lib}.a)
endforeach ()

foreach (other ${OTHERS})
    target_link_libraries(DESCAM ${other})
endforeach ()






