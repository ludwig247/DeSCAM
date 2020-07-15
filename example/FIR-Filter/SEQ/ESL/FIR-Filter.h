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
    int shiftreg[N] = {0,0,0};
    int coef[N] = {1,1,1};//{53, 0, -91, 0, 313, 500, 313, 0, -91, 0, 53};

    int acc;
    int i;


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

        while (true) {

            if (phase_algorithm == IDLE) {

                data_in->read(data_algorithm, "data_in");
                phase_algorithm = RUN;

            } else {

                acc = 0;

                for (i = N - 1; i >= 0; i--) {
                    if (i == 0) {
                        acc += data_algorithm * coef[0];
                        shiftreg[0] = data_algorithm;
                    } else {
                        shiftreg[i] = shiftreg[i - 1];
                        acc += shiftreg[i] * coef[i];
                    }
                }

                data_out->write(acc,"data_out");
                phase_algorithm = IDLE;


            }


        }

    }


};
