# Encapsulates building SystemC as an External Project.

if (USE_SYSTEM_SYSTEMC)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/CMakeModules/")
    find_package(SystemC 2.3.1 REQUIRED)
else ()
    set(SYSTEMC_COMPILER_FLAGS
            CC=${CMAKE_C_COMPILER}
            CXX=${CMAKE_CXX_COMPILER}
            CFLAGS=${CMAKE_C_FLAGS}
            CXXFLAGS=${CMAKE_CXX_FLAGS})

#    set(SYSTEMC_SHARED_FLAG --enable-shared)
#    set(SYSTEMC_VERSION 2.3.1)
#    set(SYSTEMC_MD5 "a6437844f7961c4e47d9593312f6311c")
#    set(SYSTEMC_URL_PRE "http://accellera.org/images/downloads/standards/systemc/systemc-")
#    set(SYSTEMC_URL_POST ".tgz")
    set(SYSTEMC_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/3rdparty/systemc/install)
    set(SYSTEMC_INCLUDES ${SYSTEMC_INSTALL_DIR}/include)
    set(SYSTEMC_LIBRARIES ${SYSTEMC_INSTALL_DIR}/lib-linux64)

    include(ExternalProject)
    ExternalProject_add(SYSTEMC
            #            URL ${SYSTEMC_URL_PRE}${SYSTEMC_VERSION}${SYSTEMC_URL_POST}
            #            URL_MD5 ${SYSTEMC_MD5}
#            GIT_REPOSITORY https://github.com/accellera-official/systemc.git
#            GIT_TAG 2.3.3
#            SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/install/systemc/src
            SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/install/tmp/systemc-2.3.1
            BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/3rdparty/systemc/src
            INSTALL_DIR ${SYSTEMC_INSTALL_DIR}
            UPDATE_COMMAND ""
            CONFIGURE_COMMAND <SOURCE_DIR>/configure
                --prefix=<INSTALL_DIR>
            INSTALL_COMMAND make install
            COMMAND cp -a ${SYSTEMC_INCLUDES}/. ${CMAKE_CURRENT_SOURCE_DIR}/include
            COMMAND cp -a ${SYSTEMC_LIBRARIES}/. ${CMAKE_CURRENT_SOURCE_DIR}/lib
            )

#    ExternalProject_Add_Step(SYSTEMC copy_include
#            )
#
#    ExternalProject_Add_Step(SYSTEMC copy_lib
#            )

endif ()