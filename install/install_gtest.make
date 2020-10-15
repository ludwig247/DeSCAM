# Encapsulates building Gtest as an External Project.

if (USE_SYSTEM_GTEST)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/CMakeModules/")
    #find_package(gtest REQUIRED)
else ()

    set(GTEST_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/3rdparty/gtest/install)
    set(GTEST_INCLUDES ${GTEST_INSTALL_DIR}/include)
    set(GTEST_LIBRARIES ${GTEST_INSTALL_DIR}/lib)


    include(ExternalProject)
    ExternalProject_add(GTEST
            #            URL ${GTEST_URL_PRE}${GTEST_VERSION}${GTEST_URL_POST}
            #            URL_MD5 ${GTEST_MD5}
            #            SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/install/tmp/googletest
            GIT_REPOSITORY https://github.com/google/googletest.git
            GIT_TAG release-1.8.0
            SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/install/gtest/src
            BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/3rdparty/gtest/src
            INSTALL_DIR ${GTEST_INSTALL_DIR}
            UPDATE_COMMAND ""
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            INSTALL_COMMAND make install
            COMMAND cp -a ${GTEST_INCLUDES}/. ${CMAKE_CURRENT_SOURCE_DIR}/include
            COMMAND cp -a ${GTEST_LIBRARIES}/. ${CMAKE_CURRENT_SOURCE_DIR}/lib
            )

#    ExternalProject_Add_Step(GTEST copy_include
#
#            )
#
#    ExternalProject_Add_Step(GTEST copy_lib
#            )
endif ()