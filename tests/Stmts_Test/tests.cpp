//
// Created by tobias on 11.04.17.
//
#include <gtest/gtest.h>
#include <gmock/gmock.h>

#include "Module_Test.h"
#include "Stmt_Compare_Tests.h"


int main(int argc, char **argv) {
    testing::InitGoogleMock(&argc, argv);
    return RUN_ALL_TESTS();
}