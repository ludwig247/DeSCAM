#!/bin/bash
#BINARY LOCATIONS
echo $GITHUB_WORKSPACE
SCAM_HOME="${GITHUB_WORKSPACE}" #NO SLASH AT THE END
CMAKE_BIN="cmake" #NO SLASH AT THE END
PYTHON3="python3" #NO SLASH AT THE END

#UNZIPPING FILES
echo -e "\e[30;48;5;82mUnpacking files\e[0m"
(unzip $SCAM_HOME/install/install_new.zip  -d $SCAM_HOME/install/tmp && echo "\e[30;48;5;82m Unpacked files") || (echo "\e[41mError unpacking file install_new.zip" && exit 1) ;
cd $SCAM_HOME/install/tmp;
mkdir build
