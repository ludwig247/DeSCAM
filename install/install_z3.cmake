# Encapsulates building z3 as an External Project.

if (USE_SYSTEM_Z3)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/CMakeModules/")
    find_package(z3 REQUIRED)
else ()
    include(ExternalProject)
    if (APPLE)
        if (${CMAKE_SYSTEM_VERSION} VERSION_GREATER_EQUAL 10)
            ExternalProject_Add(Z3
                    PREFIX ${CMAKE_EXTERNAL_PROJECT_DIR}/z3
                    URL https://github.com/Z3Prover/z3/releases/download/z3-4.8.6/z3-4.8.6-x64-osx-10.14.6.zip
                    # TODO this is not the correct hash
                    URL_HASH SHA512=341959a14dd41ee5465a3b34cf4a075a3ca80f5be08fa8821103b86e2660029426b3fe37e265de5fdbca961cadd461c217d554aedf196cb3496f978ba3136f00
                    CONFIGURE_COMMAND ""
                    BUILD_COMMAND ""
                    INSTALL_COMMAND ""
                    )
            set(Z3_LIB_DIR ${CMAKE_EXTERNAL_PROJECT_DIR}/z3/src/Z3/bin)
            set(Z3_INCLUDE_DIR ${CMAKE_EXTERNAL_PROJECT_DIR}/z3/src/Z3/include)
        else ()
            message(STATUS "Prebuild Z3 installation not configured for MacOS. Building from source.")
            set(Z3_FROM_SOURCE TRUE)
            include(${PROJECT_SOURCE_DIR}/install/install_z3_git.cmake)
            set(Z3_LIB_DIR ${CMAKE_SOURCE_DIR}/lib)
            set(Z3_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include)
        endif ()
    elseif (UNIX)
        if (OS_VERSION VERSION_GREATER_EQUAL 16.04)
            ExternalProject_Add(Z3
                    PREFIX ${CMAKE_EXTERNAL_PROJECT_DIR}/z3
                    URL http://github.com/Z3Prover/z3/releases/download/z3-4.8.6/z3-4.8.6-x64-ubuntu-16.04.zip
                    URL_HASH SHA512=6bcf63270c4bb6a3f13e1fd4bc2496493a3422a848494c3cc27598feaa2c0f8011170a31a4f2b11c89b8cfe05d0bab9cfee8baf4ef8a7e69807f5711f667d803
                    CONFIGURE_COMMAND ""
                    BUILD_COMMAND ""
                    INSTALL_COMMAND ""
                    )
            set(Z3_LIB_DIR ${CMAKE_EXTERNAL_PROJECT_DIR}/z3/src/Z3/bin)
            set(Z3_INCLUDE_DIR ${CMAKE_EXTERNAL_PROJECT_DIR}/z3/src/Z3/include)
        else ()
            message(STATUS "Prebuild Z3 installation not available for Ubuntu < 16.04. Building from source.")
            set(Z3_FROM_SOURCE TRUE)
            include(${PROJECT_SOURCE_DIR}/install/install_z3_git.cmake)
            set(Z3_LIB_DIR ${CMAKE_SOURCE_DIR}/lib)
            set(Z3_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include)
        endif ()
    endif ()
endif ()