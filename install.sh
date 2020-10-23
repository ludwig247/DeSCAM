#!/bin/bash

function build_DeSCAM {
	mkdir build && cd build
	cmake ../
        cmake --build . --target SCAM -- -j 8
        cmake --build . --target PrintITL_Test_Run -- -j 8
        cmake --build . --target PrintSkeleton_Test_Run -- -j 8
}

function run_tests {
	cd $SELF_DIR/bin
        ./PrintITL_Test_Run
        ./PrintSkeleton_Test_Run
}

function delete_artifacts {
        rm -rf ./build/3rdParty
        rm -rf ./install/tmp
}

function save_envvariables {
	SELF_DIR=$(pwd)
	TEST_DIR = $(pwd)
	echo Current Dir: $SELF_DIR
	SC_HOME="$SELF_DIR/include"
	SCAM_HOME="$SELF_DIR"
	CLANG_DIR="$SELF_DIR/include/clang/3.4.2/include"
	SCAM_DIR="$SELF_DIR/"
	ROOT_DIR="/"
	SYSTEMC_DIR="$SELF_DIR/include/"

	if [ -z "$SYSTEMC_HOME" ]; then
	  SYSTEMC_HOME="$SC_HOME"
	else
	  SYSTEMC_HOME="$SYSTEMC_HOME:$SC_HOME"
	fi

	export SYSTEMC_HOME
	export SCAM_HOME
	export CLANG_DIR
	export SCAM_DIR
	export ROOT_DIR
	export SYSTEMC_DIR

	echo SCAM_HOME="$SCAM_HOME" >> /etc/environment
	echo CLANG_DIR="$CLANG_DIR" >> /etc/environment
	echo SCAM_DIR="$SCAM_DIR" >> /etc/environment
	echo ROOT_DIR="$ROOT_DIR" >> /etc/environment
	echo SYSTEMC_DIR="$SYSTEMC_DIR" >> /etc/environment
	echo SYSTEMC_HOME="$SYSTEMC_HOME" >> /etc/environment

	ldconfig

	echo "source /etc/environment" >> ~/.bashrc
}
if cat /etc/os-release | agrep -q 'Ubuntu;18.04'; then
    echo Installing on Ubuntu 18.04
    apt-get -y update
    apt-get -y install git cmake gcc g++ unzip sed software-properties-common
    add-apt-repository -y ppa:deadsnakes/ppa
    apt-get -y update
    apt-get -y install python3.7 libtinfo-dev 
    build_DeSCAM
    delete_artifacts
    save_envvariables
    run_tests
elif cat /etc/os-release | agrep -q 'Ubuntu;16.04'; then
    echo Installing on Ubuntu 16.04
    apt-get -y update
    apt-get -y install git cmake gcc g++ unzip sed software-properties-common
    add-apt-repository -y ppa:deadsnakes/ppa
    apt-get -y update
    apt-get -y install python3.7 libtinfo-dev 
    build_DeSCAM
    delete_artifacts
    save_envvariables
    run_tests
else
    echo No Supported OS found!
fi
