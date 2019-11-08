#!/usr/bin/env bash

#BINARY LOCATIONS
SCAM_HOME="${GITHUB_WORKSPACE}" #NO SLASH AT THE END
CMAKE_BIN="cmake" #NO SLASH AT THE END
PYTHON3="python3" #NO SLASH AT THE END

#INSTALLING LLVM/CLANG
sed -i 's/__msan_unpoison/\/\/__msan_unpoison/' $SCAM_HOME/install/tmp/files/llvm/lib/Target/X86/X86JITInfo.cpp
sed -i 's/__msan_allocated_memory/\/\/__msan_allocated_memory/' $SCAM_HOME/install/tmp/files/llvm/Support/Allocator.cpp

echo -e "\e[30;48;5;82mInstalling LLVM/CLANG\e[0m";
(cd $SCAM_HOME/install/tmp/build/ &&
$CMAKE_BIN -DCMAKE_INSTALL_PREFIX:PATH=$SCAM_HOME/install/tmp/files/llvm ../llvm

make -w -j4 &&
make install &&
cd ../ &&
rm -r ./build/* &&
echo -e "\e[30;48;5;82mInstalled LLVM/Clang!\e[0m") || (echo -e "\e[41mError installing LLVM\e[0m" && exit 1) ;




