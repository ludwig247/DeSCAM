#!/bin/bash
#BINARY LOCATIONS
SCAM_HOME="/import/lab/users/schmitz/DeSCAM" #NO SLASH AT THE END
CMAKE_BIN="cmake" #NO SLASH AT THE END
PYTHON3="python3" #NO SLASH AT THE END

#UNZIPPING FILES
echo -e "\e[30;48;5;82mUnpacking files\e[0m"
(unzip $SCAM_HOME/install/install_new.zip  -d $SCAM_HOME/install/tmp && echo "\e[30;48;5;82m Unpacked files") || (echo "\e[41mError unpacking file install_new.zip" && exit 1) ;
cd $SCAM_HOME/install/tmp;
mkdir build

echo -e "\e[30;48;5;82mInstalling SCAM ...\e[0m";
(cd $SCAM_HOME/install/tmp/build/ &&
$CMAKE_BIN ../../../ &&
$CMAKE_BIN --build $SCAM_HOME/install/tmp/build/ --target DESCAM -- -j 4  &&
echo -e"\e[30;48;5;82mInstalled SCAM!\e[0m" ) || (echo -e "\e[41mError installing SCAM \e[0m" && exit 1);

echo -e "\e[30;48;5;82mRun Test\e[0m";
($CMAKE_BIN --build $SCAM_HOME/install/tmp/build/ --target PrintITL_Test_Run -- -j 4 && $SCAM_HOME/bin/PrintITL_Test_Run)

#DELETE install files
rm -rf $SCAM_HOME/install/tmp

echo -e "\e[30;48;5;82mDone!\e[0m";
