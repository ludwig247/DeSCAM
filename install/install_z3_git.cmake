if (Z3_FROM_SOURCE)
    message(STATUS "Building with Z3 ${Z3_VERSION}")
    ExternalProject_add(Z3
            # Location for external project with standard folder structure. Distinct by version
            PREFIX ${CMAKE_EXTERNAL_PROJECT_DIR}/z3/${Z3_VERSION}
            # Download the project from git via versioned tag. Checkout only the tag. Be verbose.
            GIT_REPOSITORY https://github.com/Z3Prover/z3.git
            GIT_TAG z3-${Z3_VERSION}

            # Do not update the project, as we intentionally checked out a specific version.
            UPDATE_COMMAND ""

            # Install locally in the project
            CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_SOURCE_DIR}
            -DCMAKE_BUILD_TYPE=Release

            INSTALL_COMMAND make install
            )

#    ExternalProject_Add_Step(Z3 FORCED_INSTALL
#            DEPENDERS install
#            COMMAND ${CMAKE_COMMAND} -E echo "Installing Z3-${Z3_VERSION}"
#            COMMENT "Installing Z3-${Z3_VERSION}"
#            ALWAYS TRUE
#            )
endif ()