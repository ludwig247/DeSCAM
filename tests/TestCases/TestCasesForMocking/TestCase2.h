//
// Created by tobias on 07.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_TESTCASE2_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_TESTCASE2_H_

#include "defines.h"

SC_MODULE(TestCase2) {
    blocking_in<int> test_in;
    blocking_out<unsigned int> test_out;

    int foo;
    unsigned int bar;

    unsigned int test_var(unsigned int val) const {
      return val + 3 + number;
    }

    SC_CTOR(TestCase2) :
    test_in("test_in"),
    test_out("test_out") {
      SC_THREAD(fsm);
    }

    void fsm() {
      while (true) {
        //test_in->read(foo);
        if (number4) {

          bar = number + bar;

          bar = bar + number2;

          bar = bar + static_cast<unsigned>(number3);

          bar = bar + test_var(number2);
        }
        test_out->write(bar);

      }
    }
};
#endif //SCAM_TESTS_GMOCK_TEST_TESTS_TESTCASE2_H_
