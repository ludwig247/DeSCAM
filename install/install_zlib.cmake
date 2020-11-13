set(ZLIB_VERSION 1.2.11)

message(STATUS "Building with ZLIB ${ZLIB_VERSION}")
set(PATH_TO_ZLIB ${CMAKE_EXTERNAL_PROJECT_DIR}/ZLIB/${ZLIB_VERSION})

include(ExternalProject)
ExternalProject_add(ZLIB
        # Location for external project with standard folder structure. Distinct by version
        PREFIX ${PATH_TO_ZLIB}
        # Download the project from git via versioned tag. Checkout only the tag. Be verbose.
        GIT_REPOSITORY https://github.com/madler/zlib.git
        GIT_TAG "v${ZLIB_VERSION}"
        GIT_PROGRESS TRUE

        # Do not update the project, as we intentionally checked out a specific version.
        UPDATE_COMMAND ""

        # Install locally in the project
        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=Release

        INSTALL_COMMAND make install
        )

set(ZLIB_LIB_DIR ${PATH_TO_ZLIB}/lib)
set(ZLIB_BINARY_DIR ${PATH_TO_ZLIB}/bin)
set(ZLIB_INCLUDE_DIR ${PATH_TO_ZLIB}/include)
