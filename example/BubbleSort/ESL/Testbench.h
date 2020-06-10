//
// Created by Tobias Jauch on 02.05.20.
//
#include<iostream>
#include <chrono>

#include "../../Interfaces/Interfaces.h"
#include "systemc.h"
#include "DataTypes.h"


#define ARRAY_SIZE 64

//#ifndef ESL_TESTBENCH_H
//#define ESL_TESTBENCH_H

struct Testbench : public sc_module {

    //Variables
    int data_testbench[ARRAY_SIZE];

    //out-port
   blocking_out<int[ARRAY_SIZE]> data_out;

    //in-port
   blocking_in<int[ARRAY_SIZE]> data_in;


    int cnt = 0;
    int cnt_fill = 0;

    int runs_simulated = 1000000; //1.000.000


    //Constructor
    SC_HAS_PROCESS(Testbench);

    Testbench(sc_module_name name) :
                 data_out("data_out"),
                 data_in("data_in")
                 {
                 SC_THREAD(fsm);
                 }

    void fsm(){

        std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();

        while(true){

            if(cnt < runs_simulated) { //Number of runs to simulate
                if (cnt_fill < ARRAY_SIZE) {
                    data_testbench[cnt_fill] = random() % 255;
                    cnt_fill++;
                } else {

                    /*for (cnt_fill = 0; cnt_fill < ARRAY_SIZE; cnt_fill++){
                        cout << data_testbench[cnt_fill] << " ";
                    }
                    cout << " " << endl;*/


                    data_out->write(data_testbench);

                    data_in->read(data_testbench);

                    for(cnt_fill = 0; cnt_fill < ARRAY_SIZE-1; cnt_fill++){
                        if(data_testbench[cnt_fill] > data_testbench[cnt_fill + 1]){
                            cout << "ERROR" << endl;
                            sc_stop();
                        }
                    }
                    cnt_fill = 0;

                    /*for (cnt_fill = 0; cnt_fill < ARRAY_SIZE; cnt_fill++){
                        cout << data_testbench[cnt_fill] << " ";
                    }
                    cout << " " << endl;

                    cnt_fill = 0;*/

                    cnt++;
                }
            }else {

                std::chrono::steady_clock::time_point end = std::chrono::steady_clock::now();


                cout << "SUCCESS!" << endl;
                cout << runs_simulated << " runs simulated" << endl;
                cout << "Wall-Clock time consumed: " << std::chrono::duration_cast<std::chrono::milliseconds>(end-begin).count() << " milliseconds" << endl;
                cout << "Simulation stopped" << endl;
                sc_stop();
            }

            wait(SC_ZERO_TIME);
            //cnt++;

        }

    }

};

//#endif //ESL_TESTBENCH_H
