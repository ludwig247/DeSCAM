# Encapsulates building Gtest as an External Project.

if (USE_SYSTEM_GTEST)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/CMakeModules/")
    find_package(GTest REQUIRED)
else ()

    include(ExternalProject)
    ExternalProject_add(GTEST
            # Location for external project with standard folder structure. Distinct by version
            PREFIX ${CMAKE_EXTERNAL_PROJECT_DIR}/googletest/${GTEST_VERSION}
            # Download the project from git via versioned tag. Checkout only the tag. Be verbose.
            GIT_REPOSITORY https://github.com/google/googletest.git
            GIT_TAG release-${GTEST_VERSION}
            GIT_SHALLOW TRUE
            GIT_PROGRESS TRUE
            GIT_CONFIG advice.detachedHead=false

            # Do not update the project, as we intentionally checked out a specific version.
            UPDATE_COMMAND ""

            # Install locally in the project
            CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_SOURCE_DIR}

            INSTALL_COMMAND make install

            )

    ExternalProject_Add_Step(GTEST FORCED_INSTALL
            DEPENDERS install
            COMMAND ${CMAKE_COMMAND} -E echo "Installing GTEST-${GTEST_VERSION}"
            COMMENT "Installing GTEST-${GTEST_VERSION}"
            ALWAYS TRUE
            )
endif ()
