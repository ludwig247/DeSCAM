//
// Created by Tobias Jauch on 15.07.2020
//
#include "../../../Interfaces/Interfaces.h"
#include "systemc.h"
#include "DataTypes.h"


#define N 3
#define ARRAY_SIZE 8

using namespace std;


struct FIR : public sc_module {

    //Variables
    phases phase_algorithm;
    int data_algorithm;
    int shiftreg[N];
    int coef[N];//{53, 0, -91, 0, 313, 500, 313, 0, -91, 0, 53};

    int acc;


    blocking_in<int> data_in;
    blocking_out<int> data_out;


    SC_HAS_PROCESS(FIR);

    FIR(sc_module_name name) :
            data_in("data_in"),
            data_out("data_out") {
        SC_THREAD(fsm);
    }

    void fsm() {

        phase_algorithm = IDLE;
        acc = 0;
        shiftreg[0] = 0;
        shiftreg[1] = 0;
        shiftreg[2] = 0;
        coef[0] = 1;
        coef[1] = 1;
        coef[2] = 1;

        while (true) {

            if (phase_algorithm == IDLE) {

                data_in->read(data_algorithm, "data_in");
                phase_algorithm = RUN_C1;
                acc = 0;

                shiftreg[2] = shiftreg[1];
                shiftreg[1] = shiftreg[0];
                shiftreg[0] = data_algorithm;

            } else if(phase_algorithm == RUN_C1) {

                insert_state("C1");

                acc = (shiftreg[2] * coef[2]);
                phase_algorithm = RUN_C2;

            } else if(phase_algorithm == RUN_C2) {

                insert_state("C2");
                acc = acc + shiftreg[1] * coef[1];
                //acc += shiftreg[1] * coef[1];
                phase_algorithm = RUN_C3;
                //assume: acc@c2 = s2*c2@c1 + s1*c1@c2
                //c2 = c2
                //s2 = s2
                //s1 = s1
                //s0 = c0
                acc_c2_i2 = acc_c2_i1
            } else if(phase_algorithm == RUN_C3) {

                insert_state("C3");
                acc = acc +  shiftreg[0] * coef[0];
                //acc = s2*c2(at c1) + s1*c1(at c2) + s0*c0@c3
                coef[2] = coef[1];
                coef[1] = coef[0];
                coef[0] = acc;
                //coef[0] = s2*c2(at c1) + s1*c1(at c2) + s0*c0@c3;
                phase_algorithm = RUN_OUT;

            }else{
                data_out->write(acc,"data_out");
                phase_algorithm = IDLE;
            }

        }

    }

};
