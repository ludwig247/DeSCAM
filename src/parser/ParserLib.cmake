
add_library(parser SHARED
        CommandLineProcess.cpp
        CommandLineParameter.cpp
        CommandLineParametersConfig.cpp
        )

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

if(LLVM_FROM_SOURCE)
    foreach (clang_lib ${CLANG_LIBS})
        target_link_libraries(parser ${LLVM_LIB_DIR}/${clang_lib})
    endforeach ()

    foreach (llvm_lib ${LLVM_LIBS})
        target_link_libraries(parser ${LLVM_LIB_DIR}/${llvm_lib})
    endforeach ()
else()

    set (search_paths
            ${PATH_TO_LLVM}
            ${PATH_TO_LLVM}/lib/cmake
            ${PATH_TO_LLVM}/lib/cmake/llvm
            ${PATH_TO_LLVM}/lib/cmake/clang
            ${PATH_TO_LLVM}/share/clang/cmake/
            ${PATH_TO_LLVM}/share/llvm/cmake/
            )

    find_package(LLVM REQUIRED CONFIG
            PATHS ${search_paths}
            NO_DEFAULT_PATH)
    find_package(Clang REQUIRED CONFIG
            PATHS ${search_paths}
            NO_DEFAULT_PATH)

    cmake_policy(SET CMP0057 NEW) # enable new cmake if

    if (LLVM IN_LIST LLVM_AVAILABLE_LIBS)
        target_link_libraries(parser LLVM clangTooling)
        else()
        target_link_libraries(parser LLVMSupport clangTooling)
    endif()
endif()

foreach (other ${OTHERS})
    target_link_libraries(parser ${other})
endforeach ()
