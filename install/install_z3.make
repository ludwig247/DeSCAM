# Encapsulates building z3 as an External Project.

if (USE_SYSTEM_Z3)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/CMakeModules/")
    find_package(z3 REQUIRED)
else ()

    set(Z3_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/3rdparty/z3/install)
    set(Z3_INCLUDES ${Z3_INSTALL_DIR}/include)
    set(Z3_LIBRARIES ${Z3_INSTALL_DIR}/lib)

    include(ExternalProject)
    ExternalProject_add(Z3
            #            URL ${Z3_URL_PRE}${Z3_VERSION}${Z3_URL_POST}
            #            URL_MD5 ${Z3_MD5}
            #            SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/install/tmp/z3
            GIT_REPOSITORY https://github.com/Z3Prover/z3.git
            GIT_TAG z3-4.8.6
            SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/install/z3/src
            BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/3rdparty/z3/src
            INSTALL_DIR ${Z3_INSTALL_DIR}
            UPDATE_COMMAND ""
            CMAKE_ARGS
            -G "Unix Makefiles"
            -DCMAKE_BUILD_TYPE=Release
            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            INSTALL_COMMAND make install
            COMMAND cp -a ${Z3_INCLUDES}/. ${CMAKE_CURRENT_SOURCE_DIR}/include
            COMMAND cp -a ${Z3_LIBRARIES}/. ${CMAKE_CURRENT_SOURCE_DIR}/lib
            )

    #    ExternalProject_Add_Step(Z3 copy_include
    #
    #            )
    #
    #    ExternalProject_Add_Step(Z3 copy_lib
    #            )
endif ()