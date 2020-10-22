//
// Created by tobias on 07.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_DEFINES_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_DEFINES_H_

#include "systemc.h"
#include "../../../example/Interfaces/Interfaces.h"


const unsigned number = 0x111;
const unsigned int number2 = 0x111;
const int number3 = 20;
const bool number4 = true;
const int intern = 3;
const int intern2 = 3;

unsigned int compute(unsigned int param, int param2) {
  if (param > 10 && param2 > 10) {
    return param + 1;
  } else return param + static_cast<unsigned int>(param2);
}

int nested(unsigned int param2) {
  return static_cast<int>(param2) + 3;
}

int compute2(int param, unsigned int param2) {
  param = param + static_cast<int>(param2);
  return param + 3 + nested(param2);
}

bool compute3(bool param, unsigned int val) {
  if (param) return val + 2;
  else return val;
}


bool global_intern(bool param, unsigned int val) {
  if (param) return val + intern;
  else return val;
}

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_DEFINES_H_
