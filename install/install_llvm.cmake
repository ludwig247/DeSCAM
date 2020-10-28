# Encapsulates building LLVM as an External Project.

if (USE_SYSTEM_LLVM)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/CMakeModules/")
    find_package(llvm REQUIRED)
else ()

    #set(LLVM_ALL_PROJECTS "clang;clang-tools-extra;compiler-rt;debuginfo-tests;libc;libclc;libcxx;libcxxabi;libunwind;lld;lldb;mlir;openmp;parallel-libs;polly;pstl")
    include(ExternalProject)
    ExternalProject_add(LLVM
            # Location for external project with standard folder structure. Distinct by version
            PREFIX ${CMAKE_EXTERNAL_PROJECT_DIR}/llvm/${LLVM_VERSION}
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

            # Install locally in the project
            CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_SOURCE_DIR}
            -DCMAKE_BUILD_TYPE=Release
            -DLLVM_INCLUDE_TESTS=OFF
            -DLLVM_ENABLE_PROJECTS=clang
            # MAC OS may also need libcxx;libcxxabi"

            INSTALL_COMMAND make install
            )

    ExternalProject_Add_Step(LLVM RTTI
            DEPENDEES download
            DEPENDERS build

            COMMENT "Enabling RTTI for 'LLVM' ${LLVM_VERSION}"
            # Insert RTTI requirement into CMakeLists.txt
            # FIXME This inserts the RTTI repeatedly. Check if it's already in the file.
            COMMAND echo set (LLVM_REQUIRES_RTTI 1) | cat - ${CMAKE_EXTERNAL_PROJECT_DIR}/llvm/${LLVM_VERSION}/src/LLVM/llvm/CMakeLists.txt > tmp
            COMMAND mv tmp ${CMAKE_EXTERNAL_PROJECT_DIR}/llvm/${LLVM_VERSION}/src/LLVM/llvm/CMakeLists.txt
            ALWAYS TRUE
            )
    ExternaLProject_Add_StepTargets(LLVM RTTI)


    ExternalProject_Add_Step(LLVM FORCED_INSTALL
            DEPENDERS install
            COMMAND ${CMAKE_COMMAND} -E echo "Installing LLVM-${LLVM_VERSION}"
            COMMENT "Installing  LLVM-${LLVM_VERSION}"
            ALWAYS TRUE
            )


    if (LLVM_VERSION VERSION_LESS 4.0.0)
        ExternalProject_Add_Step(LLVM CLANG
                DEPENDEES download
                DEPENDERS build
                COMMENT "Copying clang folder into 'LLVM' ${LLVM_VERSION} project [legacy install]"
                # Create symbolic links for the chosen version. Change the link when switching versions.
                COMMAND cp -r <SOURCE_DIR>/clang <SOURCE_DIR>/llvm/tools
                )
        #ExternalProject_Add_StepTargets(LLVM CLANG)
    endif ()
endif ()
