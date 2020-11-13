//
// Created by mi-alkoudsi 08.12.19
//

#ifndef OPTIMIZER_RA_TESTING_H
#define OPTIMIZER_RA_TESTING_H

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
                b_in->read(y);
                if(y){
                   x = 5;
                }
		if(x >= 0){
		b_out->write(x);
		}else{
		b_out->write(-x);
		}
		
                nextphase = SECTION_B;
            }
            else {
                x = -5;
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
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_in->read(y);
                if(y){
                   x = 5;
              	}
		if(x >= 0){
		b_out->write(x);
		}else{  //unreachable
		b_out->write(-x);
		}
                nextphase = SECTION_B;
            }
            else {
                x = 9;
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
    int x;
    bool y;

    //Constructor
    SC_HAS_PROCESS(Test_Module2);

    Test_Module2(sc_module_name name) :
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
                b_in->read(y);
                if(y){
                   x = 5;
                }else{
                    x = 8;
                }
		    if(x >= 0){
		    b_out->write(x);
		    }else{ //unreachable
		    b_out->write(-x);
		    }
                nextphase = SECTION_B;
            }
            else {
                x = -5;
                nextphase = SECTION_A;
            }
        }
    }
};

struct Test_Module3 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;
    int x,f;
    bool y;

    //Constructor
    SC_HAS_PROCESS(Test_Module3);

    Test_Module3(sc_module_name name) :
            b_out("b_out")
    {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<bool> b_in;
    blocking_out<int> b_out;

    void fsm() {
        nextphase = SECTION_A;
        f = 5;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_in->read(y);
                if(y){
                    x = f + 1;
                }else{
                    x = 8;
                }
                if(x >= 0){
                    b_out->write(x);
                }else{ //unreachable
                    b_out->write(-x);
                }
                nextphase = SECTION_B;
            }
            else {
                x = -5;
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
    int x,f;
    bool y;

    //Constructor
    SC_HAS_PROCESS(Test_Module4);

    Test_Module4(sc_module_name name) :
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
                b_in->read(y);
                if(y){
                    x = 1 - f;
                }else{
                    x = 8 + f;
                }
                if(x >= 0){
                    b_out->write(x);
                }else{ //unreachable
                    b_out->write(-x);
                }
                nextphase = SECTION_B;
            }
            else {
                f = -1;
                x = -5;
                b_out->write(f + x);
                nextphase = SECTION_A;
            }
        }
    }
};

#endif //OPTIMIZER_RA_TESTING_H


