//
// Created by Tobias Jauch on 02.05.20.
//
#include<iostream>
#include <chrono>

#include "../../Interfaces/Interfaces.h"
#include "systemc.h"
#include "DataTypes.h"


#define ARRAY_SIZE 8

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

    int runs_simulated = 10000000; //10.000.000

   /* timespec t1, t2;

    double timespec_diff(timespec t2, timespec t1){
        double d1 = t1.tv_sec + t1.tv_nsec / 1000000000.0;
        double d2 = t2.tv_sec + t2.tv_nsec / 1000000000.0;

        return d2-d1;
    }*/


    //Constructor
    SC_HAS_PROCESS(Testbench);

    Testbench(sc_module_name name) :
                 data_out("data_out"),
                 data_in("data_in")
                 {
                 SC_THREAD(fsm);
                 }

    void fsm(){


        //  clock_gettime(CLOCK_REALTIME, &t1);

        //std::chrono::time_point<std::chrono::system_clock> start, end;

        //std::chrono::time_point<std::chrono::system_clock> start = std::chrono::system_clock::now()

        std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();

        while(true){

            if(cnt < runs_simulated) { //Number of runs to simulate
                if (cnt_fill < ARRAY_SIZE) {
                    data_testbench[cnt_fill] = random() % 255;
                    cnt_fill++;
                } else {

                   /* cout << "Run #" << cnt+1 << endl;

                    cout << "unsorted: " << data_testbench[0] << endl;
                    cout << "unsorted: " << data_testbench[1] << endl;
                    cout << "unsorted: " << data_testbench[2] << endl;
                    cout << "unsorted: " << data_testbench[3] << endl;
                    cout << "unsorted: " << data_testbench[4] << endl;
                    cout << "unsorted: " << data_testbench[5] << endl;
                    cout << "unsorted: " << data_testbench[6] << endl;
                    cout << "unsorted: " << data_testbench[7] << endl;
                    cout << "end of unsorted Array" << endl;

                    cout << "Testbench: data sent" << endl;*/
                    data_out->write(data_testbench);

                    cnt_fill = 0;
                    data_in->read(data_testbench);
                    //cout << "Testbench: data received" << endl;

                    for(cnt_fill = 0; cnt_fill < 7; cnt_fill++){
                        if(data_testbench[cnt_fill] > data_testbench[cnt_fill + 1]){
                            cout << "ERROR" << endl;
                            sc_stop();
                        }
                    }
                    cnt_fill = 0;

                   /* cout << "sorted: " << data_testbench[0] << endl;
                    cout << "sorted: " << data_testbench[1] << endl;
                    cout << "sorted: " << data_testbench[2] << endl;
                    cout << "sorted: " << data_testbench[3] << endl;
                    cout << "sorted: " << data_testbench[4] << endl;
                    cout << "sorted: " << data_testbench[5] << endl;
                    cout << "sorted: " << data_testbench[6] << endl;
                    cout << "sorted: " << data_testbench[7] << endl;
                    cout << "end of sorted Array" << endl;*/

                    cnt++;
                }
            }else {
                //clock_gettime(CLOCK_REALTIME, &t2);
                //double t = timespec_diff(t2,t1);
               // std::chrono::time_point<std::chrono::system_clock> end = std::chrono::system_clock::now();
                std::chrono::steady_clock::time_point end = std::chrono::steady_clock::now();

                //float elapsed_seconds = std::chrono::duration_cast<std::chrono::seconds> = (end-start).count();

                //std::time_t start_time = std::chrono::system_clock::to_time_t(begin);
                //std::time_t end_time = std::chrono::system_clock::to_time_t(end);

                cout << "SUCCESS!" << endl;
                cout << runs_simulated << " runs simulated" << endl;
                cout << "Wall-Clock time consumed: " << std::chrono::duration_cast<std::chrono::seconds>(end-begin).count() << " seconds" << endl;
                //cout << "started at time " << std::ctime(&start_time) << endl;
                //cout << "finished at time " << std::ctime(&end_time) << endl;
                cout << "Simulation stopped" << endl;
                sc_stop();
            }

            wait(SC_ZERO_TIME);
            //cnt++;

        }

    }

};

//#endif //ESL_TESTBENCH_H
