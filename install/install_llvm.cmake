# Encapsulates building LLVM as an External Project.

if (USE_SYSTEM_LLVM)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/CMakeModules/")
    find_package(llvm REQUIRED)
else ()
    include(ExternalProject)
    if (APPLE)
            set(LLVM_FROM_SOURCE TRUE)
            message(STATUS "Prebuild LLVM installation not configured for MacOS. Building from source.")
            set(LLVM_FROM_SOURCE TRUE)
            include(${PROJECT_SOURCE_DIR}/install/install_LLVM_git.cmake)
            set(LLVM_LIB_DIR ${CMAKE_SOURCE_DIR}/lib)
            set(LLVM_BINARY_DIR ${CMAKE_SOURCE_DIR}/bin)
            set(LLVM_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include)
    elseif (UNIX)
        if (OS_VERSION VERSION_GREATER_EQUAL 30.04)
            ExternalProject_Add(LLVM
                    PREFIX ${CMAKE_EXTERNAL_PROJECT_DIR}/LLVM
                    URL  https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/clang+llvm-11.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz
                    URL_HASH SHA512=a620b940240e54f9f3634b15051dba1c471de19a3e7717d3efaf8474cd0102bbfcfe34fab5c543c9647958bfeb10fc270d95d11fca1d7efcdd1443356e2ae478

                    CONFIGURE_COMMAND ""
                    BUILD_COMMAND ""
                    INSTALL_COMMAND ""
                    )
            set(LLVM_LIB_DIR ${CMAKE_EXTERNAL_PROJECT_DIR}/LLVM/src/LLVM/lib)
            set(LLVM_BINARY_DIR ${CMAKE_EXTERNAL_PROJECT_DIR}/LLVM/src/LLVM/bin)
            set(LLVM_INCLUDE_DIR ${CMAKE_EXTERNAL_PROJECT_DIR}/LLVM/src/LLVM/include)
        else ()
            set(LLVM_FROM_SOURCE TRUE)
            message(STATUS "Prebuild LLVM installation not available for Ubuntu < 16.04. Building from source.")
            set(LLVM_FROM_SOURCE TRUE)
            include(${PROJECT_SOURCE_DIR}/install/install_llvm_git.cmake)
            set(LLVM_LIB_DIR ${CMAKE_SOURCE_DIR}/lib)
            set(LLVM_BINARY_DIR ${CMAKE_SOURCE_DIR}/bin)
            set(LLVM_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include)
        endif ()
    endif ()

endif ()
