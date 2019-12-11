//
// Created by mi-alkoudsi 08.12.19
//

#ifndef OPTIMIZER_LVP_TESTING_H
#define OPTIMIZER_LVP_TESTING_H

#include "systemc.h"
#include "../../../../example/Interfaces/Interfaces.h"


struct Test_Module0 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;
    int x;
    bool y;

    //Constructor
    SC_HAS_PROCESS(Test_Module0);

    Test_Module0(sc_module_name name) :
            b_out("b_out")
            {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<bool> b_in;
    blocking_out<int> b_out;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                x = 5;
                b_in->read(y);
                if(y){
                    b_out->write(x);
                }else{
                    b_out->write(-x);
                }
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                x = 1;
                b_out->write(x);
                nextphase = SECTION_A;
            }
        }
    }
};

struct Test_Module1 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(Test_Module1);

    Test_Module1(sc_module_name name) :
            b_in("b_in") {
        SC_THREAD(fsm);
    }

    blocking_in<int[2]> b_in;
    blocking_out<int> b_out;
    //Vars
    int x[2];

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_in->read(x);
                if(x[0] > x[1]){
                    b_out->write(x[0]);
                }
                nextphase = SECTION_B;
            } else {
                x[0] = 5;
                if(x[1] > x[0]){
                    b_out->write(x[1]);
                }
                nextphase = SECTION_A;
            }
        }
    }
};

struct Test_Module2 : public sc_module {

    //Constructor
    Test_Module2(sc_module_name name) :
            b_out("b_out") {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(Test_Module2);

    //Out port
    blocking_out<int> b_out;
    //Variable
    int x;
    int y;

    void fsm() {
        while (true) {
            x = 10 + y;
            y = y + 1;
            b_out->write(x); //shouldn't propagate x
        }
    }
};

enum ack_t  {
    OK, RTY, ERR
};

struct data_t{
    int data;
    ack_t ack;
};

struct Test_Module3 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(Test_Module3);

    Test_Module3(sc_module_name name) :
    b_in("b_in") {
        SC_THREAD(fsm);
    }

    blocking_in<data_t> b_in;
    blocking_out<data_t> b_out;
    //Vars
    data_t d1,d2;
    int x;
    void fsm() {
        nextphase = SECTION_A;
        d2.data = 10;
        d2.ack = ack_t::OK;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                d1.data = 10;
                d1.ack = ack_t::OK;
                if(d1.data == d2.data){
                    b_out->write(d1); //propagation here relies on the DONT_PROPAGATE_COMPOUND_VARIABLE_VALUES_TO_WRITE_STATEMENTS definition
                } else {
                    b_out->write(d2); //propagation here relies on the DONT_PROPAGATE_COMPOUND_VARIABLE_VALUES_TO_WRITE_STATEMENTS definition
                }
                nextphase = SECTION_B;
            } else {
                d1.data = x + 10;
                x = x + 1;
                if(d1.data >= 10){ //should not propagate here
                    d2.data = d2.data + 1;
                    b_out->write(d2); //propagation here relies on the DONT_PROPAGATE_COMPOUND_VARIABLE_VALUES_TO_WRITE_STATEMENTS definition
                }
                nextphase = SECTION_A;
            }
        }
    }

};

struct Test_Module4 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;

    //Constructor
    SC_HAS_PROCESS(Test_Module4);

    Test_Module4(sc_module_name name) :
    b_in("b_in") {
        SC_THREAD(fsm);
    }

    blocking_in<int[2]> b_in;
    blocking_out<int[2]> b_out;
    //Vars
    int d1[2],d2[2];
    int x;
    void fsm() {
        nextphase = SECTION_A;
        d2[0] = 5;
        d2[1] = 10;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                d1[0] = 5;
                d1[1] = 10;
                if(d1[0] == d2[0]){
                    b_out->write(d1); //propagation here relies on the DONT_PROPAGATE_COMPOUND_VARIABLE_VALUES_TO_WRITE_STATEMENTS definition
                } else {
                    b_out->write(d2); //propagation here relies on the DONT_PROPAGATE_COMPOUND_VARIABLE_VALUES_TO_WRITE_STATEMENTS definition
                }
                nextphase = SECTION_B;
            } else {
                d1[0] = x + 10;
                x = x + 1;
                if(d1[0] > 10){ //should not propagate here
                    d2[0] = d2[0] + 1;
                    b_out->write(d2); //propagation here relies on the DONT_PROPAGATE_COMPOUND_VARIABLE_VALUES_TO_WRITE_STATEMENTS definition
                }
                nextphase = SECTION_A;
            }
        }
    }

};
#endif //OPTIMIZER_LVP_TESTING_H


