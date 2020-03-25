//
// Created by tobias on 25.03.20.
//

#ifndef DESCAM_MODULESTERNARY_H


#include "systemc.h"
#include "../Interfaces/Interfaces.h"

SC_MODULE(TestTernary01) {
        blocking_in<int> data_in;
        blocking_out<int> valid_out;
        shared_out<bool> data_out;

        int value_in;
        int new_value;
        bool valid;

        SC_CTOR(TestTernary01){
            SC_THREAD(fsm);
        }

        void fsm() {
            while (true) {
                data_in->try_read(value_in, valid);
                new_value = (valid) ? (value_in + 1) : value_in + 0;
                if(new_value > 5){
                    new_value = new_value + 1;
                }
                data_out->set(valid);
                valid_out->write(new_value, "output1");
                new_value = value_in > 0 ? 1 : 0;
                data_out->set(valid);
                valid_out->write(new_value, "output2");
            }
        }
};

#endif //DESCAM_MODULESTERNARY_H
