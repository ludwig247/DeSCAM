//
// Created by hesselberg on 9/30/20.
//

#ifndef SCAM_MODULESTATENAME03_H
#define SCAM_MODULESTATENAME03_H

#include "systemc.h"
#include "Interfaces.h"

SC_MODULE(ModuleStateName03) {
        master_in<int> m_in;
        slave_in<int> s_in;
        slave_out<int> s_out;
        master_out<int> m_out;

        SC_CTOR(ModuleStateName03){
            SC_THREAD(fsm);
        }
        int val;
        bool res;
        void fsm() {
            while (true) {
                insert_state("idle");
                s_in->slave_read(val,res);
                m_in->master_read(val);
                m_out->master_write(val,"idle");
                s_out->slave_write(val);

                insert_state();
                m_in->master_read(val);
                s_in->slave_read(val,res);
                m_out->master_write(val);
                s_out->slave_write(val);

            }
        }
};


#endif //SCAM_MODULESTATENAME03_H
