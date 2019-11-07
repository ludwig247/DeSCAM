//
// Created by ludwig on 10.10.17.
//

#ifndef PROJECT_SLAVEDAVEBAVE_H_H
#define PROJECT_SLAVEDAVEBAVE_H_H


#include "systemc.h"
#include "../Interfaces/Interfaces.h"

SC_MODULE(SlaveTest)
{
    slave_in<int> test_in;
    slave_out<int> test_out;
    enum Sections{S_A, S_B};
    Sections section, nextsection;

    int val;

    SC_CTOR(SlaveTest):
            test_in("test_in"),
            test_out("test_out"),
            nextsection(S_A),
            val(0)
    {
        SC_THREAD(fsm);
    }
    void fsm()
    {
        while(true)
        {
            section = nextsection;
            if (section == S_A)
            {
                test_in->slave_read(val);
                test_out->slave_write(val);
                nextsection = S_B;
            }
            if (section == S_B)
            {
                nextsection = S_A;
            }
        }
    }
};

#endif //PROJECT_SLAVEDAVEBAVE_H_H
