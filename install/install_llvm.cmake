# Encapsulates building LLVM as an External Project.

if (USE_SYSTEM_LLVM)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/CMakeModules/")
    find_package(llvm REQUIRED)
else ()

    # Set the Version you want
    foreach(LLVM_VERSION IN LISTS LLVM_VERSIONS)
    include(ExternalProject)
    ExternalProject_add(LLVM-${LLVM_VERSION}
            # Location for external project with standard folder structure. Distinct by version
            PREFIX ${CMAKE_CURRENT_BINARY_DIR}/3rdparty/llvm/${LLVM_VERSION}
            # Download the project from git via versioned tag. Checkout only the tag. Be verbose.
            GIT_REPOSITORY https://github.com/llvm/llvm-project.git
            GIT_TAG llvmorg-${LLVM_VERSION}
            GIT_SHALLOW TRUE
            GIT_PROGRESS TRUE
            GIT_CONFIG advice.detachedHead=false

            # LLVM CMakeList.txt is located in a subdirectory
            SOURCE_SUBDIR llvm
            # Do not update the project, as we intentionally checked out a specific version.
            UPDATE_COMMAND ""

            # Insert RTTI requirement into CMakeLists.txt
            # FIXME This inserts the RTTI repeatedly. Check if it's already in the file.
            set (LLVM_CMAKE_LIST ${CMAKE_CURRENT_BINARY_DIR}/3rdparty/llvm/${LLVM_VERSION}/src/LLVM-${LLVM_VERSION}/CMakeLists.txt)
            set {LLVM_CMAKE_TEMP ${CMAKE_CURRENT_BINARY_DIR}/3rdparty/llvm/${LLVM_VERSION}/src/LLVM-${LLVM_VERSION}/tmp.txt}
            COMMAND touch tmp>
            # TODO WHY DOES THIS NOT WORK?
            COMMAND echo 'set (LLVM_REQUIRES_RTTI 1) ' | cat - ${LLVM_CMAKE_LIST} > tmp
            COMMAND mv tmp ${CMAKE_CURRENT_BINARY_DIR}/3rdparty/llvm/${LLVM_VERSION}/src/LLVM-${LLVM_VERSION}/CMakeLists.txt

            # Install locally in the project
            CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            -DCMAKE_BUILD_TYPE=Release
            -DLLVM_INCLUDE_TESTS=OFF
            -DLLVM_ENABLE_PROJECTS=clang
            # MAC OS may also need libcxx;libcxxabi"

            INSTALL_COMMAND make install
            )

    ExternalProject_Add_Step(LLVM-${LLVM_VERSION} SYMLINK
            DEPENDEES install
            COMMENT "Using libraries and headers of 'LLVM' ${LLVM_VERSION}"
            # Create symbolic links for the chosen version. Change the link when switching versions.
            COMMAND cp -a <INSTALL_DIR>/include/. ${CMAKE_CURRENT_SOURCE_DIR}/include/
            COMMAND cp -a <INSTALL_DIR>/lib/. ${CMAKE_CURRENT_SOURCE_DIR}/lib/
            ALWAYS TRUE
            )
    endforeach()
endif ()