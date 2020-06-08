//
// Created by Tobias Jauch on 26.05.2020
//
#include "../../Interfaces/Interfaces.h"
#include "systemc.h"
#include "DataTypes.h"


//#ifndef PROJECT_BUS_H
//#define PROJECT_BUS_H

#define ARRAY_SIZE 8

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

                /*cout << "Algorithm: data received" << endl;

                cout << "unsorted: " << data_algorithm[0] << endl;
                cout << "unsorted: " << data_algorithm[1] << endl;
                cout << "unsorted: " << data_algorithm[2] << endl;
                cout << "unsorted: " << data_algorithm[3] << endl;
                cout << "unsorted: " << data_algorithm[4] << endl;
                cout << "unsorted: " << data_algorithm[5] << endl;
                cout << "unsorted: " << data_algorithm[6] << endl;
                cout << "unsorted: " << data_algorithm[7] << endl;*/

            }else{
                if (i != ARRAY_SIZE){
                    if (j != ARRAY_SIZE - i - 1){
                        if (data_algorithm[j] > data_algorithm[j+1]){

                            /*swap = j==0 ?  data_algorithm[0] : swap;
                            swap = j==1 ?  data_algorithm[1] : swap;
                            swap = j==2 ?  data_algorithm[2] : swap;
                            swap = j==3 ?  data_algorithm[3] : swap;
                            swap = j==4 ?  data_algorithm[4] : swap;
                            swap = j==5 ?  data_algorithm[5] : swap;
                            swap = j==6 ?  data_algorithm[6] : swap;*/

                            swap = data_algorithm[j];

                            data_algorithm[0] = j==0 ?  data_algorithm[1] : data_algorithm[0];
                            data_algorithm[1] = j==1 ?  data_algorithm[2] : data_algorithm[1];
                            data_algorithm[2] = j==2 ?  data_algorithm[3] : data_algorithm[2];
                            data_algorithm[3] = j==3 ?  data_algorithm[4] : data_algot_end(o)##0 data_algorithm(1) == ((j_0 == 0)?data_algorithm_0(j_0):((j_0 == 1)?data_algorithm_2_0:data_algorithm_1_0)) andrithm[3];
                            data_algorithm[4] = j==4 ?  data_algorithm[5] : data_algorithm[4];
                            data_algorithm[5] = j==5 ?  data_algorithm[6] : data_algorithm[5];
                            data_algorithm[6] = j==6 ?  data_algorithm[7] : data_algorithm[6];

                            data_algorithm[1] = j==0 ?  swap : data_algorithm[1];
                            data_algorithm[2] = j==1 ?  swap : data_algorithm[2];
                            data_algorithm[3] = j==2 ?  swap : data_algorithm[3];
                            data_algorithm[4] = j==3 ?  swap : data_algorithm[4];
                            data_algorithm[5] = j==4 ?  swap : data_algorithm[5];
                            data_algorithm[6] = j==5 ?  swap : data_algorithm[6];
                            data_algorithm[7] = j==6 ?  swap : data_algorithm[7];

                            /*if(j==0){
                                swap = data_algorithm[0];
                                data_algorithm[0] = data_algorithm[1];
                                data_algorithm[1] = swap;
                            }
                            else if(j==1){
                                swap = data_algorithm[1];
                                data_algorithm[1] = data_algorithm[2];
                                data_algorithm[2] = swap;
                            }
                            else if(j==2){
                                swap = data_algorithm[2];
                                data_algorithm[2] = data_algorithm[3];
                                data_algorithm[3] = swap;
                            }
                            else if(j==3){
                                swap = data_algorithm[3];
                                data_algorithm[3] = data_algorithm[4];
                                data_algorithm[4] = swap;
                            }
                            else if(j==4){
                                swap = data_algorithm[4];
                                data_algorithm[4] = data_algorithm[5];
                                data_algorithm[5] = swap;
                            }
                            else if(j==5){
                                swap = data_algorithm[5];
                                data_algorithm[5] = data_algorithm[6];
                                data_algorithm[6] = swap;
                            }
                            else if(j==6){
                                swap = data_algorithm[6];
                                data_algorithm[6] = data_algorithm[7];
                                data_algorithm[7] = swap;
                            }*/
                        }
                        ++j;
                        //insert_state("inner_loop");
                    }else{
                        j = 0;
                        ++i;

                    }
                    insert_state("loop");

                }else{

                  /*  cout << "sorted: " << data_algorithm[0] << endl;
                    cout << "sorted: " << data_algorithm[1] << endl;
                    cout << "sorted: " << data_algorithm[2] << endl;
                    cout << "sorted: " << data_algorithm[3] << endl;
                    cout << "sorted: " << data_algorithm[4] << endl;
                    cout << "sorted: " << data_algorithm[5] << endl;
                    cout << "sorted: " << data_algorithm[6] << endl;
                    cout << "sorted: " << data_algorithm[7] << endl;

                    cout << "Algorithm: data sorted sent" << endl;*/

                    data_out->write(data_algorithm, "data_out");

                    phase_algorithm = IDLE;

                }

            }

        }

    }

};


