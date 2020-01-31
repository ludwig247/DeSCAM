
add_library(parser SHARED)
SET_TARGET_PROPERTIES(parser PROPERTIES LINKER_LANGUAGE CXX)


# get the list of all added plugins in order to link them to DESCAM
get_directory_property(PLUGIN_NAMES DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION PLUGIN_NAMES)
foreach (plugin_lib ${PLUGIN_NAMES})
    #			MESSAGE(STATUS "linking ${plugin_lib}")
    target_link_libraries(parser ${plugin_lib})
endforeach ()

target_link_libraries(parser PluginFactory)
target_link_libraries(parser tinyXML)
target_link_libraries(parser modelFactory)
target_link_libraries(parser operationFactory)
target_link_libraries(parser optimizer)
target_link_libraries(parser global)
target_link_libraries(parser Model)
target_link_libraries(parser pthread)

#include LLVM,z3,SystemC CLANG
include(DefineLibs.cmake)
foreach (clang_lib ${CLANG_LIBS})
    target_link_libraries(parser ${CMAKE_SOURCE_DIR}/lib/lib${clang_lib}.a)
endforeach ()

foreach (llvm_lib ${LLVM_LIBS})
    target_link_libraries(parser ${CMAKE_SOURCE_DIR}/lib/lib${llvm_lib}.a)
endforeach ()

foreach (other ${OTHERS})
    target_link_libraries(parser ${other})
endforeach ()