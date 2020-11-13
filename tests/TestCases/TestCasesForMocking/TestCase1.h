//
// Created by tobias on 05.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTCASE1_H_
#define SCAM_TESTS_GMOCK_TEST_TESTCASE1_H_

#include "systemc.h"
#include "../../example/Interfaces/Interfaces.h"

struct TestCase1 : public sc_module {
  //Constructor
  TestCase1(sc_module_name name) :
      b_in("b_in"),
      m_out("m_out"),
      var(1337) {
    SC_THREAD(fsm);
  }

  SC_HAS_PROCESS(TestCase1);

  //Out port
  blocking_in<int> b_in;
  master_out<int> m_out;
  //Variable - both should be removed from the model
  int var;

  void fsm() {

    while (true) {
      b_in->read(var); //state_5
      m_out->master_write(var);
    }
  }
};
#endif //SCAM_TESTS_GMOCK_TEST_TESTCASE1_H_
