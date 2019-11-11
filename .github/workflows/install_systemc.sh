#!/usr/bin/env bash

#BINARY LOCATIONS
SCAM_HOME="${GITHUB_WORKSPACE}" #NO SLASH AT THE END
CMAKE_BIN="cmake" #NO SLASH AT THE END
PYTHON3="python3" #NO SLASH AT THE END

#INSTALLING SYSTEMC
echo -e "\e[30;48;5;82mInstalling SystemC...\e[0m";
(cd $SCAM_HOME/install/tmp/build &&
../systemc-2.3.1/configure --prefix $SCAM_HOME/install/tmp/files/SystemC &&
make -w -j4 &&
make install &&
cd ../ &&
rm -r ./build/* &&
echo -e "\e[30;48;5;82mInstalled SystemC!\e[0m") || (echo -e "\e[41mError installing SystemC \e[0m" && exit 1) ;



