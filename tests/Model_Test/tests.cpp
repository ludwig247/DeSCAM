//
// Created by tobias on 11.04.17.
//
#include <gtest/gtest.h>
#include <gmock/gmock.h>

#include "Variable_Test.h"
#include "OperationState_Test.h"


int main(int argc, char **argv) {
    testing::InitGoogleMock(&argc, argv);
    return RUN_ALL_TESTS();
}