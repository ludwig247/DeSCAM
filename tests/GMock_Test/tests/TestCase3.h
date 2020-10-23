//
// Created by tobias on 07.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_TESTCASE3_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_TESTCASE3_H_

#include "defines.h"

SC_MODULE(TestCase3) {
  blocking_in<int> test_in;
  blocking_out<unsigned int> test_out;

  int foo;
  unsigned int bar;
  unsigned int list[5];

  SC_CTOR(TestCase3) :
      test_in("test_in"),
      test_out("test_out") {
    SC_THREAD(fsm);
  }

  void fsm() {
    while (true) {
      test_in->read(foo, "idle");
      bar = bar + static_cast<unsigned int>(compute2(foo, bar));
      bar = bar + compute(3, compute2(foo, bar));
      bar = bar + compute(list[0], 5);
      if (compute3(foo > 5, bar)) {
        test_out->write(bar);
      } else test_out->write(bar + 1);
    }
  }
};

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_TESTCASE3_H_
