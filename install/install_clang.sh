#!/usr/bin/env bash

#BINARY LOCATIONS
SCAM_HOME="${GITHUB_WORKSPACE}" #NO SLASH AT THE END
CMAKE_BIN="cmake" #NO SLASH AT THE END
PYTHON3="python3" #NO SLASH AT THE END

#INSTALLING LLVM/CLANG
echo -e "\e[30;48;5;82mInstalling LLVM/CLANG\e[0m";
(cd $SCAM_HOME/install/tmp/build/ &&
$CMAKE_BIN -DCMAKE_INSTALL_PREFIX:PATH=$SCAM_HOME/install/tmp/files/llvm ../llvm
gsed -i 's/__msan_unpoison/\/\/__msan_unpoison/' /llvm/lib/Support/Compression.cpp
gsed -i 's/__msan_allocated_memory/\/\/__msan_allocated_memory/' /llvm/lib/Support/Allocator.cpp
make -w -j4 &&
make install &&
cd ../ &&
rm -r ./build/* &&
echo -e "\e[30;48;5;82mInstalled LLVM/Clang!\e[0m") || (echo -e "\e[41mError installing LLVM\e[0m" && exit 1) ;




