//
// Created by Douae Nouichi on 06/11/2020
//
#include<iostream>
#include <chrono>

#include "/home/douae/DeSCAM/example/Interfaces/Interfaces.h"
#include "/home/douae/DeSCAM/example/Interfaces/MasterSlave.h"

#include "systemc.h"
#include "DataTypes.h"


using namespace std;


//#ifndef ESL_TESTBENCH_H
//#define ESL_TESTBENCH_H

struct Testbench : public sc_module {

    //Variables
    request data_testbench = {1,0, 0, 278211943};
    request data_testbench_2 = {1,0, 0, 278991943};// used in address of FF005567 only 24 bits are considered
    int response_data = 44;
    int CPU_input_data = 55;
    resp_activ response_activ;
    resp response_single_read;
    resp_idle address_last_row;
    burst read_data = {40, 50,20, 15 }; // DATA READ FROM SDRAM BY THE CPU
    burst written_data = {40, 50,20, 15 }; // DATA WRITTEN BY THE CPU TO THE SDRAM

    resp_burst response_burst_read;
    resp_burst response_burst_write;


    //PORTS

    blocking_out<request> data_out;
    slave_in<resp_activ> data_int ;
    slave_in<resp_idle> data_out_idle;
    //single_read
    slave_out<int> sdram_data_in;
    slave_in<resp> data_out_single_read;
    slave_out<request> data_in_end_read_op;
    //single_write
    slave_out<int> CPU_data_in;
    slave_in<resp> data_out_single_write;
    slave_out<request> data_in_end_write_op;
    //burst read
    slave_out<burst>sdram_data_in_burst;
    slave_in<resp_burst>data_out_burst_read;
    slave_out<request>data_in_end_burst_read_op;
    //burst write
    slave_out<burst>CPU_data_in_burst;
    slave_in<resp_burst>data_out_burst_write;
    slave_out<request>data_in_end_burst_write_op;
    //precharge
    slave_out<request>precharge_read;
    //read write
    slave_out<int>CPU_data_read_write;


    int i;
    int address = 0;

    int runs_simulated = 1;



    //Constructor
    SC_HAS_PROCESS(Testbench);

    Testbench(sc_module_name name) :
            data_out("data_out"),
            data_int("data_int"),
            data_out_idle("data_out_idle"),
            sdram_data_in("sdram_data_in"),
            data_out_single_read("data_out_single_read"),
            data_in_end_read_op ("data_in_end_read_op"),
            CPU_data_in("CPU_data_in"),
            data_out_single_write("data_out_single_write"),
            data_in_end_write_op("data_in_end_write_op"),
            sdram_data_in_burst("sdram_data_in_burst"),
            data_out_burst_read("data_out_burst_read"),
            data_in_end_burst_read_op("data_in_end_burst_read_op"),
            CPU_data_in_burst("CPU_data_in_burst"),
            data_out_burst_write("data_out_burst_write"),
            data_in_end_burst_write_op("data_in_end_burst_write_op"),
            precharge_read("precharge_read"),
            CPU_data_read_write("CPU_data_read_write")


    {
        SC_THREAD(fsm);
    }

    void fsm() {

        std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();

        while (true) {



            cout << "Data in: " << "read_request " << data_testbench.read_req << " ,write_req "
                 << data_testbench.write_req << " ,burst req " << data_testbench.burst_single
                 << " ,address read " << data_testbench.address_in << endl;


            data_out->write(data_testbench); // input to dut
            data_out_idle->slave_read(address_last_row);
            data_int->slave_read(response_activ); // output of dut in activate state
            cout<< "address at idle state "<<address_last_row.address<<" ,last row at idle state: "<< address_last_row.last_row<<endl;
            cout << "Data out activation: " << response_activ.ready << " " << response_activ.sdram_status << " "
                 << response_activ.address << " "
                 << endl; //response address is the upper 12 bits of the address


            cout << "Data read from the sdram " << response_data << endl;
            sdram_data_in->slave_write(response_data); // input to dut
            data_out_single_read->slave_read(response_single_read); // output of dut in single_read state
            cout << "Data out single_read: " << response_single_read.ready << " "
                 << response_single_read.sdram_status << " "
                 << response_single_read.address << " " << response_single_read.data_out
                 << endl;
            data_in_end_read_op -> slave_write(data_testbench_2);

            // single write operation
            CPU_data_in -> slave_write(CPU_input_data); // input to dut
            data_out_single_write -> slave_read(response_single_read);
            data_in_end_write_op -> slave_write(data_testbench_2);

            //burst read operation
            sdram_data_in_burst-> slave_write(read_data);
            data_out_burst_read-> slave_read(response_burst_read);
            data_in_end_burst_read_op -> slave_write(data_testbench_2);

            //burst write operation
            CPU_data_in_burst-> slave_write(written_data);
            data_out_burst_write-> slave_read(response_burst_write);
            data_in_end_burst_write_op -> slave_write(data_testbench_2);


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



};

//#endif //ESL_TESTBENCH_H