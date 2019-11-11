#!/usr/bin/env bash

#BINARY LOCATIONS
SCAM_HOME="${GITHUB_WORKSPACE}" #NO SLASH AT THE END
CMAKE_BIN="cmake" #NO SLASH AT THE END
PYTHON3="python3" #NO SLASH AT THE END


echo -e "\e[30;48;5;82mInstalling DESCAM ...\e[0m";
(cd $SCAM_HOME/install/tmp/build/ &&
$CMAKE_BIN ../../../ &&
$CMAKE_BIN --build $SCAM_HOME/install/tmp/build/ --target DESCAM -- -j 4  &&
echo -e"\e[30;48;5;82mInstalled DESCAM!\e[0m" ) || (echo -e "\e[41mError installing DESCAM \e[0m" && exit 1);






