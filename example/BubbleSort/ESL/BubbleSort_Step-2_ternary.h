//
// Created by Tobias Jauch on 26.05.2020
//
#include "../../Interfaces/Interfaces.h"
#include "systemc.h"
#include "DataTypes.h"


//#ifndef PROJECT_BUS_H
//#define PROJECT_BUS_H

#define ARRAY_SIZE 16

using namespace std;

struct BubbleSort : public sc_module {

    //Variables
    phases phase_algorithm;
    int data_algorithm[ARRAY_SIZE];

    int i; //counter for outer loop
    int j; //counter for inner loop
    int swap; //buffer for swapping values

    //data
    blocking_in<int[ARRAY_SIZE]> data_in;
    blocking_out<int[ARRAY_SIZE]> data_out;


    SC_HAS_PROCESS(BubbleSort);

    BubbleSort(sc_module_name name) :
       data_in("data_in"),
       data_out("data_out")
       {
        SC_THREAD(fsm);
       }

    void fsm() {

        phase_algorithm = IDLE;

        while (true) {

            if(phase_algorithm == IDLE) {

                data_in->read(data_algorithm,"data_in");
                phase_algorithm = RUN;
                i = 0;
                j = 0;

            }else{
                if (i != ARRAY_SIZE){
                    if (j != ARRAY_SIZE - i - 1){
                        if (data_algorithm[j] > data_algorithm[j+1]){

                            swap = data_algorithm[j];

                            data_algorithm[0] = j==0 ?  data_algorithm[1] : data_algorithm[0];
                            data_algorithm[1] = j==1 ?  data_algorithm[2] : data_algorithm[1];
                            data_algorithm[2] = j==2 ?  data_algorithm[3] : data_algorithm[2];
                            data_algorithm[3] = j==3 ?  data_algorithm[4] : data_algorithm[3];
                            data_algorithm[4] = j==4 ?  data_algorithm[5] : data_algorithm[4];
                            data_algorithm[5] = j==5 ?  data_algorithm[6] : data_algorithm[5];
                            data_algorithm[6] = j==6 ?  data_algorithm[7] : data_algorithm[6];
                            data_algorithm[7] = j==7 ?  data_algorithm[8] : data_algorithm[7];
                            data_algorithm[8] = j==8 ?  data_algorithm[9] : data_algorithm[8];
                            data_algorithm[9] = j==9 ?  data_algorithm[10] : data_algorithm[9];
                            data_algorithm[10] = j==10 ?  data_algorithm[11] : data_algorithm[10];
                            data_algorithm[11] = j==11 ?  data_algorithm[12] : data_algorithm[11];
                            data_algorithm[12] = j==12 ?  data_algorithm[13] : data_algorithm[12];
                            data_algorithm[13] = j==13 ?  data_algorithm[14] : data_algorithm[13];
                            data_algorithm[14] = j==14 ?  data_algorithm[15] : data_algorithm[14];

                            data_algorithm[1] = j==0 ?  swap : data_algorithm[1];
                            data_algorithm[2] = j==1 ?  swap : data_algorithm[2];
                            data_algorithm[3] = j==2 ?  swap : data_algorithm[3];
                            data_algorithm[4] = j==3 ?  swap : data_algorithm[4];
                            data_algorithm[5] = j==4 ?  swap : data_algorithm[5];
                            data_algorithm[6] = j==5 ?  swap : data_algorithm[6];
                            data_algorithm[7] = j==6 ?  swap : data_algorithm[7];
                            data_algorithm[8] = j==7 ?  swap : data_algorithm[8];
                            data_algorithm[9] = j==8 ?  swap : data_algorithm[9];
                            data_algorithm[10] = j==9 ?  swap : data_algorithm[10];
                            data_algorithm[11] = j==10 ?  swap : data_algorithm[11];
                            data_algorithm[12] = j==11 ?  swap : data_algorithm[12];
                            data_algorithm[13] = j==12 ?  swap : data_algorithm[13];
                            data_algorithm[14] = j==13 ?  swap : data_algorithm[14];
                            data_algorithm[15] = j==14 ?  swap : data_algorithm[15];

                        }
                        ++j;
                        //insert_state("inner_loop");
                    }else{
                        j = 0;
                        ++i;

                    }
                    insert_state("loop");

                }else{

                    data_out->write(data_algorithm, "data_out");

                    phase_algorithm = IDLE;

                }

            }

        }

    }

};


