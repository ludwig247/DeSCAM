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

    include(ExternalProject)
    ExternalProject_add(SYSTEMC
            # Location for external project with standard folder structure. Distinct by version
            PREFIX ${CMAKE_EXTERNAL_PROJECT_DIR}/systemc/${SYSTEMC_VERSION}
            # Download the project from git via versioned tag. Checkout only the tag. Be verbose.
            GIT_REPOSITORY https://github.com/accellera-official/systemc.git
            GIT_TAG ${SYSTEMC_VERSION}
            GIT_SHALLOW TRUE
            GIT_PROGRESS TRUE
            GIT_CONFIG advice.detachedHead=false

            # Do not update the project, as we intentionally checked out a specific version.
            UPDATE_COMMAND ""

            # Install locally in the project
            CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${CMAKE_SOURCE_DIR}/lib

            CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            -DCMAKE_BUILD_TYPE=Release
            -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_SOURCE_DIR}/lib

            INSTALL_COMMAND make install
            )

    ExternalProject_Add_Step(SYSTEMC FORCED_INSTALL
            DEPENDERS install
            COMMAND ${CMAKE_COMMAND} -E echo "Installing SYSTEMC-${SYSTEMC_VERSION}"
            COMMENT "Installing SYSTEMC-${SYSTEMC_VERSION}"
            ALWAYS TRUE
            )
    ExternaLProject_Add_StepTargets(SYSTEMC FORCED_INSTALL)

    ExternalProject_Add_Step(SYSTEMC MOVE_INCLUDES
            DEPENDEES install
            COMMAND mv  -f ${CMAKE_SOURCE_DIR}/lib/include ${CMAKE_SOURCE_DIR}/include
            ALWAYS TRUE
            )

endif ()