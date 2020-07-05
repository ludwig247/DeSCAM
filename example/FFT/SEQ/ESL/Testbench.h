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
    sc_fix data_testbench_real[ARRAY_SIZE] = {1,4,-6,3,2,4,-10,3};
    sc_fix data_testbench_img[ARRAY_SIZE] = {0,0,0,0,0,0,0,0};

    //out-port
    blocking_out<sc_fix[ARRAY_SIZE]> data_out_real;
    blocking_out<sc_fix[ARRAY_SIZE]> data_out_img;

    //in-port
    blocking_in<sc_fix[ARRAY_SIZE]> data_in_real;
    blocking_in<sc_fix[ARRAY_SIZE]> data_in_img;


    int cnt = 0;
    int cnt_fill = 0;
    int i;

    int runs_simulated = 1; //1


    //Constructor
    SC_HAS_PROCESS(Testbench);

    Testbench(sc_module_name name) :
                 data_out_real("data_out_real"),
                 data_out_img("data_out_img"),
                 data_in_real("data_in_real"),
                 data_in_img("data_in_img")
                 {
                 SC_THREAD(fsm);
                 }

    void fsm() {

        std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();

        while (true) {

            if (cnt < runs_simulated) {

                for (cnt_fill = 0; cnt_fill < ARRAY_SIZE; ++cnt_fill) {
                    //data_testbench_real[cnt_fill] = random() % 255;

                     cout << data_testbench_real[cnt_fill] << " ";

                     if(cnt_fill == ARRAY_SIZE-1){
                            cout << endl;
                     }
                }

                for (cnt_fill = 0; cnt_fill < ARRAY_SIZE; ++cnt_fill) {
                    //data_testbench_img[cnt_fill] = random() % 255;

                    cout << data_testbench_img[cnt_fill] << " ";

                    if(cnt_fill == ARRAY_SIZE-1){
                        cout << endl;
                    }
                }



                cout << "data sent" << endl;


                data_out_real->write(data_testbench_real);
                data_out_img->write(data_testbench_img);

                data_in_real->read(data_testbench_real);
                data_in_img->read(data_testbench_img);

            for (cnt_fill = 0; cnt_fill < ARRAY_SIZE; ++cnt_fill) {

                cout << data_testbench_real[cnt_fill] << " ";

                if(cnt_fill == ARRAY_SIZE-1){
                    cout << endl;
                }
            }

            for (cnt_fill = 0; cnt_fill < ARRAY_SIZE; ++cnt_fill) {

                cout << data_testbench_img[cnt_fill] << " ";

                if(cnt_fill == ARRAY_SIZE-1){
                    cout << endl;
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
