# Encapsulates building Gtest as an External Project.

if (USE_SYSTEM_GTEST)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/CMakeModules/")
    find_package(GTest REQUIRED)
else ()

    include(ExternalProject)
    foreach(GTEST_VERSION IN LISTS GTEST_VERSIONS)

    ExternalProject_add(GTEST-${GTEST_VERSION}
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
            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>

            INSTALL_COMMAND make install

            )

    ExternalProject_Add_Step(GTEST-${GTEST_VERSION} SYMLINK
            DEPENDEES install

            COMMENT "Using libraries and headers of 'GTEST' ${GTEST_VERSION}"
            COMMAND cp -a <INSTALL_DIR>/include/. ${CMAKE_CURRENT_SOURCE_DIR}/include
            COMMAND cp -a <INSTALL_DIR>/lib/. ${CMAKE_CURRENT_SOURCE_DIR}/lib
            ALWAYS TRUE
            )

    endforeach()
endif ()
