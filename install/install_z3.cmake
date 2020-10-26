# Encapsulates building z3 as an External Project.

if (USE_SYSTEM_Z3)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/CMakeModules/")
    find_package(z3 REQUIRED)
else ()

    include(ExternalProject)
    ExternalProject_add(Z3-${Z3_VERSION}
            # Location for external project with standard folder structure. Distinct by version
            PREFIX ${CMAKE_EXTERNAL_PROJECT_DIR}/z3/${Z3_VERSION}
            # Download the project from git via versioned tag. Checkout only the tag. Be verbose.
            GIT_REPOSITORY https://github.com/Z3Prover/z3.git
            GIT_TAG z3-${Z3_VERSION}
            GIT_SHALLOW TRUE
            GIT_PROGRESS TRUE
            GIT_CONFIG advice.detachedHead=false

            # Do not update the project, as we intentionally checked out a specific version.
            UPDATE_COMMAND ""

            # Install locally in the project
            CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_SOURCE_DIR}
#            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            -DCMAKE_BUILD_TYPE=Release

            INSTALL_COMMAND make install
            )
    ExternalProject_Add_Step(Z3-${Z3_VERSION} FORCED_INSTALL
            DEPENDERS install
            COMMAND ${CMAKE_COMMAND} -E echo "Forcing the re-install of Z3-${Z3_VERSION}"
            ALWAYS TRUE
            )
#    ExternalProject_Add_Step(Z3-${Z3_VERSION} SYMLINK
#            DEPENDEES install
#            COMMENT "Using libraries and headers of 'Z3' ${Z3_VERSION}"
#            # Create symbolic links for the chosen version. Change the link when switching versions.
#            COMMAND cp -a <INSTALL_DIR>/include/. ${CMAKE_CURRENT_SOURCE_DIR}/include/
#            COMMAND cp -a <INSTALL_DIR>/lib/. ${CMAKE_CURRENT_SOURCE_DIR}/lib/
#            ALWAYS TRUE
#            )
endif ()