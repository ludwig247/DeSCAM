#ifndef PROJECT_CIRCULAR1_H
#define PROJECT_CIRCULAR1_H

#include "systemc.h"
#include "../Interfaces/Interfaces.h"

SC_MODULE(circular1) {
    SC_CTOR(circular1) : nextsection(A) {
        SC_THREAD(fsm)
    };
    enum Sections {
        A, B, C
    };
    Sections section, nextsection;
    blocking_in<int> b_in1;
	blocking_in<int> b_in2;
	blocking_out<int> b_out1;

    int sum;
    int int1;
	int int2;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == A) {
                b_in1->read(int1);
                section = B;
            } else if (section == B) {
                b_in2->read(int2);
                section = C;
            } else if (section == C) {
				sum = int1 + int2;
                b_out1->write(sum);
                section = A;
            }
        }
    }
};

#endif //PROJECT_CIRCULAR1_H
