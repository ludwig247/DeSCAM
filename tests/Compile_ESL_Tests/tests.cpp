//
// Created by hesselberg on 7/15/20.
//

#include <gtest/gtest.h>

#include "Compile_ESL_Test.h"
#define SHELLSCRIPT "cmake --build ../cmake-build-debug --target Compile_ESL_Test_Run"


int main(int argc, char **argv) {

    int systemRet = system(SHELLSCRIPT);;
    if(systemRet == -1) std::terminate();

    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}