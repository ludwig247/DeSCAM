//
// Created by Douae Nouichi 06/11/2020
//
#include "/home/douae/DeSCAM/example/Interfaces/Interfaces.h"


#include "systemc.h"
#include "DataTypes.h"

//Data Path Algorithm File
#include "SDRAM-Controller.h"

//Testbench
#include "Testbench.h"


using namespace std;

int sc_main(int argc, char* argv[]) {

    SDRAM_Controller SDRAM_Controller("SDRAM_Controller");
    Testbench testbench("Testbench");


    Blocking<request>data_in("data_in");
    testbench.data_out(data_in);
    SDRAM_Controller.data_in(data_in);


    MasterSlave<resp_activ>data_int("data_int");
    testbench.data_int(data_int);
    SDRAM_Controller.data_int(data_int);

    // single_read data from sdram
    MasterSlave<int>sdram_data_in("sdram_data_in");
    testbench.sdram_data_in(sdram_data_in);
    SDRAM_Controller.sdram_data_in(sdram_data_in);

    MasterSlave<resp>data_out_single_read("data_out_single_read");
    testbench.data_out_single_read(data_out_single_read);
    SDRAM_Controller.data_out_single_read(data_out_single_read);

    MasterSlave<request>data_in_end_read_op("data_in");
    testbench.data_in_end_read_op(data_in_end_read_op);
    SDRAM_Controller.data_in_end_read_op(data_in_end_read_op);



   //single_write data from the CPU
    MasterSlave<int>CPU_data_in("CPU_data_in");
    testbench.CPU_data_in(CPU_data_in);
    SDRAM_Controller.CPU_data_in(CPU_data_in);

    MasterSlave<resp>data_out_single_write("data_out_single_write");
    testbench.data_out_single_write(data_out_single_write);
    SDRAM_Controller.data_out_single_write(data_out_single_write);

    MasterSlave<request>data_in_end_write_op("data_in_end_write_op");
    testbench.data_in_end_write_op(data_in_end_write_op);
    SDRAM_Controller.data_in_end_write_op(data_in_end_write_op);


    MasterSlave<resp_idle>data_out_idle("data_out_idle");
    testbench.data_out_idle(data_out_idle);
    SDRAM_Controller.data_out_idle(data_out_idle);

    //PRECHARGE
    MasterSlave<request>precharge_read("precharge_read");
    testbench.precharge_read(precharge_read);
    SDRAM_Controller.precharge_read(precharge_read);

    //burst read
    MasterSlave<burst>sdram_data_in_burst("sdram_data_in_burst");
    testbench.sdram_data_in_burst(sdram_data_in_burst);
    SDRAM_Controller.sdram_data_in_burst(sdram_data_in_burst);

    MasterSlave<resp_burst>data_out_burst_read("data_out_burst_read");
    testbench.data_out_burst_read(data_out_burst_read);
    SDRAM_Controller.data_out_burst_read(data_out_burst_read);

    MasterSlave<request>data_in_end_burst_read_op("data_in_end_burst_read_op");
    testbench.data_in_end_burst_read_op(data_in_end_burst_read_op);
    SDRAM_Controller.data_in_end_burst_read_op(data_in_end_burst_read_op);

    //burst write
    MasterSlave<burst>CPU_data_in_burst("CPU_data_in_burst");
    testbench.CPU_data_in_burst(CPU_data_in_burst);
    SDRAM_Controller.CPU_data_in_burst(CPU_data_in_burst);

    MasterSlave<resp_burst>data_out_burst_write("data_out_burst_write");
    testbench.data_out_burst_write(data_out_burst_write);
    SDRAM_Controller.data_out_burst_write(data_out_burst_write);

    MasterSlave<request>data_in_end_burst_write_op("data_in_end_burst_write_op");
    testbench.data_in_end_burst_write_op(data_in_end_burst_write_op);
    SDRAM_Controller.data_in_end_burst_write_op(data_in_end_burst_write_op);

    //read write
    MasterSlave<int>CPU_data_read_write("CPU_data_read_write");
    testbench.CPU_data_read_write(CPU_data_read_write);
    SDRAM_Controller.CPU_data_read_write(CPU_data_read_write);


    sc_start();

    return 0;
}

