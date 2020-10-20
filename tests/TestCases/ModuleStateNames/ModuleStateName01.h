//
// Created by hesselberg on 9/30/20.
//

#ifndef SCAM_MODULESTATENAME01_H
#define SCAM_MODULESTATENAME01_H

#include "systemc.h"
#include "Interfaces.h"

SC_MODULE(ModuleStateName01) {
        blocking_in<int> b_in;
        blocking_out<int> b_out;

        SC_CTOR(ModuleStateName01){
            SC_THREAD(fsm);
        }
        int val;
        bool res;
        void fsm() {
            while (true) {
                b_in->read(val);
                b_in->read(val,"idle");
                b_in->try_read(val,res,"wait");
                b_out->write(val);
                b_out->write(val,"store");
                b_out->try_write(val,res,"load");
            }
        }
};

#endif //SCAM_MODULESTATENAME01_H
