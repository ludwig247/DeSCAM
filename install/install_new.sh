#!/bin/bash
#BINARY LOCATIONS
SCAM_HOME="$HOME/SCAM" #NO SLASH AT THE END
CMAKE_BIN="cmake3" #NO SLASH AT THE END
PYTHON3="python" #NO SLASH AT THE END

#UNZIPPING FILES
echo -e "\e[30;48;5;82mUnpacking files\e[0m"
(unzip $SCAM_HOME/install/install_new.zip  -d $SCAM_HOME/install/tmp && echo "\e[30;48;5;82m Unpacked files") || (echo "\e[41mError unpacking file install_new.zip" && exit 1) ;
cd $SCAM_HOME/install/tmp;
mkdir build

#INSTALLING Z3
echo -e "\e[30;48;5;82mInstalling Z3\e[0m";
(cd $SCAM_HOME/install/tmp/z3 &&
 $PYTHON3 scripts/mk_make.py --prefix $SCAM_HOME/install/tmp/files/z3 &&
cd build &&
make -w -j4 &&
make install &&
echo -e "\e[30;48;5;82mInstalled Z3\e[0m" ) || (echo -e "\e[41mError installing z3\e[0m" && exit 1) ;

#INSTALLING GTEST
echo -e "\e[30;48;5;82mInstalling GTest\e[0m";
(cd $SCAM_HOME/install/tmp/build/ &&
$CMAKE_BIN -DCMAKE_INSTALL_PREFIX:PATH=$SCAM_HOME/install/tmp/files/gtest ../googletest/
make -w -j4 &&
make install &&
cd ../ &&
rm -r ./build/* &&
echo -e "\e[30;48;5;82mInstalled GTest!\e[0m") || (echo -e "\e[41mError installing GTest\e[0m" && exit 1) ;

#INSTALLING SYSTEMC
echo -e "\e[30;48;5;82mInstalling SystemC...\e[0m";
(cd $SCAM_HOME/install/tmp/build &&
../systemc-2.3.1/configure --prefix $SCAM_HOME/install/tmp/files/SystemC &&
make -w -j4 &&
make install &&
cd ../ &&
rm -r ./build/* &&
echo -e "\e[30;48;5;82mInstalled SystemC!\e[0m") || (echo -e "\e[41mError installing SystemC \e[0m" && exit 1) ;


#INSTALLING LLVM/CLANG
echo -e "\e[30;48;5;82mInstalling LLVM/CLANG\e[0m";
(cd $SCAM_HOME/install/tmp/build/ &&
$CMAKE_BIN -DCMAKE_INSTALL_PREFIX:PATH=$SCAM_HOME/install/tmp/files/llvm ../llvm
make -w -j4 &&
make install &&
cd ../ &&
rm -r ./build/* &&
echo -e "\e[30;48;5;82mInstalled LLVM/Clang!\e[0m") || (echo -e "\e[41mError installing LLVM\e[0m" && exit 1) ;


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

//LIB
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

echo -e "\e[30;48;5;82mInstalling SCAM ...\e[0m";
(cd $SCAM_HOME/install/tmp/build/ &&
$CMAKE_BIN ../../../ &&
$CMAKE_BIN --build $SCAM_HOME/install/tmp/build/ --target SCAM -- -j 4  &&
echo -e"\e[30;48;5;82mInstalled SCAM!\e[0m" ) || (echo -e "\e[41mError installing SCAM \e[0m" && exit 1);

echo -e "\e[30;48;5;82mRun Test\e[0m";
($CMAKE_BIN --build $SCAM_HOME/install/tmp/build/ --target PrintITL_Test_Run -- -j 4 && $SCAM_HOME/bin/PrintITL_Test_Run)

#DELETE install files
rm -rf $SCAM_HOME/install/tmp

echo -e "\e[30;48;5;82mDone!\e[0m";











