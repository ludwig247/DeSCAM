# Encapsulates building LLVM as an External Project.

if (USE_SYSTEM_LLVM)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/CMakeModules/")
    find_package(llvm REQUIRED)
else ()
    if (NOT ${CMAKE_SYSTEM_NAME} STREQUAL Darwin)
        set(PERF_TOGGLE -DLLVM_USE_PERF=ON)
    else ()
        set(PERF_TOGGLE)
    endif ()

    #set(LLVM_ALL_PROJECTS "clang;clang-tools-extra;compiler-rt;debuginfo-tests;libc;libclc;libcxx;libcxxabi;libunwind;lld;lldb;mlir;openmp;parallel-libs;polly;pstl")
    include(ExternalProject)
    if (APPLE)
        set(LLVM_FROM_SOURCE TRUE)
        message(STATUS "Prebuild LLVM installation not configured for MacOS. Building from source.")
        set(LLVM_FROM_SOURCE TRUE)
        include(${PROJECT_SOURCE_DIR}/install/install_LLVM_git.cmake)
        set(PATH_TO_LLVM ${CMAKE_SOURCE_DIR})

    elseif (UNIX)

        if (OS_VERSION VERSION_GREATER_EQUAL 20.04)
            ExternalProject_Add(LLVM
                    PREFIX ${CMAKE_EXTERNAL_PROJECT_DIR}/LLVM
                    URL https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/clang+llvm-11.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz
                    URL_HASH SHA512=a620b940240e54f9f3634b15051dba1c471de19a3e7717d3efaf8474cd0102bbfcfe34fab5c543c9647958bfeb10fc270d95d11fca1d7efcdd1443356e2ae478

                    CONFIGURE_COMMAND ""
                    BUILD_COMMAND ""
                    INSTALL_COMMAND ""
                    )
            set(PATH_TO_LLVM ${CMAKE_EXTERNAL_PROJECT_DIR}/LLVM/src/LLVM)

            set(PATH_TO_LLVM ${CMAKE_EXTERNAL_PROJECT_DIR}/LLVM/src/LLVM)
            ExternalProject_Add_Step(LLVM COPY
                    DEPENDEES install
                    COMMAND cp -r <SOURCE_DIR>/lib/clang ${CMAKE_SOURCE_DIR}/lib/
                    )

        elseif (OS_VERSION VERSION_GREATER_EQUAL 16.04)
            ExternalProject_Add(LLVM
                    PREFIX ${CMAKE_EXTERNAL_PROJECT_DIR}/LLVM
                    URL https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/clang+llvm-11.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz
                    URL_HASH SHA512=9dee765efad248093dd1463b3a06a7e314043ed9ad80a6902a261695a2352a28f0d1e3d804a456739818ab76f7dec59b705d8973165cf1c093371472fb4aa906

                    CONFIGURE_COMMAND ""
                    BUILD_COMMAND ""
                    INSTALL_COMMAND ""
                    )

            set(PATH_TO_LLVM ${CMAKE_EXTERNAL_PROJECT_DIR}/LLVM/src/LLVM)
            ExternalProject_Add_Step(LLVM COPY
                    DEPENDEES install
                    COMMAND cp -r <SOURCE_DIR>/clang ${CMAKE_SOURCE_DIR}/lib/
                    )

        else ()
            set(LLVM_FROM_SOURCE TRUE)
            message(STATUS "Prebuild LLVM installation not available for Ubuntu < 16.04. Building from source.")
            set(LLVM_FROM_SOURCE TRUE)
            include(${PROJECT_SOURCE_DIR}/install/install_llvm_git.cmake)
            set(PATH_TO_LLVM ${CMAKE_SOURCE_DIR})
        endif ()
    endif ()

    set(LLVM_LIB_DIR ${PATH_TO_LLVM}/lib)
    set(LLVM_BINARY_DIR ${PATH_TO_LLVM}/bin)
    set(LLVM_INCLUDE_DIR ${PATH_TO_LLVM}/include)

endif ()