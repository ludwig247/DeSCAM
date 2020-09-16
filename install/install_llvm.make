# Encapsulates building LLVM as an External Project.

if (USE_SYSTEM_LLVM)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/CMakeModules/")
    find_package(llvm REQUIRED)
else ()

    set(LLVM_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/3rdparty/llvm/install)
    set(LLVM_INCLUDES ${LLVM_INSTALL_DIR}/include)
    set(LLVM_LIBRARIES ${LLVM_INSTALL_DIR}/lib)


    include(ExternalProject)
    ExternalProject_add(LLVM
            #            URL ${LLVM_URL_PRE}${LLVM_VERSION}${LLVM_URL_POST}
            #            URL_MD5 ${LLVM_MD5}
            SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/install/tmp/llvm
            BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/3rdparty/llvm/src
            INSTALL_DIR ${LLVM_INSTALL_DIR}
            UPDATE_COMMAND ""
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            INSTALL_COMMAND make install
            # Copy include
            COMMAND cp -a ${LLVM_INCLUDES}/. ${CMAKE_CURRENT_SOURCE_DIR}/include
            # Delete gtest lib from lib
            COMMAND rm -f ${LLVM_LIBRARIES}/libgtest.a
            # Copy and delete Clang from lib folder
            COMMAND cp -a ${LLVM_LIBRARIES}/clang/3.4.2/. ${CMAKE_CURRENT_SOURCE_DIR}/include/clang/3.4.2
            COMMAND rm -rf ${LLVM_LIBRARIES}/clang
            # Copy lib
            COMMAND cp -a ${LLVM_LIBRARIES}/. ${CMAKE_CURRENT_SOURCE_DIR}/lib
            )


#    ExternalProject_Add_Step(LLVM copy_include
#            )
#
#
#    ExternalProject_Add_Step(LLVM copy_include_clang
#            )
#
#
#    ExternalProject_Add_Step(LLVM copy_lib
#            )
endif ()