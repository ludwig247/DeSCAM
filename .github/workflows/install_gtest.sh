#!/usr/bin/env bash

#BINARY LOCATIONS
SCAM_HOME="${GITHUB_WORKSPACE}" #NO SLASH AT THE END
CMAKE_BIN="cmake" #NO SLASH AT THE END
PYTHON3="python3" #NO SLASH AT THE END

#INSTALLING GTEST
echo -e "\e[30;48;5;82mInstalling GTest\e[0m";
(cd $SCAM_HOME/install/tmp/build/ &&
$CMAKE_BIN -DCMAKE_INSTALL_PREFIX:PATH=$SCAM_HOME/install/tmp/files/gtest ../googletest/
make -w -j4 &&
make install &&
cd ../ &&
rm -r ./build/* &&
echo -e "\e[30;48;5;82mInstalled GTest!\e[0m") || (echo -e "\e[41mError installing GTest\e[0m" && exit 1) ;

