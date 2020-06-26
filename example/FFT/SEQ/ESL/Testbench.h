//
// Created by Tobias Jauch on 02.05.20.
//
#include<iostream>
#include <chrono>

#include "../../../Interfaces/Interfaces.h"
#include "systemc.h"
#include "DataTypes.h"

#define ARRAY_DIM 2
#define ARRAY_SIZE 8

using namespace std;


//#ifndef ESL_TESTBENCH_H
//#define ESL_TESTBENCH_H

struct Testbench : public sc_module {

    //Variables
    double data_testbench[ARRAY_DIM][ARRAY_SIZE] = {1,4,-6,3,2,4,-10,3,0,0,0,0,0,0,0,0};

    //out-port
   blocking_out<double[ARRAY_DIM][ARRAY_SIZE]> data_out;

    //in-port
   blocking_in<double[ARRAY_DIM][ARRAY_SIZE]> data_in;


    int cnt = 0;
    int cnt_fill = 0;
    int i;

    int runs_simulated = 1; //1


    //Constructor
    SC_HAS_PROCESS(Testbench);

    Testbench(sc_module_name name) :
                 data_out("data_out"),
                 data_in("data_in")
                 {
                 SC_THREAD(fsm);
                 }

    void fsm() {

        std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();

        while (true) {

            if (cnt < runs_simulated) {

                for (i = 0; i < ARRAY_DIM; ++i) {
                    for (cnt_fill = 0; cnt_fill < ARRAY_SIZE; ++cnt_fill) {
                        data_testbench[i][cnt_fill] = random() % 255;

                        cout << data_testbench[i][cnt_fill] << " ";

                        if(cnt_fill == ARRAY_SIZE-1){
                            cout << endl;
                        }

                    }
                }

                cout << "data sent" << endl;


                data_out->write(data_testbench);

                data_in->read(data_testbench);

                for (i = 0; i < ARRAY_DIM ; ++i) {
                    for (cnt_fill = 0; cnt_fill < ARRAY_SIZE; ++cnt_fill) {

                        cout << data_testbench[i][cnt_fill] << " ";

                        if(cnt_fill == ARRAY_SIZE-1){
                            cout << endl;
                        }

                    }
                }



                cnt++;

            }else {

                std::chrono::steady_clock::time_point end = std::chrono::steady_clock::now();


                std::cout << "SUCCESS!" << endl;
                std::cout << runs_simulated << " runs simulated" << endl;
                std::cout << "Wall-Clock time consumed: "
                    << std::chrono::duration_cast<std::chrono::milliseconds>(end - begin).count() << " milliseconds"
                    << endl;
                std::cout << "Simulation stopped" << endl;
                sc_stop();
            }

        wait(SC_ZERO_TIME);

        }

    }

};

//#endif //ESL_TESTBENCH_H
