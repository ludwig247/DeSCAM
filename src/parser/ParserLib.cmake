
add_library(parser STATIC
        CommandLineProcess.cpp
        CommandLineParameter.cpp
        CommandLineParametersConfig.cpp)

SET_TARGET_PROPERTIES(parser PROPERTIES LINKER_LANGUAGE CXX)


target_link_libraries(parser PluginFactory)
target_link_libraries(parser modelFactory)
target_link_libraries(parser optimizer)
target_link_libraries(parser propertyFactory)
target_link_libraries(parser operationFactory)
target_link_libraries(parser global)
target_link_libraries(parser CLI)
target_link_libraries(parser pthread)

#include LLVM,z3,SystemC CLANG
include(DefineLibs.cmake)
foreach (clang_lib ${CLANG_LIBS})
    target_link_libraries(parser ${LLVM_LIB_DIR}/${clang_lib})
endforeach ()

foreach (llvm_lib ${LLVM_LIBS})
    target_link_libraries(parser ${LLVM_LIB_DIR}/${llvm_lib})
endforeach ()

foreach (other ${OTHERS})
    target_link_libraries(parser ${other})
endforeach ()