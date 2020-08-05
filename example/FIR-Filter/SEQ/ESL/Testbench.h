//
// Created by Tobias Jauch on 15.07.2020
//
#include<iostream>
#include <chrono>

#include "../../../Interfaces/Interfaces.h"
#include "systemc.h"
#include "DataTypes.h"

#define N 3
#define ARRAY_SIZE 8

using namespace std;


//#ifndef ESL_TESTBENCH_H
//#define ESL_TESTBENCH_H

struct Testbench : public sc_module {

    //Variables
    int data_testbench[ARRAY_SIZE] = {1,4,-6,3,2,4,-10,3};

    //out-port
    blocking_out<int> data_out;
    blocking_in<int> data_in;


    int cnt = 0;
    int cnt_fill = 0;
    int i;

    int runs_simulated = 1; //1


    //Constructor
    SC_HAS_PROCESS(Testbench);

    Testbench(sc_module_name name) :
                        data_in("data_in"),
                        data_out("data_out") {
                 SC_THREAD(fsm);
                 }

    void fsm() {

        std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();

        while (true) {

            if (cnt < ARRAY_SIZE) {

                cout << "Data in: " << data_testbench[cnt] << endl;

                //cout << "data sent" << endl;


                data_out->write(data_testbench[cnt]);

                data_in->read(data_testbench[cnt]);


                cout << "Data out: " << data_testbench[cnt] << endl;

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
