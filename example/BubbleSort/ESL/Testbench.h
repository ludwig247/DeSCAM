//
// Created by Tobias Jauch on 02.05.20.
//

#include "../../Interfaces/Interfaces.h"
#include "systemc.h"
#include "DataTypes.h"

#include <time.h>

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


    //Constructor
    SC_HAS_PROCESS(Testbench);

    Testbench(sc_module_name name) :
                 data_out("data_out"),
                 data_in("data_in")
                 {
                 SC_THREAD(fsm);
                 }

    void fsm(){

        while(true){

            double time = 0.0, tstart, tend;
            tstart = clock();

            if(cnt < 100000) { //Number of runs to simulate
                if (cnt_fill < ARRAY_SIZE) {
                    data_testbench[cnt_fill] = random() % 255;
                    cnt_fill++;
                } else {

                    /*cout << "Run #" << cnt+1 << endl;

                    cout << "unsorted: " << data_testbench.array[0] << endl;
                    cout << "unsorted: " << data_testbench.array[1] << endl;
                    cout << "unsorted: " << data_testbench.array[2] << endl;
                    cout << "unsorted: " << data_testbench.array[3] << endl;
                    cout << "unsorted: " << data_testbench.array[4] << endl;
                    cout << "unsorted: " << data_testbench.array[5] << endl;
                    cout << "unsorted: " << data_testbench.array[6] << endl;
                    cout << "unsorted: " << data_testbench.array[7] << endl;
                    cout << "end of unsorted Array" << endl;

                    cout << "Testbench: data sent" << endl;*/
                    data_out->write(data_testbench);

                    cnt_fill = 0;
                    data_in->read(data_testbench);
                   /* cout << "Testbench: data received" << endl;

                    cout << "sorted: " << data_testbench.array[0] << endl;
                    cout << "sorted: " << data_testbench.array[1] << endl;
                    cout << "sorted: " << data_testbench.array[2] << endl;
                    cout << "sorted: " << data_testbench.array[3] << endl;
                    cout << "sorted: " << data_testbench.array[4] << endl;
                    cout << "sorted: " << data_testbench.array[5] << endl;
                    cout << "sorted: " << data_testbench.array[6] << endl;
                    cout << "sorted: " << data_testbench.array[7] << endl;
                    cout << "end of sorted Array" << endl;*/
                    cnt++;
                }
            }else {
                cout << "100.000 runs simulated" << endl;
                cout << "Simulation stopped" << endl;
                tend = clock();
                cout << tstart << endl;
                cout << tend << endl;
                time = tend - tstart;
                cout << time << endl;
                cout << "Time: " << time/CLOCKS_PER_SEC << " seconds";
                sc_stop();
            }

            wait(SC_ZERO_TIME);
            //cnt++;

        }

    }

};

//#endif //ESL_TESTBENCH_H
