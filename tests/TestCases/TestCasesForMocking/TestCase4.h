//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TestCase4_H
#define SCAM_TestCase4_H

#include "Interfaces.h"

SC_MODULE(TestCase4) {
  blocking_in<int> b_in;
  blocking_out<std::array<int, 2>> b_out;
//Constructor
  SC_CTOR(TestCase4) {
    SC_THREAD(fsm);
  }

  int test;
  std::array<int, 2> myArray;

  void fsm() {
    while (true) {
      b_in->read(test);
      myArray[0] = test + myArray[1];
      myArray[1] = test;
      b_out->write(myArray);
    }
  }
};

#endif //SCAM_ARRAY00_H
