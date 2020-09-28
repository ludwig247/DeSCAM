//
// Created by hesselberg on 9/28/20.
//

#ifndef SCAM_TESTFUNCTION2_H
#define SCAM_TESTFUNCTION2_H

#include "systemc.h"
#include "Interfaces.h"
#include "Types.h"

SC_MODULE(TestFunction1) {

        unsigned int foo(unsigned int x) const{
            ++x;
            if(x>5) return x<<1;
            if(x>20) return x+2;
            else if(x == 20) return x;
            else return 0;
        }

        //Constructor
        SC_CTOR(TestFunction1):
        b_out("b_out"),
        b_in("b_in") {
            SC_THREAD(fsm);
        }

        //Out-port
        blocking_out<unsigned int> b_out;
        blocking_in<record_t> b_in;

        int x;
        unsigned int y;
        record_t record_var;

        void fsm() {
            while (true) {
                b_in->read(record_var);
                y = static_cast<unsigned int>(record_var.x);
                b_out->write(y);
                y = static_cast<unsigned int>(static_cast<int>(record_var.y) + x );
                b_out->write(y);
                y = static_cast<unsigned int>(static_cast<int>(record_var.y) >> static_cast<int>((y) & 0x0000001F));
                b_out->write(y);
                y = static_cast<unsigned int>(static_cast<int>(record_var.y) >> static_cast<int>((foo(record_var.y)) & 0x0000001F));
                b_out->write(y);
            }
        }
};

SC_MODULE(TestFunction2) {

        unsigned int foo(record_t record_var) const{
            if(static_cast<int>(record_var.y) < 20){
                return static_cast<unsigned int>(static_cast<int>(record_var.y) >> static_cast<int>(y & 0x0000001F));
            }else return 0;
        }

        //Constructor
        SC_CTOR(TestFunction2):
        b_out("b_out"),
        b_in("b_in") {
            SC_THREAD(fsm);
        }

        //Out-port
        blocking_out<unsigned int> b_out;
        blocking_in<record_t> b_in;

        int x;
        unsigned int y;
        record_t record_var;

        void fsm() {
            while (true) {
                b_in->read(record_var);

                b_out->write(foo(record_var));
            }
        }
};
#endif //SCAM_TESTFUNCTION2_H
