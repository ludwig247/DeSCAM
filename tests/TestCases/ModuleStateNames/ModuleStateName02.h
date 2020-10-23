//
// Created by hesselberg on 9/30/20.
//

#ifndef SCAM_MODULESTATENAME02_H
#define SCAM_MODULESTATENAME02_H

#include "systemc.h"
#include "Interfaces.h"

SC_MODULE(ModuleStateName02) {
        master_in<int> m_in;
        master_out<int> m_out;

        SC_CTOR(ModuleStateName02){
            SC_THREAD(fsm);
        }
        int val;
        bool res;
        void fsm() {
            while (true) {
                m_in->master_read(val);
                m_out->master_write(val,"idle");

                m_in->master_read(val);
                m_out->master_write(val,"store");

            }
        }
};

#endif //SCAM_MODULESTATENAME02_H
