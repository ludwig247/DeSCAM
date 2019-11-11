#!/usr/bin/env bash

#BINARY LOCATIONS
SCAM_HOME="${GITHUB_WORKSPACE}" #NO SLASH AT THE END
CMAKE_BIN="cmake" #NO SLASH AT THE END
PYTHON3="python3" #NO SLASH AT THE END

#INSTALLING Z3
echo -e "\e[30;48;5;82mInstalling Z3\e[0m";
(cd $SCAM_HOME/install/tmp/z3 &&
 $PYTHON3 scripts/mk_make.py --prefix $SCAM_HOME/install/tmp/files/z3 &&
cd build &&
make -w -j4 &&
make install &&
echo -e "\e[30;48;5;82mInstalled Z3\e[0m" ) || (echo -e "\e[41mError installing z3\e[0m" && exit 1) ;
