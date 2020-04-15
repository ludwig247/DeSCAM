#!/usr/bin/env bash

#BINARY LOCATIONS
SCAM_HOME="${GITHUB_WORKSPACE}" #NO SLASH AT THE END
CMAKE_BIN="cmake" #NO SLASH AT THE END
PYTHON3="python3" #NO SLASH AT THE END

echo -e "\e[30;48;5;82mRun Optimizer_Test_Run\e[0m";
($CMAKE_BIN --build $SCAM_HOME/install/tmp/build/ --target Optimizer_Test_Run -- -j 4 && $SCAM_HOME/bin/Optimizer_Test_Run)

echo -e "\e[30;48;5;82mDone!\e[0m";




