#!/usr/bin/env bash

#BINARY LOCATIONS
SCAM_HOME="${GITHUB_WORKSPACE}" #NO SLASH AT THE END
CMAKE_BIN="cmake" #NO SLASH AT THE END
PYTHON3="python3" #NO SLASH AT THE END

echo "Moving files"
cd $SCAM_HOME
mkdir include/
mkdir lib/

#Remove gtest from llvm installation
find $SCAM_HOME/install/tmp/files/llvm/ -name "*gtest.a" | while read f; do
    rm "$f"
done

#INCLUDE
cp -r $SCAM_HOME/install/tmp/files/SystemC/include/* ./include
cp -r $SCAM_HOME/install/tmp/files/llvm/include/* ./include
cp -r $SCAM_HOME/install/tmp/files/z3/include/* ./include
cp -r $SCAM_HOME/install/tmp/files/gtest/include/* ./include
mv $SCAM_HOME/install/tmp/files/llvm/lib/clang/3.4.2/ $SCAM_HOME/include/clang/3.4.2

#COPY LIBS
find $SCAM_HOME/install/tmp/files/ -name "*.a" | while read f; do
    cp "$f" $SCAM_HOME/lib/
done
find $SCAM_HOME/install/tmp/files/ -name "*.so" | while read f; do
    cp "$f" $SCAM_HOME/lib/
done

echo -e "\e[30;48;5;82mCreate config\e[0m";
(echo "#ifndef SCAM_CONFIG_HOME_H" &&
echo "#define SCAM_CONFIG_HOME_H" &&
echo "#define SCAM_HOME \"$SCAM_HOME\"" &&
echo "#endif") > $SCAM_HOME/src/global/Config.h;






