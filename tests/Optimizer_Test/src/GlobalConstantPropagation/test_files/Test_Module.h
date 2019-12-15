//
// Created by mi-alkoudsi 08.12.19
//

#ifndef OPTIMIZER_GCP_TESTING_H
#define OPTIMIZER_GCP_TESTING_H

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
        x = 5;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {  
                b_in->read(y);
                if(y){
                    b_out->write(x);
                }else{
                    b_out->write(-x);
                }
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                b_out->write(x * x);
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
    int x;
    bool y;

    //Constructor
    SC_HAS_PROCESS(Test_Module1);

    Test_Module1(sc_module_name name) :
    b_out("b_out")
    {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<bool> b_in;
    blocking_out<int> b_out;

    void fsm() {
        nextphase = SECTION_A;
        x = 5;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_in->read(y);
                x = 6;
                if(y){
                    b_out->write(x);
                }else{
                    b_out->write(-x);
                }
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                b_out->write(x * x);
                nextphase = SECTION_A;
            }
        }
    }
};


struct Test_Module2 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(Test_Module2);

    Test_Module2(sc_module_name name) :
            b_in("b_in") {
        SC_THREAD(fsm);
    }

    blocking_in<int[2]> b_in;
    blocking_out<int[2]> b_out;
    //Vars
    int x[2],y[2];
	
    void fsm() {
        nextphase = SECTION_A;
        x[0] = 5;
        x[1] = 10;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                y[0] = x[0];
                y[1] = x[1];
                if(x[0] > x[1]){
                    b_out->write(x);
                }
                nextphase = SECTION_B;
            } else {
				b_in->read(y);
                if(y[0] > x[1]){
                    b_out->write(y);
                }
                nextphase = SECTION_A;
            }
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
    data_t x,y;
	
    void fsm() {
        nextphase = SECTION_A;
        x.data = 5;
        x.ack = ack_t::OK;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                y = x;
                b_out->write(y);
                nextphase = SECTION_B;
            } else {
				b_in->read(y);
                if(y.data > x.data){
                    b_out->write(y);
                }
                nextphase = SECTION_A;
            }
        }
    }
};
#endif //OPTIMIZER_GCP_TESTING_H


