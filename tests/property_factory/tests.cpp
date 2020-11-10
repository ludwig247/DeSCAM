//
// Created by tobias on 11.04.17.
//
#include <gtest/gtest.h>
#include <gmock/gmock.h>

#include "InitiSectionTest.h"
#include "ValuePropagationTest.h"
#include "DataPathOptimizerTest.h"
#include "ConditionOptimizerTest.h"
#include "CleanUpPaths.h"


int main(int argc, char **argv) {
    testing::InitGoogleMock(&argc, argv);
    return RUN_ALL_TESTS();
}