//
// Created by tobias on 11.04.17.
//
#include <gtest/gtest.h>

#include "PrintITL_Test.h"


int main(int argc, char **argv) {
    example_headers = parameter(SCAM_HOME"/tests/Print_ITL_Tests/tests.list");
    funct_headers = parameter(SCAM_HOME"/tests/Print_ITL_Tests/functionality_tests.list");
    testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}