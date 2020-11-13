

 include(ExternalProject)
 ExternalProject_add(LLVM
  # Location for external project with standard folder structure. Distinct by version
  PREFIX ${CMAKE_EXTERNAL_PROJECT_DIR}/llvm/${LLVM_VERSION}
  # Download the project from git via versioned tag. Checkout only the tag. Be verbose.
  GIT_REPOSITORY https://github.com/llvm/llvm-project.git
  GIT_TAG llvmorg-${LLVM_VERSION}
  GIT_PROGRESS TRUE

  # LLVM CMakeList.txt is located in a subdirectory
  SOURCE_SUBDIR llvm
  # Do not update the project, as we intentionally checked out a specific version.
  UPDATE_COMMAND ""

  # Install locally in the project
  CMAKE_ARGS
  -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_SOURCE_DIR}
  -DCMAKE_BUILD_TYPE=Release
  -DLLVM_INCLUDE_TESTS=OFF
  -DLLVM_ENABLE_PROJECTS=clang;clang-tools-extra;openmp
  -DLLVM_BUILD_LLVM_DYLIB=ON
  # MAC OS may also need libcxx;libcxxabi"

  INSTALL_COMMAND make install
 )

 set(LLVM_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include)
 set(LLVM_BINARY_DIR ${CMAKE_SOURCE_DIR}/bin)
 set(LLVM_LIB_DIR ${CMAKE_SOURCE_DIR}/lib)

# ExternalProject_Add_Step(LLVM RTTI
#  DEPENDEES download
#  DEPENDERS build
#
#  COMMENT "Enabling RTTI for 'LLVM' ${LLVM_VERSION}"
#  # Insert RTTI requirement into CMakeLists.txt
#  # FIXME This inserts the RTTI repeatedly. Check if it's already in the file.
#  COMMAND echo set (LLVM_REQUIRES_RTTI 1) | cat - ${CMAKE_EXTERNAL_PROJECT_DIR}/llvm/${LLVM_VERSION}/src/LLVM/llvm/CMakeLists.txt > tmp
#  COMMAND mv tmp ${CMAKE_EXTERNAL_PROJECT_DIR}/llvm/${LLVM_VERSION}/src/LLVM/llvm/CMakeLists.txt
#  ALWAYS TRUE
# )
#
# ExternalProject_Add_Step(LLVM FORCED_INSTALL
#  DEPENDERS install
#  COMMAND ${CMAKE_COMMAND} -E echo "Installing LLVM-${LLVM_VERSION}"
#  COMMENT "Installing  LLVM-${LLVM_VERSION}"
#  ALWAYS TRUE
# )

 if (LLVM_VERSION VERSION_LESS 4.0.0)
 ExternalProject_Add_Step(LLVM CLANG
  DEPENDEES download
  DEPENDERS build
  COMMENT "Copying clang folder into 'LLVM' ${LLVM_VERSION} project [legacy install]"
  # Create symbolic links for the chosen version. Change the link when switching versions.
  COMMAND cp -r <SOURCE_DIR>/clang <SOURCE_DIR>/llvm/tools
 )
 endif()
